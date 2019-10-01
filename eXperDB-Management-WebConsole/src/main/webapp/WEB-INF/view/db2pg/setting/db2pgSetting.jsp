<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
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

/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){
	if(tab == "dump"){
		getddlDataList();
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
		getdataDataList();
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
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}
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
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "idx", className : "dt-center", defaultContent : ""}
	],'select': {'style': 'multi'}
	});
	
	tableDDL.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	tableDDL.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableDDL.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableDDL.tables().header().to$().find('th:eq(11)').css('min-width', '100px');



	tableData.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    tableData.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
    tableData.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
    tableData.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
    
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
	
}
/* ********************************************************
 * 데이터이행 데이터 가져오기
 ******************************************************** */
function getdataDataList(){
	
}

/* ********************************************************
 * DDL추출 등록 팝업
 ******************************************************** */
function fn_ddl_reg_popup(){
	var popUrl = "/db2pg/popup/ddlRegForm.do";
	var width = 965;
	var height = 820;
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
	var popUrl = "/db2pg/popup/ddlRegReForm.do";
	var width = 965;
	var height = 820;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"ddlRegRePop",popOption);
	winPop.focus();
}

/* ********************************************************
 * 데이터이행 등록 팝업
 ******************************************************** */
function fn_data_reg_popup(){
	var popUrl = "/db2pg/popup/dataRegForm.do";
	var width = 965;
	var height = 820;
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
	var popUrl = "/db2pg/popup/dataRegReForm.do";
	var width = 965;
	var height = 820;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dataRegRePop",popOption);
	winPop.focus();
}

/* ********************************************************
 * DDL추출 Data Delete
 ******************************************************** */
function fn_ddl_work_delete(){
	var datas = tableDDL.rows('.selected').data();
	if(datas.length < 1){
		alert("<spring:message code='message.msg16' />");
		return false;
	}
	
	var bck_wrk_id_List = [];
	var wrk_id_List = [];
    for (var i = 0; i < datas.length; i++) {
    	bck_wrk_id_List.push( tableDDL.rows('.selected').data()[i].bck_wrk_id);   
    	wrk_id_List.push( tableDDL.rows('.selected').data()[i].wrk_id);   
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

/* ********************************************************
 * 복제
 ******************************************************** */
function fn_copy(){
	toggleLayer($('#pop_layer_copy'), 'on');
}

</script>
<%@include file="../popup/db2pgConfigInfo.jsp"%>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>DB2PG<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>DB2PG 설명</li>
					<li></li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">DB2PG</li>
					<li>DB2PG 설정</li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('rman')">DDL추출</a></li>
					<li><a href="javascript:selectTab('dump')">데이터이행</a></li>
				</ul>
				<ul id="tab2" style="display:none;">
					<li><a href="javascript:selectTab('rman')">DDL추출</a></li>
					<li class="atv"><a href="javascript:selectTab('dump')">데이터이행</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_float">
					<span class="btn btnC_01 btn_fl"><button type="button" id="btnExcel" onclick="fn_copy()">복제</button></span> 														
					<div class="btn_type_01" id="btnDDL">
						<a class="btn" onClick="fn_rman_find_list();"><button type="button"><spring:message code="common.search" /></button></a>
						<span class="btn" onclick="fn_ddl_reg_popup()"><button type="button"><spring:message code="common.registory" /></button></span>
						<span class="btn" onClick="fn_ddl_regre_popup()"><button type="button"><spring:message code="common.modify" /></button></span>
						<span class="btn" onClick="fn_rman_work_delete()"><button type="button"><spring:message code="common.delete" /></button></span>
					</div>
					<div class="btn_type_01" id="btnData" style="display:none;">
						<span class="btn" onclick="fn_dump_find_list()"><button type="button"><spring:message code="common.search" /></button></span>
						<span class="btn" onclick="fn_data_reg_popup()"><button type="button"><spring:message code="common.registory" /></button></span>
						<span class="btn" onclick="fn_data_regre_popup()"><button type="button"><spring:message code="common.modify" /></button></span>
						<span class="btn" onclick="fn_dump_work_delete()"><button type="button"><spring:message code="common.delete" /></button></span>
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
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">DBMS구분</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
							</tr>
							<tr>
								<th scope="row" class="t9">호스트명</th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">Database</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">스키마</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
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
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">DBMS구분</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
							</tr>
							<tr>
								<th scope="row" class="t9">호스트명</th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">Database</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
								<th scope="row" class="t9">스키마</th>
								<td><input type="text" name="dbnms_nm" id="dbnms_nm" class="txt t3" maxlength="25"/></td>
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
									<th width="100">Work설명</th>
									<th width="100">DBMS 구분</th>
									<th width="100">호스트명</th>
									<th width="100">Database</th>
									<th width="100">스키마</th>
									<th width="100">등록자</th>
									<th width="100">등록일시</th>
									<th width="100">수정자</th>
									<th width="100">수정일시</th>
								</tr>
							</thead>
						</table>	
					<table id="dataDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="100"><spring:message code="common.no" /></th>
									<th width="100">Work명</th>
									<th width="100">Work설명</th>
									<th width="100">DBMS 구분</th>
									<th width="100">호스트명</th>
									<th width="100">Database</th>
									<th width="100">스키마</th>
									<th width="100">등록자</th>
									<th width="100">등록일시</th>
									<th width="100">수정자</th>
									<th width="100">수정일시</th>
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
			<div class="pop_cts" style="width: 50%; height: 300px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="workinfo">
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
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_copy'), 'off');"><span>저장</span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_copy'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>		
			</div>
		</div><!-- //pop-container -->
	</div>