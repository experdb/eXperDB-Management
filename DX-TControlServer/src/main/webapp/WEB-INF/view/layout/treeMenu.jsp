<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
.tooltip {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black;
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
	$(window.document).ready(   		
		function() {	
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
						alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
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
						alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {
					fn_usrMenuAut(result);
				}
			});  
   			
   			
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
                control:"#sidetreecontrol",
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				Schedule(result);
				GetJsonDataConnector(data, result);
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
 					if(aut.length != 0 && aut[index].bck_cng_aut_yn != "N" && aut[index].bck_hist_aut_yn != "N" && aut[index].acs_cntr_aut_yn != "N" && aut[index].adt_cng_aut_yn != "N" && aut[index].adt_hist_aut_yn != "N" ){			
					html1+='<ul class="depth_1 lnbMenu">';
					//html1+='	<li><div class="border" style="overflow: hidden;white-space: nowrap;text-overflow: ellipsis;" ><a href="#n" onClick=javascript:fn_GoLink("#n");><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip">'+item.db_svr_nm+'<span class="tooltiptext">'+item.db_svr_nm+'</span></div></a></div>';
					html1+='	<li><div class="border"  ><a href="#n" onClick=javascript:fn_GoLink("#n");><img src="../images/ico_lnb_3.png" id="treeImg"><div class="tooltip">'+item.db_svr_nm+'<span class="tooltiptext">'+item.db_svr_nm+'</span></div></a></div>';
					html1+='		<ul class="depth_2">';
					html1+='			<li class="ico2_1"><a href="#n"><img src="../images/ico_lnb_6.png" id="treeImg">백업관리</a>';
					html1+='				<ul class="depth_3">';
					if(aut.length != 0 && aut[index].bck_cng_aut_yn == "Y"){
						html1+='					<li class="ico3_1"><a href=/backup/workList.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/backup/workList.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_10.png" id="treeImg">백업설정</a></li>';
					}
					if(aut.length != 0 && aut[index].bck_hist_aut_yn == "Y"){
						html1+='					<li class="ico3_2"><a href=/backup/workLogList.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/backup/workLogList.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_11.png" id="treeImg">백업이력</a></li>';
					}
					html1+='			<li class="ico2_2"><a href=/schedulerView.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/schedulerView.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_main_tit_1.png" id="treeImg">백업스케줄러</a>';
					html1+='				</ul>';
					html1+='			</li>';
					html1+='			<li class="ico2_2"><a href="#n"><img src="../images/ico_lnb_7.png" id="treeImg">접근제어관리</a>';
					html1+='				<ul class="depth_3">';
					if(aut.length != 0 && aut[index].acs_cntr_aut_yn == "Y"){
						html1+='					<li class="ico3_3"><a href=/accessControl.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/accessControl.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_12.png" id="treeImg">접근제어</a></li>';
					}
					html1+='					<li class="ico3_3"><a href=/accessControlHistory.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/accessControlHistory.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_14.png" id="treeImg">접근제어이력</a></li>';
					if(aut.length != 0 && aut[index].adt_cng_aut_yn == "Y"){
						html1+='					<li class="ico3_4"><a href=/audit/auditManagement.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/audit/auditManagement.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_13.png" id="treeImg">감사설정</a></li>';
					}
					if(aut.length != 0 && aut[index].adt_hist_aut_yn == "Y"){
						html1+='					<li class="ico3_5"><a href=/audit/auditLogList.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink("/audit/auditLogList.do?db_svr_id='+item.db_svr_id+'");><img src="../images/ico_lnb_14.png" id="treeImg">감사이력</a></li>';
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
	          html += '              <li class="ico2_3"><a href="/transferTarget.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" onClick=javascript:fn_GoLink("/transferTarget.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'");><img src="../images/ico_lnb_8.png" id="treeImg">커넥터 설정</a></li>';
	          html += '            <li class="ico2_4"><a href="/transferDetail.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'" onClick=javascript:fn_GoLink("/transferDetail.do?cnr_id='+item.cnr_id+'&&cnr_nm='+item.cnr_nm+'");><img src="../images/ico_lnb_9.png" id="treeImg">전송대상 설정</a></li>';
	          html += '         </ul></li></ul>';   
	          })      
	          html += '</ul>';
	          $( "#tree2" ).append(html);
	       }   
	      
	      
	      function Schedule(aut){
	    	  for(var i=0; i<aut.length; i++){ 	  
		          if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000101"){	      
	    	  var html3 = '      <ul class="depth_1 lnbMenu"><li class="ico2_2"><a href="/insertScheduleView.do" onClick=javascript:fn_GoLink("/insertScheduleView.do");><img src="../images/ico_lnb_13.png" id="treeImg">스케줄 등록</a></li></ul>';
		          }else if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000102"){
	    	  html3 += '         <ul class="depth_1 lnbMenu"><li class="ico2_2"><a href="/selectScheduleListView.do" onClick=javascript:fn_GoLink("/selectScheduleListView.do");><img src="../images/ico_lnb_11.png" id="treeImg">스케줄 관리</a></li></ul>';
		          }else if(aut.length != 0 && aut[i].read_aut_yn == "Y" && aut[i].mnu_cd == "MN000103"){
	    	  html3 += '         <ul class="depth_1 lnbMenu"><li class="ico2_2"><a href="/selectScheduleHistoryView.do" onClick=javascript:fn_GoLink("/selectScheduleHistoryView.do");><img src="../images/ico_lnb_14.png" id="treeImg">스케줄 수행이력</a></li></ul>';
	    	  	}
		      }
	          $( "#tree3" ).append(html3);
	      }
		
	function fn_logout(){
		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();	
	}	
	
	
 	function fn_GoLink(url) {	
 		$.cookie('menu_url' , url, { path : '/' });
 	}
    </script>


<script type="text/javascript" src="/js/jquery.mCustomScrollbar.concat.min.js"></script><!-- mCustomScrollbar -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/common_lnb.js"></script>


	<div id="lnb_menu">
		<form name="treeView" id="treeView">
				<div class="logout">
					<div style="color: white; margin-bottom: 5%;"><%=(String)session.getAttribute("usr_nm")%>님 환영합니다.</div>
					<a href="#"><button onClick="fn_logout();">LOGOUT</button></a>
				</div>
				<div id="treeTitle"><img src="../images/ico_lnb_1.png" id="treeImg"><a href="/dbTree.do">DB 서버</a>
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
				
				<div id="treeTitle"><img src="../images/ico_main_tit_1.png" id="treeImg"><a href="/selectScheduleListView.do">스케줄</a>
				</div>	
				<div id="sidetree">						
						<div class="treeborder">
						<ul id="tree">
							<div id="tree3"></div>
						</ul>
						</div>
				</div>
				
				<div id="treeSub"><img src="../images/ico_lnb_2.png" id="treeImg"><a href="/connectorRegister.do">데이터 전송</a>
						<div id="sidetreecontrol2" style="float: right;">							
							<a href="?#"><img src="../images/ico_lnb_close.png"></a>
							<a href="?#"><img src="../images/ico_lnb_open.png"></a>
						</div>
				</div>
				<div id="sidetree1">				
			
						<div class="treeborder">
						<ul id="tree2">
							<div id="tree2"></div>
						</ul>
						</div>
				</div>
		</form>
</div>




