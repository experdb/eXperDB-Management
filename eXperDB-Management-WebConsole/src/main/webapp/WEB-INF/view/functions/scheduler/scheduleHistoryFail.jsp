<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../cmmn/cs2.jsp"%>

    <script>
    var table = null;
    
    function fn_init(){
    	/* ********************************************************
    	 * work리스트
    	 ******************************************************** */
    	table = $('#scheduleFailList').DataTable({
    	scrollY : "360px",
    	scrollX : true,
    	bDestroy: true,
    	processing : true,
    	searching : false,	
    	bSort: false,
    	columns : [
    		{data : "rownum",  className : "dt-center", defaultContent : ""}, 
    		{
				data : "exe_result",
				render : function(data, type, full, meta) {
					var html = '';
					html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_failLog('+full.exe_sn+')">';
					html += '<i class="fa fa-times"></i>';
					html += '<spring:message code="common.failed" />';
					html += "</button>";
					return html;
				},
				
				defaultContent : ""
			},
			{
					data : "fix_rsltcd",
					render : function(data, type, full, meta) {	 	
						var html = '';
 						if(full.fix_rsltcd == 'TC002002'){
 							html += '<button type="button" class="btn btn-inverse-success btn-fw" onclick="javascript:fn_fixLog('+full.exe_sn+', \'scdListFail\');">';
 							html += '<i class="fa fa-times"></i>';
 							html += '<spring:message code="etc.etc30"/>';
 							html += "</button>";
 						} else {
 							if(full.exe_rslt_cd == 'TC001701'){
 								html += ' - ';
 							}else{
 								html += '<button type="button" class="btn btn-inverse-warning btn-fw" onclick="javascript:fn_fix_rslt_reg('+full.exe_sn+', \'scdListFail\');">';
 	 							html += '<i class="fa fa-times"></i>';
 	 							html += '<spring:message code="backup_management.Enter_Action"/>';
 	 							html += "</button>";	
 							}	 
 						}
 						return html;
					},
					
					defaultContent : ""
				},
    		{data : "scd_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold" title="'+full.scd_nm+'">' + full.scd_nm + '</span>';
    			}
    		}, 
    		{data : "db_svr_nm",  defaultContent : ""},
    		{data : "wrk_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
    			}
    		}, 
    		{data : "wrk_strt_dtm",  defaultContent : ""}, 
    		{data : "wrk_end_dtm",  defaultContent : ""}
    		//{data : "exe_result",  defaultContent : ""},	   		
    	]
    	});
    	
    	
    	table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
    	table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
    	table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    	table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
        table.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
        table.tables().header().to$().find('th:eq(7)').css('min-width', '150px');
       
        $(window).trigger('resize');
    }

    
    /* ********************************************************
     * 페이지 시작시 함수
     ******************************************************** */
    $(window.document).ready(function() {
    	fn_init();
  
   	  	$.ajax({
   			url : "/selectScheduleFailList.do",
   			data : {},
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
   			success : function(result) {
   				table.rows({selected: true}).deselect();
   				table.clear().draw();
   				table.rows.add(result).draw();
   			}
   		}); 
  	});



    
   function fn_scheduleFail_list(){
	   $.ajax({
  			url : "/selectScheduleFailList.do",
  			data : {
  				scd_nm : $('#scd_nm').val(),
  				wrk_nm : $('#wrk_nm').val(),
  				fix_rsltcd : $("#fix_rsltcd").val()
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
  			success : function(result) {
  				table.rows({selected: true}).deselect();
  				table.clear().draw();
  				table.rows.add(result).draw();
  			}
  		}); 
   }
    
    
    </script>
<%@include file="../../cmmn/workRmanInfo.jsp"%>
<%@include file="../../cmmn/workDumpInfo.jsp"%>
<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/workScriptInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>
<%@include file="../../cmmn/fixRsltMsgInfo.jsp"%>
<%@include file="../../cmmn/fixRsltMsg.jsp"%>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-check-square"></i>
												<span class="menu-title"><spring:message code="schedule.scheduleFailHistory"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">SCHEDULE</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.schedule_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="schedule.scheduleFailHistory"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="message.msg171"/></p>
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
						<div class="card-body" style="margin:-10px -10px -15px -10px;">

							<form class="form-inline row">
							
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control"  style="margin-right: -0.7rem;" maxlength="25" id="scd_nm" name="scd_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="schedule.schedule_name" />'/>		
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control"  style="margin-right: -0.7rem;" maxlength="25" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />'/>		
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" name="fix_rsltcd" id="fix_rsltcd">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC002003"><spring:message code="etc.etc34"/></option>
										<option value="TC002002"><spring:message code="etc.etc30"/></option>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_scheduleFail_list();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>

							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
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

	 								<table id="scheduleFailList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="30"><spring:message code="common.no"/></th>							
												<th width="100"><spring:message code="schedule.result"/></th>
												<th width="100"><spring:message code="etc.etc31"/></th>
												<th width="200" class="dt-center"><spring:message code="schedule.schedule_name"/></th>
												<th width="100"><spring:message code="common.dbms_name"/></th>
												<th width="200"class="dt-center"><spring:message code="common.work_name"/></th>
												<th width="150"><spring:message code="schedule.work_start_datetime"/></th>
												<th width="150"><spring:message code="schedule.work_end_datetime"/></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>
