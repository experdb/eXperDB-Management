<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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
		table = $('#sourceDBMS').DataTable({	
		scrollY : "245px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
	    {data : "", defaultContent : ""},
		{data : "", defaultContent : ""},
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""}
		]
	});
		

		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '70px');		
		table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');		
		table.tables().header().to$().find('th:eq(9)').css('min-width', '65px');  
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
	    $(window).trigger('resize'); 
}



     

/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	
	fn_init();
	
  	$(function() {	
  		$('#serverList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
 
});


/* ********************************************************
 * Source DBMS 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	var popUrl = "/db2pg/popup/dbmsRegForm.do"; // 서버 url 팝업경로
	var width = 1000;
	var height = 500;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	window.open(popUrl,"",popOption);	
	
// 	window.open("/popup/dbServerRegForm.do?flag=tree","dbServerRegPop","location=no,menubar=no,scrollbars=yes,status=no,width=1050,height=638");
}


</script>




<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>DBMS<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.dbms_management_01" /></li>
					<li><spring:message code="help.dbms_management_02" /></li>						
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>DB2PG</li>
					<li class="on"> DBMS</li>
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
							<col style="width: 100px;" />
							<col style="width: 250px;" />
							<col style="width: 100px;" />
							<col style="width: 250px;" />
							<col style="width: 100px;" />
							<col style="width: 250px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">시스템명</th>
								<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" /></td>
								<th scope="row" class="t9">아이피</th>
								<td><input type="text" class="txt" name="ipadr" id="ipadr" /></td>
								<th scope="row" class="t9"><spring:message code="common.database" /></th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
							</tr>
							<tr>
								<th scope="row" class="t9">DBMS구분</th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
								<th scope="row" class="t9">계정</th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
								<th scope="row" class="t9">스키마</th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="sourceDBMS" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="30"><spring:message code="common.no" /></th>
								<th width="130">시스템명</th>
								<th width="100">DBMS구분</th>
								<th width="130">아이피</th>
								<th width="70">Database</th>
								<th width="70">스키마</th>
								<th width="70">포트</th>
								<th width="70">계정</th>
								<th width="130">케릭터셋</th>
								<th width="65"><spring:message code="common.register" /></th>
								<th width="100"><spring:message code="common.regist_datetime" /></th>
								<th width="65"><spring:message code="common.modifier" /></th>
								<th width="100"><spring:message code="common.modify_datetime" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
