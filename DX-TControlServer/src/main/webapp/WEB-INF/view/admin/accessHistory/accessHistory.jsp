<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	/**
	* @Class Name : accessHistory.jsp
	* @Description : AccessHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.07
	*
	*/
%>
<script>
	$(window.document).ready(function() {
		
		fn_buttonAut();
		
		var lgi_dtm_start = "${lgi_dtm_start}";
		var lgi_dtm_end = "${lgi_dtm_end}";
		if (lgi_dtm_start != "" && lgi_dtm_end != "") {
			$('#from').val(lgi_dtm_start);
			$('#to').val(lgi_dtm_end);
		} else {
			$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
			$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		}
	});

	function fn_buttonAut(){
		var excel_button = document.getElementById("btnExcel"); 
		var select_button = document.getElementById("btnSelect"); 
		if("${read_aut_yn}" == "Y"){
			excel_button.style.display = '';
			select_button.style.display = '';
		}else{
			excel_button.style.display = 'none';
			select_button.style.display = 'none';
		}	
	}

	
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

	// 엑셀저장
	function fn_ExportExcel() {
		var table = document.getElementById("accessHistoryTable");
		var dataCnt = table.rows.length;

		if (dataCnt ==1) {
			alert("데이터가 존재하지 않습니다.")
			return false;
		} else {
			var lgi_dtm_start = $("#from").val();
			var lgi_dtm_end = $("#to").val();
			var search = "%" + $("#search").val() + "%";
			var type = $("#type").val();
			var order_type = $("#order_type").val();
			var order = $("#order").val();
			
			var form = document.excelForm;

			$("#lgi_dtm_start").val(lgi_dtm_start);
			$("#lgi_dtm_end").val(lgi_dtm_end);
			$("#excel_search").val(search);
			$("#excel_type").val(type);
			$("#excel_order_type").val(order_type);
			$("#excel_order").val(order);
			
			form.action = "/accessHistory_Excel.do";
			form.submit();
			return;
		}
	}
	
	
	/*조회버튼 클릭시*/
	function fn_select() {
		$("#historyCheck").val("historyCheck");
		document.selectList.action = "/selectSearchAccessHistory.do";
		document.selectList.submit();
	}

	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo) {
		document.selectList.pageIndex.value = pageNo;
		document.selectList.action = "/selectAccessHistory.do";
		document.selectList.submit();
	}
</script>
	<form name="excelForm" method="post">
		<input type="hidden" name="lgi_dtm_start" id="lgi_dtm_start">
		<input type="hidden" name="lgi_dtm_end" id="lgi_dtm_end"> 
		<input type="hidden" name="excel_type" id="excel_type">
		<input type="hidden" name="excel_search" id="excel_search">
		<input type="hidden" name="excel_order_type" id=excel_order_type>
		<input type="hidden" name="excel_order" id="excel_order">
	</form>
	<div id="contents">
		<div class="contents_wrap">
			<div class="contents_tit">
				<h4>화면접근이력<a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
					<div class="location">
						<ul>
							<li>Admin</li>
							<li>이력관리</li>
							<li class="on">화면접근이력</li>
						</ul>
					</div>
				</div>
			<div class="contents">
				<div class="cmm_grp">
					<div class="btn_type_float">
						<span class="btn btnC_01 btn_fl"><button id="btnExcel" onclick="fn_ExportExcel()">엑셀저장</button></span> 
								<span class="btn btn_fr"><button id="btnSelect"onclick="fn_select()">조회</button></span>															
					</div>

					<form:form commandName="pagingVO" name="selectList" id="selectList" method="post">
						<input type="hidden" name="historyCheck" id="historyCheck">
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 80px;" />
									<col style="width: 400px;" />
									<col style="width: 80px;" />
									<col style="width: 180px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t10">접근일자</th>
										<td>
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span>
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" />
											</div>
										</td>
										<th scope="row" class="t9">사용자</th>
											<td>
												<select class="select t5" id="type" name="type">
													<option value="usr_nm" ${type == 'usr_nm' ? 'selected="selected"' : ''}>사용자명</option>
													<option value="usr_id" ${type == 'usr_id' ? 'selected="selected"' : ''}>아이디</option>
												</select>
											</td>
										<td><input type="text" class="txt t2" id="search" name="search" value="${search}"/></td>
									</tr>
									<tr>
									<th scope="row" class="t9">정렬</th>
										<td>
											<select class="select t5" id="order_type" name="order_type">
												<option value="exedtm" ${order_type == 'exedtm' ? 'selected="selected"' : ''}>일자,시간</option>
												<option value="usr_id" ${order_type == 'usr_id' ? 'selected="selected"' : ''}>아이디</option>
											</select>							
											<select class="select t5" id="order" name="order">
												<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}>내림차순</option>
												<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}>오름차순</option>		
											</select>
										</td>
									
									</tr>

								</tbody>
							</table>
						</div>

						<div class="overflow_area">
							<table class="list" id="accessHistoryTable">
								<caption>사용자 접근내역화면</caption>
								<colgroup>
									<col style="width: 5%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 25%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
								</colgroup>
								<thead>
									<tr style="border-bottom: 1px solid #b8c3c6;">
										<th scope="col">NO</th>
										<th scope="col">일자</th>
										<th scope="col">시간</th>
										<th scope="col">구분</th>
										<th scope="col">아이디</th>
										<th scope="col">사용자명</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">아이피</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="result" items="${result}" varStatus="status">
										<tr>
											<td><c:out value="${paginationInfo.totalRecordCount+1 - ((pagingVO.pageIndex-1) * pagingVO.pageSize + status.count)}" /></td>
											<td><c:out value="${result.exedtm_date}" /></td>
											<td><c:out value="${result.exedtm_hour}" /></td>
											<td><c:out value="${result.sys_cd_nm}" /></td>
											<td><c:out value="${result.usr_id}" /></td>
											<td><c:out value="${result.usr_nm}" /></td>
											<td><c:out value="${result.dept_nm}" /></td>
											<td><c:out value="${result.pst_nm}" /></td>
											<td><c:out value="${result.lgi_ipadr}" /></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>

						<Br><BR>
						<div id="paging" class="paging">
							<ul id='pagininfo'>
								<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
								<form:hidden path="pageIndex" />
							</ul>
						</div>
					</form:form>
				</div>
			</div>
		</div>
	</div>