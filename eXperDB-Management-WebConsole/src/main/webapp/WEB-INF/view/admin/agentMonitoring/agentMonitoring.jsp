<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>
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
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="agent_monitoring.Management_agent" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.agent_monitoring" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="agent_monitoring.Management_agent"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.agent_monitoring_01" /></p>
											<p class="mb-0"><spring:message code="help.agent_monitoring_02" /></p>
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
						<div class="card-body" style="margin:-10px -10px -15px 0px;">
							<div class="form-inline row" onsubmit="return false;">

								<div class="input-group mb-2 mr-sm-2 col-sm-2_5">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="100" id="DB_SVR_NM" name="DB_SVR_NM" value="${db_svr_nm}" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.dbms_name" />'/>	
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2_5">
									<input type="text" class="form-control" maxlength="100" id="IPADR" name="IPADR" value="${ipadr}" onblur="this.value=this.value.trim()" placeholder='<spring:message code="dbms_information.dbms_ip" />'/>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-12 stretch-card div-form-margin-table">
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

								<table class="table table-hover table-striped">
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
										<tr class="bg-info text-white">
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
												<c:if test="${data.MASTER_GBN == 'M'}"><div class="badge badge-outline-primary badge-pill">master</div></c:if>
												<c:if test="${data.MASTER_GBN == 'S'}"><div class="badge badge-outline-info badge-pill">slave</div></c:if>
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
											<td style="text-align: center;">
												<div class="badge badge-outline-primary">${data.AGT_VERSION}</div>
											</td>
											<td style="text-align: center;">
											<c:if test="${data.AGT_CNDT_CD == 'TC001101'}">
												<div class='badge badge-pill badge-primary' >
													<i class='fa fa-spin fa-refresh mr-2' style="margin-right: 0px !important;"></i>
												</div>
											</c:if>
											<c:if test="${data.AGT_CNDT_CD == 'TC001102'}">
												<div class='badge badge-pill badge-danger'>
													<i class='fa fa-times-circle mr-2' style="margin-right: 0px !important;"></i>
												</div>
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
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>
</form>