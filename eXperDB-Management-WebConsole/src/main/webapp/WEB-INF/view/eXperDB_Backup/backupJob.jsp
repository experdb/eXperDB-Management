<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>


<%
	/**
	* @Class Name : backupJob.jsp
	* @Description : 백업설정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-02-10	변승우 책임매니저		최초 생성
	*
	*
	* author 변승우 책임매니저
	* since 2021.01.21
	*
	*/
%>

<script>
var NodeList;
var table_policy;

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	selectTab('job');
	
	// get server information
	fn_init();
	
	fn_getSvrList();
	
	//fn_getNodeList();
	
});

function fn_init() {
	
	/* ********************************************************
	 * 노트리스트 테이블
	 ******************************************************** */
	 NodeList = $('#nodeList').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		deferRender : true,
		bSort : false,
		columns : [
		{data : "masterGbn", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				if(data == "M"){
					data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 20px;"><b>Primary</b></div>'
				}else if(data == "S"){
					data = '<i class="mdi mdi-subdirectory-arrow-right" style="margin-left: 20px;"><div class="badge badge-pill badge-outline-warning" title="" style="margin-left: 5px"><b>Standby</b></div>'
				}
				return data;
			}},
		{data : "hostName", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				data = '<class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">'+data+'';
				return data;
			}
		},
		{data : "ipadr", className : "dt-center", defaultContent : ""},			
		{data : "dbSvrId", className : "dt-center", defaultContent : ""},
		
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false}, */
		], 'select': {'style': 'single'}
	});

	 NodeList.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	 NodeList.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
	 NodeList.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	 NodeList.tables().header().to$().find('th:eq(3)').css('min-width', '30px'); 
    
    $(window).trigger('resize'); 
	
} // fn_init();

/* ********************************************************
 * 서버 리스트 가져오기
 ******************************************************** */
function fn_getSvrList() {
	$.ajax({
		url : "/experdb/getServerInfo.do",
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
		success : function(data) {
			NodeList.clear().draw();
			NodeList.rows.add(data).draw();
			
		}
	});
}


/* ********************************************************
 * 노드 리스트 가져오기
 ******************************************************** */
function fn_getNodeList() {
	$.ajax({
		url : "/experdb/getNodeList.do",
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
		success : function(data) {
		}
	});
}



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
			fn_regReset();
			$('#pop_layer_popup_backupPolicy').modal("show");
		}
	});
}

/* ********************************************************
	* 백업정책 수정 팝업창 호출
	******************************************************** */
function fn_policy_modi_popup() {
	$('#pop_layer_popup_backupPolicy').modal("hide");
	
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
			$('#pop_layer_popup_backupPolicy').modal("show");
		}
	})
	

}

/* ********************************************************
	* node check popup
	******************************************************** */
function fn_nodeCheck() {
	
}


function fn_runNow() {
	// pop_runNow
	$("#pop_runNow").modal("show");
}
function fn_cancel() {
	$("#pop_runNow").modal("hide");
}






/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(intab){
	if(intab == "job"){		
		$("#jobDiv").show();
		$("#scheduleDiv").hide();
	}else{				
		$("#jobDiv").hide();
		$("#scheduleDiv").show();
	}
}

</script>
<style>
table.dataTable.nonborder tbody td{border-top:1px solid rgb(255, 255, 255);}
</style>

<%@include file="./popup/backupRegForm.jsp"%>
<%@include file="./popup/backupRunNow.jsp"%>

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
		<div class="col-12 grid-margin stretch-card" style="margin-bottom: 0px;">
			<div class="card-body" style="padding-bottom:0px; padding-top: 0px;">
				<div class="table-responsive" style="overflow:hidden;">
					<div id="wrt_button" style="float: right;">
						<button type="button" class="btn btn-success btn-icon-text mb-2" onclick="fn_runNow()">
							<i class="ti-control-forward btn-icon-prepend "></i><spring:message code="migration.run_immediately" />
						</button>
						<button type="button" class="btn btn-danger btn-icon-text mb-2">
							<i class="mdi mdi-stop "></i> 중지
						</button>
					</div>
				</div>
			</div>
		</div>
		
		
		
		<!-- node list -->
		<div class="col-lg-6 grid-margin stretch-card" >
			<div class="card" style="width:80%; min-width:80%;">
				<div class="card-body">
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="item-icon fa fa-desktop" style="margin-left: 10px; margin-top: 3px;">	노드정보 </i>
						</div>	
						<table id="nodeList" class="table nonborder table-hover system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="30">서버유형</th>
									<th width="150">호스트명</th>
									<th width="100">아이피</th>
									<th width="50">노드 확인</th>
								</tr>
							</thead>
						</table>	
				
					<!-- <div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_getSvrList()">
								노드 확인
							</button>
						</div>
						<h4 class="card-title">
							<i class="item-icon fa fa-desktop"></i>  Node List
						</h4>
						<table id="nodeList" class="table nonborder table-hover system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100">서버유형</th>
									<th width="130">호스트명</th>
									<th width="150">아이피</th>
									<th width="50">노드 확인</th>
								</tr>
							</thead>
						</table>
					</div> -->
				</div>
			</div>
			
			<div class="card"  style="width:123%; min-width:123%; margin-left: 7px;">
				<div class="card-body">				
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('job');" >
								백업설정
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('schedule');">
								스케줄
							</a>
						</li>
					</ul>
					
					 <div class="row" style="margin-top:-20px;"  id="schedule_button">
							<div class="col-12">
								<div class="template-demo">
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScdViewInsert" data-toggle="modal" onclick="fn_policy_reg_popup()">
										<i class="ti-pencil btn-icon-prepend "></i>스케줄 등록
									</button>
								</div>
							</div>
					</div>				 	
					<div class="card my-sm-2" >
						<div class="card-body" >				
								<div class="col-12" id="jobDiv" >
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
									
									<div class="card card-inverse-info"  style="height:25px;">
										<i class="mdi mdi-blur" style="margin-left: 10px;">	Backup Destination </i>
									</div>	
										<form class="cmxform" id="backupDestination">
											<fieldset>			
												<div class="form-group row" style="margin-top: 10px;">
													<div class="col-2 col-form-label pop-label-index" style="margin-left: 20px">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Backup Destination:
													</div>
													<div class="col-2" style="padding-left: 0px;">
														<input type="text" class="form-control form-control-sm"  style="height: 30px;"/ >
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" class="form-control form-control-sm" style="height: 30px;"/>
													</div>
												</div>
											</fieldset>
										</form>
									<div class="card card-inverse-info"  style="height:25px;">
										<i class="mdi mdi-blur" style="margin-left: 10px;">	Compression </i>
									</div>
										<fieldset>			
											<div class="form-group row" style="margin-top: 15px;">
												<div class="col-2 col-form-label pop-label-index" style="margin-left: 20px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													Compression:
												</div>
												<div class="col-4" style="padding-left: 0px;">
													<input type="text" class="form-control form-control-sm" style="height: 30px;"/>
												</div>
											</div>
										</fieldset>
									<div class="card card-inverse-info"  style="height:25px;">
										<i class="mdi mdi-blur" style="margin-left: 10px;">	Full Backup Set Seeting </i>
									</div>
									
									<fieldset>			
										<div class="form-group row" style="margin-top: 15px;">
											<div class="col-2 col-form-label pop-label-index" style="margin-left: 20px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Full백업 시작일
											</div>
											<div class="col-4" style="padding-left: 0px;">
												<input type="text" class="form-control form-control-sm" style="height: 30px;"/>
											</div>
										</div>
									</fieldset>
																			
									<div class="card card-inverse-info"  style="height:25px;">
										<i class="mdi mdi-blur" style="margin-left: 10px;">	Pre/Post Script Seeting </i>
									</div>
									
								
				 
							 	</div>
							
							
								<div class="col-12" id="scheduleDiv" >
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

	 								<table id="week_scheduleList" class="table table-hover table-striped" style="width:100%;">
										<thead>
											<tr>
												<th width="130" class="text-center text-danger"><spring:message code="common.sun" /></th>
												<th width="130" class="text-center"><spring:message code="common.mon" /></th>												
												<th width="130" class="text-center"><spring:message code="common.tue" /></th>
												<th width="130" class="text-center"><spring:message code="common.wed" /></th>
												<th width="130" class="text-center"><spring:message code="common.thu" /></th>
												<th width="130" class="text-center"><spring:message code="common.fri" /></th>												
												<th width="130" class="text-center text-primary"><spring:message code="common.sat" /></th>
											</tr>
										</thead>
									</table>
							 	</div>

						</div>
					</div>
						 	
				</div>
			</div>
		</div>
	</div>
</div>