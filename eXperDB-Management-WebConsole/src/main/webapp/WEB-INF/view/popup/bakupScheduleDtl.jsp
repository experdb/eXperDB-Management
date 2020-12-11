<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	var sdt_dtl_table = null;

	$(window.document).ready(function() {
		fn_sdt_dtl_init();
	});

	/* ********************************************************
	 * 팝업시작
	 ******************************************************** */
	function fn_sdtDtlPopStart() {
		$("#sch_dtl_weekday").hide();
		$("#scd_dtl_calendar").hide();
		$("#scd_dtl_month").hide();
		$("#scd_dtl_day").hide();
		$("#scd_dtl_hour").hide();
		$("#scd_dtl_min").hide();
		$("#scd_dtl_sec").hide();
		
		sdt_dtl_table.rows().deselect();

		//캘린더 셋팅
		fn_infoDateCalenderSetting();
	
		//날짜 setting
		fn_sdt_dtl_makeDate();
		
		//조회
		fn_sdt_dtl_search();
	}

	/* ********************************************************
	 * 수정화면 이동
	 ******************************************************** */
	function fn_bckSdtModifyPopup() {
		var reregUrl = "";
		var selectBackGbn = "";
		var works = sdt_dtl_table.rows('.selected').data();

		if (works.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(works.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		var bck_wrk_id = sdt_dtl_table.row('.selected').data().bck_wrk_id;
		var bck_mode = sdt_dtl_table.row('.selected').data().bck_bsn_dscd;
		var db_svr_id = sdt_dtl_table.row('.selected').data().db_svr_id;

		if(bck_mode == "TC000201"){
			reregUrl = "/popup/rmanRegReForm.do";
			selectBackGbn = "rman";
		} else {
			reregUrl = "/popup/dumpRegReForm.do";
			selectBackGbn = "dump";
		}

		$.ajax({
			url : reregUrl,
			data : {
				db_svr_id : db_svr_id,
				bck_wrk_id : bck_wrk_id
			},
			dataType : "json",
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
				
				if (result.workInfo != null) {
					$('#pop_layer_backup_scd_dtl').modal("hide");
					
					fn_backup_dtl_update_chogihwa(selectBackGbn, result);

					if (selectBackGbn == "rman") {
						$('#rman_call_gbn', '#search_rmanReForm').val("backup_sdt");
						
						$('#pop_layer_mod_rman').modal("show");
					} else {
						$('#dump_call_gbn', '#search_dumpReForm').val("backup_sdt");
						
						$('#pop_layer_mod_dump').modal("show");
					}


				} else {
					showSwalIcon('<spring:message code="info.nodata.msg" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * 수정 팝업 초기화
	 ******************************************************** */
	function fn_backup_dtl_update_chogihwa(gbn, result) {

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
	

	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function fn_infoDateCalenderSetting() {
		var today = new Date();
		var startDay = fn_dateParse("20180101");
		var endDay = fn_dateParse("20991231");
		
		var day_today = today.toJSON().slice(0,10);
		var day_start = startDay.toJSON().slice(0,10);
		var day_end = endDay.toJSON().slice(0,10);

		if ($("#sdt_dtl_exe_dt_div").length) {
			$("#sdt_dtl_exe_dt_div").datepicker({
			}).datepicker('setDate', day_today)
			.datepicker('setStartDate', day_start)
			.datepicker('setEndDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
			}); //값 셋팅
		}

		$("#sdt_dtl_exe_dt").datepicker('setDate', day_today).datepicker('setStartDate', day_start).datepicker('setEndDate', day_end);
		$("#sdt_dtl_exe_dt_div").datepicker('updateDates');
	}
	
	/* ********************************************************
	 * detail 조회
	 ******************************************************** */
	function fn_sdt_dtl_search() {
	 	$.ajax({
			url : "/selectModifyScheduleList.do",
			data : {
				scd_id : nvlPrmSet($("#scdInfo_scd_id", "#backupScdInfoForm").val(), "")
			},
			dataType : "json",
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
				if (result != null && result != "") {
					$("#back_scd_dtl_scd_nm").val(nvlPrmSet(result[0].scd_nm,""));
					$("#back_scd_dtl_scd_exp").val(nvlPrmSet(result[0].scd_exp,""));
					$("#scd_dtl_exe_perd_cd").val(nvlPrmSet(result[0].exe_perd_cd,""));
					
					if ($("#sdt_dtl_exe_dt_div").length) {
						$("#sdt_dtl_exe_dt_div").datepicker({
						}).datepicker('setDate', result[0].exe_dt)
						.on('hide', function(e) {
							e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
						}); //값 셋팅
					}
					$("#sdt_dtl_exe_dt").datepicker('setDate', result[0].exe_dt);
					$("#sdt_dtl_exe_dt_div").datepicker('updateDates');

					$("#sdt_dtl_exe_month").val(nvlPrmSet(result[0].exe_month,""));
					$("#sdt_dtl_exe_day").val(nvlPrmSet(result[0].exe_day,""));
					
					if (result[0].exe_hms != null && result[0].exe_hms != "") {
						$("#sdt_dtl_exe_hour").val(nvlPrmSet(result[0].exe_hms.substring(4, 6),""));
						$("#sdt_dtl_exe_min").val(nvlPrmSet(result[0].exe_hms.substring(2, 4),""));
						$("#sdt_dtl_exe_sec").val(nvlPrmSet(result[0].exe_hms.substring(0, 2),""));
						
					} else {
						$("#sdt_dtl_exe_hour").val("00");
						$("#sdt_dtl_exe_min").val("00");
						$("#sdt_dtl_exe_sec").val("00");
					}
					
					var rowList = [];
					for (var i = 0; i <result.length; i++) {
						rowList.push(result[i].wrk_id);
					}

					fn_sdt_dtl_exe_pred(result[0].exe_dt, result[0].exe_month, result[0].exe_day); 
					fn_sdt_dtl_workAddCallback(JSON.stringify(rowList));
				} else {
					$("#back_scd_dtl_scd_nm").val("");
					$("#back_scd_dtl_scd_exp").val("");
					$("#scd_dtl_exe_perd_cd").val("");
					
					$("#sdt_dtl_exe_month").val("01");
					$("#sdt_dtl_exe_day").val("01");
					$("#sdt_dtl_exe_hour").val("00");
					$("#sdt_dtl_exe_min").val("00");
					$("#sdt_dtl_exe_sec").val("00");
				}
			}
		});
	}
	
	/* ********************************************************
	 * 실행주기 변경시 이벤트 호출
	 ******************************************************** */
	 function fn_sdt_dtl_workAddCallback(rowList){
		$.ajax({
			url : "/selectScheduleWorkList.do",
			data : {
				work_id : rowList,
				tCnt : 1
			},
			dataType : "json",
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
				sdt_dtl_table.clear().draw();

				if (result != null) {
					sdt_dtl_table.rows.add(result).draw();
				}

			}
		});
	}
	
	/* ********************************************************
	 * 실행주기 변경시 이벤트 호출
	 ******************************************************** */
	function fn_sdt_dtl_exe_pred(week, month, day){
		var exe_perd_cd = $("#scd_dtl_exe_perd_cd").val();

		if(exe_perd_cd == "TC001602"){
			$("#sch_dtl_weekday").show();
			
			var list = $("input:input:checkbox[name='dtl_chk']");
			
			for(var i = 0; i < list.length; i++){
				if(week.charAt(i)==1){
					list[i].checked = true;
				}
			}
			
			$("#scd_dtl_hour").hide();
			$("#scd_dtl_min").hide();
			$("#scd_dtl_sec").hide();

		}else {
			if(exe_perd_cd == "TC001603"){
				$("#scd_dtl_day").show();
				$("#sdt_dtl_exe_day").val(day);
			} else if(exe_perd_cd == "TC001604"){
				$("#scd_dtl_month").show();
				$("#scd_dtl_day").show();
	
				$("#sdt_dtl_exe_month").val(month);
				$("#sdt_dtl_exe_day").val(day);
	 		} else if(exe_perd_cd == "TC001605"){
	 			$("#scd_dtl_calendar").show();
	 		}
			
			$("#scd_dtl_hour").show();
			$("#scd_dtl_min").show();
			$("#scd_dtl_sec").show();
			
		}
	}
	 
	/* ********************************************************
	 * 날짜 setting
	 ******************************************************** */
	function fn_sdt_dtl_makeDate() {
		$("#sdt_dtl_exe_month").html("");
		$("#sdt_dtl_exe_day").html("");
		$("#sdt_dtl_exe_hour").html("");
		$("#sdt_dtl_exe_min").html("");
		$("#sdt_dtl_exe_sec").html("");

		var month = "";
		var monthHtml ="";
		var day = "";
		var dayHtml ="";
		var hour = "";
		var hourHtml ="";
		var min = "";
		var minHtml ="";
		var sec = "";
		var secHtml ="";

		/* ********************************************************
		 * 월
		 ******************************************************** */
		for(var i=1; i<=12; i++){
			if(i >= 0 && i<10){
				month = "0" + i;
			}else{
				month = i;
			}
			monthHtml += '<option value="'+month+'">'+month+'</option>';
		}
		$("#sdt_dtl_exe_month").append(monthHtml);
		
		/* ********************************************************
		 * 일
		 ******************************************************** */
		for(var i=1; i<=31; i++){
			if(i >= 0 && i<10){
				day = "0" + i;
			}else{
				day = i;
			}
			dayHtml += '<option value="'+day+'">'+day+'</option>';
		}
		$("#sdt_dtl_exe_day").append(dayHtml);
		
		/* ********************************************************
		 * 시간
		 ******************************************************** */
		for(var i=0; i<=23; i++){
			if(i >= 0 && i<10){
				hour = "0" + i;
			}else{
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">'+hour+'</option>';
		}
		$("#sdt_dtl_exe_hour").append(hourHtml);
		
		/* ********************************************************
		 * 분
		 ******************************************************** */
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		$("#sdt_dtl_exe_min").append(minHtml);

		/* ********************************************************
		 * 초
		 ******************************************************** */
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				sec = "0" + i;
			}else{
				sec = i;
			}
			secHtml += '<option value="'+sec+'">'+sec+'</option>';
		}
		$("#sdt_dtl_exe_sec").append(secHtml);
	}
	
	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_sdt_dtl_init() {
		/* ********************************************************
		 * 리스트
		 ******************************************************** */
		 sdt_dtl_table = $('#backup_sdt_dtl_list').DataTable({
			scrollY : "195px",
			scrollX : true,
			bDestroy: true,
			processing : true,
			searching : false,	
			paging :false,
			bSort: false,
			columns : [
				{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{data : "rownum", className : "dt-center", defaultContent : ""},
				{data : "db_svr_nm",  defaultContent : ""}, //서버명
				{data : "bck_bsn_dscd_nm",  defaultContent : ""}, //구분
				{data : "wrk_nm",  defaultContent : ""
					,"render": function (data, type, full) {
						  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
					}
				}, //work명
				{ data : "wrk_exp",
					render : function(data, type, full, meta) {
						var html = '';
						html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
						return html;
					},
					defaultContent : ""
				},
				{data : "wrk_id",  defaultContent : "", visible: false },
				{data : "bck_wrk_id",  defaultContent : "", visible: false },
				{data : "bck_bsn_dscd",  defaultContent : "", visible: false },
				{data : "db_svr_id",  defaultContent : "", visible: false }
			],'select': {'style': 'multi'}
		});

		 sdt_dtl_table.on( 'order.dt search.dt', function () {
			 sdt_dtl_table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				cell.innerHTML = i+1;
			});
		}).draw();

		sdt_dtl_table.tables().header().to$().find('th:eq(0)').css('width', '50px');
		sdt_dtl_table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		sdt_dtl_table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		sdt_dtl_table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		sdt_dtl_table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		sdt_dtl_table.tables().header().to$().find('th:eq(5)').css('min-width', '300px');
		sdt_dtl_table.tables().header().to$().find('th:eq(6)').css('width', '0px');
		sdt_dtl_table.tables().header().to$().find('th:eq(7)').css('width', '0px');
		sdt_dtl_table.tables().header().to$().find('th:eq(8)').css('width', '0px');
		sdt_dtl_table.tables().header().to$().find('th:eq(9)').css('width', '0px');

		$(window).trigger('resize');
	}
</script>

<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../popup/rmanRegReForm.jsp"%>
<%@include file="../popup/dumpRegReForm.jsp"%>
<%@include file="../cmmn/workScriptInfoPop.jsp"%>

<form name="backupScdInfoForm" id="backupScdInfoForm">
	<input type="hidden" name="scdInfo_db_svr_id"  id="scdInfo_db_svr_id" value="" />
	<input type="hidden" name="scdInfo_scd_id"  id="scdInfo_scd_id" value="" />
</form>

<div class="modal fade" id="pop_layer_backup_scd_dtl" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 200px;">
		<div class="modal-content" style="width:1320px;">		 	 
			<div class="modal-body" >
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="schedule.scheduleDetail"/>
				</h4>
				
				<form class="cmxform" id="modRegForm">
					<div class="card" style="margin-top:10px;border:0px;overflow-y:auto;">
						<div class="card-body" style="border: 1px solid #adb5bd;">
							<div class="form-group row div-form-margin-z">
								<label for="back_scd_dtl_scd_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.schedule_name" />
								</label>
								
								<div class="col-sm-6">
									<input type="text" class="form-control form-control-sm" id="back_scd_dtl_scd_nm" name="back_scd_dtl_scd_nm" readonly />
								</div>
								
								<div class="col-sm-4">
								</div>
								
								<label for="back_scd_dtl_scd_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="common.desc" />
								</label>
	
								<div class="col-sm-6">
									<input type="text" class="form-control form-control-sm" id="back_scd_dtl_scd_exp" name="back_scd_dtl_scd_exp" readonly />
								</div>
								
								<div class="col-sm-4">
								</div>
								
							</div>
						</div>
					</div>
					
					<br/>
					
					<div class="card" style="margin-top:10px;border:0px;overflow-y:auto;">
						<div class="card-body" style="border: 1px solid #adb5bd;">
							<div class="form-group row div-form-margin-z" style="margin-bottom:-8px;">
								<label for="back_scd_dtl_scd_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:10px;">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.schedule_time_settings" />
								</label>
								
								<div class="col-sm-2">
									<select class="form-control" style="width:100%;" onChange="fn_sdt_dtl_exe_pred();" name="scd_dtl_exe_perd_cd" id="scd_dtl_exe_perd_cd" disabled tabindex=1>
										<option value="TC001601"><spring:message code="schedule.everyday" /></option>
										<option value="TC001602"><spring:message code="schedule.everyweek" /></option>
										<option value="TC001603"><spring:message code="schedule.everymonth" /></option>
										<option value="TC001604"><spring:message code="schedule.everyyear" /></option>
										<option value="TC001605"><spring:message code="schedule.one_time_run" /></option>
									</select>		
								</div>
								
								<div class="col-sm-8" id="sch_dtl_weekday" >
									<div class="input-group input-daterange d-flex" style="padding-top:5px;">
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk0" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk0" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.sunday" />
											</label>
										</div>
																
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk1" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.monday" />
											</label>
										</div>
			
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk2" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.thuesday" />
											</label>
										</div>
			
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk3" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.wednesday" />
											</label>
										</div>
			
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk4" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.thursday" />
											</label>
										</div>
			
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk5" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.friday" />
											</label>
										</div>
			
										<div class="form-check input-group-addon mx-0">
											<label for="dtl_chk1" class="form-check-label" style="width:60px;">
												<input type="checkbox" id="dtl_chk6" name="dtl_chk" class="form-check-input" value="0" onclick="return false;" />
												<spring:message code="schedule.saturday" />
											</label>
										</div>
									</div>
								</div>
								
								<div class="col-sm-8 row" id="sch_dtl_tot_month" >
									<div class="col-sm-2_8" id="scd_dtl_calendar" style="display:none;">
										<div id="sdt_dtl_exe_dt_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="sdt_dtl_exe_dt" name="sdt_dtl_exe_dt" readonly />
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>

									<div class="col-sm-1_9" id="scd_dtl_month" style="display:none;">
										<div class="input-group input-daterange d-flex">
											<select class="form-control" name="sdt_dtl_exe_month" id="sdt_dtl_exe_month" style="width:60px;" disabled>
											</select>
											<div class="input-group-addon mx-1" style="margin-top:12px;">
												<spring:message code="schedule.month" />
											</div>
										</div>
									</div>

									<div class="col-sm-1_9" id="scd_dtl_day" style="display:none;">
										<div class="input-group input-daterange d-flex">
											<select class="form-control" name="sdt_dtl_exe_day" id="sdt_dtl_exe_day" style="width:60px;" disabled>
											</select>
											<div class="input-group-addon mx-1" style="margin-top:12px;">
												<spring:message code="common.day" />
											</div>
										</div>
									</div>

									<div class="col-sm-1_9" id="scd_dtl_hour" style="display:none;">
										<div class="input-group input-daterange d-flex">
											<select class="form-control" name="sdt_dtl_exe_hour" id="sdt_dtl_exe_hour" style="width:60px;" disabled>
											</select>
											<div class="input-group-addon mx-1" style="margin-top:12px;">
												<spring:message code="schedule.our" />
											</div>
										</div>
									</div>

									<div class="col-sm-1_9" id="scd_dtl_min" style="display:none;">
										<div class="input-group input-daterange d-flex">
											<select class="form-control" name="sdt_dtl_exe_min" id="sdt_dtl_exe_min" style="width:60px;" disabled>
											</select>
											<div class="input-group-addon mx-1" style="margin-top:12px;">
												<spring:message code="schedule.minute" />
											</div>
										</div>
									</div>

									<div class="col-sm-1_9" id="scd_dtl_sec" style="display:none;">
										<div class="input-group input-daterange d-flex">
											<select class="form-control" name="sdt_dtl_exe_sec" id="sdt_dtl_exe_sec" style="width:60px;" disabled>
											</select>
		
											<div class="input-group-addon mx-1" style="margin-top:12px;">
												<spring:message code="schedule.second" />
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<br/>
	
	
					<div class="card" style="margin-top:10px;border:0px;overflow-y:auto;">
						<div class="card-body" style="border: 1px solid #adb5bd;">
							<div class="form-group row div-form-margin-z">
								<label for="back_scd_dtl_scd_nm" class="col-sm-12 col-form-label pop-label-index" style="padding-top:7px;">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="schedule.schedule_name" />
								</label>
								
								<div class="col-sm-12">
									<table id="backup_sdt_dtl_list" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th scope="col" width="50"></th>
												<th scope="col" width="100"><spring:message code="common.no" /></th>
												<th scope="col" width="200"><spring:message code="data_transfer.server_name" /></th>
												<th scope="col" width="200"><spring:message code="common.division" /></th>
												<th scope="col" width="200"><spring:message code="common.work_name" /></th>
												<th scope="col" width="300"><spring:message code="common.work_description" /></th>
												<th scope="col" width="0"></th>
												<th scope="col" width="0"></th>
												<th scope="col" width="0"></th>
												<th scope="col" width="0"></th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
				<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button" onclick="fn_bckSdtModifyPopup();" value='<spring:message code="common.modify" />' />
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>

<%-- 
<body>
	<%@include file="../cmmn/commonLocale.jsp"%>  
	<%@include file="../cmmn/workRmanInfo.jsp"%>
	<%@include file="../cmmn/workDumpInfo.jsp"%>
	<%@include file="../cmmn/workScriptInfo.jsp"%>
 --%>