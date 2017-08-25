<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

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
		
		
		var svr_nm = "${svr_nm}";
		
		 /* ********************************************************
		  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
		  ******************************************************** */
		  	$.ajax({
				url : "/selectSvrList.do",
				data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {		
					$("#db_svr_nm").children().remove();
					$("#db_svr_nm").append("<option value='%'>전체</option>");
					if(result.length > 0){
						for(var i=0; i<result.length; i++){
							$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
						}									
					}
					$("#db_svr_nm").val(svr_nm).attr("selected", "selected");
				}
			});
		
		 	
		 
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
	
	function fn_buttonAut(){
		var read_button = document.getElementById("read_button"); 
		
		if("${read_aut_yn}" == "Y"){
			read_button.style.display = '';
		}else{
			read_button.style.display = 'none';
		}
	}
	
	/*조회버튼 클릭시*/
	function fn_selectScheduleHistory() {
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}

	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo) {
		document.selectScheduleHistory.pageIndex.value = pageNo;
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}
	
    </script>
    
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스케줄이력 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>Scheduler</li>
					<li class="on">스케줄이력</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" id="read_button"><button onClick="fn_selectScheduleHistory();">조회</button></span>
				</div>
				<form:form commandName="pagingVO" name="selectScheduleHistory" id="selectScheduleHistory" method="post">
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 150px;" />
							<col />
							<col style="width: 100px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
								<tr>
									<th scope="row" class="t10" >접근일자</th>
									<td>
										<div class="calendar_area">
											<a href="#n" class="calendar_btn">달력열기</a> 
											<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span>
											<a href="#n" class="calendar_btn">달력열기</a> 
											<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" />
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="t9 line">DB 서버명</th>
									<td>
									<select class="select t8" name="db_svr_nm" id="db_svr_nm"  style="width:300px";>
											<option value="%">전체</option>
									</select>	
									</td>
								</tr>		
							    <tr>
									<th scope="row" class="t9 line" >스케줄명</th>
									<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm"/ style="width: 300px;"></td>
								</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table class="list" id="scheduleHistoryTable">
						<caption>MY스케줄 화면</caption>
						<colgroup>
							<col style="width: 5%;" />
							<col style="width: 35%;" />
							<col style="width: 20%;" />
							<col style="width: 15%;" />
							<col style="width: 15%;" />
							<col style="width: 10%;" />
			
						</colgroup>
						<thead>
							<tr style="border-bottom: 1px solid #b8c3c6;">
								<th scope="col">NO</th>
								<th scope="col">스케줄명</th>
								<th scope="col">Work명</th>
								<th scope="col">작업시작일시</th>
								<th scope="col">작업종료일시</th>
								<th scope="col">결과</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="result" items="${result}" varStatus="status">
								<tr>
									<td><c:out value="${paginationInfo.totalRecordCount+1 - ((pagingVO.pageIndex-1) * pagingVO.pageSize + status.count)}" /></td>
									<td><c:out value="${result.wrk_nm}" /></td>
									<td><c:out value="${result.scd_nm}" /></td>
									<td><c:out value="${result.wrk_strt_dtm}" /></td>
									<td><c:out value="${result.wrk_end_dtm}" /></td>
									<td><c:out value="${result.exe_result}" /></td>
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
</div><!-- // contents -->