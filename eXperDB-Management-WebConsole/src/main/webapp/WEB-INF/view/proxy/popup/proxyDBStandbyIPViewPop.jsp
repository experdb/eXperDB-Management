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

var proxyDBStandbyListTable = "";

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
				{data : "ipadr", className : "dt-center", defaultContent : "" },
				{data : "portno", className : "dt-center", defaultContent : "" },
				{data : "db_cndt", className : "dt-center", defaultContent : "" },
			]
		});
	
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px'); // db host name
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px'); // db ip 
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); // db ip 
		proxyDBStandbyListTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px'); // db ip 
		
		$(window).trigger('resize');
	}
	
	/* *******************************************************
 	* config 파일 불러오기
 	******************************************************** */
	function fn_proxyDBStandbyViewAjax(db_svr_id) {
		// var pry_svr_id = $("pry_svr_id", "configForm").val();
		// var type = $("type", "configForm").val();
		console.log(db_svr_id);
		
		$.ajax({
			url : "/proxyMonitoring/configViewAjax.do",
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
					// var v_fileSize = Number($("#fSize", "#configForm").val());
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
		var contentsGbn_chk = $("#contents_gbn", "#configForm").val();
		$("#pop_db_standby_ip_list_view").modal("hide");
		
		if (contentsGbn_chk != null && contentsGbn_chk != "") {
			$("#"+ contentsGbn_chk).modal("show");
		}
	}
	
</script>

<div class="modal fade config-modal" id="pop_db_standby_ip_list_view" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel-3" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-sm" role="document" style="margin-top:450px; margin-left:1050px;">
		<div class="modal-content">
<!-- 			<div class="modal-body" style="margin-bottom:-30px;"> -->
					<div class="modal-content" style="width:600px;height:260px;">
			
				<h4 class="modal-title mdi mdi-alert-circle text-info config_title" id="ModalLabel" style="height:50px;padding:15px;">
<!-- 					Proxy Configuration -->
					DB Standby IP 목록
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
<!-- 							<fieldset> -->
<!-- 								<div class="form-group row"> -->
<!-- 									<div class="col-sm-12"> -->
<!-- 										<textarea class="form-control" id="config" name="config" style="height: 400px;" readonly></textarea> -->
<%-- 										<textarea class="form-control" id="config" name="config" style="height: 400px;" readonly>${data}</textarea> --%>
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
<!-- 									</div> -->
<!-- 								</div> -->

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_proxyDBStandbyIPPopcl();"><spring:message code="common.close"/></button>
								</div>
<!-- 							</fieldset> -->
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
