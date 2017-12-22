<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script>
var table = null;
var scd_nmChk = "fail";

function fn_validation(){
	var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			   alert('<spring:message code="message.msg40" />');
			   scd_nm.focus();
			   return false;
		}
		var scd_exp = document.getElementById("scd_exp");
 		if (scd_exp.value == "") {
  			   alert('<spring:message code="message.msg41" />');
  			 scd_exp.focus();
  			   return false;
  		}if(scd_nmChk == "fail"){
  			alert('<spring:message code="message.msg42" />');
  		}
 		return true;
}

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "245px",
	scrollX: true,	
	bDestroy: true,
	paging : true,
	processing : true,
	searching : false,	
	deferRender : true,
	columns : [
	{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
	{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]], className : "dt-center", defaultContent : ""},
	{data : "db_svr_nm", className : "dt-center", defaultContent : ""}, //서버명
	{data : "bck_bsn_dscd_nm", className : "dt-center", defaultContent : ""}, //구분
	{data : "wrk_nm", className : "dt-center", defaultContent : ""}, //work명
	{data : "wrk_exp", className : "dt-center", defaultContent : ""}, //work설명
	{data : "exe_ord",	
			className: "dt-center",							
			defaultContent : "",
			render: function (data, type, full, meta,row) {
				if (type === 'display') {
					var $exe_order = $('<div class="order_exc">');
					$('<a class="dtMoveUp"><img src="../images/ico_order_up.png" alt="" /></a>').appendTo($exe_order);					
					$('<a class="dtMoveDown"><img src="../images/ico_order_down.png" alt="" /></a>').appendTo($exe_order);																												
					$('</div>').appendTo($exe_order);
					return $exe_order.html();
				}
			}
	},
	{data : "nxt_exe_yn",  
		className: "dt-center",
      	defaultContent: "",
        	render: function (data, type, full){
        		var onError ='<select  id="nxt_exe_yn" name="nxt_exe_yn">';
        		if(data.NXT_EXE_YN  == 'Y') {
        			onError +='<option value="y" selected>Y</option>';
        			onError +='<option value="n">N</option>';
        		} else {
        			onError +='<option value="y">Y</option>';
        			onError +='<option value="n" selected>N</option>';
        		}
        		onError +='</select>';
        		return onError;	
        	}
          },
	{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false }
	],
 		'drawCallback': function (settings) {
				// Remove previous binding before adding it
				$('.dtMoveUp').unbind('click');
				$('.dtMoveDown').unbind('click');
				// Bind clicks to functions
				$('.dtMoveUp').click(moveUp);
				$('.dtMoveDown').click(moveDown);
			} 
});

    table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
    
	// Move the row up
	function moveUp() {
		var tr = $(this).parents('tr');
		moveRow(tr, 'up');
	}

	
	// Move the row down
	function moveDown() {
		var tr = $(this).parents('tr');
		moveRow(tr, 'down');
	}

	
  // Move up or down (depending...)
  function moveRow(row, direction) {

    var index = table.row(row).index();
    var rownum = -1;
    if (direction === 'down') {
    	rownum = 1;
    }

    var data1 = table.row(index).data();
    data1.rownum += rownum;

    var data2 = table.row(index + rownum).data();
    data2.rownum += -rownum;

    table.row(index).data(data2);
    table.row(index + rownum).data(data1);
    table.draw(true);
	}
  
  
	  table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	  table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	  table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
	  table.tables().header().to$().find('th:eq(3)').css('min-width', '70px');
	  table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	  table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
	  table.tables().header().to$().find('th:eq(6)').css('min-width', '30px');
	  table.tables().header().to$().find('th:eq(7)').css('min-width', '30px');  
	  table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');

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
		dayHtml += '</select> <spring:message code="schedule.day" />';	
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
	fn_buttonAut();
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
});



function fn_buttonAut(){
	var int_button = document.getElementById("int_button"); 
	var add_button = document.getElementById("add_button"); 
	var del_button = document.getElementById("del_button"); 

	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		add_button.style.display = '';
		del_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		add_button.style.display = 'none';
		del_button.style.display = 'none';
	}
}


/* ********************************************************
 * work등록 팝업창 호출
 ******************************************************** */
function fn_workAdd(){
	var popUrl = "/popup/scheduleRegForm.do"; 
	var width = 1220;
	var height = 680;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	window.open(popUrl,"",popOption);

}


/* ********************************************************
 * work 삭제
 ******************************************************** */
function fn_workDel(){
	table.rows( '.selected' ).remove().draw();
}


/* ********************************************************
 * 실행주기 변경시 이벤트 호출
 ******************************************************** */
function fn_exe_pred(){
	var exe_perd_cd = $("#exe_perd_cd").val();
	
	if(exe_perd_cd == "TC001602"){
		$("#weekDay").show();
	}else{
		$("#weekDay").hide();
	}	

	if(exe_perd_cd == "TC001603"){
		$("#day").show();
	}else{
		$("#day").hide();
	}
	
	if(exe_perd_cd == "TC001604"){
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
	var exe_perd_cd = $("#exe_perd_cd").val(); 
		
	if(exe_perd_cd == "TC001602"){
	    var dayWeek = new Array();
	    var list = $("input[name='chk']");
	    for(var i = 0; i < list.length; i++){
	        if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
	        	dayWeek.push(1);
	        }else{
	        	dayWeek.push(list[i].value);
	        }
	    }	    
		var exe_dt = dayWeek.toString().replace(/,/gi,'').trim();
	}else if(exe_perd_cd == "TC001605"){
		var exe_dt = $("#datepicker1").val().replace(/-/gi,'').trim();
	}	

	if (!fn_validation()) return false;
	
	var datas = table.rows().data();

	if(datas.length < 1){
		alert('<spring:message code="message.msg39" />');
		return false;
	}
	
	var arrmaps = [];
	for (var i = 0; i < datas.length; i++){
		var tmpmap = new Object();
		tmpmap["index"] = i+1;
		tmpmap["wrk_nm"] = table.rows().data()[i].wrk_nm;
        tmpmap["wrk_id"] = table.rows().data()[i].wrk_id;      
        tmpmap["nxt_exe_yn"] = table.$('select option:selected', i).val();
		arrmaps.push(tmpmap);	
		}

	if (confirm('<spring:message code="message.msg132"/>')){
		$.ajax({
			url : "/insertSchedule.do",
			data : {
				 scd_nm : $("#scd_nm").val(),
				 scd_exp : $("#scd_exp").val(),
				 exe_perd_cd : $("#exe_perd_cd").val(),
				 exe_dt : exe_dt,
				 exe_month : $("#exe_month").val(),
				 exe_day : $("#exe_day").val(),
				 exe_h : $("#exe_h").val(),
				 exe_m : $("#exe_m").val(),
				 exe_s	 : $("#exe_s").val(),			 
				 exe_hms : $("#exe_s").val()+$("#exe_m").val()+$("#exe_h").val(),
				 sWork : JSON.stringify(arrmaps)
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
				alert('<spring:message code="message.msg43" />');
				location.href='/selectScheduleListView.do' ;
			}
		}); 	
	}else{
		return false;
	}
}


//스케줄명 중복체크
function fn_check() {
	var scd_nm = document.getElementById("scd_nm");
	if (scd_nm.value == "") {
		alert('<spring:message code="message.msg40" />');
		document.getElementById('scd_nm').focus();
		return;
	}
	$.ajax({
		url : '/scd_nmCheck.do',
		type : 'post',
		data : {
			scd_nm : $("#scd_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert('<spring:message code="message.msg45" /> ');
				document.getElementById("scd_nm").focus();
				scd_nmChk = "success";
			} else {
				scd_nmChk = "fail";
				alert('<spring:message code="message.msg46" />');
				document.getElementById("scd_nm").focus();
			}
		},
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
		}
	});
}
</script>

			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4><spring:message code="menu.schedule_registration" /> <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.schedule_registration_01" /></li>
								<li><spring:message code="help.schedule_registration_02" /></li>	
								<li><spring:message code="help.schedule_registration_03" /></li>					
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Function</li>
								<li><spring:message code="menu.schedule_information" /></li>
								<li class="on"><spring:message code="menu.schedule_registration" /></li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button><spring:message code="common.registory" /></button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:120px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t9 line"><spring:message code="schedule.schedule_name" /></th>
											<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm" maxlength="20"/>
											<span class="btn btnF_04 btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 80px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
											</td>
										</tr>
										<tr>
											<th scope="row" class="t9 line"><spring:message code="schedule.scheduleExp"/></th>
											<td><input type="text" class="txt t2" id="scd_exp" name="scd_exp" style="width:500px;"/></td>
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
											<th scope="row" class="ico_t4"><spring:message code="schedule.schedule_time_settings" /></th>
											<td>
												<div class="schedule_wrap">
													<span>
														<select class="select t5" name="exe_perd_cd" id="exe_perd_cd" onChange="fn_exe_pred();">
															<option value="TC001601"><spring:message code="schedule.everyday" /></option>
															<option value="TC001602"><spring:message code="schedule.everyweek" /></option>
															<option value="TC001603"><spring:message code="schedule.everymonth" /></option>
															<option value="TC001604"><spring:message code="schedule.everyyear" /></option>
															<option value="TC001605"><spring:message code="schedule.one_time_run" /></option>
														</select>
													</span>
													<span id="weekDay" >
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.sunday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.monday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.thuesday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.wednesday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.thursday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.friday" />
							                            <input type="checkbox" id="chk" name="chk" value="0"><spring:message code="schedule.saturday" />
                        							</span>
													<span id="calendar">
														<div class="calendar_area">
															<a href="#n" class="calendar_btn">달력열기</a>
															<input type="text" class="calendar" id="datepicker1" name="exe_dt" title="스케줄시간설정" readonly />
														</div>
													</span>
													<span>
															<div id="month"></div>
													</span>
													<span>
															<div id="day"></div>
													</span>
													<span>
															<div id="hour"></div>
													</span>
													<span>
															<div id="min"></div>
													</span>
													<span>
															<div id="sec"></div>
													</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

							<div class="cmm_bd">
								<div class="sub_tit">
									<p>Work <span id="add_button"></p>
									<div class="sub_btn">
										<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_workAdd();"><span id="add_button"><spring:message code="common.add" /></span></a>
										<a href="#n" class="btn btnF_04" onclick="fn_workDel();"><span id="del_button"><spring:message code="button.delete" /></span></a>
									</div>
								</div>
								<div class="overflow_area">							
									<table id="workList" class="display" cellspacing="0" width="100%">
										<thead>
											<tr>
												<th width="10"></th>
												<th width="30"><spring:message code="common.no" /></th>												
												<th width="130"><spring:message code="common.dbms_name" /></th>
												<th width="70"><spring:message code="common.division" /></th>
												<th width="100"><spring:message code="common.work_name" /> </th>
												<th width="150"><spring:message code="common.work_description" /></th>												
												<th width="30"><spring:message code="data_transfer.run_order" /></th>
												<th width="30">OnError</th>
												<th width="0"></th>
											</tr>
										</thead>
									</table>											
								</div>
							</div>		
						</div>
					</div>
				</div>
			</div>