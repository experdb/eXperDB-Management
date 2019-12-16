<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : db2pgResultDDL.jsp
	* @Description : db2pgResultDDL 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.11.29     최초 생성
	*
	* author 김주영 사원
	* since 2019.11.29
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DDL 수행이력 상세보기</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>" />
<script src="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>

var table = null;
function fn_init() {
		table = $('#fileList').DataTable({
		scrollY : "245px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "idx", className : "dt-center", defaultContent : ""},
		{
			data : "idx",
			className : "dt-center",
			render : function(data, type, full, meta) {
				var html = "";
				html += "<span class='btn btnC_01 btnF_02'><button onclick='fn_download()'><img src='../images/ico_state_02.png' style='margin-right:3px;'>다운로드</button></span>";
				return html;
			},
			defaultContent : ""
		}
		]
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '300px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	getDataList();
});

/* ********************************************************
 * DDL 수행이력 상세정보 데이터 가져오기
 ******************************************************** */
function getDataList(){
// 	$.ajax({
// 		url : "/db2pg/selectDb2pgHistory.do", 
// 	  	data : {
// 	  		wrk_nm :  $("#wrk_nm").val(),
// 	  		exe_rslt_cd : $("#exe_rslt_cd").val()
// 	  	},
// 		dataType : "json",
// 		type : "post",
// 		beforeSend: function(xhr) {
// 	        xhr.setRequestHeader("AJAX", true);
// 	     },
// 		error : function(xhr, status, error) {
// 			if(xhr.status == 401) {
// 				alert("<spring:message code='message.msg02' />");
// 				top.location.href = "/";
// 			} else if(xhr.status == 403) {
// 				alert("<spring:message code='message.msg03' />");
// 				top.location.href = "/";
// 			} else {
// 				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
// 			}
// 		},
// 		success : function(data) {
// 			if(data.length > 0){
// 				table.rows({selected: true}).deselect();
// 				table.clear().draw();
// 				table.rows.add(data).draw();
// 			}else{
// 				table.clear().draw();
// 			}
// 		}
// 	});
}
	
</script>
<body>
<%@include file="../../cmmn/commonLocale.jsp"%>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">DDL 수행이력 상세보기</p>
			<div class="pop_cmm3">
				<p class="pop_s_tit">작업정보</p>
				<table class="list" style="border: 1px solid #99abb0;">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 85%;" />
					</colgroup>
					<tbody>
							<tr>
								<td>Work명</td>
								<td style="text-align: left">${result.wrk_nm}</td>
							</tr>
							<tr>
								<td>Work 설명</td>
								<td style="text-align: left">${result.wrk_exp}</td>
							</tr>
							<tr>
								<td>수행결과</td>
								<td style="text-align: left">
									<c:if test="${result.exe_rslt_cd eq 'TC001701'}"><img src='../../images/ico_state_02.png' style='margin-right:3px;'>Success</c:if>
									<c:if test="${result.exe_rslt_cd eq 'TC001702'}"><img src='../../images/ico_state_01.png' style='margin-right:3px;'>Fail</c:if>
								</td>
							</tr>
					</tbody>
				</table>
				<br><br>
				<p class="pop_s_tit">파일 정보</p>
					<div class="overflow_area">
						<table id="fileList" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th width="30"><spring:message code="common.no" /></th>
									<th width="100" class="dt-center">파일명</th>
									<th width="300" class="dt-center">경로</th>
									<th width="100" class="dt-center">사이즈</th>
									<th width="200" class="dt-center">생성일시</th>
									<th width="100" class="dt-center">다운로드</th>
								</tr>
							</thead>
						</table>
					</div>	
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close" /></span></a>
			</div>
		</div>
	</div>
</body>
</html>