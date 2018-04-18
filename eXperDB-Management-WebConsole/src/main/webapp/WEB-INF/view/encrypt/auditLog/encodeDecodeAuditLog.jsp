<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : encodeDecodeAuditLog.jsp
	* @Description : encodeDecodeAuditLog 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.09     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.09
	*
	*/
%>
<script>
	var table = null;

	function fn_init() {
		table = $('#encodeDecodeTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", className : "dt-center", defaultContent : ""},  
				{ data : "agentLogDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "agentRemoteAddress", className : "dt-center", defaultContent : ""},
				{ data : "profileName", className : "dt-center", defaultContent : ""},
				{ data : "instanceId", className : "dt-center", defaultContent : ""},
				{ data : "siteAccessAddress", className : "dt-center", defaultContent : ""},
				{ data : "macAddr", className : "dt-center", defaultContent : ""},
				{ data : "osLoginId", className : "dt-center", defaultContent : ""},
				{ data : "serverLoginId", className : "dt-center", defaultContent : ""},
				{ data : "adminLoginId", className : "dt-center", defaultContent : ""},
				{ data : "applicationName", className : "dt-center", defaultContent : ""},
				{ data : "extraName", className : "dt-center", defaultContent : ""},
				{ data : "hostName", className : "dt-center", defaultContent : ""},
				{ data : "locationInfo", className : "dt-center", defaultContent : ""},
				{ data : "moduleInfo", className : "dt-center", defaultContent : ""},
// 				{ data : "weekday", className : "dt-center", defaultContent : ""}, 
				{
					data : "weekday",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == "0") {
							html += '<spring:message code="common.sun" />';
						} 
						if (data == "1") {
							html += '<spring:message code="common.mon" />';
						} 
						if (data == "2") {
							html += '<spring:message code="common.tue" />';
						} 
						if (data == "3") {
							html += '<spring:message code="common.wed" />';
						} 
						if (data == "4") {
							html += '<spring:message code="common.thu" />';
						} 
						if (data == "5") {
							html += '<spring:message code="common.fri" />';
						} 
						if (data == "6") {
							html += '<spring:message code="common.sat" />';
						} 
						return html;
					},
					className : "dt-center",
					defaultContent : ""
				},
				{
					data : "encryptTrueFalse",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == true) {
							html += '<spring:message code="encrypt_log_decode.Encryption"/>';
						} else {
							html += '<spring:message code="encrypt_log_decode.Decryption"/>';
						}
						return html;
					},
					className : "dt-center",
					defaultContent : ""
				},
				{
					data : "successTrueFalse",
					render : function(data, type, full, meta) {
						var html = "";
						if (data == true) {
							html += '<spring:message code="common.success" />';
						} else {
							html += '<spring:message code="common.failed" />';
						}
						return html;
					},
					className : "dt-center",
					defaultContent : ""
				},
				{ data : "count", className : "dt-center", defaultContent : ""},
				{ data : "siteIntegrityResult", className : "dt-center", defaultContent : ""},
				{ data : "serverIntegrityResult", className : "dt-center", defaultContent : ""},
				{ data : "createDateTime", className : "dt-center", defaultContent : ""},
				{ data : "updateDateTime", className : "dt-center", defaultContent : ""}
	
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(19)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(20)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(21)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(22)').css('min-width', '150px');
	
	    $(window).trigger('resize');
	    
	}
	
	$(window.document).ready(function() {
		var dateFormat = "yyyy-mm-dd", from = $("#from").datepicker({
			changeMonth : false,
			changeYear : false,
			onClose : function(selectedDate) {
				$("#to").datepicker("option", "minDate", selectedDate);
			}
		})

		to = $("#to").datepicker({
			changeMonth : false,
			changeYear : false,
			onClose : function(selectedDate) {
				$("#from").datepicker("option", "maxDate", selectedDate);
			}
		})
		
		$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		
		fn_init();
		
		$.ajax({
			url : "/selectEncodeDecodeAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				agentUid : $('#agentUid').val(),
				successTrueFalse : $('#successTrueFalse').val(),
				searchFieldName : $('#searchFieldName').val(),
				searchOperator : $('#searchOperator').val(),
				searchFieldValueString : $('#searchFieldValueString').val()
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
					table.clear().draw();
					if(data.list!=null){
						table.rows.add(data.list).draw();
					}
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");	
				}
			}
		});		
	});
	

	/* 조회 버튼 클릭시*/
	function fn_select() {
		$.ajax({
			url : "/selectEncodeDecodeAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				agentUid : $('#agentUid').val(),
				successTrueFalse : $('#successTrueFalse').val(),
				searchFieldName : $('#searchFieldName').val(),
				searchOperator : $('#searchOperator').val(),
				searchFieldValueString : $('#searchFieldValueString').val()
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
					table.clear().draw();
					if(data.list!=null){
						table.rows.add(data.list).draw();
					}
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					location.href="/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");	
				}
			}
		});
	}
	
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_log_decode.Encryption_Decryption"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Encryption_Decryption"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_log.Audit_Log"/></li>
					<li class="on"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select();"><button><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 170px;" />
							<col style="width: 500px;" />
							<col style="width: 120px;" />
							</col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10"><spring:message code="encrypt_log_decode.Log_Period"/></th>
								<td>
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" />
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9"><spring:message code="encrypt_log_decode.Agent"/></th>
								<td>
									<select class="select t3" id="agentUid" name="agentUid">
										<option value="" ><spring:message code="common.total" /> </option>
										<c:forEach var="result" items="${result}" varStatus="status">
											<option value="<c:out value="${result.entityUid}"/>" ><c:out value="${result.entityName}"/></option>
										</c:forEach> 
									</select>
								</td>
								<th scope="row" class="t9"><spring:message code="encrypt_log_decode.Success_Failure"/></th>
								<td>
									<select class="select t8" id="successTrueFalse" name="successTrueFalse">
										<option value=""><spring:message code="common.total" /> </option>
										<option value="true"><spring:message code="common.success" /></option>
										<option value="false"><spring:message code="common.failed" /></option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9"><spring:message code="encrypt_log_decode.Additional_Search_Condition"/></th>
								<td>
									<select class="select t5" id="searchFieldName" name="searchFieldName">
										<option value=""><spring:message code="encrypt_log_decode.Not_Select"/></option>
										<option value="PROFILE_NM"><spring:message code="encrypt_policy_management.Policy_Name"/></option>
										<option value="SITE_ACCESS_ADDRESS"><spring:message code="encrypt_log_decode.Client_Address"/></option>
										<option value="HOST_NM"><spring:message code="encrypt_policy_management.Host_Name"/></option>
										<option value="EXTRA_NM"><spring:message code="encrypt_policy_management.Additional_Fields"/></option>
										<option value="MODULE_INFO"><spring:message code="encrypt_log_decode.Module_Information"/></option>
										<option value="LOCATION_INFO"><spring:message code="encrypt_log_decode.Column_Name"/></option>
										<option value="SERVER_LOGIN_ID"><spring:message code="encrypt_policy_management.Database_User"/></option>
										<option value="ADMIN_LOGIN_ID"><spring:message code="encrypt_policy_management.eXperDB_User"/></option>
										<option value="OS_LOGIN_ID"><spring:message code="user_management.user_id" /></option>
										<option value="APPLICATION_NM"><spring:message code="encrypt_policy_management.Application_Name"/></option>
										<option value="INSTANCE_ID"><spring:message code="encrypt_policy_management.Server_Instance"/></option>										
									</select>
									<select class="select t8" id="searchOperator" name="searchOperator">
										<option value="LIKE">Like</option>
										<option value="=">=</option>
										<option value="<">&lt;</option>
										<option value=">">&gt;</option>
									</select>
									<input type="text" class="txt t3" id="searchFieldValueString" name="searchFieldValueString"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="encodeDecodeTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="encrypt_log_decode.Agent_Log_Date"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Agent_Address"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Securiy_Policy"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Server_Instance"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Client_Address"/> </th>
								<th width="100"><spring:message code="encrypt_log_decode.MAC_Address"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.OS_User"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Database_User"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.eXperDB_User"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Application_Name"/></th>
								<th width="100">Extra Name</th>
								<th width="100"><spring:message code="encrypt_policy_management.Host_Name"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Column_Name"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Module_Information"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Day_of_Week"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Action"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Result"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Count"/></th>
								<th width="100"><spring:message code="encrypt_log_decode.Site_Integrity"/></th>
								<th width="120"><spring:message code="encrypt_log_decode.ServerIntegrity"/></th>
								<th width="150"><spring:message code="encrypt_log_decode.Log_Create_Time"/></th>
								<th width="150"><spring:message code="encrypt_log_sever.Log_Update_Time"/></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
