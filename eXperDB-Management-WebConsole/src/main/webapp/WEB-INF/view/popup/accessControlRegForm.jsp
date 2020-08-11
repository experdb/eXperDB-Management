<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : accessControlRegForm.jsp
	* @Description : accessControlRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26
	*
	*/
%>
<script>

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {	
		/* ********************************************************
		 * 데이터베이스 셋팅
		 ******************************************************** */
	    $("#ins_ctf_tp_nm", "#accessRegForm").change( function(){
			if (this.value == "local") {
				$("#ins_ip", "#accessRegForm").attr("disabled", "true");
				$("#ins_prefix", "#accessRegForm").attr("disabled", "true");
				$("#ins_ipmaskadr", "#accessRegForm").attr("disabled", "true");
				$("#ins_ip", "#accessRegForm").val("");
				$("#ins_prefix", "#accessRegForm").val("");
				$("#ins_ipmaskadr", "#accessRegForm").val("");
			} else {
				$("#ins_ip", "#accessRegForm").removeAttr("disabled");
				$("#ins_prefix", "#accessRegForm").removeAttr("disabled");
				$("#ins_ipmaskadr", "#accessRegForm").removeAttr("disabled");
				
				var prefix = $("#ins_prefix", "#accessRegForm").val();
				if(prefix !=""){
					$("#ins_ipmaskadr", "#accessRegForm").attr('disabled', 'true');
					$("#ins_ipmaskadr", "#accessRegForm").val("");
				}

				var prms_ipmaskadr = $("#ins_ipmaskadr", "#accessRegForm").val();
				if(prms_ipmaskadr !=""){
					$("#ins_prefix", "#accessRegForm").attr("disabled", "true");
					$("#ins_prefix", "#accessRegForm").val("");
				}
			}
	    });
		
		/* ********************************************************
		 * Prefix 변경
		 ******************************************************** */
		$("#ins_prefix", "#accessRegForm").keyup(function() { 
			if(this.value==""){
				$('#ins_ipmaskadr', "#accessRegForm").removeAttr("disabled");
			}else{
				$('#ins_ipmaskadr', "#accessRegForm").attr("disabled", "true");
			}
		});
		
		/* ********************************************************
		 * Ipmaskadr 변경
		 ******************************************************** */
		$("#ins_ipmaskadr", "#accessRegForm").keyup(function() { 
			if(this.value==""){
				$("#ins_prefix", "#accessRegForm").removeAttr("disabled");
			}else{
				$("#ins_prefix", "#accessRegForm").attr("disabled", "true");
			}
		});
		
		/* ********************************************************
		 * 메소드 변경
		 ******************************************************** */
	    $("#ins_ctf_mth_nm", "#accessRegForm").change( function(){
	    	var ctf_mth_nm = this.value;

			if(ctf_mth_nm=="ident" || ctf_mth_nm=="pam" || ctf_mth_nm=="ldap" || ctf_mth_nm=="gss" || ctf_mth_nm=="sspi" ||
				ctf_mth_nm=="cert" || ctf_mth_nm=="crypt"){
				$("#ins_opt_nm", "#accessRegForm").removeAttr("disabled");
			}else{
				$("#ins_opt_nm", "#accessRegForm").attr("disabled", "true");
			}
	    });

		/* ********************************************************
		 * validate
		 ******************************************************** */
	    $("#accessRegForm").validate({
	        rules: {
	        	ins_ip: {
	        		required: function(){
	        			if ($("#ins_ctf_tp_nm option:selected", "#accessRegForm").val() != "local") {
	        				if(nvlPrmSet($("#ins_ip", "#accessRegForm").val(),"") == "") {
	        					 return true;
	        				}
	        			}
	        			return false;
	        		}
				},
				ins_prefix: {
					max:32,
					number: true
				}
	        },
	        messages: {
	        	ins_ip: {
					required: '<spring:message code="message.msg62" />',
				},
				ins_prefix: {
					max: '<spring:message code="message.msg64" />',
					number: '<spring:message code="message.msg63" />'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				if ($("#act", "#findList").val() == "i") {
					fn_accessPopInsert();
				} else {
					fn_accessPopUpdate();
				}
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
	 * input 박스 초기 셋팅
	 ******************************************************** */
	function fn_initInputSet() {
		var ctf_tp_nm = $("#ins_ctf_tp_nm option:selected", "#accessRegForm").val();
		if (ctf_tp_nm == "local") {
			$("#ins_ip", "#accessRegForm").attr("disabled", "true");
			$("#ins_prefix", "#accessRegForm").attr('disabled', "true");
			$("#ins_ipmaskadr", "#accessRegForm").attr("disabled", "true");
		}
		
		var ctf_mth_nm = $("#ins_ctf_mth_nm option:selected", "#accessRegForm").val();
		if(ctf_mth_nm=="ident" || ctf_mth_nm=="pam" || ctf_mth_nm=="ldap" || ctf_mth_nm=="gss" || ctf_mth_nm=="sspi" 
			|| ctf_mth_nm=="cert" || ctf_mth_nm=="crypt"){
			$("#ins_opt_nm", "#accessRegForm").removeAttr("disabled");
		}else{
			$("#ins_opt_nm", "#accessRegForm").attr("disabled", "true");
		}
	}

	/* ********************************************************
	 * 추가 실행
	 ******************************************************** */
	function fn_accessPopInsert() {
		var type = $("#ins_ctf_tp_nm", "#accessRegForm").val();
		var prms_ipadr = "";

		if(type != "local") {
			var ins_ip = nvlPrmSet($("#ins_ip", "#accessRegForm").val(), "");
			var ins_prefix = nvlPrmSet($("#ins_prefix", "#accessRegForm").val(), "");

			if(ins_prefix!=""){
				prms_ipadr = ins_ip + "/" + ins_prefix;	
			}else{
				prms_ipadr = ins_ip;
			}	
		}

		accessResult = new Object();

		accessResult.prms_ipmaskadr = nvlPrmSet($("#ins_ipmaskadr", "#accessRegForm").val(), "");
		accessResult.prms_ipadr = prms_ipadr;
		accessResult.dtb = $("#ins_dtb", "#accessRegForm").val();
		accessResult.prms_usr_id = $("#ins_usr_id", "#accessRegForm").val();
		accessResult.ctf_mth_nm = $("#ins_ctf_mth_nm", "#accessRegForm").val();
		accessResult.ctf_tp_nm = $("#ins_ctf_tp_nm", "#accessRegForm").val();
		accessResult.opt_nm = nvlPrmSet($("#ins_opt_nm", "#accessRegForm").val(), "");
		
		var returnCheck= fn_isnertSave(accessResult);
		
		if(returnCheck==false){
			showSwalIcon('<spring:message code="message.msg28" />', '<spring:message code="common.close" />', '', 'error');
			$('#pop_layer_access_reg').modal("show");
		}else{
			$('#pop_layer_access_reg').modal("hide");

			$('#nowpwd_alert-danger').show();
			
			showDangerToast('top-right', '<spring:message code="access_control_management.msg2" />', '<spring:message code="access_control_management.msg3" />');
		}
	}

	/* ********************************************************
	 * 수정 실행
	 ******************************************************** */
	function fn_accessPopUpdate() {
		var type = $("#ins_ctf_tp_nm", "#accessRegForm").val();
		var prms_ipadr = "";

		if(type != "local") {
			var ins_ip = nvlPrmSet($("#ins_ip", "#accessRegForm").val(), "");
			var ins_prefix = nvlPrmSet($("#ins_prefix", "#accessRegForm").val(), "");

			if(ins_prefix!=""){
				prms_ipadr = ins_ip + "/" + ins_prefix;	
			}else{
				prms_ipadr = ins_ip;
			}
		}
		
		accessResult = new Object();
        
		accessResult.idx = $("#idx", "#findList").val();
		accessResult.prms_ipmaskadr = nvlPrmSet($("#ins_ipmaskadr", "#accessRegForm").val(), "");
		accessResult.prms_ipadr = prms_ipadr;
		accessResult.dtb = $("#ins_dtb", "#accessRegForm").val();
		accessResult.prms_usr_id = $("#ins_usr_id", "#accessRegForm").val();
		accessResult.ctf_mth_nm = $("#ins_ctf_mth_nm", "#accessRegForm").val();
		accessResult.ctf_tp_nm = $("#ins_ctf_tp_nm", "#accessRegForm").val();
		accessResult.opt_nm = nvlPrmSet($("#ins_opt_nm", "#accessRegForm").val(), "");

		var returnCheck = fn_updateSave(accessResult);
		if( returnCheck == false){
			showSwalIcon('<spring:message code="message.msg136" />', '<spring:message code="common.close" />', '', 'error');
			$('#pop_layer_access_reg').modal("show");
		}else{
			$('#pop_layer_access_reg').modal("hide");

			$('#nowpwd_alert-danger').show();
			
			showDangerToast('top-right', '<spring:message code="access_control_management.msg2" />', '<spring:message code="access_control_management.msg3" />');
		}
	}
</script>


<div class="modal fade" id="pop_layer_access_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content" >		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_ins" style="padding-left:5px;">
					<spring:message code="menu.access_control" /> <spring:message code="common.registory" />
				</h4>
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_udt" style="padding-left:5px;">
					<spring:message code="menu.access_control" />  <spring:message code="common.modify" />
				</h4>
				
				<form class="cmxform" id="accessRegForm" name="accessRegForm" >
					<fieldset>
						<div class="card" style="margin-top:10px;border:0px;">
							<div class="card-body">
								<div class="form-group row border-bottom">
									<label for="ins_db_svr_nm" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.dbms_name" />
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="ins_db_svr_nm" name="ins_db_svr_nm" readonly />
									</div>
									
									<label for="ins_dtb" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database
									</label>
									<div class="col-sm-4">
										<select class="form-control selectSearch w-100" style="margin-right: 1rem;width: 100% !important;" name="ins_dtb" id="ins_dtb" tabindex=1 >
											<option value="all">all</option>
											<option value="replication">replication</option>
											
											<c:forEach var="resultSet" items="${resultSet}" varStatus="status">
												<option value="<c:out value="${resultSet.db_nm}"/>" >
													<c:out value="${resultSet.db_nm}"/>
													<c:if test="${!empty resultSet.db_exp}">(${resultSet.db_exp})</c:if>
												</option>
											</c:forEach>
										</select>
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_ctf_tp_nm" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Type
									</label>
									<div class="col-sm-4">
										<select class="form-control selectSearch w-100" style="margin-right: 1rem;width: 100% !important;" name="ins_ctf_tp_nm" id="ins_ctf_tp_nm" tabindex=2 >
											<c:forEach var="resultType" items="${resultType}" varStatus="status">
												<option value="<c:out value="${resultType.ctf_tp_nm}"/>" >
													<c:out value="${resultType.ctf_tp_nm}"/>
												</option>
											</c:forEach>
										</select>
									</div>
									
									<label for="ins_ip" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										IP (127.0.0.1/32)
									</label>
									<div class="col-sm-2">
										<input type="text" class="form-control" maxlength="30" id="ins_ip" name="ins_ip" onblur="this.value=this.value.trim()" tabindex=3 />
									</div>
									<label for="ins_prefix" class="col-sm-1 col-form-label" style="margin-top:-5px; max-width: 2%;">
										/
									</label>
									<div class="col-sm-2" style="max-width: 13.8%">
										<input type="text" class="form-control" maxlength="20" style="width:100%" id="ins_prefix" name="ins_prefix" onKeyUp="chk_Number(this);" onblur="this.value=this.value.trim()" tabindex=4 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										User
									</label>
									<div class="col-sm-4">
										<select class="form-control selectSearch w-100" style="margin-right: 1rem;width: 100% !important;height: 2.000rem;" name="ins_usr_id" id="ins_usr_id" tabindex=5 >
											<option value="all">all</option>
											
											<c:forEach var="resultUser" items="${resultUser.data}" varStatus="status">
												<option value="<c:out value="${resultUser.rolname}"/>" >
													<c:out value="${resultUser.rolname}"/>
												</option>
											</c:forEach>
										</select>
									</div>
									
									<label for="ins_ipmaskadr" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Ipmask
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="ins_ipmaskadr" name="ins_ipmaskadr" onblur="this.value=this.value.trim()" tabindex=6 />
									</div>
								</div>
								
								<div class="form-group row">
									<label for="ins_ctf_mth_nm" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Method
									</label>
									<div class="col-sm-4">
										<select class="form-control form-control-xsm selectSearch w-100" style="margin-right: 1rem;width: 100% !important;" name="ins_ctf_mth_nm" id="ins_ctf_mth_nm" tabindex=7 >
											<c:forEach var="resultMethod" items="${resultMethod}" varStatus="status">
												<option value="<c:out value="${resultMethod.ctf_mth_nm}"/>" >
													<c:out value="${resultMethod.ctf_mth_nm}"/>
												</option>
											</c:forEach>
										</select>
									</div>
									
									<label for="ins_opt_nm" class="col-sm-2 col-form-label" style="margin-top:-5px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Option
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="ins_opt_nm" name="ins_opt_nm" onblur="this.value=this.value.trim()" tabindex=8 />
									</div>
								</div>
								
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="submit" value='<spring:message code="common.save" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</div>
						</div>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</div>