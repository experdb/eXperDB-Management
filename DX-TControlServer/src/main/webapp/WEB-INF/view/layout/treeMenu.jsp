<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.treeborder{
	overflow:auto;
	height:600px;
}

</style>

<link rel="stylesheet"
	href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<script src="/js/treeview/jquery.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.treeview.js" type="text/javascript"></script>


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

            $("#tree").treeview({
                collapsed: false,
                animated: "medium",
                control:"#sidetreecontrol",
                persist: "location"
            });
                     
        })
        

		function GetJsonData(data) {
			var parseData = $.parseJSON(data);
			$(data).each(function (index, item) {	
				var html = "";
				html+="<li><strong>"+item.db_svr_nm+"</strong>";
				html+="<ul><li>백업관리";
				html+="<ul><li><a href='/backup/rmanList.do?db_svr_id="+item.db_svr_id+"' onClick=javascript:fn_GoLink('/backup/rmanList.do?db_svr_id="+item.db_svr_id+"');>백업설정</a></li></ul>";
				html+="<ul><li><a href='/backup/rmanLogList.do?db_svr_id="+item.db_svr_id+"' onClick=javascript:fn_GoLink('/backup/rmanLogList.do?db_svr_id="+item.db_svr_id+"');>백업이력</a></li></ul>";
				html+="<ul><li><a href='?'>모니터링</a></li></ul></li></ul>";
				html+="<ul><li>접근제어관리<ul>";
				html+="<li><a href='?'>서버접근제어</a></li></ul></li></ul></li>";

				$( "#tree1" ).append(html);
			})
		}
	
 	function fn_GoLink(url) {	
 		$.cookie('menu_url' , url, { path : '/' });
 	}
    </script>

</head>
<body>
	<form name="treeView" id="treeView">
		<table border="1" width="250">
			<tr>
				<td>
					<div id="sidetree">				
						<div id="sidetreecontrol">
							<a href="?#">전체 닫기</a> | <a href="?#">전체 열기</a>
						</div>
						<div class="treeborder">
						<ul id="tree">
							<div id="tree1"></div>
						</ul>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>