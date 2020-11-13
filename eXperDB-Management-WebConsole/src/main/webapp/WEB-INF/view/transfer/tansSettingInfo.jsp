<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : tansSettingInfo.jsp
	* @Description : 전송관리 상세 조회
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2020. 04. 07
	*
	*/
%>

<script type="text/javascript">
	var info_connector_tableList = null;

	$(window.document).ready(function() {
		//테이블셋팅
		fn_info_init();
	});

	/* ********************************************************
	 * 테이블 설정
	 ******************************************************** */
	function fn_info_init(){
		info_connector_tableList = $('#info_connector_tableList').DataTable({
			scrollY : "200px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : false,	
			bSort: false,
			columns : [
				{data : "schema_name", className : "dt-center", defaultContent : ""},
				{data : "table_name", className : "dt-center", defaultContent : ""},			
			 ]
		});
		
		info_connector_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '397px');
		info_connector_tableList.tables().header().to$().find('th:eq(1)').css('min-width', '397px');

		$(window).trigger('resize'); 
	}
</script>

<div class="modal fade" id="pop_layer_trans_info" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.trans_management"/> <spring:message code="data_transfer.detail_search"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="searchInfoForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="table-responsive">
									<table id="connectInfoPopList" class="table system-tlb-scroll" style="width:100%;">
										<colgroup>
											<col style="width: 44%;" />
											<col style="width: 36%;" />
											<col style="width: 20%;" />
										</colgroup>
										<thead>
											<tr class="bg-info text-white">
												<th class="table-text-align-c">Kafka-Connect <spring:message code="data_transfer.server_name" /></th>
												<th class="table-text-align-c"><spring:message code="data_transfer.ip" /></th>
												<th class="table-text-align-c"><spring:message code="data_transfer.port" /></th>
											</tr>
										</thead>
										<tbody>
											<tr style="border-bottom: 1px solid #adb5bd;">
												<td class="table-text-align-c" id="d_kc_id_nm"></td>				
												<td class="table-text-align-c" id="d_kc_ip"></td>												
												<td class="table-text-align-c" id="d_kc_port"></td>								
											</tr>					
										</tbody>
									</table>
								</div>
							</div>
						</fieldset>
					</form>

					<br/>
	
					<div class="card-body" style="padding: 0px 0px 0px 0px;">
						<div class="form-group row div-form-margin-z">
							<div class="col-12" >
								<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
									<li class="nav-item">
										<a class="nav-link active" id="info-tab-1" data-toggle="pill" href="#infoSettingTab" role="tab" aria-controls="infoSettingTab" aria-selected="true" >
											<spring:message code="data_transfer.connect_set" />
										</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" id="info-tab-2" data-toggle="pill" href="#infoTableTab" role="tab" aria-controls="infoTableTab" aria-selected="false">
											<spring:message code="data_transfer.table_mapping" />
										</a>
									</li>
								</ul>
							</div>
						</div>
						
						<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;">
							<div class="tab-pane fade show active" role="tabpanel" id="infoSettingTab">
								<form class="cmxform" id="infoRegForm">
									<fieldset>
										<div class="form-group row" style="margin-bottom:5px;">
											<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.connect_name_set" />
											</label>
											<div class="col-sm-8">
												<span class="form-control-xsm float-left text-muted" id="d_connect_nm" ></span>
											</div>
											<div class="col-sm-2">
												&nbsp;
											</div>
										</div>
	
										<div class="form-group row" style="margin-bottom:5px;">
											<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.database" />
											</label>
											<div class="col-sm-4">
												<span class="form-control-xsm float-left text-muted" id="d_db_id" ></span>
											</div>
											<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.metadata" />
											</label>
											<div class="col-sm-4">
												<div class="onoffswitch-pop">
													<span class="form-control-xsm float-left text-muted" id="d_meta_data_chk" ></span>
												</div>
											</div>
										</div>
	
										<div class="form-group row" style="margin-bottom:5px;">
											<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.snapshot_mode" />
											</label>
											<div class="col-sm-4">
												<span class="form-control-xsm float-left text-muted" id="d_snapshot_mode_nm" ></span>
											</div>
											<div class="col-sm-6">
												&nbsp;
											</div>
										</div>

										<div class="form-group row" style="margin-bottom:0px;">
											<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.default_setting"/>
											</label>
											<div class="col-sm-10">
											</div>
										</div>
										
										<div class="form-group row" style="margin-bottom:10px;">
											<div class="col-sm-12">
												<div class="table-responsive" style="margin-top:-10px;margin-bottom:10px;">
													<table id="connectInfoPopList" class="table system-tlb-scroll" style="width:100%;">
														<colgroup>
															<col style="width: 25%;" />
															<col style="width: 15%;" />
															<col style="width: 15%;" />
															<col style="width: 15%;" />
															<col style="width: 10%;" />
															<col style="width: 10%;" />
															<col style="width: 10%;" />
														</colgroup>
														<thead>
															<tr class="bg-info text-white">
																<th class="table-text-align-c"><spring:message code="data_transfer.default_setting_name" /></th>
																<th class="table-text-align-c">plugin.name</th>
																<th class="table-text-align-c">heartbeat.interval.ms</th>
																<th class="table-text-align-c">max.batch.size</th>
																<th class="table-text-align-c">max.queue.size</th>
																<th class="table-text-align-c">offset.flush.interval.ms</th>
																<th class="table-text-align-c">offset.flush.timeout.ms</th>
															</tr>
														</thead>
														<tbody>
															<tr style="border-bottom: 0px solid #adb5bd;">			
																<td class="table-text-align-c" id="d_sc_trans_com_cng_nm"></td>												
																<td class="table-text-align-c" id="d_sc_plugin_name"></td>
																<td class="table-text-align-c" id="d_sc_heartbeat_interval_ms"></td>	
																<td class="table-text-align-c" id="d_sc_max_batch_size"></td>	
																<td class="table-text-align-c" id="d_sc_max_queue_size"></td>	
																<td class="table-text-align-c" id="d_sc_offset_flush_interval_ms"></td>	
																<td class="table-text-align-c" id="d_sc_offset_flush_timeout_ms"></td>							
															</tr>					
														</tbody>
													</table>
												</div>
											</div>
										</div>

										<div class="form-group row" style="margin-bottom:0px;">
											<label class="col-sm-2_2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);margin-bottom:0px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.compression_type" />
											</label>
											<div class="col-sm-4">
												<span class="form-control-xsm float-left text-muted" id="d_compression_type_nm" ></span>
											</div>
										</div>
									</fieldset>
								</form>	
							</div>

							<div class="tab-pane fade" role="tabpanel" id="infoTableTab">	
								<div class="row">		
									<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-25px;">
 										<div class="card" style="border:0px;">
											<div class="card-body">
												<h4 class="card-title">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="data_transfer.transfer_table" />
												</h4>
	
								 				<table id="info_connector_tableList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="161" class="dt-center" ><spring:message code="migration.schema_Name" /></th>
															<th width="162" class="dt-center" ><spring:message code="migration.table_name" /></th>	
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
			</div>			

			<br/>

			<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>