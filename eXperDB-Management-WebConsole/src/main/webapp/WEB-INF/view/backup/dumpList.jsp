<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : workList.jsp
	* @Description : 백업 목록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2017.06.07     최초 생성
	*  2017.10.23 	 변승우			테이블 -> 데이터테이블 변환
    *	
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>
<script src="/vertical-dark-sidebar/js/backup_common.js"></script>

<script type="text/javascript">
	var tableRman = null;
	var tableDump = null;
	var selectChkTab = "rman";
	var searchInit = "";
	var tabGbn = "${tabGbn}";
	var bck_wrk_id_List = [];
	var wrk_id_List = [];
	var confile_title = "";
	var immediate_data = null;
	var workJsonData = null;
	var scheduleTable = null;
	$(window).ready(function(){
		//검색조건 초기화
		selectInitTab(selectChkTab);
		
		//스케줄 테이즐 setting
		fn_init_schedule();

			//조회
		if(tabGbn != ""){
			selectTab(tabGbn);
		}else{
			selectTab("rman");
		}
			
		$('#rmanDataTable tbody').on('click','tr',function() {
			var wrk_id_up = tableRman.row(this).data().wrk_id;
			
			fn_schdule_pop_List(wrk_id_up);
		});
		
		$('#dumpDataTable tbody').on('click','tr',function() {
			var wrk_id_up = tableDump.row(this).data().wrk_id;
			
			fn_schdule_pop_List(wrk_id_up);
		});
	});

	//스케줄 테이블
	function fn_init_schedule(){
		/* ********************************************************
		* work리스트
		******************************************************** */
		scheduleTable = $('#scheduleList').DataTable({
			scrollY : "305px",
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
				{data : "rownum",  className : "dt-center", defaultContent : ""}, 		
				{data : "scd_nm", className : "dt-left", defaultContent : ""
					,render: function (data, type, full) {
						  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold" title="'+full.scd_nm+'">' + full.scd_nm + '</span>';
					}
				},
				{ data : "scd_exp",
						render : function(data, type, full, meta) {	 	
							var html = '';					
							html += '<span title="'+full.scd_exp+'">' + full.scd_exp + '</span>';
							return html;
						},
						defaultContent : ""
					},
				{data : "wrk_cnt",  className : "dt-right", defaultContent : ""}, //work갯수
				{data : "prev_exe_dtm",  defaultContent : ""
					,render: function (data, type, full) {
					if(full.prev_exe_dtm == null){
						var html = '-';
						return html;
					}
				  return data;
				}}, 
				{data : "nxt_exe_dtm",  defaultContent : ""
					,render: function (data, type, full) {
						if(full.nxt_exe_dtm == null){
							var html = '-';
							return html;
						}
					  return data;
				}}, 
				{data : "status", 
					render: function (data, type, full){
						var html = "";
						if(full.scd_cndt == "TC001801"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-minus-circle mr-2'></i>";
							html += "<spring:message code='common.waiting' />";
							html += "</div>";
						}else if(full.scd_cndt == "TC001802"){
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "<spring:message code='dashboard.running' />";
							html += "</div>";
						}else{
							html += "<div class='badge badge-pill badge-danger'>";
							html += "	<i class='ti-close mr-2'></i>";
							html += "<spring:message code='schedule.stop' />";
							html += "</div>";
						}

						return html;
					},
					className : "dt-center",
					 defaultContent : "" 	
				},

				{data : "status", 
					render: function (data, type, full){	
						var html = "";
						if(full.scd_cndt == "TC001801"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-minus-circle mr-2'></i>";
							html += "<spring:message code='access_control_management.activation' />";
							html += "</div>";
						}else if(full.scd_cndt == "TC001802"){
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "<spring:message code='dashboard.running' />";
							html += "</div>";
						}else{
							html += "<div class='badge badge-pill badge-danger'>";
							html += "	<i class='ti-close mr-2'></i>";
							html += "<spring:message code='etc.etc41' />";
							html += "</div>";
						}		

						return html;
					},
					className : "dt-center",
					defaultContent : "" 	
				},
				{
					data : "",
					render: function (data, type, full) {				
						  return '<button id="detail" class="btn btn-outline-primary" onClick=javascript:fn_dblclick_pop_scheduleInfo("'+full.scd_id+'");><spring:message code="data_transfer.detail_search" /> </button>';
					},
					className : "dt-center",
					defaultContent : "",
					orderable : false
				},
				{data : "scd_id",  defaultContent : "", visible: false },
				{data : "exe_dt",  defaultContent : "", visible: false },
			]
		});

		//더블 클릭시
		$('#scheduleList tbody').on('dblclick','tr',function() {
			var scd_id_up = scheduleTable.row(this).data().scd_id;

			fn_dblclick_pop_scheduleInfo(scd_id_up);
		});
		
		scheduleTable.tables().header().to$().find('th:eq(1)').css('min-width', '30px');	  
		scheduleTable.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		scheduleTable.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		scheduleTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
		scheduleTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(7)').css('min-width', '80px');  
		scheduleTable.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		scheduleTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
	    $(window).trigger('resize'); 
	}

	/* ********************************************************
	 * Rman Data Table initialization
	 ******************************************************** */
	function fn_rman_init(){
		tableRman = $('#rmanDataTable').DataTable({
			scrollY: "300px",
			scrollX : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
						{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
						{data : "idx", className : "dt-center", defaultContent : ""},
						{data : "wrk_nm", className : "dt-left", defaultContent : ""
							,"render": function (data, type, full) {				
								return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" data-toggle="modal" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
							}
						},
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

								return html;
							},

						},
						{data : "data_pth",
							render : function(data, type, full, meta) {	 	
								var html = '';					
								html += '<span title="'+full.data_pth+'">' + full.data_pth + '</span>';
								return html;
							},
							defaultContent : ""
						},
						{data : "bck_pth", className : "dt-left", defaultContent : ""
							,"render": function (data, type, full) {
								return '<span onClick=javascript:fn_rmanShow("'+full.bck_pth+'","'+full.db_svr_id+'"); data-toggle="modal" title="'+full.bck_pth+'" class="bold">' + full.bck_pth + '</span>';
							}
						},
						{data : "frst_regr_id", className: "dt-center", defaultContent : ""},
						{data : "frst_reg_dtm", className: "dt-center", defaultContent : ""},
						{data: "lst_mdfr_id", className: "dt-center", defaultContent: ""}, 
						{data: "lst_mdf_dtm", className: "dt-center", defaultContent: ""}, 
						{data : "bck_wrk_id", defaultContent : "", visible: false }
			],'select': {'style': 'multi'}
		});

		tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
		tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '230px');
		tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '230px');
		tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '110px');  
		tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		tableRman.tables().header().to$().find('th:eq(11)').css('min-width', '0px');

		$(window).trigger('resize'); 
	}

	/* ********************************************************
	 * 삭제 confirm
	 ******************************************************** */
	function fn_work_delete_confirm() {
		var datas = null;

		if(selectChkTab == "rman"){
			datas = tableRman.rows('.selected').data();
		} else {
			datas = tableDump.rows('.selected').data();
		}

		bck_wrk_id_List = [];
		wrk_id_List = [];

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg16"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if(selectChkTab == "rman"){
			for (var i = 0; i < datas.length; i++) {
				bck_wrk_id_List.push( tableRman.rows('.selected').data()[i].bck_wrk_id);   
				wrk_id_List.push( tableRman.rows('.selected').data()[i].wrk_id);   
			}
		} else {
			for (var i = 0; i < datas.length; i++) {
				bck_wrk_id_List.push( tableDump.rows('.selected').data()[i].bck_wrk_id);   
				wrk_id_List.push( tableDump.rows('.selected').data()[i].wrk_id);   
			}
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				//스케줄이 돌지 않고 있는 경우만 다음 실행
				if(data != null && data != 0 ){
					showSwalIcon('<spring:message code="backup_management.reg_schedule_delete_no"/>', '<spring:message code="common.close" />', '', 'error'); 
					return;
				}

				confile_title = '<spring:message code="backup_management.dumpBck"/>' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';

				if(selectChkTab == "rman"){
					$('#con_multi_gbn', '#findConfirmMulti').val("del_rman");
				} else {
					$('#con_multi_gbn', '#findConfirmMulti').val("del_dump");
				}

				$('#confirm_multi_tlt').html(confile_title);
				$('#confirm_multi_msg').html('<spring:message code="message.msg17" />');
				$('#pop_confirm_multi_md').modal("show");
			}
		});	
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_deleteWork(gbn) {
		$.ajax({
			url : "/popup/workDelete.do",
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if(result == true){
					showSwalIcon('<spring:message code="message.msg18" />', '<spring:message code="common.close" />', '', 'success');
					
					if (gbn == "del_rman") {
						fn_get_rman_list();
					} else {
						fn_get_dump_list();
					}
				}else{
					msgVale = "<spring:message code='backup_management.dumpBck' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * 즉시실행 백업
	 ******************************************************** */
	function fn_ImmediateStartConfirm(){
		var datas = null;
		var rowCnt = null;
		
		immediate_data = null;

		if(selectChkTab == 'rman'){
			datas = tableRman.rows('.selected').data();
			rowCnt = tableRman.rows('.selected').data().length;
		}else{
			datas = tableDump.rows('.selected').data();
			rowCnt = tableDump.rows('.selected').data().length;
		}

		if(rowCnt <= 0){
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
			return;	
		}else if(rowCnt > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		immediate_data = datas;

		confile_title = '<spring:message code="backup_management.dumpBck"/>' + " " + '<spring:message code="migration.run_immediately" />' + " " + '<spring:message code="common.request" />';

		$('#con_multi_gbn', '#findConfirmMulti').val("run_immediately");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="backup_management.msg01" />');
		$('#pop_confirm_multi_md').modal("show");
	}
	
	/* ********************************************************
	 * 즉시실행 DDL
	 ******************************************************** */
	function fn_ImmediateStart() {
 		$.ajax({
			url : "/backupImmediateExe.do",
			data : {
				wrk_id:immediate_data[0].wrk_id,
				db_svr_id:immediate_data[0].db_svr_id, 
				bck_bsn_dscd:immediate_data[0].bck_bsn_dscd
			},
			//timeout : 1000,
			type : "post",
			async: true,
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					if (xhr.responseText != null) {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : ", '<spring:message code="common.close" />', '', 'error');
					}
				}
			},
			success : function(result) {
				showSwalIconRst('<spring:message code="backup_management.msg02" />' + '\n' + '<spring:message code="backup_management.msg03" />', '<spring:message code="common.close" />', '', 'success', 'backup');
			}
		});
	}

	/* ********************************************************
	 * backup history 이동
	 ******************************************************** */
	function fn_backupHistory_move() {
		var id = "workLogList" + $("#db_svr_id", "#findList").val();
		location.href='/backup/workLogList.do?db_svr_id='+$("#db_svr_id", "#findList").val()+'&tabGbn='+selectChkTab;
		parent.fn_GoLink(id);
	}

	/* ********************************************************
	 * 수정버튼 클릭시 
	 ******************************************************** */
	function fn_rereg_popup(){
		var reregUrl = "";
		var datas = null;
		var bck_wrk_id = "";
		var wrk_id = "";
		
		if (selectChkTab == "rman") {
			datas = tableRman.rows('.selected').data();
			
			reregUrl = "/popup/rmanRegReForm.do";
		} else {
			datas = tableDump.rows('.selected').data();
			
			reregUrl = "/popup/dumpRegReForm.do";
		}
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
			return;	
		} else if (datas.length > 1) {
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'warning');
			return;	
		}
		
		if (selectChkTab == "rman") {
			bck_wrk_id = tableRman.row('.selected').data().bck_wrk_id;
			wrk_id = tableRman.row('.selected').data().wrk_id;
		} else {
			bck_wrk_id = tableDump.row('.selected').data().bck_wrk_id;
			wrk_id = tableDump.row('.selected').data().wrk_id;
		}
			
		$.ajax({
			url : reregUrl,
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				bck_wrk_id : bck_wrk_id,
				wrk_id : wrk_id
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
				
				if (result.workInfo != null) {
					fn_update_chogihwa(selectChkTab, result);

					if (selectChkTab == "rman") {
						$('#rman_call_gbn', '#search_rmanReForm').val("");

						$('#pop_layer_mod_rman').modal("show");
					} else {
						$('#dump_call_gbn', '#search_dumpReForm').val("");
						
						$('#pop_layer_mod_dump').modal("show");
					}
				} else {
					showSwalIcon('<spring:message code="info.nodata.msg" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
</script>

<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../popup/rmanShow.jsp"%>
<%@include file="../popup/dumpShow.jsp"%>
<%@include file="../popup/rmanRegForm.jsp"%>
<%@include file="../popup/dumpRegForm.jsp"%>
<%@include file="../popup/rmanRegReForm.jsp"%>
<%@include file="../popup/dumpRegReForm.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./../popup/scheduleWrkList.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="bck"  id="bck">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
	<input type="hidden" name="scd_id"  id="scd_id">
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
												<i class="fa fa-cog"></i>
												<span class="menu-title"><spring:message code="menu.backup_settings"/></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.backup_settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.backup_settings_01"/></p>
											<p class="mb-0"><spring:message code="help.backup_settings_03"/></p>
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
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="selectTab('rman');" >
								<spring:message code="backup_management.rman_backup" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="selectTab('dump');">
								<spring:message code="backup_management.dumpBck"/>
							</a>
						</li>
					</ul>

					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px 0px -15px 0px;">

							<form class="form-inline row" id="findSearch">
									<div class="input-group mb-2 mr-sm-2 col-sm-2">
										<input hidden="hidden" />
										<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="25" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="message.msg107" />' />
									</div>
		
									<div class="input-group mb-2 mr-sm-2 col-sm-1_7 search_rman">
										<select class="form-control" name="bck_opt_cd" id="bck_opt_cd">
											<option value=""><spring:message code="backup_management.backup_option" />&nbsp;<spring:message code="schedule.total" /></option>
											<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
											<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
											<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
										</select>
									</div>
		
									<div class="input-group mb-2 mr-sm-2 col-sm-1_7 search_dump" style="display:none;">
										<select class="form-control" name="db_id" id="db_id">
											<option value=""><spring:message code="common.database" />&nbsp;<spring:message code="schedule.total" /></option>
											<c:forEach var="result" items="${dbList}" varStatus="status">
													<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
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

		<div class="col-sm-12 stretch-card div-form-margin-table" id="left_list">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">					
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete">
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
								
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnImmediately">
									<i class="ti-control-forward btn-icon-prepend "></i><spring:message code="migration.run_immediately" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12" id="rmanDataTableDiv">
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

	 								<table id="rmanDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="30"><spring:message code="common.no" /></th>
												<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
												<th width="200" class="dt-center"><spring:message code="common.work_description" /></th>
												<th width="100"><spring:message code="backup_management.backup_option" /></th>
												<th width="230" class="dt-center"><spring:message code="backup_management.data_dir" /></th>
												<th width="230" class="dt-center"><spring:message code="backup_management.backup_dir" /></th>
												<%-- <th width="230" class="dt-center"><spring:message code="backup_management.backup_log_dir" /></th> --%>
												<th width="100"><spring:message code="common.register" /> </th>
												<th width="110"><spring:message code="common.regist_datetime" /></th>
												<th width="100"><spring:message code="common.modifier" /></th>
												<th width="100"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
											</tr>
										</thead>
									</table>
							 	</div>
							 	
								<div class="col-12" id="dumpDataTableDiv" style="diplay:none;">
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

	 								<table id="dumpDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="30"><spring:message code="common.no" /></th>
												<th width="200"><spring:message code="common.work_name" /></th>
												<th width="200"><spring:message code="common.work_description" /></th>
												<th width="130"><spring:message code="common.database" /></th>
												<th width="250"><spring:message code="backup_management.backup_dir" /></th>
												<th width="60"><spring:message code="backup_management.file_format" /></th>
												<th width="100"><spring:message code="backup_management.compressibility" /></th>
												<th width="100"><spring:message code="backup_management.incording_method" /></th>
												<th width="100"><spring:message code="backup_management.rolename" /></th>
												<th width="90"><spring:message code="backup_management.file_keep_day" /></th>
												<th width="150"><spring:message code="backup_management.backup_maintenance_count" /></th>
												<th width="70"><spring:message code="common.register" /></th>
												<th width="110"><spring:message code="common.regist_datetime" /></th>
												<th width="70"><spring:message code="common.modifier" /></th>
												<th width="100"><spring:message code="common.modify_datetime" /></th>
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

		<div class="col-sm-0_5" style="display:none;" id="center_div" >
			<div class="card" style="background-color: transparent !important;border:0px;top:30%;position: inline-block;">
				<div class="card-body" style="" onclick="fn_schedule_leftListSize();">	
					<i class='fa fa-angle-double-right text-info' style="font-size: 35px;cursor:pointer;"></i>
				</div>
			</div>
		</div>

		<div class="col-sm-6_3 stretch-card div-form-margin-table" id="right_list" style="display:none;" >
			<div class="card">
				<div class="card-body">	
					<div class="card my-sm-2">
						<div class="card-body" >
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
	
							<table id="scheduleList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="30"><spring:message code="common.no" /></th>							
										<th width="120"><spring:message code="schedule.schedule_name" /></th>
										<th width="200"><spring:message code="schedule.scheduleExp"/></th>
										<th width="50"><spring:message code="schedule.work_count" /></th>
										<th width="100"><spring:message code="schedule.pre_run_time" /></th>
										<th width="100"><spring:message code="schedule.next_run_time" /></th>
										<th width="80"><spring:message code="common.run_status" /></th>
										<th width="100"><spring:message code="etc.etc26"/></th>
										<th width="100"><spring:message code="data_transfer.detail_search" /></th>
										<th width="0"></th>
										<th width="0"></th>
									</tr>
								</thead>
							</table>
					 	</div>	
				 	</div>
				</div>
			</div>
		</div>
	</div>
</div>