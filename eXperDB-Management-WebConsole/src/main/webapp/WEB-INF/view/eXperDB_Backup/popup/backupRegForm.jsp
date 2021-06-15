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



	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		
		dateCalenderSetting();
		fn_makeMonthDay();
		fn_timePickerSetting();
		
	});
	
	function fn_regReset() {
		dateCalenderSetting();
		fn_timePickerSetting();

		$("#regTitle").show();
		$("#modiTitle").hide();

		$("#backupSetNum").val(1);

		$(':input:radio[name=merge_period]:checked').val("weekly");
		fn_mergeClick();
		
		$("#scheduleType").val(0);
		fn_scheduleType();

		$("#alldays").prop('checked', false);
		fn_alldays();
		
		$("#repeatTime").val(0);
		fn_repTimeSet();

		$("#repeat").prop('checked', false);
		fn_repeatClick();

	}

	function fn_modiReset(){
		fn_regReset();
		$("#regTitle").hide();
		$("#modiTitle").show();
	}

	/* ********************************************************
	* 작업기간 calender 셋팅
	******************************************************** */
	function dateCalenderSetting() {
		
		var today = new Date();
		var startDay = today.toJSON().slice(0,10);
		var endDay = fn_dateParse("20991231").toJSON().slice(0, 10);
		
		/* console.log("today : " + today);
		console.log("startDay : " + startDay);
		console.log("endDay : " + endDay); */

		$("#startDate").val(startDay);
		
		
		// if ($("#startDate_div", "#scheduleForm").length) {
		$("#startDate").datepicker({
			}).datepicker('setDate', startDay)
			.datepicker('setStartDate', startDay)
			.datepicker('setEndDate', endDay)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		// }

	

		
		$("#startDate").datepicker('setStartDate', startDay).datepicker('setEndDate', endDay);
		// $("#startDate_div").datepicker('updateDates');
		
	}

	function fn_timePickerSetting() {
		$('#timepicker').datetimepicker({
			format: 'LT'
		});
		$('#repTimePicker').datetimepicker({
			format: 'LT'
		});

	}

	function fn_backupReg() {
		console.log("///// backup Reg function called!! /////");
		console.log("Start Date : " + $("#startDate").val());
		console.log("Start Time : " +$("#startTime").val());
		console.log("Repeat End Time : " +$("#repEndTime").val());
		console.log("///////////////////////////////////////");

	}
	
	/* ********************************************************
	* recovery set setting
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

	/* ********************************************************
	 * schedule select function
	 ******************************************************** */
	function fn_scheduleType() {
		if($("#scheduleType").val() == 1){
			$("#scheduleCustom").slideDown();
		}else{
			$("#scheduleCustom").slideUp();
		}

	}

	/* ********************************************************
	 * day select function
	 ******************************************************** */
	// alldays click
	function fn_alldays(){
		if($("#alldays").is(":checked")){
			$("#sun").prop('checked', true);
			$("#mon").prop('checked', true);
			$("#tue").prop('checked', true);
			$("#wed").prop('checked', true);
			$("#thu").prop('checked', true);
			$("#fri").prop('checked', true);
			$("#sat").prop('checked', true);

		}else{
			$("#sun").prop('checked', false);
			$("#mon").prop('checked', false);
			$("#tue").prop('checked', false);
			$("#wed").prop('checked', false);
			$("#thu").prop('checked', false);
			$("#fri").prop('checked', false);
			$("#sat").prop('checked', false);
		}
	}

	// days click
	function fn_dayClick() {
		if(fn_dayCheck()){
			$("#alldays").prop('checked', true);
		}else{
			$("#alldays").prop('checked', false);
		}
	}

	// days check
	function fn_dayCheck() {
		if(
			$("#sun").is(":checked") &&
			$("#mon").is(":checked") &&
			$("#tue").is(":checked") &&
			$("#wed").is(":checked") &&
			$("#thu").is(":checked") &&
			$("#fri").is(":checked") &&
			$("#sat").is(":checked")
		){
			return true;
		}else{
			return false;
		}
	}

	/* ********************************************************
	 * repeat select function
	 ******************************************************** */
	// repeat check
	 function fn_repeatClick() {
		if($("#repeat").is(":checked")){
			$("#repeat_set").find('input, select').prop("disabled", false); 
			fn_repTimeSet();
		}else{
			$("#repeat_set").find('input, select').prop("disabled", true); 
			$("#repTimeAlrtM").hide();
			$("#repTimeAlrtH").hide();
		}
	}

	// repeat time setting change
	function fn_repTimeSet() {
		if($("#repeatTime").val() == 1){
			$("#everyTime").val(0);
			$("#everyTime").prop("max", 24);
			$("#everyTime").prop("min", 0);
			$("#repTimeAlrtM").hide();
			$("#repTimeAlrtH").show();
		}else{
			$("#everyTime").val(15);
			$("#everyTime").prop("max", 60);
			$("#everyTime").prop("min", 15);
			$("#repTimeAlrtH").hide();
			$("#repTimeAlrtM").show();
		}
	}

	// repeat time number check
	function fn_repTimeVal() {
		console.log("fn_repTime validation");
		var min = Number($("#everyTime").prop("min"));
		var max = Number($("#everyTime").prop("max"));
		var errStr = null;

		if($('#everyTime').val() > max || $('#everyTime').val() < min){
			errStr = min + " 과 " + max + " 사이의 값을 입력해 주세요";
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			$("#everyTime").val(min);
		}
	}




</script>
	
<div class="modal fade" id="pop_layer_popup_backupPolicy" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" >
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="regTitle" style="padding-left:5px;">
					백업정책 등록
				</h5>
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="modiTitle" style="padding-left:5px;">
					백업정책 수정
				</h5>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">
						<input type="hidden" name="ins_wrk_nmChk" id="ins_wrk_nmChk" value="fail" />					
						<fieldset>
						<!-- Recovery Set Settings	 -->
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;">	Recovery Set Settings </i>
							</div>						
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>	
												<div class="form-group row div-form-margin-z">
													<div class="col-6">
														<div  class="col-6 col-form-label pop-label-index" style="padding-top:7px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															백업 셋 보관 수
														</div>
														<div class="col-sm-4" style="margin-left: 10px">
															<input type="number" min="1" max="10000" style="width:150px; height:40px;" class="form-control form-control-sm" name="backupSetNum" id="backupSetNum" onchange="fn_backupSetVal()"/>
														</div>
													</div>
													<div class="col-6" >
														<div class="col-6 col-form-label pop-label-index" style="padding-top:7px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Merge 주기
														</div>
														<div class="col-8 row" style="margin-left: 10px;">
															<label style="padding-top: 5px">매 주 <input type="radio" id="merge_week" name="merge_period" style="margin-right: 10px; margin-left: 10px;" checked="checked" value="weekly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_week" id="merge_period_week"  class="form-control form-control-xsm" style="margin-left: 1rem;width:200px; height:40px;">
																<option value="0">Sunday</option>
																<option value="1">Monday</option>
																<option value="2">Tuesday</option>
																<option value="3">Wednesday</option>
																<option value="4">Thursday</option>
																<option value="5">Friday</option>
																<option value="6">Saturday</option>
															</select>
															
															<label style="padding-top: 10px">매 월 <input type="radio" id="merge_month" name="merge_period" style="margin-right: 10px; margin-left: 10px;" value="monthly" onchange="fn_mergeClick()"/></label>
															<select name="merge_period_month" id="merge_period_month"  class="form-control form-control-xsm" style="margin-top: 10px; margin-left: 1rem;width:200px; height:40px;" disabled>
																
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
						
						<!-- backup destination -->
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;">	Backup Destination </i>
							</div>					
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="optionForm">
											<fieldset>			
												<div class="form-group row" style="margin-bottom: 15px;">
													<div class="col-2 col-form-label pop-label-index" style="margin-left: 20px">
														<i class="item-icon fa fa-dot-circle-o"></i>
														Backup Path
													</div>
													<div class="col-4" style="padding-left: 0px;">
														<input type="text" class="form-control form-control-sm"/>
													</div>
													<div class="col-4">
														<button class="btn btn-inverse-info btn-fw">check</button>
													</div>
												</div>
											</fieldset>
									</form>		
								 	</div>
							 	</div>
							</div>
						</div>
						
						
						<!-- ########### 스케줄 설정 부분 ############### -->
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;">	Schedule </i>
							</div>					
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="scheduleForm">
											<fieldset>
												<div class="col-12" style="padding-left: 30px;">
													<div class="form-group row" style="margin-bottom: 15px;">
														<div class="col-2 col-form-label pop-label-index">
															Schedule Type
														</div>
														<select class="form-control form-control-xsm" style="margin-left: 3px;width:200px;height:40px;" id="scheduleType" name="scheduleType" onchange="fn_scheduleType()">
															<option value="0">None</option>
															<option value="1">Custom</option>
														</select>
													</div>
												</div>
												
												<div class="col-12" id="scheduleCustom" style="border: 1px solid #dee1e4;padding-top: 20px;padding-left: 30px; display:none;" >
													<div class="form-group row">
														<label for="ins_connect_nm" for="startDate" class="col-sm-2_1 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Start Date
														</label>
														<div class="col-sm-3" style="padding-left: 0px;">
															<div class="input-group date datepicker" id="startDate_div">
																<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="startDate" name="startDate" />
																<span class="input-group-addon input-group-append border-left">
																	<span class="ti-calendar input-group-text"></span>
																</span>
															</div> 
														</div>
													</div>
													<div class="form-group row">
														<label for="ins_connect_nm" for="startTime" class="col-sm-2_1 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Start Time
														</label>
														<div class="col-sm-3" style="padding-left: 0px;">
															<div class="input-group date" id="timepicker" data-target-input="nearest">
																<div class="input-group" data-target="#timepicker" data-toggle="datetimepicker">
																	<input type="text" id="startTime" class="form-control datetimepicker-input" data-target="#timepicker"/>
																	<div class="input-group-append input-group-addon">
																		<i class="ti-time input-group-text"></i>
																	</div>
																</div>
															</div>
														</div>
													
													</div>
													<div class="form-group row">
														<label for="ins_connect_nm row" class="col-sm-1_3 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Repeat
														</label>
														<div class="form-check">
															<label class="form-check-label">
																<input type="checkbox" class="form-check-input" id="repeat" name="repeat" onclick="fn_repeatClick()"/>
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="col-9 form-group" style="border: 1px solid #dee1e4;padding-left: 15px;margin-left: 50px;" id="repeat_set">
															<div class="row" style="padding-top: 10px; padding-left: 10px;" >
																<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index">
																	Every
																</label>
																<div class="col-sm-3" >
																	<input type="number" min="15" max="60" style="width:160px; height:40px;" class="form-control form-control-sm" name="everyTime" id="everyTime" onchange="fn_repTimeVal()" disabled/>
																</div>
																<select class="form-control form-control-xsm" id="repeatTime" style="margin-right: 10px;width:200px; height:40px;" onchange="fn_repTimeSet()" disabled>
																	<option value="0">Minutes</option>
																	<option value="1">Hours</option>
																</select>
																<div class="col-sm-3" style="height: 30px; margin-top: 5px;">
																	<div id="repTimeAlrtM" class="alert alert-fill-warning" style="width: 212px; height: 30px; padding-left: 5px; padding-right: 5px; padding-top: 5px; padding-bottom: 10px; margin-bottom: 0px;" >
																		<i class="ti-info-alt" style="margin-right: 2px;"></i>
																		15 ~ 60 값을 입력해주세요
																	</div>
																	<div id="repTimeAlrtH" class="alert alert-fill-warning" style="width: 212px; height: 30px; padding-left: 5px; padding-right: 5px; padding-top: 5px; padding-bottom: 10px; margin-bottom: 0px;" >
																		<i class="ti-info-alt" style="margin-right: 2px;"></i>
																		 0 ~ 24 값을 입력해주세요
																	</div>
																</div>

															</div>
															<div class="row" style="padding-top: 10px; padding-left: 10px;" >
																<label for="ins_connect_nm" class="col-sm-1_7 col-form-label-sm pop-label-index">
																	End Time
																</label>
																<div class="col-sm-3" >
																	<div class="input-group date" id="repTimePicker" data-target-input="nearest">
																		<div class="input-group" data-target="#repTimePicker" data-toggle="datetimepicker">
																			<input type="text" id="repEndTime" class="form-control datetimepicker-input" data-target="#repTimePicker" style="width: 150px; height: 40px;"/>
																			<div class="input-group-append input-group-addon" style="height: 40px;">
																				<i class="ti-time input-group-text"></i>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
													<div class="form-group row">
														<label for="ins_connect_nm" class="col-sm-2_1 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															요일 반복
														</label>
														<div class="form-check">
															<label class="form-check-label" for="sun" style="color : red;">
																<input type="checkbox" class="form-check-input" id="sun" name="sun" onclick="fn_dayClick()"/>
																일
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="mon">
																<input type="checkbox" class="form-check-input" id="mon" name="mon" onclick="fn_dayClick()"/>
																월
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="tue">
																<input type="checkbox" class="form-check-input" id="tue" name="tue" onclick="fn_dayClick()"/>
																화
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="wed">
																<input type="checkbox" class="form-check-input" id="wed" name="wed" onclick="fn_dayClick()"/>
																수
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="thu">
																<input type="checkbox" class="form-check-input" id="thu" name="thu" onclick="fn_dayClick()"/>
																목
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="fri">
																<input type="checkbox" class="form-check-input" id="fri" name="fri" onclick="fn_dayClick()"/>
																금
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="sat" style="color : blue;">
																<input type="checkbox" class="form-check-input" id="sat" name="sat" onclick="fn_dayClick()"/>
																토
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 20px;">
															<label class="form-check-label" for="all">
																<input type="checkbox" class="form-check-input" id="alldays" name="alldays" onclick="fn_alldays()"/>
																all days
																<i class="input-helper"></i>
															</label>
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
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value="<spring:message code='common.registory' />" onclick="fn_backupReg()"/>
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