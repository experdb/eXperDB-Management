<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : agentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018. 01. 04
	*
	*/
%>
<script>
var table = null;

function fn_init() {
	table = $('#agentMonitoring').DataTable({
		scrollY : "420px",
		searching : false,
		deferRender : true,
		scrollX: true,
		columns : [
			{ data : "no", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "no", className : "dt-center", defaultContent : ""}, 
			{ data : "entityName", className : "dt-center", defaultContent : ""}, 
			{ data : "entityStatusName", className : "dt-center", defaultContent : ""}, 
			{ data : "latestAddress", className : "dt-center", defaultContent : ""}, 
			{ data : "latestDateTime", className : "dt-center", defaultContent : ""}, 
			{ data : "receivedPolicyVersion", className : "dt-center", defaultContent : ""}, 
			{ data : "sentPolicyVersion", className : "dt-center", defaultContent : ""}, 
			{ data : "createDateTime", className : "dt-center", defaultContent : ""},
			{ data : "updateDateTime", className : "dt-center", defaultContent : ""},
			{ data : "updateName", className : "dt-center", defaultContent : ""},

			{ data : "extendedField", className : "dt-center", defaultContent : "", visible: false},
			{ data : "entityUid", className : "dt-center", defaultContent : "", visible: false},
			{ data : "resultCode", className : "dt-center", defaultContent : "", visible: false},
			{ data : "resultMessage", className : "dt-center", defaultContent : "", visible: false},
			{ data : "entityTypeCode", className : "dt-center", defaultContent : "", visible: false},
			{ data : "entityStatusCode", className : "dt-center", defaultContent : "", visible: false},
			{ data : "appVersion", className : "dt-center", defaultContent : "", visible: false}
		 ],'select': {'style': 'multi'}
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '180px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(9)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	
	table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(17)').css('min-width', '0px');
    $(window).trigger('resize');
    
    $('#agentMonitoring tbody').on('dblclick', 'tr', function() {
    	var data = table.row(this).data();
    	
    	var entityName =  data.entityName;
    	var entityStatusCode=  data.entityStatusCode;
    	var latestAddress =  data.latestAddress;
    	var latestDateTime = data.latestDateTime;
    	var extendedField = data.extendedField;
    	var entityUid = data.entityUid;

    	 var frmPop= document.frmPopup;
    	 var url = '/popup/agentMonitoringModifyForm.do';
    	 var width = 954;
    	 var height = 670;
    	 var left = (window.screen.width / 2) - (width / 2);
    	 var top = (window.screen.height /2) - (height / 2);
    	 var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
    	 window.open('','popupView',popOption);  
    	  
    	 frmPop.action = url;
    	 frmPop.target = 'popupView';
    	 
    	 frmPop.entityName.value = entityName;
    	 frmPop.entityUid.value = entityUid;
    	 frmPop.entityStatusCode.value = entityStatusCode;  
    	 frmPop.latestAddress.value = latestAddress;
    	 frmPop.latestDateTime.value = latestDateTime; 
    	 frmPop.extendedField.value = extendedField;
    	 
    	 frmPop.submit();   
    });
	
	    
}


$(window.document).ready(function() {
	fn_init();
	fn_select();
});


function fn_select(){
	$.ajax({
		url : "/selectAgentMonitoring.do", 
	  	data : {
	  		entityName: $('#entityName').val(),
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
				table.rows.add(data.list).draw();
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


/*수정버튼 클릭시*/
function fn_agentMonitoringModifyForm(){
	//var datasArr = new Array();	
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert("<spring:message code='message.msg35' />");
		return false;
	}else if(datas.length > 1){
		alert("<spring:message code='message.msg04' />");
		return false;
	}else{
	
		var data =  table.row('.selected').data();
		
		var entityName =  data.entityName;
		var entityStatusCode=  data.entityStatusCode;
		var latestAddress =  data.latestAddress;
		var latestDateTime = data.latestDateTime;
		var extendedField = data.extendedField;
		var entityUid = data.entityUid;
	
		//var rows = JSON.parse(extendedField);
	
		//datasArr.push(rows);
	
		 var frmPop= document.frmPopup;
		    var url = '/popup/agentMonitoringModifyForm.do';
		    var width = 954;
			var height = 670;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		    window.open('','popupView',popOption);  
		     
		    frmPop.action = url;
		    frmPop.target = 'popupView';
		    
		    frmPop.entityName.value = entityName;
		    frmPop.entityUid.value = entityUid;
		    frmPop.entityStatusCode.value = entityStatusCode;  
		    frmPop.latestAddress.value = latestAddress;
		    frmPop.latestDateTime.value = latestDateTime; 
		    frmPop.extendedField.value = extendedField;
		    
		    frmPop.submit();   
	}
}
</script>

<form name="frmPopup" id="frmPopup">
	<input type="hidden" name="entityName"  id="entityName">
	<input type="hidden" name="entityUid"  id="entityUid">
	<input type="hidden" name="entityStatusCode"  id="entityStatusCode">
	<input type="hidden" name="latestAddress"  id="latestAddress">
	<input type="hidden" name="latestDateTime"  id="latestDateTime">
	<input type="hidden" name="extendedField"  id="extendedField">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_agent.Encryption_agent_setting"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Encryption_agent_setting_01"/></li>
					<li><spring:message code="encrypt_help.Encryption_agent_setting_02"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policyOption.Settings"/></li>
					<li class="on"><spring:message code="encrypt_agent.Encryption_agent_setting"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<!-- <span class="btn"><button onClick="fn_select();">조회</button></span>  -->
					<span class="btn"><button onClick="fn_agentMonitoringModifyForm();"><spring:message code="common.modify" /></button></span>
				</div>
				<%-- <div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 120px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t2">에이전트명</th>
								<td><input type="text" id="entityName" name="entityName" class="txt t2" /></td>
							</tr>
						</tbody>
					</table>
				</div> --%>
				<div class="overflow_area">
					<table id="agentMonitoring" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"></th>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="200"><spring:message code="encrypt_agent.Agent_Name"/></th>
								<th width="100"><spring:message code="properties.status" /></th>
								<th width="150"><spring:message code="encrypt_agent.Recently_accessed_address"/></th>
								<th width="150"><spring:message code="encrypt_agent.Recently_Accessed_Time"/></th>
								<th width="130"><spring:message code="encrypt_agent.Agent_Policy_Version"/></th>
								<th width="180"><spring:message code="encrypt_agent.Recently_Transfer_Policy_Version"/></th>
								<th width="150"><spring:message code="encrypt_agent.Installation_Date"/></th>
								<th width="150"><spring:message code="encrypt_agent.Change_Date"/></th>
								<th width="100"><spring:message code="encrypt_agent.Modifier"/></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>		
								<th width="0"></th>		
								<th width="0"></th>						
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

