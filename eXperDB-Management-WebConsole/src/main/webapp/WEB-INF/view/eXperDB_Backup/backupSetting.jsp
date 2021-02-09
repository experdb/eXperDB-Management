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
	*  2021-01-21	변승우 책임매니저		최초 생성
	*  2021-01-28	신예은 매니저		화면 구성
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
	// get server information
	fn_init();
	
	fn_getSvrList();
	
	fn_getNodeList();
	
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
					data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 30px;"><b>Primary</b></div>'
				}else if(data == "S"){
					data = '<i class="mdi mdi-subdirectory-arrow-right" style="margin-left: 50px;"><div class="badge badge-pill badge-outline-warning" title="" style="margin-left: 10px"><b>Standby</b></div>'
				}
				return data;
			}},
		{data : "hostName", defaultContent : "", className : "dt-center", 
			searchable:false,
			orderable: false,
			render: function(data, type, full, meta){
				data = '<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">'+data+'</h5>';
				return data;
			}
		},
		{data : "ipadr", className : "dt-center", defaultContent : ""},			
		{data : "dbSvrId", className : "dt-center", defaultContent : ""},
		
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false}, */
		], 'select': {'style': 'single'}
	});

	 NodeList.tables().header().to$().find('th:eq(1)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(2)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(3)').css('min-width');
	 NodeList.tables().header().to$().find('th:eq(4)').css('min-width'); //
    
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
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
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
					</div>
				</div>
			</div>
		</div>
		<!-- node list end-->
		
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_policy_reg_popup();">
								<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_policy_modi_popup();">
								<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_exeCheck()">
								<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
							</button>
						</div>
						<h4 class="card-title">
							<i class="item-icon fa fa-cog"></i> 백업정책
						</h4>
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
											<div class="row">
												<div class="col-6">
													<div  class="col-6 col-form-label pop-label-index" style="padding-top:7px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														백업 셋 보관 수
													</div>
													<div class="col-sm-3" style="margin-left: 10px">
														<input type="number" style="width:200px; height:40px;" class="form-control form-control-sm" name="backupNum" id="backupNum" readonly/>
													</div>
												</div>
												<div class="col-6" >
													<div class="col-6 col-form-label pop-label-index" style="padding-top:7px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Merge 주기
													</div>
													<div class="col-8 row" style="margin-left: 10px;">
														<input type="text" style="width:200px; height:40px;" class="form-control form-control-sm" name="backupMerge" id="backupMerge" readonly/>
													</div>
												</div>
											</div>												
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
											
												<div class="form-group row">
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Start Date
													</label>
													<div class="col-sm-3" style="padding-left: 0px;">
														<input type="text" style="width:200px; height:40px;" class="form-control form-control-sm" name="startTime" id="startTime" readonly/>
													</div>
												</div>
												<div class="form-group row">
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Start Time
													</label>
													<div class="col-sm-3" style="padding-left: 0px;">
														<input type="text" style="width:200px; height:40px;" class="form-control form-control-sm" name="startTime" id="startTime" readonly/>
													</div>
												
												</div>
												<div class="form-group row">
													<label for="ins_connect_nm row" class="col-sm-2_1 col-form-label-sm pop-label-index">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Repeat
													</label>
													<div class="col-9 form-group" style="border: 1px solid #dee1e4;padding-left: 15px;" id="repeat_set">
														<div class="row" style="padding-top: 10px; padding-left: 10px;" >
															<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index">
																Every
															</label>
															<div class="col-sm-4" >
																<input type="text"style="width:150px; height:40px;" class="form-control form-control-sm" name="everyTime" id="everyTime" readonly/>
															</div>
															<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index">
																End Time
															</label>
															<div class="col-sm-3" >
																<input type="text" style="width:150px; height:40px;" class="form-control form-control-sm" name="every_min" id="every_min" readonly/>
															</div>
														</div>
													</div>
												</div>
												<div class="form-group row">
													<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index">
														<i class="item-icon fa fa-dot-circle-o"></i>
														요일 반복
													</label>
													<div class="form-check">
														<label class="form-check-label" for="sun" style="color : red;">
															<input type="checkbox" class="form-check-input" id="sun" name="sun" disabled/>
															일
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="mon">
															<input type="checkbox" class="form-check-input" id="mon" name="mon" disabled/>
															월
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="tue">
															<input type="checkbox" class="form-check-input" id="tue" name="tue" disabled/>
															화
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="wed">
															<input type="checkbox" class="form-check-input" id="wed" name="wed" disabled/>
															수
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="thu">
															<input type="checkbox" class="form-check-input" id="thu" name="thu" disabled/>
															목
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="fri">
															<input type="checkbox" class="form-check-input" id="fri" name="fri" disabled/>
															금
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="sat" style="color : blue;">
															<input type="checkbox" class="form-check-input" id="sat" name="sat" disabled/>
															토
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="alldays">
															<input type="checkbox" class="form-check-input" id="alldays" name="alldays" disabled/>
															all days
															<i class="input-helper"></i>
														</label>
													</div>
													
												</div>
												<div class="form-group row">

												</div>			
											
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