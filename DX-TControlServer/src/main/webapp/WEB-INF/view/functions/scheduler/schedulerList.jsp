<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	String usr_id = (String)session.getAttribute("usr_id");
%>
<script>
var table = null;
var scd_cndt = null;
function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#scheduleList').DataTable({
	scrollY : "245px",
	scrollX: true,	
	bDestroy: true,
	paging : true,
	processing : true,
	searching : false,	
	deferRender : true,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "scd_nm", className : "dt-left", defaultContent : ""
			,render: function (data, type, full) {
				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
			}
		},
		{data : "scd_exp", className : "dt-left", defaultContent : ""},
		{data : "wrk_cnt", className : "dt-center", defaultContent : ""}, //work갯수
		{data : "prev_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "nxt_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "scd_cndt", 
			render: function (data, type, full){
				if(full.scd_cndt=="TC001801"){
					var html = '<img src="../images/ico_agent_1.png" alt="" />';
						return html;
				}else{
					var html = '<img src="../images/ico_agent_2.png" alt="" />';
					return html;
				}
				return data;
			},
			className : "dt-center", defaultContent : "" 	
		},
		{data : "status", 
			render: function (data, type, full){
				if(full.frst_regr_id == "<%=usr_id%>"){			
					if(full.status == "s"){
						var html = '<img src="../images/ico_w_25.png" alt="실행중" id="scheduleStop"/>';
							return html;
					}else{
						var html = '<img src="../images/ico_w_24.png" alt="중지중" id="scheduleStart" />';
						return html;
					}					
				return data;
				}
			},
			className : "dt-center", defaultContent : "" 	
		},		
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "scd_id", className : "dt-center", defaultContent : "", visible: false },
	]
	});
	
 	$('#scheduleList tbody').on('click','#scheduleStop', function () {
 	    var $this = $(this);
	    var $row = $this.parent().parent();
	    $row.addClass('select-detail');
	    var datas = table.rows('.select-detail').data();

	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm("스케줄을 중지 하시겠습니까?")){
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
		    				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
		    				 location.href = "/";
		    			} else if(xhr.status == 403) {
		    				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		    	             location.href = "/";
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

	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm("스케줄을 실행 하시겠습니까?")){
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
		    				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
		    				 location.href = "/";
		    			} else if(xhr.status == 403) {
		    				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		    	             location.href = "/";
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
 	
	//더블 클릭시
	 $('#scheduleList tbody').on('dblclick','tr',function() {
		var scd_id = table.row(this).data().scd_id;
		
		var popUrl = "/scheduleWrkListVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
		var width = 1120;
		var height = 655;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
		window.open(popUrl,"",popOption);
	});		 
	
	
	  table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	  table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	  table.tables().header().to$().find('th:eq(2)').css('min-width', '250px');
	  table.tables().header().to$().find('th:eq(3)').css('min-width', '395px');
	  table.tables().header().to$().find('th:eq(4)').css('min-width', '60px');
	  table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');  
	  table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(9)').css('min-width', '65px');
	  table.tables().header().to$().find('th:eq(10)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(11)').css('min-width', '65px'); 
	  table.tables().header().to$().find('th:eq(12)').css('min-width', '130px'); 
	  table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
 
  	
});


function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	
	//조회버튼만 남기고, 등록,수정,삭제는 My스케줄에서 가능
/* 	var int_button = document.getElementById("int_button"); 
	var mdf_button = document.getElementById("mdf_button"); 
	var del_button = document.getElementById("del_button");  */
	
	/* if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		mdf_button.style.display = '';
		del_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		mdf_button.style.display = 'none';
		del_button.style.display = 'none';
	} */
		
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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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



/* ********************************************************
 * 스케줄 리스트 삭제
 ******************************************************** */
function fn_deleteScheduleList(){
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].scd_id);   
       if(table.rows('.selected').data()[i].status == "s"){
    	   alert("실행중인 스케줄이 존재합니다.");
    	   return false;
       }
  }	
    
   if(confirm("스케줄을 삭제하시겠습니까?")){
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				alert("삭제 되었습니다.");
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
		alert("선택된 항목이 없습니다.");
		return false;
	}else if (datas.length >1){
		alert("하나만 선택하셔야 합니다.")
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
	hourHtml += '</select> 시';	
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
	minHtml += '</select> 분';	
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
	hourHtml += '</select> 시';	
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
	minHtml += '</select> 분';	
	$( "#a_min" ).append(minHtml);
}
</script>

<%@include file="../../cmmn/scheduleInfo.jsp"%>

<form name="modifyForm" method="post">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스케줄 실행/중지<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
				<div class="infobox"> 
					<ul>
						<li>현재 등록되어 있는 스케줄 정보를 조회합니다.</li>
						<li>현재 등록되어 있는 스케줄을 실행 또는 중지합니다.</li>	
						</ul>
				</div>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>스케줄정보</li>
					<li class="on">스케줄 실행/중지</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" id="read_button"><button onClick="fn_selectScheduleList();">조회</button></span>
					<!-- <span class="btn" id="int_button"><a href="/insertScheduleView.do"><button>등록</button></a></span>
					<span class="btn" id="mdf_button"><button onClick="fn_modifyScheduleListView();">수정</button></span>
					<span class="btn" id="del_button"><button onClick="fn_deleteScheduleList();">삭제</button></span> -->
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:120px;" />
							<col  />
						</colgroup> 
						<tbody>
								<tr>
									<th scope="row" class="t9 line" style="width:130px;">스케줄명</th>
									<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm"/></td>
								</tr>
								<tr>
									<th scope="row" class="t9 line">설명</th>
									<td><input type="text" class="txt t2" id="scd_exp" name="scd_exp" style="width:500px;"/></td>
								</tr>
								<tr>
									<th scope="row" class="t9 line">다음수행시간</th>
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
								</tr>
								<tr>
									<th scope="row" class="t9 line" >구동상태</th>
									<td>
									<select class="select t8" name="scd_cndt" id="scd_cndt">
										<option value="%">전체</option>
										<option value="TC001801">실행</option>
										<option value="TC001802">중지</option>
									</select>	</td>				
								</tr>				
								<tr>
									<th scope="row" class="t9 line">등록자</th>
									<td ><input type="text" class="txt t2" id="frst_regr_id" name="frst_regr_id" /></td>
								</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
				
				<table id="scheduleList" class="cell-border display" >
				<caption>스케줄 리스트</caption>
					<thead>
						<tr>
							<th width="10"></th>
							<th width="30">No</th>
							<th width="250">스케줄명</th>
							<th width="395">설명</th>
							<th width="60">Work갯수</th>
							<th width="130">이전수행시간</th>
							<th width="130">다음수행시간</th>
							<th width="70">구동상태</th>
							<th width="130">실행</th>
							<th width="65">등록자</th>
							<th width="130">등록일시</th>
							<th width="65">수정자</th>
							<th width="130">수정일시</th>
							<th width="0"></th>
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->