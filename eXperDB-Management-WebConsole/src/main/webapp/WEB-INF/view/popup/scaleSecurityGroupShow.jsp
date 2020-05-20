<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="shortcut icon" href="<c:url value='/css/images/logo.ico'/>"  type="image/x-icon" />
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
	var scale_id = "${scale_id}";
	var table = null;
	
	/* ********************************************************
	 * 리스트 setting
	 ******************************************************** */
	function fn_init(){
		table = $('#securityDataTable').DataTable({
			scrollY : "200px",
			scrollX : true,
			paging: false,
			bDestroy: true,
			bSort: false,
			processing : true,
			deferRender : true,
			searching : false,	
			paging: false,
			columns : [
				{data : "security_group_id", className : "dt-left",  defaultContent : ""}, 
				{data : "security_group_nm", className : "dt-left",  defaultContent : ""}
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '120px');

		$(window).trigger('resize'); 
	}

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_init();
		var table = $('#securityDataTable').DataTable();
		
/*  		$.ajax({
			url : "/scale/securityGroupList.do", 
		  	data : {
		  		db_svr_id: db_svr_id,
		  		scale_id : scale_id
		  	},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.rows({selected: true}).deselect();
				table.clear().draw();
				table.rows.add(result.data).draw();
			}
		}); */
	});
</script>

<div class="pop_container">
	<div class="pop_cts" style="min-width:520px;height: 500px;">
 		<p class="tit">
			<spring:message code='menu.scale_security_grp_info' />
		</p>

		<div class="overflow_area" style="height: 300px;">
			<table id="securityDataTable" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th scope="col"><spring:message code='eXperDB_scale.security_group_id' /></th>
						<th scope="col"><spring:message code='eXperDB_scale.security_group_name' /></th>
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
</html>