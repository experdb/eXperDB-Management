<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : connectTargetRegForm.jsp
	* @Description : connectTargetRegForm 화면
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
	var mod_tg_topicList = null;
	var mod_connector_tg_tableList = null;

	$(window.document).ready(function() {
		fn_tg_mod_init();
	});

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function trans_target_mod_valCheck(){
		var valideMsg = "";

		if(nvlPrmSet($("#mod_tg_trans_trg_sys_nm", "#modTargetRegForm").val(), '') == "") {
			showSwalIcon('<spring:message code="data_transfer.msg6" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}

		//전성대상테이블 length 체크
		if (mod_connector_tg_tableList.rows().data().length <= 0) {
			showSwalIcon('<spring:message code="data_transfer.msg24"/>', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		return true;
	}
</script>

<div class="modal fade" id="pop_layer_con_re_reg_two_target" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="migration.target_system"/> <spring:message code="menu.mod_transfer_set"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="searchTargetModForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="table-responsive" style="margin-top:-10px;margin-bottom:-10px;">
									<table id="connectModTargetPopList" class="table system-tlb-scroll" style="width:100%;">
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
												<td class="table-text-align-c">
													<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_target_kc_nm" id="mod_target_kc_nm" disabled>
														<option value=""><spring:message code="common.choice" /></option>
														<c:forEach var="result" items="${kafkaConnectList}" varStatus="status">
															<option value="<c:out value="${result.kc_id}"/>"><c:out value="${result.kc_nm}"/></option>
														</c:forEach>
													</select>
												</td>				
												<td class="table-text-align-c">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="mod_tg_kc_ip" name="mod_tg_kc_ip" onblur="this.value=this.value.trim()" readonly />
												</td>												
												<td class="table-text-align-c">
													<input type="text" class="form-control form-control-xsm" maxlength="5" id="mod_tg_kc_port" name="mod_tg_kc_port" onblur="this.value=this.value.trim()" onKeyUp="chk_Number(this);" readonly />						
												</td>
											</tr>					
										</tbody>
									</table>
								</div>
							</div>
						</fieldset>
					</form>
				</div>

				<br/>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="modTargetRegForm">
						<input type="hidden" name="mod_tg_topic_mapp_nm" id="mod_tg_topic_mapp_nm" />
						<input type="hidden" name="mod_tg_trans_trg_sys_id"  id="mod_tg_trans_trg_sys_id">
						<input type="hidden" name="mod_tg_trans_id" id="mod_tg_trans_id" />
						<input type="hidden" name="mod_tg_trans_exrt_trg_tb_id" id="mod_tg_trans_exrt_trg_tb_id" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;margin-top:-20px;margin-bottom:8px;">
								<div class="form-group row" style="margin-bottom:0px;margin-top:-10px;">
									<label for="mod_tg_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.connect_name_set" />
									</label>
									<div class="col-sm-8">
										<input type="text" class="form-control form-control-xsm" id="mod_tg_connect_nm" name="mod_tg_connect_nm" maxlength="50" readonly />
									</div>
									<div class="col-sm-2">
										&nbsp;
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:6px;">
									<label for="mod_tg_trans_trg_sys_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.target_system" />
									</label>
									<div class="col-sm-6">
										<input type="text" class="form-control form-control-sm" id="mod_tg_trans_trg_sys_nm" name="mod_tg_trans_trg_sys_nm" readonly="readonly" />
									</div>
									<div class="col-sm-4">
										<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_mod_tg_dbmsInfo()"><spring:message code="button.create" /></button>
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:0px;">
									<label for="ins_tg_trans_trg_sys_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="access_control_management.activation" />
									</label>
									<div class="col-sm-6">
										<div class="onoffswitch-pop-play">
											<input type="checkbox" name="mod_target_transActive_act" class="onoffswitch-pop-play-checkbox" id="mod_target_transActive_act" onclick="fn_transActivation_msg_set('mod_target')" >
											<label class="onoffswitch-pop-play-label" for="mod_target_transActive_act">
												<span class="onoffswitch-pop-play-inner"></span>
												<span class="onoffswitch-pop-play-switch"></span>
											</label>
										</div>
									</div>
									<div class="col-sm-4">
										&nbsp;
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z" id="mod_target_trans_active_div" style="display:none;">
									<div class="col-sm-12">
										<div class="alert alert-info" style="margin-top:5px;margin-bottom:0px;" >
											<spring:message code="data_transfer.msg27" />
										</div>
									</div>
								</div>	
								
								<div class="form-group row" style="margin-bottom:-10px;">
									<div class="col-5 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="left_tg_mod_list">
										<div class="card" style="border:0px;">
											<div class="card-body" style="padding-left:0px;padding-right:0px;">
												<h4 class="card-title" style="margin-bottom:3px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="data_transfer.topicList" />
												</h4>
 	
									 			<table id="mod_tg_topicList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="336" class="dt-center" ><spring:message code="data_transfer.topic_nm" /></th>	
														</tr>
													</thead>
												</table>
											</div>
										</div>
									</div>

									<div class="col-1 stretch-card div-form-margin-table" style="max-width: 6%;" id="center_tg_mod_div">
										<div class="card" style="background-color: transparent !important;border:0px;">
											<div class="card-body">	
												<div class="card my-sm-2 connectTargetRegForm" style="border:0px;background-color: transparent !important;">
													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-top:50px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_tg_allRightMove();">
															<i class="fa fa-angle-double-right" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
														</a>
													</label>

													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-20px;">
														<a href="#" class="tip" onclick="fn_mod_t_tg_rightMove();">
															<i class="fa fa-angle-right" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
														</a>
													</label>

													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_tg_leftMove();">
															<i class="fa fa-angle-left" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_left_line" /></span>
														</a>
													</label>

													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_tg_allLeftMove();">
															<i class="fa fa-angle-double-left" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_all_left" /></span>
														</a>
													</label>
												</div>
											</div>
										</div>
									</div>
	
									<div class="col-5 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="right_tg_mod_list">
										<div class="card" style="border:0px;">
											<div class="card-body" style="padding-left:0px;padding-right:0px;">
												<h4 class="card-title" style="margin-bottom:3px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="data_transfer.transfer_table" />
												</h4>
	
								 				<table id="mod_connector_tg_topicList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="336" class="dt-center" ><spring:message code="data_transfer.topic_nm" /></th>	
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

			<br/>

			<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
				<button type="button" class="btn btn-primary" onclick="fn_target_mod_update();"><spring:message code="common.registory"/></button>
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>