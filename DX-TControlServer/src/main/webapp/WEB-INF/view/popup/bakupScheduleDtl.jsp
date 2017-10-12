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
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
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
	scrollY : "145px",
	bDestroy: true,
	processing : true,
	searching : false,	
	paging :false,
	columns : [
	{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]], className : "dt-center", defaultContent : ""},
	{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false },
	{data : "db_svr_nm", className : "dt-center", defaultContent : ""}, //서버명
	{data : "bck_bsn_dscd_nm", className : "dt-center", defaultContent : ""}, //구분
	{data : "wrk_nm", className : "dt-center", defaultContent : ""}, //work명
	{data : "wrk_exp", className : "dt-center", defaultContent : ""}, //work설명
	],
});

    table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
    
 
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
	monthHtml += '</select> 월';	
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
		dayHtml += '</select> 일';	
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
	hourHtml += '</select> 시';	
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
	minHtml += '</select> 분';	
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
	secHtml += '</select> 초';	
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
		error : function(xhr, status, error) {
			alert("실패")
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
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {		
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}



function fn_scheduleStop(){
	if (confirm("스케줄을 수정 하시겠습니까?")){
     	$.ajax({
    		url : "/scheduleStop.do",
    		data : {
    			scd_id : scd_id
    		},
    		dataType : "json",
    		type : "post",
    		error : function(xhr, status, error) {
    			alert("실패")
    		},
    		success : function(result) {
    			fn_updateSchedule();
    		}
    	});    
	}
}



</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
				<div class="contents_wrap">
					<div class="contents">
						<div class="cmm_grp">
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t9 line">스케줄명</th>
											<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm" readonly="readonly" /></td>
										</tr>
										<tr>
											<th scope="row" class="t9 line">설명</th>
											<td>
												<input type="text" class="txt t2" id="scd_exp" name="scd_exp" readonly="readonly" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>스케줄 등록</caption>
									<colgroup>
										<col style="width:115px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="ico_t4">스케쥴시간설정</th>
											<td>
												<div class="schedule_wrap">
													<span>
														<select class="select t5" name="exe_perd_cd" id="exe_perd_cd" onChange="fn_exe_pred();" disabled="disabled">
															<option value="TC001601">매일</option>
															<option value="TC001602">매주</option>
															<option value="TC001603">매월</option>
															<option value="TC001604">매년</option>
															<option value="TC001605">1회실행</option>
														</select>
													</span>
													<span id="weekDay" >
							                            <input type="checkbox" id="chk0" name="chk" value="0" onclick="return false;" >일요일
							                            <input type="checkbox" id="chk1" name="chk" value="0" onclick="return false;" >월요일
							                            <input type="checkbox" id="chk2" name="chk" value="0" onclick="return false;" >화요일
							                            <input type="checkbox" id="chk3" name="chk" value="0" onclick="return false;" >수요일
							                            <input type="checkbox" id="chk4" name="chk" value="0" onclick="return false;" >목요일
							                            <input type="checkbox" id="chk5" name="chk" value="0" onclick="return false;" >금요일
							                            <input type="checkbox" id="chk6" name="chk" value="0" onclick="return false;" >토요일
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
									<table id="workList" class="cell-border display" >
										<thead>
											<tr>
												<th>No</th>
												<th></th>
												<th>서버명</th>
												<th>구분</th>
												<th>work명</th>
												<th>Work설명</th>
											</tr>
										</thead>
									</table>											
							</div>		
						</div>
					</div>
				</div>
</body>
</html>