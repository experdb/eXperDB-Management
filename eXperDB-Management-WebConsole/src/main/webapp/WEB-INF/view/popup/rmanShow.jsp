<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>" />

<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script> 
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>
var db_svr_id = ${db_svr_id};
var bck = "${bck}";
var table = null;

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#rmanShowList').DataTable({
	scrollY : "480px",
	scrollX : true,
	bDestroy: true,
	processing : true,
	searching : false,	
	bSort: false,
	columns : [
	{data : "START_TIME", className : "dt-center", defaultContent : ""}, 
	{data : "END_TIME", className : "dt-center", defaultContent : ""}, 
	{data : "MODE", className : "dt-center", defaultContent : ""}, 
	{data : "DATA", className : "dt-center", defaultContent : ""}, 
	{data : "ARCLOG", className : "dt-center", defaultContent : ""}, 
	{data : "SRVLOG", className : "dt-center", defaultContent : ""}, 
	{data : "TOTAL", className : "dt-center", defaultContent : ""}, 
	{data : "COMPRESSED", className : "dt-center", defaultContent : ""}, 
	{data : "CURTLI", className : "dt-center", defaultContent : ""}, 
	{data : "PARENTTLI", className : "dt-center", defaultContent : ""}, 
	{data : "STATUS", className : "dt-center", defaultContent : ""}
	]
	});
}


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	
	$.ajax({
		url : "/rmanShow.do", 
	  	data : {
	  		db_svr_id: db_svr_id,
	  		cmd : bck
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			table.clear().draw();
			table.rows.add(data).draw();
		}
	});
});

</script>

<div class="pop_container">
	<div class="pop_cts" style="height: 800px;">
		<p class="tit">
			RMAN 백업 정보
		</p>
		<div class="overflow_area" style="height: 600px;">
			<table id="rmanShowList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th scope="col">StartTime</th>
						<th scope="col">EndTime</th>
						<th scope="col">Mode</th>
						<th scope="col">Data</th>
						<th scope="col">ArcLog</th>
						<th scope="col">SrvLog</th>
						<th scope="col">Total</th>
						<th scope="col">Compressed</th>
						<th scope="col">CurTLI</th>
						<th scope="col">ParentTLI</th>
						<th scope="col">Status</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01"> </span> <a href="#n" class="btn" onclick="window.close();"><span>
			<spring:message code="common.close" /></span></a>
		</div>
	</div>
</div>

<div id="loading">
	<img src="/images/spin.gif" alt="" />
</div>
</html>