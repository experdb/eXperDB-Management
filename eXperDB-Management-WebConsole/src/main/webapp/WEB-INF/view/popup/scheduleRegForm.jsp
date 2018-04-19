<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>


<script>
var table = null;
function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#workList').DataTable({
		scrollY : "245px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
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
		{data : "bsn_dscd_nm",  defaultContent : ""},
		{data : "bck_bsn_dscd_nm",  defaultContent : ""},
		{data : "db_svr_nm",  defaultContent : ""},		
		{data : "frst_regr_id",  defaultContent : ""},
		{data : "frst_reg_dtm",  defaultContent : ""},		
		{data : "wrk_id",  defaultContent : "", visible: false },
		{data : "db_svr_id",  defaultContent : "", visible: false},		
		{data : "db_id",  defaultContent : "", visible: false},
		{data : "db_nm",  defaultContent : "", visible: false},
		{data : "bsn_dscd",  defaultContent : "", visible: false},		
		{data : "bck_bsn_dscd",  defaultContent : "", visible: false},	
		{data : "bck_opt_cd",  defaultContent : "", visible: false},
		{data : "bck_opt_cd_nm",  defaultContent : "", visible: false},
		{data : "bck_mtn_ecnt",  defaultContent : "", visible: false},
		{data : "log_file_bck_yn",  defaultContent : "", visible: false},
		{data : "log_file_stg_dcnt",  defaultContent : "", visible: false},
		{data : "log_file_mtn_ecnt",  defaultContent : "", visible: false},
		{data : "cprt",  defaultContent : "", visible: false},
		{data : "save_pth",  defaultContent : "", visible: false},
		{data : "file_fmt_cd",  defaultContent : "", visible: false},
		{data : "file_stg_dcnt",  defaultContent : "", visible: false},
		{data : "encd_mth_nm",  defaultContent : "", visible: false},
		{data : "usr_role_nm",  defaultContent : "", visible: false},	
		{data : "lst_mdfr_id",  defaultContent : "", visible: false},
		{data : "lst_mdf_dtm",  defaultContent : "", visible: false}
		],'select': {'style': 'multi'}
	});
		
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '35px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');  
		table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');  
		table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(17)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(18)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(19)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(20)').css('min-width', '0px');  
		table.tables().header().to$().find('th:eq(21)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(22)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(23)').css('min-width', '0px');  
		table.tables().header().to$().find('th:eq(24)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(25)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(26)').css('min-width', '0px');  
		table.tables().header().to$().find('th:eq(27)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(28)').css('min-width', '0px');
		
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	
	fn_init();
	
	 /* ********************************************************
	  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
	  ******************************************************** */
	  	$.ajax({
			url : "/selectSvrList.do",
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
				$("#db_svr_nm").children().remove();
				$("#db_svr_nm").append("<option value='%'><spring:message code='common.choice' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	 
	 
		 /* ********************************************************
		  * 페이지 시작시, work 구분
		  ******************************************************** */
		  	$.ajax({
				url : "/selectWorkDivList.do",
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
					$("#work").children().remove();
					$("#work").append("<option value='%'><spring:message code="common.total" /></option>");
					if(result.length > 0){
						for(var i=0; i<result.length; i++){
							$("#work").append("<option value='"+result[i].bsn_dscd+"'>"+result[i].bsn_dscd_nm+"</option>");	
						}									
					}
				}
			}); 
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search(){
	if($("#db_svr_nm").val() == "%"){
		alert('<spring:message code="message.msg152"/>');
		return false;
	}

	$.ajax({
		url : "/selectWorkList.do",
		data : {
			bsn_dscd : $("#work").val(),
			db_svr_nm : $("#db_svr_nm").val(),
			wrk_nm : $("#wrk_nm").val()
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


/* ********************************************************
 * work 등록
 ******************************************************** */
function fn_workAdd(){
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].wrk_id);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
	opener.fn_workAddCallback(JSON.stringify(rowList));
	self.close();
}
</script>

</head>
<body>
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit"><spring:message code="schedule.workReg"/></p>
			<div class="btn_type_01">
				<span class="btn"><button onClick="fn_search();"><spring:message code="common.search" /></button></span>
			</div>
		<div class="pop_cmm">							
			<table class="write bdtype1">
				<caption><spring:message code="menu.schedule_registration" /></caption>				
				<colgroup>
					<col style="width:30px;" />
					<col style="width:50px;" />
					<col style="width:30px;" />
					<col style="width:50px;" />
					<col style="width:30px;" />
					<col style="width:100px;" />			
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.dbms_name" /></th>
						<td>
						<select class="select t8" name="db_svr_nm" id="db_svr_nm" style="width: 170px;">
								<option value="%"><spring:message code="schedule.total" /></option>
						</select>	
						<th scope="row" class="ico_t1"><spring:message code="common.division" /></th>
						<td>
						<select class="select t8" name="work" id="work">
								<option value="%"><spring:message code="common.choice" /></option>
						</select>						
						</td>									
						<th scope="row" class="ico_t1" style="magin-left:50px;" ><spring:message code="common.work_name" /></th>
						<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" /></td>				
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pop_cmm3">
			<p class="pop_s_tit"><spring:message code="schedule.workList"/></p>
			<div class="overflow_area">
				<table id="workList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th width="10"></th>
						<th width="35"><spring:message code="common.no" /></th>
						<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
						<th width="300" class="dt-center"><spring:message code="common.work_description" /></th>
						<th width="70"><spring:message code="common.division" /></th>
						<th width="100"><spring:message code="backup_management.bck_div"/></th>
						<th width="150"><spring:message code="common.dbms_name" /></th>
						<th width="100"><spring:message code="common.register" /></th>
						<th width="100"><spring:message code="common.regist_datetime" /></th>						
						<th width="0"></th>
						<th width="0"></th>						
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
						<th width="0"></th>
					</tr>
				</thead>
			</table>		
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onClick="fn_workAdd();"><spring:message code="common.add" /></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>