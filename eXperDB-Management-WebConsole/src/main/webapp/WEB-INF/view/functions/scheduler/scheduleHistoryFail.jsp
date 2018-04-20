<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs.jsp"%>
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
    		{data : "rownum",  defaultContent : ""}, 
    		{
				data : "exe_result",
				render : function(data, type, full, meta) {
					var html = '';
					html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
					return html;
				},
				
				defaultContent : ""
			},
			{
					data : "fix_rsltcd",
					render : function(data, type, full, meta) {	 						
						var html = '';
 						if(full.fix_rsltcd == 'TC002002'){
 							html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="<spring:message code="etc.etc30"/>"></span>';
 						} else {
 							if(full.exe_rslt_cd == 'TC001701'){
 								html += ' - ';
 							}else{
 								html +='<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fix_rslt_reg('+full.exe_sn+');><input type="button" value="조치입력"></span>';
 							}	 
 						}
 						return html;
					},
					
					defaultContent : ""
				},
    		{data : "scd_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
    			}
    		}, 
    		{data : "db_svr_nm",  defaultContent : ""},
    		{data : "wrk_nm", className : "dt-left", defaultContent : ""
    			,"render": function (data, type, full) {				
    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
    			}
    		}, 
    		{data : "wrk_strt_dtm",  defaultContent : ""}, 
    		{data : "wrk_end_dtm",  defaultContent : ""}
    		//{data : "exe_result",  defaultContent : ""},	   		
    	]
    	});
    	
    	
    	table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
    	table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
    	table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    	table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
        table.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
        table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
        table.tables().header().to$().find('th:eq(7)').css('min-width', '150px');
       
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
   					top.location.href = "/";
   				} else if(xhr.status == 403) {
   					alert('<spring:message code="message.msg03" />');
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
  	});

    function fn_fix_rslt_reg(exe_sn){
    	document.getElementById("exe_sn").value = exe_sn;
    	$('#fix_rslt_msg').val('');
    	$("#rdo_r_1").attr('checked', true);
    	toggleLayer($('#pop_layer_fix_rslt_reg'), 'on')
    }
    
    function fn_fix_rslt_msg_reg(){
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
   				toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');
   				location.reload();
   			}
   		}); 
    }

    
   function fn_scheduleFail_list(){
	   $.ajax({
  			url : "/selectScheduleFailList.do",
  			data : {
  				scd_nm : $('#scd_nm').val(),
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
  				table.rows({selected: true}).deselect();
  				table.clear().draw();
  				table.rows.add(result).draw();
  			}
  		}); 
   }
    
    
    </script>
<%@include file="../../cmmn/workRmanInfo.jsp"%>
<%@include file="../../cmmn/workDumpInfo.jsp"%>
<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>
<%@include file="../../cmmn/fixRsltMsg.jsp"%>


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
									<input name="rdo_r" id="rdo_r_1" type="radio" value="TC002001"  checked="checked">
										<label for="rdo_r_1" style="margin-right: 2%;"><spring:message code="etc.etc29"/></label> 
									<input name="rdo_r" id="rdo_r_2" type="radio" value="TC002002"> 
										<label for="rdo_r_2"><spring:message code="etc.etc30"/></label>
								</div>
							</td>
						</tr>
						<tr>
							<td><textarea name="fix_rslt_msg" id="fix_rslt_msg" style="height: 250px;"> </textarea>
									<input type="hidden" name="exe_sn" id="exe_sn">
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
				<div class="btn_type_01" id="btnRman">
						<a class="btn" onClick="fn_scheduleFail_list();"><button><spring:message code="common.search" /></button></a>
				</div>
			<div class="sch_form">
					<table class="write" id="searchRman">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:100px;" />
							<col style="width:230px;" />
							<col style="width:115px;" />
							<col style="width:230px;" />
							<col style="width:115px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="schedule.schedule_name" /></th>
								<td><input type="text" class="txt t3" name="scd_nm" id="scd_nm" maxlength="25"/></td>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9" ><spring:message code="etc.etc31"/></th>
								<td><select name="fix_rsltcd" id="fix_rsltcd" class="txt t3" style="width:150px;">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC002003"><spring:message code="etc.etc34"/></option>
										<option value="TC002002"><spring:message code="etc.etc30"/></option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
				
				<table id="scheduleFailList" class="display" cellspacing="0" width="100%">
				<caption>스케줄 실패 리스트</caption>
					<thead>
						<tr>
							<th width="30"><spring:message code="common.no"/></th>							
							<th width="100"><spring:message code="schedule.result"/></th>
							<th width="100"><spring:message code="etc.etc31"/></th>
							<th width="200" class="dt-center"><spring:message code="schedule.schedule_name"/></th>
							<th width="100"><spring:message code="common.dbms_name"/></th>
							<th width="200"class="dt-center"><spring:message code="common.work_name"/></th>
							<th width="150"><spring:message code="schedule.work_start_datetime"/></th>
							<th width="150"><spring:message code="schedule.work_end_datetime"/></th>						
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->