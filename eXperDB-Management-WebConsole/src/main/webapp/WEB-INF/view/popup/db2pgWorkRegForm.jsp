<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>

<script>
var tableData = null;

function fn_init3(){

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
	fn_init3();
	fn_search3();
});


/* ********************************************************
 * 조회
 ******************************************************** */
	function fn_search3(){
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
 function fn_workAdd3(){
		var datas = tableData.rows('.selected').data();
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		} 
		
		var rowList = [];
	    for (var i = 0; i < datas.length; i++) {
	        rowList.push( tableData.rows('.selected').data()[i].wrk_id);   
		   //rowList.push( table.rows('.selected').data()[i]);     
	  }	
		fn_db2pgWorkAddCallback(JSON.stringify(rowList));
		$('#pop_layer_db2pg_reg').modal("hide");
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
<div class="modal fade" id="pop_layer_db2pg_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 180px;">
		<div class="modal-content" style="width:1300px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="schedule.workReg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<input type="text" class="form-control" id="data_wrk_nm" name="data_wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />'/>
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<select class="form-control" name="data_dbms_dscd" id="data_dbms_dscd">
									<option value="source_system"><spring:message code="migration.source_system" /></option>	
									<option value="target_system"><spring:message code="migration.target_system" /></option>
								</select>
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<input type="text" class="form-control" id="dbms_dscd" name="dbms_dscd" onblur="this.value=this.value.trim()" placeholder='<spring:message code="migration.dbms_classification" />'/>
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search3();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><spring:message code="schedule.workList"/></p>
						
						<table id="dataDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10" rowspan="2"></th>
									<th width="30" rowspan="2"><spring:message code="common.no" /></th>
									<th width="100" rowspan="2"><spring:message code="common.work_name" /></th>
									<th width="200" rowspan="2"><spring:message code="common.work_description" /></th>
									<th width="440" colspan="4"><spring:message code="migration.source_system"/></th>
									<th width="440" colspan="4"><spring:message code="migration.target_system"/></th>
								</tr>
								<tr class="bg-info text-white">
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
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onclick="fn_workAdd3()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div> 