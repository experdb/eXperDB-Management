<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>


<%
	/**
	* @Class Name : accessPolicyRegForm.jsp
	* @Description : accessPolicyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.08
	*
	*/
%>

<script>
$(function() {
	var dateFormat = "yyyy-mm-dd", from = $("#startDateTime").datepicker({
		changeMonth : false,
		changeYear : true,
		onClose : function(selectedDate) {
			$("#endDateTime").datepicker("option", "minDate", selectedDate);
		}
	})

	to = $("#endDateTime").datepicker({
		changeMonth : false,
		changeYear : true,
		onClose : function(selectedDate) {
			$("#startDateTime").datepicker("option", "maxDate", selectedDate);
		}
	})
});



/*시간*/
function fn_mod_makeFromHour(){
	
	$("#mod_b_hour").empty();
	
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_from_exe_h" id="mod_from_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> ';	
	$( "#mod_b_hour" ).append(hourHtml);
}


/*분*/
function fn_mod_makeFromMin(){
	
	$("#mod_b_min").empty();
	
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_from_exe_m" id="mod_from_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select>';	
	$( "#mod_b_min" ).append(minHtml);
}


/*시간*/
function fn_mod_makeToHour(){
	
	$("#mod_a_hour").empty();
	
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_to_exe_h" id="mod_to_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> ';	
	$( "#mod_a_hour" ).append(hourHtml);
}


/*분*/
function fn_mod_makeToMin(){
	
	$("#mod_a_min").empty();
	
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_to_exe_m" id="mod_to_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select>';	
	$( "#mod_a_min" ).append(minHtml);
}




/*숫자체크*/
function NumObj(obj) {
	if (event.keyCode >= 48 && event.keyCode <= 57) {
		return true;
	} else {
		(event.preventDefault) ? event.preventDefault() : event.returnValue = false;
	}
}



/*validation 체크*/
function fn_mod_validation(){
	var specName = document.getElementById('mod_specName');
	if (specName.value == "" || specName.value == "undefind" || specName.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg18' />', '<spring:message code="common.close" />', '', 'error');
		specName.focus();
		return false;
	}
	
	var startDateTime = document.getElementById('mod_startDateTime');
	if (startDateTime.value == "" || startDateTime.value == "undefind" || startDateTime.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg13' />', '<spring:message code="common.close" />', '', 'error');
		startDateTime.focus();
		return false;
	}
	
	var endDateTime = document.getElementById('mod_endDateTime');
	if (endDateTime.value == "" || endDateTime.value == "undefind" || endDateTime.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg14' />', '<spring:message code="common.close" />', '', 'error');
		endDateTime.focus();
		return false;
	}
	
	var massiveThreshold = document.getElementById('mod_massiveThreshold');
	if (massiveThreshold.value == "" || massiveThreshold.value == "undefind" || massiveThreshold.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg15' />', '<spring:message code="common.close" />', '', 'error');
		massiveThreshold.focus();
		return false;
	}
	
	var massiveTimeInterval = document.getElementById('mod_massiveTimeInterval');
	if (massiveTimeInterval.value == "" || massiveTimeInterval.value == "undefind" || massiveTimeInterval.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg16' />', '<spring:message code="common.close" />', '', 'error');
		massiveTimeInterval.focus();
		return false;
	}
	
	return true;
}



/*수정버튼 클릭시*/
function fn_acc_update(){

	if (!fn_mod_validation()) return false;

	var total = $('input[name=mod_workDay]:checked').length;
	var workDayValue = "";
	$("input[name=mod_workDay]:checked").each(function(index) {
		  workDayValue += $(this).val(); 	  
		  if (total != index+1) {
			  workDayValue += ",";
		  }    
	});
	
	Result = new Object();
	
	Result.rnum =  $("#rnum").val();
	Result.specName = $("#mod_specName").val();
	Result.serverInstanceId = $("#mod_serverInstanceId").val();
	Result.serverLoginId = $("#mod_serverLoginId").val();
	Result.adminLoginId = $("#mod_adminLoginId").val();
	Result.osLoginId = $("#mod_osLoginId").val();
	Result.applicationName = $("#mod_applicationName").val();
	Result.accessAddress = $("#mod_accessAddress").val();
	Result.accessAddressMask = $("#mod_accessAddressMask").val();
	Result.accessMacAddress = $("#mod_accessMacAddress").val();
	Result.startDateTime = $("#mod_startDateTime").val();
	Result.endDateTime = $("#mod_endDateTime").val();
	Result.startTime = $("#mod_from_exe_h").val()+":"+$("#mod_from_exe_m").val();
	Result.endTime = $("#mod_to_exe_h").val()+":"+$("#mod_to_exe_m").val();
	Result.workDay = workDayValue;
	Result.massiveThreshold = $("#mod_massiveThreshold").val();
	Result.massiveTimeInterval = $("#mod_massiveTimeInterval").val();
	Result.extraName = $("#mod_extraName").val();
	Result.hostName = $("#mod_hostName").val();
	Result.whitelistYesNo = $(":radio[name='mod_whitelistYesNo']:checked").val();

	var returnCheck= fn_AccessUpdate(Result);   

	if(returnCheck!=false){
		$('#pop_layer_accessPolicyRegReForm').modal("hide");
	}	
}
</script>



<div class="modal fade" id="pop_layer_accessPolicyRegReForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" >
				
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_policy_management.Register_Policy"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="accModForm">
						<input type="hidden" name="whitelist" id="whitelist" />
						<input type="hidden" name="rnum" id="rnum" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Policy_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_specName" name="mod_specName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Server_Instance"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_serverInstanceId" name="mod_serverInstanceId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Database_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_serverLoginId" name="mod_serverLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.eXperDB_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_adminLoginId" name="mod_adminLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>				
								</div>
													
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.OS_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_osLoginId" name="mod_osLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Application_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_applicationName" name="mod_applicationName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>	
								</div>
									
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.IP_Address"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_accessAddress" name="mod_accessAddress"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.IP_Mask"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_accessAddressMask" name="mod_accessAddressMask"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>	
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.MAC_Address"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_accessMacAddress" name="mod_accessMacAddress"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>	
								</div>
								
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Policy_Period"/>
									</label>
									<div class="col-sm-3">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="mod_startDateTime" name="dt" >
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
									<div class="col-sm-0" style="margin-top:12px;">	
										<div class="input-group align-items-center">
											<span style="border:none; padding: 0px 10px;"> ~ </span>
										</div>
									</div>
									<div class="col-sm-3">
										<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="mod_endDateTime" name="dt" >
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>	
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Policy_Time"/>
									</label>
									<div class="col-sm-1_5">
										<div id = "mod_b_hour"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;" >
										<spring:message code="schedule.our" />
									</div>
									<div class="col-sm-1_5">
										<div id = "mod_b_min"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;">
										<spring:message code="schedule.minute" />
									</div>													
									<div class="col-sm-0" style="margin-top:7px; margin-left:20px;">		
										<div class="input-group align-items-center">
											<span style="border:none; padding: 0px 10px;"> ~ </span>
										</div>
									</div>	
									<div class="col-sm-1_5">
										<div id = "mod_a_hour"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;">
										<spring:message code="schedule.our" />
									</div>
									<div class="col-sm-1_5">
										<div id = "mod_a_min"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;">
										<spring:message code="schedule.minute" />
									</div>													
								</div>	

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Day_of_Week"/>
									</label>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label" for="sun" style="color: red;">
											<input type="checkbox" class="form-check-input" id="SUNDAY" name="mod_workDay"  value="<spring:message code="common.sun" />"  />
											<spring:message code="common.sun" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="MONDAY" name="mod_workDay"  value="<spring:message code="common.mon" />"/>
											<spring:message code="common.mon" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="TUESDAY" name="mod_workDay"  value="<spring:message code="common.tue" />"/>
											<spring:message code="common.tue" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="WEDNESDAY" name="mod_workDay" value="<spring:message code="common.wed" />"/>
											<spring:message code="common.wed" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="THURSDAY" name="mod_workDay"  value="<spring:message code="common.thu" />"/>
											<spring:message code="common.thu" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="FRIDAY" name="mod_workDay"  value="<spring:message code="common.fri" />"/>
											<spring:message code="common.fri" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label" for="sat" style="color: blue;">
											<input type="checkbox" class="form-check-input" id="SATURDAY" name="mod_workDay"  value="<spring:message code="common.sat" />"/>
									        <spring:message code="common.sat" />
											<i class="input-helper"></i>
										</label>
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.MAC_Address"/>
									</label>			
									<div class="col-sm-1_5">
										<input type="number" class="form-control form-control-xsm" id="mod_massiveThreshold" name="mod_massiveThreshold"   min="0" onKeyPress="NumObj(this);" />														
									</div>
									<div class="col-sm-2_5" style="margin-top:3px; margin-left:-20px;">
										<spring:message code="encrypt_policy_management.Threshold"/>
									</div>		
									<div class="col-sm-1_5">
										<input type="number" class="form-control form-control-xsm" id="mod_massiveTimeInterval" name="mod_massiveTimeInterval" min="0" onKeyPress="NumObj(this);"/>												
									</div>
									<div class="col-sm-1" style="margin-top:3px; margin-left:-20px;">
										<spring:message code='encrypt_policy_management.sec'/>
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Additional_Fields"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_extraName" name="mod_extraName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Host_Name"/>
									</label>
									
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_hostName" name="mod_hostName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.MAC_Address"/>
									</label>
									<div class="col-sm-2">
										<div class="form-check">
											<label class="form-check-label">
												<input type="radio" class="form-check-input" name="mod_whitelistYesNo" id="mod_whitelistYes" value="Y" checked="checked"> 
												<spring:message code="encrypt_policy_management.Access_Allow"/>	
											</label>
										</div>
									</div>
									
									<div class="col-sm-2">
										<div class="form-check">
											<label class="form-check-label">
												<input type="radio" class="form-check-input" name="mod_whitelistYesNo" id="mod_whitelistNo" value="N" > 
												<spring:message code="encrypt_policy_management.Access_Deny"/>		
											</label>
										</div>
									</div>
								</div>
							</div>					
						</fieldset>
					</form>
				</div>

				<div class="card-body">
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
						<button type="button" class="btn btn-primary" onclick="fn_acc_update();"><spring:message code="common.modify"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>