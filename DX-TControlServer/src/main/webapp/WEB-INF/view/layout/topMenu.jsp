<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
	String usr_id = (String)session.getAttribute("usr_id");
%>
<script>

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
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
							
				if((result[19].mnu_cd == "MN000701" &&  result[19].read_aut_yn == "N")) {
 					document.getElementById("MN0007").style.display = 'none';
				}else{
					document.getElementById("MN0007").style.display = '';
					if(result[i].mnu_cd == "MN000701"){
						if(result[i].read_aut_yn == "N"){
							 document.getElementById("MN000701").style.display = 'none';
						}else{
							 document.getElementById("MN000701").style.display = '';
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
			}
		}
	});    
});


function fn_cookie(url) {
	$.cookie('menu_url' , url, { path : '/' });
}
</script>
<%@include file="../help/aboutExperdbLayer.jsp"%>
<div id="header">
			<h1 class="logo"><a href="/index.do" onClick="fn_cookie(null)"><img src="/images/ico_logo_2.png" alt="eXperDB" /></a></h1>
			<div id="gnb_menu">
				<h2 class="blind">주메뉴</h2>
				<ul class="depth_1" id="gnb">
					<li><a href="#n"><span><img src="/images/ico_h_5.png" alt="FUNCTION" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0001">스케줄정보</a>
								<ul class="depth_3">
									<li><a href="/insertScheduleView.do" onClick="fn_cookie(null)" id="MN000101">스케줄 등록</a></li>
									<li><a href="/selectScheduleListView.do" onClick="fn_cookie(null)" id="MN000102">스케줄 실행/중지</a></li>
									<li><a href="/selectScheduleHistoryView.do" onClick="fn_cookie(null)" id="MN000103">스케줄 수행이력</a></li>
								</ul>
							</li>
							<li><a href="#n" id="MN0002">데이터전송정보</a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" onClick="fn_cookie(null)" id="MN000201">전송서버설정</a></li>
									<li><a href="/connectorRegister.do" onClick="fn_cookie(null)" id="MN000202">커넥터 관리</a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_6.png" alt="ADMIN" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0003">DBMS 정보</a>
								<ul class="depth_3">
									<li><a href="/dbTree.do" onClick="fn_cookie(null)" id="MN000301">DBMS 등록</a></li>
									<li><a href="/dbServer.do" onClick="fn_cookie(null)" id="MN000302">DBMS 관리</a></li>
									<li><a href="/database.do" onClick="fn_cookie(null)" id="MN000303">Database 관리</a></li>
								</ul>
							</li>				
						    <li><a href="/userManager.do" onClick="fn_cookie(null)" id="MN0004">사용자관리</a></li>
							<li><a href="#n" id="MN0005">권한관리</a>
					        	<ul class="depth_3">
									<li><a href="/menuAuthority.do" onClick="fn_cookie(null)" id="MN000501">메뉴권한관리</a></li>
									<li><a href="/dbServerAuthority.do" onClick="fn_cookie(null)" id="MN000502">서버권한관리</a></li>
									<li><a href="/dbAuthority.do" onClick="fn_cookie(null)" id="MN000503">DB권한관리</a></li>									
								</ul>
					        </li>	        					        
					        <li><a href="#n" id="MN0006">이력관리</a>
					        	<ul class="depth_3">
									<li><a href="/accessHistory.do" onClick="fn_cookie(null)" id="MN000601">화면접근이력</a></li>
								</ul>
					        </li>
					        <li><a href="#n" id="MN0007">모니터링</a>
					        	<ul class="depth_3">
									<li><a href="/agentMonitoring.do" onClick="fn_cookie(null)" id="MN000701">에이전트 모니터링</a></li>
								</ul>
					        </li>
							<li><a href="/extensionList.do" onClick="fn_cookie(null)" id="MN0008">확장팩설치 정보</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_7.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
							<li><a href="/myPage.do" onClick="fn_cookie(null)">사용자정보관리</a></li>
        					<li><a href="/myScheduleListView.do" onClick="fn_cookie(null)">My스케줄 관리</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_8.png" alt="HELP" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" onClick="fn_cookie(null)">Online Help</a></li>
							<li><a href="#n" onClick="fn_aboutExperdb()">About eXperDB</a></li>
						</ul>
					</li>
				</ul>
			</div>
</div>

