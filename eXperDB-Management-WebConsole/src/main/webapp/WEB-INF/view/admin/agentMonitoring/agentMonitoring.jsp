<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : agentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.30
	*
	*/
%>
<script>
	function fn_search() {
		var form = document.agentForm;
		
		form.action = "/agentMonitoring.do";
		form.submit();
		return;
	}
</script>
<form name="agentForm" id="agentForm" method="post">
	<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>Management <spring:message code="menu.agent_monitoring" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.agent_monitoring_01" /> </li>
								<li><spring:message code="help.agent_monitoring_02" /> </li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.agent_monitoring" /></li>
								<li class="on">관리 에이전트</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button><spring:message code="common.search" /></button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width: 120px;" />
										<col style="width: 200px;" />
										<col style="width: 120px;" />
										<col style="width: 200px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t9"><spring:message code="common.dbms_name" /></th>
											<td><input type="text" id="DB_SVR_NM" name="DB_SVR_NM" class="txt t2" value="${db_svr_nm}" maxlength="20"/></td>
											<th scope="row" class="t9"><spring:message code="dbms_information.dbms_ip" /> </th>
											<td><input type="text" id="IPADR" name="IPADR" class="txt t2" value="${ipadr}" maxlength="20"/></td>
										</tr>
										
									</tbody>
								</table>
							</div>
							<div class="overflow_area" style="height: 365px;">
								<table class="list">
									<caption>Agent 모니터링 리스트</caption>
									<colgroup>
										<col style="width:10%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
										<col style="width:15%;" />
										<col style="width:15%;" />
										<col style="width:15%;" />
										<col style="width:10%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><spring:message code="common.no" /></th>
											<th scope="col"><spring:message code="common.dbms_name" /></th>
											<th scope="col"><spring:message code="dbms_information.dbms_ip" /> </th>
											<th scope="col"><spring:message code="properties.server_type" /> </th>
											<th scope="col"><spring:message code="agent_monitoring.run_date" /> </th>
											<th scope="col"><spring:message code="agent_monitoring.regist_yn" /></th>
											<th scope="col"><spring:message code="agent_monitoring.agent_version" /></th>
											<th scope="col"><spring:message code="agent_monitoring.agent_status" /></th>
										</tr>
									</thead>
									<tbody>

									<c:if test="${fn:length(list) == 0}">
										<tr>
											<td colspan="8"><spring:message code="message.msg01" /></td>

										</tr>
									</c:if>
									<c:forEach var="data" items="${list}" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td style="text-align: left;">${data.DB_SVR_NM}</td>
											<td style="text-align: left;">${data.IPADR}</td>		
											<td style="text-align: left;">
												<c:if test="${data.MASTER_GBN == 'M'}">master</c:if>
												<c:if test="${data.MASTER_GBN == 'S'}">slave</c:if>
											</td>											
											<td style="text-align: left;">${data.STRT_DTM}</td>
											<td style="text-align: left;">
											<c:if test="${data.SET_YN == 'Y'}">
											<spring:message code="agent_monitoring.yes" />
											</c:if>
											<c:if test="${data.SET_YN == 'N' || data.ISTCNF_YN == null}">
											<font color="red"><spring:message code="agent_monitoring.no" /></font>
											</c:if>
											</td>
											<td style="text-align: right;">
												${data.AGT_VERSION}
											</td>
											<td>
											<c:if test="${data.AGT_CNDT_CD == 'TC001101'}">
												<img src="../images/ico_agent_1.png" alt="" />
											</c:if>
											<c:if test="${data.AGT_CNDT_CD == 'TC001102'}">
												<img src="../images/ico_agent_2.png" alt="" />
											</c:if>
											</td>
										</tr>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->
</form>