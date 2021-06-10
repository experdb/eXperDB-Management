<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : bckVolumeForm.jsp
	* @Description : 백업 볼륨 필터 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-06-10	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.06.10
	*
	*/
%>

<script type="text/javascript">

var targetList;

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_targetTableSetting();
	});


	function fn_targetTableSetting(){
		targetList = $('#targetList').DataTable({
				scrollX : false,
				searching : false,
				processing : true,
				paging : false,
				deferRender : true,
				info : false,
				bSort : false,
				// selected : [1],
				select : {'style' : 'multi'},
				columns : [
				{data : "mac", className : "dt-center", defaultContent : "" },
				{data : "ip", defaultContent : ""},
				{data : "netmask", defaultContent : ""},
				{data : "gateway", className : "dt-center", defaultContent : ""},
				{data : "dns", className : "dt-center", defaultContent : ""}
				
				]
			});
		 
		targetList.tables().header().to$().find('th:eq(0)').css('min-width');
		targetList.tables().header().to$().find('th:eq(1)').css('min-width');
		targetList.tables().header().to$().find('th:eq(2)').css('min-width');
		targetList.tables().header().to$().find('th:eq(3)').css('min-width');
		targetList.tables().header().to$().find('th:eq(4)').css('min-width');
		 $(window).trigger('resize');
	}	
 
function fn_targetListCancel(){
	$("#pop_layer_popup_recoveryTargetList").modal('hide');
}

function fn_recTargetDBRegPopup(){
	$("#pop_layer_popup_recTargetDBRegForm").modal('show');
}
	
</script>
<style>
table.dataTable.volume tbody tr.selected {
	color : #333333
}
</style>
	
<div class="modal fade" id="pop_layer_popup_recoveryTargetList" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<div class="row">
					<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
						Target DB List
					</h5>
				</div>
				<div class="card" style="border:0px;">
					<div class="card-body" style="padding-top: 0px; padding-bottom: 0px;">					
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text btn-sm btn-search-disable" onClick="fn_recTargetDBRegPopup()">
								등록
							</button>
						</div>
					</div>
					<div class="card-body" style="padding-top: 0px;">
						<table id="targetList" class="table table-hover volume table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100">MAC</th>
									<th width="150">IP</th>
									<th width="150">SUBNET MASK</th>
									<th width="150">GATEWAY</th>
									<th width="100">DNS</th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="card-body">
						<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
							<button type="button" class="btn btn-primary" id="regButton" onclick="">확인</button>
							<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_targetListCancel()"><spring:message code="common.cancel"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>