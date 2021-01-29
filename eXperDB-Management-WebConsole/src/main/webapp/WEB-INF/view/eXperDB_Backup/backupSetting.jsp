<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>



<%
	/**
	* @Class Name : backupSeetting.jsp
	* @Description : 백업설정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-01-21     최초 생성
	*
	* author 변승우 책임매니저
	* since 2021.01.21
	*
	*/
%>

<script>
var table_node;
var table_policy;

function fn_init() {
	
	/* ********************************************************
	 * 노트리스트 테이블
	 ******************************************************** */
	 table_node = $('#nodeList').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
		columns : [
		{data : "rownum", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        className : "dt-center",
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "서버유형", defaultContent : ""},
		{data : "호스트명", defaultContent : ""},
		{data : "IP",  defaultContent : ""},		
		{data : "OS",  defaultContent : ""},		
		{data : "설명",  defaultContent : ""},
		
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "portno", className : "dt-center", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_regr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "idx", className : "dt-center", defaultContent : "" ,visible: false},
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false} */
		]
	});



    
    $(window).trigger('resize'); 
	
}


/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {	
	fn_init();
});



	/* ********************************************************
	 * 백업정책 등록 팝업창 호출
	 ******************************************************** */
	function fn_policy_reg_popup(){

		$('#pop_layer_popup_backupPolicy').modal("hide");

		$.ajax({
			url : "/experdb/backupRegForm.do",
			data : {
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
				$('#pop_layer_popup_backupPolicy').modal("show");
			}
		});
	}


</script>

<%@include file="./popup/backupRegForm.jsp"%>


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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title">백업설정</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BACKUP</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">백업관리</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">백업설정</li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.dbms_registration_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_registration_02" /></p>
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
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-desktop"></i> 백업서버 리스트
					</h4>
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_reg_popup();">
								<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_regRe_popup();">
								<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_exeCheck()">
								<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
							</button>
						</div>

						<table id="nodeList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"><spring:message code="common.choice" /></th>				
									<th width="200">서버유형</th>					
									<th width="200">호스트명</th>
									<th width="130">아이피</th>
									<th width="50">OS</th>
									<th width="50">설명</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-cog"></i> 백업정책
					</h4>
					<div class="table-responsive" style="overflow:hidden;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_policy_reg_popup();">
								<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_regRe_popup();">
								<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_exeCheck()">
								<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
							</button>
						</div>
					</div>
					
					
					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;;">	Recovery Set Settings </i>
						</div>						
						<div class="card-body">
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="optionForm">
										<fieldset>													
													
									</fieldset>
								</form>		
							 	</div>
						 	</div>
						</div>
					</div>
					
					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;;">	Schedule </i>
						</div>					
						<div class="card-body">
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="optionForm">
										<fieldset>													
				
										</fieldset>
								</form>		
							 	</div>
						 	</div>
						</div>
					</div>
					
					
					
				</div>
			</div>
		</div>
	</div>
</div>