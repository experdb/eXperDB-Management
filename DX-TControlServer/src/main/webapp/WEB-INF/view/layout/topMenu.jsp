<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<%
	String usr_id = (String)session.getAttribute("usr_id");
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body>
			<h1 class="logo"><a href="/index.do"><img src="../images/logo.png" alt="eXperDB" /></a></h1>
			<div id="gnb_menu">
				<h2 class="blind">주메뉴</h2>
				<ul class="depth_1" id="gnb">
					<li><a href="#n"><span><img src="../images/ico_gnb1.png" alt="FUNCTION" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">Scheduler</a>
								<ul class="depth_3">
									<li><a href="#n">스케쥴 설정</a></li>
									<li><a href="#n">스케쥴 조회</a></li>
								</ul>
							</li>
							<li><a href="#n">Transfer</a>
								<ul class="depth_3">
									<li><a href="/transferSetting.do" >전송 설정</a></li>
									<li><a href="/connectorRegister.do" >Connector 등록</a></li>
								</ul>
							</li>
						</ul>
					</li>
					<li><a href="#n"><span><img src="../images/ico_gnb2.png" alt="ADMIN" /></span></a>
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
					<li><a href="#n"><span><img src="../images/ico_gnb3.png" alt="MY PAGE" /></span></a>
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
					<li><a href="#n"><span><img src="../images/ico_help.png" alt="MY PAGE" /></span></a>
						<ul class="depth_2">
							<li><a href="#n">Online Help</a></li>
							<li><a href="#n">About Tconsole</a></li>
						</ul>
					</li>
				</ul>
			</div>





<%-- <div class='zeta-menu-bar'>
  <ul class="zeta-menu">
    <li><a href="/index.do" ><i class="fa fa-home"></i> DX-Tcontrol</a></li>
    <li><a href="#" >Dashboard<i class="fa fa-dashboard"></i></a></li>
    <li><a href="#">Functions</a>
         <ul>
            <li><a href="#">Scheduler</a>
	            <ul>
		            <li><a href="#">스케줄 설정</a></li>
		            <li><a href="#">스케줄 조회</a></li>
	          	</ul>
            </li>
            <li><a href="#">Transfer</a>
	            <ul>
		            <li><a href="/transferSetting.do" >전송 설정</a></li>
		            <li><a href="/connectorRegister.do" >Connector 등록</a></li>
	          	</ul>
            </li>
         </ul>
    </li>
    
    <li><a href="#">Admin</a>
      <ul>
        <li><a href="#">DB서버관리</a>
          <ul>
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
      </ul>
    </li>
    <li><a href="#">Help</a>
      <ul>
        <li><a href="#">Online Help</a></li>
        <li><a href="#">About Tcontrol</a></li>
      </ul>
    </li> 
     <li><a href="#">Sample</a>
      <ul>
		<li><a href="/selectSampleList.do" >SampleList</a></li>
		<li><a href="/sampleDatatableList.do" >Datatable</a></li>
		<li><a href="/selectsampleLocaleList.do" >Locale</a></li>
		<li><a href="/sampleTreeList.do" >Tree</a></li>
		<li><a href="/sampleRowsShuffle.do" >RowsShuffle</a></li>
      </ul>
    </li>
    <li><a href="#">MyPage</a>
      <ul>
        <li><a href="/myPage.do" >개인정보수정</a></li>
        <li><a href="#">My스케쥴</a></li>
      </ul>
    </li> 
    	<%
    		if(usr_id != null){
    	%>
   	<li>
    	<div align="left">
			<a href="/cmmnCodeList.do" >코드관리</a>
		</div>
	</li>	
	<li>		
    	<div align="left">
			<a href="logout.do" >로그아웃</a>
		</div>	
	</li>
		<%
    	}
		%>
  </ul>
</div> --%>

</body>
</html>