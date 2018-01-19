<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
			alert("<spring:message code='message.msg01'/>")
			return false;
		} else {
			var lgi_dtm_start = $("#from").val();
			var lgi_dtm_end = $("#to").val();
			var search = "%" + $("#search").val() + "%";
			var type = $("#type").val();
			var order_type = $("#order_type").val();
			var order = $("#order").val();
			var sys_cd = $("#sys_cd").val();
			
			var form = document.excelForm;

			$("#lgi_dtm_start").val(lgi_dtm_start);
			$("#lgi_dtm_end").val(lgi_dtm_end);
			$("#excel_search").val(search);
			$("#excel_type").val(type);
			$("#excel_order_type").val(order_type);
			$("#excel_order").val(order);
			$("#excel_sys_cd").val(sys_cd);
			
			form.action = "/accessHistory_Excel.do";
			form.submit();
			return;
		}
	}
	
	
	/*조회버튼 클릭시*/
	function fn_select() {
		document.selectList.pageIndex.value = 1;
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
		<input type="hidden" name="excel_order_type" id="excel_order_type">
		<input type="hidden" name="excel_order" id="excel_order">
		<input type="hidden" name="excel_sys_cd" id="excel_sys_cd">
	</form>
	<div id="contents">
		<div class="contents_wrap">
			<div class="contents_tit">
				<h4><spring:message code="menu.screen_access_history" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
					<div class="infobox"> 
							<ul>
								<li><spring:message code="help.screen_access_history_01" /></li>
								<li><spring:message code="help.screen_access_history_02" /></li>	
							</ul>
					</div>
					<div class="location">
						<ul>
							<li>Admin</li>
							<li><spring:message code="menu.history_management" /></li>
							<li class="on"><spring:message code="menu.screen_access_history" /></li>
						</ul>
					</div>
				</div>
			<div class="contents">
				<div class="cmm_grp">
					<div class="btn_type_float">
						<span class="btn btnC_01 btn_fl"><button id="btnExcel" onclick="fn_ExportExcel()"><spring:message code="history_management.excel_save" /></button></span> 
								<span class="btn btn_fr"><button id="btnSelect"onclick="fn_select()"><spring:message code="common.search" /></button></span>															
					</div>

					<form:form commandName="pagingVO" name="selectList" id="selectList" method="post">
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 100px;" />
									<col style="width: 350px;" />
									<col style="width: 80px;" />
									<col style="width: 400px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t10"><spring:message code="history_management.access_date" /></th>
										<td>
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span>
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" />
											</div>
										</td>
										<th scope="row" class="t9"><spring:message code="history_management.user" /></th>
											<td>
												<select class="select t8" id="type" name="type">
													<option value="usr_nm" ${type == 'usr_nm' ? 'selected="selected"' : ''}><spring:message code="history_management.user_name" /></option>
													<option value="usr_id" ${type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /> </option>
												</select>
												<input type="text" class="txt t2" id="search" name="search" value="${search}"/>
											</td>				
									</tr>
									<tr>
										<th scope="row" class="t9"><spring:message code="history_management.screen_choice" /></th>
										<td>
											<select class="select t5" id="sys_cd" name="sys_cd">
												<option value="" ${sys_cd == '' ? 'selected="selected"' : ''}><spring:message code="common.total" /></option>	
												<c:forEach var="ScreenNames" items="${ScreenNames}">
													<option value="${ScreenNames.sys_cd}" ${ScreenNames.sys_cd == sys_cd ? 'selected="selected"' : ''}>${ScreenNames.sys_cd_nm}</option>							
												</c:forEach>
											</select>
										</td>
										<th scope="row" class="t9"><spring:message code="history_management.sort" /></th>
										<td>
											<select class="select t8" id="order_type" name="order_type">
												<option value="exedtm" ${order_type == 'exedtm' ? 'selected="selected"' : ''}><spring:message code="history_management.bydate" /></option>
												<option value="usr_id" ${order_type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /></option>
											</select>							
											<select class="select t5" id="order" name="order">
												<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option>
												<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>		
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="overflow_area" style="height: 370px;">
							<table class="list" id="accessHistoryTable">
								<caption>사용자 접근내역화면</caption>
								<colgroup>
									<col style="width: 5%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 15%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
									<col style="width: 10%;" />
								</colgroup>
								<thead>
									<tr style="border-bottom: 1px solid #b8c3c6;">
										<th scope="col"><spring:message code="common.no" /></th>
										<th scope="col"><spring:message code="history_management.date" /></th>
										<th scope="col"><spring:message code="history_management.time" /></th>
										<th scope="col"><spring:message code="history_management.screen" /></th>
										<th scope="col"><spring:message code="history_management.id" /></th>
										<th scope="col"><spring:message code="history_management.user_name" /></th>
										<th scope="col"><spring:message code="history_management.department" /></th>
										<th scope="col"><spring:message code="history_management.position" /></th>
										<th scope="col"><spring:message code="history_management.ip" /></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="result" items="${result}" varStatus="status">
										<tr>
											<td><c:out value="${pagingVO.pageSize*(pagingVO.pageIndex-1) + result.rownum}" /></td>
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