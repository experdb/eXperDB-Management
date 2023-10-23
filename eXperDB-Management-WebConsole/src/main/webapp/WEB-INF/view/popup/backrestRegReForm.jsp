<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name :backrestRegReForm.jsp
	* @Description : backrest 백업수정 화면
	* @Modification Information
	*
	*/
%>

<script type="text/javascript">
	var mod_restore_check = "";
	var mod_cus_check = false;
	var mod_remoteConn = "Fail";
	var mod_log_pth_chk = false;
	var mod_remote_pw = "";
	var backrestBckServerTable = null;
	var backrestBckServerTable2 = null;
	

	$(window.document).ready(function() {
		$("#workRegReFormBckr").validate({
	        rules: {
				mod_wrk_exp_bckr: {
					required: true
				}
	        },
	        messages: {
				mod_wrk_exp_bckr: {
	        		required: '<spring:message code="message.msg108" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_backrest_update_work();
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

	function fn_init_backrest_mod_form() {
		backrestBckServerTable = $('#mod_backrest_svr_Info').DataTable({
			scrollY : "60px",
			bSort: false,
			scrollX: false,	
			searching : false,
			paging : false,
			deferRender : true,
			destroy: true,
			info: false,
			columns : [
						{data : "rownum", defaultContent : "", className : "dt-center"}, 
						{data : "master_gbn", className : "dt-center", defaultContent : "",
						render: function(data, type, full, meta){
							if(data == "M"){
								data = '<div class="badge badge-pill badge-success" title="" ><b>Primary</b></div>'
							}else if(data == "S"){
								data = '<div class="badge badge-pill badge-outline-warning" title="" ><b>Standby</b></div>'
							}
							return data;
						}},
						{data : "ipadr", defaultContent : "" },
						{data : "portno", defaultContent: "" },
						{data : "svr_spr_usr_id", defaultContent : ""},
						{data : "pgdata_pth", defaultContent : ""},
						{data : "bck_svr_id", defaultContent : "", visible: false }
			],
		});
		
		backrestBckServerTable.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		backrestBckServerTable.tables().header().to$().find('th:eq(1)').css('min-width', '135px');
		backrestBckServerTable.tables().header().to$().find('th:eq(2)').css('min-width', '135px');
		backrestBckServerTable.tables().header().to$().find('th:eq(3)').css('min-width', '60px');
		backrestBckServerTable.tables().header().to$().find('th:eq(4)').css('min-width', '120px');
		backrestBckServerTable.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
		backrestBckServerTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');

		$(window).trigger('resize'); 
	}

	function fn_init_backrest_mod_form2() {
		backrestBckServerTable2 = $('#mod_backrest_svr_Info2').DataTable({
			scrollY : "60px",
			bSort: false,
			scrollX: false,	
			searching : false,
			paging : false,
			deferRender : true,
			destroy: true,
			info: false,
			columns : [
						{data : "rownum", defaultContent : "", className : "dt-center"}, 
						{data : "master_gbn", className : "dt-center", defaultContent : "",
						render: function(data, type, full, meta){
							if(data == "M"){
								data = '<div class="badge badge-pill badge-success" title="" style="margin-right: 30px;"><b>Primary</b></div>'
							}else if(data == "S"){
								data = '<div class="badge badge-pill badge-outline-warning" title="" style="margin-right: 30px"><b>Standby</b></div>'
							}
							return data;
						}},
						{data : "ipadr", defaultContent : "" },
						{data : "portno", defaultContent: "" },
						{data : "svr_spr_usr_id", defaultContent : ""},
						{data : "pgdata_pth", defaultContent : ""},
						{data : "bck_svr_id", defaultContent : "", visible: false }
			],
		});
		
		backrestBckServerTable2.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(1)').css('min-width', '135px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(2)').css('min-width', '135px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(3)').css('min-width', '60px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(4)').css('min-width', '120px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(5)').css('min-width', '200px');
		backrestBckServerTable2.tables().header().to$().find('th:eq(6)').css('min-width', '0px');

		$(window).trigger('resize'); 
	}


	//Custom popup
	function fn_mod_custom_popup(){
		mod_cus_check = true;

		$.ajax({
			url : "/popup/backrestRegCustomForm.do",
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
				
				for(var i=0; i < result['backrest_cus_opt'].length; i++){
					if(result['backrest_cus_opt'][i].opt_gbn == 0 || result['backrest_cus_opt'][i].opt_gbn == 1 ){
						bckr_cst_opt.push(result['backrest_cus_opt'][i]);
					}
				}

				if(custom_map.size == 0){
					fn_deleteCustom();
        		}else{
					if(custom_cancle == true){
						fn_deleteCustom();

						const customKeyList = custom_map.keys();
						var custom_origin_keys = [];

						for (let key of customKeyList) {
							custom_origin_keys.push(key)
						}

						for(var i=0; i < custom_map.size; i++){
							fn_backrest_custom_add(i);

							$("#ins_bckr_cst_opt_" + i).val(custom_origin_keys[i]).attr("selected",true);
							$("#ins_bckr_cst_val_" + i).val(custom_map.get(custom_origin_keys[i]));
						}
					}

					if(mod_cus_check == true ){
						fn_deleteCustom();

						const customKeyList = custom_map.keys();
						var custom_origin_keys = [];

						for (let key of customKeyList) {
							custom_origin_keys.push(key)
						}

						for(var i=0; i < custom_map.size; i++){
							fn_backrest_custom_add(i);

							$("#ins_bckr_cst_opt_" + i).val(custom_origin_keys[i]).attr("selected",true);
							$("#ins_bckr_cst_val_" + i).val(custom_map.get(custom_origin_keys[i]));
						}
					}
				}
	
				$('#pop_layer_reg_backrest_custom').modal("show");
			}
		});
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function mod_backrest_valCheck(){
		var iChkCnt = 0;

		//기본 옵션 alert
		if(nvlPrmSet($("#mod_bckr_opt_cd", "#workRegReFormBckr").val(), "") == "") {
			$("#mod_bckr_opt_cd_alert", "#workRegReFormBckr").html('백업유형를 입력해주세요.');
			$("#mod_bckr_opt_cd_alert", "#workRegReFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#mod_bckr_cnt", "#workRegReFormBckr").val(), "") == "") {
			$("#mod_bckr_cnt_alert", "#workRegReFormBckr").html('풀 백업 보관일을 입력해주세요.');
			$("#mod_bckr_cnt_alert", "#workRegReFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		// if(nvlPrmSet($("#mod_bckr_pth", "#workRegReFormBckr").val(), "") == ""){
		// 	$("#mod_bckr_pth_alert", "#workRegReFormBckr").html('백업 경로체크를 해주세요');
		// 	$("#mod_bckr_pth_alert", "#workRegReFormBckr").show();
		// 	iChkCnt = iChkCnt + 1;
		// }

		if(nvlPrmSet($("#mod_bckr_log_pth", "#workRegReFormBckr").val(), "") == "") {
			$("#mod_bckr_log_pth_alert", "#workRegReFormBckr").html('로그경로를 입력해주세요.');
			$("#mod_bckr_log_pth_alert", "#workRegReFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#mod_cps_opt_prcs", "#workRegReFormBckr").val(), "") == "") {
			$("#mod_cps_opt_prcs_alert", "#workRegReFormBckr").html('병렬도를 입력해주세요.');
			$("#mod_cps_opt_prcs_alert", "#workRegReFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		//Remote 옵션 alert
		if(mod_restore_check == "remote"){
			if(nvlPrmSet($("#mod_remt_str_ip", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_remt_str_ip_alert", "#workRegReFormBckr").html('아이피를 입력해주세요.');
				$("#mod_remt_str_ip_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#mod_remt_str_ssh", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_remt_str_ssh_alert", "#workRegReFormBckr").html('포트를 입력해주세요.');
				$("#mod_remt_str_ssh_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#mod_remt_str_usr", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_remt_str_usr_alert", "#workRegReFormBckr").html('OS 유저명을 입력해주세요.');
				$("#mod_remt_str_usr_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#mod_remt_str_pw", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_remt_str_pw_alert", "#workRegReFormBckr").html('패스워드를 입력해주세요.');
				$("#mod_remt_str_pw_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(mod_remoteConn != "Success"){
				$("#mod_ssh_con_alert", "#workRegReFormBckr").html('연결 테스트를 해주세요.');
				$("#mod_ssh_con_alert", "#workRegReFormBckr").show();
				iChkCnt = iChkCnt + 1;
			}
			
			if(!mod_log_pth_chk) {
				$("#mod_bckr_log_pth_alert", "#workRegReFormBckr").html('로그경로를 입력해주세요.');
				$("#mod_bckr_log_pth_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
		}

		//Cloud 옵션 alert
		if(mod_restore_check == "cloud"){
			if(nvlPrmSet($("#mod_cloud_bckr_s3_buk", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_buk_alert", "#workRegReFormBckr").html('s3 bucket을 입력해주세요.');
				$("#mod_cloud_bckr_s3_buk_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#mod_cloud_bckr_s3_rgn", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_rgn_alert", "#workRegReFormBckr").html('s3 region을 입력해주세요.');
				$("#mod_cloud_bckr_s3_rgn_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#mod_cloud_bckr_s3_key", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_key_alert", "#workRegReFormBckr").html('s3 key를 입력해주세요.');
				$("#mod_cloud_bckr_s3_key_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#mod_cloud_bckr_s3_npt", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_npt_alert", "#workRegReFormBckr").html('s3 endpoint을 입력해주세요.');
				$("#mod_cloud_bckr_s3_npt_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#mod_cloud_bckr_s3_pth", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_pth_alert", "#workRegReFormBckr").html('s3 경로를 입력해주세요.');
				$("#mod_cloud_bckr_s3_pth_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#mod_cloud_bckr_s3_scrk", "#workRegReFormBckr").val(), "") == "") {
				$("#mod_cloud_bckr_s3_scrk_alert", "#workRegReFormBckr").html('s3 secrey key를 입력해주세요.');
				$("#mod_cloud_bckr_s3_scrk_alert", "#workRegReFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
		}

		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}

	//압축여부에 따라 압축타입 활성화 비활성화
	function mod_backrest_compress_chk(){
		if($('#mod_bckr_cps_yn_chk').is(':checked')){
			$("#mod_cps_opt_type", "#workRegReFormBckr").attr("disabled",false);
        }else{
			$("#mod_cps_opt_type", "#workRegReFormBckr").attr("disabled",true);
		}
	}

	//alert창 onchange
 	function fn_backrest_chg_alert(obj){
		$("#"+obj.id+"_alert", "#workRegReFormBckr").html("");
		$("#"+obj.id+"_alert", "#workRegReFormBckr").hide();
		
		if($("#mod_remote_radio").is(':checked')){
			if(obj.id == 'mod_bckr_log_pth') mod_log_pth_chk = false;
		}
	} 
 
	//PG Backrest Work 수정 Update
	function fn_backrest_update_work(){
		if (!mod_backrest_valCheck()) return false;

		if($("#mod_bckr_cps_yn_chk", "#workRegReFormBckr").is(":checked") == true){
			$("#mod_cps_brkr_yn", "#workRegReFormBckr").val("Y");
		} else {
			$("#mod_cps_brkr_yn", "#workRegReFormBckr").val("N");
		}

		var cloud_map = new Map();
		var cloud_data = null;

		var remote_map = new Map();
		var remote_data = null;

		var target_svr_ipadr = "";
		var target_svr_master_gbn = "";
		var target_svr_pgdata = "";
		var target_svr_user = "";
		var target_svr_port = "";
		var bck_target_ipadr_id = "";

		if(mod_restore_check == "cloud"){
			cloud_map.set("s3_bucket", nvlPrmSet($('#mod_cloud_bckr_s3_buk', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("s3_region", nvlPrmSet($('#mod_cloud_bckr_s3_rgn', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("s3_key", nvlPrmSet($('#mod_cloud_bckr_s3_key', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("s3_endpoint", nvlPrmSet($('#mod_cloud_bckr_s3_npt', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("s3_path", nvlPrmSet($('#mod_cloud_bckr_s3_pth', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("s3_key-secret", nvlPrmSet($('#mod_cloud_bckr_s3_scrk', '#workRegReFormBckr').val(), "").trim());
			cloud_map.set("cloud_type", $("#mod_bckr_cld_opt_cd", '#workRegReFormBckr').val());

			cloud_data = JSON.stringify(Object.fromEntries(cloud_map))
		}else if (mod_restore_check == 'remote'){
			remote_map.set("remote_ip", nvlPrmSet($('#mod_remt_str_ip', '#workRegReFormBckr').val(), "").trim());
			remote_map.set("remote_port", nvlPrmSet($('#mod_remt_str_ssh', '#workRegReFormBckr').val(), "").trim());
			remote_map.set("remote_usr", nvlPrmSet($('#mod_remt_str_usr', '#workRegReFormBckr').val(), "").trim());
			remote_map.set("remote_pw", nvlPrmSet($('#mod_remt_str_pw', '#workRegReFormBckr').val(), "").trim());
			
			remote_data = JSON.stringify(Object.fromEntries(remote_map));
		}
		
		var selectedAgent = $('#mod_backrest_svr_Info2').DataTable().rows().data()[0];
		var custom_data = JSON.stringify(Object.fromEntries(custom_map))		

		if(single_chk || svrBckCheck != "local"){
			target_svr_ipadr = selectedAgent.ipadr;
			target_svr_master_gbn = selectedAgent.master_gbn;
			target_svr_pgdata = selectedAgent.pgdata_pth;
			target_svr_user = selectedAgent.svr_spr_usr_id;
			target_svr_port = selectedAgent.portno
			bck_target_ipadr_id = selectedAgent.db_svr_ipadr_id;	
		}else{
			selectedBckAgent = $('#mod_backrest_svr_Info').DataTable().rows().data()[0];;

			if(selectedBckAgent != null){
				target_svr_ipadr = selectedBckAgent.ipadr;
				target_svr_master_gbn = selectedBckAgent.master_gbn;
				target_svr_pgdata = selectedBckAgent.pgdata_pth;
				target_svr_user = selectedBckAgent.svr_spr_usr_id;
				target_svr_port = selectedBckAgent.portno
				bck_target_ipadr_id = selectedBckAgent.db_svr_ipadr_id;
			}
		}

		$.ajax({
			async : false,
			url : "/popup/workBackrestReWrite.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_id : $("#mod_wrk_id_bckr","#workRegReFormBckr").val(),
				bck_wrk_id : $("#mod_bck_wrk_id_bckr","#workRegReFormBckr").val(),
				wrk_nm : nvlPrmSet($('#mod_wrk_nm_bckr', '#workRegReFormBckr').val(), "").trim(),
				wrk_exp : nvlPrmSet($('#mod_wrk_exp_bckr', '#workRegReFormBckr').val(), ""),
				cps_yn : $("#mod_cps_brkr_yn", "#workRegReFormBckr").val(),
				bck_opt_cd : $("#mod_bckr_opt_cd", '#workRegReFormBckr').val(),
				bck_mtn_ecnt : $("#mod_bckr_cnt", '#workRegReFormBckr').val(),
				db_id : 0,
				bck_bsn_dscd : "TC000205",
				bck_pth : $("#mod_bckr_pth", "#workRegReFormBckr").val(),
				log_file_pth : $("#mod_bckr_log_pth", "#workRegReFormBckr").val(),
				bck_filenm : ($('#mod_wrk_nm_bckr', '#workRegReFormBckr').val()) + ".conf",
				prcs_cnt: $("#mod_cps_opt_prcs", "#workRegReFormBckr").val(),
				cps_type: $("#mod_cps_opt_type", "#workRegReFormBckr").val(),
				ipadr: selectedAgent.ipadr,
				pgdata_pth: selectedAgent.pgdata_pth,
				portno: selectedAgent.portno,
				svr_spr_usr_id: selectedAgent.svr_spr_usr_id,
				master_gbn: selectedAgent.master_gbn,
				db_svr_ipadr_id: selectedAgent.db_svr_ipadr_id,
				backrest_gbn: mod_restore_check,
				custom_map: custom_data,
				cloud_map: cloud_data,
				remote_map: remote_data,
				target_svr_ipadr: target_svr_ipadr,
				target_svr_master_gbn: target_svr_master_gbn,
				target_svr_pgdata: target_svr_pgdata,
				target_svr_user: target_svr_user,
				target_svr_port: target_svr_port,
				bck_target_ipadr_id: bck_target_ipadr_id
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
					$('#pop_layer_mod_backrest').modal('hide');

					fn_get_backrest_list();
					mod_remoteConn = "Fail";
				} else if (data == "I") { 
					showSwalIcon('<spring:message code="backup_management.bckPath_fail" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_mod_backrest').modal('show');
					return;
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_mod_backrest').modal('show');
					return;
				}
			}
		});
	}

	function fn_mod_backrest_cancle() {
		mod_cus_check = false;
	}
	
function fn_re_ssh_connection(){
		var remote_ip = nvlPrmSet($('#mod_remt_str_ip', '#workRegReFormBckr').val(), "").trim();
		var remote_port = nvlPrmSet($('#mod_remt_str_ssh', '#workRegReFormBckr').val(), "").trim();
		var remote_usr = nvlPrmSet($('#mod_remt_str_usr', '#workRegReFormBckr').val(), "").trim();
		var remote_pw = nvlPrmSet($('#mod_remt_str_pw', '#workRegReFormBckr').val(), "").trim();
		
		$.ajax({
			url : "/backup/RemoteConn.do",
			data : {
				remote_ip : remote_ip,
				remote_port : remote_port,
				remote_usr : remote_usr,
				remote_pw : remote_pw
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
				if(data == 'success'){
					showSwalIcon('<spring:message code="message.msg93" />', '<spring:message code="common.close" />', '', 'success');
					mod_remoteConn = "Success";
					$("#mod_ssh_con_alert", "#workRegReFormBckr").html("");
					$("#mod_ssh_con_alert", "#workRegReFormBckr").hide();
					$("#mod_remt_str_ip_alert", "#workRegReFormBckr").html("");
					$("#mod_remt_str_ip_alert", "#workRegReFormBckr").hide();
					$("#mod_remt_str_ssh_alert", "#workRegReFormBckr").html("");
					$("#mod_remt_str_ssh_alert", "#workRegReFormBckr").hide();
					$("#mod_remt_str_usr_alert", "#workRegReFormBckr").html("");
					$("#mod_remt_str_usr_alert", "#workRegReFormBckr").hide();
					$("#mod_remt_str_pw_alert", "#workRegReFormBckr").html("");
					$("#mod_remt_str_pw_alert", "#workRegReFormBckr").hide();
				}else {
					showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
					mod_remoteConn = "Fail";
				}
				
			}
		})
	}
	
	function pw_chk(obj){
		var pw_chk_id = obj.id;
		var pw_chk_val = $('#'+pw_chk_id).val();
		
		if(pw_chk_id == 'mod_remt_str_pw'){
			if(mod_remote_pw != pw_chk_val){
				mod_remoteConn = "Fail";
			}else {
				mod_remoteConn = "Success";
			}
		}
	}
	

</script>

<%@include file="../popup/backrestRegCustomForm.jsp"%>

<div class="modal fade" id="pop_layer_mod_backrest" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 10px 110px;">
		<div class="modal-content" style="width:1500px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					PG Backrest 백업수정
				</h4>
				
				<div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:850px;overflow-y:auto;">
					<form class="cmxform" id="workRegReFormBckr">
						<input type="hidden" name="mod_check_path3" id="mod_check_path3" value="N"/>
						<input type="hidden" name="mod_bck_wrk_id_bckr" id="mod_bck_wrk_id_bckr" value="" />
						<input type="hidden" name="mod_wrk_nmChk_bckr" id="mod_wrk_nmChk_bckr" value="fail" />
						<input type="hidden" name="mod_cps_brkr_yn" id="mod_cps_brkr_yn" value="" />
						<input type="hidden" name="mod_wrk_id_bckr" id="mod_wrk_id_bckr" value="" />
						<input type="hidden" name="mod_bckr_gbn" id="mod_bckr_gbn" value="" />

						<br>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="mod_wrk_nm_bckr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>

									<div class="col-sm-8">
										<input type="text" class="form-control form-control-sm" maxlength="20" id="mod_wrk_nm_bckr" name="mod_wrk_nm_bckr" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()" tabindex=1 required readonly />
									</div>

								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2">
									</div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none; width: 1062px;" id="mod_wrk_nm_bckr_alert"></div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="mod_wrk_exp_bckr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="mod_wrk_exp_bckr" name="mod_wrk_exp_bckr" rows="2" maxlength="200" onkeyup="fn_checkWord(this,25)" placeholder="200<spring:message code='message.msg188'/>" required tabindex=2></textarea>
									</div>
								</div>
							</div>
							
							<br/>

							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									
									<div id="mod_bckr_tar_svr_div" style="width:50%;">
										<label for="mod_bckr_tar_svr" class="col-sm-6 col-form-label pop-label-index">
											<i class="item-icon fa fa-dot-circle-o"></i>
											백업대상서버
										</label>
									</div>
	
									<div id="mod_bckr_svr_div" style="width:50%;">
										<label for="mod_bckr_svr" class="col-sm-2 col-form-label pop-label-index">
											<i class="item-icon fa fa-dot-circle-o"></i>
											백업서버
										</label>
									</div>
								</div>
				
								<div class="form-group row div-form-margin-z">
									<div id="mod_backrest_svr_Info_div2" style="margin-right: 30px; margin-left: 15px;">
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

										<table id="mod_backrest_svr_Info2" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="30" class="dt-center"><spring:message code="common.no" /></th>
													<th width="135" class="dt-center"><spring:message code="data_transfer.type" /></th>
													<th width="135">IP</th>
													<th width="60">PORT</th>
													<th width="120">USER</th>
													<th width="200">DATA_PATH</th>
													<th width="0"></th>
												</tr>
											</thead>
										</table>
									</div>
								

								
									<div id="mod_backrest_svr_Info_div">
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

										<table id="mod_backrest_svr_Info" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="30" class="dt-center"><spring:message code="common.no" /></th>
													<th width="135" class="dt-center"><spring:message code="data_transfer.type" /></th>
													<th width="135">IP</th>
													<th width="60">PORT</th>
													<th width="120">USER</th>
													<th width="200">DATA_PATH</th>
													<th width="0"></th>
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
							</br>
							
							<div style="border: 1px solid #adb5bd;">
								<div class="card-body">
									<div class="form-group row div-form-margin-z">
										<div class="col-12" style="background-color: #e7e7e7; height: 50px;">
											<div id="mod_bck_srv_local_check" style="background-color:white; width: 120px; padding-left: 5px; height: 40px; margin-top: 10px; border-radius: 0.4em; float: left;">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="mod_local_radio" name="mod_bck_srv" checked onclick="return(false)"/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													LOCAL
												</label>
											</div>

											<div id="mod_bck_srv_remote_check" style="background-color: #e7e7e7; width: 130px; padding-left: 5px; height: 40px; margin: 10px 0 0 25px; border-radius: 0.4em; float: left;">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="mod_remote_radio" name="mod_bck_srv" onclick="return(false)"/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													REMOTE
												</label>
											</div>

											<div id="mod_bck_srv_cloud_check" style="background-color: #e7e7e7; width: 120px; padding-left: 5px; height: 40px; margin: 10px 0 0 30px; border-radius: 0.4em; float: left;">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="mod_cloud_radio" name="mod_bck_srv" onclick="return(false)"/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													CLOUD
												</label>
											</div>

											<div style="margin-top: 3px; float: right;">
												<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button" value='CUSTOM' onclick="fn_mod_custom_popup()" />
											</div>
										</div>
									</div>
								</div>

								<div>
									<div id="mod_remote_opt" style="display: none;">
										<div style="border: 1px solid #adb5bd; margin: -10px 10px 10px 10px;">
											<div style="padding-top:7px;">
												<label for="mod_remt_opt_cd" class="col-sm-2_2 col-form-label pop-label-index" >
													<i class="item-icon fa fa-dot-circle-o"></i>
													스토리지 정보
												</label>

												<div class="d-flex" style="margin-bottom: 10px;">
													<div class="col-sm-2_3">
														<input type="text" class="form-control form-control-xsm" maxlength="50" id="mod_remt_str_ip" name="mod_remt_str_ip" style="width: 250px; height:30px;" placeholder="IP를 입력해주세요" readOnly />
													</div>

													<div class="col-sm-2" style="margin-left: 6px;">
														<input type="text" class="form-control form-control-xsm" maxlength="3" id="mod_remt_str_ssh" name="mod_remt_str_ssh" style="width: 180px; height:30px;" placeholder="SSH 포트" readOnly />
													</div>

													<div class="col-sm-2_3" style="margin-left: -30px;">
														<input type="text" class="form-control form-conftrol-xsm" maxlength="50" id="mod_remt_str_usr" name="mod_remt_str_usr" style="width: 250px; height:30px;" placeholder="OS 유저명을 입력해주세요" readOnly />
													</div>
													
													<div class="col-sm-2_3" style="margin-left: 6px;">
														<input type="password" class="form-control form-control-xsm" maxlength="50" id="mod_remt_str_pw" name="mod_remt_str_pw" style="width: 250px; height:30px;" placeholder="패스워드를 입력해주세요" onchange="pw_chk(this)"/>
													</div>

													<div class="col-sm-1" style="height: 20px; margin-top: 3px;">
														<button id="mod_ssh_conn" type="button" class="btn btn-outline-primary" style="width: 60px;padding: 5px;" onclick="fn_re_ssh_connection()">연결</button>
													</div>
													<div class="col-sm-2_3">
														<div class="alert alert-danger" style="display:none; width: 250px; margin-left: -25px;" id="mod_ssh_con_alert"></div>
													</div>
												</div>

												<!-- Remote 옵션 alert창 -->
												<div class="form-group d-flex div-form-margin-z" style="width: 900px;">
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px;" id="mod_remt_str_ip_alert"></div>
													</div>
													<div class="col-sm-2_5">
														<div class="alert alert-danger" style="display:none; width: 180px; margin-left: -25px;" id="mod_remt_str_ssh_alert"></div>
													</div>
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px; margin-left: -15px;" id="mod_remt_str_usr_alert"></div>
													</div>
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px; margin-left: -40px;" id="mod_remt_str_pw_alert"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div id="mod_cloud_opt" style="display: none;">
										<div style="border: 1px solid #adb5bd; margin: -10px 10px 10px 10px;">
											<div class="d-flex" style="padding-top:7px; ">
												<label for="mod_cld_opt_cd" class="col-sm-1_5 col-form-label pop-label-index" >
													<i class="item-icon fa fa-dot-circle-o"></i>
													클라우드 유형
												</label>

												<div class="col-sm-2_2" style="margin-top: 5px;">
													<select class="form-control form-control-xsm" style="width:120px; color: black;" name="mod_bckr_cld_opt_cd" id="mod_bckr_cld_opt_cd" tabindex=3 >
														<option selected>S3</option>
														<option disabled>Azure</option>
														<option disabled>GCS</option>
													</select>
												</div>
											</div>

											<div class="d-flex">
												<label for="mod_cloud_opt_s3_buk" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-bucket
												</label>

												<div class="col-sm-3">
													<input type="text" class="form-control form-control-xsm" maxlength="120" id="mod_cloud_bckr_s3_buk" name="mod_cloud_bckr_s3_buk" style="width: 270px;" placeholder="S3 Bucket을 입력해주세요" readOnly/>
												</div>

												<label for="mod_cloud_opt_s3_rgn" class="col-sm-1 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
													s3-region
												</label>

												<div class="col-sm-2_8">
													<input type="text" class="form-control form-control-xsm" maxlength="100" id="mod_cloud_bckr_s3_rgn" name="mod_cloud_bckr_s3_rgn" style="width: 240px;" placeholder="S3 Region을 입력해주세요" readOnly/>
												</div>

												<label for="mod_cloud_opt_s3_key" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px; ">
														<i class="item-icon fa fa-dot-circle-o"></i>
													s3-key
												</label>

												<div class="col-sm-2">
													<input type="password" class="form-control form-control-xsm" maxlength="50" id="mod_cloud_bckr_s3_key" name="mod_cloud_bckr_s3_key" style="width: 220px;" placeholder="S3 key를 입력해주세요" readOnly/>
												</div>
											</div>

											<!-- Cloud 옵션 alert창 -->
											<div class="form-group d-flex div-form-margin-z" style="width: 1200px;">
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 430px;" id="mod_cloud_bckr_s3_buk_alert"></div>
												</div>
												
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 355px; margin-left: 15px;" id="mod_cloud_bckr_s3_rgn_alert"></div>
												</div>

												<div class="col-sm-3_5">
													<div class="alert alert-danger" style="display:none; width: 380px; margin-left: -15px;" id="mod_cloud_bckr_s3_key_alert"></div>
												</div>
											</div>

											<div class="d-flex" style="margin-bottom: 10px;">
												<label for="mod_cloud_opt_s3_npt" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-endpoint
												</label>

												<div class="col-sm-3">
													<input type="text" class="form-control form-control-xsm" maxlength="120" id="mod_cloud_bckr_s3_npt" name="mod_cloud_bckr_s3_npt" style="width: 270px;" placeholder="S3 Endpoint를 입력해주세요" readOnly/>
												</div>

												<label for="mod_cloud_opt_s3_pth" class="col-sm-1 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-path
												</label>

												<div class="col-sm-2_8">
													<input type="text" class="form-control form-control-xsm" maxlength="100" id="mod_cloud_bckr_s3_pth" name="mod_cloud_bckr_s3_pth" style="width: 240px;" placeholder="S3 path를 입력해주세요" readOnly/>
												</div>

												<label for="mod_cloud_opt_s3_scrk" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-key-secret
												</label>

												<div class="col-sm-2">
													<input type="password" class="form-control form-control-xsm" maxlength="100" id="mod_cloud_bckr_s3_scrk" name="mod_cloud_bckr_s3_scrk" style="width: 220px;" placeholder="S3 secret Key를 입력해주세요" readOnly/>
												</div>
											</div>

											<!-- Cloud 옵션 alert창 -->
											<div class="form-group d-flex div-form-margin-z" style="width: 1200px;">
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 430px;" id="mod_cloud_bckr_s3_npt_alert"></div>
												</div>

												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 355px; margin-left: 15px;" id="mod_cloud_bckr_s3_pth_alert"></div>
												</div>

												<div class="col-sm-3_5">
													<div class="alert alert-danger" style="display:none; width: 380px; margin-left: -15px;" id="mod_cloud_bckr_s3_scrk_alert"></div>
												</div>
											</div>
										</div>
									</div>

									<div class="d-flex">
										<div class="card-body card-inverse-primary" style="padding:10px 0 10px 0px; width: 900px; margin-left: 10px;">
											<p class="card-text text-xl-center">백업옵션</p>
										</div>

										<div class="card-body card-inverse-primary" style="padding:10px 0 10px 0px; width: 500px; margin: 0 10px 0 60px;">
											<p class="card-text text-xl-center">압축옵션</p>
										</div>
									</div>

									<div class="d-flex">
										<div class="d-flex" style="width: 900px; margin: 20px 10px 0 10px;">
											<!-- 왼쪽 메뉴 -->
											<label for="mod_bckr_opt_cd" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												백업 유형
											</label>

											<div class="col-sm-2_2">
												<select class="form-control form-control-xsm" style="width:120px; color: black;" name="mod_bckr_opt_cd" id="mod_bckr_opt_cd" tabindex=3 >
													<option value=""><spring:message code="common.choice" /></option>
													<option value="TC000301">FULL</option>
													<option value="TC000302">INCR</option>
													<option value="TC000304">DIFF</option>
												</select>
											</div>

											<label id="mod_bck_path_label" for="mod_bckr_opt_path" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 30px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												백업 경로
											</label>

											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" maxlength="100" id="mod_bckr_pth" name="mod_bckr_pth" style="width: 410px;" readonly/>
											</div>
										</div>

										<div class="d-flex" style="width: 500px; margin: 20px 0 0 30px;">
											<!-- 오른쪽 메뉴 -->
											<label for="mod_bckr_cps_yn_chk" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												압축 여부
											</label>

											<div class="col-sm-1_5">
												<div class="onoffswitch-pop" >
													<input type="checkbox" name="mod_bckr_cps_yn_chk" class="onoffswitch-pop-checkbox" id="mod_bckr_cps_yn_chk" checked onchange="mod_backrest_compress_chk()"/>
													<label class="onoffswitch-pop-label" for="mod_bckr_cps_yn_chk">
														<span class="onoffswitch-pop-inner_YN"></span>
														<span class="onoffswitch-pop-switch" ></span>
													</label>
												</div>
											</div>
										</div>
									</div>

									<!-- 기본옵션 alert창 -->
									<div class="form-group d-flex div-form-margin-z" style="width: 900px; margin: 0px 10px 0px 10px;">
										<div class="col-sm-4">
											<div class="alert alert-danger" style="display:none;" id="mod_bckr_opt_cd_alert"></div>
										</div>
										<!-- <div class="col-sm-7" style="margin-left: 40px;">
											<div class="alert alert-danger" style="display:none;" id="mod_bckr_pth_alert"></div>
										</div> -->
									</div>


									<div class="d-flex">
										<div class="d-flex" style="width: 900px; margin: 0px 10px 10px 10px;">
											<!-- 왼쪽 메뉴 -->
											<label for="mod_bckr_opt_cnt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												풀 백업 유지개수
											</label>

											<div class="col-sm-2_2">
												<input type="number" class="form-control form-control-xsm" maxlength="100" id="mod_bckr_cnt" name="mod_bckr_cnt" value="1" min="1" style="width: 120px;" onchange="fn_backrest_chg_alert(this)"/>
											</div>

											<label for="mod_bckr_opt_log_path" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 30px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												로그 경로
											</label>

											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" maxlength="100" id="mod_bckr_log_pth" name="mod_bckr_log_pth" style="width: 410px;" onchange="fn_backrest_chg_alert(this)"/>
											</div>

											<div class="col-sm-1" style="margin-top: -2px;">
												<button type="button" id="mod_log_pth_chk" class="btn btn-inverse-info btn-fw" style="width: 80px; padding: 10px; margin-left: 35px; display:none" onclick="fn_chk_pth(this)"><spring:message code="common.dir_check" /></button>
											</div> 
										</div>

										<div class="d-flex" style="width: 500px; margin: 0px 0px 0 30px;">
											<!-- 오른쪽 메뉴 -->
											<label for="mod_bckr_cps_type" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												압축 타입
											</label>

											<div class="col-sm-3">
												<select class="form-control form-control-xsm" style="width:80px; color: black;" name="mod_cps_opt_type" id="mod_cps_opt_type" tabindex=1>
													<option selected>gzip</option>
													<option>lz4</option>>
												</select>
											</div>

											<label for="mod_bckr_prcs" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 22px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												병렬도
											</label>

											<div class="col-sm-2">
												<input type="number" class="form-control form-control-xsm" maxlength="3" id="mod_cps_opt_prcs" name="mod_cps_opt_prcs" value="1" min="1" style="width: 100px; margin-left: 10px;" onchange="fn_backrest_chg_alert(this)"/>
											</div>
										</div>
									</div>
								</div>

								<!-- 기본옵션 alert창 -->
								<div class="d-flex" style="width: 900px; margin: 0px 10px 0px 10px;">
									<div class="col-sm-4">
										<div class="alert alert-danger" style="display:none;" id="mod_bckr_cnt_alert"></div>
									</div>
									<div class="col-sm-7" style="margin-left: 40px;">
										<div class="alert alert-danger" style="display:none;" id="mod_bckr_log_pth_alert"></div>
									</div>
									<div class="col-sm-4">
									</div>
									<div class="col-sm-3" style="margin-left: 25px;">
										<div class="alert alert-danger" style="display:none; width: 190px;" id="mod_cps_opt_prcs_alert"></div>
									</div>
								</div>
							</div>

							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.modify" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_mod_backrest_cancle()"><spring:message code="common.cancel"/></button>
								</div>
							</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>