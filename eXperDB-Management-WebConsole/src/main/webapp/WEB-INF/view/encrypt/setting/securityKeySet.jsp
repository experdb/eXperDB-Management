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

	if(isServerPasswordEmpty == true) {
			$("#pnlOldPassword").hide();
			$("#pnlChangePassword").hide();
			$("#pnlNewPassword").show();
			
			pnlNewPasswordView = true;
			pnlOldPasswordView = false;
		}else if(isServerPasswordEmpty == false && isServerKeyEmpty == true) {
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
		$("#pnlNewPassword").show();
	}else{
		$("#pnlNewPassword").hide();
	}	
}

function fn_save(){	
	mstKeyRenewChk =  $("#mstKeyRenew").prop("checked");
	mstKeyUseChk = $("#mstKeyUse").prop("checked");

	if(mstKeyRenewChk == true && pnlNewPasswordView == true) {
		if(mstKeyUseChk == true){
			var chk = true;
		}else{
			var chk = false;
		}
		
		if($("#mstKeyRenewPassword").val() != $("#mstKeyRenewPasswordconfirm").val()){
			alert("비밀번호가 일치하지 않습니다.");
			return false;
		}else{
			//새로운 마스터키 파일 생성
			if($("#mstKeyMode").val() == "0000"){
				fn_newMasterKey("y",chk);
			//마스터키 사용안함
			}else{
				fn_newMasterKey("n",chk);
			}
		}
		
	}else{		
		if(pnlOldPasswordView == true){
			//마스터키 파일 없이 서버 로드
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
	var form = $("#file_form")[0];
	var formData = new FormData(form); 

	formData.append("fileobj", $("#keyfile")[0].files[0]); 
	formData.append("mstKeyPassword", $("input[name=mstKeyPassword]").val()); 

	alert(formData);
	$.ajax({
		url : "/securityMasterKeySave01.do", 
	  	data : formData,
	  	processData: false,
        contentType: false,
		//dataType : "json",
		dataType: "text",
		type : "post",
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			alert("A");
			if(data.resultCode == "0000000000"){
				alert("서버 마스터키 암호가 입력되었습니다.");
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
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				alert("서버 마스터키 암호가 입력되었습니다.");
			}
		}
	});
}

function fn_newMasterKey(useYN,chk){
	$.ajax({
		url : "/securityMasterKeySave03.do", 
	  	data : {
	  		mstKeyPassword : $("#mstKeyPassword").val(),
	  		mstKeyRenewPassword : $("#mstKeyRenewPassword").val(),
	  		mstKeyPth : $("#mstKeyPth").val(),
	  		chk : chk,
	  		useYN : useYN  		
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				alert("서버 마스터키 암호가 변경되었습니다.");
			}
		}
	});	
}
</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>서버 마스터키 암호 입력<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>서버 마스터키 암호 입력</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>암호화</li>
					<li>설정</li>
					<li class="on">암서버 마스터키 암호 설정</li>
				</ul>
			</div>
		</div>

		<div class="contents">
		<form id="file_form" method="post" enctype="multipart/form-data" action="/securityMasterKeySave01.do">
			<div class="cmm_grp">
			<%-- <form class="securityKeySet" method="post" enctype="multipart/form-data"> --%>
				<div class="cmm_bd" id="pnlOldPassword">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 5px;" />
								<col style="width: 55px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="mstKeyUse" name="mstKeyUse" onClick="fn_mstKeyUse();"/> 
												<label for="mstKeyUse">마스터키 파일 사용</label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">마스터키 위치</th>
									<td>
										<input type="text" name="mstKeyPth" id="mstKeyPth" class="txt t9" />
										<span class="btn btnC_01"><button type="button" class= "btn_type_02"  style="width: 60px; margin-right: -60px; margin-top: 0;" onClick="document.getElementById('keyfile').click();">찾아보기</button></span>
										<input type="file" size="30" id="keyfile" style="display:none;" onchange="document.getElementById('mstKeyPth').value=this.value;" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호</th>
									<td>
										<input type="text" name="mstKeyPassword" id="mstKeyPassword" class="txt t2" />										
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
								<col style="width: 5px;" />
								<col style="width: 55px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="mstKeyRenew" name="mstKeyRenew"  onClick="fn_mstKeyRenew();"/> 
												<label for="mstKeyRenew">서버 마스터키 갱신</label>
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
								<col style="width: 5px;" />
								<col style="width: 55px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t2">마스터키 모드</th>
									<td>
										<select name="mstKeyMode" id="mstKeyMode"  class="select t5">
											<option value="0000">새로운 마스터키 파일</option>
											<option value="1111">마스터키 파일 사용안함</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호</th>
									<td>
										<input type="text" name="mstKeyRenewPassword" id="mstKeyRenewPassword" class="txt t2" />										
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호 확인</th>
									<td>
										<input type="text" name="mstKeyRenewPasswordconfirm" id="mstKeyRenewPasswordconfirm" class="txt t2" />										
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="btn_type_02">
					<a href="#n" class="btn" onClick="fn_save()"><span>저장</span></a> 
				</div>
				<%-- </form>	 --%>
			</div>
			</form>
		</div>
	</div>
</div>