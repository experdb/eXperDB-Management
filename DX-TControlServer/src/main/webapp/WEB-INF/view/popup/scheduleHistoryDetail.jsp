<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : scheduleHistoryDetail.jsp
	* @Description : scheduleHistoryDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.10.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.10.24
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>스케줄수행이력 상세보기</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>
var schTable = null;
var workTable = null;

function fn_init() {
	schTable = $('#schTable').DataTable({
		scrollY : "60px",
		searching : false,
		paging: false,
		columns : [
		{ data : "scd_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "scd_exp", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_end_dtm", className : "dt-center", defaultContent : ""}, 
		{ data : "", className : "dt-center", defaultContent : ""}
		]
	});

    
    workTable = $('#workTable').DataTable({
		scrollY : "180px",
		searching : false,
		paging: false,
		columns : [
		{ data : "rownum", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_exp", className : "dt-center", defaultContent : ""}, 
		{ data : "", className : "dt-center", defaultContent : ""},  
		{ data : "", className : "dt-center", defaultContent : ""},
		{ data : "", className : "dt-center", defaultContent : ""}
		]
	});
 
}

$(window.document).ready(function() {
	fn_init();
	$.ajax({
		url : "/selectScheduleHistoryDetail.do",
		data : {
			exe_sn : "${exe_sn}"
		},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(result) {
			schTable.clear().draw();
			schTable.rows.add(result).draw();
		}
	});
	
	$.ajax({
		url : "/selectScheduleHistoryWorkDetail.do",
		data : {
			exe_sn : "${exe_sn}"
		},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(result) {
			workTable.clear().draw();
			workTable.rows.add(result).draw();
		}
	});
});
</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">스케줄수행이력 상세보기</p>
			<div class="pop_cmm3">
				<p class="pop_s_tit">스케줄정보</p>
				<div class="overflow_area" style="height: 160px;">
					<table id="schTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>스케줄명</th>
								<th>스케줄설명</th>
								<th>작업시작일시</th>
								<th>작업종료일시</th>
								<th>총작업시간</th>
							</tr>
						</thead>
					</table>
				</div>
				<br><br>
				<p class="pop_s_tit">work정보</p>
				<div class="overflow_area" style="height: 290px;">
					<table id="workTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th>No</th>
								<th>work명</th>
								<th>work설명</th>
								<th>작업시작일시</th>
								<th>작업종료일시</th>
								<th>총작업시간</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
<div id="loading"><img src="/images/spin.gif" alt="" /></div>
</body>
</html>