<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<%@include file="../../cmmn/commonLocaleTrans.jsp" %> 

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

<script src="/vertical-dark-sidebar/js/trans_monitoring.js"></script>

<script type="text/javascript">
	var cpuChart = "";
	var memChart = "";
	var allErrorChart = "";
	var connectorActTable = "";
	
	/* ********************************************************
	 * 화면 onload
	 ******************************************************** */
	$(window).ready(function(){
		//금일 날짜 setting
		fn_todaySetting();
		
		// cpu, memory error chart
		fn_cpu_mem_err_chart();
		
		// connector 기동정지 table init
		fn_connector_act_init();
		


		// 소스 chart init
// 		fn_src_chart_init();
	
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
	
	});

	/* ********************************************************
	 * connect 기동 정지 이력 테이블 setting
	 ******************************************************** */
	function fn_connector_act_init(){
		connectorActTable = $('#connectorActTable').DataTable({
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : '<spring:message code="message.msg01" />'
			},
			columns : [
				{data : "rownum", className : "dt-center", defaultContent : "", visible: false},
				{data : "connector_name", className : "dt-center", defaultContent : ""},
				{data : "act_type",							
					render : function(data, type, full, meta){
						var html = "";
							if(data == 'A'){
							html += '	<i class="fa fa-spinner fa-spin mr-2 icon-sm text-success"></i>';
							html += '	<spring:message code="eXperDB_proxy.act_start"/>';
						} else if(data == 'R') {
							html += '	<i class="fa fa-refresh fa-spin mr-2 icon-sm text-warning"></i>';
							html += '	<spring:message code="eXperDB_proxy.act_restart"/>';
						} else if(data == 'S'){
							html += '	<i class="fa fa-circle-o-notch mr-2 icon-sm text-danger"></i>';
							html += '	<spring:message code="eXperDB_proxy.act_stop"/>';
						}
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "wrk_dtm", className : "dt-center", defaultContent : "" },
			]
		});
		
		connectorActTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
		connectorActTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // time
		connectorActTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // number_of_events_filtered
		connectorActTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // number_of_erroneous_events
		
		$(window).trigger('resize');
	}

	function fn_srcConnectInfo() {
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		fn_tar_init();
		fn_src_init();
		
		if(selectValue != ""){
			$.ajax({
				url : "/transSrcConnectInfo.do",
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
						$('#ssconDBResultTable').show();
						$('#trans_monitoring_source_info').show();
						$('#trans_monitoring_target_info').show();
						if(result.connectInfo[0] != null && result.connectInfo[0] != undefined){
							$('#src_total_poll_cnt').html(result.connectInfo[0].source_record_poll_total);
							$('#src_total_error_cnt').html(result.connectInfo[0].total_record_errors);
							$('#ssconResultCntTable').show();
							$('#ssconResultCntTableNvl').hide();
						}
						$('#tar_connector_list').empty();
						$('#tar_connector_list').append('<option value=\"\">타겟 Connector</option>');
						if (nvlPrmSet(result.targetConnectorList, '') != '') {
							for (i = 0; i < result.targetConnectorList.length; i++) {
								if(i == 0){
									$('#tar_connector_list').append('<option selected value=\"'+result.targetConnectorList[i].trans_id+'\">'+result.targetConnectorList[i].connect_nm+'</option>');
									fn_tarConnectInfo();
								} else {
				                    $('#tar_connector_list').append('<option value=\"'+result.targetConnectorList[i].trans_id+'\">'+result.targetConnectorList[i].connect_nm+'</option>');
								}
			            	}
						}
						connectorActTable.clear().draw();
						if (nvlPrmSet(result.kafkaActCngList, '') != '') {
							connectorActTable.rows.add(result.kafkaActCngList).draw();
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
						$('#src-chart-line-1').empty();
						if(nvlPrmSet(result.sourceChart1, '') != '') {
							var srcChart1 = Morris.Line({
								element: 'src-chart-line-1',
								lineColors: ['#63CF72', '#FABA66','#F36368'],
								data: [
										{
											time: '',
											source_record_write_total : 0,
											source_record_poll_total : 0,
											source_record_active_count : 0,
										}
								],
								xkey: 'time',
								xkeyFormat: function(time) {
									return time.substring(10);
								},
								ykeys: ['source_record_write_total', 'source_record_poll_total', 'source_record_active_count'],
								labels: ['kafka에 기록된 레코드 수','폴링 된 총 레코드 수', 'kafka에 기록되지 않은 레코드 수']
							});
							srcChart1.setData(result.sourceChart1);
						}
						$('#src-chart-line-2').empty();
						if(nvlPrmSet(result.sourceChart2, '') != '') {
							var srcChart2 = Morris.Line({
								element: 'src-chart-line-2',
								lineColors: ['#63CF72', '#FABA66','#F36368'],
								data: [
										{
										time: '',
										source_record_write_rate : 0,
										source_record_active_count_avg : 0,
										}
								],
								xkey: 'time',
								xkeyFormat: function(time) {
									return time.substring(10);
								},
								ykeys: ['source_record_write_rate', 'source_record_active_count_avg'],
								labels: ['kafka에 기록된 초당 평균 레코드 수','kafka에 기록되지 않은 평균 레코드 수']
							});
							srcChart2.setData(result.sourceChart2);
						}
						$('#src-chart-line-error').empty();
						if(nvlPrmSet(result.sourceErrorChart, '') != '') {
							var srcErrorChart = Morris.Line({
								element: 'src-chart-line-error',
								lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
								data: [
										{
										time: '',
										total_record_errors: 0,
										total_record_failures: 0,
										total_records_skipped: 0,
										total_retries : 0
										}
								],
								xkey: 'time',
								xkeyFormat: function(time) {
									return time.substring(10);
								},
								ykeys: ['total_record_errors', 'total_record_failures', 'total_records_skipped', 'total_retries'],
								labels: ['오류 수', '레코드 처리 실패 수', '미처리 레코드 수', '재시도 작업 수']
							});
							srcErrorChart.setData(result.sourceErrorChart);
						}
						
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
// 						if (nvlPrmSet(result.sourceChart1, '') != '') {
// 							srcChart1.setData(result.sourceChart1);
// 						}
// 						if (nvlPrmSet(result.sourceChart2, '') != '') {
// 							srcChart2.setData(result.sourceChart2);
// 						}
						srcConnectTable.clear().draw();
						if (nvlPrmSet(result.sourceInfo, '') != '') {
							for(var i = 0; i < result.sourceInfo.length; i++){	
								if(result.sourceInfo[i].rownum == 1){
									if(i != result.sourceInfo.length-1 && result.sourceInfo[i+1].rownum == 2){
										result.sourceInfo[i].source_record_active_count_max_cng = result.sourceInfo[i].source_record_active_count_max - result.sourceInfo[i+1].source_record_active_count_max;
										result.sourceInfo[i].source_record_write_rate_cng = (result.sourceInfo[i].source_record_write_rate - result.sourceInfo[i+1].source_record_write_rate).toFixed(2);
										result.sourceInfo[i].source_record_active_count_avg_cng = (result.sourceInfo[i].source_record_active_count_avg - result.sourceInfo[i+1].source_record_active_count_avg).toFixed(2);
										result.sourceInfo[i].source_record_write_total_cng = result.sourceInfo[i].source_record_write_total - result.sourceInfo[i+1].source_record_write_total;
										result.sourceInfo[i].source_record_poll_total_cng = result.sourceInfo[i].source_record_poll_total - result.sourceInfo[i+1].source_record_poll_total;
										result.sourceInfo[i].source_record_active_count_cng = (result.sourceInfo[i].source_record_active_count - result.sourceInfo[i+1].source_record_active_count).toFixed(2);
									}
									srcConnectTable.row.add(result.sourceInfo[i]).draw();
								}
							}
// 							srcConnectTable.rows.add(result.sourceInfo).draw();
						}
// 						if (nvlPrmSet(result.sourceErrorChart, '') != '') {
// 							srcErrorChart.setData(result.sourceErrorChart);
// 						}
						srcErrorTable.clear().draw();
						if (nvlPrmSet(result.sourceErrorInfo, '') != '') {
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
		} else{
			$('#ssconResultCntTable').hide();
			$('#ssconResultCntTableNvl').show();
			$('#tar_connector_list').empty();
			$('#tar_connector_list').append('<option value=\"\">타겟 Connector</option>');
			fn_tarConnectInfo();
			$('#ssconDBResultTable').hide();
// 			srcConnectSettingInfoTable.clear().draw();
// 			srcMappingListTable.clear().draw();
// 			$('#src-chart-line-1').empty();
// 			$('#src-chart-line-2').empty();
// 			srcConnectTable.clear().draw();
// 			$('#src-chart-line-error').empty();
		}
		$("#loading").hide();
	}
	
	function fn_src_init(){
		$('#trans_monitoring_source_info').hide();
		$('#trans_monitoring_target_info').hide();
		$('#table_cnt').html("");
		$('#src_total_poll_cnt').html("");
		$('#src_total_error_cnt').html("");
		srcConnectSettingInfoTable.clear().draw();
		srcMappingListTable.clear().draw();
		$('#src-chart-line-1').empty();
		$('#src-chart-line-2').empty();
		srcConnectTable.clear().draw();
		$('#src-chart-line-error').empty();
		$('#src-chart-line-snapshot').empty();
		$('#src-chart-line-streaming').empty();
		$('#ssconDBResultTable').hide();
	}
	
	function fn_tar_init(){
		$('#topic_cnt').html("");
		$('#d_tg_connect_nm').text("");
		$('#d_tg_sys_nm').text("");
		$('#d_tg_dbms_type').text("");
		$('#d_tg_dbms_nm').text("");
		$('#d_tg_schema_nm').text("");
		
		$('#tar_connect_nm').text("");
		tarTopicListTable.clear().draw();
		tarConnectTable.clear().draw();
		$('#tar-chart-line-sink').empty();
		$('#tar-chart-line-complete').empty();
		$('#tar-chart-line-sink-error').empty();
		$('#skconResultTable').hide();
	}
	
	function fn_tarConnectInfo(){
		var langSelect = document.getElementById("tar_connector_list");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		fn_tar_init();
		if(selectValue != ""){
			$.ajax({
				url : "/transTarConnectInfo.do",
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
							$('#topic_cnt').html(result.topic_cnt);
							
							if(result.targetConnectInfo != null && result.targetConnectInfo != undefined){
								$('#tarconResultCntTableNvl').hide();
								$('#tarconResultCntTable').show();
								$('#sink_record_send_total').html(result.targetConnectInfo.sink_record_send_total);
								$('#tar_total_error').html(result.targetConnectInfo.total_record_errors);
								$('#skconResultTable').show();
							} else {
								$('#tarconResultCntTable').hide();
								$('#tarconResultCntTableNvl').show();
							}
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
// 						if (nvlPrmSet(result.targetSinkRecordChart, '') != '') {
// 							sinkChart.setData(result.targetSinkRecordChart);
// 						}
// 						if (nvlPrmSet(result.targetSinkCompleteChart, '') != '') {
// 							sinkCompleteChart.setData(result.targetSinkCompleteChart);
// 						}
						tarConnectTable.clear().draw();
						if (nvlPrmSet(result.targetSinkInfo, '') != '') {
							for(var i = 0; i < result.targetSinkInfo.length; i++){	
								if(result.targetSinkInfo[i].rownum == 1){
									if(i != result.targetSinkInfo.length-1 && result.targetSinkInfo[i+1].rownum == 2){
										result.targetSinkInfo[i].sink_record_active_count_cng = result.targetSinkInfo[i].sink_record_active_count - result.targetSinkInfo[i+1].sink_record_active_count;
										result.targetSinkInfo[i].put_batch_avg_time_ms_cng = result.targetSinkInfo[i].put_batch_avg_time_ms - result.targetSinkInfo[i+1].put_batch_avg_time_ms;
										result.targetSinkInfo[i].offset_commit_completion_rate_cng = (result.targetSinkInfo[i].offset_commit_completion_rate - result.targetSinkInfo[i+1].offset_commit_completion_rate).toFixed(2);
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
						fn_sink_chart_init(selectValue);
// 						if (nvlPrmSet(result.targetErrorChart, '') != '') {
// 							sinkErrorChart.setData(result.targetErrorChart);
// 						}
// 						tarErrorTable.clear().draw();
// 						if (nvlPrmSet(result.targetErrorInfo, '') != '') {
// 							console.log(result.targetErrorInfo)
// 							for(var i = 0; i < result.targetErrorInfo.length; i++){	
// 								if(result.targetErrorInfo[i].rownum == 1){
// 									if(i != result.targetErrorInfo.length-1 && result.targetErrorInfo[i+1].rownum == 2){
// 										result.targetErrorInfo[i].total_errors_logged_cng = result.targetErrorInfo[i].total_errors_logged - result.targetErrorInfo[i+1].total_errors_logged;
// 										result.targetErrorInfo[i].deadletterqueue_produce_requests_cng = result.targetErrorInfo[i].deadletterqueue_produce_requests - result.targetErrorInfo[i+1].deadletterqueue_produce_requests;
// 										result.targetErrorInfo[i].deadletterqueue_produce_failures_cng = result.targetErrorInfo[i].deadletterqueue_produce_failures - result.targetErrorInfo[i+1].deadletterqueue_produce_failures;
// 										result.targetErrorInfo[i].total_record_failures_cng = result.targetErrorInfo[i].total_record_failures - result.targetErrorInfo[i+1].total_record_failures;
// 										result.targetErrorInfo[i].total_records_skipped_cng = result.targetErrorInfo[i].total_records_skipped - result.targetErrorInfo[i+1].total_records_skipped;
// 										result.targetErrorInfo[i].total_record_errors_cng = result.targetErrorInfo[i].total_record_errors - result.targetErrorInfo[i+1].total_record_errors;
// 									}
// 									tarErrorTable.row.add(result.targetErrorInfo[i]).draw();
// 								}
// 							}
// 						}
					}

				}
			});
		} else {
			$('#tarconResultCntTable').hide();
			$('#tarconResultCntTableNvl').show();
			$('#skconResultTable').hide();
		}
		$("#loading").hide();
	}
	
	function fn_logView(type){
		var todayYN = 'N';
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
// 		if(date == 'today'){
// 			pry_svr_id = select_pry_svr_id;
// 			todayYN = 'Y';
// 		}
		var date = new Date().toJSON();
		
		var v_db_svr_id = $("#db_svr_id", "#transMonitoringForm").val();
		
		$.ajax({
			url : "/transLogView.do",
			type : 'post',
			data : {
				db_svr_id : v_db_svr_id,
				date : date,
			},
			success : function(result) {
				$("#connectorlog", "#transLogViewForm").html("");
				$("#dwLen", "#transLogViewForm").val("0");
				$("#fSize", "#transLogViewForm").val("");
				$("#log_line", "#transLogViewForm").val("1000");
				$("#type", "#transLogViewForm").val(type);
				$("#date", "#transLogViewForm").val(date);
// 				$("#aut_id", "#transLogViewForm").val(aut_id);
// 				$("#todayYN", "#transLogViewForm").val(todayYN);
				$("#todayYN", "#transLogViewForm").val("Y");
				$("#view_file_name", "#transLogViewForm").html("");
				$("#trans_id","#transLogViewForm").val(selectValue);
				if(type === 'connector'){
					dateCalenderSetting();
					$('#restart_btn').hide();
					$('#wrk_strt_dtm_div').show();
					$('.log_title').html(' Connector 로그');
				} else if(type === 'kafka'){
					$('#restart_btn').show();
					$('#wrk_strt_dtm_div').hide();
					$('.log_title').html(' Kafka 로그');
				}
				fn_transLogViewAjax();
				$('#pop_layer_log_view').modal("show");
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
			}
		});
	}

	
</script>

<!-- log 팝업 -->
<%@ include file="./../popup/transLogView.jsp" %>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/confirmForm.jsp"%>
		
<form name="transMonitoringForm" id="transMonitoringForm" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-send"></i>
												<span class="menu-title"><spring:message code="menu.monitoring" /></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.monitoring" /> </li>
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
					<div id="chart-allError" style="max-height:200px;"></div>
				</div>
			</div>
		</div>
		<!-- error chart end -->
		<!-- 실시간 chart end -->
		
		<!-- 연결 상태 그림 start -->
		<div class="col-8 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
<!-- 					<h4 class="card-title"> -->
<!-- 						<i class="item-icon fa fa-dot-circle-o"></i> 연결도 -->
<!-- 					</h4> -->
					
					<div class="row" id="reg_trans_title">
						<div class="accordion_main accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_ss_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">소스커넥터</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
											
						<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_ss_connect_server" >
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

						<div class="accordion_main col-2" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_kafka_server" >
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

						<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_sk_connect_server" >
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
											
						<div class="accordion_main accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_sk_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">싱크커넥터</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				
					<!-- proxy 데이터 있는 경우 -->	
					<div class="row" id="reg_trans_detail">
						<div class="accordion_cdc accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="border:none;" >
								<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="proxyMonitoringList">
									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:80%;" class="text-center" ">
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-12" style="margin-right: 1rem;" name="src_connect" id="src_connect" onChange="fn_srcConnectInfo()" onblur="this.value=this.value.trim()" tabindex=1>
													<option value="">소스 Connector</option>
													<c:forEach var="srcConnectorList" items="${srcConnectorList}">
														<option value="${srcConnectorList.trans_id}">${srcConnectorList.connect_nm}</option>							
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td style="width:80%;" class="text-center">
			 									<table id="ssconResultTable" class="table table-striped system-tlb-scroll" style="width:100%; border-bottom:1px solid;">
													<thead>
														<tr class="bg-info text-white">
															<th style="width:25%;font-size:12px;">테이블 수</th>
															<th style="width:37%;font-size:12px;">전체 완료 수</th>
															<th style="width:38%;font-size:12px;">오류 수</th>
														</tr>
														<tr id="ssconResultCntTableNvl" >
<!-- 															<td colspan="3" style="font-size:12px;"> -->
															<td colspan="3">
<%-- 																<spring:message code="message.msg01" /> --%>
																커넥터를 선택해주세요
															</td>
														</tr>
														<tr id="ssconResultCntTable" style="display:none;">
															<td style="text-align:center;font-size:12px;" id="table_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="src_total_poll_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="src_total_error_cnt"></td>
														</tr>
													</thead>
												</table>
											</td>
										</tr>
										
										<tr>
											<td style="width:80%;" class="text-center">
			 									<table id="ssconDBResultTable" class="table-borderless" style="width:100%; display:none;">
													<tr id="ssconDBResultCntTable">
														<td style="width:100%;">
															
															<table class="table-borderless" style="width:100%;text-align:left;">
																<tr>
																	<td colspan="2" style="width:85%;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">
																			<img src="../images/postgresql_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>
																			DB네임
																		</h6>
																	</td>
																	<td rowspan="3" style="width:15%;">
																		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
																	</td>
																</tr>
																
																<tr>
																	<td colspan="2" style="padding-top:5px;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : 192.168.50.11/5432</h6>
																	</td>
																</tr>

																<tr>
																	<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
																		<h6 class="text-muted" style="padding-left:10px;"><i class="fa fa-refresh fa-spin text-success icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>진행중</h6>
																	</td>
																</tr>
															</table>
															
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									
								</div>
							</div>
						</div>

						<div class="accordion_cdc accordion-multi-colored col-1" id="accordion" role="tablist" >
							<div class="card" style="margin-left:-10px;margin-right:-30px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyListnerConLineList">
								
									<table class="table-borderless" style="width:100%;margin-top:35px;">
										<tbody>
											<tr>
												<td style="margin-left:10px;" class="text-center" id="123">
													<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;width:120px;height:120px;" alt="">
												</td>
											</tr>
										</tbody>
									</table>

								</div>
							</div>
						</div>

						<div class="accordion_cdc_none accordion-multi-colored col-2" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;" >
								<div class="card-body" style="border:none;" id="proxyListnerMornitoringList">
								
									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:100%;height:100%;margin-left:-10px;" class="text-center" id="123">
												<i onClick="fn_logView('kafka')">
													<img src="../images/connector_icon.png" class="img-lg" style="max-width:140%;object-fit: contain;width:140px;height:140px;" alt="">
												</i>
												<h6 class="text-muted" style="padding-left:10px;"><i class="fa fa-refresh fa-spin text-success icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>진행중</h6>
												<!-- <i class="mdi mdi-cloud-sync menu-icon text-info" style="font-size: 8.0em;" onClick="fn_logView('kafka')"></i> -->
											</td>
										</tr>
									</table>
								
								<!-- 	<i class="mdi mdi-cloud-sync menu-icon text-info" style="font-size: 3.0em;" onClick="fn_logView('kafka')"></i> -->
								</div>
							</div>
						</div>
 																						
						<div class="accordion_cdc accordion-multi-colored col-1" id="accordion" role="tablist" >
							<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
								<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyListnerConLineList">
								
									<table class="table-borderless" style="width:100%;margin-top:35px;">
										<tr>
											<td style="width:100%;height:100%;" class="text-center" id="123">
												<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;width:120px;height:120px;" alt=""/>
											</td>
										</tr>
									</table>

								</div>
							</div>
						</div>

						<div class="accordion_cdc accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;" >
								<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="dbListenerVipList">

									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:80%;" class="text-center" ">
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-12" style="margin-right: 1rem;" name="tar_connector_list" id="tar_connector_list" onChange="fn_tarConnectInfo()" onblur="this.value=this.value.trim()"  tabindex=1>
													<option value="">타겟 Connector</option>
													<c:forEach var="tarConnectorList" items="${targetConnectorList}">
														<option value="${tarConnectorList.trans_id}">${tarConnectorList.connect_nm}</option>							
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td style="width:80%;" class="text-center">
			 									<table id="tarconResultTable" class="table table-striped system-tlb-scroll" style="width:100%; border-bottom:1px solid;">
													<thead>
														<tr class="bg-info text-white">
															<th style="width:25%;font-size:12px;">토픽 수</th>
															<th style="width:37%;font-size:12px;">전체 완료 수</th>
															<th style="width:38%;font-size:12px;">오류 수</th>
														</tr>
														<tr id="tarconResultCntTableNvl">
															<td colspan="3" >
<%-- 																<spring:message code="message.msg01" /> --%>
																커넥터를 선택해주세요
															</td>
														</tr>
														<tr id="tarconResultCntTable" style="display:none;">
															<td style="text-align:center;font-size:12px;" id="topic_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="sink_record_send_total"></td>
															<td style="text-align:center;font-size:12px;" id="tar_total_error"></td>
														</tr>
													</thead>
												</table>
											</td>
										</tr>
										
										<tr>
											<td style="width:80%;" class="text-center">
			 									<table id="skconResultTable" class="table-borderless" style="width:100%; display:none;">
													<tr id="skconResultCntTable" >
														<td style="width:100%;">
															
															
															<table class="table-borderless" style="width:100%;text-align:left;">
																<tr>
																	<td colspan="2" style="width:85%;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">
																			<!-- <div class="badge badge-pill badge-success" title="">M</div> -->
																			<img src="../images/oracle_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>
																			DB네임
																		</h6>
																	</td>
																	<td rowspan="3" style="width:15%;">
																		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
																	</td>
																</tr>
																
																<tr>
																	<td colspan="2" style="padding-top:5px;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : 192.168.50.11/5432</h6>
																	</td>
																</tr>

																<tr>
																	<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
																		<h6 class="text-muted" style="padding-left:10px;"><i class="fa fa-refresh fa-spin text-success icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>진행중</h6>
																	</td>
																</tr>
																
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title -->
				
					<!-- Connector 기동 정지 이력 -->
					<div class="row">
						<!-- title -->
						<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_serverlogging_div" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">Connector 기동 정지 이력</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<!-- connector 기동 정지 이력 리스트 -->
 						<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;">
								<div class="card-body" style="border:none;margin-top:-25px;margin-left:-25px;margin-right:-25px;">
									<div class="row">
										<div class="col-sm-8">
											<h6 class="mb-0 alert">
												<span class="menu-title text-success"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i>최근 3개 항목만 보여집니다.</span>
											</h6>
										</div>
										<div class="col-sm-4.5">
											<button class="btn btn-outline-primary btn-icon-text btn-sm btn-icon-text" type="button" id="connector_log_btn" onClick="fn_logView('connector')">
												<i class="mdi mdi-file-document"></i>
												connector로그
											</button>
										</div>
									</div>
 									<table id="connectorActTable" class="table table-striped system-tlb-scroll" style="width:100%;border:none;">
										<thead>
											<tr class="bg-info text-white">
												<th width="0px;">rownum</th>
												<th width="100px;">Connector 명</th>
												<th width="100px;">실행결과</th>
												<th width="100px;">시간</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div>
					<!-- connector 기동 정지 이력 리스트 end -->
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