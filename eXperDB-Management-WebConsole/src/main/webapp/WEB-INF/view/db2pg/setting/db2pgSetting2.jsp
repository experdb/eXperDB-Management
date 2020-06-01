<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<script type="text/javascript">

var tableDDL = null;
var tableData = null;

var wrk_nmChk = "fail";

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
	var popUrl = "/db2pg/popup/ddlRegForm.do";
	var width = 965;
	var height = 705;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"ddlRegPop",popOption);
	winPop.focus();
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
		alert("<spring:message code='message.msg04' />");
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
		alert("<spring:message code='message.msg04' />");
		return false;
	}
}

/* ********************************************************
 * DDL추출 Data Delete
 ******************************************************** */
function fn_ddl_work_delete(){
	var datas = tableDDL.rows('.selected').data();
	if(datas.length < 1){
		alert("<spring:message code='message.msg16' />");
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
					if(result.resultCode == "0000000000"){
						alert("<spring:message code='message.msg37' />");
						getddlDataList();
					}else{
						alert('<spring:message code="migration.msg09"/>');
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
			alert("<spring:message code='message.msg16' />");
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
						if(result.resultCode == "0000000000"){
							alert("<spring:message code='message.msg37' />");
							getdataDataList();	
						}else{
							alert('<spring:message code="migration.msg09"/>');
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
		toggleLayer($('#pop_layer_copy'), 'on');
	}else if(dataRowCnt==1){
		toggleLayer($('#pop_layer_copy'), 'on');
	}else{
		alert('<spring:message code="migration.msg10"/>');
	}
}

/* ********************************************************
 * WORK NM Validation Check
 ******************************************************** */
function fn_check() {
	var wrk_nm = document.getElementById("wrk_nm");
	if (wrk_nm.value == "") {
		alert('<spring:message code="message.msg107" />');
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
				alert('<spring:message code="backup_management.reg_possible_work_nm"/>');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";		
			} else {
				alert('<spring:message code="backup_management.effective_work_nm"/>');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "fail";	
			}
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
	});
}

/* ********************************************************
 * 복제
 ******************************************************** */
function fn_copy_save(){
	if($("#wrk_nm").val() == ""){
		alert('<spring:message code="message.msg107" />');
		$("#wrk_nm").focus();
		return false;
	}else if(wrk_nmChk =="fail"){
		alert('<spring:message code="backup_management.work_overlap_check"/>');
		return false;
	}else if($("#db2pg_ddl_wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
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
					if(result.resultCode == "0000000000"){
						$("#wrk_nm").val("");
						$("#wrk_exp").val("");
						alert('<spring:message code="message.msg07" /> ');
						toggleLayer($('#pop_layer_copy'), 'off');
						getddlDataList();
					}else{
						alert('<spring:message code="migration.msg06"/>');
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
					if(result.resultCode == "0000000000"){
						$("#wrk_nm").val("");
						$("#wrk_exp").val("");
						alert('<spring:message code="message.msg07" /> ');
						toggleLayer($('#pop_layer_copy'), 'off');
						getdataDataList();
					}else{
						alert('<spring:message code="migration.msg06"/>');
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
					if (confirm('실행결과화면으로 이동하시겠습니까?')){
						location.href='/db2pgHistory.do?gbn=ddl' ;
					}
				}
			});			
		}else {
			alert("<spring:message code='message.msg35' />");
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
						if (confirm("<spring:message code='migration.msg12' />")){
							location.href='/db2pgHistory.do?gbn=mig' ;
						}
					}
				});	
		} else {
			alert("<spring:message code='message.msg04' />");
			return false;
		}	
	}
}

</script>
<div class="content-wrapper">
	<div class="row">
		<div class="col-12">
			<div class="card">
				<div class="card-body">
					<nav aria-label="breadcrumb ">
						<ol class="breadcrumb justify-content-end bg-info">
							<li class="breadcrumb-item">MIGRATION</li>
							<li class="breadcrumb-item active" aria-current="page">설정정보관리</li>
						</ol>
					</nav>
					<div class="mt-4">
						<div class="accordion accordion-solid-header" id="accordion"
							role="tablist">
							<div class="card">
								<div class="card-header" role="tab" id="heading-1">
									<h6 class="mb-0">
										<a data-toggle="collapse" href="#collapse-1" aria-expanded="false" aria-controls="collapse-1" class="collapsed"> 설정정보관리 </a>
									</h6>
								</div>
								<div id="collapse-1" class="collapse" role="tabpanel" aria-labelledby="heading-1" data-parent="#accordion" style="">
									<div class="card-body">
										<div class="row">
											<div class="col-12">
												<p class="mb-0">서버에 생성된 설정정보관리 작업을 조회하거나 신규로 등록 또는 삭제 합니다.</p>
												<p class="mb-0">조회 목록에서 Work명을 클릭하면 Configuration 정보를 조회할 수 있습니다.</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="card">
						<div class="card-body">
							<form class="form-inline">
								<label class="sr-only" for="inlineFormInputGroupUsername2">Username</label>
								<div class="input-group mb-2 mr-sm-2">
									<div class="input-group-prepend">
										<div class="input-group-text">work명</div>
									</div>
									<input type="text" class="form-control" id="inlineFormInputGroupUsername2">
								</div>
								<label class="sr-only" for="inlineFormInputGroupUsername2">Username</label>
								<div class="input-group mb-2 mr-sm-2">
									<div class="input-group-prepend">
										<div class="input-group-text" style="color: black;">DBMS구분</div>
									</div>
									<input type="text" class="form-control" id="inlineFormInputGroupUsername2">
								</div>
								<label class="sr-only" for="inlineFormInputGroupUsername2">Username</label>
								<div class="input-group mb-2 mr-sm-2">
									<div class="input-group-prepend">
										<div class="input-group-text" style="color: #248afd;">아이피</div>
									</div>
									<input type="text" class="form-control" id="inlineFormInputGroupUsername2">
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2">
									<i class="ti-search btn-icon-prepend "></i>조회
								</button>
							</form>
						</div>
					</div>

					<br>
					<div class="template-demo">
						<button type="button" class="btn btn-outline-primary btn-icon-text">
							<i class="ti-control-play btn-icon-prepend"></i>즉시실행
						</button>
						<button type="button" class="btn btn-outline-primary btn-icon-text float-right">
							<i class="ti-files btn-icon-prepend "></i>복제등록
						</button>
						<button type="button" class="btn btn-outline-primary btn-icon-text float-right">
							<i class="ti-trash btn-icon-prepend "></i>삭제
						</button>
						<button type="button" class="btn btn-outline-primary btn-icon-text float-right">
							<i class="ti-pencil-alt btn-icon-prepend "></i>수정
						</button>
						<button type="button" class="btn btn-outline-primary btn-icon-text float-right">
							<i class="ti-pencil btn-icon-prepend "></i>등록
						</button>
						</button>
					</div>

					<br>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-12">
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

									<table id="ddlDataTable" class="table table-hover table-striped" cellspacing="0" width="100%">
										<thead>
											<tr class="bg-primary text-white">
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
							</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>















<div class="sch_form" style="display: none;">
	<table class="write" id="searchDDL">
		<caption>검색 조회</caption>
		<colgroup>
			<col style="width: 10%;" />
			<col style="width: 25%;" />
			<col style="width: 10%;" />
			<col style="width: 25%;" />
			<col style="width: 8%;" />
			<col style="width: 22%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<input type="hidden" name="ddl_save_pth" id="ddl_save_pth">
				<th scope="row" class="t9"><spring:message
						code="common.work_name" /></th>
				<td><input type="text" name="ddl_wrk_nm" id="ddl_wrk_nm"
					class="txt t3" maxlength="25" /></td>
				<th scope="row" class="t9">DBMS<spring:message
						code="common.division" /></th>
				<td><select name="ddl_dbms_dscd" id="ddl_dbms_dscd"
					class="select t5">
						<option value=""><spring:message code="common.total" /></option>
						<option value="TC002201">Oracle</option>
						<option value="TC002202">MS-SQL</option>
						<option value="TC002203">MySQL</option>
				</select></td>
			</tr>
			<tr>
				<th scope="row" class="t9"><spring:message code="data_transfer.ip" /></th>
				<td><input type="text" name="ddl_ipadr" id="ddl_ipadr" class="txt t3" /></td>
				<th scope="row" class="t9">Database</th>
				<td><input type="text" name="ddl_dtb_nm" id="ddl_dtb_nm" class="txt t3" /></td>
				<th scope="row" class="t9">Schema</th>
				<td><input type="text" name="ddl_scm_nm" id="ddl_scm_nm" class="txt t3" /></td>
			</tr>
		</tbody>
	</table>
	<table class="write" id="searchData" style="display: none;">
		<caption>검색 조회</caption>
		<colgroup>
			<col style="width: 10%;" />
			<col style="width: 25%;" />
			<col style="width: 10%;" />
			<col style="width: 25%;" />
			<col style="width: 8%;" />
			<col style="width: 22%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
				<td><input type="text" name="data_wrk_nm" id="data_wrk_nm" class="txt t3" maxlength="25" /></td>
				<th scope="row" class="t9"><spring:message code="common.division" /></th>
				<td><select name="data_dbms_dscd" id="data_dbms_dscd" class="select t5">
						<option value="source_system"><spring:message code="migration.source_system" /></option>
						<option value="target_system"><spring:message code="migration.target_system" /></option>
				</select></td>
				<th scope="row" class="t9">DBMS<spring:message code="common.division" /></th>
				<td><select name="dbms_dscd" id="dbms_dscd" class="select t5">
						<option value=""><spring:message code="common.total" /></option>
						<c:forEach var="dbmsGrb" items="${dbmsGrb}" varStatus="status">
							<option value="<c:out value="${dbmsGrb.sys_cd}"/>">
							<c:out value="${dbmsGrb.sys_cd_nm}" /></option>
						</c:forEach>
				</select></td>
			</tr>
			<tr>
				<th scope="row" class="t9"><spring:message code="data_transfer.ip" /></th>
				<td><input type="text" name="data_ipadr" id="data_ipadr" class="txt t3" /></td>
				<th scope="row" class="t9">Database</th>
				<td><input type="text" name="data_dtb_nm" id="data_dtb_nm" class="txt t3" /></td>
				<th scope="row" class="t9">Schema</th>
				<td><input type="text" name="data_scm_nm" id="data_scm_nm" class="txt t3" /></td>
			</tr>
		</tbody>
	</table>
</div>

