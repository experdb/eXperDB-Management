<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : bckPolicyRegForm.jsp
	* @Description : 풀 백업 정책 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-01-21	변승우 책임매니저		최초 생성
	*  2021-01-28	신예은 매니저		화면 구성
	*
	* author 변승우
	* since 2021.01.21
	*
	*/
%>

<script type="text/javascript">

	var storageList = [];
	var CIFSList = [];
	var NFSList = [];
	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_makeMonthDay();
	});
	
	/* ********************************************************
	 * reset
	 ******************************************************** */
	function fn_policyRegReset() {
		$("#backupSetNum").val(1);
		
		$("#compressType").val(1);
		$("input:radio[name='merge_period']:radio[value='weekly']").prop('checked', true); 
		$("#merge_period_week").val(1);
		$("#merge_period_month").val(1);
		fn_mergeClick();
		
		$("#storageType").val("2");
		fn_storageTypeClick();
		
	}

	function fn_policyModiReset(){
		$("#storageList").val($("#bckStorage").val());
		$("#storageType").val($("#bckStorageTypeVal").val());
		
		$("#backupSetNum").val($("#bckSetNum").val());
		$("#compressType").val($("#bckCompressVal").val());
		
		$("#merge_period_week").val($("#bckSetWeekDateVal").val());
		$("#merge_period_month").val($("#bckSetMonthDateVal").val());
		
		// full backup 수행일(weekly/monthly)에 따라 값 setting
		if($("#bckSetDateTypeVal").val() == "true"){
			$("input:radio[name='merge_period']:radio[value='weekly']").prop('checked', true);
		}else if($("#bckSetDateTypeVal").val() == "false"){
			$("input:radio[name='merge_period']:radio[value='monthly']").prop('checked', true);
		} 
		
		fn_mergeClick();
		fn_storageTypeClick();
	}
	// storage에 따라 분류해서 array insert
	function fn_setStorageList(data){
		storageList.length=0;
		CIFSList.length=0;
		NFSList.length=0;
		storageList = data;
		for(var i =0; i<storageList.length; i++){
			if(storageList[i].type == "CIFS Share"){
				CIFSList.push(storageList[i]);
			}else{
				NFSList.push(storageList[i]);
			}
		}
	}
	// month select setting
	function fn_makeMonthDay() {
		var dayHtml = "";
		$('#merge_period_month').children().remove();
		for(var i = 1; i<=31; i++){
			dayHtml += '<option value="'+i+'">'+i+'</option>';
		}
		dayHtml +=  '<option value="32">last day</option>' +
					'<option value="33">The last Sunday</option>' +
					'<option value="34">The last Monday</option>' +
					'<option value="35">The last Tuesday</option>' +
					'<option value="36">The last Wednesday</option>' +
					'<option value="37">The last Thursday</option>' +
					'<option value="38">The last Friday</option>' +
					'<option value="39">The last Saturday</option>' ;
		$('#merge_period_month').append(dayHtml);
	}
	/* ********************************************************
	 * click event
	 ******************************************************** */
	function fn_storageTypeClick(){
		var type = $("#storageType").val();
		var html;
		$("#storageList").empty();
		if(type == 2){
			for(var i =0; i<CIFSList.length; i++){			
				html += '<option value="'+CIFSList[i].path+'">'+CIFSList[i].path+'</option>';
			}
		}else{
			for(var i =0; i<NFSList.length; i++){			
				html += '<option value="'+NFSList[i].path+'">'+NFSList[i].path+'</option>';
			}
		}
		$("#storageList").append(html);
	}
	
	// backup storage number check
	function fn_backupSetVal() {
		var min = Number($("#backupSetNum").prop("min"));
		var max = Number($("#backupSetNum").prop("max"));
		var errStr = null;
		
		if($('#backupSetNum').val() > max || $('#backupSetNum').val() < min){
			errStr = min + " ~ " + max + ' <spring:message code="eXperDB_backup.msg47" />';
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			$("#backupSetNum").val(1);
		}
	}
	
	// merge radio check
	function fn_mergeClick() {
		var mg = $(':input:radio[name=merge_period]:checked').val();
		if(mg == "weekly"){
			$('#merge_period_week').prop("disabled", false);
			$('#merge_period_month').prop("disabled", true);
			$("#setNumTitleWeek").show();
			$("#setNumTitleMonth").hide();
		}else if(mg == "monthly"){
			$('#merge_period_month').prop("disabled", false);
			$('#merge_period_week').prop("disabled", true);
			$("#setNumTitleWeek").hide();
			$("#setNumTitleMonth").show();
		}
	}
	/* ********************************************************
	 * registration
	 ******************************************************** */
	function fn_policyReg() {
		var bckdate = "";
		if($("#storageType").val() == 1){
			$("#bckStorageType").val("NFS Share");
			$("#bckStorageTypeVal").val(1);	
		}else{
			$("#bckStorageType").val("CIFS Share");	
			$("#bckStorageTypeVal").val(2);	
		}
		$("#bckStorage").val($("#storageList").val());
		if($("#compressType").val()==1){		
			$("#bckCompress").val("Standard Compression");
		}else{
			$("#bckCompress").val("Maximum Compression");
		}
		
		$("#bckSetWeekDateVal").val($("#merge_period_week").val());
		$("#bckSetMonthDateVal").val($("#merge_period_month").val());
		
		if($(':input:radio[name=merge_period]:checked').val() == "weekly"){
			$("#bckSetDateTypeVal").val(true);
			// var setDateVal = $("#merge_period_week").val()
			
			bckdate = ' <spring:message code="eXperDB_backup.msg74" />'
			switch($("#merge_period_week").val()){
				case  "1":
					bckdate += ' <spring:message code="eXperDB_backup.msg52" />'
					break;
				case "2":
					bckdate += ' <spring:message code="eXperDB_backup.msg53" />'
					break;
				case "3":
					bckdate += ' <spring:message code="eXperDB_backup.msg54" />'
					break;
				case "4":
					bckdate += ' <spring:message code="eXperDB_backup.msg55" />'
					break;
				case "5":
					bckdate += ' <spring:message code="eXperDB_backup.msg56" />'
					break;
				case "6":
					bckdate += ' <spring:message code="eXperDB_backup.msg57" />'
					break;
				case "7":
					bckdate += ' <spring:message code="eXperDB_backup.msg58" />'
					break;
			}
		}else{
			$("#bckSetDateTypeVal").val(false);
			var setDateVal = $("#merge_period_month").val();
			$("#bckSetMonthDateVal").val(setDateVal);
			bckdate = ' <spring:message code="eXperDB_backup.msg73" />'
			if($("#merge_period_month").val()>31){
				switch($("#merge_period_month").val()){
					case "32":
						bckdate += ' <spring:message code="eXperDB_backup.msg59" />'
						break;
					case "33":
						bckdate += ' <spring:message code="eXperDB_backup.msg60" />'
						break;
					case "34":
						bckdate += ' <spring:message code="eXperDB_backup.msg61" />'
						break;
					case "35":
						bckdate += ' <spring:message code="eXperDB_backup.msg62" />'
						break;
					case "36":
						bckdate += ' <spring:message code="eXperDB_backup.msg63" />'
						break;
					case "37":
						bckdate += ' <spring:message code="eXperDB_backup.msg64" />'
						break;
					case "38":
						bckdate += ' <spring:message code="eXperDB_backup.msg65" />'
						break;
					case "39":
						bckdate += ' <spring:message code="eXperDB_backup.msg66" />'
						break;
				}
			}else{
				bckdate += " " + $("#merge_period_month").val() + ' <spring:message code="eXperDB_backup.msg67" />';
			}
		}
		
		$("#bckSetDate").val(bckdate);
		$("#bckSetNum").val($("#backupSetNum").val());
		
		$("#bckCompressVal").val($("#compressType").val());
		
		fn_alertShow();
		fn_scheduleAlert();
		$("#pop_layer_popup_backupPolicyReg").modal("hide");
	}

</script>
	
<div class="modal fade" id="pop_layer_popup_backupPolicyReg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="policyRegTitle" style="padding-left:5px;">
					<spring:message code="eXperDB_backup.msg68" />
				</h5>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<fieldset>
						<!-- backup destination -->
						<div style=" margin-bottom: 20px;">
							<div class="card my-sm-2" >
								<div class="card-body">
									<div class="row">
										<div class="col-12">
		 									<form class="cmxform" id="optionForm">
												<fieldset>			
													<div class="form-group row" style="margin-bottom: 15px;margin-top: 10px; margin-left: 20px;margin-right: 0px;">
														<select class="form-control form-control-xsm" id="storageType" name="storageType" style="width:150px; height:40px;margin-right: 10px; color:black;" onchange="fn_storageTypeClick()">
															<option value="1">NFS share</option>
															<option value="2">CIFS share</option>
														</select>
														<select class="form-control form-control-xsm" id="storageList" name="storageList" style="width:300px; height:40px; color:black;">
															
														</select>
													</div>
												</fieldset>
											</form>		
									 	</div>
								 	</div>
								</div>
								<div style="position: absolute;top:-5px; right:520px; width: 120px;">
									<h4 class="card-title" style=";background-color: white;font-size: 1em; color: #000000; ">
										<spring:message code="eXperDB_backup.msg69" />
									</h4>
								</div>
							</div>
						</div>
						<div style=" margin-bottom: 20px;">
							<div class="card my-sm-2" >
								<div class="card-body">
									<div class="row">
										<div class="col-12">
		 									<form class="cmxform" id="optionForm">
												<fieldset>			
													<div class="form-group row" style="margin-top:10px;margin-bottom: 10px;margin-left: 20px;margin-right: 0px;">
														<select class="form-control form-control-xsm" id="compressType" name="compressType" style="width:400px; height:40px; color:black;">
															<option value="1">Standard Compression</option>
															<option value="2">Maximum Compression</option>
														</select>
														
													</div>
												</fieldset>
											</form>		
									 	</div>
								 	</div>
								</div>
								<div style="position: absolute;top:-5px; right:510px; width: 130px;">
									<h4 class="card-title" style="background-color: white;font-size: 1em; color: #000000; ">
										<spring:message code="eXperDB_backup.msg70" />
									</h4>
								</div>
							</div>
						</div>
						<!-- Recovery Set Settings	 -->
						<div class="card my-sm-2" >
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row div-form-margin-z" style="margin-top: 10px;">
													<div class="col-7" >
														<div class="col-7 col-form-label pop-label-index" style="padding-top:7px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="eXperDB_backup.msg19" />
														</div>
														<div class="col-11 row" style="margin-left: 10px; padding-left: 5px;">
															<label style="padding-top: 5px; width: 87px;"><spring:message code="eXperDB_backup.msg72" /> <input type="radio" id="merge_week" name="merge_period" style="margin-right: 10px; margin-left: 10px;" value="weekly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_week" id="merge_period_week" class="form-control form-control-xsm" style="margin-left: 1rem;width:180px; height:40px; color:black;">
																<option value="1">Sunday</option>
																<option value="2">Monday</option>
																<option value="3">Tuesday</option>
																<option value="4">Wednesday</option>
																<option value="5">Thursday</option>
																<option value="6">Friday</option>
																<option value="7">Saturday</option>
															</select>
															
															<label style="padding-top: 10px; width: 87px;"><spring:message code="eXperDB_backup.msg71" /> <input type="radio" id="merge_month" name="merge_period" style="margin-right: 10px; margin-left: 10px;" value="monthly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_month" id="merge_period_month"  class="form-control form-control-xsm" style="margin-top: 10px; margin-left: 1rem;width:180px; height:40px; color:black;" disabled>
																
															</select>
														</div>
													</div>
													<div class="col-5">
														<div  class="col-11 col-form-label pop-label-index" id="setNumTitleWeek" style="padding-top:7px;padding-left: 0px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="eXperDB_backup.msg75" />
														</div>
														<div  class="col-11 col-form-label pop-label-index" id="setNumTitleMonth"style="padding-top:7px;padding-left: 0px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="eXperDB_backup.msg76" />
														</div>
														<div class="col-sm-4" style="margin-left: 10px">
															<input type="number" min="1" max="10000" style="width:150px; height:40px;" class="form-control form-control-sm" name="backupSetNum" id="backupSetNum" onchange="fn_backupSetVal()"/>
														</div>
													</div>
												</div>												
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
							<div style="position: absolute;top:-5px; right:507px; width: 131px;">
								<h4 class="card-title" style="background-color: white;font-size: 1em; color: #000000; ">
									<spring:message code="eXperDB_backup.msg21" />
								</h4>
							</div>
						</div>
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_policyReg()"><spring:message code="common.registory"/></button>
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