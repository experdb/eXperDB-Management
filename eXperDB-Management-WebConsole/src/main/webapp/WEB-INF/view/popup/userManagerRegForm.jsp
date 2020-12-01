<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : userManagerForm.jsp
	* @Description : UserManagerForm 화면
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
		$("#ins_cpn", "#insUserForm").mask("999-9999-9999");

		//캘린더 셋팅
		fn_insDateCalenderSetting();

		$(".ins_pwd_chk").keyup(function(){
			var ins_pwd_val = $("#ins_pwd", "#insUserForm").val(); 
			var ins_pwdCheck_val = $("#ins_pwdCheck", "#insUserForm").val(); 

			if(ins_pwd_val != "" && ins_pwdCheck_val != ""){
				if(ins_pwd_val == ins_pwdCheck_val){
					$("#pwdCheck_alert-danger", "#insUserForm").hide();
 					$("#ins_save_submit", "#insUserForm").removeAttr("disabled");
					$("#ins_save_submit", "#insUserForm").removeAttr("readonly");

					$("#ins_passCheck_hid", "#insUserForm").val("1");
				}else{ 
					$("#pwdCheck_alert-danger", "#insUserForm").show(); 
					$("#ins_save_submit", "#insUserForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insUserForm").attr("readonly", "readonly"); 

					$("#ins_passCheck_hid", "#insUserForm").val("0");
				}
			} else {
				$("#pwdCheck_alert-danger", "#insUserForm").hide();
				$("#ins_save_submit", "#insUserForm").removeAttr("disabled");
				$("#ins_save_submit", "#insUserForm").removeAttr("readonly");

				$("#ins_passCheck_hid", "#insUserForm").val("0");
			}
		});

		$("#ins_pwd", "#insUserForm").blur(function(){
			var ins_pwd_val = $("#ins_pwd", "#insUserForm").val(); 
			
			if (ins_pwd_val != "") {
				var passed = pwdValidate(ins_pwd_val);

				if (passed != "") {
	 				$("#ins_pwd_alert-danger", "#insUserForm").html(passed);
					$("#ins_pwd_alert-danger", "#insUserForm").show();
					
					$("#ins_pwd_alert-light", "#insUserForm").html("");
					$("#ins_pwd_alert-light", "#insUserForm").hide();

					$("#ins_save_submit", "#insUserForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insUserForm").attr("readonly", "readonly"); 
				} else {
	 				$("#ins_pwd_alert-danger", "#insUserForm").html("");
					$("#ins_pwd_alert-danger", "#insUserForm").hide();
					$("#ins_save_submit", "#insUserForm").removeAttr("disabled");
					$("#ins_save_submit", "#insUserForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#ins_pwd", "#insUserForm").val());
					
					if (newpwdVal != "") {
		 				$("#ins_pwd_alert-light", "#insUserForm").html(newpwdVal);
						$("#ins_pwd_alert-light", "#insUserForm").show();
					} else {
						$("#ins_pwd_alert-light", "#insUserForm").html("");
						$("#ins_pwd_alert-light", "#insUserForm").hide();
					}
				}
			} else {
 				$("#ins_pwd_alert-danger", "#insUserForm").html("");
				$("#ins_pwd_alert-danger", "#insUserForm").hide();
				$("#ins_pwd_alert-light", "#insUserForm").html("");
				$("#ins_pwd_alert-light", "#insUserForm").hide();
				$("#ins_save_submit", "#insUserForm").removeAttr("disabled");
				$("#ins_save_submit", "#insUserForm").removeAttr("readonly");
			}
		});  

		$("#insUserForm").validate({
			rules: {
		        	ins_usr_id: {
						required: true
					},
					ins_usr_nm: {
						required: true
					},
					ins_pwd: {
						required: true
					},
					ins_pwdCheck: {
						required: true
					}
			},
			messages: {
					ins_usr_id: {
						required: "<spring:message code='message.msg121' />"
					},
					ins_usr_nm: {
						required: "<spring:message code='message.msg58' />"
					},
					ins_pwd: {
						required: "<spring:message code='message.msg140' />"
					},
					ins_pwdCheck: {
						required: "<spring:message code='message.msg141' />"
					}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_insPop_insert_confirm();
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
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function fn_insDateCalenderSetting() {
		var today = new Date();
		var startDay = fn_dateParse("20180101");
		var endDay = fn_dateParse("20991231");
		
		var day_today = today.toJSON().slice(0,10);
		var day_start = startDay.toJSON().slice(0,10);
		var day_end = endDay.toJSON().slice(0,10);

		if ($("#ins_usr_expr_dt_div", "#insUserForm").length) {
			$("#ins_usr_expr_dt_div", "#insUserForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#ins_usr_expr_dt", "#insUserForm").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#ins_usr_expr_dt_div", "#insUserForm").datepicker('updateDates');
	}

	/* ********************************************************
	 * id 중복체크
	 ******************************************************** */
	function fn_insIdCheck() {
		var usr_id_val = $("#ins_usr_id", "#insUserForm").val();

		if (usr_id_val == "") {
			showSwalIcon('<spring:message code="message.msg121" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insUserForm").val("0");
			
			$("#idCheck_alert-danger", "#insUserForm").hide();
			return;
		}

		$.ajax({
			url : '/userManagerIdCheck.do',
			type : 'post',
			data : {
				usr_id : usr_id_val
			},
			success : function(result) {
				if (result == "true") {
					$("#ins_idCheck", "#insUserForm").val("1");
					
					$("#idCheck_alert-danger", "#insUserForm").show();
				} else {
					showSwalIcon('<spring:message code="message.msg123" />', '<spring:message code="common.close" />', '', 'error');
					$("#ins_idCheck", "#insUserForm").val("0");
					
					$("#idCheck_alert-danger", "#insUserForm").hide();
				}
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insUserForm").val("0");
				
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
	 * 등록 confirm
	 ******************************************************** */
	function fn_insPop_insert_confirm() {
		if (!fn_ins_Validation())return false;

		fn_multiConfirmModal("ins");
	}

	/* ********************************************************
	 * 등록 validate
	 ******************************************************** */
	function fn_ins_Validation() {
		var ins_idCheck_val = $("#ins_idCheck", "#insUserForm").val();
		var ins_pwd_val = $("#ins_pwd", "#insUserForm").val(); 
		var ins_pwdCheck_val = $("#ins_pwdCheck", "#insUserForm").val(); 

		//중복체크 확인
		if (ins_idCheck_val != 1) {
			showSwalIcon('<spring:message code="message.msg142" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insUserForm").val("0");
			
			$("#idCheck_alert-danger", "#insUserForm").hide();
			return false;
		}
		
		//패스워드 검증
		if(ins_pwd_val != ins_pwdCheck_val){
			$("#pwdCheck_alert-danger", "#insUserForm").show(); 
			$("#ins_save_submit", "#insUserForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insUserForm").attr("readonly", "readonly"); 

			$("#ins_passCheck_hid", "#insUserForm").val("0");
			return false;
		}

		var passed = pwdValidate(ins_pwd_val);

		if (passed != "") {
 			$("#ins_pwd_alert-danger", "#insUserForm").html(passed);
			$("#ins_pwd_alert-danger", "#insUserForm").show();
				
			$("#ins_pwd_alert-light", "#insUserForm").html("");
			$("#ins_pwd_alert-light", "#insUserForm").hide();

			$("#ins_save_submit", "#insUserForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insUserForm").attr("readonly", "readonly"); 
			
			return false;
		}
		
		return true;
	}

	/* ********************************************************
	 * id 변경시
	 ******************************************************** */
	function fn_ins_id_chg(obj) {
		$("#ins_idCheck", "#insUserForm").val("0");
		$("#idCheck_alert-danger", "#insUserForm").hide();
	}

	/* ********************************************************
	 * 등록 실행
	 ******************************************************** */
	function fn_insPop_insert() {

		if($("#ins_use_yn_chk", "#insUserForm").is(":checked") == true){
			$("#ins_use_yn", "#insUserForm").val("Y");
		} else {
			$("#ins_use_yn", "#insUserForm").val("N");
		}

		if($("#ins_encp_use_yn_chk", "#insUserForm").is(":checked") == true){
			$("#ins_encp_use_yn", "#insUserForm").val("Y");
		} else {
			$("#ins_encp_use_yn", "#insUserForm").val("N");
		}

		$('#pop_layer_user_reg').modal('hide');

		$.ajax({
			url : '/insertUserManager.do',
			data : {
				usr_id : nvlPrmSet($("#ins_usr_id", "#insUserForm").val(), ''),
				usr_nm : nvlPrmSet($("#ins_usr_nm", "#insUserForm").val(), ''),
				pwd : nvlPrmSet($("#ins_pwd", "#insUserForm").val(), ''),
				bln_nm : nvlPrmSet($("#ins_bln_nm", "#insUserForm").val(), ''),
				dept_nm : nvlPrmSet($("#ins_dept_nm", "#insUserForm").val(), ''),
				pst_nm : nvlPrmSet($("#ins_pst_nm", "#insUserForm").val(), ''),
				rsp_bsn_nm : nvlPrmSet($("#ins_rsp_bsn_nm", "#insUserForm").val(), ''),
				cpn : nvlPrmSet($("#ins_cpn", "#insUserForm").val(), ''),
				usr_expr_dt : nvlPrmSet($("#ins_usr_expr_dt", "#insUserForm").val(), ''),
				use_yn : nvlPrmSet($("#ins_use_yn", "#insUserForm").val(), ''),
				encp_use_yn : nvlPrmSet($("#ins_encp_use_yn", "#insUserForm").val(), '')
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
					fn_multiConfirmModal("ins_menu");
				} else if(data.resultCode == "8000000002") { //암호화 저장 실패
					showSwalIcon('<spring:message code="message.msg05"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_reg').modal('show');
					return;
				} else if(data.resultCode == "8000000003") {
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'warning');
					$('#pop_layer_user_reg').modal('hide');
				} else {
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_user_reg').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 메뉴권한 환면 이동
	******************************************************** */
	function fn_insPop_menu() {
 		var usr_id = nvlPrmSet($("#ins_usr_id", "#insUserForm").val(), '');
		$('#pop_layer_user_reg').modal("hide");
		
		location.href='/menuAuthority.do?usr_id=' + nvlPrmSet($("#ins_usr_id", "#insUserForm").val(), '');
	}
</script>
<div class="modal fade" id="pop_layer_user_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="user_management.userReg"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insUserForm">
						<input type="hidden" name="ins_use_yn" id="ins_use_yn" />
						<input type="hidden" name="ins_encp_use_yn" id="ins_encp_use_yn" />
						<input type="hidden" name="ins_idCheck" id="ins_idCheck" value="0" />
						<input type="hidden" name="ins_passCheck_hid" id="ins_passCheck_hid" value="0" />
						
						<input type="hidden" name="ins_idCheck_set" id="ins_idCheck_set" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.id" />(*)
									</label>

									<div class="col-sm-2_5">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 180px;" autocomplete="off" maxlength="15" id="ins_usr_id" name="ins_usr_id" onkeyup="fn_checkWord(this,15)" onblur="this.value=this.value.trim()" onChange="fn_ins_id_chg(this);" placeholder="15<spring:message code='message.msg188'/>" tabindex=1 />
									</div>

									<div class="col-sm-1_5">
										<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onclick="fn_insIdCheck();" value='<spring:message code="common.overlap_check" />' />
									</div>
									
									<label for="ins_usr_nm" class="col-sm-2_3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.user_name" />(*)
									</label>
									<div class="col-sm-3_0">
										<input type="text" class="form-control" maxlength="25" id="ins_usr_nm" name="ins_usr_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
									</div>
								</div>

								<div class="form-group row">
									<div class="col-sm-6">
										<div class="alert alert-info" style="margin-top:5px;display:none;" id="idCheck_alert-danger"><spring:message code="message.msg122" /></div>
									</div>
									<div class="col-sm-6">
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="ins_pwd" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>

									<div class="col-sm-4">
										<input type="password" style="display:none" aria-hidden="true">
										<input type="password" class="form-control ins_pwd_chk" autocomplete="new-password" maxlength="20" id="ins_pwd" name="ins_pwd" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="<spring:message code='message.msg109'/>" tabindex=3 />
									</div>

									<label for="ins_pwdCheck" class="col-sm-2_3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.confirm_password" />(*)
									</label>
									<div class="col-sm-3_0">
										<input type="password" class="form-control ins_pwd_chk" maxlength="20" id="ins_pwdCheck" name="ins_pwdCheck" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="<spring:message code='message.msg109'/>" tabindex=4 />
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<div class="col-sm-6">
										<div class="alert alert-light" style="margin-top:5px;display:none;" id="ins_pwd_alert-light"></div>
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_pwd_alert-danger"></div>
									</div>
									<div class="col-sm-6">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="pwdCheck_alert-danger"><spring:message code="etc.etc14" /></div>
									</div>
								</div>
							</div>

							<br/>
	
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="ins_bln_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.company" />
									</label>

									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="ins_bln_nm" name="ins_bln_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=5 />
									</div>

									<label for="ins_dept_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.department" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="ins_dept_nm" name="ins_dept_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=6 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_pst_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.position" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="ins_pst_nm" name="ins_pst_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=7 />
									</div>
									
									<label for="ins_rsp_bsn_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.Responsibilities" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="25" id="ins_rsp_bsn_nm" name="ins_rsp_bsn_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=8 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_cpn" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.mobile_phone_number" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="20" id="ins_cpn" name="ins_cpn" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="20<spring:message code='message.msg188'/>" tabindex=9 />
									</div>
									<label for="ins_use_yn_chk" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="onoffswitch-use" style="margin-top:0.250rem;">
											<input type="checkbox" name="ins_use_yn_chk" class="onoffswitch-use-checkbox" id="ins_use_yn_chk" />
											<label class="onoffswitch-use-label" for="ins_use_yn_chk">
												<span class="onoffswitch-use-inner"></span>
												<span class="onoffswitch-use-switch"></span>
											</label>
										</div>	
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<label for="ins_usr_expr_dt" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.expiration_date" />
									</label>
									<div class="col-sm-4">
										<div id="ins_usr_expr_dt_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="ins_usr_expr_dt" name="ins_usr_expr_dt" readonly tabindex=10 />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
									<label for="ins_encp_use_yn_chk" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_log_decode.Encryption" /> <spring:message code="user_management.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="onoffswitch-use" style="margin-top:0.250rem;">
											<input type="checkbox" name="ins_encp_use_yn_chk" class="onoffswitch-use-checkbox" id="ins_encp_use_yn_chk" />
											<label class="onoffswitch-use-label" for="ins_encp_use_yn_chk">
												<span class="onoffswitch-use-inner"></span>
												<span class="onoffswitch-use-switch"></span>
											</label>
										</div>	
									</div>
								</div>
							</div>
							
							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="ins_save_submit" value='<spring:message code="common.save" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>