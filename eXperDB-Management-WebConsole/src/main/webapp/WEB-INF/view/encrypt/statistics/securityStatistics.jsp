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
	* @Class Name : securityStatistics.jsp
	* @Description : securityStatistics 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.04.23     최초 생성
	*  2020.08.06   변승우 과장		UI 디자인 변경
	
	* author 변승우 대리
	* since 2018.01.09
	*
	*/
%>


<script type="text/javascript">
/* google.charts.load('current', {packages: ['corechart', 'bar']});
google.charts.setOnLoadCallback(drawMultSeries); */

$(window.document).ready(function() {
	
	fn_DateCalenderSetting();
	fn_selectSecurityStatistics();

});

	function fn_selectSecurityStatistics(){
		var from = $('#from').val().replace(/-/gi, "")+"00";
		var to = $('#from').val().replace(/-/gi, "")+"24";
	
		$.ajax({
			url : "/selectSecurityStatistics.do",
			data : {
				from : from,
				to : 	to,
				categoryColumn : $('#categoryColumn').val(),
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
				 	var html ="";
					for(var i=0; i<data.list.length; i++){
	
						html += '<tr"> ';
						html += '<td>'+data.list[i].categoryColumn+'</td>';
						html += '<td>'+data.list[i].encryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].encryptFailCount+'</td>';
						html += '<td>'+data.list[i].decryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].decryptFailCount+'</td>';
						html += '<td>'+data.list[i].sumCount+'</td>';
						html += '</tr>';
						$( "#col" ).html(html);			
					} 
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');	
				}	
			}
		});		
	}
	
	
	function fn_select(){
		fn_selectSecurityStatistics();
	}
	


	    
	    /* ********************************************************
		 * 작업기간 calender 셋팅
		 ******************************************************** */
		function fn_DateCalenderSetting() {
	    	var today = new Date();
			var startDay = fn_dateParse("20180101");
			var endDay = fn_dateParse("20991231");
			
			var day_today = today.toJSON().slice(0,10);
			var day_start = startDay.toJSON().slice(0,10);
			var day_end = endDay.toJSON().slice(0,10);

			if ($("#wrk_strt_dtm_div").length) {
				$("#wrk_strt_dtm_div").datepicker({
				}).datepicker('setDate', day_today)
				.datepicker('setStartDate', day_start)
				.datepicker('setEndDate', day_end)
				.on('hide', function(e) {
					e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
				}); //값 셋팅
			}

			$("#from").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
			$("#wrk_strt_dtm_div").datepicker('updateDates');
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
												<span class="menu-title"><spring:message code="encrypt_Statistics.Encrypt_Statistics"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_Statistics.Statistics"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_Statistics.Encrypt_Statistics"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encrypt_Statistics"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
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
								<div class="input-group mb-2 mr-sm-2 col-sm-2 row" >
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-12">
										<input type="text" class="form-control totDatepicker" style="height:44px;" id="from" name="from" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-left: -1rem;"name="categoryColumn" id="categoryColumn">
										<option value="SITE_ACCESS_ADDRESS"><spring:message code="encrypt_log_decode.Client_Address"/></option>
										<option value="PROFILE_NM"><spring:message code="encrypt_policy_management.Policy_Name"/></option>										
										<option value="HOST_NM"><spring:message code="encrypt_policy_management.Host_Name"/></option>
										<option value="EXTRA_NM"><spring:message code="encrypt_policy_management.Additional_Fields"/></option>
										<option value="MODULE_INFO"><spring:message code="encrypt_log_decode.Module_Information"/></option>
										<option value="LOCATION_INFO"><spring:message code="encrypt_log_decode.Column_Name"/></option>
										<option value="SERVER_LOGIN_ID">DB <spring:message code="history_management.user" /> <spring:message code="user_management.id" /></option>
									</select>	
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
							<div class="row" style="height:500px;">
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

	 								<table class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th scope="col" rowspan="2" >Encrypt Agent IP</th>						
												<th scope="col" colspan="2" style="border-bottom: 1px solid #b8c3c6"><spring:message code="encrypt_log_decode.Encryption"/></th>
												<th scope="col" colspan="2" style="border-bottom: 1px solid #b8c3c6"><spring:message code="encrypt_log_decode.Decryption"/></th>
												<th scope="col" rowspan="2"><spring:message code="encrypt_Statistics.Sum"/>  </th>						
											</tr>
											<tr class="bg-info text-white">
												<th scope="col"><spring:message code="common.success" /> </th>
												<th scope="col"><spring:message code="common.failed" /></th>
												<th scope="col"><spring:message code="common.success" /> </th>
												<th scope="col"><spring:message code="common.failed" /></th>
											</tr>
										</thead>
										<tbody id="col"  class="table table-hover table-striped system-tlb-scroll" >
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