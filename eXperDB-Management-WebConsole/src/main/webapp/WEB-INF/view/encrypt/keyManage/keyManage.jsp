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
	* @Class Name : keyManage.jsp
	* @Description : keyManage 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*  2020.08.04   변승우 과장		UI 디자인 변경
	*
	* author 변승우 대리
	* since 2018.01.09 
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#keyManageTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "no", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "no", className : "dt-center", defaultContent : ""}, 
				{ data : "resourceName", defaultContent : ""}, 
				{ data : "resourceTypeName", defaultContent : ""}, 
				{ data : "cipherAlgorithmName", defaultContent : ""}, 
				{ data : "createName", defaultContent : ""}, 
				{ data : "createDateTime", defaultContent : ""}, 
				{ data : "updateName", defaultContent : ""}, 
				{ data : "updateDateTime", defaultContent : ""},
				{ data : "resourceTypeCode", defaultContent : "", visible: false},
				{ data : "resourceNote", defaultContent : "", visible: false},
				{ data : "keyUid", defaultContent : "", visible: false},
				{ data : "keyStatusCode", defaultContent : "", visible: false},
				{ data : "keyStatusName", defaultContent : "", visible: false},
				{ data : "cipherAlgorithmCode", defaultContent : "", visible: false}
	
			 ],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
	    $(window).trigger('resize');
	    
	  //더블 클릭시
		if("${wrt_aut_yn}" == "Y"){
			
			$('#keyManageTable tbody').on('dblclick', 'tr', function() {
				
				var data = table.row(this).data();
				
				$.ajax({
					url : "/popup/keyManageRegReForm.do", 
				  	data : { 		
				  		resourceName : data.resourceName,
				  		resourceNote : data.resourceNote,
				  		keyUid : data.keyUid,
				  		keyStatusCode : data.keyStatusCode,
				  		keyStatusName : data.keyStatusName,
				  		cipherAlgorithmName : data.cipherAlgorithmName,
				  		cipherAlgorithmCode : data.cipherAlgorithmCode
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
			
						$("#mod_resourceName", "#modForm").val(nvlPrmSet(result.mod_resourceName, ""));
						$("#mod_resourceNote", "#modForm").val(nvlPrmSet(result.mod_resourceNote, ""));
						$("#mod_keyUid", "#modForm").val(nvlPrmSet(result.mod_keyUid, ""));
						$("#mod_resourceUid", "#modForm").val(nvlPrmSet(result.mod_keyUid, ""));
						$("#mod_keyStatusCode", "#modForm").val(nvlPrmSet(result.mod_keyStatusCode, ""));
						$("#mod_keyStatusName", "#modForm").val(nvlPrmSet(result.mod_keyStatusName, ""));
						$("#mod_cipherAlgorithmName", "#modForm").val(nvlPrmSet(result.mod_cipherAlgorithmName, ""));
						$("#mod_cipherAlgorithmCode", "#modForm").val(nvlPrmSet(result.mod_cipherAlgorithmCode, ""));
						$("#mod_updateDateTime", "#modForm").val(nvlPrmSet(result.mod_updateDateTime, ""));

						
						
						//초기세팅
						 $("#copyBin").prop('checked', false);
						$("#renew").prop('checked', false);
						
						$("#renewInsert").css("display", "none"); 

						//캘린더 셋팅
						fn_modDateCalenderSetting();

						$("#mod_cipherAlgorithmCode").prop("disabled", "disabled");
						//초기세팅 끝
						
						$('#pop_layer_keyManageRegReForm').modal("show");
						
						fn_historyCryptoKeySymmetric();
					}
				});
				
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
			url : "/selectCryptoKeyList.do", 
		  	data : {
		  		resourceName: $('#resourceName').val(),
		  		cipherAlgorithmName : $('#cipherAlgorithmName').val()
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
			success : function(data) {
					if(data.resultCode == "0000000000"){
						table.clear().draw();
						if(data.list.length != 0){
							table.rows.add(data.list).draw();
						}
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
	function fn_insert(){
		
		$("#ResourceName", "#keyInsForm").val(""); //암호화키이름
		$("#CipherAlgorithmCode", "#keyInsForm").val(""); //적용알고리즘
		$("#ResourceNote", "#keyInsForm").val(""); //암호화키설명
		$("#ins_usr_expr_dt", "#keyInsForm").val(""); //유효기간만료일자만료일
		
		$.ajax({
			url : "/popup/keyManageRegForm.do", 
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
				fn_insDateCalenderSetting();
				$('#pop_layer_keyManageRegForm').modal("show");
			}
		});
	}
	
	
	
	
	
	
	/* 수정 버튼 클릭시*/
	function fn_update() {

		var datas = table.rows('.selected').data();
 		var data =  table.row('.selected').data();
 		

 		if (datas.length <= 0) {
 			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
 			return false;
 		}else if (datas.length >1){
 			showSwalIcon('<spring:message code="message.msg38" />', '<spring:message code="common.close" />', '', 'error');
 		}else{
		
		$.ajax({
			url : "/popup/keyManageRegReForm.do", 
		  	data : { 		
		  		resourceName : data.resourceName,
		  		resourceNote : data.resourceNote,
		  		keyUid : data.keyUid,
		  		keyStatusCode : data.keyStatusCode,
		  		keyStatusName : data.keyStatusName,
		  		cipherAlgorithmName : data.cipherAlgorithmName,
		  		cipherAlgorithmCode : data.cipherAlgorithmCode
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
	
				fn_modDateCalenderSetting();				
				$("#mod_resourceName", "#modForm").val(nvlPrmSet(result.mod_resourceName, ""));
				$("#mod_resourceNote", "#modForm").val(nvlPrmSet(result.mod_resourceNote, ""));
				$("#mod_keyUid", "#modForm").val(nvlPrmSet(result.mod_keyUid, ""));
				$("#mod_resourceUid", "#modForm").val(nvlPrmSet(result.mod_keyUid, ""));
				$("#mod_keyStatusCode", "#modForm").val(nvlPrmSet(result.mod_keyStatusCode, ""));
				$("#mod_keyStatusName", "#modForm").val(nvlPrmSet(result.mod_keyStatusName, ""));
				$("#mod_cipherAlgorithmName", "#modForm").val(nvlPrmSet(result.mod_cipherAlgorithmName, ""));
				$("#mod_cipherAlgorithmCode", "#modForm").val(nvlPrmSet(result.mod_cipherAlgorithmCode, ""));
				$("#mod_updateDateTime", "#modForm").val(nvlPrmSet(result.mod_updateDateTime, ""));

				
				
				//초기세팅
				 $("#copyBin").prop('checked', false);
				$("#renew").prop('checked', false);
				
				$("#renewInsert").css("display", "none"); 

				//캘린더 셋팅
				fn_modDateCalenderSetting();

				$("#mod_cipherAlgorithmCode").prop("disabled", "disabled");
				//초기세팅 끝
				
				$('#pop_layer_keyManageRegReForm').modal("show");
				
				fn_historyCryptoKeySymmetric();
			}
		});
 	}
}
	
	function fn_confirm(grn){
		
		if(grn == "del"){
			var datas = table.rows('.selected').data();
			if (datas.length <= 0) {
				showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
	 			return false;
	 		}else if (datas.length >1){
	 			showSwalIcon('<spring:message code="message.msg38" />', '<spring:message code="common.close" />', '', 'error');
	 		}
		}else if (grn == "ins"){
			if (!fn_validation()) return false;
		}else if (grn == "mod"){
			
		}
		
		fn_multiConfirmModal(grn);
	}
	
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {

 			var keyUid = table.row('.selected').data().keyUid;
 			var resourceName = table.row('.selected').data().resourceName;
 			var resourceTypeCode = table.row('.selected').data().resourceTypeCode;
 			
			$.ajax({
				url : "/deleteCryptoKeySymmetric.do", 
			  	data : {
			  		keyUid: keyUid,
			  		resourceName:resourceName,
			  		resourceTypeCode:resourceTypeCode
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
				success : function(data) {
					if(data.resultCode == "0000000000"){
						showSwalIcon('<spring:message code="message.msg37" />', '<spring:message code="common.close" />', '', 'success');
						fn_select();
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
	
	
	
	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_multiConfirmModal(gbn) {
		if (gbn == "ins") {
			confirm_title = '<spring:message code="encrypt_policy_management.Encryption_Key" />' + " " + '<spring:message code="common.registory" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg143" />');
		} else if (gbn == "del") {
			confirm_title = '<spring:message code="encrypt_policy_management.Encryption_Key" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		} else 	if (gbn == "mod") {
			confirm_title = '<spring:message code="encrypt_policy_management.Encryption_Key" />' + " " + '<spring:message code="common.modify" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg147" />');
		}

		
		$('#con_multi_gbn', '#findConfirmMulti').val(gbn);
		$('#confirm_multi_tlt').html(confirm_title);
		$('#pop_confirm_multi_md').modal("show");
	}
	
	
	/* ********************************************************
	 * confirm cancel result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		
	}
	
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "del") {
			fn_delete();
		} else if (gbn == "ins") {
			fn_insertCryptoKeySymmetric();
		} else if (gbn == "mod") {
			fn_keyManagementModify();
		}
	}
</script>

<%@include file="../popup/keyManageRegForm.jsp"%>
<%@include file="../popup/keyManageRegReForm.jsp"%>
<%@include file="./../../popup/confirmMultiForm.jsp"%>

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
												<span class="menu-title"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_Key_Management_01"/></p>
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_Key_Management_02"/></p>
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_confirm('del');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_insert();" data-toggle="modal">
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

	 								<table id="keyManageTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="20"></th>
												<th width="40"><spring:message code="common.no" /></th>
												<th width="200"><spring:message code="encrypt_key_management.Key_Name"/></th>
												<th width="80"><spring:message code="encrypt_key_management.Key_Type"/></th>
												<th width="130"><spring:message code="encrypt_key_management.Encryption_Algorithm"/></th>
												<th width="80"><spring:message code="common.register" /></th>
												<th width="150"><spring:message code="common.regist_datetime" /></th>
												<th width="80"><spring:message code="common.modifier" /></th>
												<th width="150"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>		
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