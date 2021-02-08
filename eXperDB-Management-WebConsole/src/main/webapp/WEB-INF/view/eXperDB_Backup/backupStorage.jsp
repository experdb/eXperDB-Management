<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>


<%
	/**
	* @Class Name : backupStorage.jsp
	* @Description : 백업스토리지 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-02-04	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.02.04
	*
	*/
%>

<script>
var bckStorageList;
var table_policy;

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();

});

function fn_init() {
	
	/* ********************************************************
	 * backup storage list table setting
	 ******************************************************** */
	 bckStorageList = $('#bckStorageList').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		bSort : false,
		columns : [
		{data : "bckDestination", className : "dt-center", defaultContent : ""},	
		{data : "type", className : "dt-center", defaultContent : ""},	
		{data : "totalSize", className : "dt-center", defaultContent : ""},			
		{data : "FreeSize", className : "dt-center", defaultContent : ""},
		{data : "RunJobCount", className : "dt-center", defaultContent : ""},	
		{data : "WaiJobCount", className : "dt-center", defaultContent : ""}

		], 'select': {'style': 'single'}
	});

	bckStorageList.tables().header().to$().find('th:eq(1)').css('min-width');
	bckStorageList.tables().header().to$().find('th:eq(2)').css('min-width');
	bckStorageList.tables().header().to$().find('th:eq(3)').css('min-width');
	bckStorageList.tables().header().to$().find('th:eq(4)').css('min-width');
    bckStorageList.tables().header().to$().find('th:eq(5)').css('min-width');
	bckStorageList.tables().header().to$().find('th:eq(6)').css('min-width');

    $(window).trigger('resize'); 
	
} // fn_init();


/* ********************************************************
 * backup storage registration popoup
 ******************************************************** */
function fn_storage_reg_popup(){

	$('#pop_layer_popup_backupStorageReg').modal("hide");

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
			fn_regReset();
			$('#pop_layer_popup_backupStorageReg').modal("show");
		}
	});
}

/* ********************************************************
 * backup storage modification popoup
 ******************************************************** */
function fn_storage_modi_popup() {
	$('#pop_layer_popup_backupStorageReg').modal("hide");
	
	$.ajax({
		url : "/experdb/backupModiForm.do",
		data : {
			
		},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if (xhr.status == 403){
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {
			fn_modiReset();
			$('#pop_layer_popup_backupStorageReg').modal("show");
		}
	})
	

}

</script>

<%@include file="./popup/bckStorageRegForm.jsp"%>


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
												<span class="menu-title">백업 스토리지</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BACKUP</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">백업관리</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">백업스토리지</li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<!-- /////////////////////////// 내용 수정 필요 ///////////////////////////// -->
											<p class="mb-0"><spring:message code="help.dbms_registration_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_registration_02" /></p>
											<!-- //////////////////////////////////////////////////////////////////////// -->
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
		<div class="col-12 grid-margin stretch-card" style="margin-bottom: 0px;">
			<div class="card-body" style="padding-bottom:0px; padding-top: 0px;">
				<div class="table-responsive" style="overflow:hidden;">
					<div id="wrt_button" style="float: right;">
						<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_storage_reg_popup()">
							<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
						</button>
						<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_storage_modi_popup()">
							<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
						</button>
						<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="">
							<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
						</button>
						<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="">
							<i class="ti-search btn-icon-prepend "></i>조회
						</button>
					</div>
				</div>
			</div>
		</div>
		<!-- backup storage list -->
		<div class="col-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;"> 백업 스토리지 리스트 </i>
							</div>						
							<div class="card-body">
								<div class="row">
									<div class="col-12">
										 <form class="cmxform" id="optionForm">
											<fieldset>	
												<table id="bckStorageList" class="table table-hover table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
													<thead>
														<tr class="bg-info text-white">
															<th width="300">Backup Destination</th>
															<th width="50">Type</th>
															<th width="100">Total Size</th>
															<th width="50">Free Size</th>
															<th width="50">Running Job Count</th>
															<th width="50">Waiting Job Count</th>
														</tr>
													</thead>
												</table>							
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
		<!-- backup storage list end -->
	</div>
</div>