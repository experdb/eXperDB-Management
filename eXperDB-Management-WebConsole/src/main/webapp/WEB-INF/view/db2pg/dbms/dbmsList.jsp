<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : sourceDBMS.jsp
	* @Description : sourceDBMS 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.09.17     최초 생성
	*
	* author 변승우 대리
	* since 2019.09.17
	*
	*/
%>

<script>
var table = null;
var confirm_title = ""; 

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#dbms').DataTable({	
		scrollY : "330px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "rownum",  className : "dt-center", defaultContent : ""},
		{data : "db2pg_sys_nm", className : "dt-center", defaultContent : ""},
		{data : "dbms_dscd_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "scm_nm", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
	    {data : "spr_usr_id", className : "dt-center", defaultContent : ""},
		{data : "crts_nm", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "db2pg_sys_id",  defaultContent : "", visible: false }
		]
	});
	
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');		
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');		
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(10)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
	    $(window).trigger('resize'); 
}



     

/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_search();
  	$(function() {	
  		$('#dbms tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
  	
  	
 
});

/* ********************************************************
 * DBMS 조회
 ******************************************************** */
 function fn_search(){
	 	$.ajax({
	  		url : "/selectDb2pgDBMS.do",
	  		data : {
	  		 	db2pg_sys_nm : $("#db2pg_sys_nm").val(),
	  			ipadr : $("#ipadr").val(),
	  		 	portno : $("#portno").val(),
	  		  	dtb_nm : $("#dtb_nm").val(),
	  		  	scm_nm : $("#scm_nm").val(),
	  		   	spr_usr_id : $("#spr_usr_id").val(),
	  		  	dbms_dscd : $("#dbms_dscd").val(),
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
				table.clear().draw();
				table.rows.add(result).draw();
	  		}
	  	});  
}

/* ********************************************************
 * DBMS 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	$("#db2pg_sys_nm_reg", "#dbmsInsert").val("");
	$("#ipadr_reg", "#dbmsInsert").val(""); 
	$("#portno_reg", "#dbmsInsert").val(""); 
	$("#dtb_nm_reg", "#dbmsInsert").val(""); 
	$("#spr_usr_id_reg", "#dbmsInsert").val(""); 
	$("#pwd_reg", "#dbmsInsert").val(""); 
	$("#dbms_dscd_reg", "#dbmsInsert").val(""); 
	$("#crts_nm_reg", "#dbmsInsert").val(""); 

	$("#pgbtn").hide();
	$("#schema_any_reg").show();
	$("#schema_pg_reg").hide();
	$('#pop_layer_db2pg_dbms_reg').modal("show");
}


/* ********************************************************
 * DBMS 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if (datas.length >1){
		showSwalIcon('<spring:message code="message.msg38" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	
	var db2pg_sys_id = table.row('.selected').data().db2pg_sys_id;

	$.ajax({
		url : "/db2pg/popup/dbmsRegReForm.do",
		data : {
			db2pg_sys_id : db2pg_sys_id
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
			$("#db2pg_sys_id_reg_re").val(nvlPrmSet(result.resultInfo[0].db2pg_sys_id, ""));
			$("#db2pg_sys_nm_reg_re").val(nvlPrmSet(result.resultInfo[0].db2pg_sys_nm, ""));
			$("#ipadr_reg_re").val(nvlPrmSet(result.resultInfo[0].ipadr, ""));
			$("#portno_reg_re").val(nvlPrmSet(result.resultInfo[0].portno, ""));
			$("#dtb_nm_reg_re").val(nvlPrmSet(result.resultInfo[0].dtb_nm, ""));
			$("#scm_nm_reg_re").val(nvlPrmSet(result.resultInfo[0].scm_nm, ""));
			$("#spr_usr_id_reg_re").val(nvlPrmSet(result.resultInfo[0].spr_usr_id, ""));
			$("#pwd_reg_re").val(nvlPrmSet(result.pwd, ""));
			$("#crts_nm_reg_re option").remove();
			for(var i=0; i<result.dbmsChar.length; i++){
				$("#crts_nm_reg_re").append('<option value="'+result.dbmsChar[i].sys_cd+'">'+result.dbmsChar[i].sys_cd_nm+'</option>');
			}
			$("#crts_nm_reg_re").val(result.resultInfo[0].crts).prop("selected", true);
			$("#dbms_dscd_reg_re").val(result.resultInfo[0].dbms_dscd).prop("selected", true);

			$('#pop_layer_db2pg_dbms_reg_re').modal("show");
		}
	});	
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "del") {
		fn_delete2();
	}
}

/* ********************************************************
 * DBMS 삭제
 ******************************************************** */
function fn_delete(){
	var datas = table.rows('.selected').data();
	if(datas.length != 1){
		showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
			confile_title = '<spring:message code="migration.source/target_dbms_management" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("del");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
			$('#pop_confirm_multi_md').modal("show");
	}
}


function fn_delete2(){
		var db2pg_sys_id =  table.row('.selected').data().db2pg_sys_id;
		var db2pg_trg_sys_id =  table.row('.selected').data().db2pg_trg_sys_id;

		//ddl, mig work가 등록되어 있는지 확인
		$.ajax({
			url : "/db2pg/exeMigCheck.do",
			data : {
				db2pg_sys_id : db2pg_sys_id,
				db2pg_trg_sys_id : db2pg_trg_sys_id
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
				if(result>0){
					showSwalIcon('해당 DBMS가 등록된 설정들이 존재합니다.', '<spring:message code="common.close" />', '', 'error');
				}else{
						$.ajax({
							url : "/db2pg/deleteDBMS.do",
						  	data : {
						  		db2pg_sys_id : db2pg_sys_id
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
								if(result == true){
									showSwalIcon('<spring:message code="message.msg37"/>', '<spring:message code="common.close" />', '', 'success');
									fn_search();
								}else{
									showSwalIcon('<spring:message code="migration.msg09" />', '<spring:message code="common.close" />', '', 'error');
								}	
							}
						});	
				}
			}
		});
	
}

</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../popup/dbmsRegForm.jsp"%>
<%@include file="./../popup/dbmsRegReForm.jsp"%>
<%@include file="./../popup/pgDbmsRegForm.jsp"%>

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
												<span class="menu-title"><spring:message code="migration.source/target_dbms_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">MIGRATION</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_migration" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="migration.source/target_dbms_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.source/target_dbms_management_01"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px -10px;">

							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2  col-sm-2">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="db2pg_sys_nm" name="db2pg_sys_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="migration.system_name" />'/>		
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-2">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="ipadr" name="ipadr" onblur="this.value=this.value.trim()" placeholder='<spring:message code="history_management.ip" />'/>		
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-1_7">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="dtb_nm" name="dtb_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.database" />'/>		
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="dbms_dscd" id="dbms_dscd">
										<option value="">DBMS&nbsp;<spring:message code="common.division" />&nbsp;<spring:message code="common.total" /></option>
											<c:forEach var="result" items="${result}" varStatus="status">												 
 												<option value="<c:out value="${result.dbms_dscd}"/>" >
	 												<c:if test="${result.dbms_dscd == 'TC002201'}"> 	<c:out value="Oracle"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002202'}"> 	<c:out value="MS-SQL"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002203'}"> 	<c:out value="MySQL"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002204'}"> 	<c:out value="PostgreSQL"/> </c:if>
 													<c:if test="${result.dbms_dscd == 'TC002205'}"> 	<c:out value="DB2"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002206'}"> 	<c:out value="SyBaseASE"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002207'}"> 	<c:out value="CUBRID"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002208'}"> 	<c:out value="Tibero"/> </c:if>
 												</option>
 											</c:forEach>
									</select>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="spr_usr_id" name="spr_usr_id" onblur="this.value=this.value.trim()" placeholder='<spring:message code="dbms_information.account" />'/>		
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<input type="text" class="form-control" id="scm_nm" name="scm_nm" onblur="this.value=this.value.trim()" placeholder='Schema'/>		
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button" onClick="fn_search();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">

					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">			
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="del_button" onClick="fn_delete();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="mdf_button" onClick="fn_regRe_popup();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="int_button" onClick="fn_reg_popup();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>
				
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>
									<table id="dbms" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"><spring:message code="common.no" /></th>
												<th width="130"><spring:message code="migration.system_name"/></th>
												<th width="100">DBMS <spring:message code="common.division" /></th>
												<th width="130"><spring:message code="data_transfer.ip" /></th>
												<th width="100">Database</th>
												<th width="150">Schema</th>
												<th width="80"><spring:message code="data_transfer.port" /></th>
												<th width="100"><spring:message code="dbms_information.account" /></th>
												<th width="130"><spring:message code="migration.character_set"/></th>
												<th width="100"><spring:message code="common.register" /></th>
												<th width="120"><spring:message code="common.regist_datetime" /></th>
												<th width="100"><spring:message code="common.modifier" /></th>
												<th width="120"><spring:message code="common.modify_datetime" /></th>
												<th width="0"><spring:message code="common.modify_datetime" /></th>
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