<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : transMonitoring.jsp
	* @Description : 전송관리 모니터링
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.07.26     최초 생성
	*
	* author 윤정 매니저
	* since 2021.07.26
	*
	*/
%>

<script type="text/javascript">
	/* ********************************************************
	 * 화면 onload
	 ******************************************************** */
	$(window).ready(function(){
		//금일 날짜 setting
		fn_todaySetting();
	
		// 소스 chart init
		fn_src_chart_init();
	
		// 소스 snapshot init
		fn_src_snapshot_init();
	
		// 소스 streaming init
		fn_src_streaming_init();
	
		// 소스 connect setting info init
		fn_src_setting_info_init();
	
		// 소스 connect mapping table init
		fn_src_mapping_list_init();
	
		// 소스 connect init
		fn_src_connect_init();
	
		// 소스 error 리스트 init
		fn_src_error_init();
	
		// 타겟 connect 토픽 리스트 init
		fn_tar_topic_list_init();
		
		// 타겟 connect 리스트 init
		fn_tar_connect_init();
	
		// 타겟 error 리스트 init
		fn_tar_error_init();
	
		// 타겟 chart init
		fn_sink_chart_init();
	});

	/* ********************************************************
	 * 화면시작 오늘날짜 셋팅
 	******************************************************** */
	function fn_todaySetting() {
		today = new Date();
		var today_date = new Date();

		var today_ing = today.toJSON().slice(0,10).replace(/-/g,'-');
		var dayOfMonth = today.getDate();
		today_date.setDate(dayOfMonth - 7);

		var html = "<i class='fa fa-calendar menu-icon'></i> "+today_ing;

		$( "#tot_src_connect_his_today" ).append(html);	
		$( "#tot_src_error_his_today" ).append(html);	
		$( "#tot_tar_dbms_his_today" ).append(html);	
		$( "#tot_tar_connect_his_today" ).append(html);	
		$( "#tot_tar_error_his_today" ).append(html);	
	}

	function fn_srcConnectInfo() {
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		$.ajax({
			url : "/transSrcConnectInfo",
			dataType : "json",
			type : "post",
 			data : {
 				trans_id : selectValue,
 			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					$('#table_cnt').html(result.table_cnt);
					srcConnectSettingInfoTable.clear().draw();
					if (nvlPrmSet(result.connectInfo, '') != '') {
						srcConnectSettingInfoTable.rows.add(result.connectInfo).draw();
					}
					srcMappingListTable.clear().draw();
					if (nvlPrmSet(result.table_name_list, '') != '') {
						srcMappingListTable.rows.add(result.table_name_list).draw();
					}
					srcSnapshotTable.clear().draw();
					if (nvlPrmSet(result.snapshotInfo, '') != '') {
						srcSnapshotTable.rows.add(result.snapshotInfo).draw();
					}
				}
				
			}
		});
		
		
		
	}

</script>

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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-send"></i>
												<span class="menu-title">모니터링 </span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_transfer" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">모니터링</li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0">전송관리에서 등록한 소스 시스템과 타겟 시스템의  상태를 모니터링 할 수 있습니다.</p>
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
		
		
		<!-- 실시간 chart start -->
		<!-- cpu chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> CPU
					</h4>
				</div>
			</div>
		</div>
		<!-- cpu chart end -->
		
		<!-- memory chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> memory
					</h4>
				</div>
			</div>
		</div>
		<!-- memory chart end -->
		
		<!-- error chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> error
					</h4>
				</div>
			</div>
		</div>
		<!-- error chart end -->
		<!-- 실시간 chart end -->
		
		<!-- 연결 상태 그림 start -->
		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> 연결도
					</h4>
					
					<table class="table-borderless" style="width:100%;">
						<tr>
							<td>
								<div class="col-md-12 grid-margin stretch-card">
									<div class="card news_text">
										<div class="card-body">
											<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
												<table class="table-borderless" style="width:100%;height:100px;">
													<tr>
														<td colspan="2" style="width:85%">
															<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">
																<div class="badge badge-pill badge-success" title="">S</div>
																소스 시스템 명
															</h6>
														</td>
														<td rowspan="3" style="width:15%;">
															<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
														</td>
													</tr>
													<tr>
														<td colspan="2" style="padding-top:5px;">
															<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : 192.168.50.110/5432 </h6>
														</td>
													</tr>
													<tr>
														<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
															<h6 class="text-muted" style="padding-left:10px;">[DBMS 종류]</h6>
														</td>
													</tr>
												</table>
											</div>
										</div>
									</div>
								</div>
							</td>
							<td> 연결 화살표
							</td>
							<td>
								<div class="col-md-10 grid-margin stretch-card" style="margin-left:50px;">
									<div class="card">
										<div class="card-body">
											<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
												source connect <br/>
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-12" style="margin-right: 1rem;" name="src_connect" id="src_connect" onChange="fn_srcConnectInfo()" tabindex=1>
													<option value="">소스 Connector</option>
													<c:forEach var="srcConnectorList" items="${srcConnectorList}">
														<option value="${srcConnectorList.trans_id}">${srcConnectorList.connect_nm}</option>							
													</c:forEach>
												</select>
												: 연결 table 수<p id="table_cnt"></p> <br/>
												: 폴링 된 총 레코드 수  <br/>
												: 오류 수
											</div>
										</div>
									</div>
								</div>
							</td>
							<td>
								연결 화살표
							</td>							
							<td><i class="mdi mdi-cloud-sync menu-icon text-info" style="font-size: 3.0em;"></i>
							</td>
							<td> 
								연결 화살표
							</td>
							<td>
								<div class="col-md-10 grid-margin stretch-card">
									<div class="card">
										<div class="card-body">
											<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
												sink connect <br/>
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-4" style="margin-right: 1rem;" name="" id="" onChange="" tabindex=1>
													<option value="">타겟 Connector</option>
												</select>
												: 소스 연결 connect 수 / topic 수 <br/>
												: 완료 총 수 <br/>
												: 오류 수
											</div>
										</div>
									</div>
								</div>
							</td>
							<td>
								연결 화살표
							</td>
							<td> 						
								<div class="col-md-12 grid-margin stretch-card">
									<div class="card news_text">
										<div class="card-body">
											<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
												<table class="table-borderless" style="width:100%;height:100px;">
													<tr>
														<td colspan="2" style="width:85%">
															<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">
																<div class="badge badge-pill badge-success" title="">S</div>
																타겟 시스템 명
															</h6>
														</td>
														<td rowspan="3" style="width:15%;">
															<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
														</td>
													</tr>
													<tr>
														<td colspan="2" style="padding-top:5px;">
															<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : 192.168.50.171/1521 </h6>
														</td>
													</tr>
													<tr>
														<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
															<h6 class="text-muted" style="padding-left:10px;">[DBMS 종류]</h6>
														</td>
													</tr>
												</table>
											</div>
										</div>
									</div>
								</div>
							</td>
						</tr>
					</table>
			
				</div>
			</div>
		</div>
		<!-- 연결 상태 그림 end -->
		
		<!-- 소스 시스템 start -->
		<%@ include file="./transSourceMonitoring.jsp" %>
		<!-- 소스 시스템 end -->
		
		<!-- 타겟 시스템 start -->
		<%@ include file="./transTargetMonitoring.jsp" %>
		<!-- 타겟 시스템 end -->
		
	</div>
</div>