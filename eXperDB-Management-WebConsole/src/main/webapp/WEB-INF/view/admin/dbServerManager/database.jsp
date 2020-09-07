<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : database.jsp
	* @Description : database íë©´
	* @Modification Information
	*
	*   ìì ì¼         ìì ì                   ìì ë´ì©
	*  ------------    -----------    ---------------------------
	*  2017.06.23     ìµì´ ìì±
	*
	* author ë³ì¹ì° ëë¦¬
	* since 2017.06.23
	*
	*/
%>

<script>
var confirm_title = ""; 

var table = null;

function fn_init() {
	
		/* ********************************************************
		 * Repository database (데이터테이블)
		 ******************************************************** */
		table = $('#repoDBList').DataTable({
		scrollY : "310px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "idx", defaultContent : "", className : "dt-center"},		
		{data : "db_svr_nm", defaultContent : ""},
		{data : "ipadr", defaultContent : ""},
		{data : "portno", defaultContent : ""},
		{data : "db_nm", defaultContent : ""},
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""},
		{data : "db_id", defaultContent : "", visible: false}
		]
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(7)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
	    $(window).trigger('resize'); 
}

$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();

	  	$.ajax({
			url : "/selectDatabaseSvrList.do",
			data : {},
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
				$("#database_svr_nm").children().remove();
				$("#database_svr_nm").append("<option value='%'><spring:message code='common.total' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#database_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	 
function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	var int_button = document.getElementById("int_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
	}else{
		int_button.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
} 

  	$.ajax({
		url : "/selectDatabaseRepoDBList.do",
		data : {},
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
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
});


/* ********************************************************
 * Repository 조회
 ******************************************************** */
function fn_search(){
  	$.ajax({
		url : "/selectDatabaseRepoDBList.do",
		data : {
			db_svr_nm : $("#database_svr_nm").val().trim(),
			ipadr : $("#ipadr").val().trim(),
			dft_db_nm : $("#dft_db_nm").val().trim()
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
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
}


/* ********************************************************
 * 등록 팝업
 ******************************************************** */
function fn_reg_popup(){
	$('#pop_layer_dbRegForm').modal("show");
// 	window.open("/popup/dbRegForm.do","dbRegPop","location=no,menubar=no,resizable=no,scrollbars=yes,status=no,width=920,height=675,top=0,left=0");
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "ins") {
		fn_insertDB2();
	}
}

</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/dbRegForm.jsp"%>
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
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.database_management" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.dbms_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.database_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.database_management_01" /></p>
											<p class="mb-0"><spring:message code="help.database_management_02" /></p>
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
							<div class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
	 								<select class="form-control" style="margin-right: -0.7rem;"  id="database_svr_nm" name="database_svr_nm">
										<option value="%"><spring:message code="common.total" /> </option>
	 								</select>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" style="margin-right: -0.7rem;"  name="ipadr" id="ipadr"  placeholder='<spring:message code="dbms_information.dbms_ip" />'/>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" name="dft_db_nm" id="dft_db_nm" placeholder='<spring:message code="common.database" />'/>
								</div>
								
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search();" id="read_button">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-lg-12 grid-margin stretch-card">
		  <div class="card">
		    <div class="card-body">
		    	<div class="row" style="margin-top:-20px;">
					<div class="col-12">
						<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_reg_popup();" id="int_button" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.management" />
								</button>
						</div>
					</div>
				</div>
				
		      <div class="table-responsive">
					<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
						<div class="row">
							<div class="col-sm-12 col-md-6">
								<div class="dataTables_length" id="order-listing_length">
								</div>
								</div>
						</div>
					</div>
			 </div>
				
		      	<table id="repoDBList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
					<thead>
						<tr class="bg-info text-white">
							<th width="30"><spring:message code="common.no" /></th>
							<th width="130"><spring:message code="common.dbms_name" /></th>
							<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
							<th width="70"><spring:message code="data_transfer.port" /></th>
							<th width="130"><spring:message code="common.database" /></th>
							<th width="65"><spring:message code="common.register" /></th>
							<th width="100"><spring:message code="common.regist_datetime" /></th>
							<th width="65"><spring:message code="common.modifier" /></th>
							<th width="100"><spring:message code="common.modify_datetime" /></th>
							<th width="0"></th>
						</tr>
					</thead>
				</table>
		      </div>
		    </div>
		  </div>
		</div>		
		
	</div>
</div>
