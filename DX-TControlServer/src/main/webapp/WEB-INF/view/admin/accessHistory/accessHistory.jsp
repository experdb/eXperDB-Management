<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	var table = null;

	function fn_init() {
		table = $('#accessHistoryTable').DataTable({
			scrollY : "250px",
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
		var dateFormat = "yyyy-mm-dd", 
		from = $("#from").datepicker({
				changeMonth : true,
				changeYear : true,
				onClose: function( selectedDate ) {
				$( "#to" ).datepicker( "option", "minDate", selectedDate );
				}
			})
								
		to = $("#to").datepicker({
				changeMonth : true,
				changeYear : true,	
				onClose: function( selectedDate ) {
				$( "#from" ).datepicker( "option", "maxDate", selectedDate );
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

		//조회버튼 클릭시
		$("#btnSelect").click(function() {
			var lgi_dtm_start = $("#from").val();
			var lgi_dtm_end = $("#to").val();
			var usr_nm = "%" + $("#usr_nm").val() + "%";

			if (lgi_dtm_start != "" && lgi_dtm_end == "") {
				alert("종료일자를 선택해 주세요");
				return false;
			}

			if (lgi_dtm_end != "" && lgi_dtm_start == "") {
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
		var usr_nm = "%" + $("#usr_nm").val() + "%";

		if (lgi_dtm_start != "" && lgi_dtm_end == "") {
			alert("종료일자를 선택해 주세요");
			return false;
		}

		if (lgi_dtm_end != "" && lgi_dtm_start == "") {
			alert("시작일자를 선택해 주세요");
			return false;
		}

		var form = document.excelForm;

		$("#lgi_dtm_start").val(lgi_dtm_start);
		$("#lgi_dtm_end").val(lgi_dtm_end);
		$("#user_nm").val(usr_nm);

		form.action = "/accessHistory_Excel.do";
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
		<div id="contents">
			<div class="location">
				<ul>
					<li>Admin</li>
					<li class="on">사용자 접근내역</li>
				</ul>
			</div>

			<div class="contents_wrap">
				<h4>사용자 접근내역화면<a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
				<div class="contents">
					<div class="cmm_grp">
						<div class="btn_type_float">
							<span class="btn btnC_01 btn_fl"><button onclick="fn_ExportExcel()">엑셀저장</button></span> 
							<span class="btn btn_fr"><button id="btnSelect">조회</button></span>
						</div>
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 90px;" />
									<col style="width: 400px;" />
									<col style="width: 80px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t10">접근일자</th>
										<td>
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="from" name="from" title="기간검색 시작날짜" /> <span class="wave">~</span>
												<a href="#n" class="calendar_btn">달력열기</a> 
												<input type="text" class="calendar" id="to" name="to" title="기간검색 종료날짜" />
											</div>
										</td>
										<th scope="row" class="t9">사용자</th>
										<td><input type="text" class="txt t2"  id="usr_nm"/></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="overflow_area">
							<table id="accessHistoryTable" class="list" cellspacing="0" width="100%">
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
						</div>
					</div>
				</div>
			</div>
		</div>
		
		