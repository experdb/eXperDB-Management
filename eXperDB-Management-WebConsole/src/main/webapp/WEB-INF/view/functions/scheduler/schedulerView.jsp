<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- <style>
	.cellDate{
		text-overflow:ellipsis;
		overflow:hidden;
		white-space:nowrap;
	} 
</style> -->
<script>
var table = null;
var scd_nmChk = "fail";
var db_svr_id = ${db_svr_id};

function fn_validation(){
	var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			   alert('<spring:message code="message.msg40" /> ');
			   scd_nm.focus();
			   return false;
		}
		if(scd_nmChk == "fail"){
  			aler('<spring:message code="message.msg42" /> ');
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
	bSort: false,
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
						html = ' <img src="../images/af.png" id="full" alt="FULL 백업"/>';
					}else{
						html = ' <img src="../images/df.png" id="full" alt="FULL 백업"/>';
					}
					if(bar[1] > 0 ){
						html += ' <img src="../images/ai.png"  id="incremental" alt="Incremental 백업"/>';
					}else{
						html += ' <img src="../images/di.png"  id="incremental" alt="Incremental 백업"/>';
					}
					if(bar[2] > 0 ){
						html += ' <img src="../images/aa.png" id="archive" alt="Archive 백업"/>';
					}else{
						html += ' <img src="../images/da.png" id="archive" alt="Archive 백업"/>';
					}
					if(bar[3] > 0 ){
						html += ' <img src="../images/ad.png" id="dump" alt="DUMP 백업"/>';
					}else{
						html += ' <img src="../images/dd.png" id="dump" alt="DUMP 백업"/>';
					}
					
					if(full.scd_cndt == 'TC001801'){
						html += '<div style="margin-top: 7px;">';
					    html += '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
					    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>';
						html += '</div>';
					}else{
							html += '<div style="margin-top: 7px;">';
						    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';	
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';	
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
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
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';
							html += '</div>';
						}else{
								html += '<div style="margin-top: 7px;">';
							    html += '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'"); class="bold">'+full.exe_hms+' '+full.scd_nm+'</span>   ';	
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
	],'select': {'style': 'multi'}
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
	var height = 735;
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
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
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
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
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
		$("#btnGetData").click();
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

$(function(){
	
/* 	$('div').each(function(){
		
		var length =7;
		
		$(this).each(function(){
			if($(this).text().length >= length){
				$(this).text($(this).text().substr(0,length)+'...');
			}
		})
	}); */
	
	var intyear = parseInt("${month}".substr(0,4));
	var stryear = ""; 
	for(var i=-10;i<11;i++){
		stryear += "<option>"+(intyear+i)+"</option>";
	}
	$("#cmbyear").append(stryear);
	$("#cmbyear").val("${month}".substr(0,4));
	$("#cmbmonth").val("${month}".substr(4,2));
	
	$("#btnGetData").click(function(){

			var stmondt = new Date($("#cmbyear").val(),parseInt($("#cmbmonth").val())-1,1,0,0,0,0);
			var stdt = stmondt;
			var stweekofday = stmondt.getDay();
			if (stweekofday >= 0)
				stdt = addDays(stdt , stweekofday * -1);
			var eddt = addDays(stdt,35);

			$.ajax({
				url : "/selectMonthBckScheduleSearch.do",
				data : {"stdate" : stdt.format("yyyyMMdd")
					     , "eddate" : eddt.format("yyyyMMdd")
					     , "db_svr_id" : db_svr_id
					    },
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
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
						
						
						var appendnew = "<div class='line2'>";
						// data
						var maxcnt = 0;
						for(var i=0;i<7;i++){
							maxcnt = (maxcnt>tmparr[i].length)?maxcnt:tmparr[i].length;							
						}

						var height = "160px";	

						if (result.length > 4)
							height = String(12 * result.length) + "px"

						for(var i=0;i<7;i++){
							var showdt = stdt.format("MM/dd");
							var checkDt = stdt.format("MMdd");
							var checkDay = stdt.format("dd");
							var checkYear = stdt.format("yyyyMMdd");

							switch (i) {
				            case 0:
				            	appendnew += "<div class='cell' style='height:"+height+";'>";
				            	appendnew += "<font color=red>" + showdt + "</font>";    // 좌상단 날짜 
				            break;
				            case 6:
				            	appendnew += "<div class='cell' style='height:"+height+";'>";
				            	appendnew += "<font color=blue>" + showdt + "</font>";
				            break;
				            default:
				            	appendnew += "<div class='cell' style='height:"+height+";'>";
				            	appendnew += showdt;
				        	}

							//for(var j=0;j<tmparr[i].length;j++){
								//if (tmparr[i][j].runtype == "B"){
							//		appendnew += "<div style='clear:both;overflow:hidden;padding-left:5px;'><a style='color:green;' href='#' onclick='fn_showpopup2(\""+tmparr[i][j].job_id+"\",\""+tmparr[i][j].sort+"\");return false;'><b>["+tmparr[i][j].count+" 회]"+tmparr[i][j].job_nm+"</b></a></div>";
								//}else{
									//appendnew += "<div style='clear:both;overflow:hidden;padding-left:5px;'><a style='color:blue;' href='#' onclick='fn_showpopup(\""+tmparr[i][j].job_id+"\",\""+tmparr[i][j].sort+"\");return false;'><b>["+tmparr[i][j].count+" 회]"+tmparr[i][j].job_nm+"</b></a></div>";
								//}
							//}
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
					                		appendnew += "<div class='cellDate'>";
					                		if(scd_cndt == 'TC001801') {
					                			imgName = "ico_agent_1.png";
					                		} else {
					                			imgName = "ico_agent_2.png";
					                		}
					                		appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />';
					                		appendnew += "[<spring:message code="schedule.everyyear" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				                	}
				                //매월
				                } else if(exe_perd_cd == 'TC001603') {
				                	if(frst_reg_dtm<=checkYear){
					                	if(exe_day == checkDay) {
					                		appendnew += "<div class='cellDate'>";
					                		if(scd_cndt == 'TC001801') {
					                			imgName = "ico_agent_1.png";
					                		} else {
					                			imgName = "ico_agent_2.png";
					                		}
					                		appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />';
					                		appendnew += "[<spring:message code="schedule.everymonth" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				                	}
				                // 매주
				                } else if(exe_perd_cd == 'TC001602') {
				           			if(frst_reg_dtm<=checkYear){
					                	if(exe_dt.substr(i,1) == '1') {
					                		appendnew += "<div class='cellDate'>";
					                		if(scd_cndt == 'TC001801') {
					                			imgName = "ico_agent_1.png";
					                		} else {
					                			imgName = "ico_agent_2.png";
					                		}
					                		appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />';
					                		appendnew += "[<spring:message code="schedule.everyweek" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                	} 
				           			}
				                //매일
				                } else if(exe_perd_cd == 'TC001601') {
				                	if(frst_reg_dtm<=checkYear){
				                		appendnew += "<div class='cellDate'>";
				                		if(scd_cndt == 'TC001801') {
				                			imgName = "ico_agent_1.png";
				                		} else {
				                			imgName = "ico_agent_2.png";
				                		}
				                		appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />';
				                		appendnew += "[<spring:message code="schedule.everyday" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
				                	}
								//1회실행
				                } else if(exe_perd_cd == 'TC001605') {
					                if(exe_dt == checkYear) {   
					                	appendnew += "<div class='cellDate'>";
					                	if(scd_cndt == 'TC001801') {
					                		imgName = "ico_agent_1.png";
					                	} else {
					                		imgName = "ico_agent_2.png";
					                	}
					                	appendnew += '<img src="../images/' + imgName + '" alt=""  style="margin-right:10px"  width="10px" height="10px" />';
					                	appendnew += "[<spring:message code="schedule.one_time_run" />] [" + exe_hms +"] <a class='bold' href='#' onclick=javascript:fn_popup(" + scd_id + ");>"+scd_nm+"</a></div>";
					                }
			                	}
				                
							}
							
							appendnew +="</div>";
							stdt = addDays(stdt, 1);
						}
						appendnew += "</div>";
						$("#calendarbody").append(appendnew);
					}
				}
			}); 


		});

})

function addDays(theDate, days) {
    return new Date(theDate.getTime() + days*24*60*60*1000);
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
			<div id="contents">			
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4><spring:message code="schedule.bckSchedule"/> <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.backup_scheduler_01" /> </li>
								<li><spring:message code="help.backup_scheduler_02" /> </li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_tab">
							<ul id="tab1">
								<li class="atv"><a href="javascript:selectTab('week')"><spring:message code="backup_management.weekly_schedule_status" /> </a></li>
								<li><a href="javascript:selectTab('month')"><spring:message code="backup_management.monthly_schedule_status" /></a></li>
							</ul>
							<ul id="tab2" style="display:none;">
								<li><a href="javascript:selectTab('week')"><spring:message code="backup_management.weekly_schedule_status" /> </a></li>
								<li class="atv"><a href="javascript:selectTab('month')"><spring:message code="backup_management.monthly_schedule_status" /></a></li>
							</ul>
						</div>
						<div class="cmm_grp">
							<div class="btn_type_01" id="btnWeek">
								<span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button style="width: 150px;"><spring:message code="backup_management.weekly_schedule_registory" /></button></span>
							</div>
							<div class="btn_type_01" id="btnMonth">
								<!--  <span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button>월별 스케줄등록</button></span>-->
							</div>
							<div class="cmm_bd">																			
									<table id="week_scheduleList" class="cell-border display" width="100%">
										<thead>
											<tr>
												<th width="130"><spring:message code="common.sun" /></th>
												<th width="130"><spring:message code="common.mon" /></th>												
												<th width="130"><spring:message code="common.tue" /></th>
												<th width="130"><spring:message code="common.wed" /></th>
												<th width="130"><spring:message code="common.thu" /></th>
												<th width="130"><spring:message code="common.fri" /></th>												
												<th width="130"><spring:message code="common.sat" /></th>
											</tr>
										</thead>
									</table>		
									
									
							<div id="month_scheduleList" class="calendar_box">
								<div class="sch_form">
									<table width="100%"  class="write">
										<colgroup>
											<col style="width:130px;" />
											<col style="width:300px;" />
											<col/>
										</colgroup>
										<tbody>
											<tr style="height:50px;">
												<th  scope="row" class="t10"><spring:message code="common.search_year_month" /></th>
												<td>
													<select id="cmbyear"  style="width:100px" class="select t5">
													</select> <spring:message code="etc.etc09"/>&nbsp;&nbsp;&nbsp;&nbsp;
													<select id="cmbmonth"  class="select t6">
														<option>01</option><option>02</option><option>03</option><option>04</option><option>05</option><option>06</option>
														<option>07</option><option>08</option><option>09</option><option>10</option><option>11</option><option>12</option>
													</select> <spring:message code="common.mon" /> 

												</td>
												<td align="right">
	
													<span class="btn"  id="btnGetData"><button><spring:message code="common.search" /> </button></span>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								
								<div class="line1">
									<div class="cell date_brdleft"><span><font color="red"><spring:message code="common.sun" /></font></span></div>
									<div class="cell"><span><spring:message code="common.mon" /></span></div>
									<div class="cell"><span><spring:message code="common.tue" /></span></div>
									<div class="cell"><span><spring:message code="common.wed" /></span></div>
									<div class="cell"><span><spring:message code="common.thu" /></span></div>
									<div class="cell"><span><spring:message code="common.fri" /></span></div>
									<div class="cell"><span><font color="blue"><spring:message code="common.sat" /></font></span></div>
								</div>
								<div id="calendarbody">
								</div>
							</div>
									
																
							</div>		
						</div>
					</div>
				</div>
			</div>