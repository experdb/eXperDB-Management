<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
	paging : false,
	processing : true,
	searching : false,	
	deferRender : true,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "scd_nm", className : "dt-center", defaultContent : ""},
		{data : "scd_exp", className : "dt-center", defaultContent : ""},
		{data : "wrk_cnt", className : "dt-center", defaultContent : ""}, //work갯수
		{data : "prev_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "nxt_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "status", 
			render: function (data, type, full){
				if(full.status == "s"){
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
		    		error : function(xhr, status, error) {
		    			alert("실패")
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
		    		error : function(xhr, status, error) {
		    			alert("실패")
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





		
/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_makeHour();
	fn_makeMin();
	
	scd_cndt = "${scd_cndt}";
	fn_buttonAut();
	fn_init();
	fn_selectScheduleList();
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
  	$.ajax({
		url : "/selectScheduleList.do",
		data : {
			scd_cndt : scd_cndt,
			scd_nm : $("#scd_nm").val(),
			scd_exp : $("#scd_exp").val()
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
			error : function(xhr, status, error) {
				alert("실패")
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
	$( "#b_hour" ).append(hourHtml);
	$( "#a_hour" ).append(hourHtml);
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
	$( "#b_min" ).append(minHtml);
	$( "#a_min" ).append(minHtml);
}
</script>

<form name="modifyForm" method="post">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스케줄 관리 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>스케줄정보</li>
					<li class="on">스케줄 관리</li>
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
							<col style="width:130px;" />
							<col style="width:330px;" />
							<col style="width:30px;" />
							<col style="width:330px;" />
							<col style="width:100px;" />
							<col style="width:10px;" />
							<col />
						</colgroup> 
						<tbody>
								<tr>
									<th scope="row" class="t9 line">스케줄명</th>
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
												<div class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="datepicker1" name="exe_dt" title="스케줄시간설정" readonly />
														<span id="b_hour"></span>
														<span id="b_min"></span>
												</div>
										</span>
									</td>
									<td>~</td>
									<td>
										<span id="calendar">
												<div class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="datepicker1" name="exe_dt" title="스케줄시간설정" readonly />
														<span id="a_hour"></span>
														<span id="a_min"></span>
												</div>
										</span>
									</td>
								</tr>
								<tr>
									<th scope="row" class="t9 line" >구동상태</th>
									<td ><input type="text" class="txt t2" id="scd_exp" name="scd_exp" /></td>				
								</tr>				
								<tr>
									<th scope="row" class="t9 line">등록자</th>
									<td ><input type="text" class="txt t2" id="scd_exp" name="scd_exp" /></td>
								</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
				
				<table id="scheduleList" class="cell-border display" >
				<caption>스케쥴 리스트</caption>
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