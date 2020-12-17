<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : scaleExecuteForm.jsp
	* @Description : scale 실행 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>

<script type="text/javascript">

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
	    $("#scaleExecuteForm").validate({
	        rules: {
	        	exe_scale_count: {
					required: true,
					min:1
				}
	        },
	        messages: {
	        	exe_scale_count: {
					required: '<spring:message code="eXperDB_scale.msg6" arguments="1" />',
					min: '<spring:message code="eXperDB_scale.msg6" arguments="1" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_scaleInOutExecute();
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
	 * scale 실행팝업 초기화
	 ******************************************************** */
	function fn_scaleExeSet() {
		var title_gbn_param = $("#exe_title_gbn", "#scaleExecuteForm").val();
		if (title_gbn_param == "scaleIn") {
			$("#msg_scale_type", "#scaleExecuteForm").html('<spring:message code="etc.etc38"/>');
			$("#spNodrCnt", "#scaleExecuteForm").html('<spring:message code="eXperDB_scale.reduction_node_cnt"/>');
		} else {
			$("#msg_scale_type", "#scaleExecuteForm").html('<spring:message code="etc.etc39"/>');
			$("#spNodrCnt", "#scaleExecuteForm").html('<spring:message code="eXperDB_scale.expansion_node_cnt"/>');
		}
	}

	/* ********************************************************
	 * scale in Out 실행
	 ******************************************************** */
	function fn_scaleInOutExecute() {
		var scaleMsg = "";
		var exe_scale_count = "";
		var main_TableRow_Cnt = "";

		if ($("#exe_title_gbn", "#scaleExecuteForm").val() == "scaleIn") {
			exe_scale_count = nvlPrmSet($("#exe_scale_count", "#scaleExecuteForm").val(),0);
			main_TableRow_Cnt = nvlPrmSet($("#mainTableRowCnt", "#frmExecutePopup").val(),0);
			
			if (exe_scale_count > main_TableRow_Cnt) {
				msgResult= '<spring:message code="eXperDB_scale.msg31" />';
				showSwalIcon(fn_strBrReplcae(msgResult), '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}

		$.ajax({
			async : false,
			url : "/scale/scaleInOutSet.do",
		  	data : {
		  		scaleSet : $("#exe_title_gbn", "#scaleExecuteForm").val(),
				db_svr_id : $("#db_svr_id", "#frmExecutePopup").val(),
				scale_count : $("#exe_scale_count", "#scaleExecuteForm").val()
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
				if ($("#exe_title_gbn", "#scaleExecuteForm").val() == "scaleIn") {
					scaleMsg = '<spring:message code="eXperDB_scale.scale_in" />';
				} else {
					scaleMsg = '<spring:message code="eXperDB_scale.scale_out" />';
				}
				
				var msgResult = "";
				if (result.RESULT == "FAIL" || result == "") {
					msgResult= '<spring:message code="eXperDB_scale.msg2" />';
					msgResult = scaleMsg + fn_strBrReplcae(msgResult);

					showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_scale_exe').modal('show');
					return false;
				} else {
					msgResult= '<spring:message code="eXperDB_scale.msg1" />';
					msgResult = scaleMsg + fn_strBrReplcae(msgResult);

					showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_scale_exe').modal('hide');
					fn_scale_status_chk();
				}
			}
		});
	}
</script>
	
<div class="modal fade" id="pop_layer_scale_exe" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 250px 600px;">
		<div class="modal-content" style="width:500px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 id="executeTitle" class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="scaleExecuteForm">
						<input type="hidden" name="exe_title_gbn" id="exe_title_gbn" value=""/>
						
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label class="col-sm-4 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_scale.scale_type" />
									</label>
									
									<label id="msg_scale_type" class="col-sm-8 col-form-label pop-label-index">
									</label>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="ins_wrk_exp" class="col-sm-4 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span id="spNodrCnt"></span>
									</label>

									<div class="col-sm-8">
										<input type="text" class="form-control" maxlength="5" id="exe_scale_count" name="exe_scale_count" value="1" onKeyUp="chk_Number(this);" placeholder="<spring:message code='eXperDB_scale.msg6' arguments='1' />" onblur="this.value=this.value.trim()" />
									</div>
								</div>
							</div>
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px; -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="schedule.run" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>