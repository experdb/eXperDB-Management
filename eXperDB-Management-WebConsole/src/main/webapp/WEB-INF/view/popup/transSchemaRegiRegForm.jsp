<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	var ins_regi_connectNmMsg = '<spring:message code="etc.etc04" />';
	var ins_regi_ip_msg = '<spring:message code="data_transfer.ip" />';
	var ins_regi_port_msg = '<spring:message code="data_transfer.port" />';

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		$("#insTransSchRegiRegForm").validate({
			rules: {
					ins_trans_sche_regi_nm: {
						required: true
					},
					ins_trans_sche_regi_ip: {
						required: true
					},
					ins_trans_sche_regi_port: {
						required: true,
						number: true
					},
			},
			messages: {
					ins_trans_sche_regi_nm: {
						required: '<spring:message code="errors.required" arguments="'+ ins_regi_connectNmMsg +'" />'
					},
					ins_trans_sche_regi_ip: {
						required: '<spring:message code="errors.required" arguments="'+ ins_regi_ip_msg +'" />'
					},
					ins_trans_sche_regi_port: {
						required: '<spring:message code="errors.required" arguments="'+ ins_regi_port_msg +'" />',
						number: '<spring:message code="eXperDB_scale.msg15" />'
					}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fnc_ins_trans_sche_regi_wrk();
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
	function fnc_ins_trans_sche_regi_wrk() {
		if (!ins_trans_schem_regi_ins_valCheck()) return false;

		$.ajax({
			async : false,
			url : "/popup/insertTransSchemaRegistry.do",
		  	data : {
		  		regi_ipaddr: nvlPrmSet($("#ins_trans_sche_regi_ip","#insTransSchRegiRegForm").val(),''),
		  		//regi_addr : nvlPrmSet($("#ins_trans_sche_regi_ip","#insTransSchRegiRegForm").val(),''),
		  		regi_nm : nvlPrmSet($("#ins_trans_sche_regi_nm","#insTransSchRegiRegForm").val(),''),
		  		regi_port : nvlPrmSet($("#ins_trans_sche_regi_port","#insTransSchRegiRegForm").val(),'')
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
				if(result == "O"){ //중복 work명 일경우
					showSwalIcon('<spring:message code="eXperDB_CDC.msg28" />', '<spring:message code="common.close" />', '', 'error');
					return;
				} else if(result == "S"){
					showSwalIcon('<spring:message code="message.msg106" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_trans_sche_regi_reg').modal('hide');
					fn_regi_select();
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_trans_sche_regi_reg').modal('show');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 팝업시작
	 ******************************************************** */
	function fn_transScheRegiRegPopStart(result) {
		$("#ins_trans_sche_regi_nm", "#insTransSchRegiRegForm").val("");
		$("#ins_trans_sche_regi_ip", "#insTransSchRegiRegForm").val(""); 
		$("#ins_trans_sche_regi_port", "#insTransSchRegiRegForm").val(""); 
		$("#ins_trans_sche_regi_Chk", "#insTransSchRegiRegForm").val("fail"); 
	}
	/* ********************************************************
	 * IP/Port 정보 바뀌면 Connection Test 다시 
	 ******************************************************** */
	function fn_regi_change_IpPort(){
		$("#ins_trans_sche_regi_Chk", "#insTransSchRegiRegForm").val("fail"); 
	}
	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function ins_trans_schem_regi_ins_valCheck(){
		var valideMsg = "";
		if(nvlPrmSet($("#ins_trans_sche_regi_Chk", "#insTransSchRegiRegForm").val(), '') == "" || nvlPrmSet($("#ins_trans_sche_regi_Chk", "#insTransSchRegiRegForm").val(), '') == "fail") {
			showSwalIcon('Schema Registry-Connect ' + '<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}

		return true;
	}

	/* ********************************************************
	 * 커넥터 연결테스트
	 ******************************************************** */
	function fn_ins_trans_regiConnectTest() {
		var regiIP = nvlPrmSet($("#ins_trans_sche_regi_ip","#insTransSchRegiRegForm").val(),'');
		var regiPort=	nvlPrmSet($("#ins_trans_sche_regi_port","#insTransSchRegiRegForm").val(),'');

		if(regiIP == "") {
			showSwalIcon('<spring:message code="errors.required" arguments="'+ ins_regi_ip_msg +'" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		} else if(regiPort == "") {
			showSwalIcon('<spring:message code="errors.required" arguments="'+ ins_regi_port_msg +'" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}
		
		$.ajax({
			url : '/kafkaConnectionTest.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				regiIP : regiIP,
				regiPort : regiPort,
				connect_gbn : "schema"
			},
			success : function(result) {
				if(result.RESULT_DATA =="success"){
					$("#ins_trans_sche_regi_Chk","#insTransSchRegiRegForm").val("success");
					showSwalIcon('Schema Registry-Connection ' + '<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
				}else{
					$("#ins_trans_sche_regi_Chk","#insTransSchRegiRegForm").val("fail")
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

</script>

<div class="modal fade" id="pop_layer_trans_sche_regi_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Schema Registry <spring:message code="common.registory"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="insTransSchRegiRegForm">
							<input type="hidden" name="ins_trans_sche_regi_Chk" id="ins_trans_sche_regi_Chk" />
						
							<fieldset>
								<div class="form-group row">
									<label for="com_db_svr_nm" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema Registry 명
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="ins_trans_sche_regi_nm" name="ins_trans_sche_regi_nm" maxlength="200" placeholder='200<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()" tabindex=1 />	
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" id="ins_trans_sche_regi_ip" name="ins_trans_sche_regi_ip" maxlength="50" placeholder='50<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()"  onchange="fn_regi_change_IpPort();" tabindex=2 />	
									</div>
								</div>
								
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port"/>
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control"  id="ins_trans_sche_regi_port" maxlength="5" name="ins_trans_sche_regi_port" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_scale.msg15" />' onKeyUp="chk_Number(this);"  onchange="fn_regi_change_IpPort();"tabindex=3  />	
									</div>
								</div>																	

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" value='<spring:message code="common.registory" />' />
									<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" type="button" onclick="fn_ins_trans_regiConnectTest();" value='<spring:message code="eXperDB_CDC.test_connection" />' />
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