<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : proxyDBStandbyIPViewPop.jsp
	* @Description : 프록시 연결 db standby ip 확인 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 윤정 매니저
	* since 2021.05.04
	*
	*/
%>
<script type="text/javascript">

	var proxyDBStandbyListTable = null;

 	$(window.document).ready(function() {
 		fn_db_standby_list_init();
 		
 	});
 	
	function fn_db_standby_list_init(){
		proxyDBStandbyListTable = $('#proxyDBStandbyListTable').DataTable({
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : '<spring:message code="message.msg01" />'
			},
			columns : [
				{data : "rownum", className : "dt-center", defaultContent : "", visible: false},
				{data : "svr_host_nm", className : "dt-center", defaultContent : ""},
				{data : "ipadr", 
					render : function(data, type, full, meta) {
						var html = full.ipadr;
						if (full.intl_ipadr != "") {
							html += '<br/>(<spring:message code="eXperDB_proxy.internal_ip" /> :' + full.intl_ipadr + ')';
						}
						return html;
					},
					className : "dt-center", defaultContent : "" },
				{data : "portno", className : "dt-center", defaultContent : "" },
				{data : "db_cndt", 
					render : function(data, type, full, meta) {
						var html = "";
						if(data == "Y"){
							db_exe_status_chk = "text-success";
							db_exe_status_css = "fa-refresh fa-spin text-success";
							db_exe_status_val = 'running';
						} else {
							db_exe_status_chk = "text-danger";
							db_exe_status_css = "fa-times-circle text-danger";
							db_exe_status_val = 'stop';
						}
						html += '			<h6 class="text-muted" style="padding-left:10px;"><i class="fa '+db_exe_status_css+' icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>' + db_exe_status_val + '</h6>\n';
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
			]
		});
	
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // db host name
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // db ip 
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // db port 
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // db 상태
		
		$(window).trigger('resize');
	}
	
	/* *******************************************************
 	* db standby ip list 불러오기
 	******************************************************** */
	function fn_proxyDBStandbyViewAjax(db_svr_id) {
		
		$.ajax({
			url : "/proxyMonitoring/dbStandbyListAjax.do",
			dataType : "json",
			type : "post",
 			data : {
 				db_svr_id : db_svr_id,
 			},
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
					proxyDBStandbyListTable.clear().draw();
					if(nvlPrmSet(result.selectDBStandbyIPList, '') != '') {
						proxyDBStandbyListTable.rows.add(result.selectDBStandbyIPList).draw();
					}
				}
			}
		});
	}
 	
 	
	/* ********************************************************
	 * 창닫기
	 ******************************************************** */
	function fn_proxyDBStandbyIPPopcl() {
		$("#pop_db_standby_ip_list_view").modal("hide");
	}
	
</script>

<div class="modal fade config-modal" id="pop_db_standby_ip_list_view" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel-3" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-sm" role="document" style="margin-top:450px; margin-left:1050px;">
		<div class="modal-content">
					<div class="modal-content" style="width:600px;height:260px;">
			
				<h4 class="modal-title mdi mdi-alert-circle text-info db_standby_title" id="ModalLabel" style="height:50px;padding:15px;">
					<spring:message code="eXperDB_proxy.db_standby_list"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="configForm">
							<input type="hidden" name="contents_gbn" id="contents_gbn" value="" />
							<input type="hidden" name="pry_svr_id" id="pry_svr_id" value="${pry_svr_id}" />
							<input type="hidden" name="type" id="type" value="${type}" />
							<input type="hidden" name="seek" id="seek" value="0"/>
							<input type="hidden" name="endFlag" id="endFlag" value="0"/>
							<input type="hidden" name="dwLen" id="dwLen" value="0"/>
									 		<table id="proxyDBStandbyListTable" class="table table-striped system-tlb-scroll" style="width:100%;border:none;">
												<thead>
					 								<tr class="bg-info text-white">
					 									<th width="0px;">rownum</th>
														<th width="50px;"><spring:message code="properties.host"/></th>
														<th width="50px;"><spring:message code="properties.ip"/></th>
														<th width="50px;"><spring:message code="eXperDB_proxy.port"/></th>
														<th width="50px;"><spring:message code="schedule.exeState"/></th>
													</tr>
												</thead>
											</table>

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_proxyDBStandbyIPPopcl();"><spring:message code="common.close"/></button>
								</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
