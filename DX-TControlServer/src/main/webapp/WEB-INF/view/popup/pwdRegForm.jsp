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
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script>
	/*Validation*/
	function fn_pwdValidation() {
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
	function fn_update() {
		if (!fn_pwdValidation())
			return false;
		$.ajax({
			url : '/checkPwd.do',
			type : 'post',
			data : {
				nowpwd : $("#nowpwd").val()
			},
			success : function(result) {
				if (result) {
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
							alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
						}
					});
				} else {
					alert("현재 비밀번호가 틀렸습니다.");
				}

			},
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		});

	}
</script>

</head>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">패스워드 변경</p>
			<table class="write">
				<caption>패스워드 변경</caption>
				<colgroup>
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">현재 패스워드</th>
						<td><input type="password" class="txt" name="nowpwd"
							id="nowpwd" /></td>
					</tr>
				</tbody>
			</table>
			<div class="pop_cmm2">
				<table class="write">
					<caption>패스워드 변경</caption>
					<colgroup>
						<col style="width: 120px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">새 패스워드</th>
							<td><input type="password" class="txt" name="newpwd"
								id="newpwd" /></td>
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
				<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>
</body>
</html>