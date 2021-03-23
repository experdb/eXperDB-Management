<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>


<%
	/**
	* @Class Name : backupSeetting.jsp
	* @Description : 백업설정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-01-21	변승우 책임매니저		최초 생성
	*  2021-01-28	신예은 매니저		화면 구성
	*
	*
	* author 변승우 책임매니저
	* since 2021.01.21
	*
	*/
%>

<script>
var NodeList;
var scheduleList;
var schSun=[];
var schMon=[];
var schTue=[];
var schWed=[];
var schThu=[];
var schFri=[];
var schSat=[];
var schWeek = [];

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	// get server information
	fn_init();
	dateCalenderSetting();
	fn_getSvrList();
	// fn_getNodeList();
	schWeek = [schSun,schMon,schTue,schWed,schThu,schFri,schSat];
});

function fn_init() {
	
	/* ********************************************************
	 * 노트리스트 테이블
	 ******************************************************** */
	 NodeList = $('#nodeList').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		select : {
			'style' : 'single'
		},
		bSort : false,
		columns : [
		{data : "masterGbn", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				if(data == "M"){
					data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 30px;"><b>Primary</b></div>'
				}else if(data == "S"){
					data = '<i class="mdi mdi-subdirectory-arrow-right" style="margin-left: 50px;"><div class="badge badge-pill badge-outline-warning" title="" style="margin-left: 10px"><b>Standby</b></div>'
				}
				return data;
			}},
		{data : "hostName", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				data = '<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">'+data+'</h5>';
				return data;
			}
		},
		{data : "ipadr", className : "dt-center", defaultContent : ""}
		
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false}, */
		], /* select: {'style' : 'single'} */
	});

	 NodeList.tables().header().to$().find('th:eq(1)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(2)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(3)').css('min-width');
	 
	 NodeList.on('select', function(e, dt, type, indexes){
		var nodeIpadr = NodeList.row(indexes).data().ipadr
		NodeList.clear();
		// fn_scheduleReset(ipadr);
		fn_getScheduleInfo(nodeIpadr);
	 });
	 scheduleList = $('#scheduleList').DataTable({
		scrollY : "140px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		select : {'items' : 'cell', 'style' : 'single'},
		bSort : false,
		"language" : {
			"emptyTable" : " "
		} ,
		columns : [
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""},
			{className : "dt-center", defaultContent : ""}
		], 
		
	});
	 
    $(window).trigger('resize'); 
	
} // fn_init();

function dateCalenderSetting() {
		
	var today = new Date();
	var startDay = today.toJSON().slice(0,10);
	var endDay = fn_dateParse("20991231").toJSON().slice(0, 10);
	
	/* console.log("today : " + today);
	console.log("startDay : " + startDay);
	console.log("endDay : " + endDay); */

	$("#startDate").val(startDay);
	

	$("#startDate").datepicker({
		}).datepicker('setDate', startDay)
		.datepicker('setStartDate', startDay)
		.datepicker('setEndDate', endDay)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		}); //값 셋팅

	
	$("#startDate").datepicker('setStartDate', startDay).datepicker('setEndDate', endDay);
	// $("#startDate_div").datepicker('updateDates');
	
}

function fn_scheduleReset(ipadr){
	schSun=[];
	schMon=[];
	schTue=[];
	schWed=[];
	schThu=[];
	schFri=[];
	schSat=[];

	// fn_drawScheduleList();
	// fn_getScheduleInfo(ipadr);
}

/* ********************************************************
 * 서버 리스트 가져오기
 ******************************************************** */
function fn_getSvrList() {
	$.ajax({
		url : "/experdb/backupNodeList.do",
		data : {
			
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
		success : function(data) {
			NodeList.clear().draw();
			NodeList.rows.add(data).draw();
			
		}
	});
}

/* ********************************************************
 * get schedule data
 ******************************************************** */
 function fn_getScheduleInfo(ipadr){
	console.log("NodeList CLICK	!! : " + ipadr);
	$.ajax({
		url : "/experdb/getScheduleInfo.do",
		data : {
			ipadr : ipadr
		},
		type : "post"
	})
	.done(function(result){
		console.log("get schedule 성공!! " + result);
		console.log("RESULT_CODE : " + result.RESULT_CODE);
		if(result.RESULT_CODE == "0"){
			console.log("성공 : " + result.startDate);
			fn_setScheduleInfo(result);
		}else{
			console.log("실패 : " + result.startDate);
		}
	})
	.fail(function(xhr, status, error){

	})
	.always(function(){

	})
}


function fn_setScheduleInfo(result){
	console.log("=========== fn_setScheduleInfo =============");

	var scheduleData = [];
	console.log("startDate : " + result.startDate);
	console.log("storageType : " + result.storageType);
	console.log("storage : " + result.storage);
	console.log("compress : " + result.compress);
	console.log("dateType : " + result.dateType);
	console.log("date : " + result.date);
	console.log("setNum : " + result.setNum);
	console.log("weekData : " + result.weekData.length);
	console.log("==============================================");

	scheduleData = result.weekData;
	
	console.log("===============@@@@@@@@@@@@=================");
	for(var i=0 ; i<scheduleData.length; i++){
		console.log("#" + i + "# : " + scheduleData[i].startTime);
		console.log("#" + i + "# : " + scheduleData[i].repeat);
		console.log("#" + i + "# : " + scheduleData[i].repEndTime);
		console.log("#" + i + "# : " + scheduleData[i].repTime);
		console.log("#" + i + "# : " + scheduleData[i].repTimeUnit);
		console.log("#" + i + "# : " + scheduleData[i].dayPick);
		console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		fn_scheduleInsert(scheduleData[i].dayPick, scheduleData[i].startTime, scheduleData[i].repeat, scheduleData[i].repEndTime, scheduleData[i].repTime, scheduleData[i].repTimeUnit);
		
	}
	fn_drawScheduleList();

}
 

/* ********************************************************
 * node registration popoup
 ******************************************************** */
function fn_nodeRegPopup() {
	$.ajax({
		url : "/experdb/backupUnregNodeList.do",
		type : "post",
		beforeSend : function(xhr) {
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
		success : function(result){
			fn_nodeRegReset();
			fn_setIpadrList(result);
			$("#pop_layer_popup_backupNodeReg").modal("show");
		}
	})
}

/* ********************************************************
 * node update popup
 ******************************************************** */
 function fn_nodeModiPopup() {
	$.ajax({
		url : "/experdb/backupNodeInfo.do",
		type : "post",
		data : {
			path : NodeList.row('.selected').data().ipadr
		}
	})
	.done (function(result){
		fn_nodeModiReset(result);
		$("#pop_layer_popup_backupNodeReg").modal("show");
	})
	.fail (function(xhr, status, error){
		if(xhr.status == 401) {
			showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else if(xhr.status == 403) {
			showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else {
			showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
		}
	})
	
}

 /* ********************************************************
  * node delete popup
  ******************************************************** */
  function fn_nodeDelPopup(){
	var data = NodeList.rows('.selected').data();
	if(data.length < 1){
		showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		confile_title = '노드 ' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("node_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}
  }


  function fn_nodeDelete(){
	$.ajax({
		url : "/experdb/backupNodeDel.do",
		type : "post",
		data : {
			ipadr : NodeList.row('.selected').data().ipadr
		}
	})
	.done(function(result){
		if(result.RESULT_CODE == "0"){
			showSwalIconRst('<spring:message code="message.msg12" />', '<spring:message code="common.close" />', '', 'success');
		}else {
			showSwalIcon("ERROR : " + result.RESULT_DATA ,'<spring:message code="common.close" />', '', 'error');
		}
	})
	.fail (function(xhr, status, error){
		if(xhr.status == 401) {
			showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else if(xhr.status == 403) {
			showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else {
			showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
		}
	})
	.always(function(){
		fn_getSvrList();
	})
  }
 
  function fnc_confirmMultiRst(gbn){
	  if(gbn == "node_del"){
		  fn_nodeDelete();
	  }
  }
 
/* ********************************************************
 * 백업정책 등록 팝업창 호출
 ******************************************************** */
	
	function fn_policyRegPopoup() {
		$.ajax({
			url : "/experdb/backupStorageList.do",
			type : "post"
		})
		.done (function(result){			
			fn_policyRegReset(result);
			$("#pop_layer_popup_backupPolicyReg").modal("show");
		})
		.fail (function(xhr, status, error){
			 if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if (xhr.status == 403){
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		 })
	}
/* ********************************************************
 * schedule registration
 ******************************************************** */

	function fn_scheduleRegPopoup() {
		fn_scheduleRegReset();
		$("#pop_layer_popup_backupSchedule").modal("show");
	}
	
	// schedule Insert per day
	function fn_scheduleInsert(dayPick, startTime, repCheck, repEndTime, repTime, repTimeUnit) {
		var schData = new Object();
		
		schData.st = startTime;
		schData.rc = repCheck;
		if(repCheck){
			schData.rt = repTime;
			schData.ret = repEndTime;
			schData.rtu = repTimeUnit;
			if(repTimeUnit == 0){
				schData.repeat = "<b>" + startTime + " ~ " + repEndTime +"</b><br>"+ repTime +"분 간격";
			}else{
				schData.repeat = "<b>" + startTime + " ~ " + repEndTime +"</b><br>"+ repTime +"시간 간격";
			}
		}else{
			schData.rt = "";
			schData.ret = "";
			schData.rtu = "";
			schData.repeat = "<b>" + startTime + "</b>";
		}

		for(var i =0; i<7; i++){
			if(dayPick[i] == true){
				console.log("schData : " + JSON.stringify(schData));
				schWeek[i].push(schData);
				console.log("schWeek insert print : " + JSON.stringify(schWeek[i]));
			}
			schWeek[i].sort(compareTime);
		}
		
		// fn_drawScheduleList();
	}
	
	// schedule sort by startTime
	function compareTime(a, b){
        if(a.st < b.st){
                return -1;
        }else if(a.st > b.st){
                return 1;
        }else{
                return 0;
        }
	}

	function fn_drawScheduleList(){
		var dayLength = [schSun.length, schMon.length, schTue.length, schWed.length, schThu.length, schFri.length, schSat.length];
		var max = Math.max.apply(null, dayLength);
		
		scheduleList.clear().draw();
		
		for(var i=0;i<max;i++){
			var schRow = [schSun[i],schMon[i],schTue[i],schWed[i],schThu[i],schFri[i],schSat[i]];
			var viewRow = [];
			for(var j=0;j<7;j++){
				if(i<dayLength[j]){
					viewRow[j] = schRow[j].repeat;
				}else{
					viewRow[j]="";
				}
			}
			scheduleList.row.add(viewRow).draw();
		}

	}


	function fn_scheduleDel(){
		var rowIndex = scheduleList.cell('.selected').index().row;
		var dayIndex = scheduleList.cell('.selected').index().column;
		schWeek[dayIndex].splice(rowIndex, 1);
		fn_drawScheduleList();
	}
	
/* ********************************************************
 * apply
 ******************************************************** */
	
	function fn_apply() {
		console.log("fn_apply called!!");
		if(fn_applyValidation()){
			var weekData = new Object();
			weekData.mon = schMon;
			weekData.tue = schTue;
			weekData.wed = schWed;
			weekData.thu = schThu;
			weekData.fri = schFri;
			weekData.sat = schSat;
			weekData.sun = schSun;
			console.log("nodeIpadr : " + NodeList.row('.selected').data().ipadr);
			console.log("storageType : " + $("#bckStorageTypeVal").val());
			console.log("compress : " + $("#bckCompressVal").val());
			console.log("dateType : " + $("#bckSetDateTypeVal").val());
			console.log("date : " + $("#bckSetDateVal").val());

			$.ajax({
				url : "/experdb/backupScheduleReg.do",
				type : "post",
				dataType : "json",
				traditional : true,
				data : {
					nodeIpadr : NodeList.row('.selected').data().ipadr,
					weekData : JSON.stringify(weekData),
					startDate : $("#startDateSch").val(),
					storageType : $("#bckStorageTypeVal").val(),
					storage : $("#bckStorage").val(),
					compress : $("#bckCompressVal").val(),
					dateType : $("#bckSetDateTypeVal").val(),
					date : $("#bckSetDateVal").val(),
					setNum : $("#bckSetNum").val()
				}
			})
			.done (function(result){			
				showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
				location.href="/experdb/backupMonitoring.do";
			})
			.fail (function(xhr, status, error){
				 if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if (xhr.status == 403){
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			 })
		}
		
	}
	
/* ********************************************************
 * apply validation
 ******************************************************** */
 	function fn_applyValidation(){
 		var data = NodeList.rows('.selected').data();
		if(data.length<1){
			showSwalIcon('노드를 선택해주세요', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if($("#bckStorage").val() == "" || $("#bckStorage").val() == null){
			showSwalIcon('백업 정책을 등록해주세요', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		return true;
	}
 

</script>
<style>
table.dataTable.nonborder tbody td{border-top:1px solid rgb(255, 255, 255);}
table.dataTable.ccc tbody td.selected {
	background-color: #7bb8fd
}
table.dataTable.ccc tfoot th{
	border-top:1px solid rgb(255, 255, 255);
}
table.dataTable.ccc thead th{
	border-bottom : 1px solid rgb(168, 168, 168);
}
</style>
<%@include file="./../popup/confirmMultiForm.jsp"%>

<%@include file="./popup/bckNodeRegForm.jsp"%>
<%@include file="./popup/bckPolicyRegForm.jsp"%>
<%@include file="./popup/bckScheduleRegForm.jsp"%>

<form name="storeInfo">
	<input type="hidden" name="bckStorageTypeVal"  id="bckStorageTypeVal">
	<input type="hidden" name="bckStorageVal"  id="bckStorageVal" >
	<input type="hidden" name="bckCompressVal"  id="bckCompressVal" >
	<input type="text" name="bckSetDateTypeVal"  id="bckSetDateTypeVal" hidden>
	<input type="hidden" name="bckSetDateVal" id="bckSetDateVal">
</form>
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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title">백업설정</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BACKUP</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">백업관리</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">백업설정</li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.dbms_registration_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_registration_02" /></p>
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
		<div class="col-12 grid-margin stretch-card" style="margin-bottom: 0px;">
			<div class="card-body" style="padding-bottom:0px; padding-top: 0px;">
				<div class="table-responsive" style="overflow:hidden;">
					<div id="wrt_button" style="float: right;">
						<button type="button" class="btn btn-success btn-icon-text mb-2" onclick="fn_apply()">
							<i class="fa fa-check btn-icon-prepend "></i>적용
						</button>
						
					</div>
				</div>
			</div>
		</div>
		<!-- node list -->
		<div class="col-lg-5 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeRegPopup()">
								등록
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeModiPopup()">
								수정
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeDelPopup()">
								삭제
							</button>
						</div>
						<h4 class="card-title">
							<i class="item-icon fa fa-desktop"></i>  Node List
						</h4>
						<table id="nodeList" class="table nonborder table-hover system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100">서버유형</th>
									<th width="130">호스트명</th>
									<th width="100">아이피</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- node list end-->
		<div class="col-lg-7 grid-margin stretch-card">
			<div class="card"  style="padding-left: 0px;">
				<div class="card-body" style="padding-bottom: 0px;">
					<!-- <div class="row" style="margin-top:-20px;"  id="schedule_button">
						<div class="col-12" style="margin-top: 10px;">
							<div class="sch_button" style="float: right">
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_scheduleRegPopoup()">
									등록
								</button>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="">
									삭제
								</button>
							</div>
						</div>
					</div> -->
					<div class="card my-sm-2" style="" >
						<div class="card-body" style="height: 240px;padding-top: 5px;">
							<div class="col-12" id="jobDiv" >
								<div class="form-group row" style="margin-bottom: 0px; padding-left: 10px;">
									<div class="col-8 row" style="margin-top: 10px;">
										<div  class="col-4 col-form-label pop-label-index" style="font-size:1em; padding-top:7px;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											Start Date
										</div>
										<div class="col-sm-3" style="padding-left: 0px;">
											<div class="input-group " id="startDate_div" style="width: 120px;">
												<input type="text" class="form-control" style=" background-color : white; width:70px;height:30px;" id="startDateSch" name="startDateSch" readonly/>
											</div> 
										</div>
									</div>
									<div class="col-4" style="margin-top: 10px;">
										<div class="sch_button" style="float: right">
											<button type="button" class="btn btn-rounded btn-sm btn-inverse-primary" onClick="fn_scheduleRegPopoup()">
												<i class="ti-plus"></i>
											</button>
											<button type="button" class="btn btn-rounded btn-inverse-danger btn-sm" onClick="fn_scheduleDel()">
												<i class="ti-minus"></i>
											</button>
										</div>
									</div>
								</div>
								<div class="col-12 row" id="scheduleDiv" >	
									<table id="scheduleList" class="table table-hover ccc" style="width:900px;">
										<thead>
											<tr>
												<th width="80px" class="text-center text-danger"><spring:message code="common.sun" /></th>
												<th width="80px" class="text-center"><spring:message code="common.mon" /></th>												
												<th width="80px" class="text-center"><spring:message code="common.tue" /></th>
												<th width="80px" class="text-center"><spring:message code="common.wed" /></th>
												<th width="80px" class="text-center"><spring:message code="common.thu" /></th>
												<th width="80px" class="text-center"><spring:message code="common.fri" /></th>												
												<th width="80px" class="text-center text-primary"><spring:message code="common.sat" /></th>
											</tr>
										</thead>
									</table>
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card-body" style="padding-top: 0px;">	
					 <div class="row" style="margin-top:-20px;"  id="schedule_button">
						<div class="col-12" style="margin-top: 10px;">
							<div class="wrt_button" style="float: right">
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_policyRegPopoup()">
								 	등록
								</button>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="">
									수정
								</button>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="">
									삭제
								</button>
							</div>
						</div>
					</div>				 	
					<div class="card my-sm-2" style="" >
						<div class="card-body" >
							<div class="col-12" id="jobDiv" >	
								<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										백업 스토리지
									</div>
									<div class="col-2" style="padding-left: 0px;">
										<input type="text" id="bckStorageType" name = "bckStorageType" class="form-control form-control-sm"  style="height: 40px; background-color:#ffffffdd;" readonly/>
									</div>
									<div class="col-4" style="padding-left: 0px;">
										<input type="text" id="bckStorage" name = "bckStorage" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
									</div>
								</div>
								<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										압축
									</div>
									<div class="col-4" style="padding-left: 0px;">
										<input type="text" id="bckCompress" name="bckCompress" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
									</div>
								</div>		
								<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Full 백업 수행일
									</div>
									<div class="col-sm-2_5" style="margin-left: 0px;padding-left: 0px;">
										<input type="text" style="width:150px; height:40px; background-color:#ffffffdd;" class="form-control form-control-sm" name="bckSetDate" id="bckSetDate" readonly/>
									</div>
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Full 백업 보관 셋
									</div>
									<div class="col-sm-2_5" style="margin-left: 0px">
										<input type="number" min="1" max="10000" style="width:150px; height:40px; background-color:#ffffffdd;" class="form-control form-control-sm" name="bckSetNum" id="bckSetNum" readonly/>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>