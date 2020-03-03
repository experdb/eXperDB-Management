<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : sourceDBMS.jsp
	* @Description : sourceDBMS 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.09.17     최초 생성
	*
	* author 변승우 대리
	* since 2019.09.17
	*
	*/
%>

<script>
var table = null;

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#dbms').DataTable({	
		scrollY : "330px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "rownum",  className : "dt-center", defaultContent : ""},
		{data : "db2pg_sys_nm", className : "dt-center", defaultContent : ""},
		{data : "dbms_dscd_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "scm_nm", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
	    {data : "spr_usr_id", className : "dt-center", defaultContent : ""},
		{data : "crts_nm", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "db2pg_sys_id",  defaultContent : "", visible: false }
		]
	});
	
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');		
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');		
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
	    $(window).trigger('resize'); 
}



     

/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	
	fn_init();
	fn_search();
	
  	$(function() {	
  		$('#dbms tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
 
});

/* ********************************************************
 * DBMS 조회
 ******************************************************** */
 function fn_search(){
	
	 	$.ajax({
	  		url : "/selectDb2pgDBMS.do",
	  		data : {
	  		 	db2pg_sys_nm : $("#db2pg_sys_nm").val(),
	  			ipadr : $("#ipadr").val(),
	  		 	portno : $("#portno").val(),
	  		  	dtb_nm : $("#dtb_nm").val(),
	  		  	scm_nm : $("#scm_nm").val(),
	  		   	spr_usr_id : $("#spr_usr_id").val(),
	  		  	dbms_dscd : $("#dbms_dscd").val(),
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
				table.clear().draw();
				table.rows.add(result).draw();
	  		}
	  	});  
}

/* ********************************************************
 * DBMS 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	var popUrl = "/db2pg/popup/dbmsRegForm.do"; // 서버 url 팝업경로
	var width = 1000;
	var height = 520;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	window.open(popUrl,"",popOption);	
}


/* ********************************************************
 * DBMS 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	}else if (datas.length >1){
		alert('<spring:message code="message.msg38" />');
		return false;
	}
	
	var db2pg_sys_id = table.row('.selected').data().db2pg_sys_id;
	
	var popUrl = "/db2pg/popup/dbmsRegReForm.do?db2pg_sys_id="+db2pg_sys_id;
	var width = 1000;
	var height = 520;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"ddlRegRePop",popOption);
	winPop.focus();
}


</script>




<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>소스/타겟 DBMS 관리<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>Migration 소스/타겟 데이터베이스 서버를 신규로 등록하거나 이미 등록된 서버를 수정 또는 삭제합니다.</li>			
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Migration</li> 
					<li class="on"><spring:message code="migration.source/target_dbms_management"/></li>
				</ul>
			</div>
		</div>


		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
						<span class="btn" onClick="fn_search()" id="read_button"><button type="button"><spring:message code="common.search" /></button></span>
						<span class="btn" onclick="fn_reg_popup();" id="int_button"><button type="button"><spring:message code="common.registory" /></button></span>
						<span class="btn" onclick="fn_regRe_popup();" id="mdf_button"><button type="button"><spring:message code="common.modify" /></button></span>
						<span class="btn" onclick="fn_delete();" id="mdf_button"><button type="button"><spring:message code="common.delete" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>Source DBMS 조회</caption>
						<colgroup>
							<col style="width:10%;" />
							<col style="width:20%;" />
							<col style="width:10%;" />
							<col style="width:20%;" />
							<col style="width:10%;" />
							<col style="width:20%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">시스템명</th>
								<td><input type="text" class="txt t3" name="db2pg_sys_nm" id="db2pg_sys_nm" /></td>
								<th scope="row" class="t9">아이피</th>
								<td><input type="text" class="txt t3" name="ipadr" id="ipadr" /></td>
								<th scope="row" class="t9"><spring:message code="common.database" /></th>
								<td><input type="text" class="txt t3" name="dtb_nm" id="dtb_nm" /></td>
							</tr>
							<tr>
								<th scope="row" class="t9">DBMS<spring:message code="common.division" /></th>
								<td>
									<select name="dbms_dscd" id="dbms_dscd" class="select t5" >
										<option value=""><spring:message code="common.total" /></option>				
											<c:forEach var="result" items="${result}" varStatus="status">												 
 												<option value="<c:out value="${result.dbms_dscd}"/>" >
	 												<c:if test="${result.dbms_dscd == 'TC002201'}"> 	<c:out value="Oracle"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002202'}"> 	<c:out value="MS-SQL"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002203'}"> 	<c:out value="MySQL"/> </c:if>
	 												<c:if test="${result.dbms_dscd == 'TC002204'}"> 	<c:out value="PostgreSQL"/> </c:if>
 													<c:if test="${result.dbms_dscd == 'TC002205'}"> 	<c:out value="DB2"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002206'}"> 	<c:out value="SyBaseASE"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002207'}"> 	<c:out value="CUBRID"/> </c:if>
													<c:if test="${result.dbms_dscd == 'TC002208'}"> 	<c:out value="Tibero"/> </c:if>
 												</option>
 											</c:forEach>
									</select>								
								</td>
								<th scope="row" class="t9"><spring:message code="dbms_information.account" /></th>
								<td><input type="text" class="txt t3" name="spr_usr_id" id="spr_usr_id" /></td>
								<th scope="row" class="t9">Schema</th>
								<td><input type="text" class="txt t3" name="scm_nm" id="scm_nm" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="dbms" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="30"><spring:message code="common.no" /></th>
								<th width="130">시스템명</th>
								<th width="100">DBMS<spring:message code="common.division" /></th>
								<th width="130"><spring:message code="data_transfer.ip" /></th>
								<th width="100">Database</th>
								<th width="150">Schema</th>
								<th width="80"><spring:message code="data_transfer.port" /></th>
								<th width="100"><spring:message code="dbms_information.account" /></th>
								<th width="130"><spring:message code="migration.character_set"/></th>
								<th width="100"><spring:message code="common.register" /></th>
								<th width="100"><spring:message code="common.regist_datetime" /></th>
								<th width="100"><spring:message code="common.modifier" /></th>
								<th width="100"><spring:message code="common.modify_datetime" /></th>
								<th width="0"><spring:message code="common.modify_datetime" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
