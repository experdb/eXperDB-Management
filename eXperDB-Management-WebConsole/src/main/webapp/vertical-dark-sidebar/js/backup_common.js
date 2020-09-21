$(window).ready(function(){
	/* ********************************************************
	 * Click Search Button
	 ******************************************************** */
	$("#btnSelect").click(function() {
		fn_schedule_leftListSize();
		if(selectChkTab == "rman"){
			fn_get_rman_list();
		}else{
			fn_get_dump_list();
		}
	});

	/* ********************************************************
	 * insert Button
	 ******************************************************** */
	$("#btnInsert").click(function() {
		fn_schedule_leftListSize();
		fn_reg_popup();
	});

	/* ********************************************************
	 * modify Button
	 ******************************************************** */
	$("#btnModify").click(function() {
		fn_schedule_leftListSize();
		fn_rereg_popup();
	});

	/* ********************************************************
	 * delete Button
	 ******************************************************** */
	$("#btnDelete").click(function() {
		fn_schedule_leftListSize();
		fn_work_delete_confirm();
	});
	
	/* ********************************************************
	 * 즉시실행 Button
	 ******************************************************** */
	$("#btnImmediately").click(function() {
		fn_schedule_leftListSize();
		fn_ImmediateStartConfirm();
	});
});

/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectInitTab(intab){
	selectChkTab = intab;
	if(intab == "rman"){			
		$(".searchRman").show();
		$(".searchDump").hide();
		$("#rmanDataTableDiv").show();
		$("#dumpDataTableDiv").hide();

		seachParamInit(intab);
	}else{				
		$(".searchRman").hide();
		$(".searchDump").show();
		$("#rmanDataTableDiv").hide();
		$("#dumpDataTableDiv").show();

		seachParamInit(intab);
	}

	//테이블 setting
	fn_rman_init();
	fn_dump_init();
}


/* ********************************************************
 * 조회조건 초기화
 ******************************************************** */
function seachParamInit(tabGbn) {
	if (searchInit == tabGbn) {
		return;
	}

	if (tabGbn == "rman") {
		$("#bck_opt_cd option:eq(0)").attr("selected","selected");
	} else {
		$("#db_id option:eq(0)").attr("selected","selected");
	}

	searchInit = tabGbn;
}


/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(intab){
	fn_schedule_leftListSize();
	selectChkTab = intab;

	if(intab == "rman"){			
		$(".search_rman").show();
		$(".search_dump").hide();
		$("#rmanDataTableDiv").show();
		$("#dumpDataTableDiv").hide();

		seachParamInit(intab);

		fn_get_rman_list();
	}else{				
		$(".search_rman").hide();
		$(".search_dump").show();
		$("#rmanDataTableDiv").hide();
		$("#dumpDataTableDiv").show();

		seachParamInit(intab);

		fn_get_dump_list();
	}
}


/* ********************************************************
 * Get Rman Log List
 ******************************************************** */
function fn_get_rman_list(){
		$.ajax({
			url : "/backup/getWorkList.do", 
			data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			bck_bsn_dscd : "TC000201",
			bck_opt_cd : $("#bck_opt_cd", '#findSearch').val(),
			wrk_nm : nvlPrmSet($('#wrk_nm', '#findSearch').val(), "")
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
		success : function(data) {
			tableRman.rows({selected: true}).deselect();
			tableRman.clear().draw();

			if (nvlPrmSet(data, "") != '') {
				tableRman.rows.add(data).draw();
			}
		}
	});
}

/* ********************************************************
 * Get Dump Log List
 ******************************************************** */
function fn_get_dump_list(){		
	var db_id = $("#db_id", '#findSearch').val();
	if(db_id == "") db_id = 0;
	
	$.ajax({
		url : "/backup/getWorkList.do",
		data : {
			db_svr_id : $("#db_svr_id", "#findList").val(),
			bck_bsn_dscd : "TC000202",
			db_id : db_id,
			wrk_nm : nvlPrmSet($('#wrk_nm', '#findSearch').val(), "")
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
		success : function(data) {
			tableDump.rows({selected: true}).deselect();
			tableDump.clear().draw();

			if (nvlPrmSet(data, "") != '') {
				tableDump.rows.add(data).draw();
			}
		}
	});
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "del_rman" || gbn == "del_dump") {
		fn_deleteWork(gbn);
	} else if (gbn =="run_immediately") {
		fn_ImmediateStart();
	}
}

/* ********************************************************
 * 등록버튼 클릭시 
 ******************************************************** */
function fn_reg_popup(){
	var regUrl = "";

	if (selectChkTab == "rman") {
		regUrl = "/popup/rmanRegForm.do";
	} else {
		regUrl = "/popup/dumpRegForm.do";
	}

	$.ajax({
		url : regUrl,
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
			fn_insert_chogihwa(selectChkTab, result);

			if (selectChkTab == "rman") {
				$('#pop_layer_reg_rman').modal("show");
			} else {
				$('#pop_layer_reg_dump').modal("show");
			}
		}
	});
}

/* ********************************************************
 * 등록 팝업 초기화
 ******************************************************** */
function fn_insert_chogihwa(gbn, result) {
	if (gbn == "rman") {
		//work 명
		$("#ins_wrk_nm", "#workRegForm").val("");
		//work 설명
		$("#ins_wrk_exp", "#workRegForm").val("");
		//name check
		$("#ins_wrk_nmChk", "#workRegForm").val("fail");
		$("#ins_check_path2", "#workRegForm").val("N");
		
		//백업옵션
		$("#ins_bck_opt_cd", "#workRegForm").val('').prop("selected", true);
		//데이터경로
		$("#ins_data_pth", "#workRegForm").val("");
		//백업경로
		$("#ins_bck_pth", "#workRegForm").val("");
		
		//용량
		$("#backupVolume", "#workRegForm").html(common_volume + ' : 0');
		$("#backupVolume_div", "#workRegForm").show();

		$("#ins_file_stg_dcnt", "#workRegForm").val("0"); 	//Full 백업파일보관일
		$("#ins_bck_mtn_ecnt", "#workRegForm").val("0"); 	//Full 백업파일 유지개수
		$("#ins_acv_file_stgdt", "#workRegForm").val("0"); 	//아카이브 파일보관일
		$("#ins_acv_file_mtncnt", "#workRegForm").val("0"); //아카이브 파일유지개수

		//압축하기
		$("#ins_cps_yn", "#workRegForm").val("");
		$("input:checkbox[id='ins_cps_yn_chk']").prop("checked", false); 
		
		//로그파일백업 여부
		$("#ins_log_file_bck_yn", "#workRegForm").val("");
		$("input:checkbox[id='ins_log_file_bck_yn_chk']").prop("checked", false); 
		
		$("#ins_log_file_stg_dcnt", "#workRegForm").val("0"); 	//서버로그 파일 보관일수
		$("#ins_log_file_mtn_ecnt", "#workRegForm").val("0"); 	//아카이브 파일유지개수
		
		//validate box 초기화
		$("#ins_file_stg_dcnt_alert", "#workRegForm").html("");
		$("#ins_file_stg_dcnt_alert", "#workRegForm").hide();
		$("#ins_bck_mtn_ecnt_alert", "#workRegForm").html("");
		$("#ins_bck_mtn_ecnt_alert", "#workRegForm").hide();
		$("#ins_log_file_stg_dcnt_alert", "#workRegForm").html("");
		$("#ins_log_file_stg_dcnt_alert", "#workRegForm").hide();
		$("#ins_acv_file_stgdt_alert", "#workRegForm").html("");
		$("#ins_acv_file_stgdt_alert", "#workRegForm").hide();			
		$("#ins_acv_file_mtncnt_alert", "#workRegForm").html("");
		$("#ins_acv_file_mtncnt_alert", "#workRegForm").hide();			
		$("#ins_log_file_mtn_ecnt_alert", "#workRegForm").html("");
		$("#ins_log_file_mtn_ecnt_alert", "#workRegForm").hide();			

		$("#ins_bck_pth_check_alert", "#workRegForm").html("");
		$("#ins_bck_pth_check_alert", "#workRegForm").hide();
		$("#ins_worknm_check_alert", "#workRegForm").html("");
		$("#ins_worknm_check_alert", "#workRegForm").hide();
		
		fn_insertWorkPopStart();
	} else {
		//상단
		$("#ins_dump_wrk_nm", "#workDumpRegForm").val(""); 									//work 명
		$("#ins_dump_wrk_exp", "#workDumpRegForm").val("");									//work 설명
		
		//database
		$("#ins_dump_db_id", "#workDumpRegForm").val('').prop("selected", true);			//Database
		
		//백업셋팅
		$("#ins_dump_save_pth", "#workDumpRegForm").val("");								//백업경로
		$("#dump_backupVolume", "#workDumpRegForm").html(common_volume + ' : 0'); //용량
		$("#dump_backupVolume_div", "#workDumpRegForm").show();
		$("#ins_dump_file_fmt_cd", "#workDumpRegForm").val('0000').prop("selected", true);	//파일포멧
		$("#ins_dump_encd_mth_nm", "#workDumpRegForm").val('0000').prop("selected", true);	//인코딩방식
		$("#ins_dump_usr_role_nm", "#workDumpRegForm").val('0000').prop("selected", true);	//Rolename
		$("#ins_dump_cprt", "#workDumpRegForm").val('0').prop("selected", true);			//압축률
		$("#ins_dump_cprt", "#workDumpRegForm").attr("disabled",true);
		$("#ins_dump_file_stg_dcnt", "#workDumpRegForm").val("1"); 							//파일보관일수
		$("#ins_dump_bck_mtn_ecnt", "#workDumpRegForm").val("1"); 							//백업유지개수
		
		//tab checkbox 해제
		$("input:checkbox[name=ins_dump_opt]").prop("checked", false); 
		
		//tab 선택
		$('a[href="#insDumpOptionTab1"]').tab('show');

		//hidden
		$("#ins_dump_wrk_nmChk", "#workDumpRegForm").val("fail");							//name check
		$("#ins_dump_check_path2", "#workDumpRegForm").val("N");							//경로 check
		
		
		//validate box 초기화
		$("#ins_dump_worknm_check_alert", "#workDumpRegForm").html("");
		$("#ins_dump_worknm_check_alert", "#workDumpRegForm").hide();
		$("#ins_dump_save_pth_alert", "#workDumpRegForm").html("");
		$("#ins_dump_save_pth_alert", "#workDumpRegForm").hide();
		$("#ins_dump_file_fmt_cd_alert", "#workDumpRegForm").html("");
		$("#ins_dump_file_fmt_cd_alert", "#workDumpRegForm").hide();			
		$("#ins_dump_encd_mth_nm_alert", "#workDumpRegForm").html("");
		$("#ins_dump_encd_mth_nm_alert", "#workDumpRegForm").hide();			
		$("#ins_dump_usr_role_nm_alert", "#workDumpRegForm").html("");
		$("#ins_dump_usr_role_nm_alert", "#workDumpRegForm").hide();		

		//오브젝트 선택
		$("#treeview_container", "#workDumpRegForm").html("");
		
		//rollname selectbox 셋팅
		$("#ins_dump_usr_role_nm", "#workDumpRegForm").find('option').remove();
		$("#ins_dump_usr_role_nm", "#workDumpRegForm").append('<option value="0000">'+ common_choice +'</option>');

		if (nvlPrmSet(result.roleList.data,"") != "") {
			for (var idx=0; idx < result.roleList.data.length; idx++) {
				$("#ins_dump_usr_role_nm", "#workDumpRegForm").append("<option value='"+ result.roleList.data[idx].rolname + "'>" + result.roleList.data[idx].rolname + "</option>");
			}
		}

		fn_insertDumpWorkPopStart();
	}
}

/* ********************************************************
 * 수정 팝업 초기화
 ******************************************************** */
function fn_update_chogihwa(gbn, result) {
	if (gbn == "rman") {
		//상단
		$("#mod_wrk_nm", "#workModForm").val(nvlPrmSet(result.workInfo[0].wrk_nm, "")); 						//work 명
		$("#mod_wrk_exp", "#workModForm").val(nvlPrmSet(result.workInfo[0].wrk_exp, "")); 						//work 설명
		
		//hidden
		$("#mod_check_path2", "#workModForm").val("Y"); 														//백업경로체크
		$("#mod_bck_wrk_id", "#workModForm").val(nvlPrmSet(result.bck_wrk_id, "")); 							//백업작업id
		$("#mod_wrk_id", "#workModForm").val(nvlPrmSet(result.wrk_id, "")); 									//작업id

		//옵션 및 경로
		$("#mod_bck_opt_cd", "#workModForm").val(nvlPrmSet(result.workInfo[0].bck_opt_cd, "")).prop("selected", true); //백업옵션
		$("#mod_data_pth", "#workModForm").val(nvlPrmSet(result.workInfo[0].data_pth, ""));						//데이터경로
		$("#mod_bck_pth", "#workModForm").val(nvlPrmSet(result.workInfo[0].bck_pth, ""));						//백업경로
		$("#mod_backupVolume", "#workModForm").html(common_volume + ' : 0');
		$("#mod_backupVolume_div", "#workModForm").show();														//용량
		
		//옵션 - 왼쪽메뉴
		$("#mod_file_stg_dcnt", "#workModForm").val(nvlPrmSet(result.workInfo[0].file_stg_dcnt, "0"));			//Full 백업파일보관일
		$("#mod_bck_mtn_ecnt", "#workModForm").val(nvlPrmSet(result.workInfo[0].bck_mtn_ecnt, "0")); 			//Full 백업파일 유지개수
		$("#mod_acv_file_stgdt", "#workModForm").val(nvlPrmSet(result.workInfo[0].acv_file_stgdt, "0")); 		//아카이브 파일보관일
		$("#mod_acv_file_mtncnt", "#workModForm").val(nvlPrmSet(result.workInfo[0].acv_file_mtncnt, "0")); 		//아카이브 파일유지개수
		$("#mod_log_file_bck_yn", "#workModForm").val(nvlPrmSet(result.workInfo[0].log_file_bck_yn, ""));		//로그파일백업 여부
		$("#mod_cps_yn", "#workModForm").val(nvlPrmSet(result.workInfo[0].cps_yn, ""));							//압축하기
		if (nvlPrmSet(result.workInfo[0].cps_yn, "") == "Y") {
			$("input:checkbox[id='mod_cps_yn_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_cps_yn_chk']").prop("checked", false); 
		}
		
		//옵션 - 오른쪽메뉴	
		$("#mod_log_file_bck_yn", "#workModForm").val(nvlPrmSet(result.workInfo[0].log_file_bck_yn, ""));		//로그파일백업 여부
		if (nvlPrmSet(result.workInfo[0].log_file_bck_yn, "") == "Y") {
			$("input:checkbox[id='mod_log_file_bck_yn_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_log_file_bck_yn_chk']").prop("checked", false); 
		}
		$("#mod_log_file_stg_dcnt", "#workModForm").val(nvlPrmSet(result.workInfo[0].log_file_stg_dcnt, "0")); 	//서버로그 파일 보관일수
		$("#mod_log_file_mtn_ecnt", "#workModForm").val(nvlPrmSet(result.workInfo[0].log_file_mtn_ecnt, "0")); 	//아카이브 파일유지개수
		
		//validate box 초기화
		$("#mod_bck_pth_check_alert", "#workModForm").html("");
		$("#mod_bck_pth_check_alert", "#workModForm").hide();
		$("#mod_file_stg_dcnt_alert", "#workModForm").html("");
		$("#mod_file_stg_dcnt_alert", "#workModForm").hide();
		$("#mod_bck_mtn_ecnt_alert", "#workModForm").html("");
		$("#mod_bck_mtn_ecnt_alert", "#workModForm").hide();
		$("#mod_log_file_stg_dcnt_alert", "#workModForm").html("");
		$("#mod_log_file_stg_dcnt_alert", "#workModForm").hide();
		$("#mod_acv_file_stgdt_alert", "#workModForm").html("");
		$("#mod_acv_file_stgdt_alert", "#workModForm").hide();			
		$("#mod_acv_file_mtncnt_alert", "#workModForm").html("");
		$("#mod_acv_file_mtncnt_alert", "#workModForm").hide();			
		$("#mod_log_file_mtn_ecnt_alert", "#workModForm").html("");
		$("#mod_log_file_mtn_ecnt_alert", "#workModForm").hide();	
		
		fn_modWorkPopStart();
	} else {
		//상단
		$("#mod_dump_wrk_nm", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].wrk_nm, "")); 						//work 명
		$("#mod_dump_wrk_exp", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].wrk_exp, "")); 						//work 설명
		
		//hidden
		$("#mod_dump_check_path2", "#workDumpModForm").val("Y"); 														//백업경로체크
		$("#mod_dump_bck_wrk_id", "#workDumpModForm").val(nvlPrmSet(result.bck_wrk_id, "")); 							//백업작업id
		$("#mod_dump_wrk_id", "#workDumpModForm").val(nvlPrmSet(result.wrk_id, "")); 									//작업id

		//database
		$("#mod_dump_db_id", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].db_id, "")); 							//Database
		
		//백업셋팅
		$("#mod_dump_save_pth", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].save_pth, ""));					//백업경로
		$("#mod_dump_backupVolume", "#workDumpModForm").html(common_volume + ' : 0'); 			//용량
		$("#mod_dump_backupVolume_div", "#workDumpModForm").show();
		$("#mod_dump_file_fmt_cd", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].file_fmt_cd, "0000")).prop("selected", true); //백업옵션
		$("#mod_dump_encd_mth_nm", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].encd_mth_cd, "0000")).prop("selected", true);	//인코딩방식

		//rollname selectbox 셋팅
		$("#mod_dump_usr_role_nm", "#workDumpModForm").find('option').remove();
		$("#mod_dump_usr_role_nm", "#workDumpModForm").append('<option value="0000">'+ common_choice + '</option>');
		
		if (nvlPrmSet(result.roleList.data,"") != "") {
			for (var idx=0; idx < result.roleList.data.length; idx++) {
				$("#mod_dump_usr_role_nm", "#workDumpModForm").append("<option value='"+ result.roleList.data[idx].rolname + "'>" + result.roleList.data[idx].rolname + "</option>");
			}
		}
		$("#mod_dump_usr_role_nm", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].usr_role_nm, "0000")).prop("selected", true); //백업옵션
		
		//validate box 초기화
		$("#mod_dump_save_pth_alert", "#workDumpModForm").html("");
		$("#mod_dump_save_pth_alert", "#workDumpModForm").hide();
		$("#mod_dump_file_fmt_cd_alert", "#workDumpModForm").html("");
		$("#mod_dump_file_fmt_cd_alert", "#workDumpModForm").hide();			
		$("#mod_dump_encd_mth_nm_alert", "#workDumpModForm").html("");
		$("#mod_dump_encd_mth_nm_alert", "#workDumpModForm").hide();			
		$("#mod_dump_usr_role_nm_alert", "#workDumpModForm").html("");
		$("#mod_dump_usr_role_nm_alert", "#workDumpModForm").hide();

		$("#mod_dump_cprt", "#workDumpModForm").attr("disabled",true);
		$("#mod_dump_cprt", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].cprt, "0")).prop("selected", true);				//압축률
		
		$("#mod_dump_file_stg_dcnt", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].file_stg_dcnt, "1")); 					//파일보관일수
		$("#mod_dump_bck_mtn_ecnt", "#workDumpModForm").val(nvlPrmSet(result.workInfo[0].bck_mtn_ecnt, "1")); 							//백업유지개수
		
		//tab checkbox 해제
		$("input:checkbox[name=mod_dump_opt]").prop("checked", false); 
		
		//checkbox 선택
		if (result.workOptInfo.length > 0) {
				for (var idx=0; idx < result.workOptInfo.length; idx++) {
				if (result.workOptInfo[idx].grp_cd == "TC0006" && result.workOptInfo[idx].opt_cd == "TC000601") {
					$("input:checkbox[id='mod_dump_option_1_1']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0006" && result.workOptInfo[idx].opt_cd == "TC000602") {
					$("input:checkbox[id='mod_dump_option_1_2']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0006" && result.workOptInfo[idx].opt_cd == "TC000603") {
					$("input:checkbox[id='mod_dump_option_1_3']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0007" && result.workOptInfo[idx].opt_cd == "TC000701") {
					$("input:checkbox[id='mod_dump_option_2_1']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0007" && result.workOptInfo[idx].opt_cd == "TC000702") {
					$("input:checkbox[id='mod_dump_option_2_2']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0007" && result.workOptInfo[idx].opt_cd == "TC000703") {
					$("input:checkbox[id='mod_dump_option_2_3']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0008" && result.workOptInfo[idx].opt_cd == "TC000801") {
					$("input:checkbox[id='mod_dump_option_3_1']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0008" && result.workOptInfo[idx].opt_cd == "TC000802") {
					$("input:checkbox[id='mod_dump_option_3_2']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0008" && result.workOptInfo[idx].opt_cd == "TC000803") {
					$("input:checkbox[id='mod_dump_option_3_3']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0008" && result.workOptInfo[idx].opt_cd == "TC000804") {
					$("input:checkbox[id='mod_dump_option_3_4']").prop("checked", true);
				}

				
				if (result.workOptInfo[idx].grp_cd == "TC0009" && result.workOptInfo[idx].opt_cd == "TC000901") {
					$("input:checkbox[id='mod_dump_option_4_1']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0009" && result.workOptInfo[idx].opt_cd == "TC000902") {
					$("input:checkbox[id='mod_dump_option_4_2']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0009" && result.workOptInfo[idx].opt_cd == "TC000903") {
					$("input:checkbox[id='mod_dump_option_4_3']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0009" && result.workOptInfo[idx].opt_cd == "TC000904") {
					$("input:checkbox[id='mod_dump_option_4_4']").prop("checked", true);
				}
				

				if (result.workOptInfo[idx].grp_cd == "TC0010" && result.workOptInfo[idx].opt_cd == "TC001001") {
					$("input:checkbox[id='mod_dump_option_5_1']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0010" && result.workOptInfo[idx].opt_cd == "TC001002") {
					$("input:checkbox[id='mod_dump_option_5_2']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0010" && result.workOptInfo[idx].opt_cd == "TC001003") {
					$("input:checkbox[id='mod_dump_option_5_3']").prop("checked", true);
				}
				
				if (result.workOptInfo[idx].grp_cd == "TC0010" && result.workOptInfo[idx].opt_cd == "TC001004") {
					$("input:checkbox[id='mod_dump_option_5_4']").prop("checked", true);
				}

				if (result.workOptInfo[idx].grp_cd == "TC0010" && result.workOptInfo[idx].opt_cd == "TC001005") {
					$("input:checkbox[id='mod_dump_option_5_5']").prop("checked", true);
				}
			}
		}

		//tab 선택
		$('a[href="#modDumpOptionTab1"]').tab('show');
		
		//오브젝트 선택
		$("#treeview_container", "#workDumpModForm").html("");

		//트리메뉴 로딩
		var workList = new Array();
		var jsonData = null;
		if (result.workObjList.length > 0) {
				for(var i = 0; i < result.workObjList.length; i++){
		            // 객체 생성
				var workData = new Object() ;
		            
				workData.scm_nm = result.workObjList[i].scm_nm ;
				workData.obj_nm = result.workObjList[i].obj_nm ;
				
				// 리스트에 생성된 객체 삽입
	            workList.push(workData);
			}
				
				workData = new Object() ;
            
			workData.scm_nm = "" ;
			workData.obj_nm = "" ;

			// 리스트에 생성된 객체 삽입
            workList.push(workData);
		} else {
			var workData = new Object() ;
	            
			workData.scm_nm = "" ;
			workData.obj_nm = "" ;
			
			// 리스트에 생성된 객체 삽입
            workList.push(workData);
		}

		fn_modDumpWorkPopStart(workList);
	}
}

//////////////////dumpRegReForm.jsp///////////////////////////////////////////////
/* ********************************************************
 * 팝업시작 dump work
 ******************************************************** */
function fn_modDumpWorkPopStart(workJsonData) {
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
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		success : function(result) {
			haCnt = result[0].hacnt;
		}
	});
	
	//트리메뉴데이터
	mode_workObj = workJsonData;

	fn_mod_dump_checkSection();
	
	fn_mod_changeFileFmtCd();
	
	//용량체크
	fn_mod_dump_checkFolder_init(2);
	
	//트리셋팅
	setTimeout("fn_mod_get_object_list()", 100);
}

/* ********************************************************
 * Sections에 체크시 Object형태중 Only data, Only Schema를 비활성화 시킨다.
 ******************************************************** */
function fn_mod_dump_checkSection(){
	var check = false;
	$("input[name=mod_dump_opt]").each(function(){
		if( ($(this).attr("opt_cd") == "TC000601" || $(this).attr("opt_cd") == "TC000602" || $(this).attr("opt_cd") == "TC000603") && $(this).is(":checked")){
			check = true;
		}
	});
	$("input[name=mod_dump_opt]").each(function(){
		if( $(this).attr("opt_cd") == "TC000701" || $(this).attr("opt_cd") == "TC000702" ){
			if(check){
				$(this).attr("disabled",true);
			}else{
				$(this).removeAttr("disabled");
			}
		}
	});
}


/* ********************************************************
 * File Format에 따른 Checkbox disabled Check
 ******************************************************** */
function fn_mod_changeFileFmtCd(){
	if($("#mod_dump_file_fmt_cd", "#workDumpModForm").val() == "TC000401"){
		$("#mod_dump_cprt", "#workDumpModForm").removeAttr("disabled");
	}else{
		$("#mod_dump_cprt", "#workDumpModForm").attr("disabled",true);
		$("#mod_dump_cprt", "#workDumpModForm").val("0");
	}

	if($("#mod_dump_file_fmt_cd", "#workDumpModForm").val() == "TC000402"){
		$("input[name=mod_dump_opt]").each(function(){
			if( $(this).attr("opt_cd") == "TC000801" || $(this).attr("opt_cd") == "TC000903" || $(this).attr("opt_cd") == "TC000904" ){
				$(this).removeAttr("disabled");
			}
		});
	}else{
		$("input[name=mod_dump_opt]").each(function(){
			if( $(this).attr("opt_cd") == "TC000801" || $(this).attr("opt_cd") == "TC000903" || $(this).attr("opt_cd") == "TC000904" ){
				$(this).attr("disabled",true);
			}
		});
	}
}

/* ********************************************************
 * Get Selected Database`s Object List
 ******************************************************** */
function fn_mod_get_object_list(){
		var db_nm = nvlPrmSet($("#mod_dump_db_id option:selected", "#workDumpModForm").text(), "");
	var db_id = nvlPrmSet($("#mod_dump_db_id option:selected", "#workDumpModForm").val(), "");
	
	if (db_nm == "" || db_id == "") {
		$("#mod_treeview").html("");
		return;
	}

	$.ajax({
		async : false,
		url : "/getObjectList.do",
	  	data : {
		  	db_svr_id : $("#db_svr_id","#findList").val(),
			db_nm : db_nm
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
			if (data != null) {
				fn_mod_make_object_list(data);
			} else {
				$("#mod_treeview").html("");
			}
		}
	});
}

/* ********************************************************
 * Make Object Tree
 ******************************************************** */
function fn_mod_make_object_list(data){
	var html = "<ul id='mod_treeview' class='hummingbird-base'>";
	var schema = "";
	var schemaCnt = 0;
	var mod_checkStr = "";

	$(data.data).each(function (index, item) {
		var inSchema = item.schema;

		if(schemaCnt > 0 && schema != inSchema){
			html += "</ul></li>\n";
		}

		if(schema != inSchema){
			if (mode_workObj.length > 0) {
				for(var i=0;i<mode_workObj.length;i++){
					if(mode_workObj[i].scm_nm == item.schema && mode_workObj[i].obj_nm == "") mod_checkStr = " checked";
				}
			}

			html += "<li>\n";
			html += "<i class='fa fa-minus'></i>\n";
			html += "<label for='mod_schema"+schemaCnt+"'> <input id='mod_schema"+schemaCnt+"' name='mod_tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"' data-id='custom-0' type='checkbox' "+ mod_checkStr +"> "+item.schema+"</label>\n";
			html += '<ul style="display: block;">\n';
		}

		mod_checkStr = "";

		if (mode_workObj.length > 0) {
			for(var i=0;i<mode_workObj.length;i++){
				if(mode_workObj[i].scm_nm == item.schema && mode_workObj[i].obj_nm == item.name) mod_checkStr = " checked";
			}
		}

		html += "<li style='padding-left:20px;'>";
		html += "<label for='mod_table"+index+"'> <input id='mod_table"+index+"' name='mod_tree' value='"+item.name+"' otype='table' schema='"+item.schema+"' data-id='custom-1' type='checkbox' "+mod_checkStr+">  "+item.name+"</label></li>\n";

		if(schema != inSchema){ 
			schema = inSchema;
			schemaCnt++;
		}
	});
	if(schemaCnt > 0) html += "</ul></li>";
	html += "</ul>";

	$("#treeview_container", "#workDumpModForm").html("");
	$("#treeview_container", "#workDumpModForm").html(html);

	$("#mod_treeview", "#workDumpModForm").hummingbird();
}

/* ********************************************************
 * 쿼리에서 Use Column Inserts, Use Insert Commands선택시 "OIDS포함" disabled
 ******************************************************** */
function fn_mod_dump_checkOid(){
	var check = false;
	$("input[name=mod_dump_opt]").each(function(){
		if( ($(this).attr("opt_cd") == "TC000901" || $(this).attr("opt_cd") == "TC000902") && $(this).is(":checked")){
			check = true;
		}
	});
	
	$("input[name=mod_dump_opt]").each(function(){
		if( $(this).attr("opt_cd") == "TC001001" ){
			if(check){
				$(this).attr("disabled",true);
			}else{
				$(this).removeAttr("disabled");
			}
		}
	});
}

/* ********************************************************
 * 전체선택
 ******************************************************** */
function fn_mod_checkAll(schema_id, schema_name) {
	var schemaChkBox = document.getElementById("schema"+schema_id);

	if(schemaChkBox.checked) { 
		$("input[name=mod_tree]").each(function(){
			if($(this).attr("schema") == schema_name) {
				this.checked = true;
			}
		});
	} else { 
		$("input[name=mod_tree]").each(function(){
			if($(this).attr("schema") == schema_name) {
				this.checked = false;
			}
		});
	}
}

/* ********************************************************
 * 옵션 숫자 입력 blur
 ******************************************************** */
function fn_mod_dumpAlertChk(obj) {
	$("#" + obj.id + "_alert", "#workDumpModForm").html("");
	$("#" + obj.id + "_alert", "#workDumpModForm").hide();
}

/* ********************************************************
 * Object형태 중 Only data, Only Schema 중 1개만 체크가능
 ******************************************************** */
function fn_mod_dump_checkObject(code){
	var check1 = false;
	var check2 = false;

	$("input[name=mod_dump_opt]").each(function(){
		if(code == "TC000701" && $(this).attr("opt_cd") == "TC000701" && $(this).is(":checked") ){
			check1 = true;
		}else if(code == "TC000702" && $(this).attr("opt_cd") == "TC000702" && $(this).is(":checked") ){
			check2 = true;
		}
	});

	$("input[name=mod_dump_opt]").each(function(){
		if(check1 && code == "TC000701" && $(this).attr("opt_cd") == "TC000702"){
			$(this).prop("checked", false); 
		}else if(check2 && code == "TC000702" && $(this).attr("opt_cd") == "TC000701"){
			$(this).prop("checked", false); 
		}
	});
}

/* ********************************************************
 * 백업경로변경시
 ******************************************************** */
function fn_mod_check_pathChk(val) {
	$('#mod_dump_check_path2', '#workDumpModForm').val(val);
	
	$("#mod_dump_save_pth_alert", "#workDumpModForm").html('');
	$("#mod_dump_save_pth_alert", "#workDumpModForm").hide();
}


/* ********************************************************
 * Dump Data Table initialization
 ******************************************************** */
function fn_dump_init(){
	tableDump = $('#dumpDataTable').DataTable({
		scrollY: "280px",	
		scrollX: true,	
		bDestroy: true,
		paging : true,
		processing : true,
		searching : false,	
		deferRender : true,
		bSort: false,
		columns : [
					{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
					{data : "idx", className : "dt-center", defaultContent : ""},
					{data : "wrk_nm", defaultContent : ""
						,"render": function (data, type, full) {				
							return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" data-toggle="modal" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
						}
					}, 
					{data : "wrk_exp",
						render : function(data, type, full, meta) {
						var html = '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
						return html;
						},
						defaultContent : ""
					},
					{data: "db_nm", defaultContent: ""}, 
					{data : "save_pth", defaultContent : ""
						,"render": function (data, type, full) {
							return '<span onClick=javascript:fn_dumpShow("'+full.save_pth+'","'+full.db_svr_id+'"); data-toggle="modal" title="'+full.save_pth+'" class="bold">' + full.save_pth + '</span>';
						}
					},
					{data : "file_fmt_cd_nm", 
						render : function(data, type, full, meta) {
							var html = "";
							
							if (nvlPrmSet(full.file_fmt_cd_nm, "") != "") {
								html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
								html += "	<i class='fa fa-file-o mr-2' ></i>";
								html += full.file_fmt_cd_nm;
								html += "</div>";
							}

							return html;
						},
						defaultContent : ""
					},
					{data : "cprt", 
							render : function(data, type, full, meta) {
								var html = "";
								
								if (nvlPrmSet(full.cprt, "0") != "0") {
	 								html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
	 								html += "	<i class='ti-angle-double-right mr-2' ></i>";
	 								html += nvlPrmSet(full.cprt, "0") + " Level";
	 								html += "</div>";	
								} else {
									html += nvlPrmSet(full.cprt, "0");
								}

							return html;
						},

						className : "dt-right", defaultContent : ""
					}, 
					{data : "encd_mth_nm", defaultContent : ""}, 
					{data : "usr_role_nm", defaultContent : ""}, 
					{data : "file_stg_dcnt", 
						render : function(data, type, full, meta) {
							var html = "<div class='badge badge-pill badge-success text-white' style='font-size: 0.875rem;'>";
							html += nvlPrmSet(full.file_stg_dcnt, "0");
							html += "</div>";

							return html;
						},
						className : "dt-right", defaultContent : ""
					},
					{data : "bck_mtn_ecnt", 
						render : function(data, type, full, meta) {
							var html = "<div class='badge badge-pill badge-info text-white' style='font-size: 0.875rem;'>";
							html += nvlPrmSet(full.bck_mtn_ecnt, "0");
							html += "</div>";

							return html;
						},
						className : "dt-right", defaultContent : ""
					},
					{data : "frst_regr_id", defaultContent : ""},
					{data : "frst_reg_dtm", defaultContent : ""},
					{data : "lst_mdfr_id", defaultContent : ""},
					{data : "lst_mdf_dtm", defaultContent : ""},
					{data : "bck_wrk_id", defaultContent : "" , visible: false }
		],'select': {'style': 'multi'}
	});

	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '250px');
	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '60px');
	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');  
	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '90px');  
	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '150px');
	tableDump.tables().header().to$().find('th:eq(12)').css('min-width', '70px');
	tableDump.tables().header().to$().find('th:eq(13)').css('min-width', '110px');
	tableDump.tables().header().to$().find('th:eq(14)').css('min-width', '70px');  
	tableDump.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(16)').css('min-width', '0px');

   	$(window).trigger('resize');
}
