<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : pwdRegForm.jsp
	* @Description : pwdRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.20
	*
	*/
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>패스워드변경 팝업</title>
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
<script>
	/*Validation*/
	function fn_pwdValidation(){
		var nowpwd = document.getElementById("nowpwd");
		if (nowpwd.value == "") {
			   alert("현재 패스워드를 입력하여 주십시오.");
			   nowpwd.focus();
			   return false;
		}
		var newpwd = document.getElementById("newpwd");
		if (newpwd.value == "") {
			   alert("새 패스워드를 입력하여 주십시오.");
			   newpwd.focus();
			   return false;
		}
		var pwd = document.getElementById("pwd");
		if (pwd.value == "") {
			   alert("새 패스워드 확인를 입력하여 주십시오.");
			   pwd.focus();
			   return false;
		}
		if (newpwd.value != pwd.value) {
			alert("새 패스워드 정보가 일치하지 않습니다.");
			return false;
		}
		return true;
	}
	
	/*확인버튼 클릭시*/
	function fn_update(){
		if (!fn_pwdValidation()) return false;
		$.ajax({
			url : '/checkPwd.do',
			type : 'post',
			data : {
				nowpwd : $("#nowpwd").val()
			},
			success : function(result) {
				if(result){
					$.ajax({
						url : '/updatePwd.do',
						type : 'post',
						data : {
							pwd : $("#pwd").val()
						},
						success : function(result) {
							alert("저장하였습니다.");
							window.close();
						},
						error : function(request, status, error) {
							alert("실패");
						}
					});
				}
				else{
					alert("현재 비밀번호가 틀렸습니다.");
				}

			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
		
	}
</script>

</head>
<body>
	<h4>비밀번호변경</h4>
	<table border="1px solid #ccc" style="border-collapse: collapse;">
	<tr>
		<td>현재 패스워드</td>
		<td><input type="password" name="nowpwd" id="nowpwd"></td>
	</tr>
	<tr>
		<td>새 패스워드</td>
		<td><input type="password" name="newpwd" id="newpwd"></td>
	</tr>
	<tr>
		<td>새 패스워드 확인</td>
		<td><input type="password" name="pwd" id="pwd"></td>
	</tr>	
	</table>
	<br>
	<br>
	<div id="button" style="float: center;">
		<button onclick="fn_update()">확인</button>
		<button onclick="javascript:window.close();">취소</button>
	</div>
</body>
</html>