<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : scriptRegForm.jsp
	* @Description : 배치등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018. 06. 08     최초 생성
	*
	* author 변승우
	* since 2017.06.07
	*
	*/
%>

<script type="text/javascript">
	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//validate
	    $("#modRegForm").validate({
	        rules: {
				mod_wrk_exp: {
					required: true
				},
				mod_exe_cmd: {
					required: true
				}
	        },
	        messages: {
				mod_wrk_exp: {
					required: '<spring:message code="message.msg108" />'
				},
				mod_exe_cmd: {
	        		required: '<spring:message code="message.msg216" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_update_work();
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
	 * 배치 설정 수정
	 ******************************************************** */
	function fn_update_work(){

		$.ajax({
			url : '/popup/updateScript.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				wrk_id : $("#wrk_id","#findList").val(),
				wrk_exp : $("#mod_wrk_exp").val(),
				exe_cmd : $("#mod_exe_cmd").val()
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
				if(result == "F"){
					showSwalIcon('<spring:message code="eXperDB_scale.msg22"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_mod_script').modal('show');
					return false;
				}else{
					showSwalIcon('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_mod_script').modal('hide');
					fn_mainsearch();
				}
			},
		});
	}
</script>

<div class="modal fade" id="pop_layer_mod_script" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="script_settings.Modify_Script_Command" />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="modRegForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="mod_work_name" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_name" />
									</label>

									<div class="col-sm-10">
										<input type="text" class="form-control" maxlength="20" id="mod_wrk_nm" name="mod_wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()" tabindex=1 required readonly/>
									</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="mod_wrk_exp" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.work_description" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="mod_wrk_exp" name="mod_wrk_exp" rows="2" maxlength="200" onkeyup="fn_checkWord(this,25)" placeholder="200<spring:message code='message.msg188'/>" required></textarea>
									</div>
								</div>
							</div>
							
							<br/>
							
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row div-form-margin-z">
									<label for="mod_work_name" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="script_settings.Execution_Command" />
									</label>

									<div class="col-sm-10">
										<textarea class="form-control" id="mod_exe_cmd" name="mod_exe_cmd" style="height: 250px;" required></textarea>
									</div>
								</div>
							</div>
							
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.modify" />' />
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