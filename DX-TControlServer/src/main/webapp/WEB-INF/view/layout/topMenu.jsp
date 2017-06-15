<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String usr_id = (String)session.getAttribute("usr_id");
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>Insert title here</title>
<style>
.zeta-menu-bar {
  background: white;
  display: block;
  width: 100%;
  position:relative;
  z-index:10;
}
.zeta-menu { margin: 0; padding: 0; }
.zeta-menu li {
  float: left;
  list-style:none;
  position: relative;
}
.zeta-menu li:hover { background: transparent; }
.zeta-menu li:hover>a { color: gray; }
.zeta-menu a {
  color: black;
  display: block;
  padding: 10px 20px;
  text-decoration: none;
}
.zeta-menu ul {
  background: #eee;
  border: 1px solid silver;
  display: none;
  padding: 0;
  position: absolute;
  left: 0;
  top: 100%;
  width: 180px;
}
.zeta-menu ul li { float: none; }
.zeta-menu ul li:hover { background: #ddd; } 
.zeta-menu ul li:hover a { color: black; }
.zeta-menu ul a { color: black; }
.zeta-menu ul ul { left: 100%; top: 0; }
.zeta-menu ul ul li {float:left; margin-right:10px;}

a:link {
	text-decoration: none;
}

</style>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script>
$(function(){
  $(".zeta-menu li").hover(function(){
    $('ul:first',this).show();
  }, function(){
    $('ul:first',this).hide();
  });
  $(".zeta-menu>li:has(ul)>a").each( function() {
    $(this).html( $(this).html()+' &or;' );
  });
  $(".zeta-menu ul li:has(ul)")
    .find("a:first")
    .append("<p style='float:right;margin:-3px'>&#9656;</p>");
});

	function fn_cookie(url) {
		$.cookie('menu_url' , url, { path : '/' });
	}
	
</script>
</head>
<body>

<div class='zeta-menu-bar'>
  <ul class="zeta-menu">
    <li><a href="/index.do" onClick="fn_cookie(null)"><i class="fa fa-home"></i> DX-Tcontrol</a></li>
    <li><a href="#" onClick="fn_cookie(null)">Dashboard<i class="fa fa-dashboard"></i></a></li>
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
		            <li><a href="/transferSetting.do" onClick="fn_cookie(null)">전송 설정</a></li>
		            <li><a href="/connectorRegister.do" onClick="fn_cookie(null)">Connector 등록</a></li>
	          	</ul>
            </li>
         </ul>
    </li>
    
    <li><a href="#">Admin</a>
      <ul>
        <li><a href="#">DB서버관리</a>
          <ul>
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
		<li><a href="/selectSampleList.do" onClick="fn_cookie(null)">SampleList</a></li>
		<li><a href="/sampleDatatableList.do" onClick="fn_cookie(null)">Datatable</a></li>
		<li><a href="/selectsampleLocaleList.do" onClick="fn_cookie(null)">Locale</a></li>
		<li><a href="/sampleTreeList.do" onClick="fn_cookie(null)">Tree</a></li>
		<li><a href="/sampleRowsShuffle.do" onClick="fn_cookie(null)">RowsShuffle</a></li>
      </ul>
    </li>
    	<%
    		if(usr_id != null){
    	%>
   	<li>
    	<div align="left">
			<a href="/cmmnCodeList.do" onClick="fn_cookie(null)">코드관리</a>
		</div>
	</li>	
	<li>		
    	<div align="left">
			<a href="logout.do" onClick="fn_cookie(null)">로그아웃</a>
		</div>	
	</li>
		<%
    	}
		%>
  </ul>
</div>

</body>
</html>