<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : scriptHistory.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 변승우
	* since 2017.06.07
	*
	*/
%>
<script type="text/javascript">
	var table = null;

	$(window.document).ready(function() {
		//table setting
		fn_init();

		//작업기간 calender setting
		dateCalenderSetting();
		
		//조회
		fn_search();

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			var wrk_strt_dtm = $("#wrk_strt_dtm").val();
			var wrk_end_dtm = $("#wrk_end_dtm").val();

			if (wrk_strt_dtm != "" && wrk_end_dtm == "") {
				showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}

			if (wrk_end_dtm != "" && wrk_strt_dtm == "") {
				showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}

			fn_search();
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
	 * 실행이력 테이블 setting
	 ******************************************************** */
	function fn_init(){
   		table = $('#scriptHistory').DataTable({	
		scrollY: "350px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_scriptLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		},
		    		{ data : "wrk_exp",
		    			render : function(data, type, full, meta) {	 	
		    				var html = '';					
		    				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
		    				return html;
		    			},
		    			defaultContent : ""
		    		},
		    		{data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
		    		{data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
		    		{data: "wrk_dtm", className: "dt-center", defaultContent: ""}, 
		    		{
	 					data : "exe_rslt_cd_nm",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += '<i class="fa fa-check text-primary">';
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
 								html += '<button type="button" class="btn btn-inverse-success btn-fw" onclick="javascript:fn_fixLog('+full.exe_sn+', \'script\');">';
 								html += '<i class="fa fa-times"></i>';
 								html += '<spring:message code="etc.etc29"/>';
 								html += "</button>";
 	 						} else if(full.fix_rsltcd == 'TC002002'){
 	 							html += '<button type="button" class="btn btn-inverse-success btn-fw" onclick="javascript:fn_fixLog('+full.exe_sn+', \'script\');">';
 								html += '<i class="fa fa-times"></i>';
 								html += '<spring:message code="etc.etc30"/>';
 								html += "</button>";
 	 						} else {
	 							if(full.exe_rslt_cd == 'TC001701'){
	 								html += ' - ';
	 							}else{
	 								html += '<button type="button" class="btn btn-inverse-warning btn-fw" onclick="javascript:fn_fix_rslt_reg('+full.exe_sn+', \'script\');">';
	 		 						html += '<i class="fa fa-times"></i>';
	 		 						html += '<spring:message code="backup_management.Enter_Action"/>';
	 		 						html += "</button>";
	 							}	 
	 						}

	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
 		        ]
		});
   	
	   	table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	   	table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	   	table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');

    	$(window).trigger('resize'); 
	}

	/* ********************************************************
	 *  배치 이력 리스트
	 ******************************************************** */
	 function fn_search(){
		$.ajax({
			url : "/selectScriptHistoryList.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_strt_dtm : $("#wrk_strt_dtm").val(),
			  	wrk_end_dtm : $("#wrk_end_dtm").val(),
			  	exe_rslt_cd : $("#exe_rslt_cd").val(),
			  	wrk_nm : $('#wrk_nm').val()
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
				table.rows({selected: true}).deselect();
				table.clear().draw();
	
				if (nvlPrmSet(result, "") != '') {
					table.rows.add(result).draw();
				}
			}
		});
	}
</script>

<%@include file="../cmmn/workScriptInfo.jsp"%>
<%@include file="../cmmn/fixRsltMsgInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>

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
												<span class="menu-title"><spring:message code="menu.script_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.script_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.script_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.script_history_01"/></p>
											<p class="mb-0"><spring:message code="help.script_settings_02"/></p>
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
						<div class="card-body" style="margin:-10px -10px -15px 0px;">

							<form class="form-inline row" onsubmit="return false;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
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
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" name="exe_rslt_cd" id="exe_rslt_cd">
										<option value=""><spring:message code="common.status" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</div>
									
								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input type="text" class="form-control" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />' maxlength="25" />
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
								<div class="col-12">
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

	 								<table id="scriptHistory" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="common.work_name" /></th>
												<th width="100"><spring:message code="common.work_description" /></th>
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
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>