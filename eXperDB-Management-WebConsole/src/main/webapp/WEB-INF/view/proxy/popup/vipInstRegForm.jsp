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
		
		$(".ins_pwd_chk").keyup(function(){
			var ins_pwd_val = $("#ins_pwd", "#insVipInstForm").val(); 
			var ins_pwdCheck_val = $("#ins_pwdCheck", "#insVipInstForm").val(); 

			if(ins_pwd_val != "" && ins_pwdCheck_val != ""){
				if(ins_pwd_val == ins_pwdCheck_val){
					//$("#pwdCheck_alert-danger", "#insVipInstForm").hide();
 					$("#ins_save_submit", "#insVipInstForm").removeAttr("disabled");
					$("#ins_save_submit", "#insVipInstForm").removeAttr("readonly");

					$("#ins_passCheck_hid", "#insVipInstForm").val("1");
				}else{ 
					//$("#pwdCheck_alert-danger", "#insVipInstForm").show(); 
					$("#ins_save_submit", "#insVipInstForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insVipInstForm").attr("readonly", "readonly"); 

					$("#ins_passCheck_hid", "#insVipInstForm").val("0");
				}
			} else {
				//$("#pwdCheck_alert-danger", "#insVipInstForm").hide();
				$("#ins_save_submit", "#insVipInstForm").removeAttr("disabled");
				$("#ins_save_submit", "#insVipInstForm").removeAttr("readonly");

				$("#ins_passCheck_hid", "#insVipInstForm").val("0");
			}
		});

		$("#ins_pwd", "#insVipInstForm").blur(function(){
			var ins_pwd_val = $("#ins_pwd", "#insVipInstForm").val(); 
			
			if (ins_pwd_val != "") {
				var passed = pwdValidate(ins_pwd_val);

				if (passed != "") {
	 				//$("#ins_pwd_alert-danger", "#insVipInstForm").html(passed);
					//$("#ins_pwd_alert-danger", "#insVipInstForm").show();
					
					//$("#ins_pwd_alert-light", "#insVipInstForm").html("");
					//$("#ins_pwd_alert-light", "#insVipInstForm").hide();

					$("#ins_save_submit", "#insVipInstForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insVipInstForm").attr("readonly", "readonly"); 
				} else {
	 				//$("#ins_pwd_alert-danger", "#insVipInstForm").html("");
					//$("#ins_pwd_alert-danger", "#insVipInstForm").hide();
					$("#ins_save_submit", "#insVipInstForm").removeAttr("disabled");
					$("#ins_save_submit", "#insVipInstForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#ins_pwd", "#insVipInstForm").val());
					
					if (newpwdVal != "") {
		 				//$("#ins_pwd_alert-light", "#insVipInstForm").html(newpwdVal);
						//$("#ins_pwd_alert-light", "#insVipInstForm").show();
					} else {
						//$("#ins_pwd_alert-light", "#insVipInstForm").html("");
						//$("#ins_pwd_alert-light", "#insVipInstForm").hide();
					}
				}
			} else {
 				//$("#ins_pwd_alert-danger", "#insVipInstForm").html("");
				//$("#ins_pwd_alert-danger", "#insVipInstForm").hide();
				//$("#ins_pwd_alert-light", "#insVipInstForm").html("");
				//$("#ins_pwd_alert-light", "#insVipInstForm").hide();
				$("#ins_save_submit", "#insVipInstForm").removeAttr("disabled");
				$("#ins_save_submit", "#insVipInstForm").removeAttr("readonly");
			}
		});  

		$("#insVipInstForm").validate({
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

		if ($("#ins_usr_expr_dt_div", "#insVipInstForm").length) {
			$("#ins_usr_expr_dt_div", "#insVipInstForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#ins_usr_expr_dt", "#insVipInstForm").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#ins_usr_expr_dt_div", "#insVipInstForm").datepicker('updateDates');
	}

	/* ********************************************************
	 * id 중복체크
	 ******************************************************** */
	function fn_insIdCheck() {
		var usr_id_val = $("#ins_usr_id", "#insVipInstForm").val();

		if (usr_id_val == "") {
			showSwalIcon('<spring:message code="message.msg121" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insVipInstForm").val("0");
			
			//$("#idCheck_alert-danger", "#insVipInstForm").hide();
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
					$("#ins_idCheck", "#insVipInstForm").val("1");
					
					//$("#idCheck_alert-danger", "#insVipInstForm").show();
				} else {
					showSwalIcon('<spring:message code="message.msg123" />', '<spring:message code="common.close" />', '', 'error');
					$("#ins_idCheck", "#insVipInstForm").val("0");
					
					//$("#idCheck_alert-danger", "#insVipInstForm").hide();
				}
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insVipInstForm").val("0");
				
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
		var ins_idCheck_val = $("#ins_idCheck", "#insVipInstForm").val();
		var ins_pwd_val = $("#ins_pwd", "#insVipInstForm").val(); 
		var ins_pwdCheck_val = $("#ins_pwdCheck", "#insVipInstForm").val(); 

		//중복체크 확인
		if (ins_idCheck_val != 1) {
			showSwalIcon('<spring:message code="message.msg142" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insVipInstForm").val("0");
			
			//$("#idCheck_alert-danger", "#insVipInstForm").hide();
			return false;
		}
		
		//패스워드 검증
		if(ins_pwd_val != ins_pwdCheck_val){
			//$("#pwdCheck_alert-danger", "#insVipInstForm").show(); 
			$("#ins_save_submit", "#insVipInstForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insVipInstForm").attr("readonly", "readonly"); 

			$("#ins_passCheck_hid", "#insVipInstForm").val("0");
			return false;
		}

		var passed = pwdValidate(ins_pwd_val);

		if (passed != "") {
 			//$("#ins_pwd_alert-danger", "#insVipInstForm").html(passed);
			//$("#ins_pwd_alert-danger", "#insVipInstForm").show();
				
			//$("#ins_pwd_alert-light", "#insVipInstForm").html("");
			//$("#ins_pwd_alert-light", "#insVipInstForm").hide();

			$("#ins_save_submit", "#insVipInstForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insVipInstForm").attr("readonly", "readonly"); 
			
			return false;
		}
		
		return true;
	}

	/* ********************************************************
	 * id 변경시
	 ******************************************************** */
	function fn_ins_id_chg(obj) {
		$("#ins_idCheck", "#insVipInstForm").val("0");
		//$("#idCheck_alert-danger", "#insVipInstForm").hide();
	}

	/* ********************************************************
	 * 등록 실행
	 ******************************************************** */
	function fn_insPop_insert() {

		if($("#ins_use_yn_chk", "#insVipInstForm").is(":checked") == true){
			$("#ins_use_yn", "#insVipInstForm").val("Y");
		} else {
			$("#ins_use_yn", "#insVipInstForm").val("N");
		}

		if($("#ins_encp_use_yn_chk", "#insVipInstForm").is(":checked") == true){
			$("#ins_encp_use_yn", "#insVipInstForm").val("Y");
		} else {
			$("#ins_encp_use_yn", "#insVipInstForm").val("N");
		}

		$('#pop_layer_proxy_inst_reg').modal('hide');

		$.ajax({
			url : '/insertUserManager.do',
			data : {
				usr_id : nvlPrmSet($("#ins_usr_id", "#insVipInstForm").val(), ''),
				usr_nm : nvlPrmSet($("#ins_usr_nm", "#insVipInstForm").val(), ''),
				pwd : nvlPrmSet($("#ins_pwd", "#insVipInstForm").val(), ''),
				bln_nm : nvlPrmSet($("#ins_bln_nm", "#insVipInstForm").val(), ''),
				dept_nm : nvlPrmSet($("#ins_dept_nm", "#insVipInstForm").val(), ''),
				pst_nm : nvlPrmSet($("#ins_pst_nm", "#insVipInstForm").val(), ''),
				rsp_bsn_nm : nvlPrmSet($("#ins_rsp_bsn_nm", "#insVipInstForm").val(), ''),
				cpn : nvlPrmSet($("#ins_cpn", "#insVipInstForm").val(), ''),
				usr_expr_dt : nvlPrmSet($("#ins_usr_expr_dt", "#insVipInstForm").val(), ''),
				use_yn : nvlPrmSet($("#ins_use_yn", "#insVipInstForm").val(), ''),
				encp_use_yn : nvlPrmSet($("#ins_encp_use_yn", "#insVipInstForm").val(), '')
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
					$('#pop_layer_proxy_inst_reg').modal('show');
					return;
				} else if(data.resultCode == "8000000003") {
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'warning');
					$('#pop_layer_proxy_inst_reg').modal('hide');
				} else {
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_proxy_inst_reg').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 메뉴권한 환면 이동
	******************************************************** */
	function fn_insPop_menu() {
 		var usr_id = nvlPrmSet($("#ins_usr_id", "#insVipInstForm").val(), '');
		$('#pop_layer_proxy_inst_reg').modal("hide");
		
		location.href='/menuAuthority.do?usr_id=' + nvlPrmSet($("#ins_usr_id", "#insVipInstForm").val(), '');
	}
	
	
	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="form-control form-control-sm" name="exe_m" id="exe_m">';	
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		minHtml += '</select> <spring:message code="schedule.minute" />&emsp;';	
		$( "#min" ).append(minHtml);
	}
	
</script>
<div class="modal fade" id="pop_layer_proxy_inst_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.instance_reg"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insVipInstForm">
						<fieldset>
							<div class="card-body card-body-border">
								<div class="form-group row">
									<label for="ins_if_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										Interface(*)
									</label>
									<div class="col-sm-2" id="div_day_data_del_term">
										<input type="text" class="form-control form-control-sm ins_if_nm" maxlength="20" id="ins_if_nm" name="ins_if_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
									<label for="ins_master_gbn" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										우선순위(*)
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control form-control-sm ins_priority" maxlength="20" id="ins_priority" name="ins_priority" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
											
									</div>
									<label for="ins_chk_tm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										체크간격(*)
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control form-control-sm ins_chk_tm" maxlength="20" id="ins_chk_tm" name="ins_chk_tm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="ins_v_ip" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										가상 IP(*)
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control form-control-sm ins_v_ip" maxlength="20" id="ins_v_ip" name="ins_v_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
									
									<label for="ins_v_if_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.Responsibilities" /> --%>
										가상 Interface(*)
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control form-control-sm ins_v_if_nm" maxlength="20" id="ins_v_if_nm" name="ins_v_if_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
									<label for="ins_v_rot_id" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.Responsibilities" /> --%>
										가상 라우터 ID(*)
									</label>
									<div class="col-sm-2" id="div_min_data_del_term">
										<input type="text" class="form-control form-control-sm ins_v_rot_id" maxlength="20" id="ins_v_rot_id" name="ins_v_rot_id" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
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