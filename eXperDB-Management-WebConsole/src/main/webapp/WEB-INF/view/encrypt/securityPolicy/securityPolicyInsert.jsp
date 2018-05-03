<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : securityPolicyInsert.jsp
	* @Description : securityPolicyInsert 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>
<style>
.contents .cmm_tab li {
	width: 33.33%;
}

.contents {
    min-height: 600px;
 }
 
.cmm_bd .sub_tit > p{
	padding:0 8px 0 33px;
	line-height:24px;
	background:url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}

.inp_chk > span{
	margin-right: 10%;
}

.contents .cmm_tab {
    position: inherit ;
}
.contents .cmm_tab li.atv > a {
    border-top: 1px solid rgba(0, 0, 0, 0.3);
    border-left: 1px solid rgba(0, 0, 0, 0.3);
    border-right: 1px solid rgba(0, 0, 0, 0.3);
}
</style>
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
			{ data : "binUid", defaultContent : ""}, 
			{ data : "initialVectorTypeCode", defaultContent : ""}, 
			{ data : "operationModeCode", defaultContent : ""}
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
			{ data : "", className : "dt-center", defaultContent : ""}, 
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

		$("#tab1").show();
		$("#tab2").hide();
		$("#tab3").hide();

		$("#info").show();
		$("#option").hide();
		$("#accessControl").hide();
	});

	function selectTab(tab) {
		if (tab == "info") {
			$("#tab1").show();
			$("#tab2").hide();
			$("#tab3").hide();

			$("#info").show();
			$("#option").hide();
			$("#accessControl").hide();
		} else if (tab == "option") {
			$("#tab1").hide();
			$("#tab2").show();
			$("#tab3").hide();

			$("#info").hide();
			$("#option").show();
			$("#accessControl").hide();
		} else {
			$("#tab1").hide();
			$("#tab2").hide();
			$("#tab3").show();

			$("#info").hide();
			$("#option").hide();
			$("#accessControl").show();
		}

	}
	
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
		var popUrl = "/popup/securityPolicyRegForm.do?act=i"; // 서버 url 팝업경로
		var width = 1000;
		var height = 530;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);		
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
	
	/*암보호화 정책 수정 팝업*/
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
			
			var popUrl = "/popup/securityPolicyRegForm.do?act=u&&offset="+offset+"&&length="+encodeURI(length)+"&&cipherAlgorithmCode="+cipherAlgorithmCode+"&&binUid="+binUid+"&&initialVectorTypeCode="+initialVectorTypeCode+"&&operationModeCode="+operationModeCode+"&&rnum="+rnum; // 서버 url 팝업경로
			var width = 1000;
			var height = 530;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
			window.open(popUrl,"",popOption);
		}else{
			alert("<spring:message code='message.msg04' />");
			return false;
		}			
	}
	
	/*암보호화 정책 수정 */
	function fn_SecurityUpdate(result){
		table.cell(result.rnum, 2).data(result.offset).draw();
		table.cell(result.rnum, 3).data(result.length).draw();
		table.cell(result.rnum, 4).data(result.cipherAlgorithmCode).draw();
		table.cell(result.rnum, 5).data(result.binUid).draw();
		table.cell(result.rnum, 6).data(result.initialVectorTypeCode).draw();
		table.cell(result.rnum, 7).data(result.operationModeCode).draw();
		
		table.rows({selected: true}).deselect();
		return true;
	}
	
	/*암보호화 정책 삭제*/
	function fn_SecurityDel(){
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert("<spring:message code='message.msg04' />");
			return false;
		} else {
			var rows = table.rows( '.selected' ).remove().draw();
			table.rows({selected: true}).deselect();
		}
	}
	
	/*접근제어 정책 등록 팝업*/
	function fn_AccessRegForm(){
		var popUrl = "/popup/accessPolicyRegForm.do?act=i"; // 서버 url 팝업경로
		var width = 1000;
		var height = 755;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);	
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
			
			var popUrl = "/popup/accessPolicyRegForm.do?act=u&&specName="+specName
					+"&&serverInstanceId="+serverInstanceId+"&&serverLoginId="+encodeURI(serverLoginId)+"&&adminLoginId="+encodeURI(adminLoginId)
					+"&&osLoginId="+encodeURI(osLoginId)+"&&applicationName="+encodeURI(applicationName)+"&&accessAddress="+accessAddress
					+"&&accessAddressMask="+accessAddressMask+"&&accessMacAddress="+accessMacAddress+"&&startDateTime="+startDateTime
					+"&&endDateTime="+endDateTime+"&&startTime="+startTime+"&&endTime="+endTime
					+"&&workDay="+encodeURI(workDay)+"&&massiveThreshold="+massiveThreshold+"&&massiveTimeInterval="+massiveTimeInterval
					+"&&extraName="+encodeURI(extraName)+"&&hostName="+encodeURI(hostName)+"&&whitelistYesNo="+whitelistYesNo+"&&rnum="+rnum; // 서버 url 팝업경로
			var width = 1000;
			var height = 755;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
			window.open(popUrl,"",popOption);
		}else{
			alert("<spring:message code='message.msg04' />");
			return false;
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
			alert("<spring:message code='message.msg04' />");
			return false;
		} else {
			var rows = table2.rows( '.selected' ).remove().draw();
			table2.rows({selected: true}).deselect();
		}
	}

	
	//한글 입력 방지
    function fn_checkProfileName(e) {
    	var objTarget = e.srcElement || e.target;
    	if(objTarget.type == 'text') {
    	var value = objTarget.value;
    		if(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/.test(value)) {
    			alert('<spring:message code="encrypt_msg.msg22"/>');
    	   		objTarget.value = objTarget.value.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
    	  	}
    	 }
    }
	
	/*정책저장 Validation*/
	function fn_validation(){
		var profileName = document.getElementById("profileName");
		if (profileName.value == "") {
			alert('<spring:message code="encrypt_msg.msg06"/>');
			profileName.focus();
			return false;
		}
		
		var datas = table.rows().data();
		if(datas.length<=0){
			alert('<spring:message code="encrypt_msg.msg07"/>');
			return false;
		}
		
		var denyResultTypeCode = $("#denyResultTypeCode").val();
		if(denyResultTypeCode == "DRMS" || denyResultTypeCode == "DRRP"){
			var maskingValue = $("#maskingValue").val();
			if(maskingValue==""){
				alert('<spring:message code="encrypt_msg.msg08"/>');
				return false;
			}
		}
		return true;
	}
	
	
	/*정책저장*/
	function fn_save(){
		
		if (!fn_validation()) return false;
		
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
			url : '/insertSecurityPolicy.do',
			type : 'post',
			data : {
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
					alert('<spring:message code="message.msg07" />');
					location.href='/securityPolicy.do' ;
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");	
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
		
	}
</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="etc.etc01"/><a href="#n"><img src="/images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Security_Policy_Insert"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policy_management.Policy_Key_Management"/></li>
					<li><spring:message code="encrypt_policy_management.Security_Policy_Management"/></li>
					<li class="on"><spring:message code="etc.etc01"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<a href="#n" class="btn"><span onclick="fn_save()"><spring:message code="common.save"/></span></a> 
				</div>
			</div>
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('info')"><spring:message code="encrypt_policy_management.General_Information"/></a></li>
					<li><a href="javascript:selectTab('option')"><spring:message code="encrypt_policy_management.Option"/></a></li>
					<li><a href="javascript:selectTab('accessControl')"><spring:message code="encrypt_policy_management.Access_Control_Policy"/></a></li>
				</ul>
				<ul id="tab2" style="display: none;">
					<li><a href="javascript:selectTab('info')"><spring:message code="encrypt_policy_management.General_Information"/></a></li>
					<li class="atv"><a href="javascript:selectTab('option')"><spring:message code="encrypt_policy_management.Option"/></a></li>
					<li><a href="javascript:selectTab('accessControl')"><spring:message code="encrypt_policy_management.Access_Control_Policy"/></a></li>
				</ul>
				<ul id="tab3" style="display: none;">
					<li><a href="javascript:selectTab('info')"><spring:message code="encrypt_policy_management.General_Information"/></a></li>
					<li><a href="javascript:selectTab('option')"><spring:message code="encrypt_policy_management.Option"/></a></li>
					<li class="atv"><a href="javascript:selectTab('accessControl')"><spring:message code="encrypt_policy_management.Access_Control_Policy"/></a></li>
				</ul>
			</div>

			<div id="info">
				<div class="sch_form">
					<table class="write">
						<colgroup>
							<col style="width:160px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Security_Policy_Name"/>(*)</th>
								<td><input type="text" class="txt t2" name="profileName" id="profileName" maxlength="20" onkeyup='fn_checkProfileName(event)' style='ime-mode:disabled;' placeholder="20<spring:message code='message.msg188'/>"/></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Description"/> </th>
								<td><textarea class="tbd1" name="profileNote" id="profileNote" maxlength="100" onkeyup="fn_checkWord(this,100)" placeholder="100<spring:message code='message.msg188'/>"></textarea></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="cmm_bd">
					<div class="sub_tit">
						<p><spring:message code="encrypt_log_decode.Securiy_Policy"/></p>
						<div class="sub_btn">
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_SecurityRegForm();">
							<span id="add_button"><spring:message code="common.add" /></span></a> 
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_SecurityRegReForm()">
							<span id="add_button"><spring:message code="common.modify" /></span></a> 
							<a href="#n" class="btn btnF_04" onclick="fn_SecurityDel();"> 
							<span id="del_button"><spring:message code="button.delete" /></span></a>
						</div>
					</div>
					<div class="overflow_area">
						<table id="encryptPolicyTable" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th width="40"></th>
									<th width="60"><spring:message code="common.no" /></th>
									<th width="120"><spring:message code="encrypt_policy_management.Starting_Position"/></th>
									<th width="100"><spring:message code="encrypt_policy_management.Length"/></th>
									<th width="200"><spring:message code="encrypt_policy_management.Encryption_Algorithm"/></th>
									<th width="100"><spring:message code="encrypt_policy_management.Encryption_Key"/></th>
									<th width="80"><spring:message code="encrypt_policy_management.Initial_Vector"/></th>
									<th width="100"><spring:message code="encrypt_policy_management.Modes"/></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>

			<div id="option">
				<div class="sch_form">
					<table class="write">
						<colgroup>
							<col style="width: 180px;" />
							<col />
							<col style="width: 100px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Grant_Access"/></th>
								<td>
									<div class="inp_rdo">
										<input name="defaultAccessAllowTrueFalse" id="rdo_2_1" type="radio" checked="checked" value="Y">
										<label for="rdo_2_1" style="margin-right: 15%;"><spring:message code="agent_monitoring.yes" /></label> 
										<input name="defaultAccessAllowTrueFalse" id="rdo_2_2" type="radio" value="N"> 
										<label for="rdo_2_2"><spring:message code="agent_monitoring.no" /></label>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Action_when_Access_Denied"/> </th>
								<td>
									<select class="select t3" id="denyResultTypeCode" name="denyResultTypeCode" onchange="fn_changeDenyResult()">
										<c:forEach var="denyResultTypeCode" items="${denyResultTypeCode}">
											<option value="<c:out value="${denyResultTypeCode.sysCode}"/>"><c:out value="${denyResultTypeCode.sysCodeName}"/></option>
										</c:forEach> 
									</select>
								</td>
								<th scope="row" class="ico_t1" id="masking" style="display: none;"><spring:message code="encrypt_policy_management.Replace_String"/></th>
								<td>
									<input type="text" class="txt t2" name="maskingValue" id="maskingValue" style="display: none;"/>
								</td>
							</tr>
							<tr style="display: none;">
								<th scope="row" class="ico_t1"><spring:message code="encrypt_policy_management.Data_Type"/></th>
								<td>
									<select class="select t3" id="dataTypeCode" name="dataTypeCode">
										<c:forEach var="dataTypeCode" items="${dataTypeCode}">
											<option value="<c:out value="${dataTypeCode.sysCode}"/>"><c:out value="${dataTypeCode.sysCodeName}"/></option>
										</c:forEach> 
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div class="inp_chk">
										<span>
											<input type="checkbox" id="log_on_fail" name="log_on_fail" value="Y"/> 
											<label for="log_on_fail"><spring:message code="encrypt_policy_management.Failure_Logging"/></label>
										</span>
										<span>
											<input type="checkbox" id="compress_audit_log" name="compress_audit_log" value="Y"/> 
											<label for="compress_audit_log"><spring:message code="encrypt_policy_management.Log_Compression"/></label>
										</span>
										<span>
											<input type="checkbox" id="preventDoubleYesNo" name="preventDoubleYesNo" value="Y"/>
											<label for="preventDoubleYesNo"><spring:message code="encrypt_policy_management.Prevent_Double_Encryption"/></label>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div class="inp_chk">
										<span> 
											<input type="checkbox" id="log_on_success" name="log_on_success" value="Y"/> 
											<label for="log_on_success"><spring:message code="encrypt_policy_management.Success_Logging"/></label>
										</span>
										<span>
											<input type="checkbox" id="nullEncryptYesNo" name="nullEncryptYesNo" value="Y"/>
											<label for="nullEncryptYesNo"><spring:message code="encrypt_policy_management.NULL_Encryption"/></label>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<div id="accessControl">
				<div class="cmm_bd">
					<div class="sub_tit">
						<p><spring:message code="encrypt_policy_management.Access_Control_Policy"/></p>
						<div class="sub_btn">
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_AccessRegForm();">
							<span id="add_button"><spring:message code="common.add" /></span></a> 
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_AccessRegReForm()">
							<span id="add_button"><spring:message code="common.modify" /></span></a> 
							<a href="#n" class="btn btnF_04" onclick="fn_AccessDel();"> 
							<span id="del_button"><spring:message code="button.delete" /></span></a>
						</div>
					</div>
					<div class="overflow_area">
						<table id="accessControlTable" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
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
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>