<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : securityStatistics.jsp
	* @Description : securityStatistics 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.04.23     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.09
	*
	*/
%>
<<script type="text/javascript">
$(window.document).ready(function() {
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
	
	$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
	$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));

});
</script>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>암호화통계<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>암호화통계</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li>통계</li>
					<li class="on">암호화통계</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select();"><button><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 10px;" />
							<col style="width: 120px;" />
							</col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10">조회일자</th>
								<td>
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" />								
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">조회조건</th>
								<td>
									조회조건
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				

				<div class="inner">
					<table class="list" border="1">
							<caption><spring:message code="dashboard.dbms_info" /></caption>
							<colgroup>
								<col style="width: 13.5%;" />

								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />								
								<col style="width: 6%;" />
								
								<col style="width: 10%;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" rowspan="2">Encrypt Agent IP</th>						
									<th scope="col" colspan="2">암호화</th>
									<th scope="col" colspan="2">복호화</th>
									<th scope="col" rowspan="2">합계  </th>						
								</tr>
								<tr>
									<th scope="col">성공</th>
									<th scope="col">실패</th>
									<th scope="col">성공</th>
									<th scope="col">실패</th>
								</tr>
							</thead>
							<tbody>
						
							</tbody>
						</table>
					</div>

					
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
