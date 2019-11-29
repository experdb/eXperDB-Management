<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs.jsp"%>
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
	tableDDL.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
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
						alert('삭제에 실패했습니다.');
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
							alert('삭제에 실패했습니다.');
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
		alert("하나의 항목만 선택해주세요.");
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
						alert('등록에 실패했습니다.');
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
						alert('등록에 실패했습니다.');
					}	
				}
			});
		}
	}
}
 
/* ********************************************************
 * 즉시실행
 ******************************************************** */
function fn_ImmediateStart(gbn){
	var db2pgGbn = gbn;
	if(gbn == 'ddl'){
		var rowCnt = tableDDL.rows('.selected').data().length;
		var ddl_save_pth = tableDDL.row('.selected').data().ddl_save_pth;
		var dtb_nm = tableDDL.row('.selected').data().dtb_nm;

		if (rowCnt == 1) {
			$.ajax({
				url : "/db2pg/immediateStart.do",
			  	data : {
			  		wrk_id : tableDDL.row('.selected').data().wrk_id,
			  		wrk_nm : tableDDL.row('.selected').data().db2pg_ddl_wrk_nm		  		
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
					fn_db2pgDDLResultLayer(ddl_save_pth,dtb_nm);
				}
			});			
		} else {
			alert("<spring:message code='message.msg04' />");
			return false;
		}
	}else{
		var rowCnt = tableData.rows('.selected').data().length;
		if (rowCnt == 1) {					
			$.ajax({
				url : "/db2pg/immediateStart.do",
			  	data : {
			  		wrk_id : tableData.row('.selected').data().wrk_id,
			  		wrk_nm : tableData.row('.selected').data().db2pg_trsf_wrk_nm		  		
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
					alert(result.RESULT);
				}
			});	
		} else {
			alert("<spring:message code='message.msg04' />");
			return false;
		}	
	}
}


</script>
<%@include file="../popup/db2pgConfigInfo.jsp"%>
<%@include file="../popup/db2pgDDLResult.jsp"%>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>설정정보관리<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>설정정보관리 설명</li>
					<li></li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Migration</li>
					<li class="on">설정정보관리</li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('ddlWork')">DDL</a></li>
					<li><a href="javascript:selectTab('dataWork')">Migration</a></li>
				</ul>
				<ul id="tab2" style="display:none;">
					<li><a href="javascript:selectTab('ddlWork')">DDL</a></li>
					<li class="atv"><a href="javascript:selectTab('dataWork')">Migration</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_float">													
					<div class="btn_type_01" id="btnDDL">
						<span class="btn btnC_01 btn_fl"><button type="button" onclick="fn_ImmediateStart('ddl')">즉시실행</button></span> 	
						<a class="btn" onClick="getddlDataList();"><button type="button"><spring:message code="common.search" /></button></a>
						<span class="btn" onclick="fn_ddl_reg_popup()"><button type="button"><spring:message code="common.registory" /></button></span>
						<span class="btn" onClick="fn_ddl_regre_popup()"><button type="button"><spring:message code="common.modify" /></button></span>
						<span class="btn" onClick="fn_ddl_work_delete()"><button type="button"><spring:message code="common.delete" /></button></span>
						<span class="btn"><button type="button" onclick="fn_copy()">복제 등록</button></span> 	
					</div>
					<div class="btn_type_01" id="btnData" style="display:none;">
						<span class="btn btnC_01 btn_fl"><button type="button" onclick="fn_ImmediateStart('trans')">즉시실행</button></span> 	
						<span class="btn" onclick="getdataDataList()"><button type="button"><spring:message code="common.search" /></button></span>
						<span class="btn" onclick="fn_data_reg_popup()"><button type="button"><spring:message code="common.registory" /></button></span>
						<span class="btn" onclick="fn_data_regre_popup()"><button type="button"><spring:message code="common.modify" /></button></span>
						<span class="btn" onclick="fn_data_work_delete()"><button type="button"><spring:message code="common.delete" /></button></span>
						<span class="btn"><button type="button" onclick="fn_copy()">복제 등록</button></span> 	
					</div>
				</div>
				<div class="sch_form">
					<table class="write" id="searchDDL">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:10%;" />
							<col style="width:25%;" />
							<col style="width:10%;" />
							<col style="width:25%;" />
							<col style="width:8%;" />
							<col style="width:22%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<input type="hidden" name="ddl_save_pth" id="ddl_save_pth">
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="ddl_wrk_nm" id="ddl_wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">DBMS구분</th>
								<td>
									<select name="ddl_dbms_dscd" id="ddl_dbms_dscd" class="select t5" >
										<option value=""><spring:message code="common.total" /></option>				
										<option value="TC002201">Oracle</option>
										<option value="TC002202">MS-SQL</option>
										<option value="TC002203">MySQL</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">아이피</th>
								<td><input type="text" name="ddl_ipadr" id="ddl_ipadr" class="txt t3"/></td>
								<th scope="row" class="t9">Database</th>
								<td><input type="text" name="ddl_dtb_nm" id="ddl_dtb_nm" class="txt t3"/></td>
								<th scope="row" class="t9">Schema</th>
								<td><input type="text" name="ddl_scm_nm" id="ddl_scm_nm" class="txt t3"/></td>
							</tr>
						</tbody>
					</table>
					<table class="write" id="searchData" style="display:none;">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:10%;" />
							<col style="width:25%;" />
							<col style="width:10%;" />
							<col style="width:25%;" />
							<col style="width:8%;" />
							<col style="width:22%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="data_wrk_nm" id="data_wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">구분</th>
								<td>		
									<select name="data_dbms_dscd" id="data_dbms_dscd" class="select t5" >
										<option value="source_system">소스시스템</option>	
										<option value="target_system">타겟시스템</option>				
									</select>	
								</td>
								<th scope="row" class="t9">DBMS구분</th>
								<td>
									<select name="dbms_dscd" id="dbms_dscd" class="select t5" >
										<option value=""><spring:message code="common.total" /></option>				
											<c:forEach var="dbmsGrb" items="${dbmsGrb}" varStatus="status">												 
 												<option value="<c:out value="${dbmsGrb.sys_cd}"/>"><c:out value="${dbmsGrb.sys_cd_nm}"/></option>
 											</c:forEach>
									</select>	
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">아이피</th>
								<td><input type="text" name="data_ipadr" id="data_ipadr" class="txt t3"/></td>
								<th scope="row" class="t9">Database</th>
								<td><input type="text" name="data_dtb_nm" id="data_dtb_nm" class="txt t3"/></td>
								<th scope="row" class="t9">Schema</th>
								<td><input type="text" name="data_scm_nm" id="data_scm_nm" class="txt t3"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table id="ddlDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30"><spring:message code="common.no" /></th>
									<th width="100">Work명</th>
									<th width="200">Work설명</th>
									<th width="100">DBMS 구분</th>
									<th width="100">아이피</th>
									<th width="100">Database</th>
									<th width="150">Schema</th>
									<th width="100">등록자</th>
									<th width="100">등록일시</th>
									<th width="100">수정자</th>
									<th width="100">수정일시</th>
									<th width="0">db2pg_ddl_wrk_id</th>
									<th width="0">wrk_id</th>
									<th width="0">ddl_save_pth</th>
								</tr>
							</thead>
						</table>	
					<table id="dataDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="10" rowspan="2"></th>
									<th width="30" rowspan="2"><spring:message code="common.no" /></th>
									<th width="100" rowspan="2">Work명</th>
									<th width="200" rowspan="2">Work설명</th>
									<th width="600" colspan="4">소스시스템</th>
									<th width="600" colspan="4">타겟시스템</th>
									<th width="100" rowspan="2">등록자</th>
									<th width="100" rowspan="2">등록일시</th>
									<th width="100" rowspan="2">수정자</th>
									<th width="100" rowspan="2">수정일시</th>
								</tr>
								<tr>
									<th width="100">DBMS 구분</th>
									<th width="100">아이피</th>
									<th width="100">Database</th>
									<th width="100">Schema</th>
									<th width="100">DBMS 구분</th>
									<th width="100">아이피</th>
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
</div><!-- // contents -->


<div id="pop_layer_copy" class="pop-layer">
	<div class="pop-container" style="padding: 0px;">
		<div class="pop_cts" style="width: 50%; height: 350px; overflow: auto; padding: 40px; margin: 0 auto; min-height:0; min-width:0;">
			<p class="tit" style="margin-bottom: 15px;">복제 등록
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_copy'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="margin-left: 235px;"/></a>
			</p>
			<table class="write">
				<colgroup>
					<col style="width:105px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
						<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()"/>
						<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.work_description" /></th>
						<td>
							<div class="textarea_grp">
								<textarea name="wrk_exp" id="wrk_exp" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="fn_copy_save()"><span>저장</span></a>
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_copy'), 'off');"><span><spring:message code="common.close"/></span></a>
			</div>		
		</div>
	</div><!-- //pop-container -->
</div>