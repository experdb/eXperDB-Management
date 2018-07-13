<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" media="screen"
	href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" type="text/css" media="screen"
	href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/dt/dataTables.colVis.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/dt/dataTables.checkboxes.css'/>" />

<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script>
var scd_id = ${scd_id};

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "195px",
	scrollX : true,
	bDestroy: true,
	processing : true,
	searching : false,	
	paging :false,
	bSort: false,
	columns : [
	{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
	{data : "idx", className : "dt-center", defaultContent : ""},
	{data : "db_svr_nm",  defaultContent : ""}, //서버명
	{data : "bck_bsn_dscd_nm",  defaultContent : ""}, //구분
	{data : "wrk_nm",  defaultContent : ""
		,"render": function (data, type, full) {
			  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		}
	}, //work명
	{ data : "wrk_exp",
		render : function(data, type, full, meta) {	 	
			var html = '';					
			html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
			return html;
		},
		defaultContent : ""
	},
	{data : "wrk_id",  defaultContent : "", visible: false },
	{data : "bck_wrk_id",  defaultContent : "", visible: false },
	{data : "bck_bsn_dscd",  defaultContent : "", visible: false },
	{data : "db_svr_id",  defaultContent : "", visible: false }
	],
});

    table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        });
    }).draw();
    
      table.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	  table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');	  
	  table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	  table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	  table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
	  table.tables().header().to$().find('th:eq(5)').css('min-width', '300px');
	  table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
	  table.tables().header().to$().find('th:eq(7)').css('min-width', '0px');
	  table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');  
	  table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');

  $(window).trigger('resize'); 
 
}


/* ********************************************************
 * 월
 ******************************************************** */
function fn_makeMonth(){
	var month = "";
	var monthHtml ="";
	
	monthHtml += '<select class="select t7" name="exe_month" id="exe_month">';	
	for(var i=1; i<=12; i++){
		if(i >= 0 && i<10){
			month = "0" + i;
		}else{
			month = i;
		}
		monthHtml += '<option value="'+month+'">'+month+'</option>';
	}
	monthHtml += '</select> <spring:message code="schedule.month" />';	
	$( "#month" ).append(monthHtml);
}


/* ********************************************************
 * 일
 ******************************************************** */
function fn_makeDay(){
	var day = "";
	var dayHtml ="";
	
	dayHtml += '<select class="select t7" name="exe_day" id="exe_day">';	
	for(var i=1; i<=31; i++){
		if(i >= 0 && i<10){
			day = "0" + i;
		}else{
			day = i;
		}
		dayHtml += '<option value="'+day+'">'+day+'</option>';
	}
		dayHtml += '</select> <spring:message code="common.day" />';	
	$( "#day" ).append(dayHtml);
}


/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="exe_h" id="exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="exe_m" id="exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#min" ).append(minHtml);
}

/* ********************************************************
 * 초
 ******************************************************** */
 function fn_makeSec(){
	var sec = "";
	var secHtml ="";
	
	secHtml += '<select class="select t7" name="exe_s" id="exe_s">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			sec = "0" + i;
		}else{
			sec = i;
		}
		secHtml += '<option value="'+sec+'">'+sec+'</option>';
	}
	secHtml += '</select> <spring:message code="schedule.second" />';	
	$( "#sec" ).append(secHtml);
} 


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	
	$("#day").hide();
	$("#month").hide();
	$("#weekDay").hide();
	$("#calendar").hide();

	fn_makeMonth();
	fn_makeDay();
	fn_makeHour();
	fn_makeMin();
	fn_makeSec();

	
 	$.ajax({
		url : "/selectModifyScheduleList.do",
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
				alert('<spring:message code="message.msg02" />');
				top.location.href="/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href="/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {	
			document.getElementById('scd_nm').value= result[0].scd_nm;
			document.getElementById('scd_exp').value= result[0].scd_exp;				
			document.getElementById('exe_perd_cd').value= result[0].exe_perd_cd;
			document.getElementById('datepicker1').value= result[0].exe_dt;
			document.getElementById('exe_month').value= result[0].exe_month;
			document.getElementById('exe_day').value= result[0].exe_day;
 			document.getElementById('exe_h').value= result[0].exe_hms.substring(4, 6);
			document.getElementById('exe_m').value= result[0].exe_hms.substring(2, 4);
			document.getElementById('exe_s').value= result[0].exe_hms.substring(0, 2);
			var rowList = [];
		    for (var i = 0; i <result.length; i++) {
		        rowList.push(result[i].wrk_id);   
		  	}		
		    fn_exe_pred(result[0].exe_dt, result[0].exe_month, result[0].exe_day); 
		    fn_workAddCallback(JSON.stringify(rowList));
		}
	}); 
	
});


/* ********************************************************
 * 실행주기 변경시 이벤트 호출
 ******************************************************** */
function fn_exe_pred(week, month, day){
	var exe_perd_cd = $("#exe_perd_cd").val();
	
	if(exe_perd_cd == "TC001602"){
		$("#weekDay").show();

	     var list = $("input:input:checkbox[name='chk']");
	    for(var i = 0; i < list.length; i++){	    
	    	if(week.charAt(i)==1){
	    		list[i].checked = true;
	    	}   	
	    } 
	}else{
		$("#weekDay").hide();
	}	
	
	if(exe_perd_cd == "TC001603"){
		document.getElementById('exe_day').value= day;
		$("#day").show();
	}else{
		$("#day").hide();
	}
	
	if(exe_perd_cd == "TC001604"){
		document.getElementById('exe_month').value= month;
		document.getElementById('exe_day').value= day;
		$("#day").show();
		$("#month").show();
	}else{
		$("#month").hide();
	}
	
	
	if(exe_perd_cd == "TC001605"){
		
		$("#calendar").show();
	}else{
		$("#calendar").hide();
	}
}


/* ********************************************************
 * 실행주기 변경시 이벤트 호출
 ******************************************************** */
function fn_workAddCallback(rowList){
	$.ajax({
		url : "/selectScheduleWorkList.do",
		data : {
			work_id : rowList,
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href="/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href="/";
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



function fn_scheduleStop(){
	if (confirm('<spring:message code="message.msg133"/>')){
     	$.ajax({
    		url : "/scheduleStop.do",
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
    				alert('<spring:message code="message.msg02" />');
    				top.location.href="/";
    			} else if(xhr.status == 403) {
    				alert('<spring:message code="message.msg03" />');
    				top.location.href="/";
    			} else {
    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
    			}
    		},
    		success : function(result) {
    			fn_updateSchedule();
    		}
    	});    
	}
}


function fn_bckModifyPopup(){
	var works = table.rows('.selected').data();

	if (works.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	}else if(works.length > 1){
		alert('<spring:message code="message.msg04" />');
		return false;
	}else{
		
		var bck_wrk_id = table.row('.selected').data().bck_wrk_id;
		var bck_mode = table.row('.selected').data().bck_bsn_dscd;
		var db_svr_id = table.row('.selected').data().db_svr_id;
		
		if(bck_mode == "TC000201"){
			var popUrl = "/popup/rmanRegReForm.do?db_svr_id="+db_svr_id+"&bck_wrk_id="+bck_wrk_id;
			var width = 954;
			var height = 650;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
			var winPop = window.open(popUrl,"rmanRegPop",popOption);
			winPop.focus();	
		}else{
			var popUrl = "/popup/dumpRegReForm.do?db_svr_id="+db_svr_id+"&bck_wrk_id="+bck_wrk_id;
			var width = 954;
			var height = 900;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
			var winPop = window.open(popUrl,"dumpRegPop",popOption);
			winPop.focus();	
		}
	}
}


</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
#workinfo{
	margin-top: 0px !important;
}

</style>
<body>
	<%@include file="../cmmn/commonLocale.jsp"%>  
	<%@include file="../cmmn/workRmanInfo.jsp"%>
	<%@include file="../cmmn/workDumpInfo.jsp"%>

	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="schedule.scheduleDetail"/></p>
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onClick="fn_bckModifyPopup()"><button type="button"><spring:message code="common.modify" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 90px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9 line"><spring:message code="schedule.schedule_name" /></th>
								<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm" readonly="readonly" /></td>
							</tr>
							<tr>
								<th scope="row" class="t9 line"><spring:message code="common.desc" /></th>
								<td><input type="text" class="txt t2" id="scd_exp" name="scd_exp" readonly="readonly" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>스케줄 등록</caption>
						<colgroup>
							<col style="width: 115px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t4"><spring:message code="schedule.schedule_time_settings" /></th>
								<td>
									<div class="schedule_wrap">
										<span> 
										<select class="select t5" name="exe_perd_cd" id="exe_perd_cd" onChange="fn_exe_pred();"disabled="disabled">
												<option value="TC001601"><spring:message code="schedule.everyday" /></option>
												<option value="TC001602"><spring:message code="schedule.everyweek" /></option>
												<option value="TC001603"><spring:message code="schedule.everymonth" /></option>
												<option value="TC001604"><spring:message code="schedule.everyyear" /></option>
												<option value="TC001605"><spring:message code="schedule.one_time_run" /></option>
										</select>
										</span> 
										<span id="weekDay"> 
										<input type="checkbox" id="chk0" name="chk" value="0" onclick="return false;"><spring:message code="schedule.sunday" />  
										<input type="checkbox" id="chk1" name="chk" value="0" onclick="return false;"><spring:message code="schedule.monday" /> 
										<input type="checkbox" id="chk2" name="chk" value="0" onclick="return false;"><spring:message code="schedule.thuesday" />
										<input type="checkbox" id="chk3" name="chk" value="0" onclick="return false;"><spring:message code="schedule.wednesday" /> 
										<input type="checkbox" id="chk4" name="chk" value="0" onclick="return false;"><spring:message code="schedule.thursday" />
										<input type="checkbox" id="chk5" name="chk" value="0" onclick="return false;"><spring:message code="schedule.friday" />  
										<input type="checkbox" id="chk6" name="chk" value="0" onclick="return false;"><spring:message code="schedule.saturday" /> 
										</span> 
										<span id="calendar">
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="datepicker1" name="exe_dt" title="스케줄시간설정" readonly />
											</div>
										</span> 
										<span>
											<div id="month" disabled="disabled"></div>
										</span> 
										<span>
											<div id="day" disabled="disabled"></div>
										</span> 
										<span>
											<div id="hour" disabled="disabled"></div>
										</span> 
										<span>
											<div id="min" disabled="disabled"></div>
										</span> 
										<span>
											<div id="sec" disabled="disabled"></div>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="cmm_bd">
					<div class="sub_tit">
						<p>Work</p>
					</div>
					<table id="workList" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="50"></th>
								<th width="100"><spring:message code="common.no" /></th>
								<th width="200"><spring:message code="data_transfer.server_name" /></th>
								<th width="200"><spring:message code="common.division" /></th>
								<th width="200"><spring:message code="common.work_name" /></th>
								<th width="300"><spring:message code="common.work_description" /></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>