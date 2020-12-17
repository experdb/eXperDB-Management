<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : encodeDecodeAuditLog.jsp
	* @Description : encodeDecodeAuditLog 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.07.22    변승우 과장		UI 변경
	*
	* author 김주영 사원
	* since 2018.01.09
	*
	*/
%>
<script>
	var table = null;

	function fn_init() {
		table = $('#encodeDecodeTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", className : "dt-center",  defaultContent : ""},  
				{ data : "agentLogDateTime", defaultContent : ""}, 
				{ data : "agentRemoteAddress", defaultContent : ""},
				{ data : "profileName", defaultContent : ""},
				{ data : "instanceId", defaultContent : ""},
				{ data : "siteAccessAddress", defaultContent : ""},
				{ data : "macAddr", defaultContent : ""},
				{ data : "osLoginId", defaultContent : ""},
				{ data : "serverLoginId", defaultContent : ""},
				{ data : "adminLoginId", defaultContent : ""},
				{ data : "applicationName", defaultContent : ""},
				{ data : "extraName", defaultContent : ""},
				{ data : "hostName", defaultContent : ""},
				{ data : "locationInfo", defaultContent : ""},
				{ data : "moduleInfo", defaultContent : ""},
// 				{ data : "weekday", className : "dt-center", defaultContent : ""}, 
				{
					data : "weekday",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == "0") {
							html += '<spring:message code="common.sun" />';
						} 
						if (data == "1") {
							html += '<spring:message code="common.mon" />';
						} 
						if (data == "2") {
							html += '<spring:message code="common.tue" />';
						} 
						if (data == "3") {
							html += '<spring:message code="common.wed" />';
						} 
						if (data == "4") {
							html += '<spring:message code="common.thu" />';
						} 
						if (data == "5") {
							html += '<spring:message code="common.fri" />';
						} 
						if (data == "6") {
							html += '<spring:message code="common.sat" />';
						} 
						return html;
					},
					defaultContent : ""
				},
				{
					data : "encryptTrueFalse",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == true) {
							html += '<spring:message code="encrypt_log_decode.Encryption"/>';
						} else {
							html += '<spring:message code="encrypt_log_decode.Decryption"/>';
						}
						return html;
					},
					defaultContent : ""
				},
				{
					data : "successTrueFalse",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == true) {
							html += '<class="btn btn-inverse-primary btn-fw">';
							html += "	<i class='fa fa-check-circle text-primary' >";
							html += '&nbsp;Complete</i>';
							/* html += '<spring:message code="common.success" />'; */
						} else {
							html += '<class="btn btn-inverse-danger btn-fw" onclick="fn_migFailLog('+full.mig_exe_sn+')">';
							html += '<i class="fa fa-times">&nbsp;Fail</i>';					
							/* html += '<spring:message code="common.failed" />'; */
						}
						return html;
					},
					defaultContent : ""
				},
				{ data : "count", className : "dt-right", defaultContent : ""},
				{ data : "siteIntegrityResult", defaultContent : ""},
				{ data : "serverIntegrityResult", defaultContent : ""},
				{ data : "createDateTime", defaultContent : ""},
				{ data : "updateDateTime", defaultContent : ""}
	
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(19)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(20)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(21)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(22)').css('min-width', '150px');
	
	    $(window).trigger('resize');
	    
	}
	
	$(window.document).ready(function() {
		
		//작업기간 calender setting
		dateCalenderSetting();
		fn_init();
		fn_select();	
	});
	

	/* 조회 버튼 클릭시*/
	function fn_select() {
		
		$.ajax({
			url : "/selectEncodeDecodeAuditLog.do",
			data : {
				from : $('#lgi_dtm_start').val(),
				to : 	$('#lgi_dtm_end').val(),
				resultcode : $('#resultcode').val(),
				agentUid : $('#agentUid').val(),
				successTrueFalse : $('#successTrueFalse').val(),
				searchFieldName : $('#searchFieldName').val(),
				searchOperator : $('#searchOperator').val(),
				searchFieldValueString : $('#searchFieldValueString').val()
			},
			dataType : "json",
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
					table.clear().draw();
					if(data.list!=null){
						table.rows.add(data.list).draw();
					}
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');	
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error','securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}
	
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate());
		var day_start = today.toJSON().slice(0,10); 

		$("#wrk_strt_dtm").val(day_start);
		$("#wrk_end_dtm").val(day_end);

		if ($("#wrk_strt_dtm_div").length) {
			$('#wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#wrk_end_dtm").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	}
	
</script>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_log.Audit_Log"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_Decryption"/></p>
											<p class="mb-0">해당 결과는 string또는 잘못된 값의 대한 오류가 아닌 접근권한에 대한 Complete/Fail 입니다.</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px 0px;">
							<form class="form-inline row" onsubmit="return false;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_start" name="lgi_dtm_start" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
									
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>

									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_end" name="lgi_dtm_end" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>	
	
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" name="agentUid" id="agentUid">
										<option value=""><spring:message code="encrypt_log_decode.Agent"/>&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${result}" varStatus="status">
											<option value="<c:out value="${result.entityUid}"/>" ><c:out value="${result.entityName}"/></option>
										</c:forEach>
									</select>
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="successTrueFalse" id="successTrueFalse">
										<option value=""><spring:message code="encrypt_log_decode.Success_Failure"/>&nbsp;<spring:message code="schedule.total" /></option>
										<option value="true"><spring:message code="common.success" /></option>
										<option value="false"><spring:message code="common.failed" /></option>
									</select>
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="searchFieldName" id="searchFieldName">
										<option value=""><spring:message code="encrypt_log_decode.Additional_Search_Condition"/>&nbsp;<spring:message code="schedule.total" /></option>
										<option value="PROFILE_NM"><spring:message code="encrypt_policy_management.Policy_Name"/></option>
										<option value="SITE_ACCESS_ADDRESS"><spring:message code="encrypt_log_decode.Client_Address"/></option>
										<option value="HOST_NM"><spring:message code="encrypt_policy_management.Host_Name"/></option>
										<option value="EXTRA_NM"><spring:message code="encrypt_policy_management.Additional_Fields"/></option>
										<option value="MODULE_INFO"><spring:message code="encrypt_log_decode.Module_Information"/></option>
										<option value="LOCATION_INFO"><spring:message code="encrypt_log_decode.Column_Name"/></option>
										<option value="SERVER_LOGIN_ID"><spring:message code="encrypt_policy_management.Database_User"/></option>
										<option value="ADMIN_LOGIN_ID"><spring:message code="encrypt_policy_management.eXperDB_User"/></option>
										<option value="OS_LOGIN_ID"><spring:message code="user_management.user_id" /></option>
										<option value="APPLICATION_NM"><spring:message code="encrypt_policy_management.Application_Name"/></option>
										<option value="INSTANCE_ID"><spring:message code="encrypt_policy_management.Server_Instance"/></option>
									</select>
								</div>
								
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="searchOperator" id="searchOperator">
										<option value="LIKE">Like</option>
										<option value="=">=</option>
										<option value="<">&lt;</option>
										<option value=">">&gt;</option>
									</select>
								</div>
							</form>

							<form class="form-inline row" onsubmit="return false;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input type="text" class="form-control" style="margin-left: -0.9rem;" id="searchFieldValueString" name="searchFieldValueString" onblur="this.value=this.value.trim()" maxlength="25" />
								</div>
					
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSelect" onClick="fn_select();">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>	
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>
	 								<table id="encodeDecodeTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="encrypt_log_decode.Agent_Log_Date"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Agent_Address"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Securiy_Policy"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.Server_Instance"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Client_Address"/> </th>
												<th width="100"><spring:message code="encrypt_log_decode.MAC_Address"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.OS_User"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.Database_User"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.eXperDB_User"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.Application_Name"/></th>
												<th width="100">Extra Name</th>
												<th width="100"><spring:message code="encrypt_policy_management.Host_Name"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Column_Name"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Module_Information"/></th>
												<th width="100"><spring:message code="encrypt_policy_management.Day_of_Week"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Action"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Result"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Count"/></th>
												<th width="100"><spring:message code="encrypt_log_decode.Site_Integrity"/></th>
												<th width="120"><spring:message code="encrypt_log_decode.ServerIntegrity"/></th>
												<th width="150"><spring:message code="encrypt_log_decode.Log_Create_Time"/></th>
												<th width="150"><spring:message code="encrypt_log_sever.Log_Update_Time"/></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>				
	</div>
</div>	




