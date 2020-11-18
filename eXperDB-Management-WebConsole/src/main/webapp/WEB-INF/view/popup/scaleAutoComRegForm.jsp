<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		var max_clusters_msg = '<spring:message code="eXperDB_scale.max_clusters" />';
		var min_clusters_msg = '<spring:message code="eXperDB_scale.min_clusters" />';
		var auto_execution_cycle_msg = '<spring:message code="eXperDB_scale.auto_execution_cycle" />';

		$("#comRegForm").validate({
			rules: {
		        	com_max_clusters: {
						required: true,
						number: true,
						min:1
					},
					com_min_clusters: {
						required: true,
						number: true,
						min:2
					},
					com_auto_run_cycle: {
						required: true,
						number: true,
						range: [1, 60]
					},
			},
			messages: {
						com_max_clusters: {
							required: '<spring:message code="errors.required" arguments="'+ max_clusters_msg +'" />',
							number: '<spring:message code="eXperDB_scale.msg15" />',
							min: '<spring:message code="eXperDB_scale.msg6" arguments="1" />'
						},
						com_min_clusters: {
							required: '<spring:message code="errors.required" arguments="'+ min_clusters_msg +'" />',
							number: '<spring:message code="eXperDB_scale.msg15" />',
							min: '<spring:message code="eXperDB_scale.msg6" arguments="2" />'
						},
						com_auto_run_cycle: {
							required: '<spring:message code="errors.required" arguments="'+ auto_execution_cycle_msg +'" />',
							number: '<spring:message code="eXperDB_scale.msg15" />',
							range: '<spring:message code="eXperDB_scale.msg17" />'
						}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_com_insert_wrk();
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
	 * insert 실행
	 ******************************************************** */
	function fnc_com_insert_wrk() {
		$.ajax({
			async : false,
			url : "/scale/popup/scaleComCngWrite.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id","#findList").val(),
		  		min_clusters : nvlPrmSet($("#com_min_clusters","#comRegForm").val(),''),
		  		max_clusters : nvlPrmSet($("#com_max_clusters","#comRegForm").val(),''),
		  		auto_run_cycle : nvlPrmSet($("#com_auto_run_cycle","#comRegForm").val(),'')
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
				
				if(result == "F"){//저장실패
					showSwalIcon('<spring:message code="eXperDB_scale.msg2"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_com_ins_cng').modal('show');
					return false;
				}else{
					showSwalIcon('<spring:message code="message.msg144"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_com_ins_cng').modal('hide');
					fn_search_list();
				}
			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_com_ins_cng" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="common.reg_default_setting"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="comRegForm">
							<fieldset>
								<div class="form-group row">
									<label for="com_db_svr_nm" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.dbms_name"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="com_db_svr_nm" name="com_db_svr_nm"  disabled />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="com_ipadr" name="com_ipadr"  disabled />
									</div>
								</div>
							
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-3 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.max_clusters"/>
											<span style="width: 600px;"><spring:message code="help.eXperDB_scale_set_msg08" /></span>
										</a>

									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" maxlength="5" id="com_max_clusters" name="com_max_clusters" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />'>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_min_clusters" class="col-sm-3 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.min_clusters"/>
											<span style="width: 600px;"><spring:message code="help.eXperDB_scale_set_msg07" /></span>
										</a>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" maxlength="5" id="com_min_clusters" name="com_min_clusters" onKeyUp="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />'>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_auto_run_cycle" class="col-sm-3 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.auto_execution_cycle"/>
											<span style="width: 500px;"><spring:message code="help.eXperDB_scale_set_msg12" /></span>
										</a>
									</label>
									<div class="col-sm-8">
										<input type="text" class="form-control" maxlength="2" id="com_auto_run_cycle" name="com_auto_run_cycle" onKeyUp="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg16" />' disabled>
									</div>
									<label class="col-sm-1 col-form-label"><spring:message code="eXperDB_scale.time_minute"/></label>
								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" value='<spring:message code="common.registory" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>