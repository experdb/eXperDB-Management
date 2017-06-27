<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script> 
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<%-- <link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<script src="/js/treeview/jquery.js" type="text/javascript"></script> --%>
<!-- <script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script> -->
<!-- <script src="/js/treeview/jquery.treeview.js" type="text/javascript"></script> -->

<script type="text/javascript">
	$(window.document).ready(   
		function() {	
   			$.ajax({
				async : false,
				url : "/selectSampleTreeList.do",
			  	data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패");
				},
				success : function(result) {
					GetJsonData(result)
				}
			});   
   			
   			/*Tree Connector 조회*/
   			$.ajax({
				async : false,
				url : "/selectTreeConnectorRegister.do",
			  	data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패");
				},
				success : function(result) {
					//GetJsonDataConnector(result)
				}
			});      
        });
        

		function GetJsonData(data) {
			var parseData = $.parseJSON(data);
			//var parseData = JSON.stringify((data));
			
	/* 		var html = "";
 			html += 'DB 서버';
			html += '<div class="all_btn">';
			html += '<a href=# class="all_close">전체 닫기</a>';
			html += '<a href=# class="all_open">전체 열기</a>';
			html += '</div>'; */

			
 			$(data).each(function (index, item) {
				var html = "";
				html+='	<li><a href="#n">'+item.db_svr_nm+'</a>';
				html+='		<ul class="depth_2">';
				html+='			<li class="ico2_1"><a href="#n">백업관리</a>';
				html+='				<ul class="depth_3">';
				html+='					<li class="ico3_1"><a href=/backup/rmanList.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink(/backup/rmanList.do?db_svr_id='+item.db_svr_id+');>백업설정</a></li>';
				html+='					<li class="ico3_2"><a href=/backup/rmanLogList.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink(/backup/rmanLogList.do?db_svr_id='+item.db_svr_id+');>백업이력</a></li>';
				html+='				</ul>';
				html+='			</li>';
				html+='			<li class="ico2_2"><a href="#n">접근제어관리</a>';
				html+='				<ul class="depth_3">';
				html+='					<li class="ico3_3"><a href=/accessControl.do?db_svr_id='+item.db_svr_id+' onClick=javascript:fn_GoLink(/serverAccessControl?db_svr_id='+item.db_svr_id+');>서버접근제어</a></li>';
				html+='					<li class="ico3_4"><a href="#n">감사설정</a></li>';
				html+='					<li class="ico3_5"><a href="#n">감사이력</a></li>';
				html+='				</ul>';
				html+='			</li>';
				html+='		</ul>';
				html+='	</li>';			
				$( "#tree1" ).append(html);
			})		 
		}
		
	
	
		function GetJsonDataConnector(data) {						
			var parseData = $.parseJSON(data);
			//var parseData = JSON.stringify((data))			
/* 			html += '<div class="lnb_tit">Transfer';
			html += '		<div class="all_btn">';
			html += '			<a href="#n" class="all_close">전체 닫기</a>';
			html += '			<a href="#n" class="all_open">전체 열기</a>';
			html += '		</div>';
			html += '</div>'; */
			$(data).each(function (index, item) {	
				var html = "";
				html += '<ul class="depth_1 lnbMenu">';
				html += '		<li class="t1"><a href="#n">전송설정</a></li>';
				html += '		<li class="t2"><a href="#n">'+item.cnr_nm+'</a>';
				html += '			<ul class="depth_2">';
				html += '				<li class="ico2_3"><a href="#n">전송대상 설정</a></li>';
				html += '				<li class="ico2_4"><a href="#n">전송상세 설정</a></li>';
				html += '			</ul>';
				html += '		</li>';
				html += '	</ul>';
				$( "#tree2" ).append(html);
			})
			
		}	
	
		
	function fn_logout(){
		var frm = document.treeView;
		frm.action = "/logout.do";
		frm.submit();	
	}	
    </script>

</head>
<body>
	<!-- container -->
	<div id="container">
		<form name="treeView" id="treeView">

			<!-- lnb -->
			<div id="lnb_menu">
				<div class="logout">
					<button onClick="fn_logout();">LOGOUT</button>
				</div>
				<h3 class="blind">LNB 메뉴</h3>
				<div class="lnb">
					<div class="inr">
						<div class="lnb_tit" >
 							DB 서버
							<div class="all_btn">
								<a href="#n" class="all_close">전체 닫기</a> 
								<a href="#n"class="all_open">전체 열기</a>
							</div>
						</div>
						
 						<ul class="depth_1 lnbMenu"  id="tree1">
				<!-- 			<li><a href="#n">PG Server5</a>
								<ul class="depth_2">
									<li class="ico2_1"><a href="#n">백업관리</a>
										<ul class="depth_3">
											<li class="ico3_1"><a href="#n">백업 DB설정</a></li>
											<li class="ico3_2"><a href="#n">모니터링</a></li>
										</ul></li>
									<li class="ico2_2"><a href="#n">접근제어관리</a>
										<ul class="depth_3">
											<li class="ico3_3"><a href="#n">서버접근제어</a></li>
											<li class="ico3_4"><a href="#n">감사설정</a></li>
											<li class="ico3_5"><a href="#n">감사이력</a></li>
										</ul></li>
								</ul></li> -->
						</ul> 
						
					</div>
					<div class="inr type2">
						<div class="lnb_tit">
							Transfer
							<div class="all_btn">
								<a href="#n" class="all_close">전체 닫기</a> 
								<a href="#n" class="all_open">전체 열기</a>
							</div>
						</div>
						<ul class="depth_1 lnbMenu">
							<li class="t1"><a href="#n">전송설정</a></li>
							<li class="t2"><a href="#n">Connector1</a>
								<ul class="depth_2">
									<li class="ico2_3"><a href="#n">전송대상 설정</a></li>
									<li class="ico2_4"><a href="#n">전송상세 설정</a></li>
								</ul></li>
						</ul>
					</div>
				</div>
			</div>
			<!-- // lnb -->
		</form>
	</div>
</body>
</html>