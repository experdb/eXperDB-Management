<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
						<h4>에이전트 모니터링<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li>관리 대상 데이터베이스 서버에 설치된 통합 관리 시스템의 Agent 상태를 모니터링합니다.</li>
								<li>Agent가 설치된 서버와 구동 상태, 구동 일시 등의 정보를 표시됩니다.</li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li>모니터링</li>
								<li class="on">에이전트 모니터링</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button>조회</button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t2">DBMS명</th>
											<td><input type="text" id="DB_SVR_NM" name="DB_SVR_NM" class="txt t2" value="${db_svr_nm}" /></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="overflow_area">
								<table class="list">
									<caption>Agent 모니터링 리스트</caption>
									<colgroup>
										<col style="width:10%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
										<col style="width:15%;" />
										<col style="width:10%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">NO</th>
											<th scope="col">DBMS명</th>
											<th scope="col">구동일시</th>
											<th scope="col">등록여부</th>
											<th scope="col">Agent Version</th>
											<th scope="col">Agent 상태</th>
										</tr>
									</thead>
									<tbody>

									<c:if test="${fn:length(list) == 0}">
										<tr>
											<td colspan="5">Not Found Data !!</td>

										</tr>
									</c:if>
									<c:forEach var="data" items="${list}" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td>${data.DB_SVR_NM}</td>											
											<td>${data.STRT_DTM}</td>
											<td>
											<c:if test="${data.SET_YN == 'Y'}">
											예
											</c:if>
											<c:if test="${data.SET_YN == 'N' || data.ISTCNF_YN == null}">
											<font color="red">아니오</font>
											</c:if>
											</td>
											<td>
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