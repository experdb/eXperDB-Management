<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<script>
var table_dbmsInfo = null;
function fn_init_dbmsInfo() {
		table_dbmsInfo = $('#dbmsList').DataTable({
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
						}else if(data == "TC002209"){
							html += "MariaDB";
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
		
		table_dbmsInfo.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
		table_dbmsInfo.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table_dbmsInfo.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  

		$(window).trigger('resize'); 
			
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init_dbmsInfo();
	fn_search_dbmsInfo();
  	$(function() {	
  		$('#dbmsList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table_dbmsInfo.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search_dbmsInfo(){
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
  				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
  			} else if(xhr.status == 403) {
  				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
  			} else {
  				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
  			}
  		},
  		success : function(result) {
  			console.log(result);
  			if(result.length > 0){
  				table_dbmsInfo.clear().draw();
  				table_dbmsInfo.rows.add(result).draw();
  			}else{
  				table_dbmsInfo.clear().draw();
  			}
  		}
  	});  
}

	
/* ********************************************************
 * ddl 등록시 등록
 ******************************************************** */
function fn_Add(){
	var datas = table_dbmsInfo.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	var db2pg_sys_id = datas[0].db2pg_sys_id;		
	var db2pg_sys_nm = datas[0].db2pg_sys_nm;	
	fn_dbmsAddCallback(db2pg_sys_id,db2pg_sys_nm);
	$('#pop_layer_dbmsInfo_reg').modal("hide");
}


/* ********************************************************
 * ddl 수정시 등록
 ******************************************************** */
function fn_Mod(){
	var datas = table_dbmsInfo.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	var db2pg_sys_id = datas[0].db2pg_sys_id;		
	var db2pg_sys_nm = datas[0].db2pg_sys_nm;	
	fn_dbmsAddCallback2(db2pg_sys_id,db2pg_sys_nm);
	$('#pop_layer_dbmsInfo_reg').modal("hide");
}
</script>
<div class="modal fade" id="pop_layer_dbmsInfo_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					<spring:message code="migration.dbms_system_information"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">
							<div class="input-group mb-2 mr-sm-2 col-sm-4">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="db2pg_sys_nm" name="db2pg_sys_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.system_name'/>'  />
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-3">
								<select class="form-control" name="dbms_dscd" id="dbms_dscd">
									<option value=""><spring:message code="common.total" />&nbsp;DBMS<spring:message code="common.division" /></option>
									<option value="TC002201">Oracle</option>
									<option value="TC002202">MS-SQL</option>
									<option value="TC002203">MySQL</option>	
								</select>
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search_dbmsInfo();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><spring:message code="extension_pack_installation_information.dbms_list"/></p>
						<table id="dbmsList" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
							<thead>
								<tr class="bg-info text-white">
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
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="sourceSystem_add" onclick="fn_Add()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="sourceSystem_mod" onclick="fn_Mod()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>