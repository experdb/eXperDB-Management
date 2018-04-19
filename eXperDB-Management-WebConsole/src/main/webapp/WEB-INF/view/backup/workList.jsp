<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : workList.jsp
	* @Description : 백업 목록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2017.06.07     최초 생성
	*  2017.10.23 	 변승우			테이블 -> 데이터테이블 변환
    *	
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>


<script type="text/javascript">
var tableRman = null;
var tableDump = null;
function fn_init(){
	
	/* ********************************************************
	 * RMAN 백업설정 리스트
	 ******************************************************** */
	tableRman = $('#rmanDataTable').DataTable({
	scrollY : "330px",
	scrollX : true,
	searching : false,	
	deferRender : true,
	bSort: false,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
			}
		}, //work명
		{data : "wrk_exp", className : "dt-nowrap", defaultContent : ""},	
		{data : "bck_opt_cd_nm", defaultContent : ""
			,"render": function (data, type, full) {
				if(full.bck_opt_cd=="TC000301"){
					var html = '<spring:message code="backup_management.full_backup" />';
						return html;
				}else if(full.bck_opt_cd=="TC000302"){
					var html = '<spring:message code="backup_management.incremental_backup" />';
					return html;
				}else{
					var html = '<spring:message code="backup_management.change_log_backup" />';
					return html;
				}
				return data;
			}
		},
		{data : "data_pth", className : "dt-left", defaultContent : ""},	
		{data : "bck_pth", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_rmanShow("'+full.bck_pth+'","'+full.db_svr_id+'"); class="bold">' + full.bck_pth + '</span>';
			}
		 },		
		//{data : "log_file_pth", className : "dt-left", defaultContent : ""},	
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""},
		{data : "bck_wrk_id", defaultContent : "", visible: false }
	],'select': {'style': 'multi'}
	});
	
	
	/* ********************************************************
	 * DUMP 백업설정 리스트
	 ******************************************************** */
	tableDump = $('#dumpDataTable').DataTable({
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
		{data : "idx", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {				
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
			}
		},
		{data : "wrk_exp", className : "dt-left", defaultContent : ""},
		{data : "db_nm", defaultContent : ""}, 
		{data : "save_pth", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_dumpShow("'+full.save_pth+'","'+full.db_svr_id+'"); class="bold">' + full.save_pth + '</span>';
			}
		 },
		{data : "file_fmt_cd_nm", defaultContent : ""}, 
		{data : "cprt", defaultContent : ""}, 
		{data : "encd_mth_nm", defaultContent : ""}, 
		{data : "usr_role_nm", defaultContent : ""}, 
		{data : "file_stg_dcnt", defaultContent : ""}, 	
		{data : "bck_mtn_ecnt", defaultContent : ""}, 		
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""},
		{data : "bck_wrk_id", defaultContent : "" , visible: false }
	],'select': {'style': 'multi'}
	});
	
	tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '230px');
	tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '230px');
	/* tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '230px'); */
	tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '100px');  
	tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(11)').css('min-width', '0px');


	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '250px');
	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '60px');
	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');  
	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '90px');  
	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '150px');
	tableDump.tables().header().to$().find('th:eq(12)').css('min-width', '70px');
	tableDump.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(14)').css('min-width', '70px');  
	tableDump.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
	$(window).trigger('resize'); 
}


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(
	function() {	
		fn_init();		
		getRmanDataList();
		getDumpDataList();			
		$("#rmanDataTable").show();
		$("#rmanDataTable_wrapper").show();
		$("#dumpDataTable").hide();
		$("#dumpDataTable_wrapper").hide();		
});


function fn_rmanShow(bck, db_svr_id){
	
	  var frmPop= document.frmPopup;
	    var url = '/rmanShowView.do';
	    window.open('','popupView','width=1500, height=800');  
	     
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
 * Rman Backup Find Button Click
 ******************************************************** */
function fn_rman_find_list(){
	getRmanDataList($("#wrk_nm").val(), $("#bck_opt_cd").val());
}

/* ********************************************************
 * Dump Backup Find Button Click
 ******************************************************** */
function fn_dump_find_list(){
	getDumpDataList($("#wrk_nm").val(), $("#db_id").val());
}

/* ********************************************************
 * Rman Backup Regist Window Open
 ******************************************************** */
function fn_rman_reg_popup(){
	var popUrl = "/popup/rmanRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 799;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"rmanRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Rman Backup Reregist Window Open
 ******************************************************** */
function fn_rman_regreg_popup(){
	
		var datas = tableRman.rows('.selected').data();
		
		if (datas.length <= 0) {
			alert("<spring:message code='message.msg35' />");
			return false;
		}else if(datas.length > 1){
			alert("<spring:message code='message.msg04' />");
			return false;
		}else{
			var bck_wrk_id = tableRman.row('.selected').data().bck_wrk_id;
			var popUrl = "/popup/rmanRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
			var width = 954;
			var height = 799;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
			var winPop = window.open(popUrl,"rmanRegPop",popOption);
			winPop.focus();	
		}
		
}

/* ********************************************************
 * Rman Backup Reregist Window Open
 ******************************************************** */
function fn_rman_reform_popup(bck_wrk_id){
	var popUrl = "/popup/rmanRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
	var width = 954;
	var height = 650;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"rmanRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Dump Backup Regist Window Open
 ******************************************************** */
function fn_dump_reg_popup(){
	var popUrl = "/popup/dumpRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 900;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Dump Backup Reregist Window Open
 ******************************************************** */
function fn_dump_regreg_popup(){
	var datas = tableDump.rows('.selected').data();

	if (datas.length <= 0) {
		alert("<spring:message code='message.msg35' />");
		return false;
	}else if(datas.length > 1){
		alert("<spring:message code='message.msg04' />");
		return false;
	}else{
		var bck_wrk_id = tableDump.row('.selected').data().bck_wrk_id;
		var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
		var width = 954;
		var height = 900;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"dumpRegPop",popOption);
		winPop.focus();			
	}
}

/* ********************************************************
 * Dump Backup Reregist Window Open
 ******************************************************** */
function fn_dump_reform_popup(bck_wrk_id){
	var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
	var width = 954;
	var height = 900;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
}



/* ********************************************************
 * Rman Backup Data Fetch List
 ******************************************************** */
function getRmanDataList(wrk_nm, bck_opt_cd){
	$.ajax({
		url : "/backup/getWorkList.do", 
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		bck_opt_cd : bck_opt_cd,
	  		wrk_nm : wrk_nm,
	  		bck_bsn_dscd : "TC000201"
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
			tableRman.rows({selected: true}).deselect();
			tableRman.clear().draw();
			tableRman.rows.add(data).draw();
		}
	});
}




/* ********************************************************
 * Dump Backup Data Fetch List
 ******************************************************** */
function getDumpDataList(wrk_nm, db_id){
	if(db_id == "") db_id = 0;
	$.ajax({
		url : "/backup/getWorkList.do",
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		db_id : db_id,
	  		wrk_nm : wrk_nm,
	  		bck_bsn_dscd : "TC000202"
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
			tableDump.rows({selected: true}).deselect();
			tableDump.clear().draw();
			tableDump.rows.add(data).draw();
		}
	});
}


/* ********************************************************
 * Rman Data List Checkbox Check
 ******************************************************** */
function fn_rman_check_close(){
	var checkAll = true;
	$("input:checkbox[name='rmanWorkId']").each(function(){
		if(!$(this).is(":checked")) checkAll = false;
	});
	$("#rmanCheckAll").attr("checked",checkAll);
}

/* ********************************************************
 * Dump Data List Checkbox Check
 ******************************************************** */
function fn_dump_check_close(){
	var checkAll = true;
	$("input:checkbox[name='dumpWorkId']").each(function(){
		if(!$(this).is(":checked")) checkAll = false;
	});
	$("#dumpCheckAll").attr("checked",checkAll);
}

/* ********************************************************
 * Rman Data List Checkbox Check All
 ******************************************************** */
function fn_rman_check_all(){
	if($("#rmanCheckAll").is(":checked")){
		$("input:checkbox[name='rmanWorkId']").each(function(){
			this.checked = true;
		});
	}else{
		$("input:checkbox[name='rmanWorkId']").each(function(){
			this.checked = false;
		});
	}
}

/* ********************************************************
 * Dump Data List Checkbox Check All
 ******************************************************** */
function fn_dump_check_all(){
	if($("#dumpCheckAll").is(":checked")){
		$("input:checkbox[name='dumpWorkId']").each(function(){
			this.checked = true;
		});
	}else{
		$("input:checkbox[name='dumpWorkId']").each(function(){
			this.checked = false;
		});
	}
}

/* ********************************************************
 * Rman Data Delete
 ******************************************************** */
function fn_rman_work_delete(){
	var datas = tableRman.rows('.selected').data();
	
	if(datas.length < 1){
		alert("<spring:message code='message.msg16' />");
		return false;
	}
	
	var bck_wrk_id_List = [];
	var wrk_id_List = [];
    for (var i = 0; i < datas.length; i++) {
    	bck_wrk_id_List.push( tableRman.rows('.selected').data()[i].bck_wrk_id);   
    	wrk_id_List.push( tableRman.rows('.selected').data()[i].wrk_id);   
  	}	
		
    $.ajax({
		url : "/popup/scheduleCheck.do",
	  	data : {
	  		bck_wrk_id_List : JSON.stringify(bck_wrk_id_List),
	  		wrk_id_List : JSON.stringify(wrk_id_List)
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
			fn_deleteWork(data, bck_wrk_id_List, wrk_id_List);
		}
	});	
}

function fn_deleteWork(scheduleChk, bck_wrk_id_List, wrk_id_List){
	if(scheduleChk != 0 ){
		alert("<spring:message code='backup_management.reg_schedule_delete_no'/>");
		return false;
	}else{   
		if(confirm('<spring:message code="message.msg17" />')){
					$.ajax({
						url : "/popup/workDelete.do",
					  	data : {
					  		bck_wrk_id_List : JSON.stringify(bck_wrk_id_List),
					  		wrk_id_List : JSON.stringify(wrk_id_List)
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
							alert("<spring:message code='message.msg18' />");
							fn_rman_find_list();
						}
					});						
				}
			}
		}


/* ********************************************************
 * Dump Data Delete
 ******************************************************** */
function fn_dump_work_delete(){	
	var datas = tableDump.rows('.selected').data();
	
	if(datas.length < 1){
		alert("<spring:message code='message.msg16' />");
		return false;
	}
	
	var bck_wrk_id_List = [];
	var wrk_id_List = [];
    for (var i = 0; i < datas.length; i++) {
    	bck_wrk_id_List.push( tableDump.rows('.selected').data()[i].bck_wrk_id);   
    	wrk_id_List.push( tableDump.rows('.selected').data()[i].wrk_id);   
  	}	
    
    $.ajax({
		url : "/popup/scheduleCheck.do",
	  	data : {
	  		bck_wrk_id_List : JSON.stringify(bck_wrk_id_List),
	  		wrk_id_List : JSON.stringify(wrk_id_List)
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
			fn_deleteWork_dump(data, bck_wrk_id_List, wrk_id_List);
		}
	});	
}

function fn_deleteWork_dump(scheduleChk, bck_wrk_id_List, wrk_id_List){
    if(scheduleChk != 0 ){
		alert("<spring:message code='backup_management.reg_schedule_delete_no'/>");
		return false;
	}else{   
		if(confirm('<spring:message code="message.msg17" />')){
					$.ajax({
						url : "/popup/workDelete.do",
					  	data : {
					  		bck_wrk_id_List : JSON.stringify(bck_wrk_id_List),
					  		wrk_id_List : JSON.stringify(wrk_id_List)
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
							alert("<spring:message code='message.msg18' />");
							fn_dump_find_list();
						}
					});			
		}
	}
}

/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){
	if(tab == "dump"){
		$("#dumpDataTable").show();
		$("#dumpDataTable_wrapper").show();
		$("#rmanDataTable").hide();
		$("#rmanDataTable_wrapper").hide();
		$("#tab1").hide();
		$("#tab2").show();
		$("#searchRman").hide();
		$("#searchDump").show();
		$("#btnRman").hide();
		$("#btnDump").show();
	}else{
		$("#rmanDataTable").show();
		$("#rmanDataTable_wrapper").show();
		$("#dumpDataTable").hide();
		$("#dumpDataTable_wrapper").hide();
		$("#tab1").show();
		$("#tab2").hide();
		$("#searchRman").show();
		$("#searchDump").hide();
		$("#btnRman").show();
		$("#btnDump").hide();
	}
}
</script>

<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>


<form name="frmPopup">
	<input type="hidden" name="bck"  id="bck">
	<input type="hidden" name="db_svr_id"  id="db_svr_id">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.backup_settings" /><a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.backup_settings_01" /> </li>
					<%-- <li><spring:message code="help.backup_settings_02" /></li> --%>
					<li><spring:message code="help.backup_settings_03" /></li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.backup_management" /></li>
					<li class="on"><spring:message code="menu.backup_settings" /></li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('rman')"><spring:message code="backup_management.rman_backup" /></a></li>
					<li><a href="javascript:selectTab('dump')"><spring:message code="backup_management.dumpBck"/></a></li>
				</ul>
				<ul id="tab2" style="display:none;">
					<li><a href="javascript:selectTab('rman')"><spring:message code="backup_management.rman_backup" /></a></li>
					<li class="atv"><a href="javascript:selectTab('dump')"><spring:message code="backup_management.dumpBck"/></a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_01" id="btnRman">
					<a class="btn" onClick="fn_rman_find_list();"><button><spring:message code="common.search" /></button></a>
					<span class="btn" onclick="fn_rman_reg_popup()"><button><spring:message code="common.registory" /></button></span>
					<span class="btn" onClick="fn_rman_regreg_popup()"><button><spring:message code="common.modify" /></button></span>
					<span class="btn" onClick="fn_rman_work_delete()"><button><spring:message code="common.delete" /></button></span>
				</div>
				<div class="btn_type_01" id="btnDump" style="display:none;">
					<span class="btn" onclick="fn_dump_find_list()"><button><spring:message code="common.search" /></button></span>
					<span class="btn" onclick="fn_dump_reg_popup()"><button><spring:message code="common.registory" /></button></span>
					<span class="btn" onclick="fn_dump_regreg_popup()"><button><spring:message code="common.modify" /></button></span>
					<span class="btn" onclick="fn_dump_work_delete()"><button><spring:message code="common.delete" /></button></span>
				</div>
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>				
				<div class="sch_form">
					<table class="write" id="searchRman">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:100px;" />
							<col style="width:230px;" />
							<col style="width:115px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9" ><spring:message code="backup_management.backup_option" /></th>
								<td><select name="bck_opt_cd" id="bck_opt_cd" class="txt t3" style="width:150px;">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
										<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
										<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					<table class="write" id="searchDump" style="display:none;">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:100px;" />
							<col style="width:230px;" />
							<col style="width:100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" class="txt t3" name="wrk_nm" id="wrk_nm" maxlength="25"/></td>
								<th scope="row" class="t9"><spring:message code="common.database" /></th>
								<td>
									<select name="db_id" id="db_id" class="txt t3" style="width:150px;">
										<option value=""><spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
										<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				
				<div class="overflow_area">
					<table id="rmanDataTable" class="display" cellspacing="0" width="100%">
						<caption>Rman백업관리 화면 리스트</caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30"><spring:message code="common.no" /></th>
									<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
									<th width="200" class="dt-center"><spring:message code="common.work_description" /></th>
									<th width="100"><spring:message code="backup_management.backup_option" /></th>
									<th width="230" class="dt-center"><spring:message code="backup_management.data_dir" /></th>
									<th width="230" class="dt-center"><spring:message code="backup_management.backup_dir" /></th>
									<%-- <th width="230" class="dt-center"><spring:message code="backup_management.backup_log_dir" /></th> --%>
									<th width="100"><spring:message code="common.register" /> </th>
									<th width="100"><spring:message code="common.regist_datetime" /></th>
									<th width="100"><spring:message code="common.modifier" /></th>
									<th width="100"><spring:message code="common.modify_datetime" /></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>	
				

	
					<table id="dumpDataTable" class="display" cellspacing="0" width="100%">
						<caption>Dump백업관리 화면 리스트</caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30"><spring:message code="common.no" /></th>
									<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
									<th width="200" class="dt-center" ><spring:message code="common.work_description" /></th>
									<th width="130"><spring:message code="common.database" /></th>
									<th width="250" class="dt-center"><spring:message code="backup_management.backup_dir" /></th>
									<th width="60"><spring:message code="backup_management.file_format" /></th>
									<th width="100"><spring:message code="backup_management.compressibility" /></th>
									<th width="100"><spring:message code="backup_management.incording_method" /></th>
									<th width="100"><spring:message code="backup_management.rolename" /></th>
									<th width="90"><spring:message code="backup_management.file_keep_day" /></th>
									<th width="150"><spring:message code="backup_management.backup_maintenance_count" /></th>
									<th width="70"><spring:message code="common.register" /></th>
									<th width="100"><spring:message code="common.regist_datetime" /></th>
									<th width="70"><spring:message code="common.modifier" /></th>
									<th width="100"><spring:message code="common.modify_datetime" /></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
				</form>				
			</div>
		</div>
	</div>
</div><!-- // contents -->

		</div><!-- // container -->
	</div>
