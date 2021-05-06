<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : bckStorageRegForm.jsp
	* @Description : 백업 스토리지 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-02-04	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.02.04
	*
	*/
%>

<script type="text/javascript">

 var pathList = [];
 var pathUrlCheck = true;
 var storageValid = false;
 

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		storageValid = false;
		fn_regReset();
	});
	
	// loader
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
	function fn_regReset() {

		// type reset
		$("#storageType").val(1).prop("disabled", false);
		$("#storagePath").val("").prop("disabled", false);
		fn_storageTypeSelect();
		
		
		/* // concurrent backup job reset
		$(':input:radio[name=currBckJob]:checked').val("noLimit");
		fn_bckJobLimClick();
		
		// run script reset
		$("#runScript").prop('checked', false);
		fn_runScriptClick();

		$("#ModalLabel_Reg").show();
		$("#ModalLabel_Modi").hide();
		
		$("#regButton").show();
		$("#modiButton").hide();
		$("#storageChkBtn_Reg").show();
		$("#storageChkBtn_Modi").hide();

		$("#userNameAlert").empty();
		$("#passWordAlert").empty();
		$("#storagePathAlert").empty();
		
		$("#isSUserDiv").hide(); */
	}

	/* ********************************************************
	 * modification reset
	 ******************************************************** */
	function fn_modiReset(result){
		$("#storageType").val(result.type).prop("disabled", true);
		$("#userName").val(result.backupDestUser);
		storageValid = false;
		$("#passWord").val("");
		$("#isSUserDiv").hide();
		fn_storageTypeSelect();
		
		$("#storagePathAlert").empty();
		$("#passWordAlert").empty();
		$("#userNameAlert").empty();

		$("#storagePath").val(result.backupDestLocation).prop("disabled", true);

		$("#currBckLimNum").val(result.jobLimit)
		if(result.jobLimit > 0){
			$("#noLimit").prop("checked", false);
			$("#limit").prop("checked", true);
			$('#currBckLimNum').prop("disabled", false);
		}else{
			$("#noLimit").prop("checked", true);
			$("#limit").prop("checked", false);
			$('#currBckLimNum').prop("disabled", true);
		}

		$("#runScript").val(result.isRunScript);
		$("#runScriptNum").val(result.freeSizeAlert);
		$("#runScriptUnit").val(result.freeSizeAlertUnit);
		if(result.isRunScript == 1){
			$("#runScript").prop('checked', true);
			$("#runScriptNum").prop("disabled", false); 
			$("#runScriptUnit").prop("disabled", false);
		}else{
			$("#runScript").prop('checked', false);
			$("#runScriptNum").prop("disabled", true); 
			$("#runScriptUnit").prop("disabled", true); 
		}

		$("#ModalLabel_Reg").hide();
		$("#ModalLabel_Modi").show();
		$("#regButton").hide();
		$("#modiButton").show();
		
		$("#storageChkBtn_Reg").hide();
		$("#storageChkBtn_Modi").show();
	}
	
	/* ********************************************************
	 * type select function
	 ******************************************************** */
	function fn_storageTypeSelect(){
		$("#storageTypeAlert").empty();
		if($("#storageType").val() == 1){
			$("#isCifs").hide();
			$("#storageTypeAlert").append('<spring:message code="eXperDB_backup.msg90" />');
			/* $("#userName").prop("disabled", true);
			$("#passWord").prop("disabled", true);
			$("#userName").val(null);
			$("#passWord").val(null); */
		}else{
			$("#isCifs").show();
			$("#storageTypeAlert").append('<spring:message code="eXperDB_backup.msg91" />');
			/* $("#userName").prop("disabled", false);
			$("#passWord").prop("disabled", false); */
		}
		$("#storagePath").val("");
		$("#userName").val("");
		$("#passWord").val("");
		$("#storageUser").val("");
		
		// concurrent backup job reset
		$(':input:radio[name=currBckJob]:checked').val("noLimit");
		fn_bckJobLimClick();
		
		// run script reset
		$("#runScript").prop('checked', false);
		fn_runScriptClick();

		$("#ModalLabel_Reg").show();
		$("#ModalLabel_Modi").hide();
		
		$("#regButton").show();
		$("#modiButton").hide();
		$("#storageChkBtn_Reg").show();
		$("#storageChkBtn_Modi").hide();

		$("#userNameAlert").empty();
		$("#passWordAlert").empty();
		$("#storagePathAlert").empty();
		
		$("#isSUserDiv").hide();
	}
	
	/* ********************************************************
	 * concurrent backup job limit radio check
	 ******************************************************** */
	function fn_bckJobLimClick() {
		var mg = $(':input:radio[name=currBckJob]:checked').val();
		$('#currBckLimNum').val(0);
		if(mg == 'limit'){
			$('#currBckLimNum').prop("disabled", false);
		}else if(mg == 'noLimit'){
			$('#currBckLimNum').prop("disabled", true);
		}
	}

	/* ********************************************************
	 * Run Script select function
	 ******************************************************** */
	// run script check
	 function fn_runScriptClick() {
		$("#runScriptNum").val(0);

		if($("#runScript").is(":checked")){
			$("#runScript").val(1);
			$("#runScriptUnit").val(1);
			$("#runScriptNum").prop("disabled", false); 
			$("#runScriptUnit").prop("disabled", false); 
		}else{
			$("#runScript").val(0);
			$("#runScriptUnit").val(0);
			$("#runScriptNum").prop("disabled", true); 
			$("#runScriptUnit").prop("disabled", true); 
		}
	}
	
	 /* ********************************************************
	  * Registration
	  ******************************************************** */
	  function fn_storageReg () { 
		 if(storageValid == true){
			  $.ajax({
					url : "/experdb/backupStorageReg.do",
					data : {
						type : $("#storageType").val(),
						path : $("#storagePath").val(),
						storageUser : $("#storageUser").val(),
						pathUrlTF : pathUrlCheck,
						passWord : $("#passWord").val(),
						userName : $("#userName").val(),
						jobLimit : $("#currBckLimNum").val(),
						runScript : $("#runScript").val(),
						freeSizeAlert : $("#runScriptNum").val(),
						freeSizeAlertUnit : $("#runScriptUnit").val()
					},
					type : "post"
			  })
			  .done (function(result){
				  if(result.RESULT_CODE == "0"){
					  fn_getStorageList();
					  showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
					  $('#pop_layer_popup_backupStorageReg').modal("hide");
				  }else if(result.RESULT_CODE == "2"){
					  showSwalIcon('<spring:message code="eXperDB_backup.msg89" />', '<spring:message code="common.close" />', '', 'error');
				  }else{
					  showSwalIcon("ERROR Message : "+ result.RESULT_DATA+ "\n\n", '<spring:message code="common.close" />', '', 'error');
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
			  .always(function(){
				 
			  }) 
		  }else{
			  showSwalIcon('<spring:message code="eXperDB_backup.msg35" />', '<spring:message code="common.close" />', '', 'error');
		  }
	 }
	 
	 /* ********************************************************
	  * Modification
	  ******************************************************** */	 
	  function fn_storageModi(){
		if(storageValid == true){
			
			  $.ajax({
					url : "/experdb/backupStorageUpdate.do",
					data : {
						type : $("#storageType").val(),
						path : $("#storagePath").val(),
						passWord : $("#passWord").val(),
						userName : $("#userName").val(),
						jobLimit : $("#currBckLimNum").val(),
						runScript : $("#runScript").val(),
						freeSizeAlert : $("#runScriptNum").val(),
						freeSizeAlertUnit : $("#runScriptUnit").val()
					},
					type : "post",
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if (xhr.status == 403){
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
					success : function(result) {
						fn_getStorageList();
						showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
						$('#pop_layer_popup_backupStorageReg').modal("hide");
					}
			  })
		  }else{
			  showSwalIcon('<spring:message code="eXperDB_backup.msg35" />', '<spring:message code="common.close" />', '', 'error');
		  }
	  }
	  
	 
	 /* ********************************************************
	  * validation
	  ******************************************************** */
	 // validation check for registration
	 function fn_storageValidate() {
		 //storageType == 1 (NFS)
		 //storageType == 2 (CIFS)
		if($("#storageType").val()==1){
			var checkVal = fn_valChkPath() + fn_valChkSUser();
			if(checkVal == 2){
				 $.ajax({
					url : "/experdb/nfsValidation.do",
					data : {
						path : $("#storagePath").val()
					},
					type : "post",
					async: false, 
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if (xhr.status == 403){
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
					success : function(result) {		
						 if(result.RESULT_CODE == "1"){							 
							 showSwalIcon('<spring:message code="eXperDB_backup.msg36" />', '<spring:message code="common.close" />', '', 'error');
							 storageValid = false;
						 }else{
							 showSwalIcon('Connect for Success', '<spring:message code="common.close" />', '', 'success');
							 storageValid = true;
						 }	
					}
				});
			}
		}else{
			var checkVal =fn_valChkPW() + fn_valChkName() + fn_valChkPath() + fn_valChkSUser();
			if(checkVal == 4){
				 $.ajax({
						url : "/experdb/cifsValidation.do",
						data : {
							path : $("#storagePath").val(),
							userName : $("#userName").val(),
							passWord : $("#passWord").val(),						
						},
						type : "post",
						async: false, 
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
							} else if (xhr.status == 403){
								showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
							} else {
								showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
							}
						},
						success : function(result) {		
							 if(result.RESULT_CODE == "1"){
								 showSwalIcon(result.RESULT_DATA, '<spring:message code="common.close" />', '', 'error');
								 storageValid = false;
							 }else{
								 showSwalIcon('Connect for Success', '<spring:message code="common.close" />', '', 'success');
								 storageValid = true;
							 }	
						}
					});
			}
		}	
	 }
	 
	 
	 
	 
	// validation check for modification
	 function fn_storageValidateModi() {
		 if($("#storageType").val()==1){
				 $.ajax({
					url : "/experdb/nfsValidation.do",
					data : {
						path : $("#storagePath").val(),
					},
					type : "post",
					async: false, 
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if (xhr.status == 403){
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
					success : function(result) {		
						 if(result.RESULT_CODE == "1"){							 
							 showSwalIcon('<spring:message code="eXperDB_backup.msg36" />', '<spring:message code="common.close" />', '', 'error');
							 storageValid = false;
						 }else{
							 showSwalIcon('Connect for Success', '<spring:message code="common.close" />', '', 'success');
							 storageValid = true;
						 }	
					}
				});
			}else{
				var checkVal =fn_valChkPW() + fn_valChkName();
				if(checkVal == 2){
					 $.ajax({
							url : "/experdb/cifsValidation.do",
							data : {
								path : $("#storagePath").val(),
								userName : $("#userName").val(),
								passWord : $("#passWord").val(),						
							},
							type : "post",
							async: false, 
							error : function(xhr, status, error) {
								if(xhr.status == 401) {
									showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
								} else if (xhr.status == 403){
									showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
								} else {
									showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
								}
							},
							success : function(result) {		
								 if(result.RESULT_CODE == "1"){
									 showSwalIcon(result.RESULT_DATA, '<spring:message code="common.close" />', '', 'error');
									 storageValid = false;
								 }else{
									 showSwalIcon('Connect for Success', '<spring:message code="common.close" />', '', 'success');
									 storageValid = true;
								 }	
							}
					});
				}
			}	
	 }

	 // path validation check
	 function fn_valChkPath(){
		 var storagePath = $("#storagePath").val();
		$("#storagePathAlert").empty();
		fn_checkUrl(storagePath);
		storageValid = false;
		 // path duplication check
		if(fn_dupCheckPath()){
			$("#storagePathAlert").append("<spring:message code='eXperDB_backup.msg37' />");
			$("#storagePathAlert").removeClass("text-success").addClass("text-danger");
			$("#storagePath").focus();
			return false;
		}else if(!storagePath){
			$("#storagePath").val("");
			$("#storagePathAlert").append("<spring:message code='eXperDB_backup.msg38' />");
			$("#storagePathAlert").removeClass("text-success").addClass("text-danger");
			$("#storagePath").focus();
			return false;
		}else {
			
			return true;
		}
	 }
	 
	 function fn_checkUrl(storagePath){
		 var storageUrl = $("#storageUrl").val();
		if(storagePath.indexOf(storageUrl)<0){
			pathUrlCheck = false;
			$("#isSUserDiv").show();
		}else {
			pathUrlCheck = true;
			$("#isSUserDiv").hide();
		}
	 }
	 
	 function fn_valChkSUser(){
		 var sUser = $("#storageUser").val();
		 $("#storageUserAlert").empty();
		 if(pathUrlCheck == false && !sUser){
			$("#storageUser").val("");
			$("#storageUserAlert").append("Storage User를 입력해주세요");
			$("#storageUserAlert").removeClass("text-success").addClass("text-danger");
			$("#storageUser").focus();
			return false;
		 }else{
			$("#storageUserAlert").empty();
			
			return true;
		 }
	 }

	 // user name validation check
	 function fn_valChkName(){
		 var userName = $("#userName").val().replace(/ /g, '');
		 $("#userNameAlert").empty();
			storageValid = false;
		if(!userName){
			$("#userName").val("");
			$("#userNameAlert").append("<spring:message code='eXperDB_backup.msg39' />");
			$("#userNameAlert").removeClass("text-success").addClass("text-danger");
			$("#userName").focus();
			return false;
		}else{
			return true;
		}
	 }

	 // password validation check
	 function fn_valChkPW() {
		 var password = $("#passWord").val().replace(/ /g, '');
		 $("#passWordAlert").empty();
			storageValid = false;
		if(!password){
			$("#passWord").val("");
			$("#passWordAlert").append("<spring:message code='message.msg88'/>");
			$("#passWordAlert").removeClass("text-success").addClass("text-danger");
			$("#passWord").focus();
			return false;
		}else{
			return true;
		}
	 }

	 // Path duplication check
	 function fn_dupCheckPath() {
		// duplication check
		for(var i = 0; i<pathList.length; i++){
			if(pathList[i] == $("#storagePath").val()){
				return true;
			}
		}
		return false;
	 }
	 
	 // path list
	 function fn_getPathList(data) {
		 var size = data.length;
		 pathList = [];
		 for(var i=0;i<size;i++){
			 pathList.push(data[i].path);
		 }
	 }
 

</script>
<div class="modal fade" id="pop_layer_popup_backupStorageReg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
			<div id="loader"><div class="flip-square-loader mx-autor" style="border: 0px !important;z-index:99999; position:absolute; transform:translate(250%, 250%); size:150%;"></div></div>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
					<spring:message code='eXperDB_backup.msg40' />
				</h5>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Modi" style="padding-left:5px;">
					<spring:message code='eXperDB_backup.msg41' />
				</h5>
				<div class="card" style="border:0px;">
					<form class="cmxform" id="insRegForm">
						<fieldset>
							<div class="card-body">
								<div class="row">
									<div class="col-12" style="border: 1px solid #dee1e4; padding-top: 20px;padding-left: 30px;">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Type
													</div>
													<select id="storageType" name="storageType"  class="form-control form-control-xsm" style="width:200px; height:40px; color: #555555" onchange="fn_storageTypeSelect()">
														<option value="1">NFS share</option>
														<option value="2">CIFS share</option>
													</select>
													<div id="storageTypeAlert" name="storageTypeAlert" class="alert alert-fill-warning" style="font-size:0.7em;height: 20px;margin-top: 17px;margin-left: 6px;margin-bottom: 0px;padding-top: 2px;width: 187px;padding-right: 10px;padding-left: 10px;padding-bottom: 0px;">
														
													</div>
												</div>
												<div class="form-group row" id="pathDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Path
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="storagePath" name="storagePath" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkPath()"/>
														<div id="storagePathAlert" name="storagePathAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												<div id="isSUserDiv" style="display:none;">
												<div class="form-group row" id="sUserDiv" style="margin-bottom:4px;" >
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Storage User
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="storageUser" name="storageUser" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkSUser()"/>
														<div id="storageUserAlert" name="storageUserAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												</div>
												 
												<div name="isCifs" id="isCifs">
												<div class="form-group row" id="userNameDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Smb User
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="userName" name="userName" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkName()"/>
														<div id="userNameAlert" name="userNameAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												<div class="form-group row" id="passWordDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Smb Password
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="password" id="passWord" name="passWord" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkPW()"/>
														<div id="passWordAlert" name="passWordAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												</div>
												<div class="form-group">
													<div  class="col-4" style="padding-top:7px; margin-left: 3px;">
														Concurrent backup job
													</div>
													<div style="margin-left: 150px; margin-top: 10px;">
														<label style="padding-top: 5px" for="noLimit">
															<input type="radio" id="noLimit" name="currBckJob" style="margin-right: 10px; margin-left: 10px;" checked="checked" value="noLimit" onchange="fn_bckJobLimClick()"/>
														 	No Limit
														</label>
														<div class="row" style="margin-left:0px;">
															<label style="padding-top: 5px" for="limit">
																<input type="radio" id="limit" name="currBckJob" style="margin-right: 10px; margin-left: 10px;" value="limit" onchange="fn_bckJobLimClick()"/>
															 	Limit to
															</label>
															<div class="col-2" style="padding-left: 0px; margin-left: 20px;">
																<input type="number" id="currBckLimNum" class="form-control form-control-sm" value=0 style="height: 30px;"/>
															</div>
														</div>
													</div>
												</div>
												<div class="form-group row" style="margin-left: 0px;">
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="runScript">
															<input type="checkbox" class="form-check-input" id="runScript" name="runScript" value=0 onclick="fn_runScriptClick()"/>
															Run script when free space is less than
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="col-2" style="padding-left: 0px; margin-left: 20px;">
														<input type="number" id="runScriptNum" class="form-control form-control-sm" style="height: 30px;"/>
													</div>
													<div class="col-2" style="padding-left: 0px; margin-left: 10px;">
														<select name="runScriptUnit" id="runScriptUnit"  class="form-control form-control-xsm" style="width:100px; height:30px; color:#333333;">
															<option value="1">%</option>
															<option value="2">MB</option>
															<option value="0" hidden></option>
														</select>
													</div>
												</div>
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_storageReg()"><spring:message code="common.registory"/></button>
									<button type="button" class="btn btn-primary" id="modiButton" onclick="fn_storageModi()"><spring:message code="common.modify"/></button>
									<input class="btn btn-primary" width="200px" id="storageChkBtn_Reg" style="vertical-align:middle;" type="button" onClick="fn_storageValidate();" value="<spring:message code='eXperDB_backup.msg42' />" />
									<input class="btn btn-primary" width="200px" id="storageChkBtn_Modi" style="vertical-align:middle;" type="button" onClick="fn_storageValidateModi();" value="<spring:message code='eXperDB_backup.msg42' />" />
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