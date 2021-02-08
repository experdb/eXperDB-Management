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
		$("#storageType").val(1);
		fn_storageTypeSelect();
		
		// concurrent backup job reset
		$(':input:radio[name=currBckJob]:checked').val("noLimit");
		fn_bckJobLimClick();
		
		// run script reset
		$("#runScript").prop('checked', false);
		fn_runScriptClick();

		$("#regTitle").show();
		$("#modiTitle").hide();

	}

	/* ********************************************************
	 * modification reset
	 ******************************************************** */
	function fn_modiReset(){
		fn_regReset();

		$("#regTitle").hide();
		$("#modiTitle").show();
	}
	
	/* ********************************************************
	 * type select function
	 ******************************************************** */
	function fn_storageTypeSelect(){
		if($("#storageType").val() == 1){
			$("#userName").prop("disabled", true);
			$("#passWord").prop("disabled", true);
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
		if($("#runScript").is(":checked")){
			$("#runScriptNum").prop("disabled", false); 
			$("#runScriptUnit").prop("disabled", false); 
		}else{
			$("#runScriptNum").prop("disabled", true); 
			$("#runScriptUnit").prop("disabled", true); 
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
						<!-- 노드 확인 -->
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
												<div class="form-group row">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Path
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="storagePath" name="storagePath" class="form-control form-control-sm" style="width: 400px;"/>
													</div>
												</div>
												<div class="form-group row">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														User Name
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="userName" name="userName" class="form-control form-control-sm" style="width: 400px;"/>
													</div>
												</div>
												<div class="form-group row">
													<div  class="col-3" style="padding-top:7px; margin-left: 20px;">
														Password
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" id="passWord" name="passWord" class="form-control form-control-sm" style="width: 400px;"/>
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
																<input type="number" id="currBckLimNum" class="form-control form-control-sm" style="height: 30px;"/>
															</div>
														</div>
													</div>
												</div>
												<div class="form-group row" style="margin-left: 0px;">
													<div class="form-check" style="margin-left: 20px;">
														<label class="form-check-label" for="runScript">
															<input type="checkbox" class="form-check-input" id="runScript" name="runScript" onclick="fn_runScriptClick()"/>
															Run script when free space is less than
															<i class="input-helper"></i>
														</label>
													</div>
													<div class="col-2" style="padding-left: 0px; margin-left: 20px;">
														<input type="number" id="runScriptNum" class="form-control form-control-sm" style="height: 30px;"/>
													</div>
													<div class="col-2" style="padding-left: 0px; margin-left: 10px;">
														<select name="runScriptUnit" id="runScriptUnit"  class="form-control form-control-xsm" style="width:100px; height:30px;">
															<option value="1">MB</option>
															<option value="2">%</option>
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
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value="<spring:message code='common.registory' />" onclick=""/>
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