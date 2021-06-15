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

var VolumeList;
var rootCheck = true;
var bootCheck = true;
	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_volumeTableSetting();
	});
	
	$(function() {
		
		$("#volumeList").change(function(){
			console.log("volumeList CHANGE!!!");
			fn_bmrCheck();
		});
		
		$('#volumeList tbody').on( 'click', 'tr', function () {
			console.log("tbody click!!!");
			if($(this).is('.selected')){
				$(this).removeClass('selected');
			}else{
				$(this).addClass('selected'); 
			}
			fn_bmrCheck();
		});
		
	 });   
	
	// /, /boot를 선택했는지 확인
	function fn_bmrCheck(){
		var vData = VolumeList.rows('.selected').data();
		rootCheck = true;
		bootCheck = true;
		for(var i=0; i<vData.length; i++){
			if(vData[i].mountOn == "/"){
				rootCheck = false;
				break;
			}
		}
		for(var i=0; i<vData.length; i++){
			if(vData[i].mountOn == "/boot"){
				bootCheck = false;
				break;
			}
		}
		fn_bmrAlert();
	}
	
	// /, /boot 선택 유무에 따라 알림
	function fn_bmrAlert(){
		var str;
		$("#volumeAlert").empty();
		if(rootCheck&&bootCheck){
			str = '[ /, /boot ] <spring:message code="eXperDB_backup.msg92" />';
			$("#volumeAlert").append(str);
		}else if(rootCheck){
			str = '[ / ] <spring:message code="eXperDB_backup.msg92" />';
			$("#volumeAlert").append(str);
		}else if(bootCheck){
			str = '[ /boot ] <spring:message code="eXperDB_backup.msg92" />';
			$("#volumeAlert").append(str);
		}
		
	}
	function fn_volumeTableSetting(){
		 VolumeList = $('#volumeList').DataTable({
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
				{data : "rownum", className : "dt-center", defaultContent : "" , checkboxes : {'selectRow' : true}},
				{data : "mountOn", defaultContent : ""},
				{data : "filesystem", defaultContent : ""},
				{data : "used", className : "dt-center", defaultContent : ""},
				{data : "type", className : "dt-center", defaultContent : ""}
				
				]
			});
		 
		 VolumeList.tables().header().to$().find('th:eq(0)').css('min-width');
		 VolumeList.tables().header().to$().find('th:eq(1)').css('min-width');
		 VolumeList.tables().header().to$().find('th:eq(2)').css('min-width');
		 VolumeList.tables().header().to$().find('th:eq(3)').css('min-width');
		 VolumeList.tables().header().to$().find('th:eq(4)').css('min-width');
		 $(window).trigger('resize');
	}	
 
	/* ********************************************************
	 * get volume list
	 ******************************************************** */
	function fn_getVolumes(serverIp){
		$.ajax({
			url : '/experdb/getVolumes.do',
			type : 'post',
			data : {
				ipadr : serverIp
			},
			success : function(result) {
				VolumeList.clear().draw();
				VolumeList.rows.add(result.data).draw();
				fn_volumeSetting(result.data);
			},
			beforeSend : function(xhr) {
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
			}
		});
	}
	
	/* ********************************************************
	 * volume selected setting
	 ******************************************************** */
	function fn_volumeSetting(data){
		// volumeDataList에 데이터가 없을 경우 (선택된 Volume이 없을 경우) -> default All selected
		if(volumeDataList.length == 0){
			for(var i =0 ; i<data.length; i++){
				$('input', VolumeList.rows(i).nodes()).prop('checked', true); 
				VolumeList.rows(i).nodes().to$().addClass('selected');
			}
		}else{	// volumeDataList에 데이터가 있을 경우(선택된 Volume이 있을 경우) -> volumeDataList에 있는 Volume만 selected
			for(var i =0 ; i<data.length; i++){
				// selected를 풀어준 뒤
				$('input', VolumeList.rows(i).nodes()).prop('checked', false); 
				VolumeList.rows(i).nodes().to$().removeClass('selected');
				for(var j = 0; j<volumeDataList.length; j++){
					if(volumeDataList[j].mountOn == data[i].mountOn){
						// volumeDataList에 존재하면 checked 해준다
						$('input', VolumeList.rows(i).nodes()).prop('checked', true); 
						VolumeList.rows(i).nodes().to$().addClass('selected');
						break;
					} 
				}
			}
		}
		fn_bmrCheck();
	}
	
	/* ********************************************************
	 * volume registration
	 ******************************************************** */
	function fn_volumeReg() {
		// 선택된 volume들을 volumeDataList에 넣어준다
		var vSelect = VolumeList.rows('.selected').data();
		if(vSelect.length > 0){			
			volumeDataList = VolumeList.rows('.selected').data();
			fn_alertShow();
			$('#pop_layer_popup_backupVolumeFilter').modal("hide");
		}else{
			showSwalIcon('<spring:message code="eXperDB_backup.msg93" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
	}
	
	function fn_volumeCancel() {
		$('#pop_layer_popup_backupVolumeFilter').modal("hide");
	}
	
</script>
<style>
table.dataTable.volume tbody tr.selected {
	color : #333333
}
</style>
	
<div class="modal fade" id="pop_layer_popup_backupVolumeFilter" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
					Volume Filter Setting
				</h5>
				<div class="card" style="border:0px;">
					<div class="card-body">
						<table id="volumeList" class="table table-hover volume table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
							<thead>
								<tr class="bg-info text-white">
									<th width="100"></th>
									<th width="150">Volume Name</th>
									<th width="150">File System</th>
									<th width="150">Used</th>
									<th width="100">Type</th>
								</tr>
							</thead>
						</table>
						<div id="volumeAlert" class="text-danger" style="font-size:0.8em;">
							
						</div>
					</div>
					<div class="card-body">
						<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
							<button type="button" class="btn btn-primary" id="regButton" onclick="fn_volumeReg()"><spring:message code="common.choice"/></button>
							<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_volumeCancel()"><spring:message code="common.cancel"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>