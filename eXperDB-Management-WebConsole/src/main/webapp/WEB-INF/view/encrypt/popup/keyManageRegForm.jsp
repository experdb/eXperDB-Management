<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : keyManageRegForm.jsp
	* @Description : keyManageRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.08
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>암복호화 키 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<script>
$(window.document).ready(function() {
	$.datepicker.setDefaults({		
		dateFormat : 'yy-mm-dd',
		 minDate: "+730d",
		changeYear: true,
	});
	$("#datepicker3").datepicker();
});

//한글 입력 방지
function fn_checkResourceName(e) {
	var objTarget = e.srcElement || e.target;
	if(objTarget.type == 'text') {
	var value = objTarget.value;
	if(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/.test(value)) {
		alert('<spring:message code="encrypt_msg.msg22"/>');
   		objTarget.value = objTarget.value.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
  		}
	 }
}

/*validation 체크*/
function fn_validation(){
	var resourcename = document.getElementById('ResourceName');
	var CipherAlgorithmCode = document.getElementById('CipherAlgorithmCode');
	var datepicker3 = document.getElementById('datepicker3');
	
	if (resourcename.value == "" || resourcename.value == "undefind" || resourcename.value == null) {
		alert('<spring:message code="encrypt_msg.msg17"/>');
		resourcename.focus();
		return false;
	}
	if (CipherAlgorithmCode.value == "" || CipherAlgorithmCode.value == "undefind" || CipherAlgorithmCode.value == null) {
		alert('<spring:message code="encrypt_msg.msg23"/>');
		return false;
	}
	if (datepicker3.value == "" || datepicker3.value == "undefind" || datepicker3.value == null) {
		alert('<spring:message code="encrypt_msg.msg24"/>');
		return false;
	}
	return true;
}


function fu_insertCryptoKeySymmetric(){
	if (!fn_validation()) return false;
	$.ajax({
		url : "/insertCryptoKeySymmetric.do", 
	  	data : {
	  		resourceName: $('#ResourceName').val(),
	  		cipherAlgorithmCode : $('#CipherAlgorithmCode').val(),
	  		resourceNote : $('#ResourceNote').val(),
	  		validEndDateTime : $('#datepicker3').val().substring(0,10)
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
				alert('<spring:message code="message.msg07" />')
				opener.location.reload();
				window.close();
			}else if(data.resultCode == "8000000002"){
				alert("<spring:message code='message.msg05' />");
				top.location.href = "/";
			}else if(data.resultCode == "8000000003"){
				alert(data.resultMessage);
				location.href = "/securityKeySet.do";
			}else{
				alert(data.resultMessage +"("+data.resultCode+")");	
			}			
		}
	});
}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="encrypt_policy_management.Encryption_Key"/> <spring:message code="common.registory" /></p>
				<table class="write">
					<caption><spring:message code="encrypt_policy_management.Encryption_Key"/> <spring:message code="common.registory" /></caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_key_management.Key_Name"/></th>
							<td><input type="text" class="txt" name="ResourceName" id="ResourceName" maxlength="20" onkeyup='fn_checkResourceName(event)' style='ime-mode:disabled;' onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_key_management.Encryption_Algorithm"/></th>
							<td>
								<select class="select t5" id="CipherAlgorithmCode" name="CipherAlgorithmCode">
										<option value="<c:out value=""/>" ><spring:message code="common.choice" /></option>
										<c:forEach var="result" items="${result}" varStatus="status">
											<option value="<c:out value="${result.sysCode}"/>"><c:out value="${result.sysCodeName}"/></option>
										</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_key_management.Description"/></th>
							<td><input type="text" class="txt" name="ResourceNote" id="ResourceNote" maxlength="100" onkeyup="fn_checkWord(this,100)" placeholder="100<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_key_management.Expiration_Date"/></th>
							<td>
								<div class="calendar_area big">
									<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker3"  readonly="readonly">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="fu_insertCryptoKeySymmetric();"><span><spring:message code="common.save"/></span></a> 
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
			</div>
		</div>
	</div>
</body>
</html>