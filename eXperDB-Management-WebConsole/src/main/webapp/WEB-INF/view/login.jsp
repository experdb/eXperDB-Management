<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<script type="text/javascript">
	
function fn_login(){
	var strid = document.getElementById('usr_id').value;
	var strpw = document.getElementById('pwd').value; 
	 
	if (strid == "" || strid == "undefind" || strid == null)
	{
		alert('<spring:message code="message.msg128" />');
		document.getElementById('usr_id').focus();
		return false;
	}
	if (strpw == "" || strpw == "undefind" || strpw == null){
			alert('<spring:message code="message.msg129" />');
			document.getElementById('usr_id').focus();
			return false;
	}
	document.loginForm.action = "<c:url value='/login.do'/>";
   	document.loginForm.submit();
}


$(window.document).ready(function() {				
		 document.getElementById("usr_id").focus();	
	});
	
</script>
</head>
<body class="bg">
	<form name="loginForm" id="loginForm" method="post">
	<div id="login_wrap">
		<div class="inr">
			<div class="logo"><img src="../images/login_logo.png" alt="eXperDB"></div>
			<div class="inp_bx">
				<p class="tit">MEMBER LOGIN</p>
				<div class="inp_wrap t1">
					<label for="member_id"><spring:message code="user_management.id" /></label>
					<input type="text" class="txt" id="usr_id" name="usr_id" maxlength="" placeholder='<spring:message code="message.msg128" />'/>
				</div>
				<div class="inp_wrap t2">
					<label for="member_pwd"><spring:message code="user_management.password" /></label>
					<input type="password" class="txt" id="pwd" name="pwd" maxlength="" placeholder='<spring:message code="message.msg129" />'/>
				</div>
				<div class="inp_wrap t2" id="errormessage">
				<c:if test="${not empty error}">
				  	<c:choose>
				       <c:when test="${error == 'msg156'}">
				           <spring:message code="message.msg156" />
				       </c:when>
				       <c:when test="${error == 'msg157'}">
				           <spring:message code="message.msg157" />
				       </c:when>
				       <c:when test="${error == 'msg158'}">
				           <spring:message code="message.msg158" />
				       </c:when>
				       <c:when test="${error == 'msg159'}">
				           <spring:message code="message.msg159" />
				       </c:when>
				       <c:when test="${error == 'msg176'}">
				          서버 HA구성에서 Master 가 중복 됩니다.
				       </c:when>
					</c:choose>		
				</c:if></div>	
				<div class="btn_wrap">
					<button onClick="fn_login()">LOGIN</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>