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
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			for(var i = 0; i<result.length; i++){ 
				
			 	if((result[9].mnu_cd == "MN000101" &&  result[9].read_aut_yn == "N") &&  (result[10].mnu_cd == "MN000102" && result[10].read_aut_yn == "N") && (result[11].mnu_cd == "MN000103" && result[11].read_aut_yn == "N")){
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
				
			 	if((result[12].mnu_cd == "MN000201" &&  result[12].read_aut_yn == "N") &&  (result[13].mnu_cd == "MN000202" && result[13].read_aut_yn == "N")){
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
				
 				if((result[14].mnu_cd == "MN000301" &&  result[14].read_aut_yn == "N") &&  (result[15].mnu_cd == "MN000302" && result[15].read_aut_yn == "N") && (result[16].mnu_cd == "MN000303" && result[16].read_aut_yn == "N")){
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
				}else if(result[i].mnu_cd == "MN0005"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0005").style.display = 'none';
					}else{
						 document.getElementById("MN0005").style.display = '';
					}	
				}else if(result[i].mnu_cd == "MN0006"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0006").style.display = 'none';
					}else{
						 document.getElementById("MN0006").style.display = '';
					}
				}else if(result[i].mnu_cd == "MN0007"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0007").style.display = 'none';
					}else{
						 document.getElementById("MN0007").style.display = '';
					}
				}else if(result[i].mnu_cd == "MN0008"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0008").style.display = 'none';
					}else{
						 document.getElementById("MN0008").style.display = '';
					}
				}else if(result[i].mnu_cd == "MN0009"){
					if(result[i].read_aut_yn == "N"){
						 document.getElementById("MN0009").style.display = 'none';
					}else{
						 document.getElementById("MN0009").style.display = '';
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

<div id="header">
			<h1 class="logo"><a href="/index.do" onClick="fn_cookie(null)"><img src="/images/ico_logo_2.png" alt="eXperDB" /></a></h1>
			<div id="gnb_menu">
				<h2 class="blind">주메뉴</h2>
				<ul class="depth_1" id="gnb">
					<li><a href="#n"><span><img src="/images/ico_h_5.png" alt="FUNCTION" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0001">Scheduler</a>
								<ul class="depth_3">
									<li><a href="/insertScheduleView.do" onClick="fn_cookie(null)" id="MN000101">스케쥴 등록</a></li>
									<li><a href="/selectScheduleListView.do" onClick="fn_cookie(null)" id="MN000102">스케쥴 조회</a></li>
									<li><a href="/selectScheduleHistoryView.do" onClick="fn_cookie(null)" id="MN000103">스케쥴 이력</a></li>
								</ul>
							</li>
							<li><a href="#n" id="MN0002">Transfer</a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" onClick="fn_cookie(null)" id="MN000201">전송 설정</a></li>
									<li><a href="/connectorRegister.do" onClick="fn_cookie(null)" id="MN000202">Kafka-Connector 등록</a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_6.png" alt="ADMIN" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" id="MN0003">DB 서버관리</a>
								<ul class="depth_3">
									<li><a href="/dbTree.do" onClick="fn_cookie(null)" id="MN000301">DB Tree</a></li>
									<li><a href="/dbServer.do" onClick="fn_cookie(null)" id="MN000302">DB 서버</a></li>
									<li><a href="/database.do" onClick="fn_cookie(null)" id="MN000303">Database</a></li>
								</ul>
							</li>				
						    <li><a href="/userManager.do" onClick="fn_cookie(null)" id="MN0004">사용자관리</a></li>
					        <li><a href="/menuAuthority.do" onClick="fn_cookie(null)" id="MN0005">메뉴권한관리</a></li>
					        <li><a href="/dbAuthority.do" onClick="fn_cookie(null)" id="MN0006">DB권한관리</a></li>
					        <li><a href="/accessHistory.do" onClick="fn_cookie(null)" id="MN0007">화면접근이력</a></li>
					        <li><a href="/agentMonitoring.do" onClick="fn_cookie(null)" id="MN0008">Agent 모니터링</a></li>
							<li><a href="/extensionList.do" onClick="fn_cookie(null)" id="MN0009">확장설치 조회</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_7.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
							<li><a href="/myPage.do" onClick="fn_cookie(null)">개인정보수정</a></li>
        					<li><a href="/myScheduleListView.do" onClick="fn_cookie(null)">My스케쥴</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_8.png" alt="HELP" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" onClick="fn_cookie(null)">Online Help</a></li>
							<li><a href="#n" onClick="fn_cookie(null)">About Tconsole</a></li>
						</ul>
					</li>
				</ul>
			</div>
</div>

