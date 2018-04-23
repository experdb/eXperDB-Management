<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>

<%
	/**
	* @Class Name : securityPolicyOptionSet.jsp
	* @Description : securityPolicyOptionSet 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>

<style>
#ifram_hidden
{
width:1px;
height:1px;
border:0;
}
</style>

<script>
var isServerKeyEmpty  = "${isServerKeyEmpty}";
var isServerPasswordEmpty = "${isServerPasswordEmpty}";

var pnlOldPasswordView ="";
var pnlNewPasswordView ="";
var mstKeyUseChk ="";
var mstKeyRenewChk ="";
/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_buttonAut();
	if(isServerPasswordEmpty == "true") {
			$("#pnlOldPassword").hide();
			$("#pnlChangePassword").hide();
			$("#pnlNewPassword").show();
			
			pnlNewPasswordView = true;
			pnlOldPasswordView = false;
		}else if(isServerPasswordEmpty == "false" && isServerKeyEmpty == "true") {
			$("#pnlOldPassword").show();
			$("#pnlChangePassword").hide();
			$("#pnlNewPassword").hide();
			pnlNewPasswordView = false;
			pnlOldPasswordView = true;			
		} else {
			$("#pnlOldPassword").show();
			$("#pnlChangePassword").show();
			$("#pnlNewPassword").show();
			
			pnlNewPasswordView = true;
			pnlOldPasswordView = true;
		}
	
	$("#mstKeyUse").attr('checked', true);
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
				   alert('<spring:message code="encrypt_msg.msg04"/>');
				   mstKeyPth.focus();
				   return false;
			}			
		}		
			var mstKeyPassword = document.getElementById("mstKeyPassword");
			if (mstKeyPassword.value == "") {
				   alert('<spring:message code="message.msg129" />');
				   mstKeyPassword.focus();
				   return false;
			}			
			if (mstKeyPassword.value.length < 8 ) {
				   alert('<spring:message code="encrypt_msg.msg05" />');
				   mstKeyPassword.focus();
				   return false;
			}
			
	}
	

	if(pnlNewPasswordView == true){
		var mstKeyRenewPassword = document.getElementById("mstKeyRenewPassword");
		if (mstKeyRenewPassword.value == "") {
			   alert('<spring:message code="message.msg111" />');
			   mstKeyRenewPassword.focus();
			   return false;
		}
		var mstKeyRenewPasswordconfirm = document.getElementById("mstKeyRenewPasswordconfirm");
		if (mstKeyRenewPasswordconfirm.value == "") {
			   alert('<spring:message code="message.msg111" />');
			   mstKeyRenewPasswordconfirm.focus();
			   return false;
		}
		
		if (mstKeyRenewPassword.value.length < 8 ) {
			   alert('<spring:message code="encrypt_msg.msg05" />');
			   mstKeyRenewPassword.focus();
			   return false;
		}
		
		if($("#mstKeyRenewPassword").val() != $("#mstKeyRenewPasswordconfirm").val()){
			alert('<spring:message code="message.msg112" />');
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
				fn_newMasterKey("y",chk);
			//마스터키 사용안함
			}else{
				fn_newMasterKey("n",chk);
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
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				alert('<spring:message code="encrypt_msg.msg01"/>');
			}else{
				alert(data.resultMessage +"("+data.resultCode+")");
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
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				alert('<spring:message code="encrypt_msg.msg01"/>');
			}
		}
	});
}

function fn_newMasterKey(useYN,chk){
	var formData = new FormData(); 

	formData.append("useYN", useYN);
	formData.append("chk", chk);
	
	formData.append("keyFile", $("input[name=keyFile]")[0].files[0])
	formData.append("mstKeyPassword", $("input[name=mstKeyPassword]").val()); 
	formData.append("mstKeyRenewPassword", $("input[name=mstKeyRenewPassword]").val()); 
	
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
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				document.keyDownload.mstKey.value = data.masterKey;
				fn_mstKeyDownload();	
				alert('<spring:message code="encrypt_msg.msg02"/>');
			}
		}
	});	
}


function fn_mstKeyDownload(){
	document.keyDownload.taget="mskKeyForm";
	document.keyDownload.submit();
}
</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="encrypt_help.Setting_the_server_master_key_password"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policyOption.Settings"/></li>
					<li class="on"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></li>
				</ul>
			</div>
		</div>

		<div class="contents">
		<form id="masterKey" method="post" enctype="multipart/form-data" action="">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<a href="#n" class="btn" onClick="fn_save()"><span id="btnSave"><spring:message code="common.save"/></span></a> 
				</div>
			<%-- <form class="securityKeySet" method="post" enctype="multipart/form-data"> --%>
				<div class="cmm_bd" id="pnlOldPassword">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 15%" />
								<col style="width: 60%" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="mstKeyUse" name="mstKeyUse" onClick="fn_mstKeyUse();" /> 
												<label for="mstKeyUse"><spring:message code="encrypt_serverMasterKey.Using_the_Master_Key_File"/></label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_serverMasterKey.Master_Key_Path"/></th>
									<td>
										<input type="text" name="mstKeyPth" id="mstKeyPth" class="txt t9" />
										<span class="btn btnC_01"><button type="button" class= "btn_type_02"  style="width: 60px; margin-right: -60px; margin-top: 0;" onClick="document.getElementById('keyFile').click();"><spring:message code="encrypt_serverMasterKey.Browse"/></button></span>
										<input type="file" size="30" id="keyFile" name="keyFile" style="display:none;" onchange="document.getElementById('mstKeyPth').value=this.value;" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_serverMasterKey.Password"/></th>
									<td>
										<input type="password" name="mstKeyPassword" id="mstKeyPassword" class="txt t2"  placeholder="<spring:message code="encrypt_msg.msg05"/>"/>										
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				
				<div class="cmm_bd" style="margin-top: 20px;" id="pnlChangePassword">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 100%;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="mstKeyRenew" name="mstKeyRenew"  onClick="fn_mstKeyRenew();"/> 
												<label for="mstKeyRenew"><spring:message code="encrypt_serverMasterKey.Server_master_key_update"/></label>
											</span>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				
				<div class="cmm_bd" style="margin-top: 5px;" id="pnlNewPassword">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 15%" />
								<col style="width: 85%;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_serverMasterKey.Master_key_file_mode"/></th>
									<td>
										<select name="mstKeyMode" id="mstKeyMode"  class="select t5">
											<option value="0000"><spring:message code="encrypt_serverMasterKey.New_master_key_file"/> </option>
											<option value="1111"><spring:message code="encrypt_serverMasterKey.Not_using_the_master_key_file"/> </option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_serverMasterKey.Password"/></th>
									<td>
										<input type="password" name="mstKeyRenewPassword" id="mstKeyRenewPassword" class="txt t2" placeholder="<spring:message code="encrypt_msg.msg05"/>"/>										
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_serverMasterKey.Confirm_Password"/></th>
									<td>
										<input type="password" name="mstKeyRenewPasswordconfirm" id="mstKeyRenewPasswordconfirm" class="txt t2"  placeholder="<spring:message code="encrypt_msg.msg05"/>"/>										
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<%-- </form>	 --%>
			</div>
			</form>
			
			<iframe id="ifram_hidden" name="mskKeyForm"></iframe>
			<form name="keyDownload" method="post" target="mskKeyForm" action="/keyDownload.do">
				<input type="hidden" name="mstKey"  id="mstKey" >
			</form>
		</div>
	</div>
</div>