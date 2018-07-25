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
<link rel="shortcut icon" href="<c:url value='/css//images/logo.ico'/>"  type="image/x-icon" />
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
	scrollY : "450px",
	scrollX : true,
	bDestroy: true,
	processing : true,
	searching : false,	
	bSort: false,
	columns : [
	{data : "START_TIME",  defaultContent : "", 
		"render": function (data, type, full) {		
			var html = full.START_DATE+' '+full.START_TIME ;
				return html;
				return data;
		}		
	}, 
	{data : "END_TIME",  defaultContent : "", 
		"render": function (data, type, full) {		
			var html = full.END_DATE+' '+full.END_TIME ;
				return html;
				return data;
		}		
	},
	{data : "MODE",  defaultContent : "", 
		"render": function (data, type, full) {		
			var html = '';
			if (full.MODE == 'FULL') {
					html += '<spring:message code="backup_management.full_backup"/>';
				} else if(full.MODE == 'ARCH'){
					html += '<spring:message code="backup_management.change_log_backup"/>';
				} else {
					html +='<spring:message code="backup_management.incremental_backup"/>';
				}
				return html;
		}
	}, 
	{data : "DATA", className : "dt-right",  defaultContent : ""}, 
	{data : "ARCLOG", className : "dt-right",  defaultContent : ""}, 
	{data : "SRVLOG",className : "dt-right" ,  defaultContent : ""}, 
	{data : "TOTAL", className : "dt-right",  defaultContent : ""}, 
	{data : "COMPRESSED",  defaultContent : "", 
		"render": function (data, type, full) {		
			var html = '';
			if (full.COMPRESSED == 'true') {
					html += '<spring:message code="agent_monitoring.yes"/>';
				} else {
					html +='<spring:message code="agent_monitoring.no"/>';
				}
				return html;
		}
	}, 
	{data : "STATUS",  defaultContent : "", 
		"render": function (data, type, full) {		
			var html = '';
			if (full.STATUS == 'OK') {
					html += '<spring:message code="common.success"/>';
				} else {
					html +='<spring:message code="common.failed"/>';
				}
				return html;
		}
	}
	]
	});
	
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '120px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '120px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '75px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '75px');  
	$(window).trigger('resize'); 
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
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
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
			Online <spring:message code='common.backInfo' />
		</p>
		<div class="overflow_area" style="height: 600px;">
			<table id="rmanShowList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th scope="col"><spring:message code='etc.etc16' /></th>
						<th scope="col"><spring:message code='etc.etc17' /></th>
						<th scope="col"><spring:message code='backup_management.backup_option' /></th>
						<th scope="col"><spring:message code='etc.etc18' /></th>
						<th scope="col"><spring:message code='etc.etc19' /></th>
						<th scope="col"><spring:message code='etc.etc20' /></th>
						<th scope="col"><spring:message code='etc.etc21' /></th>
						<th scope="col"><spring:message code='etc.etc22' /></th>
						<th scope="col"><spring:message code='etc.etc25' /></th>
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