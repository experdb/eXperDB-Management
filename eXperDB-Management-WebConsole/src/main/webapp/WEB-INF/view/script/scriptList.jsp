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
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""},
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

	$(window).trigger('resize'); 
}


$(window.document).ready(
		function() {	
			fn_init();		
		}
);
	
	


function fn_script_reg_popup(){
	var popUrl = "/popup/scriptRegForm.do";
	//var popUrl = "/popup/scriptRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 669;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"scriptRegPop",popOption);
	winPop.focus();
}

</script>


<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스크립트 관리<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>스크립트설정 </li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>스크립트관리</li>
					<li class="on">스크립트설정></li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<a class="btn" onClick="fn_rman_find_list();"><button><spring:message code="common.search" /></button></a>
					<span class="btn" onclick="fn_script_reg_popup()"><button><spring:message code="common.registory" /></button></span>
					<span class="btn" onClick="fn_script_regreg_popup()"><button><spring:message code="common.modify" /></button></span>
					<span class="btn" onClick="fn_script_work_delete()"><button><spring:message code="common.delete" /></button></span>
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
								</tr>
							</thead>
					</table>
	
				</form>				
			</div>
		</div>
	</div>
</div><!-- // contents -->