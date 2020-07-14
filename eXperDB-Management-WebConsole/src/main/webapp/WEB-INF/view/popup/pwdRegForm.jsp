<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : pwdRegForm.jsp
	* @Description : pwdRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.20
	*
	*/
%>

<script type="text/javascript">
	$(window.document).ready(function() {
		$("#pw_alert-danger", "#pwdChgForm").hide();

		$(".pwd_chk").keyup(function(){
			var pwd1 = $("#newpwd", "#pwdChgForm").val(); 
			var pwd2 = $("#pwd", "#pwdChgForm").val(); 

			if(pwd1 != "" && pwd2 != ""){
				if(pwd1 == pwd2){
					$("#pw_alert-danger", "#pwdChgForm").hide();
					$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
					$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");
				}else{ 
					$("#pw_alert-danger", "#pwdChgForm").show(); 
					$("#pwd_submit", "#pwdChgForm").attr("disabled", "disabled"); 
					$("#pwd_submit", "#pwdChgForm").attr("readonly", "readonly"); 
				}
			} else {
				$("#pw_alert-danger", "#pwdChgForm").hide();
				$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
				$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");
			}
		});

		$("#nowpwd", "#pwdChgForm").keyup(function(){
			var nowpwd_val = $("#nowpwd", "#pwdChgForm").val(); 
			if (nowpwd_val != "") {
				$("#nowpwd_alert-danger", "#pwdChgForm").hide();
			}
		});

		$("#newpwd", "#pwdChgForm").blur(function(){
			var pwd1=$("#newpwd", "#pwdChgForm").val(); 
			
			if (pwd1 != "") {
				var passed = pwdValidate(pwd1);

				if (passed != "") {
	 				$("#newpw_alert-danger", "#pwdChgForm").html(passed);
					$("#newpw_alert-danger", "#pwdChgForm").show();
					
					$("#newpw_alert-light", "#pwdChgForm").html("");
					$("#newpw_alert-light", "#pwdChgForm").hide();

					$("#pwd_submit", "#pwdChgForm").attr("disabled", "disabled"); 
					$("#pwd_submit", "#pwdChgForm").attr("readonly", "readonly"); 
				} else {
	 				$("#newpw_alert-danger", "#pwdChgForm").html("");
					$("#newpw_alert-danger", "#pwdChgForm").hide();
					$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
					$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#newpwd", "#pwdChgForm").val());
					
					if (newpwdVal != "") {
		 				$("#newpw_alert-light", "#pwdChgForm").html(newpwdVal);
						$("#newpw_alert-light", "#pwdChgForm").show();
					} else {
						$("#newpw_alert-light", "#pwdChgForm").html("");
						$("#newpw_alert-light", "#pwdChgForm").hide();
					}
				}
			} else {
 				$("#newpw_alert-danger", "#pwdChgForm").html("");
				$("#newpw_alert-danger", "#pwdChgForm").hide();
				$("#newpw_alert-light", "#pwdChgForm").html("");
				$("#newpw_alert-light", "#pwdChgForm").hide();
				$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
				$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");
			}
		}); 
		
		//저장 버튼 클릭
		$("#pwd_submit", "#pwdChgForm").click(function(){
			var nowpwd_val = $("#nowpwd", "#pwdChgForm").val();

			if (nowpwd_val == "") {
 				$("#nowpwd_alert-danger", "#pwdChgForm").html('<spring:message code="message.msg110" />');
				$("#nowpwd_alert-danger", "#pwdChgForm").show();

				return;
			}

			$.ajax({
				url : '/checkPwd.do',
				type : 'post',
				data : {
					nowpwd : nowpwd_val
				},
				success : function(result) {
					if (result) {
						$("#newpw_alert-light", "#pwdChgForm").html("");
						$("#newpw_alert-light", "#pwdChgForm").hide();
						$("#newpw_alert-light", "#pwdChgForm").html("");
						$("#newpw_alert-light", "#pwdChgForm").hide();
						$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
						$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");
						
						$("#pwdChgForm").submit();
					} else {
		 				$("#nowpwd_alert-danger", "#pwdChgForm").html('<spring:message code="message.msg114" />');
						$("#nowpwd_alert-danger", "#pwdChgForm").show();
					}

				},
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", true);
				},
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				}
			});
		});
	
 		$("#pwdChgForm").validate({
			rules: {
				newpwd: {
					required: true
				},
				pwd: {
					required: true
				}
			},
			messages: {
				newpwd: {
					required: '<spring:message code="message.msg111" />'
				},
				pwd: {
					required: '<spring:message code="message.msg153" />',
					pwdEqualsChk: '<spring:message code="message.msg154" />'
				}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_pwdUpdate();
			},
			errorPlacement: function(label, element) {
				label.addClass('mt-2 text-danger');
				label.insertAfter(element);
		    },
		    highlight: function(element, errorClass) {
		        $(element).parent().addClass('has-danger')
		        $(element).addClass('form-control-danger')
		    }
		});

/*  		$.validator.addMethod("pwdEqualsChk", function(value, element){
 			var nowpwd_chk = $("#nowpwd", "#pwdChgForm").val(); 
 			var pwd_chk = value;

 			if (nowpwd_chk == pwd_chk) {
 				return true;
 			}

 			return this.optional(element)|| false;

 		}); */
	});

	/*확인버튼 클릭시*/
	function fn_pwdUpdate() {
		var nowpwd_chk = $("#nowpwd", "#pwdChgForm").val(); 
 		var pwd_chk = $("#pwd", "#pwdChgForm").val(); 
		
		if(nowpwd_chk == pwd_chk){
			showSwalIcon('<spring:message code="message.msg154" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		$.ajax({
			url : '/updatePwd.do',
			type : 'post',
			data : {
				pwd : $("#pwd", "#pwdChgForm").val()
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIcon('<spring:message code="message.msg57" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_pwd_chg').modal('hide');
				}else if(data.resultCode == "8000000002"){
					showSwalIcon('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_pwd_chg').modal('show');
				}else if(data.resultCode == "8000000003"){
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_pwd_chg').modal('show');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_pwd_chg').modal('show');
				}
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	/* ********************************************************
	 * 비밀번호 체크
	 ******************************************************** */
	function pwdValidate(pw) {
		if (pw == "") {
			return;
		}
		
		var reg_pwd = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,20}/;

		//비밀번호 체크
		if (!reg_pwd.test(pw)) { 
			return "<spring:message code='message.msg109' />";
		}
		
		return "";
	}

	/* ********************************************************
	 * 비밀번호 안정성 확인
	 ******************************************************** */
	function pwdSafety(pw) {
		if (pw == "") {
			return;
		}
		
		var o = { 
				length: [6, 20],
				lower: 1,
				upper: 1,
				alpha: 1, /* lower + upper */
				numeric: 1,
				special: 1, 
				custom: [ /* regexes and/or functions */ ], 
				badWords: [], 
				badSequenceLength: 5, 
				noQwertySequences: true, 
				spaceChk: true, 
				noSequential: false 
		};

		// bad sequence check 
		if (o.badSequenceLength && pw.length >= o.length[0]) {
			var lower = "abcdefghijklmnopqrstuvwxyz", 
				upper = lower.toUpperCase(), 
				numbers = "0123456789", 
				qwerty = "qwertyuiopasdfghjklzxcvbnm", 
				start = o.badSequenceLength - 1, 
				seq = "_" + pw.slice(0, start);
			
			for (i = start; i < pw.length; i++) {
				seq = seq.slice(1) + pw.charAt(i);
				
				if ( lower.indexOf(seq) > -1 || upper.indexOf(seq) > -1 || numbers.indexOf(seq) > -1 || (o.noQwertySequences && qwerty.indexOf(seq) > -1) ) {
					return "<p style='line-height:200%;'>비밀번호 안전도 <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'>낮음</span> " + "<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + "<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + "<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + "<br/>" + "<span style='color:#999; font-weight:bold;'>안전도가 높은 비밀번호를 권장합니다.</span></p>";
				}
			}
		}
		
		//password 정규식 체크 
		var re = {
				lower: /[a-z]/g, 
				upper: /[A-Z]/g, 
				alpha: /[A-Z]/gi, 
				numeric: /[0-9]/g, 
				special: /[\W_]/g 
		},rule, i;

		var lower = (pw.match(re['lower']) || []).length > 0 ? 1 : 0; 
		var upper = (pw.match(re['upper']) || []).length > 0 ? 1 : 0; 
		var numeric = (pw.match(re['numeric']) || []).length > 0 ? 1 : 0; 
		var special = (pw.match(re['special']) || []).length > 0 ? 1 : 0;

		//숫자, 알파벳(대문자, 소문자), 특수문자 2가지 조합
		if(lower + upper + numeric + special <= 2) {
			return "<p style='line-height:200%;'><spring:message code='user_management.msg5' /> <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'><spring:message code='user_management.msg6' /></span> " + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
					"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<br/>" + 
					"<span style='color:#999; font-weight:bold;'><spring:message code='user_management.msg7' /></span></p>"; 
		}
		//숫자, 알파벳(대문자, 소문자), 특수문자 4가지 조합
		else if(lower + upper + numeric + special <= 3) { 
			return "<p style='line-height:200%;'><spring:message code='user_management.msg5' /> <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'><spring:message code='user_management.msg8' /></span> " + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<br/>" + 
					"<span style='color:#999; font-weight:bold;'><spring:message code='user_management.msg9' /></span></p>"; 
		}
		//숫자, 알파벳(대문자, 소문자), 특수문자 4가지 조합
		else { 
			return "<p style='line-height:200%;'><spring:message code='user_management.msg5' /> <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'><spring:message code='user_management.msg10' /></span> " + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
					"<br/>" + "<span style='color:#999; font-weight:bold;'><spring:message code='user_management.msg11' /></span></p>";
		}

		return "";
	}
	
</script>


<div class="modal fade" id="pop_layer_pwd_chg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="user_management.edit_password"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="pwdChgForm">
							<fieldset>
								<div class="form-group row border-bottom">
									<label for="com_db_svr_nm" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.nowPw"/>
									</label>
									<div class="col-sm-9">
										<input type="password" class="form-control" maxlength="20" id="nowpwd" name="nowpwd" onKeyPress="fn_checkWord(this,20);" placeholder='<spring:message code="message.msg109" />'>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="nowpwd_alert-danger"></div>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.newPw"/>
									</label>
									<div class="col-sm-9">
										<input type="password" class="form-control pwd_chk" maxlength="20" id="newpwd" name="newpwd" onKeyPress="fn_checkWord(this,20);" placeholder='<spring:message code="message.msg109" />'>
										<div class="alert alert-light" style="margin-top:5px;display:none;" id="newpw_alert-light"></div>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="newpw_alert-danger"></div>
									</div>
								</div>
							
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.newPwConfirm"/>
									</label>
									<div class="col-sm-9">
										<input type="password" class="form-control pwd_chk js-mytooltip-pw" maxlength="20" id="pwd" name="pwd" onKeyPress="fn_checkWord(this,20);" placeholder='<spring:message code="message.msg109" />'>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="pw_alert-danger"><spring:message code="message.msg112" /></div>
									
									</div>
								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" id="pwd_submit" value='<spring:message code="common.save" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>