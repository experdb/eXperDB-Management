<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : scriptList.jsp
	* @Description : 스크립트목록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2018.06.08     최초 생성
    *	
	* author 변승우
	* since 2018.06.08
	*
	*/
%>
<script type="text/javascript">
var table = null;

function fn_init(){
		
	/* ********************************************************
	 * 스크립트설정 리스트
	 ******************************************************** */
	table = $('#scriptTable').DataTable({
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
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""},
		{data : "wrk_id", defaultContent : "", visible: false }
	],'select': {'style': 'multi'}
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');  
	table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
	$(window).trigger('resize'); 
}


$(window.document).ready(
		function() {	
			fn_init();					
			fn_search();
		}
);
	
	


function fn_search(){
	$.ajax({
		url : "/selectScriptList.do", 
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		wrk_nm : $("#wrk_nm").val()
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
			table.clear().draw();
			table.rows.add(data).draw();
		}
	});
}




function fn_reg_popup(){
	//var popUrl = "/popup/scriptRegForm.do";
	var popUrl = "/popup/scriptRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 669;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"scriptRegPop",popOption);
	winPop.focus();
}


function fn_rereg_popup(){
	var datas = table.rows('.selected').data();
	var wrk_id = table.row('.selected').data().wrk_id;
	
	if (datas.length <= 0) {
		alert("<spring:message code='message.msg35' />");
		return false;
	}else if(datas.length > 1){
		alert("<spring:message code='message.msg04' />");
		return false;
	}else{	
		var popUrl = "/popup/scriptReregForm.do?db_svr_id=${db_svr_id}&wrk_id="+wrk_id;
		var width = 954;
		var height = 669;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"scriptReregPop",popOption);
		winPop.focus();
	}
}


function fn_delete(){
	var datas = table.rows('.selected').data();
	var wrk_id = table.row('.selected').data().wrk_id;
	
	if (datas.length <= 0) {
		alert("<spring:message code='message.msg35' />");
		return false;
	}else if(datas.length > 1){
		alert("<spring:message code='message.msg04' />");
		return false;
	}else{	
		 if(confirm('<spring:message code="message.msg162"/>')){
				$.ajax({
					url : "/deleteScript.do", 
				  	data : {
				  		wrk_id : wrk_id
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
						alert('<spring:message code="message.msg60" />');
						location.reload();
					}
				});
		 }
	}
}
</script>

<%@include file="../cmmn/workScriptInfo.jsp"%>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.script_settings" /><a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.script_settings_01" /></li>
					<li><spring:message code="help.script_settings_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.script_management" /></li>
					<li class="on"><spring:message code="menu.script_settings" /></li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<a class="btn" onClick="fn_search();"><button><spring:message code="common.search" /></button></a>
					<span class="btn" onclick="fn_reg_popup()"><button><spring:message code="common.registory" /></button></span>
					<span class="btn" onClick="fn_rereg_popup()"><button><spring:message code="common.modify" /></button></span>
					<span class="btn" onClick="fn_delete()"><button><spring:message code="common.delete" /></button></span>
				</div>	
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" class="txt t3" name="wrk_nm" id="wrk_nm" maxlength="25"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">	
					<table id="scriptTable" class="display" cellspacing="0" width="100%">
						<caption>스크립트 화면 리스트</caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30"><spring:message code="common.no" /></th>
									<th width="100"><spring:message code="common.work_name" /></th>
									<th width="300"><spring:message code="common.work_description" /></th>
									<th width="100"><spring:message code="common.register" /></th>
									<th width="100"><spring:message code="common.regist_datetime" /></th>
									<th width="100"><spring:message code="common.modifier" /></th>
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