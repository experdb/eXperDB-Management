<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : DB2pg 수행이력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2019.09.17     최초 생성
    *	
	* author 변승우
	* since 2019.09.17
	*
	*/
%>


<script type="text/javascript">

var gbn ="${gbn}";
var table = null;
var tableDDL = null;
var tableData = null;


/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){	
	if(tab == "dataWork"){
		getdataDataList();
		$("#dataDataTable").show();
		$("#dataDataTable_wrapper").show();
		$("#ddlDataTable").hide();
		$("#ddlDataTable_wrapper").hide();
		$("#tab1").hide();
		$("#tab2").show();
		$("#searchDDL").hide();
		$("#searchData").show();
		$("#btnDDL").hide();
		$("#btnData").show();
	}else{
		getddlDataList();
		$("#ddlDataTable").show();
		$("#ddlDataTable_wrapper").show();
		$("#dataDataTable").hide();
		$("#dataDataTable_wrapper").hide();
		$("#tab1").show();
		$("#tab2").hide();
		$("#searchDDL").show();
		$("#searchData").hide();
		$("#btnDDL").show();
		$("#btnData").hide();
	}
}

function fn_init(){
	tableDDL = $('#ddlDataTable').DataTable({
		scrollY : "330px",
		scrollX : true,
		searching : false,	
		deferRender : true,
		bSort: false,
		columns : [
			{data : "idx", className : "dt-center", defaultContent : ""}, 
			{data : "wrk_nm", className : "dt-left", defaultContent : ""}, 
			{data : "wrk_exp", className : "dt-left", defaultContent : ""}, 
			{data : "source_ipadr", className : "dt-center", defaultContent : ""},
			{data : "source_dbms_dscd_nm", className : "dt-center", defaultContent : ""}, 
			{data : "source_dtb_nm", className : "dt-center", defaultContent : ""},
			{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},
			{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
			{data : "wrk_dtm", className : "dt-center", defaultContent : ""},
		   	{
					data : "exe_rslt_cd",
					render : function(data, type, full, meta) {	 						
						var html = '';
						if (full.exe_rslt_cd == 'TC001701') {
							html += "<span class='btn btnC_01 btnF_02'><button onclick='fn_ddlResult(\""+full.mig_exe_sn+"\",\""+full.save_pth+"/\")'><img src='../images/ico_state_02.png' style='margin-right:3px;'/>Complete</button></span>";	
						} else if(full.exe_rslt_cd == 'TC001702'){
							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_ddlFailLog('+full.mig_exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
						} else {
							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/><spring:message code="etc.etc28"/></span>';
						}
						return html;
					},
					className : "dt-center",
					defaultContent : ""
				},
			{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
			{data : "db2pg_trsf_wrk_id", defaultContent : "", visible: false},
			{data : "wrk_id", defaultContent : "", visible: false},
			{data : "mig_exe_sn", defaultContent : "", visible: false},
			{data : "save_pth", defaultContent : "", visible: false}
		]
		});
	
	
	tableData = $('#dataDataTable').DataTable({
		scrollY : "330px",
		scrollX: true,	
		bDestroy: true,
		paging : true,
		processing : true,
		searching : false,	
		deferRender : true,
		bSort: false,
	columns : [
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""}, 
		{data : "wrk_exp", className : "dt-left", defaultContent : ""}, 
		{data : "source_ipadr", className : "dt-center", defaultContent : ""},
		{data : "source_dbms_dscd_nm", className : "dt-center", defaultContent : ""}, 
		{data : "source_dtb_nm", className : "dt-center", defaultContent : ""},		
		{data : "target_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "target_dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},
		{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
		{data : "wrk_dtm", className : "dt-center", defaultContent : ""},
	   	{
				data : "exe_rslt_cd",
				render : function(data, type, full, meta) {	 						
					var html = '';
					if (full.exe_rslt_cd == 'TC001701') {
						html += "<span class='btn btnC_01 btnF_02'><button onclick='fn_result(\""+full.mig_exe_sn+"\",\""+full.save_pth+"/\")'><img src='../images/ico_state_02.png' style='margin-right:3px;'/>Complete</button></span>";	
					} else if(full.exe_rslt_cd == 'TC001702'){
						html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_migFailLog('+full.mig_exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
					} else {
						html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/><spring:message code="etc.etc28"/></span>';
					}
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "db2pg_trsf_wrk_id", defaultContent : "", visible: false},
		{data : "wrk_id", defaultContent : "", visible: false},
		{data : "mig_exe_sn", defaultContent : "", visible: false}
	]
	});

	
	
	tableDDL.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	tableDDL.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableDDL.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(13)').css('min-width', '100px');

	
	tableData.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	tableData.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableData.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
	tableData.tables().header().to$().find('th:eq(13)').css('min-width', '130px');
	tableData.tables().header().to$().find('th:eq(14)').css('min-width', '130px');
	tableData.tables().header().to$().find('th:eq(15)').css('min-width', '95px');

    
	$(window).trigger('resize'); 
}


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(

	function() {	
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);
		
		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10); 

		$("#wrk_strt_dtm").val(day_start);
		$("#wrk_end_dtm").val(day_end);
		$("#ddl_wrk_strt_dtm").val(day_start);
		$("#ddl_wrk_end_dtm").val(day_end);
		
		fn_init();
		getddlDataList();
		getdataDataList();			
	
		$("#ddlDataTable").show();
		$("#ddlDataTable_wrapper").show();
		$("#dataDataTable").hide();
		$("#dataDataTable_wrapper").hide();

		if(gbn=="ddl"){
			selectTab('ddlWork');
		}else if (gbn=="mig"){
			selectTab('dataWork');
		}
		
		$( ".calendar" ).datepicker({
			dateFormat: 'yy-mm-dd',
			changeMonth : true,
			changeYear : true
	 	});
	}
);

/* ********************************************************
 * DDL 수행이력 데이터 가져오기
 ******************************************************** */
function getddlDataList(){
	$.ajax({
		url : "/db2pg/selectDb2pgDDLHistory.do", 
	  	data : {
	  		wrk_nm :  "%"+$("#wrk_nm").val()+"%",
	  		exe_rslt_cd : $("#exe_rslt_cd").val(),
	  		wrk_strt_dtm : $("#ddl_wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#ddl_wrk_end_dtm").val()  		
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
		success : function(data) {
			if(data.length > 0){
				tableDDL.rows({selected: true}).deselect();
				tableDDL.clear().draw();
				tableDDL.rows.add(data).draw();
			}else{
				tableDDL.clear().draw();
			}
		}
	});
}

/* ********************************************************
 * Migration 수행이력 데이터 가져오기
 ******************************************************** */
function getdataDataList(){
	$.ajax({
		url : "/db2pg/selectDb2pgMigHistory.do", 
	  	data : {
	  		wrk_nm :  "%"+$("#wrk_nm").val()+"%",
	  		exe_rslt_cd : $("#exe_rslt_cd").val(),
			wrk_strt_dtm :  $("#wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#wrk_end_dtm").val()
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
		success : function(data) {
			if(data.length > 0){
				tableData.rows({selected: true}).deselect();
				tableData.clear().draw();
				tableData.rows.add(data).draw();
			}else{
				tableData.clear().draw();
			}
		}
	});
}



 /* ********************************************************
  * DDL 에러 로그 팝업
  ******************************************************** */
 function fn_ddlFailLog(mig_exe_sn){
	  var frmPop= document.frmPopup;
	  
		var width = 950;
		var height = 690;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	    var url = '/db2pg/popup/db2pgDdlErrHistoryDetail.do';
	    window.open('','popupView',popOption);  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.mig_exe_sn.value = mig_exe_sn;  
	    frmPop.submit();   
}
 
 
 /* ********************************************************
  * MIGRATION 에러 로그 팝업
  ******************************************************** */
 function fn_migFailLog(mig_exe_sn){
	  var frmPop= document.frmPopup;
	  
		var width = 950;
		var height = 690;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	    var url = '/db2pg/popup/db2pgMigErrHistoryDetail.do';
	    window.open('','popupView',popOption);  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.mig_exe_sn.value = mig_exe_sn;  
	    frmPop.submit();   
}




 /* ********************************************************
  * MIGRATION 로그 팝업
  ******************************************************** */
 function fn_result(mig_exe_sn, trans_save_pth){
	  var frmPop= document.frmPopup;
	  
		var width = 950;
		var height = 690;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	    var url = '/db2pg/popup/db2pgResult.do';
	    window.open('','popupView',popOption);  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.trans_save_pth.value = trans_save_pth;
	    frmPop.mig_exe_sn.value = mig_exe_sn;  
	    frmPop.submit();   
}
 
 
 /* ********************************************************
  * DDL추출 로그 팝업
  ******************************************************** */
 function fn_ddlResult(mig_exe_sn, ddl_save_pth){

	  var frmPop= document.frmPopup;
	  
		var width = 950;
		var height = 690;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	    var url = '/db2pg/popup/db2pgResultDDL.do';
	    window.open('','popupView',popOption);  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.ddl_save_pth.value = ddl_save_pth;
	    frmPop.mig_exe_sn.value = mig_exe_sn;  
	    frmPop.submit();  
 }
 
 
 
</script>
<%@include file="../popup/db2pgConfigInfo.jsp"%>
<form name="frmPopup">
	<input type="hidden" name="mig_exe_sn"  id="mig_exe_sn">
	<input type="hidden" name="trans_save_pth"  id="trans_save_pth">
	<input type="hidden" name="ddl_save_pth"  id="ddl_save_pth">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="migration.performance_history"/><a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.shedule_execution_history" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>MIGRATION</li>
					<li class="on"><spring:message code="migration.performance_history"/></li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('ddlWork')">DDL</a></li>
					<li><a href="javascript:selectTab('dataWork')">MIGRATION</a></li>
				</ul>
				<ul id="tab2" style="display:none;">
					<li><a href="javascript:selectTab('ddlWork')">DDL</a></li>
					<li class="atv"><a href="javascript:selectTab('dataWork')">MIGRATION</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_float">													
					<div class="btn_type_01" id="btnDDL">
						<span class="btn"><button type="button" id="btnSelect" onclick="getddlDataList();"><spring:message code="common.search" /></button></span>			
					</div>
					<div class="btn_type_01" id="btnData" style="display:none;">
						<span class="btn"><button type="button" id="btnSelect" onclick="getdataDataList();"><spring:message code="common.search" /></button></span>		
					</div>
				</div>
				<div class="sch_form">
					<table class="write" id="searchDDL">
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
										<input type="text" name="ddl_wrk_strt_dtm" id="ddl_wrk_strt_dtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="ddl_wrk_end_dtm" id="ddl_wrk_end_dtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t5" maxlength="25"  /></td>
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value="%"><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</td>														
							</tr>
						</tbody>
					</table>
					<table class="write" id="searchData" style="display:none;">
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
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t5" maxlength="25"  /></td>
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value="%"><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</td>														
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table id="ddlDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="30">NO</th>
									<th width="100"><spring:message code="common.work_name" /></th>
									<th width="200"><spring:message code="common.work_description" /></th>
									<th width="100"><spring:message code="data_transfer.ip" /> </th>
									<th width="100">DBMS <spring:message code="common.division" /></th>
									<th width="100">Database</th>
									<th width="100"><spring:message code="backup_management.work_start_time" /></th>
									<th width="100"><spring:message code="backup_management.work_end_time" /></th>
									<th width="100"><spring:message code="schedule.jobTime"/></th>
									<th width="100"><spring:message code="properties.status" /></th>
									<th width="100"><spring:message code="migration.performer"/></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>	
					<table id="dataDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="30" rowspan="2">NO</th>
									<th width="100" rowspan="2"><spring:message code="common.work_name" /></th>
									<th width="200" rowspan="2"><spring:message code="common.work_description" /></th>
									<th width="400" colspan="3"><spring:message code="migration.source_system"/></th>
									<th width="400" colspan="2"><spring:message code="migration.target_system"/></th>
									<th width="130" rowspan="2"><spring:message code="backup_management.work_start_time"/></th>
									<th width="130" rowspan="2"><spring:message code="backup_management.work_end_time"/></th>
									<th width="95" rowspan="2"><spring:message code="schedule.jobTime"/></th>
									<th width="95" rowspan="2"><spring:message code="schedule.result"/></th>
									<th width="95" rowspan="2"><spring:message code="migration.performer"/></th>
								</tr>
								<tr>
									<th width="100">DBMS<spring:message code="common.division" /></th>
									<th width="100"><spring:message code="data_transfer.ip" /></th>
									<th width="100">Database</th>
									<th width="100"><spring:message code="data_transfer.ip" /></th>
									<th width="100">Database</th>
								</tr>
							</thead>
					</table>
				</div>		
			</div>
		</div>
	</div>
</div><!-- // contents -->
