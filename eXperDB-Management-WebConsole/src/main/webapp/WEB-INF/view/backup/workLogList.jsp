<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : workLogList.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>
<script type="text/javascript">

	var selectChkTab = "rman";
	var searchInit = "";
	var tableRman = null;
	var tableDump = null;
	var tableBackrest = null;
	var tabGbn = "${tabGbn}";
	var pgbackrest = "${pgbackrest}"
	var interval = null;

	$(window.document).ready(function() {
		//검색조건 초기화
		if (tabGbn != null) {
			selectChkTab = tabGbn;
		}/* else if(pgbackrest == 'Y'){
			selectChckTab = "pgbackrest";
		} */
		selectChkTab="pgbackrest"; 
		
		selectInitTab(selectChkTab);

		//작업기간 calender setting
		dateCalenderSetting();

		//조회
 		if(tabGbn != ""){
 			if (tabGbn == "rman") {
 	 			$('#server-tab-1').click();
 			} else if(tabGbn == "pgbackrest") {
 	 			$('#server-tab-3').click();
 			}else {
 				$('#server-tab-2').click();
 			}
		}
		
		//pgbackrest 사용 여부에 따른 숨김 처리
		if(pgbackrest == "Y"){
			$('#li-server-tab-1').hide();
			$('#server-tab-3').click();
			$('#fix_rsltcd').parent().hide();
			$('#wrk_nm').parent().removeClass('col-sm-2');
			$('#wrk_nm').parent().addClass('col-sm-4');
		}else {
			$('#li-server-tab-3').hide();
			$('#server-tab-1').click();
		}

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			if(!calenderValid()) {
				return;
			}
			if(selectChkTab == "rman"){
				fn_get_rman_list();
			}else if (selectChkTab == "pgbackrest" ){
				fn_get_backrest_list();	
			}else{
				fn_get_dump_list();
			}
		});
		
			
		/* ********************************************************
		 * Click Excel Button
		 ******************************************************** */
	 	$("#btnExcel").click(function() {		 		
			var dataLength = 0;
			
			var form = document.excelForm;
			
			var db_id = $("#db_id").val();
			if(db_id == "") db_id = 0;
			
			$("#dbsvrid").val($("#db_svr_id", "#findList").val());			
			$("#bck_opt").val($("#bck_opt_cd").val());
			$("#strt_dtm").val($("#wrk_strt_dtm").val());
			$("#end_dtm").val($("#wrk_end_dtm").val());
			$("#exe_rslt").val($("#exe_rslt_cd").val());
			$("#wrkNm").val(nvlPrmSet($('#wrk_nm').val(), ""));
			$("#fixRsltcd").val($("#fix_rsltcd").val());
			$("#dbId").val(db_id);

			if(selectChkTab == "rman"){
				dataLength = tableRman.rows().data().length;
				if(dataLength >0){
					$("#histgbn").val("rman_hist");
					$("#bck_bsn").val("TC000201");
					form.action = "/backupExeclDownload.do";
				 	form.submit();				
				}						
			}else if (selectChkTab == "pgbackrest" ){
				dataLength = tableBackrest.rows().data().length;
			}else{
				 dataLength = tableDump.rows().data().length;
					if(dataLength >0){
						$("#histgbn").val("dump_hist");
						$("#bck_bsn").val("TC000202");
						form.action = "/backupExeclDownload.do";
					 	form.submit();				
					}	
			}

	}); 
		
		/* ********************************************************
		 * Click Latest Log
		 ******************************************************** */
		 if(tableBackrest != null){
			 tableBackrest.row(0).click;
		 }
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
	function selectInitTab(intab){
		selectChkTab = intab;

		if(intab == "rman"){	
			$(".search_rman").show();
			$(".search_dump").hide();
			$(".search_pgbackrest").hide();
			$("#logRmanListDiv").show();
			$("#logDumpListDiv").hide();
			$("#logBackrestListDiv").hide();
			$("#backRestActiveLogDiv").hide();
			
			seachParamInit(intab);
			
		}else if(intab == "pgbackrest"){
			$(".search_rman").hide();
			$(".search_dump").hide();
			$(".search_pgbackrest").show();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").hide();
			$("#logBackrestListDiv").show();
			$("#backRestActiveLogDiv").show();
			$('#fix_rsltcd').parent().hide();
			$('#wrk_nm').parent().removeClass('col-sm-2');
			$('#wrk_nm').parent().addClass('col-sm-2_3');
			
			seachParamInit(intab);
			
		}else{
			$(".search_rman").hide();
			$(".search_dump").show();
			$(".search_pgbackrest").hide();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").show();
			$("#logBackrestListDiv").hide();
			$("#backRestActiveLogDiv").hide();
			$('#fix_rsltcd').parent().show();
			$('#wrk_nm').parent().removeClass('col-sm-4');
			$('#wrk_nm').parent().addClass('col-sm-2');

			seachParamInit(intab);
		}

		//테이블 setting
		fn_rman_init();
		fn_dump_init();
		fn_backrest_init();  
	}
	/* ********************************************************
	 * 조회조건 초기화
	 ******************************************************** */
	function seachParamInit(tabGbn) {
		if (searchInit == tabGbn) {
			return;
		}
		
		$("#wrk_nm").val("");
		$("#exe_rslt_cd option:eq(0)").attr("selected","selected");
		$("#fix_rsltcd option:eq(0)").attr("selected","selected");

		if (tabGbn == "rman") {
			$("#bck_opt_cd option:eq(0)").attr("selected","selected");
		} else if(tabGbn == "pgbackrest"){
			$("#backrest_opt option:eq(0)").attr("selected", "selected"); 
		} else{
			$("#db_id option:eq(0)").attr("selected","selected");
		}

		searchInit = tabGbn;
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
			scrollY: "750px",
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
			scrollY: "750px",	
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
	 * pgBackrest Data Table initialization
	 ******************************************************** */
	 function fn_backrest_init(){
			tableBackrest = $('#logBackrestList').DataTable({
				scrollY: "300px",	
				scrollX: true,
				bDestroy: true,
				processing : true,
				searching : false,
				deferRender : true,
				bSort: false,
				columns : [
					{data: "rownum", className: "dt-center", defaultContent: ""},
					{data: "exe_rslt_cd", 
						render : function(data, type, full, meta){
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
						className: "dt-center", defaultContent: ""},
					{data: "wrk_nm", className: "dt-center", defaultContent: ""},
					{data: "ipadr",
						render : function(data, type, full, meta){
							html = '';
							if(full.backrest_gbn == 'remote'){
								html += full.remote_ip;
							}else {
								html = full.ipadr;
							}
							return html;
						},
						className: "dt-center", defaultContent: ""},
					{data: "storage", 
						render : function(data, type, full, meta) {
							var html = '';
							if(full.backrest_gbn != null && full.backrest_gbn != ''){
								html += full.backrest_gbn.toUpperCase();	
								return html; 
							}
						},
						className: "dt-center", defaultContent: ""},
					{data: "bck_opt_cd_nm",
							render : function(data, type, full, meta){
								var html = '';
								html += full.bck_opt_cd_nm.toUpperCase();
								return html;
							},
							className: "dt-center", defaultContent: ""},
					{data: "bck_file_pth", className: "dt-center", defaultContent: ""},
					{data: "db_sz", 
						render : function(data, type, full, meta){ 
							var html = '';
							
							if(full.db_sz !=0){
								var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
								var e = Math.floor(Math.log(full.db_sz) / Math.log(1024));

								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files text-primary' >";
								html += '&nbsp;' + (full.db_sz / Math.pow(1024, e)).toFixed(2) + " " + s[e] + '</i>';
								html += "</div>";
							}
							return html;
						},
						className: "dt-center", defaultContent: ""},
					{data: "file_sz",
						render : function(data, type, full, meta){
							var html = ''; 
							
							if(full.file_sz != 0){
								var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
								var e = Math.floor(Math.log(full.file_sz) / Math.log(1024));

								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files text-primary' >";
								html += '&nbsp;' + (full.file_sz / Math.pow(1024, e)).toFixed(2) + " " + s[e] + '</i>';
								html += "</div>";
							}
							return html;							
						},
						className: "dt-center", defaultContent: ""},
					{data: "compress", 
							render : function(data, type, full, meta){
								var html = '';
								
								if(full.exe_rslt_cd == 'TC001701'){
									console.log((full.file_sz / full.db_sz ));

									var compress = (1 - (full.file_sz / full.db_sz ))*100
									html += compress.toFixed(1) + "%";
								}
								return html;
							},
							className: "dt-center", defaultContent: ""},
					{data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""},
					{data: "wrk_end_dtm",
						render : function(data, type, full, meta){
							var html = '';
							
							if(full.exe_rslt_cd == 'TC001701'){
								html += full.wrk_end_dtm;
							}
							return html;
						},
						className: "dt-center", defaultContent: ""},
					{data: "wrk_dtm",
							render : function(data, type, full, meta){
								html = '';
								if(full.exe_rslt_cd == 'TC001701'){
									var html = "<div class='badge badge-pill badge-primary'>";
									html += "	<i class='mdi mdi-timer mr-2'></i>";
									html += full.wrk_dtm;
									html += "</div>";	
								}
								return html;
							} , 
							className: "dt-center", defaultContent: ""},
					{data: "remote_ip", className: "dt-center", defaultContent: "", visible: false},
					{data: "remote_port", className: "dt-center", defaultContent: "", visible: false},
					{data: "remote_usr", className: "dt-center", defaultContent: "", visible: false},
					{data: "remote_pw", className: "dt-center", defaultContent: "", visible: false},
				] 
			});

			tableBackrest.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
			tableBackrest.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
			tableBackrest.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
			tableBackrest.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(6)').css('min-width', '170px');
			tableBackrest.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
			tableBackrest.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
			tableBackrest.tables().header().to$().find('th:eq(12)').css('min-width', '100px');

		   	$(window).trigger('resize');
		}
		
	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(intab){
		selectChkTab = intab;
		
		if(intab == "rman"){				
			$(".search_rman").show();
			$(".search_dump").hide();
			$(".search_pgbackrest").hide();
			$("#logRmanListDiv").show();
			$("#logDumpListDiv").hide();
			$("#logBackrestListDiv").hide();
			$("#backRestActiveLogDiv").hide();

			seachParamInit(intab);
			fn_get_rman_list();
			
		}else if(intab == "pgbackrest"){
			$(".search_rman").hide();
			$(".search_dump").hide();
			$(".search_pgbackrest").show();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").hide();
			$("#logBackrestListDiv").show();
			$("#backRestActiveLogDiv").show();
			$('#fix_rsltcd').parent().hide();
			$('#wrk_nm').parent().removeClass('col-sm-2');
			$('#wrk_nm').parent().addClass('col-sm-4');
			
			seachParamInit(intab);
			fn_get_backrest_list();
			
		}else{				
			$(".search_rman").hide();
			$(".search_dump").show();
			$(".search_pgbackrest").hide();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").show();
			$("#logBackrestListDiv").hide();
			$("#backRestActiveLogDiv").hide();
			$('#fix_rsltcd').parent().show();
			$('#wrk_nm').parent().removeClass('col-sm-4');
			$('#wrk_nm').parent().addClass('col-sm-2');
			
			seachParamInit(intab);
			fn_get_dump_list();
		}
	}

	/* ********************************************************
	 * Get Rman Log List
	 ******************************************************** */
	function fn_get_rman_list(){
		if(!calenderValid()) {
			return;
		}
		
 		$.ajax({
 			url : "/backup/selectWorkLogList.do",
 			data : {
				hist_gbn : "rman_hist",
				db_svr_id : $("#db_svr_id", "#findList").val(),
				bck_bsn_dscd : "TC000201",
				bck_opt_cd : $("#bck_opt_cd").val(),
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
				tableRman.rows({selected: true}).deselect();
				tableRman.clear().draw();

				if (nvlPrmSet(result, "") != '') {
					tableRman.rows.add(result).draw();
				}
			}
		});
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
	
	/* ********************************************************
	 * Get Backrest Log List
	 ******************************************************** */
	function fn_get_backrest_list(){
		if(!calenderValid()) {
			return;
		}
		
		$.ajax({
			url : "/backup/selectWorkLogList.do",
			data : {
				hist_gbn : "backrest_hist",
				db_svr_id : $("#db_svr_id", "#findList").val(),
				bck_bsn_dscd : "TC000205",
		  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
		  		wrk_end_dtm : $("#wrk_end_dtm").val(),
		  		exe_rslt_cd : $("#exe_rslt_cd").val(),
				wrk_nm : nvlPrmSet($('#wrk_nm').val(), ""),
				backrest_gbn : $('#backrest_opt').val()
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
 				tableBackrest.rows({selected: true}).deselect();
				tableBackrest.clear().draw();
				
				if (nvlPrmSet(result, "") != '') {
					tableBackrest.rows.add(result).draw();
				}  
			}
		});
	}
	
	/* ********************************************************
	 * Get backrest Log
	 ******************************************************** */
	$(function() {
		$('#logBackrestList tbody').on('click', 'tr', function() {
			if($(this).hasClass('selected')){
				$('#backRestAcitveLog').text('');
				clearInterval(interval);
				realTimeLog();
			}else {
				tableBackrest.$('tr.selected').removeClass('selected');
				$(this).addClass('selected');
				$('#backRestAcitveLog').text('');
				clearInterval(interval);
				realTimeLog();
			}
		})
	});

	function realTimeLog(){
		$('#log_starter').text('Log Stop');
		$('#log_starter').removeClass('btn-success');
		$('#log_starter').addClass('btn-danger');
		$(function() {
			var state;
			if(tableBackrest.row('.selected').data() != null || tableBackrest.row('.selected').data() != undefined){
				state = tableBackrest.row('.selected').data().exe_rslt_cd
			}
			var backrest_gbn = tableBackrest.row('.selected').data().backrest_gbn;
			if(backrest_gbn == 'remote'){
				if(state == 'TC001701'){
					$.ajax({
						url : "/selectBackrestLog.do",
						data : {
							log_path : tableBackrest.row('.selected').data().bck_filenm,
							ipadr : tableBackrest.row('.selected').data().ipadr,
							backrest_gbn : backrest_gbn,
							remote_ip: tableBackrest.row('.selected').data().remote_ip,
							remote_port: tableBackrest.row('.selected').data().remote_port,
							remote_usr: tableBackrest.row('.selected').data().remote_usr,
							remote_pw: tableBackrest.row('.selected').data().remote_pw
						},
						dataType : "json",
						type : "post",
						beforeSend: function(xhr) {
							xhr.setRequestHeader("AJAX", true);
						},
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else if(xhr.status == 403) {
								showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else {
								showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
							}
						},
						success : function(result) {
							$('#backRestAcitveLog').text(result.RESULT_DATA);
							$('#backRestAcitveLog').scrollTop($('#backRestAcitveLog')[0].scrollHeight);
						}
					})
				}else if(state == 'TC001802'){
					var resultCode = -1;
					
					interval = setInterval(function() {
						if(resultCode == -1){
							$.ajax({
								url : "/selectBackrestLog.do",
								data : {
									log_path : tableBackrest.row('.selected').data().bck_filenm,
									ipadr : tableBackrest.row('.selected').data().ipadr,
									backrest_gbn : backrest_gbn,
									remote_ip: tableBackrest.row('.selected').data().remote_ip,
									remote_port: tableBackrest.row('.selected').data().remote_port,
									remote_usr: tableBackrest.row('.selected').data().remote_usr,
									remote_pw: tableBackrest.row('.selected').data().remote_pw
								},
								dataType : "json",
								type : "post",
								beforeSend: function(xhr) {
									xhr.setRequestHeader("AJAX", true);
								},
								error : function(xhr, status, error) {
									if(xhr.status == 401) {
										showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
										top.location.href = "/";
									} else if(xhr.status == 403) {
										showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
										top.location.href = "/";
									} else {
										showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
									}
								},
								success : function(result) {
									if($('#log_starter').text() == 'Log Stop'){
										resultCode = result.RESULT_DATA.indexOf('successfully');
										
										$('#backRestAcitveLog').text(result.RESULT_DATA);
										$('#backRestAcitveLog').scrollTop($('#backRestAcitveLog')[0].scrollHeight);	
										
									}else {
										fn_get_backrest_list();
									}
								}
							});
							$('#loading').hide();
						}else {
							clearInterval(interval);
							fn_get_backrest_list();
							$('#loading').hide();
						}
					}, 5000);
				} 

			}else {
//				상태가 실행 중이면 ajax 여러번 실행 / 상태가 성공이면 한번만 실행
				if(state == 'TC001701'){
					$.ajax({
						url : "/selectBackrestLog.do",
						data : {
							log_path : tableBackrest.row('.selected').data().bck_filenm,
							backrest_gbn : backrest_gbn,
							ipadr : tableBackrest.row('.selected').data().ipadr
						},
						dataType : "json",
						type : "post",
						beforeSend: function(xhr) {
							xhr.setRequestHeader("AJAX", true);
						},
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else if(xhr.status == 403) {
								showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else {
								showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
							}
						},
						success : function(result) {
							$('#backRestAcitveLog').text(result.RESULT_DATA);
							$('#backRestAcitveLog').scrollTop($('#backRestAcitveLog')[0].scrollHeight);
						}
					})
				} else if(state == 'TC001802'){
					var resultCode = -1;
		
					interval = setInterval(function() {
						if(resultCode == -1){
							$.ajax({
								url : "/selectBackrestLog.do",
								data : {
									log_path : tableBackrest.row('.selected').data().bck_filenm,
									backrest_gbn : backrest_gbn,
									ipadr : tableBackrest.row('.selected').data().ipadr
								},
								dataType : "json",
								type : "post",
								beforeSend: function(xhr) {
									xhr.setRequestHeader("AJAX", true);
								},
								error : function(xhr, status, error) {
									if(xhr.status == 401) {
										showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
										top.location.href = "/";
									} else if(xhr.status == 403) {
										showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
										top.location.href = "/";
									} else {
										showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
									}
								},
								success : function(result) {
									if($('#log_starter').text() == 'Log Stop'){
										resultCode = result.RESULT_DATA.indexOf('successfully');
										
										$('#backRestAcitveLog').text(result.RESULT_DATA);
										$('#backRestAcitveLog').scrollTop($('#backRestAcitveLog')[0].scrollHeight);	
										
									}else {
										fn_get_backrest_list();
									}
								}
							});
							$('#loading').hide();
						}else {
							clearInterval(interval);
							fn_get_backrest_list();
							$('#loading').hide();
						}
					}, 5000);
				}
			}
		});
	} 
	
	  
	function stopInterval(){

		var selectedRow = tableBackrest.row('.selected').data();
		var logText = $('#log_starter').text();
		
		if(selectedRow != undefined || selectedRow != null){
			var logText = $('#log_starter').text();
			
			if(selectedRow.exe_rslt_cd != 'TC001701' && logText == 'Log Stop'){
				showSwalIcon('실시간 로그 중지', '<spring:message code="common.close" />', '', 'success');
				clearInterval(interval);
				
				$('#log_starter').text('Log Restart');
				$('#log_starter').removeClass('btn-danger');
				$('#log_starter').addClass('btn-success');
			}else {
				showSwalIcon('실시간 로그 재시작', '<spring:message code="common.close" />', '', 'success');
				$('#log_starter').text('Log Stop');
				$('#log_starter').removeClass('btn-success');
				$('#log_starter').addClass('btn-danger');
				realTimeLog();
			}
		} 
	}
	
	
</script>
 
<%@include file="../cmmn/fixRsltMsgInfo.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>
<%@include file="../popup/rmanShow.jsp"%>
<%@include file="../popup/dumpShow.jsp"%>
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">	
</form>

<form name="excelForm" id="excelForm" method="post">
	<input type="hidden" name="histgbn" id="histgbn" >
	<input type="hidden" name="dbsvrid"  id="dbsvrid"  value="${db_svr_id}">	
	<input type="hidden" name="bck_bsn" id="bck_bsn" >
	<input type="hidden" name="bck_opt" id="bck_opt" >
	<input type="hidden" name="strt_dtm" id="strt_dtm" >
	<input type="hidden" name="end_dtm" id="end_dtm" >
	<input type="hidden" name="exe_rslt" id="exe_rslt" >
	<input type="hidden" name="wrkNm" id="wrkNm" >
	<input type="hidden" name="fixRsltcd" id="fixRsltcd" >
	<input type="hidden" name="dbId" id="dbId" >
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
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none; ">
						<li class="nav-item" id="li-server-tab-3">
							<a class="nav-link" id="server-tab-3" data-toggle="pill" href="#subTab-3" role="tab" aria-controls="subTab-3" aria-selected="false" onclick="selectTab('pgbackrest');" >
								pgbackrest <spring:message code="menu.backup_history" />
							</a>
						</li>
						<li class="nav-item" id="li-server-tab-1">
							<a class="nav-link" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('rman');" >
								Online <spring:message code="menu.backup_history" />
							</a>
						</li>
						<li class="nav-item" id="li-server-tab-2">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('dump');">
								Dump <spring:message code="menu.backup_history" />
							</a>
						</li>
					</ul>

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
										
								<div class="input-group mb-2 mr-sm-2 search_pgbackrest col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="backrest_opt" id="backrest_opt">
										<option value=""><spring:message code="backup_management.storage.option" /></option>
										<option value="local">local</option>
										<option value="remote">remote</option>
										<option value="cloud">cloud</option>
									</select>
								</div>		
										
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="bck_opt_cd" id="bck_opt_cd">
										<option value=""><spring:message code="backup_management.backup_option" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
										<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
										<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
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
									
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
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
								 <button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnExcel" style="margin-left: 5px;">
									<i class="ti-import btn-icon-prepend "></i>엑셀
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
								<div class="col-12" id="logRmanListDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

	 								<table id="logRmanList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="150"><spring:message code="common.work_name" /></th>
												<th width="100"><spring:message code="dbms_information.dbms_ip" /></th>
												<th width="150"><spring:message code="common.work_description" /></th>
												<th width="90"><spring:message code="backup_management.backup_option" /></th>
												<th width="230"><spring:message code="etc.etc08"/></th>
												<th width="100"><spring:message code="backup_management.work_start_time" /> </th>
												<th width="100"><spring:message code="backup_management.work_end_time" /></th>
												<th width="70"><spring:message code="backup_management.elapsed_time" /></th>
												<th width="100"><spring:message code="common.status" /></th>
												<th width="100"><spring:message code="etc.etc31"/></th>
											</tr>
										</thead>
									</table>
							 	</div>
							 	
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
							 	
							 	<div class="col-12" id="logBackrestListDiv">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"	class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>
	 								<table id="logBackrestList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="40"><spring:message code="etc.etc25" /></th>
												<th width="40"><spring:message code="common.work_name" /></th>
												<th width="60"><spring:message code="backup_management.backup.storage" /></th>
												<th width="40"><spring:message code="backup_management.storage" /></th>
												<th width="40"><spring:message code="backup_management.bck_div" /></th>
												<th width="100"><spring:message code="properties.backup_path" /></th>
												<th width="50">DB SIZE</th>
												<th width="50"><spring:message code="dashboard.backup" /> SIZE</th>
												<th width="50"><spring:message code="backup_management.compressibility" /></th>
												<th width="50"><spring:message code="dashboard.backup" /> <spring:message code="eXperDB_scale.start_time" /></th>
												<th width="50"><spring:message code="dashboard.backup" /> <spring:message code="backup_management.endtime" /></th>
												<th width="50"><spring:message code="dashboard.backup" /> <spring:message code="eXperDB_proxy.work_time" /></th>
											</tr>
										</thead>
									</table>	
							 	</div>
						 	</div>
						</div>
					</div>
					<br>
					<div id="backRestActiveLogDiv" >	
						<h4>※ Active Log</h4>
						<div class="card my-sm-2" >	
							<div class="col-12">
								<div class="card-body">
									<div class="row">
										<table id="backresLog" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<tr class="bg-info text-white">
												<th>Log Message</th> 
												<th class="float-right"><button id="log_starter" type="button" class="btn btn-danger" onclick="stopInterval()">Log Stop</button></th>
											</tr>
										</table>
										<textarea id="backRestAcitveLog" rows=20 style="width:100%;" disabled onfocus="this.value = this.value;"></textarea>
									</div> 
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