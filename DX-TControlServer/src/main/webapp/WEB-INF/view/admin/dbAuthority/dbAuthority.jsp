<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbAuthority.jsp
	* @Description : DbAuthority 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.29     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.29
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DB권한관리</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<!-- 체크박스css -->
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<!-- 체크박스js -->
<script src="js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>
<style>
</style>
<script>
	var userTable = null;
	var dbTable = null;
	var dbServerTable = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			processing : true,
			searching : true,
			paging : false,
			columns : [ 
			            {data : "rownum",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_id",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_nm",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
		dbServerTable = $('#dbserver').DataTable({
			processing : true,
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
		dbTable = $('#db').DataTable({
			processing : true,
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
	}

	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectUserManager.do",
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				userTable.clear().draw();
				userTable.rows.add(result).draw();
			}
		});

	});
</script>
<body>
	<h2>DB권한관리</h2>
	<table width="100%">
		<tr>
			<td width="50%" style="height: 20px;"><h2>사용자선택</h2></td>
			<td width="50%" style="height: 20px;"><h2>DB서버권한</h2></td>
		</tr>
		<tr>
			<td rowspan="3">
				<table id="user" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>No</th>
							<th>아이디</th>
							<th>사용자명</th>
						</tr>
					</thead>
				</table>
			</td>
			<td>
				<table id="dbserver" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>메뉴</th>
							<th>권한</th>
						</tr>
					</thead>
				</table>
			</td>
		</tr>
		<tr>
			<td style="height: 20px;"><h2>DB권한</h2></td>
		</tr>
		<tr>
			<td>
				<table id="db" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>메뉴</th>
							<th>권한</th>
						</tr>
					</thead>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>