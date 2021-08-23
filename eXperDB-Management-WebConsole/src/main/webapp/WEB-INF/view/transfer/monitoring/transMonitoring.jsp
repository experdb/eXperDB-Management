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
	var cpuChart = "";
	var memChart = "";
	/* ********************************************************
	 * 화면 onload
	 ******************************************************** */
	$(window).ready(function(){
		//금일 날짜 setting
		fn_todaySetting();
		
		// cpu, memory chart
		fn_cpu_mem_chart();
		
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
	
	function fn_cpu_mem_chart(){
		$.ajax({
			url : "/transMonitoringCpuMemList",
			dataType : "json",
			type : "post",
 			data : {
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
					cpuChart = Morris.Line({
				        element: 'chart-cpu',
				        // Tell Morris where the data is
				        data: result.processCpuList,
				        // Tell Morris which property of the data is to be mapped to which axis
				        xkey: 'time',
				        xLabelFormat: function(time) {
				        	return time.label.slice(10);
						},
				        ykeys: ['process_cpu_load', 'system_cpu_load'],
//			 	        postUnits: ' °c',
				        lineColors: ['#199cef','#FF0000'],
// 				        goals: [6.0],
// 				        goalLineColors: ['#FF0000'],
				        labels: ['process_cpu_load', 'system_cpu_load'],
				        lineWidth: 2,
				        parseTime: false,
				        hideHover: false,
				        pointSize: 0,
				        resize: true
					});
					
					memChart = Morris.Line({
				        element: 'chart-memory',
				        // Tell Morris where the data is
				        data: result.memoryList,
				        // Tell Morris which property of the data is to be mapped to which axis
				        xkey: 'time',
				        xLabelFormat: function(time) {
							return time.label.slice(10);
						},
				        ykeys: ['used'],
//			 	        postUnits: ' °c',
				        lineColors: ['#199cef'],
// 				        goals: [6.0],
// 				        goalLineColors: ['#FF0000'],
				        labels: ['used'],
				        lineWidth: 2,
				        parseTime: false,
				        hideHover: false,
				        pointSize: 0,
				        resize: true
					});
				}
			}
		});		
		setInterval(function() { 
			updateLiveTempGraph(cpuChart, memChart); 
		}, 5000);
	}
	
	function updateLiveTempGraph(cpuChart, memChart) {
		$.ajax({
			url : "/transMonitoringCpuMemList",
			dataType : "json",
			type : "post",
 			data : {
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
					cpuChart.setData(result.processCpuList);
					memChart.setData(result.memoryList);
				}
			}
		});		
	}
	
	function fn_src_init(){
		
	}
	
	function fn_srcConnectInfo() {
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		fn_tar_init();
		
		if(selectValue != ""){
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
						$('#tar_connector_list').empty();
						$('#tar_connector_list').append('<option value=\"\">타겟 Connector</option>');
						if (nvlPrmSet(result.targetConnectorList, '') != '') {
							for (i = 0; i < result.targetConnectorList.length; i++) {
			                    $('#tar_connector_list').append('<option value=\"'+result.targetConnectorList[i].trans_id+'\">'+result.targetConnectorList[i].connect_nm+'</option>');
			            	}
						}
						srcConnectSettingInfoTable.clear().draw();
						if (nvlPrmSet(result.connectInfo, '') != '') {
							srcConnectSettingInfoTable.rows.add(result.connectInfo).draw();
						}
						srcMappingListTable.clear().draw();
						if (nvlPrmSet(result.table_name_list, '') != '') {
							srcMappingListTable.rows.add(result.table_name_list).draw();
						}
						selectTab('snapshot');
// 						if (nvlPrmSet(result.snapshotChart, '') != '') {
// 							snapshotChart.setData(result.snapshotChart);
// 						}
// 						srcSnapshotTable.clear().draw();
// 						if (nvlPrmSet(result.snapshotInfo, '') != '') {
// 							for(var i = 0; i < result.snapshotInfo.length; i++){	
// 								if(result.snapshotInfo[i].rownum == 1){
// 									if(i != result.snapshotInfo.length-1 && result.snapshotInfo[i+1].rownum == 2){
// 										result.snapshotInfo[i].number_of_events_filtered_cng = result.snapshotInfo[i].number_of_events_filtered - result.snapshotInfo[i+1].number_of_events_filtered;
// 										result.snapshotInfo[i].number_of_erroneous_events_cng = result.snapshotInfo[i].number_of_erroneous_events - result.snapshotInfo[i+1].number_of_erroneous_events;
// 										result.snapshotInfo[i].queue_total_capacity_cng = result.snapshotInfo[i].queue_total_capacity - result.snapshotInfo[i+1].queue_total_capacity;
// 										result.snapshotInfo[i].queue_remaining_capacity_cng = result.snapshotInfo[i].queue_remaining_capacity - result.snapshotInfo[i+1].queue_remaining_capacity;
// 										result.snapshotInfo[i].remaining_table_count_cng = result.snapshotInfo[i].remaining_table_count - result.snapshotInfo[i+1].remaining_table_count;
// 									}
// 									srcSnapshotTable.row.add(result.snapshotInfo[i]).draw();
// 								}
// 							}
// // 							srcSnapshotTable.rows.add(result.snapshotInfo).draw();
// 						}
						console.log(result.sourceChart1)
						if (nvlPrmSet(result.sourceChart1, '') != '') {
							srcChart1.setData(result.sourceChart1);
						}
						if (nvlPrmSet(result.sourceChart2, '') != '') {
							srcChart2.setData(result.sourceChart2);
						}
						srcConnectTable.clear().draw();
						if (nvlPrmSet(result.sourceInfo, '') != '') {
							for(var i = 0; i < result.sourceInfo.length; i++){	
								if(result.sourceInfo[i].rownum == 1){
									if(i != result.sourceInfo.length-1 && result.sourceInfo[i+1].rownum == 2){
										result.sourceInfo[i].source_record_active_count_max_cng = result.sourceInfo[i].source_record_active_count_max - result.sourceInfo[i+1].source_record_active_count_max;
										result.sourceInfo[i].source_record_write_rate_cng = result.sourceInfo[i].source_record_write_rate - result.sourceInfo[i+1].source_record_write_rate;
										result.sourceInfo[i].source_record_active_count_avg_cng = result.sourceInfo[i].source_record_active_count_avg - result.sourceInfo[i+1].source_record_active_count_avg;
										result.sourceInfo[i].source_record_write_total_cng = result.sourceInfo[i].source_record_write_total - result.sourceInfo[i+1].source_record_write_total;
										result.sourceInfo[i].source_record_poll_total_cng = result.sourceInfo[i].source_record_poll_total - result.sourceInfo[i+1].source_record_poll_total;
										result.sourceInfo[i].source_record_active_count_cng = result.sourceInfo[i].source_record_active_count - result.sourceInfo[i+1].source_record_active_count;
									}
									srcConnectTable.row.add(result.sourceInfo[i]).draw();
								}
							}
// 							srcConnectTable.rows.add(result.sourceInfo).draw();
						}
						if (nvlPrmSet(result.sourceErrorChart, '') != '') {
							srcErrorChart.setData(result.sourceErrorChart);
						}
						srcErrorTable.clear().draw();
						if (nvlPrmSet(result.sourceErrorInfo, '') != '') {
							console.log(result.sourceErrorInfo)
							for(var i = 0; i < result.sourceErrorInfo.length; i++){	
								if(result.sourceErrorInfo[i].rownum == 1){
									if(i != result.sourceErrorInfo.length-1 && result.sourceErrorInfo[i+1].rownum == 2){
										result.sourceErrorInfo[i].total_errors_logged_cng = result.sourceErrorInfo[i].total_errors_logged - result.sourceErrorInfo[i+1].total_errors_logged;
										result.sourceErrorInfo[i].deadletterqueue_produce_requests_cng = result.sourceErrorInfo[i].deadletterqueue_produce_requests - result.sourceErrorInfo[i+1].deadletterqueue_produce_requests;
										result.sourceErrorInfo[i].deadletterqueue_produce_failures_cng = result.sourceErrorInfo[i].deadletterqueue_produce_failures - result.sourceErrorInfo[i+1].deadletterqueue_produce_failures;
										result.sourceErrorInfo[i].total_record_failures_cng = result.sourceErrorInfo[i].total_record_failures - result.sourceErrorInfo[i+1].total_record_failures;
										result.sourceErrorInfo[i].total_records_skipped_cng = result.sourceErrorInfo[i].total_records_skipped - result.sourceErrorInfo[i+1].total_records_skipped;
										result.sourceErrorInfo[i].total_record_errors_cng = result.sourceErrorInfo[i].total_record_errors - result.sourceErrorInfo[i+1].total_record_errors;
										result.sourceErrorInfo[i].total_retries_cng = result.sourceErrorInfo[i].total_retries - result.sourceErrorInfo[i+1].total_retries;
									}
									srcErrorTable.row.add(result.sourceErrorInfo[i]).draw();
								}
							}
// 							srcErrorTable.rows.add(result.sourceErrorInfo).draw();
						}
					}
				
				}
			});
		}
		$("#loading").hide();
	}
	
	function fn_tar_init(){
		$('#d_tg_connect_nm').text("");
		$('#d_tg_sys_nm').text("");
		$('#d_tg_dbms_type').text("");
		$('#d_tg_dbms_nm').text("");
		$('#d_tg_schema_nm').text("");
		
		$('#tar_connect_nm').text("");
		tarTopicListTable.clear().draw();
	}
	
	function fn_tarConnectInfo(){
		var langSelect = document.getElementById("tar_connector_list");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		fn_tar_init();
		console.log('tar : ' + langSelect.options[langSelect.selectedIndex].text);
		if(selectValue != ""){
			$.ajax({
				url : "/transTarConnectInfo",
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
						if (nvlPrmSet(result.targetDBMSInfo, '') != '') {
							$('#d_tg_connect_nm').text(langSelect.options[langSelect.selectedIndex].text);
							$('#d_tg_sys_nm').text(result.targetDBMSInfo[0].trans_sys_nm);
							$('#d_tg_dbms_type').text(result.targetDBMSInfo[0].dbms_type);
							$('#d_tg_dbms_nm').text(result.targetDBMSInfo[0].dtb_nm);
							$('#d_tg_schema_nm').text(result.targetDBMSInfo[0].scm_nm);
						}
						
						tarTopicListTable.clear().draw();
						if (nvlPrmSet(result.targetTopicList, '') != '') {
							$('#tar_connect_nm').text(langSelect.options[langSelect.selectedIndex].text);
							tarTopicListTable.rows.add(result.targetTopicList).draw();
						}
						if (nvlPrmSet(result.targetSinkRecordChart, '') != '') {
							sinkChart.setData(result.targetSinkRecordChart);
						}
						if (nvlPrmSet(result.targetSinkCompleteChart, '') != '') {
							sinkCompleteChart.setData(result.targetSinkCompleteChart);
						}
						tarConnectTable.clear().draw();
						if (nvlPrmSet(result.targetSinkInfo, '') != '') {
// 							tarConnectTable.rows.add(result.targetSinkInfo).draw();
							console.log(result.targetSinkInfo)
							for(var i = 0; i < result.targetSinkInfo.length; i++){	
								if(result.targetSinkInfo[i].rownum == 1){
									if(i != result.targetSinkInfo.length-1 && result.targetSinkInfo[i+1].rownum == 2){
										result.targetSinkInfo[i].sink_record_active_count_cng = result.targetSinkInfo[i].sink_record_active_count - result.targetSinkInfo[i+1].sink_record_active_count;
										result.targetSinkInfo[i].put_batch_avg_time_ms_cng = result.targetSinkInfo[i].put_batch_avg_time_ms - result.targetSinkInfo[i+1].put_batch_avg_time_ms;
										result.targetSinkInfo[i].offset_commit_completion_rate_cng = result.targetSinkInfo[i].offset_commit_completion_rate - result.targetSinkInfo[i+1].offset_commit_completion_rate;
										result.targetSinkInfo[i].sink_record_send_total_cng = result.targetSinkInfo[i].sink_record_send_total - result.targetSinkInfo[i+1].sink_record_send_total;
										result.targetSinkInfo[i].sink_record_active_count_avg_cng = result.targetSinkInfo[i].sink_record_active_count_avg - result.targetSinkInfo[i+1].sink_record_active_count_avg;
										result.targetSinkInfo[i].offset_commit_completion_total_cng = result.targetSinkInfo[i].offset_commit_completion_total - result.targetSinkInfo[i+1].offset_commit_completion_total;
										result.targetSinkInfo[i].offset_commit_skip_rate_cng = result.targetSinkInfo[i].offset_commit_skip_rate - result.targetSinkInfo[i+1].offset_commit_skip_rate;
										result.targetSinkInfo[i].offset_commit_skip_total_cng = result.targetSinkInfo[i].offset_commit_skip_total - result.targetSinkInfo[i+1].offset_commit_skip_total;
										result.targetSinkInfo[i].sink_record_read_total_cng = result.targetSinkInfo[i].sink_record_read_total - result.targetSinkInfo[i+1].sink_record_read_total;
									}
									tarConnectTable.row.add(result.targetSinkInfo[i]).draw();
								}
							}
						}
						if (nvlPrmSet(result.targetErrorChart, '') != '') {
							sinkErrorChart.setData(result.targetErrorChart);
						}
						tarErrorTable.clear().draw();
						if (nvlPrmSet(result.targetErrorInfo, '') != '') {
							console.log(result.targetErrorInfo)
							for(var i = 0; i < result.targetErrorInfo.length; i++){	
								if(result.targetErrorInfo[i].rownum == 1){
									if(i != result.targetErrorInfo.length-1 && result.targetErrorInfo[i+1].rownum == 2){
										result.targetErrorInfo[i].total_errors_logged_cng = result.targetErrorInfo[i].total_errors_logged - result.targetErrorInfo[i+1].total_errors_logged;
										result.targetErrorInfo[i].deadletterqueue_produce_requests_cng = result.targetErrorInfo[i].deadletterqueue_produce_requests - result.targetErrorInfo[i+1].deadletterqueue_produce_requests;
										result.targetErrorInfo[i].deadletterqueue_produce_failures_cng = result.targetErrorInfo[i].deadletterqueue_produce_failures - result.targetErrorInfo[i+1].deadletterqueue_produce_failures;
										result.targetErrorInfo[i].total_record_failures_cng = result.targetErrorInfo[i].total_record_failures - result.targetErrorInfo[i+1].total_record_failures;
										result.targetErrorInfo[i].total_records_skipped_cng = result.targetErrorInfo[i].total_records_skipped - result.targetErrorInfo[i+1].total_records_skipped;
										result.targetErrorInfo[i].total_record_errors_cng = result.targetErrorInfo[i].total_record_errors - result.targetErrorInfo[i+1].total_record_errors;
									}
									tarErrorTable.row.add(result.targetErrorInfo[i]).draw();
								}
							}
// 							tarErrorTable.rows.add(result.targetErrorInfo).draw();
						}
					}
				
				}
			});
		}
		$("#loading").hide();
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
					<div id="chart-cpu" style="max-height:200px;"></div>
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
					<div id="chart-memory" style="max-height:200px;"></div>
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
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-4" style="margin-right: 1rem;" name="tar_connector_list" id="tar_connector_list" onChange="fn_tarConnectInfo()" tabindex=1>
													<option value="">타겟 Connector</option>
<%-- 													<c:forEach var="tarConnectorList" items="${targetConnectorList}"> --%>
<%-- 														<option value="${tarConnectorList.trans_id}">${tarConnectorList.connect_nm}</option>							 --%>
<%-- 													</c:forEach> --%>
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