(function($) {
	/* 알람 호출*/
	showToastPosition = function(position, msg, titleMsg) {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: titleMsg,
			text: msg,
			position: String(position),
			icon: 'info',
			stack: false,
			loaderBg: '#f96868'
		})
	}
	
	/* 경고 호출*/
	showDangerToast = function(position, msg, titleMsg) {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: titleMsg,
			text: msg,
			showHideTransition: 'slide',
			position: String(position),
			icon: 'error',
			loaderBg: '#f2a654'
		})
	}
	
	/* 경고 호출*/
	showDangerToast_proxy = function(position, msg, titleMsg) {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: titleMsg,
			text: msg,
			showHideTransition: 'slide',
			position: String(position),
			icon: 'warning',
			loaderBg: '#f2a654'
		});
	}

	showToastInCustomPosition_login = function() {
		'use strict';
		resetToastPosition();
		$.toast({
			heading: 'Custom positioning',
			text: 'Specify the custom position object or use one of the predefined ones',
			icon: 'info',
			position: {
				left: 120,
				top: 120
			},
			stack: false,
			loaderBg: '#f96868'
		})
	}

	resetToastPosition = function() {
		$('.jq-toast-wrap').removeClass('bottom-left bottom-right top-left top-right mid-center'); // to remove previous position class
		$(".jq-toast-wrap").css({
			"top": "",
			"left": "",
			"bottom": "",
			"right": ""
		}); //to remove previous position style
	}
	
	//alert 기본 js
	showSwal = function(msg, btnText) {
		'use strict';
		swal({
			text: msg,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}
	
	//title 있는 alert
	showSwalTtl = function(msg, btnText, titleText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}
	
	//alert icon 추가 관련 js
	showSwalIcon = function(msg, btnText, titleText, iconText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			icon: iconText,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		})
	}

	//alert icon 추가 관련 js -- 결과가 있는 alert
	showSwalIconRst = function(msg, btnText, titleText, iconText, rstGbn) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			icon: iconText,
			button: {
				text: btnText,
				value: true,
				visible: true,
				className: "btn btn-primary"
			}
		}).then(function(){
			if (rstGbn == "his") {
				history.go(-1);
			} else if (rstGbn == "top") {
				top.location.href = "/";
			} else if (rstGbn == "reload") {
				location.reload();
			}else if (rstGbn == "securityKeySet") {
				location.href = "/securityKeySet.do";
			} else if (rstGbn == "backup") {
				fn_backupHistory_move();
			} else if (rstGbn == "rman_restore") {
				fn_restoreLogCall();
			}else if(rstGbn =="insertScd"){
				location.href = "/selectScheduleListView.do";
			} else if (rstGbn == "dump_restore") {
				fn_dumpRestoreLogCall();
			} else if (rstGbn == "logout") {
				fn_logout_result();
			}else if (rstGbn == "securityPolicy") {
				location.href = "/securityPolicy.do";
			}else if (rstGbn == "securityKeySet") {
				location.href = "/securityKeySet.do";
			}else if (rstGbn == "backupPolicyApply"){
				fn_goMonitoring();
			}else if (rstGbn == "proxyMoReload"){
				fn_proxySvrReloadSearch();
			}
        });
	}

	//confirm 관련 js
	showSwalCfm = function(msg, cBtnText, conBtnText, titleText, iconText) {
		'use strict';
		swal({
			title: titleText,
			text: msg,
			icon: iconText,
			showCancelButton: true,
			confirmButtonColor: '#3f51b5',
			cancelButtonColor: '#ff4081',
			confirmButtonText: 'Great ',
			buttons: {
				cancel: {
					text: cBtnText,
					value: false,
					visible: true,
					className: "btn btn-danger",
					closeModal: true,
				},
				confirm: {
					text: conBtnText,
					value: true,
					visible: true,
					className: "btn btn-primary",
					closeModal: true
				}
			}
		})
	}
	
	// initializing inputmask
	$(":input").inputmask();

})(jQuery);

$(window).ready(function(){
	var htmlLoad = '<div id="loading"><div class="flip-square-loader mx-auto" style="border: 0px !important;z-index:99999;"></div></div>';
	
	$("#contentsDiv").append(htmlLoad);
	$('#loading').hide();
	
	$( document ).ajaxStart(function() {	
	      $('#loading').css('position', 'absolute');
	      $('#loading').css('left', '50%');
	      $('#loading').css('top', '50%');
	      $('#loading').css('transform', 'translate(-50%,-50%)');	  
	      $('#loading').show();	
	});
	
	//AJAX 통신 종료
	$( document ).ajaxStop(function() {
		$('#loading').hide();
	});
	
	$('.modal').on('hidden.bs.modal', function (e) {
		if ($(this).find('form').length > 0) {
			for(var i=0; i<$(this).find('form').length; i++){
				if ($(this).find('form')[i] != null && $(this).find('form')[i] != undefined) {
				    $(this).find('form')[i].reset();
				    $(this).find('form').validate().resetForm();
				}
			}
		}
		

	});	
});

String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

/* ********************************************************
 * 로그아웃 
 ******************************************************** */
function fn_logout(){
	sessionStorage.removeItem('cssId');

	var frm = document.treeView;
	frm.action = "/logout.do";
	frm.submit();
}

/* ********************************************************
 * cookie 저장
 ******************************************************** */
function fn_cookie(url) {
	var cssID = sessionStorage.getItem('cssId');

/* 		$("#"+cssID).css("background-color","");
	$("#"+cssID+"c").css("color","");
	$("#"+cssID).css("border","");	

	if(url != null){
		$("#"+url).css("background-color","#f58220");
		$("#"+url+"c").css("color","white");
		$("#"+url).css("border","2px solid #f58220");	
	} */

	sessionStorage.setItem('cssId',url);
	
	parent.fn_topMenuChk();
}

/* ********************************************************
 * null 값 변경
 ******************************************************** */
function nvlPrmSet(val, subVal) {
	var strValue = val;
	if( strValue == null || strValue == ''  || strValue == undefined  || strValue == 'undefined') {
		strValue = subVal;
	}
	
	return strValue;
}

/* ********************************************************
 * profile chk
 ******************************************************** */
function fn_profileChk(id) {
	if ($("#" + id).hasClass("menu-arrow_user")) {
		$("#" + id).attr('class', 'menu-arrow_user_af');
	} else {
		$("#" + id).attr('class', 'menu-arrow_user');
	}
}

/* ********************************************************
 * 글자수 체크
 ******************************************************** */
function fn_checkWord(obj, maxlength) { 
	var str = obj.value; 
	var str_length = str.length;     
	var max_length = maxlength;  
	if (str_length == max_length) { 
		showSwalIcon(max_length+message_msg211, closeBtn, '', 'error');
	}    
	obj.focus(); 
}

/* ********************************************************
 * 숫자 체크
 ******************************************************** */
function chk_Number(object){
	$(object).keyup(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,""));
	});   
}



/* ********************************************************
 * ERROR 로그 정보 출력
 ******************************************************** */
function fn_failLog(exe_sn){
	$.ajax({
		url : "/selectWrkErrorMsg.do",
		data : {
			exe_sn : exe_sn
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
			if (result[0] != null) {
				$("#wrkLogInfo").html(result[0].rslt_msg);
			}

			$("#pop_layer_wrkLog").modal("show");						
		}
	});	
}

/* ********************************************************
 * ScriptWORK정보
 ******************************************************** */
function fn_scriptLayer(wrk_id){
	$.ajax({
		url : "/selectSciptExeInfo.do",
		data : {
			wrk_id : wrk_id
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
			if(result.length==0){
				showSwalIcon(wrk_chk_del_msg, closeBtn, '', 'error');
			}else{
				$("#info_exe_cmd").html(nvlPrmSet(result[0].exe_cmd, ""));

				$("#pop_layer_script").modal("show");
			}
		}
	});	
}

/* ********************************************************
 * WORK정보
 ******************************************************** */
function fn_workLayer(wrk_id){
	var rman_bck_opt_cd_nm = "", rman_cps_yn = "", rman_log_file_bck_yn = "", rman_log_file_mtn_ecn = "", rman_log_file_stg_dcnt = "";
	var rman_acv_file_mtncnt = "", rman_bck_mtn_ecnt = "", rman_acv_file_stgdt = "", rman_file_stg_dcnt = "";
	var dump_file_fmt_cd_nm = "", dump_cprt = "", dump_file_stg_dcnt ="", dump_bck_mtn_ecnt = "";

	$.ajax({
		url : "/selectWrkInfo.do",
		data : {
			wrk_id : wrk_id
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
			if(result.length==0){
				showSwalIcon(wrk_chk_del_msg, closeBtn, '', 'error');
			}else{
				if(result[0].bsn_dscd == "TC001901"){
					// RMAN
					if(result[0].bck_bsn_dscd == "TC000201"){
						$("#r_bck_bsn_dscd_nm").html(nvlPrmSet(result[0].bck_bsn_dscd_nm, "-"));

						if (result[0].bck_opt_cd == 'TC000301') {
							rman_bck_opt_cd_nm += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
							rman_bck_opt_cd_nm += "	<i class='fa fa-paste mr-2 text-success'></i>";
							rman_bck_opt_cd_nm += backup_management_full_backup;
							rman_bck_opt_cd_nm += '(' + result[0].bck_opt_cd_nm + ')';
							rman_bck_opt_cd_nm += "</div>";									
						} else if(result[0].bck_opt_cd == 'TC000302'){
							rman_bck_opt_cd_nm += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
							rman_bck_opt_cd_nm += "	<i class='fa fa-comments-o text-warning'></i>";
							rman_bck_opt_cd_nm += backup_management_incremental_backup;
							rman_bck_opt_cd_nm += '(' + result[0].bck_opt_cd_nm + ')';
							rman_bck_opt_cd_nm += "</button>";
						} else {
							rman_bck_opt_cd_nm += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
							rman_bck_opt_cd_nm += "	<i class='fa fa-exchange mr-2 text-info' ></i>";
							rman_bck_opt_cd_nm += backup_management_change_log_backup;
							rman_bck_opt_cd_nm += '(' + result[0].bck_opt_cd_nm + ')';
							rman_bck_opt_cd_nm += "</div>";
						}

						$("#r_bck_opt_cd_nm").html(rman_bck_opt_cd_nm);
						
						$("#r_wrk_nm").html(nvlPrmSet(result[0].wrk_nm, "-"));
						$("#r_wrk_exp").html(nvlPrmSet(result[0].wrk_exp, "-"));

						if(nvlPrmSet(result[0].cps_yn, "") != "Y"){
	    					rman_cps_yn += "<div class='badge badge-pill badge-danger' >";
	    					rman_cps_yn += "	<i class='fa fa-file-zip-o mr-2'></i>";
	    					rman_cps_yn += agent_monitoring_no;
	    					rman_cps_yn += "</div>";
						}else{
							rman_cps_yn += "<div class='badge badge-pill badge-info text-white'>";
							rman_cps_yn += "	<i class='fa fa-file-zip-o mr-2'></i>";
							rman_cps_yn += agent_monitoring_yes;
							rman_cps_yn += "</div>";
						}
						$("#r_cps_yn").html(rman_cps_yn);

						$("#r_log_file_pth").html(nvlPrmSet(result[0].log_file_pth, "-"));
						$("#r_data_pth").html(nvlPrmSet(result[0].data_pth, "-"));
						$("#r_bck_pth").html(nvlPrmSet(result[0].bck_pth, "-"));
						
						//백업파일옵션
						$("#r_file_stg_dcnt").html(nvlPrmSet(result[0].file_stg_dcnt, "0"));

						$("#r_bck_mtn_ecnt").html(nvlPrmSet(result[0].bck_mtn_ecnt, "0"));

						$("#r_acv_file_stgdt").html(nvlPrmSet(result[0].acv_file_stgdt, "0"));

						$("#r_acv_file_mtncnt").html(nvlPrmSet(result[0].acv_file_mtncnt, "0"));

						//로그파일 옵션
						if(nvlPrmSet(result[0].log_file_bck_yn, "") != "Y"){
							rman_log_file_bck_yn += "<div class='badge badge-pill badge-danger' >";
							rman_log_file_bck_yn += "	<i class='fa fa-file-zip-o mr-2'></i>";
							rman_log_file_bck_yn += agent_monitoring_no;
							rman_log_file_bck_yn += "</div>";
						}else{
							rman_log_file_bck_yn += "<div class='badge badge-pill badge-info text-white'>";
							rman_log_file_bck_yn += "	<i class='fa fa-file-zip-o mr-2'></i>";
							rman_log_file_bck_yn += agent_monitoring_yes;
							rman_log_file_bck_yn += "</div>";
						}
						$("#r_log_file_bck_yn").html(rman_log_file_bck_yn);

						$("#r_log_file_stg_dcnt").html(nvlPrmSet(result[0].log_file_stg_dcnt, "0"));
						$("#r_log_file_mtn_ecnt").html(nvlPrmSet(result[0].log_file_mtn_ecnt, "0"));

						$("#pop_layer_rman").modal("show");
					// DUMP
					}else{
						$("#d_bck_bsn_dscd_nm").html(nvlPrmSet(result[0].bck_bsn_dscd_nm, "-"));
						$("#d_wrk_nm").html(nvlPrmSet(result[0].wrk_nm, "-"));
						$("#d_wrk_exp").html(nvlPrmSet(result[0].wrk_exp, "-"));
						$("#d_db_nm").html(nvlPrmSet(result[0].db_nm, "-"));
						$("#d_save_pth").html(nvlPrmSet(result[0].save_pth, "-"));
						
						if (result[0].file_fmt_cd_nm != null) {
							dump_file_fmt_cd_nm += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
							dump_file_fmt_cd_nm += "	<i class='fa fa-file-o mr-2' ></i>";
							dump_file_fmt_cd_nm += result[0].file_fmt_cd_nm;
							dump_file_fmt_cd_nm += "</div>";
						}
						$("#d_file_fmt_cd_nm").html(dump_file_fmt_cd_nm);
						
						var dump_cprt_val = nvlPrmSet(result[0].cprt, "0");
						dump_cprt += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
						dump_cprt += "	<i class='ti-angle-double-right mr-2' ></i>";
						
						if (dump_cprt_val == "" || dump_cprt_val == "0") {
							dump_cprt += backup_management_uncompressed;
						} else {
							dump_cprt += dump_cprt_val + " Level";
						}

						dump_cprt += "</div>";
						$("#d_cprt").html(dump_cprt);

						$("#d_encd_mth_nm").html(nvlPrmSet(result[0].encd_mth_nm, "-"));
						$("#d_usr_role_nm").html(nvlPrmSet(result[0].usr_role_nm, "-"));

						$("#d_file_stg_dcnt").html(result[0].file_stg_dcnt);

						$("#d_bck_mtn_ecnt").html(nvlPrmSet(result[0].bck_mtn_ecnt, "0"));
						
						fn_workOptionLayer(result[0].bck_wrk_id, result[0].db_svr_id, result[0].db_nm);
	
						$("#pop_layer_dump").modal("show");
					}
				}else if(result[0].bsn_dscd == "TC001902"){
					fn_scriptLayerWork(result[0].wrk_id);
				}
			}
		}
	});	
}

/* ********************************************************
 * ScriptWORK정보
 ******************************************************** */
function fn_scriptLayerWork(wrk_id){
	$.ajax({
		url : "/selectSciptExeInfo.do",
		data : {
			wrk_id : wrk_id
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
			if(result.length==0){
				showSwalIcon(wrk_chk_del_msg, closeBtn, '', 'error');
			}else{
				$("#info_exe_cmd", "#rsltMsgWorkForm").html(nvlPrmSet(result[0].exe_cmd, ""));

				$("#pop_layer_script_work").modal("show");
			}
		}
	});	
}

/* ********************************************************
 * 스케줄정보
 ******************************************************** */
function fn_scdLayer(scd_id){
	$.ajax({
		url : "/selectScdInfo.do",
		data : {
			scd_id : scd_id
		},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
			}
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		success : function(result) {
			if(result.length==0){
				showSwalIcon(message_msg209, closeBtn, '', 'error');
			}else{
				var hms = "";
				
				hms += result[0].exe_hms.substring(4,6)+schedule_our;	
				hms += result[0].exe_hms.substring(2,4)+schedule_minute;	
				hms += result[0].exe_hms.substring(0,2)+schedule_second;		
				
				var day = "";
				if(result[0].exe_perd_cd == "TC001602"){
					day += "(";
					if(result[0].exe_dt.substring(0,1)=="1"){
						day += schedule_sunday+", ";
					}
					if(result[0].exe_dt.substring(1,2)=="1"){
						day += schedule_monday+", ";
					}
					if(result[0].exe_dt.substring(2,3)=="1"){
						day += schedule_thuesday+", ";
					}
					if(result[0].exe_dt.substring(3,4)=="1"){
						day += schedule_wednesday+", ";
					}
					if(result[0].exe_dt.substring(4,5)=="1"){
						day += schedule_thursday+", ";
					}
					if(result[0].exe_dt.substring(5,6)=="1"){
						day += schedule_friday+", ";
					}
					if(result[0].exe_dt.substring(6,7)=="1"){
						day += schedule_saturday;
					}
					day += ")";
				}		

				$("#d_scd_nm_info").html(result[0].scd_nm);
				$("#d_scd_exp_info").html(result[0].scd_exp);

				var scd_cndt_html = "";
				
				if (result[0].scd_cndt == "TC001801") {
					scd_cndt_html += "<div class='badge badge-pill badge-success'>";
					scd_cndt_html += "	<i class='fa fa-minus-circle mr-2'></i>";
					scd_cndt_html += common_waiting;
					scd_cndt_html += "</div>";
				} else if (result[0].scd_cndt == "TC001801") {
					scd_cndt_html += "<div class='badge badge-pill badge-warning'>";
					scd_cndt_html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
					scd_cndt_html += dashboard_running;
					scd_cndt_html += "</div>";
				} else {
					scd_cndt_html += "<div class='badge badge-pill badge-danger'>";
					scd_cndt_html += "	<i class='ti-close mr-2'></i>";
					scd_cndt_html += schedule_stop;
					scd_cndt_html += "</div>";
				}
				$("#d_scd_cndt_info").html(scd_cndt_html);

				$("#d_exe_perd_cd_info").html(result[0].exe_perd_cd_nm + " " + day);
				$("#d_scd_exe_hms").html(hms);

				$("#pop_layer_scheduleInfo").modal("show");
			}
			
		}
	});
}

/* ********************************************************
 * br 변환
 ******************************************************** */
function fn_strBrReplcae(msg) {
	if (nvlPrmSet(msg, "") != "") {
		msg = msg.replaceAll("<br/>","\n");
	}

	return msg;
}

/* ********************************************************
 * date형 변환
 ******************************************************** */
function fn_dateParse(str) {
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    return new Date(y,m-1,d);
}

/* ********************************************************
 * 비밀번호 체크
 ******************************************************** */
function pwdValidate(pw) {
	if (pw == "") {
		return;
	}
	
	var reg_pwd = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,20}/;

	//비밀번호 체크
	if (!reg_pwd.test(pw)) { 
		return message_msg109;
	}
	
	return "";
}

/* ********************************************************
 * 비밀번호 안정성 확인
 ******************************************************** */
function pwdSafety(pw) {
	if (pw == "") {
		return;
	}
	
	var o = { 
			length: [6, 20],
			lower: 1,
			upper: 1,
			alpha: 1, /* lower + upper */
			numeric: 1,
			special: 1, 
			custom: [ /* regexes and/or functions */ ], 
			badWords: [], 
			badSequenceLength: 5, 
			noQwertySequences: true, 
			spaceChk: true, 
			noSequential: false 
	};

	// bad sequence check 
	if (o.badSequenceLength && pw.length >= o.length[0]) {
		var lower = "abcdefghijklmnopqrstuvwxyz", 
			upper = lower.toUpperCase(), 
			numbers = "0123456789", 
			qwerty = "qwertyuiopasdfghjklzxcvbnm", 
			start = o.badSequenceLength - 1, 
			seq = "_" + pw.slice(0, start);
		
		for (i = start; i < pw.length; i++) {
			seq = seq.slice(1) + pw.charAt(i);
			
			if ( lower.indexOf(seq) > -1 || upper.indexOf(seq) > -1 || numbers.indexOf(seq) > -1 || (o.noQwertySequences && qwerty.indexOf(seq) > -1) ) {
				return "<p style='line-height:200%;'>" + user_management_msg5 + " <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'>" + user_management_msg6 + "</span> " + 
						"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
						"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
						"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + "<br/>" + 
						"<span style='color:#999; font-weight:bold;'>" + user_management_msg7 + "</span></p>";
			}
		}
	}
	
	//password 정규식 체크 
	var re = {
			lower: /[a-z]/g, 
			upper: /[A-Z]/g, 
			alpha: /[A-Z]/gi, 
			numeric: /[0-9]/g, 
			special: /[\W_]/g 
	},rule, i;

	var lower = (pw.match(re['lower']) || []).length > 0 ? 1 : 0; 
	var upper = (pw.match(re['upper']) || []).length > 0 ? 1 : 0; 
	var numeric = (pw.match(re['numeric']) || []).length > 0 ? 1 : 0; 
	var special = (pw.match(re['special']) || []).length > 0 ? 1 : 0;

	//숫자, 알파벳(대문자, 소문자), 특수문자 2가지 조합
	if(lower + upper + numeric + special <= 2) {
		return "<p style='line-height:200%;'>" + user_management_msg5 + " <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'>" + user_management_msg6 + "</span> " + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
				"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<br/>" + 
				"<span style='color:#999; font-weight:bold;'>" + user_management_msg7 + "</span></p>"; 
	}
	//숫자, 알파벳(대문자, 소문자), 특수문자 4가지 조합
	else if(lower + upper + numeric + special <= 3) { 
		return "<p style='line-height:200%;'>" + user_management_msg5 + " <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'>" + user_management_msg8 + "</span> " + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<span style='color:#E5E5E5; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<br/>" + 
				"<span style='color:#999; font-weight:bold;'>" + user_management_msg9 + "</span></p>"; 
	}
	//숫자, 알파벳(대문자, 소문자), 특수문자 4가지 조합
	else { 
		return "<p style='line-height:200%;'>" + user_management_msg5 + " <span style='color:#E5E5E5'>|</span> <span style='color:#E3691E; font-weight:bold;'>" + user_management_msg10 + "</span> " + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;'>―</span>" + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<span style='color:#E3691E; font-weight:bold; font-size:20px; position: relative; top: 1.5px;''>―</span>" + 
				"<br/>" + "<span style='color:#999; font-weight:bold;'>" + user_management_msg11 + "</span></p>";
	}

	return "";
}

/* ********************************************************
 * help_Open Source 클릭
 ******************************************************** */
function fn_openSource() {
	$.ajax({
		url : "/encryptLicenseInfo.do",
		type : "post",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		}
	})
	.done(function(result){
		var encryptLicense;
		$("#encryptLicenseInfo").empty();
		if(result.resultCode == 0){			
			encryptLicense = result.license;
			var html  = '<div class="top-deadLine"></div>';
				html += '<div class="form-group">';
				html += '	<p class="col-form-label" style="background: url(../../images/popup/ico_p_2.png) 8px 48% no-repeat; font-weight: bold;padding-left:25px;">Encrypt</p>';
				html += '	<p style="padding-left:25px;">' + encryptLicense + '</p>';
				html += '</div>';
			$("#encryptLicenseInfo").append(html);
			$("#pop_layer_openSource").modal("show");
			
		}else{
			$("#pop_layer_openSource").modal("show");
			
		}
	})
	.fail(function(xhr, status, error){
		if(xhr.status == 401) {
			showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else if(xhr.status == 403) {
			showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
		} else {
			showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
		}
	})

}

/* ********************************************************
 * About eXperDB
 ******************************************************** */
function fn_aboutExperdb(version){
	$("#version").html(version);
}

/* ********************************************************
 * db2pg ddl 결과 정보
 ******************************************************** */
function fn_db2pgConfigLayer(config_nm){
	$.ajax({
		url : "/selectDb2pgConfigInfo.do",
		data : {
			config_nm : config_nm
		},
//		dataType : "json",
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
			if(result==null || result==""){
				showSwalIcon(migration_msg21, closeBtn, '', 'error');
			}else{
				$("#config").html(result);

				$("#pop_layer_db2pgConfig").modal("show");
			}
	
		}
	});
}

/* ********************************************************
 * db2pg ddl 결과 정보
 ******************************************************** */
function fn_db2pgDDLResultLayer(ddl_save_pth,dtb_nm){
	$.ajax({
		url : "/db2pg/db2pgDdlCall.do",
		data : {
			ddl_save_pth : ddl_save_pth,
			dtb_nm : dtb_nm
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
			$("#table").html(result.data[0].RESULT_MSG);
			$("#constraint").html(result.data[1].RESULT_MSG);
			$("#index").html(result.data[2].RESULT_MSG);
			$("#sequence").html(result.data[3].RESULT_MSG);
		}
	});
	
	$("#pop_layer_db2pgDDLResult").modal("show");
}

/* ********************************************************
 * WORK OPTION정보
 ******************************************************** */
function fn_workOptionLayer(bck_wrk_id, db_svr_id, db_nm){
	var db_svr_id = db_svr_id;
	$.ajax({
		url : "/workOptionLayer.do",
		data : {
			bck_wrk_id : bck_wrk_id
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
			var sections = "";
			var objectType = "";
			var save_yn = "";
			var query = "";
			var etc = "";

			var queryCnt = 0;
			var etcCnt = 0;

			for(var i=0; i<result.length; i++){
				if(result[i].grp_cd == "TC0006"){
					sections += "<font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
				}else if (result[i].grp_cd == "TC0007"){
					objectType += "<font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
				}else if (result[i].grp_cd == "TC0008"){
					save_yn += "<font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
				}else if (result[i].grp_cd == "TC0009"){
					if (queryCnt % 2==0 && queryCnt != 0) {
						query += "<br/><font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
					} else {
						query += "<font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
					}

					queryCnt = queryCnt + 1;
				}else{
					if (etcCnt % 2==0 && etc != 0) {
						etc += "<br/><font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
					} else {
						etc += "<font color='#68afff'>" + result[i].opt_cd_nm + "</font>  /  ";
					}

					etcCnt = etcCnt + 1;
				}
			}
			
			if (nvlPrmSet(sections, "") != "") {
				sections = sections.substr(0, sections.length -3);
			}
			
			if (nvlPrmSet(objectType, "") != "") {
				objectType = objectType.substr(0, objectType.length -3);
			}
			
			if (nvlPrmSet(save_yn, "") != "") {
				save_yn = save_yn.substr(0, save_yn.length -3);
			}
			
			if (nvlPrmSet(query, "") != "") {
				query = query.substr(0, query.length -3);
			}
			
			if (nvlPrmSet(etc, "") != "") {
				etc = etc.substr(0, etc.length -3);
			}
			
			$("#d_sections").html(nvlPrmSet(sections, "-"));
			$("#d_objectType").html(nvlPrmSet(objectType, "-"));
			$("#d_save_yn").html(nvlPrmSet(save_yn, "-"));
			$("#d_query").html(nvlPrmSet(query, "-"));
			$("#d_etc").html(nvlPrmSet(etc, "-"));			
	
			fn_workObjectListTreeLayer(bck_wrk_id, db_svr_id, db_nm);
		}		
	});
}

/* ********************************************************
 * WORK Object 리스트
 ******************************************************** */
function fn_workObjectListTreeLayer(bck_wrk_id, db_svr_id, db_nm){
	$.ajax({
		async : false,
		url : "/workObjectListTreeLayer.do",
	  	data : {
	  		bck_wrk_id : bck_wrk_id
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
			fn_workObjectTreeLayer(db_svr_id, db_nm, result);
		}
	});	
}

/* ********************************************************
 * Object 리스트
 ******************************************************** */
function fn_workObjectTreeLayer(db_svr_id, db_nm, workObj){
	$.ajax({
		async : false,
		url : "/getObjectList.do",
		data : {
			db_svr_id : db_svr_id,
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
			fn_make_object_list(data, workObj);
		}
	});
}

/* ********************************************************
 * Make Object Tree
 ******************************************************** */
function fn_make_object_list(data, workObj){
	var html = " <form class='form-inline'><ul class='d-flex flex-column-reverse todo-list todo-list-custom tree_ul'>";
	var schema = "";
	var schemaCnt = 0;

	$(data.data).each(function (index, item) {
		var inSchema = item.schema;
		
		if(schemaCnt > 0 && schema != inSchema){
			html += "</ul></li>\n";
		}
		if(schema != inSchema){
			var checkStr = "disabled";
			$(workObj).each(function(i,v){
				if(v.scm_nm == item.schema && v.obj_nm == "") checkStr = " checked disabled";
			});
			html += "<li>";
			html += "	<div class='form-check form-check-info'>";
			html += "		<input type='checkbox' class='form-check-input form-check-input-new form-check-info' style='padding-right:-100px;' id='schema"+schemaCnt+"' name='tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"'"+checkStr+"/>";
			html += "		<label class='form-check-label' for='schema"+schemaCnt+"' style='margin-left:7px;padding-top:3px;'>"+item.schema+"</label>";
			html += "	</div>";
			html += "<ul class='tree_ul'>\n";
		}
		
		var checkStr = "disabled";
		$(workObj).each(function(i,v){
			if(v.scm_nm == item.schema && v.obj_nm == item.name) checkStr = " checked disabled";
		});
		html += "<li>";
		html += "	<div class='form-check form-check-info'>";
		html += "		<input type='checkbox' class='form-check-input form-check-input-new form-check-info' style='padding-right:-100px;' id='table"+index+"' name='tree' value='"+item.name+"' otype='table' schema='"+item.schema+"'"+checkStr+"/>";
		html += "		<label class='form-check-label' for='table"+index+"' style='margin-left:7px;padding-top:3px;' >"+item.name+"</label>";
		html += "	</div>";

		html += "</div>";
		html += "</li>\n";

		if(schema != inSchema){
			schema = inSchema;
			schemaCnt++;
		}
	});
	if(schemaCnt > 0) html += "</ul></li>";
	html += "</ul></form>";

	$(".tNav_new").html("");
	$(".tNav_new").html(html);
	//$.getScript( "/js/common.js", function() {});
	
	$('#loading').hide();
}

/* ********************************************************
 * 패스워드 확인
 ******************************************************** */
function fn_passwordConfilm(flag){
	$("#exec_password").val("");
	$("#exec_flag").val(flag);
	
	$("#pop_layer_pwConfilm").modal("show");
}

/* ********************************************************
 * 사이즈 리사이징
 ******************************************************** */
function ResizingLayer() {
	if($(".PopupLayer").css("visibility") == "visible") {
		//화면의 높이와 너비를 구한다. 
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();

		//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다. 
		$("#lay_mask").css({'width':maskWidth,'height':maskHeight});
		//$('#header').css({'width':maskWidth}); // 20131119 최창원 수정 헤더의 넓이 값을 우선 빼 봤음.

		$(".PopupLayer").each(function () {
			var left = ( $(window).scrollLeft() + ($(window).width() - $(this).width()) / 2 );
			var top = ( $(window).scrollTop() + ($(window).height() - $(this).height()) / 2 );

			if(top<0) top = 0;
			if(left<0) left = 0;

			$(this).css({"left":left, "top":top});
		});
	}
	// 퀵메뉴 팝업
	if($("#pop_setting1").css("visibility") == "visible") {
		//화면의 높이와 너비를 구한다. 
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();

		//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다. 
		$("#lay_mask").css({'width':maskWidth,'height':maskHeight});
		//$('#header').css({'width':maskWidth}); // 20131119 최창원 수정 헤더의 넓이 값을 우선 빼 봤음.

		$("#pop_setting1").each(function () {
			var left = ( $(window).scrollLeft() + ($(window).width() - $(this).width()) / 2 );
			var top = ( $(window).scrollTop() + 20 + "px" );

			if(top<0) top = 0;
			if(left<0) left = 0;

			$(this).css({"left":left, "top":top});
		});
	}
}
window.onresize = ResizingLayer;

/* ********************************************************
 *  조치입력 화면 생성
 ******************************************************** */
function fn_fix_rslt_reg(exe_sn, viewGbn){
	$('#rst_exe_sn_r', '#rsltMsgInfoForm').val(exe_sn);
	$('#rst_fix_rslt_msg_r', '#rsltMsgInfoForm').val('');
	$('#rst_rdo_r_1', '#rsltMsgInfoForm').attr('checked', true);
	$('#rst_fix_rslt_view_gbn', '#rsltMsgInfoForm').val(viewGbn);

	$('#pop_layer_fix_rslt_reg').modal("show");
}

/* ********************************************************
 *  조치입력 저장
 ******************************************************** */
function fn_fix_rslt_msg_reg(){
	var fix_rsltcd = $(":input:radio[name=rst_rdo_r]:checked").val();

	$.ajax({
		url : "/updateFixRslt.do",
		data : {
			exe_sn : $('#rst_exe_sn_r', '#rsltMsgInfoForm').val(),
			fix_rsltcd : fix_rsltcd,
			fix_rslt_msg : $('#rst_fix_rslt_msg_r', '#rsltMsgInfoForm').val()
		},
//		dataType : "json",
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
			var viewGbn = $('#rst_fix_rslt_view_gbn', '#rsltMsgInfoForm').val();
			
			$('#pop_layer_fix_rslt_reg').modal("hide");

			if (viewGbn == "rmanList") {
				fn_get_rman_list();
			} else if (viewGbn == "dumpList") {
				fn_get_dump_list();
			} else if(viewGbn == "scdList"){
				$('#pop_layer_scd_history').modal("hide");
			}else if(viewGbn=="scdListFail"){
				fn_scheduleFail_list();
			}else{
				fn_search();
			}
		}
	});
}

/* ********************************************************
 * 작업 로그정보 출력
 ******************************************************** */
function fn_fixLog(exe_sn, viewGbn){
	$.ajax({
		url : "/selectFixRsltMsg.do",
		data : {
			exe_sn : exe_sn
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
			$("#exe_sn", "#rsltMsgForm").val(result[0].exe_sn);
			
			var fix_rsltcd_val = nvlPrmSet(result[0].fix_rsltcd, "TC002001");

			$('input:radio[name=rdo]:input[value=' + fix_rsltcd_val + ']').attr("checked", true);

			$("#fix_rslt_msg", "#rsltMsgForm").html(nvlPrmSet(result[0].fix_rslt_msg, ""));

			$("#fix_update_view_gbn", '#rsltMsgForm').val(viewGbn);

			$("#lst_mdfr_id", '#rsltMsgForm').val(result[0].lst_mdfr_id);
			$("#lst_mdf_dtm", '#rsltMsgForm').val(result[0].lst_mdf_dtm);
				
			$("#pop_layer_fix_rslt_msg").modal("show");					
		}
	});	
}

/* ********************************************************
 *  조치입력 수정
 ******************************************************** */
function fn_fix_rslt_msg_modify(){
	var fix_rsltcd = $(":input:radio[name=rdo]:checked").val();

	if (nvlPrmSet($('#exe_sn', '#rsltMsgForm').val(), "") == "") {
		showSwalIcon(message_msg151, closeBtn, '', 'error');
		return;
	}

	$.ajax({
		url : "/updateFixRslt.do",
		data : {
			exe_sn : $('#exe_sn', '#rsltMsgForm').val(),
			fix_rsltcd : fix_rsltcd,
			fix_rslt_msg : nvlPrmSet($('#fix_rslt_msg', '#rsltMsgForm').val(), "")
		},
//		dataType : "json",
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
			var viewGbn = $('#fix_update_view_gbn', '#rsltMsgForm').val();
			
			$('#pop_layer_fix_rslt_msg').modal("hide");

			if (viewGbn == "rmanList") {
				fn_get_rman_list();
			} else if (viewGbn == "dumpList") {
				fn_get_dump_list();
			} else if(viewGbn == "scdList"){
				$('#pop_layer_scd_history').modal("hide");
			}else if(viewGbn=="scdListFail"){
				fn_scheduleFail_list();
			}else{
				fn_search();
			}
		}
	}); 
}

/* ********************************************************
 *  rman 백업 상세화면 출력
 ******************************************************** */
function fn_rmanShow(bck, db_svr_id){
	$.ajax({
		url : "/rmanShowView.do",
		data : {
			db_svr_id : db_svr_id,
			bck : bck
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
			$("#rmanInfo_bck", "#rmanshowForm").val(bck);
			$("#rmanInfo_db_svr_id", "#rmanshowForm").val(db_svr_id);

			$("#pop_layer_rman_show").modal("show");
			$('#pop_layer_rman_show_view').css("width", "1250px");
			
			fn_rmanshow_pop_search();
		}
	});
}

/* ********************************************************
 *  rman 백업 상세화면 출력
 ******************************************************** */
function fn_dumpShow(bck, db_svr_id){

	$.ajax({
		url : "/dumpShowView.do",
		data : {
			db_svr_id : db_svr_id,
			bck : bck
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
			$("#dumpInfo_bck", "#dumpshowForm").val(bck);
			$("#dumpInfo_db_svr_id", "#dumpshowForm").val(db_svr_id);

			$("#pop_layer_dump_show").modal("show");

			fn_dumpshow_pop_search();
		}
	});
}

/* ********************************************************
 * script rereg Btn click
 ******************************************************** */
 function fn_dblclick_pop_scheduleInfo(scd_id_up) {
	$('#scd_id', '#findList').val(scd_id_up);

 	$.ajax({
		url : "/scriptScheduleWrkListVeiw.do",
		data : {},
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
			//테이블 세팅
			fn_workpop_init();
			
			fn_workpop_search();
			
			$('#pop_layer_info_schedule').modal("show");
		}
	});
}

/* ********************************************************
 * 스크립트 리스트 100%
 ******************************************************** */
function fn_schedule_leftListSize() {
	$("#left_list").attr('class', 'col-sm-12 stretch-card div-form-margin-table');
	$("#left_list").attr('style', '');
	$('#right_list').hide();
	$('#center_div').hide();
}

/* ********************************************************
 * 스케줄리스트 조회
 ******************************************************** */
function fn_schdule_pop_List (wrk_id) {
	var db_svr_id_val = $("#db_svr_id", "#findList").val();

 	$.ajax({
		url : "/selectScriptScheduleList.do",
		data : {
			db_svr_id : db_svr_id_val,
			wrk_id : wrk_id
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
			scheduleTable.rows({selected: true}).deselect();
			scheduleTable.clear().draw();
			scheduleTable.rows.add(result).draw();
			
			if ($("#left_list").hasClass("col-sm-12")) {
				$("#left_list").attr('class', 'col-sm-5 stretch-card div-form-margin-table');
			}
			$('#right_list').show();
			$('#center_div').show();
		}
	}); 
}

/* ********************************************************
* load bar 추가
******************************************************** */
function fn_proxy_loadbar(gbn){
	var htmlLoad_proxy = '<div id="loading_proxy"><div class="flip-square-loader mx-auto" style="border: 0px !important;z-index:99999;"></div></div>';
	if($("#loading_proxy").length == 0)	$("#contentsDiv").append(htmlLoad_proxy);
	
	if (gbn == "start") {
	      $('#loading_proxy').css('position', 'absolute');
	      $('#loading_proxy').css('left', '50%');
	      $('#loading_proxy').css('top', '50%');
	      $('#loading_proxy').css('transform', 'translate(-50%,-50%)');	  
	      $('#loading_proxy').show();	
	} else {
		$('#loading_proxy').hide();	
	}
}