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
		scrollY : "50px",
		bSort: false,
		scrollX: false,
		searching : false,
		paging: false,
		scrollX: true,
		columns : [
		{ data : "scd_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "scd_exp", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_end_dtm", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_dtm", className : "dt-center", defaultContent : ""}
		]
	});
	
	schTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	schTable.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
	schTable.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
	schTable.tables().header().to$().find('th:eq(3)').css('min-width', '50px');
	schTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
    $(window).trigger('resize');
    
    workTable = $('#workTable').DataTable({
		scrollY : "190px",
		searching : false,
		paging: false,
		scrollX: true,
		columns : [
		{ data : "rownum", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_exp", className : "dt-center", defaultContent : ""}, 
		{ data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},  
		{ data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
		{ data : "wrk_dtm", className : "dt-center", defaultContent : ""},
		{data : "exe_rslt_cd", className : "dt-center", defaultContent : ""
			,"render": function (data, type, full) {
				if(full.exe_rslt_cd=="TC001701"){
					var html = '<span onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_w_20.png" alt="" id="rsltcd"/></span>';
						return html;
				}else{
					var html = '<span onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_w_19.png" alt="" id="rsltcd"/></span>';
					return html;
				}
			}
		}
		]
	});
    
    workTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
    workTable.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
    workTable.tables().header().to$().find('th:eq(2)').css('min-width', '75px');
    workTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
    workTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	workTable.tables().header().to$().find('th:eq(5)').css('min-width', '50px');
    $(window).trigger('resize');
    
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
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
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
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			workTable.clear().draw();
			workTable.rows.add(result).draw();
		}
	});
});
</script>
<body>

 <!--  popup -->
	<div id="pop_layer_wrkLog" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 600px; margin: 0 auto;">
				<p class="tit" style="margin-bottom: 15px;">작업로그 정보</p>
				<table class="write" border="">
					<caption>작업로그 정보</caption>
					<tbody>
						<tr>
							<td name="wrkLogInfo" id="wrkLogInfo" style="height: 270px;"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_wrkLog'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">스케줄수행이력 상세보기</p>
			<div class="pop_cmm3">
				<p class="pop_s_tit">스케줄정보</p>
				<div class="overflow_area" style="height: 160px;">
					<table id="schTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="50">스케줄명</th>
								<th width="50">스케줄설명</th>
								<th width="50">작업시작일시</th>
								<th width="50">작업종료일시</th>
								<th width="50">작업시간</th>
							</tr>
						</thead>
					</table>
				</div>
				<br><br>
				<p class="pop_s_tit">work정보</p>
				<div class="overflow_area" style="height: 300px;">
					<table id="workTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40">No</th>
								<th width="50">work명</th>
								<th width="75">work설명</th>
								<th width="100">작업시작일시</th>
								<th width="100">작업종료일시</th>
								<th width="50">작업시간</th>
								<th width="50">결과</th>
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