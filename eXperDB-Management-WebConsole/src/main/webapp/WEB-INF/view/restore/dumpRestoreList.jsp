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
	* @Class Name : dumpRestore.jsp
	* @Description : dumpRestore 화면
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
var tableDump = null;

/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(function() {

	fn_dump_init();
	
	var today = new Date();
	var day_end = today.toJSON().slice(0,10);
	
	today.setDate(today.getDate() - 7);
	var day_start = today.toJSON().slice(0,10); 

	$("#wrk_strt_dtm").val(day_start);
	$("#wrk_end_dtm").val(day_end);
	
	fn_get_dump_list();
	
	$( ".calendar" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth : true,
		changeYear : true
 	});
});


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
		         	{ data: "restore",
		         		"render" : function(data, type, full, meta) {
		         			var html = '';	
		         			html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_dumpRestorReg(); ><input type="button" value="복구"></span>';
		         			return html;
		         		},
		         		defaultContent: ""}, 
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
   	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
   	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
   	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '170px');
   	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(12 )').css('min-width', '100px');

    $(window).trigger('resize');
}
 
/* ********************************************************
 * 덤프 복구 등록
 ******************************************************** */
function fn_dumpRestorReg(){
	var datas = tableDump.rows('.selected').data();

	//var scd_id = table.row('.selected').data().scd_id;
	
	var form = document.dumpRestoreRegForm;
	//form.action = "/dumpRestoreRegVeiw.do?scd_id="+scd_id;
	form.action = "/dumpRestoreRegVeiw.do";
	form.submit();
	return;
	
}


/* ********************************************************
 * Get Dump Log List
 ******************************************************** */
function fn_get_dump_list(){
	var db_id = $("#db_id").val();
	if(db_id == "") db_id = 0;

	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		db_svr_id : $("#db_svr_id").val(),
	  		bck_bsn_dscd : "TC000202",
	  		db_id : db_id,
	  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#wrk_end_dtm").val(),
	  		exe_rslt_cd : $("#exe_rslt_cd").val(),
	  		wrk_nm : $('#wrk_nm').val(),
  			fix_rsltcd : $("#fix_rsltcd").val()
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
			tableDump.rows({selected: true}).deselect();
			tableDump.clear().draw();
			tableDump.rows.add(result).draw();
		}
	});
}


function fn_dumpShow(bck, db_svr_id){	
	  var frmPop= document.frmPopup;
	    var url = '/dumpShowView.do';
	    window.open('','popupView','width=1000, height=800');  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.bck.value = bck;
	    frmPop.db_svr_id.value = db_svr_id;  
	    frmPop.submit();   
}


/* ********************************************************
 * Click Search Button
 ******************************************************** */
$(function() {
	$("#btnSelect").click(function() {
		var wrk_strt_dtm = $("#wrk_strt_dtm").val();
		var wrk_end_dtm = $("#wrk_end_dtm").val();

		if (wrk_strt_dtm != "" && wrk_end_dtm == "") {
			alert("<spring:message code='message.msg14' />");
			return false;
		}

		if (wrk_end_dtm != "" && wrk_strt_dtm == "") {
			alert("<spring:message code='message.msg15' />");
			return false;
		}	
		fn_get_dump_list();
	});
});
</script>

<form name="dumpRestoreRegForm" method="post">
</form>

<form name="frmPopup">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="restore.Dump_Recovery" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="restore.Dump_Recovery" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on"><spring:message code="restore.Dump_Recovery" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
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
								<th scope="row" class="t10">백업기간</th>
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
							<tr style="height:35px;">
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</td>						
							</tr>
							<tr>
								<th scope="row" class="t9 "><spring:message code="common.database" /></th>
								<td>
									<select name="db_id" id="db_id" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
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
					<table class="display"  id="logDumpList"  cellspacing="0" width="100%">
						<caption>Dump 복구</caption>
							<thead>
								<tr>
									<th width="40"><spring:message code="common.no" /></th>
									<th width="100">복구</th>
									<th width="150"><spring:message code="common.work_name" /></th>
									<th width="100"><spring:message code="dbms_information.dbms_ip" /></th>
									<th width="150"><spring:message code="common.work_description" /></th>
									<th width="100"><spring:message code="common.database" /></th>
									<th width="100"><spring:message code="backup_management.size" /></th>
									<th width="170"><spring:message code="etc.etc08"/></th>			
									<th width="170"><spring:message code="backup_management.fileName"/></th>						
									<th width="100"><spring:message code="backup_management.work_start_time" /></th>
									<th width="100"><spring:message code="backup_management.work_end_time" /></th>
									<th width="100"><spring:message code="backup_management.elapsed_time" /></th>
									<th width="100"><spring:message code="common.status" /></th>
								</tr>
							</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
