<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : workLogList.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="bck"  id="bck">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
</form>


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
									<div class="col-5">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-check-square"></i>
												<span class="menu-title"><spring:message code="menu.backup_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.backup_history_01"/></p>
											<p class="mb-0"><spring:message code="help.backup_history_02"/></p>
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
					<ul class="nav nav-pills nav-pills-setting" id="server-tab" role="tablist">
						<li class="nav-item tab-two-style">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('rman');" >
								Online <spring:message code="menu.backup_history" />
							</a>
						</li>
						<li class="nav-item tab-two-style">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('dump');">
								Dump <spring:message code="menu.backup_history" />
							</a>
						</li>
					</ul>

					<!-- search param start -->
					<div class="card">
						<div class="card-body">

							<form class="form-inline">
								<div class="row">
									<div class="input-group mb-2 mr-sm-2">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="wrk_strt_dtm" name="wrk_strt_dtm" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
												
										<div class="input-group align-items-center">
											<span style="border:none; padding: 0px 10px;"> ~ </span>
										</div>
		
										<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="wrk_end_dtm" name="wrk_end_dtm" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
										
									<div class="input-group mb-2 mr-sm-2" style="padding:0 10px 0 10px;">
										<select class="form-control" style="width:200px;" name="exe_rslt_cd" id="exe_rslt_cd">
											<option value=""><spring:message code="common.status" />&nbsp;<spring:message code="schedule.total" /></option>
											<option value="1"><spring:message code="common.success" /></option>
											<option value="2"><spring:message code="common.failed" /></option>
										</select>
									</div>
										
									<div class="input-group mb-2 mr-sm-2 search_rman" style="padding-right:10px;">
										<select class="form-control" style="width:200px;" name="bck_opt_cd" id="bck_opt_cd">
											<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
											<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
											<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
										</select>
									</div>
									
									<div class="input-group mb-2 mr-sm-2 search_dump">
										<select class="form-control" style="width:200px;" name="db_id" id="db_id">
											<option value=""><spring:message code="common.database" />&nbsp;<spring:message code="schedule.total" /></option>
											<c:forEach var="result" items="${dbList}" varStatus="status">
													<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
											</c:forEach>
										</select>
									</div>

