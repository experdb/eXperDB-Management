<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transComConSetForm.jsp
	* @Description : 기본설정 선택 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 
	* since 2020. 04. 07
	*
	*/
%>

<style>
.null_red {
  color: red;
}
</style>

<script>
	var trans_com_con_pop_table = null;
	var trans_com_id_List = [];

	$(window.document).ready(function() {
		fn_trans_com_con_pop_init();
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_trans_com_con_pop_init(){
		trans_com_con_pop_table = $('#transComConSetPopList').DataTable({
			scrollY : "330px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			columns : [
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
						{data : "trans_com_cng_nm", className : "dt-center", defaultContent : "",orderable : false
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}
						},
						{data : "", className : "dt-center", defaultContent : "",orderable : false
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + '<spring:message code="eXperDB_CDC.unregistered" />' + '</span>';
 								} else {
 									html = '<spring:message code="eXperDB_CDC.add_complet" />';
 								}

								return html;
 							}
						},
 						{data : "plugin_name", className : "dt-center", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}
 						},
 						{data : "heartbeat_interval_ms", className : "dt-right", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}
 						},
 						{data : "max_batch_size", className : "dt-right", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}						
 						},
 						{data : "max_queue_size", className : "dt-right", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}						
 						},
 						{data : "offset_flush_interval_ms", className : "dt-right", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}						
 						}, 						
 						{data : "offset_flush_timeout_ms", className : "dt-right", defaultContent : ""
 							,render: function (data, type, full) {
 								var color = 'red';
 								var html = "";
 								if(full.heartbeat_action_query == null || full.heartbeat_action_query == ""){
 									html = '<span style="color:' + color + '">' + data + '</span>';
 								} else {
 									html = data;
 								}
 							  return html;
 							}						
 						},
 						{data : "trans_com_id",  defaultContent : "", visible: false }
 			],'select': {'style': 'multi'}
		});

		trans_com_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '120px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');		
		trans_com_con_pop_table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');	
		trans_com_con_pop_table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_trans_com_con_delete_logic(){
		$.ajax({
			url : "/deleteTransComConSet.do",
		  	data : {
		  		trans_com_id_List : JSON.stringify(trans_com_id_List)
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
					fn_trans_com_con_pop_search();
				}else{
					msgVale = "<spring:message code='data_transfer.default_setting' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
</script>

<%@include file="../popup/transComConSetRegForm.jsp"%>
<%@include file="../popup/transComConSetReRegForm.jsp"%>

<div class="modal fade" id="pop_layer_con_com_ins_list" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 180px;">
		<div class="modal-content" style="width:1300px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.default_setting"/>
				</h4>
		
				<div class="card" style="margin-top:10px;border:0px;">					
					<div class="card-body">
						<div class="row" style="margin-top:-50px;margin-right:-30px;">
							<div class="col-12">
								<div class="template-demo">	
									<button type="button" class="btn btn-outline-danger btn-icon-text mb-2 btn-search-disable" style="border:none;text-align:left;" id="btnPopCommonConChk" onClick="#">
										<i class="fa fa-check-circle-o btn-icon-prepend "></i><spring:message code="eXperDB_CDC.msg39" />
									</button>

									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsDelete" onClick="fn_transComConSetDelete();" >
										<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsModify" onClick="fn_transComConSetUpd_pop();" data-toggle="modal">
										<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsInsert" onClick="fn_transComConSetIns_pop();" data-toggle="modal">
										<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
									</button>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i><spring:message code="data_transfer.default_setting"/> LIST</p>
						
						<table id="transComConSetPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="150"><spring:message code="data_transfer.default_setting_name" /></th>
									<th width="150"><spring:message code="eXperDB_CDC.heartbeat_regist_yn" /></th>
									<th width="120">plugin.name</th>
 									<th width="100">heartbeat.interval.ms</th>
									<th width="100">max.batch.size</th>
									<th width="100">max.queue.size</th>
									<th width="100">offset.flush.interval.ms</th>
									<th width="100">offset.flush.timeout.ms</th>
									<th width="0"></th>
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