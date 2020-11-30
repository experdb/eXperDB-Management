<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

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


/* ********************************************************
 * 암호화 에이전트 설정 초기 실행
 ******************************************************** */
 $(window.document).ready(function() {
		fn_buttonAut();
		fn_init();
		fn_select();
	});
 
 
 
	/* ********************************************************
	 * 버튼 권한 설정
	 ******************************************************** */
	 function fn_buttonAut(){
		 	var btnUpdate = document.getElementById("btnModify"); 
		 	if("${wrt_aut_yn}" == "Y"){
		 		btnModify.style.display = '';
		 	}else{
		 		btnModify.style.display = 'none';
		 	} 
		 }	
	 
	 
 
	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_init() {
		table = $('#agentMonitoring').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "no", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "no", className : "dt-center", defaultContent : ""}, 
				{ data : "entityName", defaultContent : ""}, 
				
				/* { data : "entityStatusName", defaultContent : ""},  */
				
				{ data : "entityStatusName",  
	    			"render": function (data, type, full) {				
	    				var html = "";
	    				
	    				//메타데이타 설정
	    				if (nvlPrmSet(full.entityStatusName, "") == "ACTIVE" || nvlPrmSet(full.entityStatusName, "") == "") {
	    					html += "<div class='badge badge-pill badge-info' style='background-color: #71c016;color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
	    					html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
	    					html += "ACTIVE";
	    					html += "</div>";
	    				} else {
	    					html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
	    					html += "	<i class='fa fa-times-circle mr-2'></i>";
	    					html += "INACTIVE";
	    					html += "</div>";
	    				}
	
	    				return html;
	    			},
					className : "dt-center", defaultContent : "",orderable : false},
				
				
				{ data : "latestAddress", defaultContent : ""}, 
				{ data : "latestDateTime", defaultContent : ""}, 
				{ data : "receivedPolicyVersion", className : "dt-right", defaultContent : ""}, 
				{ data : "sentPolicyVersion", className : "dt-right", defaultContent : ""}, 
				{ data : "createDateTime", defaultContent : ""},
				{ data : "updateDateTime", defaultContent : ""},
				{ data : "updateName", defaultContent : ""},
				{ data : "extendedField", defaultContent : "", visible: false},
				{ data : "entityUid", defaultContent : "", visible: false},
				{ data : "resultCode", defaultContent : "", visible: false},
				{ data : "resultMessage", defaultContent : "", visible: false},
				{ data : "entityTypeCode", defaultContent : "", visible: false},
				{ data : "entityStatusCode", defaultContent : "", visible: false},
				{ data : "appVersion", defaultContent : "", visible: false}
			 ],'select': {'style': 'multi'}
		});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '90px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '180px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(9)').css('min-width', '150px');
	table.tables().header().to$().find('th:eq(10)').css('min-width', '130px');	
	table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
	table.tables().header().to$().find('th:eq(17)').css('min-width', '0px');
    $(window).trigger('resize');
    
    
    
 /* ********************************************************
  * 더블 클릭 시, 수정페이지 호출
  ******************************************************** */    
    $('#agentMonitoring tbody').on('dblclick', 'tr', function() {
    	var data = table.row(this).data();
    	
    	var entityName =  data.entityName;
		var entityStatusCode=  data.entityStatusCode;
		var latestAddress =  data.latestAddress;
		var latestDateTime = data.latestDateTime;
		var extendedField = data.extendedField;
		var entityUid = data.entityUid;
		
 		$.ajax({
			url : "/popup/agentMonitoringModifyForm.do",
			data : {	
				entityName : entityName,
				entityStatusCode : entityStatusCode,
				latestAddress : latestAddress,
				latestDateTime : latestDateTime,
				extendedField : extendedField,
				entityUid : entityUid
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
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
			success : function(result) {
				fn_update_setting(result);
				$('#pop_layer_agentMonitoringModifyForm').modal("show");
			}
		});
    });   
}




	/* ********************************************************
	 * 조회 버튼 클릭 시
	 ******************************************************** */
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
 				if(data.resultCode == "0000000000"){
					table.clear().draw();
					table.rows.add(data.list).draw();
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}



	/* ********************************************************
	 * 수정 버튼 클릭 시
	 ******************************************************** */
	function fn_newUpdate(){
		//var datasArr = new Array();	
		
		var datas = table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04"/>', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
		
			var data =  table.row('.selected').data();
			
			var entityName =  data.entityName;
			var entityStatusCode=  data.entityStatusCode;
			var latestAddress =  data.latestAddress;
			var latestDateTime = data.latestDateTime;
			var extendedField = data.extendedField;
			var entityUid = data.entityUid;
			
		
	 		$.ajax({
				url : "/popup/agentMonitoringModifyForm.do",
				data : {	
					entityName : entityName,
					entityStatusCode : entityStatusCode,
					latestAddress : latestAddress,
					latestDateTime : latestDateTime,
					extendedField : extendedField,
					entityUid : entityUid
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
							showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						} else {
							showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
						}
					},
				success : function(result) {
					fn_update_setting(result);
					$('#pop_layer_agentMonitoringModifyForm').modal("show");
				}
			});
		}
	}		
		
 		
	/* ********************************************************
	 * 수정 팝업셋팅
	 ******************************************************** */
	function fn_update_setting(result) {
		
		$("#mod_entityUid", "#baseForm").val(nvlPrmSet(result.entityUid, ""));
		$("#mod_entityName", "#baseForm").val(nvlPrmSet(result.entityName, ""));
		$("#mod_entityStatusCode", "#baseForm").val(nvlPrmSet(result.entityStatusCode, ""));
		if (nvlPrmSet(result.entityStatusCode, "") == "ES50") {
			$("input:checkbox[id='mod_entityStatusCode_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_entityStatusCode_chk']").prop("checked", false); 
		}
		
		$("#mod_latestAddress", "#subForm").val(nvlPrmSet(result.latestAddress, ""));
		$("#mod_latestDateTime", "#subForm").val(nvlPrmSet(result.latestDateTime, ""));
	
		var json = JSON.parse(result.extendedField);
	 	var html = ""; 
		
		for(key in json) {		
			html += ' <tr>';
			html += ' <td>';
			html +=	key;
			html += ' </td>';
			html += ' <td>';
			html +=	json[key];
			html += ' </td>';
			html += ' </tr>';
		}
		$( "#mod_extendedField" ).append(html);
	}
		
</script>

<%@include file="../popup/agentMonitoringModifyForm.jsp"%>

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
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_agent.Encryption_agent_setting"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_policyOption.Settings"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_agent.Encryption_agent_setting"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_agent_setting_01"/></p>
											<p class="mb-0"><spring:message code="encrypt_help.Encryption_agent_setting_02"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onClick="fn_newUpdate();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
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
									
									<table id="agentMonitoring" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="20"></th>
												<th width="40"><spring:message code="common.no" /></th>
												<th width="150"><spring:message code="encrypt_agent.Agent_Name"/></th>
												<th width="90"><spring:message code="access_control_management.activation" /></th>
												<th width="150"><spring:message code="encrypt_agent.Recently_accessed_address"/></th>
												<th width="150"><spring:message code="encrypt_agent.Recently_Accessed_Time"/></th>
												<th width="130"><spring:message code="encrypt_agent.Agent_Policy_Version"/></th>
												<th width="180"><spring:message code="encrypt_agent.Recently_Transfer_Policy_Version"/></th>
												<th width="150"><spring:message code="encrypt_agent.Installation_Date"/></th>
												<th width="150"><spring:message code="encrypt_agent.Change_Date"/></th>
												<th width="130"><spring:message code="encrypt_agent.Modifier"/></th>
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
			</div>
		</div>
	</div>
</div>