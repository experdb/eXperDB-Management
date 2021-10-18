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
					ykeys: ['error'],
					lineColors: ['#199cef'],
					labels: ['error'],
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