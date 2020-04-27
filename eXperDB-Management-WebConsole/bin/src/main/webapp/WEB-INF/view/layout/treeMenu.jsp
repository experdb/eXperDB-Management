<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<style>
.tooltip {
	position: relative;
	display: inline-block;
}

.tooltip .tooltiptext {
	visibility: hidden;
	width: 130px;
	background-color: black;
	color: #fff;
	text-align: center;
	border-radius: 6px;
	padding: 5px 0;

	/* Position the tooltip */
	position: absolute;
	z-index: 1;
	bottom: 100%;
	left: 50%;
	margin-left: -60px;
}

.tooltip:hover .tooltiptext {
	visibility: visible;
}
</style>

<script type="text/javascript">
	var before = null;
	var scale_yn_chk = "";

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
				fn_UsrDBSrvAut(result);
			}
		});

		/*Tree Connector 조회*/
		$.ajax({
			async : false,
			url : "/selectTreeConnectorRegister.do",
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
				fn_usrMenuAut(result);
			}
		});

		/*암호화 조회*/
		if('${sessionScope.session.encp_use_yn}' == 'Y'){
			$.ajax({
				async : false,
				url : "/selectTreeEncrypt.do",
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
					fn_encryptMenuAut_Y(result);
				}
			});
		}else{
			fn_encryptMenuAut_N();
			//$('.encrypt').hide();
		}

		/* tree setting */
		$("#tree").treeview({
			collapsed: false,
			animated: "medium",
			control:"#sidetreecontrol",
			persist: "location"
		});

		/* tree2 setting */
		$("#tree2").treeview({
			collapsed: false,
			animated: "medium",
			control:"#sidetreecontrol2",
			persist: "location"
		});

		/* tree3 setting */
		$("#tree3").treeview({
			collapsed: false,
			animated: "medium",
			control:"#sidetreecontrol3",
			persist: "location"
		});

		/* tree4 setting */
		$("#tree4").treeview({
			collapsed: false,
			animated: "medium",
			control:"#sidetreecontrol4",
			persist: "location"
		});
	});

/*   	function GetJsonData(data) {
		var parseData = $.parseJSON(data);
		$(data).each(function (index, item) {	
			var html = "";
			html+="<li><strong>"+item.db_svr_nm+"</strong>";
			html+="<ul><li>백업관리";
			html+="<ul><li><a href='/backup/workList.do?db_svr_id="+item.db_svr_id+"' onClick=javascript:fn_GoLink('/backup/workList.do?db_svr_id="+item.db_svr_id+"');>백업설정</a></li></ul>";
			html+="<ul><li><a href='/backup/workLogList.do?db_svr_id="+item.db_svr_id+"' onClick=javascript:fn_GoLink('/backup/workLogList.do?db_svr_id="+item.db_svr_id+"');>백업이력</a></li></ul>";
			html+="<ul><li><a href='?'>모니터링</a></li></ul></li></ul>";
			html+="<ul><li>접근제어관리<ul>";
			html+="<li><a href='?'>서버접근제어</a></li></ul></li></ul></li>";

			$( "#tree1" ).append(html);
		})
	}  */

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
				scale_yn_chk = result.scale_yn_chk;
			}
		})
		
		
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
				GetJsonData(data, result);
			}
		})
	}

	/* connect 정보 setting */
	function fn_usrMenuAut(data){
		$.ajax({
			async : false,
			url : "/transferAuthorityList.do",
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
				Schedule(result);
				if('${sessionScope.session.transfer}' == 'Y'){ 
					GetJsonDataConnector_Y(data, result);
				}else{
					GetJsonDataConnector_N();
				}
			}
		})
	}

	/* 서버별 메뉴 setting 2020.03.03 scale 추가 */
	function GetJsonData(data, aut) {
		var parseData = $.parseJSON(data);
		var html1 = "";
 /*   	html1 += '<div class="lnb_tit">DB 서버';
		html1 += '<div class="all_btn">';
		html1 += '<a href="#" class="all_close">전체 닫기</a>';
		html1 += '<a href="#" class="all_open">전체 열기</a>';
		html1 += '</div>'; 
		html1 += '</div>';    */
		var html = "";

		$(data).each(function (index, item) {
			if(aut.length != 0 && aut[index].bck_cng_aut_yn == "N" && aut[index].bck_hist_aut_yn == "N" && aut[index].bck_scdr_aut_yn == "N" && aut[index].acs_cntr_aut_yn == "N" && aut[index].policy_change_his_aut_yn == "N" && aut[index].adt_cng_aut_yn == "N" && aut[index].adt_hist_aut_yn == "N" && aut[index].script_cng_aut_yn == "N"  && aut[index].script_his_aut_yn == "N" && aut[index].emergency_restore_aut_yn == "N" && aut[index].point_restore_aut_yn == "N" && aut[index].dump_restore_aut_yn == "N" && aut[index].restore_his_aut_yn == "N" && aut[index].scale_yn == "N"){
			}else{
				html1+='<ul class="depth_1 lnbMenu">';
				html1+='	<li><div class="border"  ><a href="/property.do?db_svr_id='+item.db_svr_id+'" onClick=javascript:fn_GoLink("#n"); target="main"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip">'+item.db_svr_nm+'<span class="tooltiptext">'+item.ipadr+'</span></div></a></div>';

				html1+='		<ul class="depth_2">';
				
				if (scale_yn_chk == "Y") {
					html1+='			<li class="ico2_1"><a href="#n"><img src="../images/ico_lnb_6.png" id="treeImg"><spring:message code="menu.eXperDB_scale"/></a>';

					html1+='				<ul class="depth_3">';
					if(aut.length != 0 && aut[index].scale_yn == "Y"){
						html1+='				<li class="ico3_1" id="scaleList'+item.db_svr_id+'"><a href=/scale/scaleList.do?db_svr_id='+item.db_svr_id+' id="scaleList'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("scaleList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="menu.eXperDB_scale"/></a></li>';
					}
					if(aut.length != 0 && aut[index].scale_hist_yn == "Y"){
						html1+='				<li class="ico3_2" id="scaleLogList'+item.db_svr_id+'"><a href=/scale/scaleLogList.do?db_svr_id='+item.db_svr_id+' id="scaleLogList'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("scaleLogList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.eXperDB_scale_history"/></a></li>';
					}
					html1+='				</ul>';
					html1+='			</li>';
				}

				html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_6.png" id="treeImg"><spring:message code="menu.backup_management"/></a>';

				html1+='				<ul class="depth_3">';
				if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
					html1+='				<li class="ico3_1" id="workList'+item.db_svr_id+'"><a href=/backup/workList.do?db_svr_id='+item.db_svr_id+' id="workList'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("workList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="menu.backup_settings"/></a></li>';
				}
				if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
					html1+='				<li class="ico3_2" id="workLogList'+item.db_svr_id+'"><a href=/backup/workLogList.do?db_svr_id='+item.db_svr_id+' id="workLogList'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("workLogList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.backup_history"/></a></li>';
				}
				if(aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y"){
					html1+='				<li class="ico2_2" id="schedulerView'+item.db_svr_id+'"><a href=/schedulerView.do?db_svr_id='+item.db_svr_id+'&db_svr_nm='+item.db_svr_nm+' id="schedulerView'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("schedulerView'+item.db_svr_id+'"); target="main"><img src="../images/ico_main_tit_1.png" id="treeImg"><spring:message code="menu.backup_scheduler"/></a>';
				}
				html1+='				</ul>';
				html1+='			</li>';

				html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_6.png" id="treeImg"><spring:message code="restore.Recovery_Management"/></a>';
				html1+='				<ul class="depth_3">';
				if(aut.length != 0 && aut[index].emergency_restore_aut_yn == "Y"){
					html1+='				<li class="ico3_1" id="emergencyRestore'+item.db_svr_id+'"><a href=/emergencyRestore.do?db_svr_id='+item.db_svr_id+' id="emergencyRestore'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("emergencyRestore'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="restore.Emergency_Recovery"/></a></li>';
				}
				if(aut.length != 0 && aut[index].point_restore_aut_yn == "Y"){
					html1+='				<li class="ico3_1" id="timeRestore'+item.db_svr_id+'"><a href=/timeRestore.do?db_svr_id='+item.db_svr_id+' id="timeRestore'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("timeRestore'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="restore.Point-in-Time_Recovery"/></a></li>';
				}
				if(aut.length != 0 && aut[index].dump_restore_aut_yn == "Y"){
					html1+='				<li class="ico3_1" id="dumpRestore'+item.db_svr_id+'"><a href=/dumpRestore.do?db_svr_id='+item.db_svr_id+' id="dumpRestore'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("dumpRestore'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="restore.Dump_Recovery"/></a></li>';
				}
				if(aut.length != 0 && aut[index].restore_his_aut_yn == "Y"){
					html1+='				<li class="ico3_1" id="restoreHistory'+item.db_svr_id+'"><a href=/restoreHistory.do?db_svr_id='+item.db_svr_id+' id="restoreHistory'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("restoreHistory'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="restore.Recovery_history"/></a></li>';
				}
				html1+='				</ul>';
				html1+='			</li>';

				html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg"><spring:message code="menu.access_control_management"/></a>';
				html1+='				<ul class="depth_3">';

				if(aut.length != 0 && aut[index].acs_cntr_aut_yn == "Y"){
					html1+='				<li class="ico3_3" id="accessControl'+item.db_svr_id+'"><a href=/accessControl.do?db_svr_id='+item.db_svr_id+' id="accessControl'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("accessControl'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_12.png" id="treeImg"><spring:message code="menu.access_control" /></a></li>';
				}
				if(aut.length != 0 && aut[index].policy_change_his_aut_yn == "Y"){
					html1+='				<li class="ico3_3" id="accessControlHistory'+item.db_svr_id+'"><a href=/accessControlHistory.do?db_svr_id='+item.db_svr_id+' id="accessControlHistory'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("accessControlHistory'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.policy_changes_history" /></a></li>';
				}
				html1+='				</ul>';
				html1+='			</li>';

				html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg"><spring:message code="menu.audit_management"/></a>';
				//pg_audit 사용여부에 따른 tree메뉴 권한
				if('${sessionScope.session.pg_audit}' == 'Y'){
					html1+='			<ul class="depth_3">'
					if(aut.length != 0 && aut[index].adt_cng_aut_yn == "Y"){
						html1+='			<li class="ico3_4" id="auditManagement'+item.db_svr_id+'"><a href=/audit/auditManagement.do?db_svr_id='+item.db_svr_id+' id="auditManagement'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("auditManagement'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="menu.audit_settings" /></a></li>';
					}
					if(aut.length != 0 && aut[index].adt_hist_aut_yn == "Y"){
						html1+='			<li class="ico3_5" id="auditLogList'+item.db_svr_id+'"><a href=/audit/auditLogList.do?db_svr_id='+item.db_svr_id+' id="auditLogList'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("auditLogList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.audit_history" /></a></li>';
					}
					html1+='			</ul>';
				}
				html1+='			</li>';

				html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg"><spring:message code="menu.script_management"/></a>';
				html1+='				<ul class="depth_3">'
				if(aut.length != 0 && aut[index].script_cng_aut_yn == "Y"){
					html1+='				<li class="ico3_4" id="scriptManagement'+item.db_svr_id+'"><a href=/scriptManagement.do?db_svr_id='+item.db_svr_id+' id="scriptManagement'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("scriptManagement'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="menu.script_settings" /></a></li>';
				}
				if(aut.length != 0 && aut[index].script_his_aut_yn == "Y"){
					html1+='				<li class="ico3_5" id="scriptHistory'+item.db_svr_id+'"><a href=/scriptHistory.do?db_svr_id='+item.db_svr_id+' id="scriptHistory'+item.db_svr_id+'c" onClick=javascript:fn_GoLink("scriptHistory'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.script_history" /></a></li>';
				}
				html1+='				</ul>';
				html1+='			</li>';

				html1+='		</ul>';
				html1+='	</li>';
				html1+='</ul>';
			}
		})

		$( "#tree1" ).append(html1);
	}

	/* 데이터전송 메뉴설정 transfer Y */
	function GetJsonDataConnector_Y(data, aut) {
		var parseData = $.parseJSON(data);
		var html = "";

// 	          for(var i=0; i<aut.length; i++){ 	  
// 		          if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000201"){	        	 
// 		        	  html += '<ul class="depth_1 lnbMenu"><li class="t1"><a href="/treeTransferSetting.do"><img src="../images/ico_lnb_4.png" id="treeImg">데이터 전송설정</a></li>';
// 		          }
// 	          }

		$(data).each(function (index, item) {
			html += '      <ul class="depth_1 lnbMenu"><li class="t2"><div class="border" ><a href="#n"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip">'+item.cnr_nm+'<span class="tooltiptext">'+item.cnr_nm+'</span></div></a></div>';
			html += '         <ul class="depth_2">';
			html += '              <li class="ico2_3" id="transferTarget'+item.cnr_id+'"><a href="/transferTarget.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" id="transferTarget'+item.cnr_id+'c" onClick=javascript:fn_GoLink("transferTarget'+item.cnr_id+'"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="menu.connector_settings" /></a></li>';
			html += '            <li class="ico2_4" id="transferDetail'+item.cnr_id+'"><a href="/transferDetail.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" id="transferDetail'+item.cnr_id+'c" onClick=javascript:fn_GoLink("transferDetail'+item.cnr_id+'"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="menu.connector_run_stop" /></a></li>';
			html += '         </ul></li></ul>';   
		})
		html += '</ul>';
		$( "#tree2" ).append(html);
	}

	/* 데이터전송 메뉴설정 transfer N */
	function GetJsonDataConnector_N() {
		var html = "";
		html += '<ul class="depth_1 lnbMenu">';
		html += '</ul>';
		$( "#tree2" ).append(html);
	}
	
	/* 스케줄 메뉴 setting */ 
	function Schedule(aut){
		var html3="";
		for(var i=0; i<aut.length; i++){
			if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000101"){	      
				html3 += '      <ul class="depth_1 lnbMenu"><li class="t2"><div class="border" ><a href="#n"><img src="../images/ico_lnb_14.png" id="treeImg"><div class="tooltip"><spring:message code="menu.schedule_information" /></div></a></div>';
				html3 += '			<ul class="depth_2"><li class="ico2_2" id="insertScheduleView"><a href="/insertScheduleView.do" id="insertScheduleViewc" onClick=javascript:fn_GoLink("insertScheduleView"); target="main" ><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="menu.schedule_registration" /></a></li>';
			}

			if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000102"){
				html3 += '         <li class="ico2_2" id="selectScheduleListView"><a href="/selectScheduleListView.do" id="selectScheduleListViewc" onClick=javascript:fn_GoLink("selectScheduleListView"); target="main"><img src="../images/ico_lnb_11.png" id="treeImg"><spring:message code="etc.etc27"/></a></li>';
			}

			if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000103"){
				html3 += '         <li class="ico2_2" id="selectScheduleHistoryView"><a href="/selectScheduleHistoryView.do" id="selectScheduleHistoryViewc" onClick=javascript:fn_GoLink("selectScheduleHistoryView"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.shedule_execution_history" /></a></li></ul></li></ul>';
			}
		}

		$( "#tree4" ).append(html3);
	}

	/* 암호화 메뉴 setting 암호화 사용여부 Y일때 */  
	function fn_encryptMenuAut_Y(result){
		var html4 = "";
		html4 += '<ul class="depth_1 lnbMenu">';
		html4 += '<li class="t2"><div class="border">';
		html4 += '<a href="#n"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></div></a>';
		html4 += '</div>';
		html4 += '<ul class="depth_2">';
		if(result.length != 0 && result[0].read_aut_yn == "Y" && result[0].mnu_cd == "MN0001101"){
			html4 += '<li class="ico2_3" id="securityPolicy"><a href="/securityPolicy.do" id="securityPolicyc" onclick=fn_GoLink("securityPolicy"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></a></li>';
		}
		if(result.length != 0 && result[1].read_aut_yn == "Y" && result[1].mnu_cd == "MN0001102"){
			html4 += '<li class="ico2_3" id="keyManage"><a href="/keyManage.do" id="keyManagec" onclick=fn_GoLink("keyManage"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></a></li>';
		}
		html4 += '</ul>';
		html4 += '</li>';

		html4 += '<li class="t2"><div class="border">';
		html4 += '<a href="#n"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_log.Audit_Log"/></div></a>';
		html4 += '</div>';
		html4 += '<ul class="depth_2">';
		if(result.length != 0 && result[2].read_aut_yn == "Y" && result[2].mnu_cd == "MN0001201"){
			html4 += '<li class="ico2_4" id="encodeDecodeAuditLog"><a href="/encodeDecodeAuditLog.do"  id="encodeDecodeAuditLogc" onclick=fn_GoLink("encodeDecodeAuditLog"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></a></li>';
		}
		if(result.length != 0 && result[3].read_aut_yn == "Y" && result[3].mnu_cd == "MN0001202"){
			html4 += '<li class="ico2_4" id="managementServerAuditLog"><a href="/managementServerAuditLog.do" id="managementServerAuditLogc" onclick=fn_GoLink("managementServerAuditLog"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="encrypt_log_sever.Management_Server"/></a></li>';
		}
		if(result.length != 0 && result[4].read_aut_yn == "Y" && result[4].mnu_cd == "MN0001203"){
			html4 += '<li class="ico2_4" id="encodeDecodeKeyAuditLog"><a href="/encodeDecodeKeyAuditLog.do" id="encodeDecodeKeyAuditLogc" onclick=fn_GoLink("encodeDecodeKeyAuditLog"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="encrypt_policy_management.Encryption_Key"/></a></li>';
		}
		if(result.length != 0 && result[5].read_aut_yn == "Y" && result[5].mnu_cd == "MN0001204"){
			html4 += '<li class="ico2_4"><a href="/resourcesUseAuditLog.do" id="resourcesUseAuditLog" onclick=fn_GoLink("resourcesUseAuditLog"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg">자원사용</a></li>';
		}
		html4 += '</ul>';
		html4 += '</li>';

		html4 += '<li class="t2"><div class="border">';
		html4 += '<a href="#n"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_policyOption.Settings"/></div></a>';
		html4 += '</div>';
		html4 += '<ul class="depth_2">';
		if(result.length != 0 && result[6].read_aut_yn == "Y" && result[6].mnu_cd == "MN0001301"){
			html4 +='<li class="ico2_4" id="securityPolicyOptionSet"><a href="/securityPolicyOptionSet.do" id="securityPolicyOptionSetc" onclick=fn_GoLink("securityPolicyOptionSet"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></a></li>';
		}
		if(result.length != 0 && result[7].read_aut_yn == "Y" && result[7].mnu_cd == "MN0001302"){
			html4 +='<li class="ico2_4" id="securitySet"><a href="/securitySet.do" id="securitySetc" onclick=fn_GoLink("securitySet"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_encryptSet.Encryption_Settings"/></a></li>';
		}
		if(result.length != 0 && result[8].read_aut_yn == "Y" && result[8].mnu_cd == "MN0001303"){
			html4 +='<li class="ico2_4" id="securityKeySet"><a href="/securityKeySet.do" id="securityKeySetc" onclick=fn_GoLink("securityKeySet"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></a></li>';
		}
		if(result.length != 0 && result[9].read_aut_yn == "Y" && result[9].mnu_cd == "MN0001304"){
			html4 +='<li class="ico2_4" id="securityAgentMonitoring"><a href="/securityAgentMonitoring.do" id="securityAgentMonitoringc" onclick=fn_GoLink("securityAgentMonitoring"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_agent.Encryption_agent_setting"/> </a></li>';
		}
		html4 += '</ul>';
		html4 += '</li>';

		/* 암호화 통계 추가 */
		html4 += '<li class="t2"><div class="border">';
		html4 += '<a href="#n"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_Statistics.Statistics"/></div></a>';
		html4 += '</div>';
		html4 += '<ul class="depth_2">';
		if(result.length != 0 && result[10].read_aut_yn == "Y" && result[10].mnu_cd == "MN0001401"){
			html4 +='<li class="ico2_4" id="securityStatistics"><a href="/securityStatistics.do" id="securityStatisticsc" onclick=fn_GoLink("securityStatistics"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="encrypt_Statistics.Encrypt_Statistics"/> </a></li>';
		}
		html4 += '</ul>';
		html4 += '</ul>';

		$( "#tree3" ).append(html4);
	}

	/* 암화화메뉴 setting 암호화 사용여부 N */
	function fn_encryptMenuAut_N(){
		var html4 = '<ul class="depth_1 lnbMenu">';
		html4 += '</ul>';
		$( "#tree3" ).append(html4);
	}

	/* 로그아웃 */
	function fn_logout(){
		sessionStorage.removeItem('cssId');

		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();
	}

	/* link move */
	function fn_GoLink(url) {
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

 	function fn_localeSetting(){
 		var locale = $("#language").val();
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
 	
	function fn_aut_use_yn(){
		alert("접근권한이 존재하지 않습니다.");
		return false;
	}
</script>


<script type="text/javascript" src="/js/jquery.mCustomScrollbar.concat.min.js"></script><!-- mCustomScrollbar -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/common_lnb.js"></script>

		<div id="lnb_menu">
			<form name="treeView" id="treeView">
				<div class="logout">
					    <div style="color: white; margin-bottom: 5%; font-size: 14px;">${sessionScope.session.usr_nm}<spring:message code="common.wellcome"/></div>		
					<a href="#"  target="_top"><button type="button" onClick="fn_logout();"><spring:message code="common.logout"/></button></a>		
				</div>
			</form>
			
			<div id="treeTitle"><img src="../images/ico_lnb_1.png" id="treeImg"><a href="/dbTree.do" target="main" onclick="fn_GoLink();">DB <spring:message code="dashboard.server" /></a>
				<div id="sidetreecontrol" style="float: right;">
					<a href="?#"><img src="../images/ico_lnb_close.png"></a>
					<a href="?#"><img src="../images/ico_lnb_open.png"></a>
				</div>
			</div>
				
			<div id="sidetree">				
				<div class="treeborder">
					<ul id="tree">
						<div id="tree1"></div>
					</ul>
				</div>
			</div>
				
			<div id="treeTitle" class="transferMenu"><img src="../images/ico_lnb_2.png" id="treeImg">
			<c:set var="aut_use" value="${sessionScope.session.transfer}" />
			<c:choose>
			    <c:when test="${aut_use eq 'Y'}">
			        <a href="/connectorRegister.do" target="main" onclick="fn_GoLink();">
			        	<spring:message code="menu.data_transfer" />
					</a>
			    </c:when>		
			    <c:otherwise>
			       <span onclick="fn_aut_use_yn();">
			       		<spring:message code="menu.data_transfer" />
					</span>
			    </c:otherwise>
			</c:choose>

				<div id="sidetreecontrol2" style="float: right;">							
					<a href="?#"><img src="../images/ico_lnb_close.png"></a>
					<a href="?#"><img src="../images/ico_lnb_open.png"></a>
				</div>
			</div>
				
			<div id="sidetree">				
					<div class="treeborder">
						<ul id="tree">
							<div id="tree2"></div>
						</ul>
					</div>
			</div>

			<div id="treeTitle" class="encrypt"><img src="../images/ico_lnb_1.png" id="treeImg">
			
			<c:set var="aut_use" value="${sessionScope.session.encp_use_yn}" />
			<c:choose>
			    <c:when test="${aut_use eq 'Y'}">
			        <a href="/securityPolicy.do" target="main" onclick="fn_GoLink();">
			        	<spring:message code="encrypt_tree.Data_Encryption"/>
					</a>
			    </c:when>		
			    <c:otherwise>
			       <span onclick="fn_aut_use_yn();">
			       		<spring:message code="encrypt_tree.Data_Encryption"/>
					</span>
			    </c:otherwise>
			</c:choose>
				<!-- <a href="/securityPolicy.do" target="main" onclick="fn_GoLink();"> -->
				<div id="sidetreecontrol3" style="float: right;">							
					<a href="?#"><img src="../images/ico_lnb_close.png"></a>
					<a href="?#"><img src="../images/ico_lnb_open.png"></a>
				</div>
			</div>
				
			<div id="sidetree">				
				<div class="treeborder">
					<ul id="tree">
						<ul class="depth_1 lnbMenu">
						<div id="tree3"></div>
						</ul>  	 		
					</ul>
				</div>
			</div>

			<div id="treeTitle"><img src="../images/ico_main_tit_1.png" id="treeImg"><a href="/selectScheduleListView.do" target="main"><spring:message code="menu.schedule" /></a></div>	
			<div id="sidetree1">						
				<div class="treeborder">
					<ul id="tree">
						<div id="tree4"></div>
					</ul>
				</div>
			</div>
		</div>