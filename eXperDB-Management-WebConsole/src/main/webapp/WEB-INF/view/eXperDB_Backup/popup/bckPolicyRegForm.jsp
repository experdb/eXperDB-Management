<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : arcBackupRegForm.jsp
	* @Description : 백업정책 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-01-21	변승우 책임매니저		최초 생성
	*  2021-01-28	신예은 매니저		화면 구성
	*
	* author 변승우
	* since 2021.01.21
	*
	*/
%>

<script type="text/javascript">


	var storageList = [];
	var CIFSList = [];
	var NFSList = [];
	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		
		fn_makeMonthDay();
		
	});
	
	function fn_policyRegReset(result) {
		storageList = [];
		CIFSList = [];
		NFSList = [];
		fn_setStorageList(result);
		$("#policyRegTitle").show();
		$("#policyModiTitle").hide();

		$("#backupSetNum").val(1);
		
		$(':input:radio[name=merge_period]:checked').val("weekly");
		fn_mergeClick();
		
		$("#storageType").val("2");
		fn_storageTypeClick();
		
	}

	function fn_policyModiReset(){
		$("#regTitle").hide();
		$("#modiTitle").show();
	}
	
	function fn_setStorageList(data){
		console.log("setStorageList!!!");
		console.log("data : " + data);
		storageList = data;
		console.log("storageList length : " + storageList.length);
		for(var i =0; i<storageList.length; i++){
			if(storageList[i].type == "CIFS Share"){
				CIFSList.push(storageList[i]);
			}else{
				NFSList.push(storageList[i]);
			}
		}
	}
	
	function fn_storageTypeClick(){
		console.log("storageType Click!!!!");
		var type = $("#storageType").val();
		var html;
		$("#storageList").empty();
		if(type == 2){
			for(var i =0; i<CIFSList.length; i++){			
				html += '<option value="'+CIFSList[i].path+'">'+CIFSList[i].path+'</option>';
			}
		}else{
			for(var i =0; i<NFSList.length; i++){			
				html += '<option value="'+NFSList[i].path+'">'+NFSList[i].path+'</option>';
			}
		}
		$("#storageList").append(html);
	}
	
	/* ********************************************************
	* backup set setting
	******************************************************** */
	// backup storage number check
	function fn_backupSetVal() {
		var min = Number($("#backupSetNum").prop("min"));
		var max = Number($("#backupSetNum").prop("max"));
		var errStr = null;
		
		if($('#backupSetNum').val() > max || $('#backupSetNum').val() < min){
			errStr = min + " 과 " + max + " 사이의 값을 입력해 주세요";
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			$("#backupSetNum").val(1);
		}
	}
	
	// merge radio check
	function fn_mergeClick() {
		var mg = $(':input:radio[name=merge_period]:checked').val();
		if(mg == 'weekly'){
			$('#merge_period_week').prop("disabled", false);
			$('#merge_period_month').prop("disabled", true);
		}else if(mg == 'monthly'){
			$('#merge_period_month').prop("disabled", false);
			$('#merge_period_week').prop("disabled", true);
		}
	}

	function fn_makeMonthDay() {
		var dayHtml = "";

		for(var i = 1; i<=31; i++){
			dayHtml += '<option value="'+i+'">'+i+'</option>';
		}
		dayHtml +=  '<option value="32">last day</option>' +
					'<option value="33">The last Sunday</option>' +
					'<option value="34">The last Monday</option>' +
					'<option value="35">The last Tuesday</option>' +
					'<option value="36">The last Wednesday</option>' +
					'<option value="37">The last Thursday</option>' +
					'<option value="38">The last Friday</option>' +
					'<option value="39">The last Saturday</option>' ;
		$('#merge_period_month').append(dayHtml);
	}

	function fn_policyReg() {
		var bckdate = "";
		console.log("fn_policyReg click!!!!");
		if($("#storageType").val() == 1){
			$("#bckStorageType").val("NFS Share");
		}else{
			$("#bckStorageType").val("CIFS Share");	
		}
		$("#bckStorage").val($("#storageList").val());
		if($("#compressType").val()==1){		
			$("#bckCompress").val("Standard Compression");
		}else{
			$("#bckCompress").val("Maximum Compression");
		}

		if($(':input:radio[name=merge_period]:checked').val() == "weekly"){
			bckdate = "매주"
			switch($("#merge_period_week").val()){
				case  "0":
					bckdate += " 일요일"
					break;
				case "1":
					bckdate += " 월요일"
					break;
				case "2":
					bckdate += " 화요일"
					break;
				case "3":
					bckdate += " 수요일"
					break;
				case "4":
					bckdate += " 목요일"
					break;
				case "5":
					bckdate += " 금요일"
					break;
				case "6":
					bckdate += " 토요일"
					break;
			}
		}else{
			bckdate = "매월"
			if($("#merge_period_month").val()>31){
				switch($("#merge_period_month").val()){
					case "32":
						bckdate += " 마지막 날"
						break;
					case "33":
						bckdate += " 마지막 일요일"
						break;
					case "34":
						bckdate += " 마지막 월요일"
						break;
					case "35":
						bckdate += " 마지막 화요일"
						break;
					case "36":
						bckdate += " 마지막 수요일"
						break;
					case "37":
						bckdate += " 마지막 목요일"
						break;
					case "38":
						bckdate += " 마지막 금요일"
						break;
					case "39":
						bckdate += " 마지막 토요일"
						break;
				}
			}else{
				bckdate += " " + $("#merge_period_month").val() + "일";
			}
		}
		$("#bckSetDate").val(bckdate);
		$("#bckSetNum").val($("#backupSetNum").val());

		$("#bckCompressVal").val($("#compressType").val());
		$("#bckStorageTypeVal").val($("#storageType").val());	
		
		$("#pop_layer_popup_backupPolicyReg").modal("hide");
	}

</script>
	
<div class="modal fade" id="pop_layer_popup_backupPolicyReg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 700px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="policyRegTitle" style="padding-left:5px;">
					백업정책 등록
				</h5>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="policyModiTitle" style="padding-left:5px;">
					백업정책 수정
				</h5>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<input type="hidden" name="ins_wrk_nmChk" id="ins_wrk_nmChk" value="fail" />					
						<fieldset>
						
						
						<!-- backup destination -->
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;">	백업 스토리지 설정 </i>
							</div>					
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>			
												<div class="form-group row" style="margin-bottom: 15px;margin-left: 20px;margin-right: 0px;">
													<select class="form-control form-control-xsm" id="storageType" name="storageType" style="width:150px; height:40px;margin-right: 10px; color:black;" onchange="fn_storageTypeClick()">
														<option value="1">NFS share</option>
														<option value="2">CIFS share</option>
													</select>
													<select class="form-control form-control-xsm" id="storageList" name="storageList" style="width:300px; height:40px; color:black;">
														
													</select>
												</div>
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
						</div>
						
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;">	백업 압축 정책 </i>
							</div>					
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>			
												<div class="form-group row" style="margin-bottom: 15px;margin-left: 20px;margin-right: 0px;">
													<select class="form-control form-control-xsm" id="compressType" name="compressType" style="width:400px; height:40px; color:black;">
														<option value="1">Standard Compression</option>
														<option value="2">Maximum Compression</option>
													</select>
													
												</div>
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
						</div>
						
						<!-- Recovery Set Settings	 -->
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;">	Full 백업 정책 </i>
							</div>						
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row div-form-margin-z">
													<div class="col-5">
														<div  class="col-10 col-form-label pop-label-index" style="padding-top:7px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															백업 셋 보관 수
														</div>
														<div class="col-sm-4" style="margin-left: 10px">
															<input type="number" min="1" max="10000" style="width:150px; height:40px;" class="form-control form-control-sm" name="backupSetNum" id="backupSetNum" onchange="fn_backupSetVal()"/>
														</div>
													</div>
													<div class="col-7" >
														<div class="col-7 col-form-label pop-label-index" style="padding-top:7px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Full 백업 수행일
														</div>
														<div class="col-11 row" style="margin-left: 10px;">
															<label style="padding-top: 5px">매 주 <input type="radio" id="merge_week" name="merge_period" style="margin-right: 10px; margin-left: 10px;" checked="checked" value="weekly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_week" id="merge_period_week" class="form-control form-control-xsm" style="margin-left: 1rem;width:180px; height:40px; color:black;">
																<option value="0">Sunday</option>
																<option value="1">Monday</option>
																<option value="2">Tuesday</option>
																<option value="3">Wednesday</option>
																<option value="4">Thursday</option>
																<option value="5">Friday</option>
																<option value="6">Saturday</option>
															</select>
															
															<label style="padding-top: 10px">매 월 <input type="radio" id="merge_month" name="merge_period" style="margin-right: 10px; margin-left: 10px;" value="monthly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_month" id="merge_period_month"  class="form-control form-control-xsm" style="margin-top: 10px; margin-left: 1rem;width:180px; height:40px; color:black;" disabled>
																
															</select>
														</div>
													</div>
												</div>												
											</fieldset>
										</form>		
								 	</div>
							 	</div>
							</div>
						</div>
						
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<button type="button" class="btn btn-primary" id="regButton" onclick="fn_policyReg()"><spring:message code="common.registory"/></button>
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>