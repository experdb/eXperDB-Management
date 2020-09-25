<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs2.jsp"%>
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
		//button setting
		fn_buttonAut();
		
		//table setting
		fn_init_main_scdH();
		
		fn_init_scdH();

		//작업기간 calender setting
		dateCalenderSetting();
		
		var exe_result = "${exe_result}";
		var svr_nm = "${svr_nm}";
		var scd_nm = "${scd_nm}";
		var wrk_nm = "${wrk_nm}";
		if(exe_result == "" || exe_result==null){
			document.getElementById("exe_result").value="%";
		}else{
			document.getElementById("exe_result").value=exe_result;
		}
		
		//조회
		fn_selectScheduleHistory();
	});
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function fn_buttonAut(){
		if("${read_aut_yn}" == "Y"){
			$("#read_button").show();
		}else{
			$("#read_button").hide();
		}
	}
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate());
		var day_start = today.toJSON().slice(0,10); 

		$("#lgi_dtm_start").val(day_start);
		$("#lgi_dtm_end").val(day_end);

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
		
		$("#lgi_dtm_start").datepicker('setDate', day_start);
	    $("#lgi_dtm_end").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	    
		var lgi_dtm_start_val = "${lgi_dtm_start}";
		var lgi_dtm_end_val = "${lgi_dtm_end}";
		if (lgi_dtm_start_val != "" && lgi_dtm_end_val != "") {
			$('#lgi_dtm_start').val(lgi_dtm_start);
			$('#lgi_dtm_end').val(lgi_dtm_end);
		}
	}

	/* ********************************************************
	 * 테이블 setting
	 ******************************************************** */
	function fn_init_main_scdH(){
   		table = $('#accessHistoryTable').DataTable({	
		scrollY: "305px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "scd_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
		    			}
		    		},
		    		{data: "db_svr_nm", className: "dt-center", defaultContent: ""}, 
		    		{data: "ipadr", className: "dt-center", defaultContent: ""}, 
		    		{data: "wrk_strt_dtm", className: "dt-center", defaultContent: ""}, 
		    		{data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
		    		{data: "wrk_end_dtm", className: "dt-center", defaultContent: ""}, 
		    		{
	 					data : "exe_rslt_cd_nm",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.exe_rslt_cd == 'TC001701') {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='fa fa-check-circle text-primary' >";
								html += '&nbsp;<spring:message code="common.success" /></i>';
								html += "</div>";

	 						} else if(full.exe_rslt_cd == 'TC001702'){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='fa fa-times text-danger' >";
								html += '&nbsp;<spring:message code="common.failed" /></i>';
								html += "</div>";
	 						} else {
								html += "<div class='badge badge-pill badge-warning' style='color: #fff;'>";
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
	 					data : "exe_sn",
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						html += '<button type="button" id="detail" class="btn btn-inverse-primary btn-fw" onclick="fn_detail('+full.exe_sn+')"><spring:message code="schedule.detail_view" /> </button>';
	 						return html;
	 					},
	 					className : "dt-center",
	 					defaultContent : ""
	 				}
 		        ]
		});
   	
	   	table.tables().header().to$().find('th:eq(0)').css('min-width', '5%');
	   	table.tables().header().to$().find('th:eq(1)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(2)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(3)').css('min-width', '15%');
	   	table.tables().header().to$().find('th:eq(4)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(5)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(7)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(8)').css('min-width', '10%');

    	$(window).trigger('resize'); 
	}
	
	/* ********************************************************
	 *  배치 이력 리스트
	 ******************************************************** */
	 function fn_selectScheduleHistory(){
		var lgi_dtm_start = $("#lgi_dtm_start").val();
		var lgi_dtm_end = $("#lgi_dtm_end").val();

		if (lgi_dtm_start != "" && lgi_dtm_end == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		if (lgi_dtm_end != "" && lgi_dtm_start == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		$.ajax({
			url : "/selectScheduleHistoryNew.do",
			data : {
				db_svr_nm : $("#db_svr_nm").val(),
				lgi_dtm_start : $("#lgi_dtm_start").val(),
				lgi_dtm_end : $("#lgi_dtm_end").val(),
				scd_nm : $("#scd_nm").val(),
				exe_result : $("#exe_result").val(),
				order_type : $("#order_type").val(),
				order : $('#order').val()
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
	
	/* ********************************************************
	 *  상세조회
	 ******************************************************** */
	function fn_detail(exe_sn){
 		$.ajax({
			url : "/selectScheduleHistoryWorkDetail.do",
			data : {
				exe_sn : exe_sn
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
				workTable_history.clear().draw();
				workTable_history.rows.add(result).draw();
		
				fn_scd_deatil(exe_sn);
				$('#pop_layer_scd_history').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 *  상세조회설정
	 ******************************************************** */
 	function fn_scd_deatil(exe_sn){
		$.ajax({
			url : "/popup/scheduleHistoryDetail.do",
			data : {
				exe_sn : exe_sn,
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
				var results= result.result[0];
				$("#scd_history_info").empty();
				var html ='<table class="table table-striped system-tlb-scroll" style="border:1px solid #99abb0;">';
				html +='<colgroup><col style="width:15%;" /><col style="width:85%;" /></colgroup>';
				html +='<tbody>';
				html +='<tr><td><spring:message code="schedule.schedule_name" /></td><td style="text-align: left"><span onClick="javascript:fn_scdLayer('+results.scd_id+');" class="bold">'+results.scd_nm+'</span></td></tr>'
				html +='<tr><td><spring:message code="schedule.work_start_datetime" /></td><td style="text-align: left">'+results.wrk_strt_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.work_end_datetime" /></td><td style="text-align: left">'+results.wrk_end_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.jobTime"/></td><td style="text-align: left">'+results.wrk_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.scheduleExp"/></td><td style="text-align: left">'+results.scd_exp+'</td></tr>';
				html  +='</tbody></table>';
				$("#scd_history_info").append(html);
			}
		});
	}
</script>

<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>
<%@include file="../../popup/scheduleHistoryDetail.jsp"%>

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
												<i class="ti-calendar menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.shedule_execution_history" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">SCHEDULE</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.schedule_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.shedule_execution_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.shedule_execution_history" /></p>
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
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_start" name="lgi_dtm_start" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_end" name="lgi_dtm_end" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input type="text" class="form-control" style="margin-left: -0.7rem;margin-right: -0.7rem;" id="scd_nm" name="scd_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="schedule.schedule_name" />' value="${scd_nm}"/>		
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="db_svr_nm" name="db_svr_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.dbms_name" />' value="${svr_nm}"/>	
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="exe_result" id="exe_result">
										<option value="%"><spring:message code="schedule.result" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-left:-0.7rem;margin-right: -0.7rem;" name="order_type" id="order_type">
										<option value="wrk_strt_dtm" ${order_type == 'wrk_strt_dtm' ? 'selected="selected"' : ''}><spring:message code="schedule.work_start_datetime" /></option>
										<option value="wrk_end_dtm" ${order_type == 'wrk_end_dtm' ? 'selected="selected"' : ''}><spring:message code="schedule.work_end_datetime" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" name="order" id="order">
										<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option>
										<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>		
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button"onclick="fn_selectScheduleHistory()" >
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

	 								<table id="accessHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<colgroup>
											<col style="width: 5%;" />
											<col style="width: 10%;" />
											<col style="width: 10%;" />
											<col style="width: 15%;" />
											<col style="width: 10%;" />
											<col style="width: 10%;" />
											<col style="width: 10%;" />
											<col style="width: 10%;" />
											<col style="width: 10%;" />
										</colgroup>
										<thead>
											<tr class="bg-info text-white">
												<th scope="col"><spring:message code="common.no" /></th>
												<th scope="col"><spring:message code="schedule.schedule_name" /></th>
												<th scope="col"><spring:message code="common.dbms_name" /></th>
												<th scope="col"><spring:message code="dbms_information.dbms_ip" /></th>
												<th scope="col"><spring:message code="schedule.work_start_datetime" /></th>
												<th scope="col"><spring:message code="schedule.work_end_datetime" /></th>
												<th scope="col"><spring:message code="schedule.jobTime"/></th>
												<th scope="col"><spring:message code="schedule.result" /></th>
												<th scope="col"><spring:message code="schedule.detail_view" /></th>
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