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
	* @Class Name : encryptAgentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 변승우 대리
	* since 2018.04.23
	*
	*/
%>

	<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>Encrypt <spring:message code="menu.agent_monitoring" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
				
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.agent_monitoring" /></li>
								<li class="on">암화화 에이전트</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button>새로고침</button></span>
							</div>

							<div class="overflow_area" style="height: 365px;">
								<table class="list" border="1">
									<caption>Encrypt Agent 모니터링 리스트</caption>
									<colgroup>
										<col style="width:10%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><spring:message code="common.no" /></th>
											<th scope="col">Agent IP</th>
											<th scope="col">Agent 상태 </th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->