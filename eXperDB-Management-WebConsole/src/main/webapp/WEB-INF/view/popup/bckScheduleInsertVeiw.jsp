<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : bckScheduleInsertVeiw.jsp
	* @Description : 주간 백업스케줄 등록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>

<script type="text/javascript">
	var scd_nmChk = "fail";
	var ins_view_haCnt = 0;
	
	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		//validate
		$("#bckScdInsViewForm").validate({
			rules: {
				ins_view_scd_nm : {
					required: true
				},
				ins_view_bck : {
					required: true
				},
				ins_view_bck_opt_cd : {
	        		required: function(){
	        			if(nvlPrmSet($("#ins_view_bck", "#bckScdInsViewForm").val(),"") == "rman") {
	        				if($('#ins_view_bck_opt_cd', "#bckScdInsViewForm").val() == ""){
	        					return true;
	        				}
	        			}

	        			return false;
	        		}
				},
				ins_view_db_id : {
	        		required: function(){
	        			if(nvlPrmSet($("#ins_view_bck", "#bckScdInsViewForm").val(),"") == "dump") {
	        				if($('#ins_view_db_id', "#bckScdInsViewForm").val() == ""){
	        					return true;
	        				}
	        			}

	        			return false;
	        		}
				}
			},
			messages: {
				ins_view_scd_nm : {
					required: '<spring:message code="message.msg67" />'
				},
				ins_view_bck : {
					required: '<spring:message code="backup_management.bckOption_choice_please" />'
				},
				ins_view_bck_opt_cd : {
					required: '<spring:message code="backup_management.bckOption_choice_please" />'
				},
				ins_view_bck_opt_cd : {
					required: '<spring:message code="backup_management.database_choice_please" />'
				}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_insert_bckScdCheck();
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
	 * 주별스케줄 등록 초기화
	 ******************************************************** */
	function fn_ins_view_chogihwa(result) {
		$("#ins_view_db_id", "#bckScdInsViewForm").html("");
		$("#ins_view_hour","#bckScdInsViewForm").html("");
		$("#ins_view_min","#bckScdInsViewForm").html("");
		
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").hide();
		
		$("#ins_view_data_pth_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_data_pth_check_div", "#bckScdInsViewForm").hide();

		$("#ins_view_backup_pth_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_backup_pth_check_div", "#bckScdInsViewForm").hide();
		
		$("#ins_view_save_pth_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_save_pth_check_div", "#bckScdInsViewForm").hide();

		$("#ins_view_scd_nmChk","#bckScdInsViewForm").val("fail");
		$("#ins_view_check_path1","#bckScdInsViewForm").val("N");
		$("#ins_view_check_path3","#bckScdInsViewForm").val("N");
		$("#ins_view_check_path5","#bckScdInsViewForm").val("N");

		if (result != null) {
			$("#ins_view_db_svr_id", "#bckScdInsViewForm").val(result.db_svr_id);

			if (result.view_dbList != null) {
				$("#ins_view_db_id", "#bckScdInsViewForm").append('<option value=""><spring:message code="common.choice" /></option>');
				
				for (var idx=0; idx < result.view_dbList.length; idx++) {
					$("#ins_view_db_id", "#bckScdInsViewForm").append("<option value='"+ result.view_dbList[idx].db_id + "'>" + result.view_dbList[idx].db_nm + "</option>");
				}
			}
		}
	}

	/* ********************************************************
	 * 팝업시작 백업 스케줄 등록
	 ******************************************************** */
	function fn_insertScdViewPopStart() {
		//HA구성확인
		$.ajax({
			async : false,
			url : "/selectHaCnt.do",
			data : {
				db_svr_id : $("#ins_view_db_svr_id","#bckScdInsViewForm").val()
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
				
				if (result != null) {
					if (result[0] != null) {
						ins_view_haCnt = result[0].hacnt;
					}
				}

			}
		});
		
		//화면 setting
		$("#ins_view_r_data_pth","#bckScdInsViewForm").hide();
		$("#ins_view_r_bck_pth","#bckScdInsViewForm").hide();
		$("#ins_view_d_bck_pth","#bckScdInsViewForm").hide();
		$("#ins_view_rman_bck_opt","#bckScdInsViewForm").hide();
		$("#ins_view_dump_bck_opt","#bckScdInsViewForm").hide();
		
		//날짜 setting
		fn_ins_view_makeHour();
		fn_ins_view_makeMin();
	}
	
	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_ins_view_makeHour(){
		var hour = "";
		var hourHtml ="";
		
		hourHtml += '<select class="form-control" name="ins_view_exe_h" id="ins_view_exe_h">';	
		for(var i=0; i<=23; i++){
			if(i >= 0 && i<10){
				hour = "0" + i;
			}else{
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">'+hour+'</option>';
		}
		hourHtml += '</select> <spring:message code="schedule.our" />&emsp;';	
		$("#ins_view_hour","#bckScdInsViewForm").append(hourHtml);
	}

	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_ins_view_makeMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="form-control" name="ins_view_exe_m" id="ins_view_exe_m">';	
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		minHtml += '</select> <spring:message code="schedule.minute" />&emsp;';	
		$("#ins_view_min","#bckScdInsViewForm").append(minHtml);
	}

	/* ********************************************************
	 * work명 중복체크
	 ******************************************************** */
	function fn_ins_view_scdnm_check() {
		if ($('#ins_view_scd_nm', '#bckScdInsViewForm').val() == "") {
			showSwalIcon('<spring:message code="message.msg44" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").hide();

		$.ajax({
			url : '/scd_nmCheck.do',
			type : 'post',
			data : {
				scd_nm : $("#ins_view_scd_nm", "#bckScdInsViewForm").val().trim()
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
					showSwalIcon('<spring:message code="message.msg45" />', '<spring:message code="common.close" />', '', 'success');
					$("#ins_view_scd_nmChk","#bckScdInsViewForm").val("success");
				} else {
					showSwalIcon('<spring:message code="message.msg46" />', '<spring:message code="common.close" />', '', 'error');
					$("#ins_view_scd_nmChk","#bckScdInsViewForm").val("fail");
				}
			}
		});
	}

	/* ********************************************************
	 * 스케줄명 명 변경시
	 ******************************************************** */
	function fn_ins_view_scd_nmChk() {
		$('#ins_view_scd_nmChk', '#bckScdInsViewForm').val("fail");
		
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").html('');
		$("#ins_view_scd_check_alert", "#bckScdInsViewForm").hide();
	}

	/* ********************************************************
	 * 백업설정 변경
	 ******************************************************** */
	function fn_ins_view_bck(){
		//path 정보 호출
		 $.ajax({
			async : false,
			url : "/selectPathInfo.do",
			data : {
				db_svr_id : $("#ins_view_db_svr_id","#bckScdInsViewForm").val()
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

				if (result != null) {
					if (result[0] != null && result[0].DATA_PATH != undefined) {
						$('#ins_view_data_pth', '#bckScdInsViewForm').val(nvlPrmSet(result[0].DATA_PATH, ""));
					}
					
					//document.getElementById("rlog_file_pth").value=result[1].PGRLOG;	
					
					if (result[1] != null && result[1].PGRBAK != undefined) {
						$('#ins_view_bck_pth', '#bckScdInsViewForm').val(nvlPrmSet(result[1].PGRBAK, ""));
					}

					//document.getElementById("dlog_file_pth").value=result[1].PGDLOG;
					
					if (result[1] != null && result[1].PGDBAK != undefined) {
						$('#ins_view_save_pth', '#bckScdInsViewForm').val(nvlPrmSet(result[1].PGDBAK, ""));
					}
				}

				fn_ins_view_checkFolderVol(1);
				//fn_ins_view_checkFolderVol(2);
				fn_ins_view_checkFolderVol(3);
				//fn_ins_view_checkFolderVol(4);
				fn_ins_view_checkFolderVol(5);
			}
		}); 

		var bck = nvlPrmSet($("#ins_view_bck", "#bckScdInsViewForm").val(), "");
		
		if(bck == "rman"){
			$("#ins_view_rman_bck_opt", "#bckScdInsViewForm").show();
			//$("#r_log_pth").show();
			$("#ins_view_r_data_pth", "#bckScdInsViewForm").show();
			$("#ins_view_r_bck_pth", "#bckScdInsViewForm").show();

			//$("#d_log_pth").hide();
			$("#ins_view_d_bck_pth", "#bckScdInsViewForm").hide();
			$("#ins_view_dump_bck_opt", "#bckScdInsViewForm").hide();
		}else if(bck == "dump"){
			$("#ins_view_d_bck_pth", "#bckScdInsViewForm").show();
			//$("#d_log_pth").show();
			$("#ins_view_dump_bck_opt", "#bckScdInsViewForm").show();
			//$("#r_log_pth").hide();
			$("#ins_view_r_data_pth", "#bckScdInsViewForm").hide();
			$("#ins_view_r_bck_pth", "#bckScdInsViewForm").hide();
			$("#ins_view_rman_bck_opt", "#bckScdInsViewForm").hide();
		}else{
			$("#ins_view_d_bck_pth", "#bckScdInsViewForm").hide();
			//$("#d_log_pth").hide();
			//$("#r_log_pth").hide();
			$("#ins_view_r_data_pth", "#bckScdInsViewForm").hide();
			$("#ins_view_r_bck_pth", "#bckScdInsViewForm").hide();
			$("#ins_view_rman_bck_opt", "#bckScdInsViewForm").hide();
			$("#ins_view_dump_bck_opt", "#bckScdInsViewForm").hide();
		}	
	} 	

	/* ********************************************************
	 * 용량 체크 
	 ******************************************************** */
	function fn_ins_view_checkFolderVol(keyType){
		var save_path = "";
		 
		if (keyType == 1) {
			save_path = $('#ins_view_data_pth', '#bckScdInsViewForm').val().trim();
		}/* else if(keyType == 2){
			save_path = $("#rlog_file_pth").val();
		} */else if(keyType == 3){
			save_path = $('#ins_view_bck_pth', '#bckScdInsViewForm').val().trim();
		}/* else if(keyType == 4){
			save_path = $("#dlog_file_pth").val();
		} */else{
			save_path = $('#ins_view_save_pth', '#bckScdInsViewForm').val().trim();
		}

		if (save_path == null || save_path == "") {
			if(keyType == 1){
				$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
				
				$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
				$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
				$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
			}/* else if(keyType == 2) {
				$("#rlogVolume").empty();
				$( "#rlogVolume" ).append(volume);
			} */else if(keyType == 3) {
				$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
				
				$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
				$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
				$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
			}/* else if(keyType == 4) {
				$("#dlogVolume").empty();
				$( "#dlogVolume" ).append(volume);
			} */else if(keyType == 5) {
				$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
				
				$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
				$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
				$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
			}
			
			return;
		}
		
		if (keyType == 1) {
			$("#ins_view_data_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_data_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path1","#bckScdInsViewForm").val("N");
		}/* else if(keyType == 2){
			save_path = $("#rlog_file_pth").val();
		} */else if(keyType == 3){
			$("#ins_view_backup_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_backup_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path3","#bckScdInsViewForm").val("N");
		}/* else if(keyType == 4){
			save_path = $("#dlog_file_pth").val();
		} */else{
			$("#ins_view_save_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_save_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path5","#bckScdInsViewForm").val("N");
		}

		$.ajax({
			async : false,
			//url : "/existDirCheck.do",
			url : "/existDirCheckMaster.do",   //2019-09-26 변승우 대리, 수정(경로체크 시 MASTER만)
			data : {
				db_svr_id : $("#ins_view_db_svr_id", "#bckScdInsViewForm").val(),
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

							if(keyType == 1){
								$("#ins_view_check_path1", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_dataVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 2) {
								$("#rlogVolume").empty();
								$( "#rlogVolume" ).append(volume);
							} */else if(keyType == 3) {
								$("#ins_view_check_path3", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_backupVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 4) {
								$("#dlogVolume").empty();
								$( "#dlogVolume" ).append(volume);
							} */else if(keyType == 5) {
								$("#ins_view_check_path5", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_saveVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
							}
						}else{
							if(haCnt > 1){
								showSwalIcon('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>', '<spring:message code="common.close" />', '', 'error');
							}else{
								showSwalIcon('<spring:message code="backup_management.invalid_path"/>', '<spring:message code="common.close" />', '', 'error');
							}

							if(keyType == 1){
								$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 2) {
								$("#rlogVolume").empty();
								$( "#rlogVolume" ).append(volume);
							} */else if(keyType == 3) {
								$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 4) {
								$("#dlogVolume").empty();
								$( "#dlogVolume" ).append(volume);
							} */else if(keyType == 5) {
								$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
							}
						}	
					}else{
						showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

						if(keyType == 1){
							$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
						}/* else if(keyType == 2) {
							$("#rlogVolume").empty();
							$( "#rlogVolume" ).append(volume);
						} */else if(keyType == 3) {
							$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
						}/* else if(keyType == 4) {
							$("#dlogVolume").empty();
							$( "#dlogVolume" ).append(volume);
						} */else if(keyType == 5) {
							$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
						}
					}
				} else {
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

					if(keyType == 1){
						$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
					}/* else if(keyType == 2) {
						$("#rlogVolume").empty();
						$( "#rlogVolume" ).append(volume);
					} */else if(keyType == 3) {
						$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
					}/* else if(keyType == 4) {
						$("#dlogVolume").empty();
						$( "#dlogVolume" ).append(volume);
					} */else if(keyType == 5) {
						$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
					}
				}
	 		}
	 	});
	 }
	
	
	/* ********************************************************
	 * 용량 체크 
	 ******************************************************** */
	function fn_ins_view_checkFolder(keyType){
		var save_path = "";
		 
		if (keyType == 1) {
			save_path = $('#ins_view_data_pth', '#bckScdInsViewForm').val().trim();
		}/* else if(keyType == 2){
			save_path = $("#rlog_file_pth").val();
		} */else if(keyType == 3){
			save_path = $('#ins_view_bck_pth', '#bckScdInsViewForm').val().trim();
		}/* else if(keyType == 4){
			save_path = $("#dlog_file_pth").val();
		} */else{
			save_path = $('#ins_view_save_pth', '#bckScdInsViewForm').val().trim();
		}

		if (save_path == null || save_path == "") {
			if(keyType == 1){
				showSwalIcon('<spring:message code="message.msg77"/>', '<spring:message code="common.close" />', '', 'warning');
			} else if(keyType == 2) {
				showSwalIcon('<spring:message code="message.msg78"/>', '<spring:message code="common.close" />', '', 'warning');
			} else if(keyType == 3) {
				showSwalIcon('<spring:message code="message.msg79"/>', '<spring:message code="common.close" />', '', 'warning');
			} else if(keyType == 4) {
				showSwalIcon('<spring:message code="message.msg78"/>', '<spring:message code="common.close" />', '', 'warning');
			} else if(keyType == 5) {
				showSwalIcon('<spring:message code="message.msg79"/>', '<spring:message code="common.close" />', '', 'warning');
			}
			
			return;
		}

		if (keyType == 1) {
			$("#ins_view_data_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_data_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path1","#bckScdInsViewForm").val("N");
		}/* else if(keyType == 2){
			save_path = $("#rlog_file_pth").val();
		} */else if(keyType == 3){
			$("#ins_view_backup_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_backup_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path3","#bckScdInsViewForm").val("N");
		}/* else if(keyType == 4){
			save_path = $("#dlog_file_pth").val();
		} */else{
			$("#ins_view_save_pth_check_alert", "#bckScdInsViewForm").html('');
			$("#ins_view_save_pth_check_div", "#bckScdInsViewForm").hide();
			
			$("#ins_view_check_path5","#bckScdInsViewForm").val("N");
		}

		$.ajax({
			async : false,
			//url : "/existDirCheck.do",
			url : "/existDirCheckMaster.do",   //2019-09-26 변승우 대리, 수정(경로체크 시 MASTER만)
			data : {
				db_svr_id : $("#ins_view_db_svr_id", "#bckScdInsViewForm").val(),
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

							showSwalIcon('<spring:message code="message.msg100"/>', '<spring:message code="common.close" />', '', 'success');
							
							if(keyType == 1){
								$("#ins_view_check_path1", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_dataVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 2) {
								$("#rlogVolume").empty();
								$( "#rlogVolume" ).append(volume);
							} */else if(keyType == 3) {
								$("#ins_view_check_path3", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_backupVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 4) {
								$("#dlogVolume").empty();
								$( "#dlogVolume" ).append(volume);
							} */else if(keyType == 5) {
								$("#ins_view_check_path5", "#bckScdInsViewForm").val("Y");
								
								$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_saveVolume", "#bckScdInsViewForm").html("<spring:message code="common.volume" /> : "+volume);
								$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
							}
						}else{
							showSwalIcon('<spring:message code="message.msg75"/>', '<spring:message code="common.close" />', '', 'error');

							if(keyType == 1){
								$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 2) {
								$("#rlogVolume").empty();
								$( "#rlogVolume" ).append(volume);
							} */else if(keyType == 3) {
								$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
							}/* else if(keyType == 4) {
								$("#dlogVolume").empty();
								$( "#dlogVolume" ).append(volume);
							} */else if(keyType == 5) {
								$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
								
								$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
								$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
								$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
							}
						}	
					}else{
						showSwalIcon('<spring:message code="message.msg75" />', '<spring:message code="common.close" />', '', 'error');

						if(keyType == 1){
							$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
						}/* else if(keyType == 2) {
							$("#rlogVolume").empty();
							$( "#rlogVolume" ).append(volume);
						} */else if(keyType == 3) {
							$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
						}/* else if(keyType == 4) {
							$("#dlogVolume").empty();
							$( "#dlogVolume" ).append(volume);
						} */else if(keyType == 5) {
							$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
							
							$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
							$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
							$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
						}
					}
				} else {
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');

					if(keyType == 1){
						$("#ins_view_check_path1", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
					}/* else if(keyType == 2) {
						$("#rlogVolume").empty();
						$( "#rlogVolume" ).append(volume);
					} */else if(keyType == 3) {
						$("#ins_view_check_path3", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
					}/* else if(keyType == 4) {
						$("#dlogVolume").empty();
						$( "#dlogVolume" ).append(volume);
					} */else if(keyType == 5) {
						$("#ins_view_check_path5", "#bckScdInsViewForm").val("N");
						
						$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
						$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
						$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
					}
				}
	 		}
	 	});
	 }
	
	/* ********************************************************
	 * 백업경로변경시
	 ******************************************************** */
	function fn_ins_view_check_pathChk(gbn, val) {
		if(gbn == 1){
			$("#ins_view_check_path1", "#bckScdInsViewForm").val(val);
						
			$("#ins_view_dataVolume", "#bckScdInsViewForm").empty();
			$("#ins_view_dataVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
			$("#ins_view_dataVolume_div", "#bckScdInsViewForm").show();
		}/* else if(keyType == 2) {
			$("#rlogVolume").empty();
			$( "#rlogVolume" ).append(volume);
		} */else if(gbn == 3) {
			$("#ins_view_check_path3", "#bckScdInsViewForm").val(val);
						
			$("#ins_view_backupVolume", "#bckScdInsViewForm").empty();
			$("#ins_view_backupVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
			$("#ins_view_backupVolume_div", "#bckScdInsViewForm").show();
		}/* else if(keyType == 4) {
			$("#dlogVolume").empty();
			$( "#dlogVolume" ).append(volume);
		} */else if(gbn == 5) {
			$("#ins_view_check_path5", "#bckScdInsViewForm").val(val);
			
			$("#ins_view_saveVolume", "#bckScdInsViewForm").empty();
			$("#ins_view_saveVolume", "#bckScdInsViewForm").html('<spring:message code="common.volume" /> : 0');
			$("#ins_view_saveVolume_div", "#bckScdInsViewForm").show();
		}
	}
	
	 /* ********************************************************
	  * Backup Insert
	  ******************************************************** */
	 function fn_ins_view_bckScheduler(){
		  $("#bckScdInsViewForm").submit();
	 }

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function ins_view_valCheck(){
		var iChkCnt = 0;

		if(nvlPrmSet($("#ins_view_scd_nmChk", "#bckScdInsViewForm").val(), "") == "" || nvlPrmSet($("#ins_view_scd_nmChk", "#bckScdInsViewForm").val(), "") == "fail") {
			$("#ins_view_scd_check_alert", "#bckScdInsViewForm").html('<spring:message code="message.msg69"/>');
			$("#ins_view_scd_check_alert", "#bckScdInsViewForm").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_view_bck", "#bckScdInsViewForm").val(),"") == "rman") {
			if($("#ins_view_check_path1","#bckScdInsViewForm").val() != "Y"){
				$("#ins_view_data_pth_check_alert", "#bckScdInsViewForm").html('<spring:message code="message.msg71" />');
				$("#ins_view_data_pth_check_div", "#bckScdInsViewForm").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if($("#ins_view_check_path3","#bckScdInsViewForm").val() != "Y"){
				$("#ins_view_backup_pth_check_alert", "#bckScdInsViewForm").html('<spring:message code="backup_management.bckPath_effective_check"/>');
				$("#ins_view_backup_pth_check_div", "#bckScdInsViewForm").show();
				
				iChkCnt = iChkCnt + 1;
			}
		}
		
		if(nvlPrmSet($("#ins_view_bck", "#bckScdInsViewForm").val(),"") == "dump") {

			if($("#ins_view_check_path5","#bckScdInsViewForm").val() != "Y"){
				$("#ins_view_save_pth_check_alert", "#bckScdInsViewForm").html('<spring:message code="backup_management.bckPath_effective_check"/>');
				$("#ins_view_save_pth_check_div", "#bckScdInsViewForm").show();
				
				iChkCnt = iChkCnt + 1;
			}
		}
		
		if($("input[name=ins_view_chk]:checkbox:checked").length == 0){
			showSwalIcon('<spring:message code="message.msg223"/>', '<spring:message code="common.close" />', '', 'warning');
			iChkCnt = iChkCnt + 1;
		}

		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}
	
	/* ********************************************************
	  * Insert check
	 ******************************************************** */
	function fn_insert_bckScdCheck() {
		if (!ins_view_valCheck()) return false;
		
		var ins_view_bck = $('#ins_view_bck', "#bckScdInsViewForm").val();
		
		if(ins_view_bck =="rman"){
	 		$.ajax({
	 			async : false,
	 			url : "/popup/workRmanWrite.do",
	 		  	data : {
					db_svr_id : $("#ins_view_db_svr_id", "#bckScdInsViewForm").val(),
	 		  		wrk_nm : $("#ins_view_scd_nm", "#bckScdInsViewForm").val()+"_"+getTimeStamp(),
	 		  		wrk_exp : $("#ins_view_scd_nm", "#bckScdInsViewForm").val(),
	 		  		bck_opt_cd : $("#ins_view_bck_opt_cd", "#bckScdInsViewForm").val(),
	 		  		bck_mtn_ecnt : "7",
	 		  		cps_yn : "N",
	 		  		log_file_bck_yn : "N",
	 		  		db_id : 0,
	 		  		bck_bsn_dscd : "TC000201",
	 		  		file_stg_dcnt : "7",
	 		  		log_file_stg_dcnt : "7",
	 		  		log_file_mtn_ecnt : "7",
	 		  		data_pth : $("#ins_view_data_pth", "#bckScdInsViewForm").val(),
	 		  		bck_pth : $("#ins_view_bck_pth", "#bckScdInsViewForm").val(),
	 		  		acv_file_stgdt : "7",
	 		  		acv_file_mtncnt : "7",
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
						$('#pop_layer_backup_week_scd_ins').modal('show');
						return;
					} else if(data == "S"){
						fn_insert_view_scheduler();
					}else{
						showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
						$('#pop_layer_backup_week_scd_ins').modal('show');
						return;
					}
				}
	 		});
		} else {
			$.ajax({
				async : false,
				url : "/popup/workDumpWrite.do",
				data : {
					db_svr_id : $("#ins_view_db_svr_id", "#bckScdInsViewForm").val(),
					wrk_nm : $("#ins_view_scd_nm", "#bckScdInsViewForm").val()+"_"+getTimeStamp(),				
	 		  		wrk_exp : $("#ins_view_scd_nm", "#bckScdInsViewForm").val(),
					db_id : $("#ins_view_db_id", '#bckScdInsViewForm').val(),
			  		bck_bsn_dscd : "TC000202",
			  		save_pth : $("#ins_view_save_pth", "#bckScdInsViewForm").val(),
			  		log_file_pth : "",
			  		file_fmt_cd : null,
			  		cprt : "0",
			  		encd_mth_nm : null,
			  		usr_role_nm : null,
			  		file_stg_dcnt : "0",
					bck_mtn_ecnt : "0",
			  		bck_filenm : ""
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
						$('#pop_layer_reg_dump').modal('show');
						return;
					} else if(data == "D"){
						showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
						$('#pop_layer_reg_dump').modal('show');
						return;
					}else{
						fn_insert_view_scheduler();
					}
				}
			});
		}
	}
		
	function getTimeStamp() {
		var d = new Date();
		var s =
			    leadingZeros(d.getFullYear(), 4) + 
			    leadingZeros(d.getMonth() + 1, 2) + 
			    leadingZeros(d.getDate(), 2) + 
			    leadingZeros(d.getHours(), 2) +
			    leadingZeros(d.getMinutes(), 2) +
			    leadingZeros(d.getSeconds(), 2);
		return s;
	}

	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		
		if (n.length < digits) {
			for (i = 0; i < digits - n.length; i++)
				zero += '0';
		}
		return zero + n;
	}
	
	/* ********************************************************
	  * 스케줄 등록
	 ******************************************************** */
	function fn_insert_view_scheduler() {
		var dayWeek = new Array();
	    var list = $("input[name='ins_view_chk']");
	    for(var i = 0; i < list.length; i++){
	        if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
	        	dayWeek.push(1);
	        }else{
	        	dayWeek.push(list[i].value);
	        }
	    }
	    
	    var exe_dt = dayWeek.toString().replace(/,/gi,'').trim();
	    
		$.ajax({
			url : "/insert_bckSchedule.do",
			data : {
				 scd_nm : $("#ins_view_scd_nm", "#bckScdInsViewForm").val().trim(),
				 scd_exp : $("#ins_view_scd_nm", "#bckScdInsViewForm").val(),
				 exe_perd_cd : "TC001602",
				 exe_dt : exe_dt,
				 exe_month : "01",
				 exe_day : "01",
				 exe_h : $("#ins_view_exe_h").val(),
				 exe_m : $("#ins_view_exe_m").val(),
				 exe_s	 : "00",			 
				 exe_hms : "00"+$("#ins_view_exe_m").val()+$("#ins_view_exe_h").val()
			},
		//	dataType : "json",
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
				showSwalIcon('<spring:message code="message.msg80" />', '<spring:message code="common.close" />', '', 'success');
				fn_selectBckSchedule();
				$('#pop_layer_backup_week_scd_ins').modal('hide');
			}
		});
	}
</script>
<div class="modal fade" id="pop_layer_backup_week_scd_ins" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 280px;">
		<div class="modal-content" style="width:1120px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="etc.etc12" />
				</h4>

				<div class="card" style="border:0px;">
					<form class="cmxform" id="bckScdInsViewForm">
						<input type="hidden" name="ins_view_db_svr_id" id="ins_view_db_svr_id" value="" />
						<input type="hidden" name="ins_view_check_path1" id="ins_view_check_path1" value="N" />
						<input type="hidden" name="ins_view_check_path3" id="ins_view_check_path3" value="N" />
						<input type="hidden" name="ins_view_check_path5" id="ins_view_check_path5" value="N" />
						<input type="hidden" name="ins_view_scd_nmChk" id="ins_view_scd_nmChk" value="fail" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z" style="margin-top:-5px;">
									<label for="ins_view_scd_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:10px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="schedule.schedule_name" />
									</label>
		
									<div class="col-sm-6">
										<input type="text" class="form-control" maxlength="50" id="ins_view_scd_nm" name="ins_view_scd_nm" onkeyup="fn_checkWord(this,50)" onchange="fn_ins_view_scd_nmChk();" placeholder='50<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()" tabindex=1 required />
									</div>
		
									<div class="col-sm-4">
										<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_ins_view_scdnm_check()"><spring:message code="common.overlap_check" /></button>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2">
									</div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none;" id="ins_view_scd_check_alert"></div>
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<label for="ins_view_bck" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="menu.backup_settings" />
									</label>

									<div class="col-sm-3">
										<select class="form-control" style="margin-right: 1rem;" name="ins_view_bck" id="ins_view_bck" tabindex=2 onChange="fn_ins_view_bck();">
											<option value=""><spring:message code="common.choice" /></option>
											<option value="rman">Online</option>
											<option value="dump">Dump</option>
										</select>
									</div>
									
									<div class="col-sm-3" id="ins_view_rman_bck_opt">
										<select class="form-control" name="ins_view_bck_opt_cd" id="ins_view_bck_opt_cd" tabindex=3 >
											<option value=""><spring:message code="common.choice" /></option>
											<option value="TC000301">FULL</option>
											<option value="TC000302">incremental</option>
											<option value="TC000303">archive</option>
										</select>
									</div>
									
									<div class="col-sm-3" id="ins_view_dump_bck_opt" style="display:none;">
										<select class="form-control" name="ins_view_db_id" id="ins_view_db_id" tabindex=3 >
										</select>
									</div>
									<div class="col-sm-4">
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z"  id="ins_view_r_data_pth" >
									<label for="ins_view_data_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.data_dir" />
									</label>

									<div class="col-sm-6">
										<input type="text" class="form-control" maxlength="200" id="ins_view_data_pth" name="ins_view_data_pth" onkeyup="fn_checkWord(this, 200)" onKeydown="fn_ins_view_check_pathChk('1', 'N');" onblur="this.value=this.value.trim()" tabindex=4 />
									</div>

									<div class="col-sm-4">
										<div class="input-group input-daterange d-flex align-items-center" >
											<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_ins_view_checkFolder(1)"><spring:message code="common.dir_check" /></button>
											<div class="input-group-addon mx-4">
												<div class="card card-inverse-primary" id="ins_view_dataVolume_div" style="display:none;border:none;">
													<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
														<p class="card-text" id="ins_view_dataVolume"></p>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								
								<div class="form-group row" style="display:none;" id="ins_view_data_pth_check_div">
									<div class="col-sm-2"></div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;" id="ins_view_data_pth_check_alert"></div>
									</div>
								</div>
								
								<%-- 
								RMAN 로그경로
								<tr id="r_log_pth">
									<th scope="row" class="t9 line"><spring:message code="backup_management.backup_log_dir" /></th>
									<td>
										<input type="text" class="txt" name="rlog_file_pth" id="rlog_file_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path2').val('N')" /> 
										<span class="btn btnF_04 btnC_01"><button type="button" class="btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>
										<span id="rlogVolume" style="margin: 70px;"></span>
									</td>
								</tr> --%>

								<div class="form-group row div-form-margin-z" id="ins_view_r_bck_pth">
									<label for="ins_view_bck_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_dir" />
									</label>

									<div class="col-sm-6">
										<input type="text" class="form-control" maxlength="200" id="ins_view_bck_pth" name="ins_view_bck_pth" onkeyup="fn_checkWord(this,200)" onKeydown="fn_ins_view_check_pathChk('3', 'N');" onblur="this.value=this.value.trim()" tabindex=5 />
									</div>

									<div class="col-sm-4">
										<div class="input-group input-daterange d-flex align-items-center" >
											<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_ins_view_checkFolder(3)"><spring:message code="common.dir_check" /></button>
											<div class="input-group-addon mx-4">
												<div class="card card-inverse-primary" id="ins_view_backupVolume_div" style="display:none;border:none;">
													<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
														<p class="card-text" id="ins_view_backupVolume"></p>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								
								<div class="form-group row" style="display:none;" id="ins_view_backup_pth_check_div">
									<div class="col-sm-2"></div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;" id="ins_view_backup_pth_check_alert"></div>
									</div>
								</div>
								
								<%-- 
								DUMP 로그경로
								<tr id="d_log_pth">
									<th scope="row" class="t9 line"><spring:message code="backup_management.backup_log_dir" /></th>
									<td>
										<input type="text" class="txt" name="dlog_file_pth" id="dlog_file_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path4').val('N')" /> 
										<span class="btn btnF_04 btnC_01">
										<button type="button" class="btn_type_02" onclick="checkFolder(4)" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>
										<span id="dlogVolume" style="margin: 70px;"></span>
									</td>
								</tr> --%>		

								<div class="form-group row div-form-margin-z" id="ins_view_d_bck_pth">
									<label for="ins_view_save_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="backup_management.backup_dir" />
									</label>

									<div class="col-sm-6">
										<input type="text" class="form-control" maxlength="200" id="ins_view_save_pth" name="ins_view_save_pth" onkeyup="fn_checkWord(this,200)" onKeydown="fn_ins_view_check_pathChk('5', 'N');" onblur="this.value=this.value.trim()" tabindex=5 />
									</div>

									<div class="col-sm-4">
										<div class="input-group input-daterange d-flex align-items-center" >
											<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_ins_view_checkFolder(5)"><spring:message code="common.dir_check" /></button>
											<div class="input-group-addon mx-4">
												<div class="card card-inverse-primary" id="ins_view_saveVolume_div" style="display:none;border:none;">
													<div class="card-body" style="padding-top:10px;padding-bottom:10px;">
														<p class="card-text" id="ins_view_saveVolume"></p>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="form-group row" style="display:none;" id="ins_view_save_pth_check_div">
									<div class="col-sm-2"></div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;" id="ins_view_save_pth_check_alert"></div>
									</div>
								</div>
								
								<div class="form-group row" style="margin-bottom:-20px;">
									<label for="ins_view_save_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="schedule.scheduleSetting"/>
									</label>
									<div class="col-sm-10 form-inline">
										<div id="ins_view_weekDay" class="form-inline" style="margin-right:15px;">
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label" for="sun" style="color: red;">
													<input type="checkbox" class="form-check-input" id="ins_view_chk1" name="ins_view_chk"  value="<spring:message code="common.sun" />"  />
													<spring:message code="common.sun" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label">
													<input type="checkbox" class="form-check-input" id="ins_view_chk2" name="ins_view_chk"  value="<spring:message code="common.mon" />"/>
													<spring:message code="common.mon" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label">
													<input type="checkbox" class="form-check-input" id="ins_view_chk3" name="ins_view_chk"  value="<spring:message code="common.tue" />"/>
													<spring:message code="common.tue" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label">
													<input type="checkbox" class="form-check-input" id="ins_view_chk4" name="ins_view_chk"  value="<spring:message code="common.wed" />"/>
													<spring:message code="common.wed" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label">
													<input type="checkbox" class="form-check-input" id="ins_view_chk5" name="ins_view_chk"  value="<spring:message code="common.thu" />"/>
													<spring:message code="common.thu" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label">
													<input type="checkbox" class="form-check-input" id="ins_view_chk6" name="ins_view_chk"  value="<spring:message code="common.fri" />"/>
													<spring:message code="common.fri" />
													<i class="input-helper"></i>
												</label>
											</div>
											<div class="form-check"  style="margin-left: 20px;">
												<label class="form-check-label" for="sat" style="color: blue;">
													<input type="checkbox" class="form-check-input" id="ins_view_chk7" name="ins_view_chk"  value="<spring:message code="common.sat" />"/>
													<spring:message code="common.sat" />
													<i class="input-helper"></i>
												</label>
											</div>
										</div>
										<div id="ins_view_hour" style="margin-top:-15px;"></div>
										<div id="ins_view_min" style="margin-top:-15px;"></div>
									</div>
								</div>
							</div>
 
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
									<button type="button" class="btn btn-primary" onclick="fn_ins_view_bckScheduler();"><spring:message code="common.registory"/></button>
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