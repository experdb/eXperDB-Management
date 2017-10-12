<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dumpLogList.jsp
	* @Description : dump Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>
<script type="text/javascript">
var table = null;

function fn_init(){
   	table = $('#logList').DataTable({	
		scrollY: "250px",	
		searching : false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "db_nm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "file_sz", className: "dt-center", defaultContent: ""},
 		         	{ data: "bck_file_pth", className: "dt-center", defaultContent: ""},
 		         	{ data: "exe_rslt_cd", className: "dt-center", defaultContent: ""}
 		        ] 
	});
}

$(window.document).ready(function() {
	fn_init();
	
	var today = new Date();
	var day_end = today.toJSON().slice(0,10);
	
	today.setDate(today.getDate() - 7);
	var day_start = today.toJSON().slice(0,10); 

	$("#wrk_strt_dtm").val(day_start);
	$("#wrk_end_dtm").val(day_end);
	
	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		bck_bsn_dscd : "dump",
	  		wrk_strt_dtm : day_start,
	  		wrk_end_dtm : day_end
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
	
	$( ".calendar" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth : true,
		changeYear : true
 	});
});

function fn_find_list(){
	var db_id = $("#db_id").val();
	//if(db_id == "") db_id = 0;
	var wrk_strt_dtm = $("#wrk_strt_dtm").val();
	var wrk_end_dtm = $("#wrk_end_dtm").val();
	var exe_rslt_cd = $("#exe_rslt_cd").val();
	
	alert(db_id);
	alert(wrk_strt_dtm);
	alert(wrk_end_dtm);
	alert(exe_rslt_cd);

	
	
	//fn_init();

	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		bck_bsn_dscd : "dump",
	  		db_id : db_id,
	  		wrk_strt_dtm : wrk_strt_dtm,
	  		wrk_end_dtm : wrk_end_dtm,
	  		exe_rslt_cd : exe_rslt_cd
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
}

$(function() {
	//조회버튼 클릭시
	$("#btnSelect").click(function() {
		alert("Aaaaaaa");
		
		var wrk_strt_dtm = $("#wrk_strt_dtm").val();
		var wrk_end_dtm = $("#wrk_end_dtm").val();

		if (wrk_strt_dtm != "" && wrk_end_dtm == "") {
			alert("종료일자를 선택해 주세요");
			return false;
		}

		if (wrk_end_dtm != "" && wrk_strt_dtm == "") {
			alert("시작일자를 선택해 주세요");
			return false;
		}
		fn_find_list();
	});
});
</script>
<!-- contents -->
<div id="contents">
	<div class="location">
		<ul>
			<li>DB서버</li>
			<li>${db_svr_nm}</li>
			<li class="on">백업 이력</li>
		</ul>
	</div>

	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>Dump 백업관리<a href="#n"><img src="/images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>DB서버</li>
					<li>${db_svr_nm}</li>
					<li class="on">백업 이력</li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul>
					<li><a href="/backup/rmanLogList.do?db_svr_id=${db_svr_id}">Rman 백업 이력</a></li>
					<li class="atv"><a href="/backup/dumpLogList.do?db_svr_id=${db_svr_id}">Dump 백업 이력</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button id="btnSelect">조회</button></span>
				</div>
				<div class="sch_form">
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:80px;" />
							<col style="width:230px;" />
							<col style="width:100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10">작업기간</th>
								<td colspan="3">
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_strt_dtm" id="wrk_strt_dtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_end_dtm" id="wrk_end_dtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">상태</th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value="">선택</option>
										<option value="S">성공</option>
										<option value="F">실패</option>
									</select>
								</td>
								<th scope="row" class="t9">Database명</th>
								<td>
									<select name="db_id" id="db_id" class="select t5">
										<option value="">선택</option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
										<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>	
								</td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
				<div class="overflow_area">
					<table class="list" id="logList" cellspacing="0" width="100%">
						<caption>Dump 백업관리 이력화면 리스트</caption>
						<thead>
							<tr>
								<th scope="col">NO</th>
								<th scope="col">Database</th>
								<th scope="col">작업시작 시간</th>
								<th scope="col">작업종료 시간</th>
								<th scope="col">Size</th>
								<th scope="col">백업파일경로</th>
								<th scope="col">상태</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->

		
		</div><!-- // container -->
	</div>
</body>
</html>