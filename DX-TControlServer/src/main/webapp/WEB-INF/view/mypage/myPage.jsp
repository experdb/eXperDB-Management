<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : myPage.jsp
	* @Description : myPage 화면
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
<title>개인정보수정</title>
</head>
<script>
	/* 패스워드변경 버튼 클릭시*/
	function fn_pwdPopup() {
		window.open("/popup/pwdRegForm.do","pwdRegForm","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=500,height=300,top=0,left=0");
	}
	
	/* Validation */
	function fn_mypageValidation(){
		var usr_nm = document.getElementById("usr_nm");
		if (usr_nm.value == "") {
			   alert("사용자명을 입력하여 주십시오.");
			   usr_nm.focus();
			   return false;
		}
		return true;
	}
	
	/* 저장 버튼 클릭시*/
	function fn_update() {
		if (!fn_mypageValidation()) return false;
		
		$.ajax({
			url : '/updateMypage.do',
			type : 'post',
			data : {
				usr_id : $("#usr_id").val(),
				usr_nm : $("#usr_nm").val(),
				bln_nm : $("#bln_nm").val(),
				dept_nm : $("#dept_nm").val(),
				pst_nm : $("#pst_nm").val(),
				cpn : $("#cpn").val(),
				rsp_bsn_nm : $("#rsp_bsn_nm").val()
			},
			success : function(result) {
				alert("저장하였습니다.");
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
</script>
<body>
	<h2>개인정보수정</h2>
	<div id="button" style="float: right;">
		<button onclick="fn_update()">저장</button>
	</div>
	<br><br>
	<table border="1px solid #ccc" width="500px" style="border-collapse: collapse;">
		<tr>
			<td>사용자아이디</td>
			<td><input type="text" name="usr_id" id="usr_id" value="${usr_id}" readonly="readonly"></td>
		</tr>
		<tr>
			<td>사용자명(*)</td>
			<td><input type="text" name="usr_nm" id="usr_nm" value="${usr_nm}"></td>
		</tr>
		<tr>
			<td>패스워드(*)</td>
			<td><button type="button" onclick="fn_pwdPopup()">패스워드변경</button></td>
		</tr>
		<tr>
			<td>권한구분</td>
			<td><input type="text" name="aut_id" id="aut_id" value="${aut_id}" readonly="readonly"></td>
		</tr>
		<tr>
			<td>소속(*)</td>
			<td><input type="text" name="bln_nm" id="bln_nm" value="${bln_nm}"></td>
		</tr>
		<tr>
			<td>부서(*)</td>
			<td><input type="text" name="dept_nm" id="dept_nm" value="${dept_nm}"></td>
		</tr>
		<tr>
			<td>직급(*)</td>
			<td><input type="text" name="pst_nm" id="pst_nm" value="${pst_nm}"></td>
		</tr>
		<tr>
			<td>휴대폰번호(*)</td>
			<td><input type="text" name="cpn" id="cpn" value="${cpn}"></td>
		</tr>
		<tr>
			<td>담당업무(*)</td>
			<td><input type="text" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}"></td>
		</tr>
		<tr>
			<td>사용자만료일</td>
			<td><input type="text" name="usr_expr_dt" id="usr_expr_dt" value="${usr_expr_dt}" readonly="readonly"></td>
		</tr>
	</table>
</body>
</html>