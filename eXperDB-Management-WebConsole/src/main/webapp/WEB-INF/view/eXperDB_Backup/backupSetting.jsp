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
var volumeDataList = [];
var scheduleList;
var schSun=[];
var schMon=[];
var schTue=[];
var schWed=[];
var schThu=[];
var schFri=[];
var schSat=[];
var schWeek = [];
var jobExist=0;
var licenseNum;
var serverNum;

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	// get server information
	fn_init();
	dateCalenderSetting();
	fn_getSvrList();
	schWeek = [schSun,schMon,schTue,schWed,schThu,schFri,schSat];
});

$(window).bind('beforeunload', function (){
	if($("#applyAlert").is(":visible")){
		return false;
	}
});

$(function() {
    $('#nodeList tbody').on( 'click', 'tr', function () {
          if ( $(this).hasClass('selected') ) {
          }
         else {              
            NodeList.$('tr.selected').removeClass('selected');
             $(this).addClass('selected');      
             var nodeIpadr = NodeList.row('.selected').data().ipadr;
		
     		fn_scheduleReset();
     		fn_policyReset();
     		fn_getScheduleInfo(nodeIpadr);

         } 
     } );   
 } );    
 

function fn_init() {
	/* ********************************************************
	 * 노트리스트 테이블
	 ******************************************************** */
	 NodeList = $('#nodeList').DataTable({
		scrollY : "515px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		bSort : false,
		columns : [
		{data : "masterGbn", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				if(data == "M"){
					data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 30px;"><b>Primary</b></div>'
				}else if(data == "SS"){
					data = '<i class="mdi mdi-subdirectory-arrow-right" style="margin-left: 50px;"><div class="badge badge-pill badge-outline-warning" title="" style="margin-left: 10px"><b>Standby</b></div>'
				}else if(data == "S"){
					data = '<div class="badge badge-pill badge-outline-warning" title="" style="margin-right: 30px"><b>Standby</b></div>'
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
		
		]
	});

	 NodeList.tables().header().to$().find('th:eq(1)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(2)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(3)').css('min-width');
	 
	 scheduleList = $('#scheduleList').DataTable({
		scrollY : "140px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		select : {'items' : 'cell', 'style' : 'multi'},
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

// increment policy reset
function fn_scheduleReset(){
	volumeDataList.length = 0;
	
	schSun.length = 0;
	schMon.length = 0;
	schTue.length = 0;
	schWed.length = 0;
	schThu.length = 0;
	schFri.length = 0;
	schSat.length = 0;

	fn_drawScheduleList();
}

// backup policy reset
function fn_policyReset(){
	$("#bckStorage").val("");
	$("#bckStorageType").val("");
	$("#bckStorageTypeVal").val("");
	$("#bckCompress").val("");
	$("#bckSetDate").val("");
	$("#bckSetNum").val("");
	$("#startDateSch").val("");
	$("#jobNameVal").val("");
}

function fn_alertShow(){
	$("#applyAlert").show();
	$("#applyAlert_none").hide();
}

function fn_alertHide(){
	$("#applyAlert").hide();
	$("#applyAlert_none").show();
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
			licenseNum=data.license;
			NodeList.clear();
			NodeList.rows.add(data.serverList).draw();
			serverNum = data.serverList.length;
			fn_setLicenseNum();
		}
	});
}

function fn_setLicenseNum(){
	$("#licenseNum").empty();
	var html = "License (" + serverNum + "/" + licenseNum + ")";
	$("#licenseNum").append(html);
}

/* ********************************************************
 * get schedule data
 ******************************************************** */
 function fn_getScheduleInfo(ipadr){
	$.ajax({
		url : "/experdb/getScheduleInfo.do",
		data : {
			ipadr : ipadr
		},
		type : "post"
	})
	.done(function(result){
		if(result.RESULT_CODE == "0"){
			jobExist = 1;
			fn_setScheduleInfo(result);
		}else if(result.RESULT_CODE == "2"){
			jobExist = 0;
			console.log("fail : can not find xml file");
		}else{
			console.log("fail");
		}
	})
	.fail(function(xhr, status, error){
		if(xhr.status == 401) {
			showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else if(xhr.status == 403) {
			showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else {
			showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
		}
	})
	.always(function(){
 		fn_alertHide();
	})
}

// 불러온 백업정책 setting
function fn_setScheduleInfo(result){
	var scheduleData = [];
	scheduleData = result.weekData;
	
	for(var index=0; index<result.volumes.length; index++){
		volumeDataList.push(result.volumes[index]);
	}
	
	// 증분 백업 정책 setting
	for(var i=0 ; i<scheduleData.length; i++){
		fn_scheduleInsert(scheduleData[i].dayPick, scheduleData[i].startTime, scheduleData[i].repeat, scheduleData[i].repEndTime, scheduleData[i].repTime, scheduleData[i].repTimeUnit, scheduleData[i].backupType);
	}
	$("#startDateSch").val(result.startDate);
	fn_drawScheduleList();
	
	// 풀 백업 정책 세팅
	$("#merge_period_week").val(result.weekDate);
	$("#merge_period_month").val(result.monthDate);
	if(result.dateType == "true"){
		$("input:radio[name='merge_period']:radio[value='weekly']").prop('checked', true); 
	}else{
		$("input:radio[name='merge_period']:radio[value='monthly']").prop('checked', true); 
	}
	
	$("#bckSetWeekDateVal").val(result.weekDate);
	$("#bckSetMonthDateVal").val(result.monthDate);
	$("#bckSetDateTypeVal").val(result.dateType);
	
	$("#storageType").val(result.storageType);
	$("#bckStorageTypeVal").val(result.storageType);
	
	$("#compressType").val(result.compress);
	$("#bckCompressVal").val(result.compress);
	
	$("#storageList").val(result.storage);
	
	$("#backupSetNum").val(result.setNum);
	$("#bckSetNum").val(result.setNum);
	
	$("#jobNameVal").val(result.jobName);
	
	// full backup 수행일을 문장으로 나타내주기 위해
	fn_policyReg();
	
	$("#bckStorage").val(result.storage);
	
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
	 var data = NodeList.rows('.selected').data();
	 if(data.length<1){
		showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	 }else{		 
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
}

 /* ********************************************************
  * node delete popup
  ******************************************************** */
  // node delete confirm popup
  function fn_nodeDelPopup(){
	var data = NodeList.rows('.selected').data();
	if(data.length < 1){
		showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		if(jobExist == 0){			
			confile_title = '<spring:message code="eXperDB_backup.msg5" /> ' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("node_del");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
			$('#pop_confirm_multi_md').modal("show");
		}else{
			confile_title = '<spring:message code="eXperDB_backup.msg5" /> ' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("node_del");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_backup.msg6" /> <br><spring:message code="message.msg162" />');
			$('#pop_confirm_multi_md').modal("show");
		}
	}
  }

  // node delete
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
     		fn_scheduleReset();
     		fn_policyReset();
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
		fn_alertHide();
	})
  }
 
  // confirm function
  function fnc_confirmMultiRst(gbn){
	  if(gbn == "node_del"){
		  fn_nodeDelete();
	  }else if(gbn == "backup_del"){
		  fn_backupDelete();
	  }else if (gbn == "go_monitoring"){
		  location.href="/experdb/backupMonitoring.do";
	  }else if(gbn == "backup_apply"){
		  fn_apply();
	  }
  }
 
/* ********************************************************
 * full backup policy registration
 ******************************************************** */
	
	function fn_policyRegPopoup() {
		var data = NodeList.rows('.selected').data();
		if(data.length < 1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
			$.ajax({
				url : "/experdb/backupStorageList.do",
				type : "post"
			})
			.done (function(result){			
				fn_setStorageList(result);
				if($("#bckStorage").val() != ""){
					fn_policyModiReset();
				}else{
					fn_policyRegReset();
				}
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
	}
/* ********************************************************
 * increment policy registration
 ******************************************************** */
	
	function fn_scheduleRegPopoup() {
		var data = NodeList.rows('.selected').data();
		if(data.length < 1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
			fn_scheduleRegReset();
			$("#pop_layer_popup_backupSchedule").modal("show");
		}
	}
	
	// schedule Insert per day
	function fn_scheduleInsert(dayPick, startTime, repCheck, repEndTime, repTime, repTimeUnit, backupType) {
		var schData = new Object();
		// 입력된 데이터를 Object에 넣어줌
		schData.st = startTime;
		schData.rc = repCheck;
		schData.bt = backupType;
		
		if(backupType == 3){
			schData.repeat = "Full<br>";
		}else{
			schData.repeat = "Incremental<br>";
		}
		
		if(repCheck){
			schData.rt = repTime;
			schData.ret = repEndTime;
			schData.rtu = repTimeUnit;
			// repeat --> scheduleList에 보여줄 data
			if(repTimeUnit == 0){
				schData.repeat += "<b>" + startTime + " ~ " + repEndTime +"</b><br>"+ repTime +"<spring:message code='eXperDB_backup.msg7' />";
			}else{
				schData.repeat += "<b>" + startTime + " ~ " + repEndTime +"</b><br>"+ repTime +"<spring:message code='eXperDB_backup.msg8' />";
			}
		}else{
			schData.rt = "";
			schData.ret = "";
			schData.rtu = "";
			schData.repeat += "<b>" + startTime + "</b>";
		}
		// 선택한 요일에 데이터를 넣어줌
		for(var i =0; i<7; i++){
			if(dayPick[i] == true){
				// console.log("schData : " + JSON.stringify(schData));
				schWeek[i].push(schData);
				// console.log("schWeek insert print : " + JSON.stringify(schWeek[i]));
			}
			schWeek[i].sort(compareTime);
		}
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
	
	// scheduleList draw
	function fn_drawScheduleList(){
		var dayLength = [schSun.length, schMon.length, schTue.length, schWed.length, schThu.length, schFri.length, schSat.length];
		var max = Math.max.apply(null, dayLength);
		
		scheduleList.clear().draw();
		// 스케줄이 많은 요일 기준으로 for 문 돌면서 draw
		for(var i=0;i<max;i++){
			// 전체 스케줄 데이터
			var schRow = [schSun[i],schMon[i],schTue[i],schWed[i],schThu[i],schFri[i],schSat[i]];
			var viewRow = [];
			for(var j=0;j<7;j++){
				// 해당 요일에 i번째 스케줄이 있을시 데이터를 viewRow에 넣어줌
				if(i<dayLength[j]){
					viewRow[j] = schRow[j].repeat;
				}else{
					viewRow[j]="";
				}
			}
			// i번째 스케줄 그려줌
			scheduleList.row.add(viewRow).draw();
		}
	}
	
	// increment policy delete
	function fn_scheduleDel(){
		// 선택된 index로 해당 요일 array의 데이터 지워줌
		var delData = scheduleList.cells('.selected');
		for(var i =0 ;i<delData[0].length; i++){
			var rowIndex = delData[0][i].row;
			var colIndex = delData[0][i].column;
			schWeek[colIndex].splice(rowIndex, 1);
		}
		fn_drawScheduleList();
		fn_alertShow();
		fn_scheduleAlert();
	}
	
	function fn_scheduleAlert(){
		$("#scheAlertDiv").empty();
		var bckSetWeekIndex = $("#bckSetWeekDateVal").val()-1;
		if($("#bckSetDateTypeVal").val() == "true" && schWeek[bckSetWeekIndex].length == 0){
			$("#scheAlertDiv").append('<spring:message code="eXperDB_backup.msg95" />');
			return false;
		}
		return true;
	}
	
/* ********************************************************
 * apply
 ******************************************************** */
// if($("#applyAlert").is(":visible")){	
 	function fn_apply() {
		// jsonParser를 쓰기 위해 Object 형태로 보냄
		var weekData = new Object();
		weekData.mon = schMon;
		weekData.tue = schTue;
		weekData.wed = schWed;
		weekData.thu = schThu;
		weekData.fri = schFri;
		weekData.sat = schSat;
		weekData.sun = schSun;
		
		var volumeSet=[];
		for(var i =0; i<volumeDataList.length; i++){
			var row = new Object();
			row.mountOn = volumeDataList[i].mountOn;
			row.filesystem = volumeDataList[i].filesystem;
			row.type = volumeDataList[i].type;
			volumeSet.push(row);
		}
		$.ajax({
			url : "/experdb/backupScheduleReg.do",
			type : "post",
			dataType : "json",
			traditional : true,
			data : {
				nodeIpadr : NodeList.row('.selected').data().ipadr,
				volumeList : JSON.stringify(volumeSet),
				weekData : JSON.stringify(weekData),
				startDate : $("#startDateSch").val(),
				// storageType : $("#bckStorageTypeVal").val(),
				storage : $("#bckStorage").val(),
				compress : $("#bckCompressVal").val(),
				dateType : $("#bckSetDateTypeVal").val(),
				weekDate : $("#bckSetWeekDateVal").val(),
				monthDate : $("#bckSetMonthDateVal").val(),
				setNum : $("#bckSetNum").val(),
				jobName : $("#jobNameVal").val()
			}
		})
		.done (function(result){
			if(result.RESULT_CODE == "0"){			
				showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '','success', 'backupPolicyApply');
				jobExist = 1;
			}else {
				showSwalIcon('<spring:message code="eXperDB_backup.msg9" />', '<spring:message code="common.close" />', '', 'error');
			}
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
		.always(function(){
	 		fn_alertHide();
	 		var nodeIpadr = NodeList.row('.selected').data().ipadr;
	 		fn_scheduleReset();
	 		fn_policyReset();
	 		fn_getScheduleInfo(nodeIpadr);
		})
	}
	
	function fn_goMonitoring(){
		confile_title = '<spring:message code="eXperDB_backup.msg10" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("go_monitoring");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="eXperDB_backup.msg11" />');
		$('#pop_confirm_multi_md').modal("show");
	}
	
	
	
/* ********************************************************
 * apply validation
 ******************************************************** */
 	function fn_applyValidation(){
 		var data = NodeList.rows('.selected').data();
		if(data.length<1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if($("#bckStorage").val() == "" || $("#bckStorage").val() == null){
			showSwalIcon('<spring:message code="eXperDB_backup.msg83" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if(!$("#applyAlert").is(":visible")){
			showSwalIcon('<spring:message code="eXperDB_backup.msg96" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if(!fn_scheduleAlert()){
			showSwalIcon('<spring:message code="eXperDB_backup.msg95" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
			confile_title = '<spring:message code="eXperDB_backup.msg97" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("backup_apply");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_backup.msg98" />');
			$('#pop_confirm_multi_md').modal("show");
		}
	}

 /* ********************************************************
  * filter popup
  ******************************************************** */
function fn_filter(){
	var data = NodeList.rows('.selected').data();
	if(data.length<1){
		showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		var serverIp = NodeList.row('.selected').data().ipadr;
		fn_getVolumes(serverIp);
	}

	$('#pop_layer_popup_backupVolumeFilter').modal("show");
}

 /* ********************************************************
  * backup delete popup
  ******************************************************** */
  // backup policy delete confirm popup
  function fn_backupDelPopup(){
		var data = NodeList.rows('.selected').data();
		if(data.length < 1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg4" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if(jobExist!= 1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg12" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
			confile_title = '<spring:message code="eXperDB_backup.msg5" /> ' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("backup_del");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
			$('#pop_confirm_multi_md').modal("show");
		}
 }
  
// backup policy delete 
function fn_backupDelete() {
	 var ipadr = NodeList.row('.selected').data().ipadr;
	 var jobName = $("#jobNameVal").val();
	 
	$.ajax({
		url : "/experdb/jobDelete.do",
		type : "post",
		data : {
			ipadr:ipadr,
			jobName:jobName
		},
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
			if(result.RESULT_CODE == "0"){		
				showSwalIcon('<spring:message code="message.msg12"/>', '<spring:message code="common.close" />', '', 'success');
				fn_scheduleReset();
	     		fn_policyReset();
	     		jobExist = 0;
				fn_getScheduleInfo(ipadr);
			}else{
				showSwalIcon('<spring:message code="migration.msg09" />', '<spring:message code="common.close" />', '', 'error');
			}
		}
	})
}
</script>
<style>
table.dataTable.nonborder tbody td{border-top:1px solid rgb(255, 255, 255);}
table.dataTable.target tbody tr.selected {
	color : #333333
}
table.dataTable.ccc tbody td.selected {
	background-color: #7bb8fd
}
table.dataTable.ccc tfoot th{
	border-top:1px solid rgb(255, 255, 255);
}
table.dataTable.ccc thead th{
	border-bottom : 1px solid rgb(168, 168, 168);
}
.tooltip-inner {
    max-width: 250px;
}

</style>
<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./popup/bckNodeRegForm.jsp"%>
<%@include file="./popup/bckPolicyRegForm.jsp"%>
<%@include file="./popup/bckScheduleRegForm.jsp"%>
<%@include file="./popup/bckVolumeForm.jsp"%>

<form name="storeInfo">
	<input type="hidden" name="jobNameVal" id="jobNameVal">
	<input type="hidden" name="bckStorageTypeVal"  id="bckStorageTypeVal">
	<input type="hidden" name="bckCompressVal"  id="bckCompressVal" >
	<input type="hidden" name="bckSetDateTypeVal"  id="bckSetDateTypeVal" >
	<input type="hidden" name="bckSetWeekDateVal" id="bckSetWeekDateVal">
	<input type="hidden" name="bckSetMonthDateVal" id="bckSetMonthDateVal">
	<input type="hidden" name="serverIpadr" id="serverIpadr">
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
												<span class="menu-title"><spring:message code="eXperDB_backup.msg13" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BnR</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">Backup</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_backup.msg13" /></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_backup_setting01" /></p>
											<p class="mb-0"><spring:message code="help.eXperDB_backup_setting02" /></p>
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
		<!-- node list -->
		<div class="col-lg-5 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeRegPopup()">
								<spring:message code="common.registory" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeModiPopup()">
								<spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_nodeDelPopup()">
								<spring:message code="common.delete" />
							</button>
						</div>
						<h4 class="card-title" style="font-size: 1em; color:black; margin-bottom:10px;">
							<i class="item-icon fa fa-desktop"></i> <spring:message code="eXperDB_backup.msg15" /> 
						</h4>
						<h4 class="card-title" id="licenseNum" style="font-size: 1em; color:black; margin-bottom:0px;">
							
						</h4>
						<table id="nodeList" class="table nonborder target table-hover system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100"><spring:message code="eXperDB_backup.msg16" /></th>
									<th width="130"><spring:message code="properties.host" /></th>
									<th width="100"><spring:message code="data_transfer.ip" /></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- node list end-->
		
		<!-- policy -->
		<div class="col-lg-7 grid-margin stretch-card">
			<div class="card"  style="padding-left: 0px;">
				<div class="table-responsive row" style="overflow:hidden;padding-right: 25px;">	
					<div class="row" style="padding-left: 310px;margin-bottom: -10;padding-top: 10px;padding-bottom: -10; width : 940px;">			
						<div class="tooltip-static-demo" id="applyAlertTooltip">
							<div class="tooltip bs-tooltip-left bs-tooltip-left-demo tooltip-warning" id="applyAlert" role="tooltip" style="margin-top: 10px;margin-right: 10px;margin-bottom: 0px; display:none;">
								<div class="arrow"></div>
								<div class="tooltip-inner" style="width: 250px;"><spring:message code="eXperDB_backup.msg14" /></div>
							</div>
							<div class="tooltip bs-tooltip-left bs-tooltip-left-demo tooltip-warning" id="applyAlert_none" role="tooltip" style="margin-top: 10px;margin-right: 10px;margin-bottom: 0px; width: 263px; ">
								
							</div>
						</div>
						
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-success btn-icon-text mb-2" onclick="fn_applyValidation()">
								<i class="fa fa-check btn-icon-prepend "></i><spring:message code="common.apply" />
							</button>
							<button type="button" class="btn btn-warning btn-icon-text mb-2" style="color:white;" onclick="fn_filter()">
								<i class="mdi mdi-filter-outline "></i>Volume
							</button>
							<button type="button" class="btn btn-danger btn-icon-text mb-2" onclick="fn_backupDelPopup()">
								<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
							</button>
						</div>
					</div>
				</div>
				<!-- full backup setting start -->
				<div class="card-body" style="padding-top: 20px;height: 280px;padding-top: 0px;">	
					<div class="card my-sm-2" style="height: 262px;" >
						<div class="card-body" >
							 <div class="row" style="margin-top:-20px;"  id="schedule_button">
								<div class="col-12" style="margin-top: 10px;">
									<div class="wrt_button" style="float: right">
										<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_policyRegPopoup()">
											 <spring:message code="encrypt_policyOption.Settings" />
										</button>
									</div>
								</div>
							</div>				 	
							<div class="col-12" id="jobDiv" >	
								<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_backup.msg17" />
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
										<spring:message code="eXperDB_backup.msg18" />
									</div>
									<div class="col-4" style="padding-left: 0px;">
										<input type="text" id="bckCompress" name="bckCompress" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
									</div>
								</div>		
								<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_backup.msg19" />
									</div>
									<div class="col-sm-2_5" style="margin-left: 0px;padding-left: 0px;">
										<input type="text" style="width:150px; height:40px; background-color:#ffffffdd;" class="form-control form-control-sm" name="bckSetDate" id="bckSetDate" readonly/>
									</div>
									<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_backup.msg20" />
									</div>
									<div class="col-sm-2_5" style="margin-left: 0px">
										<input type="number" min="1" max="10000" style="width:150px; height:40px; background-color:#ffffffdd;" class="form-control form-control-sm" name="bckSetNum" id="bckSetNum" readonly/>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div style="position: absolute;top:70px; right:730px; width: 155px;">
						<h4 class="card-title" style="background-color: white;font-size: 1em; color:black;">
							<i class="item-icon fa fa-desktop"></i> <spring:message code="eXperDB_backup.msg21" />
						</h4>
					</div>
				</div>
				<!-- full backup setting end -->
			
				<div class="card-body" style="padding-bottom: 10px;">
					<div class="card my-sm-2" style="" >
						<div class="card-body" style="height: 280px;padding-top: 5px;padding-bottom: 5px;">
							<div class="col-12" id="jobDiv" style="padding-left: 0px;padding-right: 0px;">
								<div class="text-danger" id="scheAlertDiv" name="scheAlertDiv" style="height: 24px; font-size:0.8em;font-weight:bold;text-align:right;padding-top: 7px;padding-right: 30px;">
									
								</div>
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
					<div style="position: absolute;top:365px; right:735px; width:150px;">					
						<h4 class="card-title" style="background-color: white;font-size: 1em; color: #000000; ">
							<i class="item-icon fa fa-desktop"></i> <spring:message code="eXperDB_backup.msg22" />
						</h4>
					</div>
				</div>
				<!-- backup schedule end -->
			</div>
		</div>
	</div>
</div>