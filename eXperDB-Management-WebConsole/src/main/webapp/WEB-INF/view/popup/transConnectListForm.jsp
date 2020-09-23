<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	var trans_kafka_con_pop_table = null;
	
	$(window.document).ready(function() {
		fn_trans_kafka_con_pop_init();
		
	  	$(function() {	
	  		//row 클릭시
	  		$('#transKfkConPopList tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
	  	     	}else {	        	
	  	     		trans_kafka_con_pop_table.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');	            
				} 
	  		})		
	  	});
	});

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_trans_kafka_con_delete(){
		var datas = null;
		datas = trans_kafka_con_pop_table.row('.selected').data();
		if (datas == null) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		} else {
			if (datas.length <= 0) {
				showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}else if(datas.length > 1){
				showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}

		var kc_id = trans_kafka_con_pop_table.row('.selected').data().kc_id;

		$.ajax({
			url : "/popup/deleteTransKafkaConnect.do",
		  	data : {
		  		kc_id : kc_id
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
					fn_trans_kafka_con_pop_search();
				}else{
					msgVale = "<spring:message code='data_transfer.btn_title01' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	

	/* ********************************************************
	 * kafka 수정 팝업페이지 호출
	 ******************************************************** */
	function fn_trans_kfk_con_upd_pop(){
		var datas = null;
		datas = trans_kafka_con_pop_table.row('.selected').data();
		if (datas == null) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		} else {
			if (datas.length <= 0) {
				showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}else if(datas.length > 1){
				showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}
		
		var kc_id = trans_kafka_con_pop_table.row('.selected').data().kc_id;

		$.ajax({
			url : "/popup/transTargetKfkConUdt.do",
			data : {
				kc_id : kc_id
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if (result.resultInfo != null) {
					fn_tansKafkaConModPopStart(result);
					
					$('#pop_layer_trans_kfk_con_reg_re').modal("show");
				} else {
					showSwalIcon(message_msg01, closeBtn, '', 'error');
					$('#pop_layer_trans_kfk_con_reg_re').modal("hide");
					return;
				}
			}
		});
	}
</script>

<%@include file="../popup/transKafkaConRegForm.jsp"%>
<%@include file="../popup/transKafkaConRegReForm.jsp"%>

<div class="modal fade" id="pop_layer_trans_con_list" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 60px 300px;">
		<div class="modal-content" style="width:1000px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.btn_title02"/>
				</h4>
		
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row" style="margin-top:-10px;margin-bottom:-20px;">
							<div class="input-group mb-2 mr-sm-2 col-sm-4">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_trans_kafka_con_nm" name="pop_trans_kafka_con_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="etc.etc04" />'/>		
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_trans_kafka_con_pop_search();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					
					<div class="card-body">
						<div class="row" style="margin-top:-20px;margin-right:-30px;">
							<div class="col-12">
								<div class="template-demo">	
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsDelete" onClick="fn_trans_kafka_con_delete();" >
										<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsModify" onClick="fn_trans_kfk_con_upd_pop();" data-toggle="modal">
										<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
									</button>
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTransDmbsInsert" onClick="fn_trans_kfk_con_Ins_pop();" data-toggle="modal">
										<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
									</button>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i> kafka Connect LIST</p>
						
						<table id="transKfkConPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="200"><spring:message code="etc.etc04"/></th>
 									<th width="123"><spring:message code="data_transfer.ip" /></th>
									<th width="100"><spring:message code="data_transfer.port" /></th>
									<th width="130"><spring:message code="data_transfer.connection_status" /></th>
									<th width="100"><spring:message code="common.modify_datetime" /></th>
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