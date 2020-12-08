<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : dumpRestoreRegVeiw.jsp
	* @Description : 덤프복원 등록화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.09     최초 생성
	*
	* author 변승우 대리
	* since 2019.01.09
	*
	*/
%>

<script>
	/* ********************************************************
	 * Data initialization
	 ******************************************************** */
	$(window.document).ready(function() {
		var returnYn = nvlPrmSet($("#returnYn", "#findList").val(), "");
		if(returnYn == "" || returnYn != "Y") {
			$("#btnGoList").hide();
		}
	
		//내역조회
		fn_mainSearch();

		//validate
 	    $("#restoreDumpRegForm").validate({
		        rules: {
		        	restore_nm: {
					required: true
				},
				restore_exp: {
					required: true
				},
				db_nm: {
					required: true
				}
	        },
	        messages: {
	        	restore_nm: {
	        		required: '<spring:message code="restore.msg01" />'
				},
				restore_exp: {
	        		required: '<spring:message code="restore.msg03" />'
				},
				db_nm: {
					required: '<spring:message code="backup_management.bck_database_choice" />'
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
	
	/* ********************************************************
	 * 내역조회
	 ******************************************************** */
	function fn_mainSearch(){
		$.ajax({
			url : "/selectBckInfo.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				exe_sn : $("#exe_sn", "#findList").val(),
				wrk_id : $("#wrk_id", "#findList").val(),
				bck_wrk_id : $("#bck_wrk_id", "#findList").val()
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
				if (result.workBckInfo != null) {
					fn_data_setting(result);
				} else {
					showDangerToast('top-right', '<spring:message code="restore.msg04" />', '<spring:message code="restore.msg05" />');
					
					//설치안된경우 버튼 막아야함
					$("#btnScheduleRun").prop("disabled", "disabled");
					$("#btnRestoreCheck", "#restoreDumpRegForm").prop("disabled", "disabled");
				}
			}
		});
	}

	/* ********************************************************
	 * 덤프복원 리스트로 이동
	 ******************************************************** */
	function fn_goList(){
		$("#findList").attr("action", "/dumpRestore.do");
		$("#findList").submit();
	}

	/* ********************************************************
	 * 데이터 셋팅
	 ******************************************************** */
	function fn_data_setting(result) {
		$("#wrk_nm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].wrk_nm, "")); 						//work 명
		$("#exe_rslt_cd_nm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].exe_rslt_cd_nm, "")); 		//상태
		$("#ipadr", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].ipadr, "")); 						//DBMS아이피
		$("#bck_file_pth", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].bck_file_pth, "")); 			//백업파일경로
		$("#bck_filenm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].bck_filenm, ""));				//백업경로
		$("#wrk_strt_dtm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].wrk_strt_dtm, ""));			//작업시작시간
		$("#wrk_end_dtm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].wrk_end_dtm, ""));				//작업종료시간
		$("#file_fmt_cd", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].file_fmt_cd, ""));				//파일포맷
		$("#file_fmt_cd_nm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].file_fmt_cd_nm, ""));		//파일포맷명
		$("#usr_role_nm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].usr_role_nm, ""));				//Rolename

		$("#db_nm", "#restoreDumpRegForm").val(nvlPrmSet(result.workBckInfo[0].db_nm, ""));							//Database

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
		
		mode_workObj = workList;
		
		fn_dump_checkSection();

		//트리셋팅
		setTimeout("fn_get_object_list()", 100);
	}

	/* ********************************************************
	 * 부가옵션 Section 선택 시
	 ******************************************************** */
	function fn_dump_checkSection(){
		var check = false;
		$("input[name=dump_opt]").each(function(){
			if( ($(this).attr("opt_cd") == "TC000601" || $(this).attr("opt_cd") == "TC000602" || $(this).attr("opt_cd") == "TC000603") && $(this).is(":checked")){
				check = true;
			}
		});
		$("input[name=dump_opt]").each(function(){
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
	 * Object형태 중 Only data, Only Schema 중 1개만 체크가능
	 ******************************************************** */
	function fn_dump_checkObject(code){
		var check1 = false;
		var check2 = false;

		$("input[name=dump_opt]").each(function(){
			if(code == "TC000701" && $(this).attr("opt_cd") == "TC000701" && $(this).is(":checked") ){
				check1 = true;
			}else if(code == "TC000702" && $(this).attr("opt_cd") == "TC000702" && $(this).is(":checked") ){
				check2 = true;
			}
		});

		$("input[name=dump_opt]").each(function(){
			if(check1 && code == "TC000701" && $(this).attr("opt_cd") == "TC000702"){
				$(this).prop("checked", false); 
			}else if(check2 && code == "TC000702" && $(this).attr("opt_cd") == "TC000701"){
				$(this).prop("checked", false); 
			}
		});
	}

	/* ********************************************************
	 * Get Selected Database`s Object List
	 ******************************************************** */
	function fn_get_object_list(){
 		var db_nm = nvlPrmSet($("#db_nm option:selected", "#restoreDumpRegForm").text(), "");
		var db_id = nvlPrmSet($("#db_nm option:selected", "#restoreDumpRegForm").val(), "");
		
		if (db_nm == "" || db_id == "") {
			$("#treeview").html("");
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				if (data != null) {
					fn_make_object_list(data);
				} else {
					$("#treeview").html("");
				}
			}
		});
	}
	
	/* ********************************************************
	 * Make Object Tree
	 ******************************************************** */
	function fn_make_object_list(data){
		var html = "<br/><ul id='treeview' class='hummingbird-base'>";
		var schema = "";
		var schemaCnt = 0;
		var checkStr = "";

		$(data.data).each(function (index, item) {
			var inSchema = item.schema;

			if(schemaCnt > 0 && schema != inSchema){
				html += "</ul></li>\n";
			}

			if(schema != inSchema){
				if (mode_workObj.length > 0) {
					for(var i=0;i<mode_workObj.length;i++){
						if(mode_workObj[i].scm_nm == item.schema && mode_workObj[i].obj_nm == "") checkStr = " checked";
					}
				}

				html += "<li>\n";
				html += "<i class='fa fa-minus'></i>\n";
				html += "<label for='schema"+schemaCnt+"'> <input id='schema"+schemaCnt+"' name='tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"' data-id='custom-0' type='checkbox' "+ checkStr +"> "+item.schema+"</label>\n";
				html += '<ul style="display: block;">\n';
			}

			checkStr = "";

			if (mode_workObj.length > 0) {
				for(var i=0;i<mode_workObj.length;i++){
					if(mode_workObj[i].scm_nm == item.schema && mode_workObj[i].obj_nm == item.name) checkStr = " checked";
				}
			}

			html += "<li style='padding-left:20px;'>";
			html += "<label for='table"+index+"'> <input id='table"+index+"' name='tree' value='"+item.name+"' otype='table' schema='"+item.schema+"' data-id='custom-1' type='checkbox' "+checkStr+">  "+item.name+"</label></li>\n";

			if(schema != inSchema){
				schema = inSchema;
				schemaCnt++;
			}
		});
		if(schemaCnt > 0) html += "</ul></li>";
		html += "</ul>";

		$("#treeview_container", "#restoreDumpRegForm").html("");
		$("#treeview_container", "#restoreDumpRegForm").html(html);

		$("#treeview", "#restoreDumpRegForm").hummingbird();
	}

	/* ********************************************************
	 * 쿼리에서 Use Column Inserts, Use Insert Commands선택시 "OIDS포함" disabled
	 ******************************************************** */
	function fn_dump_checkOid(){
		var check = false;
		$("input[name=dump_opt]").each(function(){
			if( ($(this).attr("opt_cd") == "TC000901" || $(this).attr("opt_cd") == "TC000902") && $(this).is(":checked")){
				check = true;
			}
		});
		
		$("input[name=dump_opt]").each(function(){
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
	 * 복구명 중복체크
	 ******************************************************** */
	function fn_restoreNm_check() {
		if (nvlPrmSet($("#restore_nm", "#restoreDumpRegForm").val(), "") == "") {
			showSwalIcon('<spring:message code="restore.msg01" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}
		
		//msg 초기화restoreTimeRegForm
		$("#restorenm_check_alert", "#restoreDumpRegForm").html('');
		$("#restorenm_check_alert", "#restoreDumpRegForm").hide();
		
		$.ajax({
			url : '/restore_nmCheck.do',
			type : 'post',
			data : {
				restore_nm : $("#restore_nm", "#restoreDumpRegForm").val()
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
					$('#restore_nmChk', '#restoreDumpRegForm').val("success");
				} else {
					showSwalIcon('<spring:message code="restore.msg222" />', '<spring:message code="common.close" />', '', 'error');
					$('#restore_nmChk', '#restoreDumpRegForm').val("fail");
				}
			}
		});
	}
	
	/* ********************************************************
	 * work 명 변경시
	 ******************************************************** */
	function fn_restoreNm_Chg() {
		$('#restore_nmChk', '#restoreDumpRegForm').val("fail");
		
		$("#restorenm_check_alert", "#restoreDumpRegForm").html('');
		$("#restorenm_check_alert", "#restoreDumpRegForm").hide();
	}

	/* ********************************************************
	 * 덤프복원 실행 클릭
	 ******************************************************** */
	function fn_restore_start() {
		$("#restoreDumpRegForm").submit();
	}
	
	/* ********************************************************
	 * 덤프복원 validate 체크
	 ******************************************************** */
	function fn_restore_validate() {
		if(nvlPrmSet($("#restore_nmChk", "#restoreDumpRegForm").val(), "") == "" || nvlPrmSet($("#restore_nmChk", "#restoreDumpRegForm").val(), "") == "fail") {
			$("#restorenm_check_alert", "#restoreDumpRegForm").html('<spring:message code="restore.msg02"/>');
			$("#restorenm_check_alert", "#restoreDumpRegForm").show();
			
			return;
		}
		
		fn_passwordConfilm('dump');
	}
	 
	/* ********************************************************
	 * DUMP Restore 정보 저장
	 ******************************************************** */
	function fn_execute() {
		$("input[name=dump_opt]").each(function(){
			if( $(this).is(":checked")){
				$(this).val("Y");
			}
		});

		var scm_nm_List = [];
		var obj_nm_List = [];
		$("input[name=tree]").each(function(){
			if( $(this).is(":checked")){
				scm_nm_List.push($(this).attr("schema"));
				
				if ($(this).attr("otype") != null && $(this).attr("otype") != "table") {
					obj_nm_List.push("");
				} else {
					obj_nm_List.push($(this).val());
				}
			}
		});

		$.ajax({
			url : "/insertDumpRestore.do",
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				bck_file_pth : $("#bck_file_pth", "#restoreDumpRegForm").val(),
				restore_nm : nvlPrmSet($("#restore_nm", "#restoreDumpRegForm").val(), ""),
				restore_exp : $("#restore_exp", "#restoreDumpRegForm").val(),
				wrk_id : $("#wrk_id", "#findList").val(),
				wrkexe_sn : $("#exe_sn", "#findList").val(),
				restore_cndt : 1,
				format : $("#file_fmt_cd_nm", "#restoreDumpRegForm").val(),
				filename : $("#bck_filenm", "#restoreDumpRegForm").val(),
				jobs : $("#jobs", "#restoreDumpRegForm").val(),
				role : $("#usr_role_nm", "#restoreDumpRegForm").val(),
				pre_data_yn : $("#dump_option_1_1", "#restoreDumpRegForm").val(),
				data_yn : $("#dump_option_1_2", "#restoreDumpRegForm").val(),
				post_data_yn : $("#dump_option_1_3", "#restoreDumpRegForm").val(),

				data_only_yn : $("#dump_option_2_1", "#restoreDumpRegForm").val(),
				schema_only_yn : $("#dump_option_2_2", "#restoreDumpRegForm").val(),
				/* blobs_only_yn : $("#dump_option_2_3", "#restoreDumpRegForm").val(), //추가 */
				
				blobs_only_yn : 'N', //추가
				
				
				no_owner_yn : $("#dump_option_3_1", "#restoreDumpRegForm").val(),
				no_privileges_yn : $("#dump_option_3_2", "#restoreDumpRegForm").val(),
				no_tablespaces_yn : $("#dump_option_3_3", "#restoreDumpRegForm").val(),
				no_unlogged_table_data_yn : $("#dump_option_3_4", "#restoreDumpRegForm").val(), //추가

				use_column_inserts_yn : $("#dump_option_4_1", "#restoreDumpRegForm").val(),  //추가
				use_column_commands_yn : $("#dump_option_4_2", "#restoreDumpRegForm").val(), //추가
				create_yn : $("#dump_option_4_3", "#restoreDumpRegForm").val(),
				//drop_database_include_yn : $("#dump_option_4_4", "#restoreDumpRegForm").val(), //추가
				clean_yn : $("#dump_option_4_5", "#restoreDumpRegForm").val(),
				single_transaction_yn : $("#dump_option_4_6", "#restoreDumpRegForm").val(),

				disable_triggers_yn : $("#dump_option_5_1", "#restoreDumpRegForm").val(),
				no_data_for_failed_tables_yn : $("#dump_option_5_2", "#restoreDumpRegForm").val(),

				oids_yn : $("#dump_option_6_1", "#restoreDumpRegForm").val(), //추가
				verbose_yn : $("#dump_option_6_2", "#restoreDumpRegForm").val(),
				//quote_yn : $("#dump_option_6_2", "#restoreDumpRegForm").val(), //추가
				identifier_quotes_apply_yn : $("#dump_option_6_3", "#restoreDumpRegForm").val(), //추가
				use_set_sesson_auth_yn : $("#dump_option_6_5", "#restoreDumpRegForm").val(),
				//detail_message_yn : $("#dump_option_6_6", "#restoreDumpRegForm").val(), //추가
				exit_on_error_yn : $("#dump_option_6_7", "#restoreDumpRegForm").val(),
				db_nm : $("#db_nm", "#restoreDumpRegForm").val(),
				
				obj_nm_List : JSON.stringify(obj_nm_List),
				scm_nm_List : JSON.stringify(scm_nm_List)
			},
			dataType : "json",
			type : "post",
			beforeSend : function(xhr) {
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
					if (result == "S") {
						showSwalIconRst('<spring:message code="restore.msg224" />', '<spring:message code="common.close" />', '', 'warning', 'dump_restore');
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
	 * 로그조회
	 ******************************************************** */
	function fn_restoreLogCall() {
		$.ajax({
			url : '/restoreLogCall.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val()
			},
			success : function(result) {
				$("#restoreDumpExeclog").html("");
				fn_addLogView(result.strResultData);
				$("#pop_layer_restore_exec_log").modal("show");
			},
			beforeSend : function(xhr) {
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
			}
		});
	}
</script>

<%@include file="../cmmn/passwordConfirm.jsp"%>
<%@include file="../popup/restoreLogDumpView.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="exe_sn"  id="exe_sn"  value="${exe_sn}">
	<input type="hidden" name="wrk_id"  id="wrk_id"  value="${wrk_id}">
	<input type="hidden" name="bck_wrk_id"  id="bck_wrk_id"  value="${bck_wrk_id}">
	<input type="hidden" name="returnYn"  id="returnYn"  value="${returnYn}">
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
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-check-square"></i>
												<span class="menu-title"><spring:message code="restore.Dump_Recovery"/></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="restore.Dump_Recovery" /></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.Dump_Recovery" /></p>
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
				<div class="card-body" style="min-height:698px; max-height:780px;">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">																				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScheduleRun" onClick="fn_restore_start();">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="schedule.run" />
								</button>
								
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnGoList" onClick="fn_goList();" data-toggle="modal">
									<i class="fa fa-list btn-icon-prepend "></i><spring:message code="restore.Dump_Recovery"/> <spring:message code="common.go_to_list" />
								</button>
							</div>
						</div>
					</div>

					<form class="cmxform" id="restoreDumpRegForm">
						<input type="hidden" name="restore_nmChk" id="restore_nmChk" value="fail" />
						<input type="hidden" name="file_fmt_cd" id="file_fmt_cd" value="" />

						<fieldset>
							<div class="row" style="margin-top:10px;">
								<div class="col-md-12">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="restore_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="restore.Recovery_name" />
											</label>
		
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="restore_nm" name="restore_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onchange="fn_restoreNm_Chg();" onblur="this.value=this.value.trim()" tabindex=1 required />
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
										
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:-10px;">
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
								<div class="col-md-8 system-tlb-scroll" style="border:0px;max-height: 530px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_name" />
											</label>
											
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" disabled />
											</div>

											<label for="exe_rslt_cd_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.status" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="exe_rslt_cd_nm" name="exe_rslt_cd_nm" onblur="this.value=this.value.trim()" disabled />
											</div>
										</div>

										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ipadr" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="dbms_information.dbms_ip" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="ipadr" name="ipadr" onblur="this.value=this.value.trim()" disabled />
											</div>

											<label for="db_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.database" />
											</label>
		
											<div class="col-sm-4">
												<select class="form-control form-control-xsm" style="margin-right: 1rem;width:100%;" name="db_nm" id="db_nm" tabindex=3>
													<option value=""><spring:message code="common.choice" /></option>
													<c:forEach var="result" items="${dbList}" varStatus="status">
														<option value="<c:out value="${result.db_nm}"/>"><c:out value="${result.db_nm}"/></option>
													</c:forEach>
												</select>
											</div>
										</div>

										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="bck_file_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="etc.etc08" />
											</label>

											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="bck_file_pth" name="bck_file_pth" onblur="this.value=this.value.trim()" disabled />
											</div>

											<label for="bck_filenm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="backup_management.fileName" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="bck_filenm" name="bck_filenm" onblur="this.value=this.value.trim()" disabled />
											</div>
										</div>

										<div class="form-group row div-form-margin-z row" style="margin-top:-10px;">
											<label for="wrk_strt_dtm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="backup_management.work_start_time" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="wrk_strt_dtm" name="wrk_strt_dtm" onblur="this.value=this.value.trim()" disabled />
											</div>

											<label for="wrk_end_dtm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="backup_management.work_end_time" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="wrk_end_dtm" name="wrk_end_dtm" onblur="this.value=this.value.trim()" disabled />
											</div>
										</div>

										<div class="form-group row div-form-margin-z row border-top" style="margin-top:-10px;margin-bottom:10px;">
											<div class="col-sm-12">
											</div>
										</div>

										<div class="form-group row div-form-margin-z row">
											<label for="file_fmt_cd_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="backup_management.file_format" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="file_fmt_cd_nm" name="file_fmt_cd_nm" onblur="this.value=this.value.trim()" disabled />
											</div>

											<label for="usr_role_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="backup_management.rolename" />
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="usr_role_nm" name="usr_role_nm" onblur="this.value=this.value.trim()" disabled />
											</div>
										</div>

										<div class="form-group row div-form-margin-z row" style="margin-top:-10px;">
											<label for="jobs" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												Number of Jobs
											</label>
		
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" maxlength="3" id="jobs" name="jobs" onblur="this.value=this.value.trim()" placeholder='3<spring:message code='message.msg188'/>' tabindex=4/>
											</div>

											<div class="col-sm-6">
											</div>
										</div>

										<div class="form-group row div-form-margin-z row border-top" style="margin-top:-10px;margin-bottom:10px;">
											<div class="col-sm-12">
											</div>
										</div>

										<div class="form-group row div-form-margin-z" style="margin-bottom:-10px;">
											<div class="col-12" >
												<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
													<li class="nav-item ">
														<a class="nav-link active" id="dump-tab-1" data-toggle="pill" href="#dumpOptionTab1" role="tab" aria-controls="dumpOptionTab1" aria-selected="true" >
															<spring:message code="backup_management.add_option" /> #1
														</a>
													</li>
													<li class="nav-item">
														<a class="nav-link" id="dump-tab-2" data-toggle="pill" href="#dumpOptionTab2" role="tab" aria-controls="dumpOptionTab2" aria-selected="false">
															<spring:message code="backup_management.add_option" /> #2
														</a>
													</li>
												</ul>
											</div>
										</div>
						
										<!-- tab화면 -->
										<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;margin-bottom:-10px;">
											<div class="tab-pane fade show active" role="tabpanel" id="dumpOptionTab1">
												<div class="form-group row div-form-margin-z" style="margin-top:-30px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														<spring:message code="backup_management.sections" />
													</label>

													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_1_1" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_1_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0006" opt_cd="TC000601" onClick="fn_dump_checkSection();"
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000601'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.pre-data" />
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_1_2" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_1_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0006" opt_cd="TC000602" onClick="fn_dump_checkSection();" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000602'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.data" />
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_1_3" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_1_3" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0006" opt_cd="TC000603" onClick="fn_dump_checkSection();"
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000603'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.post-data" />
																</label>
															</div>
														</div>
													</div>
												</div>

												<div class="form-group row div-form-margin-z" style="margin-top:-15px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														<spring:message code="backup_management.object_type" />
													</label>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_2_1" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_2_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0007" opt_cd="TC000701" onClick="fn_dump_checkObject('TC000701');" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000701'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.only_data" />
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_2_2" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_2_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0007" opt_cd="TC000702" onClick="fn_dump_checkObject('TC000702');" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000702'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.only_schema" />
																</label>
															</div>
															<!--  원래없던것임 -->
															<%-- <div class="form-check input-group-addon mx-4">
																<label for="dump_option_2_3" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_2_3" name="dump_opt" class="form-check-input" value="Y" grp_cd="TC0007" opt_cd="TC000703" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000703'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.blobs" />
																</label>
															</div> --%>
														</div>
													</div>
												</div>
 
												<div class="form-group row div-form-margin-z" style="margin-top:-15px;margin-bottom:-35px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														<spring:message code="backup_management.save_yn_choice" />
													</label>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_3_1" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_3_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0008" opt_cd="TC000801" disabled 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000801'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.owner" />
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_3_2" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_3_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0008" opt_cd="TC000802" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000802'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.privilege" />
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_3_3" class="form-check-label" style="width:100px;">
																	<input type="checkbox" id="dump_option_3_3" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0008" opt_cd="TC000803" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000803'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.tablespace" />
																</label>
															</div>
															
															<!--  원래없던것임 -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_3_4" class="form-check-label" style="width:150px;">
																	<input type="checkbox" id="dump_option_3_4" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0008" opt_cd="TC000804" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000804'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.unlogged_table_data" />
																</label>
															</div>
														</div>
													</div>
												</div>
											</div>
		
											<div class="tab-pane fade" role="tabpanel" id="dumpOptionTab2">
												<div class="form-group row div-form-margin-z" style="margin-top:-30px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														<spring:message code="backup_management.query" />
													</label>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<!--  원래없던것임 -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_1" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_4_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000901" onClick="fn_dump_checkOid();" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000901'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.use_column_inserts" />
																</label>
															</div>
															<!--  원래없던것임 -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_2" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_4_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000902" onClick="fn_dump_checkOid();" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000902'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.use_column_commands" />
																</label>
															</div>
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_3" class="form-check-label" style="width:170px;">
																	<input type="checkbox" id="dump_option_4_3" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000903" disabled 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000903'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.create_database_include" />
																</label>
															</div>
														</div>
													</div>
												</div>
												
												<div class="form-group row div-form-margin-z" style="margin-top:-25px;">
													<div class="col-sm-2"></div>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<!-- 원래없던것임 -->
<%-- 															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_4" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_4_4" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000904" disabled 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000904'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.drop_database_include" />
																</label>
															</div> --%>
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_5" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_4_5" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000905"  
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000905'}">checked</c:if>
																		</c:forEach>
																	/>
																	Clean before restore
																</label>
															</div>
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_4_6" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_4_6" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0009" opt_cd="TC000906" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000906'}">checked</c:if>
																		</c:forEach>
																	/>
																	Single transaction
																</label>
															</div>
															<div class="form-check input-group-addon mx-4">
																<label class="form-check-label" style="width:170px;">
																</label>
															</div>
														</div>
													</div>
												</div>

												<div class="form-group row div-form-margin-z" style="margin-top:-15px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														Disable
													</label>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_5_1" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_5_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0021" opt_cd="TC002101" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0021' && optVal.opt_cd eq 'TC002101'}">checked</c:if>
																		</c:forEach>
																	/>
																	Trigger
																</label>
															</div>
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_5_2" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_5_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0021" opt_cd="TC002102" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0021' && optVal.opt_cd eq 'TC002102'}">checked</c:if>
																		</c:forEach>
																	/>
																	NoData for Failed Table
																</label>
															</div>
														</div>
													</div>
												</div>
												
												<div class="form-group row div-form-margin-z" style="margin-top:-15px;">
													<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
														<i class="item-icon fa fa-angle-double-right"></i>
														<spring:message code="common.etc" />
													</label>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
															<!-- 원래없던것임 -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_1" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_6_1" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0010" opt_cd="TC001001" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001001'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.oids_include" />
																</label>
															</div>

															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_2" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_6_2" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0010" opt_cd="TC001002" checked disabled/>
																	<spring:message code="backup_management.quote_include" />
																</label>
															</div>

															<!-- 원래없던것임 -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_3" class="form-check-label" style="width:170px;">
																	<input type="checkbox" id="dump_option_6_3" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0010" opt_cd="TC001003" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001003'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.Identifier_quotes_apply" />
																</label>
															</div>
														</div>
													</div>
												</div>
												
												<div class="form-group row div-form-margin-z" style="margin-top:-25px;margin-bottom:-40px;">
													<div class="col-sm-2"></div>
													<div class="col-sm-10">
														<div class="input-group input-daterange d-flex" >
<!-- 															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_4" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_6_4" name="dump_opt" class="form-check-input" value="Y" checked />
																	Verbose Message
																</label>
															</div> -->
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_5" class="form-check-label" style="width:190px;">
																	<input type="checkbox" id="dump_option_6_5" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0010" opt_cd="TC001004"  
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001004'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.set_session_auth_use" />
																</label>
															</div>
															<!-- 원래없던것임 -->
<%-- 															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_6" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_6_6" name="dump_opt" class="form-check-input" value="Y" grp_cd="TC0010" opt_cd="TC001006" 
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001006'}">checked</c:if>
																		</c:forEach>
																	/>
																	<spring:message code="backup_management.detail_message_include" />
																</label>
															</div> --%>
															
															<div class="form-check input-group-addon mx-4">
																<label for="dump_option_6_7" class="form-check-label" style="width:180px;">
																	<input type="checkbox" id="dump_option_6_7" name="dump_opt" class="form-check-input" value="N" grp_cd="TC0010" opt_cd="TC001005"  
																		<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
																			<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001005'}">checked</c:if>
																		</c:forEach>
																	/>
																	Exit on Error
																</label>
															</div>
															
															<div class="form-check input-group-addon mx-4">
																<label class="form-check-label" style="width:170px;">
																	
																</label>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="col-md-4 system-tlb-scroll" style="border:0px;height: 530px;">
									<div class="card-body-modal" style="border: 1px solid #adb5bd;">
										<!-- title -->
										<h3 class="card-title fa fa-dot-circle-o">
											<spring:message code="backup_management.object_choice" />
										</h3>
				
										<div class="table-responsive system-tlb-scroll" style="border:0px;height: 460px; overflow-x: hidden;  overflow-y: auto; ">
											<table class="table">
												<tbody>
													<tr>
														<td class="py-1" style="width: 100%; word-break:break-all;">
															<div class="row">
																<div class="col-md-12">
	 																<div id="treeview_container" class="hummingbird-treeview well h-scroll-large">
																	</div>																	
																</div>
															</div>
														</td>
													</tr>
												</tbody>
											</table>
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