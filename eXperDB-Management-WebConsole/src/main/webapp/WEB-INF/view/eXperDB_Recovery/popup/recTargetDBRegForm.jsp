<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : recTargetDBRegForm.jsp
	* @Description : 대상 DB 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-06-10	신예은 매니저		최초 생성
	*
	* author 신예은
	* since 2021.06.10
	*
	*/
%>

<script type="text/javascript">

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {

	});
	
	function fn_serverInfoSetting(data){
		$("#regMachineMAC").val(data.guestMac);
		$("#regMachineIP").val(data.guestIp);
		$("#regMachineSNM").val(data.guestSubnetmask);
		$("#regMachineGateWay").val(data.guestGateway);
		$("#regMachineDNS").val(data.guestDns);
		$("#regMachineNW").val(data.guestNetwork);
	}

	function fn_recoveryDBReg(){
		if(fn_dupCheckIp()){
			$.ajax({
				url : "/experdb/recoveryDBReg.do",
				type : "post",
				data : {
					mac : $("#regMachineMAC").val(),
					ip : $("#regMachineIP").val(),
					snm : $("#regMachineSNM").val(),
					gateway : $("#regMachineGateWay").val(),
					dns : $("#regMachineDNS").val(),
					network : $("#regMachineNW").val()
				}
			})
			.done(function(data){
				fn_targetListPopup();
				fn_recTargetDBRegClose();
				
			})
			.fail (function(xhr, status, error){
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if (xhr.status == 403){
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			})
		}
	}
	
	function fn_dupCheckIp(){
		for(var i =0; i<ipList.length; i++){
			if(ipList[i] == $("#regMachineIP").val()){
				showSwalIcon('동일한 ip의 서버가 존재합니다. 삭제 후 등록해주세요', '<spring:message code="common.close" />', '', 'error', 'top');
				return false;
			}
		}
		return true;
	}

	function fn_recTargetDBRegClose(){
		$("#pop_layer_popup_recTargetDBRegForm").modal('hide');
	}
	 
</script>
<form name="serverRegInfo">
	<input type="hidden" name="regMachineNW"  id="regMachineNW">	
</form>
	
<div class="modal fade" id="pop_layer_popup_recTargetDBRegForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 600px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<fieldset>
						<!-- backup destination -->
							<div style=" margin-bottom: 20px;">
								<div class="card my-sm-2" >
									<div class="card-body">
										<!-- <div class="row"> -->
											<div class="col-12">
												<form class="cmxform" id="optionForm">
													<fieldset>			
														<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
															<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
																MAC
															</div>
															<div class="col-7" style="padding-left: 0px;">
																<input type="text" id="regMachineMAC" name="regMachineMAC" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
															</div>
														</div>
														<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
															<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
																IP
															</div>
															<div class="col-7" style="padding-left: 0px;">
																<input type="text" id="regMachineIP" name="regMachineIP" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
															</div>
														</div>
														<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
															<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
																Subnet Mask
															</div>
															<div class="col-7" style="padding-left: 0px;">
																<input type="text" id="regMachineSNM" name="regMachineSNM" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
															</div>
														</div>
														<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
															<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
																Default Gateway
															</div>
															<div class="col-7" style="padding-left: 0px;">
																<input type="text" id="regMachineGateWay" name="regMachineGateWay" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
															</div>
														</div>
														<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
															<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
																DNS
															</div>
															<div class="col-7" style="padding-left: 0px;">
																<input type="text" id="regMachineDNS" name="regMachineDNS" class="form-control form-control-sm" style="height: 40px; background-color:#ffffffdd;" readonly/>
															</div>
														</div>
													</fieldset>
												</form>		
											</div>
										<!-- </div> -->
									</div>
									<div style="position: absolute;top:-5px; right:60%; width: 200px;">
										<h4 class="card-title" style="background-color: white;font-size: 1em; color: #000000; ">
											Target Machine Setting
										</h4>
									</div>
								</div>
							</div>
						
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_recoveryDBReg()"><spring:message code="common.registory"/></button>
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>