<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transDbmsRegForm.jsp
	* @Description : 디비 서버 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.01     최초 생성
	*
	* author 
	* since 2017.06.01
	*
	*/
%>   
<script type="text/javascript">

	/* ********************************************************
	 * 페이지 시작시
	 ******************************************************** */
	$(window.document).ready(function() {
		//validate
	    $("#trasnDbmsInsertPop").validate({
	        rules: {
	        	reg_trans_sys_nm: {
					required: true
				},
				reg_trans_dbms_dscd: {
					required: true
				},
				reg_trans_ipadr: {
					required: true
				},
				reg_trans_portno: {
					required: true,
					number: true
				},
				reg_trans_dtb_nm: {
					required: true
				},
				reg_trans_schema_nm: {
					required: true
				},
				reg_trans_spr_usr_id: {
					required: true
				},
				reg_trans_pwd: {
					required: true
				}
	        },
	        messages: {
	        	reg_trans_sys_nm: {
	        		required: '<spring:message code="migration.msg01" />'
				},
				reg_trans_dbms_dscd: {
	        		required: '<spring:message code="migration.dbms_classification" />'
				},
				reg_trans_ipadr: {
	        		required: '<spring:message code="migration.msg15" />'
				},
				reg_trans_portno: {
	        		required: '<spring:message code="migration.msg18" />',
					number: '<spring:message code="message.msg49" />'
				},
				reg_trans_dtb_nm: {
	        		required: '<spring:message code="migration.msg16" />'
				},
				reg_trans_schema_nm: {
	        		required: '<spring:message code="migration.msg17" />'
				},
				reg_trans_spr_usr_id: {
					required: '<spring:message code="migration.msg19" />'
				},
				reg_trans_pwd: {
					required: '<spring:message code="migration.msg20" />'
				}

	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_trans_dbms_insert_proc();
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
	 * Source DBMS 연결테스트
	******************************************************** */
	function fn_trans_dbms_ins_connTest(){

		if (nvlPrmSet($("#reg_trans_dbms_dscd", "#trasnDbmsInsertPop").val(), '') == "") {
			var ins_databaseMsg = "<spring:message code='migration.dbms_classification' />";
			showSwalIcon('<spring:message code="eXperDB_scale.msg3" arguments="'+ ins_databaseMsg +'" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#reg_trans_ipadr", "#trasnDbmsInsertPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#reg_trans_portno", "#trasnDbmsInsertPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg18" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#reg_trans_dtb_nm", "#trasnDbmsInsertPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg16" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").html('');
		$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").hide();

	     $.ajax({
	 		url : "/dbmsConnTest.do",
	 		data : {
	 		 	ipadr : nvlPrmSet($("#reg_trans_ipadr", "#trasnDbmsInsertPop").val(), ''),
	 		 	portno : nvlPrmSet($("#reg_trans_portno", "#trasnDbmsInsertPop").val(), ''),
	 		  	dtb_nm : nvlPrmSet($("#reg_trans_dtb_nm", "#trasnDbmsInsertPop").val(), ''),
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
	 				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else if(xhr.status == 403) {
	 				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else {
	 				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
	 			}
	 		},
	 		success : function(result) {
	 			if(result.RESULT_CODE == 0){
	 				$('#reg_trans_sys_connection', '#trasnDbmsInsertPop').val("success");
	 				showSwalIcon(result.RESULT_Conn, '<spring:message code="common.close" />', '', 'success');
	 			}else{
	 				$('#reg_trans_sys_connection', '#trasnDbmsInsertPop').val("fail");
	 				showSwalIcon(result.ERR_MSG, '<spring:message code="common.close" />', '', 'error');
	 				return false;
	 			}		
	 		}
	 	});     
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function ins_trans_dbms_valCheck(){
		var iChkCnt = 0;

		if(nvlPrmSet($("#reg_trans_sys_nmChk", "#trasnDbmsInsertPop").val(), "") == "" || nvlPrmSet($("#reg_trans_sys_nmChk", "#trasnDbmsInsertPop").val(), "") == "fail") {
			$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").html('<spring:message code="migration.msg14"/>');
			$("#reg_trans_sys_nm_check_alert", "#trasnDbmsInsertPop").show();
			
			iChkCnt = iChkCnt + 1;
		}

		if(nvlPrmSet($("#reg_trans_sys_connection", "#trasnDbmsInsertPop").val(), "") != "success") {
			$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").html('<spring:message code="message.msg89"/>');
			$("#reg_trans_connectTest_check_alert", "#trasnDbmsInsertPop").show();

			iChkCnt = iChkCnt + 1;
		}

		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}
	
	/* ********************************************************
	 * 팝업시작
	 ******************************************************** */
	function fn_transDbmsRegPopStart(result) {
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
			showSwalIcon('<spring:message code="migration.msg01" />', '<spring:message code="common.close" />', '', 'warning');
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
	 				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else if(xhr.status == 403) {
	 				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else {
	 				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
	 			}
			},
			success : function(result) {
				if (result == "true") {
					showSwalIcon('<spring:message code="migration.msg04" />', '<spring:message code="common.close" />', '', 'success');
					$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("success");
				} else {
					showSwalIcon('<spring:message code="migration.msg05" />', '<spring:message code="common.close" />', '', 'error');
					$('#reg_trans_sys_nmChk', '#trasnDbmsInsertPop').val("fail");
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
	 				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else if(xhr.status == 403) {
	 				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
	 			} else {
	 				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
	 			}
			},
			success : function(data) {
				if(data == "O"){ //중복 work명 일경우
					showSwalIcon('<spring:message code="migration.msg05" />', '<spring:message code="common.close" />', '', 'error');
					return;
				} else if(data == "S"){
					showSwalIcon('<spring:message code="message.msg106" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_trans_dbms_reg').modal('hide');
					fn_dbms_select();
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_trans_dbms_reg').modal('show');
					return;
				}
			}
		});
	}
</script>
<div class="modal fade" id="pop_layer_trans_dbms_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.target_dbms_register"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" name="trasnDbmsInsertPop" id="trasnDbmsInsertPop" method="post">
						<input type="hidden" name="reg_trans_sys_nmChk" id="reg_trans_sys_nmChk" value="fail" />
						<input type="hidden" name="reg_trans_sys_connection" id="reg_trans_sys_connection" value="" />

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="reg_trans_sys_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.system_name" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 100%;" autocomplete="off" maxlength="50" id="reg_trans_sys_nm" name="reg_trans_sys_nm" onkeyup="fn_checkWord(this,50)" onchange="fn_reg_trans_sys_nmCho();" onblur="this.value=this.value.trim()" placeholder="50<spring:message code='message.msg188'/>" tabindex=1 />
									</div>
									<div class="col-sm-1_5">
										<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onclick="fn_transDbmsInsSysnmCheck();" value='<spring:message code="common.overlap_check" />' />
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2">
									</div>

									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:-25px;display:none;" id="reg_trans_sys_nm_check_alert"></div>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="reg_trans_dbms_dscd" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										DBMS<spring:message code="properties.division"/>(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="margin-right: 1rem;width: 100% !important;" name="reg_trans_dbms_dscd" id="reg_trans_dbms_dscd" onchange="fn_reg_trans_dbms_connect_Cho();">
										</select>
									</div>
									<div class="col-sm-1_5">
<%-- 										<input class="btn btn-inverse-primary btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" id="pgbtn" type="button" onclick="fn_pgdbmsCall();" value='<spring:message code="migration.loading" />' />
 --%>									
 									</div>
								</div>
								<div class="form-group row">
									<label for="reg_trans_ipadr" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="reg_trans_ipadr" name="reg_trans_ipadr" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" onchange="fn_reg_trans_dbms_connect_Cho();" />
									</div>
									<label for="reg_trans_portno" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="5" id="reg_trans_portno" name="reg_trans_portno" onKeyUp="fn_checkWord(this,5);chk_Number(this);" onblur="this.value=this.value.trim()" placeholder="5<spring:message code='message.msg188'/>" onchange="fn_reg_trans_dbms_connect_Cho();" />
									</div>
								</div>
								<div class="form-group row">
									<label for="reg_trans_dtb_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="200" id="reg_trans_dtb_nm" name="reg_trans_dtb_nm" onkeyup="fn_checkWord(this,200)" onblur="this.value=this.value.trim()" placeholder="200<spring:message code='message.msg188'/>" onchange="fn_reg_trans_dbms_connect_Cho();" />
									</div>
									<label for="reg_trans_schema_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="50" id="reg_trans_schema_nm" name="reg_trans_schema_nm" onkeyup="fn_checkWord(this, 50)" onblur="this.value=this.value.trim()" placeholder="50<spring:message code='message.msg188'/>" />
							<!-- 			<select name="scm_nm" id="schema_pg_reg" class="form-control" style="margin-right: 1rem;width: 100% !important;"></select> -->
									</div>
								</div>
								<div class="form-group row">
									<label for="reg_trans_spr_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account"/>(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="false" maxlength="30" id="reg_trans_spr_usr_id" name="reg_trans_spr_usr_id" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" onchange="fn_reg_trans_dbms_connect_Cho();" />
									</div>
									<label for="reg_trans_pwd" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="password" class="form-control" style="width: 250px;" autocomplete="new-password"  maxlength="100" id="reg_trans_pwd" name="reg_trans_pwd" onkeyup="fn_checkWord(this, 100)" onblur="this.value=this.value.trim()" placeholder="100<spring:message code='message.msg188'/>" onchange="fn_reg_trans_dbms_connect_Cho();" />
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2"></div>
									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:-25px;display:none;" id="reg_trans_connectTest_check_alert"></div>
									</div>
								</div>
							</div>

							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_trans_insertDBMS();" value='<spring:message code="common.registory" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_trans_dbms_ins_connTest();" value='<spring:message code="dbms_information.conn_Test" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>