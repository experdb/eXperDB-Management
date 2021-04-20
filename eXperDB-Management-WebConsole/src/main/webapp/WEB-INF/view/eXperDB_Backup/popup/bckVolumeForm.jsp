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
	*  2021-04-20	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.04.20
	*
	*/
%>

<script type="text/javascript">

var volumeList;

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_volumeTableSetting();
			
	});
	
	// loader
/* 	$(function(){
		$(document).ajaxStart(function() {	
		    $("#loader").show();	
		});
		
		//AJAX 통신 종료
		$(document).ajaxStop(function() {
			$("#loader").hide();
		});
	}); */

	function fn_volumeTableSetting(){
		 volumeList = $('#volumeList').DataTable({
				scrollY : "250px",
				scrollX : false,
				searching : false,
				processing : true,
				paging : false,
				deferRender : true,
				info : false,
				bSort : false,
				columns : [
				{data : "rownum", className : "dt-center", defaultContent : "" , checkboxes : {'selectRow' : true}},
				{data : "volumeName", className : "dt-center", defaultContent : ""},
				{data : "fileSystem", className : "dt-center", defaultContent : ""},
				{data : "type", className : "dt-center", defaultContent : ""}
				
				]
			});

		 volumeList.tables().header().to$().find('th:eq(1)').css('min-width');
		 volumeList.tables().header().to$().find('th:eq(2)').css('min-width');
		 volumeList.tables().header().to$().find('th:eq(3)').css('min-width');
		 volumeList.tables().header().to$().find('th:eq(4)').css('min-width');
		 
		 $(window).trigger('resize');
	}	
 

</script>
	
<div class="modal fade" id="pop_layer_popup_backupVolumeFilter" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
					Volume Filter Setting
				</h5>
				<div class="card" style="border:0px;">
					<div class="card-body">
						<table id="volumeList" class="table table-hover table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100"></th>
									<th width="150">Volume Name</th>
									<th width="150">File System</th>
									<th width="100">Type</th>
								</tr>
							</thead>
						</table>
					</div>
					<div class="card-body">
						<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
							<button type="button" class="btn btn-primary" id="regButton" onclick=""><spring:message code="common.registory"/></button>
							<button type="button" class="btn btn-light" data-dismiss="modal" onclick=""><spring:message code="common.cancel"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>