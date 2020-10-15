<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		$("#comConModForm").validate({
			rules: {
				mod_com_trans_cng_nm: {
					required: true
				},
				mod_com_heartbeat_interval_ms: {
					number: true
				},
				mod_com_max_batch_size: {
					number: true
				},
				mod_com_max_queue_size: {
					number: true
				},
				mod_com_offset_flush_interval_ms: {
					number: true
				},
				mod_com_offset_flush_timeout_ms: {
					number: true
				}
			},
			messages: {
				mod_com_trans_cng_nm: {
					required: '<spring:message code="data_transfer.msg32" />'
				},
				mod_com_heartbeat_interval_ms: {
					number: '<spring:message code="eXperDB_scale.msg15" />'
				},
				mod_com_max_batch_size: {
					number: '<spring:message code="eXperDB_scale.msg15" />'
				},
				mod_com_max_queue_size: {
					number: '<spring:message code="eXperDB_scale.msg15" />'
				},
				mod_com_offset_flush_interval_ms: {
					number: '<spring:message code="eXperDB_scale.msg15" />'
				},
				mod_com_offset_flush_timeout_ms: {
					number: '<spring:message code="eXperDB_scale.msg15" />'
				}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_com_con_set_update_wrk();
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
	function fn_transComConSetModPopStart(result) {
		$("#mod_com_trans_com_id","#comConModForm").val(nvlPrmSet(result.trans_com_id, "1"));
		$("#mod_com_trans_cng_nm","#comConModForm").val(nvlPrmSet(result.trans_com_cng_nm, ""));
		$("#mod_com_plugin_name","#comConModForm").val(nvlPrmSet(result.plugin_name, ""));
		$("#mod_com_heartbeat_interval_ms","#comConModForm").val(nvlPrmSet(result.heartbeat_interval_ms, ""));
		$("#mod_com_heartbeat_action_query","#comConModForm").val(nvlPrmSet(result.heartbeat_action_query, ""));
		$("#mod_com_max_batch_size","#comConModForm").val(nvlPrmSet(result.max_batch_size, ""));
		$("#mod_com_max_queue_size","#comConModForm").val(nvlPrmSet(result.max_queue_size, ""));
		$("#mod_com_offset_flush_interval_ms","#comConModForm").val(nvlPrmSet(result.offset_flush_interval_ms, ""));
		$("#mod_com_offset_flush_timeout_ms","#comConModForm").val(nvlPrmSet(result.offset_flush_timeout_ms, ""));
		$(':radio[name="mod_com_auto_create_chk"]:checked').val(nvlPrmSet(result.auto_create, "true"));

		if (nvlPrmSet(result.transforms_yn, "") == "Y") {
			$("input:checkbox[id='mod_com_transforms_yn_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_com_transforms_yn_chk']").prop("checked", false); 
		}
	}
	
	
	
	/* ********************************************************
	 * insert 실행
	 ******************************************************** */
	function fnc_com_con_set_update_wrk() {
		if($("#mod_com_transforms_yn_chk", "#comConModForm").is(":checked") == true){
			$("#mod_com_transforms_yn", "#comConModForm").val("Y");
		} else {
			$("#mod_com_transforms_yn", "#comConModForm").val("N");
		}
		
		$.ajax({
			async : false,
			url : "/transComConCngWrite.do",
		  	data : {
				trans_com_id : nvlPrmSet($("#mod_com_trans_com_id","#comConModForm").val(), ""),
				trans_com_cng_nm : nvlPrmSet($("#mod_com_trans_cng_nm","#comConModForm").val(), ""),
				plugin_name : nvlPrmSet($("#mod_com_plugin_name","#comConModForm").val(),''),
				heartbeat_interval_ms : nvlPrmSet($("#mod_com_heartbeat_interval_ms","#comConModForm").val(),''),
				heartbeat_action_query : nvlPrmSet($("#mod_com_heartbeat_action_query","#comConModForm").val(),''),
				max_batch_size : nvlPrmSet($("#mod_com_max_batch_size","#comConModForm").val(),''),
				max_queue_size : nvlPrmSet($("#mod_com_max_queue_size","#comConModForm").val(),''),
				offset_flush_interval_ms : nvlPrmSet($("#mod_com_offset_flush_interval_ms","#comConModForm").val(),''),
				offset_flush_timeout_ms : nvlPrmSet($("#mod_com_offset_flush_timeout_ms","#comConModForm").val(),''),
				auto_create : $(':radio[name="mod_com_auto_create_chk"]:checked').val(),
				transforms_yn : nvlPrmSet($("#mod_com_transforms_yn","#comConModForm").val(), "N")
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
					$('#pop_layer_con_com_mod_cng').modal('show');
					return false;
				}else{
					showSwalIcon('<spring:message code="message.msg144"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_con_com_mod_cng').modal('hide');
					fn_trans_com_con_pop_search();
				}
			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_con_com_mod_cng" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index: 1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 350px;">
		<div class="modal-content" style="width:1040px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.mod_default_setting"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="comConModForm">
							<input type="hidden" name="mod_com_trans_com_id" id="mod_com_trans_com_id" value=""/>
							<input type="hidden" name="mod_com_transforms_yn" id="mod_com_transforms_yn" value=""/>

							<fieldset>
								<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-10px;">
									<div class="col-12" >
										<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="mod_server-tab" role="tablist">
											<li class="nav-item" style="max-width:20%;">
												<a class="nav-link active" id="mod-dump-tab-1" data-toggle="pill" href="#modComConSetTab1" role="tab" aria-controls="modComConSetTab1" aria-selected="true" >
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
									<div class="tab-pane fade show active" role="tabpanel" id="modComConSetTab1">
										<div class="form-group row" style="margin-top:-20px;">										
											<label for="mod_com_trans_cng_nm" class="col-sm-3 col-form-label pop-label-index">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.default_setting_name" />
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="50" id="mod_com_trans_cng_nm" name="mod_com_trans_cng_nm" onKeyUp="fn_checkWord(this,50);" onblur="this.value=this.value.trim()" placeholder="50<spring:message code='message.msg188'/>" tabindex=1 />
											</div>
										</div>

										<div class="form-group row" style="margin-top:-20px;">										
											<label for="mod_com_plugin_name" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													plugin.name
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg01" /></span>
												</a>
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="100" id="mod_com_plugin_name" name="mod_com_plugin_name" onKeyUp="fn_checkWord(this,100);" onblur="this.value=this.value.trim()" placeholder="100<spring:message code='message.msg188'/>" tabindex=2 />
											</div>
										</div>

										<div class="form-group row" style="margin-top:-15px;">
											<label for="mod_com_heartbeat_interval_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													heartbeat.interval.ms
													<span style="width: 800px;"><spring:message code="help.data_transfer_com_set_msg02" /></span>
												</a>
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="mod_com_heartbeat_interval_ms" name="mod_com_heartbeat_interval_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=3 />
											</div>
										</div>
												
										<div class="form-group row" style="margin-top:-15px;">
											<label for="mod_com_heartbeat_action_query" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													heartbeat.action.query
													<span style="width: 800px;"><spring:message code="help.data_transfer_com_set_msg03" /></span>
												</a>
		
											</label>
											<div class="col-sm-9">
												<input hidden="hidden" />
												<textarea class="form-control" id="mod_com_heartbeat_action_query" name="mod_com_heartbeat_action_query" rows="2"  tabindex=4></textarea>
											</div>
										</div>
												
										<div class="form-group row" >
											<label for="mod_com_max_batch_size" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													max.batch.size
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg04" /></span>
												</a>
		
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="mod_com_max_batch_size" name="mod_com_max_batch_size" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=5 />
											</div>
											<label for="mod_com_max_queue_size" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													max.queue.size
													<span style="width: 400px;"><spring:message code="help.data_transfer_com_set_msg05" /></span>
												</a>
		
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="mod_com_max_queue_size" name="mod_com_max_queue_size" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=6 />
											</div>
										</div>

										<div class="form-group row" style="margin-top:-15px;">
											<label for="mod_com_offset_flush_interval_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													offset.flush.interval.ms
													<span style="width: 600px;"><spring:message code="help.data_transfer_com_set_msg06" /></span>
												</a>
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="mod_com_offset_flush_interval_ms" name="mod_com_offset_flush_interval_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=6 />
											</div>
											<label for="mod_com_offset_flush_timeout_ms" class="col-sm-3 col-form-label pop-label-index">
												<a href="#" class="tip" onclick="return false;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													offset.flush.timeout.ms
													<span style="width: 550px;"><spring:message code="help.eXperDB_scale_set_msg08" /></span>
												</a>
											</label>
											<div class="col-sm-3">
												<input hidden="hidden" />
												<input type="text" class="form-control" maxlength="10" id="mod_com_offset_flush_timeout_ms" name="mod_com_offset_flush_timeout_ms" onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' tabindex=7 />
											</div>
										</div>
										
										<div class="form-group row" style="margin-top:-15px;margin-bottom:-20px;">
											<label for="mod_com_transforms_yn_chk" class="col-sm-3 col-form-label pop-label-index" style="margin-top:-10px">
												<i class="item-icon fa fa-dot-circle-o"></i>
												transform route <spring:message code="user_management.use_yn" />
											</label>
											<div class="col-sm-9">
												<div class="onoffswitch-pop">
													<input type="checkbox" name="mod_com_transforms_yn_chk" class="onoffswitch-pop-checkbox" id="mod_com_transforms_yn_chk" />
													<label class="onoffswitch-pop-label" for="mod_com_transforms_yn_chk">
														<span class="onoffswitch-pop-inner"></span>
														<span class="onoffswitch-pop-switch"></span>
													</label>
												</div>
											</div>
										</div>
									</div>
											
									<div class="tab-pane fade" role="tabpanel" id="insComConSetTab2">
										<div class="form-group row" style="margin-top:-30px;margin-bottom:-40px;">
											<label for="mod_com_plugin_name" class="col-sm-3 col-form-label">
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
															<label class="form-check-label" for="mod_com_auto_create_chk_y">
																<input type="radio" class="form-check-input" name="mod_com_auto_create_chk" id="mod_com_auto_create_chk_y" value="true" checked/>
		                          								true
		                          							</label>
		                          						</div>
		                          					</div>
		                          					<div class="col-sm-6">
		                          						<div class="form-check">
		                          							<label class="form-check-label" for="mod_com_auto_create_chk_n">
		                          								<input type="radio" class="form-check-input" name="mod_com_auto_create_chk" id="mod_com_auto_create_chk_n" value="false" />
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
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" value='<spring:message code="common.modify" />' />
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