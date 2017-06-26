<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : serverAccessControl.jsp
	* @Description : serverAccessControl 화면
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
<title>서버접근제어</title>
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
<script>
	var table = null;

	function fn_init() {
		table = $('#accessControlTable').DataTable({
			scrollY : "300px",
			searching : false,
			columns : [
				{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}
			 ]
		});
	}

	$(window.document).ready(function() {
		fn_init();
			
 		$.ajax({
			url : "/selectAccessControl.do",
			data : {
			},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		}); 
	
	});
	
	/* 조회 버튼 클릭시*/
	function fn_select() {
		
	}
	
	/* 등록 버튼 클릭시*/
	function fn_insert() {
		window.open("/popup/accessControlRegForm.do?act=i","accessControlRegForm","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=600,height=400,top=0,left=0");
	}
	
	/* 수정 버튼 클릭시*/
	function fn_update() {
		window.open("/popup/accessControlRegForm.do?act=u","accessControlRegForm","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=600,height=400,top=0,left=0");
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		
	}
	
	
</script>
<body>
	<h2>서버접근제어</h2>
	<div style="overflow: scroll; overflow-x: hidden; width: 30%; height: 500px; padding: 5px; float: left; margin-right: 50px;">
		<h3>DB서버</h3>
	</div>
	<div style="overflow: scroll; overflow-x: hidden; width: 60%; height: 500px; padding: 5px; float: left;">
		<h3>접근제어리스트</h3>
		<div id="search" style="float: left; ">
			<input type="text" >	
		</div>
		<div id="button" style="float: right;">
			<button onclick="fn_select()">조회</button>
			<button onclick="fn_insert()">등록</button>
			<button onclick="fn_update()">수정</button>
			<button onclick="fn_delete()">삭제</button>
		</div>
		<table id="accessControlTable" class="display" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th></th>
					<th>No</th>
					<th>User</th>
					<th>IP Address</th>
					<th>Method</th>
					<th>Option</th>
					<th>Type</th>
				</tr>
			</thead>
		</table>
	</div>
		
</body>
</html>