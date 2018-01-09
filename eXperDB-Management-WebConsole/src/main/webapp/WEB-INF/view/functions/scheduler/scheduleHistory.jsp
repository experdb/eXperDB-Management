<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

    <script>
    function fn_validation(){
    	
    	 var arySrtDt = $('#from').val(); // ex) 시작일자(2007-10-09)
    	 var aryEndDt = $('#to').val(); // ex) 종료일자(2007-12-05)
    	 
    	 var startDt = new Date(arySrtDt);
    	 var endDt	= new Date(aryEndDt);

    	resultDt	= Math.round((endDt.valueOf() - startDt.valueOf())/(1000*60*60*24*365/12));
    	
    	if(resultDt>6){
    		alert("<spring:message code='message.msg34' />");
    		return false; 
    	}
    	return true;
    }
    
    
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
		
		var exe_result = "${exe_result}";
		var svr_nm = "${svr_nm}";
		var scd_nm = "${scd_nm}";
		var wrk_nm = "${wrk_nm}";
		
		
		if(exe_result == "" || exe_result==null){
			document.getElementById("exe_result").value="%";
		}else{
			document.getElementById("exe_result").value=exe_result;
		}
	
		
		 /* ********************************************************
		  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
		  ******************************************************** */
		  	$.ajax({
				url : "/selectSvrList.do",
				data : {},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert("<spring:message code='message.msg02' />");
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("<spring:message code='message.msg03' />");
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {		
					$("#db_svr_nm").children().remove();
					$("#db_svr_nm").append("<option value='%'><spring:message code='common.total' /></option>");
					if(result.length > 0){
						for(var i=0; i<result.length; i++){
							$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
						}									
					}
					$("#db_svr_nm").val(svr_nm).attr("selected", "selected");
				}
			});	 
		 
		 fn_ScheduleNmList(scd_nm);
	
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
		if (!fn_validation()) return false;
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}

	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo) {
		document.selectScheduleHistory.pageIndex.value = pageNo;
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}
	
	
	function setSearchDate(start){
		$('input:not(:checked)').parent(".chkbox2").removeClass("on");
        $('input:checked').parent(".chkbox2").addClass("on");    
        
		var num = start.substring(0,1);
		var str = start.substring(1,2);

		var today = new Date();

		//var year = today.getFullYear();
		//var month = today.getMonth() + 1;
		//var day = today.getDate();
		
		var endDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#to').val(endDate);
		
		if(str == 'd'){
			today.setDate(today.getDate() - num);
		}else if (str == 'w'){
			today.setDate(today.getDate() - (num*7));
		}else if (str == 'm'){
			today.setMonth(today.getMonth() - num);
			today.setDate(today.getDate() + 1);
		}

		var startDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#from').val(startDate);
				
		// 종료일은 시작일 이전 날짜 선택하지 못하도록 비활성화
		$("#to").datepicker( "option", "minDate", startDate );
		
		// 시작일은 종료일 이후 날짜 선택하지 못하도록 비활성화
		$("#from").datepicker( "option", "maxDate", endDate );

	}

	function fn_ScheduleNmList(scd_nm){

	  var lgi_dtm_start = $('#from').val();
	  var lgi_dtm_end = $('#to').val();
	  
	  	$.ajax({
			url : "/selectScheduleNmList.do",
			data : {
				wrk_start_dtm : lgi_dtm_start,
				wrk_end_dtm : 	lgi_dtm_end				
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {		
				$("#scd_nm").children().remove();
				$("#scd_nm").append("<option value='%'><spring:message code='schedule.total' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#scd_nm").append("<option value='"+result[i].scd_nm+"'>"+result[i].scd_nm+"</option>");	
					}									
				}
				$("#scd_nm").val(scd_nm).attr("selected", "selected");		
// 				fn_selectedWork(scd_nm);
			}
		});	 
	}
	
	
	function fn_dtm(){
		fn_ScheduleNmList();
	}
	
// 	function fn_selectedWork(scd_nm){
// 	  	 $.ajax({
// 			url : "selectWrkNmList.do",
// 			data : {
// 				scd_nm : scd_nm
// 			},
// 			dataType : "json",
// 			type : "post",
// 			error : function(request, status, error) {
// 				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
// 			},
// 			success : function(result) {		
// 				$("#wrk_nm").children().remove();
// 				$("#wrk_nm").append("<option value='%'>전체</option>");
// 				if(result.length > 0){
// 					for(var i=0; i<result.length; i++){
// 						$("#wrk_nm").append("<option value='"+result[i].wrk_nm+"'>"+result[i].wrk_nm+"</option>");	
// 					}									
// 				}
// 				//$("#wrk_nm").val(wrk_nm).attr("selected", "selected");	
// 			}
// 		});
// 	}
	
	function fn_selectWrkNmList(scd_nm){
	  	 $.ajax({
			url : "selectWrkNmList.do",
			data : {
				scd_nm : scd_nm.value
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {		
				$("#wrk_nm").children().remove();
				$("#wrk_nm").append("<option value='%'><spring:message code='common.total' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#wrk_nm").append("<option value='"+result[i].wrk_nm+"'>"+result[i].wrk_nm+"</option>");	
					}									
				}
			}
		});
	}

	function fn_detail(exe_sn){
		var popUrl = "/popup/scheduleHistoryDetail.do?exe_sn="+exe_sn; // 서버 url 팝업경로
		var width = 950;
		var height = 673;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);
	}
    </script>
    
<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.shedule_execution_history" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.shedule_execution_history" /></li>
				</ul>
			</div>					
			<div class="location">
				<ul>
					<li>Function</li>
					<li><spring:message code="menu.schedule_information" /></li>
					<li class="on"><spring:message code="menu.shedule_execution_history" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" id="read_button"><button onClick="fn_selectScheduleHistory();"><spring:message code="common.search" /></button></span>
				</div>
				<form:form commandName="pagingVO" name="selectScheduleHistory" id="selectScheduleHistory" method="post">
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 80px;" />
							<col style="width: 210px;" />
							<col style="width: 70px;" />
							<col style="width: 150px;" />
							<col style="width: 60px;" />
							<col style="width: 150px;" />
						</colgroup>
						<tbody>
								<tr>
									<th scope="row" class="t10" ><spring:message code="schedule.work_day" /></th>
									<td>
										<div class="calendar_area">
											<a href="#n" class="calendar_btn">달력열기</a> 
											<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜"  onChange="fn_dtm();" /> <span class="wave">~</span>
											<a href="#n" class="calendar_btn">달력열기</a> 
											<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" onChange="fn_dtm();"  />
										</div>							
									</td>
									<td colspan="4">
										<ul class="searchDate">
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType1" onclick="setSearchDate('0d')"/>
													<label for="dateType1"><spring:message code="schedule.today" /></label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType2" onclick="setSearchDate('3d')"/>
													<label for="dateType2"><spring:message code="schedule.three_day" /></label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType3" onclick="setSearchDate('1w')"/>
													<label for="dateType3"><spring:message code="schedule.one_week" /></label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType4" onclick="setSearchDate('2w')"/>
													<label for="dateType4"><spring:message code="schedule.two_weeks" /></label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType5" onclick="setSearchDate('1m')"/>
													<label for="dateType5"><spring:message code="schedule.one_month" /> </label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType6" onclick="setSearchDate('3m')"/>
													<label for="dateType6"><spring:message code="schedule.three_month" /></label>
												</span>
											</li>
											<li>
												<span class="chkbox2">
													<input type="radio" name="dateType" id="dateType7" onclick="setSearchDate('6m')"/>
													<label for="dateType7"><spring:message code="schedule.six_month" /></label>
												</span>
											</li>
										</ul>

									</td>
								</tr>
								 <tr>
									<th scope="row" class="t9 line" ><spring:message code="schedule.schedule_name" /> </th>
									<td>
										<select class="select t4" name="scd_nm" id="scd_nm" onChange="fn_selectWrkNmList(this);">
												<option value="%"><spring:message code="schedule.total" /></option>
										</select>	
									</td>
									<th scope="row" class="t9 line"><spring:message code="common.dbms_name" /></th>
									<td>
										<select class="select t4" name="db_svr_nm" id="db_svr_nm" >
												<option value="%"><spring:message code="schedule.total" /></option>
										</select>	
									</td>									
									<th scope="row" class="t9 line"><spring:message code="schedule.result" /></th>
									<td>
										<select class="select t4" name="exe_result" id="exe_result">
												<option value="%"><spring:message code="schedule.total" /></option>
												<option value="TC001701"><spring:message code="common.success" /></option>
												<option value="TC001702"><spring:message code="common.failed" /></option>
										</select>	
									</td>
								</tr>		
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table class="list" id="scheduleHistoryTable">
						<caption>MY스케줄 화면</caption>
						<colgroup>
							<col style="width: 5%;" />
							<col style="width: 30%;" />
							<col style="width: 15%;" />
							<col style="width: 15%;" />
							<col style="width: 20%;" />
							<col style="width: 20%;" />
							<col style="width: 15%;" />
							<col style="width: 10%;" />
							<col style="width: 15%;" />
						</colgroup>
						<thead>
							<tr style="border-bottom: 1px solid #b8c3c6;">
								<th scope="col"><spring:message code="common.no" /></th>
								<th scope="col"><spring:message code="schedule.schedule_name" /></th>
								<th scope="col"><spring:message code="common.dbms_name" /></th>
								<th scope="col"><spring:message code="dbms_information.dbms_ip" /></th>							
								<th scope="col"><spring:message code="schedule.work_start_datetime" /></th>
								<th scope="col"><spring:message code="schedule.work_end_datetime" /></th>
								<th scope="col"><spring:message code="schedule.jobTime"/></th>
								<th scope="col"><spring:message code="schedule.result" /></th>
								<th scope="col"><spring:message code="schedule.detail_view" /></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="result" items="${result}" varStatus="status">
								<tr>
									<td><c:out value="${paginationInfo.totalRecordCount+1 - ((pagingVO.pageIndex-1) * pagingVO.pageSize + status.count)}" /></td>
									<td style="text-align: left;"><span onclick="fn_scdLayer('${result.scd_id}');" class="bold"><c:out value="${result.scd_nm}" /></span></td>
									<td><c:out value="${result.db_svr_nm}" /></td>		
									<td><c:out value="${result.ipadr}" /></td>						
									<td><c:out value="${result.wrk_strt_dtm}" /></td>
									<td><c:out value="${result.wrk_end_dtm}" /></td>
									<td><c:out value="${result.wrk_dtm}" /></td>
									<td>
										<c:choose>
											<c:when test="${result.exe_rslt_cd eq 'TC001701'}"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</c:when>
									    	<c:when test="${result.exe_rslt_cd eq 'TC001702'}"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</c:when>
									    	<c:otherwise>
									    		<img src="../images/ico_state_03.png" style="margin-right:3px;"/>진행중
									    	</c:otherwise>
										</c:choose>
									</td>
									<td><span class='btn btnC_01 btnF_02' onclick='fn_detail(${result.exe_sn})'><input type="button" value="<spring:message code="schedule.detail_view" />"></span></td>
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