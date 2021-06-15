<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	var before = null;
	var scale_yn_chk = "";
	var transfer_ora_chk = "";

	$(window.document).ready(function() {
		$.ajax({
			async : false,
			url : "/selectTreeDBSvrList.do",
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
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				fn_UsrDBSrvAut(result);
			}
		});
	});

	/* 서버별 메뉴 조회 */
	function fn_UsrDBSrvAut(data){
	  	$.ajax({
			async : false,
			url : "/selectServerScaleAuthInfo.do",
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
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				scale_yn_chk = result.scale_yn_chk;
				transfer_ora_chk = result.transfer_ora_chk;
			}
		});

		$.ajax({
			async : false,
			url : "/selectUsrDBSrvAutInfo.do",
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
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				GetJsonData(data, result);
			}
		});
	}

	/* 서버별 메뉴 setting 2020.03.03 scale 추가 */
	function GetJsonData(data, aut) {
		//var parseData = $.parseJSON(data);
		var menuJson = '[';

		$(data).each(function (index, item) {
			if(aut.length != 0 && aut[index].bck_cng_aut_yn == "N" && aut[index].bck_hist_aut_yn == "N" && aut[index].bck_scdr_aut_yn == "N" && aut[index].acs_cntr_aut_yn == "N" && aut[index].policy_change_his_aut_yn == "N" && aut[index].adt_cng_aut_yn == "N" && aut[index].adt_hist_aut_yn == "N" && aut[index].script_cng_aut_yn == "N"  && aut[index].script_his_aut_yn == "N" && aut[index].emergency_restore_aut_yn == "N" && aut[index].point_restore_aut_yn == "N" && aut[index].dump_restore_aut_yn == "N" && aut[index].restore_his_aut_yn == "N" && aut[index].scale_aut_yn == "N" && aut[index].scale_hist_aut_yn == "N"  && aut[index].scale_cng_aut_yn == "N"){
			}else{
				menuJson +=	'{' +
								'"text": "' + item.db_svr_nm + '",' +
								'"icon": "ti-harddrives",' +
								'"url": "/property.do?db_svr_id='+item.db_svr_id+'",' +
								'"clickVal": "#n",' +	
								'"tooltiptext": "' + item.ipadr + '",' +
								'"nodes": [';

											//서버 속성
											menuJson +=	'{' +
																'"text": "<spring:message code="menu.server_property"/>",' +
																'"icon": "mdi mdi-server",' +
																'"id": "scale'+item.db_svr_id+'",' +
																'"url": "/property.do?db_svr_id='+item.db_svr_id+'",' +
																'"menu_gbn": "server"' +
														'}';

											//scale
											if (scale_yn_chk == "Y") {
												menuJson +=	', {' +
																 '"text": "<spring:message code="menu.eXperDB_scale"/>",' +
																 '"icon": "ti-cloud-up",' +
																 '"id": "scale'+item.db_svr_id+'",' +
																 '"nodes": [';

												if(aut.length != 0 && aut[index].scale_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																//	'"icon": "fa fa-spin fa-cog",' +
																	'"icon": "fa fa-cog",' +
																	'"text": "<spring:message code="menu.eXperDB_scale_settings"/>",' +
																	'"url": "/scale/scaleManagement.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "scaleManagement'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].scale_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-expand",' +
																	'"text": "<spring:message code="menu.scale_manual"/>",' +
																	'"url": "/scale/scaleList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "scaleList'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].scale_hist_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="menu.eXperDB_scale_history"/>",' +
																	'"url": "/scale/scaleLogList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "scaleLogList'+item.db_svr_id+'"' +
																'}';
												}
												
												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}

												menuJson +=		']' +
															'}';
											}

											
											
											//덤프관리 //////////////////////////////////////////////////////////////////
											menuJson +=	',{' +
															 '"text": "<spring:message code="eXperDB_backup.msg85"/>",' +
															 '"icon": "ti-files",' +
															 '"id": "dump'+item.db_svr_id+'"';

											if((aut.length != 0 && aut[index].bck_cng_aut_yn == "Y") || (aut.length != 0 && aut[index].bck_hist_aut_yn == "Y")
											 || (aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y")){
												menuJson +=	', "nodes": [';

												if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-cog",' +
																	'"text": "<spring:message code="eXperDB_backup.msg86"/>",' +
																	'"url": "/backup/dumpList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "dumpWorkList'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="eXperDB_backup.msg87"/>",' +
																	'"url": "/backup/dumpLogList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "workLogList'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-calendar",' +
																	'"text": "<spring:message code="eXperDB_backup.msg88"/>",' +
																	'"url": "/dumpSchedulerView.do?db_svr_id='+item.db_svr_id+'&db_svr_nm='+item.db_svr_nm+'",' +
																	'"id": "schedulerView'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-window-restore",' +
																	'"text": "<spring:message code="restore.Dump_Recovery"/>",' +
																	'"url": "/dumpRestore.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "dumpRestore'+item.db_svr_id+'"' +
																'},';
												}
												
												if(aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="restore.Recovery_history"/>",' +
																	'"url": "/restoreDumpHistory.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "restoreHistory'+item.db_svr_id+'"' +
																'}';
												}

												
												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}

												menuJson +=		']';
											}

											menuJson += '}';
											////////////////////////////////////////////////////////////////////////////
											
								
											
											/* //백업관리 //////////////////////////////////////////////////////////////////
											menuJson +=	',{' +
															 '"text": "<spring:message code="menu.backup_management"/>",' +
															 '"icon": "ti-files",' +
															 '"id": "backup'+item.db_svr_id+'"';

											if((aut.length != 0 && aut[index].bck_cng_aut_yn == "Y") || (aut.length != 0 && aut[index].bck_hist_aut_yn == "Y")
											 || (aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y")){
												menuJson +=	', "nodes": [';

												if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-cog",' +
																	'"text": "<spring:message code="menu.backup_settings"/>",' +
																	'"url": "/backup/workList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "workList'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="menu.backup_history"/>",' +
																	'"url": "/backup/workLogList.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "workLogList'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-calendar",' +
																	'"text": "<spring:message code="menu.backup_scheduler"/>",' +
																	'"url": "/schedulerView.do?db_svr_id='+item.db_svr_id+'&db_svr_nm='+item.db_svr_nm+'",' +
																	'"id": "schedulerView'+item.db_svr_id+'"' +
																'}';
												}

												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}

												menuJson +=		']';
											}

											menuJson += '}';
											//////////////////////////////////////////////////////////////////////////// */

											/* //복원관리 //////////////////////////////////////////////////////////////////
											menuJson +=	',{' +
															 '"text": "<spring:message code="restore.Recovery_Management"/>",' +
															 '"icon": "mdi mdi-file-restore",' +
															 '"id": "emergency'+item.db_svr_id+'"';

											if((aut.length != 0 && aut[index].emergency_restore_aut_yn == "Y") || (aut.length != 0 && aut[index].point_restore_aut_yn == "Y")
												 || (aut.length != 0 && aut[index].dump_restore_aut_yn == "Y") || (aut.length != 0 && aut[index].restore_his_aut_yn == "Y")
											){
												menuJson +=	', "nodes": [';
													
												if(aut.length != 0 && aut[index].emergency_restore_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-bell",' +
																	'"text": "<spring:message code="restore.Emergency_Recovery"/>",' +
																	'"url": "/emergencyRestore.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "emergencyRestore'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].point_restore_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "mdi mdi-backup-restore",' +
																	'"text": "<spring:message code="restore.Point-in-Time_Recovery"/>",' +
																	'"url": "/timeRestore.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "timeRestore'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].dump_restore_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-window-restore",' +
																	'"text": "<spring:message code="restore.Dump_Recovery"/>",' +
																	'"url": "/dumpRestore.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "dumpRestore'+item.db_svr_id+'"' +
																'},';
												}

												if(aut.length != 0 && aut[index].restore_his_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="restore.Recovery_history"/>",' +
																	'"url": "/restoreHistory.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "restoreHistory'+item.db_svr_id+'"' +
																'}';
												}
												
												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}

												menuJson +=		']';
											}
											menuJson += '}';
											//////////////////////////////////////////////////////////////////////////// */
											
											//데이터전송 //////////////////////////////////////////////////////////////////
											var transferChk = String('${sessionScope.session.transfer}').trim();

											if(transferChk == 'Y'){
												menuJson +=	', {' +
															 '"text": "<spring:message code="menu.data_transfer"/>",' +
															 '"icon": "fa fa-inbox",' + 
															 '"id": "trans'+item.db_svr_id+'",' +
															 '"nodes": [';

												if (transfer_ora_chk == "Y") {
													if(aut.length != 0 && aut[index].trans_dbms_cng_aut_yn == "Y"){
														menuJson +=	'{' +
																		'"icon": "fa fa-database",' +
																		'"text": "<spring:message code="data_transfer.btn_title01"/>",' +
																		'"url": "/transDbmsSetting.do?db_svr_id='+item.db_svr_id+'",' +
																		'"id": "transDbmsSetting'+item.db_svr_id+'"' +
																	'},';
													}
												}

												if(aut.length != 0 && aut[index].trans_con_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="data_transfer.btn_title02"/>",' +
																	'"url": "/transConnectSetting.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "transConnectSetting'+item.db_svr_id+'"' +
																'},';
												}
	
												if(aut.length != 0 && aut[index].transsetting_aut_yn == "Y"){				 
													menuJson +=	'{' +
																'"icon": "fa fa-send",' +
																'"text": "<spring:message code="menu.trans_management"/>",' +
																'"url": "/transSetting.do?db_svr_id='+item.db_svr_id+'",' +
																'"id": "transSetting'+item.db_svr_id+'"' +
															'}';
												}
												
												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}

												
												
												menuJson +=		']' +
															'}';
											}
											////////////////////////////////////////////////////////////////////////////

											//서버접근설정 관리 //////////////////////////////////////////////////////////////////
											menuJson +=	',{' +
														  	 '"text": "<spring:message code="menu.access_control_management"/>",' + 
													 		 '"icon": "ti-lock",' +
															 '"id": "access'+item.db_svr_id+'"';

											if((aut.length != 0 && aut[index].acs_cntr_aut_yn == "Y") || (aut.length != 0 && aut[index].policy_change_his_aut_yn == "Y")){
												menuJson +=	', "nodes": [';
												
												if(aut.length != 0 && aut[index].acs_cntr_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-lock",' +
																	'"text": "<spring:message code="menu.access_control"/>",' +
																	'"url": "/accessControl.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "accessControl'+item.db_svr_id+'"' +
																'},';
												}
												
												if(aut.length != 0 && aut[index].policy_change_his_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="menu.policy_changes_history"/>",' +
																	'"url": "/accessControlHistory.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "accessControlHistory'+item.db_svr_id+'"' +
																'}';
												}

												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}
												
												menuJson +=		']';
											}
											
											menuJson +=	'}';
											////////////////////////////////////////////////////////////////////////////

											//감사관리 //////////////////////////////////////////////////////////////////
											//pg_audit 사용여부에 따른 tree메뉴 권한
											if('${sessionScope.session.pg_audit}' == 'Y'){
												if((aut.length != 0 && aut[index].adt_cng_aut_yn == "Y") || (aut.length != 0 && aut[index].adt_hist_aut_yn == "Y")){
													menuJson +=	', {' +
													 '"text": "<spring:message code="menu.audit_management"/>",' + 
													 '"icon": "fa fa-laptop",' +
													 '"id": "audit'+item.db_svr_id+'"';
													 
													menuJson +=	', "nodes": [';
													
													if(aut.length != 0 && aut[index].adt_cng_aut_yn == "Y"){
														menuJson +=	'{' +
																		'"icon": "fa fa-cog",' +
																		'"text": "<spring:message code="menu.audit_settings"/>",' +
																		'"url": "/audit/auditManagement.do?db_svr_id='+item.db_svr_id+'",' +
																		'"id": "auditManagement'+item.db_svr_id+'"' +
																	'},';
													}
													
													if(aut.length != 0 && aut[index].adt_hist_aut_yn == "Y"){
														menuJson +=	'{' +
																		'"icon": "fa fa-history",' +
																		'"text": "<spring:message code="menu.audit_history"/>",' +
																		'"url": "/audit/auditLogList.do?db_svr_id='+item.db_svr_id+'",' +
																		'"id": "auditLogList'+item.db_svr_id+'"' +
																	'}';
													}

													//마지막 콤마 제거
													if (menuJson.charAt(menuJson.length-1) == ",") {
														menuJson = menuJson.substr(0, menuJson.length -1);
													}
													
													menuJson +=		']';
													
													menuJson +=	'}';
												}
											}

											////////////////////////////////////////////////////////////////////////////

											//배치//////////////////////////////////////////////////////////////////
											menuJson +=	',{' +
															 '"text": "<spring:message code="menu.script_management"/>",' + 
															 '"icon": "fa fa-share-square-o",' +
															 '"id": "script'+item.db_svr_id+'"';
															
											if((aut.length != 0 && aut[index].script_cng_aut_yn == "Y") || (aut.length != 0 && aut[index].script_his_aut_yn == "Y")){
												menuJson +=	', "nodes": [';
												
												if(aut.length != 0 && aut[index].script_cng_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-cog",' +
																	'"text": "<spring:message code="menu.script_settings"/>",' +
																	'"url": "/scriptManagement.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "scriptManagement'+item.db_svr_id+'"' +
																'},';
												}
												
												if(aut.length != 0 && aut[index].script_his_aut_yn == "Y"){
													menuJson +=	'{' +
																	'"icon": "fa fa-history",' +
																	'"text": "<spring:message code="menu.script_history"/>",' +
																	'"url": "/scriptHistory.do?db_svr_id='+item.db_svr_id+'",' +
																	'"id": "scriptHistory'+item.db_svr_id+'"' +
																'}';
												}

												//마지막 콤마 제거
												if (menuJson.charAt(menuJson.length-1) == ",") {
													menuJson = menuJson.substr(0, menuJson.length -1);
												}
												
												menuJson +=		']';
											}
											
											menuJson +=	'}';
											////////////////////////////////////////////////////////////////////////////
											
											//빈값
											menuJson +=	', {' +
																'"text": "&nbsp;",' +
																'"menu_gbn": "blnck"' +
														 '}';
											
				menuJson +=		']' +
							'},';
			}
		});
		
		if (menuJson != null) {
			if (menuJson != "[") {
				menuJson = menuJson.substr(0, menuJson.length -1);
			}
		}

		menuJson += ']';

		$('#lft_tree').bstreeview({ data: menuJson });
	}
</script>

<form name="dbServerView" id="dbServerView">
	<input type="hidden" id="db_svr_id" name="db_svr_id" value="" />
<!-- <a href="/property.do?db_svr_id='+item.db_svr_id+'" onClick=javascript:fn_GoLink("#n"); target="main"><im -->
</form>

<!-- partial:partials/_settings-panel.html -->
<!-- <div class="theme-setting-wrapper">
	<div id="settings-trigger">
		<i class="ti-settings"></i>
	</div>

	<div id="theme-settings" class="settings-panel">
		<i class="settings-close ti-close"></i>
		<p class="settings-heading">SIDEBAR SKINS</p>
		<div class="sidebar-bg-options" id="sidebar-light-theme"><div class="img-ss rounded-circle bg-light border mr-3"></div>Light</div>
		<div class="sidebar-bg-options selected" id="sidebar-dark-theme"><div class="img-ss rounded-circle bg-dark border mr-3"></div>Dark</div>
		<p class="settings-heading mt-2">HEADER SKINS</p>
		<div class="color-tiles mx-0 px-4">
			<div class="tiles success"></div>
			<div class="tiles warning"></div>
			<div class="tiles danger"></div>
			<div class="tiles info"></div>
			<div class="tiles dark"></div>
			<div class="tiles default"></div>
		</div>
	</div>
</div>
 -->
<!-- partial -->
<nav class="sidebar sidebar-offcanvas" id="sidebar" style="max-height: calc(100vh - 0px);">
	<ul class="nav" style="">
<!-- 		<li class="nav-item">
			<a class="nav-link" href="/db2pgSetting2.do" target="main">
				<i class="mdi mdi-amazon-clouddrive"></i>
				<i class="mdi mdi-face-profile text-primary"></i>
				<span class="menu-title">eXperDB-Sample!!!!</span>
			</a>
		</li> -->

		<li class="nav-item li_blank">
            &nbsp;
		</li>

 		<li class="nav-item">
			<a class="nav-link" href="#n">
				<i class="ti-server menu-icon"></i>
				<span class="menu-title">DB <spring:message code="dashboard.server" /></span>
			</a>
		</li>
	</ul>
	
	<ul class="nav left_scroll" id="lft_tree" style="margin-top:-60px;width:223px;min-height: calc(100vh - 180px);max-height: calc(100vh - 180px);overflow-y:auto;overflow-x:hidden;">
	</ul>
</nav>