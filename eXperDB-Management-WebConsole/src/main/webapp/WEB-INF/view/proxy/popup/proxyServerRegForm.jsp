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
var mgmtDbmsTable = null;


function fn_mgmtDbmsTable_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	 mgmtDbmsTable = $('#mgmtDbms').DataTable({
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
	    {data : "svr_host_nm",className : "dt-center",  defaultContent : ""},
	    {data : "master_gbn",className : "dt-center",  defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center",  defaultContent : ""},
		{data : "db_cndt", className : "dt-center",  defaultContent : ""},
		{data : "db_svr_id", defaultContent : "", visible: false}
		]
	});
	
	mgmtDbmsTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	mgmtDbmsTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');//server명
	mgmtDbmsTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');//마스터 구분
	mgmtDbmsTable.tables().header().to$().find('th:eq(3)').css('min-width', '150px');//ip 주소
	mgmtDbmsTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');//포트 번호
	mgmtDbmsTable.tables().header().to$().find('th:eq(5)').css('min-width', '80px');//db 상태
	mgmtDbmsTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');//db server id
	
    $(window).trigger('resize'); 
}

	$(window.document).ready(function() {
		
		fn_mgmtDbmsTable_init();

		$(".ins_pwd_chk").keyup(function(){
			var ins_pwd_val = $("#ins_pwd", "#insProxyServerForm").val(); 
			var ins_pwdCheck_val = $("#ins_pwdCheck", "#insProxyServerForm").val(); 

			if(ins_pwd_val != "" && ins_pwdCheck_val != ""){
				if(ins_pwd_val == ins_pwdCheck_val){
					//$("#pwdCheck_alert-danger", "#insProxyServerForm").hide();
 					$("#ins_save_submit", "#insProxyServerForm").removeAttr("disabled");
					$("#ins_save_submit", "#insProxyServerForm").removeAttr("readonly");

					$("#ins_passCheck_hid", "#insProxyServerForm").val("1");
				}else{ 
					//$("#pwdCheck_alert-danger", "#insProxyServerForm").show(); 
					$("#ins_save_submit", "#insProxyServerForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insProxyServerForm").attr("readonly", "readonly"); 

					$("#ins_passCheck_hid", "#insProxyServerForm").val("0");
				}
			} else {
				//$("#pwdCheck_alert-danger", "#insProxyServerForm").hide();
				$("#ins_save_submit", "#insProxyServerForm").removeAttr("disabled");
				$("#ins_save_submit", "#insProxyServerForm").removeAttr("readonly");

				$("#ins_passCheck_hid", "#insProxyServerForm").val("0");
			}
		});

		$("#ins_pwd", "#insProxyServerForm").blur(function(){
			var ins_pwd_val = $("#ins_pwd", "#insProxyServerForm").val(); 
			
			if (ins_pwd_val != "") {
				var passed = pwdValidate(ins_pwd_val);

				if (passed != "") {
	 				//$("#ins_pwd_alert-danger", "#insProxyServerForm").html(passed);
					//$("#ins_pwd_alert-danger", "#insProxyServerForm").show();
					
					//$("#ins_pwd_alert-light", "#insProxyServerForm").html("");
					//$("#ins_pwd_alert-light", "#insProxyServerForm").hide();

					$("#ins_save_submit", "#insProxyServerForm").attr("disabled", "disabled"); 
					$("#ins_save_submit", "#insProxyServerForm").attr("readonly", "readonly"); 
				} else {
	 				//$("#ins_pwd_alert-danger", "#insProxyServerForm").html("");
					//$("#ins_pwd_alert-danger", "#insProxyServerForm").hide();
					$("#ins_save_submit", "#insProxyServerForm").removeAttr("disabled");
					$("#ins_save_submit", "#insProxyServerForm").removeAttr("readonly");

					var newpwdVal = pwdSafety($("#ins_pwd", "#insProxyServerForm").val());
					
					if (newpwdVal != "") {
		 				//$("#ins_pwd_alert-light", "#insProxyServerForm").html(newpwdVal);
						//$("#ins_pwd_alert-light", "#insProxyServerForm").show();
					} else {
						//$("#ins_pwd_alert-light", "#insProxyServerForm").html("");
						//$("#ins_pwd_alert-light", "#insProxyServerForm").hide();
					}
				}
			} else {
 				//$("#ins_pwd_alert-danger", "#insProxyServerForm").html("");
				//$("#ins_pwd_alert-danger", "#insProxyServerForm").hide();
				//$("#ins_pwd_alert-light", "#insProxyServerForm").html("");
				//$("#ins_pwd_alert-light", "#insProxyServerForm").hide();
				$("#ins_save_submit", "#insProxyServerForm").removeAttr("disabled");
				$("#ins_save_submit", "#insProxyServerForm").removeAttr("readonly");
			}
		});  

		$("#insProxyServerForm").validate({
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

		if ($("#ins_usr_expr_dt_div", "#insProxyServerForm").length) {
			$("#ins_usr_expr_dt_div", "#insProxyServerForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#ins_usr_expr_dt", "#insProxyServerForm").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#ins_usr_expr_dt_div", "#insProxyServerForm").datepicker('updateDates');
	}

	/* ********************************************************
	 * id 중복체크
	 ******************************************************** */
	function fn_insIdCheck() {
		var usr_id_val = $("#ins_usr_id", "#insProxyServerForm").val();

		if (usr_id_val == "") {
			showSwalIcon('<spring:message code="message.msg121" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insProxyServerForm").val("0");
			
			//$("#idCheck_alert-danger", "#insProxyServerForm").hide();
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
					$("#ins_idCheck", "#insProxyServerForm").val("1");
					
					//$("#idCheck_alert-danger", "#insProxyServerForm").show();
				} else {
					showSwalIcon('<spring:message code="message.msg123" />', '<spring:message code="common.close" />', '', 'error');
					$("#ins_idCheck", "#insProxyServerForm").val("0");
					
					//$("#idCheck_alert-danger", "#insProxyServerForm").hide();
				}
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insProxyServerForm").val("0");
				
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
		var ins_idCheck_val = $("#ins_idCheck", "#insProxyServerForm").val();
		var ins_pwd_val = $("#ins_pwd", "#insProxyServerForm").val(); 
		var ins_pwdCheck_val = $("#ins_pwdCheck", "#insProxyServerForm").val(); 

		//중복체크 확인
		if (ins_idCheck_val != 1) {
			showSwalIcon('<spring:message code="message.msg142" />', '<spring:message code="common.close" />', '', 'warning');
			$("#ins_idCheck", "#insProxyServerForm").val("0");
			
			//$("#idCheck_alert-danger", "#insProxyServerForm").hide();
			return false;
		}
		
		//패스워드 검증
		if(ins_pwd_val != ins_pwdCheck_val){
			//$("#pwdCheck_alert-danger", "#insProxyServerForm").show(); 
			$("#ins_save_submit", "#insProxyServerForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insProxyServerForm").attr("readonly", "readonly"); 

			$("#ins_passCheck_hid", "#insProxyServerForm").val("0");
			return false;
		}

		var passed = pwdValidate(ins_pwd_val);

		if (passed != "") {
 			//$("#ins_pwd_alert-danger", "#insProxyServerForm").html(passed);
			//$("#ins_pwd_alert-danger", "#insProxyServerForm").show();
				
			//$("#ins_pwd_alert-light", "#insProxyServerForm").html("");
			//$("#ins_pwd_alert-light", "#insProxyServerForm").hide();

			$("#ins_save_submit", "#insProxyServerForm").attr("disabled", "disabled"); 
			$("#ins_save_submit", "#insProxyServerForm").attr("readonly", "readonly"); 
			
			return false;
		}
		
		return true;
	}

	/* ********************************************************
	 * id 변경시
	 ******************************************************** */
	function fn_ins_id_chg(obj) {
		$("#ins_idCheck", "#insProxyServerForm").val("0");
		//$("#idCheck_alert-danger", "#insProxyServerForm").hide();
	}

	/* ********************************************************
	 * 등록 실행
	 ******************************************************** */
	function fn_insPop_insert() {

		if($("#ins_use_yn_chk", "#insProxyServerForm").is(":checked") == true){
			$("#ins_use_yn", "#insProxyServerForm").val("Y");
		} else {
			$("#ins_use_yn", "#insProxyServerForm").val("N");
		}

		if($("#ins_encp_use_yn_chk", "#insProxyServerForm").is(":checked") == true){
			$("#ins_encp_use_yn", "#insProxyServerForm").val("Y");
		} else {
			$("#ins_encp_use_yn", "#insProxyServerForm").val("N");
		}

		$('#pop_layer_svr_reg').modal('hide');

		$.ajax({
			url : '/insertUserManager.do',
			data : {
				usr_id : nvlPrmSet($("#ins_usr_id", "#insProxyServerForm").val(), ''),
				usr_nm : nvlPrmSet($("#ins_usr_nm", "#insProxyServerForm").val(), ''),
				pwd : nvlPrmSet($("#ins_pwd", "#insProxyServerForm").val(), ''),
				bln_nm : nvlPrmSet($("#ins_bln_nm", "#insProxyServerForm").val(), ''),
				dept_nm : nvlPrmSet($("#ins_dept_nm", "#insProxyServerForm").val(), ''),
				pst_nm : nvlPrmSet($("#ins_pst_nm", "#insProxyServerForm").val(), ''),
				rsp_bsn_nm : nvlPrmSet($("#ins_rsp_bsn_nm", "#insProxyServerForm").val(), ''),
				cpn : nvlPrmSet($("#ins_cpn", "#insProxyServerForm").val(), ''),
				usr_expr_dt : nvlPrmSet($("#ins_usr_expr_dt", "#insProxyServerForm").val(), ''),
				use_yn : nvlPrmSet($("#ins_use_yn", "#insProxyServerForm").val(), ''),
				encp_use_yn : nvlPrmSet($("#ins_encp_use_yn", "#insProxyServerForm").val(), '')
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
 		var usr_id = nvlPrmSet($("#ins_usr_id", "#insProxyServerForm").val(), '');
		$('#pop_layer_svr_reg').modal("hide");
		
		location.href='/menuAuthority.do?usr_id=' + nvlPrmSet($("#ins_usr_id", "#insProxyServerForm").val(), '');
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
<div class="modal fade" id="pop_layer_svr_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.server_reg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insProxyServerForm">
						<fieldset>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="ins_master_gbn" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										Proxy 구분(*)
									</label>
									<div class="col-sm-2">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="ins_master_gbn" id="ins_master_gbn">
											<option value="m">Master</option>
											<option value="b">Backup</option>
										</select>
									</div>
									<div class="col-sm-2"></div>
									<label for="ins_master_gbn" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										Master Proxy 서버(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="ins_master_gbn" id="ins_master_gbn">
											<option value="m">proxy_server_1</option>
											<option value="b">proxy_server_10</option>
										</select>
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:0px;">
									<label for="com_db_svr_nm" class="col-sm-2 col-form-label-sm">
										<i class="item-icon fa fa-dot-circle-o"></i>
										연결 DBMS
									</label>
									<div class="col-sm-3" id="div_day_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="ins_day_data_del_term" id="ins_day_data_del_term">
											<option value="2">vip_primary</option>
											<option value="db_svr_id">test_dbms</option>
										</select>
									</div>
									<div class="col-sm-auto"></div>
								</div>
								<div class="form-group row">
									<div class="col-sm-12">
										<table id="mgmtDbms" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="50"></th>
													<th width="150"><%-- <spring:message code="common.division" /> --%>DBMS명</th>
													<th width="150"><spring:message code="common.division" /></th>
													<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="100"><spring:message code="data_transfer.port" /></th>
													<th width="80"><spring:message code="dbms_information.conn_YN"/></th>	
													<th width="0">DBMS_ID</th>									
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
							<br/>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="ins_ipadr" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.id" /> --%>
										IP주소(*)
									</label>

									<div class="col-sm-3_0">
										<input type="text" class="form-control form-control-xsm ins_ipadr" autocomplete="off" maxlength="15" id="ins_ipadr" name="ins_ipadr" onkeyup="fn_checkWord(this,15)" onblur="this.value=this.value.trim()" onChange="fn_ins_id_chg(this);" placeholder="15<spring:message code='message.msg188'/>" tabindex=1 />
									</div>
									<div class="col-sm-auto">
									</div>
									<label for="ins_proxy_svr_nm" class="col-sm-2_3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.user_name" /> --%>
										서버명(*)
									</label>
									<div class="col-sm-3_0">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_proxy_svr_nm" name="ins_proxy_svr_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
									</div>
								</div>
								<div class="form-group row" >
									<label for="ins_root_pwd" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Root <spring:message code="user_management.password" />(*)
									</label>

									<div class="col-sm-3_0">
										<input type="password" style="display:none" aria-hidden="true">
										<input type="password" class="form-control form-control-xsm ins_root_pwd" autocomplete="new-password" maxlength="20" id="ins_root_pwd" name="ins_root_pwd" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=3 />
									</div>
									<div class="col-sm-auto">
									</div>
									<label for="ins_root_pwdChk" class="col-sm-2_3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Root <spring:message code="user_management.confirm_password" />(*)
									</label>
									<div class="col-sm-3_0">
										<input type="password" class="form-control form-control-xsm ins_root_pwdChk" maxlength="20" id="ins_root_pwdChk" name="ins_root_pwdChk" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_day_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										일별 데이터 보관 기간(*)
									</label>
									<div class="col-sm-3" id="div_day_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="ins_day_data_del_term" id="ins_day_data_del_term">
											<option value="30">30일</option>
											<option value="40">40일</option>
											<option value="50">50일</option>
											<option value="60">60일</option>
											<option value="70">70일</option>
											<option value="80">80일</option>
											<option value="90">90일</option>
										</select>
										<!-- <input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_day_data_del_trem" name="ins_day_data_del_trem" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="최소 30, 최대 90 사이의 숫자를 입력해주십시오." tabindex=7 /> 일 -->
									</div>
									
									<label for="ins_min_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.Responsibilities" /> --%>
										분별 데이터 보관 기간(*)
									</label>
									<div class="col-sm-3" id="div_min_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="ins_min_data_del_term" id="ins_min_data_del_term">
											<option value="1">1일</option>
											<option value="2">2일</option>
											<option value="3">3일</option>
											<option value="4">4일</option>
											<option value="5">5일</option>
											<option value="6">6일</option>
											<option value="7">7일</option>
										</select>
										<%-- <input type="text" class="form-control form-control-xsm" maxlength="25" id="ins_rsp_bsn_nm" name="ins_rsp_bsn_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=8 /> --%>
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="ins_use_yn" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="onoffswitch-pop" style="margin-top:0.250rem;">
											<input type="checkbox" name="ins_use_yn" class="onoffswitch-pop-checkbox" id="ins_use_yn" />
											<label class="onoffswitch-pop-label" for="ins_use_yn">
												<span class="onoffswitch-pop-inner"></span>
												<span class="onoffswitch-pop-switch"></span>
											</label>
										</div>	
									</div>
									<div class="col-sm-auto"></div>
								</div>
							</div> 
							<br/>
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="ins_save_submit" value='<spring:message code="common.save" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="ins_conn_test" value='연결테스트' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>