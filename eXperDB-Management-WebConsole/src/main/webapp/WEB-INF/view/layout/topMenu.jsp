<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	var version = "${sessionScope.session.version}";

	$(window.document).ready(function() {
		//상단 메뉴 setting
		fnc_topMenu_setting();
		
		//상단 메뉴사이즈 조정
		fnc_topMenusize();
	});
	
	//상단 메뉴 setting
	function fnc_topMenu_setting() {
		var encryptMenu = $( '#encryptMenu' ); 
		var encryptAgentMenu = $( '#encryptAgentMenu' ); 
		var trnasferMenu = $( '#trnasferMenu' ); 

		if("${sessionScope.session.encp_use_yn}" == "Y"){
			encryptMenu.show();
			encryptAgentMenu.show();
		}else{
			encryptMenu.hide();
			encryptAgentMenu.hide();
		}

		if("${sessionScope.session.transfer}" == "Y"){
			trnasferMenu.show();
		}else{
			trnasferMenu.hide();
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
					//scheduleMenu
					if (result[i].mnu_cd == "MN000101" || result[i].mnu_cd == "MN000102" || result[i].mnu_cd == "MN000103") {
						if((result[i].mnu_cd == "MN000101" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN000102" && result[i].read_aut_yn == "N") && (result[i].mnu_cd == "MN000103" && result[i].read_aut_yn == "N")){
							$( '#scheduleMenu' ).hide();
						} else {
							$( '#scheduleMenu' ).show();
							
							if(result[i].read_aut_yn == "N"){
								$('#' + result[i].mnu_cd ).hide();
							}else{
								$('#' + result[i].mnu_cd ).show();
							}
						}
					}

					//trnasferMenu
					if("${sessionScope.session.transfer}" == "Y"){
						if (result[i].mnu_cd == "MN000201" || result[i].mnu_cd == "MN000202") {
							if((result[i].mnu_cd == "MN000201" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN000202" && result[i].read_aut_yn == "N")){
								$('#trnasferMenu').hide();
							}else{
								$('#trnasferMenu').show();
	
								if(result[i].read_aut_yn == "N"){
									$('#' + result[i].mnu_cd).hide();
								}else{
									$('#' + result[i].mnu_cd).show();
								}
							}
						}
					}

					//adminMenu
					if (result[i].mnu_cd == "MN000301" || result[i].mnu_cd == "MN000302" || result[i].mnu_cd == "MN000302") {
						
						if((result[i].mnu_cd == "MN000301" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN000302" && result[i].read_aut_yn == "N") && (result[i].mnu_cd == "MN000303" && result[i].read_aut_yn == "N")) {
							$('#MN0003_DIV').hide();
						} else {
							$('#MN0003_DIV').show();

							if(result[i].read_aut_yn == "N"){
								$('#' + result[i].mnu_cd).hide();
							}else{
								$('#' + result[i].mnu_cd).show();
							}
						}
					}
					
					if (result[i].mnu_cd == "MN0004") {
						if(result[i].read_aut_yn == "N"){
							$('#MN0004_DIV').hide();
							$('#' + result[i].mnu_cd).hide();
						}else{
							$('#MN0004_DIV').show();
							$('#' + result[i].mnu_cd).show();
						}
					}

					if (result[i].mnu_cd == "MN000501" || result[i].mnu_cd == "MN000502" || result[i].mnu_cd == "MN000503") {
						if((result[i].mnu_cd == "MN000501" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN000502" && result[i].read_aut_yn == "N") && (result[i].mnu_cd == "MN000503" && result[i].read_aut_yn == "N")){
							$('#MN0005_DIV').hide();
						}else{
							$('#MN0005_DIV').show();
	
							if(result[i].read_aut_yn == "N"){
								$('#' + result[i].mnu_cd).hide();
							}else{
								$('#' + result[i].mnu_cd).show();
							}
						}
					}

					//adminMenu
 					if (result[i].mnu_cd == "MN000601") {
						if(result[i].read_aut_yn == "N") {
							$('#MN0006_DIV').hide();
							$('#' + result[i].mnu_cd).hide();
						} else {
							$('#MN0006_DIV').show();
							$('#' + result[i].mnu_cd).show();
						}
					}

					if (result[i].mnu_cd == "MN000701" || result[i].mnu_cd == "MN000702") {
						if((result[i].mnu_cd == "MN000701" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN000702" && result[i].read_aut_yn == "N")){
							$('#MN0007').hide();
						}else{
							$('#MN0007').show();
							
							if (result[i].mnu_cd == "MN000702") {
								if("${sessionScope.session.encp_use_yn}" == "Y"){
									if(result[i].read_aut_yn == "N"){
										$('#' + result[i].mnu_cd).hide();
									}else{
										$('#' + result[i].mnu_cd).show();
									}
								}
							} else {
								if(result[i].read_aut_yn == "N"){
									$('#' + result[i].mnu_cd).hide();
								}else{
									$('#' + result[i].mnu_cd).show();
								}
							}

						}
					}

					//adminMenu
 					if (result[i].mnu_cd == "MN0008") {
						if(result[i].read_aut_yn == "N") {
							$('#MN0008_DIV').hide();
							$('#' + result[i].mnu_cd).hide();
						} else {
							$('#MN0008_DIV').show();
							$('#' + result[i].mnu_cd).show();
						}
					}

					if("${sessionScope.session.encp_use_yn}" == "Y"){
	 					if(result[i].mnu_cd == "MN0001101" || result[i].mnu_cd == "MN0001102" || result[i].mnu_cd == "MN0001201" || result[i].mnu_cd == "MN0001202" || result[i].mnu_cd == "MN0001203" || result[i].mnu_cd == "MN0001204"
							|| result[i].mnu_cd == "MN0001301" || result[i].mnu_cd == "MN0001302" || result[i].mnu_cd == "MN0001303" || result[i].mnu_cd == "MN0001304" || result[i].mnu_cd == "MN0001401") {
	
							if((result[i].mnu_cd == "MN0001101" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001102" && result[i].read_aut_yn == "N") &&
								(result[i].mnu_cd == "MN0001201" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001202" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001203" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001204" && result[i].read_aut_yn == "N") &&
								(result[i].mnu_cd == "MN0001301" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001302" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001303" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001304" && result[i].read_aut_yn == "N") &&
								(result[i].mnu_cd == "MN0001401" &&  result[i].read_aut_yn == "N")){
								$('#encryptMenu').hide();
							} else {
								$('#encryptMenu').show();
								if(result[i].mnu_cd == "MN0001101" || result[i].mnu_cd == "MN0001102") {
									if((result[i].mnu_cd == "MN0001101" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001102" && result[i].read_aut_yn == "N")){
										$('#MN00011').hide();
									}else{
										$('#MN00011').show();
	
										if(result[i].read_aut_yn == "N"){
											$('#' + result[i].mnu_cd).hide();
										}else{
											$('#' + result[i].mnu_cd).show();
										}
									}
								}
	
								if(result[i].mnu_cd == "MN0001201" || result[i].mnu_cd == "MN0001202" || result[i].mnu_cd == "MN0001203" || result[i].mnu_cd == "MN0001204") {
									if((result[i].mnu_cd == "MN0001201" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001202" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001203" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001204" && result[i].read_aut_yn == "N")){
										$('#MN00012').hide();
									}else{
										$('#MN00012').show();
	
										if(result[i].read_aut_yn == "N"){
											$('#' + result[i].mnu_cd).hide();
										}else{
											$('#' + result[i].mnu_cd).show();
										}
									}
								}
								
								if(result[i].mnu_cd == "MN0001301" || result[i].mnu_cd == "MN0001302" || result[i].mnu_cd == "MN0001303" || result[i].mnu_cd == "MN0001304") {
									if((result[i].mnu_cd == "MN0001301" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001302" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001303" && result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN0001304" && result[i].read_aut_yn == "N")){
										$('#MN00013').hide();
									}else{
										$('#MN00013').show();
	
										if(result[i].read_aut_yn == "N"){
											$('#' + result[i].mnu_cd).hide();
										}else{
											$('#' + result[i].mnu_cd).show();
										}
									}
								}
	
								//암호화 통계 menu
								if (result[i].mnu_cd == "MN0001401") {
									if( result[i].read_aut_yn == "N" ){
										$('#MN00014').hide();
									}
								}
							}
						}
					}

					//migrationMenu
					if (result[i].mnu_cd == "MN00015" || result[i].mnu_cd == "MN00016"  || result[i].mnu_cd == "MN00017") {
						if((result[i].mnu_cd == "MN00015" &&  result[i].read_aut_yn == "N") &&  (result[i].mnu_cd == "MN00016" && result[i].read_aut_yn == "N") && (result[i].mnu_cd == "MN00017" && result[i].read_aut_yn == "N")){
							$('#migrationMenu').hide();
						}else{
							$('#migrationMenu').show();
	
							if(result[i].read_aut_yn == "N"){
								$('#' + result[i].mnu_cd).hide();
							}else{
								$('#' + result[i].mnu_cd).show();
							}
						}
					}
					
					
					
				}
			}
		});
		
	}

	//상단 메뉴사이즈 조정
	function fnc_topMenusize() {
		var widthMax = '1090';
		var widthLength = $( '.width-div-a' ).length;

		if (widthLength > 0) {
			$( '#li_blnck' ).css('width', widthMax - $( '.page-navigation' ).width());
		}
	}
	
	function fn_cookie(url) {
		var cssID = sessionStorage.getItem('cssId');

/* 		$("#"+cssID).css("background-color","");
		$("#"+cssID+"c").css("color","");
		$("#"+cssID).css("border","");	

		if(url != null){
			$("#"+url).css("background-color","#f58220");
			$("#"+url+"c").css("color","white");
			$("#"+url).css("border","2px solid #f58220");	
		} */

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
	
	//profile chk
	function fn_profileChk() {
		if ($("#profileArrowUser").hasClass("menu-arrow_user")) {
			$("#profileArrowUser").attr('class', 'menu-arrow_user_af');
		} else {
			$("#profileArrowUser").attr('class', 'menu-arrow_user');
		}
	}
</script>

<%@include file="../help/aboutExperdbLayer.jsp"%>
<%@include file="../help/openSourceLayer.jsp"%>

<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
	<div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
		<a class="navbar-brand brand-logo mr-5" href="/experdb.do" onClick="fn_cookie(null);"><img src="/images/main_logo.png" class="mr-2" alt="eXperDB" /></a>
		<a class="navbar-brand brand-logo-mini" href="/experdb.do" onClick="fn_cookie(null);"><img src="/images/logo_new.png" alt="eXperDB" /></a>
	</div>

	<div class="navbar-menu-wrapper d-flex align-items-center justify-content-end">
		<button class="navbar-toggler navbar-toggler align-self-center" type="button" data-toggle="minimize">
			<span class="ti-layout-grid2"></span>
		</button>

		<ul class="navbar-nav mr-lg-2">
			<li class="nav-item nav-search d-none d-lg-block">
				<div class="input-group">
					<div class="horizontal-menu">
						<nav class="bottom-navbar">
							<div class="container">
								<ul class="nav page-navigation">

									<!-- SCHEDULE -->
									<li class="nav-item width-div-a" id="scheduleMenu">
 										<a href="#" class="nav-link">
											<i class="ti-calendar menu-icon"></i>
											<span class="menu-title">SCHEDULE</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu" id="MN0001">
											<ul class="submenu-item">
												<li class="nav-item">
													<span class="nav-heading-title">
														<b><spring:message code="menu.schedule_information" /></b>
													</span>
												</li>
												<li class="nav-item" id="MN000101">
													<a class="nav-link" href="/insertScheduleView.do" onClick="fn_cookie('insertScheduleView')" target="main">
														<spring:message code="menu.schedule_registration" />
													</a>
												</li>
												<li class="nav-item" id="MN000102">
													<a class="nav-link" href="/selectScheduleListView.do" onClick="fn_cookie('selectScheduleListView')" target="main">
														<spring:message code="etc.etc27"/>
													</a>
												</li>
												<li class="nav-item" id="MN000103" >
													<a class="nav-link" href="/selectScheduleHistoryView.do" onClick="fn_cookie('selectScheduleHistoryView')" target="main">
														<spring:message code="menu.shedule_execution_history" />
													</a>
												</li>
											</ul>
										</div>
									</li>
									
									<!-- DATA TRANSFER -->
<%-- 									<li class="nav-item width-div-a" id="trnasferMenu" >
										<a href="#" class="nav-link">
											<i class="ti-layers-alt menu-icon"></i>
											<span class="menu-title">DATA TRANSFER</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu" id="MN0002">											
											<ul class="submenu-item">
												<li class="nav-item">
													<span class="nav-heading-title">
														<b><spring:message code="menu.data_transfer_information" /></b>
													</span>
												</li>
												<li class="nav-item" id="MN000201">
													<a class="nav-link" href="/transferSetting.do" onClick="fn_cookie(null)" target="main">
														<spring:message code="menu.transfer_server_settings" />
													</a>
												</li>
												<li class="nav-item" id="MN000202">
													<a class="nav-link" href="/connectorRegister.do" onClick="fn_cookie(null)" target="main">
														<spring:message code="menu.connector_management" />
													</a>
												</li>
											</ul>
										</div>
									</li>
									 --%>
									
									<!-- ADMIN -->
									<li class="nav-item mega-menu width-div-a" id="adminMenu">
										<a href="#" class="nav-link">
											<i class="ti-desktop menu-icon"></i>
											<span class="menu-title">ADMIN</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu">
											<div class="col-group-wrapper row">
												<div class="col-group col-md-3" id="MN0003_DIV">
													<p class="category-heading" id="MN0003">
														<b><spring:message code="menu.dbms_information" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN000301" >
															<a class="nav-link" href="/dbTree.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.dbms_registration" />
															</a>
														</li>
														<li class="nav-item" id="MN000302">
															<a class="nav-link" href="/dbServer.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.dbms_management" />
															</a>
														</li>
														<li class="nav-item" id="MN000303">
															<a class="nav-link" href="/database.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.database_management" />
															</a>
														</li>
													</ul>
												</div>
												
												<div class="col-group col-md-3" id="MN0004_DIV">
													<p class="category-heading">
														<b><spring:message code="menu.user_management" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0004">
															<a class="nav-link" href="/userManager.do"  onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.user_management" />
															</a>
														</li>
													</ul>
												</div>	
												
												<div class="col-group col-md-3" id="MN0005_DIV">
													<p class="category-heading" id="MN0005">
														<b><spring:message code="menu.auth_management" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN000501">
															<a class="nav-link" href="/menuAuthority.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.menu_auth_management" />
															</a>
														</li>
														<li class="nav-item" id="MN000502">
															<a class="nav-link" href="/dbServerAuthority.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.server_auth_management" />
															</a>
														</li>
														<li class="nav-item" id="MN000503" >
															<a class="nav-link" href="/dbAuthority.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.database_auth_management" />
															</a>
														</li>
													</ul>
												</div>
												
												<div class="col-group col-md-3" id="MN0006_DIV">
													<p class="category-heading" id="MN0006">
														<b><spring:message code="menu.history_management" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN000601">
															<a class="nav-link" href="/accessHistory.do"  onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.screen_access_history" />
															</a>
														</li>
													</ul>
												</div>
	
												<div class="col-group col-md-3" id="MN0007">
													<p class="category-heading">
														<b><spring:message code="menu.agent_monitoring" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN000701">
															<a class="nav-link" href="/agentMonitoring.do" onClick="fn_cookie(null)" target="main">
																<spring:message code="agent_monitoring.Management_agent" />
															</a>
														</li>
														<li class="nav-item" id="encryptAgentMenu" id="MN000702">
															<a class="nav-link" href="/encryptAgentMonitoring.do" id="MN000702" onClick="fn_cookie(null)" target="main">
																<spring:message code="agent_monitoring.Encrypt_agent" />
															</a>
														</li>
													</ul>
												</div>
												
												<div class="col-group col-md-3" id="MN0008_DIV">
													<p class="category-heading">
														<b><spring:message code="menu.extension_pack_installation_information" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0008">
															<a class="nav-link" href="/extensionList.do"  onClick="fn_cookie(null)" target="main">
																<spring:message code="menu.extension_pack_installation_information" />
															</a>
														</li>
													</ul>
												</div>
											</div>
										</div>
									</li>

									
									<!-- ENCRYPT -->
									<li class="nav-item mega-menu width-div-a" id="encryptMenu">	
										<a href="#" class="nav-link">
											<i class="ti-lock menu-icon"></i>
											<span class="menu-title">ENCRYPT</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu">
											<div class="col-group-wrapper row">
												<div class="col-group col-md-3" id="MN00011">
													<p class="category-heading">
														<b><spring:message code="encrypt_policy_management.Policy_Key_Management" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0001101">
															<a class="nav-link" href="/securityPolicy.do" onClick="fn_cookie('securityPolicy')" target="main">
																<spring:message code="encrypt_policy_management.Security_Policy_Management" />
															</a>
														</li>
														<li class="nav-item" id="MN0001102">
															<a class="nav-link" href="/keyManage.do" onClick="fn_cookie('keyManage')" target="main">
																<spring:message code="encrypt_key_management.Encryption_Key_Management" />
															</a>
														</li>
													</ul>
												</div>
												<div class="col-group col-md-3" id="MN00012">
													<p class="category-heading">
														<b><spring:message code="encrypt_log.Audit_Log" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0001201">
															<a class="nav-link" href="/encodeDecodeAuditLog.do"onClick="fn_cookie('encodeDecodeAuditLog')" target="main">
																<spring:message code="encrypt_log_decode.Encryption_Decryption" />
															</a>
														</li>
														<li class="nav-item" id="MN0001202">
															<a class="nav-link" href="/managementServerAuditLog.do" onClick="fn_cookie('managementServerAuditLog')" target="main">
																<spring:message code="encrypt_log_sever.Management_Server" />
															</a>
														</li>
														<li class="nav-item" id="MN0001203">
															<a class="nav-link" href="/encodeDecodeKeyAuditLog.do" onClick="fn_cookie('encodeDecodeKeyAuditLog')" target="main">
																<spring:message code="encrypt_policy_management.Encryption_Key" />
															</a>
														</li>
														<li class="nav-item" id="MN0001204">
															<a class="nav-link" href="/resourcesUseAuditLog.do" onClick="fn_cookie('resourcesUseAuditLog')" target="main">
																자원사용
															</a>
														</li>
													</ul>
												</div>
												<div class="col-group col-md-3" id="MN00013">
													<p class="category-heading">
														<b><spring:message code="encrypt_policyOption.Settings" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0001301">
															<a class="nav-link" href="/securityPolicyOptionSet.do" onClick="fn_cookie('securityPolicyOptionSet')" target="main">
																<spring:message code="encrypt_policyOption.Security_Policy_Option_Setting" />
															</a>
														</li>
														<li class="nav-item" id="MN0001302">
															<a class="nav-link" href="/securitySet.do" onClick="fn_cookie('securitySet')" target="main">
																<spring:message code="encrypt_encryptSet.Encryption_Settings" />
															</a>
														</li>
														<li class="nav-item" id="MN0001303">
															<a class="nav-link" href="/securityKeySet.do" onClick="fn_cookie('securityKeySet')" target="main">
																<spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password" />
															</a>
														</li>
														<li class="nav-item" id="MN0001304" >
															<a class="nav-link" href="/securityAgentMonitoring.do" onClick="fn_cookie('securityAgentMonitoring')" target="main">
																<spring:message code="encrypt_agent.Encryption_agent_setting"/>
															</a>
														</li>
													</ul>
												</div>
												<div class="col-group col-md-3" id="MN00014">
													<p class="category-heading">
														<b><spring:message code="encrypt_Statistics.Statistics" /></b>
													</p>
													<ul class="submenu-item">
														<li class="nav-item" id="MN0001401">
															<a class="nav-link" href="/securityStatistics.do" onClick="fn_cookie('securityStatistics')" target="main">
																<spring:message code="encrypt_Statistics.Encrypt_Statistics" />
															</a>
														</li>
													</ul>
												</div>
											</div>
										</div>
									</li>

									
									<!-- MIGRATION -->
									<li class="nav-item width-div-a"  id="migrationMenu">
										<a href="#" class="nav-link">
											<i class="ti-server menu-icon"></i>
											<span class="menu-title">MIGRATION</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu">											
											<ul class="submenu-item">
												<li class="nav-item">
													<span class="nav-heading-title">
														<b><spring:message code="encrypt_tree.Data_Encryption" /></b>
													</span>
												</li>
												<li class="nav-item" id="MN00015">
													<a class="nav-link" href="/db2pgDBMS.do" onClick="fn_cookie(null)" target="main">
														<spring:message code="migration.source/target_dbms_management"/>
													</a>
												</li>
												<li class="nav-item" id="MN00016">
													<a class="nav-link" href="/db2pgSetting.do" onClick="fn_cookie(null)" target="main">
														<spring:message code="migration.setting_information_management" />
													</a>
												</li>
												<li class="nav-item" id="MN00017">
													<a class="nav-link" href="/db2pgHistory.do" onClick="fn_cookie(null)" target="main">
														<spring:message code="migration.performance_history" />
													</a>
												</li>
											</ul>
										</div>
									</li>
									
 									
									<li class="nav-item width-div-a"  id="myPageMenu">
										<a href="#" class="nav-link">
											<i class="ti-user menu-icon"></i>
											<span class="menu-title">MY PAGE</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu">											
											<ul class="submenu-item">
												<li class="nav-item">
													<span class="nav-heading-title">
														<b>Language</b>
													</span>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="#n" onClick="fn_localeSet('ko')">
														Korean
													</a>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="#n"  onClick="fn_localeSet('en')">
														English
													</a>
												</li>
												
												<li class="nav-item">
													<span class="nav-heading-title">
														<b><spring:message code="menu.user_information_management"/></b>
													</span>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="/myPage.do" onClick="fn_cookie(null)">
														<spring:message code="menu.user_information_management"/>
													</a>
												</li>
												
												<li class="nav-item">
													<span class="nav-heading-title">
														<b><spring:message code="menu.my_schedule_management"/></b>
													</span>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="/myScheduleListView.do" onClick="fn_cookie(null)">
														<spring:message code="menu.my_schedule_management"/>
													</a>
												</li>
											</ul>
										</div>
									</li>

									<li class="nav-item" id="li_blnck" style="width:0px">
										&nbsp;
									</li>

								</ul>
							</div>
						</nav>
					</div>
				</div>
			</li>
		</ul>

		<ul class="navbar-nav mr-lg-2 navbar-nav-right">
			<li class="nav-item nav-search d-none d-lg-block">
				<div class="input-group">
					<div class="horizontal-menu">
						<nav class="bottom-navbar">
							<div class="container">
								<ul class="nav page-navigation">

									<!-- HELP -->
									<li class="nav-item" id="helpMenu" >
 										<a href="#" class="nav-link">
											<i class="ti-help-alt menu-icon"></i>
											<span class="menu-title">HELP</span>
											<i class="menu-arrow"></i>
										</a>
										<div class="submenu">
											<ul class="submenu-item">
												<li class="nav-item">
													<span class="nav-heading-title">
														<b>HELP</b>
													</span>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="#n" onClick="fn_aboutExperdb('${sessionScope.session.version}')" data-toggle="modal" data-target="#pop_layer_aboutExperdb" data-whatever="123" >
														About eXperDB
													</a>
												</li>
												<li class="nav-item">
													<a class="nav-link" href="#n" data-toggle="modal" data-target="#pop_layer_openSource" >
														Open Source License
													</a>
												</li>
											</ul>
										</div>
									</li>
									
								</ul>
							</div>
						</nav>
					</div>
				</div>
			</li>
			
			<li class="nav-item nav-profile dropdown">
				<a class="nav-link dropdown-toggle align-bottom" href="#" data-toggle="dropdown" id="profileDropdown" onclick="fn_profileChk();">
					<img src="/images/icons8-admin-settings-male-100.png" alt="profile"/>
					<span class="menu-title">${sessionScope.session.usr_nm} <spring:message code="common.login_user"/></span>
					<i id="profileArrowUser" class="menu-arrow_user"></i>
				</a>
				<div class="dropdown-menu dropdown-menu-right navbar-dropdown" aria-labelledby="profileDropdown">
					<a class="dropdown-item" onClick="">
						<i class="mdi mdi-face-profile text-primary"></i>
						<spring:message code="common.profile"/>
					</a>
					<a class="dropdown-item" onClick="fn_logout();">
						<i class="ti-power-off text-primary"></i>
						<spring:message code="common.logout"/>
					</a>
				</div>
			</li>
        </ul>

		<button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
			<span class="ti-layout-grid2"></span>
		</button>
	</div>
</nav>