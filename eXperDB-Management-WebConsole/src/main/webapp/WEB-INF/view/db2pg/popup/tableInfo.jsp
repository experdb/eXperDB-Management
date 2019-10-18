<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
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
var tableList = ${tableList};
var tableGbn = "${tableGbn}";

function fn_init() {
		table = $('#tableList').DataTable({
		scrollY : "300px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "table_name", className : "dt-center", defaultContent : ""},
		{data : "obj_description", className : "dt-center", defaultContent : ""}		
		],'select': {'style': 'multi'}
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');

		
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_search();
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
		url : "/selectTableList.do",
		data : {
 		 	ipadr : $("#ipadr").val(),
 		 	portno : $("#portno").val(),
 		  	dtb_nm : $("#dtb_nm").val(),
 		   	spr_usr_id : $("#spr_usr_id").val(),
 		   	pwd : $("#pwd").val(),
 		  	dbms_dscd : $("#dbms_dscd").val(),
 		  	table_nm : $("#table_nm").val(),
 		  	scm_nm : $("#scm_nm").val()
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
			table.rows.add(result.RESULT_DATA).draw();
			
			if(tableList != ""){
				fn_tableCheckSelect(tableList);
			}
		}
	});
}


/* ********************************************************
 * 등록
 ******************************************************** */
function fn_Add(){
	
	var datas = table.rows('.selected').data();
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].table_name);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
	opener.fn_tableAddCallback(rowList, tableGbn);
	self.close();
}


function fn_tableCheckSelect(tableList){
	var datas = table.rows().data();
	
	 for (var i = 0; i < datas.length; i++) {
			for(var j=0; j <tableList.length; j++ ){
				if(table.rows().data()[i].table_name == tableList[j]){
					$('input', table.rows(i).nodes()).prop('checked', true); 
					table.rows(i).nodes().to$().addClass('selected');	
				}
			}		  
	  }	
	 
}
</script>

</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">테이블정보</p>
			<div class="btn_type_01">
				<span class="btn"><button onClick="fn_search();" type="button"><spring:message code="common.search" /></button></span>
			</div>
		<div class="pop_cmm">							
			<table class="write bdtype1">
				<caption><spring:message code="menu.schedule_registration" /></caption>				
				<colgroup>
					<col style="width:30%;" />
					<col style="width:70%;" />
					<col style="width:30%;" />
					<col style="width:70%;" />
					</col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">시스템명</th>
						<td><input type="text" class="txt t9" name="db2pg_sys_nm" id="db2pg_sys_nm" value="${dbmsInfo[0].db2pg_sys_nm}" readonly/></td>										
						<th scope="row" class="ico_t1" >아이피</th>
						<td><input type="text" class="txt t9" name="ipadr" id="ipadr" value="${dbmsInfo[0].ipadr}" readonly/></td>				
					</tr>
					<tr>
						<th scope="row" class="ico_t1" >스키마명</th>
						<td><input type="text" class="txt t9" name="scm_nm" id="scm_nm" value="${dbmsInfo[0].scm_nm}" readonly/></td>			
						<%-- <th scope="row" class="ico_t1">권한스키마명</th>
						<td><select class="select t8" name="scm_nm" id="scm_nm" value=""/>
								<option value="%"><spring:message code="common.choice" /></option>
						</select></td>	 --%>									
						<th scope="row" class="ico_t1" >테이블명</th>
						<td>
						<input type="text" class="txt t9" name="table_nm" id="table_nm" />
						<input type="hidden" class="txt t4" name="dbms_dscd" id="dbms_dscd"  value="${dbmsInfo[0].dbms_dscd}"/>
						<input type="hidden" class="txt t4" name="dtb_nm" id="dtb_nm" value="${dbmsInfo[0].dtb_nm}"/>
						<input type="hidden" class="txt t4" name="spr_usr_id" id="spr_usr_id" value="${dbmsInfo[0].spr_usr_id}"/>
						<input type="hidden" class="txt t4" name="pwd" id="pwd" value="${dbmsInfo[0].pwd}"/>
						<input type="hidden" class="txt t4" name="portno" id="portno" value="${dbmsInfo[0].portno}"/>	
						</td>				
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pop_cmm3">
			<p class="pop_s_tit">테이블 리스트</p>
			<div class="overflow_area">
				<table id="tableList" class="display" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th width="30"></th>
						<th width="100" class="dt-center">테이블명</th>
						<th width="100" class="dt-center">COMMENT</th>
					</tr>
				</thead>
			</table>		
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onClick="fn_Add();" type="button">선택</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>닫기</span></a>
		</div>
	</div>
</div>
</body>
</html>