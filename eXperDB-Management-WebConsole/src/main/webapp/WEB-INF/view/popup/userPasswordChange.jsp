<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : userManagerRegReForm.jsp
	* @Description : userManagerRegReForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>
<script type="text/javascript">
	$(window.document).ready(function() {

		$(".mod_pwd_chk").keyup(function(){
			var mod_pwd_val = $("#mod_pwd", "#modUserForm").val(); 
			var mod_pwdCheck_val = $("#mod_pwdCheck", "#modUserForm").val(); 

			if(mod_pwd_val == "" && mod_pwdCheck_val == ""){
				$("#mod_pwdCheck_alert-danger", "#modUserForm").hide();
				$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
				$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

				$("#mod_passCheck_hid", "#modUserForm").val("1");

				$("#mod_pwd_chk_msg_div", "#modUserForm").show();
				$("#mod_pwd_chk_div", "#modUserForm").hide();
			}else if(mod_pwd_val != "" && mod_pwdCheck_val != ""){
				if(mod_pwd_val == mod_pwdCheck_val){
					$("#mod_pwdCheck_alert-danger", "#modUserForm").hide();
 					$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
					$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

					$("#mod_passCheck_hid", "#modUserForm").val("1");
					
					$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
					$("#mod_pwd_chk_div", "#modUserForm").show();
				}else{ 
					$("#mod_pwdCheck_alert-danger", "#modUserForm").show(); 
					$("#mod_save_submit", "#modUserForm").attr("disabled", "disabled"); 
					$("#mod_save_submit", "#modUserForm").attr("readonly", "readonly"); 

					$("#mod_passCheck_hid", "#modUserForm").val("0");
					
					$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
					$("#mod_pwd_chk_div", "#modUserForm").show();
				}
			} else {
				$("#mod_pwdCheck_alert-danger", "#modUserForm").hide();
				$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
				$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

				$("#mod_passCheck_hid", "#modUserForm").val("0");

				$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
				$("#mod_pwd_chk_div", "#modUserForm").show();
			}
		});

		$("#mod_pwd", "#modUserForm").blur(function(){
			var mod_pwd_val = $("#mod_pwd", "#modUserForm").val(); 
			var mod_pwdCheck_val = $("#mod_pwdCheck", "#modUserForm").val(); 
			var mod_passCheck_cho_val = $("#mod_passCheck_cho", "#modUserForm").val(); 
			
			if (mod_pwd_val =="" && mod_pwdCheck_val == "") {
 				$("#mod_pwd_alert-danger", "#modUserForm").html("");
				$("#mod_pwd_alert-danger", "#modUserForm").hide();
				$("#mod_pwd_alert-light", "#modUserForm").html("");
				$("#mod_pwd_alert-light", "#modUserForm").hide();
				$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
				$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

				$("#mod_passCheck_hid", "#modUserForm").val("1");

				$("#mod_pwd_chk_msg_div", "#modUserForm").show();
				$("#mod_pwd_chk_div", "#modUserForm").hide();
				return;
			}

			if (mod_pwd_val != "") {
				var passed = pwdValidate(mod_pwd_val);
		
				if ((mod_passCheck_cho_val != mod_pwd_val)&& passed != "") {
	 				$("#mod_pwd_alert-danger", "#modUserForm").html(passed);
					$("#mod_pwd_alert-danger", "#modUserForm").show();
					
					$("#mod_pwd_alert-light", "#modUserForm").html("");
					$("#mod_pwd_alert-light", "#modUserForm").hide();

					$("#mod_save_submit", "#modUserForm").attr("disabled", "disabled"); 
					$("#mod_save_submit", "#modUserForm").attr("readonly", "readonly"); 

					$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
					$("#mod_pwd_chk_div", "#modUserForm").show();
				} else {
	 				$("#mod_pwd_alert-danger", "#modUserForm").html("");
					$("#mod_pwd_alert-danger", "#modUserForm").hide();
					$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
					$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#mod_pwd", "#modUserForm").val());
					
					if (newpwdVal != "") {
		 				$("#mod_pwd_alert-light", "#modUserForm").html(newpwdVal);
						$("#mod_pwd_alert-light", "#modUserForm").show();
					} else {
						$("#mod_pwd_alert-light", "#modUserForm").html("");
						$("#mod_pwd_alert-light", "#modUserForm").hide();
					}

					$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
					$("#mod_pwd_chk_div", "#modUserForm").show();
				}
			} else {
 				$("#mod_pwd_alert-danger", "#modUserForm").html("");
				$("#mod_pwd_alert-danger", "#modUserForm").hide();
				$("#mod_pwd_alert-light", "#modUserForm").html("");
				$("#mod_pwd_alert-light", "#modUserForm").hide();
				$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
				$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

				$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
				$("#mod_pwd_chk_div", "#modUserForm").show();
			}
		});

		$("#modUserForm").validate({
			rules: {
					mod_usr_id: {
						required: true
					},
					mod_pwd: {
						required: true
					},
					mod_pwdCheck: {
						required: true
					}
			},
			messages: {
					mod_usr_id: {
						required: "<spring:message code='message.msg121' />"
					},
					mod_pwd: {
						required: "<spring:message code='message.msg140' />"
					},
					mod_pwdCheck: {
						required: "<spring:message code='message.msg141' />"
					}
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

	
	/* ********************************************************
	 * 등록 validate
	 ******************************************************** */
	function fn_mod_Validation() {
		var session_usr_id = "${sessionScope.session.usr_id}";
		var mod_usr_id = $("#mod_usr_id", "#modUserForm").val();

		if(mod_usr_id == 'admin'){
			if(session_usr_id != mod_usr_id){
				showSwalIcon('<spring:message code="message.msg120" />', '<spring:message code="common.close" />', '', 'warning');
				return false;
			}
		}

		var mod_pwd_val = $("#mod_pwd", "#modUserForm").val(); 
		var mod_pwdCheck_val = $("#mod_pwdCheck", "#modUserForm").val(); 
		var mod_passCheck_cho_val = $("#mod_passCheck_cho", "#modUserForm").val(); 
		

		if (mod_pwd_val != "" && mod_pwdCheck_val != "") {
			//패스워드 검증
			if(mod_pwd_val != mod_pwdCheck_val){
				$("#mod_pwdCheck_alert-danger", "#modUserForm").show(); 
				$("#mod_save_submit", "#modUserForm").attr("disabled", "disabled"); 
				$("#mod_save_submit", "#modUserForm").attr("readonly", "readonly"); 

				$("#mod_passCheck_hid", "#modUserForm").val("0");

				$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
				$("#mod_pwd_chk_div", "#modUserForm").show();
				return false;
			}

			var passed = "";
			
			if (mod_passCheck_cho_val != mod_pwd_val) {
				passed = pwdValidate(mod_pwd_val);
				if ( passed != "") {
		 			$("#mod_pwd_alert-danger", "#modUserForm").html(passed);
					$("#mod_pwd_alert-danger", "#modUserForm").show();
						
					$("#mod_pwd_alert-light", "#modUserForm").html("");
					$("#mod_pwd_alert-light", "#modUserForm").hide();

					$("#mod_save_submit", "#modUserForm").attr("disabled", "disabled"); 
					$("#mod_save_submit", "#modUserForm").attr("readonly", "readonly"); 

					$("#mod_pwd_chk_msg_div", "#modUserForm").hide();
					$("#mod_pwd_chk_div", "#modUserForm").show();
					return false;
				}
			}

			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");
			$("#mod_passCheck_hid", "#modUserForm").val("1");

			$("#mod_pwd_chk_msg_div", "#modUserForm").show();
			$("#mod_pwd_chk_div", "#modUserForm").hide();
		} else {
			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

			$("#mod_passCheck_hid", "#modUserForm").val("1");
			$("#mod_pwd_chk_msg_div", "#modUserForm").show();
			$("#mod_pwd_chk_div", "#modUserForm").hide();
		}

		return true;
	}


	

	
	/* ********************************************************
	 * 수정 실행
	 ******************************************************** */
	function fn_pwChange() {
		 if (!fn_mod_Validation())return false;
		 
		$.ajax({
			url : '/initPasswordUpdate.do',
			data : {
				usr_id : nvlPrmSet($("#mod_usr_id", "#modUserForm").val(), ''),
				pwd : nvlPrmSet($("#mod_pwd", "#modUserForm").val(), '')
			},
			type : "post",
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
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIcon('패스워드가 설정되었습니다.', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_user_pw_mod').modal('hide');
				} else if(data.resultCode == "8000000002") { //암호화 저장 실패
					showSwalIcon('<spring:message code="message.msg05"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_pw_mod').modal('show');
					return;
				} else if(data.resultCode == "8000000003") {
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'warning');
					$('#pop_layer_user_pw_mod').modal('hide');
				} else {
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_pw_mod').modal('show');
					return;
				}
			}
		});
	}
	 
	 
</script>
<div class="modal fade" id="pop_layer_user_pw_mod" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 300px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					초기패스워드 설정
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="modUserForm">
						<input type="hidden" name="mod_use_yn" id="mod_use_yn" />
						<input type="hidden" name="mod_encp_use_yn" id="mod_encp_use_yn" />
						<input type="hidden" name="mod_passCheck_hid" id="mod_passCheck_hid" value="0" />
						<input type="hidden" name="mod_passCheck_cho" id="mod_passCheck_cho" value="" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="mod_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.id" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" autocomplete="off" id="mod_usr_id" name="mod_usr_id" value="" readonly />
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="mod_pwd" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input type="password" style="display:none" aria-hidden="true">
										<input type="password" class="form-control mod_pwd_chk" autocomplete="new-password" maxlength="100" id="mod_pwd" name="mod_pwd" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="<spring:message code='message.msg109'/>" tabindex=2 />
									</div>

									<label for="mod_pwdCheck" class="col-sm-2_3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.confirm_password" />(*)
									</label>
									<div class="col-sm-3_0">
										<input type="password" class="form-control mod_pwd_chk" maxlength="100" id="mod_pwdCheck" name="mod_pwdCheck" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="<spring:message code='message.msg109'/>" tabindex=3 />
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;display:none;" id="mod_pwd_chk_div">
									<div class="col-sm-6">
										<div class="alert alert-light" style="margin-top:5px;display:none;" id="mod_pwd_alert-light"></div>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_pwd_alert-danger"></div>
									</div>
									<div class="col-sm-6">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_pwdCheck_alert-danger"><spring:message code="etc.etc14" /></div>
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:-10px;" id="mod_pwd_chk_msg_div">
									<div class="col-sm-12">
										<div class="alert alert-info" style="margin-top:5px;"><spring:message code="user_management.msg16" /></div>
									</div>
								</div>
							</div>

							<br/>			
							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<%-- <input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="mod_save_submit" value='<spring:message code="common.save" />' /> --%>
								 <input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" id="mod_save_submit" value='<spring:message code="common.save"/>' onClick="fn_pwChange();"  />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>