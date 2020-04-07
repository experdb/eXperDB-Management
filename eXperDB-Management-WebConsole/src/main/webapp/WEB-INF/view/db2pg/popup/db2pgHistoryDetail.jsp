<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : db2pgHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.11.06     최초 생성
	*
	* author 김주영 사원
	* since 2019.11.06
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DB2PG수행이력 상세보기</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>" />
<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/common.js"></script>
</head>
<body>
<%@include file="../../cmmn/commonLocale.jsp"%>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">실패 수행이력 상세보기</p>
			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="migration.job_information"/></p>
				<table class="list" style="border: 1px solid #99abb0;">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 85%;" />
					</colgroup>
					<tbody>
							<tr>
								<td><spring:message code="common.work_name" /></td>
								<td style="text-align: left">${result.wrk_nm}</td>
							</tr>
							<tr>
								<td><spring:message code="common.work_description" /></td>
								<td style="text-align: left">${result.wrk_exp}</td>
							</tr>
							<tr>
								<td><spring:message code="schedule.work_start_datetime" /></td>
								<td style="text-align: left">${result.wrk_strt_dtm}</td>
							</tr>
							<tr>
								<td><spring:message code="schedule.work_end_datetime" /></td>
								<td style="text-align: left">${result.wrk_end_dtm}</td>
							</tr>
							<tr>
								<td><spring:message code="schedule.jobTime" /></td>
								<td style="text-align: left">${result.wrk_dtm}</td>
							</tr>
							<tr>
								<td><spring:message code="schedule.result" /></td>
								<td style="text-align: left">
									<c:if test="${result.exe_rslt_cd eq 'TC001701'}"><img src='../../images/ico_state_02.png' style='margin-right:3px;'>Success</c:if>
									<c:if test="${result.exe_rslt_cd eq 'TC001702'}"><img src='../../images/ico_state_01.png' style='margin-right:3px;'>Fail</c:if>
								</td>
							</tr>
					</tbody>
				</table>
				<br><br>
				<p class="pop_s_tit"><spring:message code="backup_management.job_log_info"/></p>
				<table class="write" border="0">
					<caption>
						<spring:message code="backup_management.job_log_info" />
					</caption>
					<tbody>
						<tr>
							<td><textarea name="wrkLogInfo" id="wrkLogInfo" style="height: 180px;" readonly="readonly">${result.rslt_msg}</textarea></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close" /></span></a>
			</div>
		</div>
	</div>
</body>
</html>