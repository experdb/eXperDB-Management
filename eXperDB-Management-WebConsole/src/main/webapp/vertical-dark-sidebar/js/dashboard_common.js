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
		}

		$("#scriptScheduleCntList").html(scriptHtml);
		
		/////////////////////배치일정 end////////////////////////////////////////////////
	}


/* ********************************************************
 * 스케줄관리 화면이동
 ******************************************************** */
function fn_scheduleListMove(scd_nm) {
	$("#scd_nm", "#dashboardViewForm").val(scd_nm);
	
	$("#dashboardViewForm").attr("action", "/selectScheduleListView.do");
	$("#dashboardViewForm").submit();
}