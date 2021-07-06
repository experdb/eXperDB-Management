<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="./cmmn/cs2.jsp"%> 
<%@include file="./cmmn/commonLocaleDashboard.jsp" %>  

<script src="/vertical-dark-sidebar/js/dashboard_common.js"></script>

<STYLE TYPE="text/css">

.blinking{ 
 -webkit-animation:blink 5.0s ease-in-out infinite alternate; 
 -moz-animation:blink 1.0s ease-in-out infinite alternate; 
 animation:blink 3.0s ease-in-out infinite alternate;
} 

.txt_line { width:70px; padding:0 5px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

@-webkit-keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
} 

@-moz-keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
} 

@keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
}
</STYLE>

<script type="text/javascript">
	var today = "";
	var scale_yn_chk = "";

	/* ********************************************************
	 * 서버리스트 설정
	 ******************************************************** */
	function fn_serverListSetting() {
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var db_svr_id = "";
		var listCnt = 0;
		var db_svr_id_val = "";
		
		var serverTotInfo_cnt = "${fn:length(serverTotInfo)}";
		
		if (serverTotInfo_cnt == 0) {
			html += "<div class='col-md-12 grid-margin stretch-card'>\n";
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
			html += '</div>\n';
		} else {
			<c:forEach items="${serverTotInfo}" var="serverinfo" varStatus="status">
				master_gbn = nvlPrmSet("${serverinfo.master_gbn}", '') ;
				rowCount = rowCount + 1;
				listCnt = parseInt("${fn:length(serverTotInfo)}");
				
				//setting value
				db_svr_id_val = nvlPrmSet("${serverinfo.db_svr_id}", '');
				
	 			if (db_svr_id == "") {
					html += "<div class='col-md-12 grid-margin stretch-card'>\n";
					html += "	<div class='card news_text'>\n";
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_serverSebuInfo(' + db_svr_id_val + ', '+ rowCount +')" style="cursor:pointer;">\n';
					html += '			<div class="row">\n';
				} else if (db_svr_id != nvlPrmSet("${serverinfo.db_svr_id}", '')  && master_gbn == "M") {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto; text-align:center;">\n';
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" id="iDatabase' + db_svr_id_val + '" style="font-size: 3.0em;"></i>\n';
					
					if("${proxy_menu_yn}" == "Y"){
						if("${proxy_yn}" == "Y" && "${serverinfo.pry_cnt}" != "0"){
							html += '					<div class="badge badge-primary badge-pill" style="margin-top:5px;"><i class="mdi mdi-server-network menu-icon"></i>&nbsp;Proxy</div>\n';
						}
					}
					
// 					html += ' <br/> <i class="mdi mdi-server-network menu-icon text-primary"></i>Proxy\n'
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
					html += "<div class='col-md-12 grid-margin stretch-card'>\n";
					html += "	<div class='card news_text'>\n";
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_serverSebuInfo('+ db_svr_id_val +', '+ rowCount +')" style="cursor:pointer;">\n';
					html += '			<div class="row">\n';
				}
	
	 			if (master_gbn == "M") {
	 				html += '			<div class="col-sm-9">';
	 				html += '				<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
	 				html += '					<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
	 				
						if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
						} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') {
	 	 				html += '					<div class="badge badge-pill badge-success" title="">M</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') {
	 	 				html += '					<div class="badge badge-pill badge-danger">M</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<c:out value="${serverinfo.db_svr_nm}"/><br/></h5>\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
	 				html += '					(<c:out value="${serverinfo.ipadr}"/>)</h6>\n';
	 			}
	 			
	 			if (master_gbn == "S") {
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;padding-top:10px;">\n';
	 				
						if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') {
	 	 				html += '					<div class="badge badge-pill badge-success">S</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') {
	 	 				html += '					<div class="badge badge-pill badge-danger">S</div>\n';
	
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<c:out value="${serverinfo.svr_host_nm}"/><br/></h6>';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:64px;">';
	 				html += '					(<c:out value="${serverinfo.ipadr}"/>)</h6>';
	 			}
	
				if (rowCount == listCnt) {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto; text-align:center;">\n';
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
					
					//proxy menu 추가
					if("${proxy_menu_yn}" == "Y"){
						if("${proxy_yn}" == "Y" && "${serverinfo.pry_cnt}" != "0"){
							html += '					<div class="badge badge-primary badge-pill" style="margin-top:5px;"><i class="mdi mdi-server-network menu-icon"></i>&nbsp;Proxy</div>\n';
						}					
					}

					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
				}
				db_svr_id = nvlPrmSet("${serverinfo.db_svr_id}", '') ;
	
			</c:forEach>
		}

		$("#serverSsCnt", "#dashboardViewForm").val(serverTotInfo_cnt);
		$("#serverTabList").html(html);
		
		if (serverTotInfo_cnt > 0) {
			$("#serverSs1").click();
		}
	}

	/* ********************************************************
	 * 통합 스케줄 셋팅
	 ******************************************************** */
	function fn_totScdSetting() {
		var tot_start = "";
		var tot_end = "";
		var tot_run = "";
		var scheduleCnt = "";

		if (nvlPrmSet("${backupInfo}", '') != "") {
			scheduleCnt = parseInt((nvlPrmSet("${backupInfo.schedule_cnt}", '0')));
			
			if (scheduleCnt != 0) {
				//시작
				if (nvlPrmSet("${scheduleInfo.start_cnt}", '') != "") {
					tot_start = parseInt(nvlPrmSet("${scheduleInfo.start_cnt}", '0')) / scheduleCnt * 100;
					tot_start = tot_start.toFixed(2);
				} else {
					tot_start = "0.00";
				}
				
				if (nvlPrmSet("${scheduleInfo.stop_cnt}", '') != "") {
					tot_end = parseInt(nvlPrmSet("${scheduleInfo.stop_cnt}", '0')) / scheduleCnt * 100;
					tot_end = tot_end.toFixed(2);
				} else {
					tot_end = "0.00";
				}
				
				if (nvlPrmSet("${scheduleInfo.run_cnt}", '') != "") {
					tot_run = parseInt(nvlPrmSet("${scheduleInfo.run_cnt}", '0')) / scheduleCnt * 100;
					tot_run = tot_run.toFixed(2);
				} else {
					tot_run = "0.00";
				}
			} else {
				tot_start = "0.00";
				tot_end = "0.00";
				tot_run = "0.00";
			}
		} else {
			tot_start = "0.00";
			tot_end = "0.00";
			tot_run = "0.00";
		}

		$("#tot_scd_start_msg").append(tot_start);	//시작
		$("#tot_scd_stop_msg").append(tot_end);		//중지
		$("#tot_scd_run_msg").append(tot_run);		//실행중
		
	}

</script>

<%@include file="./popup/scheduleHistoryDetail.jsp"%>
<%@include file="./cmmn/workScriptInfo.jsp"%>
<%@include file="./cmmn/wrkLog.jsp"%>
<%@include file="./db2pg/popup/db2pgHistoryDetail.jsp"%>
<%@include file="./db2pg/popup/db2pgResultDDL.jsp"%> 
<%@include file="./db2pg/popup/db2pgResult.jsp"%> 
<%@include file="./scale/scaleWrkLog.jsp"%>
<%@include file="./proxy/popup/proxyDBStandbyIPViewPop.jsp"%>

<form name="dashboardViewForm" id="dashboardViewForm">
	<input type="hidden" name="scd_nm"  id="scd_nm" />
	<input type="hidden" name="db2pg_yn"  id="db2pg_yn" value="${db2pg_yn}"/>
	<input type="hidden" name="scale_yn"  id="scale_yn" value="${scale_yn}"/>
	<input type="hidden" name="dvb_svr_id_chk"  id="dvb_svr_id_chk" value= "4"/>
	<input type="hidden" name="encp_use_yn_chk"  id="encp_use_yn_chk" value="${sessionScope.session.encp_use_yn}"/>
	
	<input type="hidden" name="serverSsCnt"  id="serverSsCnt" />
	
	<input type="hidden" name="proxy_yn" id="proxy_yn" value="${proxy_yn}"/>
	<input type="hidden" name="proxy_menu_yn" id="proxy_menu_yn" value="${proxy_menu_yn}"/>
</form>

<!-- partial -->
<div class="content-wrapper main_scroll" id="contentsDivDash">
	<div class="row" style="margin-top:-20px;margin-bottom:5px;">
		<!-- title start -->
		<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist">
			<div class="card" style="margin-bottom:0px;">
				<div class="card-header" role="tab" id="page_header_div" >
					<div class="row" style="height: 15px;">
						<div class="col-7">
							<h6 class="mb-0">
								<i class="ti-calendar menu-icon"></i>
								<span class="menu-title"><spring:message code="dashboard.integrate_schedule"/></span>
							</h6>
						</div>
						<div class="col-5">
		 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
								<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_sdt_today"></li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 통합스케줄 -->
	<div class="row" style="justify-content: space-between;">
		<!-- 스케줄등록 -->
		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;"> <!--  class 신규 생성 시 max-width는 불필요한 요소이나, col-md-2  클래스 스타일이 들어가 추가했습니다.  -->
 			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleListView.do'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left">Schedule(<spring:message code="dashboard.Register_schedule" />)</p>
					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
						<c:choose>
							<c:when test="${not empty backupInfo}">
								<c:choose>
									<c:when test="${not empty backupInfo.schedule_cnt}">
										<c:choose>
											<c:when test="${fn:length(fn:escapeXml(backupInfo.schedule_cnt))>2}">
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${backupInfo.schedule_cnt}"/></h3>
											</c:when>
											<c:otherwise>
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0"><c:out value="${backupInfo.schedule_cnt}"/></h3>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
							</c:otherwise>
						</c:choose>
						<i class="ti-calendar icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>
					<p class="mb-0 mt-2 text-warning">30 days <span class="text-black ml-1"><small>(<spring:message code="dashboard.standard_msg" />)</small></span></p>
				</div>
			</div>
		</div>

		<!-- 금일예정-->
 		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;">
			<div class="card">
				<div class="card-body" >
					<p class="card-title text-md-center text-xl-left">Today(<spring:message code="dashboard.scheduled_today" />)</p>
					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
						<c:choose>
							<c:when test="${not empty scheduleInfo}">
								<c:choose>
									<c:when test="${not empty scheduleInfo.today_cnt}">
										<c:choose>
											<c:when test="${fn:length(fn:escapeXml(scheduleInfo.today_cnt))>2}">
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${scheduleInfo.today_cnt}"/></h3>
											</c:when>
											<c:otherwise>
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0"><c:out value="${scheduleInfo.today_cnt}"/></h3>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
							</c:otherwise>
						</c:choose>
						<i class="fa fa-calendar icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>
					<p class="mb-0 mt-2 text-success"><span id="tot_scd_ing_msg"></span> <span class="text-black ml-1"><small>(<spring:message code="dashboard.standard_msg" />)</small></span></p>
				</div>
			</div>
		</div>

		<!-- 시작-->		
		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;">
 			<div class="card news_text">
				<div class="card-body " onClick="location.href ='/selectScheduleListView.do?scd_cndt=TC001801'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left">Start(<spring:message code="etc.etc37"/>)</p>
					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
						<c:choose>
							<c:when test="${not empty scheduleInfo}">
								<c:choose>
									<c:when test="${not empty scheduleInfo.start_cnt}">
										<c:choose>
											<c:when test="${fn:length(fn:escapeXml(scheduleInfo.start_cnt))>2}">
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${scheduleInfo.start_cnt}"/></h3>
											</c:when>
											<c:otherwise>
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0"><c:out value="${scheduleInfo.start_cnt}"/></h3>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
							</c:otherwise>
						</c:choose>
						<i class="fa fa-play icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_start_msg"></span> <span class="text-black ml-1"><small><br>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>

		<!-- 중지 -->
 		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;">
			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleListView.do?scd_cndt=TC001803'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left">Stop(<spring:message code="schedule.stop" />)</p>
					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
						<c:choose>
							<c:when test="${not empty scheduleInfo}">
								<c:choose>
									<c:when test="${not empty scheduleInfo.stop_cnt}">
										<c:choose>
											<c:when test="${fn:length(fn:escapeXml(scheduleInfo.stop_cnt))>2}">
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${scheduleInfo.stop_cnt}"/></h3>
											</c:when>
											<c:otherwise>
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-danger"><c:out value="${scheduleInfo.stop_cnt}"/></h3>
											</c:otherwise> 
										</c:choose>
									</c:when>
									<c:otherwise>
										<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
							</c:otherwise>
						</c:choose>
						<i class="fa fa-pause icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>  
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_stop_msg"></span> <span class="text-black ml-1"><small><br>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>         

		<!-- 실행중 -->
		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;">
			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleListView.do?scd_cndt=TC001802'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left"><spring:message code="dashboard.running" /></p>

					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
							<c:choose>
								<c:when test="${not empty scheduleInfo}">
									<c:choose>
										<c:when test="${not empty scheduleInfo.run_cnt}">
											<c:choose>
												<c:when test="${fn:length(fn:escapeXml(scheduleInfo.run_cnt))>2}">
													<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${scheduleInfo.run_cnt}"/></h3>
												</c:when>
												<c:otherwise>
													<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0"><c:out value="${scheduleInfo.run_cnt}"/></h3>
												</c:otherwise> 
											</c:choose>
										</c:when>
										<c:otherwise>
											<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
								</c:otherwise>
							</c:choose>
							&nbsp;
							<i class="fa fa-refresh fa-spin icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>  
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_run_msg"></span> <span class="text-black ml-1"><small><br>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>

		<!--  오류 -->
 		<div class="col-md-2 grid-margin stretch-card" style="flex:1 0 16.66667%; min-width:250px; max-width: none;">
			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleHistoryFail.do'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left"><spring:message code="dashboard.failed" /></p>
					<div class="d-flex flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
						<c:choose>
							<c:when test="${not empty scheduleInfo}">
								<c:choose>
									<c:when test="${not empty scheduleInfo.fail_cnt}">
										<c:choose>
											<c:when test="${fn:length(fn:escapeXml(scheduleInfo.fail_cnt))>2}">
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"><c:out value="${scheduleInfo.fail_cnt}"/></h3>
											</c:when>
											<c:otherwise>
												<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-danger"><c:out value="${scheduleInfo.fail_cnt}"/></h3>
											</c:otherwise> 
										</c:choose>
									</c:when>
									<c:otherwise>
										<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<h3 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0">0</h3>
							</c:otherwise>
						</c:choose>
						<i class="fa fa-times-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
  					</div>  
					<p class="mb-0 mt-2 text-warning">30 days <span class="text-black ml-1"><small>(<spring:message code="dashboard.standard_msg" />)</small></span></p>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 데이터이관 -->
<%-- 	<div class="row">
		<div class="col-md-12 grid-margin stretch-card" style="margin-top:-10px;">
			<div class="card">
				<div class="card-body">
					<div class="row">
	                   <!-- 데이터이관 title -->
						<div class="accordion_main accordion-multi-colored col-12" id="accordion_migt_his" role="tablist">
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="migt_hist_header_div">
									<div class="row" style="height: 15px;">
										<div class="col-7">
											<h6 class="mb-0">
												<a data-toggle="collapse" href="#migt_hist_header_sub" aria-expanded="true" aria-controls="migt_hist_header_sub" onclick="fn_profileChk('migt_titleText')">
													<i class="fa fa-database menu-icon"></i>
													<span class="menu-title"><spring:message code="dashboard.migration"/></span>
													<i class="menu-arrow_user_af" id="migt_titleText" ></i>
												</a>
											</h6>
										</div>
										<div class="col-5">
											<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
												<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_migration_his_today"></li>
											</ol>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div id="migt_hist_header_sub" class="collapse show" role="tabpanel" aria-labelledby="migt_hist_header_div" data-parent="#accordion_migt_his">
 						<c:choose>
							<c:when test="${db2pg_yn eq 'Y'}"> 
								<div class="row">
									<!-- 데이터이관 일정 -->
									<div class="col-md-3 col-xl-3 justify-content-center">
										<div class="card" style="margin-left:-10px;border:none;">
											<div class="card-body" style="border:none;">
												<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.schedule" /></p>
												
												<table id="migtHistCntList" class="table table-hover system-tlb-scroll report-table_dash" style="width:100%;"></table>
											</div>
										</div>
									</div>
									
									<div class="col-md-6 col-xl-6 justify-content-center">
										<div class="card" style="margin-left:-10px;border:none;">
											<div class="card-body" style="border:none;">
												<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.history" /></p>
												
												<table id="migtHistList" class="table table-striped table-borderless" style="width:100%;">
													<thead>
														<tr>
															<th width="200" scope="col"><spring:message code="common.work_name" /></th>	
															<th width="100" scope="col" class="text-left"><spring:message code="dashboard.migration_division"/></th>		
															<th width="130" scope="col" class="text-center"><spring:message code="backup_management.work_start_time"/></th>
															<th width="130" scope="col" class="text-center"><spring:message code="backup_management.work_end_time"/></th>
															<th width="95" scope="col" class="text-center"><spring:message code="schedule.jobTime"/></th>
															<th width="95" scope="col" class="text-center"><spring:message code="schedule.result"/></th>
														</tr>
													</thead>
													<tbody id="migrationListT">
													</tbody>
												</table>
											</div>
										</div>
									</div>
									
									<div class="col-md-3 col-xl-3 justify-content-center">
										<div class="card" style="margin-left:-10px;border:none;">
											<div class="card-body" style="border:none;">
												<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.statistics" /></p>
												<table id="migtHistChart" class="table table-borderless">
												</table>
											</div>
										</div>
									</div>
								</div>
 							</c:when>
							<c:otherwise>
								<div class="row">
									<!-- 데이터이관 일정 -->
									<div class="col-md-12 justify-content-center">
										<div class="card card-inverse-danger">
											<div class="card-body">
												<p class="card-text">
													<i class="fa fa-times-circle menu-icon"></i>
													<spring:message code="dashboard.msg08" />
                       							</p>
                    						</div>
                 						</div>
									</div>
								</div>
							</c:otherwise>
						</c:choose> 
					</div>
				</div>
			</div>
		</div>
	</div>
--%>	
	<!--  서버별 정보 -->
	<div class="row">
		<div class="col-md-12 grid-margin stretch-card" style="margin-top:-10px;">
			<div class="card position-relative">
				<div class="card-body">
					<div class="row">
	                    <div class="col-3">
	                    	<!-- 서버정보 title -->
	                    	<div class="row">
								<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" style="margin-bottom:10px;">
									<div class="card" style="margin-bottom:0px;">
										<div class="card-header" role="tab" id="page_header_div" >
											<div class="row" style="height: 15px;">
												<div class="col-12">
													<h6 class="mb-0">
														<i class="ti-calendar menu-icon"></i>
														<span class="menu-title"><spring:message code="dashboard.server_information"/></span>
													</h6>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- 서버목록 -->
							<div class="row" id="serverTabList" >
							</div>
						</div>
						
						<div class="col-9">
							<div id="detailedReports" class="carousel slide detailed-report-carousel position-static pt-2" data-ride="carousel">
								<div class="carousel-inner">
									<div class="carousel-item active" id="v-pills-home_test1">
										<div class="row">
											<!-- 백업일정 title -->
											<div class="accordion_main accordion-multi-colored col-6" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_header_div" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="ti-calendar menu-icon"></i>
																	<span class="menu-title"><spring:message code="dashboard.dump_schedule"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
											
											<!-- 배치일정 title -->
											<div class="accordion_main accordion-multi-colored col-6" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_header_div" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="ti-calendar menu-icon"></i>
																	<span class="menu-title"><spring:message code="dashboard.script_schedule"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<div class="row">
											<!-- 백업일정 내역 출력 -->
											<div class="accordion_main accordion-multi-colored col-6" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;">
													<table id="bakupScheduleCntList" class="table table-hover system-tlb-scroll" style="width:100%;border:none;">
													</table>
												</div>
											</div>
											
											<!-- 배치일정 내역 출력 -->
											<div class="accordion_main accordion-multi-colored col-6" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;">
													<table id="scriptScheduleCntList" class="table table-hover system-tlb-scroll" style="width:100%;border:none;">
													</table>
												</div>
											</div>
										</div>

										<div class="row">
											<!-- 스케줄이력 title -->
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_sch_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="scd_hist_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-5">
																<h6 class="mb-0">
																	<a data-toggle="collapse" href="#scd_hist_header_sub" aria-expanded="true" aria-controls="scd_hist_header_sub" onclick="fn_profileChk('scd_titleText')">
																		<i class="ti-calendar menu-icon"></i>
																		<span class="menu-title"><spring:message code="dashboard.schedule_history" /></span>
																		<i class="menu-arrow_user_af" id="scd_titleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-7">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_sdt_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>

										<div id="scd_hist_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="scd_hist_header_div" data-parent="#accordion_sch_his">
											<!-- 스케줄이력 List -->
											<div class="col-md-7 col-xl-7 justify-content-center">
												<div class="card" style="margin-left:-10px;border:none;">
													<div class="card-body" style="border:none;">
														<table id="scheduleList" class="table table-striped table-borderless report-table_dash" style="width:100%;">
															<thead>
																<tr>
																	<th scope="col" class="text-center"><spring:message code="schedule.schedule_name" /></th>	
																	<th scope="col" class="text-center"><spring:message code="dashboard.schedule_division"/></th>		
																	<th scope="col" class="text-center"><spring:message code="schedule.work_start_datetime" /></th>
																	<th scope="col" class="text-center"><spring:message code="schedule.work_end_datetime" /></th>
																	<th scope="col" class="text-center"><spring:message code="schedule.result" /></th>
																</tr>
															</thead>
															<tbody id="scheduleListT">
															</tbody>
														</table>
													</div>
												</div>
											</div>
											
											<div class="col-md-5 col-xl-5 d-flex flex-column justify-content-center">
												<!-- 스케줄이력 chart -->
												<div class="table-responsive mb-3 mb-md-0">
													<table id="scheduleHistChart" class="table table-borderless"></table>
												</div>
											</div>
										</div>

										<div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div>

										<%-- <div class="row">
											<!-- 백업이력 title -->
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_back_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="back_hist_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-7">
																<h6 class="mb-0">
																	<a id="a_back_hist" data-toggle="collapse" href="#back_hist_header_sub" aria-expanded="true" aria-controls="back_hist_header_sub" onclick="fn_profileChk('back_titleText')">
																		<i class="ti-calendar menu-icon"></i>
																		<span class="menu-title"><spring:message code="dashboard.backup_history" /></span>
																		<i class="menu-arrow_user_af" id="back_titleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-5">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_back_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>  --%>

										<%-- <div id="back_hist_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="back_hist_header_div" data-parent="#accordion_back_his">
											<div class="col-md-12 col-xl-12 justify-content-center">
												<div class="card" style="margin-left:-10px;border:none;">
													<div class="card-body" style="border:none;">
														<table id="backupLogList" class="table table-striped table-borderless" style="width:100%;">
															<thead>
																<tr>
																	<th width="150" scope="col" class="text-center"><spring:message code="common.work_name" /></th>		
																	<th width="90" scope="col" class="text-center"><spring:message code="backup_management.backup_option" /></th>
																	<th width="100" scope="col" class="text-center"><spring:message code="backup_management.work_start_time" /> </th>
																	<th width="100" scope="col" class="text-center"><spring:message code="backup_management.work_end_time" /></th>
																	<th width="100" scope="col" class="text-center"><spring:message code="common.status" /></th>
																</tr>
															</thead>
															<tbody id="backupHistListT">
															</tbody>
														</table>
													</div>
												</div>
											</div>
											
											<div class="col-md-5 col-xl-5 d-flex flex-column justify-content-center">
												 <h4 class="card-title"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="backup_management.rman_backup" /></h4>
										 		<div id="backupRmanHistChart" style="height:250px;"></div>
											</div>
											
											<div class="col-md-7 col-xl-7 d-flex flex-column justify-content-center">
												 <h4 class="card-title"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="backup_management.dumpBck" /></h4>
										 		<div id="backupDumpHistChart" style="height:250px;"></div>
											</div>
										</div> --%>

										<!-- <div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div> -->

										<%-- <div class="row">
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_script_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="script_hist_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-7">
																<h6 class="mb-0">
																	<a id="a_script_hist" data-toggle="collapse" href="#script_hist_header_sub" aria-expanded="true" aria-controls="script_hist_header_sub" onclick="fn_profileChk('script_titleText')">
																		<i class="ti-calendar menu-icon"></i>
																		<span class="menu-title"><spring:message code="dashboard.script_history" /></span>
																		<i class="menu-arrow_user_of" id="script_titleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-5">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_script_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div> --%>
										
										<%-- <div id="script_hist_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="script_hist_header_div" data-parent="#accordion_script_his">
											<div class="col-md-8 col-xl-8 justify-content-center">
												<div class="card" style="margin-left:-10px;border:none;">
													<div class="card-body" style="border:none;">
														<table id="scriptList" class="table table-striped table-borderless report-table_dash" style="width:100%;">
															<thead>
																<tr>
																	<th width="150" scope="col" class="text-center"><spring:message code="common.work_name" /></th>		
																	<th width="100" scope="col" class="text-center"><spring:message code="backup_management.work_start_time" /> </th>
																	<th width="100" scope="col" class="text-center"><spring:message code="backup_management.work_end_time" /></th>
																	<th width="100" scope="col" class="text-center"><spring:message code="backup_management.elapsed_time" /></th>
																	<th width="100" scope="col" class="text-center"><spring:message code="common.status" /></th>
																</tr>
															</thead>
															<tbody id="scriptHistListT">
															</tbody>
														</table>
													</div>
												</div>
											</div>
											
											<div class="col-md-4 col-xl-4 justify-content-center">
 												<div class="card" style="margin-left:-10px;border:none;">
													<div class="card-body" style="border:none;">
														<canvas id="scriptHistChart" style="height:27vh; width:15vw;"></canvas>
													</div>
												</div>
											</div>
										</div>  --%>

										<!-- <div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div> -->

										<div class="row">
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_scale_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="scale_hist_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-7">
																<h6 class="mb-0">
																	<a id="a_scale_hist" data-toggle="collapse" href="#scale_hist_header_sub" aria-expanded="true" aria-controls="scale_hist_header_sub" onclick="fn_profileChk('scale_titleText')">
																		<i class="ti-calendar menu-icon"></i>
																		<span class="menu-title"><spring:message code="dashboard.eXperDB_scale_Information"/></span>
																		<i class="menu-arrow_user_of" id="scale_titleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-5">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_scale_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
                        
										<div id="scale_hist_header_sub" class="collapse show" role="tabpanel" aria-labelledby="scale_hist_header_div" data-parent="#accordion_scale_his">
											<c:choose>
												<c:when test="${scale_yn eq 'Y'}">
													<div class="row" id="scale_div_set">
														<div class="col-md-12 col-xl-12 justify-content-center">
															<div class="card" style="margin-left:-10px;border:none;">
																<div class="card-body" style="border:none;">
																	<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="menu.eXperDB_scale_settings" /></p>

																	<table id="scaleList" class="table table-striped table-borderless report-table_dash" style="width:100%;">
																		<thead>
																			<tr>
																				<th width="100" scope="col" class="text-center"><spring:message code="eXperDB_scale.process_id" /></th>
																				<th width="100" scope="col" class="text-center"><spring:message code="eXperDB_scale.scale_type" /></th>
																				<th width="80" scope="col" class="text-center"><spring:message code="eXperDB_scale.wrk_type" /></th>
																				<th width="220" scope="col" class="text-center"><spring:message code="eXperDB_scale.auto_policy_nm" /></th>
																				<th width="90" scope="col" class="text-center"><spring:message code="eXperDB_scale.work_start_time" /></th>
																				<th width="90" scope="col" class="text-center"><spring:message code="eXperDB_scale.work_end_time" /></th>
																				<th width="100" scope="col" class="text-center"><spring:message code="common.status" /></th>
																			</tr>
																		</thead>
																		<tbody id="scaleHistListT">
																		</tbody>
																	</table>
																</div>
															</div>
														</div>
														
														<div class="col-md-9 col-xl-9 justify-content-center">
			 												<div class="card" style="margin-left:-10px;margin-top:-10px;border:none;">
																<div class="card-body" style="border:none;">
																	<h4 class="card-title"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.execute_statistics" /></h4>
										 							<div id="scaleHistChart" style="height:250px;"></div>
																</div>
															</div>
														</div>
														
														<div class="col-md-3 col-xl-3 justify-content-center">
			 												<div class="card" style="margin-left:-40px;border:none;">
																<div class="card-body" style="border:none;">
																	<h4 class="card-title"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.occur_hist_statistics" /></h4>
																	<canvas id="scaleSetChart" style="height:27vh; width:15vw;"></canvas>
																</div>
															</div>
														</div>
													</div>
													<div class="row" id="scale_div_none" style="display:none;">
														<div class="col-md-12 col-xl-12 justify-content-center">
															<div class="card card-inverse-info">
																<div class="card-body">
																	<p class="card-text">
																		<i class="fa fa-times-circle menu-icon"></i>
																		<spring:message code="eXperDB_scale.msg10" />
					                       							</p>
					                    						</div>
					                 						</div>
														</div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="row">
														<div class="col-md-12 col-xl-12 justify-content-center">
															<div class="card card-inverse-danger">
																<div class="card-body">
																	<p class="card-text">
																		<i class="fa fa-times-circle menu-icon"></i>
																		<spring:message code="dashboard.msg09" />
					                       							</p>
					                    						</div>
					                 						</div>
														</div>
													</div>
												</c:otherwise>
											</c:choose>
										</div>

										<div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div>

										<div class="row">
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_encrypt_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="encrypt_hist_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-7">
																<h6 class="mb-0">
																	<a id="a_encrypt_hist" data-toggle="collapse" href="#encrypt_hist_header_sub" aria-expanded="true" aria-controls="encrypt_hist_header_sub" onclick="fn_profileChk('encrypt_titleText')">
																		<i class="ti-calendar menu-icon"></i>
																		<span class="menu-title"><spring:message code="dashboard.Encryption_Information"/></span>
																		<i class="menu-arrow_user_of" id="encrypt_titleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-5">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_encrypt_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>		

										<div id="encrypt_hist_header_sub" class="collapse show" role="tabpanel" aria-labelledby="encrypt_hist_header_div" data-parent="#accordion_encrypt_his">
											<div class="row"  id="encrypt_div_set">
												<div class="col-md-2_5 justify-content-center">
	 												<div class="card" style="margin-left:-10px;border:none;">
														<div class="card-body" style="border:none;">
															<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.encrypt_key_management_server" /></p>
															<table id="keyServerState" class="table table-hover system-tlb-scroll" style="width:100%;border:none;">
															</table>
														</div>
													</div>
												</div>
											
												<div class="col-md-3_5 justify-content-center">
	 												<div class="card" style="margin-left:-10px;border:none;">
														<div class="card-body" style="border:none;">
															<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.encrypt_key_agent" /></p>
															<table id="agentKeyServerState" class="table table-hover system-tlb-scroll" style="width:100%;border:none;">
															</table>
														</div>
													</div>
												</div>

												<div class="col-md-6 col-xl-6 justify-content-center">
	 												<div class="card" style="margin-left:-10px;border:none;">
														<div class="card-body" style="border:none;">
															<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="dashboard.encrypt_statistics" /></p>
															<%-- <canvas id="encryptHistChart" style="height:27vh; width:15vw;"></canvas> --%>
															<canvas id="encryptHistChart"></canvas>
														</div>
													</div>
												</div>
											</div>

											<div class="row" id="encrypt_div_none" style="display:none;">
												<div class="col-md-12 col-xl-12 justify-content-center">
													<div class="card card-inverse-danger">
														<div class="card-body">
															<p class="card-text">
																<i class="fa fa-times-circle menu-icon"></i>
																<spring:message code="dashboard.msg11" />
					                       					</p>
					                    				</div>
					                 				</div>
												</div>
											</div>
										</div>

										<div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div>
										
										<!-- proxy -->
										<c:if test="${proxy_menu_yn eq 'Y'}">
											<div class="row">
												<!-- proxy title -->
		                    					<div class="accordion_main accordion-multi-colored col-12" id="accordion_proxy" role="tablist">
													<div class="card" style="margin-bottom:0px;">
														<div class="card-header" role="tab" id="proxy_header_div">
															<div class="row" style="height: 15px;">
																<div class="col-7">
																	<h6 class="mb-0">
																		<a data-toggle="collapse" href="#proxy_header_sub" aria-expanded="true" aria-controls="proxy_header_sub" onclick="fn_profileChk('proxy_titleText')">
																			<i class="mdi mdi-server-network menu-icon"></i>
																			<span class="menu-title"><spring:message code="menu.proxy"/></span>
																			<i class="menu-arrow_user_af" id="proxy_titleText" ></i>
																		</a>
																	</h6>
																</div>
																<div class="col-5">
												 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																		<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_proxy_his_today"></li>
																	</ol>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
											
											<div id="proxy_header_sub" class="collapse show" role="tabpanel" aria-labelledby="proxy_header_div" data-parent="#accordion_proxy">
												<c:choose>
													<c:when test="${proxy_yn eq 'Y'}">
														<div class="row">
															<!-- 상세내역 -->
															<div class="col-12">
																<div id="detailedReports" class="carousel slide detailed-report-carousel position-static pt-2" data-ride="carousel">
																	<div class="carousel-inner">
																		<div class="carousel-item active" id="v-pills-home_test1">
																			<!-- title row start -->
																			<div class="row" id="reg_pry_title">
													
																				<!-- vip title start -->
																				<div class="accordion_main accordion-multi-colored col-3_2" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:0px; border:none;">
																						<div class="card-body" style="padding:10px 0px 0px 0px;">
																							<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="eXperDB_proxy.vip"/></p>
																						</div>
																					</div>
																				</div>
																				<!-- vip title end -->
																				
																				<!-- vip <- -> proxy 할당 title start -->
																				<div class="accordion_main col-0_5" style="border:none;" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
																						<div class="card-header" role="tab" id="page_connect_server" >
																							<div class="row" style="height: 15px;">
																								<div class="col-12">
																									<h6 class="mb-0">
																										&nbsp;
																									</h6>
																								</div>
																							</div>
																						</div>
																					</div>
																				</div>
																				<!-- vip <- -> proxy 할당 title end -->
																				
																				<!-- proxy listener title start -->
																				<div class="accordion_main accordion-multi-colored col-3_7" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:0px; border:none;">
																						<div class="card-body" style="padding:10px 0px 0px 0px;">
																							<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.con_lsn"/></p>
																						</div>
																					</div>
																				</div>
																				<!-- proxy listener title end -->
																				
																				<!-- listener db connect title start -->
																				<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
																						<div class="card-header" role="tab" id="page_connect_server" >
																							<div class="row" style="height: 15px;">
																								<div class="col-12">
																									<h6 class="mb-0">
																										&nbsp;
																									</h6>
																								</div>
																							</div>
																						</div>
																					</div>
																				</div>
																				<!-- listener db connect title end -->
																							
																				<!-- proxy connected db title start -->
																				<div class="accordion_main accordion-multi-colored col-3_4" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:0px; border:none;">
																						<div class="card-body" style="padding:10px 0px 0px 0px;">
																							<p class="card-title" style="margin-bottom:0px"><i class="fa fa-toggle-right text-info"></i>&nbsp;<spring:message code="eXperDB_proxy.con_db_server"/></p>
																						</div>
																					</div>
																				</div>
																				<!-- proxy connected db title end -->
																				
																			</div>
																			<!-- title row end -->
										
																			<!-- proxy content row start -->
																			<div class="row" id="reg_pry_detail">
													
																				<!-- vip 출력 -->
																				<div class="accordion_main accordion-multi-colored col-3_2" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:10px;border:none;" >
																						<div class="card-body" style="border:none;min-height: 240px;margin: -20px -20px 0px -20px;" id="proxyMonitoringList">
																						</div>
																					</div>
																				</div>
																				
																				<!-- 할당 -->
																				<div class="accordion_main accordion-multi-colored col-0_5" id="accordion" role="tablist" >
																					<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
																						<div class="card-body" style="border:none;min-height: 240px;margin-left:-17px;" id="proxyVipConLineList">
																						</div>
																					</div>
																				</div>
															 
																				<!-- 리스너 -->
																				<div class="accordion_main accordion-multi-colored col-3_7" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:10px;border:none;" >
																						<div class="card-body" style="border:none;min-height: 240px;margin: -20px -20px 0px -20px;" id="proxyListnerMornitoringList">
																						</div>
																					</div>
																				</div>
																				
																				<!-- 리스너 - 디비 연결 화살표 -->									
																				<div class="accordion_main accordion-multi-colored col-1" id="accordion" role="tablist" >
																					<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
																						<div class="card-body" style="border:none;min-height: 240px;margin-left:-17px;" id="proxyListnerConLineList">
																						</div>
																					</div>
																				</div>
														
														
																				<!-- DB 서버  출력-->
																				<div class="accordion_main accordion-multi-colored col-3_4" id="accordion" role="tablist" >
																					<div class="card" style="margin-bottom:10px;border:none;" >
																						<div class="card-body" style="border:none;min-height: 240px;margin: -20px -20px 0px -20px;" id="dbListenerVipList">
																						</div>
																					</div>
																				</div>
														
																			</div>
																			<!-- proxy content row end -->
																			
																			<!-- proxy 데이터 없는 경우 -->										
																			<div class="row" id="no_reg_pry_detail">
																				<div class="col-md-12 col-xl-12 justify-content-center">
																					<div class="card card-inverse-info">
																						<div class="card-body">
																							<p class="card-text">
																								<i class="fa fa-times-circle menu-icon"></i>
																								<spring:message code="eXperDB_proxy.msg40" />
									                       									</p>
									                    								</div>
									                 								</div>
																				</div>
																			</div>
																		</div>
																	</div>
																</div>
															
															</div>
														</div>
													</c:when>
													<c:otherwise>
														<div class="row">
															<div class="col-md-12 col-xl-12 justify-content-center">
																<div class="card card-inverse-danger">
																	<div class="card-body">
																		<p class="card-text">
																			<i class="fa fa-times-circle menu-icon"></i>
																			<spring:message code="dashboard.msg12" />
								                       					</p>
								                    				</div>
								                 				</div>
															</div>
														</div>
													</c:otherwise>	
												</c:choose>		
											</div>
											<!-- proxy end -->
										</c:if>

										<div class="row">
											<div class="col-md-12">
												<div class="card" style="border:none;">
													&nbsp;
												</div>
											</div>
										</div>

										<div class="row">
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_tablespace" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="tablespace_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="ti-calendar menu-icon"></i>
																	<span class="menu-title"><spring:message code="dashboard.tablespace_information"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<div class="row">
											<!-- DATA -->
											<div class="col-md-2_2 stretch-card grid-margin grid-margin-md-0" style="margin-right:-20px;">
												<div class="card" style="padding-left:10px;padding-right:10px;">
													<div class="card-body" style="padding-left:0px;padding-right:0px;">
														<div class="table-responsive system-tlb-scroll">
															<table class="table table-borderless" style="width:100%;">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">DATA</th>
 																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="filesystemTd"></td>
																	</tr>
																</tbody>
															</table>
															<table class="table table-borderless" style="width:100%;">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">Size</th>
																		<th class="border-bottom">Used</th>
																		<th class="border-bottom">Avail</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="tablespaceInfoFsizeTd"></td>
																		<td class="text-muted pl-0" id="tablespaceInfoUsedTd"></td>
																		<td class="text-muted" id="tablespaceInfoAvailTd"></td>
																	</tr>
																</tbody>
															</table>
															<p class="mb-0 mt-2 text-warning"><spring:message code="dashboard.usage"/></p>
															<div id="pg_data" class="gauge"  style="margin-top: -40px;"></div> 
														</div>
													</div>
												</div>
											</div>
												
											<!-- BAUKUP -->
											<div class="col-md-2_2 stretch-card grid-margin grid-margin-md-0" style="margin-right:-20px;">
												<div class="card" style="padding-left:10px;padding-right:10px;">
													<div class="card-body" style="padding-left:0px;padding-right:0px;">
														<div class="table-responsive system-tlb-scroll">
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">BAUKUP</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="backupPathTd"></td>
																	</tr>
																</tbody>
															</table>
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">Size</th>
																		<th class="border-bottom">Used</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="backupspaceInfoFsizeTd"></td>
																		<td class="text-muted" id="backupVTd"></td>
																	</tr>
																</tbody>
															</table>
															<p class="mb-0 mt-2 text-warning"><spring:message code="dashboard.usage"/></p>
															<div id="pg_backup" class="gauge"  style="margin-top: -40px;"></div>
														</div>
													</div>
												</div>
											</div>
												
											<!-- WAL  -->
											<div class="col-md-2_2 stretch-card grid-margin grid-margin-md-0" style="margin-right:-20px;">
												<div class="card" style="padding-left:10px;padding-right:10px;">
													<div class="card-body" style="padding-left:0px;padding-right:0px;">
														<div class="table-responsive system-tlb-scroll">
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">WAL</th>
																		</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="pgwalPathTd"></td>
																	</tr>
																</tbody>
															</table>
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="text-muted pl-0" id="walKeepSegmentsTd"></th>
																	</tr>
																	<tr>
																		<th class="text-muted pl-0" id="pgwalCntTd"></th>
																	</tr>
																</thead>
															</table>
														
															<p class="mb-0 mt-2 text-warning">WAL<spring:message code="dashboard.file"/></p>
															<div id="pg_wal" class="gauge"  style="margin-top: -40px;"></div>
														</div>
													</div>
												</div>
											</div>
											
											<!-- ARCHIVE -->
											<div class="col-md-2_2 stretch-card grid-margin grid-margin-md-0" style="margin-right:-20px;">
												<div class="card" style="padding-left:10px;padding-right:10px;">
													<div class="card-body" style="padding-left:0px;padding-right:0px;">
														<div class="table-responsive system-tlb-scroll">
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">ARCHIVE</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="pgalogPathTd"></td>
																	</tr>
																</tbody>
															</table>
															<table class="table table-borderless" style="margin-bottom: 50px">
																<thead>
																	<tr>
																		<th class="text-muted pl-0" id="pgalogCntTd"></th>
																	</tr>    
																</thead>
															</table>
															<p class="mb-0 mt-2 text-warning"><spring:message code="dashboard.directory_capacity"/></p>
															<div id="pg_arc" class="gauge"  style="margin-top: -40px;"></div>
														</div>
													</div>
												</div>
											</div>
											
											<!-- LOG -->
											<div class="col-md-2_2 stretch-card grid-margin grid-margin-md-0" style="margin-right:-20px;">
												<div class="card" style="padding-left:10px;padding-right:10px;">
													<div class="card-body" style="padding-left:0px;padding-right:0px;">
														<div class="table-responsive system-tlb-scroll">
															<table class="table table-borderless">
																<thead>
																	<tr>
																		<th class="pl-0 border-bottom">LOG</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td class="text-muted pl-0" id="logPathTd"></td>
																	</tr>
																</tbody>
															</table>
															<table class="table table-borderless" style="margin-bottom: 50px">
																<thead>
																	<tr>
																		<th class="text-muted pl-0" id="logFileCntTd"></th>
																	</tr>
																</thead>
															</table>
															
															<p class="mb-0 mt-2 text-warning"><spring:message code="dashboard.directory_capacity"/></p>
															<div id="pg_log" class="gauge"  style="margin-top: -40px;"></div>
														</div>
													</div>
												</div>
											</div>
										</div>
										

										
									</div>
			                    </div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	

</div>
<!-- content-wrapper ends -->