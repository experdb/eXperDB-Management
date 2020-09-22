<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : encryptAgentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 변승우 대리
	* since 2018.04.23
	*
	*/
%>
<script>
var table = null;

function fn_init(){
	table = $('#monitoring').DataTable({
		scrollY : "420px",
		searching : false,
		deferRender : true,
		scrollX: true,
		columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]],  className : "dt-center", defaultContent : ""},
			{ data : "monitoredName", defaultContent : ""}, 
			{ data : "status", defaultContent : "", className : "dt-center", render: function (data, type, full){
				if(full.status == "start"){
					var html = "<div class='badge badge-pill badge-primary' ><i class='fa fa-spin fa-refresh mr-2' style='margin-right: 0px !important;'></i></div>";
					return html;
				}else{
					var html = "<div class='badge badge-pill badge-danger' ><i class='fa fa-times-circle mr-2' style='margin-right: 0px !important;'></i></div>";
					return html;
				}
				return data;
			},},
			{ data : "targetType", defaultContent : "", visible: false},
			{ data : "targetUid", defaultContent : "", visible: false},
			{ data : "targetName", defaultContent : "", visible: false},
			{ data : "monitorType", defaultContent : "", visible: false},
			{ data : "resultLevel", defaultContent : "", visible: false},
			{ data : "logMessage", defaultContent : "", visible: false},
			{ data : "getEntityUid", defaultContent : "", visible: false},
		 ],'select': {'style': 'multi'}
	});
	
	table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
}

$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	fn_refresh();
});

function fn_buttonAut(){
	var btndelete = document.getElementById("btndelete"); 
	if("${wrt_aut_yn}" == "Y"){
		btndelete.style.display = '';
	}else{
		btndelete.style.display = 'none';
	}
}	

function fn_refresh(){
	$.ajax({
		url : "/selectEncryptAgentMonitoring.do", 
	  	data : {},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(data) {
			table.rows({selected: true}).deselect();
			table.clear().draw();
				if(data.resultCode == "0000000000"){
					if(data.list != null){
						table.rows.add(data.list).draw();
					}
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else{
					if(data.resultCode == undefined){
						showSwalIcon("암호화 사용 권한이 존재하지 않습니다.", '<spring:message code="common.close" />', '', 'error');
					}else{
						showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					}
				}
		}
	});	
}

function fn_delete(){
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg04"/>', '<spring:message code="common.close" />', '', 'warning');
		return false;
	} else {
		if (!confirm('<spring:message code="message.msg162"/>'))return false;
		var rowList = [];
		for (var i = 0; i < datas.length; i++) {
			rowList += datas[i].getEntityUid + ',';	
		}
		
		$.ajax({
			url : "/deleteEncryptAgentMonitoring.do", 
		  	data : {
		  		entityuid : rowList,
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
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIcon('<spring:message code="message.msg37"/>', '<spring:message code="common.close" />', '', 'success');
					fn_refresh();
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});	
	}

}
</script>

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
												<span class="menu-title"><spring:message code="agent_monitoring.Encrypt_agent" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.agent_monitoring" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="agent_monitoring.Encrypt_agent"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encrypt_agent" /></p>
											<p class="mb-0"><spring:message code="help.agent_monitoring_02" /></p>
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

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_delete()" id="btndelete" data-toggle="modal">
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_refresh()" data-toggle="modal">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
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


									<table id="monitoring" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
									<!-- <table id="monitoring" class="table table-hover table-striped" cellspacing="0" width="100%"> -->
										<colgroup>
											<col style="width:3%;" />
											<col style="width:5%;" />
											<col style="width:35%;" />
											<col style="width:15%;" />
										</colgroup>
										<thead>
											<tr class="bg-info text-white" >
												<th scope="col"></th>
												<th scope="col"><spring:message code="common.no" /></th>
												<th scope="col">Agent IP</th>
												<th scope="col">Agent <spring:message code="properties.status" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>