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
	var sdtHisTimehtml = "<i class='fa fa-calendar menu-icon'></i> "+today_date.toJSON().slice(0,10).replace(/-/g,'-') + " ~ " + today_ing;
	
	$( "#tot_sdt_today" ).append(html);						//통합스케줄
	$( "#tot_scd_ing_msg" ).append(html);					//금일예정

	$( "#tot_sdt_his_today" ).append(sdtHisTimehtml);		//스케줄 이력
	
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
				backHtml += '<td style="width:33%;line-height:150%;border:none;">';

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
					backHtml += '<div class="badge badge-pill badge-warning"><spring:message code="dashboard.running" /></div>';
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
		backHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#c9ccd7;">';
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
					scriptHtml += '<div class="badge badge-pill badge-warning"><spring:message code="dashboard.running" /></div>';
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
		backHtml += "<tr>";
		backHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#c9ccd7;">';
		backHtml += dashboard_msg03
		backHtml += '</td>';
		backHtml += "</tr>";
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
	
	///////////////////////////스케줄 list start ////////////////////////
	//데이터가 있는 경우
	if (result.scheduleHistoryresult != null && result.scheduleHistoryresult.length > 0) {
		$(result.scheduleHistoryresult).each(function (index, item) {
			scdHisHtml +='	<tr>';
			
			scdHisHtml +='		<td><span onClick="javascript:fn_scdLayer('+item.scd_id+');" class="bold">'+item.scd_nm+'</span></td>';

			scdHisHtml +='		<td class="text-center">'+item.wrk_strt_dtm+'</td>';
			scdHisHtml +='		<td class="text-center">'+item.wrk_end_dtm+'</td>';
			scdHisHtml +='		<td class="text-center">'+item.wrk_dtm+'</td>';

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
		scdHisHtml += '<td class="text-center" style="width:100%;border:none;height:20px;background-color:#c9ccd7;">';
		scdHisHtml += dashboard_msg03
		scdHisHtml += '</td>';
		scdHisHtml += "</tr>";
	}

	$("#scheduleListT").html(scdHisHtml);
	///////////////////////////스케줄 list end ////////////////////////

	///////////////////////////스케줄 chart start ////////////////////////
	if (result.scheduleHistoryChart != null) {
		chartListCnt = 1;
	}

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
 * 스케줄관리 화면이동
 ******************************************************** */
function fn_scheduleListMove(scd_nm) {
	$("#scd_nm", "#dashboardViewForm").val(scd_nm);
	
	$("#dashboardViewForm").attr("action", "/selectScheduleListView.do");
	$("#dashboardViewForm").submit();
}