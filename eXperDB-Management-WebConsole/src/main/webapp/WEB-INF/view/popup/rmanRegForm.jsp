<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : rmanRegForm.jsp
	* @Description : rman 백업등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>

<script type="text/javascript">
	var haCnt =0;

	$(window.document).ready(function() {
		//validate
	    $("#workRegForm").validate({
	        rules: {
	        	ins_wrk_nm: {
					required: true
				},
				ins_wrk_exp: {
					required: true
				},
				ins_bck_opt_cd: {
					required: true
				},
				ins_bck_pth: {
					required: true
				}
	        },
	        messages: {
	        	ins_wrk_nm: {
	        		required: '<spring:message code="message.msg107" />'
				},
				ins_wrk_exp: {
	        		required: '<spring:message code="message.msg108" />'
				},
				ins_bck_opt_cd: {
	        		required: '<spring:message code="backup_management.bckOption_choice_please" />'
				},
				ins_bck_pth: {
	        		required: '<spring:message code="message.msg79" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_insert_work();
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
		
		$("#ins_bck_opt_cd","#workRegForm").change(function() {
			if($("#ins_bck_opt_cd","#workRegForm").val()=="TC000303"){
				$("#ins_file_stg_dcnt","#workRegForm").attr("disabled",true);
				$("#ins_bck_mtn_ecnt","#workRegForm").attr("disabled",true);
			}else{
				$("#ins_file_stg_dcnt","#workRegForm").attr("disabled",false);
				$("#ins_bck_mtn_ecnt","#workRegForm").attr("disabled",false);
			}
		});
	});

	/* ********************************************************
	 * 팝업시작 rman 백업
	 ******************************************************** */
	function fn_insertWorkPopStart() {
		//HA구성확인
		$.ajax({
			async : false,
			url : "/selectHaCnt.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
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
			success : function(result) {
				haCnt = result[0].hacnt;
			}
		});
		
		//PATH  정보 호출
		$.ajax({
			async : false,
			url : "/selectPathInfo.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
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
			success : function(result) {
				if (result != null && result != ",") {
					if (result[0].DATA_PATH != null) {
						$('#ins_data_pth', '#workRegForm').val(nvlPrmSet(result[0].DATA_PATH, ""));
					}
					
					if (result[1].PGRBAK != null) {
						$('#ins_bck_pth', '#workRegForm').val(nvlPrmSet(result[1].PGRBAK, ""));
					}
				}
			}
		});
	}

	/* ********************************************************
	 * work명 중복체크
	 ******************************************************** */
	function fn_ins_worknm_check() {
		if ($('#ins_wrk_nm', '#workRegForm').val() == "") {
			showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화
		$("#ins_worknm_check_alert", "#workRegForm").html('');
		$("#ins_worknm_check_alert", "#workRegForm").hide();
		
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $('#ins_wrk_nm', '#workRegForm').val()
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
					showSwalIcon('<spring:message code="backup_management.reg_possible_work_nm" />', '<spring:message code="common.close" />', '', 'success');
					$('#ins_wrk_nmChk', '#workRegForm').val("success");
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					$('#ins_wrk_nmChk', '#workRegForm').val("fail");
				}
			}
		});
	}

	/* ********************************************************
	 * 저장경로의 존재유무 체크
	 ******************************************************** */
	function fn_ins_checkFolder(keyType){
		var save_path = nvlPrmSet($("#ins_bck_pth", "#workRegForm").val(), "");

		if(save_path == "" && keyType == 2){
			showSwalIcon('<spring:message code="message.msg79" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//초기화
		$("#ins_bck_pth_check_alert", "#workRegForm").html('');
		$("#ins_bck_pth_check_alert", "#workRegForm").hide();

		$.ajax({
			async : false,
			//url : "/existDirCheck.do",
			url : "/existDirCheckMaster.do",   //2019-09-26 변승우 대리, 수정(경로체크 시 MASTER만)
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				path : save_path
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
				if (data.result != null && data.result != undefined) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							var volume = data.result.RESULT_DATA.CAPACITY;
							
							showSwalIcon('<spring:message code="message.msg100" />', '<spring:message code="common.close" />', '', 'success');
							
							if(keyType == 2){
								$("#ins_check_path2", "#workRegForm").val("Y");
								
								$("#backupVolume", "#workRegForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#backupVolume_div", "#workRegForm").show();
							}
						}else{
							if(haCnt > 1){
								showSwalIcon('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>', '<spring:message code="common.close" />', '', 'error');
							}else{
								showSwalIcon('<spring:message code="backup_management.invalid_path"/>', '<spring:message code="common.close" />', '', 'error');
							}	

							$("#ins_check_path2", "#workRegForm").val("N");
							$("#backupVolume", "#workRegForm").html('<spring:message code="common.volume" /> : 0');
							$("#backupVolume_div", "#workRegForm").show();
						}
					}else{
						showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

						$("#ins_check_path2", "#workRegForm").val("N");
						$("#backupVolume", "#workRegForm").html('<spring:message code="common.volume" /> : 0');
						$("#backupVolume_div", "#workRegForm").show();
					}
				} else {
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

					$("#ins_check_path2", "#workRegForm").val("N");
					$("#backupVolume", "#workRegForm").html('<spring:message code="common.volume" /> : 0');
					$("#backupVolume_div", "#workRegForm").show();
				}
			}
		});
	}

	/* ********************************************************
	 * Rman Backup Insert
	 ******************************************************** */
	function fn_insert_work(){
		if (!ins_valCheck()) return false;

		if($("#ins_log_file_bck_yn_chk", "#workRegForm").is(":checked") == true){
			$("#ins_log_file_bck_yn", "#workRegForm").val("Y");
		} else {
			$("#ins_log_file_bck_yn", "#workRegForm").val("N");
		}

		if($("#ins_cps_yn_chk", "#workRegForm").is(":checked") == true){
			$("#ins_cps_yn", "#workRegForm").val("Y");
		} else {
			$("#ins_cps_yn", "#workRegForm").val("N");
		}

		$.ajax({
			async : false,
			url : "/popup/workRmanWrite.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				wrk_nm : nvlPrmSet($('#ins_wrk_nm', '#workRegForm').val(), "").trim(),
				wrk_exp : nvlPrmSet($('#ins_wrk_exp', '#workRegForm').val(), ""),
				bck_opt_cd : $("#ins_bck_opt_cd", '#workRegForm').val(),
				bck_mtn_ecnt : $("#ins_bck_mtn_ecnt", '#workRegForm').val(),
				cps_yn : $("#ins_cps_yn", "#workRegForm").val(),
				log_file_bck_yn : $("#ins_log_file_bck_yn", "#workRegForm").val(),
				db_id : 0,
				bck_bsn_dscd : "TC000201",
				file_stg_dcnt : $("#ins_file_stg_dcnt", "#workRegForm").val(),
				log_file_stg_dcnt : $("#ins_log_file_stg_dcnt", "#workRegForm").val(),
				log_file_mtn_ecnt : $("#ins_log_file_mtn_ecnt", "#workRegForm").val(),
				data_pth : $("#ins_data_pth", "#workRegForm").val(),
				bck_pth : $("#ins_bck_pth", "#workRegForm").val(),
				acv_file_stgdt : $("#ins_acv_file_stgdt", "#workRegForm").val(),
				acv_file_mtncnt : $("#ins_acv_file_mtncnt", "#workRegForm").val(),
				log_file_pth : ""
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
				if(data == "F"){ //중복 work명 일경우
					showSwalIcon('<spring:message code="message.msg191" />', '<spring:message code="common.close" />', '', 'error');
					return;
				} else if (data == "I") { 
					showSwalIcon('<spring:message code="backup_management.bckPath_fail" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_reg_rman').modal('show');
					return;
				} else if(data == "S"){
					showSwalIcon('<spring:message code="message.msg106" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_reg_rman').modal('hide');
					fn_get_rman_list();
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_reg_rman').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function ins_valCheck(){
		var iChkCnt = 0;

		if(nvlPrmSet($("#ins_wrk_nmChk", "#workRegForm").val(), "") == "" || nvlPrmSet($("#ins_wrk_nmChk", "#workRegForm").val(), "") == "fail") {
			$("#ins_worknm_check_alert", "#workRegForm").html('<spring:message code="backup_management.work_overlap_check"/>');
			$("#ins_worknm_check_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_check_path2", "#workRegForm").val(), "") != "Y") {
			$("#ins_bck_pth_check_alert", "#workRegForm").html('<spring:message code="backup_management.bckPath_effective_check"/>');
			$("#ins_bck_pth_check_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#ins_file_stg_dcnt", "#workRegForm").val(), "") == "") {
			$("#ins_file_stg_dcnt_alert", "#workRegForm").html('<spring:message code="message.msg202"/>');
			$("#ins_file_stg_dcnt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_bck_mtn_ecnt", "#workRegForm").val(), "") == "") {
			$("#ins_bck_mtn_ecnt_alert", "#workRegForm").html('<spring:message code="message.msg197"/>');
			$("#ins_bck_mtn_ecnt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_log_file_stg_dcnt", "#workRegForm").val(), "") == "") {
			$("#ins_log_file_stg_dcnt_alert", "#workRegForm").html('<spring:message code="message.msg200"/>');
			$("#ins_log_file_stg_dcnt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_acv_file_stgdt", "#workRegForm").val(), "") == "") {
			$("#ins_acv_file_stgdt_alert", "#workRegForm").html('<spring:message code="message.msg198"/>');
			$("#ins_acv_file_stgdt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_acv_file_mtncnt", "#workRegForm").val(), "") == "") {
			$("#ins_acv_file_mtncnt_alert", "#workRegForm").html('<spring:message code="message.msg199"/>');
			$("#ins_acv_file_mtncnt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_log_file_mtn_ecnt", "#workRegForm").val(), "") == "") {
			$("#ins_log_file_mtn_ecnt_alert", "#workRegForm").html('<spring:message code="message.msg201"/>');
			$("#ins_log_file_mtn_ecnt_alert", "#workRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}

	/* ********************************************************
	 * 옵션 숫자 입력 blur
	 ******************************************************** */
	function fn_inputnumberChk(obj) {
		$("#" + obj.id + "_alert", "#workRegForm").html("");
		$("#" + obj.id + "_alert", "#workRegForm").hide();
	}

	/* ********************************************************
	 * work 명 변경시
	 ******************************************************** */
	function fn_ins_wrk_nmChk() {
		$('#ins_wrk_nmChk', '#workRegForm').val("fail");
		
		$("#ins_worknm_check_alert", "#workRegForm").html('');
		$("#ins_worknm_check_alert", "#workRegForm").hide();
	}

	/* ********************************************************
	 * 백업경로변경시
	 ******************************************************** */
	function fn_ins_check_pathChk(val) {
		$('#ins_check_path2', '#workRegForm').val(val);
		
		$("#ins_bck_pth_check_alert", "#workRegForm").html('');
		$("#ins_bck_pth_check_alert", "#workRegForm").hide();
	}
</script>

<div class="modal fade" id="pop_layer_reg_rman" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 40px 110px;">
		<div class="modal-content" style="width:1500px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Online <spring:message code="dashboard.Register_backup"/>
				</h4>

				<div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:698px;overflow-y:auto;">
					<form class="cmxform" id="workRegForm">
						<input type="hidden" name="ins_check_path2" id="ins_check_path2" value="N"/>
						<input type="hidden" name="ins_wrk_nmChk" id="ins_wrk_nmChk" value="fail" />
						<input type="hidden" name="ins_cps_yn" id="ins_cps_yn" value="" />
						<input type="hidden" name="ins_log_file_bck_yn" id="ins_log_file_bck_yn" value="" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>

									<div class="col-sm-8">
										<input type="text" class="form-control form-control-sm" maxlength="20" id="ins_wrk_nm" name="ins_wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onchange="fn_ins_wrk_nmChk();" onblur="this.value=this.value.trim()" tabindex=1 required />
									</div>

									<div class="col-sm-2">
										<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_ins_worknm_check()"><spring:message code="common.overlap_check" /></button>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2">
									</div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_worknm_check_alert"></div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="ins_wrk_exp" name="ins_wrk_exp" rows="2" maxlength="200" onkeyup="fn_checkWord(this,25)" placeholder="200<spring:message code='message.msg188'/>" required tabindex=2></textarea>
									</div>
								</div>
							</div>
							
							<br/>

							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="ins_bck_opt_cd" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_option" />
									</label>

									<div class="col-sm-10">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;width:300px;" name="ins_bck_opt_cd" id="ins_bck_opt_cd" tabindex=3>
											<option value=""><spring:message code="common.choice" /></option>
											<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
											<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
											<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
										</select>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="ins_data_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:10px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.data_dir" />
									</label>

									<div class="col-sm-10">
										<input type="text" class="form-control form-control-sm" maxlength="200" id="ins_data_pth" name="ins_data_pth" readonly />
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<label for="ins_bck_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_dir" />
									</label>

									<div class="col-sm-7">
										<input type="text" class="form-control form-control-sm" maxlength="200" id="ins_bck_pth" name="ins_bck_pth" onkeyup="fn_checkWord(this,200)" onKeydown="fn_ins_check_pathChk('N');" onblur="this.value=this.value.trim()" tabindex=4 />
									</div>

									<div class="col-sm-3">
										<div class="input-group input-daterange d-flex align-items-center" >
											<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_ins_checkFolder(2)"><spring:message code="common.dir_check" /></button>
											<div class="input-group-addon mx-4">
												<div class="card card-inverse-primary" id="backupVolume_div" style="display:none;border:none;">
													<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
														<p class="card-text" id="backupVolume"></p>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								
								<div class="form-group row">
									<div class="col-sm-2"></div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_bck_pth_check_alert"></div>
									</div>
								</div>

								<div class="form-group row">
									<div class="col-sm-6">
										<div class="card card-inverse-primary">
											<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
												<p class="card-text text-xl-center"><spring:message code="backup_management.backup_file_option" /></p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="card card-inverse-primary">
											<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
												<p class="card-text text-xl-center"><spring:message code="backup_management.log_file_option" /></p>
											</div>
										</div>
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<!-- 왼쪽메뉴 -->
									<label for="ins_file_stg_dcnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.full_backup_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="ins_file_stg_dcnt" name="ins_file_stg_dcnt" value="0" tabindex=5 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="common.day" /></div>
										</div>
									</div>
									
									<label for="ins_bck_mtn_ecnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.full_backup_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="ins_bck_mtn_ecnt" name="ins_bck_mtn_ecnt" value="0" tabindex=6 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>
									
									
									<!-- 오른쪽 메뉴 -->
									<label for="ins_log_file_bck_yn_chk" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.log_file_backup_yn" />
									</label>

									<div class="col-sm-1">
										<div class="onoffswitch-pop">
											<input type="checkbox" name="ins_log_file_bck_yn_chk" class="onoffswitch-pop-checkbox" id="ins_log_file_bck_yn_chk" />
											<label class="onoffswitch-pop-label" for="ins_log_file_bck_yn_chk">
												<span class="onoffswitch-pop-inner_YN"></span>
												<span class="onoffswitch-pop-switch"></span>
											</label>
										</div>
									</div>

									<label for="ins_log_file_stg_dcnt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.server_log_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="ins_log_file_stg_dcnt" name="ins_log_file_stg_dcnt" value="0" tabindex=9 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="schedule.day" /></div>
										</div>
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_file_stg_dcnt_alert"></div>
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_bck_mtn_ecnt_alert"></div>
									</div>
									<div class="col-sm-3">
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_log_file_stg_dcnt_alert"></div>
									</div>
								</div>
								
								
								<div class="form-group row div-form-margin-z">
									<!-- 왼쪽메뉴 -->
									<label for="ins_acv_file_stgdt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.archive_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="ins_acv_file_stgdt" name="ins_acv_file_stgdt" value="0" tabindex=7 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="common.day" /></div>
										</div>
									</div>
									
									<label for="ins_acv_file_mtncnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.archive_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="ins_acv_file_mtncnt" name="ins_acv_file_mtncnt" value="0" tabindex=8 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>

									<!-- 오른쪽 메뉴 -->
									<label class="col-sm-2_6 col-form-label pop-label-index" style="padding-top:7px;"></label>

									<label for="ins_log_file_mtn_ecnt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.server_log_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="ins_log_file_mtn_ecnt" name="ins_log_file_mtn_ecnt" value="0" tabindex=10 onchange="fn_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_acv_file_stgdt_alert"></div>
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_acv_file_mtncnt_alert"></div>
									</div>
									<div class="col-sm-3">
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_log_file_mtn_ecnt_alert"></div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z" >
									<label for="ins_acv_file_stgdt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.compress" />
									</label>

									<div class="col-sm-1_5">
										<div class="onoffswitch-pop">
											<input type="checkbox" name="ins_cps_yn_chk" class="onoffswitch-pop-checkbox" id="ins_cps_yn_chk" />
											<label class="onoffswitch-pop-label" for="ins_cps_yn_chk">
												<span class="onoffswitch-pop-inner_YN"></span>
												<span class="onoffswitch-pop-switch"></span>
											</label>
										</div>
									</div>
									
									<div class="col-sm-9">
									</div>
								</div>
							</div>
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
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