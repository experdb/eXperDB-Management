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
		$("#mod_cpn", "#modUserForm").mask("999-9999-9999");

		//캘린더 셋팅
		fn_modDateCalenderSetting();

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
					mod_usr_nm: {
						required: true
					},
					mod_pwd: {
						required: true
					},
					mod_pwdCheck: {
						required: true
					}
/* 					mod_pwd: {
		        		required: function(){
		        			if (nvlPrmSet($("#mod_pwdCheck", "#modUserForm").val(),"") != "" ) {
		        				if(nvlPrmSet($("#mod_pwd", "#modUserForm").val(),"") == "") {
		        					 return true;
		        				}
		        			}
		        			return false;
		        		}
					},
					mod_pwdCheck: {
		        		required: function(){
		        			if (nvlPrmSet($("#mod_pwd", "#modUserForm").val(),"") != "" ) {
		        				if(nvlPrmSet($("#mod_pwdCheck", "#modUserForm").val(),"") == "") {
		        					 return true;
		        				}
		        			}
		        			return false;
		        		}
					} */
			},
			messages: {
					mod_usr_id: {
						required: "<spring:message code='message.msg121' />"
					},
					mod_usr_nm: {
						required: "<spring:message code='message.msg58' />"
					},
					mod_pwd: {
						required: "<spring:message code='message.msg140' />"
					},
					mod_pwdCheck: {
						required: "<spring:message code='message.msg141' />"
					}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_modPop_update_confirm();
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
	 * 수정 confirm
	 ******************************************************** */
	function fn_modPop_update_confirm() {
		if (!fn_mod_Validation())return false;

		fn_multiConfirmModal("mod");
	}

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
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function fn_modDateCalenderSetting() {
		var today = new Date();
		var startDay = fn_dateParse("20180101");
		var endDay = fn_dateParse("20991231");
		
		var day_today = today.toJSON().slice(0,10);
		var day_start = startDay.toJSON().slice(0,10);
		var day_end = endDay.toJSON().slice(0,10);

		if ($("#mod_usr_expr_dt_div", "#modUserForm").length) {
			$("#mod_usr_expr_dt_div", "#modUserForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#mod_usr_expr_dt", "#modUserForm").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#mod_usr_expr_dt_div", "#modUserForm").datepicker('updateDates');
	}
	
	/* ********************************************************
	 * 작업기간 설정
	 ******************************************************** */
	function fn_modDateUpdateSetting(usr_expr_dt) {	
		if ($("#mod_usr_expr_dt_div", "#modUserForm").length) {
			$("#mod_usr_expr_dt_div", "#modUserForm").datepicker({
			}).datepicker('setDate', usr_expr_dt)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#mod_usr_expr_dt", "#modUserForm").datepicker('setDate', usr_expr_dt);
		$("#mod_usr_expr_dt_div", "#modUserForm").datepicker('updateDates');
	}
	
	/* ********************************************************
	 * 수정 실행
	 ******************************************************** */
	function fn_modPop_update() {

		if($("#mod_use_yn_chk", "#modUserForm").is(":checked") == true){
			$("#mod_use_yn", "#modUserForm").val("Y");
		} else {
			$("#mod_use_yn", "#modUserForm").val("N");
		}

		if($("#mod_encp_use_yn_chk", "#modUserForm").is(":checked") == true){
			$("#mod_encp_use_yn", "#modUserForm").val("Y");
		} else {
			$("#mod_encp_use_yn", "#modUserForm").val("N");
		}

		$.ajax({
			url : '/updateUserManager.do',
			data : {
				usr_id : nvlPrmSet($("#mod_usr_id", "#modUserForm").val(), ''),
				usr_nm : nvlPrmSet($("#mod_usr_nm", "#modUserForm").val(), ''),
				pwd : nvlPrmSet($("#mod_pwd", "#modUserForm").val(), ''),
				bln_nm : nvlPrmSet($("#mod_bln_nm", "#modUserForm").val(), ''),
				dept_nm : nvlPrmSet($("#mod_dept_nm", "#modUserForm").val(), ''),
				pst_nm : nvlPrmSet($("#mod_pst_nm", "#modUserForm").val(), ''),
				rsp_bsn_nm : nvlPrmSet($("#mod_rsp_bsn_nm", "#modUserForm").val(), ''),
				cpn : nvlPrmSet($("#mod_cpn", "#modUserForm").val(), ''),
				usr_expr_dt : nvlPrmSet($("#mod_usr_expr_dt", "#modUserForm").val(), ''),
				use_yn : nvlPrmSet($("#mod_use_yn", "#modUserForm").val(), ''),
				encp_use_yn : nvlPrmSet($("#mod_encp_use_yn", "#modUserForm").val(), '')
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
					showSwalIcon('<spring:message code="message.msg84"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_user_mod').modal('hide');
					fn_select();
				} else if(data.resultCode == "8000000002") { //암호화 저장 실패
					showSwalIcon('<spring:message code="message.msg05"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_mod').modal('show');
					return;
				} else if(data.resultCode == "8000000003") {
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'warning');
					$('#pop_layer_user_mod').modal('hide');
				} else {
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_mod').modal('show');
					return;
				}
			}
		});
	}
</script>
<div class="modal fade" id="pop_layer_user_mod" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="user_management.userMod"/>
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
										
									<label for="mod_usr_nm" class="col-sm-2_3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.user_name" />(*)
									</label>
									<div class="col-sm-3_0">
										<input type="text" class="form-control" maxlength="25" id="mod_usr_nm" name="mod_usr_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=1 />
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
	
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="mod_bln_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.company" />
									</label>

									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="mod_bln_nm" name="mod_bln_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=4 />
									</div>

									<label for="mod_dept_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.department" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="mod_dept_nm" name="mod_dept_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=5 />
									</div>
								</div>

								<div class="form-group row">
									<label for="mod_pst_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.position" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="mod_pst_nm" name="mod_pst_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=6 />
									</div>
									
									<label for="mod_rsp_bsn_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.Responsibilities" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="mod_rsp_bsn_nm" name="mod_rsp_bsn_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=7 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="mod_cpn" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.mobile_phone_number" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="20" id="mod_cpn" name="mod_cpn" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="20<spring:message code='message.msg188'/>" tabindex=8 />
									</div>

									<label for="mod_use_yn_chk" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="onoffswitch-use" style="margin-top:0.250rem;">
											<input type="checkbox" name="mod_use_yn_chk" class="onoffswitch-use-checkbox" id="mod_use_yn_chk" />
											<label class="onoffswitch-use-label" for="mod_use_yn_chk">
												<span class="onoffswitch-use-inner"></span>
												<span class="onoffswitch-use-switch"></span>
											</label>
										</div>	
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="mod_usr_expr_dt" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.expiration_date" />
									</label>
									<div class="col-sm-4">
										<div id="mod_usr_expr_dt_div" class="input-group align-items-center date datepicker totDatepicker" >
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="mod_usr_expr_dt" name="mod_usr_expr_dt" readonly tabindex=9 />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
									
									<label for="mod_encp_use_yn_chk" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_log_decode.Encryption" /> <spring:message code="user_management.use_yn" />
									</label>
									<div class="col-sm-2">
										<div class="onoffswitch-use" style="margin-top:0.250rem;">
											<input type="checkbox" name="mod_encp_use_yn_chk" class="onoffswitch-use-checkbox" id="mod_encp_use_yn_chk" />
											<label class="onoffswitch-use-label" for="mod_encp_use_yn_chk">
												<span class="onoffswitch-use-inner"></span>
												<span class="onoffswitch-use-switch"></span>
											</label>
										</div>	
									</div>
									<div class="col-sm-2" style="height:30px;display: flex;align-items: center;">
										<span class="text-sm-left" style="font-size: 0.875rem;" id="mod_snapshotModeDetail"></span>	
									</div>
								</div>
							</div>
							
							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="mod_save_submit" value='<spring:message code="common.save" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>