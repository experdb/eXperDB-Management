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
	* @Class Name : encryptRestore.jsp
	* @Description : encryptRestore 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.11.15      최초 생성
	*
	* author 신예은
	* since 2021. 11. 15
	*
	*/
%>


<script>

/* ********************************************************
 * 암호화 백업 화면 초기화
 ******************************************************** */
 $(window.document).ready(function() {
		fn_init();
 });

/* ********************************************************
 * init
 ******************************************************** */
 function fn_init(){
	 $("#chkEncryptKey").prop('checked', false);
	 $("#chkSecurityPolicy").prop('checked', false);
	 $("#chkServer").prop('checked', false);
	 $("#chkEXperDBUser").prop('checked', false);
	 $("#chkEncryptSetting").prop('checked', false);
	 $("#backupPassword").val("");
	 $("#backupFilePath").val("");

 }

 function fn_encryptRestoreValidate(){
	 console.log("restore validation");
	 if(fn_validation()){
		var formData = new FormData();
		 formData.append("backupFile", $("input[name=backupFile]")[0].files[0]);
		 formData.append("chkKey", $("#chkEncryptKey").is(":checked"));
		 formData.append("chkPolicy", $("#chkSecurityPolicy").is(":checked"));
		 formData.append("chkServer", $("#chkServer").is(":checked"));
		 formData.append("chkAdminUser", $("#chkEXperDBUser").is(":checked"));
		 formData.append("chkConfig", $("#chkEncryptSetting").is(":checked"));
		 formData.append("password", $("#backupPassword").val());

		 $.ajax({
			url : "/encryptFileValidation.do",
			data : formData,
			dataType : "json",
			type : "post",
			processData: false,
			contentType: false
		})
		.done(function(result){
			if(result.RESULT_CODE == "0000000000"){
				fn_encryptRestoreRun();
			}else{
				var err = result.RESULT_MESSAGE;
				showSwalIconRst(err, '<spring:message code="common.close" />', '', 'error');
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

		})


	 }

 }

 function fn_encryptRestoreRun(){
	 console.log("restore run");
	 if(fn_validation()){
		 var formData = new FormData();
		 formData.append("backupFile", $("input[name=backupFile]")[0].files[0]);
		 formData.append("chkKey", $("#chkEncryptKey").is(":checked"));
		 formData.append("chkPolicy", $("#chkSecurityPolicy").is(":checked"));
		 formData.append("chkServer", $("#chkServer").is(":checked"));
		 formData.append("chkAdminUser", $("#chkEXperDBUser").is(":checked"));
		 formData.append("chkConfig", $("#chkEncryptSetting").is(":checked"));
		 formData.append("password", $("#backupPassword").val());

		$.ajax({
			url : "/encryptRestoreRun.do",
			data : formData,
			dataType : "json",
			type : "post",
			processData: false,
			contentType: false
		})
		.done(function(result){
			if(result.RESULT_CODE == "0000000000"){
				showSwalIconRst('<spring:message code="encrypt_backupRestore.msg21"/>', '<spring:message code="common.close" />', '', 'success', 'top');
			}else{
				showSwalIconRst('<spring:message code="encrypt_backupRestore.msg22"/>' + '\n\n' + result.RESULT_MESSAGE, '<spring:message code="common.close" />', '', 'error');
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

		})
	 }

 }

 


 function fn_validation(){
	var backupCheck = 	$("#chkEncryptKey").is(":checked") ||
						$("#chkSecurityPolicy").is(":checked") ||
						$("#chkServer").is(":checked") ||
						$("#chkEXperDBUser").is(":checked") ||
						$("#chkEncryptSetting").is(":checked");
	
	var backupFilePath = document.getElementById("backupFilePath").value;
	console.log("backupFilePath : " + document.getElementById("backupFilePath"));
	var pwcheck = $("#backupPassword").val();
	if(backupFilePath == null || backupFilePath == ""){
		var errStr = '<spring:message code="encrypt_backupRestore.msg23"/>';
		showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(!backupCheck){
		var errStr = '<spring:message code="encrypt_backupRestore.msg24"/>';
		showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(pwcheck == null || pwcheck == ""){
		var errStr = '<spring:message code="encrypt_backupRestore.msg25"/>';
		showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		return true;
	}

 }


 function fn_encryptBackupFileDownload(){
	document.backupFileDownload.target="backupFileForm";
	document.backupFileDownload.submit();
 }
 
		
</script>

<form name="backupFileDownload" method="post" target="backupFileForm" action="/encryptBackupDownload.do">
	<input type="hidden" name="encryptBackupFile"  id="encryptBackupFile" >
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
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_backupRestore.msg03"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_backupRestore.msg01"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_backupRestore.msg03"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_backupRestore.msg29"/></p>
											<p class="mb-0"><spring:message code="encrypt_backupRestore.msg30"/></p>
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
					<div class="row" style="margin-top:-20px; margin-bottom: 20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnRun" onClick="fn_encryptRestoreValidate();">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="encrypt_backupRestore.msg26"/>
								</button>
							</div>
						</div>
					</div>
					<div class="card" style="padding-left: 50px; padding-top: 20px;">
						<div class="card-body">
							<div class="row">
								<div class="col-12">
									<form class="cmxform" id="backupForm">
										<fieldset>
											<div class="form-group row" style="margin-bottom:20px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_backupRestore.msg27"/>
												</label>
												
												<div class="col-sm-3">
													<input type="text" class="form-control"   id="backupFilePath" name="backupFilePath" />
												</div>			
												<div class="col-sm-1_5">
													<input class="btn btn-inverse-secondary btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onClick="document.getElementById('backupFile').click();" value='<spring:message code="encrypt_serverMasterKey.Browse"/>' />
													<input type="file"  class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect"  size="30" id="backupFile" name="backupFile" style="display:none;" onchange="document.getElementById('backupFilePath').value=this.value;" />
												</div>
											</div>
											<div class="form-group row" style="margin-bottom:20px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_backupRestore.msg28"/>
												</label>
												<div class="form-check" style="margin-left: 20px;">
													<label class="form-check-label" for="chkEncryptKey">
														<input type="checkbox" class="form-check-input" id="chkEncryptKey" name="chkEncryptKey" onclick=""/>
														<spring:message code="encrypt_backupRestore.msg12"/>
														<i class="input-helper"></i>
													</label>
												</div>
												<div class="form-check" style="margin-left: 70px;">
													<label class="form-check-label" for="chkSecurityPolicy">
														<input type="checkbox" class="form-check-input" id="chkSecurityPolicy" name="chkSecurityPolicy" onclick=""/>
														<spring:message code="encrypt_backupRestore.msg13"/>
														<i class="input-helper"></i>
													</label>
												</div>
												<div class="form-check" style="margin-left: 70px;">
													<label class="form-check-label" for="chkServer">
														<input type="checkbox" class="form-check-input" id="chkServer" name="chkServer" onclick=""/>
														<spring:message code="encrypt_backupRestore.msg14"/>
														<i class="input-helper"></i>
													</label>
												</div>
												<div class="form-check" style="margin-left: 70px;">
													<label class="form-check-label" for="chkEXperDBUser">
														<input type="checkbox" class="form-check-input" id="chkEXperDBUser" name="chkEXperDBUser" onclick=""/>
														<spring:message code="encrypt_backupRestore.msg15"/>
														<i class="input-helper"></i>
													</label>
												</div>
												<div class="form-check" style="margin-left: 70px;">
													<label class="form-check-label" for="chkEncryptSetting">
														<input type="checkbox" class="form-check-input" id="chkEncryptSetting" name="chkEncryptSetting" onclick=""/>
														<spring:message code="encrypt_backupRestore.msg16"/>
														<i class="input-helper"></i>
													</label>
												</div>
											</div>
											<div class="form-group row" style="margin-bottom:20px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_backupRestore.msg17"/>
												</label>
												<div class="col-sm-3">
													<input type="password" class="form-control " id="backupPassword" name="backupPassword" placeholder='<spring:message code="encrypt_backupRestore.msg25"/>'/>
												</div>
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