<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : passwordConfirm.jsp
	* @Description : 복원 패스워드 체크
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>

<script type="text/javascript">
	/* ********************************************************
	 * 초기실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//validate
	    $("#passwordExecuteForm").validate({
		        rules: {
		        exec_password: {
					required: true
				}
	        },
	        messages: {
	        	exec_password: {
	        		required: '<spring:message code="message.msg88" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_pop_password_chk();
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
	 * 비밀번호 검증
	 ******************************************************** */
	function fn_pop_password_chk() {
		var flag = $('#exec_flag', "#passwordExecuteForm").val();
		
		$.ajax({
			url : "/psswordCheck.do",
			data : {
				password : nvlPrmSet($("#exec_password", "#passwordExecuteForm").val(), "")
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
				if(result == "true"){
					$('#pop_layer_pwConfilm').modal('hide');
					
					if(flag=="rman"){
						fn_pgWalFileSwitch();
					}else{
						fn_execute();
					}
					
				}else{
					showSwalIcon('<spring:message code="encrypt_msg.msg03" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_pwConfilm').modal('show');
				}				
			}
		});
	}
</script>
<div class="modal fade" id="pop_layer_pwConfilm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 250px 600px;">
		<div class="modal-content" style="width:500px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_serverMasterKey.Confirm_Password" />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="passwordExecuteForm">
						<input type="hidden" name="exec_flag" id="exec_flag" value=""/>
						
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row" style="margin-bottom:-10px">
									<label class="col-sm-4 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="encrypt_serverMasterKey.Password" />
									</label>
									
									<div class="col-sm-8">
										<input type="password" class="form-control" maxlength="20" id="exec_password" name="exec_password" value="" placeholder="<spring:message code='message.msg88' />" onblur="this.value=this.value.trim()" />
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