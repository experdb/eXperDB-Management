<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbServer.jsp
	* @Description : dbServer 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
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
var table = null;

function fn_init() {
	
		table = $('#serverList').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "dft_db_nm", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""}
		]
	});

	
}

$(window.document).ready(function() {
	fn_init();
	
  	$.ajax({
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
	}); 

});

$(function() {
	//조회버튼 클릭시
	$("#btnSelect").click(function() {
		$.ajax({
			url : "/selectDbServerList.do",
			data : {
				db_svr_nm : $("#db_svr_nm").val(),
				ipadr : $("#ipadr").val(),
				dft_db_nm : $("#dft_db_nm").val(),
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
});


function fn_reg_popup(){
	window.open("/popup/dbServerRegForm.do","dbServerRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=800,height=270,top=0,left=0");
}

</script>


</head>
<body>
 DB Server
 
 	<!--버튼 설정  -->
	 <table style="padding: 10px;" width="100%">
	 <tr>
	 	<td colspan="3">	 	 		
	 			<div id="button" style="float: right;">
	 				<input type="button" value="조회" id="btnSelect">
					<input type="button" value="등록" onClick="fn_reg_popup()">
					<input type="button" value="수정" id="btnUpdate">
					<input type="button" value="삭제" id="btnDelete">
				</div>
	 	</td>
	 </tr>
	 </table>
 	<!--/버튼 설정  -->
 	
 	
	<!-- 조회 조건 -->
	  <table style="border: 1px solid black; padding: 10px;" width="100%">
	  <tr>
	  	<td>
	 		◎서버명 <input type="text" name="db_svr_nm" id="db_svr_nm">
	 	</td>
	 	<td>
	 		◎아이피 <input type="text" name="ipadr" id="ipadr">
	 	</td>
	 	<td>
	 		◎Database <input type="text" name="dft_db_nm" id="dft_db_nm">
	 	</td>
	 </tr>
	 </table>
	 <!-- /조회 조건 -->
	 
	 <br><br>
	 
	 <!-- 메인 테이블 -->
	<table id="serverList" class="display" cellspacing="0" >
		<thead>
			<tr>
				<th></th>
				<th>No</th>
				<th>서버명</th>
				<th>아이피</th>
				<th>database</th>
				<th>포트</th>
				<th>User</th>
				<th>등록자</th>
				<th>등록일시</th>
				<th>수정자</th>
				<th>수정일시</th>
			</tr>
		</thead>
	</table>
	<!-- /메인 테이블 -->
</body>
</html>