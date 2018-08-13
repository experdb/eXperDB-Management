<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : scriptHistory.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 변승우
	* since 2017.06.07
	*
	*/
%>
<script type="text/javascript">
var table = null;

$(window.document).ready(function() {
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
	
	fn_init();
	fn_search();
	
});


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
		 fn_search();
	});
}); 


function fn_init(){
   	table = $('#scriptHistory').DataTable({	
		scrollY: "405px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_scriptLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		},
		    		{ data : "wrk_exp",
		    			render : function(data, type, full, meta) {	 	
		    				var html = '';					
		    				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
		    				return html;
		    			},
		    			defaultContent : ""
		    		},
		    		{ data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
		    		{ data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
		    		{ data: "wrk_dtm", className: "dt-center", defaultContent: ""}, 
		    		{
	 					data : "exe_rslt_cd_nm",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
	 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</button></span>';
	 						} else if(full.exe_rslt_cd == 'TC001702'){
	 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
	 						} else {
	 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/><spring:message code="etc.etc28"/></span>';
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
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="<spring:message code="etc.etc29"/>"></span>';
	 						} else if(full.fix_rsltcd == 'TC002002'){
	 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="<spring:message code="etc.etc30"/>"></span>';
	 						} else {
	 							if(full.exe_rslt_cd == 'TC001701'){
	 								html += ' - ';
	 							}else{
	 								html +='<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fix_rslt_reg('+full.exe_sn+');><input type="button" value="<spring:message code="backup_management.Enter_Action"/>"></span>';
	 							}	 
	 						}
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
 		        ]
	});
   	
   	table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
   	table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
   	table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');

    $(window).trigger('resize'); 
}


/* ********************************************************
 *  스크립트 리스트
 ******************************************************** */
function fn_search(){	
	$.ajax({
		url : "/selectScriptHistoryList.do",
	  	data : {
	  		db_svr_id : $("#db_svr_id").val(),
	  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#wrk_end_dtm").val(),
	  		exe_rslt_cd : $("#exe_rslt_cd").val(),
	  		wrk_nm : $('#wrk_nm').val(),
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
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}


function fn_fix_rslt_reg(exe_sn){
	document.getElementById("exe_sn_r").value = exe_sn;
	$('#fix_rslt_msg_r').val('');
	$("#rdo_r_1").attr('checked', true);
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
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');
				fn_search()
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
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				toggleLayer($('#pop_layer_fix_rslt_msg'), 'off');
				fn_search()
				//location.reload();
			}
		}); 
}
</script>

<%@include file="../cmmn/workScriptInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>


	<div id="pop_layer_fix_rslt_reg" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 60%; margin: 0 auto; min-height:0; min-width:0;">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="etc.etc33"/></p>
				<table class="write" border="0">
					<caption><spring:message code="etc.etc33"/></caption>
					<tbody>
						<tr>
							<td>
								<div class="inp_rdo">
									<input name="rdo_r" id="rdo_r_1" type="radio" value="TC002001" checked="checked">
										<label for="rdo_r_1" style="margin-right: 2%;"><spring:message code="etc.etc29"/></label> 
									<input name="rdo_r" id="rdo_r_2" type="radio" value="TC002002"> 
										<label for="rdo_r_2"><spring:message code="etc.etc30"/></label>
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
			<h4><spring:message code="menu.script_history" /><a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.script_history_01" /></li>
					<li><spring:message code="help.script_settings_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.script_management" /></li>
					<li class="on"><spring:message code="menu.script_history" /></li>
				</ul>
			</div>
		</div>
	
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button id="btnSelect" type="button"><spring:message code="common.search" /></button></span>
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
										<input type="text" name="wrk_strt_dtm" id="wrk_strt_dtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_end_dtm" id="wrk_end_dtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr>
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
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t5" maxlength="25" /></td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
				<div class="overflow_area">				
					<table class="display" id="scriptHistory" cellspacing="0" width="100%">
						<caption>스크립트 이력화면 리스트</caption>
						<thead>
							<tr>
								<th width="30"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="common.work_name" /></th>
								<th width="100"><spring:message code="common.work_description" /></th>
								<th width="100"><spring:message code="backup_management.work_start_time" /></th>
								<th width="100"><spring:message code="backup_management.work_end_time" /></th>
								<th width="100"><spring:message code="backup_management.elapsed_time" /></th>
								<th width="100"><spring:message code="common.status" /></th>
								<th width="100"><spring:message code="etc.etc31"/></th>
							</tr>
						</thead>
					</table>
				</div>			
			</div>
		</div>
	</div>
</div><!-- // contents -->
