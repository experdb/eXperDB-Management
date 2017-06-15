<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DX-Tcontrol Web v1.0</title>
<script type="text/javascript">

	function fn_login(){
			var strid = document.getElementById('usr_id').value;
			var strpw = document.getElementById('pwd').value; 
			 
			if (strid == "" || strid == "undefind" || strid == null)
			{
				alert("아이디를 넣어주세요");
				document.getElementById('usr_id').focus();
				return false;
			}
			if (strpw == "" || strpw == "undefind" || strpw == null){
					alert("비밀번호를 넣어주세요");
					document.getElementById('usr_id').focus();
					return false;
			}
	    	document.loginForm.action = "<c:url value='/login.do'/>";
	       	document.loginForm.submit();
		}


	$(window.document).ready(
			function() {				
				 document.getElementById("usr_id").focus();		
			});

</script>
<style>
@import url(https://fonts.googleapis.com/css?family=Roboto:300);

.login-page {
  width: 560px;
  padding: 10% 0 0;
  margin: auto;
}
.footer {
font-family: "Roboto", sans-serif;
font-size: 12px;
 position: relative;
 bottom:100px;
 left:150px;
 margin: auto;
 color: gray;
}

.form {
  position: relative;
  z-index: 1;
  background: #FFFFFF;
  max-width: 460px;
  margin: 0 auto 100px;
  padding: 45px;
  text-align: center;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}
.form input {
  font-family: "Roboto", sans-serif;
  outline: 0;
  background: #f2f2f2;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}
.form button {
  font-family: "Roboto", sans-serif;
  text-transform: uppercase;
  outline: 0;
  background: #0099FF;
  width: 100%;
  border: 0;
  padding: 15px;
  color: #FFFFFF;
  font-size: 14px;
  -webkit-transition: all 0.3 ease;
  transition: all 0.3 ease;
  cursor: pointer;
}
.form button:hover,.form button:active,.form button:focus {
  background: #0099FF;
}
.form .message {
  margin: 15px 0 0;
  color: #b3b3b3;
  font-size: 12px;
}
.form .message a {
  color: #4CAF50;
  text-decoration: none;
}
.form .register-form {
  display: none;
}
.container {
  position: relative;
  z-index: 1;
  max-width: 300px;
  margin: 0 auto;
}
.container:before, .container:after {
  content: "";
  display: block;
  clear: both;
}
.container .info {
  margin: 50px auto;
  text-align: center;
}
.container .info h1 {
  margin: 0 0 15px;
  padding: 0;
  font-size: 36px;
  font-weight: 300;
  color: #1a1a1a;
}
.container .info span {
  color: #4d4d4d;
  font-size: 12px;
}
.container .info span a {
  color: #000000;
  text-decoration: none;
}
.container .info span .fa {
  color: #EF3B3A;
}
body {
  background: white; /* fallback for old browsers */
  line-height:30px;
}
</style>
</head>
<body>
	<form name="loginForm" id="loginForm" method="post">
 		<div class="login-page">
			  <div class="form">
			    <img src="<c:url value='/images/egovframework/example/DX-Tcontrol_title.png'/>" alt="DX-TCONTROL" />
			    <br><br>
			      <input type="text" placeholder="id" id="usr_id"  name="usr_id" />
			      <input type="password" placeholder="password" id="pwd" name="pwd"/>
			      <button onClick="fn_login()">login</button>
			      <c:out value="${loginException.message}"/>
			  </div>
				<div class="footer">
				<br>
					<strong>Copyright (c) 2017 K4m Corp.  All rights reserved.</strong>
			  </div>
		</div>
	</form>
</body>
</html>