<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name :backrestRegForm.jsp
	* @Description : backrest 백업등록 화면
	* @Modification Information
	*
	*/
%>

<script type="text/javascript">
	var svrBckCheck = 'local';
	var selectedAgentServer = null;
	var backrestServerTable = null;
	
	$(window.document).ready(function() {
		
		$("#workRegFormBckr").validate({
	        rules: {
	        	ins_wrk_nm_bckr: {
					required: true
				},
				ins_wrk_exp_bckr: {
					required: true
				}
	        },
	        messages: {
	        	ins_wrk_nm_bckr: {
	        		required: '<spring:message code="message.msg107" />'
				},
				ins_wrk_exp_bckr: {
	        		required: '<spring:message code="message.msg108" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_backrest_insert_work();
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

	function fn_init_backrest_reg_form() {
		backrestServerTable = $('#backrest_svr_info').DataTable({
			scrollY : "110px",
			bSort: false,
			scrollX: false,	
			searching : false,
			paging : false,
			deferRender : true,
			destroy: true,
			columns : [
						{data : "rownum", defaultContent : "", className : "dt-center"}, 
						{data : "master_gbn", className : "dt-center", defaultContent : ""},
						{data : "ipadr", defaultContent : "" },
						{data : "portno", defaultContent: "" },
						{data : "svr_spr_usr_id", defaultContent : ""},
						{data : "pgdata_pth", defaultContent : ""},
						{data : "bck_svr_id", defaultContent : "", visible: false }
			],'select': {'style': 'single'}
		});
		
		backrestServerTable.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		backrestServerTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		backrestServerTable.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		backrestServerTable.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
		backrestServerTable.tables().header().to$().find('th:eq(4)').css('min-width', '170px');
		backrestServerTable.tables().header().to$().find('th:eq(5)').css('min-width', '480px');
		backrestServerTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px');

		$(window).trigger('resize'); 
	}

	$(function() {
		$("#backrest_svr_info").on('click', 'tbody tr', function(){
			$(this).toggleClass('selected');

			selectedAgentServer = backrestServerTable.rows(this).data()[0];
			var words = this.className.split(' ');

			if(words.length == 2){
				$.ajax({
					url : "/backup/backrestPath.do",
					data : {
						db_svr_id : $("#db_svr_id", "#findList").val(),
						ipadr : selectedAgentServer.ipadr
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
						$("#ins_bckr_pth", "#workRegFormBckr").val(data.RESULT_DATA.PGBBAK);
						$("#ins_bckr_log_pth", "#workRegFormBckr").val(data.RESULT_DATA.PGBLOG);
					}
				});
			}else{
				$("#ins_bckr_pth", "#workRegFormBckr").val("");
				$("#ins_bckr_log_pth", "#workRegFormBckr").val("");
			}
		});
	})

	function fn_bck_srv_check(svrBckRadioCheck) {
		var bckSrvLocal = document.getElementById("bck_srv_local_check"); 
		var bckSrvRemote = document.getElementById("bck_srv_remote_check"); 
		var bckSrvCloud = document.getElementById("bck_srv_cloud_check");
		
		if(svrBckCheck !== svrBckRadioCheck){
			fn_bckr_opt_reset();
		}

		svrBckCheck = svrBckRadioCheck;

		if(svrBckRadioCheck == "local"){
			bckSrvLocal.style.backgroundColor = "white"
			bckSrvRemote.style.backgroundColor = "#e7e7e7"
			bckSrvCloud.style.backgroundColor = "#e7e7e7"

			$("#local_radio").prop("checked", true);

			$("#remote_opt").hide();
			$("#cloud_opt").hide();
		}else if(svrBckRadioCheck == "remote"){
			bckSrvLocal.style.backgroundColor = "#e7e7e7"
			bckSrvRemote.style.backgroundColor = "white"
			bckSrvCloud.style.backgroundColor = "#e7e7e7"

			$("#remote_radio").prop("checked", true);

			$("#remote_opt").show();
			$("#cloud_opt").hide();
		}else{
			bckSrvLocal.style.backgroundColor = "#e7e7e7"
			bckSrvRemote.style.backgroundColor = "#e7e7e7"
			bckSrvCloud.style.backgroundColor = "white"

			$("#cloud_radio").prop("checked", true);

			$("#remote_opt").hide();
			$("#cloud_opt").show();
		}
	}

	/* ********************************************************
	 * work명 중복체크
	 ******************************************************** */
	 function fn_ins_worknm_bckr_check() {
		if ($('#ins_wrk_nm_bckr', '#workRegFormBckr').val() == "") {
			showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화
		$("#ins_wrk_nm_bckr_alert", "#workRegFormBckr").html('');
		$("#ins_wrk_nm_bckr_alert", "#workRegFormBckr").hide();
		
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $('#ins_wrk_nm_bckr', '#workRegFormBckr').val()
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
					$('#ins_wrk_nmChk_bckr', '#workRegFormBckr').val("success");
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					$('#ins_wrk_nmChk_bckr', '#workRegFormBckr').val("fail");
				}
			}
		});
	}

	/* ********************************************************
	 * work 명 변경시
	 ******************************************************** */
	 function fn_ins_wrk_bckr_nmChk() {
		$('#ins_wrk_nmChk_bckr', '#workRegFormBckr').val("fail");
		
		$("#ins_wrk_nmChk_bckr_alert", "#workRegFormBckr").html('');
		$("#ins_wrk_nmChk_bckr_alert", "#workRegFormBckr").hide();
	}

	function fn_bckr_opt_reset(){
		//백업옵션 초기화
		$("#ins_bckr_opt_cd", "#workRegFormBckr").val('').prop("selected", true);	//백업유형
		$("#ins_bckr_pth", "#workRegFormBckr").val("");	//백업경로
		$("#ins_bckr_cnt", "#workRegFormBckr").val(2); //풀백업보관일
		$("#ins_bckr_log_pth", "#workRegFormBckr").val("");	//로그경로

		//압축옵션 초기화
		$("input:checkbox[id='ins_bckr_cps_yn_chk']").prop("checked", true); //압축여부
		$("#ins_cps_opt_type", "#workRegFormBckr").val('gzip').prop("selected", true);	//압축타입
		$("#ins_cps_opt_type", "#workRegFormBckr").attr("disabled",false);
		$("#ins_cps_opt_prcs", "#workRegFormBckr").val(1);

		//Remote 옵션 초기화
		$("#ins_remt_str_ip", "#workRegFormBckr").val("");	//IP
		$("#ins_remt_str_ssh", "#workRegFormBckr").val(""); //SSH Port
		$("#ins_remt_str_usr", "#workRegFormBckr").val("");	//User Name
		$("#ins_remt_str_pw", "#workRegFormBckr").val("");	//Password

		//Cloud 옵션 초기화
		$("#ins_bckr_cld_opt_cd", "#workRegFormBckr").val('S3').prop("selected", true);	//Cloud 유형
		$("#ins_cloud_bckr_s3_buk", "#workRegFormBckr").val("");	//s3-bucket
		$("#ins_cloud_bckr_s3_rgn", "#workRegFormBckr").val(""); 	//s3-region
		$("#ins_cloud_bckr_s3_key", "#workRegFormBckr").val("");	//s3-key
		$("#ins_cloud_bckr_s3_npt", "#workRegFormBckr").val("");	//s3-endpoint
		$("#ins_cloud_bckr_s3_pth", "#workRegFormBckr").val("");	//s3-path
		$("#ins_cloud_bckr_s3_scrk", "#workRegFormBckr").val("");	//s3-key-secret

		//기본옵션 alert창 초기화
		$("#ins_bckr_opt_cd_alert", "#workRegFormBckr").html("");
		$("#ins_bckr_opt_cd_alert", "#workRegFormBckr").hide();
		$("#ins_bckr_pth_alert", "#workRegFormBckr").html("");
		$("#ins_bckr_pth_alert", "#workRegFormBckr").hide();
		$("#ins_bckr_cnt_alert", "#workRegFormBckr").html("");
		$("#ins_bckr_cnt_alert", "#workRegFormBckr").hide();
		$("#ins_bckr_log_pth_alert", "#workRegFormBckr").html("");
		$("#ins_bckr_log_pth_alert", "#workRegFormBckr").hide();			
		$("#ins_cps_opt_prcs_alert", "#workRegFormBckr").html("");
		$("#ins_cps_opt_prcs_alert", "#workRegFormBckr").hide();			

		//Remote 옵션 초기화
		$("#ins_remt_str_ip_alert", "#workRegFormBckr").html("");
		$("#ins_remt_str_ip_alert", "#workRegFormBckr").hide();
		$("#ins_remt_str_ssh_alert", "#workRegFormBckr").html("");
		$("#ins_remt_str_ssh_alert", "#workRegFormBckr").hide();
		$("#ins_remt_str_usr_alert", "#workRegFormBckr").html("");
		$("#ins_remt_str_usr_alert", "#workRegFormBckr").hide();
		$("#ins_remt_str_pw_alert", "#workRegFormBckr").html("");
		$("#ins_remt_str_pw_alert", "#workRegFormBckr").hide();				

		//Cloud 옵션 초기화
		$("#ins_cloud_bckr_s3_buk_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_buk_alert", "#workRegFormBckr").hide();
		$("#ins_cloud_bckr_s3_rgn_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_rgn_alert", "#workRegFormBckr").hide();
		$("#ins_cloud_bckr_s3_key_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_key_alert", "#workRegFormBckr").hide();
		$("#ins_cloud_bckr_s3_npt_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_npt_alert", "#workRegFormBckr").hide();
		$("#ins_cloud_bckr_s3_pth_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_pth_alert", "#workRegFormBckr").hide();
		$("#ins_cloud_bckr_s3_scrk_alert", "#workRegFormBckr").html("");
		$("#ins_cloud_bckr_s3_scrk_alert", "#workRegFormBckr").hide();		
		
	}

	//Custom popup
	function fn_reg_custom_popup(){
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
				}
	
				$('#pop_layer_reg_backrest_custom').modal("show");
			}
		});
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function ins_backrest_valCheck(){
		var iChkCnt = 0;

		if($('#backrest_svr_info').DataTable().rows('.selected').data()[0] == undefined){
			showSwalIcon('IP를 선택해주세요.', '<spring:message code="common.close" />', '', 'warning');

			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#ins_wrk_nmChk_bckr", "#workRegFormBckr").val(), "") == "" || nvlPrmSet($("#ins_wrk_nmChk_bckr", "#workRegFormBckr").val(), "") == "fail") {
			$("#ins_wrk_nm_bckr_alert", "#workRegFormBckr").html('<spring:message code="backup_management.work_overlap_check"/>');
			$("#ins_wrk_nm_bckr_alert", "#workRegFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		//기본 옵션 alert
		if(nvlPrmSet($("#ins_bckr_opt_cd", "#workRegFormBckr").val(), "") == "") {
			$("#ins_bckr_opt_cd_alert", "#workRegFormBckr").html('백업유형를 입력해주세요.');
			$("#ins_bckr_opt_cd_alert", "#workRegFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}
		
		if(nvlPrmSet($("#ins_bckr_cnt", "#workRegFormBckr").val(), "") == "") {
			$("#ins_bckr_cnt_alert", "#workRegFormBckr").html('풀 백업 보관일을 입력해주세요.');
			$("#ins_bckr_cnt_alert", "#workRegFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#ins_bckr_log_pth", "#workRegFormBckr").val(), "") == "") {
			$("#ins_bckr_log_pth_alert", "#workRegFormBckr").html('로그경로를 입력해주세요.');
			$("#ins_bckr_log_pth_alert", "#workRegFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#ins_cps_opt_prcs", "#workRegFormBckr").val(), "") == "") {
			$("#ins_cps_opt_prcs_alert", "#workRegFormBckr").html('병렬도를 입력해주세요.');
			$("#ins_cps_opt_prcs_alert", "#workRegFormBckr").show();
			
			iChkCnt = iChkCnt + 1;
		}

		//Remote 옵션 alert
		if(svrBckCheck == "remote"){
			if(nvlPrmSet($("#ins_remt_str_ip", "#workRegFormBckr").val(), "") == "") {
				$("#ins_remt_str_ip_alert", "#workRegFormBckr").html('아이피를 입력해주세요.');
				$("#ins_remt_str_ip_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_remt_str_ssh", "#workRegFormBckr").val(), "") == "") {
				$("#ins_remt_str_ssh_alert", "#workRegFormBckr").html('포트를 입력해주세요.');
				$("#ins_remt_str_ssh_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_remt_str_usr", "#workRegFormBckr").val(), "") == "") {
				$("#ins_remt_str_usr_alert", "#workRegFormBckr").html('유저명을 입력해주세요.');
				$("#ins_remt_str_usr_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_remt_str_pw", "#workRegFormBckr").val(), "") == "") {
				$("#ins_remt_str_pw_alert", "#workRegFormBckr").html('패스워드를 입력해주세요.');
				$("#ins_remt_str_pw_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
		}

		//Cloud 옵션 alert
		if(svrBckCheck == "cloud"){
			if(nvlPrmSet($("#ins_cloud_bckr_s3_buk", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_buk_alert", "#workRegFormBckr").html('s3 bucket을 입력해주세요.');
				$("#ins_cloud_bckr_s3_buk_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_cloud_bckr_s3_rgn", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_rgn_alert", "#workRegFormBckr").html('s3 region을 입력해주세요.');
				$("#ins_cloud_bckr_s3_rgn_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_cloud_bckr_s3_key", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_key_alert", "#workRegFormBckr").html('s3 key를 입력해주세요.');
				$("#ins_cloud_bckr_s3_key_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
			
			if(nvlPrmSet($("#ins_cloud_bckr_s3_npt", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_npt_alert", "#workRegFormBckr").html('s3 endpoint을 입력해주세요.');
				$("#ins_cloud_bckr_s3_npt_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_cloud_bckr_s3_pth", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_pth_alert", "#workRegFormBckr").html('s3 경로를 입력해주세요.');
				$("#ins_cloud_bckr_s3_pth_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}

			if(nvlPrmSet($("#ins_cloud_bckr_s3_scrk", "#workRegFormBckr").val(), "") == "") {
				$("#ins_cloud_bckr_s3_scrk_alert", "#workRegFormBckr").html('s3 secrey key를 입력해주세요.');
				$("#ins_cloud_bckr_s3_scrk_alert", "#workRegFormBckr").show();
				
				iChkCnt = iChkCnt + 1;
			}
		}

		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}

	//압축여부에 따라 압축타입 활성화 비활성화
	function ins_backrest_compress_chk(){
		if($('#ins_bckr_cps_yn_chk').is(':checked')){
			$("#ins_cps_opt_type", "#workRegFormBckr").attr("disabled",false);
        }else{
			$("#ins_cps_opt_type", "#workRegFormBckr").attr("disabled",true);
		}
	}

	//alert창 onchange
	function fn_backrest_chg_alert(obj){
		$("#"+obj.id+"_alert", "#workRegFormBckr").html("");
		$("#"+obj.id+"_alert", "#workRegFormBckr").hide();
	}

	function fn_select_agent_info(){
		$.ajax({
			url : "/backup/backrestAgentList.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				ipadr : nvlPrmSet($('#ipadr', '#workRegFormBckr').val(), "")
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
				backrestServerTable.rows({selected: true}).deselect();
				backrestServerTable.clear().draw();

				if (nvlPrmSet(data, "") != '') {
					backrestServerTable.rows.add(data['agent_list']).draw();
				}
			}
		});
	}

	//PG Backrest Work 등록
	function fn_backrest_insert_work(){
		if (!ins_backrest_valCheck()) return false;

		if($("#ins_bckr_cps_yn_chk", "#workRegFormBckr").is(":checked") == true){
			$("#ins_cps_brkr_yn", "#workRegFormBckr").val("Y");
		} else {
			$("#ins_cps_brkr_yn", "#workRegFormBckr").val("N");
		}

		var selectedAgent = $('#backrest_svr_info').DataTable().rows('.selected').data()[0];
		var custom_data = JSON.stringify(Object.fromEntries(custom_map))

		$.ajax({
			async : false,
			url : "/popup/workBackrestWrite.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_nm : nvlPrmSet($('#ins_wrk_nm_bckr', '#workRegFormBckr').val(), "").trim(),
				wrk_exp : nvlPrmSet($('#ins_wrk_exp_bckr', '#workRegFormBckr').val(), ""),
				cps_yn : $("#ins_cps_brkr_yn", "#workRegFormBckr").val(),
				bck_opt_cd : $("#ins_bckr_opt_cd", '#workRegFormBckr').val(),
				bck_mtn_ecnt : $("#ins_bckr_cnt", '#workRegFormBckr').val(),
				db_id : 0,
				bck_bsn_dscd : "TC000205",
				bck_pth : $("#ins_bckr_pth", "#workRegFormBckr").val(),
				log_file_pth : $("#ins_bckr_log_pth", "#workRegFormBckr").val(),
				bck_filenm : ($('#ins_wrk_nm_bckr', '#workRegFormBckr').val()) + ".conf",
				prcs_cnt: $("#ins_cps_opt_prcs", "#workRegFormBckr").val(),
				cps_type: $("#ins_cps_opt_type", "#workRegFormBckr").val(),
				ipadr: selectedAgent.ipadr,
				pgdata_pth: selectedAgent.pgdata_pth,
				portno: selectedAgent.portno,
				svr_spr_usr_id: selectedAgent.svr_spr_usr_id,
				master_gbn: selectedAgent.master_gbn,
				db_svr_ipadr_id: selectedAgent.db_svr_ipadr_id,
				backrest_gbn: svrBckCheck,
				custom_map: custom_data
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
					$('#pop_layer_reg_backrest').modal('show');
					return;
				} else if(data == "S"){
					showSwalIcon('<spring:message code="message.msg106" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_reg_backrest').modal('hide');
					fn_get_backrest_list();
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_reg_backrest').modal('show');
					return;
				}
			}
		});
	}

	function fn_backrest_ip_select_check(){
		var selectedIp = $('#backrest_svr_info').DataTable().rows('.selected').data()[0]

		if(selectedIp == undefined){
			showSwalIcon('IP를 선택해주세요.', '<spring:message code="common.close" />', '', 'warning');
		}
	}

</script>

<%@include file="../popup/backrestRegCustomForm.jsp"%>

<form name="search_backrestRegForm" id="search_backrestReForm" method="post">
	<input type="hidden" name="backrest_call_gbn"  id="backrest_call_gbn" value="" />
</form>

<div class="modal fade" id="pop_layer_reg_backrest" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 10px 110px;">
		<div class="modal-content" style="width:1500px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					PG Backrest 백업등록
				</h4>
				
				<div class="card system-tlb-scroll" style="margin-top:10px;border:0px;height:910px;overflow-y:auto;">
					<form class="cmxform" id="workRegFormBckr">
						<input type="hidden" name="ins_check_path3" id="ins_check_path3" value="N"/>
						<input type="hidden" name="ins_wrk_nmChk_bckr" id="ins_wrk_nmChk_bckr" value="fail" />
						<input type="hidden" name="ins_cps_brkr_yn" id="ins_cps_brkr_yn" value="" />

						<br>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_nm_bckr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>

									<div class="col-sm-8">
										<input type="text" class="form-control form-control-sm" maxlength="20" id="ins_wrk_nm_bckr" name="ins_wrk_nm_bckr" placeholder="20<spring:message code='message.msg188'/>" onchange="fn_ins_wrk_bckr_nmChk();" onblur="this.value=this.value.trim()" tabindex=1 required />
									</div>

									<div class="col-sm-2">
										<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_ins_worknm_bckr_check()"><spring:message code="common.overlap_check" /></button>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2">
									</div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:5px;display:none; width: 1062px;" id="ins_wrk_nm_bckr_alert"></div>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_exp_bckr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="ins_wrk_exp_bckr" name="ins_wrk_exp_bckr" rows="2" maxlength="200" onkeyup="fn_checkWord(this,25)" placeholder="200<spring:message code='message.msg188'/>" required tabindex=2></textarea>
									</div>
								</div>
							</div>
							
							<br/>

							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<div class="input-group mb-2 mr-sm-2 col-sm-2">
										<input hidden="hidden" />
										<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="25" id="ipadr" name="ipadr" onblur="this.value=this.value.trim()" placeholder='아이피를 입력해주세요' />
									</div>

									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_select_agent_info()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
									</button>
									
									<div class="col-12" id="backrest_svr_info_div" style="diplay:none;">
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
										   
								   		<table id="backrest_svr_info" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="30" class="dt-center"><spring:message code="common.no" /></th>
													<th width="150" class="dt-center">유형</th>
													<th width="200">IP</th>
													<th width="150">PORT</th>
													<th width="170">USER</th>
													<th width="480">DATA_PATH</th>
													<th width="0"></th>
												</tr>
											</thead>
										</table>
									</div>

									<div class="col-sm-0_5" style="display:none;" id="center_div" >
										<div class="card" style="background-color: transparent !important;border:0px;top:30%;position: inline-block;">
											<div class="card-body" style="" onclick="fn_schedule_leftListSize();">	
												<i class='fa fa-angle-double-right text-info' style="font-size: 35px;cursor:pointer;"></i>
											</div>
										</div>
									</div>
								</div>
							</div>

							</br>
							
							<div style="border: 1px solid #adb5bd;">
								<div class="card-body">
									<div class="form-group row div-form-margin-z">
										<div class="col-12" style="background-color: #e7e7e7; height: 50px;">
											<div id="bck_srv_local_check" style="background-color:white; width: 120px; padding-left: 5px; height: 40px; margin-top: 10px; border-radius: 0.4em; float: left;" onclick="fn_bck_srv_check('local')">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="local_radio" name="bck_srv" checked/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													LOCAL
												</label>
											</div>

											<div id="bck_srv_remote_check" style="background-color: #e7e7e7; width: 130px; padding-left: 5px; height: 40px; margin: 10px 0 0 25px; border-radius: 0.4em; float: left;" onclick="fn_bck_srv_check('remote')">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="remote_radio" name="bck_srv"/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													REMOTE
												</label>
											</div>

											<div id="bck_srv_cloud_check" style="background-color: #e7e7e7; width: 120px; padding-left: 5px; height: 40px; margin: 10px 0 0 30px; border-radius: 0.4em; float: left;" onclick="fn_bck_srv_check('cloud')">
												<input type="radio" class="form-control" style="width: 20px; margin-left: 10px;" id="cloud_radio" name="bck_srv"/>
												<label style="margin: -35px 0 0 35px; font-size: 1.2em;">
													CLOUD
												</label>
											</div>

											<div style="margin-top: 3px; float: right;">
												<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button" value='CUSTOM' onclick="fn_reg_custom_popup()" />
											</div>
										</div>
									</div>
								</div>

								<div>
									<div id="remote_opt" style="display: none;">
										<div style="border: 1px solid #adb5bd; margin: -10px 10px 10px 10px;">
											<div style="padding-top:7px;">
												<label for="ins_remt_opt_cd" class="col-sm-2_2 col-form-label pop-label-index" >
													<i class="item-icon fa fa-dot-circle-o"></i>
													스토리지 정보
												</label>

												<div class="d-flex" style="margin-bottom: 10px;">
													<div class="col-sm-2_3">
														<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_remt_str_ip" name="ins_remt_str_ip" style="width: 250px;" placeholder="IP를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
													</div>

													<div class="col-sm-2" style="margin-left: 6px;">
														<input type="text" class="form-control form-control-xsm" maxlength="3" id="ins_remt_str_ssh" name="ins_remt_str_ssh" style="width: 180px;" placeholder="SSH 포트" onchange="fn_backrest_chg_alert(this)"/>
													</div>

													<div class="col-sm-2_3" style="margin-left: -30px;">
														<input type="text" class="form-control form-control-xsm" maxlength="50" id="ins_remt_str_usr" name="ins_remt_str_usr" style="width: 250px;" placeholder="유저 명을 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
													</div>
													
													<div class="col-sm-2_3" style="margin-left: 6px;">
														<input type="password" class="form-control form-control-xsm" maxlength="50" id="ins_remt_str_pw" name="ins_remt_str_pw" style="width: 250px;" placeholder="패스워드를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
													</div>

													<div class="col-sm-2" style="height: 20px; margin-top: 3px;">
														<button type="button" class="btn btn-outline-primary" style="width: 60px;padding: 5px;">연결</button>
													</div>
												</div>

												<!-- Remote 옵션 alert창 -->
												<div class="form-group d-flex div-form-margin-z" style="width: 900px;">
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px;" id="ins_remt_str_ip_alert"></div>
													</div>
													<div class="col-sm-2_5">
														<div class="alert alert-danger" style="display:none; width: 180px; margin-left: -25px;" id="ins_remt_str_ssh_alert"></div>
													</div>
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px; margin-left: -15px;" id="ins_remt_str_usr_alert"></div>
													</div>
													<div class="col-sm-4">
														<div class="alert alert-danger" style="display:none; width: 250px; margin-left: -40px;" id="ins_remt_str_pw_alert"></div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div id="cloud_opt" style="display: none;">
										<div style="border: 1px solid #adb5bd; margin: -10px 10px 10px 10px;">
											<div class="d-flex" style="padding-top:7px; ">
												<label for="ins_cld_opt_cd" class="col-sm-1_5 col-form-label pop-label-index" >
													<i class="item-icon fa fa-dot-circle-o"></i>
													클라우드 유형
												</label>

												<div class="col-sm-2_2" style="margin-top: 5px;">
													<select class="form-control form-control-xsm" style="width:120px; color: black;" name="ins_bckr_cld_opt_cd" id="ins_bckr_cld_opt_cd" tabindex=3>
														<option selected>S3</option>
														<option>Azure</option>
														<option>GCS</option>
													</select>
												</div>
											</div>

											<div class="d-flex">
												<label for="ins_cloud_opt_s3_buk" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-bucket
												</label>

												<div class="col-sm-3">
													<input type="text" class="form-control form-control-xsm" maxlength="120" id="ins_cloud_bckr_s3_buk" name="ins_cloud_bckr_s3_buk" style="width: 270px;" placeholder="S3 Bucket을 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>

												<label for="ins_cloud_opt_s3_rgn" class="col-sm-1 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
													s3-region
												</label>

												<div class="col-sm-2_8">
													<input type="text" class="form-control form-control-xsm" maxlength="100" id="ins_cloud_bckr_s3_rgn" name="ins_cloud_bckr_s3_rgn" style="width: 240px;" placeholder="S3 Region을 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>

												<label for="ins_cloud_opt_s3_key" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px; ">
														<i class="item-icon fa fa-dot-circle-o"></i>
													s3-key
												</label>

												<div class="col-sm-2">
													<input type="password" class="form-control form-control-xsm" maxlength="50" id="ins_cloud_bckr_s3_key" name="ins_cloud_bckr_s3_key" style="width: 220px;" placeholder="S3 key를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>
											</div>

											<!-- Cloud 옵션 alert창 -->
											<div class="form-group d-flex div-form-margin-z" style="width: 1200px;">
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 430px;" id="ins_cloud_bckr_s3_buk_alert"></div>
												</div>
												
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 355px; margin-left: 15px;" id="ins_cloud_bckr_s3_rgn_alert"></div>
												</div>

												<div class="col-sm-3_5">
													<div class="alert alert-danger" style="display:none; width: 380px; margin-left: -15px;" id="ins_cloud_bckr_s3_key_alert"></div>
												</div>
											</div>

											<div class="d-flex" style="margin-bottom: 10px;">
												<label for="ins_cloud_opt_s3_npt" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-endpoint
												</label>

												<div class="col-sm-3">
													<input type="text" class="form-control form-control-xsm" maxlength="120" id="ins_cloud_bckr_s3_npt" name="ins_cloud_bckr_s3_npt" style="width: 270px;" placeholder="S3 Endpoint를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>

												<label for="ins_cloud_opt_s3_pth" class="col-sm-1 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-path
												</label>

												<div class="col-sm-2_8">
													<input type="text" class="form-control form-control-xsm" maxlength="100" id="ins_cloud_bckr_s3_pth" name="ins_cloud_bckr_s3_pth" style="width: 240px;" placeholder="S3 path를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>

												<label for="ins_cloud_opt_s3_scrk" class="col-sm-1_5 col-form-label pop-label-index" style="padding-top:7px;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													s3-key-secret
												</label>

												<div class="col-sm-2">
													<input type="password" class="form-control form-control-xsm" maxlength="50" id="ins_cloud_bckr_s3_scrk" name="ins_cloud_bckr_s3_scrk" style="width: 220px;" placeholder="S3 secret Key를 입력해주세요" onchange="fn_backrest_chg_alert(this)"/>
												</div>
											</div>

											<!-- Cloud 옵션 alert창 -->
											<div class="form-group d-flex div-form-margin-z" style="width: 1200px;">
												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 430px;" id="ins_cloud_bckr_s3_npt_alert"></div>
												</div>

												<div class="col-sm-5">
													<div class="alert alert-danger" style="display:none; width: 355px; margin-left: 15px;" id="ins_cloud_bckr_s3_pth_alert"></div>
												</div>

												<div class="col-sm-3_5">
													<div class="alert alert-danger" style="display:none; width: 380px; margin-left: -15px;" id="ins_cloud_bckr_s3_scrk_alert"></div>
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
											<label for="ins_bckr_opt_cd" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												백업 유형
											</label>

											<div class="col-sm-2_2">
												<select class="form-control form-control-xsm" style="width:120px; color: black;" name="ins_bckr_opt_cd" id="ins_bckr_opt_cd" tabindex=3 onchange="fn_backrest_chg_alert(this)" onclick="fn_backrest_ip_select_check()">
													<option value=""><spring:message code="common.choice" /></option>
													<option value="TC000301">FULL</option>
													<option value="TC000302">INCR</option>
													<option value="TC000304">DIFF</option>
												</select>
											</div>

											<label for="ins_bckr_opt_path" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 30px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												백업 경로
											</label>

											<div class="col-sm-5">
												<input type="text" class="form-control form-control-xsm" maxlength="100" id="ins_bckr_pth" name="ins_bckr_pth" style="width: 400px;" readonly/>
											</div>

											<!-- <div class="col-sm-2" style="margin-top: -2px;">
												<button type="button" class="btn btn-inverse-info btn-fw" style="width: 100px; padding: 10px;"><spring:message code="common.dir_check" /></button>
											</div> -->
										</div>

										<div class="d-flex" style="width: 500px; margin: 20px 0 0 30px;">
											<!-- 오른쪽 메뉴 -->
											<label for="ins_bckr_cps_yn" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												압축 여부
											</label>

											<div class="col-sm-1_5">
												<div class="onoffswitch-pop" >
													<input type="checkbox" name="ins_bckr_cps_yn_chk" class="onoffswitch-pop-checkbox" id="ins_bckr_cps_yn_chk" checked onchange="ins_backrest_compress_chk()" onclick="fn_backrest_ip_select_check()"/>
													<label class="onoffswitch-pop-label" for="ins_bckr_cps_yn_chk">
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
											<div class="alert alert-danger" style="display:none;" id="ins_bckr_opt_cd_alert"></div>
										</div>
										<div class="col-sm-7" style="margin-left: 40px;">
											<div class="alert alert-danger" style="display:none;" id="ins_bckr_pth_alert"></div>
										</div>
									</div>


									<div class="d-flex">
										<div class="d-flex" style="width: 900px; margin: 0px 10px 10px 10px;">
											<!-- 왼쪽 메뉴 -->
											<label for="ins_bckr_opt_cnt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												풀 백업 유지개수
											</label>

											<div class="col-sm-2_2">
												<input type="number" class="form-control form-control-xsm" maxlength="100" id="ins_bckr_cnt" name="ins_bckr_cnt" value="2" min="2" style="width: 120px;" onchange="fn_backrest_chg_alert(this)" onclick="fn_backrest_ip_select_check()"/>
											</div>

											<label for="ins_bckr_opt_log_path" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 30px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												로그 경로
											</label>

											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" maxlength="100" id="ins_bckr_log_pth" name="ins_bckr_log_pth" style="width: 280px;" onchange="fn_backrest_chg_alert(this)" onclick="fn_backrest_ip_select_check()"/>
											</div>

											<div class="col-sm-2" style="margin-top: -2px;">
												<button type="button" class="btn btn-inverse-info btn-fw" style="width: 100px; padding: 10px;"><spring:message code="common.dir_check" /></button>
											</div>
										</div>

										<div class="d-flex" style="width: 500px; margin: 0px 0px 0 30px;">
											<!-- 오른쪽 메뉴 -->
											<label for="ins_bckr_cps_type" class="col-sm-3 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												압축 타입
											</label>

											<div class="col-sm-3">
												<select class="form-control form-control-xsm" style="width:80px; color: black;" name="ins_cps_opt_type" id="ins_cps_opt_type" tabindex=1 onclick="fn_backrest_ip_select_check()">
													<option selected>gzip</option>
													<option>lz4</option>>
												</select>
											</div>

											<label for="ins_bckr_prcs" class="col-sm-1_8 col-form-label pop-label-index" style="padding-top:7px; margin-left: 22px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												병렬도
											</label>

											<div class="col-sm-2">
												<input type="number" class="form-control form-control-xsm" maxlength="3" id="ins_cps_opt_prcs" name="ins_cps_opt_prcs" value="1" min="1" style="width: 100px; margin-left: 10px;" onchange="fn_backrest_chg_alert(this)" onclick="fn_backrest_ip_select_check()"/>
											</div>
										</div>
									</div>
								</div>

								<!-- 기본옵션 alert창 -->
								<div class="d-flex" style="width: 900px; margin: 0px 10px 0px 10px;">
									<div class="col-sm-4">
										<div class="alert alert-danger" style="display:none;" id="ins_bckr_cnt_alert"></div>
									</div>
									<div class="col-sm-7" style="margin-left: 40px;">
										<div class="alert alert-danger" style="display:none;" id="ins_bckr_log_pth_alert"></div>
									</div>
									<div class="col-sm-4">
									</div>
									<div class="col-sm-3" style="margin-left: 25px;">
										<div class="alert alert-danger" style="display:none; width: 190px;" id="ins_cps_opt_prcs_alert"></div>
									</div>
								</div>
							</div>

							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.registory" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>