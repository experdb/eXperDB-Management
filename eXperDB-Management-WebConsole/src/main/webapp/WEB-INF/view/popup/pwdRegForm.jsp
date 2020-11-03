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
									<label for="com_db_svr_nm" class="col-sm-3_0 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.nowPw"/>
									</label>
									<div class="col-sm-8">
										<input type="password" class="form-control" maxlength="20" id="nowpwd" name="nowpwd" onKeyPress="fn_checkWord(this,20);" placeholder='<spring:message code="message.msg109" />'>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="nowpwd_alert-danger"></div>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3_0 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.newPw"/>
									</label>
									<div class="col-sm-8">
										<input type="password" class="form-control pwd_chk" maxlength="20" id="newpwd" name="newpwd" onKeyPress="fn_checkWord(this,20);" placeholder='<spring:message code="message.msg109" />'>
										<div class="alert alert-light" style="margin-top:5px;display:none;" id="newpw_alert-light"></div>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="newpw_alert-danger"></div>
									</div>
								</div>
							
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-3_0 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.newPwConfirm"/>
									</label>
									<div class="col-sm-8">
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