<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : workLogList.jsp
	* @Description : Log List 화면
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
var tableRman = null;
var tableDump = null;
var tab = "rman";

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
	
	fn_get_rman_list();
	//fn_get_dump_list();
	
	$( ".calendar" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth : true,
		changeYear : true
 	});
});

/* ********************************************************
 * Rman Data Table initialization
 ******************************************************** */
function fn_rman_init(){
   	tableRman = $('#logRmanList').DataTable({	
		scrollY: "545px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		},
		    		{ data: "ipadr", className: "dt-center", defaultContent: ""},
		         	{ data: "wrk_exp", className: "dt-left", defaultContent: ""}, 		         	
 		         	{ data: "bck_opt_cd_nm", className: "dt-center", defaultContent: ""}, 
 		         	{data : "bck_file_pth", className : "dt-left", defaultContent : ""
	 		   			,"render": function (data, type, full) {
	 		   				  return '<span onClick=javascript:fn_rmanShow("'+full.bck_file_pth+'","'+full.db_svr_id+'"); class="bold">' + full.bck_file_pth + '</span>';
	 		   			}
	 		   		 },
 		         	{ data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_dtm", className: "dt-center", defaultContent: ""}, 
	 		   		{
	 					data : "exe_rslt_cd_nm",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
	 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</span>';
	 						} else if(full.exe_rslt_cd == 'TC001702'){
	 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
	 						} else {
	 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/>실행중</span>';
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				},
	 				{
	 					data : "fix_rsltcd",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.fix_rsltcd == 'TC002001') {
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="해결"></span>';
	 						} else if(full.fix_rsltcd == 'TC002002'){
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="미해결"></span>';
	 						} else {
	 							if(full.exe_rslt_cd == 'TC001701'){
	 								html += ' - ';
	 							}else{
	 								html +='<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fix_rslt_reg('+full.exe_sn+');><input type="button" value="조치입력"></span>';
	 							}	 
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
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
   	tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
    $(window).trigger('resize'); 
}

/* ********************************************************
 * Dump Data Table initialization
 ******************************************************** */
function fn_dump_init(){
   	tableDump = $('#logDumpList').DataTable({	
		scrollY: "245px",	
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		}, 
		    		{ data: "ipadr", className: "dt-center", defaultContent: ""},
		         	{ data: "wrk_exp", className: "dt-left", defaultContent: ""}, 
 		         	{ data: "db_nm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "file_sz", className: "dt-center", defaultContent: ""},
 		         	{data : "bck_file_pth", className : "dt-left", defaultContent : ""
	 		   			,"render": function (data, type, full) {
	 		   				  return '<span onClick=javascript:fn_dumpShow("'+full.bck_file_pth+'","'+full.db_svr_id+'"); class="bold">' + full.bck_file_pth + '</span>';
	 		   			}
	 		   		 },
 		         	{ data: "bck_filenm", className: "dt-left", defaultContent: ""},
 		         	{ data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "wrk_end_dtm", className: "dt-center", defaultContent: ""},  		         			         	
 		         	{ data: "wrk_dtm", className: "dt-center", defaultContent: ""},
	 		   		{
	 					data : "exe_rslt_cd",
	 					render : function(data, type, full, meta) {
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
	 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</span>';
	 						} else if(full.exe_rslt_cd == 'TC001702'){
	 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
	 						} else {
	 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/>실행중</span>';
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				},
	 				{
	 					data : "fix_rsltcd",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.fix_rsltcd == 'TC002001') {
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="해결"></span>';
	 						} else if(full.fix_rsltcd == 'TC002002'){
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="미해결"></span>';
	 						} else {
	 							if(full.exe_rslt_cd == 'TC001701'){
	 								html += ' - ';
	 							}else{
	 								html +='<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fix_rslt_reg('+full.exe_sn+');><input type="button" value="조치입력"></span>';
	 							}
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
 		        ],'select': {'style': 'multi'} 
	});

   	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
   	tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
   	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
   	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '200px');
   	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '200px');
   	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
   	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
    $(window).trigger('resize');
}


function fn_rmanShow(bck, db_svr_id){
	alert(db_svr_id);
	  var frmPop= document.frmPopup;
	    var url = '/rmanShowView.do';
	    window.open('','popupView','width=1000, height=800');  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.bck.value = bck;
	    frmPop.db_svr_id.value = db_svr_id;  
	    frmPop.submit();   
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
 * Get Rman Log List
 ******************************************************** */
function fn_get_rman_list(){
	$.ajax({
		url : "/backup/selectWorkLogList.do",
	  	data : {
	  		db_svr_id : $("#db_svr_id").val(),
	  		bck_bsn_dscd : "TC000201",
	  		bck_opt_cd : $("#bck_opt_cd").val(),
	  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#wrk_end_dtm").val(),
	  		exe_rslt_cd : $("#exe_rslt_cd").val()
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
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
	  		exe_rslt_cd : $("#exe_rslt_cd").val()
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
	             location.href = "/";
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

		if(tab == "rman"){
			fn_get_rman_list();
		}else{
			fn_get_dump_list();
		}
	});
});

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


function fn_fix_rslt_reg(exe_sn){
	document.getElementById("exe_sn_r").value = exe_sn;
	$('#fix_rslt_msg_r').val('');
	toggleLayer($('#pop_layer_fix_rslt_reg'), 'on')
}

function fn_fix_rslt_msg_reg(){
	var fix_rsltcd = $(":input:radio[name=rdo_r]:checked").val();
	
	$.ajax({
			url : "/updateFixRslt.do",
			data : {
				exe_sn : $('#exe_sn_r').val(),
				fix_rsltcd : fix_rsltcd,
				fix_rslt_msg : $('#fix_rslt_msg_r').val()
			},
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
				toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');
				location.reload();
			}
		}); 
}


function fn_fix_rslt_msg_modify(){
	var fix_rsltcd = $(":input:radio[name=rdo]:checked").val();

	$.ajax({
			url : "/updateFixRslt.do",
			data : {
				exe_sn : $('#exe_sn').val(),
				fix_rsltcd : fix_rsltcd,
				fix_rslt_msg : $('#fix_rslt_msg').val()
			},
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
				toggleLayer($('#pop_layer_fix_rslt_msg'), 'off');
				location.reload();
			}
		}); 
}


</script>
<%@include file="../cmmn/wrkLog.jsp"%>
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>

<form name="frmPopup">
	<input type="hidden" name="bck"  id="bck">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
</form>

	<div id="pop_layer_fix_rslt_reg" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 60%; margin: 0 auto; min-height:0; min-width:0;">
				<p class="tit" style="margin-bottom: 15px;">조치결과 등록</p>
				<table class="write" border="0">
					<caption>조치결과 등록</caption>
					<tbody>
						<tr>
							<td>
								<div class="inp_rdo">
									<input name="rdo_r" id="rdo_r_1" type="radio" checked="checked">
										<label for="rdo_r_1" style="margin-right: 2%;">해결</label> 
									<input name="rdo_r" id="rdo_r_2" type="radio"> 
										<label for="rdo_r_2">미해결</label>
								</div>
							</td>
						</tr>						
						<tr>
							<td><textarea name="fix_rslt_msg_r" id="fix_rslt_msg_r" style="height: 250px;"> </textarea>
									<input type="hidden" name="exe_sn_r" id="exe_sn_r">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="fn_fix_rslt_msg_reg();"><span><spring:message code="common.save"/></span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
	
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.backup_history" /><a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.backup_history_01" /></li>
					<li><spring:message code="help.backup_history_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.backup_management" /></li>
					<li class="on"><spring:message code="menu.backup_history" /></li>
				</ul>
			</div>
		</div>
	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab_rman">
					<li class="atv"><a href="javascript:selectTab('rman');">Rman <spring:message code="menu.backup_history" /></a></li>
					<li><a href="javascript:selectTab('dump');">Dump <spring:message code="menu.backup_history" /></a></li>
				</ul>
				<ul id="tab_dump" style="display:none">
					<li><a href="javascript:selectTab('rman');">Rman <spring:message code="menu.backup_history" /></a></li>
					<li class="atv"><a href="javascript:selectTab('dump');">Dump <spring:message code="menu.backup_history" /></a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button id="btnSelect"><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:90px;" />
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
								<th scope="row" class="t9 search_rman"><spring:message code="backup_management.backup_option" /></th>
								<td class="search_rman">
									<select name="bck_opt_cd" id="bck_opt_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
										<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
										<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
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
						</tbody>
					</table>
					</form>
				</div>
				<div class="overflow_area" id="logRmanListDiv">
					<table class="display" id="logRmanList" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="150" class="dt-center"><spring:message code="common.work_name" /></th>
								<th width="100"><spring:message code="dbms_information.dbms_ip" /></th>
								<th width="150" class="dt-center"><spring:message code="common.work_description" /></th>
								<th width="90"><spring:message code="backup_management.backup_option" /></th>
								<th width="230" class="dt-center"><spring:message code="etc.etc08"/></th>
								<th width="100"><spring:message code="backup_management.work_start_time" /> </th>
								<th width="100"><spring:message code="backup_management.work_end_time" /></th>
								<th width="70"><spring:message code="backup_management.elapsed_time" /></th>
								<th width="100"><spring:message code="common.status" /></th>
								<th width="100">조치결과</th>
							</tr>
						</thead>
					</table>
				</div>
				<div class="overflow_area" style="display:none;" id="logDumpListDiv">
					<table class="display" id="logDumpList" cellspacing="0" width="100%">
						<caption>Dump 백업관리 이력화면 리스트</caption>
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
								<th width="100"><spring:message code="dbms_information.dbms_ip" /></th>
								<th width="200" class="dt-center"><spring:message code="common.work_description" /></th>
								<th width="100"><spring:message code="common.database" /></th>
								<th width="100"><spring:message code="backup_management.size" /></th>
								<th width="200" class="dt-center"><spring:message code="etc.etc08"/></th>			
								<th width="200" class="dt-center"><spring:message code="backup_management.fileName"/></th>						
								<th width="100"><spring:message code="backup_management.work_start_time" /></th>
								<th width="100"><spring:message code="backup_management.work_end_time" /></th>
								<th width="100"><spring:message code="backup_management.elapsed_time" /></th>
								<th width="100"><spring:message code="common.status" /></th>
								<th width="100">조치결과</th>
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