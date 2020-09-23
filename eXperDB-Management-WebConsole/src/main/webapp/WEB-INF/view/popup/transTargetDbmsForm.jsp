<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	var tans_dbms_pop_table = null;

	$(window.document).ready(function() {
		fn_tans_dbms_pop_init();
	});

	/* ********************************************************
	 * trans dbms 삭제버튼 클릭시
	 ******************************************************** */
	function fn_trans_dbms_del_confirm(){
		confile_title = '<spring:message code="data_transfer.btn_title01" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("trans_dbms_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_trans_dbms_delete_logic(){
		var trans_sys_id = tans_dbms_pop_table.row('.selected').data().trans_sys_id;
		
		$.ajax({
			url : "/popup/deleteTransDBMS.do",
		  	data : {
		  		trans_sys_id : trans_sys_id
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
				if(result == true){
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_trans_dbms_pop_search();
				}else{
					msgVale = "<spring:message code='data_transfer.btn_title01' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
</script>

<%@include file="../popup/transDbmsRegForm.jsp"%>
<%@include file="../popup/transDbmsRegReForm.jsp"%>

<div class="modal fade" id="pop_layer_trans_target_dbms" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 180px;">
		<div class="modal-content" style="width:1300px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.btn_title01"/>
				</h4>
		
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row" style="margin-top:-10px;margin-bottom:-20px;">
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_trans_sys_nm" name="pop_trans_sys_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="migration.system_name" />'/>		
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_ipadr" name="pop_ipadr" onblur="this.value=this.value.trim()" placeholder='<spring:message code="history_management.ip" />'/>		
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_dtb_nm" name="pop_dtb_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.database" />'/>		
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_trans_dbms_pop_search();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					
					<div class="card-body">
						<div class="row" style="margin-top:-20px;margin-right:-30px;">
							<div class="col-12">
								<div class="template-demo">	
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsDelete" onClick="fn_transDbmsChk('delete');" >
										<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsModify" onClick="fn_transDbmsChk('update');" data-toggle="modal">
										<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsInsert" onClick="fn_transDbmsIns_pop();" data-toggle="modal">
										<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
									</button>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i> DBMS LIST</p>
						
						<table id="tansDbmsPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="170"><spring:message code="migration.system_name"/></th>
 									<th width="100">DBMS<spring:message code="common.division" /></th>
									<th width="150"><spring:message code="data_transfer.ip" /></th>
									<th width="100">Database</th>
									<th width="150">Schema</th>
									<th width="100"><spring:message code="data_transfer.port" /></th>
									<th width="130"><spring:message code="dbms_information.account" /></th>
									<th width="0"><spring:message code="common.modify_datetime" /></th>
								</tr>
							</thead>
						</table>
					</div>
					
					<br/>
					
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>