<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script>
	/* PW Validation*/
	function fn_pwValidation(str){
		 var reg_pwd = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
		 if(!reg_pwd.test(str)){
		 	alert('<spring:message code="message.msg109" />');
		 	return false;
		 }
		 return true;
	}

	/*확인버튼 클릭시*/
	function fn_update() {
		var nowpwd = document.getElementById("nowpwd");
		var newpwd = document.getElementById("newpwd");
		var pwd = document.getElementById("pwd");
		if (nowpwd.value == "") {
			alert('<spring:message code="message.msg110" />');
			nowpwd.focus();
			return false;
		}

		$.ajax({
			url : '/checkPwd.do',
			type : 'post',
			data : {
				nowpwd : $("#nowpwd").val()
			},
			success : function(result) {
				if (result) {
					if (newpwd.value == "") {
						alert('<spring:message code="message.msg111" />');
						newpwd.focus();
						return false;
					}
					if (!fn_pwValidation(newpwd.value))return false;
					
					if (pwd.value == "") {
						alert("새 패스워드 확인를 입력하여 주십시오.");
						pwd.focus();
						return false;
					}
					if (!fn_pwValidation(pwd.value))return false;
					
					if (newpwd.value != pwd.value) {
						alert('<spring:message code="message.msg112" />');
						return false;
					}
					
					if(nowpwd.value == newpwd.value){
						alert("현재 패스워드와 동일한 패스워드로는 변경하실 수 없습니다.");
						return false;
					}
					
					$.ajax({
						url : '/updatePwd.do',
						type : 'post',
						data : {
							pwd : $("#pwd").val()
						},
						success : function(result) {
							alert('<spring:message code="message.msg57" /> ');
							window.close();
						},
						beforeSend: function(xhr) {
					        xhr.setRequestHeader("AJAX", true);
					     },
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								alert('<spring:message code="message.msg02" />');
								 location.href = "/";
							} else if(xhr.status == 403) {
								alert('<spring:message code="message.msg03" />');
					             location.href = "/";
							} else {
								alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
							}
						}
					});
				} else {
					alert('<spring:message code="message.msg114" />');
				}

			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});

	}
</script>

</head>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="user_management.edit_password" /></p>
			<table class="write">
				<caption><spring:message code="user_management.edit_password" /></caption>
				<colgroup>
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">현재 패스워드</th>
						<td><input type="password" class="txt" name="nowpwd" id="nowpwd" /></td>
					</tr>
				</tbody>
			</table>
			<div class="pop_cmm2">
				<table class="write">
					<caption><spring:message code="user_management.edit_password" /></caption>
					<colgroup>
						<col style="width: 120px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">새 패스워드</th>
							<td><input type="password" class="txt" name="newpwd" id="newpwd" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">새 패스워드 확인</th>
							<td><input type="password" class="txt" name="pwd" id="pwd" /></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01"><button onclick="fn_update()">저장</button></span>
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
			</div>
		</div>
	</div>
</body>
</html>