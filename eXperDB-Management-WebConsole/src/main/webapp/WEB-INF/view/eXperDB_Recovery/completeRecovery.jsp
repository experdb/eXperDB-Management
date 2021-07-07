<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
   

<%
	/**
	* @Class Name : completeRecovery.jsp
	* @Description : 완전복구 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-06-09	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.06.09
	*
	*/
%>

<script type="text/javascript">

var storageList = [];
var CIFSList = [];
var NFSList = [];
var storageExist = "N";
/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();
	fn_getBackupDBList();
	$("#storageDiv").hide();
});


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

 
function fn_bmrInstanceClick(){
	var instance = $("#bmrInstant").val();
	$("#bmrInstantAlert").empty();
	if(instance == 1){
		$("#bmrInstantAlert").append("* 먼저 서버 시작에 필요한 데이터를 복구합니다. 이후 나머지 데이터는 서버 시작 후 복구 됩니다.");
	}
}


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

function fn_setBackupDBList(data){
	var html;
	for(var i =0; i<data.length; i++){
		html += '<option value="'+data[i].ipadr+'">'+data[i].ipadr+ ' [' + data[i].masterGbn + ']'+'</option>';
	}
	$("#backupDBList").append(html);
}

function fn_backupDBChoice(){
	var ipadr = $("#backupDBList").val();
	if(ipadr != 0) {
		$.ajax({
			url : "/experdb/recStorageList.do",
			type : "post",
			data : {
				ipadr : ipadr
			}
		})
		.done(function(result){
			fn_setStorageList(result.storageList);
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
}


function fn_recoveryDBReset(){
	$("#recMachineMAC").val("");
	$("#recMachineIP").val("");
	$("#recoveryDB").val("");
	$("#recMachineSNM").val("");
	$("#recMachineGateWay").val("");
	$("#recMachineDNS").val("");
}

function fn_setStorageList(data) {
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
		
	}else{
		storageExist = "Y";
		for(var i =0; i<storageList.length; i++){
			if(storageList[i].type == "2"){
				CIFSList.push(storageList[i]);
			}else{
				NFSList.push(storageList[i]);
			}
		}
		$("#storageDiv").show();
	}
}

function fn_storageTypeClick(){
	var type = $("#storageType").val();
	var html;
	$("#storageList").empty();
	if(type == 2){
		for(var i =0; i<CIFSList.length; i++){			
			html += '<option value="'+CIFSList[i].path+'">'+CIFSList[i].path+'</option>';
		}
	}else{
		for(var i =0; i<NFSList.length; i++){			
			html += '<option value="'+NFSList[i].path+'">'+NFSList[i].path+'</option>';
		}
	}
	$("#storageList").append(html);
}

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

function fn_runNowClick(){
	if(fn_valCheck()){
		confile_title = '복구 수행';
		$('#con_multi_gbn', '#findConfirmMulti').val("recovery_run");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('복구를 수행하시겠습니까?');
		$('#pop_confirm_multi_md').modal("show");
	}
}

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

function fn_passwordCheckPopup(){
	 fn_pwCheckFormReset();
	 $("#pop_layer_popup_recoveryPasswordCheckForm").modal("show");
}

function fn_recoveryRun(){
	if($("#recoveryPW").val() != ""){
		
		// console.log("=================================================");
		// console.log("password		" + $("#recoveryPW").val());
		// console.log("bmrInstant		" + $("#bmrInstant").val());
		// console.log("sourceDB		" + $("#backupDBList").val());
		// console.log("storageType	" + $("#recStorageType").val());
		// console.log("storagePath	" + $("#recStoragePath").val());
		// console.log("targetMac		" + $("#recMachineMAC").val());
		// console.log("targetIp		" + $("#recMachineIP").val());
		// console.log("targetSNM		" + $("#recMachineSNM").val());
		// console.log("targetGW		" + $("#recMachineGateWay").val());
		// console.log("targetDNS		" + $("#recMachineDNS").val());
		// console.log("=================================================");
		
		if($("#recStorageType").val() == "" || $("#recStoragePath").val() == ""){
			$("#recStorageType").val($("#storageType").val());
			$("#recStoragePath").val($("#storageList").val());
		}
		$.ajax({
			url : "/experdb/completeRecoveryRun.do",
			type : "post",
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
				targetDNS : $("#recMachineDNS").val()
			}
		})
		.done(function(data){
			if(data.result_code == 5){
				showSwalIcon('잘못된 비밀번호 입니다', '<spring:message code="common.close" />', '', 'error', 'top');
				fn_pwCheckFormReset();
				
			}else if(data.result_code == 1){
				$("#pop_layer_popup_recoveryPasswordCheckForm").modal("hide");
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

</script>

<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./popup/recTargetListForm.jsp"%>
<%@include file="./popup/recTargetDBRegForm.jsp"%>
<%@include file="./popup/recPwChkForm.jsp"%>

<form name="recoveryInfo">
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
												<span class="menu-title">Complete Recovery</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BnR</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">Recovery</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">Complete Recovery</li>
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
			<div class="card grid-margin stretch-card" style="height: 130px;margin-bottom: 10px;">
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
			</div>
			<div class="card grid-margin stretch-card" style="height: 470px;">
				<div class="card-body" style="height: 140px; margin-top: 10px;">
					<div style="width:600px; text-align:center;">
						<div class="row" style="position:absolute; left:50%;transform: translateX(-50%);">
							<div class="col-4" style="text-align:center;">
								<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 7.0em;"></i>
								<h5 style="margin-top: 8px;">백업 DB</h5>
							</div>
							<i class="mdi mdi-arrow-right-bold icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 7.0em;"></i>
							<div class="col-4" style="text-align:center;">
								<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 7.0em;"></i>
								<h5 style="margin-top: 8px;">복구 DB</h5>
							</div>
						</div>
					</div>
				</div>
				<div class="card-body">
					<div class="form-group row" style="margin-top: 10px;margin-left: 0px;">
						<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
							백업 DB
						</div>
						<div class="col-4" style="padding-left: 0px;">
							<select class="form-control form-control-xsm" id="backupDBList" style=" width: 200px; height: 35px;" onchange="fn_backupDBChoice()">
								<option value="0">선택</option>
							</select>
						</div>
					</div>
					<div class="form-group row" id="storageDiv" style="margin-top: 10px;margin-left: 0px; ">
						<div  class="col-3 col-form-label pop-label-index" style="padding-top:7px;">
							Storage
						</div>
						<select class="form-control form-control-xsm" id="storageType" name="storageType" style="width:130px; height:35px;margin-right: 10px; color:black;" onchange="fn_storageTypeClick()">
							<option value="1">NFS share</option>
							<option value="2">CIFS share</option>
						</select>
						<select class="form-control form-control-xsm" id="storageList" name="storageList" style="width:200px; height:35px; color:black;">
							
						</select>
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
				</div>
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