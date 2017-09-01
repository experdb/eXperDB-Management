<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
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
	columns : [
	{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
	{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]], className : "dt-center", defaultContent : ""},
	{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false },
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
          }
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
 * work등록 팝업창 호출
 ******************************************************** */
function fn_workAdd(){
	var popUrl = "/popup/scheduleRegForm.do"; 
	var width = 1220;
	var height = 800;
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
		var exe_dt = $("#datepicker1").val().replace(/-/gi,'').trim();
	}	
	
	var datas = table.rows().data();

	if(datas.length < 1){
		alert("WORK 정보가 존재 하지않습니다.");
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
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				if(confirm("수정되었습니다. 스케줄 실행 하시겠습니까?")){
					fn_scheduleReStart();
				}else{
				}
			}
		}); 	
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
	
	var row = new Object();
	
    row.scd_id= scd_id;
    row.exe_perd_cd =  $("#exe_perd_cd").val();
    row.exe_dt = exe_dt;
    row.exe_month =  $("#exe_month").val();
    row.exe_day =  $("#exe_day").val();
    row.exe_hms = $("#exe_s").val()+$("#exe_m").val()+$("#exe_h").val();
  
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
			location.href='/selectScheduleListView.do' ;
		}
	});    
}

</script>

			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>스케줄 등록수정 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>Function</li>
								<li>Scheduler</li>
								<li class="on">스케줄수정</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button onClick="fn_scheduleStop();">수정</button></span>
							</div>
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
											<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm"/></td>
										</tr>
										<tr>
											<th scope="row" class="t9 line">설명</th>
											<td>
												<textarea class="tbd1" name="scd_exp" id="scd_exp"></textarea>
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
														<select class="select t5" name="exe_perd_cd" id="exe_perd_cd" onChange="fn_exe_pred();">
															<option value="TC001601">매일</option>
															<option value="TC001602">매주</option>
															<option value="TC001603">매월</option>
															<option value="TC001604">매년</option>
															<option value="TC001605">1회실행</option>
														</select>
													</span>
													<span id="weekDay" >
							                            <input type="checkbox" id="chk0" name="chk" value="0">일요일
							                            <input type="checkbox" id="chk1" name="chk" value="0">월요일
							                            <input type="checkbox" id="chk2" name="chk" value="0">화요일
							                            <input type="checkbox" id="chk3" name="chk" value="0">수요일
							                            <input type="checkbox" id="chk4" name="chk" value="0">목요일
							                            <input type="checkbox" id="chk5" name="chk" value="0">금요일
							                            <input type="checkbox" id="chk6" name="chk" value="0">토요일
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
									<p>Work 등록</p>
									<div class="sub_btn">
										<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_workAdd();"><span>추가</span></a>
										<a href="#n" class="btn btnF_04" onclick="fn_workDel();"><span>삭제</span></a>
									</div>
								</div>
								<div class="overflow_area">							
									<table id="workList" class="cell-border display" >
										<thead>
											<tr>
												<th></th>
												<th>No</th>
												<th></th>
												<th>서버명</th>
												<th>구분</th>
												<th>work명</th>
												<th>Work설명</th>
												<th>실행순서</th>
												<th>OnError</th>
											</tr>
										</thead>
									</table>											
								</div>
							</div>		
						</div>
					</div>
				</div>
			</div>