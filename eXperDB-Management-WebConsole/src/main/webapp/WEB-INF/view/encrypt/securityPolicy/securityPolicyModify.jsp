<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

​
<%
	/**
	* @Class Name : securityPolicyModify.jsp
	* @Description : securityPolicyModify 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*  2020.08.18   변승우 과장		UI 디자인 변경
	
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>

<script>
	var table = null;
	var table2 = null;

	function fn_init() {
		table = $('#encryptPolicyTable').DataTable({
			scrollY : "250px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "offset", className : "dt-right", defaultContent : ""}, 
			{ data : "length", className : "dt-right", defaultContent : ""}, 
			{ data : "cipherAlgorithmCode", defaultContent : ""}, 
			{ data : "resourceName", defaultContent : ""}, 
			{ data : "initialVectorTypeCode", defaultContent : ""}, 
			{ data : "operationModeCode", defaultContent : ""},
			{ data : "binUid", defaultContent : "",defaultContent : "", visible: false}
			],'select': {'style': 'multi'}
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
	    
	    table2 = $('#accessControlTable').DataTable({
			scrollY : "250px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", defaultContent : ""}, 
			{ data : "specName", defaultContent : ""}, 
			{ data : "serverInstanceId", defaultContent : ""}, 
			{ data : "serverLoginId", defaultContent : ""}, 
			{ data : "adminLoginId", defaultContent : ""}, 
			{ data : "osLoginId", defaultContent : ""},
			{ data : "applicationName", defaultContent : ""}, 
			{ data : "accessAddress", defaultContent : ""},
			{ data : "accessAddressMask", defaultContent : ""},
			{ data : "accessMacAddress", defaultContent : ""},
			{ data : "startDateTime", defaultContent : ""},
			{ data : "endDateTime", defaultContent : ""},
			{ data : "startTime", defaultContent : ""},
			{ data : "endTime", defaultContent : ""},
			{ data : "workDay", defaultContent : ""},
			{ data : "massiveThreshold", className : "dt-right", defaultContent : ""},
			{ data : "massiveTimeInterval", className : "dt-right", defaultContent : ""},
			{ data : "extraName", defaultContent : ""},
			{ data : "hostName", defaultContent : ""},
			{ data : "whitelistYesNo", defaultContent : ""}
			],'select': {'style': 'multi'}
		});

	    table2.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	    table2.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
	    table2.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(19)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(20)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		
		table2.on( 'order.dt search.dt', function () {
			table2.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
	}
	
	$(window.document).ready(function() {
		fn_init();

		
		$("#insOptionTab").hide();
		$("#insAccess_Control_PolicTab").hide();
		
		//table 탭 이동시
		$('a[href="#insGeneral_InformationTab"]').on('shown.bs.tab', function (e) {
			$("#insGeneral_InformationTab").show();
			$("#insOptionTab").hide();
			$("#insAccess_Control_PolicTab").hide();
		}); 
		
		//table 탭 이동시
		$('a[href="#insOptionTab"]').on('shown.bs.tab', function (e) {
			$("#insOptionTab").show();
			$("#insGeneral_InformationTab").hide();
			$("#insAccess_Control_PolicTab").hide();
		}); 
		
		//table 탭 이동시
		$('a[href="#insAccess_Control_PolicTab"]').on('shown.bs.tab', function (e) {
			$("#insAccess_Control_PolicTab").show();
			$("#insOptionTab").hide();
			$("#insGeneral_InformationTab").hide();
		});
		
		
		/* var denyResultTypeCode = "${result.denyResultTypeCode}";
		if(denyResultTypeCode == "DRMS" || denyResultTypeCode == "DRRP"){
			$("#masking").show();
			$("#maskingValue").show();
		}else{
			$("#masking").hide();
			$("#maskingValue").hide();
		} */
		
	});


	/*대체 문자열 제어*/
	function fn_changeDenyResult(){
		var denyResultTypeCode = $("#denyResultTypeCode").val();
		if(denyResultTypeCode == "DRMS" || denyResultTypeCode == "DRRP"){
			$("#masking").show();
			$("#maskingValue").show();
		}else{
			$("#masking").hide();
			$("#maskingValue").hide();
		}
	}
	
	/*암보호화 정책 등록 팝업*/
	function fn_SecurityRegForm(){
		
 		$.ajax({
			url : "/popup/securityPolicyRegForm.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
		     error : function(xhr, status, error) {
					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
			success : function(result) {			
				fn_securityPolicyRegFormInit(result);			
				$('#pop_layer_securityPolicyRegForm').modal("show");
			}
		});
		
	}
	
	/*암보호화 정책 등록화면 초기세팅*/
	function fn_securityPolicyRegFormInit(result){	

		$("#pop_offset", "#baseForm").val(""); //시작위치
		$("#pop_length", "#baseForm").val(""); //길이
		$("#pop_last").prop('checked', false) ;		
		$("#pop_cipherAlgorithmCode").val("SEED-128");
		$("#pop_initialVectorTypeCode").val("FIXED");
		$("#pop_operationModeCode").val("CBC");
		
		 var pop_cipherAlgorithmCode = document.getElementById("pop_cipherAlgorithmCode");
		 fn_changeBinUid(pop_cipherAlgorithmCode);				
		 
	}
	
	
	/*암보호화 정책 수정화면 팝업*/
	function fn_SecurityRegReForm(){

		var rowCnt = table.rows('.selected').data().length;
		if (rowCnt == 1) {
			
			var rnum = table.row('.selected').index();
			var offset = table.row('.selected').data().offset;
			var length = table.row('.selected').data().length;
			var cipherAlgorithmCode = table.row('.selected').data().cipherAlgorithmCode;
			var binUid = table.row('.selected').data().binUid;
			var initialVectorTypeCode = table.row('.selected').data().initialVectorTypeCode;
			var operationModeCode = table.row('.selected').data().operationModeCode;
			
	 		$.ajax({
				url : "/popup/securityPolicyRegReForm.do",
				data : {	
					rnum : rnum,
					offset : offset,
					length : length,
					cipherAlgorithmCode : cipherAlgorithmCode,
					binUid : binUid,
					initialVectorTypeCode : initialVectorTypeCode,
					operationModeCode : operationModeCode
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
			     error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if(xhr.status == 403) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
				success : function(result) {			
					fn_securityPolicyRegReFormInit(result);	
					$('#pop_layer_securityPolicyRegReForm').modal("show");
				}
			});
					
		}else{
			showSwalIcon('<spring:message code='message.msg04' />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}		
	}
	

	/*암보호화 정책 수정화면 초기세팅*/
	function fn_securityPolicyRegReFormInit(result){	

		$("#mod_rnum", "#modForm").val(nvlPrmSet(result.mod_rnum, ""));
		$("#mod_offset", "#modForm").val(nvlPrmSet(result.mod_offset, ""));
		$("#mod_length", "#modForm").val(nvlPrmSet(result.mod_length, ""));
		$("#mod_last").prop('checked', false) ;
		$("#mod_cipherAlgorithmCode", "#modForm").val(nvlPrmSet(result.mod_cipherAlgorithmCodeValue, ""));
		$("#mod_binUidValue", "#modForm").val(nvlPrmSet(result.mod_binUidValue, ""));
		$("#mod_initialVectorTypeCode", "#modForm").val(nvlPrmSet(result.mod_initialVectorTypeCodeValue, ""));
		$("#mod_operationModeCode", "#modForm").val(nvlPrmSet(result.mod_operationModeCodeValue, ""));

		 var mod_cipherAlgorithmCode = document.getElementById("mod_cipherAlgorithmCode");
		 fn_mod_changeBinUid(mod_cipherAlgorithmCode);		
		 
	    if(result.mod_length == '<spring:message code="encrypt_policy_management.End"/>'){
	    	$("#mod_last").prop('checked', true) ;
			$('#mod_length').attr('disabled', true);
			$("#mod_binUid").val(result.mod_binUidValue).attr("selected", "selected");
	    }
 
	}
	
	
	/*암보호화 정책 등록*/
	function fn_SecurityAdd(result){
		var stop = 0;
		var data = table.rows().data();
		for(var i=0; i<data.length; i++){
			var length = data[i].length;
			if(length=='<spring:message code="encrypt_policy_management.End"/>'){
				stop = 1;
			}
		}
		
		if(result.length =='<spring:message code="encrypt_policy_management.End"/>' && stop == 1){
			return false;
		}
		
		table.row.add({
			"offset":result.offset,
			"length":result.length,
			"cipherAlgorithmCode":result.cipherAlgorithmCode,
			"binUid":result.binUid,
			"initialVectorTypeCode":result.initialVectorTypeCode,
			"operationModeCode":result.operationModeCode
		}).draw();	
		table.rows({selected: true}).deselect();
		return true;
	}
	
	
	/*암보호화 정책 수정 */
	function fn_SecurityUpdate(result){
		table.cell(result.rnum, 2).data(result.offset).draw();
		table.cell(result.rnum, 3).data(result.length).draw();
		table.cell(result.rnum, 4).data(result.cipherAlgorithmCode).draw();
		table.cell(result.rnum, 5).data(result.resourceName).draw();
		table.cell(result.rnum, 6).data(result.initialVectorTypeCode).draw();
		table.cell(result.rnum, 7).data(result.operationModeCode).draw();
		table.cell(result.rnum, 8).data(result.binUid).draw();
		
		table.rows({selected: true}).deselect();
		return true;
	}
	
	/*암보호화 정책 삭제*/
	function fn_SecurityDel(){
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code='message.msg04' />', '<spring:message code="common.close" />', '', 'error');
			return false;
		} else {
			var rows = table.rows( '.selected' ).remove().draw();
			table.rows({selected: true}).deselect();
		}
	}
	
	
	/*접근제어 정책 등록 팝업*/
	function fn_AccessRegForm(){	
		$.ajax({
			url : "/popup/accessPolicyRegForm.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
		     error : function(xhr, status, error) {
					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
			success : function(result) {			
				fn_accessPolicyRegFormInit();	
				$('#pop_layer_accessPolicyRegForm').modal("show");
			}
		});
	}
	
	/*접근제어 정책 등록 초기세팅*/
	function fn_accessPolicyRegFormInit(){
		$("#specName", "#accbaseForm").val("");
		$("#serverInstanceId", "#accbaseForm").val("");
		$("#serverLoginId", "#accbaseForm").val("");
		$("#adminLoginId", "#accbaseForm").val("");
		$("#osLoginId", "#accbaseForm").val("");
		$("#applicationName", "#accbaseForm").val("");
		$("#accessAddress", "#accbaseForm").val("");
		$("#accessAddressMask", "#accbaseForm").val("");
		$("#accessMacAddress", "#accbaseForm").val("");
		$("#massiveThreshold", "#accbaseForm").val("");
		$("#massiveTimeInterval", "#accbaseForm").val("");
		$("#extraName", "#accbaseForm").val("");
		$("#hostName", "#accbaseForm").val("");
		
		
		dateCalenderSetting();

		fn_makeFromHour();
		fn_makeFromMin();
		fn_makeToHour();
		fn_makeToMin();
	
		$("#SUNDAY").prop('checked', false);
		$("#MONDAY").prop('checked', false);
		$("#TUESDAY").prop('checked', false);
		$("#WEDNESDAY").prop('checked', false);
		$("#THURSDAY").prop('checked', false);
		$("#FRIDAY").prop('checked', false);
		$("#SATURDAY").prop('checked', false);	
		
		$("#to_exe_h").val(23);
		$("#to_exe_m").val(59);
		$('#endDateTime').val('9997-12-31');
		

		$("#whitelistYes").prop('checked', true);		
	}
	
	
	
	
	/*접근제어 정책 등록*/
	function fn_AccessAdd(result){
		table2.row.add({
			"specName":result.specName,
			"serverInstanceId":result.serverInstanceId,
			"serverLoginId":result.serverLoginId,
			"adminLoginId":result.adminLoginId,
			"osLoginId":result.osLoginId,
			"applicationName":result.applicationName,
			"accessAddress":result.accessAddress,
			"accessAddressMask":result.accessAddressMask,
			"accessMacAddress":result.accessMacAddress,
			"startDateTime":result.startDateTime,
			"endDateTime":result.endDateTime,
			"startTime":result.startTime,
			"endTime":result.endTime,
			"workDay":result.workDay,
			"massiveThreshold":result.massiveThreshold,
			"massiveTimeInterval":result.massiveTimeInterval,
			"extraName":result.extraName,
			"hostName":result.hostName,
			"whitelistYesNo":result.whitelistYesNo
		}).draw();	
		table2.rows({selected: true}).deselect();	
	}
	
	
	/*접근제어 정책 수정 팝업*/
	function fn_AccessRegReForm(){
		
		var rowCnt = table2.rows('.selected').data().length;
		
		if (rowCnt == 1) {
			var rnum = table2.row('.selected').index();
			var specName = table2.row('.selected').data().specName;					
			var serverInstanceId = table2.row('.selected').data().serverInstanceId;
			var serverLoginId = table2.row('.selected').data().serverLoginId;
			var adminLoginId = table2.row('.selected').data().adminLoginId;
			var osLoginId = table2.row('.selected').data().osLoginId;
			var applicationName = table2.row('.selected').data().applicationName;
			var accessAddress = table2.row('.selected').data().accessAddress;
			var accessAddressMask = table2.row('.selected').data().accessAddressMask;
			var accessMacAddress = table2.row('.selected').data().accessMacAddress;
			var startDateTime = table2.row('.selected').data().startDateTime;
			var endDateTime = table2.row('.selected').data().endDateTime;
			var startTime = table2.row('.selected').data().startTime;
			var endTime = table2.row('.selected').data().endTime;
			var workDay = table2.row('.selected').data().workDay;
			var massiveThreshold = table2.row('.selected').data().massiveThreshold;
			var massiveTimeInterval = table2.row('.selected').data().massiveTimeInterval;
			var extraName = table2.row('.selected').data().extraName;
			var hostName = table2.row('.selected').data().hostName;
			var whitelistYesNo = table2.row('.selected').data().whitelistYesNo;
						
			$.ajax({
				url : "/popup/accessPolicyRegReForm.do",
				data : {
					rnum : rnum,
					specName : specName,
					serverInstanceId : serverInstanceId,
					serverLoginId : serverLoginId,
					adminLoginId : adminLoginId,
					osLoginId : osLoginId,
					applicationName : applicationName,
					accessAddress : accessAddress,
					accessAddressMask : accessAddressMask,
					accessMacAddress : accessMacAddress,
					startDateTime : startDateTime,
					endDateTime : endDateTime,
					startTime : startTime,
					endTime : endTime,
					workDay : workDay,
					massiveThreshold : massiveThreshold,
					massiveTimeInterval : massiveTimeInterval,
					extraName : extraName,
					hostName : hostName,
					whitelistYesNo : whitelistYesNo			
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
			     error : function(xhr, status, error) {
						if(xhr.status == 401) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else if(xhr.status == 403) {
							showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
				success : function(result) {			
					fn_accessPolicyRegReFormInit(result);	
					$('#pop_layer_accessPolicyRegReForm').modal("show");
				}
			});
			
		}else{
			showSwalIcon('<spring:message code='message.msg04' />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}	
	}
	
	/*접근제어 정책 수정 초기세팅*/
	function fn_accessPolicyRegReFormInit(result){
		
		fn_mod_makeFromHour();
		fn_mod_makeFromMin();
		fn_mod_makeToHour();
		fn_mod_makeToMin();

		$("#rnum", "#accModForm").val(nvlPrmSet(result.rnum, ""));
		$("#mod_specName", "#accModForm").val(nvlPrmSet(result.specName, ""));
		$("#mod_serverInstanceId", "#accModForm").val(nvlPrmSet(result.serverInstanceId, ""));
		$("#mod_serverLoginId", "#accModForm").val(nvlPrmSet(result.serverLoginId, ""));
		$("#mod_adminLoginId", "#accModForm").val(nvlPrmSet(result.adminLoginId, ""));
		$("#mod_osLoginId", "#accModForm").val(nvlPrmSet(result.osLoginId, ""));
		$("#mod_applicationName", "#accModForm").val(nvlPrmSet(result.applicationName, ""));
		$("#mod_accessAddress", "#accModForm").val(nvlPrmSet(result.accessAddress, ""));
		$("#mod_accessAddressMask", "#accModForm").val(nvlPrmSet(result.accessAddressMask, ""));
		$("#mod_accessMacAddress", "#accModForm").val(nvlPrmSet(result.accessMacAddress, ""));
		$("#mod_startDateTime", "#accModForm").val(nvlPrmSet(result.startDateTime, ""));
		$("#mod_endDateTime", "#accModForm").val(nvlPrmSet(result.endDateTime, ""));
		
		var startTime = result.startTime;
		var endTime = result.endTime;
		var from_exe= startTime.split(':');
		var to_exe= endTime.split(':');
		$("#mod_from_exe_h").val(from_exe[0]);
		$("#mod_from_exe_m").val(from_exe[1]);
		$("#mod_to_exe_h").val(to_exe[0]);
		$("#mod_to_exe_m").val(to_exe[1]);
			
		var workday = result.workDay;
		var day = workday.split(",");

		 $('input:checkbox[name="mod_workDay"]').each(function() {
			 for(var i=0; i<day.length; i++){
				if(this.value == day[i]){
					this.checked = true;
				 }
			}
		 });
		 
		$("#mod_massiveThreshold", "#accModForm").val(nvlPrmSet(result.massiveThreshold, ""));
		$("#mod_massiveTimeInterval", "#accModForm").val(nvlPrmSet(result.massiveTimeInterval, ""));
		$("#mod_extraName", "#accModForm").val(nvlPrmSet(result.extraName, ""));
		$("#mod_hostName", "#accModForm").val(nvlPrmSet(result.hostName, ""));

		if(result.whitelistYesNo == 'Y'){
			$("#mod_whitelistYes").prop('checked', true);	
			$("#mod_whitelistNo").prop('checked', false);	
		}else{
			$("#mod_whitelistYes").prop('checked', false);	
			$("#mod_whitelistNo").prop('checked', true);	
		}
		
	}
	
	
	/*접근제어 정책 수정*/
	function fn_AccessUpdate(result){
		table2.cell(result.rnum, 2).data(result.specName).draw();
		table2.cell(result.rnum, 3).data(result.serverInstanceId).draw();
		table2.cell(result.rnum, 4).data(result.serverLoginId).draw();
		table2.cell(result.rnum, 5).data(result.adminLoginId).draw();
		table2.cell(result.rnum, 6).data(result.osLoginId).draw();
		table2.cell(result.rnum, 7).data(result.applicationName).draw();
		table2.cell(result.rnum, 8).data(result.accessAddress).draw();
		table2.cell(result.rnum, 9).data(result.accessAddressMask).draw();
		table2.cell(result.rnum, 10).data(result.accessMacAddress).draw();
		table2.cell(result.rnum, 11).data(result.startDateTime).draw();
		table2.cell(result.rnum, 12).data(result.endDateTime).draw();
		table2.cell(result.rnum, 13).data(result.startTime).draw();
		table2.cell(result.rnum, 14).data(result.endTime).draw();
		table2.cell(result.rnum, 15).data(result.workDay).draw();
		table2.cell(result.rnum, 16).data(result.massiveThreshold).draw();
		table2.cell(result.rnum, 17).data(result.massiveTimeInterval).draw();
		table2.cell(result.rnum, 18).data(result.extraName).draw();
		table2.cell(result.rnum, 19).data(result.hostName).draw();
		table2.cell(result.rnum, 20).data(result.whitelistYesNo).draw();
		
		table2.rows({selected: true}).deselect();
	}
	
	/*접근제어 정책 삭제*/
	function fn_AccessDel(){
		var datas = table2.rows('.selected').data();
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code='message.msg04' />', '<spring:message code="common.close" />', '', 'error');
			return false;
		} else {
			var rows = table2.rows( '.selected' ).remove().draw();
			table2.rows({selected: true}).deselect();
		}
	}
	
	/*정책저장 Validation*/
	function fn_validation(){
		var profileName = document.getElementById("profileName");
		if (profileName.value == "") {
			showSwalIcon('<spring:message code='encrypt_msg.msg06' />', '<spring:message code="common.close" />', '', 'error');
			profileName.focus();
			return false;
		}
		
		var datas = table.rows().data();
		if(datas.length<=0){
			showSwalIcon('<spring:message code='encrypt_msg.msg07' />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		
		var denyResultTypeCode = $("#denyResultTypeCode").val();
		if(denyResultTypeCode == "DRMS" || denyResultTypeCode == "DRRP"){
			var maskingValue = $("#maskingValue").val();
			if(maskingValue==""){
				showSwalIcon('<spring:message code='encrypt_msg.msg08' />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}
		}
		
		return true;
	}
	
	//한글 입력 방지
    function fn_checkProfileName(e) {
    	var objTarget = e.srcElement || e.target;
    	if(objTarget.type == 'text') {
    	var value = objTarget.value;
		if(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/.test(value)) {
			showSwalIcon('<spring:message code='encrypt_msg.msg22' />', '<spring:message code="common.close" />', '', 'error');
	   		objTarget.value = objTarget.value.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
	  		}
    	}
    }
	
	/*정책저장*/
	function fn_save(){

		/*보안정책*/
		var datas = table.rows().data();
		var securityPolicy = [];
		for(var i = 0; i < datas.length; i++){
			var tmpmap = new Object();
			tmpmap["offset"] = table.rows().data()[i].offset;
			tmpmap["length"] = table.rows().data()[i].length;
			tmpmap["cipherAlgorithmCode"] = table.rows().data()[i].cipherAlgorithmCode;
			tmpmap["binUid"] = table.rows().data()[i].binUid;
			tmpmap["initialVectorTypeCode"] = table.rows().data()[i].initialVectorTypeCode;
			tmpmap["operationModeCode"] = table.rows().data()[i].operationModeCode;
			securityPolicy.push(tmpmap);	
			}
		
		/*접근제어정책*/
		var datas2 = table2.rows().data();
		var accessPolicy = [];
		for(var i = 0; i < datas2.length; i++){
			var policy = new Object();
			policy["specName"] = table2.rows().data()[i].specName;
			policy["serverInstanceId"] = table2.rows().data()[i].serverInstanceId;
			policy["serverLoginId"] = table2.rows().data()[i].serverLoginId;
			policy["adminLoginId"] = table2.rows().data()[i].adminLoginId;
			policy["osLoginId"] = table2.rows().data()[i].osLoginId;
			policy["applicationName"] = table2.rows().data()[i].applicationName;
			policy["accessAddress"] = table2.rows().data()[i].accessAddress;
			policy["accessAddressMask"] = table2.rows().data()[i].accessAddressMask;
			policy["accessMacAddress"] = table2.rows().data()[i].accessMacAddress;
			policy["startDateTime"] = table2.rows().data()[i].startDateTime;
			policy["endDateTime"] = table2.rows().data()[i].endDateTime;
			policy["startTime"] = table2.rows().data()[i].startTime;
			policy["endTime"] = table2.rows().data()[i].endTime;
			policy["workDay"] = table2.rows().data()[i].workDay;
			policy["massiveThreshold"] = table2.rows().data()[i].massiveThreshold;
			policy["massiveTimeInterval"] = table2.rows().data()[i].massiveTimeInterval;
			policy["extraName"] = table2.rows().data()[i].extraName;
			policy["hostName"] = table2.rows().data()[i].hostName;
			policy["whitelistYesNo"] = table2.rows().data()[i].whitelistYesNo;
			accessPolicy.push(policy);
			}
		
		var denyResultTypeCode = $("#denyResultTypeCode").val();
		var maskingValue = "";
		if(denyResultTypeCode == "DRMS" || denyResultTypeCode == "DRRP"){
			maskingValue = $("#maskingValue").val();
		}else{
			maskingValue = "";
		}	

		$.ajax({
			url : '/updateSecurityPolicy.do',
			type : 'post',
			data : {
				profileUid : "${profileUid}",
				
				/*기본정보*/
				profileName : $("#profileName").val(),
				profilenote : $("#profileNote").val(),
				
				/*보안정책*/
				securityPolicy : JSON.stringify(securityPolicy),
				
				/*옵션*/
				defaultAccessAllowTrueFalse : $(":radio[name='defaultAccessAllowTrueFalse']:checked").val(),
				denyResultTypeCode : $("#denyResultTypeCode").val(),
				dataTypeCode : "DTCH",
				log_on_fail : $(":checkbox[name='log_on_fail']:checked").val(),
				compress_audit_log : $(":checkbox[name='compress_audit_log']:checked").val(),
				preventDoubleYesNo : $(":checkbox[name='preventDoubleYesNo']:checked").val(),
				log_on_success : $(":checkbox[name='log_on_success']:checked").val(),
				nullEncryptYesNo : $(":checkbox[name='nullEncryptYesNo']:checked").val(),
				maskingValue : maskingValue,

				/*접근제어정책*/
				accessPolicy : JSON.stringify(accessPolicy),
				
			},
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIconRst('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success', 'securityPolicy');
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
		
	}
	
	
	
	function fn_confirm(){
		
		if (!fn_validation()) return false;
		fn_ConfirmModal();
	}


	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_ConfirmModal() {
		confirm_title = '<spring:message code="encrypt_policy_management.Security_Policy_Modify"/>' ;
		 $('#confirm_msg').html('<spring:message code="message.msg148" />');

		$('#confirm_tlt').html(confirm_title);
		$('#pop_confirm_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmRst(){
		fn_save();
	}
	
</script>


<%@include file="../popup/securityPolicyRegForm.jsp"%>
<%@include file="../popup/securityPolicyRegReForm.jsp"%>
<%@include file="../popup/accessPolicyRegForm.jsp"%>
<%@include file="../popup/accessPolicyRegReForm.jsp"%> 
<%@include file="./../../popup/confirmForm.jsp"%>


<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_policy_management.Security_Policy_Modify"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
							 				<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></li>
											<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policy_management.Security_Policy_Modify"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Security_Policy_Update"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">

					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_confirm();" >
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.save"/>
								</button>
							</div>
						</div>
					</div>

					<div class="form-group row div-form-margin-z" style="margin-top:10px;margin-bottom:-10px;">
						<div class="col-12" >
							<ul class="nav nav-pills nav-pills-setting" style="border-bottom:0px;" id="server-tab" role="tablist">
								<li class="nav-item tab-pop-two-style"  style="width:31.5%">										
									<a class="nav-link active" id="ins-tab-1" data-toggle="pill" href="#insGeneral_InformationTab" role="tab" aria-controls="insGeneral_InformationTab" aria-selected="true" >
										<spring:message code="encrypt_policy_management.General_Information"/>
									</a>
								</li>
								<li class="nav-item tab-pop-two-style" style="width:31.5%">
									<a class="nav-link" id="ins-tab-2" data-toggle="pill" href="#insOptionTab" role="tab" aria-controls="insOptionTab" aria-selected="false">
										<spring:message code="encrypt_policy_management.Option"/>
									</a>
								</li>
								<li class="nav-item tab-pop-two-style" style="width:31.5%">									
									<a class="nav-link" id="ins-tab-3" data-toggle="pill" href="#insAccess_Control_PolicTab" role="tab" aria-controls="insAccess_Control_PolicTab" aria-selected="false">
										<spring:message code="encrypt_policy_management.Access_Control_Policy"/>
									</a>
								</li>
							</ul>
						</div>
					</div>

					<!-- tab화면 -->
					<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;">
						<div class="tab-pane fade show active" role="tabpanel" id="insGeneral_InformationTab">
							<div class="card-body" style="border: 1px solid #c9ccd7;margin-top:-10px;">
								<div class="row">
									<div class="col-12">
										<form class="cmxform" id="insRegForm">
											<fieldset>
												<div class="form-group row" style="margin-bottom:10px;margin-top:0px;">
													<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policy_management.Security_Policy_Name"/>(*)
													</label>
													<div class="col-sm-4">
														<input type="text" class="form-control form-control-xsm" id="profileName" name="profileName"  value="${result.profileName}" maxlength="20" placeholder='20<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()" tabindex=3 />
													</div>
												</div>
												<div class="form-group row" style="margin-bottom:-10px;">
													<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policy_management.Description"/>
													</label>
													<div class="col-sm-4">
														<input type="text" class="form-control form-control-xsm" id="profileNote" name="profileNote" value="${result.profileNote}" maxlength="100" placeholder='100<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()" tabindex=3 />
													</div>
												</div>
											</fieldset>
										</form>
									</div>
								</div>
							</div>

							<div class="card-body" style="margin-top:-10px;margin-bottom:-20px;">
								<div class="row">
									<div class="col-12">
										<div class="template-demo">
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="del_button" onClick="fn_SecurityDel();" >
												<i class="ti-minus btn-icon-prepend "></i><spring:message code="common.delete" />
											</button>                              
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_SecurityRegReForm();" data-toggle="modal">
												<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
											</button>                              
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="add_button" onClick="fn_SecurityRegForm();" data-toggle="modal">
												<i class="ti-plus btn-icon-prepend "></i><spring:message code="common.add" />
											</button>
										</div>
									</div>
								</div>

								<div class="table-responsive">
									<div id="order-listing_wrapper"
										class="dataTables_wrapper dt-bootstrap4 no-footer">
										<div class="row">
											<div class="col-sm-12 col-md-6">
												<div class="dataTables_length" id="order-listing_length">
												</div>
											</div>
										</div>
									</div>
								</div>

					 			<table id="encryptPolicyTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
									<thead>
				 						<tr class="bg-info text-white">
											<th width="40"></th>
											<th width="60"><spring:message code="common.no" /></th>
											<th width="120"><spring:message code="encrypt_policy_management.Starting_Position"/></th>
											<th width="100"><spring:message code="encrypt_policy_management.Length"/></th>
											<th width="200"><spring:message code="encrypt_policy_management.Encryption_Algorithm"/></th>
											<th width="100"><spring:message code="encrypt_policy_management.Encryption_Key"/></th>
											<th width="80"><spring:message code="encrypt_policy_management.Initial_Vector"/></th>
											<th width="100"><spring:message code="encrypt_policy_management.Modes"/></th>
											<th width="0"></th>	
										</tr>
									</thead>
									<tbody>
										<c:forEach var="ProfileCipherSpecData" items="${result.ProfileCipherSpecData}">
											<tr>
												<td></td>
												<td></td>
												<td>${ProfileCipherSpecData.offset}</td>
												<td>
													<c:if test="${ProfileCipherSpecData.length eq null}"><spring:message code="encrypt_policy_management.End"/></c:if>
													<c:if test="${ProfileCipherSpecData.length != '' || ProfileCipherSpecData.length ne null}">${ProfileCipherSpecData.length}</c:if>
												</td>
												<td>${ProfileCipherSpecData.CipherAlgorithmName}</td>
												<td>
													<c:forEach var="cryptoKey" items="${cryptoKey}">
														<c:if test="${cryptoKey.getBinUid eq ProfileCipherSpecData.binUid}" >${cryptoKey.resourceName}</c:if>	
													</c:forEach>
												</td>
												<td>
													<c:if test="${ProfileCipherSpecData.initialVectorTypeCode eq 'IVFX'}">FIXED</c:if>
													<c:if test="${ProfileCipherSpecData.initialVectorTypeCode eq 'IVRD'}">RANDOM</c:if>
												</td>
												<td>
													<c:if test="${ProfileCipherSpecData.operationModeCode eq 'OMCB'}">CBC</c:if>
													<c:if test="${ProfileCipherSpecData.operationModeCode eq 'OMCT'}">CTR</c:if>
												</td>
												<td>${ProfileCipherSpecData.binUid}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>	
						</div>

						<!-- 옵션 탭 -->
						<div class="tab-pane fade show active" role="tabpanel" id="insOptionTab">
							<div class="card-body" style="border: 1px solid #c9ccd7;margin-top:-10px;">
								<div class="row">
									<div class="col-12">
										<form class="cmxform" id="insRegForm">
											<fieldset>
												<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policy_management.Grant_Access"/>
													</label>

													<div class="col-sm-1">
														<div class="form-check">
															<label class="form-check-label">
															<input type="radio" class="form-check-input" name="defaultAccessAllowTrueFalse" id="rdo_2_1"  value="Y" ${result.defaultAccessAllowTrueFalse == 'true' ? 'checked="checked"' : ''} > 예																
															</label>
														</div>												
													</div>	

													<div class="col-sm-1">
														<div class="form-check">
															<label class="form-check-label">
															<input type="radio" class="form-check-input" name="defaultAccessAllowTrueFalse" id="rdo_2_2" value="N" ${result.defaultAccessAllowTrueFalse == 'false' ? 'checked="checked"' : ''}> 아니오														
															</label>
														</div>												
													</div>
												</div>

												<div class="form-group row" style="margin-bottom:10px;">
													<label for="ins_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="encrypt_policy_management.Action_when_Access_Denied"/>
													</label>
													<div class="col-sm-2">
														<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="denyResultTypeCode" id="denyResultTypeCode" onchange="fn_changeDenyResult()">
															<c:forEach var="denyResultTypeCode" items="${denyResultTypeCode}">
																<option value="<c:out value="${denyResultTypeCode.sysCode}"/>" ${result.denyResultTypeCode == denyResultTypeCode.sysCode ? 'selected="selected"' : ''}><c:out value="${denyResultTypeCode.sysCodeName}"/></option>
															</c:forEach>
														</select>
													</div>
												</div>

												<div class="form-group row" style="margin-bottom:10px;">
													<span class="form-check"  style="margin-left: 15px;">
														<label class="form-check-label">
															<input type="checkbox" class="form-check-input" id="log_on_fail" name="log_on_fail"  value="Y" ${result.log_on_fail == 'true' ? 'checked="checked"' : ''} />
															<spring:message code="encrypt_policy_management.Failure_Logging"/>
															<i class="input-helper"></i>
														</label>
													</span>

													<span class="form-check"  style="margin-left: 20px;">
														<label class="form-check-label">
															<input type="checkbox" class="form-check-input" id="compress_audit_log" name="compress_audit_log" value="Y" ${result.compress_audit_log == 'true' ? 'checked="checked"' : ''}/>
															<spring:message code="encrypt_policy_management.Log_Compression"/>
															<i class="input-helper"></i>
														</label>
													</span>

													<span class="form-check"  style="margin-left: 20px;">
														<label class="form-check-label">
															<input type="checkbox" class="form-check-input" id="preventDoubleYesNo" name="preventDoubleYesNo" value="Y" ${result.preventDoubleYesNo == 'Y' ? 'checked="checked"' : ''} />
															<spring:message code="encrypt_policy_management.Prevent_Double_Encryption"/>
															<i class="input-helper"></i>
														</label>
													</span>

													<span class="form-check"  style="margin-left: 20px;">
														<label class="form-check-label">
															<input type="checkbox" class="form-check-input" id="log_on_success" name="log_on_success" value="Y" ${result.log_on_success == 'true' ? 'checked="checked"' : ''}/>
															<spring:message code="encrypt_policy_management.Success_Logging"/>
															<i class="input-helper"></i>
														</label>
													</span>

													<span class="form-check"  style="margin-left: 20px;">
															<label class="form-check-label">
																<input type="checkbox" class="form-check-input" id="nullEncryptYesNo" name="nullEncryptYesNo" value="Y" ${result.nullEncryptYesNo == 'Y' ? 'checked="checked"' : ''}/>
																<spring:message code="encrypt_policy_management.NULL_Encryption"/>
																<i class="input-helper"></i>
															</label>
													</span>
												</div>
											</fieldset>
										</form>											
									</div>
								</div>
							</div>
						</div>
						<!--  옵션 탭 끝 -->

						<!-- 접근제어정책 탭 -->
						<div class="tab-pane fade show active" role="tabpanel" id="insAccess_Control_PolicTab">
							<div class="card-body" style="border: 1px solid #c9ccd7;margin-top:-10px;">
								<div class="row">
									<div class="col-12">
										<div class="template-demo">
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="del_button" onClick="fn_AccessDel();" >
												<i class="ti-minus btn-icon-prepend "></i><spring:message code="common.delete" />
											</button>
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_AccessRegReForm();" data-toggle="modal">
												<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
											</button>
											<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="add_button" onClick="fn_AccessRegForm();" data-toggle="modal">
												<i class="ti-plus btn-icon-prepend "></i><spring:message code="common.add" />
											</button>
										</div>
									</div>
								</div>

								<div class="table-responsive">
									<div id="order-listing_wrapper"
										class="dataTables_wrapper dt-bootstrap4 no-footer">
										<div class="row">
											<div class="col-sm-12 col-md-6">
												<div class="dataTables_length" id="order-listing_length">
												</div>
											</div>
										</div>
									</div>
								</div>

					 			<table id="accessControlTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
									<thead>
				 						<tr class="bg-info text-white">
										<th width="10"></th>
										<th width="20"><spring:message code="common.no" /></th>
										<th width="100"><spring:message code="encrypt_policy_management.Policy_Name"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Server_Instance"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Database_User"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.eXperDB_User"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.OS_User"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Application_Name"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.IP_Address"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.IP_Mask"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.MAC_Address"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Policy_Period"/> FROM</th>
										<th width="100"><spring:message code="encrypt_policy_management.Policy_Period"/> TO</th>
										<th width="100"><spring:message code="encrypt_policy_management.Policy_Time"/> FROM</th>
										<th width="100"><spring:message code="encrypt_policy_management.Policy_Time"/> TO</th>
										<th width="100"><spring:message code="encrypt_policy_management.Day_of_Week"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Threshold"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.sec"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Additional_Fields"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Host_Name"/></th>
										<th width="100"><spring:message code="encrypt_policy_management.Whether_Allowing_Access"/></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="arrProfileAclSpec" items="${result.arrProfileAclSpec}">
										<tr>
											<td></td>
											<td></td>
											<td>${arrProfileAclSpec.specName}</td>
											<td>${arrProfileAclSpec.serverInstanceId}</td>
											<td>${arrProfileAclSpec.serverLoginId}</td>
											<td>${arrProfileAclSpec.adminLoginId}</td>
											<td>${arrProfileAclSpec.osLoginId}</td>
											<td>${arrProfileAclSpec.applicationName}</td>
											<td>${arrProfileAclSpec.accessAddress}</td>
											<td>${arrProfileAclSpec.accessAddressMask}</td>
											<td>${arrProfileAclSpec.accessMacAddress}</td>
											<td>${arrProfileAclSpec.startDateTime}</td>
											<td>${arrProfileAclSpec.endDateTime}</td>
											<td>${arrProfileAclSpec.startTime}</td>
											<td>${arrProfileAclSpec.endTime}</td>
											<td>${arrProfileAclSpec.workDay}</td>
											<td>${arrProfileAclSpec.massiveThreshold}</td>
											<td>${arrProfileAclSpec.massiveTimeInterval}</td>
											<td>${arrProfileAclSpec.extraName}</td>
											<td>${arrProfileAclSpec.hostName}</td>
											<td>${arrProfileAclSpec.whitelistYesNo}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>						
			</div>
		</div>
	</div>	
</div>