<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<script>
var table_tableInfo = null;
var tableList = "";
var tableGbn = "";

function fn_init_tableInfo() {
		table_tableInfo = $('#tableList').DataTable({
		scrollY : "300px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "table_name", className : "dt-center", defaultContent : ""},
		{data : "obj_type", className : "dt-center", defaultContent : ""},
		{data : "obj_description", className : "dt-center", defaultContent : ""}		
		],'select': {'style': 'multi'}
	});
		
		table_tableInfo.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table_tableInfo.tables().header().to$().find('th:eq(1)').css('min-width', '300px');
		table_tableInfo.tables().header().to$().find('th:eq(2)').css('min-width', '140px');
		table_tableInfo.tables().header().to$().find('th:eq(3)').css('min-width', '300px');

		
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
function fn_search_tableInfo(){
	var table_nm = null;
	
	if($("#table_nm_table").val() == ""){
		table_nm="%";
	}else{
		table_nm=$("#table_nm_table").val();
	}
	
	if($("#db_svr_nm_table").val() == "%"){
		showSwalIcon('<spring:message code="message.msg152" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}

	$.ajax({
		url : "/selectTableList.do",
		data : {
 		 	ipadr : $("#ipadr_table").val(),
 		 	portno : $("#portno_table").val(),
 		  	dtb_nm : $("#dtb_nm_table").val(),
 		  	spr_usr_id : $("#spr_usr_id_table").val(),
 		  	pwd : $("#pwd_table").val(),
 		  	dbms_dscd : $("#dbms_dscd_table").val(),
 		  	table_nm : table_nm,
 		  	scm_nm : $("#scm_nm_table").val(),
 		  	object_type : $("#object_type_table").val()
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
		success : function(result) {
			table_tableInfo.rows({selected: true}).deselect();
			table_tableInfo.clear().draw();

			if (result.RESULT_DATA != null) {
				table_tableInfo.rows.add(result.RESULT_DATA).draw();
			}

			if(tableList != ""){
				fn_tableCheckSelect(tableList);
			}
		}
	});
}

/* ********************************************************
 * DDL 등록시 테이블 추가
 ******************************************************** */
function fn_Add_Table(){
	
	var totalCnt = table_tableInfo.rows().data().length;
	var datas = table_tableInfo.rows('.selected').data();
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table_tableInfo.rows('.selected').data()[i].table_name);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
 
	fn_tableAddCallback(rowList, tableGbn, totalCnt);
	$('#pop_layer_tableInfo_reg').modal("hide");
}


/* ********************************************************
 * DDL 수정시 테이블 추가
 ******************************************************** */
function fn_Mod_Table(){
	
	var totalCnt = table_tableInfo.rows().data().length;
	var datas = table_tableInfo.rows('.selected').data();
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table_tableInfo.rows('.selected').data()[i].table_name);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
 
	fn_tableAddCallback2(rowList, tableGbn, totalCnt);
	$('#pop_layer_tableInfo_reg').modal("hide");
}


/* ********************************************************
 * DATA 등록시 테이블 추가
 ******************************************************** */
function fn_Add_Table_Data(){
	
	var totalCnt = table_tableInfo.rows().data().length;
	var datas = table_tableInfo.rows('.selected').data();
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table_tableInfo.rows('.selected').data()[i].table_name);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
 
	fn_tableAddCallback3(rowList, tableGbn, totalCnt);
	$('#pop_layer_tableInfo_reg').modal("hide");
}

/* ********************************************************
 * DATA 수정시 테이블 추가
 ******************************************************** */
function fn_Mod_Table_Data(){
	
	var totalCnt = table_tableInfo.rows().data().length;
	var datas = table_tableInfo.rows('.selected').data();
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table_tableInfo.rows('.selected').data()[i].table_name);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
 
	fn_tableAddCallback4(rowList, tableGbn, totalCnt);
	$('#pop_layer_tableInfo_reg').modal("hide");
}

function fn_tableCheckSelect(tableList){
	var datas = table_tableInfo.rows().data();
	
	 for (var i = 0; i < datas.length; i++) {
			for(var j=0; j <tableList.length; j++ ){
				if(table_tableInfo.rows().data()[i].table_name == tableList[j]){
					$('input', table_tableInfo.rows(i).nodes()).prop('checked', true); 
					table_tableInfo.rows(i).nodes().to$().addClass('selected');	
				}
			}		  
	  }	
	 
}
</script>
<div class="modal fade" id="pop_layer_tableInfo_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" >
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 45px 300px;">
		<div class="modal-content" style="width:1100px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					<spring:message code="migration.table_information"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="db2pg_sys_nm_table" name="db2pg_sys_nm_table" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.system_name'/>'  />
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<input type="text" class="form-control" style="margin-right: -0.7rem;"  id="ipadr_table" name="ipadr_table" onblur="this.value=this.value.trim()" placeholder='<spring:message code='data_transfer.ip'/>'  />
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<input type="text" class="form-control" style="margin-right: -0.7rem;"  id="scm_nm_table" name="scm_nm_table" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.schema_Name'/>'  />
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_3">
								<select class="form-control" name="work" id="object_type_table">
									<option value=""><spring:message code="migration.table_type"/> 전체</option>
									<option value="TABLE">TABLE</option>
									<option value="VIEW">VIEW</option>
								</select>
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<input type="text" class="form-control" id="table_nm_table" name="table_nm_table" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.table_name'/>'  />
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search_tableInfo();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<input type="hidden" class="txt t4" name="dbms_dscd_table" id="dbms_dscd_table"  />
					<input type="hidden" class="txt t4" name="dtb_nm_table" id="dtb_nm_table" />
					<input type="hidden" class="txt t4" name="spr_usr_id_table" id="spr_usr_id_table" />
					<input type="hidden" class="txt t4" name="pwd_table" id="pwd_table" />
					<input type="hidden" class="txt t4" name="portno_table" id="portno_table" />	
					
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><spring:message code="data_transfer.tableList"/></p>
						<table id="tableList" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
 									<th width="10"></th>
									<th width="300" class="dt-center"><spring:message code="migration.table_name"/></th>
									<th width="140" class="dt-center"><spring:message code="migration.table_type"/></th>
									<th width="300" class="dt-center"><spring:message code="migration.table_comment"/></th>  
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