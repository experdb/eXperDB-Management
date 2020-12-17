<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : securitySet.jsp
	* @Description : securitySet 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*  2020.08.06   변승우 과장		UI 디자인 변경	
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>
<script>

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_buttonAut();
		fn_makeSelect01();
		fn_makeSelect02();
		fn_makeSelect03();
		
		fn_selectEncriptSet();
	});

	function fn_buttonAut(){
		var btnSave = document.getElementById("btnSave"); 

		if("${wrt_aut_yn}" == "Y"){
			btnSave.style.display = '';
		}else{
			btnSave.style.display = 'none';
		}
	}

	/* ********************************************************
	 * 관리서버 모니터링 주기
	 ******************************************************** */
	 function fn_makeSelect01(){
		var sec = "";
		var secHtml ="";

		secHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="MONITOR_POLLING_SERVER" id="MONITOR_POLLING_SERVER">';	
		for(var i=10; i<=599; i++){
			if(i >= 0 && i<10){
				sec = i;
			}else{
				sec = i;
			}
			secHtml += '<option value="'+sec+'">'+sec+'</option>';
		}
		secHtml += '</select>';	
		$( "#period01" ).append(secHtml);
	}

	 /* ********************************************************
	  * 에이전트와 관리서버 통신 주기
	  ******************************************************** */
	  function fn_makeSelect02(){
		var sec = "";
		var secHtml ="";
		
		secHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="MONITOR_POLLING_AGENT" id="MONITOR_POLLING_AGENT">';	
		for(var i=5; i<=399; i++){
			if(i >= 0 && i<10){
				sec = i;
			}else{
				sec = i;
			}
			secHtml += '<option value="'+sec+'">'+sec+'</option>';
		}
		secHtml += '</select> ';	
		$( "#period02" ).append(secHtml);
	 }

	/* ********************************************************
	 * 암호화 키의 유효기간이 다음 날짜 이하로 남으면 경고
	******************************************************** */
	function fn_makeSelect03(){
		var sec = "";
		var secHtml ="";

		secHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="MONITOR_EXPIRE_CRYPTO_KEY" id="MONITOR_EXPIRE_CRYPTO_KEY">';	
		for(var i=10; i<=599; i++){
			if(i >= 0 && i<10){
				sec = i;
			}else{
				sec = i;
			}
			secHtml += '<option value="'+sec+'">'+sec+'</option>';
		}
		secHtml += '</select>';	
		$( "#period03" ).append(secHtml);
	}

	function fn_selectEncriptSet(){
		$.ajax({
			url : "/selectEncryptSet.do", 
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
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					if(data.list[0].ValueTrueFalse == true){
						$("#ValueTrueFalse").attr('checked', true);
					}else{
						$("#ValueTrueFalse").attr('checked', false);
					}				
					if(data.list[0].MONITOR_AGENT_AUDIT_LOG_HMAC == true){
						$("#MONITOR_AGENT_AUDIT_LOG_HMAC").attr('checked', true);
					}else{
						$("#MONITOR_AGENT_AUDIT_LOG_HMAC").attr('checked', false);
					}					
					$("#MONITOR_POLLING_AGENT").val(data.list[0].MONITOR_POLLING_AGENT);
					$("#MONITOR_EXPIRE_CRYPTO_KEY").val(data.list[0].MONITOR_EXPIRE_CRYPTO_KEY);				
					$("#MONITOR_POLLING_SERVER").val(data.list[0].MONITOR_POLLING_SERVER);
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

	function fn_save(){
		var arrmaps = [];
		var tmpmap = new Object();

		tmpmap["ValueTrueFalse"] =$("#ValueTrueFalse").prop("checked");
		tmpmap["MONITOR_AGENT_AUDIT_LOG_HMAC"] = $("#MONITOR_AGENT_AUDIT_LOG_HMAC").prop("checked");
		tmpmap["MONITOR_POLLING_AGENT"] = $("#MONITOR_POLLING_AGENT").val();
		tmpmap["MONITOR_EXPIRE_CRYPTO_KEY"] = $("#MONITOR_EXPIRE_CRYPTO_KEY").val();
		tmpmap["MONITOR_POLLING_SERVER"] = $("#MONITOR_POLLING_SERVER").val();
		arrmaps.push(tmpmap);

		$.ajax({
			url : "/saveEncryptSet.do", 
			data : {
				arrmaps : JSON.stringify(arrmaps),
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
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIcon('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');	
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

	function fn_confirm(){
		fn_ConfirmModal();
	}

	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_ConfirmModal() {
		confirm_title = '<spring:message code="encrypt_encryptSet.Encryption_Settings"/>' + " " + '<spring:message code="common.save" />';
		 $('#confirm_msg').html('<spring:message code="message.msg148" />');

		$('#confirm_tlt').html(confirm_title);
		$('#pop_confirm_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmRst(){
		fn_save();
	}
</script>


<%@include file="./../../popup/confirmForm.jsp"%>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_encryptSet.Encryption_Settings"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ENCRYPT</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Settings"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_encryptSet.Encryption_Settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_Settings"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave" onClick="fn_confirm();">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.save" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card card-inverse-info"  style="height:25px;">
							<i class="mdi mdi-blur" style="margin-left: 10px;">	<spring:message code="encrypt_encryptSet.Encryption_Settings"/> </i>
						</div>

						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<form class="cmxform" id="optionForm">
											<fieldset>		
																						
												<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">					
													<div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              	<input type="checkbox" class="form-check-input" id="ValueTrueFalse" name="ValueTrueFalse" >
									                             	<spring:message code="encrypt_encryptSet.Stop_Transfer_Policy"/>
									                            <i class="input-helper"></i></label>
									                 </div>					
												</div>		
																				
												<div class="form-group row" style="margin-bottom:10px;">
														<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="margin-left: 75px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="encrypt_encryptSet.Monitoring_Period"/>
														</label>
														<div class="col-sm-1" style=" margin-left: 70px;">
															<div id = "period01"></div>
														</div>											
														 <div style="margin-top:15px;"><spring:message code="schedule.second" /> </div>													
												</div>						
													
												<div class="form-group row" style="margin-bottom:10px;">
														<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="margin-left: 75px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="encrypt_encryptSet.Communication_period_between_agent_and_management_server"/>
														</label>
														<div class="col-sm-1" style=" margin-left: 70px;">
															<div id = "period02"></div>
														</div>											
														 <div style="margin-top:15px;"><spring:message code="schedule.second" />(5 ~ 86400<spring:message code="schedule.second" />)</div>												
												</div>	
												
												<div class="form-group row" style="margin-bottom:10px;">
														<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="margin-left: 75px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="encrypt_encryptSet.Warning_when_the_encryption_key_is_valid_for_less_than"/>
														</label>
														<div class="col-sm-1" style=" margin-left: 70px;">
															<div id = "period03"></div>
														</div>											
														 <div style="margin-top:15px;"><spring:message code="schedule.day" />(10 ~ 600<spring:message code="schedule.day" />)</div>													
												</div>					
																										
												<div class="form-group row" style="margin-bottom:10px;margin-left: 50px;">					
													<div class="form-check"  style="margin-left: 20px;">
									                            <label class="form-check-label">
									                              	<input type="checkbox" class="form-check-input" id="MONITOR_AGENT_AUDIT_LOG_HMAC" name="MONITOR_AGENT_AUDIT_LOG_HMAC" >
									                             	<spring:message code="encrypt_encryptSet.Apply_forgery_prevention_to_logs"/>
									                            <i class="input-helper"></i></label>
									                 </div>					
												</div>		
												
										</fieldset>
									</form>	
							 	</div>
						 	</div>
						</div>
					</div>

					
				</div>
			</div>
		</div>
	</div>
</div>