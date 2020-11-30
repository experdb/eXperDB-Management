<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : agentMonitoringModifyForm.jsp
	* @Description : 암호화 에이전트 모니터링 수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.07.16   변승우 과장   UI 디자인 변경
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>

<script>
	function fn_agentStatusSave(){
		
		if($("#mod_entityStatusCode_chk").is(":checked") == true){
			$("#mod_entityStatusCode").val("ES50");
		} else {
			$("#mod_entityStatusCode").val("ES55");
		}
		
		$.ajax({
			url : "/agentStatusSave.do", 
		  	data : {		  		
		  		entityName : $('#mod_entityName').val(),
		  		entityUid : $('#mod_entityUid').val(),
		  		entityStatusCode : $('#mod_entityStatusCode').val(),
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
					showSwalIcon('<spring:message code="encrypt_msg.msg21"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_agentMonitoringModifyForm').modal('hide');
					fn_select();
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
					$('#pop_layer_agentMonitoringModifyForm').modal('hide');				
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error','securityKeySet');
					$('#pop_layer_agentMonitoringModifyForm').modal('hide');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_agentMonitoringModifyForm').modal('hide');	
					return false;
				}
			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_agentMonitoringModifyForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" >
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.mod_transfer_set"/>
				</h4>
								
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card card-inverse-info" >
						<i class="mdi mdi-blur" style="margin-left: 10px;">	<spring:message code="encrypt_policy_management.General_Information"/> </i>
					</div>
						<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #83b0d6e8; height:160px;">			
									<div class="tab-pane fade show active" role="tabpanel" id="insSettingTab">
										<form class="cmxform" id="baseForm">
											<input type="hidden" name="mod_entityUid" id="mod_entityUid" >
											<input type="hidden" name="mod_entityStatusCode" id="mod_entityStatusCode"/>
											<fieldset>								
												<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_agent.Agent_Name"/>
													</label>
													<div class="col-sm-4">
														<input type="text" class="form-control form-control-xsm" id="mod_entityName" name="mod_entityName"  onblur="this.value=this.value.trim()"  readonly="readonly"/>
													</div>
												</div>											
											<div class="form-group row" style="margin-bottom:10px;">
												<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
													<i class="item-icon fa fa-dot-circle-o"></i>
													Agent <spring:message code="access_control_management.activation" />
												</label>
												<div class="col-sm-4">
													<div class="activeswitch-pop">
														<input type="checkbox" name="mod_entityStatusCode_chk" class="activeswitch-pop-checkbox" id="mod_entityStatusCode_chk" />
														<label class="activeswitch-pop-label" for="mod_entityStatusCode_chk">
															<span class="activeswitch-pop-inner"></span>
															<span class="activeswitch-pop-switch"></span>
														</label>
													</div>
												</div>											
											</div>	
										</fieldset>
									</form>	
								</div>
							</div>						
						</div>				

					
				<div class="card" style="margin-top:10px;border:0px;">		
					<div class="card card-inverse-info">
						<i class="mdi mdi-blur" style="margin-left: 10px;">	<spring:message code="encrypt_agent.Additional_Information"/> </i>
					</div>
						<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #83b0d6e8; height:160px;">
									<div class="tab-pane fade show active" role="tabpanel" id="insSettingTab">
										<form class="cmxform" id="subForm">
											<fieldset>								
												<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_agent.Recently_accessed_address"/>
													</label>
													<div class="col-sm-4">
														<input type="text" class="form-control form-control-xsm" id="mod_latestAddress" name="mod_latestAddress"  onblur="this.value=this.value.trim()"  readonly="readonly"/>
													</div>
												</div>												
												<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_agent.Recently_Accessed_Time"/>
													</label>
													<div class="col-sm-4">
														<input type="text" class="form-control form-control-xsm" id="mod_latestDateTime" name="mod_latestDateTime"  onblur="this.value=this.value.trim()"  readonly="readonly"/>
													</div>											
												</div>	
											</fieldset>
										</form>	
									</div>
								</div>						
							</div>	
							
							<form class="cmxform" id="searchModForm">
								<fieldset>
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="table-responsive">
											<table id="connectModPopList" class="table system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 35%;" />
													<col style="width: 65%;" />
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c"><spring:message code="encrypt_agent.System_Key"/></th>
														<th class="table-text-align-c"><spring:message code="encrypt_agent.System_Value"/></th>
													</tr>
												</thead>
												<tbody id="mod_extendedField">				
												</tbody> 
											</table>
										</div>
									</div>
								</fieldset>
							</form>				
				</div>
				
			<div class="top-modal-footer" style="text-align: center !important; margin: -15px 0 0 -20px;" >
					<button type="button" class="btn btn-primary" onclick="fn_agentStatusSave();"><spring:message code="common.modify"/></button>
					<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
			
		</div>
	</div>
</div>