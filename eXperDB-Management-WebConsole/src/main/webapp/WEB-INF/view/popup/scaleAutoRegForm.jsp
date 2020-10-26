<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : scaleAutoRegForm.jsp
	* @Description : scale Auto 설정 등록 화면
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
	var ins_scale_type_msg =  '<spring:message code="eXperDB_scale.scale_type" />';
	var ins_execute_type_msg = '<spring:message code="eXperDB_scale.execute_type" />';
	var ins_policy_type_msg = '<spring:message code="eXperDB_scale.policy_type" />';
	var ins_policy_time_msg = '<spring:message code="eXperDB_scale.policy_time" />';
	var ins_target_value_msg = '<spring:message code="eXperDB_scale.target_value" />';
	var insMsgValue = "";


	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
	    $("#insRegForm").validate({
	        rules: {
	        	ins_scale_type_cd: {
					required: true
				},
	        	ins_execute_type_cd: {
					required: true
				},
	        	ins_policy_type_cd: {
					required: true
				},
	        	ins_auto_policy_time: {
					required: true
				},
	        	ins_auto_level: {
					required: true
				},
	        	ins_expansion_clusters: {
	        		required: function(){
	        			if (nvlPrmSet($("#ins_scale_type_cd", "#insRegForm").val(),"") == "2" && nvlPrmSet($("#ins_execute_type_cd", "#insRegForm").val(),"") == "TC003402") {
	        				if(nvlPrmSet($("#ins_expansion_clusters", "#insRegForm").val(),"") == "") {
	        					 return true;
	        				}
	        			}
	        			return false;
	        		}
				}
	        },
	        messages: {
	        	ins_scale_type_cd: {
					required: '<spring:message code="eXperDB_scale.msg3" arguments="'+ ins_scale_type_msg +'" />'
				},
				ins_execute_type_cd: {
					required: '<spring:message code="eXperDB_scale.msg3" arguments="'+ ins_execute_type_msg +'" />'
				},
				ins_policy_type_cd: {
					required: '<spring:message code="eXperDB_scale.msg3" arguments="'+ ins_policy_type_msg +'" />'
				},
				ins_auto_policy_time: {
					required: '<spring:message code="eXperDB_scale.msg18" arguments="1" />'
				},
				ins_auto_level: {
					required: '<spring:message code="eXperDB_scale.msg18" arguments="1" />'
				},
				ins_expansion_clusters: {
					required: '<spring:message code="eXperDB_scale.msg18" arguments="1" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_insert_wrk();
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
	 * insert button click
	 ******************************************************** */
 	function fnc_insert_wrk() {
		//화면 valid check
		if (!valCheck()) return false;
		
		var ins_min_clusters_val = nvlPrmSet($("#ins_min_clusters", "#insRegForm").val(), "");
		var ins_max_clusters_val = nvlPrmSet($("#ins_max_clusters", "#insRegForm").val(), "");
		var ins_expansion_clusters_val = nvlPrmSet($("#ins_expansion_clusters", "#insRegForm").val(), "");

		$.ajax({
			async : false,
			url : "/scale/popup/scaleCngWrite.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id","#findList").val(),
		  		scale_type_cd : $("#ins_scale_type_cd", "#insRegForm").val(),
		  		execute_type_cd : $("#ins_execute_type_cd", "#insRegForm").val(),
		  		policy_type_cd : $("#ins_policy_type_cd", "#insRegForm").val(),
		  		auto_policy_time : $("#ins_auto_policy_time", "#insRegForm").val(),
		  		auto_level : $("#ins_auto_level", "#insRegForm").val(),
		  		min_clusters : ins_min_clusters_val,
		  		max_clusters : ins_max_clusters_val,
		  		expansion_clusters : ins_expansion_clusters_val,
		  		auto_policy_set_div : $(':radio[name="ins_auto_policy_set_div"]:checked').val(),
		  		useyn : $(':radio[name="ins_useyn"]:checked').val()
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
				if(result == "O"){//중복
					showSwalIcon('<spring:message code="eXperDB_scale.msg5"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_ins_cng').modal('show');
					return false;
				}else if(result == "F"){//저장실패
					showSwalIcon('<spring:message code="eXperDB_scale.msg2"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_ins_cng').modal('show');
					return false;
				}else{
					showSwalIcon('<spring:message code="message.msg144"/>', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_ins_cng').modal('hide');
					fn_search_list();
				}
			}
		});
	}
	
	/* ********************************************************
	 * screen valid check
	 ******************************************************** */
 	function valCheck(){
		var totMsg = "";

 		if (nvlPrmSet($("#ins_scale_type_cd", "#insRegForm").val(),"") == "1" && nvlPrmSet($("#ins_execute_type_cd", "#insRegForm").val(),"") == "TC003402") { //scale-in / auto-scale
  			if(nvlPrmSet($("#ins_min_clusters", "#insRegForm").val(),"") == "") { 
 				insMsgValue = '<spring:message code="eXperDB_scale.min_clusters" />';
 				totMsg = '<spring:message code="eXperDB_scale.msg19" arguments="'+ insMsgValue +'" />' + "\n" +'<spring:message code="eXperDB_scale.msg20" />';
 				showSwalIcon(totMsg, '<spring:message code="common.close" />', '', 'error');
 				return false;
 			} 
 		} else if (nvlPrmSet($("#ins_scale_type_cd", "#insRegForm").val(),"") == "2" && nvlPrmSet($("#ins_execute_type_cd", "#insRegForm").val(),"") == "TC003402") { //scale-out / auto-scale
  			if(nvlPrmSet($("#ins_max_clusters", "#insRegForm").val(),"") == "") { 
 				insMsgValue = '<spring:message code="eXperDB_scale.max_clusters" />';
 				totMsg = '<spring:message code="eXperDB_scale.msg19" arguments="'+ insMsgValue +'" />' + "\n" +'<spring:message code="eXperDB_scale.msg20" />';
 				showSwalIcon(totMsg, '<spring:message code="common.close" />', '', 'error');
 				return false;
 			}
 		}
		
		return true;
	}

	/* ********************************************************
	 * scale 유형 / 실행유형 변경에 따른 최소/최대 클러수터 변경
	 ******************************************************** */
	function fn_ins_scale_type_chg() {
		var scale_type_cd = nvlPrmSet($("#ins_scale_type_cd", "#insRegForm").val(),""); //scale 유형
		var execute_type_cd = nvlPrmSet($("#ins_execute_type_cd", "#insRegForm").val(),""); //실행유형
		
		if (scale_type_cd == "1" && execute_type_cd == "TC003402") { //scale-in / auto-scale
			$("#ins_min_clusters", "#insRegForm").val($("#ins_min_clusters_hd", "#insRegForm").val());
			$("#ins_max_clusters", "#insRegForm").val("");
			$("#ins_expansion_clusters", "#insRegForm").prop('disabled', true);
			
			$("#ins_expansion_clusters", "#insRegForm").val("");
			
			if ($("#ins_min_clusters", "#insRegForm").val() == "") {
				$("#ins_min_clusters", "#insRegForm").val("2");
			}
		} else if (scale_type_cd == "2" && execute_type_cd == "TC003402") { //scale-out / auto-scale
			$("#ins_max_clusters", "#insRegForm").val($("#ins_max_clusters_hd", "#insRegForm").val());
			$("#ins_min_clusters", "#insRegForm").val("");
			
			$("#ins_expansion_clusters", "#insRegForm").prop('disabled', false);
		} else {
			$("#ins_max_clusters", "#insRegForm").val("");
			$("#ins_min_clusters", "#insRegForm").val("");
			$("#ins_expansion_clusters", "#insRegForm").val("");
			$("#ins_expansion_clusters", "#insRegForm").prop('disabled', true);
		}
	}

	/* ********************************************************
	 * 정책유형에 따른 %표시 출력
	 ******************************************************** */
	function fn_ins_policy_type_chg() {
		var policy_type_cd = nvlPrmSet($("#ins_policy_type_cd", "#insRegForm").val(),""); //정책유형

		if (policy_type_cd == "TC003501") { //cpu
			$("#ins_check_execute_sp", "#insRegForm").show();
		} else {
			$("#ins_check_execute_sp", "#insRegForm").hide();
		}
	}
</script>

<div class="modal fade" id="pop_layer_ins_cng" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.Register_auto_scale_setting" />
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="insRegForm">
							<input type="hidden" name="ins_min_clusters_hd" id="ins_min_clusters_hd" value=""/>
							<input type="hidden" name="ins_max_clusters_hd" id="ins_max_clusters_hd" value=""/>

							<fieldset>
								<div class="form-group row">
									<label for="ins_scale_type_cd" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" onclick="return false;" class="tip">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.scale_type" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg01" /></span>
										</a>
									</label>

									<div class="col-sm-4">
										<select class="form-control" style="width:200px; margin-right: 1rem;" onChange="fn_ins_scale_type_chg();" name="ins_scale_type_cd" id="ins_scale_type_cd" tabindex=1>
											<option value=""><spring:message code="common.choice" /></option>
											<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
											<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
										</select>
									</div>
									
									<label for="ins_execute_type_cd" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" onclick="return false;" class="tip">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.execute_type" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg02" /></span>
										</a>
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="width:200px; margin-right: 1rem;" name="ins_execute_type_cd" id="ins_execute_type_cd" onChange="fn_ins_scale_type_chg();" tabindex=2>
											<option value=""><spring:message code="common.choice" /></option>
											<c:forEach var="result" items="${executeTypeList}" varStatus="status">
												<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:forEach>
										</select>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_policy_type_cd" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.policy_type"/>
											<span style="width: 350px;"><spring:message code="help.eXperDB_scale_set_msg03" /></span>
										</a>
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="width:200px; margin-right: 1rem;" name="ins_policy_type_cd" id="ins_policy_type_cd" onChange="fn_ins_policy_type_chg();" tabindex=3>
											<option value=""><spring:message code="common.choice" /></option>
											<c:forEach var="result" items="${policyTypeList}" varStatus="status">
												<c:if test="${result.sys_cd == 'TC003501'}">
													<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
												</c:if>
											</c:forEach>
										</select>										
									</div>
									
									<label for="ins_useyn_1" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="form-group row">
											<div class="col-sm-6">
												<div class="form-check">
													<label class="form-check-label" for="ins_useyn_1">
														<input type="radio" class="form-check-input" name="ins_useyn" id="ins_useyn_1" value="Y" checked tabindex=5 />
                          								<spring:message code="dbms_information.use"/>
                          							</label>
                          						</div>
                          					</div>
                          					<div class="col-sm-6">
                          						<div class="form-check">
                          							<label class="form-check-label" for="ins_useyn_2">
                          								<input type="radio" class="form-check-input" name="ins_useyn" id="ins_useyn_2" value="N" tabindex=6 />
                          								<spring:message code="dbms_information.unuse"/>
                          							</label>
                          						</div>
                          					</div>
                          				</div>										
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_auto_policy_set_div_1" class="col-sm-2_3 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.policy_time_div" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg04" /></span>
										</a>
									</label>
									<div class="col-sm-3">
										<div class="form-group row">
											<div class="col-sm-6">
												<div class="form-check">
													<label class="form-check-label" for="ins_auto_policy_set_div_1">
														<input type="radio" class="form-check-input" name="ins_auto_policy_set_div" id="ins_auto_policy_set_div_1" value="1" checked tabindex=4 />
                          								<spring:message code="eXperDB_scale.policy_time_1"/>
                          							</label>
                          						</div>
                          					</div>
                          					<div class="col-sm-6">
                          						<div class="form-check">
                          							<label class="form-check-label" for="ins_auto_policy_set_div_2">
                          								<input type="radio" class="form-check-input" name="ins_auto_policy_set_div" id="ins_auto_policy_set_div_2" value="2" tabindex=4 />
                          								<spring:message code="eXperDB_scale.policy_time_2"/>
                          							</label>
                          						</div>
                          					</div>
                          				</div>										
									</div>

									<label for="ins_auto_policy_time" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.policy_time" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg05" /></span>
										</a>
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control" maxlength="5" id="ins_auto_policy_time" name="ins_auto_policy_time" onKeyPress="chk_Number(this);" placeholder='<spring:message code='eXperDB_scale.msg16'/>' onblur="this.value=this.value.trim()" tabindex=6 />
									</div>
									<label class="col-sm-1 col-form-label"><spring:message code="eXperDB_scale.time_minute"/></label>
								</div>
								
								<div class="form-group row">
									<label for="ins_auto_level" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.target_value" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg06" /></span>
										</a>
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control" maxlength="10" id="ins_auto_level" name="ins_auto_level" onKeyUp="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />' onblur="this.value=this.value.trim()" tabindex=7 />
									</div>
									<label class="col-sm-1 col-form-label">
										<span id="ins_check_execute_sp">	
											%
										</span>
									</label>
									
									<label for="ins_expansion_clusters" class="col-sm-2_5 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.expansion_clusters" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg09" /></span>
										</a>
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control" maxlength="5" id="ins_expansion_clusters" name="ins_expansion_clusters" onKeyUp="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg15" />'  onblur="this.value=this.value.trim()" tabindex=8 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_min_clusters" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.min_clusters" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg10" /></span>
										</a>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="5" id="ins_min_clusters" name="ins_min_clusters" onKeyUp="chk_Number(this);" onblur="this.value=this.value.trim()" tabindex=9 disabled/>
									</div>
									<label for="ins_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<a href="#" class="tip" onclick="return false;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="eXperDB_scale.max_clusters" />
											<span style="width: 450px;"><spring:message code="help.eXperDB_scale_set_msg11" /></span>
										</a>
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" maxlength="5" id="ins_max_clusters" name="ins_max_clusters" onKeyUp="chk_Number(this);" onblur="this.value=this.value.trim()" tabindex=10 disabled />
									</div>
								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.registory" />' />
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