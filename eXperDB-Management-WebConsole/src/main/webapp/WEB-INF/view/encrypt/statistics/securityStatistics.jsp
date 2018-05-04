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
<!-- <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> -->
<script type="text/javascript">
/* google.charts.load('current', {packages: ['corechart', 'bar']});
google.charts.setOnLoadCallback(drawMultSeries); */

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
	
	fn_selectSecurityStatistics();

});

	function fn_selectSecurityStatistics(){
		var from = $('#from').val().replace(/-/gi, "")+"00";
		var to = $('#from').val().replace(/-/gi, "")+"24";
	
		$.ajax({
			url : "/selectSecurityStatistics.do",
			data : {
				from : from,
				to : 	to,
				categoryColumn : $('#categoryColumn').val(),
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {		
				if(data.resultCode == "0000000000"){
				 	var html ="";
					for(var i=0; i<data.list.length; i++){
	
						html += '<tr>';
						html += '<td>'+data.list[i].categoryColumn+'</td>';
						html += '<td>'+data.list[i].encryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].encryptFailCount+'</td>';
						html += '<td>'+data.list[i].decryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].decryptFailCount+'</td>';
						html += '<td>'+data.list[i].sumCount+'</td>';
						html += '</tr>';
						$( "#col" ).html(html);			
					} 
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					location.href="/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");
				}
			}
		});		
	}
	
	
	function fn_select(){
		fn_selectSecurityStatistics();
	}
	

	
/* 	function drawMultSeries(data) {
			var arrData = [];
			var arr = ["구분", "성공", "실패"]; 
			
			var encSuccessCount = 0;
			var encFailCount = 0;
			var decSuccessCount = 0;
			var decFailCount = 0;
			
			arrData.push(arr);
		
			for(var i=0; i<data.list.length; i++){
				
				encSuccessCount += Number(data.list[i].encryptSuccessCount);
				encFailCount += Number(data.list[i].encryptFailCount);
				decSuccessCount += Number(data.list[i].decryptSuccessCount);
				decFailCount += Number(data.list[i].decryptFailCount);
			}	
			var encArr = ["암호화", encSuccessCount, encFailCount]; 
			var decArr = ["복호화", decSuccessCount, decFailCount]; 
	
			arrData.push(encArr);
			arrData.push(decArr);

		
     
	      var data = google.visualization.arrayToDataTable(arrData);

	      var options = {
	        chartArea: {width: '85%'},
	        hAxis: {
	          title: 'Total Encrypt / Decrypt Count',
	          minValue: 0
	        },
	      };

	      var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
	      chart.draw(data, options);
	    } */
	
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
									<select class="select t5" id="categoryColumn">
										<option value="SITE_ACCESS_ADDRESS">클라이언트 주소</option>
										<option value="PROFILE_NM">정책 이름</option>										
										<option value="HOST_NM">호스트 이름</option>
										<option value="EXTRA_NM">추가 필드</option>
										<option value="MODULE_INFO">모듈 정보</option>
										<option value="LOCATION_INFO">DB 컬럼</option>
										<option value="SERVER_LOGIN_ID">DB 사용자 아이디</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				

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
							<tbody id="col">
							</tbody>
						</table>						
			</div>
				<!-- <div id="chart_div" ></div> -->		
		</div>
	</div>
</div>
<!-- // contents -->
