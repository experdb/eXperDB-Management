<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>스케줄수행이력 상세보기</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>
var workTable = null;

function fn_init() {

    workTable = $('#workTable').DataTable({
		scrollY : "190px",
		searching : false,
		paging: false,
		scrollX: true,
		columns : [
		{ data : "rownum", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
			}
		},
		{ data : "wrk_exp", className : "dt-left", defaultContent : ""}, 
		{ data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},  
		{ data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
		{ data : "wrk_dtm", className : "dt-center", defaultContent : ""},
		{data : "exe_rslt_cd", className : "dt-center", defaultContent : ""
			,"render": function (data, type, full) {
				if(full.exe_rslt_cd=="TC001701"){
					var html = '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</span>';
						return html;
				}else{
					var html = '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
					return html;
				}
			}
		},
		{data : "scd_id", className : "dt-center", defaultContent : "", visible: false }
		]
	});
    
    workTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
    workTable.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
    workTable.tables().header().to$().find('th:eq(2)').css('min-width', '75px');
    workTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
    workTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	workTable.tables().header().to$().find('th:eq(5)').css('min-width', '50px');
	workTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
    $(window).trigger('resize');
    
}

$(window.document).ready(function() {
	fn_init();
	
	$.ajax({
		url : "/selectScheduleHistoryWorkDetail.do",
		data : {
			exe_sn : "${exe_sn}"
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			workTable.clear().draw();
			workTable.rows.add(result).draw();
		}
	});
});
</script>
<body>
<style>
#scdinfo{
	width: 30% !important;
}

#workinfo{
	width: 60% !important;
	height: 610px !important;
}

</style>
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>
	
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="schedule.scheduleHistoryDetail"/></p>
			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="menu.schedule_information" /></p>
					<table class="list" style="border:1px solid #b8c3c6;">
						<thead>
							<tr>
								<th scope="col"><spring:message code="schedule.schedule_name" /></th>
								<th scope="col"><spring:message code="schedule.scheduleExp"/></th>
								<th scope="col"><spring:message code="schedule.work_start_datetime" /></th>
								<th scope="col"><spring:message code="schedule.work_end_datetime" /></th>
								<th scope="col"><spring:message code="schedule.jobTime"/></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="result" items="${result}" varStatus="status">
								<tr>
									<td><span onClick='javascript:fn_scdLayer("${result.scd_id}");' class="bold">${result.scd_nm}</span></td>
									<td>${result.scd_exp}</td>
									<td>${result.wrk_strt_dtm}</td>
									<td>${result.wrk_end_dtm}</td>
									<td>${result.wrk_dtm}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				<br><br>
				<p class="pop_s_tit"><spring:message code="backup_management.work_info"/></p>
				<div class="overflow_area" style="height: 300px;">
					<table id="workTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40">No</th>
								<th width="50"><spring:message code="common.work_name" /></th>
								<th width="75"><spring:message code="common.work_description" /></th>
								<th width="100"><spring:message code="schedule.work_start_datetime" /></th>
								<th width="100"><spring:message code="schedule.work_end_datetime" /></th>
								<th width="100"><spring:message code="schedule.jobTime"/></th>
								<th width="50"><spring:message code="schedule.result" /></th>
								<th width="0"></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close"/></span></a>
			</div>
		</div>
	</div>
<div id="loading"><img src="/images/spin.gif" alt="" /></div>
</body>
</html>