<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : auditLogList.jsp
	* @Description : Audit 로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
	*
	*/
%>

<script language="javascript">
$(window.document).ready(function() {
	var lgi_dtm_start = "${start_date}";
	var lgi_dtm_end = "${end_date}";
	if (lgi_dtm_start != "" && lgi_dtm_end != "") {
		$('#from').val(lgi_dtm_start);
		$('#to').val(lgi_dtm_end);
	} else {
		$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
	}
});

$(function() {
	var dateFormat = "yyyy-mm-dd", from = $("#from").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#to").datepicker("option", "minDate", selectedDate);
		}
	})

	to = $("#to").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#from").datepicker("option", "maxDate", selectedDate);
		}
	})

	function getDate(element) {
		var date;
		try {
			date = $.datepicker.parseDate(dateFormat, element.value);
		} catch (error) {
			date = null;
		}
		return date;
	}
});

	function fn_search() {
		var form = document.auditForm;
		
		form.action = "/audit/auditLogSearchList.do";
		form.submit();
		return;
	}
	
	function fn_openLogView(file_name) {
		var db_svr_id = $("#db_svr_id").val();

		var param = "db_svr_id=" + db_svr_id + "&file_name=" + file_name;
		
		window.open("/audit/auditLogView.do?" + param  ,"popLogView","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=915,height=710,top=0,left=0");
	}
</script>

<form name="auditForm" id="auditForm" method="post" onSubmit="return false;">
<input type="hidden" id="db_svr_id" name="db_svr_id" value="${db_svr_id}">
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>감사이력 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>${serverName}</li>
								<li>접근제어관리</li>
								<li class="on">감사 이력</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button onClick="javascript:fn_search();">조회</button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col />
									</colgroup>
									<tbody>

										<tr>
											<th scope="row" class="t10">작업기간</th>
											<td colspan="5">
												<div class="calendar_area">
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="from" name="start_date" title="기간검색 시작날짜" readonly="readonly" />
													<span class="wave">~</span>
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="to" name="end_date" title="기간검색 종료날짜" readonly="readonly" />
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="overflow_area">
								<table class="list">
									<caption>Rman 백업관리 이력화면 리스트</caption>
									<colgroup>
										<col style="width:5%;" />
										<col style="width:60%;" />
										<col style="width:15%;" />
										<col style="width:20%;" />

									</colgroup>
									<thead>
										<tr>
											<th scope="col">No</th>
											<th scope="col">로그파일명</th>
											<th scope="col">Size</th>
											<th scope="col">수정일시</th>
										</tr>
									</thead>
									<tbody>
									
									<c:if test="${fn:length(logFileList) == 0}">
										<tr>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											
										</tr>
									</c:if>
									<c:forEach var="log" items="${logFileList}" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td><a href="javascript:fn_openLogView('${log.file_name}')">${log.file_name}</a></td>
											<td>${log.file_size}</td>
											<td>${log.file_lastmodified}</td>
											
										</tr>
									</c:forEach>
									
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
</form>