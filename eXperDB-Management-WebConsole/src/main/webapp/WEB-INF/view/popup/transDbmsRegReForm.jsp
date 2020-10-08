<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transDbmsRegReForm.jsp
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
	    $("#trasnDbmsModifyPop").validate({
	        rules: {
	        	mod_trans_sys_nm: {
					required: true
				},
				mod_trans_dbms_dscd: {
					required: true
				},
				mod_trans_ipadr: {
					required: true
				},
				mod_trans_portno: {
					required: true,
					number: true
				},
				mod_trans_dtb_nm: {
					required: true
				},
				mod_trans_schema_nm: {
					required: true
				},
				mod_trans_spr_usr_id: {
					required: true
				},
				mod_trans_pwd: {
					required: true
				}
	        },
	        messages: {
	        	mod_trans_sys_nm: {
	        		required: '<spring:message code="migration.msg01" />'
				},
				mod_trans_dbms_dscd: {
	        		required: '<spring:message code="migration.dbms_classification" />'
				},
				mod_trans_ipadr: {
	        		required: '<spring:message code="migration.msg15" />'
				},
				mod_trans_portno: {
	        		required: '<spring:message code="migration.msg18" />',
					number: '<spring:message code="message.msg49" />'
				},
				mod_trans_dtb_nm: {
	        		required: '<spring:message code="migration.msg16" />'
				},
				mod_trans_schema_nm: {
	        		required: '<spring:message code="migration.msg17" />'
				},
				mod_trans_spr_usr_id: {
					required: '<spring:message code="migration.msg19" />'
				},
				mod_trans_pwd: {
					required: '<spring:message code="migration.msg20" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_trans_dbms_modify_proc();
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
	 * 팝업시작
	 ******************************************************** */
	function fn_tansDbmsModPopStart(result) {
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsInsertPop").html("");
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsInsertPop").hide();

		$("#mod_trans_sys_id", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].trans_sys_id, ""));
		$("#mod_trans_sys_nm", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].trans_sys_nm, ""));
		$("#mod_trans_ipadr", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].ipadr, "")); 
		$("#mod_trans_portno", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].portno, "")); 
		$("#mod_trans_dtb_nm", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].dtb_nm, "")); 
		$("#mod_trans_schema_nm", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].scm_nm, ""));
		$("#mod_trans_spr_usr_id", "#trasnDbmsModifyPop").val(nvlPrmSet(result.resultInfo[0].spr_usr_id, ""));
		$("#mod_trans_pwd", "#trasnDbmsModifyPop").val(nvlPrmSet(result.pwd, "")); 
		$('#mod_trans_sys_connection', '#trasnDbmsModifyPop').val("success");

		$("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").find('option').remove();
		$("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").append('<option value=""><spring:message code="common.choice" /></option>');
		
		if (result.dbmsGrb_reg != null) {
			for (var idx=0; idx < result.dbmsGrb_reg.length; idx++) {
				if (result.dbmsGrb_reg[idx].sys_cd == "TC002201") {
					$("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").append("<option value='"+ result.dbmsGrb_reg[idx].sys_cd + "'>" + result.dbmsGrb_reg[idx].sys_cd_nm + "</option>");
				}
			}
		}

		$("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").val(result.resultInfo[0].dbms_dscd).prop("selected", true)
	}
	

	/* ********************************************************
	 * Source DBMS 연결테스트
	******************************************************** */
	function fn_trans_dbms_mod_connTest(){
		if (nvlPrmSet($("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").val(), '') == "") {
			var ins_databaseMsg = "<spring:message code='migration.dbms_classification' />";
			showSwalIcon('<spring:message code="eXperDB_scale.msg3" arguments="'+ ins_databaseMsg +'" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#mod_trans_ipadr", "#trasnDbmsModifyPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#mod_trans_portno", "#trasnDbmsModifyPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg18" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (nvlPrmSet($("#mod_trans_dtb_nm", "#trasnDbmsModifyPop").val(), '') == "") {
			showSwalIcon('<spring:message code="migration.msg16" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").html('');
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").hide();

	     $.ajax({
	 		url : "/dbmsConnTest.do",
	 		data : {
	 		 	ipadr : nvlPrmSet($("#mod_trans_ipadr", "#trasnDbmsModifyPop").val(), ''),
	 		 	portno : nvlPrmSet($("#mod_trans_portno", "#trasnDbmsModifyPop").val(), ''),
	 		  	dtb_nm : nvlPrmSet($("#mod_trans_dtb_nm", "#trasnDbmsModifyPop").val(), ''),
	 		   	spr_usr_id : nvlPrmSet($("#mod_trans_spr_usr_id", "#trasnDbmsModifyPop").val(), ''),
	 		   	pwd : nvlPrmSet($("#mod_trans_pwd", "#trasnDbmsModifyPop").val(), ''),
	 		  	dbms_dscd : nvlPrmSet($("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").val(), '')
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
	 				$('#mod_trans_sys_connection', '#trasnDbmsModifyPop').val("success");
	 				showSwalIcon(result.RESULT_Conn, '<spring:message code="common.close" />', '', 'success');
	 			}else{
	 				$('#mod_trans_sys_connection', '#trasnDbmsModifyPop').val("fail");
	 				showSwalIcon(result.ERR_MSG, '<spring:message code="common.close" />', '', 'error');
	 				return false;
	 			}		
	 		}
	 	});
	}

	/* ********************************************************
	 * DBMS 등록
	 ******************************************************** */
	function fn_trans_modifyDBMS(){
		$('#trasnDbmsModifyPop').submit();
	}
	

	/* ********************************************************
	 * DBMS 등록 로직 실행
	 ******************************************************** */
	function fn_trans_dbms_modify_proc(){
		if (!mod_trans_dbms_valCheck()) return false;

		$.ajax({
			async : false,
	  		url : "/popup/updateTransDBMS.do",
			data : {
				trans_sys_id : $("#mod_trans_sys_id", "#trasnDbmsModifyPop").val(),
	  		 	trans_sys_nm : nvlPrmSet($("#mod_trans_sys_nm", "#trasnDbmsModifyPop").val(), ''),
	  			ipadr : nvlPrmSet($("#mod_trans_ipadr", "#trasnDbmsModifyPop").val(), ''),
	  		 	portno : nvlPrmSet($("#mod_trans_portno", "#trasnDbmsModifyPop").val(), ''),
	  		  	dtb_nm : nvlPrmSet($("#mod_trans_dtb_nm", "#trasnDbmsModifyPop").val(), ''),
	  		  	scm_nm : nvlPrmSet($("#mod_trans_schema_nm", "#trasnDbmsModifyPop").val(), ''),
	  		   	spr_usr_id : nvlPrmSet($("#mod_trans_spr_usr_id", "#trasnDbmsModifyPop").val(), ''),
	  		   	pwd : nvlPrmSet($("#mod_trans_pwd", "#trasnDbmsModifyPop").val(), ''),
	  		  	dbms_dscd : nvlPrmSet($("#mod_trans_dbms_dscd", "#trasnDbmsModifyPop").val(), '')
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
					showSwalIcon('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_trans_dbms_reg_re').modal('hide');
					fn_dbms_select();
				}else{
					showSwalIcon('<spring:message code="eXperDB_scale.msg22" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_trans_dbms_reg_re').modal('show');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function mod_trans_dbms_valCheck(){
		var iChkCnt = 0;

		if(nvlPrmSet($("#mod_trans_sys_connection", "#trasnDbmsModifyPop").val(), "") != "success") {
			$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").html('<spring:message code="message.msg89"/>');
			$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").show();

			iChkCnt = iChkCnt + 1;
		}

		if (iChkCnt > 0) {
			return false;
		}

		return true;
	}

	/* ********************************************************
	 * 시스템 명 변경시
	 ******************************************************** */
	function fn_mod_trans_dbms_connect_Cho() {
		$('#mod_trans_sys_connection', '#trasnDbmsModifyPop').val("");
		
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").html('');
		$("#mod_trans_connectTest_check_alert", "#trasnDbmsModifyPop").hide();
	}
</script>

<div class="modal fade" id="pop_layer_trans_dbms_reg_re" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.target_dbms_modify"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" name="trasnDbmsModifyPop" id="trasnDbmsModifyPop" method="post">
						<input type="hidden" name="mod_trans_sys_connection" id="mod_trans_sys_connection" value="" />
						<input type="hidden" name="mod_trans_sys_id" id="mod_trans_sys_id"/>

						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="mod_trans_sys_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.system_name" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 100%;" autocomplete="off" maxlength="50" id="mod_trans_sys_nm" name="mod_trans_sys_nm" onkeyup="fn_checkWord(this,50)" readonly />
									</div>
									<div class="col-sm-6">
									</div>
								</div>
								
								<div class="form-group row">
									<label for="mod_trans_dbms_dscd" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										DBMS<spring:message code="properties.division"/>(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="margin-right: 1rem;width: 100% !important;" name="mod_trans_dbms_dscd" id="mod_trans_dbms_dscd" onFocus='this.initialSelect = this.selectedIndex;' onchange="fn_mod_trans_dbms_connect_Cho();">
										</select>
									</div>
									<div class="col-sm-6">
									</div>
								</div>

								<div class="form-group row">
									<label for="mod_trans_ipadr" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="mod_trans_ipadr" name="mod_trans_ipadr" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" onchange="fn_mod_trans_dbms_connect_Cho();" />
									</div>
									<label for="mod_trans_portno" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="5" id="mod_trans_portno" name="mod_trans_portno" onKeyUp="fn_checkWord(this,5);chk_Number(this);" onblur="this.value=this.value.trim()" placeholder="5<spring:message code='message.msg188'/>" onchange="fn_mod_trans_dbms_connect_Cho();" />
									</div>
								</div>

								<div class="form-group row">
									<label for="mod_trans_dtb_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="200" id="mod_trans_dtb_nm" name="mod_trans_dtb_nm" onkeyup="fn_checkWord(this,200)" onblur="this.value=this.value.trim()" placeholder="200<spring:message code='message.msg188'/>" onchange="fn_mod_trans_dbms_connect_Cho();" />
									</div>
									<label for="mod_trans_schema_nm" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="50" id="mod_trans_schema_nm" name="mod_trans_schema_nm" onkeyup="fn_checkWord(this, 50)" onblur="this.value=this.value.trim()" placeholder="50<spring:message code='message.msg188'/>" />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="mod_trans_spr_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account"/>(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="false" maxlength="30" id="mod_trans_spr_usr_id" name="mod_trans_spr_usr_id" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" onchange="fn_mod_trans_dbms_connect_Cho();" />
									</div>
									<label for="mod_trans_pwd" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="password" class="form-control" style="width: 250px;" autocomplete="new-password"  maxlength="100" id="mod_trans_pwd" name="mod_trans_pwd" onkeyup="fn_checkWord(this, 100)" onblur="this.value=this.value.trim()" placeholder="100<spring:message code='message.msg188'/>" onchange="fn_mod_trans_dbms_connect_Cho();" />
									</div>
								</div>
								
								<div class="form-group row div-form-margin-z">
									<div class="col-sm-2"></div>
									<div class="col-sm-10">
										<div class="alert alert-danger" style="margin-top:-25px;display:none;" id="mod_trans_connectTest_check_alert"></div>
									</div>
								</div>
							</div>

							<br/>

							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_trans_modifyDBMS();" value='<spring:message code="common.modify" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_trans_dbms_mod_connTest();" value='<spring:message code="dbms_information.conn_Test" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
