<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>
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

		var today = new Date();
		var day = today.toJSON().slice(0,10);

		if (lgi_dtm_start != "" && lgi_dtm_end != "") {
			$('#from').val(lgi_dtm_start);
			$('#to').val(lgi_dtm_end);
		} else {
			$('#from').val(day);
			$('#to').val(day);
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
	
	<div class="content-wrapper main_scroll" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
<!-- 												<i class="fa fa-check-square"></i> -->
												<span class="menu-title"><spring:message code="menu.screen_access_history" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.history_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.screen_access_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.screen_access_history_01" /></p>
											<p class="mb-0"><spring:message code="help.screen_access_history_02" /></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<form:form commandName="pagingVO" name="selectList" id="selectList" method="post" class="form-inline">
		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body">
							<div class="form-inline">
								<div class="row">
									<div class="input-group mb-2 mr-sm-2">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="from" name="lgi_dtm_start" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
												
										<div class="input-group align-items-center">
											<span style="border:none; padding: 0px 10px;"> ~ </span>
										</div>
		
										<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="to" name="lgi_dtm_end" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div> 
	
									<div class="input-group mb-2 mr-sm-2">
										<select class="form-control" style="width:150px; margin-right: 1rem;" id="type" name="type">
	 										<option value="usr_nm" ${type == 'usr_nm' ? 'selected="selected"' : ''}><spring:message code="history_management.user_name" /></option> 
	 										<option value="usr_id" ${type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /> </option>
	 									</select>
	 									<input type="text" class="form-control" style="width:200px;" id="search" name="search" value="${search}" maxlength="15" placeholder='<spring:message code="history_management.user" />'/>
									</div>
									<div class="input-group mb-2 mr-sm-2">
	 									<select class="form-control" style="width:150px; margin-right: 1rem;" id="sys_cd" name="sys_cd">
											<option value="" ${sys_cd == '' ? 'selected="selected"' : ''}><spring:message code="common.total" /></option>	
												<c:forEach var="ScreenNames" items="${ScreenNames}">
													<option value="${ScreenNames.sys_cd}" ${ScreenNames.sys_cd == sys_cd ? 'selected="selected"' : ''}>${ScreenNames.sys_cd_nm}</option>							
												</c:forEach>
	 									</select>
									</div>
									<div class="input-group mb-2 mr-sm-2">
										<select class="form-control" style="width:150px; margin-right: 1rem;" id="order_type" name="order_type">
											<option value="exedtm" ${order_type == 'exedtm' ? 'selected="selected"' : ''}><spring:message code="history_management.bydate" /></option>
											<option value="usr_id" ${order_type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /></option>
										</select>							
										<select class="form-control" style="width:150px; margin-right: 1rem;" id="order" name="order">
											<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option>
											<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>		
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnExcel" onclick="fn_ExportExcel()" data-toggle="modal">
									<i class="fa fa-file-excel-o btn-icon-prepend "></i><spring:message code="history_management.excel_save" />
								</button>
													
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSelect" onclick="fn_select()" data-toggle="modal">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

										<table class="table table-hover table-striped" id="accessHistoryTable">
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
												<tr class="bg-primary text-white" style="border-bottom: 1px solid #b8c3c6;">
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
														<td style="text-align: left;"><c:out value="${result.exedtm_date}" /></td>
														<td style="text-align: left;"><c:out value="${result.exedtm_hour}" /></td>
														<td style="text-align: left;"><c:out value="${result.sys_cd_nm}" /></td>
														<td style="text-align: left;"><c:out value="${result.usr_id}" /></td>
														<td style="text-align: left;"><c:out value="${result.usr_nm}" /></td>
														<td style="text-align: left;"><c:out value="${result.dept_nm}" /></td>
														<td style="text-align: left;"><c:out value="${result.pst_nm}" /></td>
														<td style="text-align: left;"><c:out value="${result.lgi_ipadr}" /></td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
							 	</div>
						 	</div>

					</div>
					<div class="card-body" >
						 <div class="row">
							<div class="col-sm-12 col-md-12">
								 <ul id='pagininfo' class='pagination justify-content-center'> 
							 		<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" /> 
							 		<form:hidden path="pageIndex" /> 
							 	</ul>
							</div>
						</div>
					</div>
							
						</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
		</form:form>
		
	</div>
</div>

<!-- 	<div id="contents"> -->
<!-- 		<div class="contents_wrap"> -->
<!-- 			<div class="contents"> -->
<!-- 				<div class="cmm_grp"> -->
<!-- 					<div class="btn_type_float"> -->
<%-- 						<span class="btn btnC_01 btn_fl"><button type="button" id="btnExcel" onclick="fn_ExportExcel()"><spring:message code="history_management.excel_save" /></button></span>  --%>
<%-- 								<span class="btn btn_fr"><button type="button" id="btnSelect"onclick="fn_select()"><spring:message code="common.search" /></button></span>															 --%>
<!-- 					</div> -->

<%-- 					<form:form commandName="pagingVO" name="selectList" id="selectList" method="post"> --%>
<!-- 						<div class="sch_form"> -->
<!-- 							<table class="write"> -->
<%-- 								<caption>검색 조회</caption> --%>
<%-- 								<colgroup> --%>
<%-- 									<col style="width: 100px;" /> --%>
<%-- 									<col style="width: 350px;" /> --%>
<%-- 									<col style="width: 80px;" /> --%>
<%-- 									<col style="width: 400px;" /> --%>
<%-- 									<col /> --%>
<%-- 								</colgroup> --%>
<!-- 								<tbody> -->
<!-- 									<tr> -->
<%-- 										<th scope="row" class="t10"><spring:message code="history_management.access_date" /></th> --%>
<!-- 										<td> -->
<!-- 											<div class="calendar_area"> -->
<!-- 												<a href="#n" class="calendar_btn">달력열기</a>  -->
<!-- 												<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span> -->
<!-- 												<a href="#n" class="calendar_btn">달력열기</a>  -->
<!-- 												<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" /> -->
<!-- 											</div> -->
<!-- 										</td> -->
<%-- 										<th scope="row" class="t9"><spring:message code="history_management.user" /></th> --%>
<!-- 											<td> -->
<!-- 												<select class="select t8" id="type" name="type"> -->
<%-- 													<option value="usr_nm" ${type == 'usr_nm' ? 'selected="selected"' : ''}><spring:message code="history_management.user_name" /></option> --%>
<%-- 													<option value="usr_id" ${type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /> </option> --%>
<!-- 												</select> -->
<%-- 												<input type="text" class="txt t2" id="search" name="search" value="${search}" maxlength="15"/> --%>
<!-- 											</td>				 -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<%-- 										<th scope="row" class="t9"><spring:message code="history_management.screen_choice" /></th> --%>
<!-- 										<td> -->
<!-- 											<select class="select t5" id="sys_cd" name="sys_cd"> -->
<%-- 												<option value="" ${sys_cd == '' ? 'selected="selected"' : ''}><spring:message code="common.total" /></option>	 --%>
<%-- 												<c:forEach var="ScreenNames" items="${ScreenNames}"> --%>
<%-- 													<option value="${ScreenNames.sys_cd}" ${ScreenNames.sys_cd == sys_cd ? 'selected="selected"' : ''}>${ScreenNames.sys_cd_nm}</option>							 --%>
<%-- 												</c:forEach> --%>
<!-- 											</select> -->
<!-- 										</td> -->
<%-- 										<th scope="row" class="t9"><spring:message code="history_management.sort" /></th> --%>
<!-- 										<td> -->
<!-- 											<select class="select t8" id="order_type" name="order_type"> -->
<%-- 												<option value="exedtm" ${order_type == 'exedtm' ? 'selected="selected"' : ''}><spring:message code="history_management.bydate" /></option> --%>
<%-- 												<option value="usr_id" ${order_type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /></option> --%>
<!-- 											</select>							 -->
<!-- 											<select class="select t5" id="order" name="order"> -->
<%-- 												<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option> --%>
<%-- 												<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>		 --%>
<!-- 											</select> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</div> -->

<!-- 						<div class="overflow_area" style="height: 370px;"> -->
<!-- 							<table class="list" id="accessHistoryTable"> -->
<%-- 								<caption>사용자 접근내역화면</caption> --%>
<%-- 								<colgroup> --%>
<%-- 									<col style="width: 5%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 15%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 									<col style="width: 10%;" /> --%>
<%-- 								</colgroup> --%>
<!-- 								<thead> -->
<!-- 									<tr style="border-bottom: 1px solid #b8c3c6;"> -->
<%-- 										<th scope="col"><spring:message code="common.no" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.date" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.time" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.screen" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.id" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.user_name" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.department" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.position" /></th> --%>
<%-- 										<th scope="col"><spring:message code="history_management.ip" /></th> --%>
<!-- 									</tr> -->
<!-- 								</thead> -->
<!-- 								<tbody> -->
<%-- 									<c:forEach var="result" items="${result}" varStatus="status"> --%>
<!-- 										<tr> -->
<%-- 											<td><c:out value="${pagingVO.pageSize*(pagingVO.pageIndex-1) + result.rownum}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.exedtm_date}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.exedtm_hour}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.sys_cd_nm}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.usr_id}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.usr_nm}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.dept_nm}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.pst_nm}" /></td> --%>
<%-- 											<td style="text-align: left;"><c:out value="${result.lgi_ipadr}" /></td> --%>
<!-- 										</tr> -->
<%-- 									</c:forEach> --%>
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</div> -->

<!-- 						<Br><BR> -->
<!-- 						<div id="paging" class="paging"> -->
<!-- 							<ul id='pagininfo'> -->
<%-- 								<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" /> --%>
<%-- 								<form:hidden path="pageIndex" /> --%>
<!-- 							</ul> -->
<!-- 						</div> -->
<%-- 					</form:form> --%>
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->