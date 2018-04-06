<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
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
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			fn_usrMenuAut(result);
		}
	});  
   
   	/*암호화 조회*/
   	if('${sessionScope.encp_use_yn}' == 'Y'){
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
   					 location.href = "/";
   				} else if(xhr.status == 403) {
   					alert('<spring:message code="message.msg03" />');
   		             location.href = "/";
   				} else {
   					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
   				}
   			},
   			success : function(result) {
   				fn_encryptMenuAut(result);
   			}
   		});
   	}else{
   		$('.encrypt').hide();
   	}
   
      $("#tree").treeview({
          collapsed: false,
          animated: "medium",
          control:"#sidetreecontrol",
          persist: "location"
      });
      
      $("#tree2").treeview({
          collapsed: false,
          animated: "medium",
          control:"#sidetreecontrol2",
          persist: "location"
      });
      
      $("#tree3").treeview({
          collapsed: false,
          animated: "medium",
          control:"#sidetreecontrol3",
          persist: "location"
      });
      
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
	
	
	function fn_UsrDBSrvAut(data){
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
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				GetJsonData(data, result);
			}
		})
	}	
	
	
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
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				GetJsonDataConnector(data, result);
				Schedule(result);
			}
		})
	}	
	

  		function GetJsonData(data, aut) {
			var parseData = $.parseJSON(data);
		 	var html1 = "";
 /*   			html1 += '<div class="lnb_tit">DB 서버';
			html1 += '<div class="all_btn">';
			html1 += '<a href="#" class="all_close">전체 닫기</a>';
			html1 += '<a href="#" class="all_open">전체 열기</a>';
			html1 += '</div>'; 
			html1 += '</div>';    */
			var html = "";

 			$(data).each(function (index, item) {
 				if(aut.length != 0 && aut[index].bck_cng_aut_yn == "N" && aut[index].bck_hist_aut_yn == "N" && aut[index].bck_scdr_aut_yn == "N" && aut[index].acs_cntr_aut_yn == "N" && aut[index].policy_change_his_aut_yn == "N" && aut[index].adt_cng_aut_yn == "N" && aut[index].adt_hist_aut_yn == "N" ){	
 				}else{
 					html1+='<ul class="depth_1 lnbMenu">';
					html1+='	<li><div class="border"  ><a href="/property.do?db_svr_id='+item.db_svr_id+'" onClick=javascript:fn_GoLink("#n"); target="main"><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip">'+item.db_svr_nm+'<span class="tooltiptext">'+item.ipadr+'</span></div></a></div>';
					html1+='		<ul class="depth_2">';
					html1+='			<li class="ico2_1"><a href="#n"><img src="../images/ico_lnb_6.png" id="treeImg"><spring:message code="menu.backup_management"/></a>';
					html1+='				<ul class="depth_3">';
					if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
						html1+='					<li class="ico3_1"><a href=/backup/workList.do?db_svr_id='+item.db_svr_id+' id="workList'+item.db_svr_id+'" onClick=javascript:fn_GoLink("workList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_10.png" id="treeImg"><spring:message code="menu.backup_settings"/></a></li>';
					}
					if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
						html1+='					<li class="ico3_2"><a href=/backup/workLogList.do?db_svr_id='+item.db_svr_id+' id="workLogList'+item.db_svr_id+'" onClick=javascript:fn_GoLink("workLogList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_11.png" id="treeImg"><spring:message code="menu.backup_history"/></a></li>';
					}
					if(aut.length != 0 && aut[index].bck_scdr_aut_yn == "Y"){
					html1+='			<li class="ico2_2"><a href=/schedulerView.do?db_svr_id='+item.db_svr_id+'&db_svr_nm='+item.db_svr_nm+' id="schedulerView'+item.db_svr_id+'" onClick=javascript:fn_GoLink("schedulerView'+item.db_svr_id+'"); target="main"><img src="../images/ico_main_tit_1.png" id="treeImg"><spring:message code="menu.backup_scheduler"/></a>';
					}
					html1+='				</ul>';
					html1+='			</li>';
					html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg"><spring:message code="menu.access_control_management"/></a>';
					html1+='				<ul class="depth_3">';
					if(aut.length != 0 && aut[index].acs_cntr_aut_yn == "Y"){
						html1+='					<li class="ico3_3"><a href=/accessControl.do?db_svr_id='+item.db_svr_id+' id="accessControl'+item.db_svr_id+'" onClick=javascript:fn_GoLink("accessControl'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_12.png" id="treeImg"><spring:message code="menu.access_control" /></a></li>';
					}
					if(aut.length != 0 && aut[index].policy_change_his_aut_yn == "Y"){
					html1+='					<li class="ico3_3"><a href=/accessControlHistory.do?db_svr_id='+item.db_svr_id+' id="accessControlHistory'+item.db_svr_id+'" onClick=javascript:fn_GoLink("accessControlHistory'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.policy_changes_history" /></a></li>';
					}			
					html1+='				</ul>';
					html1+='			</li>';
					html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg"><spring:message code="menu.audit_management"/></a>';
					html1+='				<ul class="depth_3">'
					if(aut.length != 0 && aut[index].adt_cng_aut_yn == "Y"){
						html1+='					<li class="ico3_4"><a href=/audit/auditManagement.do?db_svr_id='+item.db_svr_id+' id="auditManagement'+item.db_svr_id+'" onClick=javascript:fn_GoLink("auditManagement'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="menu.audit_settings" /></a></li>';
					}
					if(aut.length != 0 && aut[index].adt_hist_aut_yn == "Y"){
						html1+='					<li class="ico3_5"><a href=/audit/auditLogList.do?db_svr_id='+item.db_svr_id+' id="auditLogList'+item.db_svr_id+'" onClick=javascript:fn_GoLink("auditLogList'+item.db_svr_id+'"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.audit_history" /></a></li>';
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
		

		
	      function GetJsonDataConnector(data, aut) {      
	          var parseData = $.parseJSON(data);
	          var html = "";      
	         
// 	          for(var i=0; i<aut.length; i++){ 	  
// 		          if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000201"){	        	 
// 		        	  html += '<ul class="depth_1 lnbMenu"><li class="t1"><a href="/treeTransferSetting.do"><img src="../images/ico_lnb_4.png" id="treeImg">데이터 전송설정</a></li>';
// 		          }
// 	          }
	          $(data).each(function (index, item) {
	          html += '      <ul class="depth_1 lnbMenu"><li class="t2"><div class="border" ><a href="#n"><img src="../images/ico_lnb_5.png" id="treeImg"><div class="tooltip">'+item.cnr_nm+'<span class="tooltiptext">'+item.cnr_nm+'</span></div></a></div>';
	          html += '         <ul class="depth_2">';
	          html += '              <li class="ico2_3"><a href="/transferTarget.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" id="transferTarget'+item.cnr_id+'" onClick=javascript:fn_GoLink("transferTarget'+item.cnr_id+'"); target="main"><img src="../images/ico_lnb_8.png" id="treeImg"><spring:message code="menu.connector_settings" /></a></li>';
	          html += '            <li class="ico2_4"><a href="/transferDetail.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" id="transferDetail'+item.cnr_id+'" onClick=javascript:fn_GoLink("transferDetail'+item.cnr_id+'"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="menu.connector_run_stop" /></a></li>';
	          html += '         </ul></li></ul>';   
	          })      
	          html += '</ul>';
	          $( "#tree2" ).append(html);
	       }   
	      
	      
	      function Schedule(aut){
	    	  var html3="";
	    	  for(var i=0; i<aut.length; i++){ 	  
		          if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000101"){	      
	    	  	 html3 += '      <ul class="depth_1 lnbMenu"><li class="t2"><div class="border" ><a href="#n"><img src="../images/ico_lnb_14.png" id="treeImg"><div class="tooltip"><spring:message code="menu.schedule_information" /><span class="tooltiptext"><spring:message code="menu.schedule_information" /></span></div></a></div>';
	    	  	 html3 += '			<ul class="depth_2"><li class="ico2_2"><a href="/insertScheduleView.do" id="insertScheduleView" onClick=javascript:fn_GoLink("insertScheduleView"); target="main" ><img src="../images/ico_lnb_13.png" id="treeImg"><spring:message code="menu.schedule_registration" /></a></li>';
		          }
		          
		         if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000102"){
		        	 html3 += '         <li class="ico2_2"><a href="/selectScheduleListView.do" id="selectScheduleListView" onClick=javascript:fn_GoLink("selectScheduleListView"); target="main"><img src="../images/ico_lnb_11.png" id="treeImg"><spring:message code="etc.etc27"/></a></li>';
		          }
		         
		         if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000103"){
	    	 		 html3 += '         <li class="ico2_2"><a href="/selectScheduleHistoryView.do" id="selectScheduleHistoryView" onClick=javascript:fn_GoLink("selectScheduleHistoryView"); target="main"><img src="../images/ico_lnb_14.png" id="treeImg"><spring:message code="menu.shedule_execution_history" /></a></li></ul></li></ul>';
		          }
		      }

	          $( "#tree4" ).append(html3);
	      }
	      
	      
	      function fn_encryptMenuAut(result){
			var html4 = "";
			html4 += '<ul class="depth_1 lnbMenu">';
			html4 += '<li class="t2"><div class="border">';
			html4 += '<a href="#n"><img src="../images/ico_lnb_5.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_policy_management.Policy_Key_Management"/><span class="tooltiptext"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></span></div></a>';
			html4 += '</div>';
			html4 += '<ul class="depth_2">';
			if(result.length != 0 && result[0].read_aut_yn == "Y" && result[0].mnu_cd == "MN0001101"){
				html4 += '<li class="ico2_3"><a href="/securityPolicy.do" id="securityPolicy" onclick=fn_GoLink("securityPolicy"); target="main"><img src="../images/ico_lnb_8.png" id="treeImg"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></a></li>';
			}
			if(result.length != 0 && result[1].read_aut_yn == "Y" && result[1].mnu_cd == "MN0001102"){
				html4 += '<li class="ico2_3"><a href="/keyManage.do" id="keyManage" onclick=fn_GoLink("keyManage"); target="main"><img src="../images/ico_lnb_8.png" id="treeImg"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></a></li>';
			}
			html4 += '</ul>';
			html4 += '</li>';
			
			html4 += '<li class="t2"><div class="border">';
			html4 += '<a href="#n"><img src="../images/ico_lnb_5.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_log.Audit_Log"/><span class="tooltiptext"><spring:message code="encrypt_log.Audit_Log"/></span></div></a>';
			html4 += '</div>';
			html4 += '<ul class="depth_2">';
			if(result.length != 0 && result[2].read_aut_yn == "Y" && result[2].mnu_cd == "MN0001201"){
				html4 += '<li class="ico2_4"><a href="/encodeDecodeAuditLog.do"  id="encodeDecodeAuditLog" onclick=fn_GoLink("encodeDecodeAuditLog"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_log_decode.Encryption_Decryption"/></a></li>';
			}
			if(result.length != 0 && result[3].read_aut_yn == "Y" && result[3].mnu_cd == "MN0001202"){
				html4 += '<li class="ico2_4"><a href="/managementServerAuditLog.do" id="managementServerAuditLog" onclick=fn_GoLink("managementServerAuditLog"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_log_sever.Management_Server"/></a></li>';
			}
			if(result.length != 0 && result[4].read_aut_yn == "Y" && result[4].mnu_cd == "MN0001203"){
				html4 += '<li class="ico2_4"><a href="/encodeDecodeKeyAuditLog.do" id="encodeDecodeKeyAuditLog" onclick=fn_GoLink("encodeDecodeKeyAuditLog"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_policy_management.Encryption_Key"/></a></li>';
			}
			if(result.length != 0 && result[5].read_aut_yn == "Y" && result[5].mnu_cd == "MN0001204"){
				html4 += '<li class="ico2_4"><a href="/resourcesUseAuditLog.do" id="resourcesUseAuditLog" onclick=fn_GoLink("resourcesUseAuditLog"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg">자원사용</a></li>';
			}
			html4 += '</ul>';
			html4 += '</li>';
			
			
			html4 += '<li class="t2"><div class="border">';
			html4 += '<a href="#n"><img src="../images/ico_lnb_5.png" id="treeImg"><div class="tooltip"><spring:message code="encrypt_policyOption.Settings"/><span class="tooltiptext"><spring:message code="encrypt_policyOption.Settings"/></span></div></a>';
			html4 += '</div>';
			html4 += '<ul class="depth_2">';
			if(result.length != 0 && result[6].read_aut_yn == "Y" && result[6].mnu_cd == "MN0001301"){
				  html4 +='<li class="ico2_4"><a href="/securityPolicyOptionSet.do" id="securityPolicyOptionSet" onclick=fn_GoLink("securityPolicyOptionSet"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></a></li>';
			}
			if(result.length != 0 && result[7].read_aut_yn == "Y" && result[7].mnu_cd == "MN0001302"){
				html4 +='<li class="ico2_4"><a href="/securitySet.do" id="securitySet" onclick=fn_GoLink("securitySet"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_encryptSet.Encryption_Settings"/></a></li>';
			}
			if(result.length != 0 && result[8].read_aut_yn == "Y" && result[8].mnu_cd == "MN0001303"){
				html4 +='<li class="ico2_4"><a href="/securityKeySet.do" id="securityKeySet" onclick=fn_GoLink("securityKeySet"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></a></li>';
			}
			if(result.length != 0 && result[9].read_aut_yn == "Y" && result[9].mnu_cd == "MN0001304"){
				html4 +='<li class="ico2_4"><a href="/securityAgentMonitoring.do" id="securityAgentMonitoring" onclick=fn_GoLink("securityAgentMonitoring"); target="main"><img src="../images/ico_lnb_9.png" id="treeImg"><spring:message code="encrypt_agent.Encryption_agent_setting"/> </a></li>';
			}
			html4 += '</ul>';
			html4 += '</li>';
			html4 += '</ul>';
	    	  
	    	$( "#tree3" ).append(html4);
	      }
	      
		
	function fn_logout(){
		
		sessionStorage.removeItem('cssId');
		
		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();	
	}	
	
	
 	function fn_GoLink(url) {
 		var cssID = sessionStorage.getItem('cssId');

 		$("#"+cssID).css("background-color","");
 		$("#"+cssID).css("color","");
 		$("#"+cssID).css("padding","");
 		$("#"+cssID).css("border","");	
 		
 		if(url != null){
 			$("#"+url).css("background-color","#f58220");
 			$("#"+url).css("color","white");
 			$("#"+url).css("padding","3px");
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
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				location.reload();
			}
		})
 	}
    </script>


<script type="text/javascript" src="/js/jquery.mCustomScrollbar.concat.min.js"></script><!-- mCustomScrollbar -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/common_lnb.js"></script>

		<div id="lnb_menu">
			<form name="treeView" id="treeView">
				<div class="logout">
					    <div style="color: white; margin-bottom: 5%; font-size: 14px;"><%=(String)session.getAttribute("usr_nm")%><spring:message code="common.wellcome"/></div>		
					<a href="#"  target="_top"><button onClick="fn_logout();"><spring:message code="common.logout"/></button></a>		
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
				
			<div id="treeTitle"><img src="../images/ico_lnb_2.png" id="treeImg"><a href="/connectorRegister.do" target="main" onclick="fn_GoLink();"><spring:message code="menu.data_transfer" /></a>
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

			<div id="treeTitle" class="encrypt"><img src="../images/ico_lnb_2.png" id="treeImg"><a href="/securityPolicy.do" target="main" onclick="fn_GoLink();">데이터 암호화</a>
					<div id="sidetreecontrol3" style="float: right;">							
						<a href="?#"><img src="../images/ico_lnb_close.png"></a>
						<a href="?#"><img src="../images/ico_lnb_open.png"></a>
					</div>
			</div>
				
			<div id="sidetree">				
				<div class="treeborder">
					<ul id="tree">
						<div id="tree3"></div>  	 		
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
