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
	
	/* ********************************************************
	 * timepicker setting
	 ******************************************************** */
	function fn_timePickerSetting() {
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
					$("#repeatTime").val()
		 )
		 fn_drawScheduleList();
			$("#pop_layer_popup_backupSchedule").modal("hide");
		} 
	}
	
	/* ********************************************************
	 * validation check
	 ******************************************************** */
	 // schedule registration validation
	 function fn_validationSchReg(){
		if(fn_valChkSchTime()){
			return false;
		}else if(fn_valChkSchDay()){
			return false;
		}
		return true;
	 }
	 // time check
	 function fn_valChkSchTime(){
		if($("#repeat").prop("checked")){
			var timeChk = $("#startTime").val()>$("#repEndTime").val();
			if(!$("#repEndTime").val()){
				var errStr = "End Time 값을 입력해주세요";
				showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
				return true;
			}else if(timeChk){
				var errStr = "End Time은 Start Time 보다 늦어야합니다";
				showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
				return true;
			}
		}
		return false;
	 }
	
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
			return false;
		}else{
			var errStr = "하나 이상의 요일을 선택해주세요";
			showSwalIcon(errStr, '<spring:message code="common.close" />', '', 'error');
			return true;
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
			$("#everyTime").val("");
			// $("#repeatTime").val("");
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
			errStr = min + " 과 " + max + " 사이의 값을 입력해 주세요";
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
					백업배치 설정
				</h5>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insRegForm">				
							<div class="card-body">
								<div class="row">
									<div class="col-12">
	 									<form class="cmxform" id="scheduleForm">
											<fieldset>
												<div class="col-12" id="scheduleCustom" style="border: 1px solid #dee1e4;padding-top: 20px;padding-left: 30px;" >
													<div class="form-group row">
														<label for="ins_connect_nm" for="startDate" class="col-sm-2_3 col-form-label-sm pop-label-index">
															<i class="item-icon fa fa-dot-circle-o"></i>
															Start Date
														</label>
														<div class="col-sm-4" style="padding-left: 0px;">
															<div class="input-group date datepicker" id="startDate_div">
																<input type="text" class="form-control totDatepicker" style="width:70px;height:44px;" id="startDate" name="startDate" />
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
																		<div id="repTimeAlrtM" class="alert alert-fill-warning" style="font-size: 0.7em; width: 160px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 0px; padding-bottom: 10px; margin-bottom: 0px;" >
																			<!-- <i class="ti-info-alt" style="margin-right: 2px;"></i> -->
																			15 ~ 60 값을 입력해주세요
																		</div>
																		<div id="repTimeAlrtH" class="alert alert-fill-warning" style="font-size: 0.7em; width: 160px; height: 20px; padding-left: 5px; padding-right: 5px; padding-top: 0px; padding-bottom: 10px; margin-bottom: 0px;" >
																			<!-- <i class="ti-info-alt" style="margin-right: 2px;"></i> -->
																			 0 ~ 24 값을 입력해주세요
																		</div>
																	</div>
																</div>
																<select class="form-control form-control-xsm" id="repeatTime" style="margin-right: 10px;width:150px; height:40px;" onchange="fn_repTimeSet()" disabled>
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
														<label for="ins_connect_nm" class="col-sm-2_3 col-form-label-sm pop-label-index">
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