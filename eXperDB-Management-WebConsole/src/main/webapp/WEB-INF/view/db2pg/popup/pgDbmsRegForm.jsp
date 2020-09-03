<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>

<script>
var table_pgdbms = null;
function fn_init_pgdbms() {
		table_pgdbms = $('#pgDbmsList').DataTable({
		scrollY : "150px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "db_nm", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : ""},
		{data : "svr_spr_scm_pwd", className : "dt-center", defaultContent : "", visible: false},
		]
	});
		
		table_pgdbms.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table_pgdbms.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		table_pgdbms.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
		table_pgdbms.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
		table_pgdbms.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table_pgdbms.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
		table_pgdbms.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
		
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init_pgdbms();
	fn_search_pgdbms();
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search_pgdbms(){
	$.ajax({
		url : "/selectPgDbmsList.do",
		data : {
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
			table_pgdbms.rows({selected: true}).deselect();
			table_pgdbms.clear().draw();
			table_pgdbms.rows.add(result).draw();
		}
	});
}

/* ********************************************************
 * 기 등록된 PostgreSQL DB 등록
 ******************************************************** */
function fn_Add(){
	var datas = table_pgdbms.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	fn_pgDbmsAddCallback(datas);
	//opener.fn_pgSchemaList(datas);
	$('#pop_layer_pgdbms_reg').modal("hide");	
}


	$(function() {	
  		$('#pgDbmsList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table_pgdbms.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		});   
  		
  		$('#pgDbmsList tbody').on('dblclick', 'tr', function () {
  			var datas = table_pgdbms.rows('.selected').data();
  			if (datas.length <= 0) {
  				showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
  				return false;
  			} 
  			fn_pgDbmsAddCallback(datas);
  			//opener.fn_pgSchemaList(datas);
  			$('#pop_layer_pgdbms_reg').modal("hide");	
		});

  	});
	
</script>
<div class="modal fade" id="pop_layer_pgdbms_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					PostgreSQL <spring:message code="migration.dbms_system_information"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline">
							<div class="input-group mb-2 mr-sm-2">
								<input type="text" class="form-control" style="width:300px;margin-right: 2rem;" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.dbms_name" />'/>
							</div>
							<div class="input-group mb-2 mr-sm-2">
								<input type="text" class="form-control" style="width:300px;margin-right: 2rem;" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='Database'/>
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search_pgdbms();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description">PostgreSQL <spring:message code="extension_pack_installation_information.dbms_list" /></p>
						<table id="pgDbmsList" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="150" class="dt-center"><spring:message code="common.dbms_name" /></th>
									<th width="150" class="dt-center">DBMS<spring:message code="data_transfer.ip" /></th>
									<th width="150">Database</th>
									<th width="100"><spring:message code="data_transfer.port" /></th>
									<th width="150"><spring:message code="dbms_information.account" /></th>
									<th width="0"><spring:message code="user_management.password" /></th>
								</tr>
							</thead>
						</table>
					</div>
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onclick="fn_Add()" value='<spring:message code="common.choice" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>