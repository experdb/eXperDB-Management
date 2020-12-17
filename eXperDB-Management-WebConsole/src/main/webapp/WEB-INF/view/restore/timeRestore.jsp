<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : timeRestore.jsp
	* @Description : timeRestore 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.09     최초 생성
	*
	* author 변승우 대리
	* since 2019.01.09
	*
	*/
%>

<script type="text/javascript">
	$(window.document).ready(function() {
		//초기설정
		fn_init();

		//validate
 	    $("#restoreTimeRegForm").validate({
		        rules: {
		        	restore_nm: {
					required: true
				},
				restore_exp: {
					required: true
				}
	        },
	        messages: {
	        	restore_nm: {
	        		required: '<spring:message code="restore.msg01" />'
				},
				restore_exp: {
	        		required: '<spring:message code="restore.msg03" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_restore_validate();
			},
	        errorPlacement: function(label, element) {
	          label.addClass('mt-2 text-danger');
	          label.insertAfter(element);
	        },
	        highlight: function(element, errorClass) {
	          $(element).parent().addClass('has-danger')
	          $(element).addClass('form-control-danger')
	        }
		});
	});

	/* ********************************************************
	 * 초기설정
	 ******************************************************** */
	function fn_init() {
		$("#storage_view", "#restoreTimeRegForm").hide();

		//시간 설정
		fn_makeHour();
		fn_makeMin();
		fn_makeSec();
		
		//캘린더 셋팅
		fn_insDateCalenderSetting();
		
		//pghbak 조회
		fn_pgrback_search();
	}

	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeHour() {
		var hour = "";
		var hourHtml = "<select class='form-control form-control-sm' style='display: inline-block;width:80px;margin-top:4px;' name='timeline_h' id='timeline_h' tabindex=7 >";

		for (var i = 0; i <= 23; i++) {
			if (i >= 0 && i < 10) {
				hour = "0" + i;
			} else {
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">' + hour + '</option>';
		}
		hourHtml += '</select> <font size="2em"><spring:message code="schedule.our" /></font>';
		$("#hour", "#restoreTimeRegForm").append(hourHtml);
	}

	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin() {
		var min = "";
		var minHtml = "<select class='form-control form-control-sm' style='display: inline-block;width:80px;margin-top:4px;' name='timeline_m' id='timeline_m' tabindex=7 >";

		for (var i = 0; i <= 59; i++) {
			if (i >= 0 && i < 10) {
				min = "0" + i;
			} else {
				min = i;
			}
			minHtml += '<option value="'+min+'">' + min + '</option>';
		}
		minHtml += '</select> <font size="2em"><spring:message code="schedule.minute" /></font>';
		$("#min", "#restoreTimeRegForm").append(minHtml);
	}
	
	/* ********************************************************
	 * 초
	 ******************************************************** */
	function fn_makeSec() {
		var sec = "";
		var secHtml = "<select class='form-control form-control-sm' style='display: inline-block;width:80px;margin-top:4px;' name='timeline_s' id='timeline_s' tabindex=8 >";

		for (var i = 0; i <= 59; i++) {
			if (i >= 0 && i < 10) {
				sec = "0" + i;
			} else {
				sec = i;
			}
			secHtml += '<option value="'+sec+'">' + sec + '</option>';
		}
		secHtml += '</select> <font size="2em"><spring:message code="schedule.second" /></font>';
		$("#sec", "#restoreTimeRegForm").append(secHtml);
	}
	
	/* ********************************************************
	 * PGRBAK 조회
	 ******************************************************** */
	function fn_pgrback_search() {
		$.ajax({
			async : false,
			url : "/selectPathInfo.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
			},
			type : "post",
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
			},
			success : function(result) {
				if (result != null && result !=",") {
					$("#rman_pth", "#restoreTimeRegForm").val(result[1].PGRBAK);
				} else {
					$("#rman_pth", "#restoreTimeRegForm").val("");
				}
			}
		});
	}
	

	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function fn_insDateCalenderSetting() {
		var today = new Date();
		var startDay = fn_dateParse("20100101");
		var endDay = fn_dateParse("20991231");
		
		var day_today = today.toJSON().slice(0,10);
		var day_start = startDay.toJSON().slice(0,10);
		var day_end = endDay.toJSON().slice(0,10);

		if ($("#timeline_dt_div", "#insUserForm").length) {
			$("#timeline_dt_div", "#insUserForm").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#timeline_dt", "#restoreTimeRegForm").datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#timeline_dt_div", "#restoreTimeRegForm").datepicker('updateDates');
	}

	/* ********************************************************
	 * Storage 경로 선택 (기존/신규)
	 ******************************************************** */
	function fn_storage_path_set() {
		var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

		if (asis_flag == "0") {
			$("#storage_view", "#restoreTimeRegForm").hide();
			fn_clean();
		} else {
			$("#storage_view", "#restoreTimeRegForm").show();
			$("#restore_dir", "#restoreTimeRegForm").val("");
		}
	}

	/* ********************************************************
	 * 신규 Storage 경로 확인
	 ******************************************************** */
	function fn_new_storage_check() {
		var new_storage = $("#restore_dir", "#restoreTimeRegForm").val();

		$.ajax({
			async : false,
			url : "/existDirCheckMaster.do",
		  	data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
		  		path : new_storage
		  	},
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
				if (data != null) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							
							showSwalIcon('<spring:message code="message.msg100" />', '<spring:message code="common.close" />', '', 'success');
							/* 
							$("#dtb_pth").val(new_storage + "${pgdata}");
							$("#svrlog_pth").val(new_storage + "${srvlog}"); */
							
							$("#dtb_pth", "#restoreTimeRegForm").val(new_storage);
							$("#svrlog_pth", "#restoreTimeRegForm").val(new_storage);
						}else{
							showSwalIcon('<spring:message code="backup_management.invalid_path"/>', '<spring:message code="common.close" />', '', 'error');
						}
					}else{
						showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');
					}
				} else {
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	/* ********************************************************
	 * 신규 Storage 초기화
	 ******************************************************** */
	function fn_clean() {
		$("#restore_dir", "#restoreTimeRegForm").val("");
		$("#dtb_pth", "#restoreTimeRegForm").val("${pgdata}");
		$("#svrlog_pth", "#restoreTimeRegForm").val("${srvlog}");
	}

	/* ********************************************************
	 * 복구명 중복체크
	 ******************************************************** */
	function fn_restoreNm_check() {
		if (nvlPrmSet($("#restore_nm", "#restoreTimeRegForm").val(), "") == "") {
			showSwalIcon('<spring:message code="restore.msg01" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화restoreTimeRegForm
		$("#restorenm_check_alert", "#restoreTimeRegForm").html('');
		$("#restorenm_check_alert", "#restoreTimeRegForm").hide();
		
		$.ajax({
			url : '/restore_nmCheck.do',
			type : 'post',
			data : {
				restore_nm : $("#restore_nm", "#restoreTimeRegForm").val()
			},
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
			success : function(result) {
				if (result == "true") {
					showSwalIcon('<spring:message code="restore.msg221" />', '<spring:message code="common.close" />', '', 'success');
					$('#restore_nmChk', '#restoreTimeRegForm').val("success");
				} else {
					showSwalIcon('<spring:message code="restore.msg222" />', '<spring:message code="common.close" />', '', 'error');
					$('#restore_nmChk', '#restoreTimeRegForm').val("fail");
				}
			},

		});
	}
	
	/* ********************************************************
	 * work 명 변경시
	 ******************************************************** */
	function fn_restoreNm_Chg() {
		$('#restore_nmChk', '#restoreTimeRegForm').val("fail");
		
		$("#restorenm_check_alert", "#restoreTimeRegForm").html('');
		$("#restorenm_check_alert", "#restoreTimeRegForm").hide();
	}

	/* ********************************************************
	 * RMAN Show 정보 확인
	 ******************************************************** */
	function fn_rmanShowOpen() {
		var bck_val = nvlPrmSet($("#rman_pth", "#restoreTimeRegForm").val(), "");
		
		fn_rmanShow(bck_val, $("#db_svr_id","#findList").val());
	}

	/* ********************************************************
	 * 긴급복원 실행 클릭
	 ******************************************************** */
	function fn_restore_start() {
		$("#restoreTimeRegForm").submit();
	}
	
	/* ********************************************************
	 * 시점복원 validate 체크
	 ******************************************************** */
	function fn_restore_validate() {
		if(nvlPrmSet($("#restore_nmChk", "#restoreTimeRegForm").val(), "") == "" || nvlPrmSet($("#restore_nmChk", "#restoreTimeRegForm").val(), "") == "fail") {
			$("#restorenm_check_alert", "#restoreTimeRegForm").html('<spring:message code="restore.msg02"/>');
			$("#restorenm_check_alert", "#restoreTimeRegForm").show();
			
			return;
		}
		
		fn_passwordConfilm('rman');
	}

	/* ********************************************************
	 * RMAN Restore 시작 전 (select pg_switch_wal()) -- 패스워드 팝업 실행 result
	 ******************************************************** */
	function fn_pgWalFileSwitch(){
		$.ajax({
			url : "/pgWalFileSwitch.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
			},
			dataType : "json",
			type : "post",
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
			},
			success : function(result) {
				//정상완료 시
				if(result.RESULT_CODE ==0){
					fn_execute();
				} else {
					showSwalIcon('<spring:message code="message.msg32" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});		
	}
	 
	/* ********************************************************
	 * RMAN Restore 정보 저장
	 ******************************************************** */
	function fn_execute() {
		var timeline_dt = $("#timeline_dt", "#restoreTimeRegForm").val();
		var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

		if (timeline_dt != null && timeline_dt != "") {
			timeline_dt = timeline_dt.split("-").join("");
		}

		$.ajax({
			url : "/insertRmanRestore.do",
			data : {
 				db_svr_id : $("#db_svr_id","#findList").val(),
				asis_flag : asis_flag,
				restore_dir : $("#restore_dir", "#restoreTimeRegForm").val(),
				dtb_pth : $("#dtb_pth", "#restoreTimeRegForm").val(),
				pgalog_pth : $("#pgalog_pth", "#restoreTimeRegForm").val(),
				svrlog_pth : $("#svrlog_pth", "#restoreTimeRegForm").val(),
				bck_pth : $("#bck_pth", "#restoreTimeRegForm").val(),
				restore_cndt : 1,
				restore_flag : 1,
				timeline_dt : timeline_dt,
				restore_nm : $("#restore_nm", "#restoreTimeRegForm").val(),
				restore_exp : $("#restore_exp", "#restoreTimeRegForm").val(),
				timeline_h : $("#timeline_h", "#restoreTimeRegForm").val(),
				timeline_m : $("#timeline_m", "#restoreTimeRegForm").val(),
				timeline_s : $("#timeline_s", "#restoreTimeRegForm").val()
			},
			dataType : "json",
			type : "post",
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
			},
			success : function(result) {
				if (result != null) {
					if (result == "S") {
						showSwalIconRst('<spring:message code="restore.msg223" />', '<spring:message code="common.close" />', '', 'warning', 'rman_restore');
					} else {
						showSwalIcon('<spring:message code="message.msg32" />', '<spring:message code="common.close" />', '', 'error');
						return;
					}
				} else {
					showSwalIcon('<spring:message code="message.msg32" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 로그조회
	 ******************************************************** */
	function fn_restoreLogCall() {
		$.ajax({
			url : '/restoreLogCall.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
			},
			success : function(result) {
				$("#exelog", "#restoreTimeRegForm").append(result.strResultData);
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
</script>

<%@include file="../popup/rmanShow.jsp"%>
<%@include file="../cmmn/passwordConfirm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
</form>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">

					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="mdi mdi-backup-restore"></i>
												<span class="menu-title"><spring:message code="restore.Point-in-Time_Recovery"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" > 
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.Recovery_Management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.Point-in-Time_Recovery" /></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.Point-in-Time_Recovery" /></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body" style="min-height:698px; max-height:750px;">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">																				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScheduleRun" onClick="fn_restore_start();">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="schedule.run" />
								</button>

							</div>
						</div>
					</div>

					<form class="cmxform" id="restoreTimeRegForm">
						<input type="hidden" name="restore_nmChk" id="restore_nmChk" value="fail" />
						<input type="hidden" name="rman_pth" id="rman_pth" value="" />

						<fieldset>
							<div class="row" style="margin-top:10px;">
								<div class="col-md-12 system-tlb-scroll" style="height: 185px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="restore_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_name" />
											</label>
		
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="restore_nm" name="restore_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onchange="fn_restoreNm_Chg();" onblur="this.value=this.value.trim()" tabindex=1 required />
											</div>
		
											<div class="col-sm-2">
												<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" id="btnRestoreCheck" onclick="fn_restoreNm_check()"><spring:message code="common.overlap_check" /></button>
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z">
											<div class="col-sm-2">
											</div>
		
											<div class="col-sm-9">
												<div class="alert alert-danger form-control-sm" style="margin-top:5px;display:none;" id="restorenm_check_alert"></div>
											</div>
											
											<div class="col-sm-1">
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:10px;">
											<label for="restore_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_Description" />
											</label>
		
											<div class="col-sm-10">
												<textarea class="form-control form-control-xsm" id="restore_exp" name="restore_exp" rows="2" maxlength="150" onkeyup="fn_checkWord(this,150)" placeholder="150<spring:message code='message.msg188'/>" required tabindex=2></textarea>
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:-30px;">
											<label for="db_svr_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.server_name" />
											</label>

											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="db_svr_nm" name="db_svr_nm" value="${db_svr_nm}" onblur="this.value=this.value.trim()" readonly />
											</div>

											<label for="ipadr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Server_IP" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="ipadr" name="ipadr" value="${ipadr}" onblur="this.value=this.value.trim()" readonly />
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="row" style="margin-top:10px;">
								<div class="col-md-6 system-tlb-scroll" style="border:0px;max-height: 460px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="wrk_nm" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Storage <spring:message code="common.path" />
											</label>
											
											<div class="col-sm-3" >
												<div class="form-check">
													<label class="form-check-label" for="storage_path_org">
														<input type="radio" class="form-check-input" name="asis_flag" id="storage_path_org" onClick="fn_storage_path_set();" value="0" checked tabindex=3 />
		                          						<spring:message code="restore.existing" />
		                          					</label>
		                          				</div>
		                          			</div>
		                          			<div class="col-sm-3">
		                          				<div class="form-check">
		                          					<label class="form-check-label" for="storage_path_new">
		                          						<input type="radio" class="form-check-input" name="asis_flag" id="storage_path_new" value="1" onClick="fn_storage_path_set();" tabindex=4 />
		                          						<spring:message code="restore.new" />
		                          					</label>
		                          				</div>
		                          			</div>
		                          			<div class="col-sm-3">
		                          				&nbsp;
		                          			</div>
		                          		</div>

										<div class="form-group row div-form-margin-z" style="margin-top:-5px;" id="storage_view">
											<label for="ipadr" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_Path" />
											</label>
											
											<div class="col-sm-5">
												<input type="text" class="form-control form-control-sm" id="restore_dir" name="restore_dir" value="" onblur="this.value=this.value.trim()" tabindex=5 />
											</div>
											
											<div class="col-sm-2">
												<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_new_storage_check()"><spring:message code="common.dir_check" /></button>
											</div>
											<div class="col-sm-2">
												<button type="button" class="btn btn-inverse-info btn-fw" style="width: 100px;" onclick="fn_clean()"><spring:message code="restore.reset" /></button>
											</div>
										</div>

										<div class="form-group row div-form-margin-z" style="margin-top:-5px;margin-right:0px;" >
											<div class="col-sm-12" style="border: 1px solid #adb5bd;">
												<div class="row" style="margin-top:10px;">
													<label class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="restore.Recovery_Information" />
													</label>
													
													<div class="col-sm-9">
														<button type="button" class="btn btn-inverse-info btn-fw" style="width: 180px;" onclick="fn_rmanShowOpen();"><spring:message code="restore.Recovery_Information" /></button>
													</div>
												</div>

												<div class="row" style="margin-bottom:10px;">
													<div class="col-sm-4">
														<div id="timeline_dt_div" class="input-group align-items-center date datepicker totDatepicker">
															<input type="text" class="form-control totDatepicker" style="width:100px;height:44px;" id="timeline_dt" name="timeline_dt" readonly tabindex=10 />
															<span class="input-group-addon input-group-append border-left">
																<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
															</span>
														</div>
													</div>
													
													<div class="col-sm-8">
														<span id="hour" style="margin-right: 1rem;"></span>
														<span id="min" style="margin-right: 1rem;"></span>
														<span id="sec"></span>
													</div>
												</div>
											</div>
										</div>

										<div class="form-group row div-form-margin-z" style="margin-top:5px;">
											<label for="ipadr" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Database Storage
											</label>
											
											<div class="col-sm-9">
												<input type="text" class="form-control form-control-sm" id="dtb_pth" name="dtb_pth" value="${pgdata}" onblur="this.value=this.value.trim()" readonly />
											</div>
										</div>

										<div class="form-group row div-form-margin-z">
											<label for="ipadr" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Archive WAL Storage
											</label>
											<div class="col-sm-9">
												<input type="text" class="form-control form-control-sm" id="pgalog_pth" name="pgalog_pth" value="${pgalog}" onblur="this.value=this.value.trim()" readonly />
											</div>
										</div> 

										<div class="form-group row div-form-margin-z" >
											<label for="ipadr" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Server Log Storage
											</label>
											<div class="col-sm-9">
												<input type="text" class="form-control form-control-sm" id="svrlog_pth" name="svrlog_pth" value="${srvlog}" onblur="this.value=this.value.trim()" readonly />
											</div>
										</div>

										<div class="form-group row div-form-margin-z">
											<label for="ipadr" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Backup Storage
											</label>
											<div class="col-sm-9">
												<input type="text" class="form-control form-control-sm" id="bck_pth" name="bck_pth" value="${pgrbak}" onblur="this.value=this.value.trim()" readonly />
											</div>
										</div>
									</div>
								</div>

								<div class="col-md-6 system-tlb-scroll" style="border:0px;height: 460px;">
									<div class="card-body-modal" style="border: 1px solid #adb5bd;">
										<!-- title -->
										<h3 class="card-title fa fa-toggle-right">
											Restore <spring:message code="restore.Execution_log" />
										</h3>

										<div class="row" >
											<div class="col-md-12" >
												<textarea class="form-control system-tlb-scroll" id="exelog" name="exelog" style="height:395px;" readonly></textarea>
											</div>
										</div>
									</div>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>