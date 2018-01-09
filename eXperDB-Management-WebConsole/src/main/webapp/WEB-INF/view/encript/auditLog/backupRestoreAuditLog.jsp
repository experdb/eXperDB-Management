<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : backupRestoreAuditLog.jsp
	* @Description : backupRestoreAuditLog 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.09     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.09
	*
	*/
%>
<script>
	var table = null;

	function fn_init() {
		table = $('#table').DataTable({
			scrollY : "250px",
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
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}
	
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(19)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(20)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(21)').css('min-width', '100px');
		
	
	    $(window).trigger('resize');
	    
		//더블 클릭시
		$('#table tbody').on('dblclick', 'tr', function() {
	
		});
	}
	
	$(window.document).ready(function() {
		fn_init();
	});
	

	/* 조회 버튼 클릭시*/
	function fn_select() {

	}
	
	/* 다운로드 버튼 클릭시*/
	function fn_download() {

	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {

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

	});

</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>백업및복원<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li>백업및복원설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>데이터암호화</li>
					<li>감사로그</li>
					<li class="on">백업및복원</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select();"><button>조회</button></span>
					<span class="btn" onclick="fn_download();"><button>다운로드</button></span>
					<span class="btn" onclick="fn_delete();"><button>삭제</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 300px;" />
							<col style="width: 100px;" />
							</col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10">로그기간</th>
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
								<th scope="row" class="t9">접근자</th>
								<td>
									<select class="select t5">
										<option value="">전체</option>
									</select>
								</td>
								<th scope="row" class="t9">성공/실패</th>
								<td>
									<select class="select t5">
										<option value="">전체</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="table" class="display" cellspacing="0"width="100%">
						<thead>
							<tr>
								<th width="40"></th>
								<th width="100">NO</th>
								<th width="100">작업일시</th>
								<th width="100">작업자</th>
								<th width="100">작업자 주소</th>
								<th width="100">서버 주소</th>
								<th width="100">작업구분</th>
								<th width="100">백업구분</th>
								<th width="100">로그시작일시</th>
								<th width="100">로그종료일시</th>
								<th width="100">암호화 키</th>
								<th width="100">정책</th>
								<th width="100">서버</th>
								<th width="100">eXperDB사용자</th>
								<th width="100">환경설정</th>
								<th width="100">관리로그</th>
								<th width="100">사이트로그</th>
								<th width="100">백업로그</th>
								<th width="100">자원 사용 로그</th>
								<th width="100">상태로그</th>
								<th width="100">태이블 암호화 로그</th>
								<th width="100">파일경로</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
