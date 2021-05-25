<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : rmanRegReForm.jsp
	* @Description : rman 백업수정 화면
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
	var haCnt = 0;
	var save_path = "";

	$(window.document).ready(function() {
		//validate
 	    $("#workModForm").validate({
	        rules: {
	        	mod_wrk_nm: {
					required: true
				},
				mod_wrk_exp: {
					required: true
				},
				mod_bck_opt_cd: {
					required: true
				},
				mod_bck_pth: {
					required: true
				}
	        },
	        messages: {
	        	mod_wrk_nm: {
	        		required: '<spring:message code="message.msg107" />'
				},
				mod_wrk_exp: {
	        		required: '<spring:message code="message.msg108" />'
				},
				mod_bck_opt_cd: {
	        		required: '<spring:message code="backup_management.bckOption_choice_please" />'
				},
				mod_bck_pth: {
	        		required: '<spring:message code="message.msg79" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_update_work();
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
		
		$("#mod_bck_opt_cd","#workModForm").change(function() {
			if($("#mod_bck_opt_cd","#workModForm").val()=="TC000303"){
				$("#mod_file_stg_dcnt","#workModForm").attr("disabled",true);
				$("#mod_bck_mtn_ecnt","#workModForm").attr("disabled",true);
			}else{
				$("#mod_file_stg_dcnt","#workModForm").attr("disabled",false);
				$("#mod_bck_mtn_ecnt","#workModForm").attr("disabled",false);
			}
		});
	});

	/* ********************************************************
	 * 팝업시작 rman 수정
	 ******************************************************** */
	function fn_modWorkPopStart() {

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
		
		//용량체크
		fn_mod_checkFolder_init(2);
	}

	/* ********************************************************
	 * 시작시 폴더 용량 가져오기
	 ******************************************************** */
	function fn_mod_checkFolder_init(keyType){
		save_path = nvlPrmSet($("#mod_bck_pth", "#workModForm").val(), "");

		//초기화
		$("#mod_bck_pth_check_alert", "#workModForm").html('');
		$("#mod_bck_pth_check_alert", "#workModForm").hide();
		
		if(save_path == "" && keyType == 2){
			$("#mod_check_path2", "#workModForm").val("N");
			$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
			$("#mod_backupVolume_div", "#workModForm").show();
			return;
		}

		$.ajax({
			async : false,
			/* url : "/existDirCheck.do", */
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
				if (data != null) {
					if (data.result != null && data.result != undefined) {
						if(data.result.ERR_CODE == ""){
							if(data.result.RESULT_DATA.IS_DIRECTORY == 0){ 
								var volume = data.result.RESULT_DATA.CAPACITY;

								if(keyType == 2){
									$("#mod_check_path2", "#workModForm").val("Y");
									
									$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : '+volume);
									$("#mod_backupVolume_div", "#workModForm").show();
								}
							}else{
								if(haCnt > 1){
									$("#mod_bck_pth_check_alert", "#workModForm").html('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>');
								}else{
									$("#mod_bck_pth_check_alert", "#workModForm").html('<spring:message code="backup_management.invalid_path"/>');
								}	
								
								$("#mod_bck_pth_check_alert", "#workModForm").show();

								$("#mod_check_path2", "#workModForm").val("N");
								$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
								$("#mod_backupVolume_div", "#workModForm").show();
							}
						}else{
							$("#mod_bck_pth_check_alert", "#workModForm").html('<spring:message code="message.msg76" />');
							$("#mod_bck_pth_check_alert", "#workModForm").show();

							$("#mod_check_path2", "#workModForm").val("N");
							$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
							$("#mod_backupVolume_div", "#workModForm").show();
						}
					} else {
						$("#mod_check_path2", "#workModForm").val("Y");
						$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
						$("#mod_backupVolume_div", "#workModForm").show();
					}

				} else {
					$("#mod_bck_pth_check_alert", "#workModForm").html('<spring:message code="message.msg76" />');
					$("#mod_bck_pth_check_alert", "#workModForm").show();

					$("#mod_check_path2", "#workModForm").val("N");
					$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
					$("#mod_backupVolume_div", "#workModForm").show();
				}
			}
		});
	}
	

	/* ********************************************************
	 * 저장경로의 존재유무 체크
	 ******************************************************** */
	function fn_mod_checkFolder(keyType){
		save_path = nvlPrmSet($("#mod_bck_pth", "#workModForm").val(), "");

		if(save_path == "" && keyType == 2){
			showSwalIcon('<spring:message code="message.msg79" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//초기화
		$("#mod_bck_pth_check_alert", "#workModForm").html('');
		$("#mod_bck_pth_check_alert", "#workModForm").hide();

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
								$("#mod_check_path2", "#workModForm").val("Y");
								
								$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : '+volume);
								$("#mod_backupVolume_div", "#workModForm").show();
							}
						}else{
							if(haCnt > 1){
								showSwalIcon('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>', '<spring:message code="common.close" />', '', 'error');
							}else{
								showSwalIcon('<spring:message code="backup_management.invalid_path"/>', '<spring:message code="common.close" />', '', 'error');
							}	

							$("#mod_check_path2", "#workModForm").val("N");
							$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
							$("#mod_backupVolume_div", "#workModForm").show();
						}
					}else{
						showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

						$("#mod_check_path2", "#workModForm").val("N");
						$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
						$("#mod_backupVolume_div", "#workModForm").show();
					}
				} else {
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

					$("#mod_check_path2", "#workModForm").val("N");
					$("#mod_backupVolume", "#workModForm").html('<spring:message code="common.volume" /> : 0');
					$("#mod_backupVolume_div", "#workModForm").show();
				}
			}
		});
	}

	/* ********************************************************
	 * 백업경로 변경시
	 ******************************************************** */
	function fn_mod_check_pathChk(val) {
		$('#mod_check_path2', '#workModForm').val(val);
		
		$("#mod_bck_pth_check_alert", "#workModForm").html('');
		$("#mod_bck_pth_check_alert", "#workModForm").hide();
	}

	/* ********************************************************
	 * 옵션 숫자 입력 blur
	 ******************************************************** */
	function fn_mod_inputnumberChk(obj) {
		$("#" + obj.id + "_alert", "#workModForm").html("");
		$("#" + obj.id + "_alert", "#workModForm").hide();
	}
	

	/* ********************************************************
	 * Rman Backup update
	 ******************************************************** */
	function fn_update_work(){
		if (!mod_valCheck()) return false;
		
		if($("#mod_log_file_bck_yn_chk", "#workModForm").is(":checked") == true){
			$("#mod_log_file_bck_yn", "#workModForm").val("Y");
		} else {
			$("#mod_log_file_bck_yn", "#workModForm").val("N");
		}
		
		if($("#mod_cps_yn_chk", "#workModForm").is(":checked") == true){
			$("#mod_cps_yn", "#workModForm").val("Y");
		} else {
			$("#mod_cps_yn", "#workModForm").val("N");
		}
		
		$.ajax({
			async : false,
			url : "/popup/workRmanReWrite.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				bck_wrk_id : $("#mod_bck_wrk_id","#workModForm").val(),
				wrk_id : $("#mod_wrk_id","#workModForm").val(),
				wrk_nm : nvlPrmSet($('#mod_wrk_nm', '#workModForm').val(), "").trim(),
				wrk_exp : nvlPrmSet($('#mod_wrk_exp', '#workModForm').val(), ""),
				bck_opt_cd : $("#mod_bck_opt_cd", '#workModForm').val(),
				bck_mtn_ecnt : $("#mod_bck_mtn_ecnt", '#workModForm').val(),
				cps_yn : nvlPrmSet($('#mod_cps_yn', '#workModForm').val(), "N"),
				log_file_bck_yn : nvlPrmSet($("#mod_log_file_bck_yn", "#workModForm").val(), "N"),
				file_stg_dcnt : $("#mod_file_stg_dcnt", "#workModForm").val(),
				log_file_stg_dcnt : $("#mod_log_file_stg_dcnt", "#workModForm").val(),
				log_file_mtn_ecnt : $("#mod_log_file_mtn_ecnt", "#workModForm").val(),
				data_pth : $("#mod_data_pth", "#workModForm").val(),
				bck_pth : $("#mod_bck_pth", "#workModForm").val(),
				acv_file_stgdt : $("#mod_acv_file_stgdt", "#workModForm").val(),
				acv_file_mtncnt : $("#mod_acv_file_mtncnt", "#workModForm").val(),
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
				if(data == "S"){
					showSwalIcon('<spring:message code="message.msg155" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_mod_rman').modal('hide');

					if ($("#rman_call_gbn", "#search_rmanReForm").val() == "backup_sdt") {
	 					selectSdtTab("week");
	 					fn_selectBckSchedule();
					} else {
						fn_get_rman_list();
					}
				} else if (data == "I") { 
					showSwalIcon('<spring:message code="backup_management.bckPath_fail" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_mod_rman').modal('show');
					return;
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_mod_rman').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function mod_valCheck(){
		var iChkCnt = 0;

		if(nvlPrmSet($("#mod_check_path2", "#workModForm").val(), "") != "Y") {
			$("#mod_bck_pth_check_alert", "#workModForm").html('<spring:message code="backup_management.bckPath_effective_check"/>');
			$("#mod_bck_pth_check_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#mod_file_stg_dcnt", "#workModForm").val(), "") == "") {
			$("#mod_file_stg_dcnt_alert", "#workModForm").html('<spring:message code="message.msg202"/>');
			$("#mod_file_stg_dcnt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_bck_mtn_ecnt", "#workModForm").val(), "") == "") {
			$("#mod_bck_mtn_ecnt_alert", "#workModForm").html('<spring:message code="message.msg197"/>');
			$("#mod_bck_mtn_ecnt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_log_file_stg_dcnt", "#workModForm").val(), "") == "") {
			$("#mod_log_file_stg_dcnt_alert", "#workModForm").html('<spring:message code="message.msg200"/>');
			$("#mod_log_file_stg_dcnt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_acv_file_stgdt", "#workModForm").val(), "") == "") {
			$("#mod_acv_file_stgdt_alert", "#workModForm").html('<spring:message code="message.msg198"/>');
			$("#mod_acv_file_stgdt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_acv_file_mtncnt", "#workModForm").val(), "") == "") {
			$("#mod_acv_file_mtncnt_alert", "#workModForm").html('<spring:message code="message.msg199"/>');
			$("#mod_acv_file_mtncnt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_log_file_mtn_ecnt", "#workModForm").val(), "") == "") {
			$("#mod_log_file_mtn_ecnt_alert", "#workModForm").html('<spring:message code="message.msg201"/>');
			$("#mod_log_file_mtn_ecnt_alert", "#workModForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}

</script>

<form name="search_rmanReForm" id="search_rmanReForm" method="post">
	<input type="hidden" name="rman_call_gbn"  id="rman_call_gbn" value="" />
</form>

<div class="modal fade" id="pop_layer_mod_rman" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 40px 110px;">
		<div class="modal-content" style="width:1500px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Online <spring:message code="backup_management.bck_mod"/>
				</h4>
				
				<div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:698px;overflow-y:auto;">
					<form class="cmxform" id="workModForm">
						<input type="hidden" name="mod_check_path2" id="mod_check_path2" value="Y"/>
						<input type="hidden" name="mod_bck_wrk_id" id="mod_bck_wrk_id" value="" />
						<input type="hidden" name="mod_cps_yn" id="mod_cps_yn" value="" />
						<input type="hidden" name="mod_log_file_bck_yn" id="mod_log_file_bck_yn" value="" />
						<input type="hidden" name="mod_wrk_id" id="mod_wrk_id" value="" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="mod_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>

									<div class="col-sm-10">
										<input type="text" class="form-control form-control-sm" maxlength="20" id="mod_wrk_nm" name="mod_wrk_nm" required readonly />
									</div>
								</div>
				
								<div class="form-group row div-form-margin-z">
									<label for="mod_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="mod_wrk_exp" name="mod_wrk_exp" rows="2" maxlength="200" onkeyup="fn_checkWord(this,25)" placeholder="200<spring:message code='message.msg188'/>" required tabindex=1></textarea>
									</div>
								</div>
							</div>
							
							<br/>

							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="mod_bck_opt_cd" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_option" />
									</label>

									<div class="col-sm-10">
										<select class="form-control form-control-xsm" style="margin-right: 1rem;width:300px;" name="mod_bck_opt_cd" id="mod_bck_opt_cd" tabindex=3>
											<option value=""><spring:message code="common.choice" /></option>
											<option value="TC000301"><spring:message code="backup_management.full_backup" /></option>
											<option value="TC000302"><spring:message code="backup_management.incremental_backup" /></option>
											<option value="TC000303"><spring:message code="backup_management.change_log_backup" /></option>
										</select>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="mod_data_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:10px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.data_dir" />
									</label>

									<div class="col-sm-10">
										<input type="text" class="form-control form-control-sm" maxlength="200" id="mod_data_pth" name="mod_data_pth" readonly />
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<label for="mod_bck_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_dir" />
									</label>

									<div class="col-sm-7">
										<input type="text" class="form-control form-control-sm" maxlength="200" id="mod_bck_pth" name="mod_bck_pth" onkeyup="fn_checkWord(this,200)" onKeydown="fn_mod_check_pathChk('N');" onblur="this.value=this.value.trim()" tabindex=4 />
									</div>

									<div class="col-sm-3">
										<div class="input-group input-daterange d-flex align-items-center" >
											<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_mod_checkFolder(2)"><spring:message code="common.dir_check" /></button>
											<div class="input-group-addon mx-4">
												<div class="card card-inverse-primary" id="mod_backupVolume_div" style="display:none;border:none;">
													<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
														<p class="card-text" id="mod_backupVolume"></p>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								
								<div class="form-group row">
									<div class="col-sm-2"></div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_bck_pth_check_alert"></div>
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
									<label for="mod_file_stg_dcnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.full_backup_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="mod_file_stg_dcnt" name="mod_file_stg_dcnt" min="0" tabindex=5 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="common.day" /></div>
										</div>
									</div>
									
									<label for="mod_bck_mtn_ecnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.full_backup_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="mod_bck_mtn_ecnt" name="mod_bck_mtn_ecnt" min="0" tabindex=6 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>
									
									
									<!-- 오른쪽 메뉴 -->
									<label for="mod_log_file_bck_yn_chk" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.log_file_backup_yn" />
									</label>

									<div class="col-sm-1">
										<div class="onoffswitch-pop">
											<input type="checkbox" name="mod_log_file_bck_yn_chk" class="onoffswitch-pop-checkbox" id="mod_log_file_bck_yn_chk" />
											<label class="onoffswitch-pop-label" for="mod_log_file_bck_yn_chk">
												<span class="onoffswitch-pop-inner_YN"></span>
												<span class="onoffswitch-pop-switch"></span>
											</label>
										</div>
									</div>

									<label for="mod_log_file_stg_dcnt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.server_log_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="mod_log_file_stg_dcnt" name="mod_log_file_stg_dcnt"  min="0" tabindex=9 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="common.day" /></div>
										</div>
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_file_stg_dcnt_alert"></div>
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_bck_mtn_ecnt_alert"></div>
									</div>
									<div class="col-sm-3">
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_log_file_stg_dcnt_alert"></div>
									</div>
								</div>
								
								
								<div class="form-group row div-form-margin-z">
									<!-- 왼쪽메뉴 -->
									<label for="mod_acv_file_stgdt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.archive_file_keep_day" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-17px;" maxlength="3" id="mod_acv_file_stgdt" name="mod_acv_file_stgdt" min="0" tabindex=7 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="common.day" /></div>
										</div>
									</div>
									
									<label for="mod_acv_file_mtncnt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.archive_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="mod_acv_file_mtncnt" name="mod_acv_file_mtncnt" min="0" tabindex=8 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>

									<!-- 오른쪽 메뉴 -->
									<label class="col-sm-2_6 col-form-label pop-label-index" style="padding-top:7px;"></label>

									<label for="mod_log_file_mtn_ecnt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.server_log_file_maintenance_count" />
									</label>

									<div class="col-sm-1_5">
										<div class="input-group input-daterange d-flex align-items-center" >
											<input type="number" class="form-control form-control-sm"  style="width:50px;margin-right:-22px;" maxlength="3" id="mod_log_file_mtn_ecnt" name="mod_log_file_mtn_ecnt" min="0" tabindex=10 onchange="fn_mod_inputnumberChk(this);" />
											<div class="input-group-addon mx-4" style="font-size: 12px;"><spring:message code="backup_management.count" /></div>
										</div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_acv_file_stgdt_alert"></div>
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_acv_file_mtncnt_alert"></div>
									</div>
									<div class="col-sm-3">
									</div>
									<div class="col-sm-3">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="mod_log_file_mtn_ecnt_alert"></div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z" >
									<label for="mod_acv_file_stgdt" class="col-sm-1_7 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="backup_management.compress" />
									</label>

									<div class="col-sm-1_5">
										<div class="onoffswitch-pop">
											<input type="checkbox" name="mod_cps_yn_chk" class="onoffswitch-pop-checkbox" id="mod_cps_yn_chk" />
											<label class="onoffswitch-pop-label" for="mod_cps_yn_chk">
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
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.modify" />' />
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