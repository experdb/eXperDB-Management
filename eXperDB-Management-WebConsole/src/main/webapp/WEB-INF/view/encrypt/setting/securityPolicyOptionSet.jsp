<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : securityPolicyOptionSet.jsp
	* @Description : securityPolicyOptionSet 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.07.17   변승우 과장		UI 디자인 변경
	*
	* author 변승우 대리
	* since 2018.01.04
	
	*
	*/
%>

<script>

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
 	fn_buttonAut();
	fn_makeStartHour();
	fn_makeEndHour();
	
	fn_securityPolicyOptionSelect01();
	fn_securityPolicyOptionSelect02(); 
	
});


function fn_buttonAut(){
	var btnSave = document.getElementById("btnSave"); 
	
	if("${wrt_aut_yn}" == "Y"){
		btnSave.style.display = '';
	}else{
		btnSave.style.display = 'none';
	}
}

/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeStartHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"  name="start_exe_h" id="start_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour =  i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#startHour" ).append(hourHtml);
}

function fn_makeEndHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"  name="stop_exe_h" id="stop_exe_h">';	
	for(var i=0; i<=24; i++){
		if(i >= 0 && i<10){
			hour =  i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#endHour" ).append(hourHtml);
}

/*	GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF(기본 접근 허용) : 0, 1
GLOBAL_POLICY_FORCED_LOGGING_OFF_TF(암복호화 로그 기록 중지) : 0, 1
GLOBAL_POLICY_BOOST_TF(부스트) : True, False
GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION(암복호화 로그 서버에서 압축 시간 )
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT(암복호화 로그 AP에서 최대 압축값)
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT(암복호화 로그 압축 중단 시간 )
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL(암복호화 로그 압축 시작값)
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD(암복호화 로그 압축 출력 시간 )*/
function fn_securityPolicyOptionSelect01(){
	$.ajax({
		url : "/selectSysConfigListLike.do", 
	  	data : {
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
		success : function(data) {
			if(data.resultCode == "0000000000"){
				for(var i=0; i<data.list.length; i++){
					if(data.list[i].configKey == "GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" && data.list[i].configValue== "1"){
						$("#GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" && data.list[i].configValue== "1"){
						$("#GLOBAL_POLICY_FORCED_LOGGING_OFF_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_BOOST_TF" && data.list[i].configValue== "true"){
						$("#GLOBAL_POLICY_BOOST_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val(data.list[i].configValue);
						}						
					}
				}
			}else if(data.resultCode == "8000000002"){
				showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
			}else if(data.resultCode == "0000000003"){		
				showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
			}
		}
	});	
}


function fn_securityPolicyOptionSelect02(){
	$.ajax({
		url : "/selectSysMultiValueConfigListLike.do", 
	  	data : {
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
				showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				
				if(data.list[1].logTransferWaitTime == null || data.list[1].logTransferWaitTime == "" || data.list[1].logTransferWaitTime == "null" || data.list[1].logTransferWaitTime == "0"){
					$("#logTransferWaitTime").val("1");
				}else{
					$("#logTransferWaitTime").val(data.list[1].logTransferWaitTime);
				}
				
				if(data.list[0].blnIsvalueTrueFalse == true){
					$("#blnIsvalueTrueFalse").attr('checked', true);
				}
			
				if(data.list[0].day0 == true){
					$("#mon").attr('checked', true);
				}			
				if(data.list[0].day1 == true){
					$("#tue").attr('checked', true);
				}						
				if(data.list[0].day2 == true){
					$("#wed").attr('checked', true);
				}		
				if(data.list[0].day3 == true){
					$("#thu").attr('checked', true);
				}		
				if(data.list[0].day4 == true){
					$("#fri").attr('checked', true);
				}
				if(data.list[0].day5 == true){
					$("#sat").attr('checked', true);
				}
				if(data.list[0].day6 == true){
					$("#sun").attr('checked', true);
				}

				document.getElementById('start_exe_h').value=data.list[0].transferStart;
				document.getElementById('stop_exe_h').value=data.list[0].transferStop;
				
			}	
			fn_change();
		}
	});	
}

/*정책저장 Validation*/
function fn_validation(){
	//암복호화 로그 서버에서 압축시간
	var GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION");
	//암복호화 로그 압축 출력 시간
	var GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD");
	//암복호화 로그 압축 중단 시간
	var GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT");
	
	if (GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION.value < GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD.value) {
		showSwalIcon('[암복호화 로그 서버에서 압축 시간 단위(초)]값은 [암복호화 로그 압축 출력 시간 단위(초)]보다 크거나 같아야 합니다.', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	if (GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT.value <= GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD.value) {
		showSwalIcon('[암복호화 로그 압축 중단 시간(초)]값은 [암복호화 로그 압축 출력 시간 단위(초)]보다 커야 합니다.', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	return true;
}

function fn_save(){
	
	var arrmaps01 = [];
	var tmpmap01 = new Object();
	
	var arrmaps02 = [];
	var tmpmap02 = new Object();
	
	 var dayWeek = new Array();
	 dayWeek.push($("#mon").prop("checked"));
	 dayWeek.push($("#tue").prop("checked"));
	 dayWeek.push($("#wed").prop("checked"));
	 dayWeek.push($("#thu").prop("checked"));
	 dayWeek.push($("#fri").prop("checked"));
	 dayWeek.push($("#sat").prop("checked"));
	 dayWeek.push($("#sun").prop("checked"));

	tmpmap01["global_policy_default_access_allow_tf"] =$("#GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF").prop("checked");
	tmpmap01["global_policy_forced_logging_off_tf"] = $("#GLOBAL_POLICY_FORCED_LOGGING_OFF_TF").prop("checked");
	tmpmap01["global_policy_boost_tf"] = $("#GLOBAL_POLICY_BOOST_TF").prop("checked");
	tmpmap01["global_policy_crypt_log_tm_resolution"] = $("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val();
	tmpmap01["global_policy_crypt_log_compress_flush_timeout"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val();
	tmpmap01["global_policy_crypt_log_compress_limit"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val();
	tmpmap01["global_policy_crypt_log_compress_print_period"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val();
	tmpmap01["global_policy_crypt_log_compress_initial"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val();
	arrmaps01.push(tmpmap01);	
	
	tmpmap02["blnIsvalueTrueFalse"] = $("#blnIsvalueTrueFalse").prop("checked");
	tmpmap02["start_exe_h"] = $("#start_exe_h").val();
	tmpmap02["stop_exe_h"] = $("#stop_exe_h").val();
	tmpmap02["logTransferWaitTime"] = $("#logTransferWaitTime").val();
	arrmaps02.push(tmpmap02);	
	
	$.ajax({
		url : "/sysConfigSave.do", 
	  	data : {
	  		arrmaps01 : JSON.stringify(arrmaps01),
	  		dayWeek : JSON.stringify(dayWeek),
	  		arrmaps02 : JSON.stringify(arrmaps02)
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
				showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				showSwalIcon('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');		
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
			}else if(data.resultCode == "0000000003"){		
				showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
			}	
		}
	});	
}

function fn_change(){
	if($("input:checkbox[id='blnIsvalueTrueFalse']").is(":checked")){
		$("#mon").attr("onclick", "");
		$("#tue").attr("onclick", "");
		$("#wed").attr("onclick", "");
		$("#thu").attr("onclick", "");
		$("#fri").attr("onclick", "");
		$("#sat").attr("onclick", "");
		$("#sun").attr("onclick", "");
		$("#start_exe_h").attr("disabled", false);
		$("#stop_exe_h").attr("disabled", false);
	}else{
		$("#mon").attr("onclick", "return false;");
		$("#tue").attr("onclick", "return false;");
		$("#wed").attr("onclick", "return false;");
		$("#thu").attr("onclick", "return false;");
		$("#fri").attr("onclick", "return false;");
		$("#sat").attr("onclick", "return false;");
		$("#sun").attr("onclick", "return false;");
		$("#start_exe_h").attr("disabled", true);
		$("#stop_exe_h").attr("disabled", true);

	}
}


function fn_confirm(){
	
	if (!fn_validation()) return false;
	fn_ConfirmModal();
}


/* ********************************************************
 * confirm modal open
 ******************************************************** */
function fn_ConfirmModal() {
	confirm_title = '<spring:message code="encrypt_policyOption.Security_Policy_Option_Setting" />' + " " + '<spring:message code="common.save" />';
	 $('#confirm_msg').html('<spring:message code="message.msg148" />');

	$('#confirm_tlt').html(confirm_title);
	$('#pop_confirm_md').modal("show");
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmRst(){
	fn_save();
}

</script>

<%@include file="./../../popup/confirmForm.jsp"%>

<form name='isServerKeyEmpty' method='post' target='main' action='/securityKeySet.do'></form>

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
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ENCRYPT</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Settings"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Security_Policy_Option_Setting"/></p>
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave" onClick="fn_confirm();">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.save" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;;">	<spring:message code="encrypt_policyOption.Default_Option"/> </i>
						</div>
						
						<div class="card-body">
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="optionForm">
										<fieldset>													
											<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">					
												<div class="form-check"  style="margin-left: 20px;">
								                            <label class="form-check-label">
								                              <input type="checkbox" class="form-check-input" id="GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" name="GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" >
								                             <spring:message code="encrypt_policyOption.Grant_Access"/>	
								                            <i class="input-helper"></i></label>
								                 </div>					
											</div>																	
											<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">					
												<div class="form-check"  style="margin-left: 20px;">
								                            <label class="form-check-label">
								                              <input type="checkbox" class="form-check-input" id="GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" name="GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" >
								                             <spring:message code="encrypt_policyOption.Stop_Logging"/>
								                            <i class="input-helper"></i></label>
								                 </div>					
											</div>		
									</fieldset>
								</form>		
							 	</div>
						 	</div>
						</div>
					</div>
					
					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;">	<spring:message code="encrypt_policy_management.Log_Compression"/> </i>
						</div>
						
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
<form class="cmxform" id="compressForm">
											<fieldset>												
												<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">														
													<div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="GLOBAL_POLICY_BOOST_TF" name="GLOBAL_POLICY_BOOST_TF" >
									                             <spring:message code="encrypt_policyOption.Boost"/>
									                            <i class="input-helper"></i></label>
									                 </div>
												</div>																							
												<div class="form-group row" style="margin-bottom:10px;">
													<!-- 암복호화 로그 서버에서 압축시간 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 89px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Compression_time_in_the_log_server"/>
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION" name="GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION"   maxlength="3" min="0" value="0"/>														
													</div>
													<%-- <span>(<spring:message code="schedule.second" />)</span> --%>

													<!-- 암복호화 로그 AP에서 최대 압축값 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 32px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Maximum_Compression_value_in_the_log_AP"/> 
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT"   maxlength="3" min="0" value="0"/>														
													</div>
													
													<!-- 암복호화 로그 압축 시작값 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 32px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Start_value_of_log_compression"/>
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL"   maxlength="3" min="0" value="0"/>														
													</div>
												</div>	
												
																	
												<div class="form-group row" style="margin-bottom:10px;">
													<!-- 암복호화 로그 압축 출력시간 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 89px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Display_time_of_log_compression"/>
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD"   maxlength="3" min="0" value="0"/>														
													</div>
												
													<!-- 암복호화 로그 압축 중단 시간 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 32px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Stop_time_of_log_compression"/>
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT"   maxlength="3" min="0" value="0"/>														
													</div>
													<%-- <span>(<spring:message code="schedule.second" />)</span> --%>
													
													<!-- 암복호화 로그 전송 대기시간 -->
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index" style="margin-left: 32px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Wait_time_of_log_transmission"/>
													</label>
													<div class="col-sm-1">
														<input type="number" class="form-control form-control-xsm" id="logTransferWaitTime" name="logTransferWaitTime"   maxlength="3" min="0" value="0"/>														
													</div>										
												</div>		
	
										</fieldset>
									</form>		
							 	</div>
						 	</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;">	<spring:message code="encrypt_policyOption.Log_Batch_Transmission"/> </i>
						</div>
						
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
<form class="cmxform" id="transForm">
											<fieldset>																
												<div class="form-group row" style="margin-bottom:10px;margin-left: 55px;">					
													<div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="blnIsvalueTrueFalse" name="blnIsvalueTrueFalse"  onchange="fn_change()"/>
									                             <spring:message code="encrypt_policyOption.Collect_logs_only_at_specified_times"/>
									                            <i class="input-helper"></i></label>
									                 </div>					
												</div>																							
												<div class="form-group row" style="margin-bottom:10px;margin-left: 48px;">		
													<label for="ins_connect_nm" class="col-sm-13 col-form-label-sm pop-label-index" style="margin-left: 32px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policyOption.Transfer_Day"/>
													</label>													
													<div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label" for="sun" style="color: red;">
									                              <input type="checkbox" class="form-check-input" id="sun" name="sun" />
									                             <spring:message code="common.sun" />
									                            <i class="input-helper"></i></label>
									                 </div>											                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="mon" name="mon"  />
									                             <spring:message code="common.mon" />
									                            <i class="input-helper"></i></label>
									                 </div>									                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="tue" name="tue"  />
									                             <spring:message code="common.tue" />
									                            <i class="input-helper"></i></label>
									                 </div>									                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="wed" name="wed" />
									                            <spring:message code="common.wed" />
									                            <i class="input-helper"></i></label>
									                 </div>									                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="thu" name="thu"  />
									                             <spring:message code="common.thu" />
									                            <i class="input-helper"></i></label>
									                 </div>									                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              <input type="checkbox" class="form-check-input" id="fri" name="fri"  />
									                             <spring:message code="common.fri" />
									                            <i class="input-helper"></i></label>
									                 </div>									                 
									                 <div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label" for="sat" style="color: blue;">
									                              <input type="checkbox" class="form-check-input" id="sat" name="sat"  />
									                             <spring:message code="common.sat" />
									                            <i class="input-helper"></i></label>
									                 </div>     		
												</div>
																			
											<div class="form-group row" style="margin-bottom:10px; margin-left: 60px;">
												<div class="col-sm-1">
														<div id = "startHour"></div>													
												</div>		
												<div style="margin-top:15px;"><spring:message code="encrypt_policyOption.Start_Transfer"/></div>
												
												<div class="col-sm-1" style=" margin-left: 70px;">
														<div id = "endHour"></div>
												</div>											
												 <div style="margin-top:15px;"><spring:message code="encrypt_policyOption.End_Transfer"/> </div>
											</div>		
										</fieldset>
									</form>		
							 	</div>
						 	</div>
						</div>
					</div>

				</div>
			</div>
		</div>

		
		
	</div>
</div>	
	

