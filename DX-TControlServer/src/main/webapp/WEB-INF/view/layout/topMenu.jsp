<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%
	String usr_id = (String)session.getAttribute("usr_id");
%>


<div id="header">
			<h1 class="logo"><a href="/index.do"><img src="/images/ico_logo_2.png" alt="eXperDB" /></a></h1>
			<div id="gnb_menu">
				<h2 class="blind">주메뉴</h2>
				<ul class="depth_1" id="gnb">
					<li><a href="#n"><span><img src="/images/ico_h_5.png" alt="FUNCTION" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">Scheduler</a>
								<ul class="depth_3">
									<li><a href="/insertScheduleView.do">스케쥴 등록</a></li>
									<li><a href="/selectScheduleListView.do">스케쥴 조회</a></li>
								</ul>
							</li>
							<li><a href="#n">Transfer</a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" >전송 설정</a></li>
									<li><a href="/connectorRegister.do" >Kafka-Connector 등록</a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_6.png" alt="ADMIN" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">DB 서버관리</a>
								<ul class="depth_3">
									<li><a href="/dbTree.do" >DB Tree</a></li>
									<li><a href="/dbServer.do" >DB 서버</a></li>
									<li><a href="/database.do" >Database</a></li>
								</ul>
							</li>						
						    <li><a href="/userManager.do" >사용자관리</a></li>
					        <li><a href="/menuAuthority.do" >메뉴권한관리</a></li>
					        <li><a href="/dbAuthority.do" >DB권한관리</a></li>
					        <li><a href="/accessHistory.do" >화면접근이력</a></li>
					        <li><a href="/agentMonitoring.do" >Agent 모니터링</a></li>
							<li><a href="#n">확장설치 조회</a></li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="/images/ico_h_7.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
							<li><a href="/myPage.do" >개인정보수정</a></li>
        					<li><a href="#">My스케쥴</a></li>
						</ul>
					</li>
					<%
			    		if(usr_id != null){
			    	%>
			   	<li>
						<a href="/cmmnCodeList.do" >코드관리</a>
				</li>	
					<%
			    	}
					%>
					<li><a href="#n"><span><img src="/images/ico_h_8.png" alt="HELP" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">Online Help</a></li>
							<li><a href="#n">About Tconsole</a></li>
						</ul>
					</li>
				</ul>
			</div>
</div>

