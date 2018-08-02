<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs.jsp"%>
<script>
var table = null;
var scd_cndt = null;
function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#scheduleList').DataTable({
	scrollY : "425px",
	scrollX: true,	
	bDestroy: true,
	paging : true,
	processing : true,
	searching : false,	
	deferRender : true,
	bSort: false,
	columns : [
		{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "rownum",  className : "dt-center", defaultContent : ""}, 		
		{data : "scd_nm", className : "dt-left", defaultContent : ""
			,render: function (data, type, full) {
				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
			}
		},
		{ data : "scd_exp",
				render : function(data, type, full, meta) {	 	
					var html = '';					
					html += '<span title="'+full.scd_exp+'">' + full.scd_exp + '</span>';
					return html;
				},
				defaultContent : ""
			},
		{data : "db_svr_nm",  defaultContent : ""},
		{data : "wrk_cnt",  className : "dt-right", defaultContent : ""}, //work갯수
		{data : "prev_exe_dtm",  defaultContent : ""
			,render: function (data, type, full) {
			if(full.prev_exe_dtm == null){
				var html = '-';
				return html;
			}
		  return data;
		}}, 
		{data : "nxt_exe_dtm",  defaultContent : ""
			,render: function (data, type, full) {
				if(full.nxt_exe_dtm == null){
					var html = '-';
					return html;
				}
			  return data;
		}}, 
		{data : "status", 
			render: function (data, type, full){
				if(full.scd_cndt == "TC001801"){
					var html = '<img src="../images/ico_agent_1.png" alt="" />';
						return html;
				}else if(full.scd_cndt == "TC001802"){
					var html = '<img src="../images/ico_state_03.png" alt="" />';
					return html;
				}else{
					var html = '<img src="../images/ico_agent_2.png" alt="" />';
					return html;
				}
				return data;
			},
			className : "dt-center",
			 defaultContent : "" 	
		},
		{data : "status", 
			render: function (data, type, full){		
					if(full.scd_cndt == "TC001801"){
						var html = '<img src="../images/ico_state_04.png"  id="scheduleStop"/>';
							return html;
					}else if(full.scd_cndt == "TC001802"){
						var html = '<img src="../images/ico_state_03.png" id="scheduleRunning" /> <spring:message code="etc.etc28"/>';
						return html;
					}else{
						var html = '<img src="../images/ico_state_06.png" id="scheduleStart" />';
						return html;
					}			
				return data;
			},
			className : "dt-center",
			 defaultContent : "" 	
		},
		{
			data : "",
			render : function(data, type, full, meta) {
				var html = "<span class='btn btnC_01 btnF_02'><button id='detail'><spring:message code='data_transfer.detail_search' /> </button></span>";
				return html;
			},
			className : "dt-center",
			defaultContent : "",
			orderable : false
		},
		{data : "frst_regr_id",  defaultContent : ""},
		{data : "frst_reg_dtm",  defaultContent : ""},
		{data : "lst_mdfr_id",  defaultContent : ""},
		{data : "lst_mdf_dtm",  defaultContent : ""},
		{data : "scd_id",  defaultContent : "", visible: false },
		{data : "exe_dt",  defaultContent : "", visible: false },
	],'select': {'style': 'multi'}
	});
	

 	$('#scheduleList tbody').on('click','#scheduleStop', function () {
 	    var $this = $(this);
	    var $row = $this.parent().parent();
	    $row.addClass('select-detail');
	    var datas = table.rows('.select-detail').data();

	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm('<spring:message code="message.msg131"/>')){
		     	$.ajax({
		    		url : "/scheduleStop.do",
		    		data : {
		    			scd_id : row.scd_id
		    		},
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
		    			location.reload();
		    		}
		    	});    
	       }
	    } 
	}); 
 	
 	$('#scheduleList tbody').on('click','#scheduleStart', function () {
 	    var $this = $(this);
	    var $row = $this.parent().parent();
	    $row.addClass('select-detail');
	    var datas = table.rows('.select-detail').data();
	    
	     if(datas[0].exe_perd_cd == "TC001605"){
	    	 if (!fn_dateValidation(datas[0].exe_dt)) return false;
		}	 
	    
	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm('<spring:message code="message.msg130"/>')){
		     	$.ajax({
		    		url : "/scheduleReStart.do",
		    		data : {
		    			sWork : JSON.stringify(row)
		    		},
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
		    			location.reload();
		    		}
		    	});    
	       }
	    } 
	}); 
 	
 	
 	$('#scheduleList tbody').on('click','#scheduleRunning', function () {
 	    alert('<spring:message code="message.msg189"/>');
 	    return false;
	}); 
 	
	//더블 클릭시
	if("${wrt_aut_yn}" == "Y"){
		 $('#scheduleList tbody').on('dblclick','tr',function() {
			var scd_id = table.row(this).data().scd_id;
			
			var popUrl = "/scheduleWrkListVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
			var width = 1100;
			var height = 560;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
					
			window.open(popUrl,"",popOption);
		});		
	}
 
	
	
	//상세조회 클릭시
	$('#scheduleList tbody').on('click','#detail',function() {
		var $this = $(this);
    	var $row = $this.parent().parent().parent();
    	$row.addClass('detail');
    	var datas = table.rows('.detail').data();
    	if(datas.length==1) {
    		var row = datas[0];
	    	$row.removeClass('detail');
 			var scd_id  = row.scd_id;
 			var popUrl = "/scheduleWrkListVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
 			var width = 1100;
 			var height = 560;
 			var left = (window.screen.width / 2) - (width / 2);
 			var top = (window.screen.height /2) - (height / 2);
 			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
 			window.open(popUrl,"",popOption);
    	}
	});	
	
	  table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	  table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');	  
	  table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	  table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
	  table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	  table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
	  table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(7)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(8)').css('min-width', '70px');  
	  table.tables().header().to$().find('th:eq(9)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	  table.tables().header().to$().find('th:eq(11)').css('min-width', '65px');
	  table.tables().header().to$().find('th:eq(12)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(13)').css('min-width', '65px'); 
	  table.tables().header().to$().find('th:eq(14)').css('min-width', '130px'); 
	  table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');
	  table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
    $(window).trigger('resize'); 
}




$(function() {
	var dateFormat = "yyyy-mm-dd", from = $("#from").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#to").datepicker("option", "minDate", selectedDate);
		}
	})

	to = $("#to").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#from").datepicker("option", "maxDate", selectedDate);
		}
	})

	function getDate(element) {
		var date;
		try {
			date = $.datepicker.parseDate(dateFormat, element.value);
		} catch (error) {
			date = null;
		}
		return date;
	}
});
		
/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_makeFromHour();
	fn_makeFromMin();
	fn_makeToHour();
	fn_makeToMin();
	
	var scd_cndt = "${scd_cndt}";
	$('#scd_cndt').val(scd_cndt);
	
	fn_buttonAut();
	fn_init();
	
  	$.ajax({
		url : "/selectScheduleList.do",
		data : {
			wrk_nm : $("#wrk_nm").val(),
			scd_cndt : $("#scd_cndt").val(),
			scd_nm : $("#scd_nm").val(),
			frst_regr_id : $("#frst_regr_id").val(),
			scd_exp : $("#scd_exp").val()
		},
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
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
 
  	
});


function fn_buttonAut(){

	var read_button = document.getElementById("read_button"); 
	
	//조회버튼만 남기고, 등록,수정,삭제는 My스케줄에서 가능
 	var int_button = document.getElementById("int_button"); 
	var mdf_button = document.getElementById("mdf_button"); 
	var del_button = document.getElementById("del_button"); 
	
	 if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		mdf_button.style.display = '';
		del_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		mdf_button.style.display = 'none';
		del_button.style.display = 'none';
	} 
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
}


/* ********************************************************
 * 스케줄 리스트 조회
 ******************************************************** */
function fn_selectScheduleList(){
	var nxt_exe_from = $("#from").val() + " " + $("#from_exe_h").val() + ":" + $("#from_exe_m").val();
	var nxt_exe_to = $("#to").val() + " " + $("#to_exe_h").val() + ":" + $("#to_exe_m").val();
	
	
  	$.ajax({
		url : "/selectScheduleList.do",
		data : {
			wrk_nm : $("#wrk_nm").val(),
			scd_cndt : $("#scd_cndt").val(),
			scd_nm : $("#scd_nm").val(),
			frst_regr_id : $("#frst_regr_id").val(),
			scd_exp : $("#scd_exp").val(),
			nxt_exe_from : nxt_exe_from,
			nxt_exe_to : nxt_exe_to
		},
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
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
}



/* ********************************************************
 * 스케줄 리스트 삭제
 ******************************************************** */
function fn_deleteScheduleList(){
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].scd_id);   
       if(table.rows('.selected').data()[i].status == "s"){
    	   alert("<spring:message code='message.msg36'/>");
    	   return false;
       }
  }	
    
   if(confirm('<spring:message code="message.msg134"/>')){
	  	$.ajax({
			url : "/deleteScheduleList.do",
			data : {
				rowList : JSON.stringify(rowList)
			},
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
				alert('<spring:message code="message.msg60" />');
				location.reload();
			}
		}); 		   
   }
}


/* ********************************************************
 * 스케줄 리스트 수정
 ******************************************************** */
function fn_modifyScheduleListView(){
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	}else if (datas.length >1){
		alert('<spring:message code="message.msg38" />');
		return false;
	}
	
	var scd_id = table.row('.selected').data().scd_id;
	
	var form = document.modifyForm;
	form.action = "/modifyScheduleListVeiw.do?scd_id="+scd_id;
	form.submit();
	return;
	
}


/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeFromHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="from_exe_h" id="from_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#b_hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeFromMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="from_exe_m" id="from_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#b_min" ).append(minHtml);
}


/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeToHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="to_exe_h" id="to_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#a_hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeToMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="to_exe_m" id="to_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#a_min" ).append(minHtml);
}


//스케줄 재실행  현재 날짜 이전의 날짜를 실행할수 없도록 하는 함수
function fn_dateValidation(exe_dt){
	var day = new Date();
	var dd = day.getDate();
	var mm = day.getMonth()+1; //January is 0!
	var yyyy = day.getFullYear();
	
	if((mm+"").length < 2) {  // 월이 한자리 수인 경우 (예: 1, 3, 5) 앞에 0을 붙여주기 위해, 즉 01, 03, 05
		mm = "0" + mm;
	}
	
	if((dd+"").length < 2) {       // 일이 한자리 수인 경우 앞에 0을 붙여주기 위해
		dd = "0" + dd;
	}
	var today = yyyy +"" + mm + "" + dd;
	
	 if(today > exe_dt){
		alert('<spring:message code="message.msg213"/>');
		return false;
	} 
	 return true;
} 
</script>

<%@include file="../../cmmn/scheduleInfo.jsp"%>

<form name="modifyForm" method="post">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="etc.etc27"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
				<div class="infobox"> 
					<ul>
						<li><spring:message code="help.schedule_run_stop_01" /></li>
						<li><spring:message code="help.schedule_run_stop_02" /></li>	
						</ul>
				</div>
			<div class="location">
				<ul>
					<li>Function</li>
					<li><spring:message code="menu.schedule_information" /></li>
					<li class="on"><spring:message code="menu.schedule_run_stop" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" id="read_button"><button type="button" onClick="fn_selectScheduleList();"><spring:message code="common.search" /></button></span>
					<span class="btn" id="int_button"><a href="/insertScheduleView.do"><button><spring:message code="common.registory" /></button></a></span>
					<span class="btn" id="mdf_button"><button type="button" onClick="fn_modifyScheduleListView();"><spring:message code="common.modify" /></button></span>
					<span class="btn" id="del_button"><button type="button" onClick="fn_deleteScheduleList();"><spring:message code="common.delete" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:140px;" />
							<col  />
						</colgroup> 
						<tbody>
								<tr>
									<th scope="row" class="t9 line" style="width:130px;"><spring:message code="schedule.schedule_name" /></th>
									<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm" maxlength="20"/></td>
								</tr>
								<tr>
									<th scope="row" class="t9 line"><spring:message code="schedule.scheduleExp"/></th>
									<td><textarea class="tbd1" name="scd_exp" id="scd_exp" maxlength="150"></textarea></td>
								</tr>
								<%-- <tr>
									<th scope="row" class="t9 line"><spring:message code="schedule.next_run_time" /></th>
									<td>
										<span id="calendar">
												<span class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="from" name="b_exe_dt" title="스케줄시간설정"  />
														<span id="b_hour"></span>
														<span id="b_min"></span>
												</span>
										</span>
										 &nbsp&nbsp&nbsp&nbsp&nbsp  ~ &nbsp&nbsp&nbsp&nbsp&nbsp  
										<span id="calendar">
												<span class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="to" name="a_exe_dt" title="스케줄시간설정"  />
														<span id="a_hour"></span>
														<span id="a_min"></span>
												</span>
										</span>
									</td>
								</tr> --%>
								<tr>
									<th scope="row" class="t9 line"><spring:message code="common.work_name" /></th>
									<td ><input type="text" class="txt t2" id="wrk_nm" name="wrk_nm" maxlength="20"/></td>
								</tr>
								<tr>
									<th scope="row" class="t9 line" ><spring:message code="common.run_status" /></th>
									<td>
									<select class="select t8" name="scd_cndt" id="scd_cndt">
										<option value="%"><spring:message code="schedule.total" /></option>
										<option value="TC001801"><spring:message code="etc.etc37"/></option>
										<option value="TC001802"><spring:message code="schedule.run" /></option>
										<option value="TC001803"><spring:message code="schedule.stop" /></option>
									</select>	</td>				
								</tr>				
								<tr>
									<th scope="row" class="t9 line"><spring:message code="common.register" /></th>
									<td ><input type="text" class="txt t2" id="frst_regr_id" name="frst_regr_id" /></td>
								</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
				
				<table id="scheduleList" class="cell-border display" cellspacing="0" width="100%">
				<caption>스케줄 리스트</caption>
					<thead>
						<tr>
							<th width="10"></th>
							<th width="30"><spring:message code="common.no" /></th>							
							<th width="200"><spring:message code="schedule.schedule_name" /></th>
							<th width="300"><spring:message code="schedule.scheduleExp"/></th>
							<th width="100"><spring:message code="data_transfer.server_name" /></th>
							<th width="70"><spring:message code="schedule.work_count" /></th>
							<th width="130"><spring:message code="schedule.pre_run_time" /></th>
							<th width="130"><spring:message code="schedule.next_run_time" /></th>
							<th width="70"><spring:message code="common.run_status" /></th>
							<th width="130"><spring:message code="etc.etc26"/></th>
							<th width="100"><spring:message code="data_transfer.detail_search" /></th>
							<th width="65"><spring:message code="common.register" /></th>
							<th width="130"><spring:message code="common.regist_datetime" /></th>
							<th width="65"><spring:message code="common.modifier" /></th>
							<th width="130"><spring:message code="common.modify_datetime" /></th>
							<th width="0"></th>
							<th width="0"></th>
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->