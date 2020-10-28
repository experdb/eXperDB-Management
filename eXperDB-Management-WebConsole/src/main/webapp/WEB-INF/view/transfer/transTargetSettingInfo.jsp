<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : transTargetSettingInfo.jsp
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
	var info_target_connector_tableList = null;

	$(window.document).ready(function() {
		//테이블셋팅
		fn_info_target_init();
	});

	/* ********************************************************
	 * 테이블 설정
	 ******************************************************** */
	function fn_info_target_init(){
		info_target_connector_tableList = $('#info_tg_connector_tableList').DataTable({
			scrollY : "200px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : false,	
			bSort: false,
			columns : [
				{data : "idx", className : "dt-center", defaultContent : ""}, 
				{data : "topic_name", className : "dt-center", defaultContent : ""}	
			 ]
		});

		info_target_connector_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '150px');
		info_target_connector_tableList.tables().header().to$().find('th:eq(1)').css('min-width', '675px');

		$(window).trigger('resize'); 
	}
</script>

<div class="modal fade" id="pop_layer_target_trans_info" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="migration.target_system"/> <spring:message code="menu.trans_management"/> <spring:message code="data_transfer.detail_search"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="searchTargetInfoForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="table-responsive" style="margin-top:-10px;margin-bottom:-10px;">
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
											<tr style="border-bottom: 0px solid #adb5bd;">
												<td class="table-text-align-c" id="d_tg_kc_id_nm"></td>				
												<td class="table-text-align-c" id="d_tg_kc_ip"></td>												
												<td class="table-text-align-c" id="d_tg_kc_port"></td>								
											</tr>					
										</tbody>
									</table>
								</div>
							</div>
						</fieldset>
					</form>
				</div>

				<br/>
				
				<div class="card" style="margin-top:10px;border:0px;margin-bottom:-30px;">
					<form class="cmxform" id="infoTargetForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;margin-top:-20px;margin-bottom:8px;">
							
								<div class="form-group row" style="margin-bottom:0px;margin-top:-10px;">
									<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.connect_name_set" />
									</label>
									<div class="col-sm-8">
										<span class="form-control-xsm float-left text-muted" id="d_tg_connect_nm" ></span>
									</div>
									<div class="col-sm-2">
										&nbsp;
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:0px;">
									<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.target_system" />
									</label>
									<div class="col-sm-10">
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:0px;">
									<div class="col-sm-12">
										<div class="table-responsive" style="margin-top:-10px;margin-bottom:-10px;">
											<table id="connectInfoPopList" class="table system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 30%;" />
													<col style="width: 20%;" />
													<col style="width: 10%;" />
													<col style="width: 20%;" />
													<col style="width: 20%;" />
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c"><spring:message code="migration.system_name"/></th>
														<th class="table-text-align-c"><spring:message code="data_transfer.ip" /></th>
														<th class="table-text-align-c"><spring:message code="data_transfer.port" /></th>
														<th class="table-text-align-c">Database</th>
														<th class="table-text-align-c"><spring:message code="dbms_information.account" /></th>
													</tr>
												</thead>
												<tbody>
													<tr style="border-bottom: 0px solid #adb5bd;">			
														<td class="table-text-align-c" id="d_tg_system_name"></td>												
														<td class="table-text-align-c" id="d_tg_system_ip"></td>
														<td class="table-text-align-c" id="d_tg_system_port"></td>	
														<td class="table-text-align-c" id="d_tg_system_database"></td>	
														<td class="table-text-align-c" id="d_tg_system_account"></td>								
													</tr>					
												</tbody>
											</table>
										</div>
									</div>
								</div>

								<div class="form-group row" style="margin-top:20px;margin-bottom:-20px;">
									<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.transfer_table" />
									</label>
									<div class="col-sm-10">
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
										<div class="card" style="border:0px;">
											<div class="card-body" style="padding-left:0px;padding-right:0px;">	
								 				<table id="info_tg_connector_tableList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="100" class="dt-center" ><spring:message code="common.order" /></th>
															<th width="500" class="dt-center" ><spring:message code="data_transfer.topic_nm" /></th>	
														</tr>
													</thead>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>			

			<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>