<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : scheduleHistoryDetail.jsp
	* @Description : scheduleHistoryDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.10.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.10.24
	*
	*/
%>
<script>
var workTable_history = null;

function fn_init_scdH() {
	workTable_history = $('#workTable_history').DataTable({
		scrollY : "130px",
		searching : false,
		paging: false,
		scrollX: true,
		bSort: false,
		columns : [
		{ data : "rownum", className : "dt-center",  defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  /* return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>'; */
				  return '<span title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
			}
		},
		{ data : "wrk_exp",
			render : function(data, type, full, meta) {	 	
				var html = '';					
				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
				return html;
			},
			defaultContent : ""
		},
		{ data : "wrk_strt_dtm",  defaultContent : ""},  
		{ data : "wrk_end_dtm",  defaultContent : ""},
		{ data : "wrk_dtm",  defaultContent : ""},
		{data : "exe_rslt_cd",  defaultContent : "",className : "dt-center"
			,"render": function (data, type, full) {
				if(full.exe_rslt_cd=="TC001701"){
						var html = "";
						html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
						html += "	<i class='fa fa-check-circle text-primary' >";
						html += '&nbsp;<spring:message code="common.success" /></i>';
						html += "</div>";
						return html;
				}else if(full.exe_rslt_cd == 'TC001702'){
					var html = '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_failLog('+full.exe_sn+')">';
					html += '<i class="fa fa-times"></i>';
					html += '<spring:message code="common.failed" />';
					html += "</button>";
					return html;
				}else{
					var html = '';
					html += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
					html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
					html += '&nbsp;<spring:message code="etc.etc28" />';
					html += "</div>";
					return html;
				}
			}
		},
			{
				data : "fix_rsltcd",
				render : function(data, type, full, meta) {	 						
					var html = '';
					if (full.fix_rsltcd == 'TC002001') {
						html += '<button type="button" class="btn btn-inverse-success btn-fw" onclick="javascript:fn_fixLog('+full.exe_sn+', \'scdList\');">';
						html += '<i class="fa fa-times"></i>';
						html += '<spring:message code="etc.etc29"/>';
						html += "</button>";
					} else if(full.fix_rsltcd == 'TC002002'){
							html += '<button type="button" class="btn btn-inverse-success btn-fw" onclick="javascript:fn_fixLog('+full.exe_sn+', \'scdList\');">';
							html += '<i class="fa fa-times"></i>';
							html += '<spring:message code="etc.etc30"/>';
							html += "</button>";
					} else {
						if(full.exe_rslt_cd == 'TC001701'){
							html += ' - ';
						}else{
							html += '<button type="button" class="btn btn-inverse-warning btn-fw" onclick="javascript:fn_fix_rslt_reg('+full.exe_sn+', \'scdList\');">';
	 						html += '<i class="fa fa-times"></i>';
	 						html += '<spring:message code="backup_management.Enter_Action"/>';
	 						html += "</button>";
						}
					}
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			},
		{data : "scd_id",  defaultContent : "", visible: false }
		]
	});
    
    workTable_history.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
    workTable_history.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
    workTable_history.tables().header().to$().find('th:eq(2)').css('min-width', '300px');
    workTable_history.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
    workTable_history.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
	workTable_history.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	workTable_history.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	workTable_history.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	workTable_history.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
    $(window).trigger('resize');
    
}





</script>
<body>
<%@include file="../cmmn/commonLocale.jsp"%>  
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/workScriptInfo.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>

<%@include file="../cmmn/fixRsltMsgInfo.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>

<div class="modal fade" id="pop_layer_scd_history" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 180px;">
		<div class="modal-content" style="width:1300px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="schedule.scheduleHistoryDetail"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><spring:message code="menu.schedule_information"/></p>
						<div class="form-inline" id="scd_history_info">
						</div>
						<br><br>
						<p class="card-description"><spring:message code="backup_management.work_info"/></p>
						<table id="workTable_history" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
							<thead>
								<tr class="bg-info text-white">
									<th width="40"><spring:message code="common.no" /></th>
									<th width="200" class="dt-center"><spring:message code="common.work_name"/></th>
									<th width="300" class="dt-center"><spring:message code="common.work_description"/></th>
									<th width="150"><spring:message code="schedule.work_start_datetime"/></th>
									<th width="150"><spring:message code="schedule.work_end_datetime"/></th>
									<th width="100"><spring:message code="schedule.jobTime"/></th>
									<th width="100"><spring:message code="schedule.result"/></th>
									<th width="0"><spring:message code="etc.etc31"/></th>
								</tr>
							</thead>
						</table>
					</div>
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div> 
	