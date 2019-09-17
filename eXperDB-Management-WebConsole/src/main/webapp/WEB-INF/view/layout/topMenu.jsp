<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<script>
var version = "${sessionScope.session.version}";

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	var encryptMenu = document.getElementById("encryptMenu");
	var encryptAgentMenu = document.getElementById("encryptAgentMenu");
	
 	if("${sessionScope.session.encp_use_yn}" == "Y"){
		encryptAgentMenu.style.display = '';
	}else{
		encryptAgentMenu.style.display = 'none';
	} 
 	
 	
	var trnasferMenu = document.getElementById("trnasferMenu");
 	if("${sessionScope.session.transfer}" == "Y"){
 		trnasferMenu.style.display = '';
	}else{
		trnasferMenu.style.display = 'none';
	}
 	
 	
	$.ajax({
		url : "/menuAuthorityList.do",
		data : {},
		dataType : "json",
		type : "post",
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
		},
		success : function(result) {
			for(var i = 0; i<result.length; i++){ 
			 	if((result[1].mnu_cd == "MN000101" &&  result[1].read_aut_yn == "N") &&  (result[2].mnu_cd == "MN000102" && result[2].read_aut_yn == "N") && (result[3].mnu_cd == "MN000103" && result[3].read_aut_yn == "N")){
					document.getElementById("MN0001").style.display = 'none';
				}else{
					document.getElementById("MN0001").style.display = '';
					 if(result[i].mnu_cd == "MN000101"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN000101").style.display = 'none';
							}else{
								 document.getElementById("MN000101").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN000102"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN000102").style.display = 'none';
							}else{
								 document.getElementById("MN000102").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN000103"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN000103").style.display = 'none';
							}else{
								 document.getElementById("MN000103").style.display = '';
							}
						}
				} 
				
			 	if((result[5].mnu_cd == "MN000201" &&  result[5].read_aut_yn == "N") &&  (result[6].mnu_cd == "MN000202" && result[6].read_aut_yn == "N")){
					document.getElementById("MN0002").style.display = 'none';
				}else{
					document.getElementById("MN0002").style.display = '';
					if(result[i].mnu_cd == "MN000201"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000201").style.display = 'none';
						}else{
							 document.getElementById("MN000201").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000202"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000202").style.display = 'none';
						}else{
							 document.getElementById("MN000202").style.display = '';
						}
					}
				} 
				
 				if((result[8].mnu_cd == "MN000301" &&  result[8].read_aut_yn == "N") &&  (result[9].mnu_cd == "MN000302" && result[9].read_aut_yn == "N") && (result[10].mnu_cd == "MN000303" && result[10].read_aut_yn == "N")){
 					document.getElementById("MN0003").style.display = 'none';
				}else{
					document.getElementById("MN0003").style.display = '';
					if(result[i].mnu_cd == "MN000301"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000301").style.display = 'none';
						}else{
							 document.getElementById("MN000301").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000302"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000302").style.display = 'none';
						}else{
							 document.getElementById("MN000302").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000303"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000303").style.display = 'none';
						}else{
							 document.getElementById("MN000303").style.display = '';
						}
					}	
				} 
										
		 		if(result[i].mnu_cd == "MN0004"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0004").style.display = 'none';
					}else{
						document.getElementById("MN0004").style.display = '';
					}
				}
		 		
				if((result[13].mnu_cd == "MN000501" &&  result[13].read_aut_yn == "N") &&  (result[14].mnu_cd == "MN000502" && result[14].read_aut_yn == "N") && (result[15].mnu_cd == "MN000503" && result[15].read_aut_yn == "N")){
 					document.getElementById("MN0005").style.display = 'none';
				}else{
					document.getElementById("MN0005").style.display = '';
					if(result[i].mnu_cd == "MN000501"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000501").style.display = 'none';
						}else{
							 document.getElementById("MN000501").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000502"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000502").style.display = 'none';
						}else{
							 document.getElementById("MN000502").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000503"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000503").style.display = 'none';
						}else{
							 document.getElementById("MN000503").style.display = '';
						}
					}	
				} 
		 			 				 		
				if((result[17].mnu_cd == "MN000601" &&  result[17].read_aut_yn == "N")) {
 					document.getElementById("MN0006").style.display = 'none';
				}else{
					document.getElementById("MN0006").style.display = '';
					if(result[i].mnu_cd == "MN000601"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000601").style.display = 'none';
						}else{
							 document.getElementById("MN000601").style.display = '';
						}
					}				
				} 
							
				if((result[19].mnu_cd == "MN000701" &&  result[19].read_aut_yn == "N") && (result[38].mnu_cd == "MN000702" &&  result[38].read_aut_yn == "N")) {
 					document.getElementById("MN0007").style.display = 'none';
				}else{
					document.getElementById("MN0007").style.display = '';
					if(result[i].mnu_cd == "MN000701"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000701").style.display = 'none';
						}else{
							 document.getElementById("MN000701").style.display = '';
						}
					}else if(result[i].mnu_cd == "MN000702"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000702").style.display = 'none';
						}else{
							 document.getElementById("MN000302").style.display = '';
						}
					}				
				} 
				
				 if(result[i].mnu_cd == "MN0008"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0008").style.display = 'none';
					}else{
						 document.getElementById("MN0008").style.display = '';
					}
				} 
				 

				 if((result[24].mnu_cd == "MN0001101" &&  result[24].read_aut_yn == "N") &&  (result[25].mnu_cd == "MN0001102" && result[25].read_aut_yn == "N")){
	 					document.getElementById("MN00011").style.display = 'none';
					}else{
						document.getElementById("MN00011").style.display = '';
						if(result[i].mnu_cd == "MN0001101"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001101").style.display = 'none';
							}else{
								 document.getElementById("MN0001101").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001102"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001102").style.display = 'none';
							}else{
								 document.getElementById("MN0001102").style.display = '';
							}
						}
					}		 
				 
				 if((result[27].mnu_cd == "MN0001201" &&  result[27].read_aut_yn == "N") &&  (result[28].mnu_cd == "MN0001202" && result[28].read_aut_yn == "N") &&  (result[29].mnu_cd == "MN0001203" && result[29].read_aut_yn == "N") &&  (result[30].mnu_cd == "MN0001204" && result[30].read_aut_yn == "N")){
	 					document.getElementById("MN00012").style.display = 'none';
					}else{
						document.getElementById("MN00012").style.display = '';
						if(result[i].mnu_cd == "MN0001201"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001201").style.display = 'none';
							}else{
								 document.getElementById("MN0001201").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001202"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001202").style.display = 'none';
							}else{
								 document.getElementById("MN0001202").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001203"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001203").style.display = 'none';
							}else{
								 document.getElementById("MN0001203").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001204"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001204").style.display = 'none';
							}else{
								 document.getElementById("MN0001204").style.display = '';
							}
						}
					}
				 
				 if((result[32].mnu_cd == "MN0001301" &&  result[32].read_aut_yn == "N") &&  (result[33].mnu_cd == "MN0001302" && result[33].read_aut_yn == "N") &&  (result[34].mnu_cd == "MN0001303" && result[34].read_aut_yn == "N") &&  (result[35].mnu_cd == "MN0001304" && result[35].read_aut_yn == "N")){
	 					document.getElementById("MN00013").style.display = 'none';
					}else{
						document.getElementById("MN00013").style.display = '';
						if(result[i].mnu_cd == "MN0001301"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001301").style.display = 'none';
							}else{
								 document.getElementById("MN0001301").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001302"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001302").style.display = 'none';
							}else{
								 document.getElementById("MN0001302").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001303"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001303").style.display = 'none';
							}else{
								 document.getElementById("MN0001303").style.display = '';
							}
						}else if(result[i].mnu_cd == "MN0001304"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001304").style.display = 'none';
							}else{
								 document.getElementById("MN0001304").style.display = '';
							}
						}
					} 
				 
				 
				 if((result[37].mnu_cd == "MN0001401" &&  result[37].read_aut_yn == "N") ){
	 					document.getElementById("MN00014").style.display = 'none';
					}else{
						document.getElementById("MN00014").style.display = '';
						if(result[i].mnu_cd == "MN0001401"){
							if(result[i].read_aut_yn == "N"){
								 document.getElementById("MN0001401").style.display = 'none';
							}else{
								 document.getElementById("MN0001401").style.display = '';
							}
						}
					} 
				 
			}
		}
	});    
});


function fn_cookie(url) {
	var cssID = sessionStorage.getItem('cssId');

	$("#"+cssID).css("background-color","");
		$("#"+cssID+"c").css("color","");
		$("#"+cssID).css("border","");	
		
		if(url != null){
			$("#"+url).css("background-color","#f58220");
			$("#"+url+"c").css("color","white");
			$("#"+url).css("border","2px solid #f58220");	
		}
	
	sessionStorage.setItem('cssId',url);
}




	function fn_localeSet(locale){
 		$.ajax({
			async : false,
			url : "/setChangeLocale.do",
			data : {
				locale:locale				
			},
			dataType : "json",
			type : "post",
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
			},
			success : function(result) {
				location.reload();
			}
		})
 	}
	
	
	/* function fn_monitoring(){		
		var popUrl = "/monitoringDashboard.do";
		var width = 954;
		var height = 799;
		var popOption = "width="+width+", height="+height+", fullscreen=yes, resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"eXperDB_Monitoring",popOption);
		winPop.focus();

	} */
</script>
<%@include file="../help/aboutExperdbLayer.jsp"%>
<%@include file="../help/openSourceLayer.jsp"%>
<div id="header">
			<h1 class="logo"><a href="/experdb.do" onClick="fn_cookie(null)"><img src="/images/ico_logo_2.png" alt="eXperDB" /></a></h1>
			<div id="gnb_menu">
				<h2 class="blind"><spring:message code="etc.etc10"/></h2>
				<ul class="depth_1" id="gnb">
					<li><a href="#n"><span><img src="/images/ico_h_5.png" alt="FUNCTION" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0001"><spring:message code="menu.schedule_information" /></a>
								<ul class="depth_3">
									<li><a href="/insertScheduleView.do" onClick="fn_cookie('insertScheduleView')" id="MN000101" target="main"><spring:message code="menu.schedule_registration" /></a></li>
									<li><a href="/selectScheduleListView.do" onClick="fn_cookie('selectScheduleListView')" id="MN000102" target="main"><spring:message code="etc.etc27"/></a></li>
									<li><a href="/selectScheduleHistoryView.do" onClick="fn_cookie('selectScheduleHistoryView')" id="MN000103" target="main"><spring:message code="menu.shedule_execution_history" /></a></li>
								</ul>
							</li>
							<li id="trnasferMenu"><a href="#n" id="MN0002"><spring:message code="menu.data_transfer_information" /></a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" onClick="fn_cookie(null)" id="MN000201" target="main"><spring:message code="menu.transfer_server_settings" /></a></li>
									<li><a href="/connectorRegister.do" onClick="fn_cookie(null)" id="MN000202" target="main"><spring:message code="menu.connector_management" /></a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_6.png" alt="ADMIN" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0003"><spring:message code="menu.dbms_information" /></a>
								<ul class="depth_3">
									<li><a href="/dbTree.do" onClick="fn_cookie(null)" id="MN000301" target="main"><spring:message code="menu.dbms_registration" /></a></li>
									<li><a href="/dbServer.do" onClick="fn_cookie(null)" id="MN000302" target="main"><spring:message code="menu.dbms_management" /></a></li>
									<li><a href="/database.do" onClick="fn_cookie(null)" id="MN000303" target="main"><spring:message code="menu.database_management" /></a></li>
								</ul>
							</li>				
						    <li><a href="/userManager.do" onClick="fn_cookie(null)" id="MN0004" target="main"><spring:message code="menu.user_management" /></a></li>
							<li><a href="#n" id="MN0005"><spring:message code="menu.auth_management" /></a>
					        	<ul class="depth_3">
									<li><a href="/menuAuthority.do" onClick="fn_cookie(null)" id="MN000501" target="main"><spring:message code="menu.menu_auth_management" /></a></li>
									<li><a href="/dbServerAuthority.do" onClick="fn_cookie(null)" id="MN000502" target="main"><spring:message code="menu.server_auth_management" /></a></li>
									<li><a href="/dbAuthority.do" onClick="fn_cookie(null)" id="MN000503" target="main"><spring:message code="menu.database_auth_management" /></a></li>									
								</ul>
					        </li>	        					        
					        <li><a href="#n" id="MN0006"><spring:message code="menu.history_management" /></a>
					        	<ul class="depth_3">
									<li><a href="/accessHistory.do" onClick="fn_cookie(null)" id="MN000601" target="main"><spring:message code="menu.screen_access_history" /></a></li>
								</ul>
					        </li>
					        <li><a href="#n" id="MN0007"><spring:message code="menu.agent_monitoring"/></a>
					        	<ul class="depth_3">
									<li><a href="/agentMonitoring.do" onClick="fn_cookie(null)" id="MN000701" target="main"><spring:message code="agent_monitoring.Management_agent"/></a></li>	
									<li id="encryptAgentMenu"><a href="/encryptAgentMonitoring.do" onClick="fn_cookie(null)" id="MN000702" target="main"><spring:message code="agent_monitoring.Encrypt_agent"/></a></li>								
								</ul>
					        </li>
							<li><a href="/extensionList.do" onClick="fn_cookie(null)" id="MN0008" target="main"><spring:message code="menu.extension_pack_installation_information"/></a></li>
						</ul>
					</li>					
					
					<c:choose>
					    <c:when test="${sessionScope.session.encp_use_yn eq 'Y'}">
					    	<li id="encryptMenu" ><a href="#n" onClick="fn_cookie(null)"><span><img src="/images/encrypt.png" alt="ENCRYPT" /></span></a>				       	
					    </c:when>
					    <c:otherwise>
					        <li id="encryptMenu" style="display:none;"><a href="#n" onClick="fn_cookie(null)"><span><img src="/images/encrypt.png" alt="ENCRYPT" /></span></a>
					    </c:otherwise>
					</c:choose>

						<ul class="depth_2">
						    <li><a href="#n" id="MN00011" onClick="fn_cookie(null)"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></a>
        						<ul class="depth_3">
									<li><a href="/securityPolicy.do" target="main" id="MN0001101" onClick="fn_cookie('securityPolicy')"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></a></li>
									<li><a href="/keyManage.do" target="main" id="MN0001102" onClick="fn_cookie('keyManage')"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></a></li>
								</ul>
        					</li>
						    <li><a href="#n" id="MN00012" onClick="fn_cookie(null)"><spring:message code="encrypt_log.Audit_Log"/></a>
        						<ul class="depth_3">
									<li><a href="/encodeDecodeAuditLog.do" target="main" id="MN0001201" onClick="fn_cookie('encodeDecodeAuditLog')"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></a></li>
									<li><a href="/managementServerAuditLog.do" target="main" id="MN0001202" onClick="fn_cookie('managementServerAuditLog')"><spring:message code="encrypt_log_sever.Management_Server"/></a></li>
									<li><a href="/encodeDecodeKeyAuditLog.do" target="main" id="MN0001203" onClick="fn_cookie('encodeDecodeKeyAuditLog')"><spring:message code="encrypt_policy_management.Encryption_Key"/></a></li>
<!-- 								<li><a href="/backupRestoreAuditLog.do" target="main">백업및복원</a></li> -->
									<li><a href="/resourcesUseAuditLog.do" target="main" id="MN0001204"  onClick="fn_cookie('resourcesUseAuditLog')">자원사용</a></li>
								</ul>
        					</li>
							<li><a href="#n" id="MN00013" onClick="fn_cookie(null)"><spring:message code="encrypt_policyOption.Settings" /></a>
        						<ul class="depth_3">
									<li><a href="/securityPolicyOptionSet.do" target="main" id="MN0001301" onClick="fn_cookie('securityPolicyOptionSet')"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></a></li>
									<li><a href="/securitySet.do" target="main" id="MN0001302" onClick="fn_cookie('securitySet')"><spring:message code="encrypt_encryptSet.Encryption_Settings"/></a></li>
									<li><a href="/securityKeySet.do" target="main" id="MN0001303" onClick="fn_cookie('securityKeySet')"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></a></li>
									<li><a href="/securityAgentMonitoring.do" target="main"  id="MN0001304" onClick="fn_cookie('securityAgentMonitoring')"><spring:message code="encrypt_agent.Encryption_agent_setting"/></a></li>
								</ul>
        					</li>
        					<li><a href="#n" id="MN00014" onClick="fn_cookie(null)"><spring:message code="encrypt_Statistics.Statistics"/></a>
        						<ul class="depth_3">
        							<li><a href="/securityStatistics.do" target="main" id="MN0001401" onClick="fn_cookie('securityStatistics')"><spring:message code="encrypt_Statistics.Encrypt_Statistics"/></a></li>
        						</ul>
        					</li>
						</ul>
					</li>
					
					<li><a href="#n"><span><img src="/images/ico_h_10.png" alt="DB2PG" /></span></a>
						<ul class="depth_2">
						    <li><a href="" onClick="fn_cookie(null)" target="main">SOURCE DBMS</a></li>
							<li><a href="" onClick="fn_cookie(null)" target="main">TARGET DBMS</a></li>
        					<li><a href="/db2pgSetting.do" onClick="fn_cookie(null)" target="main">DB2PG</a></li>
						</ul>
					</li>
					
					<li><a href="#n"><span><img src="/images/ico_h_7.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
						    <li><a href="#n">Language</a>
        						<ul class="depth_3">
									<li><a href="#n" onClick="fn_localeSet('ko')">Korean</a></li>
									<li><a href="#n" onClick="fn_localeSet('en')">English</a></li>
								</ul>
        					</li>
							<li><a href="/myPage.do" onClick="fn_cookie(null)" target="main"><spring:message code="menu.user_information_management"/></a></li>
        					<li><a href="/myScheduleListView.do" onClick="fn_cookie(null)" target="main"><spring:message code="menu.my_schedule_management"/></a></li>
						</ul>
					</li>
					<!-- <li><a href="#n" onClick="fn_monitoring();"><span><img src="/images/ico_h_9.png" alt="Monitoring" /></span></a>
					</li> -->
					<li><a href="#n"><span><img src="/images/ico_h_8.png" alt="HELP" /></span></a>
						<ul class="depth_2">
							<!-- <li><a href="#n" onClick="fn_cookie(null)" target="main">Online Help</a></li> -->
							<li><a href="#n" onClick="fn_aboutExperdb('${sessionScope.session.version}')" >About eXperDB</a></li>
							<li><a href="#n" onClick="fn_openSource()" >Open Source License</a></li>
						</ul>
					</li>
				</ul>
			</div>
</div>

