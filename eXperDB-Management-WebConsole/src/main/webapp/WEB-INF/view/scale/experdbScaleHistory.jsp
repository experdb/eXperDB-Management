<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
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

<script type="text/javascript">
	var tableExecute = null;
	var tableOccur = null;
	var selectChkTab = "executeHist";
	var searchInit = "";
	var tabGbn = "${tabGbn}";
	var clickExecute = false;
	var clickOccur = false;

	//scale 체크 조회
	var install_yn = "";

	$(window.document).ready(function() {
		//검색조건 초기화
		selectInitTab(selectChkTab);
		
		//작업기간 calender setting
		dateCalenderSetting();

		//aws 서버 확인
		fn_selectScaleInstallChk(tabGbn);

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			selectTab(selectChkTab);
			
			if(selectChkTab == "executeHist"){
				fn_get_execute_list();
			}else{
				fn_get_occur_list();
			}
		});
	});
	
	/* ********************************************************
	 * aws 서버 확인
	 ******************************************************** */
	function fn_selectScaleInstallChk(tabGbn) {
		//scale 체크 조회
		var errorMsg = "";
		var titleMsg = "";

		$.ajax({
			url : "/scale/selectScaleInstallChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					install_yn = result.install_yn;
				}

				//AWS 서버인경우
				if (install_yn == "Y") {
					//조회
					if(tabGbn != ""){
						selectTab(tabGbn);
					}else{
						selectTab("executeHist");
					}
				} else {
					showDangerToast('top-right', '<spring:message code="eXperDB_scale.msg10" />', '<spring:message code="eXperDB_scale.msg14" />');
					
					//설치안된경우 버튼 막아야함
					$("#btnSelect").prop("disabled", "disabled");
					$("#wrk_strt_dtm").prop("disabled", "disabled");
					$("#wrk_end_dtm").prop("disabled", "disabled");
					$("#exe_rslt_cd").prop("disabled", "disabled");
					$("#scale_type_cd").prop("disabled", "disabled");
					$("#policy_type_cd").prop("disabled", "disabled");
					$("#process_id_set").prop("disabled", "disabled");
					$("#wrk_type_Cd").prop("disabled", "disabled");
					$("#execute_type_cd").prop("disabled", "disabled");
					
					selectTab("executeHist");
				}
			}
		});
		$('#loading').hide();
	}
	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectInitTab(intab){
		selectChkTab = intab;
		if(intab == "executeHist"){			
			$(".search_execute").show();
			$(".search_occur").hide();
			$("#logExecuteHistListDiv").show();
			$("#logOccurHistListDiv").hide();

			seachParamInit(intab);
		}else{				
			$(".search_execute").hide();
			$(".search_occur").show();
			$("#logExecuteHistListDiv").hide();
			$("#logOccurHistListDiv").show();

			seachParamInit(intab);
		}

		//테이블 setting
		fn_execute_init();
		fn_occur_init();
	}

	
	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(intab){
		selectChkTab = intab;
		if(intab == "executeHist"){			
			$(".search_execute").show();
			$(".search_occur").hide();
			$("#logExecuteHistListDiv").show();
			$("#logOccurHistListDiv").hide();

			seachParamInit(intab);

			if (install_yn == "Y") {
				fn_get_execute_list();
				clickExecute = true;
			}
		}else{				
			$(".search_execute").hide();
			$(".search_occur").show();
			$("#logExecuteHistListDiv").hide();
			$("#logOccurHistListDiv").show();

			seachParamInit(intab);

			if (install_yn == "Y") {
 				fn_get_occur_list();
				clickOccur = true;
			}
		}
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
		    }); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#wrk_end_dtm").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
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
	function fn_execute_init(){
		var scale_type_nm_init = "";
		
		tableExecute = $('#scaleExecuteHistList').DataTable({
			scrollY : "280px",
			scrollX : true,
			searching : false,
			deferRender : true,
			bSort: false,
			columns : [
					{data: "rownum", className: "dt-center", defaultContent: ""},
					{data : "process_id", className : "dt-center", defaultContent : ""
						,render: function (data, type, full) {
							return '<span onClick=javascript:fn_scaleExecHistLayer("'+full.scale_wrk_sn+'"); class="bold" data-toggle="modal" title="'+full.process_id+'">' + full.process_id + '</span>';
						}
					},
					{
						data : "scale_type_nm",
						render: function (data, type, full){
	 						var html = '';
	 						if (full.scale_type == "1") {
	 							html = '<spring:message code="etc.etc38" />';
	 						} else {
	 							html = '<spring:message code="etc.etc39" />';
	 						}
	 						return html;
						},
					},
					{
						data : "wrk_type_nm", 
 						render: function (data, type, full){
	 						var html = '';
	 						if (full.wrk_type == "TC003301") {
								html += "<div class='badge badge-pill badge-success'>";
								html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
								html += full.wrk_type_nm;
								html += "</div>";
	 						} else {
								html += "<div class='badge badge-pill badge-warning'>";
								html += "	<i class='fa fa-user-o mr-2'></i>";
								html += full.wrk_type_nm;
								html += "</div>";
	 						}
	 						return html;
						},
						className : "dt-center", defaultContent : ""},
					{
						data : "auto_policy_nm", 
						render: function (data, type, full){
	 						if (full.wrk_type == "TC003301") {
		 						var html = "";
								if (typeof full.policy_type_nm == "undefined") {
									html += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
									html += '<i class="mdi mdi-gender-transgender"></i>';
									html += '<spring:message code="eXperDB_scale.msg32" />';
									html += "</div>";
								} else {			 						
									if (full.policy_type_nm == "CPU") {
										html += "<div class='badge badge-pill badge-info'>";
										html += '<i class="mdi mdi-vector-square"></i>';
										html += full.policy_type_nm;
										html += "</div>";
									} else {
										html += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
										html += '<i class="mdi mdi-gender-transgender"></i>';
										html += full.policy_type_nm;
										html += "</div>";
									}

									html += " (";
			 						if (full.auto_policy_set_div == "1") {
		 								html += '<spring:message code="eXperDB_scale.policy_time_1" />';
			 						} else {
		 								html += '<spring:message code="eXperDB_scale.policy_time_2" />' ;
			 						}
			 						
			 						html += ' ' + full.auto_level;
			 						
			 						if (full.auto_policy == "TC003501") {
		 								html += '%';
			 						}
			 						
			 						html += ' ' + full.auto_policy_time + "minutes) ";
			 						
			 						if (full.scale_type == "1") {
			 							html += '<spring:message code="eXperDB_scale.under" />';
			 						} else {
			 							html += '<spring:message code="eXperDB_scale.or_more" />';
			 						}
								}

	 						}
	 						return html;
						},
						className : "dt-left", defaultContent : ""
					},
					{data : "wrk_strt_dtm", className : "dt-center", defaultContent : ""},
					{
						data : "wrk_end_dtm", 
	 					render: function (data, type, full){
	 						var html = '';
							if(full.wrk_id == "2"){
								html = full.wrk_end_dtm;
							}
							return html;
						},
						className : "dt-center", defaultContent : ""
					},
					{
						data : "wrk_dtm", 
	 					render: function (data, type, full){
	 						var html = '';
							if(full.wrk_id == "2"){
								html = full.wrk_dtm;
							}
							return html;
						},
						className : "dt-center", defaultContent : ""
					},
					{
						data : "wrk_id", 
		 				render: function (data, type, full){
 		 						var html = '';
								if(full.wrk_id == "1"){
									html = '<div class="loader-scale-box"><div class="dot-opacity-loader"><span></span><span></span><span></span><span></span></div><span class="text-warning"><spring:message code="restore.progress" /></span></div>';
								}else{
									html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
									html += '<i class="fa fa-check-circle" style="color: #6600CC;"></i>';
									html += '&nbsp;<spring:message code="eXperDB_scale.complete" />';
									html += "</div>";
								}
								return html;
								
							},
						className : "dt-center",
						defaultContent : ""
					},
					{
	 					data : "exe_rslt_cd_nm",
	 					render : function(data, type, full, meta) {	 
	 						var html = '';
					
	 						if (full.exe_rslt_cd == 'TC001701' && full.wrk_id == '2') {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += '<i class="fa fa-check-circle text-primary"></i>';
								html += '&nbsp;<spring:message code="common.success" />';
								html += "</div>";
	 						} else if(full.exe_rslt_cd == 'TC001702' && full.wrk_id == '2') {
								html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_scaleFailLog('+full.scale_wrk_sn+')">';
								html += '<i class="fa fa-times"></i>';
								html += '<spring:message code="common.failed" />';
								html += "</button>";
	 						} else {
	 							html += '<div class="loader-scale-box"><div class="dot-opacity-loader"><span></span><span></span><span></span><span></span></div><span class="text-warning"><spring:message code="etc.etc28" /></span></div>';
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
		tableExecute.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		tableExecute.tables().header().to$().find('th:eq(4)').css('min-width', '220px');
		tableExecute.tables().header().to$().find('th:eq(5)').css('min-width', '90px');
		tableExecute.tables().header().to$().find('th:eq(6)').css('min-width', '90px');
		tableExecute.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		tableExecute.tables().header().to$().find('th:eq(8)').css('min-width', '100px');

		$(window).trigger('resize'); 
	}
	
	/* ********************************************************
	 * 발생이력 Data Table initialization
	 ******************************************************** */
	function fn_occur_init(){
		tableOccur = $('#logOccurHistList').DataTable({	
			scrollY: "300px",	
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
						{ data: "rownum", className: "dt-center", defaultContent: ""},
			         	{data : "scale_type_nm", 
		 					render : function(data, type, full, meta) {	 						
		 						var html = '';
		 						if (full.scale_type == "1") {
		 							html = '<spring:message code="etc.etc38" />';
		 						} else {
		 							html = '<spring:message code="etc.etc39" />';
		 						}

								return html;
		 					},
							className : "dt-center", defaultContent : ""},
			         	{
			         		data : "execute_type_nm", 
		 					render : function(data, type, full, meta) {
								var html = '';
								
								if (full.execute_type == 'TC003402') {
									html += "<div class='badge badge-pill badge-success'>";
									html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
									html += full.execute_type_nm;
									html += "</div>";
								} else {
									html += "<div class='badge badge-pill badge-warning'>";
									html += "	<i class='fa fa-bell-o mr-2'></i>";
									html += full.execute_type_nm;
									html += "</div>";
								}

								return html;
		 					},
			         		className : "dt-center", defaultContent : ""},
			         	{
			         		data : "policy_type_nm", 
							render : function(data, type, full, meta) {
								var html = '';

								if (full.policy_type_nm == "CPU") {
									html += '<i class="mdi mdi-vector-square"></i>';
								} else {
									html += '<i class="mdi mdi-gender-transgender"></i>';
								}

								html += "&nbsp;" + full.policy_type_nm;
								return html;
							},
			         		className : "dt-center", defaultContent : ""},
			         	{
			         		data : "auto_policy_contents", 
		 					render : function(data, type, full, meta) {	
		 						var html = "";
		 						if (full.auto_policy_set_div == "1") {
	 								html += '<spring:message code="eXperDB_scale.policy_time_1" />';
		 						} else {
	 								html += '<spring:message code="eXperDB_scale.policy_time_2" />' ;
		 						}
		 						
		 						html += ' ' + full.auto_level;
		 						
		 						if (full.policy_type == "TC003501") {
	 								html += '%';
		 						}
		 						
		 						html += ' ' + full.auto_policy_time + "minutes ";
		 						
		 						if (full.scale_type == "1") {
		 							html += '<spring:message code="eXperDB_scale.under" />';
		 						} else {
		 							html += '<spring:message code="eXperDB_scale.or_more" />';
		 						}
								return html;
		 					},
							className : "dt-left", defaultContent : ""
						},	
				        {
							data : "event_occur_contents", 
			 				render : function(data, type, full, meta) {	
			 						var html = "";
									if (full.policy_type == "TC003501") {
										html += "<div class='row' style='width:150px;'><div class='col-8'>";
										
										html += "<div class='progress progress-lg mt-2' style='width:100%;'>";
										html += "	<div class='progress-bar bg-info progress-bar-striped' role='progressbar' style='width: "+ full.event_occur_contents + "%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>"+ full.event_occur_contents + "%</div>";
										html += "</div>";
										
										html += "</div>";
										
										html += "<div class='col-4' style='text-align: left;margin-left: -8px; margin-top: 6px;'>";

				 						if (full.auto_policy_set_div == "1") {
			 								html += '<spring:message code="eXperDB_scale.policy_time_1" />';
				 						} else {
			 								html += '<spring:message code="eXperDB_scale.policy_time_2" />' ;
				 						}
										
										html += ' ' + full.event_occur_contents + " %";
										html += "</div>";

										html += "</div></div>";
									} else {
										if (full.auto_policy_set_div == "1") {
			 								html += '<spring:message code="eXperDB_scale.policy_time_1" />';
				 						} else {
			 								html += '<spring:message code="eXperDB_scale.policy_time_2" />' ;
				 						}
										
				 						html += ' ' + full.event_occur_contents;
									}

									return html;
			 				},
							className : "dt-left", defaultContent : ""
						},
			         	{data : "event_occur_dtm", className : "dt-center", defaultContent : ""},
			]
		});

		tableOccur.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		tableOccur.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
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
				db_svr_id : $("#db_svr_id", "#findList").val(),
		  		wrk_strt_dtm : $("#wrk_strt_dtm").val(),
		  		wrk_end_dtm : $("#wrk_end_dtm").val(),
		  		exe_rslt_cd : $("#exe_rslt_cd").val(),
		  		scale_type_cd : $("#scale_type_cd").val(),
		  		wrk_type_Cd : $("#wrk_type_Cd").val(),
		  		process_id_set : $('#process_id_set').val()
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
				tableExecute.rows({selected: true}).deselect();
				tableExecute.clear().draw();

				if (nvlPrmSet(result, "") != '') {
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
				db_svr_id : $("#db_svr_id", "#findList").val(),
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				tableOccur.rows({selected: true}).deselect();
				tableOccur.clear().draw();

				if (nvlPrmSet(result, "") != '') {
					tableOccur.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * scale 실행이력 상세정보
	 ******************************************************** */
	function fn_scaleExecHistLayer(scale_wrk_sn){
		var scale_type_nm = "";
		var execute_type_nm = "";
		var auto_policy_nm = '';
		var wrk_stat = "";
		var exe_rslt_cd_nm = "";

		$.ajax({
			url : "/scale/selectScaleWrkInfo.do",
			data : {
				scale_wrk_sn : scale_wrk_sn,
				db_svr_id : $("#db_svr_id", "#findList").val()
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
				if(result == null){
					msgVale = "<spring:message code='menu.scale_execute_hist' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');

					$("#d_process_id").html("");
					$("#d_ipadr").html("");
					$("#d_scale_type_nm").html("");
					$("#d_wrk_type_nm").html("");
					$("#d_auto_policy_nm").html("");
					$("#d_wrk_strt_dtm").html("");
					$("#d_wrk_end_dtm").html("");
					$("#d_wrk_dtm").html("");
					$("#d_wrk_stat").html("");				
					$("#d_exe_rslt_cd_nm").html("");

					$('#pop_layer_log').modal('hide');
					return;
				}else{
					$("#d_process_id").html(nvlPrmSet(result.process_id, "-"));
					$("#d_ipadr").html(nvlPrmSet(result.ipadr, "-"));

 					if (result.scale_type == "1") {
 						scale_type_nm = '<spring:message code="etc.etc38" />';
 					} else {
 						scale_type_nm = '<spring:message code="etc.etc39" />';
 					}
					$("#d_scale_type_nm").html(scale_type_nm);
					
					if (result.wrk_type == "TC003301") {
						execute_type_nm += "<div class='badge badge-pill badge-success'>";
						execute_type_nm += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
						execute_type_nm += result.wrk_type_nm;
						execute_type_nm += "</div>";
 					} else {
 						execute_type_nm += "<div class='badge badge-pill badge-warning'>";
 						execute_type_nm += "	<i class='fa fa-user-o mr-2'></i>";
 						execute_type_nm += result.wrk_type_nm;
						execute_type_nm += "</div>";
 					}
					$("#d_wrk_type_nm").html(nvlPrmSet(execute_type_nm, "-"));

					if (result.wrk_type == "TC003301") {
						if (typeof result.policy_type_nm == "undefined") {
							auto_policy_nm += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
							auto_policy_nm += '<i class="mdi mdi-gender-transgender"></i>';
							auto_policy_nm += '<spring:message code="eXperDB_scale.msg32" />';
							auto_policy_nm += "</div>";
						} else {
							if (result.policy_type_nm == "CPU") {
								auto_policy_nm += "<div class='badge badge-pill badge-info'>";
								auto_policy_nm += '<i class="mdi mdi-vector-square"></i>';
								auto_policy_nm += result.policy_type_nm;
								auto_policy_nm += "</div>";
							} else {
								auto_policy_nm += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
								auto_policy_nm += '<i class="mdi mdi-gender-transgender"></i>';
								auto_policy_nm += result.policy_type_nm;
								auto_policy_nm += "</div>";
							}

							auto_policy_nm += " (";
							
		 					if (result.auto_policy_set_div == "1") {
		 						auto_policy_nm += '<spring:message code="eXperDB_scale.policy_time_1" />';
		 					} else {
		 						auto_policy_nm += '<spring:message code="eXperDB_scale.policy_time_2" />';
		 					}
		 					
		 					auto_policy_nm += ' ' + result.auto_level;
		 					
	 						if (result.auto_policy == "TC003501") {
	 							auto_policy_nm += '%';
							}
	 						
	 						auto_policy_nm += ' ' + result.auto_policy_time + "minutes) ";
	 						
	 						if (result.scale_type == "1") {
	 							auto_policy_nm += '<spring:message code="eXperDB_scale.under" />';
	 						} else {
	 							auto_policy_nm += '<spring:message code="eXperDB_scale.or_more" />';
	 						}
						}
					}
					$("#d_auto_policy_nm").html(nvlPrmSet(auto_policy_nm, "-"));

					$("#d_wrk_strt_dtm").html(nvlPrmSet(result.wrk_strt_dtm, "-"));
					$("#d_wrk_end_dtm").html(nvlPrmSet(result.wrk_end_dtm, "-"));
					$("#d_wrk_dtm").html(nvlPrmSet(result.wrk_dtm, "-"));

					if (result.wrk_id == "1") {
						wrk_stat = '<div class="loader-scale-box"><div class="dot-opacity-loader"><span></span><span></span><span></span><span></span></div><span class="text-warning"><spring:message code="restore.progress" /></span></div>';
					} else if (result.wrk_id == "2") {
						wrk_stat += "<div class='badge badge-pill' style='color: #fff;background-color: #6600CC;'>";
						wrk_stat += '<i class="fa fa-check"></i>';
						wrk_stat += '<spring:message code="eXperDB_scale.complete" />';
						wrk_stat += "</div>";
					} else {
						wrk_stat = "-";
					}
					$("#d_wrk_stat").html(wrk_stat);

 					if (result.exe_rslt_cd == 'TC001701' && result.wrk_id == '2') {
 						exe_rslt_cd_nm += "<div class='badge badge-pill badge-primary'>";
 						exe_rslt_cd_nm += '<i class="fa fa-check"></i>';
 						exe_rslt_cd_nm += '<spring:message code="common.success" />';
 						exe_rslt_cd_nm += "</div>";
					} else if(result.exe_rslt_cd == 'TC001702' && result.wrk_id == '2') {
 						exe_rslt_cd_nm += "<div class='badge badge-pill badge-danger'>";
 						exe_rslt_cd_nm += '<i class="ti-close"></i>';
 						exe_rslt_cd_nm += '<spring:message code="common.failed" />';
 						exe_rslt_cd_nm += "</div>";
					} else {
						exe_rslt_cd_nm += '<div class="loader-scale-box"><div class="dot-opacity-loader"><span></span><span></span><span></span><span></span></div><span class="text-warning"><spring:message code="etc.etc28" /></span></div>';
 					}					
					$("#d_exe_rslt_cd_nm").html(exe_rslt_cd_nm);

					$('#pop_layer_log').modal("show");
				}
		
			}
		});	
	}

	/* ********************************************************
	 * ERROR 로그 정보 출력
	 ******************************************************** */
	function fn_scaleFailLog(scale_wrk_sn){
		$.ajax({
			url : "/scale/selectScaleWrkErrorMsg.do",
			data : {
				scale_wrk_sn : scale_wrk_sn,
				db_svr_id : $("#db_svr_id", "#findList").val()
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
				if (result != null) {

 					if (nvlPrmSet(result.rslt_msg,"") == "Auto scale-in_fail") {
						result.rslt_msg = '<spring:message code="eXperDB_scale.msg11" />';
					} else if (nvlPrmSet(result.rslt_msg,"") == "Auto scale-out_fail") {
						result.rslt_msg = '<spring:message code="eXperDB_scale.msg12" />';
					}
 					
 					if (result.rslt_msg != "") {
 						result.rslt_msg = fn_strBrReplcae(result.rslt_msg);
 					}

					$("#d_scaleWrkLogInfo").html(result.rslt_msg);

					$('#pop_layer_err_msg').modal("show");
				} else {
 					$("#d_scaleWrkLogInfo").html("");

					$('#pop_layer_err_msg').modal("hide");
				}
			}
		});	
	}

	/* ********************************************************
	 * 수동확장 메뉴이동
	 ******************************************************** */
	function fnc_menuMove() {
		$('#pop_layer_err_msg').modal("hide");
		var moveId = "scaleList" + $("#db_svr_id", "#findList").val();

		parent.fn_treeMenu_move(moveId);
		
		//location.href='/scale/scaleList.do?db_svr_id=' + $("#db_svr_id", "#findList").val();
	}
</script>

<%@include file="./experdbScaleLogInfo.jsp"%>
<%@include file="./scaleWrkLog.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
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
												<span class="menu-title"><spring:message code="menu.eXperDB_scale_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.eXperDB_scale"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.eXperDB_scale_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_scale_history_01"/></p>
											<p class="mb-0"><spring:message code="help.eXperDB_scale_history_02"/></p>
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
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('executeHist');" >
								<spring:message code="menu.scale_execute_hist" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('occurHist');">
								<spring:message code="menu.scale_auto_occur_hist" />
							</a>
						</li>
					</ul>

					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">
							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row">
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="height:44px;" id="wrk_strt_dtm" name="wrk_strt_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
												
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="height:44px;" id="wrk_end_dtm" name="wrk_end_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 search_execute col-sm-1_5">
									<select class="form-control" name="exe_rslt_cd" id="exe_rslt_cd" style="margin-left: -0.7rem;margin-right: -0.7rem;">
										<option value=""><spring:message code="common.status" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="1"><spring:message code="common.success" /></option>
										<option value="2"><spring:message code="common.failed" /></option>
									</select>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" name="scale_type_cd" id="scale_type_cd" style="margin-right: -0.7rem;">
										<option value=""><spring:message code="eXperDB_scale.scale_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
										<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 search_occur col-sm-1_5">
									<select class="form-control" name="policy_type_cd" id="policy_type_cd" style="margin-right: -0.7rem;">
										<option value=""><spring:message code="eXperDB_scale.policy_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${policyTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 search_occur col-sm-1_7">
									<select class="form-control" name="execute_type_cd" id="execute_type_cd" style="margin-right: -0.7rem;">
										<option value=""><spring:message code="eXperDB_scale.execute_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${executeTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 search_execute col-sm-2_5" >
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="process_id_set" name="process_id_set" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_scale.process_id" />' maxlength="20" />
								</div>
									
								<div class="input-group mb-2 mr-sm-2 search_execute col-sm-1_5">
<%-- 										<div class="input-group-prepend">
											<div class="input-group-text" style="color: #248afd;margin-right: 0.5rem;"><spring:message code="eXperDB_scale.wrk_type" /></div>
										</div>
										 --%>	
									<select class="form-control" style="width:200px;" name="wrk_type_Cd" id="wrk_type_Cd">
										<option value=""><spring:message code="eXperDB_scale.wrk_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${wrkTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
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
								<div class="col-12" id="logExecuteHistListDiv">
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

	 								<table id="scaleExecuteHistList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="eXperDB_scale.process_id" /></th>
												<th width="100"><spring:message code="eXperDB_scale.scale_type" /></th>
												<th width="80"><spring:message code="eXperDB_scale.wrk_type" /></th>
												<th width="220"><spring:message code="eXperDB_scale.auto_policy_nm" /></th>
												<th width="90"><spring:message code="eXperDB_scale.work_start_time" /></th>
												<th width="90"><spring:message code="eXperDB_scale.work_end_time" /></th>
												<th width="90"><spring:message code="eXperDB_scale.working_time" /></th>
												<th width="100"><spring:message code="eXperDB_scale.progress" /></th>
												<th width="100"><spring:message code="common.status" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
							 	
								<div class="col-12" id="logOccurHistListDiv">
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

	 								<table id="logOccurHistList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="eXperDB_scale.scale_type" /></th>
												<th width="100"><spring:message code="eXperDB_scale.execute_type" /></th>												
												<th width="100"><spring:message code="eXperDB_scale.policy_type" /></th>
												<th width="200"><spring:message code="eXperDB_scale.auto_policy_nm" /></th>
												<th width="200"><spring:message code="eXperDB_scale.occur_hist" /></th>
												<th width="100"><spring:message code="eXperDB_scale.occur_time" /></th>
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