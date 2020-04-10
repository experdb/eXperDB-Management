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
var tableData = null;

function fn_init(){

	tableData = $('#dataDataTable').DataTable({
		scrollY : "330px",
		scrollX: true,	
		bDestroy: true,
		paging : true,
		processing : true,
		searching : false,	
		deferRender : true,
		bSort: false,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "db2pg_trsf_wrk_nm", className : "dt-center", defaultContent : ""}, 
		{data : "db2pg_trsf_wrk_exp", className : "dt-center", defaultContent : ""}, 
		{data : "source_dbms_dscd", className : "dt-center",defaultContent : ""},
		{data : "source_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "source_dtb_nm", className : "dt-center", defaultContent : ""}, 
		{data : "source_scm_nm", className : "dt-center", defaultContent : ""},
		{data : "target_dbms_dscd",className : "dt-center",defaultContent : ""},
		{data : "target_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "target_dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "target_scm_nm", className : "dt-center", defaultContent : ""},
		{data : "db2pg_trsf_wrk_id", defaultContent : "", visible: false},
		{data : "wrk_id", defaultContent : "", visible: false}
	],'select': {'style': 'multi'}
	});
	
	tableData.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    tableData.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
    tableData.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
    tableData.tables().header().to$().find('th:eq(4)').css('min-width', '140px');
    tableData.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(8)').css('min-width', '140px');
    tableData.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(11)').css('min-width', '100px');

	$(window).trigger('resize'); 
}


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_search();
});


/* ********************************************************
 * 조회
 ******************************************************** */
	function fn_search(){
		$.ajax({
			url : "/db2pg/selectDataWork.do", 
		  	data : {
		  		wrk_nm : "%" + $("#data_wrk_nm").val() + "%",
		  		data_dbms_dscd : $("#data_dbms_dscd").val(),
		  		dbms_dscd : "%" +$("#dbms_dscd").val()+ "%",
		  		ipadr : "%" ,
		  		dtb_nm : "%" ,
		  		scm_nm : "%"
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
				if(data.length > 0){
					tableData.rows({selected: true}).deselect();
					tableData.clear().draw();
					tableData.rows.add(data).draw();
				}else{
					tableData.clear().draw();
				}
			}
		});
	}



/* ********************************************************
 * work 등록
 ******************************************************** */
 function fn_workAdd(){
		var datas = tableData.rows('.selected').data();
		if (datas.length <= 0) {
			alert('<spring:message code="message.msg35" />');
			return false;
		} 
		
		var rowList = [];
	    for (var i = 0; i < datas.length; i++) {
	        rowList.push( tableData.rows('.selected').data()[i].wrk_id);   
		   //rowList.push( table.rows('.selected').data()[i]);     
	  }	
		opener.fn_db2pgWorkAddCallback(JSON.stringify(rowList));
		self.close();
	}
</script>

</head>
<style>
#scdinfo{
	width: 35% !important;
	margin-top: 0px !important;
}

#workinfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}

#scriptInfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}
</style>
<body>
<%@include file="../cmmn/commonLocale.jsp"%>  


<div class="pop_container">
	<div class="pop_cts">
		<p class="tit"><spring:message code="schedule.workReg"/></p>
			<div class="btn_type_01">
				<span class="btn"><button onClick="fn_search();" type="button"><spring:message code="common.search" /></button></span>
			</div>
			<div class="sch_form">
				<table class="write" >
							<caption>검색 조회</caption>
							<colgroup>
								<col style="width:10%;" />
								<col style="width:15%;" />
								<col style="width:10%;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
									<td><input type="text" name="data_wrk_nm" id="data_wrk_nm" class="txt t4" maxlength="25"/></td>
									<th scope="row" class="t9"><spring:message code="properties.division" /></th>
									<td>		
										<select name="data_dbms_dscd" id="data_dbms_dscd" class="select t5" >
											<option value="source_system"><spring:message code="migration.source_system" /></option>	
											<option value="target_system"><spring:message code="migration.target_system" /></option>				
										</select>	
									</td>
									<th scope="row" class="t9"><spring:message code="migration.dbms_classification" /></th>
									<td><input type="text" name="dbms_dscd" id="dbms_dscd" class="txt t4"/></td>
								</tr>
							</tbody>
						</table>							
				</div>
		<div class="pop_cmm3">
			<p class="pop_s_tit"><spring:message code="schedule.workList"/></p>
			<div class="overflow_area">
					<table id="dataDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="10" rowspan="2"></th>
									<th width="30" rowspan="2"><spring:message code="common.no" /></th>
									<th width="100" rowspan="2"><spring:message code="common.work_name" /></th>
									<th width="200" rowspan="2"><spring:message code="common.work_description" /></th>
									<th width="440" colspan="4"><spring:message code="migration.source_system"/></th>
									<th width="440" colspan="4"><spring:message code="migration.target_system"/></th>
								</tr>
								<tr>
									<th width="140">DBMS <spring:message code="common.division" /></th>
									<th width="100"><spring:message code="data_transfer.ip" /></th>
									<th width="100">Database</th>
									<th width="100">Schema</th>
									<th width="140">DBMS <spring:message code="common.division" /></th>
									<th width="100"><spring:message code="data_transfer.ip" /></th>
									<th width="100">Database</th>
									<th width="100">Schema</th>
								</tr>
							</thead>
					</table>		
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onClick="fn_workAdd();" type="button"><spring:message code="common.add" /></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>