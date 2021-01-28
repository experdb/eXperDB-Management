<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : arcBackupRegForm.jsp
	* @Description : 백업정책 등록 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021. 01. 21     최초 생성
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
		
	});
	
	
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var startDay = today.toJSON().slice(0,10);
		var endDay = fn_dateParse("20991231");
		
		var day_today = today.toJSON().slice(0,10);
		var day_start = startDay;
		var day_end = endDay.toJSON().slice(0,10);
		
		$("#startDateTime").val(day_today);
		$("#endDateTime").val(day_today);
		
		if ($("#wrk_strt_dtm_div").length) {
			$("#wrk_strt_dtm_div").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#startDateTime").datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#endDateTime").datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		
	    $("#wrk_strt_dtm_div").datepicker('updateDates');
	}


</script>
	
<div class="modal fade" id="pop_layer_popup_backupPolicy" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" >
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;">
				<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					백업정책 등록
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
	 									<form class="cmxform" id="optionForm">
											<fieldset>			
											
											</fieldset>
									</form>		
								 	</div>
							 	</div>
							</div>
						</div>
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.registory" />' />
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