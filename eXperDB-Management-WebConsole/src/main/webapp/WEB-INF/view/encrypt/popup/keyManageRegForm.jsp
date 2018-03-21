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

function fu_insertCryptoKeySymmetric(){
	
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
				alert("등록되었습니다.")
				opener.location.reload();
				window.close();
			}else if(data.resultCode == "8000000003"){
				alert(data.resultMessage);
				location.href = "/securityKeySet.do";
			}else{
				alert("resultCode : " + data.resultCode + " resultMessage : " + data.resultMessage);			
			}			
		}
	});
}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">암호화 키 등록</p>
				<table class="write">
					<caption>암호화 키 등록</caption>
					<colgroup>
						<col style="width: 130px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">암호화 키 이름</th>
							<td><input type="text" class="txt" name="ResourceName" id="ResourceName" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">적용 알고리즘</th>
							<td>
								<select class="select t5" id="CipherAlgorithmCode" name="CipherAlgorithmCode">
										<option value="<c:out value=""/>" ><c:out value="선택"/></option>
										<c:forEach var="result" items="${result}" varStatus="status">
											<option value="<c:out value="${result.sysCode}"/>"><c:out value="${result.sysCodeName}"/></option>
										</c:forEach> 
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">암호화 키 설명</th>
							<td><input type="text" class="txt" name="ResourceNote" id="ResourceNote" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">유효기간 만료일</th>
							<td>
								<div class="calendar_area big">
									<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker3"  readonly="readonly">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="fu_insertCryptoKeySymmetric();"><span>저장</span></a> 
				<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>
</body>
</html>