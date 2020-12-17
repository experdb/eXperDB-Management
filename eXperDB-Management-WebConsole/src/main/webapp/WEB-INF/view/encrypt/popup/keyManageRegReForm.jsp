<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>


<%
	/**
	* @Class Name : keyManageRegReForm.jsp
	* @Description : keyManageRegReForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*  2020.08.04   변승우 과장		UI 디자인 변경
	
	
	* author 변승우 대리
	* since 2018.01.08
	*
	*/
%>

<script>
$(window.document).ready(function() {
	fn_mod_init();
});

var renewalhistoryTable = null;

 function fn_mod_init(){
	renewalhistoryTable = $('#renewalhistoryTable').DataTable({
		scrollY : "135px",
		searching : false,
		paging: false,
		scrollX: true,
		bSort: false,
		columns : [
		{ data : "no", className : "dt-center", defaultContent : ""},
		{ data : "version", className : "dt-right", defaultContent : ""},
		{ data : "keyStatusName", defaultContent : ""},
		{ data : "validEndDateTime", defaultContent : ""},
		{ data : "createName", defaultContent : ""},
		{ data : "createDateTime", defaultContent : ""},
		{ data : "updateName", defaultContent : ""},
		{ data : "updateDateTime", defaultContent : ""},
		{ data : "binuid", defaultContent : "", visible: false },
		{ data : "binstatuscode", defaultContent : "", visible: false }
		]
	});
	
	renewalhistoryTable.tables().header().to$().find('th:eq(0)').css('min-width', '25px');
	renewalhistoryTable.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
	renewalhistoryTable.tables().header().to$().find('th:eq(2)').css('min-width', '80px');
	renewalhistoryTable.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
	renewalhistoryTable.tables().header().to$().find('th:eq(4)').css('min-width', '80px');
	renewalhistoryTable.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
	renewalhistoryTable.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
	renewalhistoryTable.tables().header().to$().find('th:eq(7)').css('min-width', '130px');
	renewalhistoryTable.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
	renewalhistoryTable.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
    $(window).trigger('resize');
} 


$(function() {
	$("#renew").on('change', function() {
		  if ($(this).is(':checked')) {
		    $(this).attr('value', 'true');
		  } else {
		    $(this).attr('value', 'false');
		  }
		  
		  var renew = $("#renew").val();
		  
		 if(renew == "true"){
			$("#renewInsert").css("display", "");
		 }else{
			 $("#renewInsert").css("display", "none");
		 }
	});
	
	
	$("#copyBin").on('change', function() {
		  if ($(this).is(':checked')) {
		    $(this).attr('value', 'true');
		  } else {
		    $(this).attr('value', 'false');
		  }	 
	});
});


function fn_keyManagementModify(){
	
	var datas = renewalhistoryTable.rows().data();
	
	var datasArr = new Array();	
	for(var i=0; i<datas.length; i++){
		var rows = new Object();
		rows["binuid"] = renewalhistoryTable.rows().data()[i].binuid;	
		rows["binstatuscode"] = renewalhistoryTable.rows().data()[i].binstatuscode;	
		rows["validEndDateTime"] = renewalhistoryTable.rows().data()[i].validEndDateTime;	
		datasArr.push(rows);
	}

 $.ajax({
		url : "/updateCryptoKeySymmetric.do", 
	  	data : {
	  		keyUid : $('#mod_keyUid').val(),
	  		resourceUid : $('#mod_resourceUid').val(),
	  		resourceName: $('#mod_resourceName').val(),
	  		cipherAlgorithmCode : $('#mod_cipherAlgorithmCode').val(),
	  		resourceNote : $('#mod_resourceNote').val(),
	  		validEndDateTime : $('#mod_expr_dt').val().substring(0,10),
	  		renew : $("#renew").val(),
	  		copyBin : $("#copyBin").val(),
	  		historyCryptoKeySymmetric : JSON.stringify(datasArr),
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
			if(data.resultCode == "0000000000"){
				showSwalIcon('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success');
				fn_historyCryptoKeySymmetric();
			}else if(data.resultCode == "8000000002"){
				showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
			}else if(data.resultCode == "0000000003"){		
				showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
			}	
		}
	});	
}

function fn_historyCryptoKeySymmetric(){

	$.ajax({
		url : "/historyCryptoKeySymmetric.do", 
	  	data : {
	  		keyUid : $('#mod_keyUid').val(),
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
			if(data.resultCode == "0000000000"){
				renewalhistoryTable.clear().draw();
				renewalhistoryTable.rows.add(data.list).draw();
			}else if(data.resultCode == "8000000002"){
				showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');
			}else if(data.resultCode == "8000000003"){
				showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error', 'securityKeySet');
			}else if(data.resultCode == "0000000003"){		
				showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
			}else{
				showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');	
			}				
		}
	});
}

/* ********************************************************
 * 작업기간 calender 셋팅
 ******************************************************** */
function fn_modDateCalenderSetting() {
	
	var today = new Date();

	today.setFullYear(today.getFullYear() + 2);
	var startDay = today.toJSON().slice(0,10);

	var endDay = fn_dateParse("20991231").toJSON().slice(0,10);

	$("#mod_expr_dt").val(startDay);
	
	$("#mod_expr_dt", "#modForm").datepicker('setStartDate', startDay).datepicker('setEndDate', endDay);
	$("#mod_expr_dt_div", "#modForm").datepicker('updateDates'); 


}

</script>

<div class="modal fade" id="pop_layer_keyManageRegReForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_key_management.Encryption_Key_Modify"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="modForm">
						<input type="hidden" id="mod_keyUid" name="mod_keyUid" />
						<input type="hidden" id="mod_resourceUid" name="mod_resourceUid" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Key_Name"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_resourceName" name="mod_resourceName"  readonly="readonly" value="${resourceName}" />
									</div>
								</div>		

								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Encryption_Algorithm"/>
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_cipherAlgorithmCode" id="mod_cipherAlgorithmCode" >
											<option value="<c:out value=""/>" ><spring:message code="common.choice" /></option>
												 <c:forEach var="mod_result" items="${result}"  varStatus="status">
													<option value="<c:out value="${mod_result.sysCode}"/>" <c:if test="${mod_result.sysCode == cipherAlgorithmCode }">selected="selected"</c:if>><c:out value="${mod_result.sysCodeName}"/></option>
												</c:forEach> 
											</select>
									</div>											
								</div>			
																																									
								<div class="form-group row" style="margin-bottom:10px;">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Description"/>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control form-control-xsm" id="mod_resourceNote" name="mod_resourceNote"   value="${resourceNote}" maxlength="100" onkeyup="fn_checkWord(this,100)" placeholder="100<spring:message code='message.msg188'/>"/>
									</div>
								</div>							
															
								<div class="form-group row" style="margin-bottom:10px;">
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="renew" name="renew" >
											<spring:message code="encrypt_key_management.Update_Add_Binaries"/>
											<i class="input-helper"></i>
										</label>
									</div>
								</div>	

								<div class="form-group row" style="margin-bottom:10px;" id="renewInsert">
									<label for="ins_connect_nm" class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_key_management.Expiration_Date"/>
									</label>
									<div class="col-sm-4">
										<div id="mod_expr_dt_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="mod_expr_dt" name="mod_expr_dt" readonly tabindex=10 />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>		
									<div class="form-check"  style="margin-left: 20px;">
										<label class="form-check-label">
											<input type="checkbox" class="form-check-input" id="copyBin" name="copyBin" />
											<spring:message code="encrypt_key_management.Copy_Binary"/>
											<i class="input-helper"></i>
										</label>
									</div>								
								</div>	
							</div>									
						</fieldset>
					</form>	
				</div>

				<div class="card" style="margin-top:10px;border:0px;">		
					<table id="renewalhistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
						<thead>
	 						<tr class="bg-info text-white">
								<th width="25"><spring:message code="common.no" /></th>										
								<th width="50"><spring:message code="encrypt_key_management.Version"/></th>
								<th width="80"><spring:message code="encrypt_key_management.Status"/></th>
								<th width="130"><spring:message code="encrypt_key_management.Expiration_Date"/></th>
								<th width="80"><spring:message code="common.register" /></th>
								<th width="130"><spring:message code="common.regist_datetime" /></th>
								<th width="80"><spring:message code="common.modifier" /></th>
								<th width="130"><spring:message code="common.modify_datetime" /></th>
								<th width="0"></th>
								<th width="0"></th>
							</tr>
						</thead>
					</table>							
				</div>	
							
				<div class="card-body">
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
						<button type="button" class="btn btn-primary" onclick="fn_confirm('mod');"><spring:message code="common.save"/></button>
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>