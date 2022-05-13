<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<script>
var migTableinfo = null;
var tableList = "";


function fn_init_tableInfo() {
		migTableinfo = $('#tableList').DataTable({
		scrollY : "400px",
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		info : false,
		bSort : false,
		columns : [
			{data : "idx", className : "dt-center", defaultContent : ""}, 
			{data : "table_nm", className : "dt-center", defaultContent : ""}, 
			{data : "total_cnt", className : "dt-right", defaultContent : "", render: $.fn.dataTable.render.number( ',' ) }, 
			{data : "mig_cnt", className : "dt-right", defaultContent : "", render: $.fn.dataTable.render.number( ',' ) },
			{data : "start_time", className : "dt-center", defaultContent : ""}, 
			{data : "end_time", className : "dt-center", defaultContent : ""},
			{data : "elapsed_time", className : "dt-center", defaultContent : ""},
			{data : "status", className : "dt-center", defaultContent : ""},		
		]
	});
		
		migTableinfo.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		migTableinfo.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
		migTableinfo.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		migTableinfo.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		migTableinfo.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
		migTableinfo.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
		migTableinfo.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		migTableinfo.tables().header().to$().find('th:eq(7)').css('min-width', '150px');
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init_tableInfo();
});


/* ********************************************************
 * 조회
 ******************************************************** */
  function fn_mig_tableInfo_popup(mig_nm){
	  miGnm = mig_nm;
	  
	  $('#pop_layer_tableInfo_reg').modal("show");
	  
	 $.ajax({
 			url : "/db2pg/selectMigHistoryDetail.do", 
 		  	data : {
 		  		mig_nm : mig_nm
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
 				migTableinfo.clear().draw();
 				migTableinfo.rows.add(data).draw();
 			}
 		});
 } 
 
 
 function fn_search_migTableInfo(){
	 
	 $.ajax({
			url : "/db2pg/selectMigTableInfo.do", 
		  	data : {
		  		mig_nm : miGnm,
		  		table_nm :  $("#table_nm").val(),
		  		status : $("#status").val()
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
				migTableinfo.clear().draw();
				migTableinfo.rows.add(data).draw();
			}
		});
	 
	 
 }

</script>
<div class="modal fade" id="pop_layer_tableInfo_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" >
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 45px 150px;">
		<div class="modal-content" style="width:1309px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					<spring:message code="migration.table_information"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					 <div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">							
							<div class="input-group mb-2 mr-sm-2 search_rman col-sm-3">
								<input type="text" class="form-control" id="table_nm" name="table_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.table_name'/>'  />
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_3">
								<select class="form-control" name="status" id=status>
									<option value=""><spring:message code="backup_management.full_backup_title" /></option>
									<option value="SUCCESS">SUCCESS</option>
									<option value="FAIL">FAIL</option>
								</select>
							</div>
						
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search_migTableInfo();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					
					

					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<table id="tableList" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" >
							<thead>
								<tr class="bg-info text-white">
 									<th width="10">No</th>
									<th width="200" class="dt-center"><spring:message code="migration.table_name"/></th>
									<th width="100" class="dt-center"><spring:message code="migration.totalcnt"/></th>
									<th width="100" class="dt-center"><spring:message code="migration.migcnt"/></th>
									<th width="150" class="dt-center"><spring:message code="migration.starttime"/></th>  
									<th width="150" class="dt-center"><spring:message code="migration.endtime"/></th>  
									<th width="100" class="dt-center"><spring:message code="migration.elapsedtime"/></th>  
									<th width="100" class="dt-center"><spring:message code="migration.status"/></th>  
									
								</tr>
							</thead>
						</table>
					</div>
					
					<br>
					
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px" style="vertical-align:middle; display: none;" type="button" id="add" onclick="fn_Add_Table()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px" style="vertical-align:middle; display: none;" type="button" id="mod" onclick="fn_Mod_Table()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px" style="vertical-align:middle; display: none;" type="button" id="add_data" onclick="fn_Add_Table_Data()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px" style="vertical-align:middle; display: none;" type="button" id="mod_data" onclick="fn_Mod_Table_Data()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>