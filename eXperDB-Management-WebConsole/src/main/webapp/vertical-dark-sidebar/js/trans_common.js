$(window).ready(function(){
});

/* ********************************************************
 * 전체조회
 ******************************************************** */
function fn_tot_select() {
	//source 시스템
	fn_source_select();
	
	//target 조회 추가
	fn_target_select();
}

/* ********************************************************
 * 소스시스템 transfer Data Fetch List
 ******************************************************** */
function fn_source_select(){
	$.ajax({
		url : "/selectSourceTransSetting.do", 
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			connect_nm : $("#connect_nm").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			source_table.rows({selected: true}).deselect();
			source_table.clear().draw();

			if (nvlPrmSet(result, '') != '') {
				source_table.rows.add(result).draw();
			}
		}
	});
}

/* ********************************************************
 * 타겟시스템 transfer Data Fetch List
 ******************************************************** */
function fn_target_select(){
	$.ajax({
		url : "/selectTargetTransSetting.do", 
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			connect_nm : $("#connect_nm").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			target_table.rows({selected: true}).deselect();
			target_table.clear().draw();

			if (nvlPrmSet(result, '') != '') {
				target_table.rows.add(result).draw();
			}
		}
	});
}

/* ********************************************************
 * table 별 체크 해제
 ******************************************************** */
function fn_another_checkAll(tableNm) {
	if(tableNm == "transTargetSettingTable") { 
		source_table.rows({selected: true}).deselect();
	} else { 
		target_table.rows({selected: true}).deselect();
	}
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmCancelRst(gbn){
	if ($('#chk_act_row', '#findList') != null) {
		var canCheckId = "";
			
		if (gbn == "con_start" || gbn == "con_end") {
			canCheckId = 'source_transActivation' + $('#chk_act_row', '#findList').val();
		} else {
			canCheckId = 'target_transActivation' + $('#chk_act_row', '#findList').val();
		}

		if (gbn == "con_start") {
			$("input:checkbox[id='" + canCheckId + "']").prop("checked", false); 
		} else if (gbn == "con_end") {
			$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
		} else if (gbn == "target_con_end") {
			$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
		} else if (gbn == "target_con_start") {
			$("input:checkbox[id='" + canCheckId + "']").prop("checked", false); 
		}
	}
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "del" || gbn == "target_del") {
		fn_delete(gbn);
	} else if (gbn == "con_start" || gbn == "con_end" || gbn == "target_con_start" || gbn == "target_con_end") {
		fn_act_execute(gbn);
	} else if (gbn == "active" || gbn == "disabled" || gbn == "target_active" || gbn == "target_disabled") {
		fn_tot_act_execute(gbn);
	} else if (gbn == "trans_dbms_del") {
		fn_trans_dbms_delete_logic();
	}
}

/* ********************************************************
 * 활성화 단건실행
 ******************************************************** */
function fn_act_execute(act_gbn) {
	var ascRow =  $('#chk_act_row', '#findList').val();
	var validateMsg ="";
	var checkId = "";

	if (act_gbn == "con_start") {
		$.ajax({
			url : "/transStart.do",
			data : {
				db_svr_id : $('#source_db_svr_id' + ascRow).val(),
				trans_exrt_trg_tb_id : $('#source_trans_exrt_trg_tb_id' + ascRow).val(),
				trans_id : $('#source_trans_id' + ascRow).val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				checkId = 'source_transActivation' + ascRow;
				
				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
					$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
					return;
				} else {
					if (result == "success") {
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						
						$("input:checkbox[id='" + checkId + "']").prop("checked", false);
						return;
					}
				}
			}
		});
	} else 	if (act_gbn == "target_con_start") {
		$.ajax({
			url : "transTargetStart.do",
			data : {
				db_svr_id : $('#target_db_svr_id' + ascRow).val(),
				trans_exrt_trg_tb_id : $('#target_trans_exrt_trg_tb_id' + ascRow).val(),
				trans_id : $('#target_trans_id' + ascRow).val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				checkId = 'target_transActivation' + ascRow;
				
				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
					$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
					return;
				} else {
					if (result == "success") {
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						
						$("input:checkbox[id='" + checkId + "']").prop("checked", false);
						return;
					}
				}
			}
		});
	} else 	if (act_gbn == "con_end") {
		$.ajax({
			url : "/transStop.do",
			data : {
				db_svr_id : $('#source_db_svr_id' + ascRow).val(),
				trans_id : $('#source_trans_id' + ascRow).val(),
				kc_ip : $('#source_kc_ip' + ascRow).val(),
				kc_port : $('#source_kc_port' + ascRow).val(),
				connect_nm : $('#source_connect_nm' + ascRow).val(),
				trans_active_gbn:"source"
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				checkId = 'source_transActivation' + ascRow;
				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');

					$("input:checkbox[id='" + checkId + "']").prop("checked", true); 
					return;
				} else {
					if (result == "success") {
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						$("input:checkbox[id='" + checkId + "']").prop("checked", true);
						return;
					}
				}
			}
		});
	} else 	if (act_gbn == "target_con_end") {
		$.ajax({
			url : "/transStop.do",
			data : {
				db_svr_id : $('#target_db_svr_id' + ascRow).val(),
				trans_id : $('#target_trans_id' + ascRow).val(),
				kc_ip : $('#target_kc_ip' + ascRow).val(),
				kc_port : $('#target_kc_port' + ascRow).val(),
				connect_nm : $('#target_connect_nm' + ascRow).val(),
				trans_active_gbn:"target"
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				checkId = 'target_transActivation' + ascRow;
				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');

					$("input:checkbox[id='" + checkId + "']").prop("checked", true); 
					return;
				} else {
					if (result == "success") {
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						$("input:checkbox[id='" + checkId + "']").prop("checked", true);
						return;
					}
				}
			}
		});
	}
}

/* ********************************************************
 * 삭제버튼 클릭시
 ******************************************************** */
function fn_del_confirm(active_gbn){
	var validateMsg = "";
	var sebuTitle = "";
	var multi_gbn = "";
	var datas = null;
	
	if (active_gbn == "source") {
		datas = source_table.rows('.selected').data();
		sebuTitle = migration_source_system;
		multi_gbn = "del";
	} else {
		datas = target_table.rows('.selected').data();
		sebuTitle = migration_target_system;
		multi_gbn = "target_del";
	}

	var i_exe_status = 0;

	trans_id_List = [];
	trans_exrt_trg_tb_id_List = [];

	if (datas.length <= 0) {
		showSwalIcon(message_msg35, closeBtn, '', 'error');
		return;
	}

	//활성화 체크
	for (var i = 0; i < datas.length; i++) {
		if(datas[i].exe_status == "TC001501"){
			i_exe_status = i_exe_status + 1;
		}

		trans_id_List.push(datas[i].trans_id);   
		trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
	}

	if (i_exe_status > 0) {
		validateMsg = data_transfer_msg7;
		showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
		return;
	}
	
	confile_title = menu_trans_management + " " + sebuTitle + "" + button_delete + " " + common_request;

	$('#con_multi_gbn', '#findConfirmMulti').val(multi_gbn);
	
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html(message_msg162);
	$('#pop_confirm_multi_md').modal("show");
}

/* ********************************************************
 * 선택 활성화 클릭
 ******************************************************** */
function fn_activaExecute_click(tot_con_gbn){
	var validateMsg = "";
	var datas = null;
	var sourceDatas = null;
	var targetDatas = null;
	var active_gbn = "";

	sourceDatas = source_table.rows('.selected').data();
	targetDatas = target_table.rows('.selected').data();

	var i_exe_status = 0;
	var i_un_exe_status = 0;
	
	trans_id_List = [];
	trans_exrt_trg_tb_id_List = [];

	kc_ip_List = [];
	kc_port_List = [];
	connect_nm_List = [];

	if (sourceDatas.length <= 0 && targetDatas.length <= 0) {
		showSwalIcon(message_msg35, closeBtn, '', 'error');
		return;
	}

	if (sourceDatas.length > 0 && targetDatas.length > 0) {
		showSwalIcon(fn_strBrReplcae(data_transfer_msg23), closeBtn, '', 'error');
		return;
	}

	if (sourceDatas.length > 0) {
		datas = sourceDatas;
		active_gbn = "source";
	} else {
		datas = targetDatas;
		active_gbn = "target";
	}

	if (tot_con_gbn == "active") {
		for (var i = 0; i < datas.length; i++) {
	 		if(datas[i].exe_status == "TC001501"){
				i_exe_status = i_exe_status + 1;
			} else {
				i_un_exe_status = i_un_exe_status + 1;

				trans_id_List.push(datas[i].trans_id);
				trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
			}
		}

		//실행 내역이 없는 경우
		if (i_un_exe_status <= 0) {
			showSwalIcon(data_transfer_msg17, closeBtn, '', 'error');
			return;
		}

		if (i_exe_status > 0) {
			validateMsg = data_transfer_msg13;
		} else {
			validateMsg = data_transfer_msg12;
		}
	} else {
		for (var i = 0; i < datas.length; i++) {
 			if(datas[i].exe_status == "TC001501"){
				i_exe_status = i_exe_status + 1;

				trans_id_List.push(datas[i].trans_id);
				trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
				kc_ip_List.push(datas[i].kc_ip);
				kc_port_List.push(datas[i].kc_port);
				connect_nm_List.push(datas[i].connect_nm);

			} else {
				i_un_exe_status = i_un_exe_status + 1;
			}
		}

		//실행 내역이 없는 경우
		if (i_exe_status <= 0) {
			showSwalIcon(data_transfer_msg17, closeBtn, '', 'error');
			return;
		}

		if (i_un_exe_status > 0) {
			validateMsg = data_transfer_msg15;
		} else {
			validateMsg = data_transfer_msg14;
		}
	}

	if (active_gbn == "source") {
		confile_title = menu_trans_management + " " + migration_source_system + " " + data_transfer_transfer_activity;

		tot_con_gbn = tot_con_gbn;
	} else {
		confile_title = menu_trans_management + " " + migration_target_system + " " + data_transfer_transfer_activity;

		tot_con_gbn = "target_" + tot_con_gbn;
	}

	$('#con_multi_gbn', '#findConfirmMulti').val(tot_con_gbn);
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html(validateMsg);
	$('#pop_confirm_multi_md').modal("show");
}

/* ********************************************************
 * 선택 활성화 실행
 ******************************************************** */
function fn_tot_act_execute(exeGbn){
	var trans_active_gbn = "";

	//버튼 제어
	fn_buttonExecuteAut("start", exeGbn);
	
	if (exeGbn == "target_active" || exeGbn == "target_disabled") {
		trans_active_gbn = "target";
	} else {
		trans_active_gbn = "source";
	}

	if (exeGbn == "active" || exeGbn == "target_active") {
		$.ajax({
			url : "/transTotExecute.do",
			data : {
				execute_gbn : exeGbn,
				db_svr_id : $("#db_svr_id", "#findList").val(),
				trans_id_List : JSON.stringify(trans_id_List),
				trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List),
				trans_active_gbn : trans_active_gbn
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				//버튼제어
				fn_buttonExecuteAut("end", "");

				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
					return;
				} else {
					if (result == "success") {
						showSwalIcon(data_transfer_msg16, closeBtn, '', 'success');
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						return;
					}
				}
			}
		});
	} else {
		$.ajax({
			url : "/transTotExecute.do",
			data : {
				execute_gbn : exeGbn,
				db_svr_id : $("#db_svr_id", "#findList").val(),
				trans_id_List : JSON.stringify(trans_id_List),
				trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List),
				kc_ip_List : JSON.stringify(kc_ip_List),
				kc_port_List : JSON.stringify(kc_port_List),
				connect_nm_List : JSON.stringify(connect_nm_List),
				trans_active_gbn : trans_active_gbn
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				//버튼제어
				fn_buttonExecuteAut("end", "");

				if (result == null) {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
					return;
				} else {
					if (result == "success") {
						showSwalIcon(data_transfer_msg16, closeBtn, '', 'success');
						fn_tot_select();
					} else {
						validateMsg = data_transfer_msg10;
						showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
						return;
					}
				}
			}
		});
	}
}

/* ********************************************************
 * button 제어
 ******************************************************** */
function fn_buttonExecuteAut(autIngGbn, exeIngGbn){
	var strMsg = "";
	if(autIngGbn == "start"){
		if (exeIngGbn == "active" || exeIngGbn == "target_active") {
			strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
			strMsg += data_transfer_save_select_active + ' ' + restore_progress;

			$("#btnChoActive").html(strMsg);
		} else {
			strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
			strMsg += data_transfer_save_select_disabled + ' ' + restore_progress;

			$("#btnChoDisabled").html(strMsg);
		}

		$("#btnChoActive").prop("disabled", "disabled");
		$("#btnChoDisabled").prop("disabled", "disabled");

		$("#btnScDelete").prop("disabled", "disabled");
		$("#btnTgDelete").prop("disabled", "disabled");
		$("#btnScModify").prop("disabled", "disabled");
		$("#btnTgModify").prop("disabled", "disabled");
		$("#btnScInsert").prop("disabled", "disabled");
		$("#btnTgInsert").prop("disabled", "disabled");
		$("#btnSearch").prop("disabled", "disabled");
		$("#btnCommonInsert").prop("disabled", "disabled");
		$("#btnKafkaInsert").prop("disabled", "disabled");
	}else{
		strMsg = '<i class="fa fa-spin fa-cog btn-icon-prepend"></i>';
		$("#btnChoActive").html(strMsg + data_transfer_save_select_active);
		$("#btnChoDisabled").html(strMsg + data_transfer_save_select_disabled);
		
		$("#btnChoActive").prop("disabled", "");
		$("#btnChoDisabled").prop("disabled", "");

		$("#btnScDelete").prop("disabled", "");
		$("#btnTgDelete").prop("disabled", "");
		$("#btnScModify").prop("disabled", "");
		$("#btnTgModify").prop("disabled", "");
		$("#btnScInsert").prop("disabled", "");
		$("#btnTgInsert").prop("disabled", "");
		$("#btnSearch").prop("disabled", "");
		$("#btnCommonInsert").prop("disabled", "");
		$("#btnKafkaInsert").prop("disabled", "");
	} 
}

/* ********************************************************
 * 상세 팝업셋팅
 ******************************************************** */
function fn_info_setting(result, active_gbn) {
	if (active_gbn == "source") {
		//스냅샷 모드 추가
		var snapshot_mode_re = nvlPrmSet(result.snapshot_mode, "");
		var snapshot_mode_nm = nvlPrmSet(result.snapshot_nm, "");
		var info_meta_data_chk = "";

		//압축형태
		var compression_type_info_val = "";
		var compression_type_info = nvlPrmSet(result.compression_type, "");

		$("#d_kc_ip", "#searchInfoForm").html(nvlPrmSet(result.kc_ip, ""));
		$("#d_kc_port", "#searchInfoForm").html(nvlPrmSet(result.kc_port, ""));

		$("#d_connect_nm", "#infoRegForm").html(nvlPrmSet(result.connect_nm, ""));
		$("#d_db_id", "#infoRegForm").html(nvlPrmSet(result.db_nm, ""));

		//스냅샷 모드 change
		if(snapshot_mode_re == "TC003601"){
			snapshot_mode_nm += ' ' + data_transfer_msg2;
		}else if(snapshot_mode_re == "TC003602"){
			snapshot_mode_nm += ' ' + data_transfer_msg3;
		}else if (snapshot_mode_re == "TC003603"){
			snapshot_mode_nm += ' ' + data_transfer_msg1;
		}else if (snapshot_mode_re == "TC003604"){
			snapshot_mode_nm += ' ' + data_transfer_msg4;
		}else if (snapshot_mode_re == "TC003605"){
			snapshot_mode_nm += ' ' + data_transfer_msg5;
		}
		$("#d_snapshot_mode_nm", "#infoRegForm").html(snapshot_mode_nm);

		//압축모드
		if (compression_type_info != "") {
			if (compression_type_info == 'TC003701') {
				compression_type_info_val += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				compression_type_info_val += "	<i class='ti-close text-danger mr-2'></i>";
				compression_type_info_val += nvlPrmSet(result.compression_nm, "");
				compression_type_info_val += "</div>";
			} else {
				compression_type_info_val += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				compression_type_info_val += "	<i class='fa fa-file-zip-o text-success mr-2'></i>";
				compression_type_info_val += nvlPrmSet(result.compression_nm, "");
				compression_type_info_val += "</div>";
			}
		}

		$("#d_compression_type_nm", "#infoRegForm").html(compression_type_info_val);
		
		//메타데이타 설정
		if (nvlPrmSet(result.meta_data, "") == "OFF" || nvlPrmSet(result.meta_data, "") == "") {
			info_meta_data_chk += "<div class='badge badge-pill badge-light' style='background-color: #EEEEEE;'>";
			info_meta_data_chk += "	<i class='fa fa-power-off mr-2'></i>";
			info_meta_data_chk += "OFF";
			info_meta_data_chk += "</div>";
		} else {
			info_meta_data_chk += "<div class='badge badge-pill badge-info text-white'>";
			info_meta_data_chk += "	<i class='fa fa-power-off mr-2'></i>";
			info_meta_data_chk += "ON";
			info_meta_data_chk += "</div>";
		}
		$("#d_meta_data_chk", "#infoRegForm").html(info_meta_data_chk);

		info_connector_tableList.rows({selected: true}).deselect();
		info_connector_tableList.clear().draw();
		
		if (result.tables.data != null) {
			info_connector_tableList.rows.add(result.tables.data).draw();
		}

		$('a[href="#infoSettingTab"]').tab('show');
	} else {
		$("#d_tg_kc_ip", "#searchTargetInfoForm").html(nvlPrmSet(result.kc_ip, ""));
		$("#d_tg_kc_port", "#searchTargetInfoForm").html(nvlPrmSet(result.kc_port, ""));

		$("#d_tg_connect_nm", "#infoTargetForm").html(nvlPrmSet(result.connect_nm, ""));

		$("#d_tg_system_name", "#infoTargetForm").html(nvlPrmSet(result.trans_sys_nm, ""));
		$("#d_tg_system_ip", "#infoTargetForm").html(nvlPrmSet(result.ipadr, ""));
		$("#d_tg_system_port", "#infoTargetForm").html(nvlPrmSet(result.portno, ""));
		$("#d_tg_system_database", "#infoTargetForm").html(nvlPrmSet(result.dtb_nm, ""));
		$("#d_tg_system_account", "#infoTargetForm").html(nvlPrmSet(result.spr_usr_id, ""));

		info_target_connector_tableList.rows({selected: true}).deselect();
		info_target_connector_tableList.clear().draw();

		if (result.tables.data != null) {
			info_target_connector_tableList.rows.add(result.tables.data).draw();
		}
	}
}

/* ********************************************************
 * target DBMS 설정 버튼 클릭
 ******************************************************** */
function fn_common_dmbs_ins(){
	var selectDbList = "";

	$.ajax({
		url : "/popup/transTargetDbmsSetting.do",
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_tansDbmsPopStart();

			$('#pop_layer_trans_target_dbms').modal("show");
		}
	});
}

/* ********************************************************
 * 등록 팝업 초기화
 ******************************************************** */
function fn_insert_chogihwa(gbn, active_gbn) {
	if (gbn == "reg") {
		if (active_gbn == "source") {
			//스냅샷 모드 추가
			$("#ins_snapshot_mode", "#insRegForm").val('TC003603').prop("selected", true); //값이 1인 option 선택

			//압축형태 추가
			$("#ins_compression_type", "#insRegForm").val('TC003701').prop("selected", true); //값이 1인 option 선택

			$("#ins_snapshotModeDetail", "#insRegForm").html(data_transfer_msg1);

			//메타데이타 설정
			$("#ins_meta_data", "#insRegForm").val("OFF");
			$("input:checkbox[id='ins_meta_data_chk']").prop("checked", false); 
			
			$("#ins_source_trans_active_div").hide();
			
			ins_tableList.clear().draw();
			ins_connector_tableList.clear().draw();
			
			ins_connect_status_Chk = "fail";
			ins_connect_nm_Chk = "fail";
			
			$('a[href="#insSettingTab"]').tab('show');
		} else {
			
			ins_tg_topicList.clear().draw();
			ins_connector_tg_tableList.clear().draw();
			
			$("#ins_target_trans_active_div").hide();
			
			ins_tg_connect_status_Chk = "fail";
			ins_tg_connect_nm_Chk = "fail";
			
		}

	} else {
		if (active_gbn == "source") {
			//스냅샷 모드 추가
			$("#mod_snapshot_mode", "#modRegForm").val('TC003603').prop("selected", true); //값이 1인 option 선택

			//압축형태 추가
			$("#mod_compression_type", "#modRegForm").val('TC003701').prop("selected", true); //값이 1인 option 선택
			
			//입력관련 초기화
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg1);

			//메타데이타 설정
			$("#mod_meta_data", "#modRegForm").val("OFF");
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", false); 
			
			$("#mod_source_trans_active_div").hide();
			
			mod_tableList.clear().draw();
			mod_connector_tableList.clear().draw();

			$('a[href="#modSettingTab"]').tab('show');
		} else {
			
			$("#mod_targer_trans_active_div").hide();
			
			mod_connector_tg_tableList.clear().draw();
			mod_tg_topicList.clear().draw();

		}
	}
}

/* ********************************************************
 * 수정 팝업셋팅
 ******************************************************** */
function fn_update_setting(result, active_gbn) {
	if (active_gbn == "source") {
		$("#mod_kc_ip", "#searchModForm").val(nvlPrmSet(result.kc_ip, ""));
		$("#mod_kc_port", "#searchModForm").val(nvlPrmSet(result.kc_port, ""));
		
		$("#mod_connect_nm", "#modRegForm").val(nvlPrmSet(result.connect_nm, ""));
		$("#mod_db_id", "#modRegForm").val(nvlPrmSet(result.db_nm, ""));
		$("#mod_db_id_set", "#modRegForm").val(nvlPrmSet(result.db_id, ""));
		$("#mod_trans_id", "#modRegForm").val(nvlPrmSet(result.trans_id, ""));
		$("#mod_trans_exrt_trg_tb_id","#modRegForm").val(nvlPrmSet(result.trans_exrt_trg_tb_id, ""));

		//스냅샷 모드 추가
		var snapshot_mode_re = nvlPrmSet(result.snapshot_mode, "");
		$("#mod_snapshot_mode", "#modRegForm").val(snapshot_mode_re).prop("selected", true);

		//압축형태 추가
		$("#mod_compression_type", "#modRegForm").val(nvlPrmSet(result.compression_type, "TC003701")).prop("selected", true);
		
		//메타데이타 설정
		$("#mod_meta_data", "#modRegForm").val(nvlPrmSet(result.meta_data, ""));

		if (nvlPrmSet(result.meta_data, "") == "ON") {
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", false); 
		}
	
		//스냅샷 모드 change
		if(snapshot_mode_re == "TC003601"){
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg2); //(초기스냅샷 1회만 수행)
		}else if(snapshot_mode_re == "TC003602"){
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg3); //(스냅샷 항상 수행)
		}else if (snapshot_mode_re == "TC003603"){
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg1); //(스냅샷 수행하지 않음)
		}else if (snapshot_mode_re == "TC003604"){
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg4); //(스냅샷만 수행하고 종료)
		}else if (snapshot_mode_re == "TC003605"){
			$("#mod_snapshotModeDetail", "#modRegForm").html(data_transfer_msg5); //(복제슬롯이 생성된 시접부터의 스냅샷 lock 없는 효율적방법)
		}
		
		mod_connector_tableList.rows({selected: true}).deselect();
		mod_connector_tableList.clear().draw();
		
		if (result.tables.data != null) {
			mod_connector_tableList.rows.add(result.tables.data).draw();	
		}
	} else {
		$("#mod_tg_kc_ip", "#searchTargetModForm").val(nvlPrmSet(result.kc_ip, ""));
		$("#mod_tg_kc_port", "#searchTargetModForm").val(nvlPrmSet(result.kc_port, ""));
		
		$("#mod_tg_connect_nm", "#modTargetRegForm").val(nvlPrmSet(result.connect_nm, ""));
		$("#mod_tg_trans_id", "#modTargetRegForm").val(nvlPrmSet(result.trans_id, ""));
		$("#mod_tg_trans_exrt_trg_tb_id","#modTargetRegForm").val(nvlPrmSet(result.trans_exrt_trg_tb_id, ""));
		$("#mod_tg_trans_trg_sys_id","#modTargetRegForm").val(nvlPrmSet(result.trans_trg_sys_id, ""));
		$("#mod_tg_trans_trg_sys_nm","#modTargetRegForm").val(nvlPrmSet(result.trans_sys_nm, ""));
		
		mod_connector_tg_tableList.rows({selected: true}).deselect();
		mod_connector_tg_tableList.clear().draw();
		
		if (result.tables.data != null) {
			mod_connector_tg_tableList.rows.add(result.tables.data).draw();	
		}
		
		fn_topic_search_tg_mod();
	}
}

/* ********************************************************
 * 등록버튼 클릭시
 ******************************************************** */
function fn_newInsert(active_gbn){
	var selectDbList = "";
	$.ajax({
		url : "/popup/connectRegForm2.do",
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			act : "i"
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_insert_chogihwa("reg", active_gbn);

			if (active_gbn == "source") {
				$('#pop_layer_con_reg_two').modal("show");
			} else {
				$('#pop_layer_con_reg_two_target').modal("show");
			}

		}
	});
}

/* ********************************************************
 * modal popup 활성화 클릭
 ******************************************************** */
function fn_transActivation_msg_set(pop_gbn) {
	if (pop_gbn == "ins_source") {
		if($("#ins_source_transActive_act", "#insRegForm").is(":checked") == true){
			$("#ins_source_trans_active_div").show();
		} else {
			$("#ins_source_trans_active_div").hide();
		}
	} else if (pop_gbn == "mod_source") {
		if($("#mod_source_transActive_act", "#modRegForm").is(":checked") == true){
			$("#mod_source_trans_active_div").show();
		} else {
			$("#mod_source_trans_active_div").hide();
		}
	} else if (pop_gbn == "ins_target") {
		if($("#ins_target_transActive_act", "#insTargetRegForm").is(":checked") == true){
			$("#ins_target_trans_active_div").show();
		} else {
			$("#ins_target_trans_active_div").hide();
		}
	} else if (pop_gbn == "mod_target") {
		if($("#mod_target_transActive_act", "#modTargetRegForm").is(":checked") == true){
			$("#mod_target_trans_active_div").show();
		} else {
			$("#mod_target_trans_active_div").hide();
		}
	}
}

/* ********************************************************
 * modal popup 활성화 클릭
 ******************************************************** */
function fn_auto_trans_active_start(pop_gbn, trans_exrt_trg_tb_id_val, trans_id_val) {
	$.ajax({
		url : "/transAutoStart.do",
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			trans_active_gbn : pop_gbn,
			trans_exrt_trg_tb_id : trans_exrt_trg_tb_id_val,
			trans_id : trans_id_val
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if (result == null) {
				validateMsg = data_transfer_msg10;
				showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
				return;
			} else {
				if (result == "success") {
				} else {
					validateMsg = data_transfer_msg10;
					showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
					return;
				}
			}
			
			fn_tot_select();
		}
	});
}

/* ********************************************************
 * 수정버튼 클릭시
 ******************************************************** */
function fn_newUpdate(active_gbn){
	var datas = null;
	var updUrl = "";

	if (active_gbn == "source") {
		datas = source_table.rows('.selected').data();
		updUrl = "/popup/connectRegReForm.do";
	} else {
		datas = target_table.rows('.selected').data();
		updUrl = "/popup/connectTargetRegReForm.do";
	}

	var validateMsg = "";

	if (datas.length <= 0) {
		showSwalIcon(message_msg35, closeBtn, '', 'error');
		return;
	}else if(datas.length > 1){
		showSwalIcon(message_msg04, closeBtn, '', 'error');
		return;
	}

	if(datas[0].exe_status == "TC001501"){
		validateMsg = data_transfer_msg11;
		showSwalIcon(fn_strBrReplcae(validateMsg), closeBtn, '', 'error');
		return;
	}

	var trans_id_chk = datas[0].trans_id;
	var trans_exrt_trg_tb_id_chk = datas[0].trans_exrt_trg_tb_id;

	$('#mod_prm_trans_id', '#findList').val(trans_id_chk);
	$('#mod_prm_trans_exrt_trg_tb_id', '#findList').val(trans_exrt_trg_tb_id_chk);

		$.ajax({
		url : updUrl,
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			act : "u",
			trans_exrt_trg_tb_id : trans_exrt_trg_tb_id_chk,
			trans_id : trans_id_chk
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_insert_chogihwa("mod", active_gbn);

			//update setting
			fn_update_setting(result, active_gbn);

			if (active_gbn == "source") {
				$('#pop_layer_con_re_reg_two').modal("show");
			} else {
				$('#pop_layer_con_re_reg_two_target').modal("show");
			}
		}
	});
}



/**********************타겟시스템 등록***********************************/
/* ********************************************************
 * 테이블 설정
 ******************************************************** */
function fn_tg_ins_init(){
	ins_tg_topicList = $('#ins_tg_topicList').DataTable({
		scrollY : "200px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : false,
		bSort: false,
		columns : [
			{
				data : "topic_name", className : "dt-center", defaultContent : ""
			},
		],'select': {'style': 'multi'}
	});

	ins_tg_topicList.tables().header().to$().find('th:eq(0)').css('min-width', '350px');
		
		ins_connector_tg_tableList = $('#ins_connector_tg_topicList').DataTable({
		scrollY : "200px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : false,	
		bSort: false,
		columns : [
			{data : "topic_name", className : "dt-center", defaultContent : ""},			
		 ],'select': {'style': 'multi'}
	});
	
		ins_connector_tg_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '350px');

	$(window).trigger('resize'); 
}

/* ********************************************************
 * 커넥터 연결테스트 
 ******************************************************** */
function fn_ins_target_kcConnectTest() {
	var kafkaIp = $("#ins_tg_kc_ip", "#searchTargetRegForm").val();
	var kafkaPort=	$("#ins_tg_kc_port", "#searchTargetRegForm").val();

	$.ajax({
		url : '/kafkaConnectionTest.do',
		type : 'post',
		data : {
			db_svr_id : $("#db_svr_id","#findList").val(),
			kafkaIp : kafkaIp,
			kafkaPort : kafkaPort
		},
		success : function(result) {
			if(result.RESULT_DATA =="success"){
				ins_tg_connect_status_Chk ="success";
				showSwalIcon('kafka-Connection ' + message_msg93, closeBtn, '', 'success');
				
				fn_topic_search_tg_ins();
			}else{
				ins_tg_connect_status_Chk ="fail";
				showSwalIcon('kafka-Connection ' + message_msg92, closeBtn, '', 'error');
			}
		},
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		}
	});
	$('#loading').hide();
}

/* ********************************************************
 * 커넥터명 중복체크
 ******************************************************** */
function fn_ins_target_ConNmCheck() {
	var connect_nm_val = nvlPrmSet($("#ins_tg_connect_nm", "#insTargetRegForm").val(), '');

	if (connect_nm_val == "") {
		showSwalIcon(data_transfer_msg18, closeBtn, '', 'warning');
		return;
	}
	
	$.ajax({
		url : '/connect_target_nm_Check.do',
		type : 'post',
		data : {
			connect_nm : connect_nm_val
		},
		success : function(result) {
			if (result == "true") {
				ins_tg_connect_nm_Chk = "success";
				showSwalIcon(data_transfer_msg19, closeBtn, '', 'success');
			} else {
				ins_tg_connect_nm_Chk = "fail";
				showSwalIcon(data_transfer_msg20, closeBtn, '', 'error');
			}
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		}
	});
}

/* ********************************************************
 * DBMS 시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_ins_tg_dbmsInfo(){
	$('#info_trans_targetSystem_mod').hide();
	$('#info_trans_targetSystem_add').show();
	
	$('#info_tg_tans_sys_nm').val("");
	$('#info_tg_dbms_work').val("%");
	
	fn_info_trans_search_dbmsInfo();

	$('#pop_layer_trans_dbmsInfo_reg').modal("show");
}


/* ********************************************************
 * DBMS 서버 호출하여 입력
 ******************************************************** */
function fn_trans_dbmsAddCallback(trans_sys_id, trans_sys_nm){
	 $("#ins_tg_trans_trg_sys_id", "#insTargetRegForm").val(nvlPrmSet(trans_sys_id, ''));
	 $("#ins_tg_trans_trg_sys_nm", "#insTargetRegForm").val(nvlPrmSet(trans_sys_nm, ''));
}


/* ********************************************************
 * 커넥터 설정 등록
 ******************************************************** */
function fn_target_ins_insert() {
	var table_mapp = [];

	if(!trans_target_ins_valCheck()) {
		return;
	}
	
	var tableDatas = ins_connector_tg_tableList.rows().data();

	if(tableDatas.length > 0){
		var tableRowList = [];
		
		for (var i = 0; i < tableDatas.length; i++) {
			tableRowList.push( ins_connector_tg_tableList.rows().data()[i]);    
			table_mapp.push(ins_connector_tg_tableList.rows().data()[i].topic_name);
		}
		
		$("#ins_tg_topic_mapp_nm", "#insTargetRegForm").val(table_mapp);
		
		var schema_total_cnt= 0;
		var table_total_cnt = 0;

		$.ajax({
			async : false,
			url : "/insertTargetConnectInfo.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				kc_ip : nvlPrmSet($("#ins_tg_kc_ip", "#searchTargetRegForm").val(), ''),
				kc_port : nvlPrmSet($("#ins_tg_kc_port", "#searchTargetRegForm").val(), ''),
				connect_nm : nvlPrmSet($("#ins_tg_connect_nm", "#insTargetRegForm").val(), ''),
				exrt_trg_tb_nm : nvlPrmSet($("#ins_tg_topic_mapp_nm", "#insTargetRegForm").val(), ''),
				trans_trg_sys_id : nvlPrmSet($("#ins_tg_trans_trg_sys_id", "#insTargetRegForm").val(), ''),
				schema_total_cnt : schema_total_cnt,
				table_total_cnt : table_total_cnt
			},
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if(result == "success"){
					showSwalIcon(message_msg144, closeBtn, '', 'success');
					$('#pop_layer_con_reg_two_target').modal('hide');
					
					//자동활성화 등록
					if($("#ins_target_transActive_act", "#insTargetRegForm").is(":checked") == true){
						fn_auto_trans_active_start("ins_target", "", "");
					} else {
						fn_tot_select();
					}
				}else{
					showSwalIcon(migration_msg06, closeBtn, '', 'error');
					$('#pop_layer_con_reg_two_target').modal('show');
					return false;
				}
			}
		});	
	}
}


/* ********************************************************
 * 테이블 리스트 조회
 ******************************************************** */
function fn_topic_search_tg_ins(){
	
	var db_svr_id = $("#db_svr_id","#findList").val();
	var kc_ip = $("#ins_tg_kc_ip", "#searchTargetRegForm").val();

	$.ajax({
		url : "/selectTargetTopicMappList.do",
		data : {
			db_svr_id : db_svr_id,
			kc_ip : kc_ip
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {	
			ins_tg_topicList.rows({selected: true}).deselect();
			ins_tg_topicList.clear().draw();
			
			ins_connector_tg_tableList.rows({selected: true}).deselect();
			ins_connector_tg_tableList.clear().draw();

			//조회 후, connector_tableList과 비교 후 같으면 리스트에서 제외
			if (result.data != null) {
				fn_ins_target_trableListRemove(result.data);
			} 

		}
	});
}

/* ********************************************************
 * 조회 데이터 중복 내역 방지
 ******************************************************** */
	function fn_ins_target_trableListRemove(result){
	var connTableRows = ins_connector_tg_tableList.rows().data();

	if (connTableRows.length > 0 && result.length > 0) {
		for(var i=0; i<result.length; i++){
			for(var j=0; j<connTableRows.length; j++){
				if(result[i].topic_name == connTableRows[j].topic_name){
					result.splice(i, 1);
				}
			}
		}
	}

	ins_tg_topicList.rows.add(result).draw();
}

	
/*================ 테이블 리스트 조정 ======================= */
/* ********************************************************
 * 선택 우측이동 (> 클릭)
 ******************************************************** */
function fn_ins_t_tg_rightMove() {
	var datas = ins_tg_topicList.rows('.selected').data();
	var rows = [];

	//선택 건수 없는 경우
	if(datas.length < 1) {
		showSwalIcon(message_msg35, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(ins_tg_topicList.rows('.selected').data()[i]); 
	}
		
	ins_connector_tg_tableList.rows.add(rows).draw();
	ins_tg_topicList.rows('.selected').remove().draw();
}
	

/* ********************************************************
 * 선택 좌측이동 (< 클릭)
 ******************************************************** */
function fn_ins_t_tg_leftMove() {
	var datas = ins_connector_tg_tableList.rows('.selected').data();
	var rows = [];

	//선택 건수 없는 경우
	if(datas.length < 1) {
		showSwalIcon(message_msg35, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(ins_connector_tg_tableList.rows('.selected').data()[i]); 
	}
	
	ins_tg_topicList.rows.add(rows).draw();
	ins_connector_tg_tableList.rows('.selected').remove().draw();
}

/* ********************************************************
 * 전체 우측이동 (>> 클릭)
 ******************************************************** */	
function fn_ins_t_tg_allRightMove() {
	var datas = ins_tg_topicList.rows().data();
	var rows = [];

	//row 존재 확인
	if(datas.length < 1) {
		showSwalIcon(message_msg01, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(ins_tg_topicList.rows().data()[i]); 	
	}

	ins_connector_tg_tableList.rows.add(rows).draw(); 	
	ins_tg_topicList.rows({selected: true}).deselect();
	ins_tg_topicList.rows().remove().draw();
}


/* ********************************************************
 * 전체 좌측이동 (<< 클릭)
 ******************************************************** */	
function fn_ins_t_tg_allLeftMove() {
	var datas = ins_connector_tg_tableList.rows().data();
	var rows = [];

	//row 존재 확인
	if(datas.length < 1) {
		showSwalIcon(message_msg01, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(ins_connector_tg_tableList.rows().data()[i]); 	
	}

	ins_tg_topicList.rows.add(rows).draw(); 	
	ins_connector_tg_tableList.rows({selected: true}).deselect();
	ins_connector_tg_tableList.rows().remove().draw();
}

/*******************************************end*********************************/

/************************************타겟시스템 수정*****************************/
/* ********************************************************
 * 테이블 설정
 ******************************************************** */
function fn_tg_mod_init(){
	mod_tg_topicList = $('#mod_tg_topicList').DataTable({
		scrollY : "200px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : false,
		bSort: false,
		columns : [
			{
				data : "topic_name", className : "dt-center", defaultContent : ""
			},
		],'select': {'style': 'multi'}
	});

	mod_tg_topicList.tables().header().to$().find('th:eq(0)').css('min-width', '350px');
		
	mod_connector_tg_tableList = $('#mod_connector_tg_topicList').DataTable({
		scrollY : "200px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : false,	
		bSort: false,
		columns : [
			{data : "topic_name", className : "dt-center", defaultContent : ""},			
		 ],'select': {'style': 'multi'}
	});
	
	mod_connector_tg_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '350px');

	$(window).trigger('resize'); 
}

/* ********************************************************
 * DBMS 시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_mod_tg_dbmsInfo(){
	$('#info_trans_targetSystem_mod').show();
	$('#info_trans_targetSystem_add').hide();
	
	$('#info_tg_tans_sys_nm').val("");
	$('#info_tg_dbms_work').val("%");
	
	fn_info_trans_search_dbmsInfo();

	$('#pop_layer_trans_dbmsInfo_reg').modal("show");
}

/* ********************************************************
 * DBMS 서버 호출하여 입력
 ******************************************************** */
function fn_trans_dbmsModCallback(trans_sys_id, trans_sys_nm){
	 $("#mod_tg_trans_trg_sys_id", "#modTargetRegForm").val(nvlPrmSet(trans_sys_id, ''));
	 $("#mod_tg_trans_trg_sys_nm", "#modTargetRegForm").val(nvlPrmSet(trans_sys_nm, ''));
}


/* ********************************************************
 * 커넥터 설정 등록
 ******************************************************** */
function fn_target_mod_update() {
	var table_mapp = [];

	if(!trans_target_mod_valCheck()) {
		return;
	}
	
	var tableDatas = mod_connector_tg_tableList.rows().data();

	if(tableDatas.length > 0){
		var tableRowList = [];
		
		for (var i = 0; i < tableDatas.length; i++) {
			tableRowList.push( mod_connector_tg_tableList.rows().data()[i]);    
			table_mapp.push(mod_connector_tg_tableList.rows().data()[i].topic_name);
		}
		
		$("#mod_tg_topic_mapp_nm", "#modTargetRegForm").val(table_mapp);
		
		var schema_total_cnt= 0;
		var table_total_cnt = 0;

		$.ajax({
			async : false,
			url : "/updateTargetConnectInfo.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				exrt_trg_tb_nm : nvlPrmSet($("#mod_tg_topic_mapp_nm", "#modTargetRegForm").val(), ''),
				trans_trg_sys_id : nvlPrmSet($("#mod_tg_trans_trg_sys_id", "#modTargetRegForm").val(), ''),
				schema_total_cnt : schema_total_cnt,
				table_total_cnt : table_total_cnt,
				trans_id : $("#mod_tg_trans_id","#modTargetRegForm").val(),
				trans_exrt_trg_tb_id : $("#mod_tg_trans_exrt_trg_tb_id","#modTargetRegForm").val(),
			},
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if(result == "success"){
					showSwalIcon(message_msg144, closeBtn, '', 'success');
					$('#pop_layer_con_re_reg_two_target').modal('hide');

					//자동활성화 등록
					if($("#mod_target_transActive_act", "#modTargetRegForm").is(":checked") == true){
						fn_auto_trans_active_start("mod_target", $("#mod_tg_trans_exrt_trg_tb_id","#modTargetRegForm").val(), $("#mod_tg_trans_id","#modTargetRegForm").val());
					} else {
						fn_tot_select();
					}
				}else{
					showSwalIcon(migration_msg06, closeBtn, '', 'error');
					$('#pop_layer_con_re_reg_two_target').modal('show');
					return false;
				}
			}
		});	
	}
}

/* ********************************************************
 * 테이블 리스트 조회
 ******************************************************** */
function fn_topic_search_tg_mod(){
	
	var db_svr_id = $("#db_svr_id","#findList").val();
	var kc_ip = $("#mod_tg_kc_ip", "#searchTargetModForm").val();

	$.ajax({
		url : "/selectTargetTopicMappList.do",
		data : {
			db_svr_id : db_svr_id,
			kc_ip : kc_ip
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {	
			mod_tg_topicList.rows({selected: true}).deselect();
			mod_tg_topicList.clear().draw();

			//조회 후, connector_tableList과 비교 후 같으면 리스트에서 제외
			if (result.data != null) {
				fn_mod_target_trableListRemove(result.data);
			} 
		}
	});
}

/* ********************************************************
 * 조회 데이터 중복 내역 방지
 ******************************************************** */
	function fn_mod_target_trableListRemove(result){
	var connTableRows = mod_connector_tg_tableList.rows().data();

	if (connTableRows.length > 0 && result.length > 0) {
		for(var i=0; i<result.length; i++){
			for(var j=0; j<connTableRows.length; j++){
				if(result[i].topic_name == connTableRows[j].topic_name){
					result.splice(i, 1);
				}
			}
		}
	}

	mod_tg_topicList.rows.add(result).draw();
}
	
/*================ 테이블 리스트 조정 ======================= */
/* ********************************************************
 * 선택 우측이동 (> 클릭)
 ******************************************************** */
function fn_mod_t_tg_rightMove() {
	var datas = mod_tg_topicList.rows('.selected').data();
	var rows = [];

	//선택 건수 없는 경우
	if(datas.length < 1) {
		showSwalIcon(message_msg35, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(mod_tg_topicList.rows('.selected').data()[i]); 
	}
	
	mod_connector_tg_tableList.rows.add(rows).draw();
	mod_tg_topicList.rows('.selected').remove().draw();
}
	
/* ********************************************************
 * 선택 좌측이동 (< 클릭)
 ******************************************************** */
function fn_mod_t_tg_leftMove() {
	var datas = mod_connector_tg_tableList.rows('.selected').data();
	var rows = [];

	//선택 건수 없는 경우
	if(datas.length < 1) {
		showSwalIcon(message_msg35, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(mod_connector_tg_tableList.rows('.selected').data()[i]); 
	}
		
	mod_tg_topicList.rows.add(rows).draw();
	mod_connector_tg_tableList.rows('.selected').remove().draw();
}

/* ********************************************************
 * 전체 우측이동 (>> 클릭)
 ******************************************************** */	
function fn_mod_t_tg_allRightMove() {
	var datas = mod_tg_topicList.rows().data();
	var rows = [];

	//row 존재 확인
	if(datas.length < 1) {
		showSwalIcon(message_msg01, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(mod_tg_topicList.rows().data()[i]); 	
	}
	
	mod_connector_tg_tableList.rows.add(rows).draw(); 	
	mod_tg_topicList.rows({selected: true}).deselect();
	mod_tg_topicList.rows().remove().draw();
}

/* ********************************************************
 * 전체 좌측이동 (<< 클릭)
 ******************************************************** */	
function fn_mod_t_tg_allLeftMove() {
	var datas = mod_connector_tg_tableList.rows().data();
	var rows = [];

	//row 존재 확인
	if(datas.length < 1) {
		showSwalIcon(message_msg01, closeBtn, '', 'warning');
		return;
	}

	for (var i = 0;i<datas.length;i++) {
		rows.push(mod_connector_tg_tableList.rows().data()[i]); 	
	}
	
	mod_tg_topicList.rows.add(rows).draw(); 	
	mod_connector_tg_tableList.rows({selected: true}).deselect();
	mod_connector_tg_tableList.rows().remove().draw();
}
/**************************************end*************************************/

/*********************************DBMS 관리************************************/

/* ********************************************************
 * 팝업시작
 ******************************************************** */
function fn_tansDbmsPopStart() {
	//조회
	fn_trans_dbms_pop_search();

  	$(function() {	
		$('#tansDbmsPopList tbody').on( 'click', 'tr', function () {
			if ( $(this).hasClass('selected') ) {
			}else {	        	
				tans_dbms_pop_table.$('tr.selected').removeClass('selected');
				$(this).addClass('selected');	            
			} 
		})   
  	});
}

/* ********************************************************
 * DBMS 조회
 ******************************************************** */
function fn_trans_dbms_pop_search(){
	$.ajax({
		url : "/selectTransDBMS.do",
		data : {
			trans_sys_nm : nvlPrmSet($("#pop_trans_sys_nm").val(), ''),
			ipadr : nvlPrmSet($("#pop_ipadr").val(), ''),
			dtb_nm : nvlPrmSet($("#pop_dtb_nm").val(), '')
		},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			tans_dbms_pop_table.rows({selected: true}).deselect();
			tans_dbms_pop_table.clear().draw();
			if (nvlPrmSet(result, '') != '') {
				tans_dbms_pop_table.rows.add(result).draw();
			}
		}
	});
}

/* ********************************************************
 * 테이블 셋팅
 ******************************************************** */
function fn_tans_dbms_pop_init() {
	/* ********************************************************
	 * 리스트
	 ******************************************************** */
	 tans_dbms_pop_table = $('#tansDbmsPopList').DataTable({
		scrollY : "270px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
			{data : "rownum",  className : "dt-center", defaultContent : ""},
			{data : "trans_sys_nm", className : "dt-center", defaultContent : ""},
			{data : "dbms_dscd_nm", className : "dt-center", defaultContent : ""},
			{data : "ipadr", className : "dt-center", defaultContent : ""},
			{data : "dtb_nm", className : "dt-center", defaultContent : ""},
			{data : "scm_nm", className : "dt-center", defaultContent : ""},
			{data : "portno", className : "dt-center", defaultContent : ""},
		    {data : "spr_usr_id", className : "dt-center", defaultContent : ""},
			{data : "trans_sys_id",  defaultContent : "", visible: false }
		]
	});

	tans_dbms_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	tans_dbms_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '170px');
		tans_dbms_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	tans_dbms_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
	tans_dbms_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '120px');
	tans_dbms_pop_table.tables().header().to$().find('th:eq(5)').css('min-width', '150px');
	tans_dbms_pop_table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');		
	tans_dbms_pop_table.tables().header().to$().find('th:eq(7)').css('min-width', '138px');	
	tans_dbms_pop_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');

	$(window).trigger('resize');
}

/* ********************************************************
 * DBMS 등록 팝업페이지 호출
 ******************************************************** */
function fn_transDbmsIns_pop(){
	$('#pop_layer_trans_dbms_reg').modal("hide");
	
	$.ajax({
		url : "/popup/transTargetDbmsIns.do",
		data : {
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_tansDbmsRegPopStart(result);
			
			$('#pop_layer_trans_dbms_reg').modal("show");
		}
	});
}

/* ********************************************************
 * DBMS 사용여부 체크
 ******************************************************** */
function fn_transDbmsChk(selGbn) {
	var datas = tans_dbms_pop_table.rows('.selected').data();
	
	if (datas.length <= 0) {
		showSwalIcon(message_msg35, closeBtn, '', 'error');
		return;
	}
	
	var trans_sys_id =  tans_dbms_pop_table.row('.selected').data().trans_sys_id;

	//사용중이거나 활성활 일경우
		$.ajax({
		url : "/popup/selectTransDmbsIngChk.do",
		data : {
			trans_sys_id : trans_sys_id,
			exeGbn : selGbn
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			var msgResult = "";

			if (result != null) {
				if (result == "S") {
					if (selGbn =="update") {
						fn_transDbmsUpd_pop();
					} else {
						fn_trans_dbms_del_confirm();
					}
				} else if (result == "O") {
					msgResult= data_transfer_msg22;
					msgResult = fn_strBrReplcae(msgResult);
					showSwalIcon(msgResult, closeBtn, '', 'error');
					return;
				} else {
					msgResult= data_transfer_msg21;
					msgResult = fn_strBrReplcae(msgResult);
					showSwalIcon(msgResult, closeBtn, '', 'error');
					return;
				}
			} else {
				msgResult= data_transfer_msg21;
				msgResult = fn_strBrReplcae(msgResult);
				showSwalIcon(msgResult, closeBtn, '', 'error');
				return;
			}
		}
	});
}

/* ********************************************************
 * DBMS 수정 팝업페이지 호출
 ******************************************************** */
function fn_transDbmsUpd_pop(){

	var trans_sys_id = tans_dbms_pop_table.row('.selected').data().trans_sys_id;

	$.ajax({
		url : "/popup/transTargetDbmsUpd.do",
		data : {
			trans_sys_id : trans_sys_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if (result.resultInfo != null) {
				fn_tansDbmsModPopStart(result);
				
				$('#pop_layer_trans_dbms_reg_re').modal("show");
			} else {
				showSwalIcon(message_msg01, closeBtn, '', 'error');
				$('#pop_layer_trans_dbms_reg_re').modal("hide");
				return;
			}
		}
	});	
}
/****************************************************************************/

/*************************transDbmsRegForm.jsp******************************/

/* ********************************************************
 * 팝업시작
 ******************************************************** */
function fn_tansDbmsRegPopStart(result) {
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").html("");
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").hide();		

	$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").html("");
	$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").hide();

	$("#reg_trans_sys_nm", "#trasnDbmsInsertPop").val("");
	$("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_ipadr", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_portno", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_dtb_nm", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_schema_nm", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_spr_usr_id", "#trasnDbmsInsertPop").val(""); 
	$("#reg_trans_pwd", "#trasnDbmsInsertPop").val(""); 
	
	$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("fail");
	$('#reg_trans_sys_connection', '#trasnDbmsInsertPop').val("");
	
	$("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").find('option').remove();
	$("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").append('<option value="">' + common_choice + '</option>');

	if (result.dbmsGrb_reg != null) {
		for (var idx=0; idx < result.dbmsGrb_reg.length; idx++) {
			if (result.dbmsGrb_reg[idx].sys_cd == "TC002201") {
				$("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").append("<option value='"+ result.dbmsGrb_reg[idx].sys_cd + "'>" + result.dbmsGrb_reg[idx].sys_cd_nm + "</option>");
			}
		}
	}
}

/* ********************************************************
 * 시스템명 중복체크
 ******************************************************** */
function fn_transDbmsInsSysnmCheck() {
	if ($('#reg_trans_sys_nm', '#trasnDbmsInsertPop').val() == "") {
		showSwalIcon(migration_msg01, closeBtn, '', 'warning');
		return;
	}
	
	//msg 초기화
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").html('');
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").hide();
	
	$.ajax({
		url : '/trans_sys_nmCheck.do',
		type : 'post',
		data : {
			trans_sys_nm : $('#reg_trans_sys_nm', '#trasnDbmsInsertPop').val()
		},
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if (result == "true") {
				showSwalIcon(migration_msg04, closeBtn, '', 'success');
				$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("success");
			} else {
				showSwalIcon(migration_msg05, closeBtn, '', 'error');
				$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("fail");
			}
		}
	});
}

/* ********************************************************
 * 시스템 명 변경시
 ******************************************************** */
function fn_reg_trans_sys_nmCho() {
	$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("fail");
	
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").html('');
	$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").hide();
}

/* ********************************************************
 * DBMS 등록
 ******************************************************** */
function fn_trans_insertDBMS(){
	$('#trasnDbmsInsertPop').submit();
}

/* ********************************************************
 * DBMS 등록 로직 실행
 ******************************************************** */
function fn_trans_dbms_insert_proc(){
	if (!ins_trans_dbms_valCheck()) return false;

	$.ajax({
		async : false,
  		url : "/popup/insertTransDBMS.do",
		data : {
  		 	trans_sys_nm : nvlPrmSet($("#reg_trans_sys_nm", "#trasnDbmsInsertPop").val(), ''),
  			ipadr : nvlPrmSet($("#reg_trans_ipadr", "#trasnDbmsInsertPop").val(), ''),
  		 	portno : nvlPrmSet($("#reg_trans_portno", "#trasnDbmsInsertPop").val(), ''),
  		  	dtb_nm : nvlPrmSet($("#reg_trans_dtb_nm", "#trasnDbmsInsertPop").val(), ''),
  		  	scm_nm : nvlPrmSet($("#reg_trans_schema_nm", "#trasnDbmsInsertPop").val(), ''),
  		   	spr_usr_id : nvlPrmSet($("#reg_trans_spr_usr_id", "#trasnDbmsInsertPop").val(), ''),
  		   	pwd : nvlPrmSet($("#reg_trans_pwd", "#trasnDbmsInsertPop").val(), ''),
  		  	dbms_dscd : nvlPrmSet($("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").val(), '')
		},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(data) {
			if(data == "O"){ //중복 work명 일경우
				showSwalIcon(migration_msg05, closeBtn, '', 'error');
				return;
			} else if(data == "S"){
				showSwalIcon(message_msg106, closeBtn, '', 'success');
				$('#pop_layer_trans_dbms_reg').modal('hide');
				fn_trans_dbms_pop_search();
			}else{
				showSwalIcon(migration_msg06, closeBtn, '', 'error');
				$('#pop_layer_trans_dbms_reg').modal('show');
				return;
			}
		}
	});
}

/* ********************************************************
 * 시스템 명 변경시
 ******************************************************** */
function fn_reg_trans_dbms_connect_Cho() {
	$('#reg_trans_sys_connection', '#trasnDbmsInsertPop').val("");
	
	$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").html('');
	$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").hide();
}
/****************************************************************************/

/*************************transConnectListForm.jsp******************************/
/* ********************************************************
 * target kafka 설정 버튼 클릭
 ******************************************************** */
function fn_common_kafka_ins(){
	$.ajax({
		url : "/popup/transConSettingForm.do",
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_transKafkaConPopStart();

			$('#pop_layer_trans_con_list').modal("show");
		}
	});
}



/* ********************************************************
 * 테이블 셋팅
 ******************************************************** */
function fn_trans_kafka_con_pop_init() {
	/* ********************************************************
	 * 리스트
	 ******************************************************** */
	trans_kafka_con_pop_table = $('#transKfkConPopList').DataTable({
		scrollY : "260px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		paging: false,
		columns : [
			{data : "rownum",  className : "dt-center", defaultContent : ""},
			{data : "kc_nm", className : "dt-left", defaultContent : ""},
			{data : "kc_ip", className : "dt-center", defaultContent : ""},
			{data : "kc_port", className : "dt-center", defaultContent : ""},

			{data : "exe_status", 
				render: function (data, type, full){
					var html = "";
					if(full.exe_status == "TC001501"){
						html += "<div class='badge badge-pill badge-success'>";
						html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
						html += 		data_transfer_connecting;
					} else {
						html += "<div class='badge badge-pill badge-danger'>";
						html += "	<i class='ti-close mr-2'></i>";
						html += 		schedule_stop;
					}

					html += "</div>";

					return html;
				},
				className : "dt-left",
				defaultContent : "" 	
			},
			
			{data : "dtb_nm", className : "dt-center", defaultContent : ""},
			{data : "kc_id",  defaultContent : "", visible: false }
		]
	});
	 

	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '123px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	trans_kafka_con_pop_table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');

	$(window).trigger('resize');
}

/* ********************************************************
 * 팝업시작
 ******************************************************** */
function fn_transKafkaConPopStart() {
	//조회
	fn_trans_kafka_con_pop_search();

  	$(function() {	
		$('#transKfkConPopList tbody').on( 'click', 'tr', function () {
			if ( $(this).hasClass('selected') ) {
			}else {
				tans_dbms_pop_table.$('tr.selected').removeClass('selected');
				$(this).addClass('selected');
			}
		})
	});
}

/* ********************************************************
 * kafka connect 조회
 ******************************************************** */
function fn_trans_kafka_con_pop_search(){

	$.ajax({
		url : "/selectTransKafkaConList.do",
		data : {
			kc_nm : nvlPrmSet($("#pop_trans_kafka_con_nm").val(), '')
		},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			trans_kafka_con_pop_table.rows({selected: true}).deselect();
			trans_kafka_con_pop_table.clear().draw();
			if (nvlPrmSet(result, '') != '') {
				trans_kafka_con_pop_table.rows.add(result).draw();
			}
		}
	});
}

/* ********************************************************
 * kafka connect 등록 팝업페이지 호출
 ******************************************************** */
function fn_trans_kfk_con_Ins_pop(){
	$('#pop_layer_trans_kfk_con_reg').modal("hide");
	
	$.ajax({
		url : "/popup/transTargetKfkConIns.do",
		data : {
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			fn_tansKfkConRegPopStart(result);

			$('#pop_layer_trans_kfk_con_reg').modal("show");
		}
	});
}
/************************************************************************/

/*************************transDbmsRegForm.jsp******************************/

/* ********************************************************
 * 팝업시작
 ******************************************************** */
function fn_tansKfkConRegPopStart(result) {
	$("#ins_trans_kafka_con_nm", "#insTransKfkConRegForm").val("");
	$("#ins_trans_kafka_con_ip", "#insTransKfkConRegForm").val(""); 
	$("#ins_trans_kafka_con_port", "#insTransKfkConRegForm").val(""); 
	$("#ins_trans_kafka_con_Chk", "#insTransKfkConRegForm").val("fail"); 
}

/* ********************************************************
 * insert 실행
 ******************************************************** */
function fnc_ins_trans_kafka_con_wrk() {
	if (!ins_trans_kafka_ins_valCheck()) return false;

	$.ajax({
		async : false,
		url : "/popup/insertTransKafkaConnect.do",
	  	data : {
	  		kc_nm : nvlPrmSet($("#ins_trans_kafka_con_nm","#insTransKfkConRegForm").val(),''),
	  		kc_ip : nvlPrmSet($("#ins_trans_kafka_con_ip","#insTransKfkConRegForm").val(),''),
	  		kc_port : nvlPrmSet($("#ins_trans_kafka_con_port","#insTransKfkConRegForm").val(),'')
	  	},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if(result == "O"){ //중복 work명 일경우
				showSwalIcon(data_transfer_msg28, closeBtn, '', 'error');
				return;
			} else if(result == "S"){
				showSwalIcon(message_msg106, closeBtn, '', 'success');
				$('#pop_layer_trans_kfk_con_reg').modal('hide');
				fn_trans_kafka_con_pop_search();
			}else{
				showSwalIcon(migration_msg06, closeBtn, '', 'error');
				$('#pop_layer_trans_kfk_con_reg').modal('show');
				return;
			}
		}
	});
}


/* ********************************************************
 * 팝업시작
 ******************************************************** */
function fn_tansKafkaConModPopStart(result) {
	$("#mod_trans_kafka_con_nm", "#modTransKfkConRegForm").val(nvlPrmSet(result.resultInfo[0].kc_nm, ""));
	$("#mod_trans_kafka_con_ip", "#modTransKfkConRegForm").val(nvlPrmSet(result.resultInfo[0].kc_ip, "")); 
	$("#mod_trans_kafka_con_port", "#modTransKfkConRegForm").val(nvlPrmSet(result.resultInfo[0].kc_port, "")); 
	$("#mod_trans_kafka_con_id", "#modTransKfkConRegForm").val(nvlPrmSet(result.resultInfo[0].kc_id, ""));
	$("#mod_trans_kafka_con_Chk", "#modTransKfkConRegForm").val("success"); 
}


/* ********************************************************
 * update 실행
 ******************************************************** */
function fnc_mod_trans_kafka_con_wrk() {
	if (!mod_trans_kafka_ins_valCheck()) return false;

	$.ajax({
		async : false,
		url : "/popup/updateTransKafkaConnect.do",
	  	data : {
	  		kc_id : nvlPrmSet($("#mod_trans_kafka_con_id","#modTransKfkConRegForm").val(),''),
	  		kc_nm : nvlPrmSet($("#mod_trans_kafka_con_nm","#modTransKfkConRegForm").val(),''),
	  		kc_ip : nvlPrmSet($("#mod_trans_kafka_con_ip","#modTransKfkConRegForm").val(),''),
	  		kc_port : nvlPrmSet($("#mod_trans_kafka_con_port","#modTransKfkConRegForm").val(),'')
	  	},
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			if(result == "S"){
				showSwalIcon(message_msg106, closeBtn, '', 'success');
				$('#pop_layer_trans_kfk_con_reg_re').modal('hide');
				fn_trans_kafka_con_pop_search();
			}else{
				showSwalIcon(migration_msg06, closeBtn, '', 'error');
				$('#pop_layer_trans_kfk_con_reg_re').modal('show');
				return;
			}
		}
	});
}

