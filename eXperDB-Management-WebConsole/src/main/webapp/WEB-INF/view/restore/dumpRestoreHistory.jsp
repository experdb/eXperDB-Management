<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	var tableRman = null;
	var tableDump = null;
	var tabGbn = nvlPrmSet("${tabGbn}", "dump");
	var searchInit = "";

	/* ********************************************************
	 * Data initialization
	 ******************************************************** */
	$(window.document).ready(function() {
		
		//검색조건 초기화
		selectInitTab(tabGbn);

		//작업기간 calender setting
		dateCalenderSetting();

		//조회
		/* if(tabGbn != ""){
			selectTab(tabGbn);
		}else{
			selectTab("rman");
		} */
			selectTab("dump");

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			if(!calenderValid()) {
				return;
			}

			/* if(tabGbn == "rman"){
				fn_get_rman_list();
			}else{
				fn_get_dump_list();
			} */
				fn_get_dump_list();
		});
	});

	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectInitTab(intab){
		tabGbn = intab;
		/* if(intab == "rman"){			
			$(".search_rman").show();
			$(".search_dump").hide();
			$("#logRmanListDiv").show();
			$("#logDumpListDiv").hide();

			seachParamInit(intab);
		}else{	 */			
			$(".search_rman").hide();
			$(".search_dump").show();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").show();

			seachParamInit(intab);
		// }

		//테이블 setting
		// fn_rman_init();
		fn_dump_init();
	}

	/* ********************************************************
	 * 조회조건 초기화
	 ******************************************************** */
	function seachParamInit(tabGbn) {
		if (searchInit == tabGbn) {
			return;
		}
		
		$("#restore_nm").val("");
		$("#restore_cndt option:eq(0)").attr("selected","selected");
		$("#fix_rsltcd option:eq(0)").attr("selected","selected");

		if (tabGbn == "rman") {
			$("#restore_flag option:eq(0)").attr("selected","selected");
		} else {
			$("#db_nm option:eq(0)").attr("selected","selected");
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

		$("#restore_strtdtm").val(day_start);
		$("#restore_enddtm").val(day_end);

		if ($("#restore_strtdtm_div").length) {
			$('#restore_strtdtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_start = new Date(selected.date.valueOf());
		    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
		        $("#restore_enddtm_div").datepicker('setStartDate', day_start);
		        $("#restore_enddtm").datepicker('setStartDate', day_start);
			}); //값 셋팅
		}

		if ($("#restore_enddtm_div").length) {
			$('#restore_enddtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_end = new Date(selected.date.valueOf());
		    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
		        $('#restore_strtdtm_div').datepicker('setEndDate', day_end);
		        $('#restore_strtdtm').datepicker('setEndDate', day_end);
			}); //값 셋팅
		}
		
		$("#restore_strtdtm").datepicker('setDate', day_start);
	    $("#restore_enddtm").datepicker('setDate', day_end);
	    $('#restore_strtdtm_div').datepicker('updateDates');
	    $('#restore_enddtm_div').datepicker('updateDates');
	}
	
	/* ********************************************************
	 * calender valid 체크
	 ******************************************************** */
	function calenderValid() {
		var restore_strtdtm = $("#restore_strtdtm").val();
		var restore_enddtm = $("#restore_enddtm").val();

		if (restore_strtdtm != "" && restore_enddtm == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}

		if (restore_enddtm != "" && restore_strtdtm == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}
		
		return true;
	}

	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(intab){
		tabGbn = intab;
		/* if(intab == "rman"){			
			$(".search_rman").show();
			$(".search_dump").hide();
			$("#logRmanListDiv").show();
			$("#logDumpListDiv").hide();
	
			seachParamInit(intab);
	
			fn_get_rman_list();
		}else{ */
			$(".search_rman").hide();
			$(".search_dump").show();
			$("#logRmanListDiv").hide();
			$("#logDumpListDiv").show();
	
			seachParamInit(intab);
			fn_get_dump_list();
		// }
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
						{
							data : "restore_flag",
							render : function(data, type, full, meta) {
								var html = '';
								
								if (full.restore_flag == '0') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
									html += "	<i class='fa fa-bell text-danger mr-2'></i>";
	 								html += '<spring:message code="restore.Emergency_Recovery"/>';
									html += "</div>";
								} else {
									html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
									html += "	<i class='mdi mdi-backup-restore text-info mr-2'></i>";
	 								html += '<spring:message code="restore.Point-in-Time_Recovery"/>';
									html += "</div>";
								}
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},        
						{ data: "restore_nm", className: "dt-center", defaultContent: ""},
						{ data: "restore_exp", className: "dt-left", defaultContent: ""},
						
			         	{ data: "timeline", 
							render : function(data, type, full, meta) {
								var html = '';
								
								if (nvlPrmSet(full.timeline_dt, "") != '') {
									html += full.timeline_dt.substring(0,4) + "-" + full.timeline_dt.substring(4,6) + "-" + full.timeline_dt.substring(6,8);
									
									if (nvlPrmSet(full.timeline_h, "") != '' && nvlPrmSet(full.timeline_m, "") != '' && nvlPrmSet(full.timeline_s, "") != '') {
										html += " " + full.timeline_h + ":" + nvlPrmSet(full.timeline_m, "") + ":" + nvlPrmSet(full.timeline_s, "");
									}
								}
				
								return html;
							},
							className: "dt-center", defaultContent: ""}, 
			         	{ data: "restore_strtdtm", className: "dt-center", defaultContent: ""},
			         	{ data: "restore_enddtm", className: "dt-center", defaultContent: ""}, 
			         	{
							data : "restore_cndt",
							render : function(data, type, full, meta) {
								var html = '';
								if (full.restore_cndt == '0') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-check-circle text-primary' >";
									html += '&nbsp;<spring:message code="common.success" /></i>';
									html += "</div>";
								} else if (full.restore_cndt == '1'){
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-play text-warning' >";
									html += '&nbsp;<spring:message code="etc.etc37" />';
									html += "</div>";
									
								} else if (full.restore_cndt == '2'){
									html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
									html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
									html += '&nbsp;<spring:message code="restore.progress" />';
									html += "</div>";
								} else {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-times text-danger' >";
									html += '&nbsp;<spring:message code="common.failed" /></i>';
									html += "</div>";
								}
								
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},								
			         	{
			    			data : "",
			    			render : function(data, type, full, meta) {
			    				var html = "";
 								html += '<button type="button" class="btn btn-primary btn-icon-text" onclick="fn_restoreLogInfo('+full.restore_sn+', \'rman\');">';
 								html += '<i class="fa fa-lightbulb-o btn-icon-prepend"></i>';
 								html += '<spring:message code="restore.log"/>';
 								html += "</button>";

			    				return html;
			    			},
			    			className : "dt-center",
			    			defaultContent : ""
			    		},			         	
			         	{ data: "regr_id", className: "dt-center", defaultContent: ""},
			    		{ data: "restore_sn", className: "dt-center", defaultContent: "", visible: false}
 		        ]
		});
   	
	   	tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
	   	tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	   	tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	   	tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	   	tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '120px');
	   	tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '120px');
	   	tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '120px');
	   	tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '75px');
	   	tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	   	tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	   	tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '0px');

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
		         		{data: "restore_nm", className: "dt-center", defaultContent: ""},
						{data: "restore_exp", className: "dt-left", defaultContent: ""},
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
	 		         	{data: "bck_filenm", defaultContent: ""},
	 		         	{data: "restore_strtdtm", className: "dt-center", defaultContent: ""},
			         	{data: "restore_enddtm", className: "dt-center", defaultContent: ""},		         			         	
 		         		{
							data : "restore_cndt",
							render : function(data, type, full, meta) {
								var html = '';
							
								if (full.restore_cndt == '0') {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-check-circle text-primary' >";
									html += '&nbsp;<spring:message code="common.success" /></i>';
									html += "</div>";
								} else if (full.restore_cndt == '1'){
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-play text-warning' >";
									html += '&nbsp;<spring:message code="etc.etc37" />';
									html += "</div>";
									
								} else if (full.restore_cndt == '2'){
									html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
									html += "	<i class='fa fa-spin fa-spinner mr-2' ></i>";
									html += '&nbsp;<spring:message code="restore.progress" />';
									html += "</div>";
								} else {
									html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += "	<i class='fa fa-times text-danger' >";
									html += '&nbsp;<spring:message code="common.failed" /></i>';
									html += "</div>";
								}
	
								return html;
							},
							className : "dt-center",
							defaultContent : ""
						},
						{
			    			data : "",
			    			render : function(data, type, full, meta) {
			    				var html = "";
									html += '<button type="button" class="btn btn-primary btn-icon-text" onclick="fn_restoreLogInfo('+full.restore_sn+', \'dump\');">';
									html += '<i class="fa fa-lightbulb-o btn-icon-prepend"></i>';
									html += '<spring:message code="restore.log"/>';
									html += "</button>";

			    				return html;
			    			},
			    			className : "dt-center",
			    			defaultContent : ""
			    		},			         	
		         	{ data: "regr_id", className: "dt-center", defaultContent: ""},
		    		{ data: "restore_sn", className: "dt-center", defaultContent: "", visible: false}
 		        ]
		});

	   	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
	   	tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	   	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
	   	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '170px');
	   	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	   	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	    $(window).trigger('resize');
	}

	/* ********************************************************
	 * Get Rman Log List
	 ******************************************************** */
	function fn_get_rman_list(){
		if(!calenderValid()) {
			return;
		}
		
 		$.ajax({
			url : "/rmanRestoreHistory.do",
		  	data : {
				hist_gbn : "rman_hist",
				db_svr_id : $("#db_svr_id", "#findList").val(),
		  		restore_flag : $("#restore_flag").val(),
		  		restore_strtdtm : $("#restore_strtdtm").val(),
		  		restore_enddtm : $("#restore_enddtm").val(),
		  		restore_cndt : $("#restore_cndt").val(),
		  		restore_nm : nvlPrmSet($('#restore_nm').val(), ""),
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
			url : "/dumpRestoreHistory.do",
		  	data : {
				hist_gbn : "dump_hist",
				db_svr_id : $("#db_svr_id", "#findList").val(),
		  		db_id : db_id,
		  		restore_strtdtm : $("#restore_strtdtm").val(),
		  		restore_enddtm : $("#restore_enddtm").val(),
		  		restore_cndt : $("#restore_cndt").val(),
		  		restore_nm : nvlPrmSet($('#restore_nm').val(), "")
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
	 * ScriptWORK정보
	 ******************************************************** */
	function fn_restoreLogInfo(restore_sn, flag){
		$.ajax({
			url : "/restoreLogView.do",
			data : {
				restore_sn : restore_sn,
				db_svr_id : $("#db_svr_id", "#findList").val(),
				flag : flag
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		    },
		    error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if(result.length==0){
					showSwalIcon("<spring:message code='message.msg210' />", '<spring:message code="common.close" />', '', 'error');
				}else{
					$("#pop_restore_sn", "#findList").val(restore_sn);
					$("#pop_flag", "#findList").val(flag);

					if (flag == "rman") {
						$("#restoreRmanHistorylog").show();
						$("#restoreDumpHistorylog").hide();
						
						$("#restoreRmanHistorylog").html("");
					} else {
						$("#restoreRmanHistorylog").hide();
						$("#restoreDumpHistorylog").show();
						
						$("#restoreDumpHistorylog").html("");
					}

					fn_addView();
					
					$("#pop_layer_restore_log").modal("show");
				}
			}
		});	
	}
</script>

<%@include file="../popup/restoreLogView.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
	<input type="hidden" name="pop_restore_sn"  id="pop_restore_sn"  value="">
	<input type="hidden" name="pop_flag"  id="pop_flag"  value="">
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
												<span class="menu-title"><spring:message code="restore.Recovery_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.Recovery_Management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.Recovery_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.Recovery_history"/></p>
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
					<%-- <ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('rman');" >
								<spring:message code="restore.Emergency_Point-in-Time" /> <spring:message code="restore.Recovery_history" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('dump');">
								Dump <spring:message code="restore.Recovery_history" />
							</a>
						</li>
					</ul> --%>

					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">

							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row">
									<div id="restore_strtdtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="height:44px;" id="restore_strtdtm" name="restore_strtdtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
												
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="restore_enddtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="height:44px;" id="restore_enddtm" name="restore_enddtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control"  style="margin-left: -0.7rem;margin-right: -0.7rem;" name="restore_cndt" id="restore_cndt">
										<option value=""><spring:message code="common.status" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="0"><spring:message code="common.success" /></option>
										<option value="1"><spring:message code="etc.etc37" /></option>
										<option value="2"><spring:message code="restore.progress" /></option>
										<option value="3"><spring:message code="common.failed" /></option>
									</select>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="restore_flag" id="restore_flag">
										<option value=""><spring:message code="restore.Recovery_Category" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="0"><spring:message code="restore.Emergency_Recovery" /></option>
										<option value="1"><spring:message code="restore.Point-in-Time_Recovery" /></option>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 search_dump col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="db_nm" id="db_nm">
										<option value=""><spring:message code="common.database" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
											<option value="<c:out value="${result.db_nm}"/>"><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 col-sm-3" >
									<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="25" id="restore_nm" name="restore_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="message.msg107" />' />
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
												<th width="100"><spring:message code="restore.Recovery_Category" /></th>
												<th width="150"><spring:message code="restore.Recovery_name" /></th>
												<th width="200"><spring:message code="restore.Recovery_Description" /></th>
												<th width="120">TimeLine</th>
												<th width="120"><spring:message code="backup_management.work_start_time" /></th>
												<th width="120"><spring:message code="backup_management.work_end_time" /></th>
												<th width="75"><spring:message code="common.status" /></th>
												<th width="100"><spring:message code="restore.log" /></th>
												<th width="100"><spring:message code="restore.worker" /></th>
												<th width="0"></th>
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
												<th width="150"><spring:message code="restore.Recovery_name" /></th>
												<th width="100"><spring:message code="restore.Recovery_Description" /></th>
												<th width="100">Database</th>
												<th width="100">SIZE</th>
												<th width="170"><spring:message code="backup_management.fileName" /></th>			
												<th width="120"><spring:message code="backup_management.work_start_time" /></th>						
												<th width="120"><spring:message code="backup_management.work_end_time" /></th>
												<th width="100"><spring:message code="common.status" /></th>
												<th width="100"><spring:message code="restore.log" /></th>
												<th width="100"><spring:message code="restore.worker" /></th>
												<th width="0"></th>
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