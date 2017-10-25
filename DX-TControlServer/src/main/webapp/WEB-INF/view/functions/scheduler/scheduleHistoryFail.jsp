<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

    <script>
    var table = null;
    
    function fn_init(){
    	/* ********************************************************
    	 * work리스트
    	 ******************************************************** */
    	table = $('#scheduleFailList').DataTable({
    	scrollY : "245px",
    	bDestroy: true,
    	processing : true,
    	searching : false,	
    	columns : [
    		{data : "rownum", className : "dt-center", defaultContent : "", }, 
    		{data : "scd_nm", className : "dt-center", defaultContent : ""}, 
    		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
    		{data : "wrk_nm", className : "dt-center", defaultContent : ""}, 
    		{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""}, 
    		{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""}, 
    		{data : "exe_result", className : "dt-center", defaultContent : ""},
    	]
    	});
    }

    
    /* ********************************************************
     * 페이지 시작시 함수
     ******************************************************** */
    $(window.document).ready(function() {
    	fn_init();
  
   	  	$.ajax({
   			url : "/selectScheduleFailList.do",
   			data : {},
   			dataType : "json",
   			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
   			success : function(result) {

   				table.clear().draw();
   				table.rows.add(result).draw();
   			}
   		}); 
  	});

    
    
    </script>
    
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스케줄실패이력<a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>Scheduler</li>
					<li class="on">스케줄실패이력</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="overflow_area">
				
				<table id="scheduleFailList" class="cell-border display" >
				<caption>스케줄 실패 리스트</caption>
					<thead>
						<tr>
							<th>No</th>
							<th>스케줄명</th>
							<th>DBMS명</th>
							<th>Work명</th>
							<th>작업시작일시</th>
							<th>작업종료일시</th>
							<th>결과</th>
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->