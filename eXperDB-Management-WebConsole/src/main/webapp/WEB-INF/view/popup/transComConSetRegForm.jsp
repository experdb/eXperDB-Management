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

		$("#comConRegForm").validate({
			rules: {
					com_heartbeat_interval_ms: {
						number: true
					},
					com_max_batch_size: {
						number: true
					},
					com_max_queue_size: {
						number: true
					},
					com_offset_flush_interval_ms: {
						number: true
					},
					com_offset_flush_timeout_ms: {
						number: true
					}
			},
			messages: {
					com_heartbeat_interval_ms: {
						number: '<spring:message code="eXperDB_scale.msg15" />'
					},
					com_max_batch_size: {
						number: '<spring:message code="eXperDB_scale.msg15" />'
					},
					com_max_queue_size: {
						number: '<spring:message code="eXperDB_scale.msg15" />'
					},
					com_offset_flush_interval_ms: {
						number: '<spring:message code="eXperDB_scale.msg15" />'
					},
					com_offset_flush_timeout_ms: {
						number: '<spring:message code="eXperDB_scale.msg15" />'
					}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_com_con_set_insert_wrk();
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
	function fnc_com_con_set_insert_wrk() {
		if($("#com_transforms_yn_chk", "#comConRegForm").is(":checked") == true){
			$("#com_transforms_yn", "#comConRegForm").val("Y");
		} else {
			$("#com_transforms_yn", "#comConRegForm").val("N");
		}
		
		$.ajax({
			async : false,
			url : "/transComConCngWrite.do",
		  	data : {
				trans_com_id : nvlPrmSet($("#com_trans_com_id","#comConRegForm").val(), ""),
				plugin_name : nvlPrmSet($("#com_plugin_name","#comConRegForm").val(),''),
				heartbeat_interval_ms : nvlPrmSet($("#com_heartbeat_interval_ms","#comConRegForm").val(),''),
				heartbeat_action_query : nvlPrmSet($("#com_heartbeat_action_query","#comConRegForm").val(),''),
				max_batch_size : nvlPrmSet($("#com_max_batch_size","#comConRegForm").val(),''),
				max_queue_size : nvlPrmSet($("#com_max_queue_size","#comConRegForm").val(),''),
				offset_flush_interval_ms : nvlPrmSet($("#com_offset_flush_interval_ms","#comConRegForm").val(),''),
				offset_flush_timeout_ms : nvlPrmSet($("#com_offset_flush_timeout_ms","#comConRegForm").val(),''),
				auto_create : $(':radio[name="com_auto_create_chk"]:checked').val(),
				transforms_yn : nvlPrmSet($("#com_transforms_yn","#comConRegForm").val(), "N")
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
					validateMsg = '<spring:message code="eXperDB_scale.msg2"/>';

					showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_con_com_ins_cng').modal('show');
					return false;
				}else{
					showSwalIcon('<spring:message code="message.msg144"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_con_com_ins_cng').modal('hide');
					fn_tot_select();
				}
			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_con_com_ins_cng" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 80px 350px;">
		<div class="modal-content" style="width:1040px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="common.reg_default_setting"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="comConRegForm">
							<input type="hidden" name="com_trans_com_id" id="com_trans_com_id" value=""/>
							<input type="hidden" name="com_transforms_yn" id="com_transforms_yn" value=""/>

							<fieldset>
								<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-10px;">
									<div class="col-12" >
										<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
											<li class="nav-item" style="max-width:20%;">
												<a class="nav-link active" id="ins-dump-tab-1" data-toggle="pill" href="#insComConSetTab1" role="tab" aria-controls="insComConSetTab1" aria-selected="true" >
													<spring:message code="migration.source_system" />
												</a>
											</li>
<%-- 											<li class="nav-item">
												<a class="nav-link" id="ins-dump-tab-2" data-toggle="pill" href="#insComConSetTab2" role="tab" aria-controls="insComConSetTab2" aria-selected="false">
													<spring:message code="migration.target_system" />
												</a>
											</li> --%>
										</ul>
									</div>
								</div>
							
								<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;margin-bottom:-10px;">
									<div class="tab-pane fade show active" role="tabpanel" id="insComConSetTab1">
										<div class="form-group row" style="margin-top:-20px;">										
											<label for="com_plugin_name" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													plugin.name
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg01" /></span>
												</a>
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="100" id="com_plugin_name" name="com_plugin_name" onKeyUp="fn_checkWord(this,100);" onblur="this.value=this.value.trim()" placeholder="100<spring:message code='message.msg188'/>" tabindex=1 />
											</div>
										</div>

										<div class="form-group row" style="margin-top:-15px;">
											<label for="com_heartbeat_interval_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													heartbeat.interval.ms
													<span style="width: 800px;"><spring:message code="help.data_transfer_com_set_msg02" /></span>
												</a>
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="com_heartbeat_interval_ms" name="com_heartbeat_interval_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=2 />
											</div>
										</div>
												
										<div class="form-group row" style="margin-top:-15px;">
											<label for="com_heartbeat_action_query" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													heartbeat.action.query
													<span style="width: 800px;"><spring:message code="help.data_transfer_com_set_msg03" /></span>
												</a>
		
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<textarea class="form-control" id="com_heartbeat_action_query" name="com_heartbeat_action_query" rows="2"  tabindex=3></textarea>
											</div>
										</div>
												
										<div class="form-group row" >
											<label for="com_max_batch_size" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													max.batch.size
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg04" /></span>
												</a>
		
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="com_max_batch_size" name="com_max_batch_size" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=4 />
											</div>
											<label for="com_max_queue_size" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													max.queue.size
													<span style="width: 400px;"><spring:message code="help.data_transfer_com_set_msg05" /></span>
												</a>
		
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="com_max_queue_size" name="com_max_queue_size" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=5 />
											</div>
										</div>

										<div class="form-group row" style="margin-top:-15px;">
											<label for="com_offset_flush_interval_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													offset.flush.interval.ms
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg06" /></span>
												</a>
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="com_offset_flush_interval_ms" name="com_offset_flush_interval_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=6 />
											</div>
											<label for="com_offset_flush_timeout_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													offset.flush.timeout.ms
													<span style="width: 550px;"><spring:message code="help.eXperDB_scale_set_msg08" /></span>
												</a>
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="com_offset_flush_timeout_ms" name="com_offset_flush_timeout_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=7 />
											</div>
										</div>
										
										<div class="form-group row" style="margin-top:-15px;margin-bottom:-20px;">
											<label for="com_transforms_yn_chk" class="col-sm-3 col-form-label pop-label-index" style="margin-top:-10px">
												<i class="item-icon fa fa-dot-circle-o"></i>
												transform route <spring:message code="user_management.use_yn" />
											</label>
											<div class="col-sm-9">
												<div class="onoffswitch-pop">
													<input type="checkbox" name="com_transforms_yn_chk" class="onoffswitch-pop-checkbox" id="com_transforms_yn_chk" />
													<label class="onoffswitch-pop-label" for="com_transforms_yn_chk">
														<span class="onoffswitch-pop-inner"></span>
														<span class="onoffswitch-pop-switch"></span>
													</label>
												</div>
											</div>
										</div>
									</div>
											
									<div class="tab-pane fade" role="tabpanel" id="insComConSetTab2">
										<div class="form-group row" style="margin-top:-30px;margin-bottom:-40px;">
											<label for="com_plugin_name" class="col-sm-3 col-form-label">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													auto.create
													<span style="width: 600px;"><spring:message code="help.eXperDB_scale_set_msg08" /></span>
												</a>
											</label>
											<div class="col-sm-6">
												<div class="form-group row" style="margin-top:5px;">
													<div class="col-sm-6">
														<div class="form-check">
															<label class="form-check-label" for="com_auto_create_chk_y">
																<input type="radio" class="form-check-input" name="com_auto_create_chk" id="com_auto_create_chk_y" value="true" checked/>
		                          								true
		                          							</label>
		                          						</div>
		                          					</div>
		                          					<div class="col-sm-6">
		                          						<div class="form-check">
		                          							<label class="form-check-label" for="com_auto_create_chk_n">
		                          								<input type="radio" class="form-check-input" name="com_auto_create_chk" id="com_auto_create_chk_n" value="false" />
		                          								false
		                          							</label>
		                          						</div>
		                          					</div>
		                          				</div>
											</div>
											<div class="col-sm-3">
											</div>
										</div>
									</div>
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