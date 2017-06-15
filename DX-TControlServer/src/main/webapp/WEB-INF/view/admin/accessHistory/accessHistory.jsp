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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>화면접근이력</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/jquery-ui.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />

<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>

<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>

<!-- <script src="js/treeview/jquery.js" type="text/javascript"></script> -->
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>
<script>
	var table = null;

	function fn_init() {
		table = $('#accessHistoryTable').DataTable({
			scrollY : "300px",
			processing : true,
			searching : false,
			columns : [ 
	         		{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{ data: "exedtm_date", className: "dt-center", defaultContent: ""}, 
		         	{ data: "exedtm_hour", className: "dt-center", defaultContent: ""}, 
		         	{ data: "sys_cd_nm", className: "dt-center", defaultContent: ""}, 
		         	{ data: "usr_id", className: "dt-center", defaultContent: ""}, 
		         	{ data: "usr_nm", className: "dt-center", defaultContent: ""}, 
		         	{ data: "dept_nm", className: "dt-center", defaultContent: ""}, 
		         	{ data: "pst_nm", className: "dt-center", defaultContent: ""},  
		         	{ data: "lgi_ipadr", className: "dt-center", defaultContent: ""}
			]
		});
	}

	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectAccessHistory.do",
			data : {},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		});
	});

	$(function() {
		var dateFormat = "mm/dd/yy", 
		from = $("#from").datepicker({
					defaultDate : "+1w",
					changeMonth : true,
					changeYear: true,
					numberOfMonths : 1,
					prevText : '이전 달',
					nextText : '다음 달',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
				}).on("change", function() {
				to.datepicker("option", "minDate", getDate(this));
				}), 
		to = $("#to").datepicker({
					defaultDate : "+1w",
					changeMonth : true,
					changeYear: true,
					numberOfMonths : 1,
					prevText : '이전 달',
					nextText : '다음 달',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
				}).on("change", function() {
			from.datepicker("option", "maxDate", getDate(this));
				});

		function getDate(element) {
			var date;
			try {
				date = $.datepicker.parseDate(dateFormat, element.value);
			} catch (error) {
				date = null;
			}
			return date;
		}

		//조회버튼 클릭시
		$("#btnSelect").click(function() {
  			var lgi_dtm_start = $("#from").val();
			var lgi_dtm_end = $("#to").val();
			var usr_nm = "%"+$("#usr_nm").val()+"%";
			
			if(lgi_dtm_start!="" && lgi_dtm_end==""){
				alert("종료일자를 선택해 주세요");
				return false;
			}
			
			if(lgi_dtm_end!="" && lgi_dtm_start==""){
				alert("시작일자를 선택해 주세요");
				return false;
			}
			
			$.ajax({
				url : "/selectAccessHistory.do",
				data : {
					lgi_dtm_start : lgi_dtm_start,
					lgi_dtm_end : lgi_dtm_end,
					usr_nm : usr_nm
				},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {
					table.clear().draw();
					table.rows.add(result).draw();
				}
			});
		});
	});

	// 엑셀저장
	function fn_ExportExcel() {
		var lgi_dtm_start = $("#from").val();
		var lgi_dtm_end = $("#to").val();
		var usr_nm = "%"+$("#usr_nm").val()+"%";
		
		if(lgi_dtm_start!="" && lgi_dtm_end==""){
			alert("종료일자를 선택해 주세요");
			return false;
		}
		
		if(lgi_dtm_end!="" && lgi_dtm_start==""){
			alert("시작일자를 선택해 주세요");
			return false;
		}
		
		var form = document.excelForm;
		
		$("#lgi_dtm_start").val(lgi_dtm_start);
		$("#lgi_dtm_end").val(lgi_dtm_end);
		$("#user_nm").val(usr_nm);

		form.action = "/accessHistory_data_JxlExportExcel.do";
		form.submit();
		return;
	}
</script>
<body>
<form name="excelForm" method="post">
	<input type="hidden" name="lgi_dtm_start" id="lgi_dtm_start">
	<input type="hidden" name="lgi_dtm_end" id="lgi_dtm_end">
	<input type="hidden" name="user_nm" id="user_nm">
</form>

	<h2>화면접근이력</h2>
	<div id="button">
		<button onclick="fn_ExportExcel()">엑셀저장</button>
		<input type="button" value="조회" id="btnSelect" style="float: right;">
	</div>
	<br>
	<table style="border: 1px solid black; padding: 10px;" width="100%">
		<tr>
			<td>접근일자</td>
			<td><input type="text" id="from" name="from"> ~ <input
				type="text" id="to" name="to"></td>
			<td>사용자명</td>
			<td><input type="text" id="usr_nm"></td>
		</tr>
	</table>
	<br>
	<table id="accessHistoryTable" class="display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th>No</th>
				<th>일자</th>
				<th>시간</th>
				<th>구분</th>
				<th>아이디</th>
				<th>사용자명</th>
				<th>부서</th>
				<th>직급</th>
				<th>아이피</th>
			</tr>
		</thead>
	</table>
</body>
</html>