<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
   

<%
	/**
	* @Class Name : timeRecovery.jsp
	* @Description : 시점복구 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-06-09	신예은 매니저		최초 생성
	*	2021-10-14 	변승우 책임         기능 추가
	*
	* author 신예은 매니저
	* since 2021.06.09
	*
	*/
%>

<style>
.moving-square-loader:before {
    content: "";
    position: absolute;
    width: 14px;
    height: 14px;
    top: calc(50% - -15px);
    left: 0px;
    background-color: #68afff;
    animation: rotatemove 1s infinite;
}
</style>

<script type="text/javascript">

var storagePath;
var storageExist = "N";
var storageList = [];
var CIFSList = [];
var NFSList = [];
var storageExist = "N";
var recLogList;
var jobend = 0;

/* 
#1. 백업 DB 리스트 조회
#2.  Source(복구) DB 선택시, recoveryPoint 가져오기
#2-2. 선택된 SourceDB Recovery Point 조회
#3. 타겟서버 등록
#4. 복구수행 버튼 클릭
#4-1. 복구 수행전 Validation 수행
#4-2 시점복원 수행 전, 패스워드 체크
#5. 시점복원 수행
*/


/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();
	fn_getBackupDBList();
	$(".moving-square-loader").hide();
	$("#status_basic").show();
});



/* ********************************************************
 * 초기화
 ******************************************************* */
function fn_init(){
	recLogList = $("#recLogList").DataTable({
		scrollY : "480px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		lengthChange: false,
		deferRender : true,
		info : false,
		bSort : false,
		columns : [
		{
			data : "type",
			render : function(data, type, full, meta) {	 						
				var html = '';
				// TYPE_INFO
				if (full.type == 1) {
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-info-circle text-primary' /> </i>";
				html += "</div>";
				// TYPE_ERROR
				}else if(full.type == 2){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-times-circle text-danger' /> </i>";
					html += "</div>";
				// TYPE_WARNING
				}  else if(full.type == 3){
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-warning text-warning' /> </i>";
				html += "</div>";				
				} 
				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},				
		{data : "time", className : "dt-center", defaultContent : ""},	
		{data : "message", className : "dt-left", defaultContent : ""}
		]
	});

	recLogList.tables().header().to$().find('th:eq(0)').css('min-width');
	recLogList.tables().header().to$().find('th:eq(1)').css('min-width');
	recLogList.tables().header().to$().find('th:eq(2)').css('min-width');

	$(window).trigger('resize'); 

}



/* ********************************************************
 * 무조건 BmrInstance 백업으로 진행 (자바에서 처리)
 ******************************************************* */
/* function fn_bmrInstanceClick(){
	var instance = $("#bmrInstant").val();
	$("#bmrInstantAlert").empty();
	if(instance == 1){
		$("#bmrInstantAlert").append("* 먼저 서버 시작에 필요한 데이터를 복구합니다. 이후 나머지 데이터는 서버 시작 후 복구 됩니다.");
	}
} */



/* ********************************************************
 * #1. Source(복구) DB 리스트 조회
 ******************************************************* */
function fn_getBackupDBList(){
	$.ajax({
		url : "/experdb/nodeInfoList.do",
		type : "post"
	})
	.done(function(result){
		fn_setBackupDBList(result.serverList);
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
 * 조회된 BackupDB 리스트 Select Box에 적용
 ******************************************************* */
function fn_setBackupDBList(data){
	var html;
	for(var i =0; i<data.length; i++){
		html += '<option value="'+data[i].ipadr+'">'+data[i].ipadr+ ' [' + data[i].masterGbn + ']'+'</option>';
	}
	$("#backupDBList").append(html);
}



/* ********************************************************
 * #2.  Source(복구) DB 선택시, StorageList 조회
 ******************************************************* */
function fn_getRecoveryInfo(){
	var ipadr = $("#backupDBList").val();

	//스토리지 정보 조회
	$.ajax({
		url : "/experdb/recStorageList.do",
		type : "post",
		data : {
			ipadr : ipadr
		}
	})
	.done(function(result){
		fn_setStorageList(result.storageList, ipadr);
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
			fn_recoveryDBReset();
		})
} 


function fn_recoveryDBReset(){
	$("#recMachineMAC").val("");
	$("#recMachineIP").val("");
	$("#recoveryDB").val("");
	$("#recMachineSNM").val("");
	$("#recMachineGateWay").val("");
	$("#recMachineDNS").val("");
}



/* ********************************************************
 * #2-1. Storage set
 ******************************************************* */
function fn_setStorageList(data, ipadr) {

	storageList.length=0;
	CIFSList.length=0;
	NFSList.length=0;
	storageList = data;
	$("#storageDiv").hide();
	$("#recStorageType").val("");
	$("#recStoragePath").val("");
	
	if(storageList.length == 0){
		storageExist = "N";
		showSwalIcon('백업된 데이터가 존재하지 않습니다.', '<spring:message code="common.close" />', '', 'error');
		$("#backupDBList").val(0);
		
	}else if(storageList.length == 1){
		storageExist = "Y";		
		$("#recStorageType").val(data[0].type);
		$("#recStoragePath").val(data[0].path);
		
		fn_getRecoveryPoint(data[0].path,ipadr);
		
	}else{
		storageExist = "Y";
		for(var i =0; i<storageList.length; i++){
			if(storageList[i].type == "2"){
				CIFSList.push(storageList[i]);
			}else{
				NFSList.push(storageList[i]);
			}
		}
	}
}


/* ********************************************************
 * #2-2. 선택된 SourceDB Recovery Point 조회
 ******************************************************* */
function fn_getRecoveryPoint(storagePath,ipadr){

	$.ajax({
		url : "/experdb/getRecoveryPoint.do",
		type : "post",
		data : {
			storagePath : storagePath,
			ipadr:ipadr
		}
	})
	.done(function(result){
		fn_setRecoveryTimeList(result.result);
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
 * Recovery Point set
 ******************************************************* */
function fn_setRecoveryTimeList(data){
	$("#recoveryTimeList").empty();
	var html;
	for(var i =0; i<data.length; i++){
		html += '<option value="'+data[i].recoveryPoint+'">'+data[i].recoveryTime+ '</option>';
	}
	$("#recoveryTimeList").append(html);
}




/* ********************************************************
 * #3. 타겟서버 등록
 ******************************************************* */
function fn_targetListPopup(){
	if($("#backupDBList").val() != 0){
		$.ajax({
			url : "/experdb/recoveryDBList.do",
			type : "post"
		})
		.done(function(result){
			TargetList.clear();
			TargetList.rows.add(result.recoveryList).draw();
			fn_setIpList(result.recoveryList);
			$("#pop_layer_popup_recoveryTargetList").modal("show");
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
	}else{
		showSwalIcon('선택된 백업 DB가 없습니다', '<spring:message code="common.close" />', '', 'error');
	}	
}



/* ********************************************************
 * #4. 복구수행 버튼 클릭
 ******************************************************* */
function fn_runNowClick(){
	if(fn_valCheck()){
		confile_title = '복구 수행';
		$('#con_multi_gbn', '#findConfirmMulti').val("recovery_run");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('복구를 수행하시겠습니까?');
		$('#pop_confirm_multi_md').modal("show");
	}
}


/* ********************************************************
 * #4-1. 복구 수행전 Validation 수행
 ******************************************************* */
function fn_valCheck(){
	if($("#bmrInstant").val() == 0){
		showSwalIcon('Instance BMR을 선택해주세요', '<spring:message code="common.close" />', '', 'error', 'top');
		return false;
	}else if($("#backupDBList").val() == 0){
		showSwalIcon('백업 DB를 선택해주세요', '<spring:message code="common.close" />', '', 'error', 'top');
		return false;
	}else if($("#recMachineIP").val() == ""){
		showSwalIcon('복구 DB를 선택해주세요', '<spring:message code="common.close" />', '', 'error', 'top');
		return false;
	}
	return true;
}


function fnc_confirmMultiRst(gbn){
	  if(gbn == "recovery_run"){
		  fn_passwordCheckPopup();
	  }else if(gbn == "recoveryDB_del"){
		  fn_recMachineDel();
	  }
}


/* ********************************************************
 *  #4-2 시점복원 수행 전, 패스워드 체크
 ******************************************************* */
function fn_passwordCheckPopup(){
	 fn_pwCheckFormReset();
	 $("#pop_layer_popup_recoveryPasswordCheckForm").modal("show");
}


/* ********************************************************
 * #5. 시점복원 수행
 ******************************************************* */
function fn_recoveryRun(){
	if($("#recoveryPW").val() != ""){
	$.ajax({
		url : "/experdb/timeRecoveryRun.do",
		type: "post",
		data : {
			password : $("#recoveryPW").val(),
			bmrInstant : $("#bmrInstant").val(),
			sourceDB : $("#backupDBList").val(),
			storageType : $("#recStorageType").val(),
			storagePath : $("#recStoragePath").val(),
			targetMac : $("#recMachineMAC").val(),
			targetIp : $("#recMachineIP").val(),
			targetSNM : $("#recMachineSNM").val(),
			targetGW : $("#recMachineGateWay").val(),
			targetDNS : $("#recMachineDNS").val(),
			timePoint: $("#recoveryTimeList").val()
		}
	})
	.done(function(data){
		if(data.result_code == 5){ 
			showSwalIcon('잘못된 비밀번호 입니다', '<spring:message code="common.close" />', '', 'error', 'top');
			fn_pwCheckFormReset();
		}else{
			showSwalIcon('복원이 시작됩니다', '<spring:message code="common.close" />', '', 'success');
			// 생성된 jobName
			var jobName = data.jobName;
			// 실행된 Job의 id 조회
			var jobId = fn_selectJobId(jobName);
			// logCheck 함수 called
			fn_selectActivityLogCheck(jobId, jobName);
			$("#pop_layer_popup_recoveryPasswordCheckForm").modal("hide");			
			$(".moving-square-loader").show();
			$("#status_basic").hide();		
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
	}else{
		showSwalIcon('비밀번호를 입력해주세요', '<spring:message code="common.close" />', '', 'error', 'top');
		$("#recoveryPW").focus();
	}
}


//logcheck 함수
function fn_selectActivityLogCheck(jobid, jobname){	
		// console.log("fn_selectActivityLogCheck!! --> " + jobid + " // " + jobname);
		setTimeout(fn_selectJobEnd, 8000, jobid,jobname);	
		setTimeout(fn_selectActivityLog, 5000, jobid,jobname);			
}



/* function fn_getRecoveryTimeOption(){
	
	var jobid = $("#recoveryTimeList").val();
	
	$.ajax({
		url : "/experdb/getRecoveryTimeOption.do",
		type : "post",
		data : {
			jobid : jobid
		}
	})
	.done(function(result){
		//alert(JSON.stringify(result.data));
		fn_setStorageInfo(result.data);
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
} */



//jobId 조회
function fn_selectJobId(jobname){
	var result = 0;
	// jobId가 0이 아닐때까지(제대로 조회 될 때까지) 조회
	while(!result){		
		$.ajax({
			url : "/experdb/selectJobId.do",
			data : {
				jobname : jobname
			},
			async: false, 
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
				result = data;
			}
		});
		console.log("jobId : " + result);
	}
	return result;
	//$('#loading').hide();	
}

//log 조회
function fn_selectActivityLog(jobid, jobname) {
	$.ajax({
		url : "/experdb/backupActivityLogList.do",
		data : {
			jobid : jobid
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
			if(jobend == 0){
				recLogList.clear().draw();
				recLogList.rows.add(data).draw();	
			}else{
				recLogList.clear().draw();
			}
		}
	});
	$('#loading').hide();
} 


//job 종료 여부 조회
function fn_selectJobEnd(jobid,jobname){
	
	$.ajax({
		url : "/experdb/selectJobEnd.do",
		data : {
			jobname:jobname
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
			//console.log('종료 데이터= '+data);		
			 if(data == 1){		
				jobend = 1;
				recLogList.clear().draw();
				$("#status_basic").show();
				$(".moving-square-loader").hide();
			}else{	
				jobend = 0;
				fn_selectActivityLogCheck(jobid, jobname);
			} 						
		}
	});
	$('#loading').hide();	
}

</script>

<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./popup/recTargetListForm.jsp"%>
<%@include file="./popup/recTargetDBRegForm.jsp"%>
<%@include file="./popup/recPwChkForm.jsp"%>

<form name="recoveryInfo">
	<input type="hidden" name="recPoint"  id="recPoint">	
	<input type="hidden" name="recStorageType" id="recStorageType">
	<input type="hidden" name="recStoragePath"  id="recStoragePath">
	<input type="hidden" name="recMachineMAC"  id="recMachineMAC">
	<input type="hidden" name="recMachineIP"  id="recMachineIP">
	<input type="hidden" name="recMachineSNM"  id="recMachineSNM">
	<input type="hidden" name="recMachineGateWay"  id="recMachineGateWay">
	<input type="hidden" name="recMachineDNS"  id="recMachineDNS">	
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
												<span class="menu-title">Point-in-Time Recovery</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BnR</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">Recovery</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">Point-in-Time Recovery</li>
										</ol>
									</div>
								</div>
							</div>
							<!-- ///////////////////////////////////////// 수정 필요 ////////////////////////////////////////// -->
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
							<!-- ////////////////////////////////////////////////////////////////////////////////////////// -->
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<div class="col-12 grid-margin stretch-card" style="margin-bottom: 0px;">
			<div class="card-body" style="padding-bottom:0px; padding-top: 0px;">
				<div id="wrt_button" style="float: right;">
					<button type="button" class="btn btn-success btn-icon-text mb-2" onclick="fn_runNowClick()">
						<i class="ti-control-forward btn-icon-prepend "></i>복구
					</button>
				</div>
			</div>
		</div>
		
		<!-- recovery setting -->
		<div class="col-lg-5">
			<!-- <div class="card grid-margin stretch-card" style="height: 130px;margin-bottom: 10px;">
				<div class="card-body">
					<div style="border: 1px solid rgb(200, 200, 200); height: 90px;">
						<div class="form-group row" style="margin-top: 20px; margin-bottom: 5px; margin-left: 15px;">
							<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
								Instant BMR
							</div>
							<div class="col-2" style="padding-left: 0px;">
								<select class="form-control form-control-xsm" id="bmrInstant" style=" width: 200px; height: 35px;" onchange="fn_bmrInstanceClick()">
									<option value="0">선택</option>
									<option value="1">enable</option>
									<option value="2">disable</option>
								</select>
							</div>
						</div>
						<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
							<div  class="col-12 col-form-label pop-label-index" id="bmrInstantAlert" name="bmrInstantAlert" style="padding-top:0px; color:red; font-size:0.8em; padding-bottom: 0px;">
								
							</div>
						</div>
					</div>
				</div>
			</div> -->
			<div class="card grid-margin stretch-card" style="height: 570px;">
				<div class="card-body" style="height: 140px; margin-top: 140px;">
					<div style="width:900px; text-align:center;">
						<div class="row" style="position:absolute; left:50%;transform: translateX(-50%);">
							<div class="col-4" style="text-align:center;">
								<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 9.0em;margin-left: -100px;"></i>
								<h5 style="margin-top: 20px;width:100px; margin-left: -60px;">SOURCE DB</h5>
								<select class="form-control form-control-xsm" id="backupDBList" style="width: 200px; height: 35px; margin-top: 20px; margin-left: -100px;" onchange="fn_getRecoveryInfo()">
									<option value="0">선택</option>
								</select>
								<select class="form-control form-control-xsm"  name="recoveryTimeList"  id="recoveryTimeList" style=" width: 200px; height: 35px; margin-left: -100px; margin-top: 4px;">
									<option value="0">시점선택</option>
								</select>
							</div>
							<div id="status_basic" ><i class="mdi mdi-arrow-right-bold icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="padding-left: 20px;margin-right: 20p;font-size: 6.0em;margin-top: 20px;"></i></div>
							<i class="moving-square-loader"></i>
							<div class="col-4" style="text-align:center;">
								<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 9.0em;margin-right: -150px;"></i>
								<h5 style="margin-top: 20px;width:100px;margin-left: 68px;">TARGET</h5>
								<div class="col-4" style="padding-left: 0px;">
									<input type="text" id="recoveryDB" name="recoveryDB" class="form-control form-control-sm" style="height: 35px;background-color:#ffffffdd;margin-top: 20px;margin-left: 20px;width: 200px;" readonly/>
								</div>
								<div class="col-4" style="padding-left: 157px;margin-top: -35px;">
									<button type="button" class="btn btn-inverse-primary btn-icon-text btn-sm btn-search-disable" onClick="fn_targetListPopup()" style="width: 63px;height: 35px;">등록</button>
								</div>
							</div>
						</div>
						

					  <!-- <div class="col-4" style="padding-left: -60px; padding-top:270px;">
							<select class="form-control form-control-xsm"  name="recoveryTimeList"  id="recoveryTimeList" style=" width: 200px; height: 35px;" onchange="fn_getRecoveryTimeOption()">
								<option value="0">시점선택</option>
							</select>
						</div> -->
				
						
					</div>
				</div>
				<!-- <div class="card-body">
					<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
						<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
							백업 DB
						</div>
						<div class="col-4" style="padding-left: 0px;">
							<select class="form-control form-control-xsm" id="backupDBList" style=" width: 200px; height: 35px;" onchange="fn_getRecoveryTimeList()">
								<option value="0">선택</option>
							</select>
						</div>
					</div>
					<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
						<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
							시점선택
						</div>
					 <div class="col-4" style="padding-left: 0px;">
							<select class="form-control form-control-xsm"  name="recoveryTimeList"  id="recoveryTimeList" style=" width: 200px; height: 35px;" onchange="fn_getRecoveryTimeOption()">
								<option value="0">선택</option>
							</select>
						</div>
					</div>

					<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
						<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
							복구 DB
						</div>
						<div class="col-4" style="padding-left: 0px;">
							<input type="text" id="recoveryDB" name="recoveryDB" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
						</div>
						<div class="col-4" style="padding-left: 0px;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text btn-sm btn-search-disable" onClick="fn_targetListPopup()">등록</button>
						</div>
					</div>
				</div> -->
			</div>
		</div>
		<!-- recovery setting end-->
		
		<!-- log -->
		<div class="col-lg-7 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:500px;">
						<table id="recLogList" class="table table-hover system-tlb-scroll" style="width:100%; align:dt-center; ">
							<thead>
								<tr class="bg-info text-white">
									<th width="70" style="background-color: #7e7e7e;">Status</th>
									<th width="70" style="background-color: #7e7e7e;">Time</th>
									<th width="500" style="background-color: #7e7e7e;">Message</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>