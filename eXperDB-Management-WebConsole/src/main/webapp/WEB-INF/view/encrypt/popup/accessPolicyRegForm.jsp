<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근제어 정책 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
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

$(window.document).ready(function() {
	fn_makeFromHour();
	fn_makeFromMin();
	fn_makeToHour();
	fn_makeToMin();
	if("${act}" =='u'){
		$('#specName').val('${specName}');
		$('#serverInstanceId').val('${serverInstanceId}');
		$('#serverLoginId').val('${serverLoginId}');
		$('#adminLoginId').val('${adminLoginId}');
		$('#osLoginId').val('${osLoginId}');
		$('#applicationName').val('${applicationName}');
		$('#accessAddress').val('${accessAddress}');
		$('#accessAddressMask').val('${accessAddressMask}');
		$('#accessMacAddress').val('${accessMacAddress}');
		$('#startDateTime').val('${startDateTime}');
		$('#endDateTime').val('${endDateTime}');
		
		var startTime = '${startTime}';
		var endTime = '${endTime}';
		var from_exe= startTime.split(':');
		var to_exe= endTime.split(':');
		$("#from_exe_h").val(from_exe[0]);
		$("#from_exe_m").val(from_exe[1]);
		$("#to_exe_h").val(to_exe[0]);
		$("#to_exe_m").val(to_exe[1]);
		
		var workday = '${workDay}';
		var day = workday.split(",");

		 $('input:checkbox[name="workDay"]').each(function() {
			 for(var i=0; i<day.length; i++){
				if(this.value == day[i]){
					this.checked = true;
				 }
			}
		 });
		$('#massiveThreshold').val('${massiveThreshold}');
		$('#massiveTimeInterval').val('${massiveTimeInterval}');
		$('#extraName').val('${extraName}');
		$('#hostName').val('${hostName}');
		if('${whitelistYesNo}' == 'Y'){
			$("#whitelistYes:radio[value='Y']").attr("checked", true);
		}else{
			$("#whitelistNo:radio[value='N']").attr("checked", true);
		}
	}else{
		$("#to_exe_h").val(23);
		$("#to_exe_m").val(59);
		$('#startDateTime').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#endDateTime').val('9997-12-31');
	}
});
	

/*시간*/
function fn_makeFromHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="from_exe_h" id="from_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#b_hour" ).append(hourHtml);
}


/*분*/
function fn_makeFromMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="from_exe_m" id="from_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#b_min" ).append(minHtml);
}


/*시간*/
function fn_makeToHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="to_exe_h" id="to_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#a_hour" ).append(hourHtml);
}


/*분*/
function fn_makeToMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="to_exe_m" id="to_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#a_min" ).append(minHtml);
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
function fn_validation(){
	var specName = document.getElementById('specName');
	if (specName.value == "" || specName.value == "undefind" || specName.value == null) {
		alert('<spring:message code="encrypt_msg.msg18"/>');
		specName.focus();
		return false;
	}
	
	var startDateTime = document.getElementById('startDateTime');
	if (startDateTime.value == "" || startDateTime.value == "undefind" || startDateTime.value == null) {
		alert('<spring:message code="encrypt_msg.msg13"/>');
		startDateTime.focus();
		return false;
	}
	
	var endDateTime = document.getElementById('endDateTime');
	if (endDateTime.value == "" || endDateTime.value == "undefind" || endDateTime.value == null) {
		alert('<spring:message code="encrypt_msg.msg14"/>');
		endDateTime.focus();
		return false;
	}
	
	var massiveThreshold = document.getElementById('massiveThreshold');
	if (massiveThreshold.value == "" || massiveThreshold.value == "undefind" || massiveThreshold.value == null) {
		alert('<spring:message code="encrypt_msg.msg15"/>');
		massiveThreshold.focus();
		return false;
	}
	
	var massiveTimeInterval = document.getElementById('massiveTimeInterval');
	if (massiveTimeInterval.value == "" || massiveTimeInterval.value == "undefind" || massiveTimeInterval.value == null) {
		alert('<spring:message code="encrypt_msg.msg16"/>');
		massiveTimeInterval.focus();
		return false;
	}
	
	return true;
}

/*저장버튼 클릭시*/
function fn_save(){
	if (!fn_validation()) return false;
 	
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
	
	var returnCheck= opener.fn_AccessAdd(Result);   
	if(returnCheck!=false){
		window.close();
	}
}

/*수정버튼 클릭시*/
function fn_update(){
	if (!fn_validation()) return false;
	 
	var total = $('input[name=workDay]:checked').length;
	var workDayValue = "";
	$("input[name=workDay]:checked").each(function(index) {
		  workDayValue += $(this).val(); 	  
		  if (total != index+1) {
			  workDayValue += ",";
		  }    
	});

	
	Result = new Object();
	
	Result.rnum = "${rnum}";
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
	
	var returnCheck= opener.fn_AccessUpdate(Result);   
	if(returnCheck!=false){
		window.close();
	}	
}
</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">접근제어 정책 등록</p>
				<table class="write">
					<caption>접근제어 정책 등록</caption>
					<colgroup>
						<col style="width: 130px;" />
						<col />
						<col style="width: 130px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Policy_Name"/></th>
							<td><input type="text" class="txt" name="specName" id="specName" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Server_Instance"/></th>
							<td><input type="text" class="txt" name="serverInstanceId" id="serverInstanceId" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Database_User"/></th>
							<td><input type="text" class="txt" name="serverLoginId" id="serverLoginId" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.eXperDB_User"/></th>
							<td><input type="text" class="txt" name="adminLoginId" id="adminLoginId" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.OS_User"/></th>
							<td><input type="text" class="txt" name="osLoginId" id="osLoginId" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Application_Name"/></th>
							<td><input type="text" class="txt" name="applicationName" id="applicationName" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.IP_Address"/> </th>
							<td><input type="text" class="txt" name="accessAddress" id="accessAddress" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.IP_Mask"/></th>
							<td><input type="text" class="txt" name="accessAddressMask" id="accessAddressMask" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.MAC_Address"/></th>
							<td><input type="text" class="txt" name="accessMacAddress" id="accessMacAddress" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Policy_Period"/></th>
							<td colspan="3">
								<span id="calendar"> 
									<span class="calendar_area big"> <a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" class="calendar" id="startDateTime" name="dt" title="스케줄시간설정" />
									</span>
								</span>
								&nbsp&nbsp&nbsp&nbsp&nbsp ~ &nbsp&nbsp&nbsp&nbsp&nbsp 
								<span id="calendar"> 
									<span class="calendar_area big"> 
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="endDateTime" name="dt" title="스케줄시간설정" />
									</span>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Policy_Time"/></th>
							<td colspan="3">
								<span id="b_hour" style="margin-right: 10px;"></span><span id="b_min"></span>
									&nbsp&nbsp&nbsp&nbsp&nbsp ~ &nbsp&nbsp&nbsp&nbsp&nbsp
								<span id="a_hour" style="margin-right: 10px;"></span><span id="a_min"></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Day_of_Week"/></th>
							<td colspan="3">
								<div class="inp_chk">
									<input type="checkbox" id="SUNDAY" name="workDay" value="<spring:message code="common.sun" />" />
									<label for="SUNDAY" style="margin-right: 10px; color: red;"><spring:message code="common.sun" /></label>
									
									<input type="checkbox" id="MONDAY" name="workDay" value="<spring:message code="common.mon" />"/>
									<label for="MONDAY" style="margin-right: 10px;"><spring:message code="common.mon" /></label>		
									
									<input type="checkbox" id="TUESDAY" name="workDay" value="<spring:message code="common.tue" />"/>
									<label for="TUESDAY" style="margin-right: 10px;"><spring:message code="common.tue" /></label>
									
									<input type="checkbox" id="WEDNESDAY" name="workDay" value="<spring:message code="common.wed" />"/>
									<label for="WEDNESDAY" style="margin-right: 10px;"><spring:message code="common.wed" /></label>
									
									<input type="checkbox" id="THURSDAY" name="workDay" value="<spring:message code="common.thu" />"/>
									<label for="THURSDAY" style="margin-right: 10px;"><spring:message code="common.thu" /></label>
									
									<input type="checkbox" id="FRIDAY" name="workDay" value="<spring:message code="common.fri" />"/>
									<label for="FRIDAY" style="margin-right: 10px;"><spring:message code="common.fri" /></label>
									
									<input type="checkbox" id="SATURDAY" name="workDay" value="<spring:message code="common.sat" />"/>
									<label for="SATURDAY" style="color: blue;"><spring:message code="common.sat" /></label>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">임계치(대량작업)</th>
							<td>
								<input type="number" class="txt"  min="0" name="massiveThreshold" id="massiveThreshold" style="width: 50px;" onKeyPress="NumObj(this);"/>&nbsp&nbsp건수/ &nbsp&nbsp 
								<input type="number" class="txt" min="0" name="massiveTimeInterval" id="massiveTimeInterval" style="width: 50px;" onKeyPress="NumObj(this);"/><spring:message code='encrypt_policy_management.sec'/>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Additional_Fields"/></th>
							<td><input type="text" class="txt" name="extraName" id="extraName" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Host_Name"/></th>
							<td><input type="text" class="txt" name="hostName" id="hostName" maxlength="40" onkeyup="fn_checkWord(this,40)" placeholder="40<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">규칙 만족할 때</th>
							<td>
								<div class="inp_rdo">
									<input name="whitelistYesNo" id="whitelistYes" type="radio" checked="checked" value="Y">
									<label for="whitelistYes" style="margin-right: 15%;">접근허용</label> 
									<input name="whitelistYesNo" id="whitelistNo" type="radio" value="N"> 
									<label for="whitelistNo">접근거부</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			<div class="btn_type_02">
				<c:if test="${act == 'i'}">
					<a href="#n" class="btn"><span onclick="fn_save()"><spring:message code="common.save"/></span></a> 
				</c:if>
				<c:if test="${act == 'u'}">
					<a href="#n" class="btn"><span onclick="fn_update()"><spring:message code="common.modify" /></span></a> 
				</c:if>
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
			</div>
		</div>
	</div>
</body>
</html>