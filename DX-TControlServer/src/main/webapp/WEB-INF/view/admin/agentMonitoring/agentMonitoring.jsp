<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : agentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.30
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Agent 모니터링</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>
<script>
var table = null;

function fn_init() {
	table = $('#example').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		columns : [
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}, 
		 ]
	});
}

$(window.document).ready(function() {
	fn_init();
});
</script>
<body>
	<h2>Agent 모니터링</h2>
	<div id="button" style="margin-left: 95%;">
		<input type="button" value="조회">
	</div>
	<br>
	<table style="border: 1px solid black; padding: 10px;" width="100%">
		<tr>
			<td>DB서버명</td>
			<td><input type="text" id="search"></td>
		</tr>
	</table>
	<br>
	<table id="example" class="display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th>No</th>
				<th>DB서버</th>
				<th>Agent상태</th>
				<th>구동일시</th>
				<th>설치확인</th>
			</tr>
		</thead>
	</table>
</body>
</html>