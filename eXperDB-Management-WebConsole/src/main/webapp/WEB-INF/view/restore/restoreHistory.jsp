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

	$("#restore_strtdtm").val(day_start);
	$("#restore_enddtm").val(day_end);
	
	fn_get_rman_list();
	
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
						{ data: "restore_exp", className: "dt-left", defaultContent: ""},
			         	{ data: "timeline", className: "dt-center", defaultContent: ""}, 
			         	{ data: "restore_strtdtm", className: "dt-center", defaultContent: ""},
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
			         	{
			    			data : "",
			    			render : function(data, type, full, meta) {
			    				var html = '<span class="btn btnC_01 btnF_02"><button onclick="fn_restoreLogInfo('+full.restore_sn+')">로그</button></span>';
			    				
			    				return html;
			    			},
			    			className : "dt-center",
			    			defaultContent : ""
			    		},			         	
			         	{ data: "regr_id", className: "dt-center", defaultContent: ""},
			    		{ data: "restore_sn", className: "dt-center", defaultContent: "", visible: false}
 		        ]
	});
   	
   	tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
   	tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
   	tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
   	tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
   	tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '120px');
   	tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '120px');
   	tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '120px');
   	tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '75px');
   	tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '70px');
   	tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
   	tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
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
   	tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
   	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
   	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
   	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
    $(window).trigger('resize');
}



/* ********************************************************
 * Click Search Button
 ******************************************************** */
$(function() {
	
	$(function() {	
  		$('#logRmanList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     		tableRman.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
	
	$(function() {	
  		$('#logDumpList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	tableDump.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
	
	$("#btnSelect").click(function() {
		var restore_strtdtm = $("#restore_strtdtm").val();
		var restore_enddtm = $("#restore_enddtm").val();

		if (restore_strtdtm != "" && restore_enddtm == "") {
			alert("<spring:message code='message.msg14' />");
			return false;
		}

		if (restore_enddtm != "" && restore_strtdtm == "") {
			alert("<spring:message code='message.msg15' />");
			return false;
		}

		if(tab == "rman"){
			fn_get_rman_list();
		}else{
			fn_get_dump_list();
		}
	});
});


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


function fn_restoreLogInfo(restore_sn){
	
	//window.open("/restoreLogInfo.do?restore_sn="+ restore_sn+ "&db_svr_id="+db_svr_id  ,"popRestoreLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=1200,height=970,top=0,left=0");	
	window.open("/restoreLogView.do?restore_sn=" + restore_sn+ "&db_svr_id="+db_svr_id  ,"popRestoreLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=1200,height=970,top=0,left=0");
	
/*   	$.ajax({
 		url : '/restoreLogInfo.do',
 		type : 'post',
 		data : {
 			restore_sn : restore_sn,
 			db_svr_id : db_svr_id
 		},	
 		success : function(result) {
 			
 			$("#exelog").append(result.strResultData); 
 		},
 		beforeSend: function(xhr) {
 	        xhr.setRequestHeader("AJAX", true);
 	     },
 		error : function(xhr, status, error) {
 			if(xhr.status == 401) {
 				alert('<spring:message code="message.msg02" />');
 				top.location.href = "/";
 			} else if(xhr.status == 403) {
 				alert('<spring:message code="message.msg03" />');
 				top.location.href = "/";
 			} else {
 				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
 			}
 		}
 	}); 	 */
}
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="restore.Recovery_history" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="restore.Recovery_history" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on"><spring:message code="restore.Recovery_history" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab_rman">
					<li class="atv"><a href="javascript:selectTab('rman');"><spring:message code="restore.Emergency_Point-in-Time" /> <spring:message code="restore.Recovery_history" /></a></li>
					<li><a href="javascript:selectTab('dump');">Dump <spring:message code="restore.Recovery_history" /></a></li>
				</ul>
				<ul id="tab_dump" style="display:none">
					<li><a href="javascript:selectTab('rman');"><spring:message code="restore.Emergency_Point-in-Time" /> <spring:message code="restore.Recovery_history" /></a></li>
					<li class="atv"><a href="javascript:selectTab('dump');">Dump <spring:message code="restore.Recovery_history" /></a></li>
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
										<option value="0"><spring:message code="common.success" /></option>
										<option value="1"><spring:message code="etc.etc37" /></option>
										<option value="2">진행중</option>
										<option value="3"><spring:message code="common.failed" /></option>
									</select>
								</td>
								<th scope="row" class="t9 search_rman">복구구분</th>
								<td class="search_rman">
									<select name="restore_flag" id="restore_flag" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="0"><spring:message code="restore.Emergency_Recovery" /></option>
										<option value="1"><spring:message code="restore.Point-in-Time_Recovery" /></option>
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
								<th scope="row" class="t9"><spring:message code="restore.Recovery_name" /></th>
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
								<th width="100">복구구분</th>
								<th width="150"><spring:message code="restore.Recovery_name" /></th>
								<th width="200"><spring:message code="restore.Recovery_Description" /></th>
								<th width="120">TimeLine</th>
								<th width="120"><spring:message code="backup_management.work_start_time" /></th>
								<th width="120"><spring:message code="backup_management.work_end_time" /></th>
								<th width="75"><spring:message code="common.status" /></th>
								<th width="70">로그</th>
								<th width="100">작업자</th>
								<th width="0"></th>
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
								<th width="150"><spring:message code="restore.Recovery_name" /></th>
								<th width="100"><spring:message code="restore.Recovery_Description" /></th>
								<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
								<th width="100">Database</th>
								<th width="100">SIZE</th>
								<th width="170"><spring:message code="backup_management.fileName" /></th>			
								<th width="120"><spring:message code="backup_management.work_start_time" /></th>						
								<th width="120"><spring:message code="backup_management.work_end_time" /></th>
								<th width="100"><spring:message code="common.status" /></th>
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
