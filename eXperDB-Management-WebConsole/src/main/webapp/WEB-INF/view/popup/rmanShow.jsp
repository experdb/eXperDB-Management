<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : fixRsltMsg.jsp
	* @Description : 조치입력 화면
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
	var rmanshow_table = null;

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		//table 셋팅
		fn_rmanshow_pop_init();
	});
	
	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_rmanshow_pop_init() {
		rmanshow_table = $('#rmanShowList').DataTable({
			scrollY : "330px",
			scrollX : true,
			bDestroy: true,
			processing : true,
			searching : false,	
			bSort: false,
			columns : [
			   		{data : "START_TIME",  defaultContent : "", 
			   			"render": function (data, type, full) {
			   				var html = full.START_DATE+' '+full.START_TIME ;
			   					return html;
			   					return data;
			   			}
			   		},
					{data : "END_TIME",  defaultContent : "", 
						"render": function (data, type, full) {
							var html = full.END_DATE+' '+full.END_TIME ;
								return html;
								return data;
						}
					},
					{data : "MODE",  defaultContent : "", 
						"render": function (data, type, full) {
							var html = '';

							if (full.MODE == 'FULL') {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='fa fa-paste mr-2 text-success'></i>";
								html += '<spring:message code="backup_management.full_backup" />';
								html += "</div>";									
							} else if(full.MODE == 'ARCH'){
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
						}
					},
					{data : "DATA", className : "dt-right",  defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";

							if(full.DATA != "0B" && full.DATA != "----" && full.DATA != ""){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files' >";
								html += '&nbsp;' + full.DATA + '</i>';
								html += "</div>";
							}else{
								html += full.DATA;
							}
							
							return html;
						}
					}, 
					{data : "ARCLOG", className : "dt-right",  defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";
							
							if(full.ARCLOG != "0B" && full.ARCLOG != "----" && full.ARCLOG != ""){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files' >";
								html += '&nbsp;' + full.ARCLOG + '</i>';
								html += "</div>";
							}else{
								html += full.ARCLOG;
							}
							
							return html;
						}
					}, 
					{data : "SRVLOG",className : "dt-right" ,  defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";
							
							if(full.SRVLOG != "0B"  && full.SRVLOG != "----" && full.SRVLOG != ""){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files' >";
								html += '&nbsp;' + full.ARCLOG + '</i>';
								html += "</div>";
							}else{
								html += full.SRVLOG;
							}
							
							return html;
						}
					}, 
					{data : "TOTAL", className : "dt-right",  defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";
							
							if(full.TOTAL != "0B" && full.TOTAL != ""){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files text-primary' >";
								html += '&nbsp;' + full.TOTAL + '</i>';
								html += "</div>";
							}else{
								html += full.TOTAL;
							}
							
							return html;
						}
					}, 
					{data : "COMPRESSED",  defaultContent : "", 
		    			"render": function (data, type, full) {				
		    				var html = "";

		    				if (full.COMPRESSED == 'true') {
		    					html += "<div class='badge badge-pill badge-info text-white'>";
		    					html += "	<i class='fa fa-file-zip-o mr-2'></i>";
		    					html += '<spring:message code="agent_monitoring.yes"/>';
		    					html += "</div>";
		    				} else {
		    					html += "<div class='badge badge-pill badge-light' style='background-color: transparent !important;'>";
		    					html += "	<i class='fa fa-file-zip-o mr-2'></i>";
		    					html +='<spring:message code="agent_monitoring.no"/>';
		    					html += "</div>";
		    				}

		    				return html;
		    			}
					}, 
					{data : "STATUS",  defaultContent : "", 
						render : function(data, type, full, meta) {
							var html = '';
							if (full.STATUS == 'OK') {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='fa fa-check-circle text-primary' >";
								html += '&nbsp;<spring:message code="common.success" /></i>';
								html += "</div>";
							} else {
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='fa fa-times text-danger' >";
								html += '&nbsp;<spring:message code="common.failed" /></i>';
								html += "</div>";
							}
							return html;
						}
					}
			]
		});
		
		rmanshow_table.tables().header().to$().find('th:eq(0)').css('min-width', '125px');
		rmanshow_table.tables().header().to$().find('th:eq(1)').css('min-width', '125px');
		rmanshow_table.tables().header().to$().find('th:eq(2)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(3)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(4)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(5)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(6)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(7)').css('min-width', '75px');
		rmanshow_table.tables().header().to$().find('th:eq(8)').css('min-width', '75px');
			
		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 내역 조회
	 ******************************************************** */
	function fn_rmanshow_pop_search() {
	 	$.ajax({
			url : "/rmanShow.do",
			data : {
				db_svr_id: $("#rmanInfo_db_svr_id", "#rmanshowForm").val(),
				cmd : $("#rmanInfo_bck", "#rmanshowForm").val()
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
				rmanshow_table.clear().draw();

				if (result.data != null) {
					rmanshow_table.rows.add(result.data).draw();

/*  					if (result.data.length > 0) {
						$('#pop_layer_rman_show_view').css("width", "1340px");
					} else {
						$('#pop_layer_rman_show_view').css("width", "1250px");
					} */
				} else {
/* 				 	$('#pop_layer_rman_show_view').css("width", "1250px"); */
				}
			}
		}); 
	 	$('#loading').hide();
	}
</script>

<form name="rmanshowForm" id="rmanshowForm" method="post">
	<input type="hidden" name="rmanInfo_bck"  id="rmanInfo_bck"  value="">
	<input type="hidden" name="rmanInfo_db_svr_id"  id="rmanInfo_db_svr_id"  value="">
</form>

<div class="modal fade" id="pop_layer_rman_show" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" >
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 200px;">
		<div class="modal-content" style="width:1250px;" id="pop_layer_rman_show_view">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Online <spring:message code='common.backInfo' />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<div class="form-group row">
							<div class="card my-sm-2 col-sm-12">
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
	
									<table id="rmanShowList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th scope="col"><spring:message code='etc.etc16' /></th>
												<th scope="col"><spring:message code='etc.etc17' /></th>
												<th scope="col"><spring:message code='backup_management.backup_option' /></th>
												<th scope="col"><spring:message code='etc.etc18' /></th>
												<th scope="col"><spring:message code='etc.etc19' /></th>
												<th scope="col"><spring:message code='etc.etc20' /></th>
												<th scope="col"><spring:message code='etc.etc21' /></th>
												<th scope="col"><spring:message code='etc.etc22' /></th>
												<th scope="col"><spring:message code='etc.etc25' /></th>
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