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
					{data : "schema_nm", 
						render : function(data, type, full, meta){
							var html = "";
// 							html += full.exrt_trg_tb_nm.split('.')[0];
							html += '	<i class="fa fa-power-off mr-2"></i>' + data;
							return html;
						}, 
						className : "dt-center", 
						defaultContent : ""
					}, 
					{data : "table_nm", 
						render : function(data, type, full, meta){
							var html = "";
							html += '<div class="badge badge-pill badge-light" style="background-color: #EEEEEE;">';
							html += '	<i class="fa fa-power-off mr-2"></i>' + data;
// 							html += '		' + data.split('.')[1] + '</div>';
							return html;
						}, 
						className : "dt-center", 
						defaultContent : ""
					},	
			]
		});
		
		srcMappingListTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // rownum
		srcMappingListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
	
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
		
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // rownum
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // proxy server id
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // proxy server id
		srcConnectSettingInfoTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // proxy server id
	
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
				{data : "number_of_events_filtered", className : "dt-center", defaultContent : "" },
				{data : "number_of_erroneous_events", className : "dt-center", defaultContent : "" },
				{data : "queue_total_capacity", className : "dt-center", defaultContent : "" },
				{data : "queue_remaining_capacity", className : "dt-center", defaultContent : "" },
				{data : "remaining_table_count", className : "dt-center", defaultContent : "" },
			]
		});
		
		srcSnapshotTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // rownum
		srcSnapshotTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
		srcSnapshotTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // proxy server name
		srcSnapshotTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // success or fail
		srcSnapshotTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
		srcSnapshotTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
		srcSnapshotTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date
	
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
				{data : "number_of_committed_transactions", className : "dt-center", defaultContent : "" },
				{data : "total_number_of_events_seen", className : "dt-center", defaultContent : "" },
				{data : "number_of_events_filtered", className : "dt-center", defaultContent : "" },
				{data : "number_of_erroneous_events", className : "dt-center", defaultContent : "" },
				{data : "milli_seconds_since_last_event", className : "dt-center", defaultContent : "" },
			]
		});
		
		srcStreamingTable.tables().header().to$().find('th:eq(0)').css('min-width', '100px'); // rownum
		srcStreamingTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // proxy server id
		srcStreamingTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // proxy server name
		srcStreamingTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // success or fail
		srcStreamingTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // first reg date
		srcStreamingTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px'); // first reg date
		srcStreamingTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); // first reg date
		srcStreamingTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px'); // first reg date
	
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
				{data : "source_record_active_count_max", className : "dt-center", defaultContent : "" },
				{data : "source_record_write_rate", className : "dt-center", defaultContent : "" },
				{data : "source_record_active_count_avg", className : "dt-center", defaultContent : "" },
				{data : "source_record_write_total", className : "dt-center", defaultContent : "" },
				{data : "source_record_poll_total", className : "dt-center", defaultContent : "" },
				{data : "source_record_active_count", className : "dt-center", defaultContent : "" },
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
				{data : "total_errors_logged", className : "dt-center", defaultContent : "" },
				{data : "deadletterqueue_produce_requests", className : "dt-center", defaultContent : "" },
				{data : "deadletterqueue_produce_failures", className : "dt-center", defaultContent : "" },
				{data : "total_record_failures", className : "dt-center", defaultContent : "" },
				{data : "total_records_skipped", className : "dt-center", defaultContent : "" },
				{data : "total_record_errors", className : "dt-center", defaultContent : "" },
				{data : "total_retries ", className : "dt-center", defaultContent : "" },
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
			$("#server-tab-1").addClass("active");
			$("#server-tab-2").removeClass("active");
			
		}else{
			$(".snapshotDiv").hide();
			$(".streamingDiv").show();
			$("#server-tab-2").addClass("active");
			$("#server-tab-1").removeClass("active");
			
		}
	}
	
	function fn_src_chart_init(){
		
		var snapshotChart = Morris.Line({
			element: 'src-chart-line-snapshot',
			lineColors: ['#63CF72', '#FABA66',],
			data: [
					{
					exe_dtm_ss: '2021-06-10 10:20:35',
					number_of_events_filtered : 0,
					number_of_erroneous_events : 0,
					}
			],
			xkey: 'exe_dtm_ss',
			xkeyFormat: function(exe_dtm_ss) {
				return exe_dtm_ss.substring(10);
			},
			ykeys: ['number_of_events_filtered', 'number_of_erroneous_events'],
			labels: ['필터링 된 이벤트 수', '오류 난 이벤트 수']
		});
		
		var streamingChart = Morris.Line({
			element: 'src-chart-line-streaming',
			lineColors: ['#63CF72', '#FABA66','#F36368'],
			data: [
					{
					exe_dtm_ss: '2021-06-10 10:20:35',
					total_number_of_events_seen : 0,
					number_of_events_filtered : 0,
					number_of_erroneous_events : 0,
					}
			],
			xkey: 'exe_dtm_ss',
			xkeyFormat: function(exe_dtm_ss) {
				return exe_dtm_ss.substring(10);
			},
			ykeys: ['total_number_of_events_seen', 'number_of_events_filtered', 'number_of_erroneous_events'],
			labels: ['이벤트 총 수','필터링 된 이벤트 수', '오류 난 이벤트 수']
		});

		var scrChart1 = Morris.Line({
			element: 'src-chart-line-1',
			lineColors: ['#63CF72', '#FABA66','#F36368'],
			data: [
					{
					exe_dtm_ss: '2021-06-10 10:20:35',
					source_record_write_total : 0,
					source_record_poll_total : 0,
					source_record_active_count : 0,
					}
			],
			xkey: 'exe_dtm_ss',
			xkeyFormat: function(exe_dtm_ss) {
				return exe_dtm_ss.substring(10);
			},
			ykeys: ['source_record_write_total', 'source_record_poll_total', 'source_record_active_count'],
			labels: ['kafka에 기록된 레코드 수','폴링 된 총 레코드 수', 'kafka에 기록되지 않은 레코드 수']
		});
		
		var srcChart2 = Morris.Line({
			element: 'src-chart-line-2',
			lineColors: ['#63CF72', '#FABA66','#F36368'],
			data: [
					{
					exe_dtm_ss: '2021-06-10 10:20:35',
					source_record_write_rate : 0,
					source_record_active_count_avg : 0,
					}
			],
			xkey: 'exe_dtm_ss',
			xkeyFormat: function(exe_dtm_ss) {
				return exe_dtm_ss.substring(10);
			},
			ykeys: ['source_record_write_rate', 'source_record_active_count_avg'],
			labels: ['kafka에 기록된 초당 평균 레코드 수','kafka에 기록되지 않은 평균 레코드 수']
		});
		
		var srcErrorChart = Morris.Line({
			element: 'src-chart-line-error',
			lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
			data: [
					{
					exe_dtm_ss: '2021-06-10 10:20:35',
					total_record_errors: 0,
					total_record_failures: 0,
					total_records_skipped: 0,
					total_retries : 0
					}
			],
			xkey: 'exe_dtm_ss',
			xkeyFormat: function(exe_dtm_ss) {
				return exe_dtm_ss.substring(10);
			},
			ykeys: ['total_record_errors', 'total_record_failures', 'total_records_skipped', 'total_retries'],
			labels: ['오류 수', '레코드 처리 실패 수', '미처리 레코드 수', '재시도 작업 수']
		});
		
	}

	
	
</script>

<div class="col-lg-6 grid-margin stretch-card">
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
			
			<!-- snapshot start -->
			<div class="snapshotDiv" style="display:block;">
				<!-- chart -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;snapshot
							</p>
							<div id="src-chart-line-snapshot" style="max-height:200px;"></div>
						</div>
					</div>
				</div>
				
				<!-- table -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="srcSnapshotTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">connector_src_name </th>
										<th width="100px;">time </th>
										<th width="100px;">number_of_events_filtered </th>
										<th width="100px;">number_of_erroneous_events </th>
										<th width="100px;">queue_total_capacity </th>
										<th width="100px;">queue_remaining_capacity </th>
										<th width="100px;">remaining_table_count </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				
			</div>
			<!-- snapshot end -->
			
			<!-- streaming start -->
			<div class="streamingDiv" style="display:none;">
			
				<!-- chart -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;streaming
							</p>
							<div id="src-chart-line-streaming" style="max-height:200px;"></div>
						</div>
					</div>
				</div>
				
				<!-- table -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="srcStreamingTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">connector_src_name </th>
										<th width="100px;">time </th>
										<th width="100px;">last_transaction_id </th>
										<th width="100px;">number_of_committed_transactions </th>
										<th width="100px;">total_number_of_events_seen </th>
										<th width="100px;">number_of_events_filtered </th>
										<th width="100px;">number_of_erroneous_events </th>
										<th width="100px;">milli_seconds_since_last_event </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				
			</div>
			<!-- streaming end -->
			
			<!-- connect 정보 start -->
			<!-- connect title start -->
			<div class="accordion_main accordion-multi-colored col-12" id="accordion_src_connect_his" role="tablist">
				<div class="card" style="margin-bottom:0px;">
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
					<div class="card-body" style="border: 1px solid #adb5bd; margin-bottom:8px;">
						<div class="form-group row" style="margin-bottom:-20px;">
							<label class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
								<i class="item-icon fa fa-dot-circle-o"></i>
								connect 설정 정보
							</label>
							<div class="col-sm-9">
							</div>
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
							<label class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
								<i class="item-icon fa fa-dot-circle-o"></i>
								<spring:message code="data_transfer.transfer_table" />
							</label>
							<div class="col-sm-9">
							</div>
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
			<!-- connect info end -->
			<div id="src_connect_header_sub_list" class="collapse show row" role="tabpanel" aria-labelledby="src_connect_header_div" data-parent="#accordion_src_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<p class="card-title" style="margin-bottom:5px;margin-left:10px;">
								<i class="item-icon fa fa-toggle-right text-info"></i>
								&nbsp;connect 실시간 차트
<!-- 								<i class="fa fa-bar-chart-o menu-icon text-info"></i> -->
<!-- 								connect 실시간 차트 -->
							</p>
						</div>
					</div>
				</div>
				
				<!-- chart 1 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;chart1
							</p>
							<div id="src-chart-line-1" style="max-height:200px;"></div>
						</div>
					</div>
				</div>
						
				<!-- chart 2 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;chart2
							</p>
							<div id="src-chart-line-2" style="max-height:200px;"></div>
						</div>
					</div>
				</div>

				<!-- connect 리스트 -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="srcConnectTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">time</th>
										<th width="100px;">source_record_active_count_max</th>
										<th width="100px;">source_record_write_rate</th>
										<th width="100px;">source_record_active_count_avg </th>
										<th width="100px;">source_record_write_total </th>
										<th width="100px;">source_record_poll_total</th>
										<th width="100px;">source_record_active_count </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>

			</div>
			<!-- connect 정보 end -->
			
			<!-- error 정보 start -->
			<div class="accordion_main accordion-multi-colored col-12" id="accordion_src_error_his" role="tablist">
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
				<div class="card" style="margin-left:-10px;border:none;">
					<div class="card-body" style="border:none;">
						<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
							<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;error 차트
						</p>
						<div id="src-chart-line-error" style="max-height:200px;"></div>
					</div>
				</div>
			</div>
			
			<!-- error 리스트 -->
			<div class="col-md-12 col-xl-12 justify-content-center">
				<div class="card" style="margin-left:-10px;border:none;">
					<div class="card-body" style="border:none;">
						<table id="srcErrorTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
							<thead class="bg-info text-white">
								<tr>
									<th width="0px;">rownum</th>
									<th width="100px;">last_error_timestamp </th>
									<th width="100px;">total_errors_logged </th>
									<th width="100px;">deadletterqueue_produce_requests</th>
									<th width="100px;">deadletterqueue_produce_failures </th>
									<th width="100px;">total_record_failures</th>
									<th width="100px;">total_records_skipped </th>
									<th width="100px;">total_record_errors</th>
									<th width="100px;">total_retries</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
				
			<!-- error 정보 end -->
			
		</div>
	</div>
</div>
