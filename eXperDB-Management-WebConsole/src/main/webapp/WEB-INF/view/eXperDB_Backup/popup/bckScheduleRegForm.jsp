<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : bckScheduleRegForm.jsp
	* @Description : 백업정책 스케줄등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-03-03	신예은 매니저		최초 생성
	*
	* author 신예은
	* since 2021.03.03
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
	
	function fn_scheduleRegReset() {
		dateCalenderSetting();
		fn_timePickerSetting();

		$("#alldays").prop('checked', false);
		fn_alldays();
		
		$("#repeatTime").val(0);
		fn_repTimeSet();

		$("#repeat").prop('checked', false);
		fn_repeatClick();
		
	}

	/* ********************************************************
	* 작업기간 calender 셋팅
	******************************************************** */
	function dateCalenderSetting() {
		
		var today = new Date();
		var startDay = today.toJSON().slice(0,10);
		var endDay = fn_dateParse("20991231").toJSON().slice(0, 10);
		
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
	
	/* ********************************************************
	 * timepicker setting
	 ******************************************************** */
	function fn_timePickerSetting() {
		var date = new Date();
		var time = moment(date).format("HH:mm");
		
		$("#startTime").val(time);
		$('#timepicker').datetimepicker({
			// format: 'LT'
			format: 'HH:mm',
			defaultDate : new Date()
		});
		$('#repTimePicker').datetimepicker({
			format: 'HH:mm'
		});
		
	}

	/* ********************************************************
	 * schedule registration
	 ******************************************************** */
	function fn_scheduleReg() {
		var dayPick = new Array();
		 if(fn_validationSchReg()){
			 //check된 요일값 dayPick에 넣어주기
			 // checked --> true / unchecked --> false
			dayPick.push($("#sun").prop("checked"));
			dayPick.push($("#mon").prop("checked"));
			dayPick.push($("#tue").prop("checked"));
			dayPick.push($("#wed").prop("checked"));
			dayPick.push($("#thu").prop("checked"));
			dayPick.push($("#fri").prop("checked"));
			dayPick.push($("#sat").prop("checked"));
			
			$("#startDateSch").val($("#startDate").val());
			
			fn_scheduleInsert(
					dayPick,
					$("#startTime").val(),
					$("#repeat").prop("checked"),
					$("#repEndTime").val(),
					$("#everyTime").val(),
					$("#repeatTime").val(),
					$("#backupType").val()
			)
			fn_drawScheduleList();
			fn_alertShow();
			fn_scheduleAlert();
			$("#pop_layer_popup_backupSchedule").modal("hide");
		} 
	}
	
	/* ********************************************************
	 * validation check
	 ******************************************************** */
	 // schedule registration validation
	 function fn_validationSchReg(){
		if(!fn_valChkSchTime()){ // time 값 check
			return false;
		}else if(!fn_valChkSchDay()){ // 요일이 선택되었는지 check
			return false;
		}
		return true;
	 }
	
	 // time check
	 function fn_valChkSchTime(){
		// repeat이 check 되었을 경우 (endTime이 존재)
		if($("#repeat").prop("checked")){
			// 시간 값(String)을 Date 형식으로 만듬
			// '1970-01-01 ' 의미없음 (단순히 포멧 맞추기 용)
			var startTime = new Date('1970-01-01 '+$("#startTime").val());
			var endTime = new Date('1970-01-01 '+$("#repEndTime").val());
			
			// endTime을 check할 기준 값
			var chkEndTime;
			
			// repeat 값에 따라 chkEndTime 세팅
			// endTime > startTime + repeat
			if($("#repeatTime").val() == 1){
				chkEndTime = startTime.setHours(startTime.getHours() + parseInt($("#everyTime").val()));
			}else{
				chkEndTime = startTime.setMinutes(startTime.getMinutes() + parseInt($("#everyTime").val()));
			}
			
			// chkEndTime을 Date 형식으로 바꿈
			var valEndTime = new Date(chkEndTime);
			
			var timeChk =  endTime.getTime() > valEndTime.getTime();
			var endStartChk = $("#repEndTime").val()>$("#startTime").val();
			
			if(!$("#repEndTime").val()){ // endTime 입력 유무 체크
				var errStr = '<spring:message code="eXperDB_backup.msg43" />';
				showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
				return false;
			}else if(!endStartChk){ // startTime - endTime 값 체크
				var errStr = '<spring:message code="eXperDB_backup.msg44" />';
				showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
				return false;
			}else if(!timeChk){ // repeat을 고려한 endTime 값 체크
				var errStr = '<spring:message code="eXperDB_backup.msg45" />';
				showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
				return false;
			}
		}
		return true;
	 }
	
	 // 요일 check validation
	function fn_valChkSchDay(){
		if(
			$("#sun").is(":checked") ||
			$("#mon").is(":checked") ||
			$("#tue").is(":checked") ||
			$("#wed").is(":checked") ||
			$("#thu").is(":checked") ||
			$("#fri").is(":checked") ||
			$("#sat").is(":checked")
		){
			return true;
		}else{
			var errStr = '<spring:message code="eXperDB_backup.msg46" />';
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			return false;
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
	// 모든 요일 check 되었을 경우 alldays check 처리
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
			$("#everyTime").val("");
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
		var min = Number($("#everyTime").prop("min"));
		var max = Number($("#everyTime").prop("max"));
		var errStr = null;

		if($('#everyTime').val() > max || $('#everyTime').val() < min){
			errStr = min + " ~ " + max + ' <spring:message code="eXperDB_backup.msg47" />';
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			$("#everyTime").val(min);
		}
	}

</script>
	
<div class="modal fade" id="pop_layer_popup_backupSchedule" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 800px">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="regTitle" style="padding-left:5px;">
					<spring:message code="eXperDB_backup.msg48" />
				</h5>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">				
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="scheduleForm">
											<fieldset>
												<div class="col-12" id="scheduleCustom" style="border: 1px solid #dee1e4;padding-top: 20px;padding-left: 15px;" >
													<div class="form-group row" style="margin-bottom: 20px;">
														<label for="backupType" class="col-sm-2_3 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Type
														</label>
														<select class="form-control form-control-xsm" id="backupType" style="margin-right: 10px;width:215px; height:40px; color: #555555;" onchange="">
															<option value="3">Full Backup</option>
															<option value="4">Incremental Backup</option>
														</select>
													</div>
													
													<div class="form-group row">
														<label for="ins_connect_nm" for="startDate" class="col-sm-2_3 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Start Date
														</label>
														<div class="col-sm-4" style="padding-left: 0px;">
															<div class="input-group date datepicker" id="startDate_div">
																<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="startDate" name="startDate"/>
																<span class="input-group-addon input-group-append border-left">
																	<span class="ti-calendar input-group-text"></span>
																</span>
															</div> 
														</div>
													</div>
													
													<div class="form-group row">
														<label for="ins_connect_nm" for="startTime" class="col-sm-2_3 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Start Time
														</label>
														<div class="col-sm-4" style="padding-left: 0px;">
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
													<div class="form-group row" style="margin-bottom: 0px;">
														<label for="ins_connect_nm row" class="col-sm-1_6 col-form-label-sm pop-label-index" style=" padding-right: 0px;">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Repeat
														</label>
														<div class="form-check" style="margin-right: 17px;">
															<label class="form-check-label">
																<input type="checkbox" class="form-check-input" id="repeat" name="repeat" onclick="fn_repeatClick()"/>
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="col-9 form-group" style="border: 1px solid #dee1e4;padding-left: 15px;margin-left: 0px;" id="repeat_set">
															<div class="row" style="padding-top: 10px; padding-left: 10px;" >
																<label for="ins_connect_nm" class="col-sm-2_5 col-form-label-sm pop-label-index">
																	Every
																</label>
																<div class="col-sm-4" >
																	<input type="number" style="width:140px; height:40px;" class="form-control form-control-sm" name="everyTime" id="everyTime" onchange="fn_repTimeVal()" disabled/>
																	<div class="col-sm-5" style="height: 25px;margin-top: 3px;padding-left: 0px;">
																		<div id="repTimeAlrtM" class="alert alert-fill-warning" style="font-size: 0.7em; width: 170px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 0px; padding-bottom: 10px; margin-bottom: 0px;" >
																			<!-- <i class="ti-info-alt" style="margin-right: 2px;"></i> -->
																			<spring:message code="eXperDB_backup.msg49" />
																		</div>
																		<div id="repTimeAlrtH" class="alert alert-fill-warning" style="font-size: 0.7em; width: 180px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 0px; padding-bottom: 10px; margin-bottom: 0px;" >
																			<!-- <i class="ti-info-alt" style="margin-right: 2px;"></i> -->
																			<spring:message code="eXperDB_backup.msg50" />
																		</div>
																	</div>
																</div>
																<select class="form-control form-control-xsm" id="repeatTime" style="margin-right: 10px;width:150px; height:40px; color: #555555;" onchange="fn_repTimeSet()" disabled>
																	<option value="0">Minutes</option>
																	<option value="1">Hours</option>
																</select>

															</div>
															<div class="row" style="padding-top: 5px; padding-left: 10px;" >
																<label for="ins_connect_nm" class="col-sm-2_5 col-form-label-sm pop-label-index">
																	End Time
																</label>
																<div class="col-sm-5" >
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
														<label for="ins_connect_nm" class="col-sm-2_2 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															<spring:message code="eXperDB_backup.msg51" />
														</label>
														<div class="form-check">
															<label class="form-check-label" for="sun" style="color : red;">
																<input type="checkbox" class="form-check-input" id="sun" name="sun" onclick="fn_dayClick()"/>
																<spring:message code='schedule.sunday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="mon">
																<input type="checkbox" class="form-check-input" id="mon" name="mon" onclick="fn_dayClick()"/>
																<spring:message code='schedule.monday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="tue">
																<input type="checkbox" class="form-check-input" id="tue" name="tue" onclick="fn_dayClick()"/>
																<spring:message code='schedule.thuesday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="wed">
																<input type="checkbox" class="form-check-input" id="wed" name="wed" onclick="fn_dayClick()"/>
																<spring:message code='schedule.wednesday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="thu">
																<input type="checkbox" class="form-check-input" id="thu" name="thu" onclick="fn_dayClick()"/>
																<spring:message code='schedule.thursday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="fri">
																<input type="checkbox" class="form-check-input" id="fri" name="fri" onclick="fn_dayClick()"/>
																<spring:message code='schedule.friday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="sat" style="color : blue;">
																<input type="checkbox" class="form-check-input" id="sat" name="sat" onclick="fn_dayClick()"/>
																<spring:message code='schedule.saturday' />
																<i class="input-helper"></i>
															</label>
														</div>
														<div class="form-check" style="margin-left: 15px;">
															<label class="form-check-label" for="all">
																<input type="checkbox" class="form-check-input" id="alldays" name="alldays" onclick="fn_alldays()"/>
																ALL
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
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<%-- <input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value="<spring:message code='common.registory' />" onclick="fn_scheduleReg()"/> --%>
									<button type="button" class="btn btn-primary" onclick="fn_scheduleReg()"><spring:message code="common.registory" /></button>
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>