<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : securityPolicyRegForm.jsp
	* @Description : securityPolicyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*  2020.08.04   변승우 과장		UI 디자인 변경
	*
	* author 김주영 사원
	* since 2018.01.04
	*
	*/
%>

<script>

/*validation 체크*/
function fn_sec_mod_validation(){
	var offset = document.getElementById('mod_offset');
	var length = document.getElementById('mod_length');
	var cipherAlgorithmCode = document.getElementById('mod_cipherAlgorithmCode');
	var binUid = document.getElementById('mod_binUid');
	
	if (offset.value == "" || offset.value == "undefind" || offset.value == null) {
		showSwalIcon('<spring:message code="encrypt_msg.msg09"/>', '<spring:message code="common.close" />', '', 'error');;
		offset.focus();
		return false;
	}
	if($("input:checkbox[id='mod_last']").is(":checked")){
		$('#mod_length').val('<spring:message code="encrypt_policy_management.End"/>');
	}
	if (length.value == "" || length.value == "undefind" || length.value == null) {
		showSwalIcon('<spring:message code="encrypt_msg.msg10"/>', '<spring:message code="common.close" />', '', 'error');
		length.focus();
		return false;
	}	
	if(cipherAlgorithmCode.value!="SHA-256"){
		if (binUid.value == "" || binUid.value == "undefind" || binUid.value == null) {
			showSwalIcon('<spring:message code="encrypt_msg.msg11"/>', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
	}	
	return true;
}


/*수정버튼 클릭시*/
function fn_update(){
	if (!fn_sec_mod_validation()) return false;
	
	Result = new Object();
	
	Result.rnum = $("#mod_rnum").val();
	Result.offset = $("#mod_offset").val();
	Result.length = $("#mod_length").val();
	Result.cipherAlgorithmCode = $("#mod_cipherAlgorithmCode").val();
	if($("#mod_binUid > option:selected").attr("value2") == undefined){
		Result.binUid=null;
	}else{
		Result.binUid = $("#mod_binUid > option:selected").val();
	}
	if($("#mod_binUid > option:selected").attr("value2") == undefined){
		Result.resourceName=null;
	}else{
		Result.resourceName=$("#mod_binUid > option:selected").attr("value2");
	}
	Result.initialVectorTypeCode = $("#mod_initialVectorTypeCode").val();
	Result.operationModeCode = $("#mod_operationModeCode").val();

	var returnCheck= fn_SecurityUpdate(Result);   
	if(returnCheck==true){
		$('#pop_layer_securityPolicyRegReForm').modal("hide");
	}
}




/*길이 끝까지 선택시*/
function fn_mod_lastCheck(){
	if($("input:checkbox[id='mod_last']").is(":checked")){
		$('#mod_length').val('');
		$('#mod_length').attr('disabled', 'true');
	}else{
		$('#mod_length').removeAttr('disabled');
	}
}


/*알고리즘 선택시*/
function fn_mod_changeBinUid(selectObj){
	$("#mod_binUid").empty();
	var html = "";
	<c:forEach var="mod_binUid" items="${mod_binUid}">
	if(selectObj.value == "${mod_binUid.cipherAlgorithmName}"){
		html += "<option value=${mod_binUid.getBinUid} value2=${mod_binUid.resourceName} >${mod_binUid.resourceName} (${mod_binUid.validEndDate})</option>"
	}
	</c:forEach> 
	$("#mod_binUid").append(html);
}

</script>

<div class="modal fade" id="pop_layer_securityPolicyRegReForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="etc.etc01"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="modForm">
						<input type="hidden" name="mod_rnum" id="mod_rnum">	

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Starting_Position"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_offset" name="mod_offset"  maxlength="4" onKeyPress="NumObj(this);" />
									</div>
								</div>	

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Length"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_length" name="mod_length"  maxlength="4" onKeyPress="NumObj(this); "  />
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="mod_last" name="mod_last" onchange="fn_mod_lastCheck()">
											<spring:message code="encrypt_policy_management.End"/>
											<i class="input-helper"></i>
										</label>
									</div>						
								</div>	
					
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Encryption_Algorithm"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_cipherAlgorithmCode" id="mod_cipherAlgorithmCode"  onChange="fn_mod_changeBinUid(this)">
											<c:forEach var="mod_cipherAlgorithmCode" items="${mod_cipherAlgorithmCode}"  varStatus="status">
												<option value="<c:out value="${mod_cipherAlgorithmCode.sysCodeName}"/>" ${mod_cipherAlgorithmCodeValue eq mod_cipherAlgorithmCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${mod_cipherAlgorithmCode.sysCodeName}"/></option>
											</c:forEach> 
										</select>
									</div>
								</div>	

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Encryption_Key"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_binUid" id="mod_binUid" >
										</select>
									</div>										
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Initial_Vector"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_initialVectorTypeCode" id="mod_initialVectorTypeCode" >
											<c:forEach var="mod_initialVectorTypeCode" items="${mod_initialVectorTypeCode}"  >
												<option value="${mod_initialVectorTypeCode.sysCodeName}" ${mod_initialVectorTypeCodeValue eq mod_initialVectorTypeCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${mod_initialVectorTypeCode.sysCodeName}"/></option>
											</c:forEach>
										</select> 
									</div>										
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Modes"/>
									</label>
									<div class="col-sm-4">
										 <select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_operationModeCode" id="mod_operationModeCode" >
											<c:forEach var="mod_operationModeCode" items="${mod_operationModeCode}"  >
												<option value="${mod_operationModeCode.sysCodeName}" ${mod_operationModeCodeValue eq mod_operationModeCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${mod_operationModeCode.sysCodeName}"/></option>
											</c:forEach>
										</select>
									</div>										
								</div>		
							</div>					
						</fieldset>
					</form>
				</div>

				<div class="card-body">
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
						<button type="button" class="btn btn-primary" onclick="fn_update();"><spring:message code="common.modify"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>