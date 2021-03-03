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
var serverListTable = null;


function fn_serverListTable_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	 serverListTable = $('#serverList').DataTable({
		scrollY : "100px",
		bSort: false,
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
		columns : [
		{data : "rownum",
			render: function(data, type, full, meta){
		    	if(type === 'display'){
		        	data = '<input type="radio" name="radio" value="' + data + '">';   
		       	}
		        return data;
		    },
			defaultContent : "",  
			targets: 0,
	    	searchable: false,
	    	orderable: false,
	    	className : "dt-center"
	    }, 
		{data : "ipadr",  defaultContent : ""},
		{data : "portno", className : "dt-right",  defaultContent : ""},
		{data : "master_gbn",  defaultContent : ""},
		{data : "connYn",  defaultContent : ""},	
		{data : "svr_host_nm",  defaultContent : "", visible: false}
		]
	});
	
	serverListTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	serverListTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
	serverListTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	serverListTable.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	serverListTable.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
	serverListTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
	
    $(window).trigger('resize'); 
}

	$(window.document).ready(function() {
		
		fn_serverListTable_init();

		$(".ins_pwd_chk").keyup(function(){
			var ins_pwd_val = $("#ins_pwd", "#insProxyListenForm").val(); 
			var ins_pwdCheck_val = $("#ins_pwdCheck", "#insProxyListenForm").val(); 

			if(ins_pwd_val != "" && ins_pwdCheck_val != ""){
				if(ins_pwd_val == ins_pwdCheck_val){
					//$("#pwdCheck_alert-danger", "#insProxyListenForm").hide();
 					$("#ins_save_submit", "#insProxyListenForm").removeAttr("disabled");
					$("#ins_save_submit", "#insProxyListenForm").removeAttr("readonly");

					$("#ins_passCheck_hid", "#insProxyListenForm").val("1");
				}else{ 
					//$("#pwdCheck_alert-danger", "#insProxyListenForm").show(); 
					$("#ins_save_submit", "#insProxyListenForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insProxyListenForm").attr("readonly", "readonly"); 

					$("#ins_passCheck_hid", "#insProxyListenForm").val("0");
				}
			} else {
				//$("#pwdCheck_alert-danger", "#insProxyListenForm").hide();
				$("#ins_save_submit", "#insProxyListenForm").removeAttr("disabled");
				$("#ins_save_submit", "#insProxyListenForm").removeAttr("readonly");

				$("#ins_passCheck_hid", "#insProxyListenForm").val("0");
			}
		});

		$("#ins_pwd", "#insProxyListenForm").blur(function(){
			var ins_pwd_val = $("#ins_pwd", "#insProxyListenForm").val(); 
			
			if (ins_pwd_val != "") {
				var passed = pwdValidate(ins_pwd_val);

				if (passed != "") {
	 				//$("#ins_pwd_alert-danger", "#insProxyListenForm").html(passed);
					//$("#ins_pwd_alert-danger", "#insProxyListenForm").show();
					
					//$("#ins_pwd_alert-light", "#insProxyListenForm").html("");
					//$("#ins_pwd_alert-light", "#insProxyListenForm").hide();

					$("#ins_save_submit", "#insProxyListenForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insProxyListenForm").attr("readonly", "readonly"); 
				} else {
	 				//$("#ins_pwd_alert-danger", "#insProxyListenForm").html("");
					//$("#ins_pwd_alert-danger", "#insProxyListenForm").hide();
					$("#ins_save_submit", "#insProxyListenForm").removeAttr("disabled");
					$("#ins_save_submit", "#insProxyListenForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#ins_pwd", "#insProxyListenForm").val());
					
					if (newpwdVal != "") {
		 				//$("#ins_pwd_alert-light", "#insProxyListenForm").html(newpwdVal);
						//$("#ins_pwd_alert-light", "#insProxyListenForm").show();
					} else {
						//$("#ins_pwd_alert-light", "#insProxyListenForm").html("");
						//$("#ins_pwd_alert-light", "#insProxyListenForm").hide();
					}
				}
			} else {
 				//$("#ins_pwd_alert-danger", "#insProxyListenForm").html("");
				//$("#ins_pwd_alert-danger", "#insProxyListenForm").hide();
				//$("#ins_pwd_alert-light", "#insProxyListenForm").html("");
				//$("#ins_pwd_alert-light", "#insProxyListenForm").hide();
				$("#ins_save_submit", "#insProxyListenForm").removeAttr("disabled");
				$("#ins_save_submit", "#insProxyListenForm").removeAttr("readonly");
			}
		});  

		$("#insProxyListenForm").validate({
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

		if ($("#ins_usr_expr_dt_div", "#insProxyListenForm").length) {
			$("#ins_usr_expr_dt_div", "#insProxyListenForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#ins_usr_expr_dt", "#insProxyListenForm").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#ins_usr_expr_dt_div", "#insProxyListenForm").datepicker('updateDates');
	}

	/* ********************************************************
	 * id 중복체크
	 ******************************************************** */
	function fn_insIdCheck() {
		var usr_id_val = $("#ins_usr_id", "#insProxyListenForm").val();

		if (usr_id_val == "") {
			showSwalIcon('<spring:message code="message.msg121" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insProxyListenForm").val("0");
			
			//$("#idCheck_alert-danger", "#insProxyListenForm").hide();
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
					$("#ins_idCheck", "#insProxyListenForm").val("1");
					
					//$("#idCheck_alert-danger", "#insProxyListenForm").show();
				} else {
					showSwalIcon('<spring:message code="message.msg123" />', '<spring:message code="common.close" />', '', 'error');
					$("#ins_idCheck", "#insProxyListenForm").val("0");
					
					//$("#idCheck_alert-danger", "#insProxyListenForm").hide();
				}
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insProxyListenForm").val("0");
				
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
		var ins_idCheck_val = $("#ins_idCheck", "#insProxyListenForm").val();
		var ins_pwd_val = $("#ins_pwd", "#insProxyListenForm").val(); 
		var ins_pwdCheck_val = $("#ins_pwdCheck", "#insProxyListenForm").val(); 

		//중복체크 확인
		if (ins_idCheck_val != 1) {
			showSwalIcon('<spring:message code="message.msg142" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insProxyListenForm").val("0");
			
			//$("#idCheck_alert-danger", "#insProxyListenForm").hide();
			return false;
		}
		
		//패스워드 검증
		if(ins_pwd_val != ins_pwdCheck_val){
			//$("#pwdCheck_alert-danger", "#insProxyListenForm").show(); 
			$("#ins_save_submit", "#insProxyListenForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insProxyListenForm").attr("readonly", "readonly"); 

			$("#ins_passCheck_hid", "#insProxyListenForm").val("0");
			return false;
		}

		var passed = pwdValidate(ins_pwd_val);

		if (passed != "") {
 			//$("#ins_pwd_alert-danger", "#insProxyListenForm").html(passed);
			//$("#ins_pwd_alert-danger", "#insProxyListenForm").show();
				
			//$("#ins_pwd_alert-light", "#insProxyListenForm").html("");
			//$("#ins_pwd_alert-light", "#insProxyListenForm").hide();

			$("#ins_save_submit", "#insProxyListenForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insProxyListenForm").attr("readonly", "readonly"); 
			
			return false;
		}
		
		return true;
	}

	/* ********************************************************
	 * id 변경시
	 ******************************************************** */
	function fn_ins_id_chg(obj) {
		$("#ins_idCheck", "#insProxyListenForm").val("0");
		//$("#idCheck_alert-danger", "#insProxyListenForm").hide();
	}

	/* ********************************************************
	 * 등록 실행
	 ******************************************************** */
	function fn_insPop_insert() {

		if($("#ins_use_yn_chk", "#insProxyListenForm").is(":checked") == true){
			$("#ins_use_yn", "#insProxyListenForm").val("Y");
		} else {
			$("#ins_use_yn", "#insProxyListenForm").val("N");
		}

		if($("#ins_encp_use_yn_chk", "#insProxyListenForm").is(":checked") == true){
			$("#ins_encp_use_yn", "#insProxyListenForm").val("Y");
		} else {
			$("#ins_encp_use_yn", "#insProxyListenForm").val("N");
		}

		$('#pop_layer_svr_reg').modal('hide');

		$.ajax({
			url : '/insertUserManager.do',
			data : {
				usr_id : nvlPrmSet($("#ins_usr_id", "#insProxyListenForm").val(), ''),
				usr_nm : nvlPrmSet($("#ins_usr_nm", "#insProxyListenForm").val(), ''),
				pwd : nvlPrmSet($("#ins_pwd", "#insProxyListenForm").val(), ''),
				bln_nm : nvlPrmSet($("#ins_bln_nm", "#insProxyListenForm").val(), ''),
				dept_nm : nvlPrmSet($("#ins_dept_nm", "#insProxyListenForm").val(), ''),
				pst_nm : nvlPrmSet($("#ins_pst_nm", "#insProxyListenForm").val(), ''),
				rsp_bsn_nm : nvlPrmSet($("#ins_rsp_bsn_nm", "#insProxyListenForm").val(), ''),
				cpn : nvlPrmSet($("#ins_cpn", "#insProxyListenForm").val(), ''),
				usr_expr_dt : nvlPrmSet($("#ins_usr_expr_dt", "#insProxyListenForm").val(), ''),
				use_yn : nvlPrmSet($("#ins_use_yn", "#insProxyListenForm").val(), ''),
				encp_use_yn : nvlPrmSet($("#ins_encp_use_yn", "#insProxyListenForm").val(), '')
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
					$('#pop_layer_svr_reg').modal('show');
					return;
				} else if(data.resultCode == "8000000003") {
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'warning');
					$('#pop_layer_svr_reg').modal('hide');
				} else {
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_svr_reg').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 메뉴권한 환면 이동
	******************************************************** */
	function fn_insPop_menu() {
 		var usr_id = nvlPrmSet($("#ins_usr_id", "#insProxyListenForm").val(), '');
		$('#pop_layer_svr_reg').modal("hide");
		
		location.href='/menuAuthority.do?usr_id=' + nvlPrmSet($("#ins_usr_id", "#insProxyListenForm").val(), '');
	}
	
	
	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="form-control form-control-xsm" name="exe_m" id="exe_m">';	
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
<div class="modal fade" id="pop_layer_proxy_listen_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.listener_reg"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insProxyListenForm">
						<!-- <input type="hidden" name="ins_use_yn" id="ins_use_yn" />
						<input type="hidden" name="ins_encp_use_yn" id="ins_encp_use_yn" />
						<input type="hidden" name="ins_idCheck" id="ins_idCheck" value="0" />
						<input type="hidden" name="ins_passCheck_hid" id="ins_passCheck_hid" value="0" />
						
						<input type="hidden" name="ins_idCheck_set" id="ins_idCheck_set" /> -->

						<fieldset>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="ins_lsn_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.id" /> --%>
										Listener 명칭(*)
									</label>

									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm ins_lsn_nm" autocomplete="off" maxlength="15" id="ins_lsn_nm" name="ins_lsn_nm" onkeyup="fn_checkWord(this,15)" onblur="this.value=this.value.trim()" onChange="fn_ins_id_chg(this);" placeholder="15<spring:message code='message.msg188'/>" tabindex=1 />
									</div>
									<label for="ins_con_bind" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.user_name" /> --%>
										bind(*)
									</label>
									<div class="col-sm-2_2">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_con_bind_ip" name="ins_con_bind_ip" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="ip 주소 또는 *" tabindex=2 />
									</div>
									<div class="col-sm-auto col-form-label-sm">
										:
									</div>
									<div class="col-sm-1_5">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_con_bind_port" name="ins_con_bind_port" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="port" tabindex=2 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="ins_lsn_desc" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										설명
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_lsn_desc" name="ins_lsn_desc" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
							</div>
							<br/>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="ins_db_user_id" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										 계정(*)
									</label>
									<div class="col-sm-4" id="ins_db_user_id">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_db_user_id" name="ins_db_user_id" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
									<label for="ins_db_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										Database(*)
									</label>
									<div class="col-sm-4" id="ins_db_nm">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_db_nm" name="ins_db_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_con_sim_query" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Simple Query(*)
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_con_sim_query" name="ins_con_sim_query" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="ins_file_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										필드명(*)
									</label>
									<div class="col-sm-4" id="ins_file_nm">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_file_nm" name="ins_file_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
									<label for="ins_field_val" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										필드값(*)
									</label>
									<div class="col-sm-4" id="ins_field_val">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_field_val" name="ins_field_val" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
							</div>
							
							<br/>
							
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
										<label for="com_db_svr_nm" class="col-sm-12 col-form-label-sm" style="margin-bottom:-50px;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											DBMS
										</label>
									</div>
									<div class="form-group row">
										<div class="col-sm-12">
											<a data-toggle="modal" href="#pop_layer_ip_reg"><span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span></a>
											<span onclick="fn_ipadrDelForm();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
											<table id="serverList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="50"></th>
														<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
														<th width="150"><spring:message code="data_transfer.port" /></th>
														<th width="200"><spring:message code="common.division" /></th>
														<th width="200"><spring:message code="dbms_information.conn_YN"/></th>	
														<th width="0"></th>								
													</tr>
												</thead>
											</table>
										
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