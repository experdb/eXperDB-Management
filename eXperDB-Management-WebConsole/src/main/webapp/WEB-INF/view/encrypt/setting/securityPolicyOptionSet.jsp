<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>

<%
	/**
	* @Class Name : securityPolicyOptionSet.jsp
	* @Description : securityPolicyOptionSet 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
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
	fn_makeStartHour();
	fn_makeEndHour();
	
	fn_securityPolicyOptionSelect01();
	fn_securityPolicyOptionSelect02();
	
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
 * 시간
 ******************************************************** */
function fn_makeStartHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t6" name="start_exe_h" id="start_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour =  i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#startHour" ).append(hourHtml);
}

function fn_makeEndHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t6" name="stop_exe_h" id="stop_exe_h">';	
	for(var i=0; i<=24; i++){
		if(i >= 0 && i<10){
			hour =  i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#endHour" ).append(hourHtml);
}

/*	GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF(기본 접근 허용) : 0, 1
GLOBAL_POLICY_FORCED_LOGGING_OFF_TF(암복호화 로그 기록 중지) : 0, 1
GLOBAL_POLICY_BOOST_TF(부스트) : True, False
GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION(암복호화 로그 서버에서 압축 시간 )
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT(암복호화 로그 AP에서 최대 압축값)
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT(암복호화 로그 압축 중단 시간 )
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL(암복호화 로그 압축 시작값)
GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD(암복호화 로그 압축 출력 시간 )*/
function fn_securityPolicyOptionSelect01(){
	$.ajax({
		url : "/selectSysConfigListLike.do", 
	  	data : {
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				for(var i=0; i<data.list.length; i++){
					if(data.list[i].configKey == "GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" && data.list[i].configValue== "1"){
						$("#GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" && data.list[i].configValue== "1"){
						$("#GLOBAL_POLICY_FORCED_LOGGING_OFF_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_BOOST_TF" && data.list[i].configValue== "true"){
						$("#GLOBAL_POLICY_BOOST_TF").attr('checked', true);
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val(data.list[i].configValue);
						}
					}if(data.list[i].configKey == "GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD"){
						if(data.list[i].configValue == null || data.list[i].configValue == "" || data.list[i].configValue == "null" || data.list[i].configValue == "0"){
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val("1");
						}else{
							$("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val(data.list[i].configValue);
						}						
					}
				}
			}else if(data.resultCode == "8000000002"){
				alert("<spring:message code='message.msg05' />");
				top.location.href = "/";
			}else if(data.resultCode == "8000000003"){
				alert(data.resultMessage);
				location.href = "/securityKeySet.do";
			}else{
				alert(data.resultMessage +"("+data.resultCode+")");
			}
		}
	});	
}


function fn_securityPolicyOptionSelect02(){
	$.ajax({
		url : "/selectSysMultiValueConfigListLike.do", 
	  	data : {
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				if(data.list[1].logTransferWaitTime == null || data.list[1].logTransferWaitTime == "" || data.list[1].logTransferWaitTime == "null" || data.list[1].logTransferWaitTime == "0"){
					$("#logTransferWaitTime").val("1");
				}else{
					$("#logTransferWaitTime").val(data.list[1].logTransferWaitTime);
				}
				
				if(data.list[0].blnIsvalueTrueFalse == true){
					$("#blnIsvalueTrueFalse").attr('checked', true);
				}
			
				if(data.list[0].day0 == true){
					$("#mon").attr('checked', true);
				}			
				if(data.list[0].day1 == true){
					$("#tue").attr('checked', true);
				}						
				if(data.list[0].day2 == true){
					$("#wed").attr('checked', true);
				}		
				if(data.list[0].day3 == true){
					$("#thu").attr('checked', true);
				}		
				if(data.list[0].day4 == true){
					$("#fri").attr('checked', true);
				}
				if(data.list[0].day5 == true){
					$("#sat").attr('checked', true);
				}
				if(data.list[0].day6 == true){
					$("#sun").attr('checked', true);
				}

				document.getElementById('start_exe_h').value=data.list[0].transferStart;
				document.getElementById('stop_exe_h').value=data.list[0].transferStop;
				
			}	
			fn_change();
		}
	});	
}

/*정책저장 Validation*/
function fn_validation(){
	//암복호화 로그 서버에서 압축시간
	var GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION");
	//암복호화 로그 압축 출력 시간
	var GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD");
	//암복호화 로그 압축 중단 시간
	var GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT = document.getElementById("GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT");
	
	if (GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION.value < GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD.value) {
		alert('[암복호화 로그 서버에서 압축 시간 단위(초)]값은 [암복호화 로그 압축 출력 시간 단위(초)]보다 크거나 같아야 합니다.');
		return false;
	}
	if (GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT.value <= GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD.value) {
		alert('[암복호화 로그 압축 중단 시간(초)]값은 [암복호화 로그 압축 출력 시간 단위(초)]보다 커야 합니다.');
		return false;
	}
	return true;
}

function fn_save(){
	if (!fn_validation()) return false;
	
	var arrmaps01 = [];
	var tmpmap01 = new Object();
	
	var arrmaps02 = [];
	var tmpmap02 = new Object();
	
	 var dayWeek = new Array();
	 dayWeek.push($(mon).prop("checked"));
	 dayWeek.push($(tue).prop("checked"));
	 dayWeek.push($(wed).prop("checked"));
	 dayWeek.push($(thu).prop("checked"));
	 dayWeek.push($(fri).prop("checked"));
	 dayWeek.push($(sat).prop("checked"));
	 dayWeek.push($(sun).prop("checked"));
	 
	tmpmap01["global_policy_default_access_allow_tf"] =$(GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF).prop("checked");
	tmpmap01["global_policy_forced_logging_off_tf"] = $(GLOBAL_POLICY_FORCED_LOGGING_OFF_TF).prop("checked");
	tmpmap01["global_policy_boost_tf"] = $(GLOBAL_POLICY_BOOST_TF).prop("checked");
	tmpmap01["global_policy_crypt_log_tm_resolution"] = $("#GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION").val();
	tmpmap01["global_policy_crypt_log_compress_flush_timeout"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT").val();
	tmpmap01["global_policy_crypt_log_compress_limit"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT").val();
	tmpmap01["global_policy_crypt_log_compress_print_period"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD").val();
	tmpmap01["global_policy_crypt_log_compress_initial"] = $("#GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL").val();
	arrmaps01.push(tmpmap01);	
	
	tmpmap02["blnIsvalueTrueFalse"] = $(blnIsvalueTrueFalse).prop("checked");
	tmpmap02["start_exe_h"] = $("#start_exe_h").val();
	tmpmap02["stop_exe_h"] = $("#stop_exe_h").val();
	tmpmap02["logTransferWaitTime"] = $("#logTransferWaitTime").val();
	arrmaps02.push(tmpmap02);	
	
	$.ajax({
		url : "/sysConfigSave.do", 
	  	data : {
	  		arrmaps01 : JSON.stringify(arrmaps01),
	  		dayWeek : JSON.stringify(dayWeek),
	  		arrmaps02 : JSON.stringify(arrmaps02)
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				alert('<spring:message code="message.msg07" />');
				//location.reload();
			}else if(data.resultCode == "8000000003"){
				alert(data.resultMessage);
				location.href = "/securityKeySet.do";
			}else{
				alert(data.resultMessage +"("+data.resultCode+")");
			}	
		}
	});	
}

function fn_change(){
	if($("input:checkbox[id='blnIsvalueTrueFalse']").is(":checked")){
		$("#mon").attr("onclick", "");
		$("#tue").attr("onclick", "");
		$("#wed").attr("onclick", "");
		$("#thu").attr("onclick", "");
		$("#fri").attr("onclick", "");
		$("#sat").attr("onclick", "");
		$("#sun").attr("onclick", "");
		$("#start_exe_h").attr("disabled", false);
		$("#stop_exe_h").attr("disabled", false);
	}else{
		$("#mon").attr("onclick", "return false;");
		$("#tue").attr("onclick", "return false;");
		$("#wed").attr("onclick", "return false;");
		$("#thu").attr("onclick", "return false;");
		$("#fri").attr("onclick", "return false;");
		$("#sat").attr("onclick", "return false;");
		$("#sun").attr("onclick", "return false;");
		$("#start_exe_h").attr("disabled", true);
		$("#stop_exe_h").attr("disabled", true);

	}
}
</script>

<style>
.cmm_bd .sub_tit>p {
	padding: 0 8px 0 33px;
	line-height: 24px;
	background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}

.inp_chk >span{
margin-right: 10px;
}
</style>

<form name='isServerKeyEmpty' method='post' target='main' action='/securityKeySet.do'></form>


<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Security_Policy_Option_Setting"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policyOption.Settings"/></li>
					<li class="on"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<a href="#n" class="btn" onClick="fn_save()"><button id="btnSave"><spring:message code="common.save"/></button></a> 
				</div>
						
				<div class="cmm_bd">
					<div class="sub_tit">
						<p><spring:message code="encrypt_policyOption.Default_Option"/></p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 120px;" />
								<col />
								<col style="width: 100px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<div class="inp_chk">
												<span style="margin-right: 10%;"> 
												<input type="checkbox" id="GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" name="GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF" /> 
												<label for="GLOBAL_POLICY_DEFAULT_ACCESS_ALLOW_TF"><spring:message code="encrypt_policyOption.Grant_Access"/></label>
												</span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<div class="inp_chk">
												<span style="margin-right: 10%;"> 
												<input type="checkbox" id="GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" name="GLOBAL_POLICY_FORCED_LOGGING_OFF_TF" /> 
												<label for="GLOBAL_POLICY_FORCED_LOGGING_OFF_TF"><spring:message code="encrypt_policyOption.Stop_Logging"/></label>
												</span>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<br><br>

				<div class="cmm_bd">
					<div class="sub_tit">
						<p>로그압축</p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 370px;" />
								<col />
								<col style="width: 320px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span style="margin-right: 10%;"> <input type="checkbox" id="GLOBAL_POLICY_BOOST_TF" name="GLOBAL_POLICY_BOOST_TF" /> 
												<label for="GLOBAL_POLICY_BOOST_TF"><spring:message code="encrypt_policyOption.Boost"/></label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Compression_time_in_the_log_server"/></th>
									<td><input type="number" class="txt t6" name="GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION" id="GLOBAL_POLICY_CRYPT_LOG_TM_RESOLUTION" maxlength="3" min="0" value="0">(<spring:message code="schedule.second" />)</td>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Stop_time_of_log_compression"/></th>
									<td><input type="number" class="txt t6" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_FLUSH_TIMEOUT" maxlength="3" min="0" value="0">(<spring:message code="schedule.second" />)</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Maximum_Compression_value_in_the_log_AP"/></th>
									<td><input type="number" class="txt t6" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_LIMIT" maxlength="3" min="0" value="0"></td>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Display_time_of_log_compression"/></th>
									<td><input type="number" class="txt t6" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_PRINT_PERIOD" maxlength="3" min="0" value="0">(<spring:message code="schedule.second" />)</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Start_value_of_log_compression"/></th>
									<td><input type="number" class="txt t6" name="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL" id="GLOBAL_POLICY_CRYPT_LOG_COMPRESS_INITIAL" maxlength="3" min="0" value="0"></td>
									<th scope="row" class="ico_t2"><spring:message code="encrypt_policyOption.Wait_time_of_log_transmission"/></th>
									<td><input type="number" class="txt t6" name="logTransferWaitTime" id="logTransferWaitTime" maxlength="3" min="0" value="0">(<spring:message code="schedule.second" />)</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<br><br>

				<div class="cmm_bd">
					<div class="sub_tit">
						<p><spring:message code="encrypt_policyOption.Log_Batch_Transmission"/></p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 60px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span style="margin-right: 10%;"> 
											<input type="checkbox" id="blnIsvalueTrueFalse" name="blnIsvalueTrueFalse" onchange="fn_change()"/> 
												<label for="blnIsvalueTrueFalse"><spring:message code="encrypt_policyOption.Collect_logs_only_at_specified_times"/></label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2" colspan="2"><spring:message code="encrypt_policyOption.Transfer_Day"/></th>
								</tr>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span>
												<input type="checkbox" id="sun" name="sun" />
												<label for="sun" style="color: red;"><spring:message code="common.sun" /></label>
											</span>
											<span>
												<input type="checkbox" id="mon" name="mon" />
												<label for="mon"><spring:message code="common.mon" /></label>
											</span>
											<span>
												<input type="checkbox" id="tue" name="tue" />
												<label for="tue"><spring:message code="common.tue" /></label>
											</span>
											<span>
												<input type="checkbox" id="wed" name="wed" />
												<label for="wed"><spring:message code="common.wed" /></label>
											</span>
											<span>
												<input type="checkbox" id="thu" name="thu" />
												<label for="thu"><spring:message code="common.thu" /></label>
											</span>
											<span>
												<input type="checkbox" id="fri" name="fri" />
												<label for="fri"><spring:message code="common.fri" /></label>
											</span>
											<span>
												<input type="checkbox" id="sat" name="sat" />
												<label for="sat" style="color: blue;"><spring:message code="common.sat" /></label>
											</span>
										</div>
									</td>
								</tr>
								<tr> 
									<td><div id="startHour"></div></td> 
									<td><spring:message code="encrypt_policyOption.Start_Transfer"/></td> 
								</tr> 
								<tr>
									<td><div id="endHour"></div></td> 
									<td><spring:message code="encrypt_policyOption.End_Transfer"/></td> 
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
