<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

    <script>
    var table = null;
    
    function fn_init(){
    	/* ********************************************************
    	 * work리스트
    	 ******************************************************** */
    	table = $('#scheduleFailList').DataTable({
    	scrollY : "245px",
    	scrollX : true,
    	bDestroy: true,
    	processing : true,
    	searching : false,	
    	bSort: false,
    	columns : [
    		{data : "rownum", className : "dt-center", defaultContent : ""}, 
    		{data : "scd_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
    			}
    		}, 
    		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
    		{data : "wrk_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
    			}
    		}, 
    		{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""}, 
    		{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""}, 
    		//{data : "exe_result", className : "dt-center", defaultContent : ""},
	   		{
				data : "exe_result",
				render : function(data, type, full, meta) {
					var html = '';
					html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			}
    	],'select': {'style': 'multi'}
    	});
    	
    	
    	table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
    	table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
        table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
        table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
        table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
        $(window).trigger('resize');
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
   					alert('<spring:message code="message.msg02" />');
   					 location.href = "/";
   				} else if(xhr.status == 403) {
   					alert('<spring:message code="message.msg03" />');
   		             location.href = "/";
   				} else {
   					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
   				}
   			},
   			success : function(result) {
   				table.rows({selected: true}).deselect();
   				table.clear().draw();
   				table.rows.add(result).draw();
   			}
   		}); 
  	});

    
    
    </script>
<%@include file="../../cmmn/workRmanInfo.jsp"%>
<%@include file="../../cmmn/workDumpInfo.jsp"%>
<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="schedule.scheduleFailHistory"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="message.msg171"/></li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Function</li>
					<li><spring:message code="menu.schedule" /></li>
					<li class="on"><spring:message code="schedule.scheduleFailHistory"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="overflow_area">
				
				<table id="scheduleFailList" class="display" cellspacing="0" width="100%">
				<caption>스케줄 실패 리스트</caption>
					<thead>
						<tr>
							<th width="30"><spring:message code="common.no"/></th>
							<th width="200" class="dt-center"><spring:message code="schedule.schedule_name"/></th>
							<th width="100"><spring:message code="common.dbms_name"/></th>
							<th width="200"class="dt-center"><spring:message code="common.work_name"/></th>
							<th width="150"><spring:message code="schedule.work_start_datetime"/></th>
							<th width="150"><spring:message code="schedule.work_end_datetime"/></th>
							<th width="100"><spring:message code="schedule.result"/></th>
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->