<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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
						{ data : "trans_com_cng_nm", className : "dt-center", defaultContent : "",orderable : false},
 						{data : "plugin_name", className : "dt-center", defaultContent : ""},
 						{data : "heartbeat_interval_ms", className : "dt-right", defaultContent : ""},
 						{data : "max_batch_size", className : "dt-right", defaultContent : ""},
 						{data : "max_queue_size", className : "dt-right", defaultContent : ""},
 						{data : "offset_flush_interval_ms", className : "dt-right", defaultContent : ""}, 						
 						{data : "offset_flush_timeout_ms", className : "dt-right", defaultContent : ""},
 						{data : "trans_com_id",  defaultContent : "", visible: false }
 			],'select': {'style': 'multi'}
		});

		trans_com_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		trans_com_con_pop_table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');		
		trans_com_con_pop_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');	
		trans_com_con_pop_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 기본사항 팝업 시작
	 ******************************************************** */
	function fn_transCommonConSetPopStart(){
		//조회
		fn_trans_com_con_pop_search();
	}

	/* ********************************************************
	 * 기본사항 조회
	 ******************************************************** */
	function fn_trans_com_con_pop_search(){
		$.ajax({
			url : "/selectTransComConPopList.do",
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
				trans_com_con_pop_table.rows({selected: true}).deselect();
				trans_com_con_pop_table.clear().draw();
				if (nvlPrmSet(result, '') != '') {
					trans_com_con_pop_table.rows.add(result).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * 기본사항 등록 팝업페이지 호출
	 ******************************************************** */
	function fn_transComConSetIns_pop(){
		$('#pop_layer_con_com_ins_cng').modal("hide");

 		$.ajax({ 
			url : "/transComSettingCngIns.do",
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
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				fn_transComConSetRegPopStart(result);
				
				$('#pop_layer_con_com_ins_cng').modal("show");
			}
		});
	}

	/* ********************************************************
	 * 기본사항 수정팝업
	 ******************************************************** */
	function fn_transComConSetUpd_pop() {
		var datas = trans_com_con_pop_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		} 
		
		var mod_trans_com_id = trans_com_con_pop_table.row('.selected').data().trans_com_id;

		$.ajax({
			url : "/selectTransComSettingCngInfo.do",
			data : {
				trans_com_id : mod_trans_com_id
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
				if(result != null){
					fn_transComConSetModPopStart(result);
				}

				$('#pop_layer_con_com_mod_cng').modal('show');
			}
		});
	}

	/* ********************************************************
	 * trans common 삭제버튼 클릭시
	 ******************************************************** */
	function fn_transComConSetDelete(){
		var totDatas = trans_com_con_pop_table.data();
		var datas = trans_com_con_pop_table.rows('.selected').data();

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if (totDatas.length <= datas.length) {
			showSwalIcon('<spring:message code="data_transfer.msg33" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		trans_com_id_List = [];

		for (var i = 0; i < datas.length; i++) {
			trans_com_id_List.push(datas[i].trans_com_id);   
		}

		confile_title = '<spring:message code="data_transfer.default_setting" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("trans_com_con_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
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