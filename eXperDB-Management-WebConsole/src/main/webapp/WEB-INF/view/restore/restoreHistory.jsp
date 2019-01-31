<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : restoreHistory.jsp
	* @Description : restoreHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.09     최초 생성
	*
	* author 변승우 대리
	* since 2019.01.09
	*
	*/
%>
<script type="text/javascript">
var tableRman = null;
var tableDump = null;
var tab = "rman";
var db_svr_id = "${db_svr_id}";

/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(function() {

	fn_rman_init();
	fn_dump_init();
	
	var today = new Date();
	var day_end = today.toJSON().slice(0,10);
	
	today.setDate(today.getDate() - 7);
	var day_start = today.toJSON().slice(0,10); 

	$("#wrk_strt_dtm").val(day_start);
	$("#wrk_end_dtm").val(day_end);
	
	$( ".calendar" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth : true,
		changeYear : true
 	});
	$("#logDumpListDiv").hide();
});



/* ********************************************************
 * Rman Data Table initialization
 ******************************************************** */
function fn_rman_init(){
   	tableRman = $('#logRmanList').DataTable({	
		scrollY: "405px",
		scrollX : true,
		searching : false,	
		deferRender : true,
		bSort: false,
	    columns : [
			     		{ data: "rownum", className: "dt-center", defaultContent: ""}, 
			     		{
							data : "restore_flag",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.restore_flag == '0') {
									html += '긴급복구';
								} else {
									html +='시점복구';
								}
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},		        
						{ data: "restore_nm", className: "dt-center", defaultContent: ""},
						{ data: "restore_exp", className: "dt-center", defaultContent: ""},
			         	{ data: "timeline", className: "dt-center", defaultContent: ""}, 
			         	{ data: "restore_strdtm", className: "dt-center", defaultContent: ""},
			         	{ data: "restore_enddtm", className: "dt-center", defaultContent: ""}, 
			         	{
							data : "restore_cndt",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.restore_cndt == '0') {
									html += '성공';
								} else if (full.restore_cndt == '1'){
									html +='시작';
								} else if (full.restore_cndt == '2'){
									html +='진행중';
								} else {
									html +='실패';
								}
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},		
						
			         	{ data: "restore_cndt", className: "dt-center", defaultContent: ""},
			         	{ data: "exelog", className: "dt-center", defaultContent: ""}, 
			         	{ data: "regr_id", className: "dt-center", defaultContent: ""}
 		        ]
	});
   	
   	tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
   	tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
   	tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
   	tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
   	tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '90px');
   	tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '230px');
   	tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
   	tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
   	tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '70px');
   	tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
    $(window).trigger('resize'); 
}

/* ********************************************************
 * Dump Data Table initialization
 ******************************************************** */
function fn_dump_init(){
   	tableDump = $('#logDumpList').DataTable({	
		scrollY: "405px",	
		scrollX: true,	
		bDestroy: true,
		paging : true,
		processing : true,
		searching : false,	
		deferRender : true,
		bSort: false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		}, 
		    		{ data: "ipadr", className: "dt-center", defaultContent: ""},
		    		{ data : "wrk_exp",
		    			render : function(data, type, full, meta) {	 	
		    				var html = '';					
		    				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
		    				return html;
		    			},
		    			defaultContent : ""
		    		},  
 		         	{ data: "db_nm", defaultContent: ""}, 
 		         	//{ data: "file_sz", className: "dt-center", defaultContent: ""},
 		         	
 		         	 {data : "file_sz", defaultContent : ""
	 		   			,"render": function (data, type, full) {
	 		   				if(full.file_sz != 0){
				 		   		  var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
				 		   		  var e = Math.floor(Math.log(full.file_sz) / Math.log(1024));
				 		   		  return (full.file_sz / Math.pow(1024, e)).toFixed(2) + " " + s[e];
	 		   				}else{
	 		   					return full.file_sz;
	 		   				}
	 		   			}
	 		   		 },
	 		   		  
 		         	
 		         	{data : "bck_file_pth", defaultContent : ""
	 		   			,"render": function (data, type, full) {
	 		   				  return '<span onClick=javascript:fn_dumpShow("'+full.bck_file_pth+'","'+full.db_svr_id+'"); title="'+full.bck_file_pth+'" class="bold">' + full.bck_file_pth + '</span>';
	 		   			}
	 		   		 },
 		         	{ data: "bck_filenm", defaultContent: ""},
 		         	{ data: "wrk_strt_dtm", defaultContent: ""}, 
 		         	{ data: "wrk_end_dtm", defaultContent: ""},  		         			         	
 		         	{ data: "wrk_dtm", defaultContent: ""},
	 		   		{
	 					data : "exe_rslt_cd",
	 					render : function(data, type, full, meta) {
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
	 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</span>';
	 						} else if(full.exe_rslt_cd == 'TC001702'){
	 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
	 						} else {
	 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/><spring:message code="etc.etc28"/></span>';
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
 		        ],'select': {'style': 'multi'} 
	});

   	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
   	tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
   	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
   	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '170px');
   	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
   	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
    $(window).trigger('resize');
}


	/* ********************************************************
	 * Get Rman Restore Log List
	 ******************************************************** */
	function fn_get_rman_list(){
		$.ajax({
			url : "/rmanRestoreHistory.do",
		  	data : {
		  		db_svr_id : db_svr_id,
		  		restore_flag : $("#restore_flag").val(),
		  		restore_strtdtm : $("#restore_strtdtm").val(),
		  		restore_enddtm : $("#restore_enddtm").val(),
		  		restore_cndt : $("#restore_cndt").val(),
		  		restore_nm : $('#restore_nm').val()
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
			success : function(result) {
				tableRman.rows({selected: true}).deselect();
				tableRman.clear().draw();
				tableRman.rows.add(result).draw();
			}
		});
	}


/* ********************************************************
 * Tab Click
 ******************************************************** */
var clickDump = false;
function selectTab(intab){
	tab = intab;
	if(intab == "dump"){
		$("#tab_rman").hide();
		$("#tab_dump").show();
		$(".search_rman").hide();
		$(".search_dump").show();
		$("#logRmanListDiv").hide();
		$("#logDumpListDiv").show();
		if(clickDump == false){
			fn_get_dump_list();
			clickDump = true;
		}
	}else{
		$("#tab_rman").show();
		$("#tab_dump").hide();
		$(".search_rman").show();
		$(".search_dump").hide();
		$("#logDumpListDiv").hide();
		$("#logRmanListDiv").show();
	}
}


</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>복구이력<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>복구이력</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on">복구이력</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab_rman">
					<li class="atv"><a href="javascript:selectTab('rman');">긴급/시점 복구이력</a></li>
					<li><a href="javascript:selectTab('dump');">Dump 복구이력</a></li>
				</ul>
				<ul id="tab_dump" style="display:none">
					<li><a href="javascript:selectTab('rman');">긴급/시점 복구이력</a></li>
					<li class="atv"><a href="javascript:selectTab('dump');">Dump 복구이력</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button type="button" id="btnSelect"><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:110px;" />
							<col style="width:230px;" />
							<col style="width:110px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10"><spring:message code="common.work_term" /></th>
								<td colspan="3">
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="restore_strtdtm" id="restore_strtdtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="restore_enddtm" id="restore_enddtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr style="height:35px;">
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="restore_cndt" id="restore_cndt" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="0">성공</option>
										<option value="1">시작</option>
										<option value="2">진행중</option>
										<option value="3">실패</option>
									</select>
								</td>
								<th scope="row" class="t9 search_rman">복구구분</th>
								<td class="search_rman">
									<select name="restore_flag" id="restore_flag" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="0">긴급복구</option>
										<option value="1">시점복구</option>
									</select>
								</td>
								<th scope="row" class="t9 search_dump" style="display:none;"><spring:message code="common.database" /></th>
								<td class="search_dump" style="display:none;">
									<select name="db_id" id="db_id" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
										<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>	
								</td>							
							</tr>
							<tr>
								<th scope="row" class="t9">복구명</th>
								<td><input type="text" name="restore_nm" id="restore_nm" class="txt t5" maxlength="25"  /></td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
				<div class="overflow_area" id="logRmanListDiv">
					<table class="display" id="logRmanList" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="150">복구구분</th>
								<th width="100">복구명</th>
								<th width="150">복구설명</th>
								<th width="90">TimeLine</th>
								<th width="230">작업시작시간</th>
								<th width="100">작업종료시간 </th>
								<th width="100">상태</th>
								<th width="70">로그</th>
								<th width="100">작업자</th>
							</tr>
						</thead>
					</table>
				</div>
				<div class="overflow_area" id="logDumpListDiv">
					<table class="display" id="logDumpList" cellspacing="0" width="100%">
						<caption>Dump 백업관리 이력화면 리스트</caption>
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="150">복구명</th>
								<th width="100">복구설명</th>
								<th width="150">DBMS아이피</th>
								<th width="100">Database</th>
								<th width="100">SIZE</th>
								<th width="170">백업파일명</th>			
								<th width="170">작업시작시간</th>						
								<th width="100">작업종료시간</th>
								<th width="100">상태</th>
								<th width="100">로그</th>
								<th width="100">작업자</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>

	</div>
</div>
<!-- // contents -->
