<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : dumpLogList.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.04.07     최초 생성
	*
	* author 변승우
	* since 2021.04.07
	*
	*/
%>
<script type="text/javascript">

	var tableDump = null;


	$(window.document).ready(function() {
		
		selectInitTab();

		//작업기간 calender setting
		dateCalenderSetting();
		fn_get_dump_list();

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			if(!calenderValid()) {
				return;
			}
			fn_get_dump_list();

		});
	});
	
	/* ********************************************************
	 * calender valid 체크
	 ******************************************************** */
	function calenderValid() {
		var wrk_strt_dtm = $("#wrk_strt_dtm").val();
		var wrk_end_dtm = $("#wrk_end_dtm").val();

		if (wrk_strt_dtm != "" && wrk_end_dtm == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}

		if (wrk_end_dtm != "" && wrk_strt_dtm == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}
		
		return true;
	}
	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectInitTab(){
		// selectChkTab = intab;

		$(".search_rman").hide();
		$(".search_dump").show();
		$("#logRmanListDiv").hide();
		$("#logDumpListDiv").show();

		seachParamInit();

		//테이블 setting
		fn_dump_init();
	}
	/* ********************************************************
	 * 조회조건 초기화
	 ******************************************************** */
	function seachParamInit() {
		$("#wrk_nm").val("");
		$("#exe_rslt_cd option:eq(0)").attr("selected","selected");
		$("#fix_rsltcd option:eq(0)").attr("selected","selected");
		$("#db_id option:eq(0)").attr("selected","selected");

	}

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

		if ($("#wrk_strt_dtm_div").length) {
			$('#wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_start = new Date(selected.date.valueOf());
		    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
		        $("#wrk_end_dtm_div").datepicker('setStartDate', day_start);
		        $("#wrk_end_dtm").datepicker('setStartDate', day_start);
			}); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_end = new Date(selected.date.valueOf());
		    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
		        $('#wrk_strt_dtm_div').datepicker('setEndDate', day_end);
		        $('#wrk_strt_dtm').datepicker('setEndDate', day_end);
			}); //값 셋팅
		}
		
		$("#wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#wrk_end_dtm").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	}	

	/* ********************************************************
	 * Rman Data Table initialization
	 ******************************************************** */
	function fn_rman_init(){
		tableRman = $('#logRmanList').DataTable({
			scrollY: "300px",
			scrollX : true,
			searching : false,
			deferRender : true,
			bSort: false,
			columns : [
						{data: "rownum", className: "dt-center", defaultContent: ""}, 
						{data : "wrk_nm", className : "dt-left", defaultContent : ""
							,"render": function (data, type, full) {				
								return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" data-toggle="modal" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
							}
						},
						{data: "ipadr", className: "dt-center", defaultContent: ""},
						{data : "wrk_exp",
							render : function(data, type, full, meta) {
								var html = '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
								return html;
							},
							defaultContent : ""
						},
						{data: "bck_opt_cd_nm", className: "dt-center", defaultContent: "",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.bck_opt_cd == 'TC000301') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-paste mr-2 text-success'></i>";
									html += '<spring:message code="backup_management.full_backup" />';
									html += "</div>";									
								} else if(full.bck_opt_cd == 'TC000302'){
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-comments-o text-warning'></i>";
									html += '&nbsp;<spring:message code="backup_management.incremental_backup" />';
									html += "</button>";
								} else {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-exchange mr-2 text-info' ></i>";
									html += '<spring:message code="backup_management.change_log_backup" />';
									html += "</div>";
								}
/* 								
								html += "<div class='row' style='width:150px;'><div class='col-8'>";
 */
								return html;
							},

						},
						{data : "bck_file_pth", className : "dt-left", defaultContent : ""
							,"render": function (data, type, full) {
								return '<span onClick=javascript:fn_rmanShow("'+full.bck_file_pth+'","'+full.db_svr_id+'"); data-toggle="modal" title="'+full.bck_file_pth+'" class="bold">' + full.bck_file_pth + '</span>';
							}
						},
						{data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
						{data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
						{data: "wrk_dtm", 
							render : function(data, type, full, meta) {
								var html = "<div class='badge badge-pill badge-primary'>";
								html += "	<i class='mdi mdi-timer mr-2'></i>";
								html += full.wrk_dtm;
								html += "</div>";	

								return html;
							},
							className: "dt-center", defaultContent: ""}, 
						{data : "exe_rslt_cd_nm",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.exe_rslt_cd == 'TC001701') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-check-circle text-primary' >";
									html += '&nbsp;<spring:message code="common.success" /></i>';
									html += "</div>";
									
								} else if(full.exe_rslt_cd == 'TC001702'){
 									html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_failLog('+full.exe_sn+')">';
									html += '<i class="fa fa-times"></i>';
									html += '<spring:message code="common.failed" />';
									html += "</button>";
								} else {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
									html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
									html += '&nbsp;<spring:message code="etc.etc28" />';
									html += "</div>";
								}

								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},
						{
							data : "fix_rsltcd",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.fix_rsltcd == 'TC002001') {
	 								html += '<button type="button" class="btn btn-primary btn-icon-text" onclick="javascript:fn_fixLog('+full.exe_sn+', \'rmanList\');">';
	 								html += '<i class="fa fa-lightbulb-o btn-icon-prepend"></i>';
	 								html += '<spring:message code="etc.etc29"/>';
	 								html += "</button>";
								} else if(full.fix_rsltcd == 'TC002002'){
	 								html += '<button type="button" class="btn btn-danger btn-icon-text" onclick="javascript:fn_fixLog('+full.exe_sn+', \'rmanList\');">';
	 								html += '<i class="fa fa-times btn-icon-prepend"></i>';
	 								html += '<spring:message code="etc.etc30"/>';
	 								html += "</button>";
								} else {
									if(full.exe_rslt_cd == 'TC001701'){
										html += ' - ';
									}else{
		 								html += '<button type="button" class="btn btn-success btn-icon-text" onclick="javascript:fn_fix_rslt_reg('+full.exe_sn+', \'rmanList\');">';
		 								html += '<i class="ti-pencil-alt btn-icon-prepend"></i>';
		 								html += '<spring:message code="backup_management.Enter_Action"/>';
		 								html += "</button>";
									}
								}

								return html;
							},
							defaultContent : ""
						}
			]
		});

		tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
		tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '90px');
		tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '230px');
		tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '70px');
		tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '100px');

		$(window).trigger('resize'); 
	}

	/* ********************************************************
	 * Dump Data Table initialization
	 ******************************************************** */
	function fn_dump_init(){
		tableDump = $('#logDumpList').DataTable({
			scrollY: "300px",	
			scrollX: true,
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
						{data: "rownum", className: "dt-center", defaultContent: ""},
						{data : "wrk_nm", defaultContent : ""
							,"render": function (data, type, full) {				
								return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" data-toggle="modal" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
							}
						}, 
						{data: "ipadr", className: "dt-center", defaultContent: ""},
						{data : "wrk_exp",
							render : function(data, type, full, meta) {
							var html = '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
							return html;
							},
							defaultContent : ""
						},
						{data: "db_nm", defaultContent: ""}, 
						{data : "file_sz", defaultContent : ""
							,"render": function (data, type, full) {
								var html = "";
								
								if(full.file_sz != 0){
									var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
									var e = Math.floor(Math.log(full.file_sz) / Math.log(1024));

									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='ti-files text-primary' >";
									html += '&nbsp;' + (full.file_sz / Math.pow(1024, e)).toFixed(2) + " " + s[e] + '</i>';
									html += "</div>";
								}else{
									html += full.file_sz;
								}
								
								return html;
							}
						},
						{data : "bck_file_pth", defaultContent : ""
							,"render": function (data, type, full) {
								return '<span onClick=javascript:fn_dumpShow("'+full.bck_file_pth+'","'+full.db_svr_id+'"); data-toggle="modal" title="'+full.bck_file_pth+'" class="bold">' + full.bck_file_pth + '</span>';
							}
						},
						{data: "bck_filenm", defaultContent: ""},
						{data: "wrk_strt_dtm", defaultContent: ""}, 
						{data: "wrk_end_dtm", defaultContent: ""},
						{data: "wrk_dtm", 
							render : function(data, type, full, meta) {
								var html = "<div class='badge badge-pill badge-primary'>";
								html += "	<i class='mdi mdi-timer mr-2'></i>";
								html += full.wrk_dtm;
								html += "</div>";	

								return html;
							},
							defaultContent: ""},
						{data : "exe_rslt_cd",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.exe_rslt_cd == 'TC001701') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-check-circle text-primary' >";
									html += '&nbsp;<spring:message code="common.success" /></i>';
									html += "</div>";
									
								} else if(full.exe_rslt_cd == 'TC001702'){
 									html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_failLog('+full.exe_sn+')">';
									html += '<i class="fa fa-times"></i>';
									html += '<spring:message code="common.failed" />';
									html += "</button>";
								} else {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
									html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
									html += '&nbsp;<spring:message code="etc.etc28" />';
									html += "</div>";
								}
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},
						{data : "fix_rsltcd",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.fix_rsltcd == 'TC002001') {
	 								html += '<button type="button" class="btn btn-primary btn-icon-text" onclick="javascript:fn_fixLog('+full.exe_sn+', \'dumpList\');">';
	 								html += '<i class="fa fa-lightbulb-o btn-icon-prepend"></i>';
	 								html += '<spring:message code="etc.etc29"/>';
	 								html += "</button>";
								} else if(full.fix_rsltcd == 'TC002002'){
	 								html += '<button type="button" class="btn btn-danger btn-icon-text" onclick="javascript:fn_fixLog('+full.exe_sn+', \'dumpList\');">';
	 								html += '<i class="fa fa-times btn-icon-prepend"></i>';
	 								html += '<spring:message code="etc.etc30"/>';
	 								html += "</button>";
								} else {
									if(full.exe_rslt_cd == 'TC001701'){
										html += ' - ';
									}else{
		 								html += '<button type="button" class="btn btn-success btn-icon-text" onclick="javascript:fn_fix_rslt_reg('+full.exe_sn+', \'dumpList\');">';
		 								html += '<i class="ti-pencil-alt btn-icon-prepend"></i>';
		 								html += '<spring:message code="backup_management.Enter_Action"/>';
		 								html += "</button>";
									}
								}
								return html;
							},
							defaultContent : ""
						}
			]
		});

		tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
		tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '170px');
		tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
		tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		tableDump.tables().header().to$().find('th:eq(12)').css('min-width', '100px');

	   	$(window).trigger('resize');
	}

	/* ********************************************************
	 * Get Dump Log List
	 ******************************************************** */
	function fn_get_dump_list(){
		if(!calenderValid()) {
			return;
		}
		
		var db_id = $("#db_id").val();
		if(db_id == "") db_id = 0;
		
		$.ajax({
			url : "/backup/selectWorkLogList.do",
			data : {
				hist_gbn : "dump_hist",
				db_svr_id : $("#db_svr_id", "#findList").val(),
				bck_bsn_dscd : "TC000202",
				db_id : db_id,
		  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
		  		wrk_end_dtm : $("#wrk_end_dtm").val(),
		  		exe_rslt_cd : $("#exe_rslt_cd").val(),
				wrk_nm : nvlPrmSet($('#wrk_nm').val(), ""),
				fix_rsltcd : $("#fix_rsltcd").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		    },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				tableDump.rows({selected: true}).deselect();
				tableDump.clear().draw();

				if (nvlPrmSet(result, "") != '') {
					tableDump.rows.add(result).draw();
				}
			}
		});
	}
</script>

<%@include file="../cmmn/fixRsltMsgInfo.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>
<%@include file="../popup/dumpShow.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
</form>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-history"></i>
												<span class="menu-title"><spring:message code="menu.backup_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.backup_history_01"/></p>
											<p class="mb-0"><spring:message code="help.backup_history_02"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">

					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">

							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2  col-sm-3_0 row">
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="wrk_strt_dtm" name="wrk_strt_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
												
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="wrk_end_dtm" name="wrk_end_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-left: -0.7rem;margin-right: -0.7rem;" name="exe_rslt_cd" id="exe_rslt_cd">
										<option value=""><spring:message code="common.status" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</div>
								<div class="input-group mb-2 mr-sm-2 search_dump col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="db_id" id="db_id">
										<option value=""><spring:message code="common.database" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
												<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="25" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="message.msg107" />' />
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="fix_rsltcd" id="fix_rsltcd">
										<option value=""><spring:message code="etc.etc31" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="TC002003"><spring:message code="etc.etc34"/></option>
										<option value="TC002001"><spring:message code="etc.etc29"/></option>
										<option value="TC002002"><spring:message code="etc.etc30"/></option>
									</select>
								</div>
									
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSelect">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12" id="logDumpListDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

	 								<table id="logDumpList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="150"><spring:message code="common.work_name" /></th>
												<th width="100"><spring:message code="dbms_information.dbms_ip" /></th>
												<th width="150"><spring:message code="common.work_description" /></th>
												<th width="100"><spring:message code="common.database" /></th>
												<th width="100"><spring:message code="backup_management.size" /></th>
												<th width="170"><spring:message code="etc.etc08"/></th>			
												<th width="170"><spring:message code="backup_management.fileName"/></th>
												<th width="100"><spring:message code="backup_management.work_start_time" /></th>
												<th width="100"><spring:message code="backup_management.work_end_time" /></th>
												<th width="100"><spring:message code="backup_management.elapsed_time" /></th>
												<th width="100"><spring:message code="common.status" /></th>
												<th width="100"><spring:message code="etc.etc31"/></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>
