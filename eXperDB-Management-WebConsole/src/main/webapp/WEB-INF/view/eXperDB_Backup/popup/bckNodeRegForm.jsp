<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : bckNodeRegForm.jsp
	* @Description : 백업 대상 서버 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-02-18	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.02.18
	*
	*/
%>

<script type="text/javascript">

 var ipadr = [];

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_nodeRegReset();
		
	});
	
	$(function(){
		$(document).ajaxStart(function() {	
		    $("#loader").show();	
		});
		
		//AJAX 통신 종료
		$(document).ajaxStop(function() {
			$("#loader").hide();
		});
	});
	
	

	/* ********************************************************
	 * registration reset
	 ******************************************************** */
	function fn_nodeRegReset() {
		// $("#loader").hide();
		
		$("#ipAddr").prop("disabled", false);
		$("#userCred").prop('checked', false);
		fn_userCredentClick();
		
		// $("#rootName").val("");
		$("#rootPW").val("");
		$("#userCredName").val("");
		$("#userCredPw").val("");
		$("#description").val("");
		
		// $("#rootNameAlert").empty();
		$("#rootPWAlert").empty();
		$("#userCredNameAlert").empty();
		$("#userCredPwAlert").empty();
		
		$("#ModalLabel_Reg").show();
		$("#ModalLabel_Modi").hide();
		$("#regButton").show();
		$("#modiButton").hide();		

	}

	/* ********************************************************
	 * modification reset
	 ******************************************************** */
	function fn_nodeModiReset(result){
		$("#loader").hide();
		if(result.userName == null || result.userName == ""){
			$("#userCred").prop('checked', false);
		}else{
			$("#userCred").prop('checked', true);
		}
		fn_userCredentClick();

		var html = '<option value="' + result.ipadr + '">' + result.ipadr + '</option>';
		$("#ipAddr").prop("disabled", true);
		$("#ipAddr").empty();
		$("#ipAddr").append(html);
		
		// $("#rootName").val(result.rootName);
		$("#userCredName").val(result.userName);
		$("#description").val(result.description);
		
		$("#rootPW").val("");
		$("#userCredPw").val("");
		
		
		// $("#rootNameAlert").empty();
		$("#rootPWAlert").empty();
		$("#userCredNameAlert").empty();
		$("#userCredPwAlert").empty();
	
		$("#ModalLabel_Reg").hide();
		$("#ModalLabel_Modi").show();
		$("#regButton").hide();
		$("#modiButton").show();
	}
		
	 /* ********************************************************
	  * Registration
	  ******************************************************** */
	function fn_nodeReg(){
		if(fn_validationNodeReg()){
			$.ajax({
				url : "/experdb/backupNodeReg.do",
				data : {
					ipadr : $("#ipAddr").val(),
					rootName : $("#rootName").val(),
					rootPW : $("#rootPW").val(),
					userCred : $("#userCred").val(),
					userName : $("#userCredName").val(),
					userPW : $("#userCredPw").val(),
					description : $("#description").val()
				},
				type : "post"
			})
			// , textStatus, xhr
			.done (function(result){
				if(result.RESULT_CODE == "0"){
					showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
					fn_getSvrList();
					 $('#pop_layer_popup_backupNodeReg').modal("hide");
				}else{					
					showSwalIconRst(result.RESULT_DATA, '<spring:message code="common.close" />', '', 'error');
				}
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
	 
	 /* ********************************************************
	  * Modification
	  ******************************************************** */	 
	  function fn_nodeModi(){
		    if(fn_validationNodeReg()){
				$.ajax({
					url : "/experdb/backupNodeModi.do",
					data : {
						ipadr : $("#ipAddr").val(),
						rootName : $("#rootName").val(),
						rootPW : $("#rootPW").val(),
						userCred : $("#userCred").val(),
						userName : $("#userCredName").val(),
						userPW : $("#userCredPw").val(),
						description : $("#description").val()
					},
					type : "post"
				})
				// , textStatus, xhr
				.done (function(result){
					if(result.RESULT_CODE == "0"){
						showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
						fn_getSvrList();
						 $('#pop_layer_popup_backupNodeReg').modal("hide");
					}else{					
						showSwalIconRst(result.RESULT_DATA, '<spring:message code="common.close" />', '', 'error');
					}
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
	 
	 /* ********************************************************
	  * validation
	  ******************************************************** */
	 // registration validation
	  function fn_validationNodeReg(){
		var checkVal = fn_valChkUserPW() + fn_valChkUserName() + fn_valChkRootPW();
		if(checkVal){
			return false;
		}else if(serverNum >= licenseNum){
			showSwalIcon('<spring:message code="eXperDB_backup.msg94" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		return true;
	 }

	  // Root name validation check
	/*  function fn_valChkRootName(){
		 $("#rootName").val($("#rootName").val().replace(/ /g, ''));
		 $("#rootNameAlert").empty();
		if(!$("#rootName").val()){
			$("#rootNameAlert").append('<spring:message code="eXperDB_backup.msg77" />');
			$("#rootNameAlert").removeClass("text-success").addClass("text-danger");
			$("#rootName").focus();
			return true;
		}else{
			return false;
		}
	 } */

	 // Root Password validation check
	 function fn_valChkRootPW() {
		$("#rootPWAlert").empty();
		if(!$("#rootPW").val()){
			$("#rootPWAlert").append('<spring:message code="eXperDB_backup.msg78" />');
			$("#rootPWAlert").removeClass("text-success").addClass("text-danger");
			$("#rootPW").focus();
			return true;
		} else{
			return false;
		}
	 }

	 // User name validation check
	 function fn_valChkUserName(){
		$("#userCredName").val($("#userCredName").val().replace(/ /g, ''));
		$("#userCredNameAlert").empty();
		if($("#userCred").is(":checked")&&!$("#userCredName").val()){
			$("#userCredNameAlert").append('<spring:message code="eXperDB_backup.msg79" />');
			$("#userCredNameAlert").removeClass("text-success").addClass("text-danger");
			$("#userCredName").focus();
			return true;
		}else {
			return false;
		}
	 }

	 // User password validation check
	 function fn_valChkUserPW() {
		$("#userCredPwAlert").empty();
		if($("#userCred").is(":checked")&&!$("#userCredPw").val()){
			$("#userCredPwAlert").append('<spring:message code="eXperDB_backup.msg80" />');
			$("#userCredPwAlert").removeClass("text-success").addClass("text-danger");
			$("#userCredPw").focus();
			return true;
		}else{
			return false;
		}
	 }
	 /* ********************************************************
	  * Motion
	  ******************************************************** */ 
	  function fn_userCredentClick(){
		 if($("#userCred").is(":checked")){
			$("#userCred").val("true");
			$("#userCredName").prop("disabled", false);
			$("#userCredPw").prop("disabled", false);
		 }else{
			$("#userCred").val("false");
			$("#userCredName").prop("disabled", true);
			$("#userCredPw").prop("disabled", true);
			$("#userCredName").val("");
			$("#userCredPw").val("");
			$("#userCredNameAlert").empty();
			$("#userCredPwAlert").empty();
		 }
	  }

	  function fn_setIpadrList(result){
		var html = "";
		$("#ipAddr").empty();
		for(var i in result){
			html += '<option value="' + result[i].ipadr + '">' + result[i].ipadr + '</option>';
		}
		$("#ipAddr").append(html);
	  }
	  

</script>
	
<div class="modal fade" id="pop_layer_popup_backupNodeReg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" id="nodeRegPopupDiv" style="margin-bottom:-30px;">
			<div id="loader"><div class="flip-square-loader mx-autor" style="border: 0px !important;z-index:99999; position:absolute; transform:translate(250%, 250%); size:150%;"></div></div>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
					<spring:message code="eXperDB_backup.msg81" />
				</h5>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Modi" style="padding-left:5px;" >
					<spring:message code="eXperDB_backup.msg82" />
				</h5>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<fieldset>
							<div class="card-body" style="padding-top: 10px; padding-bottom: 10px;">
								<div class="row">
									<div class="col-12" style="border: 1px solid #dee1e4; padding-top: 20px;padding-left: 30px;">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row">
													<div  class="col-4" style="padding-top:7px; margin-left: 20px;">
														Hostname / IP Address
													</div>
													<select id="ipAddr" name="ipAddr"  class="form-control form-control-xsm" style="width:350px; height:40px; color:#908f8f;" onchange="">
														
													</select>
												</div>
												<input type="hidden" id="rootName" name="rootName" value="root"/>
												<div class="form-group row" style="margin-bottom:4px">
													<div  class="col-4" style="padding-top:7px; margin-left: 20px;">
														Root Password
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="password" id="rootPW" name="rootPW" class="form-control form-control-sm" style="width: 350px;" onchange="fn_valChkRootPW()"/>
														<div id="rootPWAlert" name="rootPWAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												<div class="form-group" style="height: 180px;margin-bottom: 10px;">
													<div class="form-group" style="border: 1px solid #dee1e4;padding-top: 30px; position:relative;">
														<div class="form-group row" style="margin-bottom:4px;" >
															<div  class="col-3" style="padding-top:7px; margin-left: 70px;">
																User Name
															</div>
															<div class="col-4" style="padding-left: 0px;">
																<input type="text" id="userCredName" name="userCredName" class="form-control form-control-sm" style="width: 350px;" onchange="fn_valChkUserName()"/>
																<div id="userCredNameAlert" name="userCredNameAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
																	
																</div>
															</div>
														</div>
														<div class="form-group row" style="margin-bottom:4px">
															<div  class="col-3" style="padding-top:7px; margin-left: 70px;">
																Password
															</div>
															<div class="col-4" style="padding-left: 0px;">
																<input type="password" id="userCredPw" name="userCredPw" class="form-control form-control-sm" style="width: 350px;" onchange="fn_valChkUserPW()"/>
																<div id="userCredPwAlert" name="userCredPwAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
																	
																</div>
															</div>
														</div>
													</div>
													<div class="form-check" style="width:145px;background-color: white; font-size: 1rem; margin-left: 20px;position: absolute;top: 140px;margin-top: 0px;margin-bottom: 0px;">
														<label class="form-check-label" for="userCred" style="font-size: 1em;">
															<input type="checkbox" class="form-check-input" id="userCred" name="userCred" value="N" onclick="fn_userCredentClick()"/>
															User Credentials
															<i class="input-helper"></i>
														</label>
													</div>
												</div>
												<div class="form-group row" style="margin-bottom:20px; position:relative">
													<div  class="col-4" style="padding-top:7px; margin-left: 20px;">
														Description
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<textarea id="description" name="description" class="form-control form-control-sm" style="width: 350px; height: 100px;" onchange=""></textarea>
													</div>
												</div>
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
						
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_nodeReg()"><spring:message code="common.registory"/></button>
									<button type="button" class="btn btn-primary" id="modiButton" onclick="fn_nodeModi()"><spring:message code="common.modify"/></button>
									<button type="button" class="btn btn-light" data-dismiss="modal" onclick=""><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>