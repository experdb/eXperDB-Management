<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : DB2pg 수행이력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2019.09.17     최초 생성
    *	
	* author 변승우
	* since 2019.09.17
	*
	*/
%>


<script type="text/javascript">

var table = null;

function fn_init(){
	
	table = $('#historyDataTable').DataTable({
		scrollY : "330px",
		scrollX: true,	
		bDestroy: true,
		paging : true,
		processing : true,
		searching : false,	
		deferRender : true,
		bSort: false,
	columns : [
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_exp", className : "dt-center", defaultContent : ""}, 
		{
			data : "source_dbms_dscd",
			className : "dt-center",
			render : function(data, type, full, meta) {
				var html = "";
				if (data == "TC002201") {
					html += "Oracle";
				}else if(data == "TC002202"){
					html += "MS-SQL";
				}else if(data == "TC002203"){
					html += "MySQL";
				}else if(data == "TC002204"){
					html += "PostgreSQL";
				}else if(data == "TC002205"){
					html += "DB2";
				}else if(data == "TC002206"){
					html += "SyBaseASE";
				}else if(data == "TC002207"){
					html += "CUBRID";
				}else if(data == "TC002208"){
					html += "Tibero";
				}
				return html;
			},
			defaultContent : ""
		},
		{data : "source_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "source_dtb_nm", className : "dt-center", defaultContent : ""}, 
		{data : "target_ipadr", className : "dt-center", defaultContent : ""}, 
		{data : "target_dtb_nm", className : "dt-center", defaultContent : ""},
		{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},
		{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
		{data : "wrk_dtm", className : "dt-center", defaultContent : ""},
		{
			data : "exe_rslt_nm",
			className : "dt-center",
			render : function(data, type, full, meta) {
				var html = "";
				if (data == "Success") {
					 html += "<span class='btn btnC_01 btnF_02'><button onclick='fn_log("+full.imd_exe_sn+","+full.trans_save_pth+")'><img src='../images/ico_state_02.png' style='margin-right:3px;'>Success</button></span>";
					
				} else {
					html += "<span class='btn btnC_01 btnF_02'><button onclick='fn_log("+full.imd_exe_sn+","+full.trans_save_pth+")'><img src='../images/ico_state_01.png' style='margin-right:3px;'>Fail</button></span>";
				}
				return html;
			},
			defaultContent : ""
		},
		{data : "db2pg_trsf_wrk_id", defaultContent : "", visible: false},
		{data : "wrk_id", defaultContent : "", visible: false},
		{data : "imd_exe_sn", defaultContent : "", visible: false},
		{data : "trans_save_pth", defaultContent : "", visible: false}
	]
	});

    table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
    table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
    table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');
    table.tables().header().to$().find('th:eq(9)').css('min-width', '130px');
    table.tables().header().to$().find('th:eq(10)').css('min-width', '95px');
    table.tables().header().to$().find('th:eq(11)').css('min-width', '95px');
    
	$(window).trigger('resize'); 
}


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(
		
	function() {	
		fn_init();
		
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);
		
		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10); 

		$("#wrk_strt_dtm").val(day_start);
		$("#wrk_end_dtm").val(day_end);
		
		$( ".calendar" ).datepicker({
			dateFormat: 'yy-mm-dd',
			changeMonth : true,
			changeYear : true
	 	});
		
		fn_search();
	}
);


/* ********************************************************
 * DB2PG 수행이력 데이터 가져오기
 ******************************************************** */
function fn_search(){
	$.ajax({
		url : "/db2pg/selectDb2pgHistory.do", 
	  	data : {
	  		wrk_nm :  $("#wrk_nm").val(),
	  		exe_rslt_cd : $("#exe_rslt_cd").val()
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
				table.rows({selected: true}).deselect();
	 			table.clear().draw();
	 			table.rows.add(data).draw();
			}else{
				table.clear().draw();
			}
		}
	});
}

/* ********************************************************
 * 에러 로그 팝업
 ******************************************************** */
 function fn_log(imd_exe_sn, trans_save_pth){
	
	alert(imd_exe_sn);
	alert(trans_save_pth);
	
	  var frmPop= document.frmPopup;
	  
		var width = 950;
		var height = 690;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	    var url = '/db2pg/popup/db2pgHistoryDetail.do';
	    window.open('','popupView',popOption);  
	     
	    frmPop.action = url;
	    frmPop.target = 'popupView';
	    frmPop.trans_save_pth.value = trans_save_pth;
	    frmPop.imd_exe_sn.value = imd_exe_sn;  
	    frmPop.submit();   
}
</script>

<form name="frmPopup">
	<input type="hidden" name="imd_exe_sn"  id="imd_exe_sn">
	<input type="hidden" name="trans_save_pth"  id="trans_save_pth">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>DB2PG 수행이력<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>DB2PG 수행이력 설명</li>
					<li></li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">DB2PG 수행이력</li>
					<li>DB2PG 수행이력</li>
				</ul>
			</div>
		</div>	
		<div class="contents">

			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button type="button" id="btnSelect" onclick="fn_search();"><spring:message code="common.search" /></button></span>					
				</div>
				
				<div class="sch_form">
				<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:110px;" />
							<col style="width:230px;" />
							<col style="width:110px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10"><spring:message code="common.work_term" /></th>
								<td colspan="3">
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_strt_dtm" id="wrk_strt_dtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_end_dtm" id="wrk_end_dtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr style="height:35px;">
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t5" maxlength="25"  /></td>
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</td>														
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table id="historyDataTable" class="display" cellspacing="0" width="100%">
						<caption></caption>
							<thead>
								<tr>
									<th width="30" rowspan="2"><spring:message code="common.no" /></th>
									<th width="100" rowspan="2">Work명</th>
									<th width="200" rowspan="2">Work설명</th>
									<th width="400" colspan="3">소스시스템</th>
									<th width="400" colspan="2">타겟시스템</th>
									<th width="130" rowspan="2">수행시작시간</th>
									<th width="130" rowspan="2">수행종료시간</th>
									<th width="95" rowspan="2">수행시간(초)</th>
									<th width="95" rowspan="2">수행결과</th>
								</tr>
								<tr>
									<th width="100">DBMS 구분</th>
									<th width="100">아이피</th>
									<th width="100">Database</th>
									<th width="100">아이피</th>
									<th width="100">Database</th>
								</tr>
							</thead>
					</table>
				</div>		
			</div>
		</div>
	</div>
</div><!-- // contents -->
