<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : userManagerForm.jsp
	* @Description : UserManagerForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자 정보 등록/수정</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/jquery-ui.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />

<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>

<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>

<!-- <script src="js/treeview/jquery.js" type="text/javascript"></script> -->
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>
<script>
	var check = 0;
	var act = "${act}";
	
	//등록버튼 클릭시
	function fn_insert() {
		var strid = document.getElementById('usr_id');
		var strnm = document.getElementById('usr_nm');
		var strpwd1 = document.getElementById('pwd1');
		var strpwd2 = document.getElementById('pwd2');

		if (strid.value == "" || strid.value == "undefind" || strid.value == null) {
			alert("사용자 아이디를 넣어주세요");
			strid.focus();
			return false;
		}
		if (strnm.value == "" || strnm.value == "undefind" || strnm.value == null) {
			alert("사용자명을 넣어주세요");
			strnm.focus();
			return false;
		}
		if (strpwd1.value == "" || strpwd1.value == "undefind" || strpwd1.value == null) {
			alert("패스워드를 넣어주세요");
			strpwd1.focus();
			return false;
		}
		if (strpwd2.value == "" || strpwd2.value == "undefind" || strpwd2.value == null) {
			alert("패스워드확인을 넣어주세요");
			strpwd2.focus();
			return false;
		}
		if (strpwd1.value != strpwd2.value) {
			alert("패스워드 정보가 일치하지 않습니다.");
			return false;
		}
		document.userForm.action = "<c:url value='/insertUserManager.do'/>";
		document.userForm.submit();
	}

	//수정버튼 클릭시
	function fn_update() {
		var strnm = document.getElementById('usr_nm');
		var strpwd1 = document.getElementById('pwd1');
		var strpwd2 = document.getElementById('pwd2');
		
		if (strnm.value == "" || strnm.value == "undefind" || strnm.value == null) {
			alert("사용자명을 넣어주세요");
			strnm.focus();
			return false;
		}
		if (strpwd1.value == "" || strpwd1.value == "undefind" || strpwd1.value == null) {
			alert("패스워드를 넣어주세요");
			strpwd1.focus();
			return false;
		}
		if (strpwd2.value == "" || strpwd2.value == "undefind" || strpwd2.value == null) {
			alert("패스워드확인을 넣어주세요");
			strpwd2.focus();
			return false;
		}
		if (strpwd1.value != strpwd2.value) {
			alert("패스워드 정보가 일치하지 않습니다.");
			return false;
		}
		
		document.userForm.action = "<c:url value='/updateUserManager.do'/>";
		document.userForm.submit();
	}
	
	//취소버튼 클릭시
	function fn_cancel() {
		document.location.href = "/userManager.do";
	}
	
	//아이디 중복체크
	function fn_idCheck() {
		check = 1;
		var usr_id = document.getElementById("usr_id");
		if (usr_id.value == "") {
			alert("사용자 아이디를 넣어주세요");
			document.getElementById('usr_id').focus();
			return;
		}
		$.ajax({
			url : '/UserManagerIdCheck.do',
			type : 'post',
			data : {
				usr_id : $("#usr_id").val()
			},
			success : function(result) {
				if (result == "true") {
					alert("사용자아이디를 사용하실 수 있습니다.");
					document.getElementById("usr_nm").focus();
				} else {
					alert("중복된값이 존재합니다.");
					document.getElementById("usr_id").focus();
				}
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}

	$(function() {
		window.onload = function() {
			if (act == "i") {
				document.getElementById("usr_id").focus();
				$("#usr_nm").attr("onfocus", "idcheck_alert();");
				$("#pwd1").attr("onfocus", "idcheck_alert();");
				$("#pwd2").attr("onfocus", "idcheck_alert();");
				$("#bln_nm").attr("onfocus", "idcheck_alert();");
				$("#dept_nm").attr("onfocus", "idcheck_alert();");
				$("#pst_nm").attr("onfocus", "idcheck_alert();");
				$("#rsp_bsn_nm").attr("onfocus", "idcheck_alert();");
				$("#cphno").attr("onfocus", "idcheck_alert();");
				$("#datepicker").attr("onfocus", "idcheck_alert();");
				$("#use_yn").attr("onfocus", "idcheck_alert();");
			}
		};
		$("#datepicker").datepicker({
			dateFormat : 'yymmdd'
		});
	});

	function idcheck_alert() {
		if (check != 1) {
			alert("아이디를 입력한 후 중복 체크를 해주세요");
			document.getElementById('usr_id').focus();
		}
	}

	$.datepicker.setDefaults({
		dateFormat : 'yy-mm-dd',
		prevText : '이전 달',
		nextText : '다음 달',
		monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월',
				'10월', '11월', '12월' ],
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월',
				'9월', '10월', '11월', '12월' ],
		dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
		showMonthAfterYear : true,
		yearSuffix : '년'
	});

	$(window.document).ready(function() {
		if (act == "u") {
			$("input[name=usr_id]").attr("readonly", true);
		}
	})
</script>
<body>
	<h2><c:if test="${act == 'i'}">사용자 등록</c:if><c:if test="${act == 'u'}">사용자 수정</c:if></h2>
	<form name="userForm" id="userForm" method="post">
			<table style="border: 1px solid black; padding: 10px;" width="100%">
				<tr>
					<td>사용자 아이디(*)</td>
					<td><input type="text" name="usr_id" id="usr_id" value="${get_usr_id}"> 
					<c:if test="${act == 'i'}"><button type="button" onclick="fn_idCheck()">중복체크</button></c:if>
					</td>
					<td>사용자명(*)</td>
					<td><input type="text" name="usr_nm" id="usr_nm" value="${usr_nm}"></td>
				</tr>
				<tr>
					<td>패스워드(*)</td>
					<td><input type="password" id="pwd1" value="${pwd}"></td>
					<td>패스워드확인(*)</td>
					<td><input type="password" name="pwd" id="pwd2" value="${pwd}"></td>
				</tr>
				<tr>
					<td>소속</td>
					<td><input type="text" name="bln_nm" id="bln_nm" value="${bln_nm}"></td>
					<td>부서</td>
					<td><input type="text" name="dept_nm" id="dept_nm" value="${dept_nm}"></td>
				</tr>
				<tr>
					<td>직급</td>
					<td><input type="text" name="pst_nm" id="pst_nm" value="${pst_nm}"></td>
					<td>담당업무</td>
					<td><input type="text" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}"></td>
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td><input type="text" name="cpn" id="cpn" value="${cpn}"></td>
					<td>권한구분</td> 
					<!-- 				<td><input type="text" name="aut_id" id="aut_id" value="${aut_id}"></td> -->
				</tr>
				<tr>
					<td>사용자만료일</td>
					<td><input type="text" id="datepicker" name="usr_expr_dt" value="${usr_expr_dt}"></td>
					<td>사용여부</td>
					<td><select id="use_yn" name="use_yn">
							<option value="Y" ${use_yn == 'Y' ? 'selected="selected"' : ''}>사용</option>
							<option value="N" ${use_yn == 'N' ? 'selected="selected"' : ''}>미사용</option>
					</select></td>
				</tr>
			</table>
		</form>
		<br> 
		<c:if test="${act == 'i'}"><button type="button" onclick="fn_insert()">등록</button></c:if> 
		<c:if test="${act == 'u'}"><button type="button" onclick="fn_update()">수정</button></c:if> 
		<button type="button" onclick="fn_cancel()">취소</button>
</body>
</html>