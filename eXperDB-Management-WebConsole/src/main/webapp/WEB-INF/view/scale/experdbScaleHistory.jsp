<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : experdbScaleHistory.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author
	* since
	*
	*/
%>
<style>
.scaleIng {  display:inline-block; margin:0 2px; height:20px; padding:0 12px; color:red; text-align:left; font-weight: bold; font-size:13px;}

table {border-spacing: 0}
table th, table td {padding: 0}
</style>

<script type="text/javascript">
	var tableExecute = null;
	var tableOccur = null;
	var clickExecute = false;
	var clickOccur = false;
	var tab = "executeHist";
	var tabGbn = "${tabGbn}";
	var searchInit = "";

	$(window.document).ready(function() {
		
		//작업기간 calender setting
		dateCalenderSetting();
		
		//테이블 setting
		fn_execute_init();
		fn_occur_init();
		
		//조회
		if(tabGbn != ""){
			selectTab(tabGbn);
		}else{
			selectTab("executeHist");
		}

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			if(tab == "executeHist"){
				fn_get_execute_list();
			}else{
				fn_get_occur_list();
			}
		});
		
	});

	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10);

		$("#wrk_strt_dtm").val(day_start);
		$("#wrk_end_dtm").val(day_end);
		
		$("#occur_strt_dtm").val(day_start);
		$("#occur_end_dtm").val(day_end);

		$( ".calendar" ).datepicker({
			dateFormat: 'yy-mm-dd',
			changeMonth : true,
			changeYear : true
	 	});
	}
	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(intab){
		tab = intab;
		if(intab == "executeHist"){
			$("#tab_occurHist").hide();
			$("#tab_executeHist").show();
			
			$("#logExecuteHistListDiv").show();
			$("#logOccurHistListDiv").hide();
			$(".search_execute").show();
			$(".search_occur").hide();
			
			seachParamInit(intab);

			if(clickExecute == false){
				fn_get_execute_list();
				clickExecute = true;
			}
		}else{	
			$("#tab_occurHist").show();
			$("#tab_executeHist").hide();
			
			$("#logExecuteHistListDiv").hide();
			$("#logOccurHistListDiv").show();
			
			$(".search_execute").hide();
			$(".search_occur").show();
			
			seachParamInit(intab);
			
			if(clickOccur == false){
				fn_get_occur_list();
				clickOccur = true;
			}
		}
	}
	
	/* ********************************************************
	 * 조회조건 초기화
	 ******************************************************** */
	function seachParamInit(tabGbn) {
		if (searchInit == tabGbn) {
			return;
		}
		
		if (tabGbn == "executeHist") {
			$("#policy_type_cd option:eq(0)").attr("selected","selected");
			$("#execute_type_cd option:eq(0)").attr("selected","selected");
		} else {
			$("#exe_rslt_cd option:eq(0)").attr("selected","selected");
			$("#wrk_type_Cd option:eq(0)").attr("selected","selected");
			$("#policy_type_cd").val("");
		}

		searchInit = tabGbn;
	}
	 
	
	/* ********************************************************
	 * 실행이력 테이블 setting
	 ******************************************************** */
	function fn_execute_init() {
		tableExecute = $('#scaleExecuteHistList').DataTable({	
			scrollY: "405px",
			scrollX : true,
			searching : false,	
			deferRender : true,
			bSort: false,
		    columns : [
			         	{ data: "rownum", className: "dt-center", defaultContent: ""},
			         	{data : "process_id", className : "dt-center", defaultContent : ""
							,render: function (data, type, full) {
								  return '<span onClick=javascript:fn_scaleHistLayer("'+full.process_id+'"); class="bold" title="'+full.process_id+'">' + full.process_id + '</span>';
							}
			         	},
			         	{data : "scale_type_nm", className : "dt-center", defaultContent : ""},
			         	{data : "wrk_type_nm", className : "dt-center", defaultContent : ""},
			         	{data : "auto_policy_nm", className : "dt-left", defaultContent : ""},
			         	{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},
			         	{data : "wrk_end_dtm", className : "dt-center", defaultContent : ""},
			         	{data : "wrk_id", 
		 					render: function (data, type, full){
								if(full.wrk_id == "1"){
									var html = '<span class="btn btnC_01 btnF_02"><img src="../images/spinner_loading.png" alt="" style="width:30%; margin-right:3px;" />' + '<spring:message code="restore.progress" /></span>';
									return html;
								}else{
									var html = '<span class="btn btnC_01 btnF_02"><spring:message code="eXperDB_scale.complete" /></span>';
									return html;
								}
								return data;
							},
							className : "dt-center",
							defaultContent : ""
			         	},
		 		   		{
		 					data : "exe_rslt_cd_nm",
		 					render : function(data, type, full, meta) {	 						
		 						var html = '';
		 						if (full.exe_rslt_cd == 'TC001701' && full.wrk_id == '2') {
		 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/><spring:message code="common.success" /></span>';
		 						} else if(full.exe_rslt_cd == 'TC001702' && full.wrk_id == '2') {
		 							html += '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.scale_wrk_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/><spring:message code="common.failed" /></button></span>';
		 						} else {
		 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/spinner_loading.png" alt="" style="width:30%; margin-right:3px;" /><spring:message code="etc.etc28"/></span>';
		 						}
		 						return html;
		 					},
		 					className : "dt-center",
		 					defaultContent : ""
		 				}
		 		        ]
		});
	   	
		tableExecute.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		tableExecute.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(2)').css('min-width', '80px');
		tableExecute.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		tableExecute.tables().header().to$().find('th:eq(4)').css('min-width', '220px');
		tableExecute.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(8)').css('min-width', '80px');

	   	$(window).trigger('resize');
	}
	
	/* ********************************************************
	 * 발생이력 Data Table initialization
	 ******************************************************** */
	function fn_occur_init(){
		tableOccur = $('#logOccurHistList').DataTable({	
			scrollY: "405px",	
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
						{ data: "rownum", className: "dt-center", defaultContent: ""},
			         	{data : "scale_type_nm", className : "dt-center", defaultContent : ""},
			         	{
			         		data : "execute_type_nm", 
		 					render : function(data, type, full, meta) {	 						
		 						var html = '';
		 						if (full.execute_type_cd == 'TC003401') {
		 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_1.png" alt=""  style="margin-right:3px;"/>' + full.execute_type_nm +'</span>';
		 						} else {
		 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_2.png" alt="" style="margin-right:3px;" />' + full.execute_type_nm +'</span>';
		 						}
		 						return html;
		 					},
			         		className : "dt-center", defaultContent : ""},
			         	{data : "policy_type_nm", className : "dt-center", defaultContent : ""},
			         	{data : "auto_policy_contents", className : "dt-left", defaultContent : ""},
			         	{data : "event_occur_contents", className : "dt-left", defaultContent : ""},
			         	{data : "event_occur_dtm", className : "dt-center", defaultContent : ""},
			]
		});

		tableOccur.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		tableOccur.tables().header().to$().find('th:eq(1)').css('min-width', '80px');
		tableOccur.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		tableOccur.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		tableOccur.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
	   	tableOccur.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
	   	tableOccur.tables().header().to$().find('th:eq(6)').css('min-width', '100px');

	   	$(window).trigger('resize');
	}

	/* ********************************************************
	 * calender valid 체크
	 ******************************************************** */
	function calenderValid() {
		var wrk_strt_dtm = $("#wrk_strt_dtm").val();
		var wrk_end_dtm = $("#wrk_end_dtm").val();

		if (wrk_strt_dtm != "" && wrk_end_dtm == "") {
			alert("<spring:message code='message.msg14' />");
			return false;
		}

		if (wrk_end_dtm != "" && wrk_strt_dtm == "") {
			alert("<spring:message code='message.msg15' />");
			return false;
		}
		
		return true;
	}
	
	/* ********************************************************
	 * Get 실행이력 List
	 ******************************************************** */
	function fn_get_execute_list(){
		if(!calenderValid()) {
			return;
		}
		
 		$.ajax({
			url : "/scale/selectScaleHistoryList.do",
			data : {
				hist_gbn : "execute_hist",
				db_svr_id : $("#db_svr_id").val(),
		  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
		  		wrk_end_dtm : $("#wrk_end_dtm").val(),
		  		exe_rslt_cd : $("#exe_rslt_cd").val(),
		  		scale_type_cd : $("#scale_type_cd").val(),
		  		wrk_type_Cd : $("#wrk_type_Cd").val(),
		  		process_id_set : $('#process_id_set').val(),
		  		fix_rsltcd : $("#fix_rsltcd").val()
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
			success : function(result) {
				tableExecute.rows({selected: true}).deselect();
				tableExecute.clear().draw();

				if (nvlSet(result) != '' && nvlSet(result) != '-') {
					tableExecute.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * Get 발생이력 Log List
	 ******************************************************** */
	function fn_get_occur_list(){
		if(!calenderValid()) {
			return;
		}

		$.ajax({
			url : "/scale/selectScaleHistoryList.do",
			data : {
				hist_gbn : "occur_hist",
				db_svr_id : $("#db_svr_id").val(),
		  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
		  		wrk_end_dtm : $("#wrk_end_dtm").val(),
		  		scale_type_cd : $("#scale_type_cd").val(),
		  		execute_type_cd : $("#execute_type_cd").val(),
		  		policy_type_cd : $("#policy_type_cd").val()
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
			success : function(result) {
				tableOccur.rows({selected: true}).deselect();
				tableOccur.clear().draw();

				if (nvlSet(result) != '' && nvlSet(result) != '-') {
					tableOccur.rows.add(result).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * null체크
	 ******************************************************** */
	function nvlSet(val) {
		var strValue = val;
		if( strValue == null || strValue == '') {
			strValue = "-";
		}
		
		return strValue;
	}
</script>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.eXperDB_scale_history" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.eXperDB_scale_history_01" /></li>
					<li><spring:message code="help.eXperDB_scale_history_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.eXperDB_scale" /></li>
					<li class="on"><spring:message code="menu.eXperDB_scale_history" /></li>
				</ul>
			</div>
		</div>
	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab_executeHist">
					<li class="atv"><a href="javascript:selectTab('executeHist');"><spring:message code="menu.scale_execute_hist" /></a></li>
					<li><a href="javascript:selectTab('occurHist');"><spring:message code="menu.scale_auto_occur_hist" /></a></li>
				</ul>
				<ul id="tab_occurHist" style="display:none">
					<li><a href="javascript:selectTab('executeHist');"><spring:message code="menu.scale_execute_hist" /></a></li>
					<li class="atv"><a href="javascript:selectTab('occurHist');"><spring:message code="menu.scale_auto_occur_hist" /></a></li>
				</ul>
			</div>
		
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button id="btnSelect" type="button"><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
					<form name="findList" id="findList" method="post">
						<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>

						<table class="write">
							<caption>검색 조회</caption>
							<colgroup>							
								<col style="width:110px;" />
								<col style="width:320px;" />
								<col style="width:110px;" />
								<col />
							</colgroup>
							<tbody>
								<!-- 싱행이력  -->
								<tr>
									<th scope="row" class="t10 search_execute"><spring:message code="common.work_term" /></th>
									<th scope="row" class="t10 search_occur"><spring:message code="eXperDB_scale.occur_term" /></th>
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
									<th scope="row" class="t9 search_execute"><spring:message code="common.status" /></th>
									<td class="search_execute">
										<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
											<option value=""><spring:message code="schedule.total" /></option>
											<option value="TC001701"><spring:message code="common.success" /></option>
											<option value="TC001702"><spring:message code="common.failed" /></option>
										</select>
									</td>
									
									<th scope="row" class="t9"><spring:message code="eXperDB_scale.scale_type" /></th>
									<td>
										<select name="scale_type_cd" id="scale_type_cd" class="select t5">
											<option value=""><spring:message code="schedule.total" /></option>
											<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
											<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
										</select>
									</td>
									<th scope="row" class="t9 search_occur"><spring:message code="eXperDB_scale.policy_type" /></th>
									<td class="search_occur">
										<select name="policy_type_cd" id="policy_type_cd" class="select t5">
											<option value=""><spring:message code="schedule.total" /></option>
											<c:forEach var="result" items="${policyTypeList}" varStatus="status">
												<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:forEach>
										</select>
									</td>
									
									
								</tr>
								<tr class="search_execute">
									<th scope="row" class="t9"><spring:message code="eXperDB_scale.process_id" /></th>
									<td>
										<input type="text" name="process_id_set" id="process_id_set" class="txt t5" maxlength="20"  />
									</td>
									<th scope="row" class="t9"><spring:message code="eXperDB_scale.wrk_type" /></th>
									<td>
										<select name="wrk_type_Cd" id="wrk_type_Cd" class="select t5">
											<option value=""><spring:message code="schedule.total" /></option>
											<c:forEach var="result" items="${wrkTypeList}" varStatus="status">
												<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:forEach>
										</select>
									</td>
								</tr>
								
								<tr class="search_occur">
									<th scope="row" class="t9"><spring:message code="eXperDB_scale.execute_type" /></th>
									<td colspan="3">
										<select name="execute_type_cd" id="execute_type_cd" class="select t5">
											<option value=""><spring:message code="schedule.total" /></option>
											<c:forEach var="result" items="${executeTypeList}" varStatus="status">
												<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:forEach>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>

				<div class="overflow_area" id="logExecuteHistListDiv">
					<table class="display" id="scaleExecuteHistList" style="width:100%;">
						<caption>Scale 실행이력 리스트</caption>
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="eXperDB_scale.process_id" /></th>
								<th width="80"><spring:message code="eXperDB_scale.scale_type" /></th>
								<th width="80"><spring:message code="eXperDB_scale.wrk_type" /></th>
								<th width="220"><spring:message code="eXperDB_scale.auto_policy_nm" /></th>
								<th width="100"><spring:message code="eXperDB_scale.work_start_time" /> </th>
								<th width="100"><spring:message code="eXperDB_scale.work_end_time" /></th>
								<th width="100"><spring:message code="eXperDB_scale.progress" /></th>
								<th width="80"><spring:message code="common.status" /></th>
							</tr>
						</thead>
					</table>
				</div>	
				
				<div class="overflow_area" id="logOccurHistListDiv">
					<table class="display" id="logOccurHistList" style="width:100%;">
						<caption>Scale Auto 발생이력</caption>
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="80"><spring:message code="eXperDB_scale.scale_type" /></th>
								<th width="100"><spring:message code="eXperDB_scale.execute_type" /></th>
								<th width="100"><spring:message code="eXperDB_scale.policy_type" /></th>
								<th width="200"><spring:message code="eXperDB_scale.auto_policy_nm"/></th>	
								<th width="200"><spring:message code="eXperDB_scale.occur_hist" /></th>	
								<th width="100"><spring:message code="eXperDB_scale.occur_time" /></th>
							</tr>
						</thead>
					</table>
				</div>
						
			</div>
		</div>
	</div>
</div><!-- // contents -->