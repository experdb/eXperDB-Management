<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : DB2pg 수행이력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2019.09.17     최초 생성
	*  2020.08.21   변승우 과장		UI 디자인 변경
	*	
	* author 변승우
	* since 2019.09.17
	*
	*/
%>


<script type="text/javascript">

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
							html += '<button type="button" class="btn btn-inverse-primary btn-fw" onclick="fn_ddlResult(\''+full.mig_exe_sn+'\',\''+full.save_pth+'/\')">';
							html += "	<i class='fa fa-check-circle text-primary' >";
							html += '&nbsp;Complete</i>';
							html += "</button>";					
						} else if(full.exe_rslt_cd == 'TC001702'){
							html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_ddlFailLog('+full.mig_exe_sn+')">';
							html += '<i class="fa fa-times">&nbsp;Fail</i>';
//							html += '<spring:message code="common.failed" />';
							html += "</button>";		
						} else {
							html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
							html += '&nbsp;<spring:message code="etc.etc28" />';
							html += "</div>";
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
		{data : "source_dbms_dscd_nm", className : "dt-center", defaultContent : ""}, 
		{data : "source_ipadr", className : "dt-center", defaultContent : ""},
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
						html += '<button type="button" class="btn btn-inverse-primary btn-fw" onclick="fn_result(\''+full.mig_exe_sn+'\',\''+full.save_pth+'/\')">';
						html += "	<i class='fa fa-check-circle text-primary' >";
						html += '&nbsp;Complete</i>';
						html += "</button>";
						html += '<br/><button type="button" class="btn btn-inverse-primary btn-fw" onclick="fn_dn_report(\''+full.save_pth+'/result/\')" style="margin-top:4pt">';
						html += "	<i class='fa fa-check-circle text-primary' >";
						html += '&nbsp;Mig Report</i>';
						html += "</button>";
						
					} else if(full.exe_rslt_cd == 'TC001702'){
						html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_migFailLog('+full.mig_exe_sn+')">';
						html += '<i class="fa fa-times">&nbsp;Fail</i>';
//						html += '<spring:message code="common.failed" />';
						html += "</button>";
					} else {
						html += "<div id='progress"+full.idx+"'></div>";
						/* html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
						html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
						html += '&nbsp;<spring:message code="etc.etc28" />';
						html += "</div>"; */
						getProgress(full.mig_exe_sn,full.save_pth,full.idx);
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
		
		fn_init();
	
		ddlDateCalenderSetting();
		migDateCalenderSetting();
		
		//getddlDataList();
		//getdataDataList();			
		
		if(getUrlParam('gbn')=='mig'){
			//$("#ddlDataTable").hide();
			//$("#ddlDataTable_wrapper").hide();
			//$("#dataDataTable").show();
			//$("#dataDataTable_wrapper").show();
			$('#server-tab-2 aria-selected').val(true);
			$('#server-tab-1 aria-selected').val(false);
			$('#server-tab-2').addClass('active');
			$('#server-tab-1').removeClass('active');
			selectTab('dataWork');
		}else {
			//$("#ddlDataTable").show();
			//$("#ddlDataTable_wrapper").show();
			//$("#dataDataTable").hide();
			//$("#dataDataTable_wrapper").hide();	
			$('#server-tab-2 aria-selected').val(false);
			$('#server-tab-1 aria-selected').val(true);
			$('#server-tab-1').addClass('active');
			$('#server-tab-2').removeClass('active');
			selectTab('ddlWork');
		}
	}
	
);

function getUrlParam(paramName){
	var url = location.href;
	var result;
	
	var parameters = (url.slice(url.indexOf('?') + 1, url.length)).split('&');
	for (var i = 0; i < parameters.length; i++) { 
		var varName = parameters[i].split('=')[0]; 
		if (varName.toUpperCase() == paramName.toUpperCase()) { 
			result = parameters[i].split('=')[1]; 
			return decodeURIComponent(result); 
		} 
	}

};

/* ********************************************************
 * DDL 수행이력 데이터 가져오기
 ******************************************************** */
function getddlDataList(){
	$.ajax({
		url : "/db2pg/selectDb2pgDDLHistory.do", 
	  	data : {
	  		wrk_nm :  "%"+$("#ddl_wrk_nm").val()+"%",
	  		exe_rslt_cd : $("#ddl_exe_rslt_cd").val(),
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
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
	  		wrk_nm :  "%"+$("#mig_wrk_nm").val()+"%",
	  		exe_rslt_cd : $("#mig_exe_rslt_cd").val(),
			wrk_strt_dtm :  $("#mig_wrk_strt_dtm").val(),
	  		wrk_end_dtm : $("#mig_wrk_end_dtm").val()
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
 * Migration 진행현황
 ******************************************************** */
function getProgress(mig_exe_sn, trans_save_pth, idx){
	var html;
	var reCycle = true;
	
	$.ajax({
		url : "/db2pg/db2pgProgress.do", 
	  	data : {
	  		mig_exe_sn : mig_exe_sn,
	  		trans_save_pth :trans_save_pth
	  	},
		dataType : "json",
		type : "post",
		async: false,
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {
			var perCent = 0;
			if(result.totalcnt > 0)	perCent = Math.round((result.nowcnt / result.totalcnt)*100);
			if(result.totalcnt != null && result.totalcnt != "" && result.totalcnt == result.nowcnt){
				reCycle = false;
				getdataDataList();

			} else{
				html = '<div id="outer" style="width: 100%; height: 22px; background: #fff;border:1px solid #5e50f9;">';
				html += '  <div id="inner1" style="width: ' + perCent + '%; height: 20px;background: #68afff;color:red;font-size:14px;vertical-align:middle;"></div>';
				html += '</div>';
				html += '<div id="inner2" style="width: 100%; margin-top:4pt; height: 20px;color:red;font-size:14px;vertical-align:middle;align:center">' + result.nowcnt + " / " + result.totalcnt + ' ('+perCent+'%)</div>';
			}
			
			eval("$('#progress"+idx+"')").html(html);

			if(reCycle){
				setTimeout(function() {
					  getProgress(mig_exe_sn, trans_save_pth, idx);
					}, 2000);
			}
		}
	});
}


 /* ********************************************************
  * DDL 에러 로그 팝업
  *********************************************************/
  function fn_ddlFailLog(mig_exe_sn){
	  
		$.ajax({
			url : "/db2pg/popup/db2pgDdlErrHistoryDetail.do", 
		  	data : {
		  		mig_exe_sn:mig_exe_sn
		  	},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {	
				$('#pop_wrk_nm').html(result.result.wrk_nm);
				$('#pop_wrk_exp').html(result.result.wrk_exp);
				$('#pop_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
				$('#pop_wrk_end_dtm').html(result.result.wrk_end_dtm);
				$('#pop_wrk_dtm').html(result.result.wrk_dtm);
				$('#pop_exe_rslt_cd').html('<i class="fa fa-times text-danger">&nbsp;<spring:message code="common.failed" /></i>');
				$("#pop_rslt_msg", "#subForm").val(nvlPrmSet(result.result.rslt_msg, "")); 
				$('#pop_layer_db2pgDdlErrHistoryDetail').modal("show");
			}
		});

}

 
 

  /* ********************************************************
   * DDL추출 로그 팝업
   ******************************************************** */
  function fn_ddlResult(mig_exe_sn, ddl_save_pth){
 	 
 		$.ajax({
 			url : "/db2pg/popup/db2pgResultDDL.do", 
 		  	data : {
 		  		mig_exe_sn : mig_exe_sn,
 		  		ddl_save_pth :ddl_save_pth
 		  	},
 			dataType : "json",
 			type : "post",
 			beforeSend: function(xhr) {
 		        xhr.setRequestHeader("AJAX", true);
 		     },
 			error : function(xhr, status, error) {
 				if(xhr.status == 401) {
 					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
 				} else if(xhr.status == 403) {
 					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
 				} else {
 					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
 				}
 			},
 			success : function(result) {		
 				$('#ddl_result_wrk_nm').html(result.result.wrk_nm);
 				$('#ddl_result_wrk_exp').html(result.result.wrk_exp);				
 				$('#ddl_result_exe_rslt_cd').html('<i class="fa fa-check-circle text-primary" >&nbsp;Complete</i>');				
 				fn_ddlResultInit();
 				getDataResultList(result.ddl_save_pth);			
 				$('#pop_layer_db2pgResultDDL').modal("show");
 			}
 		});
  }
  
 
 
 
 /* ********************************************************
  * MIGRATION 에러 로그 팝업
  ******************************************************** */
 function fn_migFailLog(mig_exe_sn){
	 
		$.ajax({
			url : "/db2pg/popup/db2pgMigErrHistoryDetail.do", 
		  	data : {
		  		mig_exe_sn:mig_exe_sn
		  	},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {		
				$('#pop_wrk_nm').html(result.result.wrk_nm);
				$('#pop_wrk_exp').html(result.result.wrk_exp);
				$('#pop_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
				$('#pop_wrk_end_dtm').html(result.result.wrk_end_dtm);
				$('#pop_wrk_dtm').html(result.result.wrk_dtm);
				$('#pop_exe_rslt_cd').html('<i class="fa fa-times text-danger">&nbsp;<spring:message code="common.failed" /></i>');
				$("#pop_rslt_msg", "#subForm").val(nvlPrmSet(result.result.rslt_msg, "")); 
				$('#pop_layer_db2pgDdlErrHistoryDetail').modal("show");
			}
		});
}




 /* ********************************************************
  * MIGRATION 로그 팝업
  ******************************************************** */
 function fn_result(mig_exe_sn, trans_save_pth){
		$.ajax({
			url : "/db2pg/popup/db2pgResult.do", 
		  	data : {
		  		mig_exe_sn : mig_exe_sn,
		  		trans_save_pth :trans_save_pth
		  	},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {		

				$('#mig_result_wrk_nm').html(result.result.wrk_nm);
				$('#mig_result_wrk_exp').html(result.result.wrk_exp);
				$('#mig_result_wrk_strt_dtm').html(result.result.wrk_strt_dtm);
				$('#mig_result_wrk_end_dtm').html(result.result.wrk_end_dtm);
				$('#mig_result_wrk_dtm').html(result.result.wrk_dtm);				
 				$('#mig_result_exe_rslt_cd').html('<i class="fa fa-check-circle text-primary" >&nbsp;Complete</i>');
 				$('#mig_result_exe_rslt_report').html("<a href=\"javascript:fn_dn_report('" + trans_save_pth + "result/')\" ><b>Migration Report Download</b></a>");

 				 if(result.db2pgResult.RESULT == null){
 					$('#mig_result_msg').html("파일이 삭제되어 작업로그정보를 출력할 수 없습니다.");	
 				}else{
 					$('#mig_result_msg').html(result.db2pgResult.RESULT);	
 				} 
 				
				$('#pop_layer_db2pgResult').modal("show"); 
			}
		});
}
 
 
 
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function ddlDateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10); 

		$("#ddl_wrk_strt_dtm").val(day_start);
		$("#ddl_wrk_end_dtm").val(day_end);

		if ($("#ddl_wrk_strt_dtm_div").length) {
			$('#ddl_wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#ddl_wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#ddl_wrk_end_dtm").datepicker('setDate', day_end);
	    $('#ddl_wrk_strt_dtm_div').datepicker('updateDates');
	    $('#ddl_wrk_end_dtm_div').datepicker('updateDates');
	}	
	
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function migDateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10); 

		$("#mig_wrk_strt_dtm").val(day_start);
		$("#mig_wrk_end_dtm").val(day_end);

		if ($("#mig_wrk_strt_dtm_div").length) {
			$('#mig_wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#mig_wrk_end_dtm_div").length) {
			$('#mig_wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#mig_wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#mig_wrk_end_dtm").datepicker('setDate', day_end);
	    $('#mig_wrk_strt_dtm_div').datepicker('updateDates');
	    $('#mig_wrk_end_dtm_div').datepicker('updateDates');
	}	
 
	/* ********************************************************
	 *파일 다운로드
	 ******************************************************** */
	function fn_dn_report(path){
		location.href="/db2pg/popup/db2pgFileDownload.do?name=report.html&path="+path;
	}
</script>

<%-- <%@include file="../popup/db2pgConfigInfo.jsp"%> --%>
<%@include file="../popup/db2pgHistoryDetail.jsp"%>
<%@include file="../popup/db2pgResultDDL.jsp"%> 
<%@include file="../popup/db2pgResult.jsp"%> 


<form name="frmPopup">
	<input type="hidden" name="mig_exe_sn"  id="mig_exe_sn">
	<input type="hidden" name="trans_save_pth"  id="trans_save_pth">
	<input type="hidden" name="ddl_save_pth"  id="ddl_save_pth">
</form>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-server menu-icon"></i>
												<span class="menu-title"><spring:message code="migration.performance_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">MIGRATION</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_migration" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="migration.performance_history"/></li>
										</ol>
									</div>
								</div>
							</div>							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.shedule_execution_history" /></p>
											<p class="mb-0">수행 결과에 대해선 수행이 완료 후 상태가 변경되며, 수동으로 조회 하셔야 합니다.</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('ddlWork');" >
								DDL
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('dataWork');">
								MIGRATION
							</a>
						</li>
					</ul>
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">
							<!-- DDL 수행이력 조회조건 -->
							<form class="form-inline row" id="searchDDL">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row">		
									<div id="ddl_wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="ddl_wrk_strt_dtm" name="ddl_wrk_strt_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none; padding: 0px 10px;"> ~ </span>
									</div>
									<div id="ddl_wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="ddl_wrk_end_dtm" name="ddl_wrk_end_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-3">
									<input type="text" class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" maxlength="25" name="ddl_wrk_nm" id="ddl_wrk_nm"  placeholder='<spring:message code="common.work_name" />'/>
								</div>									
								<div class="input-group mb-2 mr-sm-2 col-sm-2" >
									<select class="form-control" name="ddl_exe_rslt_cd" id="ddl_exe_rslt_cd">
										<option value="%"><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="getddlDataList()">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>		
							
							<!-- MIGRATION 수행이력 조회조건 -->
							<form class="form-inline row" id="searchData" style="display:none;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row">		
									<div id="mig_wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="mig_wrk_strt_dtm" name="mig_wrk_strt_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none; padding: 0px 10px;"> ~ </span>
									</div>
									<div id="mig_wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="mig_wrk_end_dtm" name="mig_wrk_end_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>									
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-3">
									<input type="text" class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" maxlength="25" name="mig_wrk_nm" id="mig_wrk_nm"  placeholder='<spring:message code="common.work_name" />'/>
								</div>									
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-2" >
									<select class="form-control" style="width:150px;" name="mig_exe_rslt_cd" id="mig_exe_rslt_cd">
										<option value="%"><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="getdataDataList()">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-12 stretch-card div-form-margin-table" id="left_list">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12" id="rmanDataTableDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>
	 								<table id="ddlDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
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
							 	</div>					 	
								<div class="col-12" id="dumpDataTableDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>
	 								<table id="dataDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
											<tr class="bg-info text-white">
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
										<tr class="bg-info text-white">
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
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
		<div class="col-sm-0_5" style="display:none;" id="center_div" >
			<div class="card" style="background-color: transparent !important;border:0px;top:30%;position: inline-block;">
				<div class="card-body" style="" onclick="fn_schedule_leftListSize();">	
					<i class='fa fa-angle-double-right text-info' style="font-size: 35px;cursor:pointer;"></i>
				</div>
			</div>
		</div>
	</div>
</div>

