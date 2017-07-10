<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
var table = null;
	
function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "245px",
	processing : true,
	searching : false,		
	columns : [
	{data:"index", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]], className : "dt-center", defaultContent : ""},
	{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false },
	{data : "db_svr_nm", className : "dt-center", defaultContent : ""}, //서버명
	{data : "bck_bsn_dscd_nm", className : "dt-center", defaultContent : ""}, //구분
	{data : "wrk_nm", className : "dt-center", defaultContent : ""}, //work명
	{data : "wrk_exp", className : "dt-center", defaultContent : ""}, //work설명
	{className: "dt-center",
			data: null,			
			title: '실행순서',
			searchable: false,
			sortable: false,					
			defaultContent : "",
			render: function (data, type, full, meta,row) {
				if (type === 'display') {
					var $exe_order = $('<div class="order_exc">');
					$('<a class="dtMoveUp"><img src="../images/ico_order_up.png" alt="" /></a>').appendTo($exe_order);					
					$('<a class="dtMoveDown"><img src="../images/ico_order_down.png" alt="" /></a>').appendTo($exe_order);																												
					$('</div>').appendTo($exe_order);
					return $exe_order.html();
				}
				return data;
			}
	},
	{data: null,  	 		     
        	render: function (data, type, full, meta){
        		var onError ='<select  id="exe_rslt_cd" name="exe_rslt_cd">';
        		onError +='<option value="y">Y</option>';
        		onError +='<option value="n">N</option>';
        		onError +='</select>';
        		return onError;
          		},
          	className: "dt-center",
          	orderable: false, 
          	defaultContent: ""},
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
    	table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
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

	//여기서부터 다시진행
    var data1 = table.row(index).data();
	alert(JSON.stringify(data1));
	
    data1.rownum += rownum;

    var data2 = table.row(index + rownum).data();
    data2.rownum += -rownum;

    table.row(index).data(data2);
    table.row(index + rownum).data(data1);
    table.draw(false);
	}
}

/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="" id="">';	
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
	
	minHtml += '<select class="select t7" name="" id="">';	
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
	
	secHtml += '<select class="select t7" name="" id="">';	
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
	
	$("#calendar").hide();
	
	fn_makeHour();
	fn_makeMin();
	fn_makeSec();
	
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
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
	
	window.open(popUrl,"",popOption);

}

/* ********************************************************
 * 실행주기 변경시 이벤트 호출
 ******************************************************** */
function fn_exe_pred(){
	var exe_perd_cd = $("#exe_perd_cd").val();
	
	if(exe_perd_cd == "TC001605"){
		$("#calendar").show();
	}else{
		$("#calendar").hide();
	}
}


function fn_workAddCallback(rowList){
	table.clear().draw();
	table.rows.add(result).draw();
}
</script>

<!-- contents -->
			<div id="contents">
				<div class="location">
					<ul>
						<li>My Page</li>
						<li class="on">스케쥴 등록</li>
					</ul>
				</div>

				<div class="contents_wrap">
					<h4>스케쥴 리스트화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button>등록</button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col style="width:240px;" />
										<col style="width:60px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t9 line">스케줄명</th>
											<td><input type="text" class="txt t2"/></td>
											<th scope="row" class="t9">설명</th>
											<td><input type="text" class="txt t2"/></td>
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
																							
													<span id="calendar">		
													<div class="calendar_area" >													
															<a href="#n" class="calendar_btn">달력열기</a>
															<input type="text" class="calendar" id="datepicker1" title="스케줄시간설정" readonly />												
													</div>	
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
										<a href="#n" class="btn btnF_04"><span>삭제</span></a>
									</div>
								</div>
								<div class="overflow_area">
								<table id="workList" class="cell-border display" >
		
									<thead>
										<tr>
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
			</div><!-- // contents -->