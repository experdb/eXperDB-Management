$(window).ready(function(){
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

/* ********************************************************
 * CPU / MEM / ERROR 차트
 * ******************************************************** */
function fn_cpu_mem_err_chart(){
	$.ajax({
		url : "/transMonitoringCpuMemList.do",
		dataType : "json",
		type : "post",
			data : {
			},
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
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
					xLabels: 'day',
					xLabelFormat: function(time) {
						return time.label.slice(10);
					},
					ykeys: ['process_cpu_load', 'system_cpu_load'],
					lineColors: ['#199cef','#FF0000'],
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
					lineColors: ['#199cef'],
					labels: ['used'],
					lineWidth: 2,
					parseTime: false,
					hideHover: false,
					pointSize: 0,
					resize: true
				});
				
				allErrorChart = Morris.Line({
					element: 'chart-allError',
					// Tell Morris where the data is
					data: result.allErrorList,
					// Tell Morris which property of the data is to be mapped to which axis
					xkey: 'time',
					xLabelFormat: function(time) {
						return time.label.slice(10);
					},
					ykeys: ['src_total_record_errors', 'tar_total_record_errors'],
					lineColors: ['#FABA66','#F36368'],
					labels: ['소스 error', '타겟 error'],
					lineWidth: 2,
					parseTime: false,
					hideHover: false,
					pointSize: 0,
					resize: true
				});
			}
		}
	});
	$('#loading').hide();

	setInterval(function() { 
		updateLiveTempGraph(cpuChart, memChart, allErrorChart); 
	}, 5000);
}

/* ********************************************************
 * CPU / MEM 차트 조회
 * ******************************************************** */
function updateLiveTempGraph(cpuChart, memChart, allErrorChart) {
	$.ajax({
		url : "/transMonitoringCpuMemList.do",
		dataType 	: "json",
		type : "post",
			data : {
			},
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if (result != null) {
				cpuChart.setData(result.processCpuList);
				memChart.setData(result.memoryList);
				allErrorChart.setData(result.allErrorList);
				
				//로그 기록 테이블 설정
//				connectorActTable.clear().draw();
//				if (nvlPrmSet(result.connectorActLogList, '') != '') {
//					connectorActTable.rows.add(result.connectorActLogList).draw();
//				}
				$('#proxyLog').css('min-height','100px');
			}
		}
	});	
	$('#loading').hide();
}

/* ********************************************************
* load bar 추가
******************************************************** */
function fn_trans_loadbar(gbn){
	var htmlLoad_trans = '<div id="loading_trans"><div class="flip-square-loader mx-auto" style="border: 0px !important;z-index:99999;"></div></div>';
	if($("#loading_trans").length == 0)	$("#contentsDiv").append(htmlLoad_trans);
	
	if (gbn == "start") {
	      $('#loading_trans').css('position', 'absolute');
	      $('#loading_trans').css('left', '50%');
	      $('#loading_trans').css('top', '50%');
	      $('#loading_trans').css('transform', 'translate(-50%,-50%)');	  
	      $('#loading_trans').show();	
	} else {
		$('#loading_trans').hide();	
	}
}

/* ********************************************************
* 소스시스템 connect 정보 - 설정정보 리스트 조회
******************************************************** */
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
			"emptyTable" : message_msg01
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

/* ********************************************************
* 소스시스템 connect 정보 - 전송대상 테이블 리스트 조회
******************************************************** */
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
			"emptyTable" : message_msg01
		},
		columns : [
				{data : "schema_nm", className : "dt-center", defaultContent : ""}, 
				{data : "table_nm", className : "dt-left", defaultContent : ""},	
		]
	});
	
	srcMappingListTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // schema name
	srcMappingListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // table name

	$(window).trigger('resize');
}

/* ********************************************************
* 소스시스템 connect - 실시간 리스트 조회
******************************************************** */
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
			"emptyTable" : message_msg01
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

/* ********************************************************
* 타겟시스템 connect - 전송대상 토픽리스트 조회
******************************************************** */
function fn_tar_topic_list_init(){
	tarTopicListTable = $('#tarTopicListTable').DataTable({
		searching : false,
		scrollY : true,
		scrollX: true,	
		paging : false,
		deferRender : true,
		info : false,
		sort: false, 
		"language" : {
			"emptyTable" : message_msg01
		},
		columns : [
				{data : "rownum", className : "dt-center", defaultContent : ""}, 
				{data : "topic_name", className : "dt-center", defaultContent : ""}	
		]
	});
	
	tarTopicListTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
	tarTopicListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id

	$(window).trigger('resize');
}

/* ********************************************************
* 타겟시스템 connect - 실시간리스트 조회
******************************************************** */
function fn_tar_connect_init(){
	tarConnectTable = $('#tarConnectTable').DataTable({
		searching : false,
		scrollY : true,
		scrollX: true,	
		paging : false,
		deferRender : true,
		info : false,
		sort: false, 
		"language" : {
			"emptyTable" : message_msg01
		},
		columns : [
//				{data : "rownum", className : "dt-center", defaultContent : "", visible: false},
			{data : "time", className : "dt-center", defaultContent : ""},
			{data : "sink_record_active_count", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['sink_record_active_count_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['sink_record_active_count_cng']+')';
					} else if(full['sink_record_active_count_cng'] == 0 || typeof full['sink_record_active_count_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['sink_record_active_count_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "put_batch_avg_time_ms", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['put_batch_avg_time_ms_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['put_batch_avg_time_ms_cng']+')';
					} else if(full['put_batch_avg_time_ms_cng'] == 0 || typeof full['put_batch_avg_time_ms_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['put_batch_avg_time_ms_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "offset_commit_completion_rate", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['offset_commit_completion_rate_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['offset_commit_completion_rate_cng']+')';
					} else if(full['offset_commit_completion_rate_cng'] == 0 || typeof full['offset_commit_completion_rate_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['offset_commit_completion_rate_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "sink_record_send_total", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['sink_record_send_total_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['sink_record_send_total_cng']+')';
					} else if(full['sink_record_send_total_cng'] == 0 || typeof full['sink_record_send_total_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['sink_record_send_total_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "sink_record_active_count_avg", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['sink_record_active_count_avg_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['sink_record_active_count_avg_cng']+')';
					} else if(full['sink_record_active_count_avg_cng'] == 0 || typeof full['sink_record_active_count_avg_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['sink_record_active_count_avg_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "offset_commit_completion_total", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['offset_commit_completion_total_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['offset_commit_completion_total_cng']+')';
					} else if(full['offset_commit_completion_total_cng'] == 0 || typeof full['offset_commit_completion_total_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['offset_commit_completion_total_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "offset_commit_skip_rate", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['offset_commit_skip_rate_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['offset_commit_skip_rate_cng']+')';
					} else if(full['offset_commit_skip_rate_cng'] == 0 || typeof full['offset_commit_skip_rate_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['offset_commit_skip_rate_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "offset_commit_skip_total", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['offset_commit_skip_total_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['offset_commit_skip_total_cng']+')';
					} else if(full['offset_commit_skip_total_cng'] == 0 || typeof full['offset_commit_skip_total_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['offset_commit_skip_total_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
			{data : "sink_record_read_total", 
				render: function(data, type, full, meta){
					var html = "";
					html += '<div>' + data;
					if(full['sink_record_read_total_cng'] > 0){
						html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['sink_record_read_total_cng']+')';
					} else if(full['sink_record_read_total_cng'] == 0 || typeof full['sink_record_read_total_cng'] === 'undefined'){
						html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)';
					} else {
						html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['sink_record_read_total_cng']+')';
					}
					html += '</div>';
					return html;
				},
				className : "dt-center", 
				defaultContent : "" 
			},
		]
	});

//		tarConnectTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
	tarConnectTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // proxy server id
	tarConnectTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server name
	tarConnectTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // success or fail
	tarConnectTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(8)').css('min-width', '100px'); // first reg date
	tarConnectTable.tables().header().to$().find('th:eq(9)').css('min-width', '100px'); // first reg date

	$(window).trigger('resize');
}

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
			"emptyTable" : message_msg01
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

/* ********************************************************
 * 소스 커넥터 - 하단 리스트 초기화
 ******************************************************** */
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

/* ********************************************************
 * 싱크 커넥터 - 하단 리스트 초기화
 ******************************************************** */
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

/* ********************************************************
 * 소스 커넥터 - 하단 상세화면 차트 setting
 ******************************************************** */
function funcSsChartSetting(result) {
	
	//실시간 차트 - 실시간 전송 레코드
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

	//실시간 차트 - 평균 전송 레코드
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

	//에러 차트
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
	
	
//		if (nvlPrmSet(result.snapshotChart, '') != '') {
//		snapshotChart.setData(result.snapshotChart);
//	}
//	srcSnapshotTable.clear().draw();
//	if (nvlPrmSet(result.snapshotInfo, '') != '') {
//		for(var i = 0; i < result.snapshotInfo.length; i++){	
//			if(result.snapshotInfo[i].rownum == 1){
//				if(i != result.snapshotInfo.length-1 && result.snapshotInfo[i+1].rownum == 2){
//					result.snapshotInfo[i].number_of_events_filtered_cng = result.snapshotInfo[i].number_of_events_filtered - result.snapshotInfo[i+1].number_of_events_filtered;
//					result.snapshotInfo[i].number_of_erroneous_events_cng = result.snapshotInfo[i].number_of_erroneous_events - result.snapshotInfo[i+1].number_of_erroneous_events;
//					result.snapshotInfo[i].queue_total_capacity_cng = result.snapshotInfo[i].queue_total_capacity - result.snapshotInfo[i+1].queue_total_capacity;
//					result.snapshotInfo[i].queue_remaining_capacity_cng = result.snapshotInfo[i].queue_remaining_capacity - result.snapshotInfo[i+1].queue_remaining_capacity;
//					result.snapshotInfo[i].remaining_table_count_cng = result.snapshotInfo[i].remaining_table_count - result.snapshotInfo[i+1].remaining_table_count;
//				}
//				srcSnapshotTable.row.add(result.snapshotInfo[i]).draw();
//			}
//		}
//// 							srcSnapshotTable.rows.add(result.snapshotInfo).draw();
//	}
//	if (nvlPrmSet(result.sourceChart1, '') != '') {
//		srcChart1.setData(result.sourceChart1);
//	}
//	if (nvlPrmSet(result.sourceChart2, '') != '') {
//		srcChart2.setData(result.sourceChart2);
//	}
}

/* ********************************************************
 * 소스 커넥터 - 하단 상세화면 리스트 setting
 ******************************************************** */
function funcSsListSetting(result) {
	// 실시간 리스트
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
//			srcConnectTable.rows.add(result.sourceInfo).draw();
	}
	
	//에러 리스트
/*	if (nvlPrmSet(result.sourceErrorInfo, '') != '') {
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
			}
		}
	}*/
}

/* ********************************************************
 * 싱크 커넥터 - 하단 상세화면 connect 정보 리스트 setting
 ******************************************************** */
function funcTarListSetting(result, langSelect) {
	//connect 정보 - 전송대상 토픽 리스트 setting
	tarTopicListTable.clear().draw();
	if (nvlPrmSet(result.targetTopicList, '') != '') {
		$('#tar_connect_nm').text(langSelect.options[langSelect.selectedIndex].text);
		tarTopicListTable.rows.add(result.targetTopicList).draw();
	}
	
	//connect 정보 - 실시간 정보 리스트 setting
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
}

/* ********************************************************
 * 싱크 커넥터 - 하단 상세화면 connect 정보 차트 setting
 ******************************************************** */
function fn_sink_chart_init(trans_id){
	if(trans_id != ""){
		$.ajax({
			url : "/transTarSinkChart.do",
			dataType : "json",
			type : "post",
 			data : {
 				trans_id : trans_id,
 			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					if (nvlPrmSet(result.targetSinkRecordChart, '') != '') {
						var sinkChart = Morris.Line({
							element: 'tar-chart-line-sink',
							ineColors: ['#63CF72', '#FABA66',],
							data: [
								{
									time: '',
									sink_record_active_count: 0,
									sink_record_send_total: 0,
								}
							],
							xkey: 'time',
							xkeyFormat: function(time) {
								return time.substring(10);
							},
							ykeys: ['sink_record_active_count', 'sink_record_send_total'],
							labels: ['싱크 중인 레코드 수', '싱크 완료 총 수']
						});
						sinkChart.setData(result.targetSinkRecordChart);
					}
					
					if (nvlPrmSet(result.targetSinkCompleteChart, '') != '') {
						var sinkCompleteChart = Morris.Line({
							element: 'tar-chart-line-complete',
							lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
							data: [
									{
										time: '',
										offset_commit_completion_total: 0,
										offset_commit_skip_total: 0,
									}
							],
							xkey: 'time',
							xkeyFormat: function(time) {
								return time.substring(10);
							},
							ykeys: ['offset_commit_completion_total', 'offset_commit_skip_total'],
							labels: ['완료 총 수', '무시된 총 커밋 수']
						});
						sinkCompleteChart.setData(result.targetSinkCompleteChart);
					}
					
					if (nvlPrmSet(result.targetErrorChart, '') != '') {

						var sinkErrorChart = Morris.Line({
							element: 'tar-chart-line-sink-error',
							lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
							data: [
									{
										time: '',
										total_record_errors: 0,
										total_record_failures: 0,
										total_records_skipped: 0,
									}
							],
							xkey: 'time',
							xkeyFormat: function(time) {
								return time.substring(10);
							},
							ykeys: ['total_record_errors', 'total_record_failures', 'total_records_skipped'],
							labels: ['오류 수', '레코드 처리 실패 수', '미처리 레코드 수']
						});
						$('#tar-chart-error').show();							
						$('#tar-chart-error-nvl').hide();
						sinkErrorChart.setData(result.targetErrorChart);
					} else {
						$('#tar-chart-error').hide();							
						$('#tar-chart-error-nvl').show();	
					}
				}
			}
		});
	} 
	$("#loading").hide();
}



//	if (nvlPrmSet(result.targetErrorChart, '') != '') {
//		sinkErrorChart.setData(result.targetErrorChart);
//	}
//	tarErrorTable.clear().draw();
//	if (nvlPrmSet(result.targetErrorInfo, '') != '') {
//		console.log(result.targetErrorInfo)
//		for(var i = 0; i < result.targetErrorInfo.length; i++){	
//			if(result.targetErrorInfo[i].rownum == 1){
//				if(i != result.targetErrorInfo.length-1 && result.targetErrorInfo[i+1].rownum == 2){
//					result.targetErrorInfo[i].total_errors_logged_cng = result.targetErrorInfo[i].total_errors_logged - result.targetErrorInfo[i+1].total_errors_logged;
//					result.targetErrorInfo[i].deadletterqueue_produce_requests_cng = result.targetErrorInfo[i].deadletterqueue_produce_requests - result.targetErrorInfo[i+1].deadletterqueue_produce_requests;
//					result.targetErrorInfo[i].deadletterqueue_produce_failures_cng = result.targetErrorInfo[i].deadletterqueue_produce_failures - result.targetErrorInfo[i+1].deadletterqueue_produce_failures;
//					result.targetErrorInfo[i].total_record_failures_cng = result.targetErrorInfo[i].total_record_failures - result.targetErrorInfo[i+1].total_record_failures;
//					result.targetErrorInfo[i].total_records_skipped_cng = result.targetErrorInfo[i].total_records_skipped - result.targetErrorInfo[i+1].total_records_skipped;
//					result.targetErrorInfo[i].total_record_errors_cng = result.targetErrorInfo[i].total_record_errors - result.targetErrorInfo[i+1].total_record_errors;
//				}
//				tarErrorTable.row.add(result.targetErrorInfo[i]).draw();
//			}
//		}
//	}

/* ********************************************************
 * 싱크 커넥터 - 하단 상세화면 connect 정보 리스트 setting
 ******************************************************** */
function fn_dbmsConnect_digm(connectGbn, result) {
	var htmlTargetDbms = "";
	var db_exe_status_chk = "";
	var db_exe_status_css = "";
	var db_exe_status_val = "";
	
	if (connectGbn == "tar") {
		//dbms 연결도 변경
		if (nvlPrmSet(result.transDbmsInfoList, '') != '') {
			for (i = 0; i < result.transDbmsInfoList.length; i++) {

				if (result.transDbmsInfoList[i].dbms_dscd == "TC002201") {
					htmlTargetDbms = '<img src="../images/oracle_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>';
				} else if (result.transDbmsInfoList[i].dbms_dscd == "TC002204") {
					htmlTargetDbms = '<img src="../images/postgresql_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>';
				} else if (result.transDbmsInfoList[i].dbms_dscd == "TC002210") {
					htmlTargetDbms = '<img src="../images/hdfs_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>';
				}
				htmlTargetDbms += " " + result.transDbmsInfoList[i].trans_sys_nm;
				$('#targetDbmsNm').html(htmlTargetDbms);
				
				htmlTargetDbms = "IP/PORT : " + result.transDbmsInfoList[i].ipadr + "/" + result.transDbmsInfoList[i].portno;
				$('#targetDbmsIp').html(htmlTargetDbms);
				
				if(result.transDbmsInfoList[i].db_exe_status == 'TC001501'){
					db_exe_status_chk = "text-success";
					db_exe_status_css = "fa-refresh fa-spin text-success";
					db_exe_status_val = 'running';
				} else {
					db_exe_status_chk = "text-danger";
					db_exe_status_css = "fa-times-circle text-danger";
					db_exe_status_val = 'stop';
				}
				
				htmlTargetDbms = '<i class="fa '+db_exe_status_css+' icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>' + db_exe_status_val;
				$('#targetDbmsStatus').html(htmlTargetDbms);
				
				htmlTargetDbms = '<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 '+db_exe_status_chk+'" style="font-size: 3em;"></i>';
				$('#targetDbmsImg').html(htmlTargetDbms);
			}
		}
	}
}

/* ********************************************************
 * 소스시스템 - 스냅샷 / 스트리밍 챠트 setting
 ******************************************************** */
function fn_snapshot_strem(strGbn) {
	var langSelect = document.getElementById("src_connect");
	var selectValue = langSelect.options[langSelect.selectedIndex].value;
	
	if (strGbn == "snapshot") {
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
	} else {
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
	}
	$("#loading").hide();
	
}




///////////////////////////////////////////////////////미사용////////////////////////////////////////////////
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
			"emptyTable" : message_msg01
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
			"emptyTable" : message_msg01
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
			"emptyTable" : message_msg01
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
* 타겟시스템 connect - 에러테이블
******************************************************** */
function fn_tar_error_init(){
	tarErrorTable = $('#tarErrorTable').DataTable({
		searching : false,
		scrollY : true,
		scrollX: true,	
		paging : false,
		deferRender : true,
		info : false,
		sort: false, 
		"language" : {
			"emptyTable" : message_msg01
		},
		columns : [
//				{data : "rownum", className : "dt-center", defaultContent : "", visible: false},
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
		]
	});
//		tarErrorTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
	tarErrorTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // proxy server id
	tarErrorTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server name
	tarErrorTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // success or fail
	tarErrorTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // first reg date
	tarErrorTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
	tarErrorTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
	tarErrorTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date

	$(window).trigger('resize');
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