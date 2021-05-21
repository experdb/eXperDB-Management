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
	*  2018.01.04     최초 생성
	*  2020.08.06   변승우 과장		UI 디자인 변경	
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>

<script>
	var isServerKeyEmpty  = "${isServerKeyEmpty}";
	var isServerPasswordEmpty = "${isServerPasswordEmpty}";
	var resultCode = "${resultCode}";

	var pnlOldPasswordView ="";
	var pnlNewPasswordView ="";
	var mstKeyUseChk ="";
	var mstKeyRenewChk ="";
	var initKey="";

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		
		if(resultCode == "8000000002"){
			showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
		}else if(resultCode == "0000000003"){		
			showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
		}

		fn_buttonAut();

		if(isServerPasswordEmpty == "true") {
			initKey = true;
			$("#pnlOldPassword").hide();
			$("#pnlChangePassword").hide();
			$("#pnlNewPassword").show();
			
			pnlNewPasswordView = true;
			pnlOldPasswordView = false;
			$("#mstKeyUse").prop('checked', false);
			
		}else if(isServerPasswordEmpty == "false" && isServerKeyEmpty == "true") {
			initKey = false;
			$("#pnlOldPassword").show();
			$("#pnlChangePassword").hide();
			$("#pnlNewPassword").hide();
			pnlNewPasswordView = false;
			pnlOldPasswordView = true;		
			$("#mstKeyUse").attr('checked', true);
		} else {
			initKey = false;
			$("#pnlOldPassword").show();
			$("#pnlChangePassword").show();
			$("#pnlNewPassword").show();
			
			pnlNewPasswordView = true;
			pnlOldPasswordView = true;
			$("#mstKeyUse").attr('checked', true);
		}

		$("#mstKeyRenew").attr('checked', true);
	});

	function fn_buttonAut(){
		var btnSave = document.getElementById("btnSave"); 
		
		if("${wrt_aut_yn}" == "Y"){
			btnSave.style.display = '';
		}else{
			btnSave.style.display = 'none';
		}
	}

	function fn_mstKeyUse(){
		mstKeyUseChk = $("#mstKeyUse").prop("checked");

		if(mstKeyUseChk == true){
			$("#mstKeyPth").attr('disabled', false);
		}else{
			$("#mstKeyPth").attr('disabled', true);
		}
	}

	function fn_mstKeyRenew(){
		mstKeyRenewChk =  $("#mstKeyRenew").prop("checked");

		if(mstKeyRenewChk == true){
			pnlNewPasswordView = true;
			$("#pnlNewPassword").show();
		}else{
			pnlNewPasswordView = false;
			$("#pnlNewPassword").hide();
		}
	}

	function fn_validation(){
		mstKeyUseChk = $("#mstKeyUse").prop("checked");

		if(pnlOldPasswordView == true){
			//마스터키 파일 사용시
			if(mstKeyUseChk == true){
				var mstKeyPth = document.getElementById("mstKeyPth");
				if (mstKeyPth.value == "") {
					showSwalIcon('<spring:message code="encrypt_msg.msg04"/>', '<spring:message code="common.close" />', '', 'error');
					mstKeyPth.focus();
					return false;
				}
			}

			var mstKeyPassword = document.getElementById("mstKeyPassword");
			if (mstKeyPassword.value == "") {
				showSwalIcon('<spring:message code="message.msg129" />', '<spring:message code="common.close" />', '', 'error');
				mstKeyPassword.focus();
				return false;
			}

			if (mstKeyPassword.value.length < 8 ) {
				showSwalIcon('<spring:message code="encrypt_msg.msg05"/>', '<spring:message code="common.close" />', '', 'error');
				mstKeyPassword.focus();
				return false;
			}
		}

		if(pnlNewPasswordView == true){
			var mstKeyRenewPassword = document.getElementById("mstKeyRenewPassword");
			if (mstKeyRenewPassword.value == "") {
				showSwalIcon('<spring:message code="message.msg111" />', '<spring:message code="common.close" />', '', 'error');
				mstKeyRenewPassword.focus();
				return false;
			}

			var mstKeyRenewPasswordconfirm = document.getElementById("mstKeyRenewPasswordconfirm");
			if (mstKeyRenewPasswordconfirm.value == "") {
				showSwalIcon('<spring:message code="message.msg111" />', '<spring:message code="common.close" />', '', 'error');
				mstKeyRenewPasswordconfirm.focus();
				return false;
			}

			if (mstKeyRenewPassword.value.length < 8 ) {
				showSwalIcon('<spring:message code="encrypt_msg.msg05" />', '<spring:message code="common.close" />', '', 'error');
				mstKeyRenewPassword.focus();
				return false;
			}

			if($("#mstKeyRenewPassword").val() != $("#mstKeyRenewPasswordconfirm").val()){
				showSwalIcon('<spring:message code="message.msg112"/>', '<spring:message code="common.close" />', '', 'error');
				return false;
			}
		}
		return true;
	}

	function fn_save(){
		if (!fn_validation()) return false;

		mstKeyRenewChk =  $("#mstKeyRenew").prop("checked");
		mstKeyUseChk = $("#mstKeyUse").prop("checked");

		if(mstKeyRenewChk == true && pnlNewPasswordView == true) {
			if(mstKeyUseChk == true){
				var chk = true;
			}else{
				var chk = false;
			}

			//새로운 마스터키 파일 생성
			if($("#mstKeyMode").val() == "0000"){
				fn_newMasterKey("y",chk, initKey);
				//마스터키 사용안함
			}else{
				fn_newMasterKey("n",chk, initKey);
			}
		}else{
			if(pnlOldPasswordView == true){
				if(mstKeyUseChk == true){
					fn_keyFileLoadServerKey();
				}else{
					fn_noKeyFileLoadServerKey($("#mstKeyPassword").val());
				}
			}else if(pnlNewPasswordView == true){
				//마스터키 파일 없이 서버 로드
				fn_noKeyFileLoadServerKey($("#mstKeyRenewPassword").val());
			}
		}
	}

	function fn_keyFileLoadServerKey(){
		var formData = new FormData();

		formData.append("keyFile", $("input[name=keyFile]")[0].files[0]);
		formData.append("mstKeyPassword", $("input[name=mstKeyPassword]").val()); 

		$.ajax({
			url : "/securityMasterKeySave01.do", 
			data : formData,
			processData: false,
			contentType: false,
			dataType : "json",
			type : "post",
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
					showSwalIcon('<spring:message code="encrypt_msg.msg01"/>', '<spring:message code="common.close" />', '', 'success');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	function fn_noKeyFileLoadServerKey(keyPassword){
		$.ajax({
			url : "/securityMasterKeySave02.do", 
			data : {
				mstKeyPassword : keyPassword
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
					showSwalIcon('<spring:message code="encrypt_msg.msg01"/>', '<spring:message code="common.close" />', '', 'success');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	function fn_newMasterKey(useYN,chk,initKey){
		
		var formData = new FormData(); 

		formData.append("useYN", useYN);
		formData.append("chk", chk);

		formData.append("keyFile", $("input[name=keyFile]")[0].files[0])
		formData.append("mstKeyPassword", $("input[name=mstKeyRenewPassword]").val()); 
		formData.append("mstKeyRenewPassword", $("input[name=mstKeyRenewPasswordconfirm]").val()); 
		formData.append("initKey", initKey); 

		$.ajax({
			url : "/securityMasterKeySave03.do", 
			data : formData,
			processData: false,
			contentType: false,
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
					if(data.keyYN == "Y"){
						document.keyDownload.mstKey.value = data.masterKey;
						fn_mstKeyDownload();	
					}
					if(initKey == true){
						showSwalIcon('<spring:message code="encrypt_msg.msg01"/>', '<spring:message code="common.close" />', '', 'success');	
					}else{
						showSwalIcon('<spring:message code="encrypt_msg.msg02"/>', '<spring:message code="common.close" />', '', 'success');
					}
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	function fn_mstKeyDownload(){
		document.keyDownload.taget="mskKeyForm";
		document.keyDownload.submit();
	}
</script>

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
												<span class="menu-title"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ENCRYPT</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Settings"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Setting_the_server_master_key_password"/></p>
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave" onClick="fn_save();">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.save" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2"  id="pnlOldPassword">
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="baseForm">
										<fieldset>
											<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">
												<div class="form-check"  style="margin-left: 20px;">
													<label class="form-check-label">
														<input type="checkbox" class="form-check-input" id="mstKeyUse" name="mstKeyUse"   onClick="fn_mstKeyUse();" />
														<spring:message code="encrypt_serverMasterKey.Using_the_Master_Key_File"/>	
														<i class="input-helper"></i>
													</label>
												</div>
											</div>	
											
											<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-1_5 col-form-label-sm pop-label-index" style="margin-left: 75px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_serverMasterKey.Master_Key_Path"/>
													</label>
													
													<div class="col-sm-3">
														<input type="text" class="form-control"   id="mstKeyPth" name="mstKeyPth" />
													</div>			
													<div class="col-sm-1_5">
														<input class="btn btn-inverse-secondary btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onClick="document.getElementById('keyFile').click();" value='<spring:message code="encrypt_serverMasterKey.Browse"/>' />
														<input type="file"  class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect"  size="30" id="keyFile" name="keyFile" style="display:none;" onchange="document.getElementById('mstKeyPth').value=this.value;" />
													</div>
											</div>

											<div class="form-group row" style="margin-bottom:10px;">
												<label for="ins_connect_nm" class="col-sm-1_5 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_serverMasterKey.Password"/>
												</label>
												<div class="col-sm-3">
													<input type="password" class="form-control " id="mstKeyPassword" name="mstKeyPassword"  placeholder="<spring:message code="encrypt_msg.msg05"/>"/>
												</div>
											</div>
										</fieldset>
									</form>
							 	</div>
						 	</div>
						</div>
					</div>

					<div class="card my-sm-2" id="pnlChangePassword">
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="baseForm">
										<fieldset>
											<div class="form-group row" style="margin-bottom:-10px;margin-left: 50px;">
												<div class="form-check"  style="margin-left: 20px;">
													<label class="form-check-label">
														<input type="checkbox" class="form-check-input" id="mstKeyRenew" name="mstKeyRenew"   onClick="fn_mstKeyRenew();" />
														<spring:message code="encrypt_serverMasterKey.Server_master_key_update"/>
														<i class="input-helper"></i>
													</label>
												</div>
											</div>
										</fieldset>
									</form>
							 	</div>
						 	</div>
						</div>
					</div>

					<div class="card my-sm-2" id="pnlNewPassword">
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="baseForm">
										<fieldset>
											<div class="form-group row" style="margin-bottom:10px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_serverMasterKey.Master_key_file_mode"/>
												</label>
												<div class="col-sm-3">
													<select class="form-control " style="margin-right: 1rem;" name="mstKeyMode" id="mstKeyMode" >
														<option value="0000"><spring:message code="encrypt_serverMasterKey.New_master_key_file"/> </option>
														<option value="1111"><spring:message code="encrypt_serverMasterKey.Not_using_the_master_key_file"/> </option>
													</select>
												</div>
											</div>
											<div class="form-group row" style="margin-bottom:10px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_serverMasterKey.Password"/>
												</label>
												<div class="col-sm-3">
													<input type="password" class="form-control " id="mstKeyRenewPassword" name="mstKeyRenewPassword"    placeholder="<spring:message code="encrypt_msg.msg05"/>"/>
												</div>
											</div>
											<div class="form-group row" style="margin-bottom:10px;">
												<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index" style="margin-left: 75px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="encrypt_serverMasterKey.Confirm_Password"/>
												</label>
												<div class="col-sm-3">
													<input type="password" class="form-control " id="mstKeyRenewPasswordconfirm" name="mstKeyRenewPasswordconfirm"  placeholder="<spring:message code="encrypt_msg.msg05"/>"/>
												</div>
											</div>
										</fieldset>
									</form>
							 	</div>
						 	</div>
						</div>
					</div>
					
					<form name="keyDownload" method="post" target="mskKeyForm" action="/keyDownload.do">
						<input type="hidden" name="mstKey"  id="mstKey" >
					</form>
			
				</div>
			</div>
		</div>
	</div>
</div>