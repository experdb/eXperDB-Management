<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : db2pgSetting.jsp
	* @Description : DB2pg 설정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2019.09.17     최초 생성
    *	
	* author kimjy
	* since 2019.09.17
	*
	*/
%>

<script type="text/javascript">

var tableDDL = null;
var tableData = null;

var wrk_nmChk = "fail";

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
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
     	{data : "db2pg_ddl_wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {				
				  return '<span onClick=javascript:fn_db2pgConfigLayer("'+full.db2pg_ddl_wrk_nm+'"); class="bold">' + full.db2pg_ddl_wrk_nm + '</span>';
			}
		},
		{data : "db2pg_ddl_wrk_exp", className : "dt-left", defaultContent : ""}, 
		{data : "dbms_dscd", className : "dt-center", defaultContent : ""}, 
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "scm_nm", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "db2pg_ddl_wrk_id", defaultContent : "", visible: false},
		{data : "wrk_id", defaultContent : "", visible: false},
		{data : "ddl_save_pth", defaultContent : "", visible: false}
	],'select': {'style': 'multi'}
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
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
     	{data : "db2pg_trsf_wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {				
				  return '<span onClick=javascript:fn_db2pgConfigLayer("'+full.db2pg_trsf_wrk_nm+'"); class="bold">' + full.db2pg_trsf_wrk_nm + '</span>';
			}
		},
		{data : "db2pg_trsf_wrk_exp", className : "dt-left", defaultContent : ""}, 
		{data : "source_dbms_dscd", className : "dt-center", defaultContent : ""}, 
		{data : "source_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "source_dtb_nm", className : "dt-center", defaultContent : ""}, 
		{data : "source_scm_nm", className : "dt-center", defaultContent : ""},
		{data : "target_dbms_dscd", className : "dt-center", defaultContent : ""},
		{data : "target_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "target_dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "target_scm_nm", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "db2pg_trsf_wrk_id", defaultContent : "", visible: false},
		{data : "wrk_id", defaultContent : "", visible: false},
		{data : "trans_save_pth", defaultContent : "", visible: false},
		{data : "src_cnd_qry", defaultContent : "", visible: false}
	],'select': {'style': 'multi'}
	});
	
	tableDDL.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	tableDDL.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableDDL.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableDDL.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(7)').css('min-width', '150px');
	tableDDL.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(9)').css('min-width', '120px');
	tableDDL.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(11)').css('min-width', '120px');
	tableDDL.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
	tableDDL.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
	tableDDL.tables().header().to$().find('th:eq(14)').css('min-width', '0px');

	tableData.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    tableData.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
    tableData.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
    tableData.tables().header().to$().find('th:eq(4)').css('min-width', '450px');
    tableData.tables().header().to$().find('th:eq(5)').css('min-width', '450px');
    tableData.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(18)').css('min-width', '0px');
    tableData.tables().header().to$().find('th:eq(19)').css('min-width', '0px');
    tableData.tables().header().to$().find('th:eq(20)').css('min-width', '0px');
    tableData.tables().header().to$().find('th:eq(21)').css('min-width', '0px');
    
	$(window).trigger('resize'); 
}


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(
	function() {
		fn_init();	
		getddlDataList();
		getdataDataList();		
		$("#ddlDataTable").show();
		$("#ddlDataTable_wrapper").show();
		$("#dataDataTable").hide();
		$("#dataDataTable_wrapper").hide();		
});

/* ********************************************************
 * DDL추출 데이터 가져오기
 ******************************************************** */
function getddlDataList(){
	$.ajax({
		url : "/db2pg/selectDDLWork.do", 
	  	data : {
	  		wrk_nm : "%" + $("#ddl_wrk_nm").val() + "%",
	  		dbms_dscd : "%" + $("#ddl_dbms_dscd").val() + "%",
	  		ipadr : "%" + $("#ddl_ipadr").val() + "%",
	  		dtb_nm : "%" + $("#ddl_dtb_nm").val() + "%",
	  		scm_nm : "%" + $("#ddl_scm_nm").val() + "%"
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
				tableData.rows({selected: true}).deselect();
				tableDDL.clear().draw();
				tableDDL.rows.add(data).draw();
			}else{
				tableDDL.clear().draw();
			}
		}
	});
}

/* ********************************************************
 * 데이터이행 데이터 가져오기
 ******************************************************** */
function getdataDataList(){
	$.ajax({
		url : "/db2pg/selectDataWork.do", 
	  	data : {
	  		wrk_nm : "%" + $("#data_wrk_nm").val() + "%",
	  		data_dbms_dscd : $("#data_dbms_dscd").val(),
	  		dbms_dscd : "%" +$("#dbms_dscd").val()+ "%",
	  		ipadr : "%" + $("#data_ipadr").val() + "%",
	  		dtb_nm : "%" + $("#data_dtb_nm").val() + "%",
	  		scm_nm : "%" + $("#data_scm_nm").val() + "%"
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
 * DDL추출 등록 팝업
 ******************************************************** */
function fn_ddl_reg_popup(){
	$("#db2pg_ddl_wrk_nm", "#ddlRegForm").val("");
	$("#db2pg_ddl_wrk_exp", "#ddlRegForm").val("");
	$("#db2pg_sys_nm", "#ddlRegForm").val("");
	$("#src_include_tables", "#ddlRegForm").val("");
	$("#src_exclude_tables", "#ddlRegForm").val("");
	
	
	$('#pop_layer_ddl_reg').modal("show");
}

/* ********************************************************
 * DDL추출 수정 팝업
 ******************************************************** */
function fn_ddl_regre_popup(){
	var rowCnt = tableDDL.rows('.selected').data().length;
	if (rowCnt == 1) {
		var db2pg_ddl_wrk_id = tableDDL.row('.selected').data().db2pg_ddl_wrk_id;
		var popUrl = "/db2pg/popup/ddlRegReForm.do?db2pg_ddl_wrk_id=" +  db2pg_ddl_wrk_id;
		var width = 965;
		var height = 705;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"ddlRegRePop",popOption);
		winPop.focus();
	} else {
		showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
}

/* ********************************************************
 * 데이터이행 등록 팝업
 ******************************************************** */
function fn_data_reg_popup(){
	var popUrl = "/db2pg/popup/dataRegForm.do";
	var width = 965;
	var height = 800;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dataRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * 데이터이행 수정 팝업
 ******************************************************** */
function fn_data_regre_popup(){
	var rowCnt = tableData.rows('.selected').data().length;
	if (rowCnt == 1) {
		var db2pg_trsf_wrk_id = tableData.row('.selected').data().db2pg_trsf_wrk_id;
		var popUrl = "/db2pg/popup/dataRegReForm.do?db2pg_trsf_wrk_id=" +  db2pg_trsf_wrk_id;
		var width = 965;
		var height = 800;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"dataRegRePop",popOption);
		winPop.focus();
	} else {
		showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
}

/* ********************************************************
 * DDL추출 Data Delete
 ******************************************************** */
function fn_ddl_work_delete(){
	var datas = tableDDL.rows('.selected').data();
	if(datas.length < 1){
		showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		var wrkList = [];
		for (var i = 0; i < datas.length; i++) {
			wrkList += datas[i].wrk_id + ',';	
		}
		var wrkIdList = [];
		for (var i = 0; i < datas.length; i++) {
			wrkIdList += datas[i].db2pg_ddl_wrk_id + ',';	
		}
		var wrkNmList = [];
		for (var i = 0; i < datas.length; i++) {
			wrkNmList += datas[i].db2pg_ddl_wrk_nm + ',';	
		}
		if(confirm('<spring:message code="message.msg162"/>')){
			$.ajax({
				url : "/db2pg/deleteDDLWork.do",
			  	data : {
			  		wrk_id : wrkList,
			  		db2pg_ddl_wrk_id : wrkIdList,
			  		db2pg_ddl_wrk_nm : wrkNmList
			  	},
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
					if(result.resultCode == "0000000000"){
						showSwalIcon('<spring:message code="message.msg37"/>', '<spring:message code="common.close" />', '', 'success');
						getddlDataList();
					}else{
						showSwalIcon('<spring:message code="migration.msg09" />', '<spring:message code="common.close" />', '', 'error');
					}	
				}
			});	
		 };	
	}
}

/* ********************************************************
 * Data 추출 Data Delete
 ******************************************************** */
 function fn_data_work_delete(){
	 var datas = tableData.rows('.selected').data();
		if(datas.length < 1){
			showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{
			var wrkList = [];
			for (var i = 0; i < datas.length; i++) {
				wrkList += datas[i].wrk_id + ',';	
			}
			var wrkIdList = [];
			for (var i = 0; i < datas.length; i++) {
				wrkIdList += datas[i].db2pg_trsf_wrk_id + ',';	
			}
			var wrkNmList = [];
			for (var i = 0; i < datas.length; i++) {
				wrkNmList += datas[i].db2pg_trsf_wrk_nm + ',';	
			}
			if(confirm('<spring:message code="message.msg162"/>')){
				$.ajax({
					url : "/db2pg/deleteDataWork.do",
				  	data : {
				  		wrk_id : wrkList,
				  		db2pg_trsf_wrk_id : wrkIdList,
				  		db2pg_trsf_wrk_nm : wrkNmList
				  	},
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
						if(result.resultCode == "0000000000"){
							showSwalIcon('<spring:message code="message.msg37"/>', '<spring:message code="common.close" />', '', 'success');
							getdataDataList();	
						}else{
							showSwalIcon('<spring:message code="migration.msg09" />', '<spring:message code="common.close" />', '', 'error');
						}	
					}
				});	
			 };	
		}
}

/* ********************************************************
 * 복제버튼 클릭시
 ******************************************************** */
function fn_copy(){
	var ddlRowCnt = tableDDL.rows('.selected').data().length;
	var dataRowCnt = tableData.rows('.selected').data().length;
	if(ddlRowCnt==1){
		$("#wrk_nm", "#copyRegForm").val("");
		$("#wrk_exp", "#copyRegForm").val("");
		$('#pop_layer_copy').modal("show");
	}else if(dataRowCnt==1){
		$("#wrk_nm", "#copyRegForm").val("");
		$("#wrk_exp", "#copyRegForm").val("");
		$('#pop_layer_copy').modal("show");
	}else{
		showSwalIcon('<spring:message code="migration.msg10" />', '<spring:message code="common.close" />', '', 'error');
	}
}

/* ********************************************************
 * WORK NM Validation Check
 ******************************************************** */
function fn_check() {
	var wrk_nm = document.getElementById("wrk_nm");
	if (wrk_nm.value == "") {
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		document.getElementById('wrk_nm').focus();
		return;
	}
	$.ajax({
		url : '/wrk_nmCheck.do',
		type : 'post',
		data : {
			wrk_nm : $("#wrk_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				showSwalIcon('<spring:message code="backup_management.reg_possible_work_nm"/>', '<spring:message code="common.close" />', '', 'success');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";		
			} else {
				showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "fail";	
			}
		},
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
		}
	});
}

/* ********************************************************
 * 복제
 ******************************************************** */
function fn_copy_save(){
	if($("#wrk_nm").val() == ""){
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		$("#wrk_nm").focus();
		return false;
	}else if(wrk_nmChk =="fail"){
		showSwalIcon('<spring:message code="backup_management.work_overlap_check" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if($("#db2pg_ddl_wrk_exp").val() == ""){
		showSwalIcon('<spring:message code="message.msg108" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_ddl_wrk_exp").focus();
		return false;
	}else{
		var rowCnt = tableDDL.rows('.selected').data().length;
		if (rowCnt == 1) {
			var db2pg_ddl_wrk_id = tableDDL.row('.selected').data().db2pg_ddl_wrk_id;
			$.ajax({
				url : "/db2pg/insertCopyDDLWork.do",
			  	data : {
			  		db2pg_ddl_wrk_nm : $("#wrk_nm").val().trim(),
			  		db2pg_ddl_wrk_exp : $("#wrk_exp").val(),
			  		db2pg_ddl_wrk_id : db2pg_ddl_wrk_id
			  	},
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
					if(result.resultCode == "0000000000"){
						$("#wrk_nm").val("");
						$("#wrk_exp").val("");
						alert('<spring:message code="message.msg07" /> ');
						$('#pop_layer_copy').modal("hide");
						getddlDataList();
					}else{
						showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					}	
				}
			});	
		}
		var rowCnt = tableData.rows('.selected').data().length;
		if (rowCnt == 1) {
			var db2pg_trsf_wrk_id = tableData.row('.selected').data().db2pg_trsf_wrk_id;
			$.ajax({
				url : "/db2pg/insertCopyDataWork.do",
			  	data : {
			  		db2pg_trsf_wrk_nm : $("#wrk_nm").val().trim(),
			  		db2pg_trsf_wrk_exp : $("#wrk_exp").val(),
			  		db2pg_trsf_wrk_id : db2pg_trsf_wrk_id
			  	},
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
					if(result.resultCode == "0000000000"){
						$("#wrk_nm").val("");
						$("#wrk_exp").val("");
						alert('<spring:message code="message.msg07" /> ');
						$('#pop_layer_copy').modal("hide");
						getdataDataList();
					}else{
						showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					}	
				}
			});
		}
	}
}
 
/* ********************************************************
 * 즉시실행 DDL 
 ******************************************************** */
function fn_ImmediateStart(gbn){
	var db2pgGbn = gbn;
	
	if(gbn == 'ddl'){
		var datas = tableDDL.rows('.selected').data();
		var rowCnt = tableDDL.rows('.selected').data().length;

		var dataSet=[];
		
		if (rowCnt > 0) {
			alert(rowCnt+" 개의 Work를 실행하였습니다.");		
			for (var i = 0; i < datas.length; i++) {
				 var row = new Object()
				 row.wrk_id = datas[i].wrk_id;
				 row.wrk_nm = datas[i].db2pg_ddl_wrk_nm;
				 row.mig_dscd = "TC003201";
				 row.gbn = gbn;
				 row.ddl_save_pth = datas[i].ddl_save_pth;
				 dataSet.push(row);
			}
			$.ajax({
				url : "/db2pg/ImmediateExe.do",
			  	data : {
			  		datas : JSON.stringify(dataSet)	  		
			  	},
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
					if (confirm('실행결과화면으로 이동하시겠습니까?')){
						location.href='/db2pgHistory.do?gbn=ddl' ;
					}
				}
			});			
		}else {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}	
	}else{		
/* ********************************************************
 * 즉시실행 Migration
 ******************************************************** */			
		var datas = tableData.rows('.selected').data();
		var rowCnt = tableData.rows('.selected').data().length;
		
		var dataSet=[];
		
		if (rowCnt > 0) {				
			alert(rowCnt+" <spring:message code='migration.msg11' />");		
			/* ********************************************************
			 * 실행조건 필요(여러개의 WORK중 동일한 테이블 있을시, Alert알림 실행X)
			 * 경우의 수가 너무 많음 추후 고려
			 ******************************************************** */				
				for (var i = 0; i < datas.length; i++) {
					 var row = new Object()
					 row.wrk_id = datas[i].wrk_id;
					 row.wrk_nm = datas[i].db2pg_trsf_wrk_nm;
					 row.mig_dscd = "TC003202";
					 row.gbn = gbn;
					 row.trans_save_pth = datas[i].trans_save_pth;
					 dataSet.push(row);
				}			
				$.ajax({
					url : "/db2pg/ImmediateExe.do",
				  	data : {
				  		datas : JSON.stringify(dataSet)	  		
				  	},
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
						if (confirm("<spring:message code='migration.msg12' />")){
							location.href='/db2pgHistory.do?gbn=mig' ;
						}
					}
				});	
		} else {
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}	
	}
}

</script>
<%@include file="../popup/db2pgConfigInfo.jsp"%>
<%@include file="../popup/ddlRegForm.jsp"%>

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
									<div class="col-5">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-server menu-icon"></i>
												<span class="menu-title"><spring:message code="migration.setting_information_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">MIGRATION</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="migration.setting_information_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.setting_information_management_01"/></p>
											<p class="mb-0"><spring:message code="help.setting_information_management_02"/></p>
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
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('ddlWork');" >
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
							<form class="form-inline" id="searchDDL">
								<div class="row">
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="hidden" name="ddl_save_pth" id="ddl_save_pth">
										<input type="text" class="form-control" style="width:250px;" maxlength="25" id="ddl_wrk_nm" name="ddl_wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />' />
									</div>
									<div class="input-group mb-2 mr-sm-2 search_rman" style="padding-right:10px;">
										<select class="form-control" style="width:200px;"name="ddl_dbms_dscd" id="ddl_dbms_dscd" class="select t5" >
											<option value="">DBMS<spring:message code="common.division" />&nbsp;<spring:message code="common.total" /></option>
											<option value="TC002201">Oracle</option>
											<option value="TC002202">MS-SQL</option>
											<option value="TC002203">MySQL</option>
										</select>
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:250px;" id="ddl_ipadr" name="ddl_ipadr" onblur="this.value=this.value.trim()" placeholder='<spring:message code="data_transfer.ip" />' />
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:250px;" id="ddl_dtb_nm" name="ddl_dtb_nm" onblur="this.value=this.value.trim()" placeholder='Database' />
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:250px;" id="ddl_scm_nm" name="ddl_scm_nm" onblur="this.value=this.value.trim()" placeholder='Schema' />
									</div>
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="getddlDataList()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
									</button>
								</div>
							</form>
							
							<form class="form-inline" id="searchData" style="display:none;">
								<div class="row">
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="hidden" name="ddl_save_pth" id="ddl_save_pth">
										<input type="text" class="form-control" style="width:200px;" maxlength="25" id="data_wrk_nm" name="data_wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />' />
									</div>
									<div class="input-group mb-2 mr-sm-2 search_rman" style="padding-right:10px;">
										<select class="form-control" style="width:200px;"name="ddl_dbms_dscd" id="ddl_dbms_dscd" class="select t5" >
											<option value="source_system"><spring:message code="migration.source_system"/></option>	
											<option value="target_system"><spring:message code="migration.target_system"/></option>
										</select>
									</div>
									<div class="input-group mb-2 mr-sm-2 search_rman" style="padding-right:10px;">
										<select class="form-control" style="width:200px;" name="data_dbms_dscd" id="data_dbms_dscd" class="select t5" >
											<option value="">DBMS<spring:message code="common.division" />&nbsp;<spring:message code="common.total" /></option>
											<c:forEach var="dbmsGrb" items="${dbmsGrb}" varStatus="status">												 
 												<option value="<c:out value="${dbmsGrb.sys_cd}"/>"><c:out value="${dbmsGrb.sys_cd_nm}"/></option>
 											</c:forEach>
										</select>
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:200px;" id="data_ipadr" name="data_ipadr" onblur="this.value=this.value.trim()" placeholder='<spring:message code="data_transfer.ip" />' />
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:200px;" id="data_dtb_nm" name="data_dtb_nm" onblur="this.value=this.value.trim()" placeholder='Database' />
									</div>
									<div class="input-group mb-2 mr-sm-2" style="padding-right:10px;">
										<input type="text" class="form-control" style="width:200px;" id="data_scm_nm" name="data_scm_nm" onblur="this.value=this.value.trim()" placeholder='Schema' />
									</div>
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="getdataDataList()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
									</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-12 stretch-card div-form-margin-table" id="left_list">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo" id="btnDDL">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" onclick="fn_ImmediateStart('ddl')" data-toggle="modal">
									<i class="ti-control-forward btn-icon-prepend "></i><spring:message code="migration.run_immediately"/>
								</button>
								
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_copy()" id="btnImmediately">
									<i class="ti-layers btn-icon-prepend "></i><spring:message code="migration.create_replica" />
								</button>				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onclick="fn_ddl_work_delete()">
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onclick="fn_ddl_regre_popup()" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onclick="fn_ddl_reg_popup()" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
							
							<div class="template-demo" id="btnData" style="display:none;">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" onclick="fn_ImmediateStart('trans')" data-toggle="modal">
									<i class="ti-control-forward btn-icon-prepend "></i><spring:message code="migration.run_immediately"/>
								</button>
								
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_copy()" id="btnImmediately">
									<i class="ti-layers btn-icon-prepend "></i><spring:message code="migration.create_replica" />
								</button>				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onclick="fn_data_work_delete()">
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onclick="fn_ddl_regre_popup()" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onclick="fn_data_reg_popup()" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>

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
												<th width="10"></th>
												<th width="30"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="common.work_name" /></th>
												<th width="200"><spring:message code="common.work_description" /></th>
												<th width="100">DBMS <spring:message code="common.division" /></th>
												<th width="100"><spring:message code="history_management.ip" /></th>
												<th width="100">Database</th>
												<th width="150">Schema</th>
												<th width="100"><spring:message code="common.register" /></th>
												<th width="120"><spring:message code="common.regist_datetime" /></th>
												<th width="100"><spring:message code="common.modifier" /></th>
												<th width="120"><spring:message code="common.modify_datetime" /></th>
												<th width="0">db2pg_ddl_wrk_id</th>
												<th width="0">wrk_id</th>
												<th width="0">ddl_save_pth</th>
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
												<th width="10" rowspan="2"></th>
												<th width="30" rowspan="2"><spring:message code="common.no" /></th>
												<th width="100" rowspan="2"><spring:message code="common.work_name" /></th>
												<th width="200" rowspan="2"><spring:message code="common.work_description" /></th>
												<th width="600" colspan="4"><spring:message code="migration.source_system"/></th>
												<th width="600" colspan="4"><spring:message code="migration.target_system"/></th>
												<th width="100" rowspan="2"><spring:message code="common.register" /></th>
												<th width="120" rowspan="2"><spring:message code="common.regist_datetime" /></th>
												<th width="100" rowspan="2"><spring:message code="common.modifier" /></th>
												<th width="120" rowspan="2"><spring:message code="common.modify_datetime" /></th>
											</tr>
											<tr class="bg-info text-white">
												<th width="100">DBMS <spring:message code="common.division" /></th>
												<th width="100"><spring:message code="data_transfer.ip" /></th>
												<th width="100">Database</th>
												<th width="100">Schema</th>
												<th width="100">DBMS <spring:message code="common.division" /></th>
												<th width="100"><spring:message code="data_transfer.ip" /></th>
												<th width="100">Database</th>
												<th width="100">Schema</th>
												<th width="0">db2pg_trsf_wrk_id</th>
												<th width="0">wrk_id</th>
												<th width="0">trans_save_pth</th>
												<th width="0">src_cnd_qry</th>
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




<!-- 복제 등록  -->
<div class="modal fade" id="pop_layer_copy" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="display: none;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 200px 300px;">
		<div class="modal-content" style="width:1000px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="migration.create_replica"/>
				</h4>
				<div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:250px;overflow-y:auto;">
					<form class="cmxform" id="copyRegForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>
									<div class="col-sm-8">
										<input type="text" class="form-control form-control-sm" maxlength="20" id="wrk_nm" name="wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()"/>
									</div>
									<div class="col-sm-2">
										<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_check()"><spring:message code="common.overlap_check" /></button>
									</div>
								</div>
								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>
									<div class="col-sm-10">
										<textarea class="form-control" id="wrk_exp" name="wrk_exp" rows="2" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>" required tabindex=2></textarea>
									</div>
								</div>
							</div>
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button"  onclick="fn_copy_save()" value='<spring:message code="common.registory" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>