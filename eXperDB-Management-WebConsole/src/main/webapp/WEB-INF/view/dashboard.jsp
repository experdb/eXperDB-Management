<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="./cmmn/cs2.jsp"%> 

<script type="text/javascript">
	var today = "";
	var scale_yn_chk = "";

	$(window.document).ready(function() { 
		//오늘날짜 setting
		fn_todaySetting();
		
		//통합 스케줄 setting
		fn_totScdSetting();
		
		//서버정보 리스트 setting
		fn_serverListSetting();
	});

	/* ********************************************************
	 * 금일 날짜 셋팅
	 ******************************************************** */
	function fn_todaySetting() {
		today = new Date();

		var html = "<i class='fa fa-calendar menu-icon'></i> "+today.toJSON().slice(0,10).replace(/-/g,'-');

		$( "#tot_sdt_today" ).append(html);
		$( "#tot_scd_ing_msg" ).append(html);
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
			scheduleCnt = nvlPrmSet("${backupInfo.schedule_cnt}", '0');
			
			if (scheduleCnt != 0) {
				//시작
				if (nvlPrmSet("${scheduleInfo.start_cnt}", '') != "") {
					tot_start = nvlPrmSet("${scheduleInfo.start_cnt}", '0') / scheduleCnt * 100;
					tot_start = tot_start.toFixed(2);
				} else {
					tot_start = "0.00";
				}
				
				if (nvlPrmSet("${scheduleInfo.stop_cnt}", '') != "") {
					tot_end = nvlPrmSet("${scheduleInfo.stop_cnt}", '0') / scheduleCnt * 100;
					tot_end = tot_end.toFixed(2);
				} else {
					tot_end = "0.00";
				}
				
				if (nvlPrmSet("${scheduleInfo.run_cnt}", '') != "") {
					tot_run = nvlPrmSet("${scheduleInfo.run_cnt}", '0') / scheduleCnt * 100;
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

	/* ********************************************************
	 * 서버리스트 설정
	 ******************************************************** */
	function fn_serverListSetting() {
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var db_svr_id = "";
		var listCnt = 0;

		<c:choose>
			<c:when test="${fn:length(serverTotInfo) == 0}">
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
			</c:when>
			<c:otherwise>
				<c:forEach items="${serverTotInfo}" var="serverinfo" varStatus="status">
					master_gbn = nvlPrmSet("${serverinfo.master_gbn}", '') ;
					rowCount = rowCount + 1;
					listCnt = parseInt("${fn:length(serverTotInfo)}");
					
		 			if (db_svr_id == "") {				
						html += "<div class='col-md-12 grid-margin stretch-card'>\n";
						html += "	<div class='card news_text'>\n";
						html += '		<div class="card-body row" onClick="fn_serverSebuInfo("'+nvlPrmSet("${serverinfo.db_svr_id}", '')+'")" style="cursor:pointer;">\n';
					} else if (db_svr_id != nvlPrmSet("${serverinfo.db_svr_id}", '')  && master_gbn == "M") {
						html += '				</div>\n';
						html += '			</div>\n';
						html += '			<div class="col-sm-3" style="margin:auto;">\n';
						html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
						html += '			</div>\n';
						html += "		</div>\n";
						html += "	</div>\n";
						html += '</div>\n';
						
						html += "<div class='col-md-12 grid-margin stretch-card'>\n";
						html += "	<div class='card news_text'>\n";
						html += '		<div class="card-body row" onClick="fn_serverSebuInfo("'+nvlPrmSet("${serverinfo.db_svr_id}", '')+'")" style="cursor:pointer;">\n';
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
						html += '			<div class="col-sm-3" style="margin:auto;">\n';
						html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
						html += '			</div>\n';
						html += "		</div>\n";
						html += "	</div>\n";
						html += '</div>\n';
						
					}
					db_svr_id = nvlPrmSet("${serverinfo.db_svr_id}", '') ;
		
				</c:forEach>
			</c:otherwise>
		</c:choose>

		$("#serverTabList").html(html);
	}
</script>

<!-- partial -->
<div class="content-wrapper main_scroll">
	<div class="row" style="margin-top:-20px;margin-bottom:5px;">
		<!-- title start -->
		<div class="accordion_main accordion-multi-colored col-12" sid="accordion" role="tablist">
			<div class="card" style="margin-bottom:0px;">
				<div class="card-header" role="tab" id="page_header_div" >
					<div class="row" style="height: 15px;">
						<div class="col-5">
							<h6 class="mb-0">
								<i class="ti-calendar menu-icon"></i>
								<span class="menu-title"><spring:message code="etc.etc44"/></span>
							</h6>
						</div>
						<div class="col-7">
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
	<div class="row">
		<!-- 스케줄등록 -->
		<div class="col-md-2 grid-margin stretch-card">
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
 		<div class="col-md-2 grid-margin stretch-card">
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
		<div class="col-md-2 grid-margin stretch-card">
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
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_start_msg"></span> <span class="text-black ml-1"><small>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>

		<!-- 중지 -->
 		<div class="col-md-2 grid-margin stretch-card">
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
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_stop_msg"></span> <span class="text-black ml-1"><small>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>         

		<!-- 실행중 -->
		<div class="col-md-2 grid-margin stretch-card">
			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleListView.do?scd_cndt=TC001802'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left">Running(<spring:message code="dashboard.running" />)</p>
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
						<i class="fa fa-refresh fa-spin icon-md mb-0 mb-md-3 mb-xl-0 text-info"></i>
					</div>  
					<p class="mb-0 mt-2 text-danger"><span id="tot_scd_run_msg"></span> <span class="text-black ml-1"><small>(<spring:message code="dashboard.msg01" />)</small></span></p>
				</div>
			</div>
		</div>

		<!--  오휴 -->
 		<div class="col-md-2 grid-margin stretch-card">
			<div class="card news_text">
				<div class="card-body" onClick="location.href ='/selectScheduleHistoryFail.do'" style="cursor:pointer;">
					<p class="card-title text-md-center text-xl-left">Fail(<spring:message code="dashboard.failed" />)</p>
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
	
	<div class="row">
		<div class="col-md-12 grid-margin stretch-card">
			<div class="card position-relative">
				<div class="card-body">
					<div class="row">
	                    <div class="col-3">
	                    	<div class="row">
								<!-- title start -->
								<div class="accordion_main accordion-multi-colored col-12" sid="accordion" role="tablist" style="margin-bottom:10px;">
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
							

							
							
	                    	<div class="row" id="serverTabList" >


	                    	
	                    		<!-- <div class="col-12">
	                    		
	                    		
	                    		
	                    		
	                    			<ul class="nav nav-pills nav-pills-vertical nav-pills-warning" id="v-pills-tab" role="tablist" aria-orientation="vertical">
										<li class="nav-item">

			 								<a class="nav-link active" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home_test1" role="tab" aria-controls="v-pills-home_test1" aria-selected="true">
												<i class="ti-home"></i>



				                          </a>   
                            
				                        </li>
				                        

	                    		
	                    		
	                    
	                      

	                        <li class="nav-item">
	                          <a class="nav-link" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-home_test2" role="tab" aria-controls="v-pills-home_test2" aria-selected="false">
	                            <i class="ti-user"></i>
	                            Profile
	                          </a>                          
	                        </li>
	                        <li class="nav-item">
	                          <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false">
	                            <i class="ti-email"></i>
	                            Reach
	                          </a>                          
	                        </li>
	                      </ul>
	                    </div> -->
	                    </div>
					</div>
	                    
	                    
	                    <div class="col-9">
			                  <div id="detailedReports" class="carousel slide detailed-report-carousel position-static pt-2" data-ride="carousel">
			                    <div class="carousel-inner">
			                      <div class="carousel-item active" id="v-pills-home_test1">
			                        <div class="row">
			                          <div class="col-md-12 col-xl-3 d-flex flex-column justify-content-center">
			                            <div class="ml-xl-4">
			                              <h1>$34040</h1>
			                              <h3 class="font-weight-light mb-xl-4">North America</h3>
			                              <p class="text-muted mb-2 mb-xl-0">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
			                            </div>  
			                            </div>
			                          <div class="col-md-12 col-xl-9">
			                            <div class="row">
			                              <div class="col-md-6">
			                                <div class="table-responsive mb-3 mb-md-0">
			                                  <table class="table table-borderless report-table">
			                                    <tr>
			                                      <td class="text-muted">Illinois</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-success" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">713</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Washington</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-warning" role="progressbar" style="width: 30%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">583</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Mississippi</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">924</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">California</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-primary" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">664</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Maryland</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-success" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">560</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Alaska</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">793</h5></td>
			                                    </tr>
			                                  </table>
			                                </div>
			                              </div>
			                              <div class="col-md-6 mt-3">
			                                <canvas id="north-america-chart"></canvas>
			                                <div id="north-america-legend"></div>
			                              </div>
			                            </div>
			                          </div>
			                        </div>
			                      </div>
			                      <div class="carousel-item" id="v-pills-home_test2">
			                        <div class="row">
			                          <div class="col-md-12 col-xl-3 d-flex flex-column justify-content-center">
			                            <div class="ml-xl-4">
			                              <h1>$61321</h1>
			                              <h3 class="font-weight-light mb-xl-4">South America</h3>
			                              <p class="text-muted mb-2 mb-xl-0">It is the period time a user is actively engaged with your website, page or app, etc. The total number of sessions within the date range. </p>
			                            </div>
			                          </div>
			                          <div class="col-md-12 col-xl-9">
			                            <div class="row">
			                              <div class="col-md-6">
			                                <div class="table-responsive mb-3 mb-md-0">
			                                  <table class="table table-borderless report-table">
			                                    <tr>
			                                      <td class="text-muted">Brazil</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-success" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">613</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Argentina</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-warning" role="progressbar" style="width: 30%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">483</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Peru</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">824</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Chile</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-primary" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">564</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Colombia</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-success" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">460</h5></td>
			                                    </tr>
			                                    <tr>
			                                      <td class="text-muted">Uruguay</td>
			                                      <td class="w-100 px-0">
			                                        <div class="progress progress-md mx-4">
			                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
			                                        </div>
			                                      </td>
			                                      <td><h5 class="font-weight-bold mb-0">693</h5></td>
			                                    </tr>
			                                  </table>
			                                </div>
			                              </div>
			                              <div class="col-md-6 mt-3">
			                                <canvas id="south-america-chart"></canvas>
			                                <div id="south-america-legend"></div>
			                              </div>
			                            </div>
			                          </div>
			                        </div>
			                      </div>
			                    </div>
			                    <a class="carousel-control-prev" href="#detailedReports" role="button" data-slide="prev">
			                      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
			                      <span class="sr-only">Previous</span>
			                    </a>
			                    <a class="carousel-control-next" href="#detailedReports" role="button" data-slide="next">
			                      <span class="carousel-control-next-icon" aria-hidden="true"></span>
			                      <span class="sr-only">Next</span>
			                    </a>
			                  </div>
			                 </div>
			                 </div>
                </div>
              
              </div>
            </div>
          </div>
          
          
          
          
          
          
          
          
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
 <div class="col-md-12 col-xl-12 grid-margin stretch-card d-none d-md-flex">
              <div class="card">
                <div class="card-body">
                  <h4 class="card-title">Vertical Pills</h4>
                  <p class="card-description">Add class <code>.nav-pills-vertical</code> to <code>.nav</code> and 
                    <code>.tab-content-vertical</code> to <code>.tab-content</code>
                  </p>
                  <div class="row">
                    <div class="col-4">
                      <ul class="nav nav-pills nav-pills-vertical nav-pills-info" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <li class="nav-item">
                          <a class="nav-link active" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home" role="tab" aria-controls="v-pills-home" aria-selected="true">
                            <i class="ti-home"></i>
                            Home
                          </a>                          
                        </li>
                        <li class="nav-item">
                          <a class="nav-link" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false">
                            <i class="ti-user"></i>
                            Profile
                          </a>                          
                        </li>
                        <li class="nav-item">
                          <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false">
                            <i class="ti-email"></i>
                            Reach
                          </a>                          
                        </li>
                      </ul>
                    </div>
                    <div class="col-8">
                      <div class="tab-content tab-content-vertical" id="v-pills-tabContent">
                        <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                          <div class="media">
                            <img class="mr-3 w-25 rounded" src="https://via.placeholder.com/115x115" alt="sample image">
                            <div class="media-body">
                              <h5 class="mt-0">I'm doing mental jumping jacks.</h5>
                              <p>
                                Only you could make those words cute. Oh I beg to differ, I think we have a lot to discuss. After all, 
                                you are a client. I am not a killer. 
                              </p>
                            </div>
                          </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                          <div class="media">
                            <img class="mr-3 w-25 rounded" src="https://via.placeholder.com/115x115" alt="sample image">
                            <div class="media-body">
                              <p>I'm thinking two circus clowns dancing. You? Finding a needle in a haystack isn't hard when every straw is computerized. Tell him time is of the essence. 
                                Somehow, I doubt that. You have a good heart, Dexter.</p>
                            </div>
                          </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab">
                          <div class="media">
                            <img class="mr-3 w-25 rounded" src="https://via.placeholder.com/115x115" alt="sample image">
                            <div class="media-body">
                              <p>
                                  I'm really more an apartment person. This man is a knight in shining armor. Oh I beg to differ, I think we have a lot to discuss. After all, you are a client. You all right, Dexter?
                              </p>
                              <p>
                                  I'm generally confused most of the time. Cops, another community I'm not part of. You're a killer. I catch killers. Hello, Dexter Morgan.
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


	
			





                    
                    
                  
                
              
		


                    
                   
                  
                
              
		




	
          <div class="row">
            <div class="col-md-6 grid-margin stretch-card">
              <div class="card">
                <div class="card-body">
                  <p class="card-title">Order and Downloads</p>
                  <p class="text-muted font-weight-light">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                  <div class="d-flex flex-wrap mb-5">
                    <div class="mr-5 mt-3">
                      <p class="text-muted">Order value</p>
                      <h3>12.3k</h3>
                    </div>
                    <div class="mr-5 mt-3">
                      <p class="text-muted">Orders</p>
                      <h3>14k</h3>
                    </div>
                    <div class="mr-5 mt-3">
                      <p class="text-muted">Users</p>
                      <h3>71.56%</h3>
                    </div>
                    <div class="mt-3">
                      <p class="text-muted">Downloads</p>
                      <h3>34040</h3>
                    </div> 
                  </div>
                  <canvas id="order-chart"></canvas>
                </div>
              </div>
            </div>
            <div class="col-md-6 grid-margin stretch-card">
              <div class="card">
                <div class="card-body">
                  <p class="card-title">Sales Report</p>
                  <p class="text-muted font-weight-light">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                  <div id="sales-legend" class="chartjs-legend mt-4 mb-2"></div>
                  <canvas id="sales-chart"></canvas>
                </div>
                <div class="card border-right-0 border-left-0 border-bottom-0">
                  <div class="d-flex justify-content-center justify-content-md-end">
                    <div class="dropdown flex-md-grow-1 flex-xl-grow-0">
                      <button class="btn btn-lg btn-outline-light dropdown-toggle rounded-0 border-top-0 border-bottom-0" type="button" id="dropdownMenuDate2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                        Today
                      </button>
                      <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuDate2">
                        <a class="dropdown-item" href="#">January - March</a>
                        <a class="dropdown-item" href="#">March - June</a>
                        <a class="dropdown-item" href="#">June - August</a>
                        <a class="dropdown-item" href="#">August - November</a>
                      </div>
                    </div>
                    <button class="btn btn-lg btn-outline-light text-primary rounded-0 border-0 d-none d-md-block" type="button"> View all </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12 grid-margin">
              <div class="card bg-primary border-0 position-relative">
                <div class="card-body">
                  <p class="card-title text-white">Performance Overview</p>
                  <div id="performanceOverview" class="carousel slide performance-overview-carousel position-static pt-2" data-ride="carousel">
                    <div class="carousel-inner">
                      <div class="carousel-item active">
                        <div class="row">
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-4 mt-md-0">
                              <div class="icon icon-a text-white mr-3">
                                <i class="ti-cup icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Revenue</h3>
                                  <h3 class="mb-0">34040</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+34040</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">0.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-b text-white mr-3">
                                <i class="ti-bar-chart icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Sales</h3>
                                  <h3 class="mb-0">$9672471</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">-7.34567</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">2.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-c text-white mr-3">
                                <i class="ti-shopping-cart-full icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Purchases</h3>
                                  <h3 class="mb-0">6358</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+9082</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">35.54%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="carousel-item">
                        <div class="row">
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-4 mt-md-0">
                              <div class="icon icon-a text-white mr-3">
                                <i class="ti-cup icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Revenue</h3>
                                  <h3 class="mb-0">34040</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+34040</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">0.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-b text-white mr-3">
                                <i class="ti-bar-chart icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Sales</h3>
                                  <h3 class="mb-0">$9672471</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">-7.34567</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">2.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-c text-white mr-3">
                                <i class="ti-shopping-cart-full icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Purchases</h3>
                                  <h3 class="mb-0">6358</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+9082</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">35.54%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="carousel-item">
                        <div class="row">
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-4 mt-md-0">
                              <div class="icon icon-a text-white mr-3">
                                <i class="ti-cup icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Revenue</h3>
                                  <h3 class="mb-0">34040</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+34040</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">0.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-b text-white mr-3">
                                <i class="ti-bar-chart icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Sales</h3>
                                  <h3 class="mb-0">$9672471</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">-7.34567</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">2.036%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                          <div class="col-md-4 item">
                            <div class="d-flex flex-column flex-xl-row mt-5 mt-md-0">
                              <div class="icon icon-c text-white mr-3">
                                <i class="ti-shopping-cart-full icon-lg ml-3"></i>
                              </div>
                              <div class="content text-white">
                                <div class="d-flex flex-wrap align-items-center mb-2 mt-3 mt-xl-1">
                                  <h3 class="font-weight-light mr-2 mb-1">Purchases</h3>
                                  <h3 class="mb-0">6358</h3>
                                </div>
                                <div class="col-8 col-md-7 d-flex border-bottom border-info align-items-center justify-content-between px-0 pb-2 mb-3">
                                  <h5 class="mb-0">+9082</h5>
                                  <div class="d-flex align-items-center">
                                    <i class="ti-angle-down mr-2"></i>
                                    <h5 class="mb-0">35.54%</h5>
                                  </div>  
                                </div>
                                <p class="text-white font-weight-light pr-lg-2 pr-xl-5">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <a class="carousel-control-prev" href="#performanceOverview" role="button" data-slide="prev">
                      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                      <span class="sr-only">Previous</span>
                    </a>
                    <a class="carousel-control-next" href="#performanceOverview" role="button" data-slide="next">
                      <span class="carousel-control-next-icon" aria-hidden="true"></span>
                      <span class="sr-only">Next</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-7 grid-margin stretch-card">
              <div class="card">
                <div class="card-body">
                  <p class="card-title mb-0">Top Products</p>
                  <div class="table-responsive">
                    <table class="table table-striped table-borderless">
                      <thead>
                        <tr>
                          <th>Product</th>
                          <th>Price</th>
                          <th>Date</th>
                          <th>Status</th>
                        </tr>  
                      </thead>
                      <tbody>
                        <tr>
                          <td>Search Engine Marketing</td>
                          <td class="font-weight-bold">$362</td>
                          <td>21 Sep 2018</td>
                          <td class="font-weight-medium text-success">Completed</td>
                        </tr>
                        <tr>
                          <td>Search Engine Optimization</td>
                          <td class="font-weight-bold">$116</td>
                          <td>13 Jun 2018</td>
                          <td class="font-weight-medium text-success">Completed</td>
                        </tr>
                        <tr>
                          <td>Display Advertising</td>
                          <td class="font-weight-bold">$551</td>
                          <td>28 Sep 2018</td>
                          <td class="font-weight-medium text-warning">Pending</td>
                        </tr>
                        <tr>
                          <td>Pay Per Click Advertising</td>
                          <td class="font-weight-bold">$523</td>
                          <td>30 Jun 2018</td>
                          <td class="font-weight-medium text-warning">Pending</td>
                        </tr>
                        <tr>
                          <td>E-Mail Marketing</td>
                          <td class="font-weight-bold">$781</td>
                          <td>01 Nov 2018</td>
                          <td class="font-weight-medium text-danger">Cancelled</td>
                        </tr>
                        <tr>
                          <td>Referral Marketing</td>
                          <td class="font-weight-bold">$283</td>
                          <td>20 Mar 2018</td>
                          <td class="font-weight-medium text-warning">Pending</td>
                        </tr>
                        <tr>
                          <td>Social media marketing</td>
                          <td class="font-weight-bold">$897</td>
                          <td>26 Oct 2018</td>
                          <td class="font-weight-medium text-success">Completed</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-5 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<h4 class="card-title">To Do Lists</h4>
									<div class="list-wrapper pt-2">
										<ul class="d-flex flex-column-reverse todo-list todo-list-custom">
											<li>
												<div class="form-check form-check-flat">
													<label class="form-check-label">
														<input class="checkbox" type="checkbox">
														Meeting with Urban Team
													</label>
												</div>
												<i class="remove ti-close"></i>
											</li>
											<li class="completed">
												<div class="form-check form-check-flat">
													<label class="form-check-label">
														<input class="checkbox" type="checkbox" checked>
														Duplicate a project for new customer
													</label>
												</div>
												<i class="remove ti-close"></i>
											</li>
											<li>
												<div class="form-check form-check-flat">
													<label class="form-check-label">
														<input class="checkbox" type="checkbox">
														Project meeting with CEO
													</label>
												</div>
												<i class="remove ti-close"></i>
											</li>
											<li class="completed">
												<div class="form-check form-check-flat">
													<label class="form-check-label">
														<input class="checkbox" type="checkbox" checked>
														Follow up of team zilla
													</label>
												</div>
												<i class="remove ti-close"></i>
											</li>
											<li>
												<div class="form-check form-check-flat">
													<label class="form-check-label">
														<input class="checkbox" type="checkbox">
														Level up for Antony
													</label>
												</div>
												<i class="remove ti-close"></i>
											</li>
										</ul>
                  </div>
                  <div class="add-items d-flex mb-0 mt-2">
										<input type="text" class="form-control todo-list-input"  placeholder="Add new task">
										<button class="add btn btn-icon text-primary todo-list-add-btn bg-transparent"><i class="ti-location-arrow"></i></button>
									</div>
								</div>
							</div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
              <div class="card position-relative">
                <div class="card-body">
                  <p class="card-title">Detailed Reports</p>
                  <div id="" class="carousel slide detailed-report-carousel position-static pt-2" data-ride="carousel">
                    <div class="carousel-inner">
                      <div class="carousel-item active">
                        <div class="row">
                          <div class="col-md-12 col-xl-3 d-flex flex-column justify-content-center">
                            <div class="ml-xl-4">
                              <h1>$34040</h1>
                              <h3 class="font-weight-light mb-xl-4">North America</h3>
                              <p class="text-muted mb-2 mb-xl-0">The total number of sessions within the date range. It is the period time a user is actively engaged with your website, page or app, etc</p>
                            </div>  
                            </div>
                          <div class="col-md-12 col-xl-9">
                            <div class="row">
                              <div class="col-md-6">
                                <div class="table-responsive mb-3 mb-md-0">
                                  <table class="table table-borderless report-table">
                                    <tr>
                                      <td class="text-muted">Illinois</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-success" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">713</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Washington</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-warning" role="progressbar" style="width: 30%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">583</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Mississippi</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">924</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">California</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-primary" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">664</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Maryland</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-success" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">560</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Alaska</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">793</h5></td>
                                    </tr>
                                  </table>
                                </div>
                              </div>
                              <div class="col-md-6 mt-3">
                                <canvas id="north-america-chart"></canvas>
                                <div id="north-america-legend"></div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="carousel-item">
                        <div class="row">
                          <div class="col-md-12 col-xl-3 d-flex flex-column justify-content-center">
                            <div class="ml-xl-4">
                              <h1>$61321</h1>
                              <h3 class="font-weight-light mb-xl-4">South America</h3>
                              <p class="text-muted mb-2 mb-xl-0">It is the period time a user is actively engaged with your website, page or app, etc. The total number of sessions within the date range. </p>
                            </div>
                          </div>
                          <div class="col-md-12 col-xl-9">
                            <div class="row">
                              <div class="col-md-6">
                                <div class="table-responsive mb-3 mb-md-0">
                                  <table class="table table-borderless report-table">
                                    <tr>
                                      <td class="text-muted">Brazil</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-success" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">613</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Argentina</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-warning" role="progressbar" style="width: 30%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">483</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Peru</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">824</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Chile</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-primary" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">564</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Colombia</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-success" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">460</h5></td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">Uruguay</td>
                                      <td class="w-100 px-0">
                                        <div class="progress progress-md mx-4">
                                          <div class="progress-bar bg-danger" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                      </td>
                                      <td><h5 class="font-weight-bold mb-0">693</h5></td>
                                    </tr>
                                  </table>
                                </div>
                              </div>
                              <div class="col-md-6 mt-3">
                                <canvas id="south-america-chart"></canvas>
                                <div id="south-america-legend"></div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <a class="carousel-control-prev" href="#detailedReports" role="button" data-slide="prev">
                      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                      <span class="sr-only">Previous</span>
                    </a>
                    <a class="carousel-control-next" href="#detailedReports" role="button" data-slide="next">
                      <span class="carousel-control-next-icon" aria-hidden="true"></span>
                      <span class="sr-only">Next</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-4 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body">
                  <p class="card-title mb-0">Projects</p>
                  <div class="table-responsive">
                    <table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">Places</th>
                          <th class="border-bottom">Orders</th>
                          <th class="border-bottom">Users</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="text-muted pl-0">Kentucky</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">65</span>(2.15%)</p></td>
                          <td class="text-muted">65</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0">Ohio</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">54</span>(3.25%)</p></td>
                          <td class="text-muted">51</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0">Nevada</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">22</span>(2.22%)</p></td>
                          <td class="text-muted">32</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0">North Carolina</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">46</span>(3.27%)</p></td>
                          <td class="text-muted">15</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0">Montana</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">17</span>(1.25%)</p></td>
                          <td class="text-muted">25</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0">Nevada</td>
                          <td><p class="mb-0"><span class="font-weight-bold mr-2">52</span>(3.11%)</p></td>
                          <td class="text-muted">71</td>
                        </tr>
                        <tr>
                          <td class="text-muted pl-0 pb-0">Louisiana</td>
                          <td class="pb-0"><p class="mb-0"><span class="font-weight-bold mr-2">25</span>(1.32%)</p></td>
                          <td class="text-muted pb-0">14</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 stretch-card">
              <div class="row">
                <div class="col-md-12 grid-margin stretch-card">
                  <div class="card">
                    <div class="card-body">
                      <p class="card-title">Charts</p>
                      <div class="charts-data">
                        <div class="mt-3">
                          <p class="text-muted mb-0">Orders</p>
                          <div class="d-flex justify-content-between align-items-center">
                            <div class="progress progress-md flex-grow-1 mr-4">
                              <div class="progress-bar bg-success" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <p class="text-muted mb-0">5k</p>
                          </div>
                        </div>
                        <div class="mt-3">
                          <p class="text-muted mb-0">Users</p>
                          <div class="d-flex justify-content-between align-items-center">
                            <div class="progress progress-md flex-grow-1 mr-4">
                              <div class="progress-bar bg-success" role="progressbar" style="width: 35%" aria-valuenow="35" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <p class="text-muted mb-0">3k</p>
                          </div>
                        </div>
                        <div class="mt-3">
                          <p class="text-muted mb-0">Downloads</p>
                          <div class="d-flex justify-content-between align-items-center">
                            <div class="progress progress-md flex-grow-1 mr-4">
                              <div class="progress-bar bg-success" role="progressbar" style="width: 48%" aria-valuenow="48" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <p class="text-muted mb-0">992</p>
                          </div>
                        </div>
                        <div class="mt-3">
                          <p class="text-muted mb-0">Visitors</p>
                          <div class="d-flex justify-content-between align-items-center">
                            <div class="progress progress-md flex-grow-1 mr-4">
                              <div class="progress-bar bg-success" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <p class="text-muted mb-0">687</p>
                          </div>
                        </div>
                      </div>  
                    </div>
                  </div>
                </div>
                <div class="col-md-12 stretch-card grid-margin grid-margin-md-0">
                  <div class="card data-icon-card-primary">
                    <div class="card-body">
                      <p class="card-title text-white">Number of Meetings</p>                      
                      <div class="row">
                        <div class="col-8 text-white">
                          <h3>3404</h3>
                          <p class="text-white font-weight-light mb-0">The total number of sessions within the date range. It is the period time</p>
                        </div>
                        <div class="col-4 background-icon">
                          <i class="ti-calendar"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 stretch-card">
              <div class="card">
                <div class="card-body">
                  <p class="card-title">Notifications</p>
                  <ul class="icon-data-list">
                    <li>
                      <p class="text-primary mb-1">Isabella Becker</p>
                      <p class="text-muted">Sales dashboard have been created</p>
                      <small class="text-muted">9:30 am</small>
                    </li>
                    <li>
                      <p class="text-primary mb-1">Adam Warren</p>
                      <p class="text-muted">You have done a great job #TW11109872</p>
                      <small class="text-muted">10:30 am</small>
                    </li>
                    <li>
                      <p class="text-primary mb-1">Leonard Thornton</p>
                      <p class="text-muted">Sales dashboard have been created</p>
                      <small class="text-muted">11:30 am</small>
                    </li>
                    <li>
                      <p class="text-primary mb-1">George Morrison</p>
                      <p class="text-muted">Sales dashboard have been created</p>
                      <small class="text-muted">8:50 am</small>
                    </li>
                    <li>
                      <p class="text-primary mb-1">Ryan Cortez</p>
                      <p class="text-muted">Herbs are fun and easy to grow.</p>
                      <small class="text-muted">9:00 am</small>
                    </li>
                    
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- content-wrapper ends -->