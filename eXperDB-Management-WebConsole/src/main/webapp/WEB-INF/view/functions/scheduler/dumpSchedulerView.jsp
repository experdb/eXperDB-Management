<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs2.jsp"%>

<script>
	var table = null;
	var scd_nmChk = "fail";
	var db_svr_id = ${db_svr_id};
	var selectSdtChkTab = "week";
	var searchInit = "";

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window).ready(function(){
		
		//당해년도, 월 setting
		fn_todaySetting();
		
		//검색조건 초기화
		selectSdtInitTab(selectSdtChkTab);

		/* ********************************************************
		 * insert Button
		 ******************************************************** */
		$("#btnScdViewInsert").click(function() {
			fn_insertSchedule();
		});

		$("#btnSearchData").click(function() {
			//조회조건 setting
			var stmondt = new Date($("#cmbyear").val(),parseInt($("#cmbmonth").val())-1,1,0,0,0,0);
			var stdt = stmondt;
			var stweekofday = stmondt.getDay();
			if (stweekofday >= 0) {
				stdt = addDays(stdt , stweekofday * -1);
			}
			var eddt = addDays(stdt,35);

			$.ajax({
				url : "/selectMonthBckScheduleSearch.do",
				data : {
						"stdate" : stdt.format("yyyyMMdd"),
						"eddate" : eddt.format("yyyyMMdd"),
						"db_svr_id" : db_svr_id
				},
				dataType : "json",
				type : "post",
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
					$("#calendarbody").empty();

					for(var irow=0;irow<5;irow++){
						var tmparr = new Object();
						tmparr[0] = [];
						tmparr[1] = [];
						tmparr[2] = [];
						tmparr[3] = [];
						tmparr[4] = [];
						tmparr[5] = [];
						tmparr[6] = [];
						
						var appendnew = "<tr>";

						// data
						var maxcnt = 0;
						for(var i=0;i<7;i++){
							maxcnt = (maxcnt>tmparr[i].length)?maxcnt:tmparr[i].length;
						}

						var height = "130px";

						if (result.length > 4) {
							height = String(17 * result.length) + "px";
						}

						for(var i=0;i<7;i++){
							var showdt = stdt.format("MM/dd");
							var checkDt = stdt.format("MMdd");
							var checkDay = stdt.format("dd");
							var checkYear = stdt.format("yyyyMMdd");
							
							appendnew += "<td style='width: 130px; word-break:break-all;'>";

							switch (i) {
				            case 0:
				            	appendnew += "<div class='cell row' style='height:"+height+";'>";
				            	appendnew += "<font color=red>" + showdt + "</font>";    // 좌상단 날짜 
				           		break;
				            case 6:
				            	appendnew += "<div class='cell row' style='height:"+height+";'>";
				            	appendnew += "<font color=blue>" + showdt + "</font>";
				      		    break;
				            default:
				            	appendnew += "<div class='cell row' style='height:"+height+";'>";
				            	appendnew += showdt;
				        	}
 
							for(var j=0;j<result.length;j++){

				            	var scd_id = result[j].scd_id;
				                var scd_nm = result[j].scd_nm;
				                var scd_exp = result[j].scd_exp;
				                var scd_cndt = result[j].scd_cndt;
				                var exe_perd_cd = result[j].exe_perd_cd;
				                var exe_month = result[j].exe_month;
				                var exe_day = result[j].exe_day;
				                var exe_hms = result[j].exe_hms;
				                var exe_dt = result[j].exe_dt;
				                var frst_reg_dtm = result[j].frst_reg_dtm;
				                var imgName = "";
				                
				                var resultYearCheckDt = exe_month + "" + exe_day;

				                //매년
				                if(exe_perd_cd == 'TC001604') {
				                	if(frst_reg_dtm<=checkYear){
					                	if(resultYearCheckDt == checkDt) {
					                		appendnew += "<div class='col-md-12 badge badge-pill badge-light' style='text-align: left; background-color: transparent !important;font-weight:bold;'>";
					                		if(scd_cndt == 'TC001801') {
					                			appendnew += "<i class='fa fa-spin fa-refresh mr-2 text-success'></i>";
					                		} else {
					                			appendnew += "<i class='fa fa-minus-circle mr-2 text-danger'></i>";
					                		}
					                		appendnew += "[<spring:message code="schedule.everyyear" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				                	}
				                //매월
				                } else if(exe_perd_cd == 'TC001603') {
				                	if(frst_reg_dtm<=checkYear){
					                	if(exe_day == checkDay) {
					                		appendnew += "<div class='col-md-12 badge badge-pill badge-light' style='text-align: left; background-color: transparent !important;font-weight:bold;'>";
					                		if(scd_cndt == 'TC001801') {
					                			appendnew += "<i class='fa fa-spin fa-refresh mr-2 text-success'></i>";
					                		} else {
					                			appendnew += "<i class='fa fa-minus-circle mr-2 text-danger'></i>";
					                		}
					                		appendnew += "[<spring:message code="schedule.everymonth" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				                	}
				                // 매주
				                } else if(exe_perd_cd == 'TC001602') {
				           			if(frst_reg_dtm<=checkYear){
					                	if(exe_dt.substr(i,1) == '1') {
					                		appendnew += "<div class='col-md-12 badge badge-pill badge-light' style='text-align: left; background-color: transparent !important;font-weight:bold;'>";
					                		if(scd_cndt == 'TC001801') {
					                			appendnew += "<i class='fa fa-spin fa-refresh mr-2 text-success'></i>";
					                		} else {
					                			appendnew += "<i class='fa fa-minus-circle mr-2 text-danger'></i>";
					                		}
					                		appendnew += "[<spring:message code="schedule.everyweek" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				           			}
				                //매일
				                } else if(exe_perd_cd == 'TC001601') {
				                	if(frst_reg_dtm<=checkYear){
				                		appendnew += "<div class='col-md-12 badge badge-pill badge-light' style='text-align: left; background-color: transparent !important;font-weight:bold;'>";
				                		if(scd_cndt == 'TC001801') {
				                			appendnew += "<i class='fa fa-spin fa-refresh mr-2 text-success'></i>";
				                		} else {
				                			appendnew += "<i class='fa fa-minus-circle mr-2 text-danger'></i>";
				                		}
				                		appendnew += "[<spring:message code="schedule.everyday" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
				                	}
								//1회실행
				                } else if(exe_perd_cd == 'TC001605') {
					                if(exe_dt == checkYear) {
					                	appendnew += "<div class='col-md-12 badge badge-pill badge-light' style='text-align: left; background-color: transparent !important;font-weight:bold;'>";
					                	if(scd_cndt == 'TC001801') {
					                		appendnew += "<i class='fa fa-spin fa-refresh mr-2 text-success'></i>";
					                	} else {
					                		appendnew += "<i class='fa fa-minus-circle mr-2 text-danger'></i>";
					                	}
/* 					                	appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />'; */
					                	appendnew += "[<spring:message code="schedule.one_time_run" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                }
			                	}
				                
							}

							appendnew +="</div>";
							stdt = addDays(stdt, 1);
							
							appendnew += "</td>";
						}

						appendnew += "</tr>";
						
						$("#calendarbody").append(appendnew);
					}
				}
			});	
		});
	});
	
	/* ********************************************************
	 * 날짜 구하기
	 ******************************************************** */
	function addDays(theDate, days) {
	    return new Date(theDate.getTime() + days*24*60*60*1000);
	}
	
	/* ********************************************************
	 * 해당년 월 setting
	 ******************************************************** */
	function fn_todaySetting(){
		$("#cmbyear").html("");
		$("#cmbmonth").html("");
		
		var intyear = parseInt("${month}".substr(0,4));

		//년도 setting
		var stryear = ""; 
		for(var i=-10;i<11;i++){
			stryear += '<option value="' + (intyear+i) + '">' + (intyear+i) + ' <spring:message code="etc.etc09"/></option>'
		}
		
		//월 setting
		var strMonth = ""; 
        for(var i=1; i <= 12; i++) {
            var sm = i > 9 ? i : "0"+i ;            
            $('#cmbmonth').append('<option value="' + sm + '">' + sm + ' <spring:message code="common.mon" /> </option>');    
        }
 
		$("#cmbyear").append(stryear);
		$("#cmbyear").val("${month}".substr(0,4));
		$("#cmbmonth").val("${month}".substr(4,2));
	}

	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectSdtInitTab(intab){
		selectSdtChkTab = intab;
 		if(intab == "week"){			
			$("#find_month").hide();
			$("#week_button").show();//주별 등록버튼
			$("#week_scheduleListDiv").show();
			$("#month_scheduleListDiv").hide();
		}else{				
			$("#find_month").show();
			$("#week_button").hide();//주별 등록버튼
			$("#week_scheduleListDiv").hide();
			$("#month_scheduleListDiv").show();
			$("#btnSearchData").click();
		}

		fn_weekTable_init(); //주별스케줄 setting
		
		fn_selectBckSchedule(); //주별스케줄 조회
	}
	
	/* ********************************************************
	 * 주별 테이블 setting
	 ******************************************************** */
	function fn_weekTable_init(){
		table = $('#week_scheduleList').DataTable({
			scrollY : "350px",
			scrollX: true,	
			paging : false,
			searching : false,	
			bSort: false,
			columns : [
				//일요일
				{	
					data : "scd_nm",
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";
	
						if(full.exe_dt.substring(0,1)=="1"){			
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}
									
							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}
		
							return html;
						}else{
							return html;
						}

						return html;				
					},
					defaultContent : ""
				},	

				// 월요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";
		
						if(full.exe_dt.substring(1,2)=="1"){
							var bar = new Array(0, 0, 0, 0);

							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}					
						return html;				
					},
					defaultContent : "" 	
				},	
			
				// 화요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";
						if(full.exe_dt.substring(2,3)=="1"){		
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}					
						return html;				
					},
					defaultContent : "" 	
				},	
			
				// 수요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";

						if(full.exe_dt.substring(3,4)=="1"){	
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}					
						return html;				
					},
					defaultContent : "" 	
				},	
			
				// 목요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";

						if(full.exe_dt.substring(4,5)=="1"){
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}				
						return html;				
					},
					defaultContent : "" 	
				},	
			
				// 금요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";

						if(full.exe_dt.substring(5,6)=="1"){
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}					
						return html;				
					},
					defaultContent : "" 	
				},	
			
				// 토요일
				{
					data : "scd_nm", 
					render: function (data, type, full){
						var strArr = full.bck_bsn_dscd.split(',');		
						var html = "";

						if(full.exe_dt.substring(6,7)=="1"){
							var bar = new Array(0, 0, 0, 0);
							for(var i=0; i<strArr.length; i++){							
								if(strArr[i] == "TC000201"){
									if(full.bck_opt_cd == "TC000301"){
										bar[0] = bar[0]+1;
									}else if (full.bck_opt_cd == "TC000302"){
										bar[1] = bar[1]+1;
									}else{
										bar[2] = bar[2]+1;
									}
								}else{
									bar[3] = bar[3]+1;
								}	
							}

							html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";

							//full backup
							if(bar[0] > 0 ){
								html += "	<i class='fa fa-paste mr-2 text-success'></i> FULL " + '<spring:message code="dashboard.backup" />';
							}
									
							//Incremental 백업
							if(bar[1] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Incremental " + '<spring:message code="dashboard.backup" />';
							}
	
							//Archive 백업
							if(bar[2] > 0 ){
								html += "	<i class='fa fa-comments-o text-warning'></i> Archive " + '<spring:message code="dashboard.backup" />';
							}
									
							if(bar[3] > 0 ){
								html += "	<i class='fa fa-file-code-o mr-2 text-danger' ></i> DUMP"  + '<spring:message code="dashboard.backup" />';
							}
							html += "</div>";
							
							html += '<br/>';

							if(full.scd_cndt == "TC001801"){								
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';
								html += "	<i class='fa fa-spin fa-refresh mr-2 text-success' style='font-weight:bold;'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							 }else{
								html += '<div class="badge badge-pill badge-light" style="background-color: transparent !important;font-size: 0.875rem;" onClick=javascript:fn_popup("'+full.scd_id+'");>';;
								html += "	<i class='fa fa-minus-circle mr-2 text-danger'></i>";
								html += "<span class='text-primary bold' style='font-weight:bold;'>" + full.exe_hms+' '+full.scd_nm + "</span>";
								html += "</div>";
							}

							return html;
						}else{
							return html;
						}					
						return html;				
					},
				 	defaultContent : "" 	
				},	
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	    
		$(window).trigger('resize'); 
	}
	
	/* ********************************************************
	 * 주별 테이블 setting
	 ******************************************************** */
	function fn_selectBckSchedule(){
		$.ajax({
			url : "/selectBckSchedule.do",
			data : {db_svr_id : db_svr_id},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();

				if (nvlPrmSet(result, "") != '') {
					table.rows.add(result).draw();
				}
			}
		}); 	
	}
	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectSdtTab(intab){
		selectSdtChkTab = intab;

		if(intab == "week"){			
			$("#find_month").hide();
			$("#week_button").show();//주별 등록버튼
			$("#week_scheduleListDiv").show();
			$("#month_scheduleListDiv").hide();
		}else{				
			$("#find_month").show();
			$("#week_button").hide();//주별 등록버튼
			$("#week_scheduleListDiv").hide();
			$("#month_scheduleListDiv").show();
			$("#btnSearchData").click();
		}
	}
	
	function fn_popup(scd_id){
		var popUrl = "/bckScheduleDtlVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
		var width = 1320;
		var height = 735;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
		window.open(popUrl,"",popOption);
	}
	
	/* ********************************************************
	 * 팝업호출
	 ******************************************************** */
	 function fn_popup(scd_id){
		$.ajax({
			url : "/bckScheduleDtlVeiw.do",
			data : {
				scd_id : scd_id
			},
			dataType : "json",
			type : "post",
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
				$("#scdInfo_scd_id", "#backupScdInfoForm").val(result.scd_id);
				$("#scdInfo_db_svr_id", "#backupScdInfoForm").val($("#db_svr_id", "#findList").val());

				//POP START
				fn_sdtDtlPopStart();
				
				$("#pop_layer_backup_scd_dtl").modal("show");
			}
		});
	}
		
	/* ********************************************************
	 * 주별스케줄 등록
	 ******************************************************** */
	 function fn_insertSchedule(){
		 $.ajax({
			url : "/bckScheduleInsertVeiw.do",
			data : {
				"db_svr_id" : db_svr_id
			},
			dataType : "json",
			type : "post",
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
				fn_ins_view_chogihwa(result);

				//POP START
				fn_insertScdViewPopStart();

				$("#pop_layer_backup_week_scd_ins").modal("show");
			}
		});
	}
	 
	Date.prototype.format = function(f) {
	    if (!this.valueOf()) return " ";

	    var weekName = ["<spring:message code="schedule.sunday" /> ", "<spring:message code="schedule.monday" />", "<spring:message code="schedule.thuesday" />", "<spring:message code="schedule.wednesday" />", "<spring:message code="schedule.thursday" />", "<spring:message code="schedule.friday" />", "<spring:message code="schedule.saturday" /> "];
	    var d = this;

	    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
	        switch ($1) {
	            case "yyyy": return d.getFullYear();
	            case "yy": return (d.getFullYear() % 1000).zf(2);
	            case "MM": return (d.getMonth() + 1).zf(2);
	            case "dd": return d.getDate().zf(2);
	            case "E": return weekName[d.getDay()];
	            case "HH": return d.getHours().zf(2);
	            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
	            case "mm": return d.getMinutes().zf(2);
	            case "ss": return d.getSeconds().zf(2);
	            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
	            default: return $1;
	        }
	    });
	};
 
	String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
	String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
	Number.prototype.zf = function(len){return this.toString().zf(len);};

	/**
	 * Day of Year  
	 * @returns
	 */
	Date.prototype.DayOfYear = function(){
		var onejan = new Date(this.getFullYear(),0,1);
		return Math.ceil((this - onejan) / 86400000); 
	};

	/**
	 * Convert String Format to Date Object 
	 * @param _format   "yyyy-mm-dd"    
	 * @param _delimeter  "-"
	 * @returns {Date}
	 */
	function StringToDate(_date , _format , _delimiter){
	    var formatLowerCase=_format.toLowerCase();
	    var formatItems=formatLowerCase.split(_delimiter);
	    var dateItems=_date.split(_delimiter);
	    var monthIndex=formatItems.indexOf("mm");
	    var dayIndex=formatItems.indexOf("dd");
	    var yearIndex=formatItems.indexOf("yyyy");
	    var month=parseInt(dateItems[monthIndex]);
	    month-=1;
	    var formatedDate = new Date(dateItems[yearIndex],month,dateItems[dayIndex]);
	    return formatedDate;
	}

	var DateDiff =  {
		    inDays: function(d1, d2) {
		        var t2 = d2.getTime();
		        var t1 = d1.getTime();
		 
		        return parseInt((t2-t1)/(24*3600*1000));
		    },
		 
		    inWeeks: function(d1, d2) {
		        var t2 = d2.getTime();
		        var t1 = d1.getTime();
		 
		        return parseInt((t2-t1)/(24*3600*1000*7));
		    },
		 
		    inMonths: function(d1, d2) {
		        var d1Y = d1.getFullYear();
		        var d2Y = d2.getFullYear();
		        var d1M = d1.getMonth();
		        var d2M = d2.getMonth();
		 
		        return (d2M+12*d2Y)-(d1M+12*d1Y);
		    },
		 
		    inYears: function(d1, d2) {
		        return d2.getFullYear()-d1.getFullYear();
		    }
	};
</script>

<%@include file="../../popup/bakupScheduleDtl.jsp"%>
<%@include file="../../popup/bckScheduleInsertVeiw.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}" />
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
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-cog"></i>
												<span class="menu-title"><spring:message code="schedule.bckSchedule"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="schedule.bckSchedule"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.backup_scheduler_01"/></p>
											<p class="mb-0"><spring:message code="help.backup_scheduler_02"/></p>
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

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectSdtTab('week');" >
								<spring:message code="backup_management.weekly_schedule_status" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectSdtTab('month');">
								<spring:message code="backup_management.monthly_schedule_status" />
							</a>
						</li>
					</ul>

					<!-- search param start -->
					<div class="card"  id="find_month">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">
							<form class="form-inline row" >
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" name="cmbyear" id="cmbyear">
										<option value=""><spring:message code="schedule.total" /></option>
									</select>
								</div>
								
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" name="cmbmonth" id="cmbmonth">
										<option value=""><spring:message code="schedule.total" /></option>
									</select>
								</div>		

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearchData">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;"  id="week_button">
						<div class="col-12">
							<div class="template-demo">
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScdViewInsert" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="backup_management.weekly_schedule_registory" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12" id="week_scheduleListDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

	 								<table id="week_scheduleList" class="table table-hover table-striped" style="width:100%;">
										<thead>
											<tr>
												<th width="130" class="text-center text-danger"><spring:message code="common.sun" /></th>
												<th width="130" class="text-center"><spring:message code="common.mon" /></th>												
												<th width="130" class="text-center"><spring:message code="common.tue" /></th>
												<th width="130" class="text-center"><spring:message code="common.wed" /></th>
												<th width="130" class="text-center"><spring:message code="common.thu" /></th>
												<th width="130" class="text-center"><spring:message code="common.fri" /></th>												
												<th width="130" class="text-center text-primary"><spring:message code="common.sat" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
							 	
								<div class="col-12" id="month_scheduleListDiv" style="diplay:none;">
 									<div class="table-responsive">
										<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

	 								<table id="month_scheduleList" class="table table-hover table-bordered table-striped" style="width:100%;">
	 									<thead>
											<tr>
												<th width="130" class="text-center text-danger" style="font-weight:bold;"><spring:message code="common.sun" /></th>
												<th width="130" class="text-center" style="font-weight:bold;"><spring:message code="common.mon" /></th>												
												<th width="130" class="text-center" style="font-weight:bold;"><spring:message code="common.tue" /></th>
												<th width="130" class="text-center" style="font-weight:bold;"><spring:message code="common.wed" /></th>
												<th width="130" class="text-center" style="font-weight:bold;"><spring:message code="common.thu" /></th>
												<th width="130" class="text-center" style="font-weight:bold;"><spring:message code="common.fri" /></th>												
												<th width="130" class="text-center text-primary" style="font-weight:bold;"><spring:message code="common.sat" /></th>
											</tr>
										</thead>
										<tbody id="calendarbody">
										
										</tbody>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>