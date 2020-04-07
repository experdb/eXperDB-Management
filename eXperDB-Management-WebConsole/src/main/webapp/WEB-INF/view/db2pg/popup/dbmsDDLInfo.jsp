<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
<script>
var table = null;
function fn_init() {
		table = $('#dbmsList').DataTable({
		scrollY : "150px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		   		{data : "rownum", className : "dt-center", defaultContent : ""},
				{data : "db2pg_sys_nm", className : "dt-center", defaultContent : ""},
				{
					data : "dbms_dscd",
					className : "dt-center",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == "TC002201") {
							html += "Oracle";
						}else if(data == "TC002202"){
							html += "MS-SQL";
						}else if(data == "TC002203"){
							html += "MySQL";
						}else if(data == "TC002204"){
							html += "PostgreSQL";
						}else if(data == "TC002205"){
							html += "DB2";
						}else if(data == "TC002206"){
							html += "SyBaseASE";
						}else if(data == "TC002207"){
							html += "CUBRID";
						}else if(data == "TC002208"){
							html += "Tibero";
						}
						return html;
					},
					defaultContent : ""
				},
				{data : "ipadr", className : "dt-center", defaultContent : ""},
				{data : "dtb_nm", className : "dt-center", defaultContent : ""},
				{data : "scm_nm", className : "dt-center", defaultContent : ""},
				{data : "portno", className : "dt-center", defaultContent : ""},
			    {data : "spr_usr_id", className : "dt-center", defaultContent : ""},
			    {data : "db2pg_sys_id", defaultContent : "", visible: false}
		]
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  

		$(window).trigger('resize'); 
		
		$('#dbmsList tbody').on('dblclick','tr',function() {
			var datas = table.row(this).data();
			var db2pg_sys_id = datas.db2pg_sys_id;		
			var db2pg_sys_nm = datas.db2pg_sys_nm;		
			opener.fn_dbmsAddCallback(db2pg_sys_id,db2pg_sys_nm);
			self.close();
		});	
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_search();
	
  	$(function() {	
  		$('#dbmsList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search(){
 	$.ajax({
  		url : "/selectDDLDb2pgDBMS.do",
  		data : {
  		 	db2pg_sys_nm : $("#db2pg_sys_nm").val(),
  			ipadr : $("#ipadr").val(),
  			dbms_dscd : $("#dbms_dscd").val()
  		},
  		type : "post",
  		beforeSend: function(xhr) {
  	        xhr.setRequestHeader("AJAX", true);
  	     },
  		error : function(xhr, status, error) {
  			if(xhr.status == 401) {
  				alert('<spring:message code="message.msg02" />');
  				top.location.href = "/";
  			} else if(xhr.status == 403) {
  				alert('<spring:message code="message.msg03" />');
  				top.location.href = "/";
  			} else {
  				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
  			}
  		},
  		success : function(result) {
  			if(result.length > 0){
  				table.clear().draw();
  				table.rows.add(result).draw();
  			}else{
  				table.clear().draw();
  			}
  		}
  	});  
}

	
/* ********************************************************
 * 등록
 ******************************************************** */
function fn_Add(){
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	} 
	var db2pg_sys_id = datas[0].db2pg_sys_id;		
	var db2pg_sys_nm = datas[0].db2pg_sys_nm;	
	opener.fn_dbmsAddCallback(db2pg_sys_id,db2pg_sys_nm);
	self.close();
}

</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">DBMS시스템정보</p>
			<div class="btn_type_01">
				<span class="btn"><button onClick="fn_search();" type="button"><spring:message code="common.search" /></button></span>
			</div>
		<div class="pop_cmm">							
			<table class="write bdtype1">
				<caption><spring:message code="menu.schedule_registration" /></caption>				
				<colgroup>
					<col style="width:8%;" />
					<col style="width:17%;" />
					<col style="width:8%;" />
					<col style="width:12%;" />
					<col style="width:8%;" />
					<col style="width:17%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="migration.system_name"/></th>
						<td><input type="text" class="txt t4" name="db2pg_sys_nm" id="db2pg_sys_nm" /></td>		
						<th scope="row" class="ico_t1">DBMS<spring:message code="common.division" /></th>
						<td>
							<select name="dbms_dscd" id="dbms_dscd" class="select t4" >
									<option value=""><spring:message code="common.total" /></option>
									<option value="TC002201">Oracle</option>
									<option value="TC002202">MS-SQL</option>
									<option value="TC002203">MySQL</option>				
								</select>						
						</td>									
						<th scope="row" class="ico_t1" ><spring:message code="data_transfer.ip" /></th>
						<td><input type="text" class="txt t4" name="ipadr" id="ipadr" /></td>				
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pop_cmm3">
			<p class="pop_s_tit">DBMS 시스템 리스트</p>
			<div class="overflow_area">
				<table id="dbmsList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th width="50"><spring:message code="common.no" /></th>
						<th width="100"><spring:message code="migration.system_name"/></th>
						<th width="100">DBMS<spring:message code="common.division" /></th>
						<th width="100"><spring:message code="data_transfer.ip" /></th>
						<th width="100">Database</th>
						<th width="100">Schema</th>
						<th width="100"><spring:message code="data_transfer.port" /></th>
						<th width="100">User</th>
					</tr>
				</thead>
			</table>		
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onClick="fn_Add();" type="button"><spring:message code="common.choice" /></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close"/></span></a>
		</div>
	</div>
</div>
</body>
</html>