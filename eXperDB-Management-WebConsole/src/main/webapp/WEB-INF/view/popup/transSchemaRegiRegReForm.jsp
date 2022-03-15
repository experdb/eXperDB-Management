<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	var mod_regi_connectNmMsg = '<spring:message code="etc.etc04" />';
	var mod_regi_ip_msg = '<spring:message code="data_transfer.ip" />';
	var mod_regi_port_msg = '<spring:message code="data_transfer.port" />';

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		$("#modTransScheRegiRegForm").validate({
			rules: {
					mod_trans_regi_nm: {
						required: true
					},
					mod_trans_regi_ip: {
						required: true
					},
					mod_trans_regi_port: {
						required: true,
						number: true
					},
			},
			messages: {
					mod_trans_regi_nm: {
						required: '<spring:message code="errors.required" arguments="'+ mod_regi_connectNmMsg +'" />'
					},
					mod_trans_regi_ip: {
						required: '<spring:message code="errors.required" arguments="'+ mod_regi_ip_msg +'" />'
					},
					mod_trans_regi_port: {
						required: '<spring:message code="errors.required" arguments="'+ mod_regi_port_msg +'" />',
						number: '<spring:message code="eXperDB_scale.msg15" />'
					}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_mod_trans_regi_wrk();
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
	 * Validation Check
	 ******************************************************** */
	function mod_trans_regi_upd_valCheck(){
		var valideMsg = "";
		if(nvlPrmSet($("#mod_trans_regi_Chk", "#modTransScheRegiRegForm").val(), '') == "" || nvlPrmSet($("#mod_trans_regi_Chk", "#modTransScheRegiRegForm").val(), '') == "fail") {
			showSwalIcon('Schema Registry ' + '<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}

		return true;
	}

	/* ********************************************************
	 * 커넥터 연결테스트
	 ******************************************************** */
	function fn_mod_trans_regiConnectTest() {
		var regiIp = nvlPrmSet($("#mod_trans_regi_ip","#modTransScheRegiRegForm").val(),'');
		var regiPort=	nvlPrmSet($("#mod_trans_regi_port","#modTransScheRegiRegForm").val(),'');

		if(regiIp == "") {
			showSwalIcon('<spring:message code="errors.required" arguments="'+ mod_regi_ip_msg +'" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		} else if(regiPort == "") {
			showSwalIcon('<spring:message code="errors.required" arguments="'+ mod_regi_port_msg +'" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}
		
		$.ajax({
			url : '/kafkaConnectionTest.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				regiIP : regiIp,
				regiPort : regiPort,
				connect_gbn : "schema"
			},
			success : function(result) {
				if(result.RESULT_DATA =="success"){
					$("#mod_trans_regi_Chk","#modTransScheRegiRegForm").val("success");
					showSwalIcon('Schema Registry-Connection ' + '<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
				}else{
					$("#mod_trans_regi_Chk","#modTransScheRegiRegForm").val("fail")
					showSwalIcon('Schema Registry-Connection ' + '<spring:message code="message.msg92"/>', '<spring:message code="common.close" />', '', 'error');
				}
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
			}
		});
		$('#loading').hide();
	}

	/* ********************************************************
	 * 팝업시작
	 ******************************************************** */
	function fn_transSchemRegiModPopStart(result) {
		$("#mod_trans_regi_nm", "#modTransScheRegiRegForm").val(nvlPrmSet(result.resultInfo[0].regi_nm, ""));
		$("#mod_trans_regi_ip", "#modTransScheRegiRegForm").val(nvlPrmSet(result.resultInfo[0].regi_ip, "")); 
		$("#mod_trans_regi_port", "#modTransScheRegiRegForm").val(nvlPrmSet(result.resultInfo[0].regi_port, "")); 
		$("#mod_trans_regi_id", "#modTransScheRegiRegForm").val(nvlPrmSet(result.resultInfo[0].regi_id, ""));
		
		if (result.resultInfo[0].exe_status == "TC001501") {
			$("#mod_trans_regi_Chk", "#modTransScheRegiRegForm").val("success"); 
		} else {
			$("#mod_trans_regi_Chk", "#modTransScheRegiRegForm").val("fail");
		}
	}
	/* ********************************************************
	 * IP/Port 정보 바뀌면 Connection Test 다시 
	 ******************************************************** */
	function fn_regi_change_IpPort_re(){
		$("#mod_trans_regi_Chk", "#modTransScheRegiRegForm").val("fail");
	}
	/* ********************************************************
	 * update 실행
	 ******************************************************** */
	function fnc_mod_trans_regi_wrk() {
		if (!mod_trans_regi_upd_valCheck()) return false;

		$.ajax({
			async : false,
			url : "/popup/updateTransSchemaRegistry.do",
		  	data : {
		  		regi_id : nvlPrmSet($("#mod_trans_regi_id","#modTransScheRegiRegForm").val(),''),
		  		regi_nm : nvlPrmSet($("#mod_trans_regi_nm","#modTransScheRegiRegForm").val(),''),
		  		regi_ipaddr : nvlPrmSet($("#mod_trans_regi_ip","#modTransScheRegiRegForm").val(),''),
		  		regi_port : nvlPrmSet($("#mod_trans_regi_port","#modTransScheRegiRegForm").val(),'')
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
				if(result == "S"){
					showSwalIcon('<spring:message code="message.msg106" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_trans_sche_regi_reg_re').modal('hide');
					fn_regi_select();
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_trans_sche_regi_reg_re').modal('show');
					return;
				}
			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_trans_sche_regi_reg_re" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Schema Registry <spring:message code="common.modify"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="modTransScheRegiRegForm">
							<input type="hidden" name="mod_trans_regi_Chk" id="mod_trans_regi_Chk" />
							<input type="hidden" name="mod_trans_regi_id" id="mod_trans_regi_id" />
						
							<fieldset>
								<div class="form-group row">
									<label for="com_db_svr_nm" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema Registry 명
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="mod_trans_regi_nm" name="mod_trans_regi_nm"  disabled />	
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="mod_trans_regi_ip" name="mod_trans_regi_ip" maxlength="50" placeholder='50<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()"  onchange="fn_regi_change_IpPort_re();" tabindex=1 />	
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control"  id="mod_trans_regi_port" maxlength="5" name="mod_trans_regi_port" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_scale.msg15" />' onKeyUp="chk_Number(this);" onchange="fn_regi_change_IpPort_re();" tabindex=2  />	
									</div>
								</div>																	

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" value='<spring:message code="common.modify" />' />
									<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" type="button" onclick="fn_mod_trans_regiConnectTest();" value='<spring:message code="eXperDB_CDC.test_connection" />' />
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