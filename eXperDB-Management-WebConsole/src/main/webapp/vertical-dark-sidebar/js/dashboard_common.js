var todayTotDate = null;
var todayChkYear = null;
var todayChkMonth = null;
var todayChkDate = null;
var todayChkDay = null;
var todayChkHours = null;
var todayMinutes = null;

$(window).ready(function(){
	//금일 날짜 체크
	fn_today_setChk();

	//오늘날짜 setting
	fn_todaySetting();

	//통합 스케줄 setting
	fn_totScdSetting();

	//서버정보 리스트 setting
	fn_serverListSetting();	

	// tooltip 셋팅
	setTimeout(function(){
		$('[data-toggle="tooltip"]').tooltip({
			template: '<div class="tooltip tooltip-warning" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
		});
	},250);
});

/* ********************************************************
 * 서버정보 click
 ******************************************************** */
function fn_serverSebuInfo(db_svr_id, rowChkCnt) {
	//load bar 추가
	
	var obj = $('#loading_dash');
	var iHeight = (($(window).height() - obj.outerHeight()) / 2) + $("#contentsDivDash").scrollTop();
	var iWidth = (($(window).width() - obj.outerWidth()) / 2) + $("#contentsDivDash").scrollLeft();
	obj.css({
		position: 'absolute',
		display:'block',
		top: iHeight,
		left: iWidth
	});

	$('#loading_dash').show();

	//초기화
	fn_serverDivClear(db_svr_id, rowChkCnt);
}

/* ********************************************************
 * 초기화
 ******************************************************** */
function fn_serverDivClear(db_svr_id, rowChkCnt) {
	//백업정보
	/*if ($('#a_back_hist').attr('aria-expanded') == "false") {
		$('#a_back_hist').click();
	}*/

	//배치정보
	/*if ($('#a_script_hist').attr('aria-expanded') == "false") {
		$('#a_script_hist').click();
	}*/

	if ($('#a_scale_hist').attr('aria-expanded') == "false") {
		$('#a_scale_hist').click();
	}

	if ($('#a_encrypt_hist').attr('aria-expanded') == "false") {
		$('#a_encrypt_hist').click();
	}

	$("#scheduleHistChart").html("");
	/*$("#backupRmanHistChart").html("");
	$("#backupDumpHistChart").html("");	*/

	/*var scriptHistChartCanvas = document.getElementById("scriptHistChart");
	scriptHistChartCanvas.getContext("2d").clearRect(0, 0, scriptHistChartCanvas.width, scriptHistChartCanvas.height);*/

	if ($("#scaleHistChart") != null) {
		$("#scaleHistChart").html("");	
	}

	if (document.getElementById("scaleSetChart") != null) {
		var scaleSetChartCanvas = document.getElementById("scaleSetChart");
		scaleSetChartCanvas.getContext("2d").clearRect(0, 0, scaleSetChartCanvas.width, scaleSetChartCanvas.height);
	}

	if (document.getElementById("encryptHistChart") != null) {
		var encryptHistChartCanvas = document.getElementById("encryptHistChart");
		encryptHistChartCanvas.getContext("2d").clearRect(0, 0, encryptHistChartCanvas.width, encryptHistChartCanvas.height);
	}

	//table space
	$("#pg_data").html("");
	$("#pg_backup").html("");
	$("#pg_wal").html("");
	$("#pg_arc").html("");
	$("#pg_log").html("");

	//클릭시 css
	var serverSsCnt_chk = parseInt(nvlPrmSet($("#serverSsCnt", "#dashboardViewForm").val(),0));

	if (serverSsCnt_chk > 0) {
		for (var i = 1; i <= serverSsCnt_chk; i++) {
			$("#serverSs" + i).css('background-color','#fff');
		}
	}

	$("#serverSs" + rowChkCnt).css('background-color','#c2defe');

	fn_dbSvrIdSearch(db_svr_id);
	fn_prySearch(db_svr_id);
}

/* ********************************************************
 * 메인 대시보드 셋팅
 ******************************************************** */
function fn_main_tab_setting(result) {

	//백업일정, 배치일정, 데이터이관 일정 setting
	fn_schedule_cnt_set(result);

	//스케줄 이력 목록 setting
	fn_schedule_History_set(result);

	//백업 이력 목록 setting
	//fn_backup_History_set(result);

	//배치 이력 목록 setting
	//fn_script_History_set(result);

	//데이터 이관 setting
//	if (nvlPrmSet($("#db2pg_yn", "#dashboardViewForm").val(), "N") == "Y") {
//		fn_migration_history_set(result);
//	}

	//scale setting
	if (nvlPrmSet($("#scale_yn", "#dashboardViewForm").val(), "N") == "Y") {
		fn_scale_history_set(result);
	}

	//암호화 정보 setting
	if(nvlPrmSet($("#encp_use_yn_chk", "#dashboardViewForm").val(), "N")  == "Y"){
		$("#encrypt_div_none").hide();
		$("#encrypt_div_set").show();
		fn_encrypt_serverStatus();
	}else{
		$("#encrypt_div_none").show();
		$("#encrypt_div_set").hide();
	} 

	//테이블스페이즈 정보 setting
	fn_tablescpace_setting(result);
}

/* ********************************************************
 * 테이블스페이즈 정보 setting
 ******************************************************** */
function fn_tablescpace_setting(result) {
	var textHtml= "";

	if (result.tablespaceObj != null) {
		//data
		if (result.tablespaceObj.CMD_TABLESPACE_INFO != null && result.tablespaceObj.CMD_TABLESPACE_INFO != undefined) {
			$("#filesystemTd").html('<i class="fa fa-hdd-o text-primary">'+ nvlPrmSet(result.tablespaceObj.CMD_TABLESPACE_INFO[0].filesystem, "") + '</i>');
			$("#tablespaceInfoFsizeTd").html(nvlPrmSet(result.tablespaceObj.CMD_TABLESPACE_INFO[0].fsize, "0"));
			$("#tablespaceInfoUsedTd").html(nvlPrmSet(result.tablespaceObj.CMD_TABLESPACE_INFO[0].used, "0"));
			$("#tablespaceInfoAvailTd").html(nvlPrmSet(result.tablespaceObj.CMD_TABLESPACE_INFO[0].avail, "0"));
			fn_gData(result.tablespaceObj.CMD_TABLESPACE_INFO[0].use);
		} else {
			$("#filesystemTd").html('<i class="fa fa-hdd-o text-primary"></i>');
			$("#tablespaceInfoFsizeTd").html("0");
			$("#tablespaceInfoUsedTd").html("0");
			$("#tablespaceInfoAvailTd").html("0");
			fn_gData("0%");
		}

		//backup
		if (result.tablespaceObj.BACKUP_PATH != null && result.tablespaceObj.BACKUP_PATH != undefined) {
			$("#backupPathTd").html('<i class="fa fa-hdd-o text-primary">'+ nvlPrmSet(result.tablespaceObj.BACKUP_PATH, "") + '</i>');
		} else {
			$("#backupPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
			$("#backupspaceInfoFsizeTd").html("0");
		}

		if (result.tablespaceObj.CMD_BACKUPSPACE_INFO != null && result.tablespaceObj.CMD_BACKUPSPACE_INFO != undefined) {
			$("#backupspaceInfoFsizeTd").html(nvlPrmSet(result.tablespaceObj.CMD_BACKUPSPACE_INFO[0].fsize, "0"));
			$("#backupVTd").html(nvlPrmSet(result.tablespaceObj.BACKUP_V, "0"));
			fn_gBackup(result.tablespaceObj.CMD_BACKUPSPACE_INFO[0].fsize, result.tablespaceObj.BACKUP_V);
		} else {
			$("#backupspaceInfoFsizeTd").html("0");
			$("#backupVTd").html("0");
			
			fn_gBackup("0M", "0M");
		}

		//WAL
		if (result.tablespaceObj.PGWAL_PATH != null && result.tablespaceObj.PGWAL_PATH != undefined) {
			$("#pgwalPathTd").html('<i class="fa fa-hdd-o text-primary">'+ nvlPrmSet(result.tablespaceObj.PGWAL_PATH, "") + '</i>');
		} else {
			$("#pgwalPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		}

		if (result.tablespaceObj.WAL_KEEP_SEGMENTS != null && result.tablespaceObj.WAL_KEEP_SEGMENTS != undefined) {
			$("#walKeepSegmentsTd").html('<i class="ti-files"> WAL_KEEP_SEGMENTS : </i>'+ nvlPrmSet(result.tablespaceObj.WAL_KEEP_SEGMENTS, "") + dashboard_count);
		} else {
			$("#walKeepSegmentsTd").html('<i class="ti-files"> WAL_KEEP_SEGMENTS : </i>0' + dashboard_count);
		}

		if (result.tablespaceObj.PGWAL_CNT != null && result.tablespaceObj.PGWAL_CNT != undefined) {
			$("#pgwalCntTd").html('<i class="ti-files"> WAL_FILE : </i>'+ nvlPrmSet(result.tablespaceObj.PGWAL_CNT, "") + dashboard_count);
			
			fn_gWal(result.tablespaceObj.PGWAL_CNT, result.tablespaceObj.WAL_KEEP_SEGMENTS);
		} else {
			$("#pgwalCntTd").html('<i class="ti-files"> WAL_FILE : </i>0' + dashboard_count);
			
			fn_gWal("0", "0");
		}

		//ARCHIVE
		if (result.tablespaceObj.PGALOG_PATH != null && result.tablespaceObj.PGALOG_PATH != undefined) {
			$("#pgalogPathTd").html('<i class="fa fa-hdd-o text-primary">'+ nvlPrmSet(result.tablespaceObj.PGALOG_PATH, "") + '</i>');
		} else {
			$("#pgalogPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		}

		if (result.tablespaceObj.PGALOG_CNT != null && result.tablespaceObj.PGALOG_CNT != undefined) {
			$("#pgalogCntTd").html('<i class="ti-files"> ARCHIVE_FILE :  </i>'+ nvlPrmSet(result.tablespaceObj.PGALOG_CNT, "") + " " + dashboard_count +'</i>');
		} else {
			$("#pgalogCntTd").html('<i class="ti-files"> ARCHIVE_FILE :  </i>');
		}

		if (result.tablespaceObj.PGALOG_V != null && result.tablespaceObj.PGALOG_V != undefined) {
			fn_gArc(result.tablespaceObj.PGALOG_V);
		} else {
			fn_gArc("0");
		}

		//LOG
		if (result.tablespaceObj.LOG_PATH != null && result.tablespaceObj.LOG_PATH != undefined) {
			$("#logPathTd").html('<i class="fa fa-hdd-o text-primary">'+ nvlPrmSet(result.tablespaceObj.LOG_PATH, "") + '</i>');
		} else {
			$("#logPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		}

		if (result.tablespaceObj.LOG_CNT != null && result.tablespaceObj.LOG_CNT != undefined) {
			$("#logFileCntTd").html('<i class="ti-files"> LOG_FILE :  </i>'+ nvlPrmSet(result.tablespaceObj.LOG_CNT, "") + " " + dashboard_count +'</i>');
		} else {
			$("#logFileCntTd").html('<i class="ti-files"> LOG_FILE :  </i>');
		}

		if (result.tablespaceObj.LOG_V != null && result.tablespaceObj.LOG_V != undefined) {
			fn_gLog(result.tablespaceObj.LOG_V);
		} else {
			fn_gLog("0");
		}
	} else {
		$("#filesystemTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		$("#tablespaceInfoFsizeTd").html("0");
		$("#tablespaceInfoUsedTd").html("0");
		$("#tablespaceInfoAvailTd").html("0");
		fn_gData("0%");

		$("#backupPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		$("#backupspaceInfoFsizeTd").html("0");
		fn_gBackup("0M", "0M");

		$("#pgwalPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		$("#walKeepSegmentsTd").html('<i class="ti-files"> WAL_KEEP_SEGMENTS : </i>0' + dashboard_count);
		$("#pgwalCntTd").html('<i class="ti-files"> WAL_FILE : </i>0' + dashboard_count);
		fn_gWal("0", "0");

		$("#pgalogPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		fn_gArc("0");

		$("#logPathTd").html('<i class="fa fa-hdd-o text-primary"></i>');
		$("#logFileCntTd").html('<i class="ti-files"> LOG_FILE :  </i>');
		fn_gLog("0");
	}

	$('#loading_dash').hide();	
}

/* ********************************************************
 * 암호화관리 설정
 ******************************************************** */
function fn_encrypt_serverStatus() {
	$.ajax({
		url : "/serverStatus.do",
		data : {},
		dataType : "json",
		type : "post",
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
		success : function(data) {
			fn_encrypt_setting(data);
		}
	});
}

/* ********************************************************
 * 암호화 setting
 ******************************************************** */
function fn_encrypt_setting(data) {
	var keyServerHtml = "";

	keyServerHtml += "<tr>";
	keyServerHtml += '<td style="width:50%;line-height:150%;border:none;">';
	
	if(data.resultCode == "0000000000"){
		keyServerHtml += '<div class="badge badge-pill badge-success"><i class="fa fa-spin fa-spinner"></i></div>';
		keyServerHtml += '&nbsp;' + dashboard_running;
	}else if(data.resultCode == "8000000002"){
		keyServerHtml += '<div class="badge badge-pill badge-danger"><i class="fa fa-minus"></i></div>';
		keyServerHtml += '&nbsp;' + schedule_stop;
	}
	keyServerHtml += '</td>';
	keyServerHtml += "</tr>";

	$("#keyServerState").html(keyServerHtml);

	//암호화키 agent 조회
	fn_selectSecurityStatistics(today);
}

/* ********************************************************
 * 암호화키 agent 조회
 ******************************************************** */
function fn_selectSecurityStatistics(today){
	var encryptSuccessCount = 0;
	var encryptFailCount = 0;
	var decryptSuccessCount = 0;
	var decryptFailCount = 0;

	$.ajax({
		url : "/selectDashSecurityStatistics.do",
		data : {
			from : today+"00",
			to : 	today+"24",
			categoryColumn : "SITE_ACCESS_ADDRESS"
		},
		dataType : "json",
		type : "post",
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
		success : function(data) {
			if(data.resultCode == "0000000000"){
				var html ="";

				if (data.list.length > 0) {
					for(var i=0; i<data.list.length; i++){
						html += '<tr>';
						html += '<td style="width:100%;line-height:150%;border:none;">';
	
						if(data.list[i].status == "start"){
							html += '<div class="badge badge-pill badge-success"><i class="fa fa-spin fa-spinner"></i></div>';
						} else {
							html += '<div class="badge badge-pill badge-danger"><i class="fa fa-minus"></i></div>';
						}
						html += "&nbsp;" + data.list[i].monitoredName;

						html += '</td>';
						html += "</tr>";

						encryptSuccessCount += encryptSuccessCount + parseInt(nvlPrmSet(data.list[i].encryptSuccessCount, 0));
						encryptFailCount += encryptFailCount + parseInt(nvlPrmSet(data.list[i].encryptFailCount, 0));
						decryptSuccessCount += decryptSuccessCount + parseInt(nvlPrmSet(data.list[i].decryptSuccessCount, 0));
						decryptFailCount += decryptFailCount + parseInt(nvlPrmSet(data.list[i].decryptFailCount, 0));
					}

					$( "#agentKeyServerState" ).html(html);
				}
			}else if(data.resultCode == "8000000002"){
				showSwalIcon(message_msg05, closeBtn, '', 'error');
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, closeBtn, '', 'warning', 'securityKeySet');
			}else{
				if (data.list != null) {
					if(data.list.length != 0){
						showSwalIcon(data.resultMessage +"("+data.resultCode+")", closeBtn, '', 'error');
					}
				}
			}
		}
	});

	fn_selectSecurityChart(encryptSuccessCount, encryptFailCount, decryptSuccessCount, decryptFailCount);
}

/* ********************************************************
 * 암호화 chart setting
 ******************************************************** */
function fn_selectSecurityChart(encryptSuccessCount, encryptFailCount, decryptSuccessCount, decryptFailCount){
	///////////////////////////암호화 chart start ////////////////////////
	if ($("#encryptHistChart").length) {
		var encryptSucCnt = nvlPrmSet(encryptSuccessCount, 0);
		var encryptFailCnt = nvlPrmSet(encryptFailCount, 0);
		var decryptSucCnt = nvlPrmSet(decryptSuccessCount, 0);
		var decryptFailCnt = nvlPrmSet(decryptFailCount, 0);

		var options = {
/*				responsive: false,*/
				scales: {
					yAxes: [{
						ticks: {
							beginAtZero: true
						}
					}]
				},
				legend: {
					display: false
				},
				elements: {
					point: {
						radius: 0
					}
				}
		};

		var data = {
				labels: [dashboard_encrypt_success, dashboard_encrypt_failed, dashboard_decrypt_success, dashboard_decrypt_failed],
				datasets: [{
					label: 'count :',
					data: [encryptSucCnt, encryptFailCnt, decryptSucCnt, decryptFailCnt],
					backgroundColor: [
						'rgba(54, 162, 235, 0.2)',
						'rgba(255, 206, 86, 0.2)',
						'rgba(75, 192, 192, 0.2)',
						'rgba(255, 99, 132, 0.2)'
					],
					borderColor: [
						'rgba(54, 162, 235, 1)',
						'rgba(255, 206, 86, 1)',
						'rgba(75, 192, 192, 1)',
						'rgba(255,99,132,1)'
					],
					borderWidth: 1,
					fill: false
				}]
		};

		var barChartCanvas = $("#encryptHistChart").get(0).getContext("2d");
		var barChart = new Chart(barChartCanvas, {
			type: 'bar',
			data: data,
			options: options
		});
	}
	///////////////////////////암호화 chart end ////////////////////////
}

/* ********************************************************
 * 서버리스트 설정
 ******************************************************** */
function fn_dbSvrIdSearch(db_svr_id_val) {
	$.ajax({
		url : "/dashboarod_main_search.do",
		data : {
			db_svr_id : db_svr_id_val
		},
		dataType : "json",
		type : "post",
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
			//update setting
			fn_main_tab_setting(result);
		}
	});
}

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
	var sdtHisTimehtml = "<i class='fa fa-calendar menu-icon'></i> "+today_date.toJSON().slice(0,10).replace(/-/g,'-') + " ~ " + today_ing;

	$( "#tot_sdt_today" ).append(html);						//통합스케줄
	$( "#tot_scd_ing_msg" ).append(html);					//금일예정

	$( "#tot_sdt_his_today" ).append(sdtHisTimehtml);		//스케줄 이력
	$( "#tot_back_his_today" ).append(sdtHisTimehtml);		//백업 이력
//	$( "#tot_script_his_today" ).append(sdtHisTimehtml);	//배치 이력
//	$( "#tot_migration_his_today" ).append(sdtHisTimehtml);	//migration 이력
	$( "#tot_scale_his_today" ).append(sdtHisTimehtml);	

	$( "#tot_encrypt_his_today" ).append(html);	
	$( "#tot_proxy_his_today" ).append(html);	
}

/* ********************************************************
 * 금일 날짜 설정
 ******************************************************** */
function fn_today_setChk() {
	todayTotDate = new Date();
	todayChkYear = todayTotDate.getFullYear(); // 년도
	todayChkMonth = String(todayTotDate.getMonth() + 1);  // 월
	todayChkDate = String(todayTotDate.getDate());  // 날짜
	todayChkDay = todayTotDate.getDay();  // 요일
	todayChkHours = String(todayTotDate.getHours()); // 시
	todaySetHours = todayTotDate.getHours(); 		// 변경전
	todayChkMinutes = String(todayTotDate.getMinutes());  // 분

	if(todayChkMonth.length < 2){ 
		todayChkMonth = "0" + todayChkMonth; 
	}

	if(todayChkDate.length == 1){ 
		todayChkDate = "0" + todayChkDate;
	}

	if(todayChkHours.length < 2){ 
		todayChkHours = "0" + todayChkHours; 
	}

	if(todayChkMinutes.length == 1){ 
		todayChkMinutes = "0" + todayChkMinutes;
	}
}

/* ********************************************************
 * 일정 설정
 ******************************************************** */
function fn_schedule_cnt_set(result) {
	var checkDt = todayChkMonth + "" + todayChkDate;
	var checkYear = todayChkYear + "" + todayChkMonth + "" + todayChkDate; //전체 날짜
	var checkDay = todayChkDate;

	var backHtml = "";
	var scriptHtml = "";
	var backCount=0;
	var scriptCount=0;
	var exe_perd_cd_val = "";
	var scdHK = "";
	var checkMons = "";
	var ampm ="";
	var hours = "";

	/////////////////////백업일정 start////////////////////////////////////////////////
	if (result.backupScdCnt != null && result.backupScdCnt > 0) {
		backHtml += "<tr>";

		$(result.backupScdresult).each(function (index, item) {
			exe_perd_cd_val = item.exe_perd_cd;
			scdHK = "";
			var resultYearCheckDt = item.exe_month + "" + item.exe_day;
				
			if(exe_perd_cd_val == 'TC001605') {			//1회실행
				if(item.exe_dt == checkYear) {
					scdHK = 'TC001605';
				}
			} else if(exe_perd_cd_val == 'TC001601') {		//매일
				if(item.frst_reg_dtm <= checkYear) {
					scdHK = 'TC001601';
				}
			} else if(exe_perd_cd_val == 'TC001602') {		//매주
				if(item.frst_reg_dtm <= checkYear) {
					for(var i=0;i<7;i++){
						if(item.exe_dt.substr(i,1) == '1') {
							checkMons = i;
						}

						if (checkMons == todayChkDay) {
							scdHK = 'TC001602';
							continue;
						}
					}
				}
			} else if(exe_perd_cd_val == 'TC001603') {			//매월
				if(item.frst_reg_dtm <= checkYear) {
					if(item.exe_day == checkDay) {
						scdHK = 'TC001603';
					}
				}
			} else if(exe_perd_cd_val == 'TC001604') {
				if(item.frst_reg_dtm <= checkYear) {
					if(resultYearCheckDt == checkDt) {
						scdHK = 'TC001604';
					}
				}
			}

			if (scdHK != null && scdHK != "") {
				backHtml += '<td style="width:25%;line-height:150%;border:none;">';

				if (item.bck_bsn_dscd == 'TC000201') {
					if (item.bck_opt_cd == 'TC000301') { //전체백업
						backHtml += "	<i class='fa fa-paste mr-2 text-success'></i>";
					} else if(item.bck_opt_cd == 'TC000302'){ //증분백업
						backHtml += "	<i class='fa fa-comments-o text-warning'></i>";
					} else { //변경이력백업
						backHtml += "	<i class='fa fa-exchange mr-2 text-info' ></i>";
					}
				} else if (item.bck_bsn_dscd == 'TC000202') {
					backHtml += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i>";
				}

				backHtml += "<a class='nav-link_title' href='#' onclick='fn_scheduleListMove(\""+item.scd_nm+"\");'>";	
				backHtml += "&nbsp;"+ item.scd_nm;
				backHtml += "</a>";
				backHtml += '<br/>';

				if (item.scd_cndt == 'TC001801') { //대기
					backHtml += "	<i class='fa fa-circle mr-2 text-success' ></i>";
				} else { //실행중
					backHtml += '<div class="badge badge-pill badge-warning">' + dashboard_running + '</div>';
				}

				if(scdHK == 'TC001605') { 				//1회실행
					backHtml += schedule_one_time_run;
				} else if(scdHK == 'TC001601') { 		//매일
					backHtml += schedule_everyday;
				} else if (scdHK == 'TC001602') {		//매주
					backHtml += schedule_everyweek;
				} else if (scdHK == 'TC001603') {		//매월
					backHtml += schedule_everymonth;
				} else if(scdHK == 'TC001604') {	//매년
					backHtml += schedule_everyyear;
				}
				backHtml += '<br/>';

				ampm = item.exe_hh >= 12 ? 'pm' : 'am';
				hours = item.exe_hh % 12;
				hours = hours.length < 2 ? '0'+hours : hours;
				minutes = item.exe_mm.length < 2 ? '0'+item.exe_mm : item.exe_mm;

				backHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + hours + ":" + minutes + " " + ampm;

				backCount = backCount + 1;

				backHtml += '</td>';
			}

			//4의 배수일때 tr 추가
			if (backCount % 4 == 0)  {
				backHtml += "</tr>";
				backHtml += "<tr>";
			}
		});
		backHtml += "</tr>";
	} else {
		backHtml += "<tr>";
		backHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#ededed;">';
		backHtml += dashboard_msg02
		backHtml += '</td>';
		backHtml += "</tr>";
	}

	$("#bakupScheduleCntList").html(backHtml);
	/////////////////////백업일정 end////////////////////////////////////////////////

	/////////////////////배치일정 start////////////////////////////////////////////////
	if (result.backupScdCnt != null && result.backupScdCnt > 0) {
		scriptHtml += "<tr>";

		$(result.scriptScdresult).each(function (index, item) {
			exe_perd_cd_val = item.exe_perd_cd;
			scdHK = "";
			var resultYearCheckDt = item.exe_month + "" + item.exe_day;

			if(exe_perd_cd_val == 'TC001605') {			//1회실행
				if(item.exe_dt == checkYear) {
					scdHK = 'TC001605';
				}
			} else if(exe_perd_cd_val == 'TC001601') {		//매일
				if(item.frst_reg_dtm <= checkYear) {
					scdHK = 'TC001601';
				}
			} else if(exe_perd_cd_val == 'TC001602') {		//매주
				if(item.frst_reg_dtm <= checkYear) {
					for(var i=0;i<7;i++){
						if(item.exe_dt.substr(i,1) == '1') {
							checkMons = i;
						}

						if (checkMons == todayChkDay) {
							scdHK = 'TC001602';
							continue;
						}
					}
				}
			} else if(exe_perd_cd_val == 'TC001603') {			//매월
				if(item.frst_reg_dtm <= checkYear) {
					if(item.exe_day == checkDay) {
						scdHK = 'TC001603';
					}
				}
			} else if(exe_perd_cd_val == 'TC001604') {
				if(item.frst_reg_dtm <= checkYear) {
					if(resultYearCheckDt == checkDt) {
						scdHK = 'TC001604';
					}
				}
			}

			if (scdHK != null && scdHK != "") {
				scriptHtml += '<td style="width:33%;line-height:150%">';
				scriptHtml += "	<i class='fa fa-exchange mr-2 text-primary' ></i>";

				scriptHtml += "<a class='nav-link_title' href='#' onclick='fn_scheduleListMove(\""+item.scd_nm+"\");'>";	
				scriptHtml += "&nbsp;"+ item.scd_nm;
				scriptHtml += "</a>";
				scriptHtml += '<br/>';

				if (item.scd_cndt == 'TC001801') { //대기
					scriptHtml += "	<i class='fa fa-circle mr-2 text-success' ></i>";
				} else { //실행중
					scriptHtml += '<div class="badge badge-pill badge-warning">' + dashboard_running + '</div>';
				}

				if(scdHK == 'TC001605') { 				//1회실행
					scriptHtml += schedule_one_time_run;
				} else if(scdHK == 'TC001601') { 		//매일
					scriptHtml += schedule_everyday;
				} else if (scdHK == 'TC001602') {		//매주
					scriptHtml += schedule_everyweek;
				} else if (scdHK == 'TC001603') {		//매월
					scriptHtml += schedule_everymonth;
				} else if(scdHK == 'TC001604') {	//매년
					scriptHtml += schedule_everyyear;
				}
				scriptHtml += '<br/>';

				ampm = item.exe_hh >= 12 ? 'pm' : 'am';
				hours = item.exe_hh % 12;
				hours = hours.length < 2 ? '0'+hours : hours;
				minutes = item.exe_mm.length < 2 ? '0'+item.exe_mm : item.exe_mm;

				scriptHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + hours + ":" + minutes + " " + ampm;

				scriptCount = scriptCount + 1;
				scriptHtml += '</td>';
			}

			//4의 배수일때 tr 추가
			if (scriptCount % 4 == 0)  {
				scriptHtml += "</tr>";
				scriptHtml += "<tr>";
			}
		});

		scriptHtml += "</tr>";
	} else {
		scriptHtml += "<tr>";
		scriptHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#ededed;">';
		scriptHtml += dashboard_msg03
		scriptHtml += '</td>';
		scriptHtml += "</tr>";
	}

	$("#scriptScheduleCntList").html(scriptHtml);
	/////////////////////배치일정 end////////////////////////////////////////////////
}

/* ********************************************************
 * 스케줄 이력 설정
 ******************************************************** */
function fn_schedule_History_set(result) {
	var scdHisHtml = "";
	var scdHisChartHtml = "";
	var chartText = "";
	var chartColor = "";
	var chartCnt = 0;
	var chartMaxCnt = "";
	var chartWidth = "";
	var chartListCnt = 0;
	var db2_pgYn = "";
	
	///////////////////////////스케줄 list start ////////////////////////
	if (result.scheduleHistoryresult != null && result.scheduleHistoryresult.length > 0) {
		$(result.scheduleHistoryresult).each(function (index, item) {
			scdHisHtml +='	<tr>';
			
			scdHisHtml +='		<td><span onClick="javascript:fn_scdLayer('+item.scd_id+');" class="bold">'+item.scd_nm+'</span></td>';

			scdHisHtml +='		<td class="text-center">';
			if (item.bsn_dscd == "TC001901") {
				scdHisHtml += '<i class="ti-files text-primary"></i>';
				scdHisHtml += "&nbsp;" + dashboard_backup;
			} else if (item.bsn_dscd == "TC001902") {
				scdHisHtml += '<i class="fa fa-share-square-o text-success"></i>';
				scdHisHtml += "&nbsp;" + dashboard_script;
			} else {
				scdHisHtml += '<i class="ti-server text-warning"></i>';
				scdHisHtml += "&nbsp;" + dashboard_migration;
			}
			scdHisHtml +='	</td>';
			
			scdHisHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';
			scdHisHtml +='		<td class="text-center">'+item.wrk_end_dtm+'</td>';

			scdHisHtml +='		<td class="text-center">';
			if (item.exe_rslt_cd == "TC001701") {
				scdHisHtml += '<i class="fa fa-check text-primary">';
				scdHisHtml += '&nbsp;' + common_success + '</i>';
			} else if (item.exe_rslt_cd == "TC001702") {
				scdHisHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_failLog('+item.exe_sn+')">';
				scdHisHtml += '<i class="fa fa-times"></i>';
				scdHisHtml += common_failed;
				scdHisHtml += "</div>";

			} else {
				scdHisHtml += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
				scdHisHtml += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
				scdHisHtml += '&nbsp;' + etc_etc28;
				scdHisHtml += "</div>";
			}
			scdHisHtml +='	</td>';

			scdHisHtml +='	</tr>';
		});

	} else {
		scdHisHtml += "<tr>";
		scdHisHtml += '<td class="text-center" colspan="5" style="width:100%;border:none;height:20px;background-color:#ededed;">';
		scdHisHtml += dashboard_msg04
		scdHisHtml += '</td>';
		scdHisHtml += "</tr>";
	}

	$("#scheduleListT").html(scdHisHtml);
	///////////////////////////스케줄 list end ////////////////////////

	///////////////////////////스케줄 chart start ////////////////////////
	if (result.scheduleHistoryChart != null) {
		chartListCnt = 1;
	}

	db2_pgYn = nvlPrmSet($("#db2pg_yn", "#dashboardViewForm").val(), "N");

	if (db2_pgYn == "Y") {
		if ($("#scheduleHistChart").length) {
			var back_tot_cnt = 0; back_suc_cnt = 0; back_fal_cnt = 0;
			var script_tot_cnt = 0; script_suc_cnt = 0; script_fal_cnt = 0;
			var db2_pg_tot_cnt = 0; db2_pg_suc_cnt = 0; db2_pg_fal_cnt = 0;

			if  (chartListCnt > 0) {
				back_tot_cnt = nvlPrmSet(result.scheduleHistoryChart.back_tot_cnt, 0);
				back_suc_cnt = nvlPrmSet(result.scheduleHistoryChart.back_suc_cnt, 0);
				back_fal_cnt = nvlPrmSet(result.scheduleHistoryChart.back_fal_cnt, 0);
				script_tot_cnt = nvlPrmSet(result.scheduleHistoryChart.script_tot_cnt, 0);
				script_suc_cnt = nvlPrmSet(result.scheduleHistoryChart.script_suc_cnt, 0);
				script_fal_cnt = nvlPrmSet(result.scheduleHistoryChart.script_fal_cnt, 0);
				db2_pg_tot_cnt = nvlPrmSet(result.scheduleHistoryChart.db2_pg_tot_cnt, 0);
				db2_pg_suc_cnt = nvlPrmSet(result.scheduleHistoryChart.db2_pg_suc_cnt, 0);
				db2_pg_fal_cnt = nvlPrmSet(result.scheduleHistoryChart.db2_pg_fal_cnt, 0);
			}

			var schedulechart = Morris.Bar({
				element: 'scheduleHistChart',
				barColors: ['#76C1FA', '#63CF72', '#F36368'],
				data: [{
							scheduleGbn: dashboard_backup,
							tot_cnt: back_tot_cnt,
							suc_cnt: back_suc_cnt,
							fal_cnt: back_fal_cnt
						},
						{
							scheduleGbn: dashboard_script,
							tot_cnt: script_tot_cnt,
							suc_cnt: script_suc_cnt,
							fal_cnt: script_fal_cnt
						}
						/*,
						{
							scheduleGbn: dashboard_migration,
							tot_cnt: db2_pg_tot_cnt,
							suc_cnt: db2_pg_suc_cnt,
							fal_cnt: db2_pg_fal_cnt
						}*/
				],
				xkey: 'scheduleGbn',
				ykeys: ['tot_cnt', 'suc_cnt', 'fal_cnt'],
				labels: [dashboard_progress_end, common_success, common_failed]
			});
		}
	} else {
		for (var i = 0; i < 7; i++) {
			scdHisChartHtml += '<tr>';
			chartMaxCnt = "100";
			chartCnt = "0";
			chartWidth = "0";

			if (i == 0) {
				chartText = dashboard_schedule_history_cht_msg1;
				chartColor = "bg-success";

			} else if (i == 1) {
				chartText = dashboard_schedule_history_cht_msg2;
				chartColor = "bg-warning";

			} else if (i == 2) {
				chartText = dashboard_schedule_history_cht_msg3;	
				chartColor = "bg-primary";

			} else if (i == 3) {
				chartText = dashboard_schedule_history_cht_msg4;
				chartColor = "bg-danger";

			} else if (i == 4) {
				chartText = dashboard_schedule_history_cht_msg5;
				chartColor = "bg-warning";

			} else if (i == 5) {
				chartText = dashboard_schedule_history_cht_msg6;
				chartColor = "bg-primary";

			} else if (i == 6) {
				chartText = dashboard_schedule_history_cht_msg7;
				chartColor = "bg-danger";
			}
			chartWidth = Math.floor(nvlPrmSet(chartWidth, 0));

			scdHisChartHtml += '	<td class="text-muted">' + chartText + '</td>';
			scdHisChartHtml += '	<td class="w-100 px-0">';
			scdHisChartHtml += '		<div class="progress progress-md mx-4">';
			scdHisChartHtml += '			<div id="scd_pro_' + i + '" class="progress-bar ' + chartColor + '" role="progressbar" style="width: ' + chartWidth + '%" aria-valuenow="' + chartWidth + '" aria-valuemin="0" aria-valuemax="' + chartMaxCnt + '"></div>';
			scdHisChartHtml += '		</div>';
			scdHisChartHtml += '	</td>';
			scdHisChartHtml += '	<td><h5 class="font-weight-bold mb-0" id="scd_pro_text_' + i + '">' + chartCnt + '</h5></td>';

			scdHisChartHtml += "</tr>";
		}

		$("#scheduleHistChart").html(scdHisChartHtml);

		//스케줄 프로그레스바 설정
		if (chartListCnt > 0) {
			setTimeout(fn_schedule_History_progres, 1000, result.scheduleHistoryChart);
		}
	}
}

/* ********************************************************
 * 스케줄 history 프로그레스바 loading
 ******************************************************** */
function fn_schedule_History_progres(result) {
	var chartCnt = 0;
	var chartWidth = "";

	for (var i = 0; i < 7; i++) {
		chartCnt = 0;
		chartWidth = "";

		if (i == 0) {
			chartCnt = nvlPrmSet(result.tot_cnt, "0");
			chartWidth = "100";
		} else if (i == 1) { //백업건수 / 전체건수
			chartCnt = nvlPrmSet(result.back_tot_cnt, "0");
			chartWidth = parseInt(nvlPrmSet(result.back_tot_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		} else if (i == 2) { //백업성공건수 / 전체건수
			chartCnt = nvlPrmSet(result.back_suc_cnt, "0");
			chartWidth = parseInt(nvlPrmSet(result.back_suc_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		} else if (i == 3) { //백업실패건수 / 전체건수
			chartCnt = nvlPrmSet(result.back_fal_cnt, "0");
			chartWidth = parseInt(nvlPrmSet(result.back_fal_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		} else if (i == 4) { //배치건수 / 전체건수
			chartCnt = nvlPrmSet(result.script_tot_cnt, "0");
			chartWidth = parseInt(nvlPrmSet(result.script_tot_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		} else if (i == 5) {
			chartCnt = nvlPrmSet(result.script_suc_cnt, "0");
			chartWidth = parseInt(nvlPrmSet(result.script_suc_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		} else if (i == 6) {
			chartCnt = nvlPrmSet(result.script_fal_cnt, "0") ;
			chartWidth = parseInt(nvlPrmSet(result.script_fal_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
		}
		chartWidth = Math.floor(nvlPrmSet(chartWidth, 0));

		$("#scd_pro_" + i).css("width", chartWidth + "%"); 
		$("#scd_pro_text_" + i).html(chartCnt); 
	}
}

/* ********************************************************
 * 백업 이력 설정
 ******************************************************** */
/*function fn_backup_History_set(result) {
	var backHisHtml = "";
	
	///////////////////////////백업 list start ////////////////////////
	//데이터가 있는 경우
	if (result.backupHistoryresult != null && result.backupHistoryresult.length > 0) {
		$(result.backupHistoryresult).each(function (index, item) {
			backHisHtml +='	<tr>';
			
			backHisHtml +='		<td><span onClick=javascript:fn_workLayer("'+item.wrk_id+'"); class="bold" data-toggle="modal" title="'+item.wrk_nm+'">' + item.wrk_nm + '</span></td>';
			
			backHisHtml +='		<td class="text-center">';

			if (item.bck_bsn_dscd == 'TC000201') {
				if (item.bck_opt_cd == 'TC000301') {
					backHisHtml += '<i class="fa fa-paste mr-2 text-success"></i>';
					backHisHtml += backup_management_full_backup;
				} else if(item.bck_opt_cd == 'TC000302'){
					backHisHtml += '<i class="fa fa-paste mr-2 text-warning"></i>';
					backHisHtml += backup_management_incremental_backup;
				} else {
					backHisHtml += '<i class="fa fa-paste mr-2 text-info"></i>';
					backHisHtml += backup_management_change_log_backup;
				}
			} else {
				backHisHtml += '<i class="fa fa-file-code-o mr-2 text-danger"></i>';
				backHisHtml += dashboard_dump_backup;
			}
			backHisHtml +='	</td>';
			
			backHisHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';
			backHisHtml +='		<td class="text-center">'+item.wrk_end_dtm+'</td>';
			
			backHisHtml +='		<td class="text-center">';
			if (item.exe_rslt_cd == "TC001701") {
				backHisHtml += '<i class="fa fa-check text-primary">';
				backHisHtml += '&nbsp;' + common_success + '</i>';
			} else if (item.exe_rslt_cd == "TC001702") {
				backHisHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_failLog('+item.exe_sn+')">';
				backHisHtml += '<i class="fa fa-times"></i>';
				backHisHtml += common_failed;
				backHisHtml += "</div>";

			} else {
				backHisHtml += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
				backHisHtml += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
				backHisHtml += '&nbsp;' + etc_etc28;
				backHisHtml += "</div>";
			}
			backHisHtml +='	</td>';
			
			backHisHtml +='	</tr>';
		});

	} else {
		backHisHtml += "<tr>";
		backHisHtml += '<td class="text-center" colspan="5" style="width:100%;border:none;height:20px;background-color:#ededed;">';
		backHisHtml += dashboard_msg05
		backHisHtml += '</td>';
		backHisHtml += "</tr>";
	}

	$("#backupHistListT").html(backHisHtml);
	///////////////////////////백업 list end ////////////////////////

	///////////////////////////백업 chart start ////////////////////////
	if ($("#backupRmanHistChart").length) {
		var rmanchart = Morris.Bar({
						element: 'backupRmanHistChart',
						barColors: ['#76C1FA', '#FABA66', '#63CF72', '#F36368'],
						data: [{
							bck_opt_cd_nm: backup_management_full_backup,
							wrk_cnt: 0,
							schedule_cnt: 0,
							success_cnt: 0,
							fail_cnt: 0
							},
							{
								bck_opt_cd_nm: backup_management_incremental_backup,
								wrk_cnt: 0,
								schedule_cnt: 0,
								success_cnt: 0,
								fail_cnt: 0
							},
							{
								bck_opt_cd_nm: backup_management_change_log_backup,
								wrk_cnt: 0,
								schedule_cnt: 0,
								success_cnt: 0,
								fail_cnt: 0
							}
						],
						xkey: 'bck_opt_cd_nm',
						ykeys: ['wrk_cnt', 'schedule_cnt', 'success_cnt', 'fail_cnt'],
						labels: [common_registory, common_apply, common_success, common_failed]
		});

		if (result.backupRmanInfo != null) {
			if (result.backupRmanInfo.length > 0) {
				var backupRmanChart = [];
				for(var i = 0; i<result.backupRmanInfo.length; i++){
					if (result.backupRmanInfo[i].bck_opt_cd == "TC000301") {
						result.backupRmanInfo[i].bck_opt_cd_nm = backup_management_full_backup;
					} else if (result.backupRmanInfo[i].bck_opt_cd == "TC000302") {
						result.backupRmanInfo[i].bck_opt_cd_nm = backup_management_incremental_backup;
					} else {
						result.backupRmanInfo[i].bck_opt_cd_nm = backup_management_change_log_backup;
					}
					
					backupRmanChart.push(result.backupRmanInfo[i]);
				}	
		
				rmanchart.setData(backupRmanChart);
			}
		}
	}

	if ($("#backupDumpHistChart").length) {
		var dumpchart = Morris.Bar({
						element: 'backupDumpHistChart',
						barColors: ['#76C1FA', '#FABA66', '#63CF72', '#F36368'],
						data: [{
								db_nm: 'server',
								wrk_cnt: 0,
								schedule_cnt: 0,
								success_cnt: 0,
								fail_cnt: 0
							}
						],
						xkey: 'db_nm',
						ykeys: ['wrk_cnt', 'schedule_cnt', 'success_cnt', 'fail_cnt'],
						labels: [common_registory, common_apply, common_success, common_failed]
		});

		if (result.backupDumpInfo != null) {
			if (result.backupDumpInfo.length > 0) {
				dumpchart.setData(result.backupDumpInfo);
			}
		}
	}
	///////////////////////////백업 chart end ////////////////////////
	setTimeout(function()
		{
			$("#a_back_hist").click()
		},500);
}
*/
/* ********************************************************
 * 배치 이력 설정
 ******************************************************** */
/*function fn_script_History_set(result) {
	var scriptHisHtml = "";
	var chartListCnt = 0;

	///////////////////////////배치 list start ////////////////////////
	//데이터가 있는 경우
	if (result.scriptHistoryresult != null && result.scriptHistoryresult.length > 0) {
		$(result.scriptHistoryresult).each(function (index, item) {
			scriptHisHtml +='	<tr>';
			scriptHisHtml +='		<td><span onClick=javascript:fn_scriptLayer("'+item.wrk_id+'"); class="bold" data-toggle="modal" title="'+item.wrk_nm+'">' + item.wrk_nm + '</span></td>';
			scriptHisHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';
			scriptHisHtml +='		<td class="text-center">'+item.wrk_end_dtm+'</td>';
			scriptHisHtml +='		<td class="text-center">'+item.wrk_dtm+'</td>';
			
			scriptHisHtml +='		<td class="text-center">';
			if (item.exe_rslt_cd == "TC001701") {
				scriptHisHtml += '<i class="fa fa-check text-primary">';
				scriptHisHtml += '&nbsp;' + common_success + '</i>';
			} else if (item.exe_rslt_cd == "TC001702") {
				scriptHisHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_failLog('+item.exe_sn+')">';
				scriptHisHtml += '<i class="fa fa-times"></i>';
				scriptHisHtml += common_failed;
				scriptHisHtml += "</div>";
			} else {
				scriptHisHtml += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
				scriptHisHtml += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
				scriptHisHtml += '&nbsp;' + etc_etc28;
				scriptHisHtml += "</div>";
			}
			scriptHisHtml +='	</td>';
			
			scriptHisHtml +='	</tr>';
		});

	} else {
		scriptHisHtml += "<tr>";
		scriptHisHtml += '<td class="text-center" colspan="5" style="width:100%;border:none;height:20px;background-color:#ededed;">';
		scriptHisHtml += dashboard_msg05
		scriptHisHtml += '</td>';
		scriptHisHtml += "</tr>";
	}

	$("#scriptHistListT").html(scriptHisHtml);
	///////////////////////////배치 list end ////////////////////////

	///////////////////////////배치 chart start ////////////////////////
	if ($("#scriptHistChart").length) {
		var tot_cnt = 0; ins_cnt = 0; suc_cnt = 0; fal_cnt = 0;

		if  (result.scriptHistoryChart != null) {
			tot_cnt = nvlPrmSet(result.scriptHistoryChart.tot_cnt, 0);
			ins_cnt = nvlPrmSet(result.scriptHistoryChart.ins_cnt, 0);
			suc_cnt = nvlPrmSet(result.scriptHistoryChart.suc_cnt, 0);
			fal_cnt = nvlPrmSet(result.scriptHistoryChart.fal_cnt, 0);
		}

		var options = {
				responsive: false,
				scales: {
					yAxes: [{
						ticks: {
							beginAtZero: true
						}
					}]
				},
				legend: {
					display: false
				},
				elements: {
					point: {
						radius: 0
					}
				}
		};
		
		var data = {
				labels: [common_registory, dashboard_progress_end, common_success, common_failed],
				datasets: [{
					label: 'count :',
					data: [tot_cnt, ins_cnt, suc_cnt, fal_cnt],
					backgroundColor: [
						'rgba(54, 162, 235, 0.2)',
						'rgba(255, 206, 86, 0.2)',
						'rgba(75, 192, 192, 0.2)',
						'rgba(255, 99, 132, 0.2)'
					],
					borderColor: [
						'rgba(54, 162, 235, 1)',
						'rgba(255, 206, 86, 1)',
						'rgba(75, 192, 192, 1)',
						'rgba(255,99,132,1)'
					],
					borderWidth: 1,
					fill: false
				}]
		};

		var barChartCanvas = $("#scriptHistChart").get(0).getContext("2d");
		var barChart = new Chart(barChartCanvas, {
			type: 'bar',
			data: data,
			options: options
		});
	}
	///////////////////////////배치 chart end ////////////////////////
	setTimeout(function()
			{
				$("#a_script_hist").click()
			},500);
}*/

/* ********************************************************
 * migration setting
 ******************************************************** */
function fn_migration_history_set(result) {
	var checkDt = todayChkMonth + "" + todayChkDate;
	var checkYear = todayChkYear + "" + todayChkMonth + "" + todayChkDate; //전체 날짜
	var checkDay = todayChkDate;

	var migtHtml = "";
	var exe_perd_cd_val = "";
	var scdHK = "";
	var checkMons = "";
	var ampm ="";
	var hours = "";
	var migtCount=0;

	var migtHisHtml = "";
	var migtHisChartHtml = "";
	var chartMaxCnt = "";
	var chartCnt = 0;
	var chartWidth = "";
	var chartText = "";
	var chartColor = "";

	/////////////////////migration 일정 start////////////////////////////////////////////////
//	if (result.migtScdCnt != null && result.migtScdCnt > 0) {
//		migtHtml += "<tr>";
//		
//		$(result.migtScdresult).each(function (index, item) {
//			exe_perd_cd_val = item.exe_perd_cd;
//			scdHK = "";
//			var resultYearCheckDt = item.exe_month + "" + item.exe_day;
//			
//			if(exe_perd_cd_val == 'TC001605') {			//1회실행
//				if(item.exe_dt == checkYear) {
//					scdHK = 'TC001605';
//				}
//			} else if(exe_perd_cd_val == 'TC001601') {		//매일
//				if(item.frst_reg_dtm <= checkYear) {
//					scdHK = 'TC001601';
//				}
//			} else if(exe_perd_cd_val == 'TC001602') {		//매주
//				if(item.frst_reg_dtm <= checkYear) {
//					for(var i=0;i<7;i++){
//						if(item.exe_dt.substr(i,1) == '1') {
//							checkMons = i;
//						}
//
//						if (checkMons == todayChkDay) {
//							scdHK = 'TC001602';
//							continue;
//						}
//					}
//				}
//			} else if(exe_perd_cd_val == 'TC001603') {			//매월
//				if(item.frst_reg_dtm <= checkYear) {
//					if(item.exe_day == checkDay) {
//						scdHK = 'TC001603';
//					}
//				}
//			} else if(exe_perd_cd_val == 'TC001604') {
//				if(item.frst_reg_dtm <= checkYear) {
//					if(resultYearCheckDt == checkDt) {
//						scdHK = 'TC001604';
//					}
//				}
//			}
//
//			if (scdHK != null && scdHK != "") {
//				migtHtml += '<td style="width:33%;line-height:150%;border:none;">';
//				
//				migtHtml += "	<i class='fa fa-exchange mr-2 text-info' ></i>";
//				migtHtml += "	<a class='nav-link_title' href='#' onclick='fn_scheduleListMove(\""+item.scd_nm+"\");'>";
//				migtHtml += "		&nbsp;"+ item.scd_nm;
//				migtHtml += "	</a>";
//				migtHtml += '	<br/>';
//				
//				if (item.scd_cndt == 'TC001801') { //대기
//					migtHtml += "	<i class='fa fa-circle mr-2 text-success' ></i>";
//				} else { //실행중
//					migtHtml += '	<div class="badge badge-pill badge-warning">' + dashboard_running + '</div>';
//				}
//				
//				if(scdHK == 'TC001605') { 				//1회실행
//					migtHtml += schedule_one_time_run;
//				} else if(scdHK == 'TC001601') { 		//매일
//					migtHtml += schedule_everyday;
//				} else if (scdHK == 'TC001602') {		//매주
//					migtHtml += schedule_everyweek;
//				} else if (scdHK == 'TC001603') {		//매월
//					migtHtml += schedule_everymonth;
//				} else if(scdHK == 'TC001604') {	//매년
//					migtHtml += schedule_everyyear;
//				}
//				migtHtml += '<br/>';
//				
//				ampm = item.exe_hh >= 12 ? 'pm' : 'am';
//				hours = item.exe_hh % 12;
//				hours = hours.length < 2 ? '0'+hours : hours;
//				minutes = item.exe_mm.length < 2 ? '0'+item.exe_mm : item.exe_mm;
//				
//				migtHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + hours + ":" + minutes + " " + ampm;
//				
//				migtCount = migtCount + 1;
//				
//				migtHtml += '</td>';
//			}
//
//			//4의 배수일때 tr 추가
//			if (migtCount % 3 == 0)  {
//				migtHtml += "</tr>";
//				migtHtml += "<tr>";
//			}
//		});
//		
//		migtHtml += "</tr>";
//	} else {
//		migtHtml += "<tr>";
//		migtHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#ededed;">';
//		migtHtml += dashboard_msg06
//		migtHtml += '</td>';
//		migtHtml += "</tr>";
//	}
//
//	$("#migtHistCntList").html(migtHtml);
	/////////////////////migration 일정 end////////////////////////////////////////////////

	///////////////////////////migration list start ////////////////////////	
//	if (result.migtHistoryresult != null && result.migtHistoryresult.length > 0) {
//		$(result.migtHistoryresult).each(function (index, item) {
//			migtHisHtml +='	<tr>';
//			
//			migtHisHtml +='		<td>'+item.wrk_nm+'</td>';
//			
//			migtHisHtml +='		<td class="text-center">';
//			if (item.migt_gbn == "DDL") {
//				migtHisHtml += '<i class="fa fa-archive text-primary">';
//			} else {
//				migtHisHtml += '<i class="fa fa-file text-success">';
//			}
//			migtHisHtml += "&nbsp;" + item.migt_gbn;
//			migtHisHtml += '</i>';
//			migtHisHtml +='	</td>';
//			
//			migtHisHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';
//			migtHisHtml +='		<td class="text-center">'+item.wrk_end_dtm+'</td>';
//			migtHisHtml +='		<td class="text-center">'+item.wrk_dtm+'</td>';
//			
//			migtHisHtml +='		<td class="text-center">';
//			if (item.exe_rslt_cd == "TC001701") {
///*				if (item.migt_gbn == "DDL") {
//
//					migtHisHtml += '<div class="badge badge-pill badge-primary " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_dash_ddlResult(\''+item.mig_exe_sn+'\',\''+item.save_pth+'/\')">';
//				} else {
//					migtHisHtml += '<div class="badge badge-pill badge-primary " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_dash_migtResult(\''+item.mig_exe_sn+'\',\''+item.save_pth+'/\')">';
//				}
//				migtHisHtml += '<i class="fa fa-check"></i>';
//				migtHisHtml += common_success;
//				migtHisHtml += "</div>";
//				*/
//				migtHisHtml += '<i class="fa fa-check text-primary">';
//				migtHisHtml += '&nbsp;' + common_success + '</i>';
///*				
//				migtHisHtml += '<input class="btn btn-primary btn-sm" width="200px;" style="vertical-align:middle;" onclick="fn_dash_ddlResult(\''+item.mig_exe_sn+'\',\''+item.save_pth+'/\')" type="button" value="'+common_success+ '" />';
//				
//					*/
//			} else if(item.exe_rslt_cd == 'TC001702'){
//				if (item.migt_gbn == "DDL") {
//					migtHisHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_dash_ddlFailLog('+item.mig_exe_sn+')">';
//				} else {
//					migtHisHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_dash_migtFailLog('+item.mig_exe_sn+')">';
//				}
//
//				migtHisHtml += '<i class="fa fa-times"></i>';
//				migtHisHtml += common_failed;
//				migtHisHtml += "</div>";
//			} else {
//				migtHisHtml += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
//				migtHisHtml += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
//				migtHisHtml += '&nbsp;' + etc_etc28;
//				migtHisHtml += "</div>";
//			}
//			migtHisHtml +='	</td>';
//
//			migtHisHtml +='	</tr>';
//		});
//
//	} else {
//		migtHisHtml += "<tr>";
//		migtHisHtml += '<td class="text-center" colspan="6" style="height:300px;border:none;height:20px;background-color:#ededed;">';
//		migtHisHtml += dashboard_msg07
//		migtHisHtml += '</td>';
//		migtHisHtml += "</tr>";
//	}

//	$("#migrationListT").html(migtHisHtml);
	///////////////////////////migration list end ////////////////////////

	///////////////////////////migration chart start ////////////////////////
//	if ($("#migtHistChart").length) {
//		for (var i = 0; i < 7; i++) {
//			chartMaxCnt = "100";
//			chartCnt = "0";
//			chartWidth = "0";
//
//			if (i == 0) {
//				chartText = dashboard_schedule_history_cht_msg1;
//				chartColor = "bg-success";
//
//			} else if (i == 1) {
//				chartText = dashboard_migration_all;
//				chartColor = "bg-warning";
//
//			} else if (i == 2) {
//				chartText = dashboard_migration_success;	
//				chartColor = "bg-primary";
//
//			} else if (i == 3) {
//				chartText = dashboard_migration_failed;
//				chartColor = "bg-danger";
//
//			} else if (i == 4) {
//				chartText = dashboard_ddl_all;
//				chartColor = "bg-warning";
//
//			} else if (i == 5) {
//				chartText = dashboard_ddl_success;
//				chartColor = "bg-primary";
//
//			} else if (i == 6) {
//				chartText = dashboard_ddl_failed;
//				chartColor = "bg-danger";
//			}
//			chartWidth = Math.floor(nvlPrmSet(chartWidth, 0));
//			
//			migtHisChartHtml += '<tr>';
//
//			migtHisChartHtml += '	<td class="text-muted">' + chartText + '</td>';
//			migtHisChartHtml += '	<td class="w-100 px-0">';
//			migtHisChartHtml += '		<div class="progress progress-md mx-4">';
//			migtHisChartHtml += '			<div id="migt_pro_' + i + '" class="progress-bar ' + chartColor + ' progress-bar-striped progress-bar-animated" role="progressbar" style="width: ' + chartWidth + '%" aria-valuenow="' + chartWidth + '" aria-valuemin="0" aria-valuemax="' + chartMaxCnt + '"></div>';
//			migtHisChartHtml += '		</div>';
//			migtHisChartHtml += '	</td>';
//			migtHisChartHtml += '	<td><h5 class="font-weight-bold mb-0" id="migt_pro_text_' + i + '">' + chartCnt + '</h5></td>';
//			
//			migtHisChartHtml += "</tr>";
//		}
//
//		$("#migtHistChart").html(migtHisChartHtml);
//
//		//프로그레스바 설정
//		if (result.migtHistoryChart != null) {
//			setTimeout(fn_migt_History_progres, 1000, result.migtHistoryChart);
//		}
		///////////////////////////migration chart end ////////////////////////
//	}
}

/* ********************************************************
 * migration history 프로그레스바 loading
 ******************************************************** */
function fn_migt_History_progres(result) {
	var chartCnt = 0;
	var chartWidth = "";

//	for (var i = 0; i < 7; i++) {
//		chartCnt = 0;
//		chartWidth = "";
//		
//		if (i == 0) {
//			chartCnt = nvlPrmSet(result.tot_cnt, "0");
//			if (chartCnt == "0") {
//				chartWidth = "0";
//			} else {
//				chartWidth = "100";
//			}
//		} else if (i == 1) { //배치건수 / 전체건수
//			chartCnt = nvlPrmSet(result.migration_tot_cnt, "0");
//			chartWidth = parseInt(nvlPrmSet(result.migration_tot_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		} else if (i == 2) {
//			chartCnt = nvlPrmSet(result.migration_suc_cnt, "0");
//			chartWidth = parseInt(nvlPrmSet(result.migration_suc_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		} else if (i == 3) {
//			chartCnt = nvlPrmSet(result.migration_fal_cnt, "0") ;
//			chartWidth = parseInt(nvlPrmSet(result.migration_fal_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		} else if (i == 4) { //백업건수 / 전체건수
//			chartCnt = nvlPrmSet(result.ddl_tot_cnt, "0");
//			chartWidth = parseInt(nvlPrmSet(result.ddl_tot_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		} else if (i == 5) { //백업성공건수 / 전체건수
//			chartCnt = nvlPrmSet(result.ddl_suc_cnt, "0");
//			chartWidth = parseInt(nvlPrmSet(result.ddl_suc_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		} else if (i == 6) { //백업실패건수 / 전체건수
//			chartCnt = nvlPrmSet(result.ddl_fal_cnt, "0");
//			chartWidth = parseInt(nvlPrmSet(result.ddl_fal_cnt, "0")) / parseInt(nvlPrmSet(result.tot_cnt, "0")) * 100;
//		}
//		
//		
//		chartWidth = Math.floor(nvlPrmSet(chartWidth, 0));
//
//		$("#migt_pro_" + i).css("width", chartWidth + "%"); 
//		$("#migt_pro_text_" + i).html(chartCnt); 
//	}
}

/* ********************************************************
 * scale setting
 ******************************************************** */
function fn_scale_history_set(result) {
	if (result.scale_install_yn != null && result.scale_install_yn == "Y") {
		$("#scale_div_none").hide();
		$("#scale_div_set").show();

		var scaleHistHtml = "";
		var chartListCnt = 0;

		///////////////////////////scale hist list start ////////////////////////
		//데이터가 있는 경우
		if (result.scaleHistoryresult != null && result.scaleHistoryresult.length > 0) {
			$(result.scaleHistoryresult).each(function (index, item) {
				scaleHistHtml +='	<tr>';
				scaleHistHtml +='		<td>' + item.process_id + '</td>';

				if (item.scale_type == "1") {
					scaleHistHtml +='		<td class="text-center">' + etc_etc38 + '</td>';
				} else {
					scaleHistHtml +='		<td class="text-center">' + etc_etc39 + '</td>';
				}

				scaleHistHtml +='		<td class="text-center">';
				if (item.wrk_type == "TC003301") {
					scaleHistHtml += "		<div class='badge badge-pill badge-success'>";
					scaleHistHtml += "			<i class='fa fa-spin fa-spinner mr-2'></i>";
					scaleHistHtml += item.wrk_type_nm;
					scaleHistHtml += "		</div>";
				} else {
					scaleHistHtml += "<div class='badge badge-pill badge-warning'>";
					scaleHistHtml += "	<i class='fa fa-user-o mr-2'></i>";
					scaleHistHtml += item.wrk_type_nm;
					scaleHistHtml += "</div>";
				}
				scaleHistHtml +='	</td>';

				scaleHistHtml +='		<td class="text-center">';
				if (item.wrk_type == "TC003301") {
					if (item.policy_type_nm == "CPU") {
						scaleHistHtml += "<div class='badge badge-pill badge-info'>";
						scaleHistHtml += '<i class="mdi mdi-vector-square"></i>';
						scaleHistHtml += item.policy_type_nm;
						scaleHistHtml += "</div>";
					} else {
						scaleHistHtml += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
						scaleHistHtml += '<i class="mdi mdi-gender-transgender"></i>';
						scaleHistHtml += item.policy_type_nm;
						scaleHistHtml += "</div>";
					}

					scaleHistHtml += " (";
					if (item.auto_policy_set_div == "1") {
						scaleHistHtml += eXperDB_scale_policy_time_1;
					} else {
						scaleHistHtml += eXperDB_scale_policy_time_2 ;
					}

					scaleHistHtml += ' ' + item.auto_level;
						
					if (item.auto_policy == "TC003501") {
						scaleHistHtml += '%';
					}
						
					scaleHistHtml += ' ' + item.auto_policy_time + "minutes) ";

					if (item.scale_type == "1") {
						scaleHistHtml += eXperDB_scale_under;
					} else {
						scaleHistHtml += eXperDB_scale_or_more;
					}
				}
				scaleHistHtml +='	</td>';
				
				scaleHistHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';

				scaleHistHtml +='		<td class="text-center">';
				if(item.wrk_id == "2"){
					scaleHistHtml += item.wrk_end_dtm;
				} else {
					scaleHistHtml += "";
				}
				scaleHistHtml +='	</td>';

				scaleHistHtml +='		<td class="text-center">';
				if (item.exe_rslt_cd == 'TC001701' && item.wrk_id == '2') {
					scaleHistHtml += '<i class="fa fa-check text-primary">';
					scaleHistHtml += '&nbsp;' + common_success + '</i>';
				} else if(item.exe_rslt_cd == 'TC001702' && item.wrk_id == '2') {
					scaleHistHtml += '<div class="badge badge-pill badge-danger " style="font-size: 0.75rem;cursor:pointer;" onclick="fn_dash_scaleFailLog('+item.scale_wrk_sn+')">';
					scaleHistHtml += '<i class="fa fa-times"></i>';
					scaleHistHtml += common_failed;
					scaleHistHtml += "</div>";
				} else {
					scaleHistHtml += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
					scaleHistHtml += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
					scaleHistHtml += '&nbsp;' + etc_etc28;
					scaleHistHtml += "</div>";
				}

				scaleHistHtml +='	</td>';
				
				scaleHistHtml +='	</tr>';
			});
		} else {
			scaleHistHtml += "<tr>";
			scaleHistHtml += '<td class="text-center" colspan="7" style="width:100%;border:none;height:20px;background-color:#ededed;">';
			scaleHistHtml += dashboard_msg10
			scaleHistHtml += '</td>';
			scaleHistHtml += "</tr>";
		}

		$("#scaleHistListT").html(scaleHistHtml);
		///////////////////////////scale list end ////////////////////////

		///////////////////////////scale chart start ////////////////////////

		if ($("#scaleHistChart").length) {
			var scalechart = Morris.Bar({
							element: 'scaleHistChart',
							barColors: ['#76C1FA', '#FABA66', '#63CF72', '#F36368'],
							data: [{
									scale_nm: etc_etc38 + "-" + dashboard_auto,
									suc: 0,
									fal: 0
								},
								{
									scale_nm: etc_etc39 + "-" + dashboard_auto,
									suc: 0,
									fal: 0
								},
								{
									scale_nm: etc_etc38 + "-" + dashboard_manual,
									suc: 0,
									fal: 0
								},
								{
									scale_nm: etc_etc39 + "-" + dashboard_manual,
									wrksuc_cnt: 0,
									fal: 0
								}
							],
							xkey: 'scale_nm',
							ykeys: ['suc', 'fal'],
							labels: [common_success, common_failed]
			});

			if (result.scaleSettingChartresult != null) {
				if (result.scaleSettingChartresult.length > 0) {
					var scaleHitChart = [];
					for(var i = 0; i<result.scaleSettingChartresult.length; i++){
						if (result.scaleSettingChartresult[i].scale_nm == "scale_nm0") {
							result.scaleSettingChartresult[i].scale_nm = etc_etc38 + "-" + dashboard_auto;
						} else if (result.scaleSettingChartresult[i].scale_nm == "scale_nm1") {
							result.scaleSettingChartresult[i].scale_nm = etc_etc39 + "-" + dashboard_auto;
						} else if (result.scaleSettingChartresult[i].scale_nm == "scale_nm2") {
							result.scaleSettingChartresult[i].scale_nm = etc_etc38 + "-" + dashboard_manual;
						} else {
							result.scaleSettingChartresult[i].scale_nm = etc_etc39 + "-" + dashboard_manual;
						}

						scaleHitChart.push(result.scaleSettingChartresult[i]);
					}

					scalechart.setData(scaleHitChart);
				}
			}
		}

		//발생이력
		if ($("#scaleSetChart").length) {
			var occur_in_auto = 0; occur_out_auto = 0; occur_in_nct = 0; occur_out_nct = 0;

			if  (result.scaleSettingChart != null) {
				occur_in_auto = nvlPrmSet(result.scaleSettingChart.occur_in_auto, 0);
				occur_out_auto = nvlPrmSet(result.scaleSettingChart.occur_out_auto, 0);
				occur_in_nct = nvlPrmSet(result.scaleSettingChart.occur_in_nct, 0);
				occur_out_nct = nvlPrmSet(result.scaleSettingChart.occur_out_nct, 0);
			}

			var options = {
					responsive: false,
					scales: {
						yAxes: [{
							ticks: {
								beginAtZero: true
							}
						}]
					},
					legend: {
						display: false
					},
					elements: {
						point: {
							radius: 0
						}
					}
			};

			var data = {
					labels: [common_registory, dashboard_progress_end, common_success, common_failed],
					datasets: [{
						label: 'count :',
						data: [occur_in_auto, occur_out_auto, occur_in_nct, occur_out_nct],
						backgroundColor: [
							'rgba(54, 162, 235, 0.2)',
							'rgba(255, 206, 86, 0.2)',
							'rgba(75, 192, 192, 0.2)',
							'rgba(255, 99, 132, 0.2)'
						],
						borderColor: [
							'rgba(54, 162, 235, 1)',
							'rgba(255, 206, 86, 1)',
							'rgba(75, 192, 192, 1)',
							'rgba(255,99,132,1)'
						],
						borderWidth: 1,
						fill: false
					}]
			};

			var barChartCanvas = $("#scaleSetChart").get(0).getContext("2d");
			var barChart = new Chart(barChartCanvas, {
				type: 'bar',
				data: data,
				options: options
			});
		}
		///////////////////////////백업 chart end ////////////////////////
		setTimeout(function()
			{
				$("#a_scale_hist").click()
			},500);
	} else { //aws 서버가 아닌경우
		$("#scale_div_none").show();
		$("#scale_div_set").hide();
	}
}

/* ********************************************************
 * ERROR 로그 정보 출력
 ******************************************************** */
function fn_dash_scaleFailLog(scale_wrk_sn){
	$.ajax({
		url : "/scale/selectScaleWrkErrorMsg.do",
		data : {
			scale_wrk_sn : scale_wrk_sn,
			db_svr_id : $("#dvb_svr_id_chk", "#dashboardViewForm").val()
		},
		dataType : "json",
		type : "post",
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
				if (nvlPrmSet(result.rslt_msg,"") == "Auto scale-in_fail") {
					result.rslt_msg = eXperDB_scale_msg11;
				} else if (nvlPrmSet(result.rslt_msg,"") == "Auto scale-out_fail") {
					result.rslt_msg = eXperDB_scale_msg12;
				}

				if (result.rslt_msg != "") {
					result.rslt_msg = fn_strBrReplcae(result.rslt_msg);
				}

				$("#d_scaleWrkLogInfo").html(result.rslt_msg);
				$('#scale_wrk_menu_move').hide();
				
				$('#pop_layer_err_msg').modal("show");
			} else {
				$("#d_scaleWrkLogInfo").html("");
				$('#pop_layer_err_msg').modal("hide");
			}
		}
	});
}

/* ********************************************************
 * DDL추출 로그 팝업
 ******************************************************** */
function fn_dash_ddlResult(mig_exe_sn, ddl_save_pth){
//	$.ajax({
//			url : "/db2pg/popup/db2pgResultDDL.do", 
//			data : {
//		  		mig_exe_sn : mig_exe_sn,
//		  		ddl_save_pth :ddl_save_pth
//		  	},
//			dataType : "json",
//			type : "post",
//			beforeSend: function(xhr) {
//				xhr.setRequestHeader("AJAX", true);
//			},
//			error : function(xhr, status, error) {
//				if(xhr.status == 401) {
//					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
//				} else if(xhr.status == 403) {
//					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
//				} else {
//					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
//				}
//			},
//			success : function(result) {		
//				$('#ddl_result_wrk_nm').html("");
//				$('#ddl_result_wrk_exp').html("");
//				$('#ddl_result_exe_rslt_cd').html("");	
//				
//				fn_ddlResultInit();
//
//				if (result.result != null) {
//					$('#ddl_result_wrk_nm').html(result.result.wrk_nm);
//					$('#ddl_result_wrk_exp').html(result.result.wrk_exp);
//					$('#ddl_result_exe_rslt_cd').html('<i class="fa fa-check-circle text-primary" >&nbsp;' + common_success + '</i>');
//				}
//
//				if (result.ddl_save_pth != null && result.ddl_save_pth != "") {
//					getDataResultList(result.ddl_save_pth);
//				}
//
//				$('#pop_layer_db2pgResultDDL').modal("show");
//			}
//	});
}

/* ********************************************************
 * MIGRATION 로그 팝업
 ******************************************************** */
function fn_dash_migtResult(mig_exe_sn, trans_save_pth){
//	$.ajax({
//			url : "/db2pg/popup/db2pgResult.do", 
//		  	data : {
//		  		mig_exe_sn : mig_exe_sn,
//		  		trans_save_pth :trans_save_pth
//		  	},
//			dataType : "json",
//			type : "post",
//			beforeSend: function(xhr) {
//		        xhr.setRequestHeader("AJAX", true);
//		    },
//			error : function(xhr, status, error) {
//				if(xhr.status == 401) {
//					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
//				} else if(xhr.status == 403) {
//					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
//				} else {
//					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
//				}
//			},
//			success : function(result) {
//				$('#mig_result_wrk_nm').html("");
//				$('#mig_result_wrk_exp').html("");
//				$('#mig_result_wrk_strt_dtm').html("");
//				$('#mig_result_wrk_end_dtm').html("");
//				$('#mig_result_wrk_dtm').html("");				
//				$('#mig_result_exe_rslt_cd').html("");
//				
//				$('#mig_result_msg').html("");
//				
//				if (result.result != null) {
//					$('#mig_result_wrk_nm').html(result.result.wrk_nm);
//					$('#mig_result_wrk_exp').html(result.result.wrk_exp);
//					$('#mig_result_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
//					$('#mig_result_wrk_end_dtm').html(result.result.wrk_end_dtm);
//					$('#mig_result_wrk_dtm').html(result.result.wrk_dtm);
//					
//					$('#mig_result_exe_rslt_cd').html('<i class="fa fa-check-circle text-primary" >&nbsp;' + common_success + '</i>');
//				}
//				
//				if(result.db2pgResult == null){
//					$('#mig_result_msg').html("파일이 삭제되어 작업로그정보를 출력할 수 없습니다.");	
//				}else{
//					$('#mig_result_msg').html(result.db2pgResult.RESULT);	
//				}
//
//				$('#pop_layer_db2pgResult').modal("show"); 
//			}
//	});
}

/* ********************************************************
 * DDL 에러 로그 팝업
 *********************************************************/
function fn_dash_ddlFailLog(mig_exe_sn){
//	$.ajax({
//			url : "/db2pg/popup/db2pgDdlErrHistoryDetail.do", 
//		  	data : {
//		  		mig_exe_sn:mig_exe_sn
//		  	},
//			dataType : "json",
//			type : "post",
//			beforeSend: function(xhr) {
//		        xhr.setRequestHeader("AJAX", true);
//		    },
//			error : function(xhr, status, error) {
//				if(xhr.status == 401) {
//					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
//				} else if(xhr.status == 403) {
//					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
//				} else {
//					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
//				}
//			},
//			success : function(result) {
//				$('#pop_wrk_nm').html("");
//				$('#pop_wrk_exp').html("");
//				$('#pop_wrk_strt_dtm').html("");
//				$('#pop_wrk_end_dtm').html("");
//				$('#pop_wrk_dtm').html("");
//				$('#pop_exe_rslt_cd').html("");
//				$("#pop_rslt_msg", "#subForm").val(""); 
//				
//				if (result.result != null) {
//					$('#pop_wrk_nm').html(result.result.wrk_nm);
//					$('#pop_wrk_exp').html(result.result.wrk_exp);
//					$('#pop_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
//					$('#pop_wrk_end_dtm').html(result.result.wrk_end_dtm);
//					$('#pop_wrk_dtm').html(result.result.wrk_dtm);
//					$('#pop_exe_rslt_cd').html('<i class="fa fa-times text-danger">&nbsp;' + common_failed + '</i>');
//					$("#pop_rslt_msg", "#subForm").val(nvlPrmSet(result.result.rslt_msg, "")); 
//				}
//
//				$('#pop_layer_db2pgDdlErrHistoryDetail').modal("show");
//			}
//	});
}

/* ********************************************************
 * MIGRATION 에러 로그 팝업
 ******************************************************** */
function fn_dash_migtFailLog(mig_exe_sn){
//	$.ajax({
//			url : "/db2pg/popup/db2pgMigErrHistoryDetail.do", 
//		  	data : {
//		  		mig_exe_sn:mig_exe_sn
//		  	},
//			dataType : "json",
//			type : "post",
//			beforeSend: function(xhr) {
//		        xhr.setRequestHeader("AJAX", true);
//		    },
//			error : function(xhr, status, error) {
//				if(xhr.status == 401) {
//					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
//				} else if(xhr.status == 403) {
//					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
//				} else {
//					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
//				}
//			},
//			success : function(result) {
//				$('#pop_wrk_nm').html("");
//				$('#pop_wrk_exp').html("");
//				$('#pop_wrk_strt_dtm').html("");
//				$('#pop_wrk_end_dtm').html("");
//				$('#pop_wrk_dtm').html("");
//				$('#pop_exe_rslt_cd').html("");
//				$("#pop_rslt_msg", "#subForm").val(""); 
//				
//				if (result.result != null) {
//					$('#pop_wrk_nm').html(result.result.wrk_nm);
//					$('#pop_wrk_exp').html(result.result.wrk_exp);
//					$('#pop_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
//					$('#pop_wrk_end_dtm').html(result.result.wrk_end_dtm);
//					$('#pop_wrk_dtm').html(result.result.wrk_dtm);
//					$('#pop_exe_rslt_cd').html('<i class="fa fa-times text-danger">&nbsp;' + common_failed + '</i>');
//					$("#pop_rslt_msg", "#subForm").val(nvlPrmSet(result.result.rslt_msg, "")); 
//				}
//
//				$('#pop_layer_db2pgDdlErrHistoryDetail').modal("show");
//			}
//	});
}

/* ********************************************************
 * 스케줄관리 화면이동
 ******************************************************** */
function fn_scheduleListMove(scd_nm) {
	$("#scd_nm", "#dashboardViewForm").val(scd_nm);

	$("#dashboardViewForm").attr("action", "/selectScheduleListView.do");
	$("#dashboardViewForm").submit();
}

/* ********************************************************
 * proxy setting
 ******************************************************** */
function fn_prySearch(db_svr_id_val) {
	$.ajax({
		url : "/proxyMonitoring/dashboardProxy.do",
		data : {
			db_svr_id : db_svr_id_val
		},
		dataType : "json",
		type : "post",
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
			//update setting
			fn_proxyInit(result);
		}
	});
}

/* ********************************************************
* 프록시 서버정보 상세 설정
******************************************************** */
function fn_proxyInit(result) {
	if (result.proxyServerByDBSvrId.length > 0) {
		// vip 모니터링
		fn_keepMonInfo(result);

		// 프록시 모니터링 setting
		fn_proxyMonInfo(result);

		// 프록시 연결 db 모니터링 setting
		fn_dbMonInfo(result);
		$("#reg_pry_title").show();
		$("#reg_pry_detail").show();
		$("#no_reg_pry_detail").hide();
	} else {
		$("#reg_pry_title").hide();
		$("#reg_pry_detail").hide();
		$("#no_reg_pry_detail").show();
	}

	setTimeout(function(){
		$('[data-toggle="tooltip"]').tooltip({
			template: '<div class="tooltip tooltip-warning" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
		});
	},250);
}

/* ********************************************************
* vip 모니터링 셋팅
******************************************************** */
function fn_keepMonInfo(result){
	var rowCount = 0;
	var html_vip = "";
	var html_sebu = "";
	var html_vip_line = "";
	var html_listner = "";
	var master_gbn = "";
	var pry_svr_id = "";
	var listCnt = 0;
	var pry_svr_id_val = "";
	var proxyServerByDBSvrId_cnt = result.proxyServerByDBSvrId.length;
	var master_state = "";
	var exe_status_chk = "";
	var kal_exe_status_chk = "";
	var exe_status_css = "";
	var kal_exe_status_css = "";
	var strVip = "";
	var kal_install_yn = "";

	//ROW 만들기
	for(var i = 0; i < proxyServerByDBSvrId_cnt; i++){
		var pry_agent_status = result.proxyServerByDBSvrId[i].conn_result;

		//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임

		html_vip += '	<p class="card-title" style="margin-bottom:-25px;margin-left:10px;">\n';
		html_vip += '	<span id="vip_proxy_nm' + i + '"></span>\n';
		html_vip += '	</p>\n';
		
		html_vip += '	<table class="table-borderless" style="width:100%;">\n';
		html_vip += '		<tr>\n';

		html_vip += '			<td style="width:80%;height:240px;" class="text-center" id="keepVipDiv' + i + '">\n';
		html_vip += '			&nbsp;</td>\n';

		html_vip += '		</tr>\n';
		html_vip += '	</table>\n';
		if(i == 0) {
			html_vip_line += '	<p class="card-title" style="margin-bottom:-15px;margin-left:10px;">\n';
		} else {
			html_vip_line += '	<p class="card-title" style="margin-bottom:-15px;margin-left:10px;padding-top:2rem;">\n';
		}
		html_vip_line += '	<span>&nbsp;</span>\n';
		html_vip_line += '	</p>\n';

		html_vip_line += '	<table class="table-borderless" style="width:100%;">\n';
		html_vip_line += '		<tr>\n';

		html_vip_line += '			<td style="width:100%;height:240px;" class="text-center" id="keepVipDivLine' + i + '">\n';
		html_vip_line += '			</td>\n';

		html_vip_line += '		</tr>\n';
		html_vip_line += '	</table>\n';

		if (i != proxyServerByDBSvrId_cnt-1 && proxyServerByDBSvrId_cnt > 1) {
			html_vip += '<hr>\n';
			html_vip_line += '<br/>\n';
		}
	}

	$("#proxyMonitoringList").html(html_vip);
	$("#proxyVipConLineList").html(html_vip_line);

	var iVipChkCnt = 0;
	if (result.proxyServerVipList != null && result.proxyServerVipList.length > 0) {
		for(var i = 0; i < result.proxyServerVipList.length; i++){
			var count = 0;
			if (result.proxyServerVipList[i].kal_install_yn == "Y") {
				if (result.proxyServerVipList[i].kal_exe_status != null && result.proxyServerVipList[i].kal_exe_status == "TC001501") {
					kal_exe_status_chk = "text-primary";
					kal_exe_status_css = "fa-refresh fa-spin text-success";
				} else {
					kal_exe_status_chk = "text-danger";
					kal_exe_status_css = "fa-times-circle text-danger";
				}

				html_sebu = "";
				html_vip_line = "";
				html_sebu += '					<i class="ti-vimeo-alt icon-md mb-0 mb-md-3 mb-xl-0 '+kal_exe_status_chk+'" style="font-size: 5em;margin-top:10px;" ></i>\n';

				strVip = result.proxyServerVipList[i].v_ip;

				if (strVip != null && strVip != "," && strVip != "") {
					//마지막 문자열 제거
					if (strVip.charAt(strVip.length-1) == ",") {
						strVip = strVip.slice(0,-1);
					}

					//첫 문자열 제거
					if (strVip.substr(0, 1) == ",") {
						strVip = strVip.substr(1);
					}

					var strVipSplit = strVip.split(',');
					for ( var j in strVipSplit ) {
						var strVipSplit_val = strVipSplit[j].substr(0, strVipSplit[j].indexOf('/'));
						html_sebu += '				<h5 class="text-info"><i class="fa '+kal_exe_status_css+' icon-md mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>'
						html_sebu += '				' + strVipSplit_val + '</h5>\n';	
					}

					//line 생성
					if(pry_agent_status == "Y"){
						html_vip_line += '					<i class="mdi mdi-swap-horizontal icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;width:100%;" id="vip_line' + i + '"></i>\n';
					}
				}

				for(var j = 0; j < result.proxyServerByDBSvrId.length; j++) {
					kal_install_yn = result.proxyServerByDBSvrId[j].kal_install_yn;
					if (result.proxyServerByDBSvrId[j].pry_svr_id == result.proxyServerVipList[i].pry_svr_id) {
						count++;
						if (result.proxyServerVipList[i].pry_svr_nm != "") {
							var vip_btn_html = "";
							vip_btn_html += '<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;&nbsp;' + result.proxyServerVipList[i].pry_svr_nm;
							vip_btn_html +=	'<br/>&nbsp;';
							$("#vip_proxy_nm" + j).html(vip_btn_html);
						}

						$("#keepVipDiv"+ j).html(html_sebu);

						$("#keepVipDivLine" + j).html(html_vip_line);

						iVipChkCnt = j;
					} else if(j == result.proxyServerByDBSvrId.length-1 && count == 0){
						html_sebu = "";
						var vip_btn_html = "";
						vip_btn_html += '<br/>&nbsp;';
						html_sebu += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i>&nbsp;' + proxy_msg39  + '</h6>';

						$("#vip_proxy_nm" + j).html(vip_btn_html);
						$("#keepVipDiv"+ j).html(html_sebu);
						$("#keepVipDiv" + j).attr('style', "width:80%;height:240px;")
						$("#keepVipDivLine" + j).html(html_vip_line);
						$("#vip_line0","#keepVipDivLine" + j).hide();
					}
				}
			} else {
				html_sebu = "";
				var vip_btn_html = "";
				vip_btn_html += '</br>&nbsp;';
				html_sebu += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 2em;"></i>&nbsp;<spring:message code="eXperDB_proxy.msg39"/> </h6>';
				$("#vip_proxy_nm" + i).html(vip_btn_html);
				$("#keepVipDiv" + i).attr('style', "width:80%;height:220px;")
				$("#keepVipDiv" + i).html(html_sebu);
			}
		}
	} else if( result.proxyServerVipList.length == 0){
		for(var j = 0; j < result.proxyServerByDBSvrId.length; j++) {
			kal_install_yn = result.proxyServerByDBSvrId[j].kal_install_yn;
				html_sebu = "";
				var vip_btn_html = "";
				vip_btn_html += '<br/>&nbsp;';
	 		html_sebu += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i>&nbsp;' + proxy_msg39  + '</h6>';

	 		$("#vip_proxy_nm" + j).html(vip_btn_html);
				$("#keepVipDiv" + j).attr('style', "width:80%;height:220px;")
				$("#keepVipDiv" + j).html(html_sebu);
			}
	}

	//vip 두번째 row가 없는 경우 row size 변경
	if (result.proxyServerVipList.length  == 1 && proxyServerByDBSvrId_cnt <= 1 && iVipChkCnt < 1) {
		$("#keepVipDiv" + result.proxyServerVipList.length).attr('style', "width:80%;padding-left:20px;height:30px;");
		$("#keepVipDivLine" + result.proxyServerVipList.length).attr('style', "width:80%;padding-left:20px;height:30px;");
	}

	if (master_state == 'TC001501') {
			setInterval(iDatabase_toggle, 5000);
	}
}

/* ********************************************************
* 프록시 서버 모니터링 셋팅
******************************************************** */
function fn_proxyMonInfo(result){
	var html_listner = "";
	var proxyServerByDBSvrId_cnt = result.proxyServerByDBSvrId.length;
	var iProxyChkCnt = 0;
	var iProxyChkTitleCnt = 0;
	var html_pry_title = "";
	var agent_state = "";
	var html_agent = "";
	var html_listner_ss = "";
	var lsn_status_chk = "";

	//연결 모니터링
	var html_listner_con = "";
	var html_listner_con_ss = "";

	//////////////////////////////////////
	//Proxy 연결 리스너
	for(var i = 0; i < proxyServerByDBSvrId_cnt; i++) {
		//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임
			
		html_listner += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';

		html_listner += '	<span id="proxy_listner_nm' + i + '"></span>\n';
		html_listner += '	</p>\n';
		
		html_listner += '	<table class="table-borderless" style="width:100%;">\n';
		html_listner += '		<tr>\n';
		html_listner += '			<td style="width:15%;padding-left:10px;" class="text-center" id="proxyAgentDiv' + i + '">\n';
		html_listner += '			</td>\n';
		html_listner += '			<td style="width:85%;height:220px;" class="text-center" id="proxyListnerDiv' + i + '">\n';
		html_listner += '			&nbsp;</td>\n';

		html_listner += '		</tr>\n';
		html_listner += '	</table>\n';

		if (i != 1 && proxyServerByDBSvrId_cnt > 1) {
			html_listner += '<hr>\n';
		}
		/////////////////////////////////////////////////////////////////////////////////////////////
		if(i == 1){
 			html_listner_con += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;padding-top:2rem;">\n';
		} else {
 			html_listner_con += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';
		}

		html_listner_con += '	<span id="proxy_listner_con_nm' + i + '">&nbsp;<br/></span>\n';
		html_listner_con += '	</p>\n';
		
		html_listner_con += '	<table class="table-borderless" style="width:100%;">\n';
		html_listner_con += '		<tr>\n';
		html_listner_con += '			<td style="width:100%;height:220px;text-align:center;" id="dbProxyConDiv' + i + '">\n';
		html_listner_con += '			&nbsp;</td>\n';

		html_listner_con += '		</tr>\n';
		html_listner_con += '	</table>\n';

		if (i != 1 && proxyServerByDBSvrId_cnt > 1) {
			html_listner_con += '<br/>\n';
		} 
			
	}

	$("#proxyListnerMornitoringList").html(html_listner);
	$("#proxyListnerConLineList").html(html_listner_con);
	
	//////////////////////////////////////

	//제목 및 agent 상태
	for(var j = 0; j < result.proxyServerByDBSvrId.length; j++){
		html_listner_ss = "";
		html_listner_con_ss = "";
		var lsnNulkCnt = 0;
		var pry_agent_status = result.proxyServerByDBSvrId[j].conn_result;
		
		//title
		if (result.proxyServerByDBSvrId[j].pry_svr_nm != "") {
			html_pry_title = '<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">';
			if(nvlPrmSet(result.proxyServerByDBSvrId[j].exe_status, '') == 'TC001501'){
				html_pry_title += '		<div class="badge badge-pill badge-success" title="">' + result.proxyServerByDBSvrId[j].master_gbn + '</div>\n';
				html_pry_title += '			'+result.proxyServerByDBSvrId[j].pry_svr_nm+'\n';
			} else {
				html_pry_title += '		<div class="badge badge-pill badge-danger" title="">' +  result.proxyServerByDBSvrId[j].master_gbn + '</div>\n';
				html_pry_title += '			'+result.proxyServerByDBSvrId[j].pry_svr_nm+'\n';
			}
			
			html_pry_title += '</h5>\n';

			html_pry_title += '<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:30px;padding-top:3px;">';
			html_pry_title += '		IP : '+result.proxyServerByDBSvrId[j].ipadr+'\n';
			html_pry_title += '</h6>\n';

			$("#proxy_listner_nm" + j).html(html_pry_title);
		}
		
		//agent 상태 체크
		if(result.proxyServerByDBSvrId[j].agt_cndt_cd == 'TC001501' && pry_agent_status == "Y"){
			html_agent = '					<i class="mdi mdi-server-network icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>\n';
		} else {
			html_agent = '					<i class="mdi mdi-server-network icon-md mb-0 mb-md-3 mb-xl-0 text-danger" style="font-size: 3em;"></i>\n';
		}
		html_agent += '					<h6 class="text-muted">Agent</h6>\n';
		
		$("#proxyAgentDiv" + j).html(html_agent);
		
		if (result.proxyServerLsnList.length > 0) {
			var count = 0;
			for(var k = 0; k < result.proxyServerLsnList.length; k++){
				if (result.proxyServerByDBSvrId[j].pry_svr_id == result.proxyServerLsnList[k].pry_svr_id) {
					count++;
					//proxy 리스너 셋팅
					if(nvlPrmSet(result.proxyServerLsnList[k].lsn_exe_status, '') == 'TC001501'){
						lsn_status_chk = "text-primary";
					} else {
						lsn_status_chk = "text-danger";
					}
					html_listner_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_listner_ss += '	<tr>';
					html_listner_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';

					html_listner_ss += '			<h5 class="mb-0 mb-sm-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:8%;padding-left:30px;text-align:left;">';
					
					if(nvlPrmSet(result.proxyServerLsnList[k].lsn_exe_status, '') == 'TC001501'){
						html_listner_ss += '			<div class="badge badge-pill badge-success" title="">L</div>\n';
					} else {
						html_listner_ss += '			<div class="badge badge-pill badge-danger" title="">L</div>\n';
					}

					html_listner_ss += '				<span data-toggle="tooltip" data-placement="bottom" data-html="true" title=\''+result.proxyServerLsnList[k].lsn_desc+'\'>';
					html_listner_ss += '				'+result.proxyServerLsnList[k].lsn_nm+'\n';
					html_listner_ss += '				</span>\n';
					html_listner_ss += '			</h5>\n';
					
					html_listner_ss += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="text-align:left;padding-left:30px;padding-top:3px;">';
					html_listner_ss += '				Bind IP : Port(*) : '+result.proxyServerLsnList[k].con_bind_port+'\n';
					html_listner_ss += '			</h6>\n';
					
					html_listner_ss += '		</td>\n';
					html_listner_ss += '	</tr>\n';
					html_listner_ss += '</table>\n';
					
					///////////////////////////////////////////////////////
					// db 연결 셋팅
					html_listner_con_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_listner_con_ss += '	<tr>';
					html_listner_con_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';

					var db_conn_ip_num = "";
					var db_conn_ip_num_af = "";
					
					//agent가 살아있는 경우, proxy, keep은 kal_agent가 y일때 keepalived가 모두 살아있는 경우, kal_agent 'N' 일때
					if(result.proxyServerByDBSvrId[j].agt_cndt_cd == 'TC001501' &&
						result.proxyServerByDBSvrId[j].exe_status == 'TC001501' &&
						((result.proxyServerByDBSvrId[j].kal_install_yn == '' || result.proxyServerByDBSvrId[j].kal_install_yn != 'Y') ||
						  (result.proxyServerByDBSvrId[j].kal_install_yn == 'Y' && result.proxyServerByDBSvrId[j].kal_exe_status == 'TC001501')) &&
						  pry_agent_status == 'Y'
						){
						if (result.proxyServerLsnList[k].db_conn_ip_num != null) {
							db_conn_ip_num = result.proxyServerLsnList[k].db_conn_ip_num.replace(/,\s*$/, "").replace(/,\s*/,"");
							if (db_conn_ip_num == '1') {
								if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
									//첫번째 오른쪽
									db_conn_ip_num_af = '<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""/>';

								} else {
									//두번째 상단
									db_conn_ip_num_af = '<img src="../images/arrow_up.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
								}
							} else if (db_conn_ip_num == '2') {
								if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
									//첫번째 하단
									db_conn_ip_num_af = '<img src="../images/arrow_down.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
								} else {
									//두번째 row 일자
									db_conn_ip_num_af = '<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
								}
							} else if(db_conn_ip_num != ''){
								//첫번째 row 일자, 하단
								if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
									db_conn_ip_num_af = '<img src="../images/arrow_side_down.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
								} else {
									//두번째 row 일자, 상단
									db_conn_ip_num_af = '<img src="../images/arrow_up_side.png" class="img-lg"  style="max-width:120%;object-fit: contain;" alt=""  />';
								}
							}
						}
					}

					html_listner_con_ss += '		<span class="image blinking"> '+db_conn_ip_num_af+' </span>\n';

					html_listner_con_ss += '		</td>\n';
					html_listner_con_ss += '	</tr>\n';
					html_listner_con_ss += '</table>\n';
					
					lsnNulkCnt ++;
				} else if(k == result.proxyServerLsnList.length-1 && count == 0){
					html_listner_ss = "";
	 				html_listner_ss += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i>' + proxy_msg41 + '</h6>';
	 				$("#proxyListnerDiv" + j).html(html_listner_ss);
				}
			}

			if (lsnNulkCnt < 2) {
				html_listner_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
				html_listner_ss += '	<tr>';
				html_listner_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
				html_listner_ss += '		&nbsp;</td>\n';
				html_listner_ss += '	</tr>\n';
				html_listner_ss += '</table>\n';
				
				html_listner_con_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
				html_listner_con_ss += '	<tr>';
				html_listner_con_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
				html_listner_con_ss += '		&nbsp;</td>\n';
				html_listner_con_ss += '	</tr>\n';
				html_listner_con_ss += '</table>\n';
			}
			lsnNulkCnt = 0;

			$("#proxyListnerDiv" + j).html(html_listner_ss);
			$("#dbProxyConDiv" + j).html(html_listner_con_ss);
		} else {
			html_listner_ss = "";
			html_listner_ss += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i>' + proxy_msg41 + '</h6>';
			$("#proxyListnerDiv" + j).html(html_listner_ss);
		}
	}
}

/* ********************************************************
* 디비 서버 모니터링 셋팅
******************************************************** */
function fn_dbMonInfo(result){

	var rowCount = 0;
	var dbNulkCnt = 0;
	var html = "";
	var master_gbn = "";
	var pry_svr_id = "";
	var listCnt = 0;
	var pry_svr_id_val = "";
	var db_exe_status_chk = "";
	var db_exe_status_css = "";
	var db_exe_status_val = "";
	
	var proxyServerByDBSvrId_cnt = result.proxyServerByDBSvrId.length;
	
	var html_db = "";
	
	//////////////////////////////////////
	//db 연결 리스너
	for(var i = 0; i < proxyServerByDBSvrId_cnt; i++){
			//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임
			
			html_db += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';

			html_db += '		<span id="db_proxy_nm' + i + '"></span>\n';
			html_db += '	</p>\n';
		
			html_db += '	<table class="table-borderless" style="width:100%;">\n';
			html_db += '		<tr>\n';
			html_db += '			<td style="width:100%;height:220px;" id="dbProxyDiv' + i + '">\n';
			html_db += '			&nbsp;</td>\n';

			html_db += '		</tr>\n';
			html_db += '	</table>\n';

			if (i != 1 && proxyServerByDBSvrId_cnt > 1) {
				html_db += '<hr>\n';
			}
	}

	$("#dbListenerVipList").html(html_db);
	//////////////////////////////////////
	
	
	//////////////////////////////////////
	//Proxy 연결 db

	//제목 및 agent 상태
		for(var j = 0; j < result.proxyServerByDBSvrId.length; j++){
			html_db = "";
			//title
		if (result.proxyServerByDBSvrId[j].pry_svr_nm != "") {
			$("#db_proxy_nm" + j).html('<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;&nbsp;' + result.proxyServerByDBSvrId[j].pry_svr_nm + '<br/>&nbsp;');
		}

			if (result.dbServerConProxyList != null && result.dbServerConProxyList.length > 0) {
			for(var k = 0; k < result.dbServerConProxyList.length; k++){

				if (result.proxyServerByDBSvrId[j].pry_svr_id == result.dbServerConProxyList[k].pry_svr_id) {

					html_db += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_db += '	<tr>';
					
					html_db += '		<td colspan="2" style="width:85%;">';

					if(result.dbServerConProxyList[k].master_gbn == 'M'){
						html_db += '		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">';
					} else {
						html_db += '		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-left:10px;padding-top:10px;">';
					}

					if(result.dbServerConProxyList[k].db_cndt == 'Y'){
						html_db += '		<div class="badge badge-pill badge-success" title="">'+result.dbServerConProxyList[k].master_gbn+'</div>';
					} else {
						html_db += '		<div class="badge badge-pill badge-danger" title="">'+result.dbServerConProxyList[k].master_gbn+'</div>';
					}
					 
					if(result.dbServerConProxyList[k].svr_host_nm != null && result.dbServerConProxyList[k].svr_host_nm != ""){
						if(result.dbServerConProxyList[k].master_gbn == 'M'){
							html_db += '		Master(';
						} else {
							html_db += '		Standby(<a href="#" onclick="fn_standby_view(' + result.dbServerConProxyList[k].db_svr_id + ')">';
						}
						html_db += '			' + result.dbServerConProxyList[k].svr_host_nm;
						if(result.dbServerConProxyList[k].master_gbn == 'M'){
							html_db += '		)';
						} else {
							if(result.dbServerConProxyList[k].cnt_svr_id > 1){
								html_db += '	' + proxy_and  + ' ' + (result.dbServerConProxyList[k].cnt_svr_id -1) + ' ' + proxy_others + '</a>)';
							} else {
								html_db += '	</a>)';
							}
						}
					} else {
						if(result.dbServerConProxyList[k].master_gbn == 'M'){
							html_db += '		Master';	
						} else {
							html_db += '		Standby';
						}
					}
					html_db += '			</h6>';
					html_db += '		</td>';
					
					
					html_db += '		<td rowspan="3" style="width:15%;">';
					if(result.dbServerConProxyList[k].db_cndt == 'Y'){
						html_db += '		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>\n';
					} else {
						html_db += '		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger" style="font-size: 3em;"></i>';
					}

					html_db += '		</td>';
					
					html_db += '	</tr>';

					html_db += '	<tr>';
					html_db += '		<td colspan="2" style="padding-top:5px;">';

						if(result.dbServerConProxyList[k].master_gbn == 'M'){
						html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : ' + result.dbServerConProxyList[k].ipadr + '/' + result.dbServerConProxyList[k].portno + '</h6>';
					} else {
						if(result.dbServerConProxyList[k].cnt_svr_id > 1){
							html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">' + representative_ip +' : ' + result.dbServerConProxyList[k].ipadr + '</h6>';
						} else {
							html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : ' + result.dbServerConProxyList[k].ipadr + '/' + result.dbServerConProxyList[k].portno + '</h6>';
						}
					}

					
					html_db += '		</td>'
					html_db += '	</tr>'

						
					//내부 ip setting
					if(result.dbServerConProxyList[k].intl_ipadr != null && result.dbServerConProxyList[k].intl_ipadr != "") {
						html_db += '	<tr>';
						html_db += '		<td colspan="2" style="padding-top:5px;">';
						html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:70px;">('+ internal_ip + ' : ' + result.dbServerConProxyList[k].intl_ipadr + ')</h6>';
						html_db += '		</td>';
						html_db += '	</tr>';
					}

					if(result.dbServerConProxyList[k].db_cndt == 'Y'){
						db_exe_status_chk = "text-success";
						db_exe_status_css = "fa-refresh fa-spin text-success";
						db_exe_status_val = 'running';
					} else {
						db_exe_status_chk = "text-danger";
						db_exe_status_css = "fa-times-circle text-danger";
						db_exe_status_val = 'stop';
					}

					html_db += '	<tr >\n';
					html_db += '		<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">\n';
					html_db += '			<h6 class="text-muted" style="padding-left:10px;"><i class="fa '+db_exe_status_css+' icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>' + db_exe_status_val + '</h6>\n';			
					html_db += '		</td>\n';
					html_db += '	</tr>\n';
					html_db += '	</table>\n';
					
					dbNulkCnt ++;
				}
			}
			 
			if (dbNulkCnt < 2 ) {
				html_db += '<table class="table-borderless" style="width:100%;height:100px;">\n';
				html_db += '	<tr>';
				html_db += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
				html_db += '		&nbsp;</td>\n';
				html_db += '	</tr>\n';
				html_db += '</table>\n';
			}

			dbNulkCnt = 0;
			
			$("#dbProxyDiv" + j).html(html_db);
		}
	}
}

/* ********************************************************
* db standby ip list 조회
******************************************************** */
function fn_standby_view(db_svr_id){
	fn_proxyDBStandbyViewAjax(db_svr_id);
	setTimeout(function(){
		if(proxyDBStandbyListTable != null) proxyDBStandbyListTable.columns.adjust().draw();
	},200);
	$('#pop_db_standby_ip_list_view').modal("show");
	$('#loading').hide();
}