<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : securityPolicy.jsp
	* @Description : securityPolicy 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*  2020.08.03   변승우 과장		UI 디자인 변경
	*
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#policyTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "rnum", className : "dt-center", defaultContent : ""},
				{ data : "profileName", defaultContent : ""},
				{ data : "profileNote",
 					render : function(data, type, full, meta) {	 	
 						var html = '';					
 						html += '<span title="'+full.profileNote+'">' + full.profileNote + '</span>';
 						return html;
 					},
 					defaultContent : ""
 				},
				{ data : "profileStatusName", defaultContent : ""},
				{ data : "createName", defaultContent : ""},
				{ data : "createDateTime", defaultContent : ""},
				{ data : "updateName", defaultContent : ""},
				{ data : "updateDateTime", defaultContent : ""},
				{ data : "profileUid",visible: false }
				
			 ],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '90px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '90px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
	
	    $(window).trigger('resize');
	    
	     
		//더블 클릭시
		if("${wrt_aut_yn}" == "Y"){
			$('#policyTable tbody').on('dblclick', 'tr', function() {
				var datas = table.row(this).data();
				if (datas.length <= 0) {
					showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
				}else if (datas.length >1){
					showSwalIcon('<spring:message code="message.msg38"/>', '<spring:message code="common.close" />', '', 'error');	
				}else{
					var profileUid = datas.profileUid;
					var form = document.modifyForm;
					form.action = "/securityPolicyModify.do?profileUid="+profileUid;
					form.submit();
					return;
				}
			});
		}

	}
	
	
	
	$(window.document).ready(function() {
		fn_buttonAut();
		fn_init();
		fn_select();
	});

	
	function fn_buttonAut(){
		var btnInsert = document.getElementById("btnInsert"); 
		var btnUpdate = document.getElementById("btnUpdate"); 
		var btnDelete = document.getElementById("btnDelete"); 
		
		if("${wrt_aut_yn}" == "Y"){
			btnInsert.style.display = '';
			btnUpdate.style.display = '';
			btnDelete.style.display = '';
		}else{
			btnInsert.style.display = 'none';
			btnUpdate.style.display = 'none';
			btnDelete.style.display = 'none';
		}
	}	
	
	/* 조회 버튼 클릭시*/
	function fn_select() {
		$.ajax({
			url : "/selectSecurityPolicy.do",
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					table.clear().draw();
					table.rows.add(data.list).draw();
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}
	
	
	/* 등록 버튼 클릭시*/
	function fn_insert() {
			var form = document.insertForm;
			form.action = "/securityPolicyInsert.do";
			form.submit();
			return;
	}
	
	

	/* 수정 버튼 클릭시*/
	function fn_update() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
		}else if (datas.length >1){
			showSwalIcon('<spring:message code="message.msg38"/>', '<spring:message code="common.close" />', '', 'error');	
		}else{
			var profileUid = table.row('.selected').data().profileUid;
			var form = document.modifyForm;
			form.action = "/securityPolicyModify.do?profileUid="+profileUid;
			form.submit();
			return;
		}
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		
		var datas = table.rows('.selected').data();
 		var profileUid = table.row('.selected').data().profileUid;

 			var rowList = [];
 			for (var i = 0; i < datas.length; i++) {
 				rowList += datas[i].profileUid + ',';				
 			}
		
			$.ajax({
				url : "/deleteSecurityPolicy.do", 
			  	data : {
			  		profileUid: rowList
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
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(data) {		
					if(data.resultCode == "0000000000"){
						showSwalIconRst('<spring:message code="message.msg37" />', '<spring:message code="common.close" />', '', 'success', 'reload');
					}else if(data.resultCode == "8000000002"){
						showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
					}else if(data.resultCode == "8000000003"){
						showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
					}else if(data.resultCode == "0000000003"){		
						showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
					}else{
						showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					}
				}
			});
	}

	function fn_delete_confirm(){
		
		var datas = table.rows('.selected').data();

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
 			return false;
 		}
		
		fn_ConfirmModal();
	}


	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_ConfirmModal() {
		confirm_title = '<spring:message code="encrypt_policy_management.Security_Policy_Management"/>' ;
		 $('#confirm_msg').html('<spring:message code="message.msg17" />');

		$('#confirm_tlt').html(confirm_title);
		$('#pop_confirm_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmRst(){
		fn_delete();
	}
	
</script>

<%@include file="./../../popup/confirmForm.jsp"%>

<form name="insertForm" method="post">
</form>
<form name="modifyForm" method="post">
</form>

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
												<span class="menu-title"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></span> 
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Security_Policy_Management" /></p>
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

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">

					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">			
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_delete_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_insert();" >
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

	 								<table id="policyTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="40"></th>
												<th width="40"><spring:message code="common.no" /></th>
												<th width="130"><spring:message code="encrypt_policy_management.Policy_Name"/></th>
												<th width="200"><spring:message code="encrypt_policy_management.Description"/></th>
												<th width="60"><spring:message code="encrypt_policy_management.Status"/></th>
												<th width="70"><spring:message code="common.register" /></th>
												<th width="90"><spring:message code="common.regist_datetime" /></th>
												<th width="70"><spring:message code="common.modifier" /></th>
												<th width="90"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
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