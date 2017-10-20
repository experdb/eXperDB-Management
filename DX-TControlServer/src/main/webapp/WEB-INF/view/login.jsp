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
	
	function fn_validation() {
		var strid = document.getElementById('usr_id');
		var strpw = document.getElementById('pwd');

		if (strid.value == "" || strid.value == "undefind" || strid.value == null) {
			alert("아이디를 넣어주세요");
			strid.focus();
			return false;
		}
		if (strpw.value == "" || strpw.value == "undefind" || strpw.value == null) {
			alert("비밀번호를 넣어주세요");
			strpw.focus();
			return false;
		}
		return true;
	}

	$(window.document).ready(function() {
		document.getElementById("usr_id").focus();
	});
	
	function fn_login() {
		if (!fn_validation())return false;
		$.ajax({
			url : "/login.do",
			data : {
				usr_id : $("#usr_id").val(),
				pwd : $("#pwd").val()
			},
			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				var html ="";
				if(result == "idFail"){
					html += '<p>등록되지 않은 사용자 입니다.<br>관리자에게 문의 하여주십시오.</p>';
				}else if(result == "passwordFail"){
					html += '<p>아이디나 비밀번호가 잘못되었습니다.</p>';
				}else if(result == "useynFail"){
					html += '<p>사용할 수 없는 아이디 입니다.</p>';
				}else if(result=="usrexprdtFail"){
					html += '<p>사용 만료된 아이디 입니다.</p>';
				}else if(result == "loginSuccess"){
					 location.href = "/index.do";
				}else{
					 location.href ="/";
				}
				$("#errormessage").empty();
				$("#errormessage").append(html);
			}
		});
	}
	
	function onKeyDown()
	{
	     if(event.keyCode == 13)
	     {
	    	 fn_login();
	     }
	}


</script>

</head>

<body class="bg">
		<div id="login_wrap">
			<div class="inr">
				<div class="logo">
					<img src="../images/login_logo.png" alt="eXperDB">
				</div>
				<div class="inp_bx">
					<p class="tit">MEMBER LOGIN</p>
					<div class="inp_wrap t1">
						<label for="member_id">ID</label> 
						<input type="text" class="txt" id="usr_id" name="usr_id" title="아이디 입력" maxlength="" placeholder="아이디를 입력하세요."  onKeyDown="onKeyDown();"/>
					</div>
					<div class="inp_wrap t2">
						<label for="member_pwd">Password</label> <input type="password" class="txt" id="pwd" name="pwd" title="비밀번호 입력" maxlength="" placeholder="비밀번호를 입력하세요."  onKeyDown="onKeyDown();"/>
					</div>	
					<div class="inp_wrap t2" id="errormessage">
					</div>			
					<div class="btn_wrap" >
						<button onClick="fn_login()">LOGIN</button>
					</div>
				</div>
			</div>
		</div>
</body>
</html>