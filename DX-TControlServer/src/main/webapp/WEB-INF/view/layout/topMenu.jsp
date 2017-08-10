<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
	String usr_id = (String)session.getAttribute("usr_id");
%>
<script>
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
							<li><a href="#n">Scheduler</a>
								<ul class="depth_3">
									<li><a href="/insertScheduleView.do" onClick="fn_cookie(null)">스케쥴 등록</a></li>
									<li><a href="/selectScheduleListView.do" onClick="fn_cookie(null)">스케쥴 조회</a></li>
									<li><a href="/selectScheduleHistoryView.do" onClick="fn_cookie(null)">스케쥴 이력</a></li>
								</ul>
							</li>
							<li><a href="#n">Transfer</a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" onClick="fn_cookie(null)">전송 설정</a></li>
									<li><a href="/connectorRegister.do" onClick="fn_cookie(null)">Kafka-Connector 등록</a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_6.png" alt="ADMIN" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">DB 서버관리</a>
								<ul class="depth_3">
									<li><a href="/dbTree.do" onClick="fn_cookie(null)">DB Tree</a></li>
									<li><a href="/dbServer.do" onClick="fn_cookie(null)">DB 서버</a></li>
									<li><a href="/database.do" onClick="fn_cookie(null)">Database</a></li>
								</ul>
							</li>						
						    <li><a href="/userManager.do" onClick="fn_cookie(null)">사용자관리</a></li>
					        <li><a href="/menuAuthority.do" onClick="fn_cookie(null)">메뉴권한관리</a></li>
					        <li><a href="/dbAuthority.do" onClick="fn_cookie(null)">DB권한관리</a></li>
					        <li><a href="/accessHistory.do" onClick="fn_cookie(null)">화면접근이력</a></li>
					        <li><a href="/agentMonitoring.do" onClick="fn_cookie(null)">Agent 모니터링</a></li>
							<li><a href="/extensionList.do" onClick="fn_cookie(null)">확장설치 조회</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_7.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
							<li><a href="/myPage.do" onClick="fn_cookie(null)">개인정보수정</a></li>
        					<li><a href="#" onClick="fn_cookie(null)">My스케쥴</a></li>
						</ul>
					</li>
					<%
			    		if(usr_id != null){
			    	%>
			   	<li>
						<a href="/cmmnCodeList.do" onClick="fn_cookie(null)">코드관리</a>
				</li>	
					<%
			    	}
					%>
					<li><a href="#n"><span><img src="/images/ico_h_8.png" alt="HELP" /></span></a>
						<ul class="depth_2">
							<li><a href="#n" onClick="fn_cookie(null)">Online Help</a></li>
							<li><a href="#n" onClick="fn_cookie(null)">About Tconsole</a></li>
						</ul>
					</li>
				</ul>
			</div>
</div>

