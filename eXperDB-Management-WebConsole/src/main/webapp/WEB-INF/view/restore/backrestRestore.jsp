<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>

<script type="text/javascript">
	var dbServerTable = null;
	var table_db = null;
	var db_info_arr = [];
	var exelog = "";
	var time_restore = "";
	var selected_type = "";
	var backrest_gbn = "";
	var backupInfoCode = "";
	var db_svr_nm = "";
	var remote_ip = "";

	$(window.document).ready(function() {

		fn_init();

		//validate
	    $("#restoreBackrestRegForm").validate({
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

    function fn_init_db_svr_info() {
		dbServerTable = $('#db_svr_info').DataTable({
			scrollY : "538px",
			bSort: false,
			scrollX: false,	
			searching : false,
			paging : false,
			deferRender : true,
			destroy: true,
			columns : [
						{data : "master_gbn", className : "dt-center", defaultContent : "",
						render: function(data, type, full, meta){
							if(data == "M"){
								data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 30px;"><b>Primary</b></div>'
							}else if(data == "S"){
								data = '<i class="mdi mdi-subdirectory-arrow-right" style="margin-left: 50px;"><div class="badge badge-pill badge-outline-warning" title="" style="margin-right: 30px"><b>Standby</b></div>'
							}
							
							return data;
						}},
						{data : "svr_host_nm", className : "dt-center", defaultContent : "" },
						{data : "ipadr", className : "dt-center", defaultContent: "" },
						{data : "bck_svr_id", defaultContent : "", visible: false }
			],'select': {'style': 'single'}
		});
		
		dbServerTable.tables().header().to$().find('th:eq(0)').css('min-width', '170px');
		dbServerTable.tables().header().to$().find('th:eq(1)').css('min-width', '190px');
		dbServerTable.tables().header().to$().find('th:eq(2)').css('min-width', '190px');
		dbServerTable.tables().header().to$().find('th:eq(3)').css('min-width', '0px');

		$(window).trigger('resize'); 
	}

	function fn_init(){
		fu_database_list_init();
		fn_makeHour();
		fn_makeMin();
		fn_makeSec();

		fn_select_agent_info();

		// fn_init_db_svr_info();

		$("#pitr_div").hide();
	}

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
		$("#hour", "#restoreBackrestRegForm").append(hourHtml);
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
		$("#min", "#restoreBackrestRegForm").append(minHtml);
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
		$("#sec", "#restoreBackrestRegForm").append(secHtml);
	}

	function fn_restore_type_chk(obj){
		$("#"+obj.id+"_alert", "#restoreBackrestRegForm").html("");
		$("#"+obj.id+"_alert", "#restoreBackrestRegForm").hide();
		var selected_type = $("#ins_rst_opt_cd option:selected").val();

		if(selected_type == "pitr"){
			$("#rst_pitr_dtm", "#restoreBackrestRegForm").val("");
			$('#timeline_h option:eq(0)').prop("selected", true);
			$('#timeline_m option:eq(0)').prop("selected", true);
			$('#timeline_s option:eq(0)').prop("selected", true);
			document.getElementById("bckr_restore_type_alert").style.width = "340px"
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").html('<spring:message code="restore.type.time.exp" />');
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").show();
			$("#dbList_div").hide();
			$("#pitr_div").show();
		}else if(selected_type == "full"){
			document.getElementById("bckr_restore_type_alert").style.width = "665px"
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").html('<spring:message code="restore.type.full.exp" />');
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").show();
			$("#dbList_div").hide();
			$("#pitr_div").hide();
		}else if(selected_type == "ropd"){
			//특정 데이터베이스 복구
			fn_select_database_list();
			table_db.rows({selected: true}).deselect();
			$('#src_database option:eq(0)').prop("selected", true);
			document.getElementById("bckr_restore_type_alert").style.width = "720px"
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").show();
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").html('특정 데이터베이스를 복구대상 서버에 복구합니다. (postgres, template0, template1는 자동으로 복구됩니다.)');
			$("#dbList_div").show();
			$("#pitr_div").hide();
		}else{
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").hide();
			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").html('');
			$("#dbList_div").hide();
			$("#pitr_div").hide();
		}
	}

	async function fn_select_agent_info(){
		$.ajax({
			url : "/restore/backrestAllAgentList.do",
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
			success : function(data) {
				var db_server_data = data['agent_list'];

				if(data.result_code == "E"){
					showSwalIconRst("백업된 정보가 없습니다.", closeBtn, '', 'error', '');
				}else{
					backrest_gbn = data.backrest_gbn;

					for(var i=0; i < db_server_data.length; i++){
						db_info_arr.push(db_server_data[i]);
					}

					if(backrest_gbn == "cloud"){
						$("#cloud_s3_restore_info", "#restoreBackrestRegForm").css("display", "");
						$("#ssh_port_info", "#restoreBackrestRegForm").css("display", "none");
					}else if(backrest_gbn == "remote"){
						$("#cloud_s3_restore_info", "#restoreBackrestRegForm").css("display", "none");
						$("#ssh_port_info", "#restoreBackrestRegForm").css("display", "none");

						remote_ip = data.remote_ip;
					}else{
						$("#cloud_s3_restore_info", "#restoreBackrestRegForm").css("display", "none");
						$("#ssh_port_info", "#restoreBackrestRegForm").css("display", "none");
					}
					
					db_svr_nm = data.db_svr_nm;
					// fn_select_database_list();
				}

				fn_init_db_svr_info();

				dbServerTable.rows({selected: true}).deselect();
				dbServerTable.clear().draw();

				if (nvlPrmSet(data, "") != '') {
					dbServerTable.rows.add(db_info_arr).draw();
				}
				
				backupInfoCode = data.result_code;

				
			}
		});
	}


	/* ********************************************************
	 * 복구명 중복체크
	 ******************************************************** */
	 function fn_restoreNm_check() {
		if (nvlPrmSet($("#restore_nm", "#restoreBackrestRegForm").val(), "") == "") {
			showSwalIcon('<spring:message code="restore.msg01" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화
		$("#restorenm_check_alert", "#restoreBackrestRegForm").html('');
		$("#restorenm_check_alert", "#restoreBackrestRegForm").hide();

		$.ajax({
			url : '/backrest_nmCheck.do',
			type : 'post',
			data : {
				backrest_nm : $("#restore_nm", "#restoreBackrestRegForm").val()
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
					$('#restore_nmChk', '#restoreBackrestRegForm').val("success");
				} else {
					showSwalIcon('<spring:message code="restore.msg222" />', '<spring:message code="common.close" />', '', 'error');
					$('#restore_nmChk', '#restoreBackrestRegForm').val("fail");
				}
			}
		});
	}

	/* ********************************************************
	 * 복원명 변경 시
	 ******************************************************** */
	 function fn_restoreNm_Chg() {
		$('#restore_nmChk', '#restoreTimeRegForm').val("fail");
		
		$("#restorenm_check_alert", "#restoreTimeRegForm").html('');
		$("#restorenm_check_alert", "#restoreTimeRegForm").hide();
	}

	/* ********************************************************
	 * validate 체크
	 ******************************************************** */
	function fn_restore_validate() {
		var iChkCnt = 0;
		var selected_type = $("#ins_rst_opt_cd option:selected").val();
		var agentInfo = $('#db_svr_info').DataTable().rows('.selected').data()[0];

		if(nvlPrmSet($("#restore_nmChk", "#restoreBackrestRegForm").val(), "") == "" || nvlPrmSet($("#restore_nmChk", "#restoreBackrestRegForm").val(), "") == "fail") {
			$("#restorenm_check_alert", "#restoreBackrestRegForm").html('<spring:message code="restore.msg02"/>');
			$("#restorenm_check_alert", "#restoreBackrestRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}

		//1
		if($('#db_svr_info').DataTable().rows('.selected').data()[0] == undefined){
			showSwalIcon("복원 대상 서버를 선택해주세요", '<spring:message code="common.close" />', '', 'warning');

			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#ins_rst_opt_cd", "#restoreBackrestRegForm").val(), "") == "") {
			$("#ins_rst_opt_cd_alert", "#restoreBackrestRegForm").html('복구유형를 입력해주세요.');
			$("#ins_rst_opt_cd_alert", "#restoreBackrestRegForm").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(selected_type == "pitr"){
			if(nvlPrmSet($("#rst_pitr_dtm", "#restoreBackrestRegForm").val(), "") == "") {
				$("#rst_pitr_dtm_alert", "#restoreBackrestRegForm").html('특정 시점의 날짜를 선택해주세요.');
				$("#rst_pitr_dtm_alert", "#restoreBackrestRegForm").show();
			
				iChkCnt = iChkCnt + 1;
			}
		}

		if(selected_type == "ropd"){
			if($('#dbList').DataTable().rows('.selected').data()[0] == undefined) {
				showSwalIcon("복구할 특정 테이터베이스를 선택해주세요.", '<spring:message code="common.close" />', '', 'warning');
			
				iChkCnt = iChkCnt + 1;
			}
		}

		//2
		if(backrest_gbn == "cloud"){
			if(nvlPrmSet($("#ins_s3_bucket", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_bucket_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.bucket" />');
				$("#ins_s3_bucket_alert", "#restoreBackrestRegForm").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_s3_region", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_region_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.region" />');
				$("#ins_s3_region_alert", "#restoreBackrestRegForm").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_s3_key", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_key_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.key" />');
				$("#ins_s3_key_alert", "#restoreBackrestRegForm").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_s3_endpoint", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_endpoint_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.endpoint" />');
				$("#ins_s3_endpoint_alert", "#restoreBackrestRegForm").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_s3_path", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_path_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.path" />');
				$("#ins_s3_path_alert", "#restoreBackrestRegForm").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_s3_secret", "#restoreBackrestRegForm").val(), "") == "") {
				$("#ins_s3_secret_alert", "#restoreBackrestRegForm").html('<spring:message code="backup_management.s3.secretkey" />');
				$("#ins_s3_secret_alert", "#restoreBackrestRegForm").show();

				iChkCnt = iChkCnt + 1;
			}
		}else if(backrest_gbn == "local"){
			if($("#db_svr_id", "#findList").val() != agentInfo.db_svr_id){
				if(nvlPrmSet($("#ins_ssh_port", "#restoreBackrestRegForm").val(), "") == "") {
					$("#ins_ssh_port_alert", "#restoreBackrestRegForm").html('ssh 포트를 입력해주세요');
					$("#ins_ssh_port_alert", "#restoreBackrestRegForm").show();

					iChkCnt = iChkCnt + 1;
				}
			}

			// if(nvlPrmSet($("#ins_ssh_port", "#restoreBackrestRegForm").val(), "") == "") {
			// 	$("#ins_ssh_port_alert", "#restoreBackrestRegForm").html('ssh 포트를 입력해주세요');
			// 	$("#ins_ssh_port_alert", "#restoreBackrestRegForm").show();

			// 	iChkCnt = iChkCnt + 1;
			// }
		}

		if (iChkCnt > 0) {
			return false;
		}

		fn_passwordConfilm('backrest');
		return true;
	}


	/* ********************************************************
	 * 요소값이 바뀌었을때
	 ******************************************************** */
	function fn_backrest_chg_alert(obj){
		$("#"+obj.id+"_alert", "#restoreBackrestRegForm").html("");
		$("#"+obj.id+"_alert", "#restoreBackrestRegForm").hide();
	}


	/* ********************************************************
	 * 실행버튼 클릭 시
	 ******************************************************** */
	function fn_restore_start() {
		if(backupInfoCode == "E"){	
			showSwalIconRst("백업된 정보가 없습니다.", closeBtn, '', 'error', '');
		}else{
			$("#restoreBackrestRegForm").submit();
		}

		
	}


	/* ********************************************************
	 * 복구 내용 저장 
	 ******************************************************** */
	function fn_execute(){
		var timeline_dt = $("#rst_pitr_dtm", "#restoreBackrestRegForm").val();
		var timeline_h = $("#timeline_h", "#restoreBackrestRegForm").val();
		var timeline_m = $("#timeline_m", "#restoreBackrestRegForm").val();
		var timeline_s = $("#timeline_s", "#restoreBackrestRegForm").val();
		var selected_type = $("#ins_rst_opt_cd option:selected").val();
		var restore_type = 0;
		var selectedAgent = $('#db_svr_info').DataTable().rows('.selected').data()[0];

		if(selected_type == "pitr"){
			restore_type = 1;
			time_restore = timeline_dt + " " + timeline_h + ":" + timeline_m + ":" + timeline_s;
		}else if(selected_type == "full"){
			restore_type = 0;
		}else if(selected_type == "ropd"){
			restore_type = 2;
		}
		
		if (timeline_dt != null && timeline_dt != "") {
			timeline_dt = timeline_dt.split("-").join("");
		}

		$.ajax({
			url : "/insertBackrestRestore.do",
			data : {
				db_svr_id : selectedAgent.db_svr_id,
				db_svr_ipadr_id : selectedAgent.db_svr_ipadr_id,
				restore_nm : $("#restore_nm", "#restoreBackrestRegForm").val(),
				restore_exp : $("#restore_exp", "#restoreBackrestRegForm").val(),
				restore_flag :  restore_type,
				restore_cndt :	2,
				asis_flag : 0,
				timeline_dt : timeline_dt,
				timeline_h : timeline_h,
				timeline_m : timeline_m,
				timeline_s : timeline_s
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
			success : function(data) {
				if (data != null) {
					if (data.snResult == "S") {
						exelog = data.exelog;
						if(restore_type == 0){
							showSwalIconRst('<spring:message code="restore.msg225" />', '<spring:message code="common.close" />', '', 'warning', 'backrest_restore');
						}else if(restore_type == 1){
							showSwalIconRst('<spring:message code="restore.msg226" />', '<spring:message code="common.close" />', '', 'warning', 'backrest_restore');
						}else if(restore_type == 2){
							showSwalIconRst('특정 데이터베이스 복구를 시작합니다.', '<spring:message code="common.close" />', '', 'warning', 'backrest_restore');
						}
						fn_restore_execute();
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
	 * 복구 실행 
	 ******************************************************** */
	 function fn_restore_execute(){
		var restore_type = $("#ins_rst_opt_cd option:selected").val();
		var agentInfo = $('#db_svr_info').DataTable().rows('.selected').data()[0];

		var cloud_map = new Map();
		var cloud_data = null;
		var dbList_map = new Map();
		var dbList_data = null;
		var list_type = null;

		if(backrest_gbn == "cloud"){
			cloud_map.set("s3_bucket", nvlPrmSet($('#ins_s3_bucket', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("s3_region", nvlPrmSet($('#ins_s3_region', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("s3_key", nvlPrmSet($('#ins_s3_key', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("s3_endpoint", nvlPrmSet($('#ins_s3_endpoint', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("s3_path", nvlPrmSet($('#ins_s3_path', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("s3_key-secret", nvlPrmSet($('#ins_s3_secret', '#restoreBackrestRegForm').val(), "").trim());
			cloud_map.set("cloud_type", "s3");

			cloud_data = JSON.stringify(Object.fromEntries(cloud_map))
		}

		if(restore_type == "ropd"){
			var dbList_data = $('#dbList').DataTable().rows('.selected').data();
			list_type = $("#src_database option:selected").val();
			
			for(var i=0; i < dbList_data.length; i++){
				dbList_map.set(i, dbList_data[i].dft_db_nm)
			}

			dbList_data = JSON.stringify(Object.fromEntries(dbList_map))

			console.log(dbList_data);
		}

		$.ajax({
			url : "/executeBackrestRestore.do",
			data : {
				exelog : exelog,
				restore_nm : $("#restore_nm", "#restoreBackrestRegForm").val(),
				restore_type : restore_type,
				ipadr : agentInfo.ipadr,
				time_restore : time_restore,
				pgdata_pth : agentInfo.pgdata_pth,
				portno : agentInfo.portno,
				svr_spr_usr_id : agentInfo.svr_spr_usr_id,
				db_svr_ipadr_id : agentInfo.db_svr_ipadr_id,
				db_svr_id : $("#db_svr_id", "#findList").val(),
				restore_db_svr_id : agentInfo.db_svr_id,
				cloud_map : cloud_data,
				backup_location : backrest_gbn,
				ssh_port : nvlPrmSet($('#ins_ssh_port', '#restoreBackrestRegForm').val(), "").trim(),
				dbList_map : dbList_data,
				list_type : list_type
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
				cloud_map.clear();
				cloud_data = null;
			}
		});
	}


	/* ********************************************************
	 * restore history 이동
	 ******************************************************** */
	function fn_bckr_restore_History_move() {
		var agentInfo = $('#db_svr_info').DataTable().rows('.selected').data()[0];

		var id = "restoreHistory" + agentInfo.db_svr_id;
		location.href='/restoreHistory.do?db_svr_id='+agentInfo.db_svr_id;
		parent.fn_GoLink(id);
	}


	$(function() {
		$("#db_svr_info").on('click', 'tbody tr', function(){
			var agentInfo = $('#db_svr_info').DataTable().rows(this).data()[0];
			var state = $('#ins_rst_opt_cd option:selected').val();

			$('#ins_rst_opt_cd option:eq(0)').prop("selected", true);

			if(state == "pitr"){
				$("#rst_pitr_dtm", "#restoreBackrestRegForm").val("");
				$('#timeline_h option:eq(0)').prop("selected", true);
				$('#timeline_m option:eq(0)').prop("selected", true);
				$('#timeline_s option:eq(0)').prop("selected", true);

				$("#pitr_div").hide();
			}else if(state = "ropd"){
				$("#dbList_div", "#restoreBackrestRegForm").css("display", "none");
			}

			if($("#db_svr_id", "#findList").val() == agentInfo.db_svr_id){
				$("#restore_opt_db", "#restoreBackrestRegForm").css("display", "none");
			}else{
				$("#restore_opt_db", "#restoreBackrestRegForm").css("display", "");
			}


			if(backrest_gbn == "local"){
				if($("#db_svr_id", "#findList").val() == agentInfo.db_svr_id){
					$("#ssh_port_info", "#restoreBackrestRegForm").css("display", "none");
				}else{
					$("#ssh_port_info", "#restoreBackrestRegForm").css("display", "");
				}
			}

			$("#bckr_restore_type_alert", "#restoreBackrestRegForm").hide();

		});
	})

	function fn_select_database_list() {
		$.ajax({
			url : "/selectTreeServerDBList.do",
			data : {
				db_svr_nm: db_svr_nm
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
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');						}
			},
			success : function(result) { 
				var db_list_data = [];

				for(var i=0; i < result.data.length; i++){
					if(result.data[i].dft_db_nm != "postgres"){
						db_list_data.push(result.data[i]);
					}
				}

				table_db.clear().draw();
	    		table_db.rows.add(db_list_data).draw();
				// table_db.rows({selected: true}).deselect();
			}
		});
	}

	function fu_database_list_init(){
		table_db = $('#dbList').DataTable({
			scrollY : "240px",
			scrollX: true,	
			searching : true,
			paging : true,		
			deferRender : true,
			destroy : true,
			lengthChange : false,
			language: {
        		"search": "",
				"searchPlaceholder" : "DB명을 입력해주세요"
    		},	
			columns : [
				{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{data : "dft_db_nm", defaultContent : ""}
			],'select': {'style': 'multi'}
		});

		table_db.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
   		table_db.tables().header().to$().find('th:eq(1)').css('min-width', '470px');
	}
	
</script>

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
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub">
												<i class="fa fa-cog"></i>
												<span class="menu-title"><spring:message code="restore.msg00" /></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.msg00" /></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="restore.msg001" /></p>
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
				<div class="card-body" style="min-height:1000px; max-height:1400px;">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">																				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScheduleRun" onClick="fn_restore_start();">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="schedule.run" />
								</button>

								<div class="col-sm-2_5 float-right">
									<div class="alert alert-info " style="width: 100%; margin-top: 18px;"><spring:message code="restore.msg002" /></div>
								</div>
							</div>
						</div>
					</div>

					<form class="cmxform" id="restoreBackrestRegForm">
						<input type="hidden" name="restore_nmChk" id="restore_nmChk" value="fail" />
												
						<fieldset>
							<div class="row" style="margin-top:10px;">
								<div class="col-md-12 system-tlb-scroll" style="min-height: 200px; max-height: 500px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="restore_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_name" />
											</label>
		
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="restore_nm" name="restore_nm" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"" onchange="fn_restoreNm_Chg();" onblur="this.value=this.value.trim()" tabindex=1 required />
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

                                        <div class="form-group row div-form-margin-z">
											<label for="restore_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_Description" />
											</label>
		
											<div class="col-sm-10">
												<textarea class="form-control form-control-xsm" id="restore_exp" name="restore_exp" rows="2" maxlength="150" onkeyup="fn_checkWord(this,150)" placeholder="150<spring:message code='message.msg188'/>" required tabindex=2></textarea>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="row" style="margin-top:10px;">
								<div class="col-md-6 system-tlb-scroll" style="min-height: 600px; max-height: 800px; overflow-x: hidden ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
                                        <div style="margin-left: -15px; display: flex;">
                                            <label for="restore_nm" class="col-sm-7 col-form-label pop-label-index" style="padding-top:7px;">
                                                <i class="ti-desktop menu-icon"></i>
                                                <span>복구<spring:message code="restore.target.list" /></span>
                                            </label>

											<div class="col-sm-5">
												<div class="alert alert-danger form-control-sm" style="margin-top:-7px; visibility: hidden " id="server_selected_check_alert">복구 대상 서버를 선택해주세요</div>
											</div>
                                        </div>

										<!-- <div class="col-sm-5">
											<div class="alert alert-danger form-control-sm" style="margin-top:5px;" id="server_selected_check_alert">복구 대상 서버를 선택해주세요</div>
										</div> -->

                                        <div class="col-12" id="backrest_svr_info_div" style="">
                                            <div class="table-responsive">
                                                <div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
                                                    <div class="row">
                                                        <div class="col-sm-12 col-md-6">
                                                            <div class="dataTables_length" id="order-listing_length">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <table id="db_svr_info" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
                                                <thead>
                                                    <tr class="bg-info text-white">
                                                        <th width="170" class="dt-center"><spring:message code="eXperDB_backup.msg16" /></th>
                                                        <th width="190" class="dt-center"><spring:message code="properties.host" /></th>
                                                        <th width="190" class="dt-center"><spring:message code="properties.ip" /></th>
                                                        <th width="0"></th>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
									</div>
								</div>

								<div class="col-md-6 system-tlb-scroll" style="border:0px; min-height: 600px; max-height: 700px; overflow-x: hidden; ">
									<div class="card-body" style="border: 1px solid #adb5bd; padding: 10px;">
                                        <div>
											<div class="form-group row div-form-margin-z" style="padding: 10px; display: none;" id="cloud_s3_restore_info">
                                                <label for="" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    s3-bucket
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_s3_bucket" name="ins_s3_bucket" style="width: 100%" placeholder="" />
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_s3_bucket_alert"></div>
												</div>

												<label for="" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                   s3-region
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_s3_region" name="ins_s3_region" style="width: 100%" placeholder="" />
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_s3_region_alert"></div>
												</div>

												<label for="" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    s3-key
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="password" class="form-control form-control-xsm" maxlength="50" id="ins_s3_key" name="ins_s3_key" style="width: 100%" placeholder=""/>
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px; " id="ins_s3_key_alert"></div>
												</div>

												<label for="backup_file_type" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    s3-endpoint
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_s3_endpoint" name="ins_s3_endpoint" style="width: 100%" placeholder=""/>
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_s3_endpoint_alert"></div>
												</div>

												<label for="backup_file_type" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    s3-path
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_s3_path" name="ins_s3_path" style="width: 100%" placeholder="" />
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_s3_path_alert"></div>
												</div>

												<label for="backup_file_type" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    s3-key-secret
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="password" class="form-control form-control-xsm" maxlength="50" id="ins_s3_secret" name="ins_s3_secret" style="width: 100%" placeholder=""/>
												</div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_s3_secret_alert"></div>
												</div>
							
												<!-- <div class="col-sm-3">
													<div class="alert alert-danger" style="display:none; width: 220px; margin-left: -15px;" id="ins_rst_opt_cd_alert"></div>
												</div> -->
                                            </div>

											<div class="form-group row div-form-margin-z" style="margin-top:10px; padding: 10px;" id="ssh_port_info">
                                                <label for="" class="col-sm-3 col-form-label pop-label-index" style="margin-top: -10px;">
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    ssh-port
                                                </label>
												<div class="col-sm-4" style="margin-left: 10px;">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_ssh_port" name="ins_ssh_port" style="width: 100%" placeholder="" />
												</div>
												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-top: -7px;" id="ins_ssh_port_alert"></div>
												</div>
											</div>


                                            <div class="form-group row div-form-margin-z" style="margin-top:10px; padding: 10px;">
                                                <label for="restore_type" class="col-sm-3 col-form-label pop-label-index" >
                                                    <i class="item-icon fa fa-dot-circle-o"></i>
                                                    <spring:message code="restore.type" />
                                                </label>
 
                                                <div class="col-sm-4">
                                                    <select class="form-control form-control-sm" style=" color: black; margin-top: 5px; margin-left: 10px;" name="ins_rst_opt_cd" id="ins_rst_opt_cd" tabindex=2 onchange="fn_restore_type_chk(this)">
													    <option value=""><spring:message code="common.choice" /></option>
	    												<option value="full"><spring:message code="restore.type.full" /></option>
		    											<option value="pitr"><spring:message code="restore.type.time" /></option>
														<option value="ropd" id="restore_opt_db" style="display: none;">특정 데이터베이스 복구</option>
				    								</select>
                                                </div>

												<div class="col-sm-4">
													<div class="alert alert-danger" style="display:none; width: 105%; margin-left: 10px;" id="ins_rst_opt_cd_alert"></div>
												</div>
                                            </div>

											<div class="form-group row div-form-margin-z">
												<div class="alert alert-info " style="display:none; width: 100%; margin:20px" id="bckr_restore_type_alert" ></div>
											</div>
											

                                            <div class="form-group row div-form-margin-z" style="padding: 10px; margin-left: 1px;" id="pitr_div">
												<div id="rst_pitr_div" class="input-group align-items-center date datepicker totDatepicker col-sm-4">
                                                    <input type="text" class="form-control totDatepicker" id="rst_pitr_dtm" name="rst_pitr_dtm" onchange="fn_backrest_chg_alert(this)">
                                                    <span class="input-group-addon input-group-append border-left">
                                                        <span class="ti-calendar input-group-text" style="cursor:pointer"></span>
                                                    </span>
                                                </div>

												<div class="col-sm-8">
													<span id="hour" style="margin-right: 1rem;"></span>
													<span id="min" style="margin-right: 1rem;"></span>
													<span id="sec"></span>
												</div>
                                            </div>

											<div class="col-sm-4">
												<div class="alert alert-danger" style="display:none; width: 265px; margin-left: -2px;" id="rst_pitr_dtm_alert"></div>
											</div>


											<div id="dbList_div" style="display: none;">
												<div class="form-group row div-form-margin-z" style="margin-top:10px; padding: 10px;">
													<label for="restore_type" class="col-sm-3 col-form-label pop-label-index" >
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="dbms_information.databaseList"/>
													</label>
												</div>

												<div style="margin-top: -7%;">
													<div style="width: 100%; position: relative;  z-index: 2;">
														<!-- <div class="col-sm-9" style="display: flex;">
															<div>
																<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="25" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='DB명을 입력해주세요' />
															</div>

															<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSelect" style="margin-left: 1rem;">
																<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
															</button>
														</div> -->

														<div class="col-sm-4" style="top: 40px;">
															<select name="src_database" id="src_database"  class="form-control form-control-sm" style="width: 80%; color: black;">
																<option value="include">대상 데이터베이스</option>
																<option value="exclude">제외 데이터베이스</option>
															</select>
														</div>
													</div>


													<div style="margin-left: 15px; position: relative; margin-right: 15px; margin-bottom: 20px; z-index: 1;">
														<table id="dbList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
															<thead>
																<tr class="bg-info text-white">
																	<th width="50" style="text-align: center;"><input name="select" value="1" type="checkbox"></th>
																	<th width="470"><spring:message code="common.database" /></th>
																</tr>
															</thead>
														</table> 
													</div>
												</div>
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