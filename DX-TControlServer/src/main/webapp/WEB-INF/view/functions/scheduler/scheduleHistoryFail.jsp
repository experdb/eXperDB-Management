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
   			beforeSend: function(xhr) {
   		        xhr.setRequestHeader("AJAX", true);
   		     },
   			error : function(xhr, status, error) {
   				if(xhr.status == 401) {
   					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
   					 location.href = "/";
   				} else if(xhr.status == 403) {
   					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
   		             location.href = "/";
   				} else {
   					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
   				}
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
			<h4>스케줄실패이력<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>정상적으로 완료되지 않은 스케줄 이력을 조회합니다.</li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Function</li>
					<li>스케줄</li>
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