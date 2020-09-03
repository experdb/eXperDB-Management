<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : scheduleWrkList.jsp
	* @Description : 
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
	var workPoptable = null;

	/* ********************************************************
	 * 내역 조회
	 ******************************************************** */
	function fn_workpop_search() {
	 	$.ajax({
			url : "/selectWrkScheduleList.do",
			data : {
				scd_id : $("#scd_id", "#findList").val()	
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
				workPoptable.rows({selected: true}).deselect();
				workPoptable.clear().draw();
				workPoptable.rows.add(result).draw();
			}
		}); 
	}

	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_workpop_init() {
		var popName = "pop_layer_info_schedule";
		
		workPoptable = $('#workPopList').DataTable({
			scrollY : "245px",
			scrollX : true,
			bDestroy: true,
			processing : true,
			searching : false,	
			bSort: false,
			columns : [
				{data : "idx", className : "dt-center", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]],  defaultContent : ""},
				{data : "wrk_id",  defaultContent : "", visible: false },
				{data : "db_svr_nm",  defaultContent : ""}, //서버명
				{data : "bsn_dscd_nm",  defaultContent : ""},
				{data : "bck_bsn_dscd_nm",  defaultContent : ""}, //구분
				{data : "wrk_nm", className : "dt-left", defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";
							if(full.bsn_dscd_nm != "MIGRATION"){
								html +='<span onClick="fn_workLayer(\''+full.wrk_id+'\');" class="bold" >' + full.wrk_nm + '</span>';
				  				return html;
							}else{
								return '<span title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
							}
						}
				}, //work명
				{ data : "wrk_exp",
					render : function(data, type, full, meta) {	 	
						var html = '';					
						html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
						return html;
					},
					defaultContent : ""
				},
				{data : "nxt_exe_yn", className: "dt-center", defaultContent: ""}
			]
		});

		workPoptable.on( 'order.dt search.dt', function () {
			workPoptable.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();

	    workPoptable.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	    workPoptable.tables().header().to$().find('th:eq(1)').css('min-width', '0px');
	   	workPoptable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	   	workPoptable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	   	workPoptable.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	   	workPoptable.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
	   	workPoptable.tables().header().to$().find('th:eq(6)').css('min-width', '300px');
	   	workPoptable.tables().header().to$().find('th:eq(7)').css('min-width', '80px');

    	$(window).trigger('resize'); 
	}
</script>

<%@include file="./../cmmn/workScriptInfoPop.jsp"%>

<div class="modal fade" id="pop_layer_info_schedule" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:1060;">

	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="schedule.workList" />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<div class="form-group row">
							<div class="card my-sm-2 col-12">
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
	
									<table id="workPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"><spring:message code="common.no" /></th>
												<th width="0"></th>
												<th width="100"><spring:message code="data_transfer.server_name" /></th>
												<th width="100"><spring:message code="common.division" /></th>	
												<th width="130"><spring:message code="backup_management.detail_div"/></th>		
												<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
												<th width="300" class="dt-center"><spring:message code="common.work_description" /></th>
												<th width="80"><spring:message code="schedule.onerror" /></th>
											</tr>
										</thead>
									</table>
					 			</div>	
				 			</div>
						</div>
						

						<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
							<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>