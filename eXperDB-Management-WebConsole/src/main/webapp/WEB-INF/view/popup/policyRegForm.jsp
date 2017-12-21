<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : policyRegForm.jsp
	* @Description : policyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.11.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.11.20
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>보안정책등록</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" href="/css/calendar.css">
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

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<style>
.contents .cmm_tab li {
	width: 33.33%;
}

.contents {
    min-height: 600px;
 }
</style>
<script>
	var table = null;
	var table2 = null;

	function fn_init() {
		table = $('#encryptPolicyTable').DataTable({
			scrollY : "200px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
	    
	    table2 = $('#accessControlTable').DataTable({
			scrollY : "200px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}
			]
		});

	    table2.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	    table2.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
	    table2.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
	    table2.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
	    table2.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(6)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(11)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(12)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(13)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(14)').css('min-width', '150px');
		table2.tables().header().to$().find('th:eq(15)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(16)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
	}
	
	$(window.document).ready(function() {
		fn_init();
		fn_makeFromHour();
		fn_makeFromMin();
		fn_makeToHour();
		fn_makeToMin();
		
		$("#tab1").show();
		$("#tab2").hide();
		$("#tab3").hide();

		$("#info").show();
		$("#option").hide();
		$("#accessControl").hide();
	});

	function selectTab(tab) {
		if (tab == "info") {
			$("#tab1").show();
			$("#tab2").hide();
			$("#tab3").hide();

			$("#info").show();
			$("#option").hide();
			$("#accessControl").hide();
		} else if (tab == "option") {
			$("#tab1").hide();
			$("#tab2").show();
			$("#tab3").hide();

			$("#info").hide();
			$("#option").show();
			$("#accessControl").hide();
		} else {
			$("#tab1").hide();
			$("#tab2").hide();
			$("#tab3").show();

			$("#info").hide();
			$("#option").hide();
			$("#accessControl").show();
		}

	}
	
	function fn_encryptPolicyAddForm(){
		toggleLayer($('#pop_layer'), 'on');
	}
	
	function fn_accessControlAddForm(){
		toggleLayer($('#pop_layer2'), 'on');
	}
	
	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeToHour(){
		var hour = "";
		var hourHtml ="";
		
		hourHtml += '<select class="select t7" name="to_exe_h" id="to_exe_h" style="margin-right: 10px;">';	
		for(var i=0; i<=23; i++){
			if(i >= 0 && i<10){
				hour = "0" + i;
			}else{
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">'+hour+'</option>';
		}
		hourHtml += '</select><spring:message code="schedule.our" />';	
		$( "#a_hour" ).append(hourHtml);
	}


	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeToMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="select t7" name="to_exe_m" id="to_exe_m" style="margin-right: 10px; margin-left:10px;" >';	
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		minHtml += '</select><spring:message code="schedule.minute" />';	
		$( "#a_min" ).append(minHtml);
	}
	
	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeFromHour(){
		var hour = "";
		var hourHtml ="";
		
		hourHtml += '<select class="select t7" name="from_exe_h" id="from_exe_h" style="margin-right: 10px;">';	
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
		
		minHtml += '<select class="select t7" name="from_exe_m" id="from_exe_m" style="margin-right: 10px; margin-left:10px;">';	
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
</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">보안정책등록</p>
			<div class="contents">
				<div class="cmm_tab">
					<ul id="tab1">
						<li class="atv"><a href="javascript:selectTab('info')"><spring:message code="properties.basic_info" /></a></li>
						<li><a href="javascript:selectTab('option')">옵션</a></li>
						<li><a href="javascript:selectTab('accessControl')">접근제어정책</a></li>
					</ul>
					<ul id="tab2" style="display: none;">
						<li><a href="javascript:selectTab('info')"><spring:message code="properties.basic_info" /></a></li>
						<li class="atv"><a href="javascript:selectTab('option')">옵션</a></li>
						<li><a href="javascript:selectTab('accessControl')">접근제어정책</a></li>
					</ul>
					<ul id="tab3" style="display: none;">
						<li><a href="javascript:selectTab('info')"><spring:message code="properties.basic_info" /></a></li>
						<li><a href="javascript:selectTab('option')">옵션</a></li>
						<li class="atv"><a
							href="javascript:selectTab('accessControl')">접근제어정책</a></li>
					</ul>
				</div>

				<div id="info">
					<table class="write">
						<caption><spring:message code="properties.basic_info" /></caption>
						<colgroup>
							<col style="width: 110px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">보안정책이름</th>
								<td><input type="text" class="txt" name="policyName" id="policyName" /></td>

							</tr>
							<tr>
								<th scope="row" class="ico_t1">보안정책설명</th>
								<td><input type="text" class="txt" name="policyComment"
									id="policyComment" /></td>
							</tr>

							<tr>
								<th scope="row" class="ico_t1" colspan="4">암호화정책 
								<span onclick="fn_encryptPolicyAddForm();" style="cursor: pointer">
									<img src="../images/popup/plus.png" alt="" style="float: right;"/></span>
									<span onclick="fn_encryptPolicyDelForm();" style="cursor: pointer">
									<img src="../images/popup/minus.png" alt="" style="float: right;"/></span>
								</th>
							</tr>
							<tr>
								<th colspan="4">
									<table id="encryptPolicyTable" class="display" cellspacing="0"
										width="100%">
										<thead>
											<tr>
												<th width="10"></th>
												<th width="20">No</th>
												<th width="120">시작위치</th>
												<th width="100">길이</th>
												<th width="100">암호화알고리즘</th>
												<th width="100">암호화키</th>
												<th width="80">초기벡터</th>
												<th width="100">운영모드</th>
											</tr>
										</thead>
									</table>
								</th>
							</tr>
						</tbody>
					</table>

				</div>

				<div id="option">
				<table class="write">
						<caption>옵션</caption>
						<colgroup>
							<col style="width: 150px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">기본접근허용</th>
								<td><div class="inp_rdo">
									<input name="rdo" id="rdo_2_1" type="radio" checked="checked">
									<label for="rdo_2_1" style="margin-right: 15%;">예</label>
										<input name="rdo" id="rdo_2_2" type="radio">
									<label for="rdo_2_2">아니오</label>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">접근 거부시 처리</th>
								<td><select class="select" id="" name="">
									<option value="ERROR">ERROR</option>
								</select></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">데이터 타입</th>
								<td><select class="select" id="" name="">
									<option value="STRING">STRING</option>
								</select></td>
							</tr>
							<tr>
								<th scope="row" colspan="2">
									<div class="inp_chk">
									<span style="margin-right: 10%;">
										<input type="checkbox" id="option_1_1" name=""/>
										<label for="option_1_1">실패 로그 기록</label>
									</span>
									<span style="margin-right: 10%;">
										<input type="checkbox" id="option_1_2" name=""/>
										<label for="option_1_2">로그압축</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_3" name=""/>
										<label for="option_1_3">이중 암호화 방지</label>
									</span>
									</div>
								</th>
							</tr>
							<tr>
								<th scope="row" colspan="2">
									<div class="inp_chk">
									<span style="margin-right: 10%;">
										<input type="checkbox" id="option_1_4" name=""/>
										<label for="option_1_4">성공 로그 기록</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_5" name=""/>
										<label for="option_1_5">NULL 암호화</label>
									</span>
									</div>
								</th>
							</tr>
						</tbody>
					</table>
				</div>

				<div id="accessControl">
					<table class="write">
						<caption>접근제어정책</caption>
						<colgroup>
							<col style="width: 110px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1" colspan="4">접근제어정책 
								<span onclick="fn_accessControlAddForm();" style="cursor: pointer">
									<img src="../images/popup/plus.png" alt="" style="float: right;"/></span>
									<span onclick="fn_accessControlDelForm();" style="cursor: pointer">
									<img src="../images/popup/minus.png" alt="" style="float: right;"/></span>
								</th>
							</tr>
							<tr>
								<th colspan="4">
									<table id="accessControlTable" class="display" cellspacing="0" width="100%">
										<thead>
											<tr>									
												<th width="10"></th>
												<th width="20">No</th>
												<th width="50">규칙이름</th>
												<th width="100">서버인스턴스</th>
												<th width="50">db사용자</th>
												<th width="100">eXperDB사용자</th>
												<th width="50">OS사용자</th>
												<th width="100">프로그램이름</th>
												<th width="100">접근 ip 주소</th>
												<th width="100">IP 주소 마스크 </th>
												<th width="100">접근mac 주소</th>
												<th width="50">기간</th>
												<th width="50">시간대</th>
												<th width="50">요일</th>
												<th width="150">대량작업 임계건수</th>
												<th width="50">초</th>
												<th width="50">추가필드</th>
												<th width="100">호스트이름</th>
												<th width="100">접근허용여부</th>
											</tr>
										</thead>
									</table>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<div class="btn_type_02">
				<span class="btn btnC_01">
					<button type="button" onclick="fn_insert()">저장</button>
				</span> <a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>

	<div id="loading">
		<img src="/images/spin.gif" alt="" />
	</div>
	
	<!--  popup -->
	<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" >
				<p class="tit">암복호화 정책 등록</p>
					<form name="ipadr_form">
						<table class="write">
							<caption>암복호화 정책 등록</caption>
							<colgroup>
								<col style="width:130px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1">시작위치</th>
									<td><input type="text" class="txt" name="" id="" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">길이</th>
									<td><input type="text" class="txt" name="" id="" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">암호화 알고리즘</th>
									<td><select class="select" id="" name="">
									<option value="SEED-128">SEED-128</option>
									<option value="ARIA-128">ARIA-128</option>
									<option value="ARIA-192">ARIA-192</option>
									<option value="ARIA-256">ARIA-256</option>
									<option value="AES-128">AES-128</option>
									<option value="AES-256">AES-256</option>
									<option value="SHA-256">SHA-256</option>
									</select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">암호화 키</th>
									<td><select class="select" id="" name="">
									<option value="AES-256">AES-256</option></select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">초기 벡터</th>
									<td><select class="select" id="" name="">
									<option value="FIXED">FIXED</option>
									<option value="RANDOM">RANDOM</option>
									</select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">운영모드</th>
									<td><select class="select" id="" name="">
									<option value="CBC">CBC</option>
									<option value="CTR">CTR</option>
									</select></td>
								</tr>
							</tbody>
						</table>
					</form>
				<div class="btn_type_02">
					<a href="#n" class="btn"><span>저장</span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
		<!--  popup -->
	<div id="pop_layer2" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" >
				<p class="tit">접근제어 정책 등록</p>
					<form name="ipadr_form">
						<table class="write">
							<caption>접근제어 정책 등록</caption>
							<colgroup>
								<col style="width:130px;" />
								<col />
								<col style="width:130px;" />
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
												<span class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="from" name="b_exe_dt" title="스케줄시간설정"  />
														
												</span>
										</span>
										 &nbsp&nbsp&nbsp&nbsp&nbsp  ~ &nbsp&nbsp&nbsp&nbsp&nbsp  
										<span id="calendar">
												<span class="calendar_area">
														<a href="#n" class="calendar_btn">달력열기</a>
														<input type="text" class="calendar" id="to" name="a_exe_dt" title="스케줄시간설정"  />
														
												</span>
										</span>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">시간대</th>
									<td colspan="2"><span id="b_hour"></span><span id="b_min"></span>
									&nbsp&nbsp&nbsp&nbsp&nbsp  ~ &nbsp&nbsp&nbsp&nbsp&nbsp  
									<span id="a_hour"></span><span id="a_min"></span></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">임계치(대량작업)</th>
									<td><input type="text" class="txt" name="" id="" style="width: 50px;"/>&nbsp&nbsp건수/ &nbsp&nbsp
									<input type="text" class="txt" name="" id="" style="width: 50px;"/>초
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
									<td><div class="inp_rdo">
									<input name="rdo" id="rdo_2_3" type="radio" checked="checked">
									<label for="rdo_2_3" style="margin-right: 15%;">접근허용</label>
										<input name="rdo" id="rdo_2_4" type="radio">
									<label for="rdo_2_4">접근거부</label>
									</div></td>
								</tr>
							</tbody>
						</table>
					</form>
				<div class="btn_type_02">
					<a href="#n" class="btn"><span>저장</span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer2'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
	
</body>
</html>