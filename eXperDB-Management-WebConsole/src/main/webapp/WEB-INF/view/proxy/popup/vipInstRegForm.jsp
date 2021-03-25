<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : vipInstRegForm.jsp
	* @Description : vipInstRegForm 화면
	* @Modification Information
	*
	*   수정일         		수정자             수정내용
	*  -----------	-----   -----------    ---------------------------
	*  2021.03.16  	김민정  	최초 생성
	*
	* author 김민정
	* since 2021.03.16
	*
	*/
%>

<script type="text/javascript">
var vip_ip_msg =  '<spring:message code="eXperDB_proxy.vip" />';
var vip_interface_msg = '<spring:message code="eXperDB_proxy.vip_interface" />';
var vip_router_msg = '<spring:message code="eXperDB_proxy.vip_router" />';
var vip_state_msg = '<spring:message code="eXperDB_proxy.vip_state" />';
var vip_priority_msg = '<spring:message code="eXperDB_proxy.vip_priority" />';
var vip_chk_tm_msg = '<spring:message code="eXperDB_proxy.vip_check_tm" />';

	$(window.document).ready(function() {
		$.validator.addMethod("validatorIpFormat2", function (str, element, param) {
			  var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(3[0-2]|[0-2][0-9]?)$/;
			    if (ipformat.test(str)) {
			        return true;
			    }
			    return false;
		});
		
		$.validator.addMethod("duplCheckVIp", function (str, element, param) {
				var cnt = 0;
			    var listLen = vipInstTable.rows().data().length;
			    var tblData = vipInstTable.rows().data();
			    for(var i=0; i< listLen; i++){
			    	if(str==tblData[i].v_ip){
			    		if($("#instReg_mode", "#insVipInstForm").val()=="mod" && $("#instReg_vip_cng_id", "#insVipInstForm").val() != tblData[i].vip_cng_id){
			    			cnt++;
			    		}else if($("#instReg_mode", "#insVipInstForm").val()=="reg"){
			    			cnt++;
			    		}
			    	}
			    }
			    if(cnt > 0){
			    	return false;
			    }
			    return true;
		  });
		  
		  $.validator.addMethod("duplCheckRotId", function (str, element, param) {
			  	var cnt = 0;
			    var listLen = vipInstTable.rows().data().length;
			    var tblData = vipInstTable.rows().data();
			    for(var i=0; i< listLen; i++){
			    	if(str==tblData[i].v_rot_id){
			    		if($("#instReg_mode", "#insVipInstForm").val()=="mod" && $("#instReg_vip_cng_id", "#insVipInstForm").val() != tblData[i].vip_cng_id){
			    			cnt++;
			    		}else if($("#instReg_mode", "#insVipInstForm").val()=="reg"){
			    			cnt++;
			    		}
			    	}
			    }
			    if(cnt > 0){
			    	return false;
			    }
			    return true;
		  });
		
		 $("#insVipInstForm").validate({
		        rules: {
		        	instReg_v_ip: {
						required:true,
						validatorIpFormat2 :true,
						duplCheckVIp:true
					},
					instReg_v_if_nm: {
						required: true
					},
					instReg_v_rot_id: {
						required: true,
						duplCheckRotId : true
					},
					instReg_state_nm: {
						required: true
					},
					instReg_priority: {
						required: true
					},
					instReg_chk_tm: {
						required: true
					}
		        },
		        messages: {
		        	instReg_v_ip: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						validatorIpFormat2 : '<spring:message code="errors.format" arguments="'+ 'IP주소' +'" />',
						duplCheckVIp : '가상 IP가 중복됩니다.'
					},
					instReg_v_if_nm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					instReg_v_rot_id: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						duplCheckRotId : '가상 라우터 id가 중복됩니다'
					},
					instReg_state_nm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					instReg_priority: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					instReg_chk_tm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					}
		        },
				submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
					if($("#instReg_mode", "#insVipInstForm").val()=="mod"){
						instReg_mod_vip_instance();
					}else{
						instReg_add_vip_instance();
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
	function instReg_add_vip_instance(){
		//입력받은 데이터를 Table에 저장하지 않고,DataTable에만 입력 
		showSwalIcon('상단의 [적용]을 실행해야 \n변경 사항에 대해 저장/적용 됩니다.', '<spring:message code="common.close" />', '', 'success');
		$("#modYn").val("Y");
		vipInstTable.row.add({
			"state_nm" : $("#instReg_state_nm", "#insVipInstForm").val(),
			"v_ip" : $("#instReg_v_ip", "#insVipInstForm").val(),
			"v_rot_id" : $("#instReg_v_rot_id", "#insVipInstForm").val(),
			"v_if_nm" : $("#instReg_v_if_nm", "#insVipInstForm").val(),
			"priority" : $("#instReg_priority", "#insVipInstForm").val(),
			"chk_tm" : $("#instReg_chk_tm", "#insVipInstForm").val(),
			"vip_cng_id" : $("#instReg_vip_cng_id", "#insVipInstForm").val(),
			"pry_svr_id" : $("#instReg_pry_svr_id", "#insVipInstForm").val()
		}).draw();
		$('#pop_layer_proxy_inst_reg').modal("hide");
	}
	
	function instReg_mod_vip_instance(){
		//입력받은 데이터를 Table에 저장하지 않고,DataTable에만 입력 
		showSwalIcon('상단의 [적용]을 실행해야 \n변경 사항에 대해 저장/적용 됩니다.', '<spring:message code="common.close" />', '', 'success');
		$("#modYn").val("Y");
		var dataLen = vipInstTable.rows().data().length;
		var oriData = vipInstTable.rows().data();
		for(var i=0; i<dataLen; i++){
			if(oriData[i].vip_cng_id ==  $("#instReg_vip_cng_id", "#insVipInstForm").val()){
				oriData[i].state_nm = $("#instReg_state_nm", "#insVipInstForm").val();
				oriData[i].v_ip = $("#instReg_v_ip", "#insVipInstForm").val();
				oriData[i].v_rot_id = $("#instReg_v_rot_id", "#insVipInstForm").val();
				oriData[i].v_if_nm = $("#instReg_v_if_nm", "#insVipInstForm").val();
				oriData[i].priority = $("#instReg_priority", "#insVipInstForm").val();
				oriData[i].chk_tm = $("#instReg_chk_tm", "#insVipInstForm").val();
				
				var tempData = vipInstTable.rows().data();
				vipInstTable.clear().draw();
				vipInstTable.rows.add(tempData).draw();
			}
		}
		$('#pop_layer_proxy_inst_reg').modal("hide");
	}
	
	function fn_change_v_if_nm_sel(){
		$("#instReg_v_if_nm", "#insVipInstForm").val($("#instReg_v_if_nm_sel", "#insVipInstForm").val());
	}
	function fn_change_v_ip_sel(){
		$("#instReg_v_ip", "#insVipInstForm").val($("#instReg_v_ip_sel", "#insVipInstForm").val());
	}
	
</script>
<div class="modal fade" id="pop_layer_proxy_inst_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 200px 330px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.instance_reg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="insVipInstForm">
						<input type="hidden" id="instReg_pry_svr_id" name="instReg_pry_svr_id" />
						<input type="hidden" id="instReg_vip_cng_id" name="instReg_vip_cng_id" />
						<input type="hidden" id="instReg_mode" name="instReg_mode" />
						<fieldset>
							<div class="card-body card-body-border">
								<div class="form-group row">
									<label for="instReg_v_ip" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.vip" />(*)
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm instReg_v_ip" maxlength="20" id="instReg_v_ip" name="instReg_v_ip" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="xxx.xxx.xxx.xxx/xx" tabindex=1 />
									</div>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_v_ip_sel" id="instReg_v_ip_sel" onchange="fn_change_v_ip_sel();"  tabindex=4 >
											<option value="">직접 입력</option>
											<option value="192.168.50.115/32">192.168.50.115/32</option>
											<option value="192.168.50.116/32">192.168.50.116/32</option>
											<option value="10.0.2.15/32">10.0.2.15/32</option>
										</select>
									</div>
									<label for="instReg_state_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.vip_state" />(*)
									</label>
									<div class="col-sm-2">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_state_nm" id="instReg_state_nm"  tabindex=4 >
											<option value="MASTER">MASTER</option>
											<option value="BACKUP">BACKUP</option>
										</select>
									</div>
								</div>
								<div class="form-group row">
									<label for="instReg_v_if_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.vip_interface" />(*)
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm instReg_v_if_nm" maxlength="20" id="instReg_v_if_nm" name="instReg_v_if_nm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_v_if_nm_sel" id="instReg_v_if_nm_sel" onchange="fn_change_v_if_nm_sel();"  tabindex=4 >
											<option value="">직접 입력</option>
											<option value="enp0s3">enp0s3</option>
											<option value="enp0s8">enp0s8</option>
										</select>
									</div>
									<label for="instReg_v_rot_id" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.vip_router" />(*)
									</label>
									<div class="col-sm-2" id="div_min_data_del_term">
										<input type="number" class="form-control form-control-xsm instReg_v_rot_id" maxlength="20" id="instReg_v_rot_id" name="instReg_v_rot_id" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=3 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="instReg_priority" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										<spring:message code="eXperDB_proxy.vip_priority" />(*)
									</label>
									<div class="col-sm-2">
										<input type="number" class="form-control form-control-xsm instReg_priority" maxlength="20" id="instReg_priority" name="instReg_priority" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=5 />
									</div>
									<div class="col-sm-4">
									</div>
									<label for="instReg_chk_tm" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.vip_check_tm" />(*)
									</label>
									<div class="col-sm-2">
										<input type="number" class="form-control form-control-xsm instReg_chk_tm" maxlength="20" id="instReg_chk_tm" name="instReg_chk_tm" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="" tabindex=6 />
									</div>
								</div>
							</div>
							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="instReg_save_submit" value='<spring:message code="common.save" />'/>
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>