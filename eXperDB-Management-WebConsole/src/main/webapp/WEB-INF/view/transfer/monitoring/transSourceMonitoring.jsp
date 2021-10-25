<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%
	/**
	* @Class Name : transSourceMonitoring.jsp
	* @Description : 전송관리 소스 시스템 모니터링
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

	var srcSnapshotTable = "";
	var srcStreamingTable = "";
	var srcConnectTable = "";
	var srcErrorTable = "";
	var srcMappingListTable = "";
	var snapshotChart = "";
	var streamingChart = "";
// 	var srcChart1 = "";
// 	var srcChart2 = "";
	var srcErrorChart = "";
	
	function fn_src_mapping_list_init(){
		srcMappingListTable = $('#srcMappingListTable').DataTable({
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
					{data : "schema_nm", className : "dt-center", defaultContent : ""}, 
					{data : "table_nm", className : "dt-center", defaultContent : ""},	
			]
		});
		
		srcMappingListTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // schema name
		srcMappingListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // table name
	
		$(window).trigger('resize');
	}
	
	function fn_src_setting_info_init(){
		srcConnectSettingInfoTable = $('#srcConnectSettingInfoTable').DataTable({
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
					{data : "connect_nm", className : "dt-center", defaultContent : ""}, 
					{data : "db_nm", className : "dt-center", defaultContent : ""},	
					{data : "meta_data", 
						render : function(data, type, full, meta){
							var html = "";
							html += '<div class="badge badge-pill badge-light" style="background-color: #EEEEEE;">';
							html += '	<i class="fa fa-power-off mr-2"></i>';
							html += '		' + data + '</div>';
							return html;
						}, 
						className : "dt-center", 
						defaultContent : ""
					},	
					{data : "snapshot_mode", className : "dt-center", defaultContent : ""},	
					{data : "compression_type", 
						render : function(data, type, full, meta){
							var html = "";
							html += '<div class="badge badge-light" style="background-color: transparent !important;">';
							html += '	<i class="fa fa-file-zip-o text-success mr-2"></i>';
							html += '		' + data + '</div>';
							return html;
						},
						className : "dt-center", 
						defaultContent : ""
					}	
			]
		});
		
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // connect name
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // database name
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // metadata
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // snapshot mode
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // compression type
	
		$(window).trigger('resize');
	}
	
	function fn_src_snapshot_init(){
		srcSnapshotTable = $('#srcSnapshotTable').DataTable({
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
				{data : "connector_src_name", className : "dt-center", defaultContent : ""},
				{data : "time", className : "dt-center", defaultContent : "" },
				{data : "number_of_events_filtered", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['number_of_events_filtered_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['number_of_events_filtered_cng']+')';
						} else if(full['number_of_events_filtered_cng'] == 0 || typeof full['number_of_events_filtered_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['number_of_events_filtered_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "number_of_erroneous_events", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['number_of_erroneous_events_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['number_of_erroneous_events_cng']+')';
						} else if(full['number_of_erroneous_events_cng'] == 0 || typeof full['number_of_erroneous_events_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['number_of_erroneous_events_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "queue_total_capacity", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['queue_total_capacity_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['queue_total_capacity_cng']+')';
						} else if(full['queue_total_capacity_cng'] == 0 || typeof full['queue_total_capacity_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['queue_total_capacity_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "queue_remaining_capacity", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['queue_remaining_capacity_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['queue_remaining_capacity_cng']+')';
						} else if(full['queue_remaining_capacity_cng'] == 0 || typeof full['queue_remaining_capacity_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['queue_remaining_capacity_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "remaining_table_count", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['remaining_table_count_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['remaining_table_count_cng']+')';
						} else if(full['remaining_table_count_cng'] == 0 || typeof full['remaining_table_count_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['remaining_table_count_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
			]
		});
		
		srcSnapshotTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // connector source name
		srcSnapshotTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // time
		srcSnapshotTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // number_of_events_filtered
		srcSnapshotTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // number_of_erroneous_events
		srcSnapshotTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // queue_total_capacity
		srcSnapshotTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // queue_remaining_capacity
		srcSnapshotTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // remaining_table_count
	
		$(window).trigger('resize');
	}
	
	function fn_src_streaming_init(){
		srcStreamingTable = $('#srcStreamingTable').DataTable({
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
				{data : "connector_src_name", className : "dt-center", defaultContent : ""},
				{data : "time", className : "dt-center", defaultContent : "" },
				{data : "last_transaction_id", className : "dt-center", defaultContent : "" },
				{data : "number_of_committed_transactions", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['number_of_committed_transactions_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['number_of_committed_transactions_cng']+')';
						} else if(full['number_of_committed_transactions_cng'] == 0 || typeof full['number_of_committed_transactions_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['number_of_committed_transactions_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "total_number_of_events_seen",  
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_number_of_events_seen_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_number_of_events_seen_cng']+')';
						} else if(full['total_number_of_events_seen_cng'] == 0 || typeof full['total_number_of_events_seen_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_number_of_events_seen_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "number_of_events_filtered",  
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['number_of_events_filtered_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['number_of_events_filtered_cng']+')';
						} else if(full['number_of_events_filtered_cng'] == 0 || typeof full['number_of_events_filtered_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['number_of_events_filtered_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "number_of_erroneous_events",  
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['number_of_erroneous_events_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['number_of_erroneous_events_cng']+')';
						} else if(full['number_of_erroneous_events_cng'] == 0 || typeof full['number_of_erroneous_events_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['number_of_erroneous_events_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "milli_seconds_since_last_event",  
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['milli_seconds_since_last_event_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['milli_seconds_since_last_event_cng']+')';
						} else if(full['milli_seconds_since_last_event_cng'] == 0 || typeof full['milli_seconds_since_last_event_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['milli_seconds_since_last_event_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
			]
		});
		
		srcStreamingTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // connector source name
		srcStreamingTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // time
		srcStreamingTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // last transaction id
		srcStreamingTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // number of committed transactions
		srcStreamingTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // total number of events
		srcStreamingTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // number of events filtered
		srcStreamingTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // number of erroneous events
		srcStreamingTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px'); // milliseconds since last event
	
		$(window).trigger('resize');
	}
	
	function fn_src_connect_init(){
		srcConnectTable = $('#srcConnectTable').DataTable({
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
				{data : "time", className : "dt-center", defaultContent : ""},
				{data : "source_record_active_count_max", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_active_count_max_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_active_count_max_cng']+')';
						} else if(full['source_record_active_count_max_cng'] == 0 || typeof full['source_record_active_count_max_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_active_count_max_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "source_record_write_rate", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_write_rate_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_write_rate_cng']+')';
						} else if(full['source_record_write_rate_cng'] == 0 || typeof full['source_record_write_rate_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_write_rate_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "source_record_active_count_avg", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_active_count_avg_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_active_count_avg_cng']+')';
						} else if(full['source_record_active_count_avg_cng'] == 0 || typeof full['source_record_active_count_avg_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_active_count_avg_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "source_record_write_total", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_write_total_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_write_total_cng']+')';
						} else if(full['source_record_write_total_cng'] == 0 || typeof full['source_record_write_total_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_write_total_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "source_record_active_count", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_active_count_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_active_count_cng']+')';
						} else if(full['source_record_active_count_cng'] == 0 || typeof full['source_record_active_count_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_active_count_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "source_record_poll_total", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['source_record_poll_total_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['source_record_poll_total_cng']+')';
						} else if(full['source_record_poll_total_cng'] == 0 || typeof full['source_record_poll_total_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['source_record_poll_total_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				}
			]
		});
		
		srcConnectTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // rownum
		srcConnectTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
		srcConnectTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // proxy server name
		srcConnectTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // success or fail
		srcConnectTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
		srcConnectTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
		srcConnectTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date
	
		$(window).trigger('resize');
	}
	
	function fn_src_error_init(){
		srcErrorTable = $('#srcErrorTable').DataTable({
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
				{data : "last_error_timestamp", className : "dt-center", defaultContent : ""},
				{data : "total_errors_logged", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_errors_logged_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_errors_logged_cng']+')';
						} else if(full['total_errors_logged_cng'] == 0 || typeof full['total_errors_logged_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_errors_logged_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "deadletterqueue_produce_requests", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['deadletterqueue_produce_requests_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['deadletterqueue_produce_requests_cng']+')';
						} else if(full['deadletterqueue_produce_requests_cng'] == 0 || typeof full['deadletterqueue_produce_requests_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['deadletterqueue_produce_requests_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "deadletterqueue_produce_failures", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['deadletterqueue_produce_failures_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['deadletterqueue_produce_failures_cng']+')';
						} else if(full['deadletterqueue_produce_failures_cng'] == 0 || typeof full['deadletterqueue_produce_failures_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['deadletterqueue_produce_failures_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "total_record_failures", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_record_failures_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_record_failures_cng']+')';
						} else if(full['total_record_failures_cng'] == 0 || typeof full['total_record_failures_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_record_failures_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "total_records_skipped", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_records_skipped_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_records_skipped_cng']+')';
						} else if(full['total_records_skipped_cng'] == 0 || typeof full['total_records_skipped_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_records_skipped_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "total_record_errors", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_record_errors_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_record_errors_cng']+')';
						} else if(full['total_record_errors_cng'] == 0 || typeof full['total_record_errors_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_record_errors_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
				{data : "total_retries", 
					render: function(data, type, full, meta){
						var html = "";
						html += '<div>' + data;
						if(full['total_retries_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['total_retries_cng']+')';
						} else if(full['total_retries_cng'] == 0 || typeof full['total_retries_cng'] === 'undefined'){
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['total_retries_cng']+')';
						}
						html += '</div>';
						return html;
					},
					className : "dt-center", 
					defaultContent : "" 
				},
			]
		});
		srcErrorTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
		srcErrorTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
		srcErrorTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // proxy server name
		srcErrorTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // success or fail
		srcErrorTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
		srcErrorTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
		srcErrorTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date
		srcErrorTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px'); // first reg date
		srcErrorTable.tables().header().to$().find('th:eq(8)').css('min-width', '100px'); // first reg date
	
		$(window).trigger('resize');
	}
	
	/* ********************************************************
	* TAB 선택 이벤트 
	******************************************************** */
	function selectTab(tab){	
		if(tab == "snapshot"){
			$(".snapshotDiv").show();
			$(".streamingDiv").hide();
			fn_snapshot();
		}else{
			$(".snapshotDiv").hide();
			$(".streamingDiv").show();

			fn_streaming();
		}
	}
	
	function fn_src_chart_init(){
		
		srcChart1 = Morris.Line({
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
		
		srcChart2 = Morris.Line({
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
		
		srcErrorChart = Morris.Line({
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
		
	}
	
	function fn_snapshot(){
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		$('#src-chart-line-snapshot').empty();
		
		if(selectValue != ""){
			$.ajax({
				url : "/transSrcSnapshotInfo.do",
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
						if (nvlPrmSet(result.snapshotChart, '') != '') {
							var snapshotChart = Morris.Line({
								element: 'src-chart-line-snapshot',
								lineColors: ['#63CF72', '#FABA66',],
								data: [
										{
										time: '',
										number_of_events_filtered : 0,
										number_of_erroneous_events : 0,
										}
								],
								xkey: 'time',
								xkeyFormat: function(time) {
									return time.substring(10);
								},
								ykeys: ['number_of_events_filtered', 'number_of_erroneous_events'],
								labels: ['필터링 된 이벤트 수', '오류 난 이벤트 수']
							});
							snapshotChart.setData(result.snapshotChart);
						}
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
// 						}
					}
				}
			});
		} 
		$("#loading").hide();
	}
	
	function fn_streaming(){
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;

		$('#src-chart-line-streaming').empty();
		
		if(selectValue != ""){
			$.ajax({
				url : "/transSrcStreamingInfo.do",
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
						if (nvlPrmSet(result.streamingChart, '') != '') {
							var streamingChart = Morris.Line({
								element: 'src-chart-line-streaming',
								lineColors: ['#63CF72', '#FABA66','#F36368'],
								data: [
										{
										time: '',
										total_number_of_events_seen : 0,
										number_of_events_filtered : 0,
										number_of_erroneous_events : 0,
										}
								],
								xkey: 'time',
								xkeyFormat: function(time) {
									return time.substring(10);
								},
								ykeys: ['total_number_of_events_seen', 'number_of_events_filtered', 'number_of_erroneous_events'],
								labels: ['이벤트 총 수','필터링 된 이벤트 수', '오류 난 이벤트 수']
							});
							streamingChart.setData(result.streamingChart);
						}
// 						srcStreamingTable.clear().draw();
// 						if (nvlPrmSet(result.streamingInfo, '') != '') {
// 							for(var i = 0; i < result.streamingInfo.length; i++){	
// 								if(result.streamingInfo[i].rownum == 1){
// 									if(i != result.streamingInfo.length-1 && result.streamingInfo[i+1].rownum == 2){
// 										result.streamingInfo[i].number_of_committed_transactions_cng = result.streamingInfo[i].number_of_committed_transactions - result.streamingInfo[i+1].number_of_committed_transactions;
// 										result.streamingInfo[i].total_number_of_events_seen_cng = result.streamingInfo[i].total_number_of_events_seen - result.streamingInfo[i+1].total_number_of_events_seen;
// 										result.streamingInfo[i].number_of_events_filtered_cng = result.streamingInfo[i].number_of_events_filtered - result.streamingInfo[i+1].number_of_events_filtered;
// 										result.streamingInfo[i].number_of_erroneous_events_cng = result.streamingInfo[i].number_of_erroneous_events - result.streamingInfo[i+1].number_of_erroneous_events;
// 										result.streamingInfo[i].milli_seconds_since_last_event_cng = result.streamingInfo[i].milli_seconds_since_last_event - result.streamingInfo[i+1].milli_seconds_since_last_event;
// 									}
// 									srcStreamingTable.row.add(result.streamingInfo[i]).draw();
// 								}
// 							}
// 						}
					}
				}
			});
		}
		$("#loading").hide();
	}
	
</script>

<div class="col-lg-6 grid-margin stretch-card" id="trans_monitoring_source_info" style="display:none;">
	<div class="card">
		<div class="card-body">
			<h4 class="card-title">
				<i class="item-icon fa fa-dot-circle-o"></i> 소스 시스템
			</h4>

			<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
				<li class="nav-item">
					<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('snapshot');" >
						snapshot
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('streaming');">
						streaming
					</a>
				</li>
			</ul>

			<div class="tab-content" id="pills-tabContent" style="border:none;">
				<div class="tab-pane fade show active snapshotDiv" style="margin-top:-30px;" role="tabpanel" id="subTab-1">
					<p class="card-title" style="margin-bottom:0px;">
						<i class="item-icon mdi mdi-snapchat text-info"></i>&nbsp;snapshot
					</p>
					<div id="src-chart-line-snapshot" style="height:170px;"></div>
				</div>
				<div class="tab-pane fade streamingDiv" style="margin-top:-30px;" role="tabpanel" id="subTab-2">	
					<p class="card-title" style="margin-bottom:0px;">
						<i class="item-icon mdi mdi-access-point text-info"></i>&nbsp;streaming
					</p>
					<div id="src-chart-line-streaming" style="height:170px;"></div>
				</div>
			</div>

			<div class="accordion_main accordion-multi-colored " id="accordion_src_connect_his" role="tablist">
				<div class="card " style="margin-bottom:0px;">
					<div class="card-header" role="tab" id="src_connect_header_div">
						<div class="row" style="height: 15px;">
							<div class="col-6">
								<h6 class="mb-0">
									<a data-toggle="collapse" href="#src_connect_header_sub" aria-expanded="true" aria-controls="src_connect_header_sub" onclick="fn_profileChk('SrcConnectTitleText')">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span class="menu-title">Connect 정보</span>
										<i class="menu-arrow_user_af" id="SrcConnectTitleText" ></i>
									</a>
								</h6>
							</div>
							<div class="col-6">
								<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
									<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_src_connect_his_today"></li>
								</ol>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- connect title end -->
			
			<!-- connect info start -->
			<div id="src_connect_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="src_connect_header_div" data-parent="#accordion_src_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center" >
					<div class="card " style="margin-bottom:0px;border:none;">
						<div class="card-body" style="border:none; box-shadow: 0px 1px 7px 1px rgba(211, 211, 211, 2);margin-bottom:8px;">
							<div class="form-group row" style="margin-bottom:-20px;margin-top:-20px;">
								<label class="col-sm-12 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									connect 설정 정보
								</label>
							</div>
							
							<div class="form-group row" style="margin-bottom:-10px;">
								<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
									<div class="card" style="border:0px;">
										<div class="card-body" style="padding-left:0px;padding-right:0px;">	
									 		<table id="srcConnectSettingInfoTable" class="table table-hover system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="100" class="dt-center" >connect명</th>
														<th width="500" class="dt-center" >데이터베이스</th>	
														<th width="500" class="dt-center" >메타데이터여부</th>	
														<th width="500" class="dt-center" >스냅샷여부</th>	
														<th width="500" class="dt-center" >압축형태</th>	
													</tr>
												</thead>
	<!-- 											<tbody> -->
	<!-- 												<tr> -->
	<!-- 													<td>inventory-connector -->
	<!-- 													</td> -->
	<!-- 													<td>inventory</td> -->
	<!-- 													<td> -->
	<!-- 														<div class="badge badge-pill badge-light" style="background-color: #EEEEEE;">	 -->
	<!-- 															<i class="fa fa-power-off mr-2"></i> -->
	<!-- 															OFF -->
	<!-- 														</div> -->
	<!-- 													</td> -->
	<!-- 													<td>NEVER </td> -->
	<!-- 													<td> -->
	<!-- 														<div class="badge badge-light" style="background-color: transparent !important;">	 -->
	<!-- 															<i class="fa fa-file-zip-o text-success mr-2"></i>GZIP -->
	<!-- 														</div> -->
	<!-- 													</td> -->
	<!-- 												</tr> -->
	<!-- 											</tbody> -->
											</table>
										</div>
									</div>
								</div>
							</div>
							<br/>
							<div class="form-group row" style="margin-bottom:-20px;">
								<label class="col-sm-12 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="data_transfer.transfer_table" />
								</label>
							</div>
							
							<div class="form-group row" style="margin-bottom:-10px;">
								<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
									<div class="card" style="border:0px;">
										<div class="card-body" style="padding-left:0px;padding-right:0px;">	
									 		<table id="srcMappingListTable" class="table table-hover system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="100" class="dt-center" >스키마명</th>
														<th width="500" class="dt-center" >테이블명</th>	
													</tr>
	<!-- 											</thead> -->
	<!-- 											<tbody> -->
	<!-- 												<tr> -->
	<!-- 													<td>experdb</td> -->
	<!-- 													<td>dumb_table</td> -->
	<!-- 												</tr> -->
	<!-- 											</tbody> -->
											</table>
										</div>
									</div>
								</div>
							</div>
									
						</div>
					</div>
				</div>
			</div>
			<!-- connect info end -->

			<div id="src_connect_header_sub_list" class="collapse show row" role="tabpanel" aria-labelledby="src_connect_header_div" data-parent="#accordion_src_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<p class="card-title" style="margin-bottom:5px;margin-left:10px;">
								<i class="item-icon fa fa-bar-chart-o text-info"></i>
								&nbsp;connect 실시간 차트
<!-- 								<i class="fa fa-bar-chart-o menu-icon text-info"></i> -->
<!-- 								connect 실시간 차트 -->
							</p>
						</div>
					</div>
				</div>

				<!-- chart 1 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon mdi mdi-chart-line text-info"></i>&nbsp;실시간 전송 레코드
							</p>
							<div id="src-chart-line-1" style="height:200px;"></div>
						</div>
					</div>
				</div>
				
				<!-- chart 2 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon mdi mdi-chart-areaspline text-info"></i>&nbsp;평균 전송 레코드
							</p>
							<div id="src-chart-line-2" style="height:200px;"></div>
						</div>
					</div>
				</div>

				<!-- connect 리스트 -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;margin-top:-30px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="srcConnectTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">time</th>
										<th width="100px;">커넥터 미기록 최대 레코드 수</th>
										<th width="100px;">커넥터 기록된 평균 레코드 수 </th>
										<th width="100px;">커넥터 미기록 평균 레코드 수<</th>
										<th width="100px;">커넥터 기록된 레코드 수 </th>
										<th width="100px;">커넥터 미기록 레코드 수 </th>
										<th width="100px;">폴링 총 레코드 수</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- connect 정보 end -->

			<!-- error 정보 start -->
			<div class="accordion_main accordion-multi-colored" id="accordion_src_error_his" role="tablist">
				<div class="card" style="margin-bottom:0px;">
					<div class="card-header" role="tab" id="src_error_header_div">
						<div class="row" style="height: 15px;">
							<div class="col-6">
								<h6 class="mb-0">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<span class="menu-title">Error 정보</span>
								</h6>
							</div>
							<div class="col-6">
								<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
									<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_src_error_his_today"></li>
								</ol>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- error chart -->
			<div class="col-md-12 col-xl-12 justify-content-center">
				<div class="card" style="margin-left:-20px;border:none;">
					<div class="card-body" style="border:none;">
						<div id="src-chart-line-error" style="max-height:200px;"></div>
					</div>
				</div>
			</div>

			<!-- error 리스트 -->
<!-- 			<div class="col-md-12 col-xl-12 justify-content-center"> -->
<!-- 				<div class="card" style="margin-left:-10px;border:none;"> -->
<!-- 					<div class="card-body" style="border:none;"> -->
<!-- 						<table id="srcErrorTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;"> -->
<!-- 							<thead class="bg-info text-white"> -->
<!-- 								<tr> -->
<!-- 									<th width="0px;">rownum</th> -->
<!-- 									<th width="100px;">last_error_timestamp </th> -->
<!-- 									<th width="100px;">total_errors_logged </th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_requests</th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_failures </th> -->
<!-- 									<th width="100px;">total_record_failures</th> -->
<!-- 									<th width="100px;">total_records_skipped </th> -->
<!-- 									<th width="100px;">total_record_errors</th> -->
<!-- 									<th width="100px;">total_retries</th> -->
<!-- 								</tr> -->
<!-- 							</thead> -->
<!-- 						</table> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
				
			<!-- error 정보 end -->
		</div>
	</div>
</div>
