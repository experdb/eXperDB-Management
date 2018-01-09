<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : accessPolicyRegForm.jsp
	* @Description : accessPolicyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.08
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근제어 정책 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<script>
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

});

$(window.document).ready(function() {
	fn_makeFromHour();
	fn_makeFromMin();
	fn_makeToHour();
	fn_makeToMin();
});
	
	

/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeFromHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="from_exe_h" id="from_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#b_hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeFromMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="from_exe_m" id="from_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#b_min" ).append(minHtml);
}


/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeToHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t7" name="to_exe_h" id="to_exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select> <spring:message code="schedule.our" />';	
	$( "#a_hour" ).append(hourHtml);
}


/* ********************************************************
 * 분
 ******************************************************** */
function fn_makeToMin(){
	var min = "";
	var minHtml ="";
	
	minHtml += '<select class="select t7" name="to_exe_m" id="to_exe_m">';	
	for(var i=0; i<=59; i++){
		if(i >= 0 && i<10){
			min = "0" + i;
		}else{
			min = i;
		}
		minHtml += '<option value="'+min+'">'+min+'</option>';
	}
	minHtml += '</select> <spring:message code="schedule.minute" />';	
	$( "#a_min" ).append(minHtml);
}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">접근제어 정책 등록</p>
				<table class="write">
					<caption>접근제어 정책 등록</caption>
					<colgroup>
						<col style="width: 130px;" />
						<col />
						<col style="width: 130px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">규칙이름</th>
							<td><input type="text" class="txt" name="" id="" /></td>
							<th scope="row" class="ico_t1">서버인스턴스</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">DB 사용자</th>
							<td><input type="text" class="txt" name="" id="" /></td>
							<th scope="row" class="ico_t1">experDB사용자</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">OS 사용자</th>
							<td><input type="text" class="txt" name="" id="" /></td>
							<th scope="row" class="ico_t1">프로그램이름</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">접근IP주소</th>
							<td><input type="text" class="txt" name="" id="" /></td>
							<th scope="row" class="ico_t1">IP 주소 마스크</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">접근 MAC 주소</th>
							<td><input type="text" class="txt" name="" id="" /></td>

						</tr>
						<tr>
							<th scope="row" class="ico_t1">기간</th>
							<td colspan="3">
								<span id="calendar"> 
									<span class="calendar_area big"> <a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" class="calendar" id="from" name="dt" title="스케줄시간설정" />
									</span>
								</span>
								&nbsp&nbsp&nbsp&nbsp&nbsp ~ &nbsp&nbsp&nbsp&nbsp&nbsp 
								<span id="calendar"> 
									<span class="calendar_area big"> 
									<a href="#n" class="calendar_btn">달력열기</a> 
									<input type="text" class="calendar" id="to" name="dt" title="스케줄시간설정" />
									</span>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">시간대</th>
							<td colspan="3">
								<span id="b_hour" style="margin-right: 10px;"></span><span id="b_min"></span>
									&nbsp&nbsp&nbsp&nbsp&nbsp ~ &nbsp&nbsp&nbsp&nbsp&nbsp
								<span id="a_hour" style="margin-right: 10px;"></span><span id="a_min"></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">임계치(대량작업)</th>
							<td>
								<input type="text" class="txt" name="" id="" style="width: 50px;" />&nbsp&nbsp건수/ &nbsp&nbsp 
								<input type="text" class="txt" name="" id="" style="width: 50px;" />초
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">추가필드</th>
							<td><input type="text" class="txt" name="" id="" /></td>
							<th scope="row" class="ico_t1">호스트이름</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">규칙 만족할 때</th>
							<td>
								<div class="inp_rdo">
									<input name="rdo" id="rdo_2_3" type="radio" checked="checked">
									<label for="rdo_2_3" style="margin-right: 15%;">접근허용</label> 
									<input name="rdo" id="rdo_2_4" type="radio"> 
									<label for="rdo_2_4">접근거부</label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			<div class="btn_type_02">
				<a href="#n" class="btn"><span>저장</span></a> 
				<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>
</body>
</html>