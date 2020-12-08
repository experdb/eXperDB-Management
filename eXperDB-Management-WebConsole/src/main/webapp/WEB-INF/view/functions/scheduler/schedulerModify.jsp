<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>

<script>
var confirm_title = ""; 

var scd_id = ${scd_id};

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "245px",
	bDestroy: true,
	processing : true,
	searching : false,	
	bSort: false,
	scrollX: true,
	columns : [
	{data : "rownum", className : "dt-center", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
	{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]],  className : "dt-center", defaultContent : ""},
	{data : "wrk_nm", className : "dt-left", defaultContent : ""}, //work명
	{ data : "wrk_exp",
		render : function(data, type, full, meta) {	 	
			var html = '';					
			html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
			return html;
		},
		defaultContent : ""
	},
	{data : "db_svr_nm",  defaultContent : ""}, //서버명
	{data : "bsn_dscd_nm",  defaultContent : ""}, //구분
	{data : "bck_bsn_dscd_nm",  defaultContent : ""}, //백업구분
	{data : "exe_ord",	
			className: "dt-center",							
			defaultContent : "",
			render: function (data, type, full, meta,row) {
				if (type === 'display') {
					var $exe_order = $('<div class="order_exc">');
					$('<a class="dtMoveUp"><div class="badge badge-pill badge-success"><i class="fa fa-angle-double-up" style="font-size: 18px;cursor:pointer;"></i></div></a>').appendTo($exe_order);					
					$('<a class="dtMoveDown"><div class="badge badge-pill badge-warning"><i class="fa fa-angle-double-down" style="font-size: 18px;cursor:pointer;"></i></div></a></a>').appendTo($exe_order);																										
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
        		if(full.nxt_exe_yn  == 'Y') {
        			onError +='<option value="Y" selected>Y</option>';
        			onError +='<option value="N">N</option>';
        		} else {
        			onError +='<option value="Y">Y</option>';
        			onError +='<option value="N" selected>N</option>';
        		}
        		onError +='</select>';
        		return onError;	
        	}
          },
     {data : "wrk_id",  defaultContent : "", visible: false }     
	],'select': {'style': 'multi'},
 		'drawCallback': function (settings) {
				// Remove previous binding before adding it
				$('.dtMoveUp').unbind('click');
				$('.dtMoveDown').unbind('click');
				// Bind clicks to functions
				$('.dtMoveUp').click(moveUp);
				$('.dtMoveDown').click(moveDown);
			} 
});

	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '80px');
	table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
    $(window).trigger('resize'); 
    
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
}


/* ********************************************************
 * 월
 ******************************************************** */
function fn_makeMonth(){
	var month = "";
	var monthHtml ="";
	
	monthHtml += '<select class="form-control" name="exe_month" id="exe_month">';	
	for(var i=1; i<=12; i++){
		if(i >= 0 && i<10){
			month = "0" + i;
		}else{
			month = i;
		}
		monthHtml += '<option value="'+month+'">'+month+'</option>';
	}
	monthHtml += '</select> <spring:message code="schedule.month" />&emsp;';	
	$( "#month" ).append(monthHtml);
}


/* ********************************************************
 * 일
 ******************************************************** */
function fn_makeDay(){
	var day = "";
	var dayHtml ="";
	
	dayHtml += '<select class="form-control" name="exe_day" id="exe_day">';	
	for(var i=1; i<=31; i++){
		if(i >= 0 && i<10){
			day = "0" + i;
		}else{
			day = i;
		}
		dayHtml += '<option value="'+day+'">'+day+'</option>';
	}
		dayHtml += '</select> <spring:message code="schedule.day" />&emsp;';	
	$( "#day" ).append(dayHtml);
}



/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control" name="exe_h" id="exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />&emsp;';	
	$( "#hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="form-control" name="exe_m" id="exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />&emsp;';	
	$( "#min" ).append(minHtml);
}

/* ********************************************************
 * 초
 ******************************************************** */
 function fn_makeSec(){
	var sec = "";
	var secHtml ="";
	
	secHtml += '<select class="form-control" name="exe_s" id="exe_s">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			sec = "0" + i;
		}else{
			sec = i;
		}
		secHtml += '<option value="'+sec+'">'+sec+'</option>';
	}
	secHtml += '</select> <spring:message code="schedule.second" />&emsp;';	
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
	fn_insDateCalenderSetting();

	
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
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {
			if(result[0].exe_perd_cd == "TC001602"){
				$("#weekDay").show();				
				if(result[0].exe_dt.length ==7){
					for(var i=0; i<result[0].exe_dt.length; i++){
						if(result[0].exe_dt[i] == 1){
							document.getElementById('chk'+i).checked = true;
						}
					}					
				}				
			}else if(result[0].exe_perd_cd == "TC001603"){
				$("#day").show();
			}else if(result[0].exe_perd_cd == "TC001604"){
				$("#day").show();
				$("#month").show();
			}else if(result[0].exe_perd_cd == "TC001605"){
				$("#calendar").show();
			}
			
			document.getElementById('scd_id').value= result[0].scd_id;
			document.getElementById('scd_nm').value= result[0].scd_nm;
			document.getElementById('scd_exp').value= result[0].scd_exp;				
			document.getElementById('exe_perd_cd').value= result[0].exe_perd_cd;
			//document.getElementById('weekDay').value= result[0].exe_dt==null?'':result[0].exe_dt;
			document.getElementById('datepicker1').value= result[0].exe_dt==null?'':result[0].exe_dt;	
			document.getElementById('exe_month').value= result[0].exe_month;
			document.getElementById('exe_day').value= result[0].exe_day;
 			document.getElementById('exe_h').value= result[0].exe_hms.substring(4, 6);
			document.getElementById('exe_m').value= result[0].exe_hms.substring(2, 4);
			document.getElementById('exe_s').value= result[0].exe_hms.substring(0, 2);
			
			table.clear().draw();
			table.rows.add(result).draw();
			
			/* var rowList = [];
		    for (var i = 0; i <result.length; i++) {
		        rowList.push(result[i].wrk_id);   
		  	}		
		    fn_exe_pred(result[0].exe_dt, result[0].exe_month, result[0].exe_day); 
		    fn_workAddCallback(JSON.stringify(rowList)); */
		}
	}); 
	
});

/* ********************************************************
 * 작업기간 calender 셋팅
 ******************************************************** */
function fn_insDateCalenderSetting() {
	var today = new Date();
	var startDay = fn_dateParse("20180101");
	var endDay = fn_dateParse("20991231");
	
	var day_today = today.toJSON().slice(0,10);
	var day_start = startDay.toJSON().slice(0,10);
	var day_end = endDay.toJSON().slice(0,10);

	if ($("#ins_expr_dt_div").length) {
		$("#ins_expr_dt_div").datepicker({
		}).datepicker('setDate', day_today)
		.datepicker('setStartDate', day_start)
		.datepicker('setEndDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		}); //값 셋팅
	}

	$("#datepicker1").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
	$("#ins_expr_dt_div").datepicker('updateDates');
}

function fn_db2pgWorkAddCallback(rowList){
	
	var tCnt = table.rows().data().length;
	
	$.ajax({
		url : "/selectDb2pgScheduleWorkList.do",
		data : {
			work_id : rowList,
			tCnt : tCnt
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
			table.rows({selected: true}).deselect();
			//table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}

/* ********************************************************
 * DB2PG work등록 팝업창 호출
 ******************************************************** */
function fn_db2pgAdd(){
	var cnt=0;
	
	/* if(table.rows().data().length > 0){
		for (var i = 0; i < table.rows().data().length; i++) {		
			if(table.rows().data()[i].bsn_dscd_nm=="백업" || table.rows().data()[i].bsn_dscd_nm=="스크립트"){
				cnt ++;
			}	
	  	}
		
		if(cnt >0){
			showSwalIcon('스케줄에 백업 및 스크립트가 포함되어 있습니다.', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
	} */
	
	$('#pop_layer_db2pg_reg').modal("show");
}	
	

/* ********************************************************
 * work등록 팝업창 호출
 ******************************************************** */
function fn_workAdd(){
	
	var cnt =0;
	
	if(table.rows().data().length > 0){
		var wrk_id_list = [];
		for (var i = 0; i < table.rows().data().length; i++) {
			
			if(table.rows().data()[i].bsn_dscd_nm=="MIGRATION"){
				cnt ++;
			}
			
			wrk_id_list.push( table.rows().data()[i].wrk_id);   
	  	}
//  스케줄 등록시 migration, 배치설정  같이 등록 되게끔
// 		if(cnt >0){
// 			showSwalIcon('스케줄에 MIGRATION이 포함되어 있습니다.', '<spring:message code="common.close" />', '', 'error');
// 			return false;
// 		}
		
		$('#pop_layer_scd_reg').modal("show");
	}else{
		$('#pop_layer_scd_reg').modal("show");
	}
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



/* ********************************************************
 * 실행주기 변경시 이벤트 호출
 ******************************************************** */
function fn_workAddCallback(rowList){
	
	var tCnt = table.rows().data().length;
	
	$.ajax({
		url : "/selectScheduleWorkList.do",
		data : {
			work_id : rowList,
			tCnt : tCnt
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
			table.rows({selected: true}).deselect();
			//table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}



function fn_scheduleStop(){
	confile_title = 'SCHEDULE' + " " + '<spring:message code="common.modify" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("stop");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="message.msg133" />');
	$('#pop_confirm_multi_md').modal("show");
}


function fn_scheduleStop2(){
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
    				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
    			} else if(xhr.status == 403) {
    				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
    			} else {
    				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
    			}
    		},
    		success : function(result) {
    			fn_updateSchedule();
    		}
    	});    
}


function fn_updateSchedule(){
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
		//현재날짜와 비교하여 이전이면 등록 불가
		var exe_dt = $("#datepicker1").val().replace(/-/gi,'').trim();
		if (!fn_dateValidation(exe_dt)) return false;
	}	
	
	var datas = table.rows().data();

	if(datas.length < 1){
		showSwalIcon('<spring:message code="message.msg39" />', '<spring:message code="common.close" />', '', 'error');
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

		$.ajax({
			url : "/updateSchedule.do",
			data : {
				scd_id : scd_id,
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
				confile_title = '<spring:message code="menu.schedule" /> <spring:message code="schedule.run" />' + " " + '<spring:message code="common.request" />';
				$('#con_multi_gbn', '#findConfirmMulti').val("mod");
				$('#confirm_multi_tlt_01').html(confile_title);
				$('#confirm_multi_msg_01').html('<spring:message code="message.msg135" />');
				$('#pop_confirm_multi_md_01').modal("show");
			}
		}); 	
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "mod") {
		fn_scheduleReStart();
	}else if(gbn == "stop"){
		fn_scheduleStop2();
	}
}

function fn_scheduleReStart(){
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
	
	var scd_id= $("#scd_id").val();
	var exe_perd_cd =  $("#exe_perd_cd").val();
	var exe_month =  $("#exe_month").val()=='undefined'?'':$('#exe_month').val();
	var exe_day =  $("#exe_day").val()=='undefined'?'':$('#exe_day').val();
	var exe_hms = $("#exe_s").val()+$("#exe_m").val()+$("#exe_h").val();

 	$.ajax({
		url : "/scheduleReStart.do",
		data : {
			scd_id : scd_id,
			exe_perd_cd : exe_perd_cd,
			exe_dt : exe_dt,
			exe_month : exe_month,
			exe_day : exe_day,
			exe_hms : exe_hms
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
			location.href='/selectScheduleListView.do' ;
		}
	});    
}

// 스케줄 등록시  현재 날짜 이전의 날짜를 등록할수 없도록 하는 함수
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
		 showSwalIcon('<spring:message code="message.msg213" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	 return true;
} 
</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>

<%@include file="./../../popup/scheduleRegForm.jsp"%>
<%@include file="./../../popup/db2pgWorkRegForm.jsp"%>

<input type="hidden" id="scd_id" name="scd_id">

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
												<i class="ti-calendar menu-icon"></i>
												<span class="menu-title"><spring:message code="schedule.scheduleMod"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">SCHEDULE</li>
											<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.schedule_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="schedule.scheduleMod"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="message.msg172"/></p>
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

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onClick="fn_scheduleStop();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="button.modify" />
								</button>
							</div>
						</div>
					</div>
					<div class="card my-sm-2">
						<div class="card-body">
							<div class="form-group row" style="margin-bottom:-10px;">
								<label for="ins_dept_nm" class="col-sm-1_6 col-form-label pop-label-index">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.schedule_name" />
								</label>
								<div class="col-sm-4">
									<input type="text" class="form-control" maxlength="20" id="scd_nm" name="scd_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="20<spring:message code='message.msg188'/>"/>
								</div>
<!-- 								<div class="col-sm-1_5"> -->
<%-- 									<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onclick="fn_check();" value='<spring:message code="common.overlap_check" />' /> --%>
<!-- 								</div> -->
							</div>
							<div class="form-group row" style="margin-bottom:-10px;">
								<label for="ins_pst_nm" class="col-sm-1_6 col-form-label pop-label-index">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.scheduleExp" />
								</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" maxlength="150" id="scd_exp" name="scd_exp" onkeyup="fn_checkWord(this,150)" onblur="this.value=this.value.trim()" placeholder="150<spring:message code='message.msg188'/>"/>
								</div>
							</div>
							<div class="form-group row" style="margin-bottom:-10px;">
								<label for="ins_pst_nm" class="col-sm-1_6 col-form-label pop-label-index">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.schedule_time_settings" />
								</label>
								<div class="col-sm-2">
									<select class="form-control" name="exe_perd_cd" id="exe_perd_cd" onChange="fn_exe_pred();">
										<option value="TC001601"><spring:message code="schedule.everyday" /></option>
										<option value="TC001602"><spring:message code="schedule.everyweek" /></option>
										<option value="TC001603"><spring:message code="schedule.everymonth" /></option>
										<option value="TC001604"><spring:message code="schedule.everyyear" /></option>
										<option value="TC001605"><spring:message code="schedule.one_time_run" /></option>
									</select>
								</div>		
								
								<div class="col-sm-8 form-inline">	
									<div id="weekDay" class="form-inline">
										<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk0" name="chk" value="0"><spring:message code="schedule.sunday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk1" name="chk" value="0"><spring:message code="schedule.monday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk2" name="chk" value="0"><spring:message code="schedule.thuesday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk3" name="chk" value="0"><spring:message code="schedule.wednesday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk4" name="chk" value="0"><spring:message code="schedule.thursday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk5" name="chk" value="0"><spring:message code="schedule.friday" />&emsp;
				                            </label>
		                          		</div>
		                          		<div class="form-check form-check-primary">
				                            <label class="form-check-label">
				                              <input type="checkbox" class="form-check-input" id="chk6" name="chk" value="0"><spring:message code="schedule.saturday" />&emsp;
				                            </label>
		                          		</div>
		                          	</div>
									<div class="col-sm-3"  id="calendar" style="margin-top:-15px;">
										<div id="ins_usr_expr_dt_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" id="datepicker1" name="exe_dt"  tabindex=10 />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
									<div id="month" style="margin-top:-15px;"></div>
									<div id="day" style="margin-top:-15px;"></div>
									<div id="hour" style="margin-top:-15px;"></div>
									<div id="min" style="margin-top:-15px;"></div>
									<div id="sec" style="margin-top:-15px;"></div>
								</div>
							</div>
							
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-12">
									<div class="template-demo">			
										<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="del_button" onClick="fn_workDel();" >
											<i class="ti-minus btn-icon-prepend "></i><spring:message code="common.delete" />
										</button>
										<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="add_button" onClick="fn_workAdd();" data-toggle="modal">
											<i class="ti-plus btn-icon-prepend "></i><spring:message code="common.add" />
										</button>
										<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="db2pg_button" onClick="fn_db2pgAdd();" data-toggle="modal">
											<i class="ti-server btn-icon-prepend "></i>MIGRATION
										</button>
									</div>
								</div>
							</div>
						
							<div class="card my-sm-2" >
								<div class="card-body" >
									<div class="row">
										<div class="col-12">
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
		
			 								<table id="workList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
												<thead>
		 											<tr class="bg-info text-white">
														<th width="10"></th>
														<th width="30"><spring:message code="common.no" /></th>			
														<th width="200" class="dt-center"><spring:message code="common.work_name" /> </th>
														<th width="300" class="dt-center"><spring:message code="common.work_description" /></th>																							
														<th width="130"><spring:message code="common.dbms_name" /></th>
														<th width="70"><spring:message code="common.division" /></th>
														<th width="130"><spring:message code="backup_management.detail_div" /></th>										
														<th width="80"><spring:message code="data_transfer.run_order" /></th>
														<th width="80">OnError</th>
														<th width="0"></th>
													</tr>
												</thead>
											</table>
									 	</div>
								 	</div>
								</div>
							</div>
						</div>
					<!-- content-wrapper ends -->
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>