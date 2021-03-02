<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : arcBackupRegForm.jsp
	* @Description : 백업정책 등록 팝업
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

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_regReset();
			
	});

	/* ********************************************************
	 * registration reset
	 ******************************************************** */
	function fn_regReset() {

		// type reset
		$("#storageType").val(1).prop("disabled", false);
		$("#storagePath").val("").prop("disabled", false);
		fn_storageTypeSelect();
		
		// concurrent backup job reset
		$(':input:radio[name=currBckJob]:checked').val("noLimit");
		fn_bckJobLimClick();
		
		// run script reset
		$("#runScript").prop('checked', false);
		fn_runScriptClick();

		$("#regTitle").show();
		$("#modiTitle").hide();
		
		$("#regButton").show();
		$("#modiButton").hide();		

		$("#userNameAlert").empty();
		$("#passWordAlert").empty();
		$("#storagePathAlert").empty();
	}

	/* ********************************************************
	 * modification reset
	 ******************************************************** */
	function fn_modiReset(result){
		$("#storageType").val(result.type).prop("disabled", true);
		$("#userName").val(result.backupDestUser);
		$("#passWord").val("");

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

		$("#regTitle").hide();
		$("#modiTitle").show();
		$("#regButton").hide();
		$("#modiButton").show();
	}
	
	/* ********************************************************
	 * type select function
	 ******************************************************** */
	function fn_storageTypeSelect(){
		if($("#storageType").val() == 1){
			$("#userName").prop("disabled", true);
			$("#passWord").prop("disabled", true);
			$("#userName").val(null);
			$("#passWord").val(null);
		}else{
			$("#userName").prop("disabled", false);
			$("#passWord").prop("disabled", false);
		}
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
		  if(fn_validationReg()){
			  $.ajax({
					url : "/experdb/backupStorageReg.do",
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
					type : "post"
			  })
			  .done (function(data){
				  /* if(data.RESULT_CODE == "0"){
					  fn_getStorageList();
					  showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');					  
				  }else{
					  showSwalIcon("ERROR Message : "+ data.RESULT_DATA+ "\n\n", '<spring:message code="common.close" />', '', 'error');
				  } */
					  fn_getStorageList();
					  showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');					  
				  
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
				  $('#pop_layer_popup_backupStorageReg').modal("hide");
			  }) 
		  }
	 }
	 
	 /* ********************************************************
	  * Modification
	  ******************************************************** */	 
	  function fn_storageModi(){
		if(fn_validationModi()){
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
						// $("#pop_layer_popup_backupStorageReg").hide();
						showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
						$('#pop_layer_popup_backupStorageReg').modal("hide");
					}
			  })
		  }
	  }
	  
	 
	 /* ********************************************************
	  * validation
	  ******************************************************** */
	 // validation check for registration
	 function fn_validationReg() {

		// INSERT CHECK (PATH, USERNAME, PASSWORD)
		// path insert check
		if($("#storageType").val()==2){
			var checkVal = fn_valChkPW() + fn_valChkName() + fn_valChkPath();
			if(checkVal){
				return false;
			}
		}else if(fn_valChkPath()){
			return false;
		}
		return true;
	 }
	 
	// validation check for modification
	 function fn_validationModi() {
		if($("#storageType").val()==2){
			var checkVal = fn_valChkPW() + fn_valChkName();						
			if(checkVal){
				return false;
			}
		}
		return true;
	 }

	 // path validation check
	 function fn_valChkPath(){
		 var storagePath = $("#storagePath").val();
		$("#storagePathAlert").empty();
		var pathCheck = $("#pathcheck").val();
		 // path duplication check
		if(fn_dupCheckPath()){
			$("#storagePathAlert").append("이미 등록된 Path 입니다");
			$("#storagePathAlert").removeClass("text-success").addClass("text-danger");
			$("#storagePath").focus();
			return true;
		}else if(!storagePath){
			$("#storagePath").val("");
			$("#storagePathAlert").append("Path를 입력해주세요");
			$("#storagePathAlert").removeClass("text-success").addClass("text-danger");
			$("#storagePath").focus();
			return true;
		}else if(pathCheck != 0){
			$("#storagePathAlert").append("유효한 Path를 입력해주세요");
			$("#storagePathAlert").removeClass("text-success").addClass("text-danger");
			$("#storagePath").focus();
			return true;
		}
		else{
			// $("#storagePathAlert").append("사용가능한 Path 입니다");
			// $("#storagePathAlert").removeClass("text-danger").addClass("text-success");
			// $("#storagePathAlert").show();
			return false;
		}
	 }

	 // user name validation check
	 function fn_valChkName(){
		 var userName = $("#userName").val().replace(/ /g, '');
		 $("#userNameAlert").empty();
		if(!userName){
			$("#userName").val("");
			$("#userNameAlert").append("이름을 입력해주세요");
			$("#userNameAlert").removeClass("text-success").addClass("text-danger");
			$("#userName").focus();
			return true;
		}else{
			return false;
		}
	 }

	 // password validation check
	 function fn_valChkPW() {
		 var password = $("#passWord").val().replace(/ /g, '');
		 $("#passWordAlert").empty();
		if(!password){
			$("#passWord").val("");
			$("#passWordAlert").append("비밀번호를 입력해주세요");
			$("#passWordAlert").removeClass("text-success").addClass("text-danger");
			$("#passWord").focus();
			return true;
		}else{
			return false;
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

	 // Path check
	function fn_checkPath(){
		$("#storagePath").val($("#storagePath").val().replace(/ /g, ''));
		$.ajax({
			url : "/experdb/checkStoragePath.do",
			data : {
				path : $("#storagePath").val(),
				type : $("#storageType").val()
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
					$("#pathcheck").val(result);
					fn_valChkPath(result);
					
			}
		})
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
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					백업 스토리지
				</h5>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<fieldset>
						<div class="card my-sm-2" >
							<div class="card card-inverse-info" id="regTitle" style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;"> 백업 스토리지 등록 </i>
							</div>
							<div class="card card-inverse-info" id="modiTitle" style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;"> 백업 스토리지 수정 </i>
							</div>					
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Type
													</div>
													<select id="storageType" name="storageType"  class="form-control form-control-xsm" style="width:400px; height:40px;" onchange="fn_storageTypeSelect()">
														<option value="1">NFS share</option>
														<option value="2">CIFS share</option>
													</select>
												</div>
												<div class="form-group row" id="pathDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Path
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="storagePath" name="storagePath" class="form-control form-control-sm" style="width: 400px;" onchange="fn_checkPath()"/>
														<input type="hidden" id="pathcheck" value=1/>
														<div id="storagePathAlert" name="storagePathAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												<div class="form-group row" id="userNameDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														User Name
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="userName" name="userName" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkName()"/>
														<div id="userNameAlert" name="userNameAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
														</div>
													</div>
												</div>
												<div class="form-group row" id="passWordDiv" style="margin-bottom:4px">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Password
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="password" id="passWord" name="passWord" class="form-control form-control-sm" style="width: 400px;" onchange="fn_valChkPW()"/>
														<div id="passWordAlert" name="passWordAlert" class="text-danger" style="font-size:0.8em;  width: 212px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 1px; padding-bottom: 5px; margin-bottom: 0px; ">
															
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
														<select name="runScriptUnit" id="runScriptUnit"  class="form-control form-control-xsm" style="width:100px; height:30px;">
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
						</div>
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_storageReg()"><spring:message code="common.registory"/></button>
									<button type="button" class="btn btn-primary" id="modiButton" onclick="fn_storageModi()"><spring:message code="common.modify"/></button>
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