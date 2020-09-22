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
	var dumpshow_table = null;

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		//table 셋팅
		fn_dumpshow_pop_init();
	});
	
	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_dumpshow_pop_init() {
		dumpshow_table = $('#dumpShowList').DataTable({
			scrollY : "330px",
			scrollX : true,
			bDestroy: true,
			processing : true,
			searching : false,	
			bSort: false,
			columns : [
			   		{data : "file_name",  defaultContent : ""},
			   		{data : "file_size", className : "dt-right",  defaultContent : ""
						,"render": function (data, type, full) {
							var html = "";
							
							if(full.file_size != "0" && full.file_size != "----" && full.file_size != "0Byte" && full.file_size != ""){
								html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
								html += "	<i class='ti-files text-primary' >";
								html += '&nbsp;' + full.file_size + '</i>';
								html += "</div>";
							}else{
								html += full.file_size;
							}
							
							return html;
						}
			   		}, 
			   		{data : "file_lastmodified",  defaultContent : ""}
			]
		});
	
		dumpshow_table.tables().header().to$().find('th:eq(0)').css('min-width', '400px');
		dumpshow_table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
		dumpshow_table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	
		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 내역 조회
	 ******************************************************** */
	function fn_dumpshow_pop_search() {
	 	$.ajax({
			url : "/dumpShow.do",
			data : {
				db_svr_id: $("#dumpInfo_db_svr_id", "#dumpshowForm").val(),
				cmd : $("#dumpInfo_bck", "#dumpshowForm").val()
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
				dumpshow_table.clear().draw();

				if (result.data != null) {
					dumpshow_table.rows.add(result.data).draw();
				}
			}
		}); 
	 	$('#loading').hide();
	}
</script>

<form name="dumpshowForm" id="dumpshowForm" method="post">
	<input type="hidden" name="dumpInfo_bck"  id="dumpInfo_bck"  value="">
	<input type="hidden" name="dumpInfo_db_svr_id"  id="dumpInfo_db_svr_id"  value="">
</form>

<div class="modal fade" id="pop_layer_dump_show" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 350px;">
		<div class="modal-content" style="width:1000px;" id="pop_layer_dump_show_view">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					DUMP <spring:message code='common.backInfo' />
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
	
									<table id="dumpShowList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th scope="col"><spring:message code='backup_management.fileName' /></th>
												<th scope="col"><spring:message code='common.volume' /></th>
												<th scope="col"><spring:message code='common.modify_datetime' /></th>
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