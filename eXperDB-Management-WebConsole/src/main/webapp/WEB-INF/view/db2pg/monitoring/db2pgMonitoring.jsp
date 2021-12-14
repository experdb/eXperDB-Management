<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : db2pgMonitoring.jsp
	* @Description : db2pgMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.07.23     최초 생성
	*	2021.11.10     기능개발 	변승우 책임
	*
	* author 신예은 매니저
	* since 2021.07.23
	* 
	*/
%>


<script>
var table;
var tableData;

$(window.document).ready(function(){
	fn_init();
	fn_selectExeWork();
	//fn_getStatus();
});




function fn_init() {
	
	tableData = $('#dataDataTable').DataTable({
		scrollY : "100px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		bSort : false,
	columns : [
		{data : "idx", className : "dt-center", defaultContent : ""}, 
     	{data : "wrk_nm", className : "dt-left", defaultContent : ""},
     	{data : "mig_info", className : "dt-left", defaultContent : ""},
     	{
			data : "progress",
			render : function(data, type, full, meta) {	
				var html = '';
					html += '<div class="progress" style="width:270px; height:25px; margin-top: -6px;">';
					html += '<div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:'+full.progress+'%">';
					html += full.progress+'%';
					html += '</div>';
					html += '</div>';
					html += '<div class="info" align="right" style="margin-top: -20px;"> 전체테이블 : '+full.rs_cnt+'/'+full.total_table_cnt +'</div>';						
				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},
     	{data : "total_table_cnt", className : "dt-left", defaultContent : "", visible: false},
     	{data : "rs_cnt", className : "dt-left", defaultContent : "", visible: false},
		/* {data : "src_dbms_dscd", className : "dt-center", defaultContent : ""}, 
		{data : "src_ip", className : "dt-center", defaultContent : ""}, 
		{data : "src_database", className : "dt-center", defaultContent : ""}, 
		{data : "tar_ip", className : "dt-center", defaultContent : ""}, 
		{data : "tar_database", className : "dt-center", defaultContent : ""}, */
	]
	});
	
	
    tableData.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
    tableData.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(2)').css('min-width', '500px');
    tableData.tables().header().to$().find('th:eq(3)').css('min-width', '300px')
    /* tableData.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(6)').css('min-width', '100px'); */
    
	$(window).trigger('resize');
	
	
	
	table = $("#monitoring").DataTable({
		scrollY : "330px",
		searching : false,
		deferRender : true,
		paging : false,
		scrollX: true,
		bSort: false,
		columns : [
			{data : "table_nm",  defaultContent : ""},
			{data : "total_cnt", className : "dt-right", defaultContent : "", render: $.fn.dataTable.render.number( ',' ) },
			{data : "mig_cnt", className : "dt-right", defaultContent : "", render: $.fn.dataTable.render.number( ',' ) },
			{data : "start_time", className : "dt-center", defaultContent : ""},
			{data : "end_time", className : "dt-center", defaultContent : ""},
			{data : "elapsed_time", className : "dt-center", defaultContent : ""},
			{data : "status", className : "dt-center", defaultContent : ""}
		]
	});

	table.tables().header().to$().find('th:eq(0)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
	
	
	//더블 클릭시
	 $('#dataDataTable tbody').on('dblclick','tr',function() {
		 var wrk_nm = tableData.row(this).data().wrk_nm;
		 fn_getStatus(wrk_nm);
	});		

	
}

function fn_getStatus(wrk_nm){
	setInterval(function() {
	$.ajax({
		url : "/db2pg/monitoring/getData.do",
		data : {			
			wrk_nm : wrk_nm
		},
		dataType : "json",
		type : "post",
		success : function(result){
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
	$('#loading').hide();
	}, 3000);	
}


function fn_selectExeWork(){
	setInterval(function() {
	$.ajax({
		url : "/db2pg/monitoring/selectExeWork.do",
		data : {			
		},
		dataType : "json",
		type : "post",
		success : function(result){
			tableData.clear().draw();
			tableData.rows.add(result).draw();
		}
	});
	$('#loading').hide();
	}, 5000);	
}

</script>



<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-server menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.trans_monitoring" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">MIGRATION</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_migration" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.trans_monitoring" /></li>
										</ol>
									</div>
								</div>
							</div>
							<!-- 수정필요 -->
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.db2pg.monitoring_01" /></p>
											<p class="mb-0"><spring:message code="help.db2pg.monitoring_02" /></p>
										</div>
									</div>
								</div>
							</div>
							<!-- ///////// -->
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<div class="col-12 div-form-margin-table stretch-card">
				<div class="card my-sm-2" >
					<div class="card-body" >
						<div class="row">
							<div class="col-12">			
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_selectExeWork()" style="float: right;">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
									</button>												
									<table id="dataDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"   style="background-color: #778899;"><spring:message code="common.no" /></th>
												<th width="100"  style="background-color: #778899;"><spring:message code="common.work_name" /></th>
												<th width="100"  style="background-color: #778899;">MIGRATION</th>
												<th width="100"  style="background-color: #778899;">Status</th>
												<%-- <th width="100"  style="background-color: #778899;">DBMS <spring:message code="common.division" /></th>
												<th width="100"  style="background-color: #778899;"><spring:message code="data_transfer.ip" /></th>
												<th width="100"  style="background-color: #778899;">Database</th>												
												<th width="100"  style="background-color: #778899;"><spring:message code="data_transfer.ip" /></th>
												<th width="100"  style="background-color: #778899;">Database</th> --%>
											</tr>
										</thead>
									</table>
								 	</div>
						 	</div>
						</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
		
		<div class="col-12 div-form-margin-table stretch-card" style="margin-top: 20px;">
			<div class="card">				
				<div class="card-body">			
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">							
									<table id="monitoring" class="table table-hover system-tlb-scroll" cellspacing="0" width="100%">
										<thead>
											<tr class="bg-info text-white">
												<th width="130"><spring:message code="migration.table_name" /></th>
												<th width="130"><spring:message code="migration.totalcnt" /></th>
												<th width="130"><spring:message code="migration.migcnt" /></th>
												<th width="130"><spring:message code="migration.starttime" /></th>
												<th width="130"><spring:message code="migration.endtime" /></th>
												<th width="130"><spring:message code="migration.elapsedtime" /></th>
												<th width="80"><spring:message code="migration.status" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>