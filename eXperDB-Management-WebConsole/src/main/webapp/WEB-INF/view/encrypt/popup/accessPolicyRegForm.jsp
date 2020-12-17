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
	*  2020.08.11   변승우 과장		UI 디자인 변경
	*
	* author 김주영 사원
	* since 2018.01.08
	*
	*/
%>



<script>

/*시간*/
function fn_makeFromHour(){
	$("#b_hour").empty();
	
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"   name="from_exe_h" id="from_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#b_hour" ).append(hourHtml);
}


/*분*/
function fn_makeFromMin(){
	$("#b_min").empty();
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"   name="from_exe_m" id="from_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> ';	
	$( "#b_min" ).append(minHtml);
}


/*시간*/
function fn_makeToHour(){
	$("#a_hour").empty();
	
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"   name="to_exe_h" id="to_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> ';	
	$( "#a_hour" ).append(hourHtml);
}


/*분*/
function fn_makeToMin(){
	
	$("#a_min").empty();
	
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="form-control form-control-xsm" style="margin-right: 1rem;"    name="to_exe_m" id="to_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> ';	
	$( "#a_min" ).append(minHtml);
}



/*validation 체크*/
function fn_acc_ins_validation(){
	var specName = document.getElementById('specName');
	if (specName.value == "" || specName.value == "undefind" || specName.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg18' />', '<spring:message code="common.close" />', '', 'error');
		specName.focus();
		return false;
	}
	
	var startDateTime = document.getElementById('startDateTime');
	if (startDateTime.value == "" || startDateTime.value == "undefind" || startDateTime.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg13' />', '<spring:message code="common.close" />', '', 'error');;
		startDateTime.focus();
		return false;
	}
	
	var endDateTime = document.getElementById('endDateTime');
	if (endDateTime.value == "" || endDateTime.value == "undefind" || endDateTime.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg14' />', '<spring:message code="common.close" />', '', 'error');
		endDateTime.focus();
		return false;
	}
	
	var massiveThreshold = document.getElementById('massiveThreshold');
	if (massiveThreshold.value == "" || massiveThreshold.value == "undefind" || massiveThreshold.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg15' />', '<spring:message code="common.close" />', '', 'error');
		massiveThreshold.focus();
		return false;
	}
	
	var massiveTimeInterval = document.getElementById('massiveTimeInterval');
	if (massiveTimeInterval.value == "" || massiveTimeInterval.value == "undefind" || massiveTimeInterval.value == null) {
		showSwalIcon('<spring:message code='encrypt_msg.msg16' />', '<spring:message code="common.close" />', '', 'error');
		massiveTimeInterval.focus();
		return false;
	}
	
	return true;
}

/*저장버튼 클릭시*/
function fn_acc_save(){
	if (!fn_acc_ins_validation()) return false;
 	
	var total = $('input[name=workDay]:checked').length;
	
	var workDayValue = "";
	$("input[name=workDay]:checked").each(function(index) {
		  workDayValue += $(this).val(); 	  
		  if (total != index+1) {
			  workDayValue += ",";
		  }    
	});

	Result = new Object();
	
	Result.specName = $("#specName").val();
	Result.serverInstanceId = $("#serverInstanceId").val();
	Result.serverLoginId = $("#serverLoginId").val();
	Result.adminLoginId = $("#adminLoginId").val();
	Result.osLoginId = $("#osLoginId").val();
	Result.applicationName = $("#applicationName").val();
	Result.accessAddress = $("#accessAddress").val();
	Result.accessAddressMask = $("#accessAddressMask").val();
	Result.accessMacAddress = $("#accessMacAddress").val();
	Result.startDateTime = $("#startDateTime").val();
	Result.endDateTime = $("#endDateTime").val();
	Result.startTime = $("#from_exe_h").val()+":"+$("#from_exe_m").val();
	Result.endTime = $("#to_exe_h").val()+":"+$("#to_exe_m").val();
	Result.workDay = workDayValue;
	Result.massiveThreshold = $("#massiveThreshold").val();
	Result.massiveTimeInterval = $("#massiveTimeInterval").val();
	Result.extraName = $("#extraName").val();
	Result.hostName = $("#hostName").val();
	Result.whitelistYesNo = $(":radio[name='whitelistYesNo']:checked").val();
	
	var returnCheck= fn_AccessAdd(Result);   
	if(returnCheck!=false){
		$('#pop_layer_accessPolicyRegForm').modal("hide");
	}
}



/* ********************************************************
 * calender 셋팅
 ******************************************************** */
function dateCalenderSetting() {
	var today = new Date();
	var startDay = today.toJSON().slice(0,10);
	var endDay = fn_dateParse("20991231");
	
	var day_today = today.toJSON().slice(0,10);
	var day_start = startDay;
	var day_end = endDay.toJSON().slice(0,10);
	
	$("#startDateTime").val(day_today);
	$("#endDateTime").val(day_today);
	
	if ($("#wrk_strt_dtm_div", "#accbaseForm").length) {
		$("#wrk_strt_dtm_div", "#accbaseForm").datepicker({
		}).datepicker('setDate', day_today)
		.datepicker('setStartDate', day_start)
		.datepicker('setEndDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    }); //값 셋팅
	}
	
	if ($("#wrk_end_dtm_div", "#accbaseForm").length) {
		$("#wrk_end_dtm_div", "#accbaseForm").datepicker({
		}).datepicker('setDate', day_today)
		.datepicker('setStartDate', day_start)
		.datepicker('setEndDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    }); //값 셋팅
	}
	$("#startDateTime", "#accbaseForm").datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
	$("#endDateTime", "#accbaseForm").datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
	
    $("#wrk_strt_dtm_div","#accbaseForm").datepicker('updateDates');
    $("#wrk_end_dtm_div", "#accbaseForm").datepicker('updateDates');
	
	
	/*
	var today = new Date();
	var day_end = today.toJSON().slice(0,10);

	today.setDate(today.getDate());
	var day_start = today.toJSON().slice(0,10); 

	$("#startDateTime").val(day_start);
	$("#endDateTime").val(day_end);

	if ($("#wrk_strt_dtm_div").length) {
		$('#wrk_strt_dtm_div').datepicker({
		}).datepicker('setDate', day_start)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    }); //값 셋팅
	}

	if ($("#wrk_end_dtm_div").length) {
		$('#wrk_end_dtm_div').datepicker({
		}).datepicker('setDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    }); //값 셋팅
	}
	
	$("#startDateTime").datepicker('setDate', day_start);
    $("#endDateTime").datepicker('setDate', day_end);
    $('#wrk_strt_dtm_div').datepicker('updateDates');
    $('#wrk_end_dtm_div').datepicker('updateDates');
    */
}
</script>

<div class="modal fade" id="pop_layer_accessPolicyRegForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_policy_management.Register_Policy"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="accbaseForm">
						<input type="hidden" name="whitelist" id="whitelist" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Policy_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="specName" name="specName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Server_Instance"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="serverInstanceId" name="serverInstanceId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Database_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="serverLoginId" name="serverLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.eXperDB_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="adminLoginId" name="adminLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>				
								</div>
					
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.OS_User"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="osLoginId" name="osLoginId"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Application_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="applicationName" name="applicationName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>	
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.IP_Address"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="accessAddress" name="accessAddress"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.IP_Mask"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="accessAddressMask" name="accessAddressMask"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>	
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.MAC_Address"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="accessMacAddress" name="accessMacAddress"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
									</div>	
								</div>

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Policy_Period"/>
									</label>
									<div class="col-sm-3">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="startDateTime" name="dt" >
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
											<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="endDateTime" name="dt" >
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
										<div id = "b_hour"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;" >
										<spring:message code="schedule.our" />
									</div>
													
									<div class="col-sm-1_5">
										<div id = "b_min"></div>	
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
										<div id = "a_hour"></div>
									</div>
									<div class="col-sm-0" style="margin-top:5px; margin-left:-5px;">
										<spring:message code="schedule.our" />
									</div>
									<div class="col-sm-1_5">
										<div id = "a_min"></div>
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
											<input type="checkbox" class="form-check-input" id="SUNDAY" name="workDay"  value="<spring:message code="common.sun" />"  />
											<spring:message code="common.sun" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="MONDAY" name="workDay"  value="<spring:message code="common.mon" />"/>
											<spring:message code="common.mon" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="TUESDAY" name="workDay"  value="<spring:message code="common.tue" />"/>
											<spring:message code="common.tue" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="WEDNESDAY" name="workDay"  value="<spring:message code="common.wed" />"/>
											<spring:message code="common.wed" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="THURSDAY" name="workDay"  value="<spring:message code="common.thu" />"/>
											<spring:message code="common.thu" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="FRIDAY" name="workDay"  value="<spring:message code="common.fri" />"/>
											<spring:message code="common.fri" />
											<i class="input-helper"></i>
										</label>
									</div>
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label" for="sat" style="color: blue;">
											<input type="checkbox" class="form-check-input" id="SATURDAY" name="workDay"  value="<spring:message code="common.sat" />"/>
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
										<input type="number" class="form-control form-control-xsm" id="massiveThreshold" name="massiveThreshold"   min="0" onKeyPress="NumObj(this);" />
									</div>
									<div class="col-sm-3" style="margin-top:3px; margin-left:-20px;">
										<spring:message code="encrypt_policy_management.Threshold"/>
									</div>
									<div class="col-sm-1_5">
										<input type="number" class="form-control form-control-xsm" id="massiveTimeInterval" name="massiveTimeInterval" min="0" onKeyPress="NumObj(this);"/>
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
										<input type="text" class="form-control form-control-xsm" id="extraName" name="extraName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_policy_management.Host_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="hostName" name="hostName"  maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/>
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
												<input type="radio" class="form-check-input" name="whitelistYesNo" id="whitelistYes" value="Y" checked="checked">
												<spring:message code="encrypt_policy_management.Access_Allow"/>
											</label>
										</div>
									</div>
									<div class="col-sm-2">
										<div class="form-check">
											<label class="form-check-label">
												<input type="radio" class="form-check-input" name="whitelistYesNo" id="whitelistNo" value="N" > 
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
						<button type="button" class="btn btn-primary" onclick="fn_acc_save();"><spring:message code="common.save"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>