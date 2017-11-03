<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
var table = null;
var scd_nmChk = "fail";
var db_svr_id = ${db_svr_id};

function fn_validation(){
	var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			   alert("스케줄명을 입력하여 주십시오.");
			   scd_nm.focus();
			   return false;
		}
		if(scd_nmChk == "fail"){
  			"스케줄명 중복체크 하셔야합니다.";
  		}
 		return true;
}

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#week_scheduleList').DataTable({
	scrollY : "350px",
	scrollX: true,	
	paging : false,
	searching : false,	
	columns : [
	// 일요일
	{data : "scd_nm", 
		render: function (data, type, full){
			var strArr = full.bck_bsn_dscd.split(',');		
			var html = null;
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
					if(bar[0] > 0 ){
						html = ' <img src="../images/af.png" id="full"/>';
					}else{
						html = ' <img src="../images/df.png" id="full"/>';
					}
					if(bar[1] > 0 ){
						html += ' <img src="../images/ai.png"  id="incremental"/>';
					}else{
						html += ' <img src="../images/di.png"  id="incremental"/>';
					}
					if(bar[2] > 0 ){
						html += ' <img src="../images/aa.png" id="archive"/>';
					}else{
						html += ' <img src="../images/da.png" id="archive"/>';
					}
					if(bar[3] > 0 ){
						html += ' <img src="../images/ad.png" id="dump"/>';
					}else{
						html += ' <img src="../images/dd.png" id="dump"/>';
					}
					
					if(full.scd_cndt == 'TC001801'){
						html += '<div style="margin-top: 7px;">';
					    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
					    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
						html +=  full.scd_nm+'</span>';	
						html += '</div>';
					}else{
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
					}	
						return html;
				}else{
					return html;
				}					
			return data;				
			},
			defaultContent : "" 	
		},	
		
		// 월요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			defaultContent : "" 	
		},	
		
		// 화요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			defaultContent : "" 	
		},	
		
		// 수요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			defaultContent : "" 	
		},	
		
		// 목요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			defaultContent : "" 	
		},	
		
		// 금요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			defaultContent : "" 	
		},	
		
		// 토요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
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
						if(bar[0] > 0 ){
							html = ' <img src="../images/af.png" id="full"/>';
						}else{
							html = ' <img src="../images/df.png" id="full"/>';
						}
						if(bar[1] > 0 ){
							html += ' <img src="../images/ai.png"  id="incremental"/>';
						}else{
							html += ' <img src="../images/di.png"  id="incremental"/>';
						}
						if(bar[2] > 0 ){
							html += ' <img src="../images/aa.png" id="archive"/>';
						}else{
							html += ' <img src="../images/da.png" id="archive"/>';
						}
						if(bar[3] > 0 ){
							html += ' <img src="../images/ad.png" id="dump"/>';
						}else{
							html += ' <img src="../images/dd.png" id="dump"/>';
						}
						if(full.scd_cndt == 'TC001801'){
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
								html += '</div>';
						}	
							return html;
					}else{
						return html;
					}					
				return data;				
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


function fn_popup(scd_id){
	var popUrl = "/bckScheduleDtlVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
	var width = 1320;
	var height = 655;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
	window.open(popUrl,"",popOption);
}


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_selectBckSchedule();
	//fn_selectMonthBckSchedule();
	$("#week_scheduleList").show();
	$("#week_scheduleList_wrapper").show();
	$("#month_scheduleList").hide();
	$("#month_scheduleList_wrapper").hide();
	$("#btnWeek").show();
	$("#btnMonth").hide();
});

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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 	
}


function fn_selectMonthBckSchedule(){
	$.ajax({
		url : "/selectMonthBckSchedule.do",
		data : {db_svr_id : db_svr_id},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 	
}


function fn_insertSchedule(){
	var popUrl = "/bckScheduleInsertVeiw.do?db_svr_id="+db_svr_id; // 서버 url 팝업경로
	var width = 1120;
	var height = 425;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
	window.open(popUrl,"",popOption);
}


/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){
	if(tab == "month"){
		$("#month_scheduleList").show();
		$("#month_scheduleList_wrapper").show();
		$("#week_scheduleList").hide();
		$("#week_scheduleList_wrapper").hide();
		$("#tab1").hide();
		$("#tab2").show();
		$("#btnMonth").show();
		$("#btnWeek").hide();
	}else{
		$("#week_scheduleList").show();
		$("#week_scheduleList_wrapper").show();
		$("#month_scheduleList").hide();
		$("#month_scheduleList_wrapper").hide();
		$("#tab1").show();
		$("#tab2").hide();
		$("#btnWeek").show();
		$("#btnMonth").hide();
	}
}
</script>
			<div id="contents">			
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>백업 스케줄 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
					</div>
					<div class="contents">
						<div class="cmm_tab">
							<ul id="tab1">
								<li class="atv"><a href="javascript:selectTab('week')">주별 스케줄현황</a></li>
								<li><a href="javascript:selectTab('month')">월별 스케줄현황</a></li>
							</ul>
							<ul id="tab2" style="display:none;">
								<li><a href="javascript:selectTab('week')">주별 스케줄현황</a></li>
								<li class="atv"><a href="javascript:selectTab('month')">월별 스케줄현황</a></li>
							</ul>
						</div>
						<div class="cmm_grp">
							<div class="btn_type_01" id="btnWeek">
								<span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button>주별 스케줄등록</button></span>
							</div>
							<div class="btn_type_01" id="btnMonth">
								<span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button>월별 스케줄등록</button></span>
							</div>
							<div class="cmm_bd">																			
									<table id="week_scheduleList" class="cell-border display" width="100%">
										<thead>
											<tr>
												<th width="130">일</th>
												<th width="130">월</th>												
												<th width="130">화</th>
												<th width="130">수</th>
												<th width="130">목</th>
												<th width="130">금</th>												
												<th width="130">토</th>
											</tr>
										</thead>
									</table>		
									
									
									<table id="month_scheduleList" class="cell-border display" width="100%">
										<thead>
											<tr>
												<th width="130">1월</th>
												<th width="130">2월</th>												
												<th width="130">3월</th>
												<th width="130">4월</th>
												<th width="130">5월</th>
												<th width="130">6월</th>												
												<th width="130">7월</th>
												<th width="130">8월</th>
												<th width="130">9월</th>
												<th width="130">10월</th>
												<th width="130">11월</th>												
												<th width="130">12월</th>
											</tr>
										</thead>
									</table>																
							</div>		
						</div>
					</div>
				</div>
			</div>