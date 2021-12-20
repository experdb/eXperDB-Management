<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : DB2pg 수행이력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2019.09.17     최초 생성
	*  2020.08.21   변승우 과장		UI 디자인 변경
	*	
	* author 변승우
	* since 2019.09.17
	*
	*/
%>


<script type="text/javascript">

var migtable = null;
	
	function fn_init(){
		migtable = $('#migHistoryTable').DataTable({
			scrollY : "330px",
			searching : false,
			processing : true,
			paging : false,
			deferRender : true,
			info : false,
			bSort : false,
			columns : [
				{data : "idx", className : "dt-center", defaultContent : ""}, 
				{data : "exe_date", className : "dt-center", defaultContent : ""}, 
				{data : "wrk_nm", className : "dt-center", defaultContent : ""}, 
				{data : "total_table_cnt", className : "dt-left", defaultContent : ""},
				{data : "mig_table_cnt", className : "dt-left", defaultContent : ""}, 
				{data : "start_time", className : "dt-center", defaultContent : ""},
				{data : "end_time", className : "dt-center", defaultContent : ""},
				{data : "elapsed_time", className : "dt-center", defaultContent : ""},			
				{
					data : "historyDetail",
					render : function(data, type, full, meta) {
						var html = '';	
							html += '<button type="button" class="btn  btn-inverse-primary btn-fw" onclick="fn_mig_tableInfo_popup(\''+full.mig_nm+'\')">';
							html += "	<i class='fa fa-check-circle text-primary' >";
							html += '&nbsp;Table Info</i>';
							html += "</button>";					
						return html;
					},
					className : "dt-center",
					defaultContent : ""
				},							
				{data : "mig_nm", className : "dt-center", defaultContent : "", visible: false}
			]
			});
		
		migtable.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		migtable.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		migtable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		migtable.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	  
		$(window).trigger('resize'); 
		
		//더블 클릭시
		 $('#migHistoryTable tbody').on('dblclick','tr',function() {		 
			  var mig_nm = migtable.row(this).data().mig_nm;
			  fn_mig_tableInfo_popup(mig_nm);			  
		});		
		
	}



/* ********************************************************
 * Data initialization
 ******************************************************** */
	$(window.document).ready(	
		function() {		
			fn_init();
			dateCalenderSetting();
			fn_selectMigHistory();
			
		}	
	);


/* ********************************************************
 * Migration 수행이력 조회
 ******************************************************** */
 	function fn_selectMigHistory(){

 		$.ajax({
 			url : "/db2pg/selectMigHistory.do", 
 		  	data : {
 		  		wrk_nm :  $("#wrk_nm").val(),
 		  		migStartDate :  $("#migStartDate").val(),
 		  		migEndDate : $("#migEndDate").val()
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
 				migtable.clear().draw();
 				migtable.rows.add(data).draw();
 			}
 		});
	}


	/* ********************************************************
	 * 수행이력 기간 calender 셋팅
	 ******************************************************** */
	 function dateCalenderSetting() {
			var today = new Date();
			var day_end = today.toJSON().slice(0,10);

			today.setDate(today.getDate() - 7);
			var day_start = today.toJSON().slice(0,10);

			$("#migStartDate").val(day_start);
			$("#migEndDate").val(day_end);

			if ($("#mig_strt_dtm_div").length) {
				$('#mig_strt_dtm_div').datepicker({
				}).datepicker('setDate', day_start)
				.on('hide', function(e) {
					e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			    })
			    .on('changeDate', function(selected){
			    	day_start = new Date(selected.date.valueOf());
			    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
			        $("#mig_strt_dtm_div").datepicker('setStartDate', day_start);
			        $("#migEndDate").datepicker('setStartDate', day_start);
				}); //값 셋팅
			}

			if ($("#mig_end_dtm_div").length) {
				$('#mig_end_dtm_div').datepicker({
				}).datepicker('setDate', day_end)
				.on('hide', function(e) {
					e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			    })
			    .on('changeDate', function(selected){
			    	day_end = new Date(selected.date.valueOf());
			    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
			        $('#mig_strt_dtm_div').datepicker('setEndDate', day_end);
			        $('#migStartDate').datepicker('setEndDate', day_end);
				}); //값 셋팅
			}
			
			$("#migStartDate").datepicker('setDate', day_start);
		    $("#migEndDate").datepicker('setDate', day_end);
		    $('#mig_strt_dtm_div').datepicker('updateDates');
		    $('#mig_end_dtm_div').datepicker('updateDates');
		}
	
	
	 /* ********************************************************
	  * Migration table info popoup
	  ******************************************************** */
	  /* function fn_mig_tableInfo_popup(mig_nm){
		 
		 $.ajax({
	 			url : "/db2pg/selectMigHistoryDetail.do", 
	 		  	data : {
	 		  		mig_nm : mig_nm
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
	 				alert(JSON.stringify(data));
	 				migTableinfo.clear().draw();
	 				migTableinfo.rows.add(data).draw();
	 			}
	 		});
		 		 
		  $('#pop_layer_tableInfo_reg').modal("show");
	 }  */
</script>

<%@include file="../popup/migTableInfo.jsp"%> 

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
												<span class="menu-title">MIGRATION <spring:message code="migration.performance_history" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">MIGRATION</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_migration" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">MIGRATION <spring:message code="migration.performance_history" /></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.mig_history_01" /></p>
											<p class="mb-0"><spring:message code="help.mig_history_02" /></p>
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
						<div class="card-body" style="margin:-10px -10px -15px -10px;">	
							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" style="margin-left: 0px;" >
									<div id="mig_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="migStartDate" name="migStartDate" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
									<div id="mig_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="migEndDate" name="migEndDate" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
								<div class="input-group mb-2 mr-sm-2 search_rman col-sm-3">
									<input type="text" class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" maxlength="25" name="wrk_nm" id="wrk_nm"  placeholder='<spring:message code="common.work_name" />'/>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button" onClick="fn_selectMigHistory();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
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

	 								<table id="migHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
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
												<th scope="col"><spring:message code="migration.exeDate" /></th>
												<th scope="col"><spring:message code="common.work_name" /></th>
												<th scope="col"><spring:message code="migration.table_totalcnt" /></th>
												<th scope="col"><spring:message code="migration.table_migcnt" /></th>
												<th scope="col"><spring:message code="migration.starttime" /></th>
												<th scope="col"><spring:message code="migration.endtime" /></th>
												<th scope="col"><spring:message code="migration.elapsedtime" /></th>
												<th scope="col"><spring:message code="migration.remark" /></th>
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

