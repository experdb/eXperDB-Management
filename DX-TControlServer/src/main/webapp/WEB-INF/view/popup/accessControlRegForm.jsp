<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : accessControlRegForm.jsp
	* @Description : accessControlRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근제어 등록/수정 팝업</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
</head>
<script>
	/* Validation */
	function fn_accessControl(){
		var prms_ipadr = document.getElementById("prms_ipadr");
		if (prms_ipadr.value == "") {
			   alert("IP를 입력하여 주십시오.");
			   prms_ipadr.focus();
			   return false;
		}
		return true;
	}
	
	/* 등록 버튼 클릭시*/
	function fn_insert() {
		alert("등록");
		if (!fn_accessControl()) return false;
		$.ajax({
			url : "/insertAccessControl.do",
			data : {
				db_svr_id : $("#db_svr_id").val(),
				db_id : $("#db_id").val(),
				prms_ipadr : $("#prms_ipadr").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val(),
				cmd_cnts : $("#cmd_cnts").val(),
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
			}
		});
	}

	/* 수정 버튼 클릭시*/
	function fn_update() {
		alert("수정");
		if (!fn_accessControl()) return false;
		$.ajax({
			url : "/updateAccessControl.do",
			data : {
				db_svr_id : $("#db_svr_id").val(),
				db_id : $("#db_id").val(),
				prms_ipadr : $("#prms_ipadr").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val(),
				cmd_cnts : $("#cmd_cnts").val(),
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
			}
		});
	}
</script>
<body>
	<h3>
		<c:if test="${act == 'i'}">접근제어 등록</c:if>
		<c:if test="${act == 'u'}">접근제어 수정</c:if>
	</h3>
	
	<div style="border: 1px solid black; padding: 10px; margin-bottom: 15px;">
		DB 서버명 : <input type="text" readonly="readonly" id="db_svr_id" name="db_svr_id"> <br> 
		Database : <input type="text" readonly="readonly" id="db_id" name="db_id">
	</div>
	<div style="border: 1px solid black; padding: 10px;">
		<table>
			<tr>
				<td>◎ IP</td>
				<td><input type="text" id="prms_ipadr" name="prms_ipadr"></td>
				<td>◎ User</td>
				<td><input type="text" id="prms_usr_id" name="prms_usr_id"></td>
			</tr>
			<tr>
				<td>◎ Method</td>
				<td>
					<select id="ctf_mth_nm" name="ctf_mth_nm">
						<option value="trues">trues</option>
						<option value="reject">reject</option>
						<option value="md5">md5</option>
						<option value="password">password</option>
						<option value="Krb4">Krb4</option>
						<option value="krb5">krb5</option>
						<option value="ident">ident</option>
						<option value="pam">pam</option>
						<option value="ldap">ldap</option>
						<option value="gss">gss</option>
						<option value="Sspi">Sspi</option>
						<option value="cert">cert</option>
						<option value="crypt">crypt</option>
						<option value="radius">radius</option>
						<option value="peer">peer</option>
					</select>
				</td>
				<td>◎ Type</td>
				<td>
					<select id="ctf_tp_nm" name="ctf_tp_nm">
						<option value="local">local</option>
						<option value="host">host</option>
						<option value="hostssl">hostssl</option>
						<option value="hostnossl">hostnossl</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>◎ Option</td>
				<td><input type="text" id="opt_nm" name="opt_nm"></td>
			</tr>
			<tr>
				<td colspan="4"><textarea rows="5" cols="85" name="cmd_cnts" id="cmd_cnts"></textarea></td>
			</tr>
		</table>
		<div style="padding: 10px; text-align: center;">
			<c:if test="${act == 'i'}">
				<button type="button" onclick="fn_insert()">저장</button>
			</c:if>
			<c:if test="${act == 'u'}">
				<button type="button" onclick="fn_update()">저장</button>
			</c:if>
			<input type="button" value="취소" onclick="self.close()">
		</div>
	</div>
</body>
</html>