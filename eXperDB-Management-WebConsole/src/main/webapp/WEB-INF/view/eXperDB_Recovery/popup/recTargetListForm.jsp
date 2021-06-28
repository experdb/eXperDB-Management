<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : recTargetListForm.jsp
	* @Description : 복구DB리스트
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

var TargetList;
var ipList=[];

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_targetTableSetting();
	});
	
	$(function() {
	    $('#targetList tbody').on( 'click', 'tr', function () {
	          if ( $(this).hasClass('selected') ) {
	          }
	         else {              
	        	 TargetList.$('tr.selected').removeClass('selected');
	             $(this).addClass('selected');      

	         } 
	     } );   
	 } );    

	function fn_targetTableSetting(){
		TargetList = $('#targetList').DataTable({
				scrollX : false,
				searching : false,
				processing : true,
				paging : false,
				deferRender : true,
				info : false,
				bSort : false,
				// selected : [1],
				select : {'style' : 'single'},
				columns : [
					{data : "guestMac", className : "dt-center", defaultContent : "" },
					{data : "guestIp", defaultContent : ""},
					{data : "guestSubnetmask", defaultContent : ""},
					{data : "guestGateway", className : "dt-center", defaultContent : ""},
					{data : "guestDns", className : "dt-center", defaultContent : ""},
					{data : "machineId",  defaultContent : "", visible: false }
				]
			});
		 
		TargetList.tables().header().to$().find('th:eq(0)').css('min-width');
		TargetList.tables().header().to$().find('th:eq(1)').css('min-width');
		TargetList.tables().header().to$().find('th:eq(2)').css('min-width');
		TargetList.tables().header().to$().find('th:eq(3)').css('min-width');
		TargetList.tables().header().to$().find('th:eq(4)').css('min-width');
		 $(window).trigger('resize');
	}	
	
	function fn_recMachineReg(){
		var data = TargetList.rows('.selected').data()[0];
		if(data.length<1){
			showSwalIcon('복구DB를 선택해주세요', '<spring:message code="common.close" />', '', 'error');
		}else{
			$("#recMachineMAC").val(data.guestMac);
			$("#recMachineIP").val(data.guestIp);
			$("#recoveryDB").val(data.guestIp);
			$("#recMachineSNM").val(data.guestSubnetmask);
			$("#recMachineGateWay").val(data.guestGateway);
			$("#recMachineDNS").val(data.guestDns);
			$("#pop_layer_popup_recoveryTargetList").modal('hide');
		}
		
	}
	
	function fn_recMachineDelConfirm(){
		console.log("## fn_recMachineDelConfirm ##")
		var data = TargetList.rows('.selected').data();
		if(data.length < 1){
			showSwalIcon('삭제할 복구DB를 선택해주세요', '<spring:message code="common.close" />', '', 'error');
		}else{
			confile_title = '복구DB 삭제';
			$('#con_multi_gbn', '#findConfirmMulti').val("recoveryDB_del");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('선택한 복구DB 정보를 삭제하시겠습니까?');
			$('#pop_confirm_multi_md').modal("show");
		}
	}
	
	function fn_recMachineDel(){
		console.log("## fn_recMachineDel ##");
		$.ajax({
			url : "/experdb/recoveryDBDelete.do",
			type : "post",
			data : {
				machineId : TargetList.row('.selected').data().machineId
			}
		})
		.done(function(data){
			fn_targetListPopup();
			console.log("## fn_recMachineDel done ##");
		})
		.fail (function(xhr, status, error){
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if (xhr.status == 403){
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		})
	}
	
	function fn_setIpList(data){
		var size = data.length;
		ipList = [];
		for(var i=0;i<size;i++){
			ipList.push(data[i].guestIp);
		}
	}
	
	function fn_fileRead(){
		var formData = new FormData();
		
		formData.append("serverInfoFile", $("#recSvrInfoFile")[0].files[0]);
		
		$.ajax({
			url : "/experdb/serverInfoFileRead.do",
			data : formData,
			processData: false,
			contentType: false,
			dataType : "json",
			type : "post"
		})
		.done(function(data){
			fn_serverInfoSetting(data.serverInfo);
			$("#pop_layer_popup_recTargetDBRegForm").modal('show');
		})
		.fail(function(){
			
		})
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
							<input class="btn btn-inverse-primary btn-icon-text btn-sm btn-search-disable" style="margin-left:-20px;" type="button" onClick="document.getElementById('recSvrInfoFile').click();" value='추가' />
							<input class="btn btn-inverse-danger btn-icon-text btn-sm btn-search-disable" style="" type="button" onClick="fn_recMachineDelConfirm()" value='삭제' />
							<input type="file"  id="recSvrInfoFile" style="margin-left:-20px; display:none;" value="등록" onChange="fn_fileRead()">
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
							<button type="button" class="btn btn-primary" id="regButton" onclick="fn_recMachineReg()">확인</button>
							<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_targetListCancel()"><spring:message code="common.cancel"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>