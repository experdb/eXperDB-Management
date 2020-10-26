<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : dbTree.jsp
	* @Description : dbTree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.31
	*
	*/
%>

<script>
//연결테스트 확인여부
var connCheck = "fail";

var table_dbServer = null;
var table_db = null;

function fn_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "300px",
		searching : false,
		paging : false,
		bSort: false,
		columns : [
		{data : "rownum", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        className : "dt-center",
	        render: function(data, type, full, meta){
	           if(type === 'display'){
// 	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "idx", defaultContent : "" ,visible: false},
		{data : "db_svr_id", defaultContent : "", visible: false},
		{data : "db_svr_nm", defaultContent : ""},
		{data : "ipadr", defaultContent : ""},
		{data : "dft_db_nm", defaultContent : ""},
		{data : "portno", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", defaultContent : "", visible: false},
		{data : "frst_regr_id", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", defaultContent : "", visible: false}			
		]
	});

	/* ********************************************************
	 * 디비 (데이터테이블)
	 ******************************************************** */
	table_db = $('#dbList').DataTable({
		scrollY : "300px",
		searching : false,
		paging : false,
		bSort: false,
		columns : [
		{data : "extname", defaultContent : ""}, 
		{data : "extversion", defaultContent : ""},
		{data : "installYn", defaultContent : "<spring:message code='extension_pack_installation_information.install_y' />"}, 		
		]
	});
	
}


/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	
  	$.ajax({
		url : "/selectDbServerList.do",
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
			table_dbServer.clear().draw();
			table_dbServer.rows.add(result).draw();
		}
	});
  	
  	

});

$(function() {		
	
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#dbServerList tbody').on( 'click', 'tr', function () {
    	var check = table_dbServer.row( this ).index()+1
         if ( $(this).hasClass('selected') ) {
        }
        else {
        	
        	table_dbServer.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
            
        } 
         var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;

        /* ********************************************************
         * 선택된 서버에 대한 확장 조회
        ******************************************************** */
       	$.ajax({
    		url : "/extensionDetail.do",
    		data : {
    			db_svr_id: db_svr_id,			
    		},
    		dataType : "json",
    		type : "post",
    		beforeSend: function(xhr) {
    	        xhr.setRequestHeader("AJAX", true);
    	     },
    		error : function(xhr, status, error) {
    			if(xhr.status == 401) {
    				showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
    				top.location.href = "/";
    			} else if(xhr.status == 403) {
    				showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
    				top.location.href = "/";
    			} else {
    				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
    			}
    		},
    		success : function(result) {
    			table_db.clear().draw();
    			if(result == null){
    				showSwalIcon('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error');
    			}else{
	    			table_db.rows.add(result).draw();
	    			//fn_dataCompareChcek(result);
    			}
    		}
    	});
        
    } );
    

})


</script>


<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body" >
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.extension_pack_installation_information" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.extension_pack_installation_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.extension_pack_installation_information"/></li>
					 					</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.extension_pack_installation_information" /></p>
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

		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body" style=" height: 100%;">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i>
						<spring:message code="extension_pack_installation_information.dbms_list"/>
					</h4>

					<div class="table-responsive" style=" height: 100%;">
						<table id="dbServerList" class="table table-hover table-striped" cellspacing="0" width="100%" align="right">
							<thead>
								<tr class="bg-info text-white">
									<th><spring:message code="common.no" /></th>
									<th></th>
									<th></th>
									<th><spring:message code="common.dbms_name" /></th>
									<th><spring:message code="dbms_information.dbms_ip" /> </th>
									<th><spring:message code="common.database" /></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>

		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body" style=" height: 100%;">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i>
						<spring:message code="extension_pack_installation_information.exp_module_list"/>
					</h4>
					<div class="table-responsive"  style=" height: 100%;">
						<table id="dbList" class="table table-hover table-striped" cellspacing="0" width="100%" align="left">
							<thead>
								<tr class="bg-info text-white">
									<th><spring:message code="extension_pack_installation_information.extension_name" /></th>
									<th><spring:message code="properties.version" /></th>
									<th><spring:message code="extension_pack_installation_information.install_yn" /> </th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>