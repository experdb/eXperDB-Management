<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/jquery-ui.css'/>"/>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>"/>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/json2.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.treeview.js" type="text/javascript"></script>

<script type="text/javascript">
var table = null;

function fn_init(){
   	table = $('#logList').DataTable({	
		scrollY: "300px",	
		"processing": true,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "db_nm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "exe_rslt_cd", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "bck_file_pth", className: "dt-center", defaultContent: ""},
 		         	{ data: "file_sz", className: "dt-center", defaultContent: ""}
 		        ] 
	});
}

$(window.document).ready(function() {
	fn_init();
	
	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		bck_bsn_dscd : "rman"
	  	},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
	
	$( ".datepicker" ).datepicker({
		dateFormat: 'yy-mm-dd'
 	});
});

function fn_find_list(){
	var bck_opt_cd = $("#bck_opt_cd").val();
	var wrk_strt_dtm = $("#wrk_strt_dtm").val();
	var wrk_end_dtm = $("#wrk_end_dtm").val();
	var exe_rslt_cd = $("#exe_rslt_cd").val();
	
	//fn_init();

	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		bck_bsn_dscd : "rman",
	  		db_id : db_id,
	  		wrk_strt_dtm : wrk_strt_dtm,
	  		wrk_end_dtm : wrk_end_dtm,
	  		exe_rslt_cd : exe_rslt_cd
	  	},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}

$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
});
</script>
</head>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><a href="/backup/rmanLogList.do?db_svr_id=${db_svr_id}"> RMAN 백업이력</a></li>			
				<li><img
					src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
					alt="" /> DUMP 백업이력</li>
			</ul>
		</div>
		<!-- // 검색창 -->
		<form name="findList" id="findList" method="post">
		<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
		<div id="search">
		작업기간 : <input type="text" name="wrk_strt_dtm" id="wrk_strt_dtm" class="datepicker" readonly style="width:80px;"/> ~ <input type="text" name="wrk_end_dtm" id="wrk_end_dtm" class="datepicker" readonly style="width:80px;"/>
		상태 : <select name="exe_rslt_cd" id="exe_rslt_cd">
					<option value="">선택</option>
					<option value="S">성공</option>
					<option value="F">실패</option>
				</select>
		Database명 : <select name="db_id" id="db_id">
			<option value="">선택</option>
			<c:forEach var="result" items="${dbList}" varStatus="status">
			<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
			</c:forEach>
		</select>				
		</div>
		<div  style="margin-bottom:50px;text-align:center;float:right;">
				<span class="btn_blue_l">
					<a href="javascript:fn_find_list();">조회</a> <img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" style="margin-left: 6px;" alt="" />
				</span>
		</div>
		</form>
		<!-- // 검색창 -->		
		<!-- // 타이틀 -->
		<table id="logList" class="display" cellspacing="0" width="100%">
	        <thead>
	            <tr>
	                <th>No</th>
	                <th>DATABASE</th>
	                <th>작업시작시간</th>
	                <th>작업종료시간</th>
	                <th>상태</th>
	                <th>백업파일경로</th>
	                <th>Size</th>
	            </tr>
	        </thead>
	    </table>
		
		
	</div>
</body>
</html>