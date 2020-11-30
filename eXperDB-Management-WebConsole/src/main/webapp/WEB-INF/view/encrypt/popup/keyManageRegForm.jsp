<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : keyManageRegForm.jsp
	* @Description : keyManageRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*  2020.08.04   변승우 과장		UI 디자인 변경
	
	
	* author 변승우 대리
	* since 2018.01.08
	*
	*/
%>


<script>
$(window.document).ready(function() {
	
	//캘린더 셋팅
	fn_insDateCalenderSetting();
	
});

//한글 입력 방지
function fn_checkResourceName(e) {
	var objTarget = e.srcElement || e.target;
	if(objTarget.type == 'text') {
	var value = objTarget.value;
	if(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/.test(value)) {
		 showSwalIcon('<spring:message code="encrypt_msg.msg22"/>', '<spring:message code="common.close" />', '', 'error');
   		objTarget.value = objTarget.value.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
  		}
	 }
}

/*validation 체크*/
function fn_validation(){
	var resourcename = document.getElementById('ResourceName');
	var CipherAlgorithmCode = document.getElementById('CipherAlgorithmCode');
	var ins_expr_dt = document.getElementById('ins_expr_dt');
	
	if (resourcename.value == "" || resourcename.value == "undefind" || resourcename.value == null) {
		 showSwalIcon('<spring:message code="encrypt_msg.msg17"/>', '<spring:message code="common.close" />', '', 'error');
		resourcename.focus();
		return false;
	}
	if (CipherAlgorithmCode.value == "" || CipherAlgorithmCode.value == "undefind" || CipherAlgorithmCode.value == null) {
		 showSwalIcon('<spring:message code="encrypt_msg.msg23"/>', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	if (ins_expr_dt.value == "" || ins_expr_dt.value == "undefind" || ins_expr_dt.value == null) {
		 showSwalIcon('<spring:message code="encrypt_msg.msg24"/>', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	return true;
}





function fn_insertCryptoKeySymmetric(){
	
	$.ajax({
		url : "/insertCryptoKeySymmetric.do", 
	  	data : {
	  		resourceName: $('#ResourceName').val(),
	  		cipherAlgorithmCode : $('#CipherAlgorithmCode').val(),
	  		resourceNote : $('#ResourceNote').val(),
	  		validEndDateTime : $('#ins_expr_dt').val().substring(0,10)
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
				showSwalIcon('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
				$('#pop_layer_keyManageRegForm').modal("hide");
				fn_select();
			}else if(data.resultCode == "8000000002"){
				showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
			}else if(data.resultCode == "0000000003"){		
				showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
			}			
		}
	});
	
}


/* ********************************************************
 * 작업기간 calender 셋팅
 ******************************************************** */
function fn_insDateCalenderSetting() {
	
	var today = new Date();

	today.setFullYear(today.getFullYear() + 2);
	var startDay = today.toJSON().slice(0,10);

	var endDay = fn_dateParse("20991231").toJSON().slice(0,10);

	$("#ins_expr_dt").val(startDay);
	
	if ($("#ins_expr_dt_div", "#keyInsForm").length) {
		$("#ins_expr_dt_div", "#keyInsForm").datepicker({
		}).datepicker('setDate', startDay)
		.datepicker('setStartDate', startDay)
		.datepicker('setEndDate', endDay)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		}); //값 셋팅
	}
	

	$("#ins_expr_dt", "#keyInsForm").datepicker('setStartDate', startDay).datepicker('setEndDate', endDay);
	$("#ins_expr_dt_div", "#keyInsForm").datepicker('updateDates'); 
	

	
	
	/* 
	var today = new Date();
	var startDay = fn_dateParse("20180101");
	var endDay = fn_dateParse("20991231");
	
	var day_today = today.toJSON().slice(0,10);
	var day_start = today.toJSON().slice(0,10);
	var day_end = endDay.toJSON().slice(0,10);

	let date = new Date(today.toJSON());
	date.setFullYear(date.getFullYear() + 2);
	var enc_day = date.toJSON().slice(0,10);
	alert(day_today);
	alert(enc_day);
	
	if ($("#ins_expr_dt_div", "#keyInsForm").length) {
		$("#ins_expr_dt_div", "#keyInsForm").datepicker({
		}).datepicker('setDate', enc_day)
		.datepicker('setStartDate', day_start)
		.datepicker('setEndDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		}); //값 셋팅
	}

	$("#ins_expr_dt", "#keyInsForm").datepicker('setDate', enc_day).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
	$("#ins_expr_dt_div", "#keyInsForm").datepicker('updateDates'); */
}


</script>

<div class="modal fade" id="pop_layer_keyManageRegForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_policy_management.Encryption_Key"/> <spring:message code="common.registory" />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="keyInsForm">

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Key_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="ResourceName" name="ResourceName"  maxlength="20" onkeyup='fn_checkResourceName(event)' style='ime-mode:disabled;' onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>
								</div>		

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Encryption_Algorithm"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="CipherAlgorithmCode" id="CipherAlgorithmCode" >
											<option value="<c:out value=""/>" ><spring:message code="common.choice" /></option>
											<c:forEach var="result" items="${result}"  varStatus="status">
												<option value="<c:out value="${result.sysCode}"/>"><c:out value="${result.sysCodeName}"/></option>
											</c:forEach> 
										</select>
									</div>											
								</div>			
					
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Description"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="ResourceNote" name="ResourceNote"   maxlength="100" onkeyup="fn_checkWord(this,100)" placeholder="100<spring:message code='message.msg188'/>"/>
									</div>
								</div>							

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Expiration_Date"/>
									</label>
									<div class="col-sm-4">
										<div id="ins_expr_dt_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="ins_expr_dt" name="ins_expr_dt"  tabindex=10 />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>										
								</div>	
							</div>					
						</fieldset>
					</form>
				</div>
							
				<div class="card-body">
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
						<button type="button" class="btn btn-primary" onclick="fn_confirm('ins');"><spring:message code="common.save"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>			
			</div>
		</div>
	</div>
</div>