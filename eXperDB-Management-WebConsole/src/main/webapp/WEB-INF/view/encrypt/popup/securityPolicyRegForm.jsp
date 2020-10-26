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


/*숫자체크*/
function NumObj(obj) {
	if (event.keyCode >= 48 && event.keyCode <= 57) {
		return true;
	} else {
		(event.preventDefault) ? event.preventDefault() : event.returnValue = false;
	}
}


/*validation 체크*/
function fn_sec_validation(){
	var offset = document.getElementById('pop_offset');
	var length = document.getElementById('pop_length');
	var cipherAlgorithmCode = document.getElementById('pop_cipherAlgorithmCode');
	var binUid = document.getElementById('pop_binUid');
	
	if (offset.value == "" || offset.value == "undefind" || offset.value == null) {
		showSwalIcon('<spring:message code="encrypt_msg.msg09"/>', '<spring:message code="common.close" />', '', 'error');
		offset.focus();
		return false;
	}
	if($("input:checkbox[id='pop_last']").is(":checked")){
		$('#pop_length').val('<spring:message code="encrypt_policy_management.End"/>');
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



/*저장버튼 클릭시*/
function fn_sec_save(){
	if (!fn_sec_validation()) return false;
	
	Result = new Object();
	
	Result.offset = $("#pop_offset").val();
	Result.length = $("#pop_length").val();
	Result.cipherAlgorithmCode = $("#pop_cipherAlgorithmCode").val();
	Result.binUid = $("#pop_binUid > option:selected").val();
	Result.resourceName=$("#pop_binUid > option:selected").attr("value2");
	Result.initialVectorTypeCode = $("#pop_initialVectorTypeCode").val();
	Result.operationModeCode = $("#pop_operationModeCode").val();

	var returnCheck= fn_SecurityAdd(Result);
	if(returnCheck==true){
		$('#pop_layer_securityPolicyRegForm').modal("hide");
	}else{
		$('#pop_length').val('');
		$("#pop_last").prop('checked', false);
		$('#pop_length').attr('disabled', false);
		showSwalIcon('<spring:message code="encrypt_msg.msg12"/>', '<spring:message code="common.close" />', '', 'error');
	}
}



/*길이 끝까지 선택시*/
function fn_lastCheck(){
	if($("input:checkbox[id='pop_last']").is(":checked")){
		$('#pop_length').val('');
		$('#pop_length').attr('disabled', 'true');
	}else{
		$('#pop_length').removeAttr('disabled');
	}
}

/*알고리즘 선택시*/
function fn_changeBinUid(selectObj){
	$("#pop_binUid").empty();
	var html = "";
	<c:forEach var="pop_binUid" items="${pop_binUid}">
	if(selectObj.value == "${pop_binUid.cipherAlgorithmName}"){
		html += "<option value=${pop_binUid.getBinUid} value2=${pop_binUid.resourceName} >${pop_binUid.resourceName} (${pop_binUid.validEndDate})</option>"
	}
	</c:forEach> 
	$("#pop_binUid").append(html);
}

</script>

<div class="modal fade" id="pop_layer_securityPolicyRegForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="etc.etc01"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="baseForm">

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Starting_Position"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="pop_offset" name="pop_offset"  maxlength="4" onKeyPress="NumObj(this);" />
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Length"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="pop_length" name="pop_length"  maxlength="4" onKeyPress="NumObj(this); "  />
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="pop_last" name="pop_last" onchange="fn_lastCheck()">
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
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="pop_cipherAlgorithmCode" id="pop_cipherAlgorithmCode"  onChange="fn_changeBinUid(this)">
											<c:forEach var="pop_cipherAlgorithmCode" items="${pop_cipherAlgorithmCode}"  varStatus="status">
												<option value="<c:out value="${pop_cipherAlgorithmCode.sysCodeName}"/>" ${pop_cipherAlgorithmCodeValue eq pop_cipherAlgorithmCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${pop_cipherAlgorithmCode.sysCodeName}"/></option>
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
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="pop_binUid" id="pop_binUid" >
										</select>
									</div>										
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Initial_Vector"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="pop_initialVectorTypeCode" id="pop_initialVectorTypeCode" >
											<c:forEach var="pop_initialVectorTypeCode" items="${pop_initialVectorTypeCode}"  >
												<option value="${pop_initialVectorTypeCode.sysCodeName}" ${pop_initialVectorTypeCodeValue eq pop_initialVectorTypeCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${pop_initialVectorTypeCode.sysCodeName}"/></option>
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
										 <select class="form-control form-control-xsm" style="margin-right: 1rem;" name="pop_operationModeCode" id="pop_operationModeCode" >
											<c:forEach var="pop_operationModeCode" items="${pop_operationModeCode}"  >
												<option value="${pop_operationModeCode.sysCodeName}" ${pop_operationModeCodeValue eq pop_operationModeCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${pop_operationModeCode.sysCodeName}"/></option>
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
						<button type="button" class="btn btn-primary" onclick="fn_sec_save();"><spring:message code="common.save"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>							
			</div>
		</div>
	</div>
</div>