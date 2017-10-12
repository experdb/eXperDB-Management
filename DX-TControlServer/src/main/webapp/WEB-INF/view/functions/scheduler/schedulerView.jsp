<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script>
var table = null;
var scd_nmChk = "fail";
var db_svr_id = ${db_svr_id};

function fn_validation(){
	var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			   alert("스케줄명을 입력하여 주십시오.");
			   scd_nm.focus();
			   return false;
		}
		if(scd_nmChk == "fail"){
  			"스케줄명 중복체크 하셔야합니다.";
  		}
 		return true;
}

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#bck_scheduleList').DataTable({
	scrollY : "245px",
	scrollX: true,	
	paging : false,
	searching : false,	
	columns : [
	// 일요일
	{data : "scd_nm", 
		render: function (data, type, full){
			var strArr = full.bck_bsn_dscd.split(',');		
			var html = null;
				if(full.exe_dt.substring(0,1)=="1"){			
					if(full.scd_cndt == 'TC001801'){
					    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
					    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
						html +=  full.scd_nm+'</span>';	
					   // html += full.scd_nm;
					}else{
						    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
						}										
					for(var i=0; i<strArr.length; i++){
						if(strArr[i] == "TC000201"){
							html += ' <img src="../images/r.png" id="rman"/>';
							if(full.bck_opt_cd == "TC000301"){
								html += ' <img src="../images/f.png" id="full"/>';
							}else if (full.bck_opt_cd == "TC000302"){
								html += ' <img src="../images/i.png"  id="incremental"/>';
							}else{
								html += ' <img src="../images/a.png" id="archive"/>';
							}
						}else{
							html += ' <img src="../images/d.png" id="dump"/>';
						}	
					}
						return html;
				}else{
					return html;
				}					
			return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 월요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(1,2)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
							}												
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 화요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(2,3)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
							}											
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 수요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(3,4)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
							}												
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 목요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(4,5)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';	
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
							}											
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 금요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(5,6)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';			
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	;	
							}													
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
		
		// 토요일
		{data : "scd_nm", 
			render: function (data, type, full){
				var strArr = full.bck_bsn_dscd.split(',');		
				var html = null;
					if(full.exe_dt.substring(6,7)=="1"){
						if(full.scd_cndt == 'TC001801'){
						    html = '<img src="../images/ico_agent_1.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
						    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
							html +=  full.scd_nm+'</span>';	
							}else{
							    html = '<img src="../images/ico_agent_2.png" alt=""  style="margin-right:10px"  width="10px" height="10px" />';		
							    html +=	'<span onClick=javascript:fn_popup("'+full.scd_id+'");>'+full.exe_hms+ '   ';
								html +=  full.scd_nm+'</span>';	
							}	
						for(var i=0; i<strArr.length; i++){
							if(strArr[i] == "TC000201"){
								html += ' <img src="../images/r.png" id="rman"/>';
								if(full.bck_opt_cd == "TC000301"){
									html += ' <img src="../images/f.png" id="full"/>';
								}else if (full.bck_opt_cd == "TC000302"){
									html += ' <img src="../images/i.png"  id="incremental"/>';
								}else{
									html += ' <img src="../images/a.png" id="archive"/>';
								}
							}else{
								html += ' <img src="../images/d.png" id="dump"/>';
							}	
						}
							return html;
					}else{
						return html;
					}					
				return data;				
			},
			className : "dt-center", defaultContent : "" 	
		},	
	]
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
	var height = 655;
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
});

function fn_selectBckSchedule(){
	$.ajax({
		url : "/selectBckSchedule.do",
		data : {db_svr_id : db_svr_id},
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


/* function fn_insertSchedule(){
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

	if (confirm("스케줄을 등록 하시겠습니까?")){
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
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				alert("스케줄이 등록되었습니다.");
				location.href='/selectScheduleListView.do' ;
			}
		}); 	
	}else{
		return false;
	}
} */


function fn_insertSchedule(){
	var popUrl = "/bckScheduleInsertVeiw.do?db_svr_id="+db_svr_id; // 서버 url 팝업경로
	var width = 1120;
	var height = 425;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
	window.open(popUrl,"",popOption);
}

</script>
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>백업 스케줄 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"  onClick="fn_insertSchedule();" id="int_button"><button>백업 스케줄 등록</button></span>
							</div>
							<div class="cmm_bd">
								<div class="sub_tit">
									<p>스케줄 현황</p>
								</div>
								<div class="overflow_area">							
									<table id="bck_scheduleList" class="cell-border display" width="100%">
										<thead>
											<tr>
												<th width="130">일</th>
												<th width="130">월</th>												
												<th width="130">화</th>
												<th width="130">수</th>
												<th width="130">목</th>
												<th width="130">금</th>												
												<th width="130">토</th>
											</tr>
										</thead>
									</table>											-
								</div>
							</div>		
						</div>
					</div>
				</div>
			</div>