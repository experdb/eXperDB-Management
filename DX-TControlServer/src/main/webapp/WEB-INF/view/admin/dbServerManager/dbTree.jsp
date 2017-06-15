<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbTree.jsp
	* @Description : dbTree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.31
	*
	*/
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
<title>Insert title here</title>
<script>
var table_dbServer = null;
var table_db = null;

function fn_init() {
	
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "cpn", className : "dt-center", defaultContent : ""} 
		]
	});

	table_db = $('#dbList').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		columns : [
		{data : "cpn", className : "dt-center", defaultContent : ""}, 
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		
		]
	});
	
}

$(window.document).ready(function() {
	fn_init();
	
/*  	$.ajax({
		url : "/selectDbServerList.do",
		data : {},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); */ 

});
</script>
</head>
<body>
 DB Tree
 
<table style="border: 1px solid black; padding: 10px;" width="100%">
 	<tr>	
 		<td>
 			<!-- 서버 리스트 -->
 			DB Server 리스트		
 			<!--버튼 설정  -->
 			<div id="button" style="margin-left: 73%;">
				<input type="button" value="등록">
				<input type="button" value="수정" id="btnUpdate">
				<input type="button" value="삭제" id="btnDelete">
			</div>
			<table id="dbServerList" class="display" cellspacing="0" >
				<thead>
					<tr>
						<th></th>
						<th>DB 서버</th>
					</tr>
				</thead>
			</table>
 		</td>
 		<td>
 			<!-- 서버에 대한 Database 리스트 -->
 			Database 리스트
  			<!--버튼 설정  -->
 			<div id="button" style="margin-left: 73%;">
				<input type="button" value="저장">
			</div>			
			<table id="dbList" class="display" cellspacing="0" >
				<thead>
					<tr>
						<th>메뉴</th>
						<th>등록선택</th>
					</tr>
				</thead>
			</table>
 		</td>
 	</tr>
 </table>
</body>
</html>