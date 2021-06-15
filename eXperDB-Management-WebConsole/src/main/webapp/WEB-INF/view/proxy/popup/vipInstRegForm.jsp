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
			    		if($("#instReg_mode", "#insVipInstForm").val()=="mod" && vipInstTable.rows('.selected').indexes()[0] != i){
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
		
		$.validator.addMethod("duplCheckPriority", function (str, element, param) {
			var cnt = 0;
		    var listLen = vipInstTable.rows().data().length;
		    var tblData = vipInstTable.rows().data();
		    for(var i=0; i< listLen; i++){
		    	if($("#instReg_priority", "#insVipInstForm").val()==tblData[i].priority){
		    		if($("#instReg_mode", "#insVipInstForm").val()=="mod" && vipInstTable.rows('.selected').indexes()[0] != i){
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
			    		if($("#instReg_mode", "#insVipInstForm").val()=="mod" && vipInstTable.rows('.selected').indexes()[0] != i){
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
						duplCheckVIp:true,
						maxlength: 20
					},
					instReg_v_if_nm: {
						required: true,
						maxlength: 20
					},
					instReg_v_rot_id: {
						required: true,
						duplCheckRotId : true
					},
					instReg_state_nm: {
						required: true
					},
					instReg_priority_sel: {
						required: true,
						duplCheckPriority : false
						
					},
					instReg_chk_tm: {
						required: true
					}
		        },
		        messages: {
		        	instReg_v_ip: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						validatorIpFormat2 : '<spring:message code="errors.format" arguments="'+ 'IP주소' +'" />',
						duplCheckVIp : '<spring:message code="errors.duplicate" />',
						maxlength: '20'+'<spring:message code="message.msg211"/>'
					},
					instReg_v_if_nm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						maxlength: '20'+'<spring:message code="message.msg211"/>'
					},
					instReg_v_rot_id: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						duplCheckRotId : '<spring:message code="errors.duplicate" />',
						maxlength: '20'+'<spring:message code="message.msg211"/>'
					},
					instReg_state_nm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					instReg_priority_sel: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						duplCheckPriority : '<spring:message code="errors.duplicate" />'
					},
					instReg_chk_tm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />',
						maxlength: '18'+'<spring:message code="message.msg211"/>'
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
		          $(element).parent().addClass('has-danger');
		          $(element).addClass('form-control-danger');
		        }
			});
		 
		/*  $('[data-toggle="tooltip_priority"]').tooltip({
				template: '<div class="tooltip tooltip-info tooltip_priority" role="tooltip" style="z-index: 1;"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
			}); */
	});
	
	
	/* ********************************************************
     * 우선순위 자동 Sort 
	 * 	 등록일 경우
	    	1) 내 값 보다 클 경우 그대로 유지
	    	2) 내 값과 같거나 작을 경우 -1
	    
	 *	수정일 경우
	     	1) 입력한 값이 변경 전 값보다 작을 경우
	     		(1) 변경 전 나 보다 작은 값이 내가 입력한 값보다 같거나 클 경우 +1
	     		(2) 변경 전 나 보다 작은 값이 내가 입력한 값보다 작을 경우 그대로 유지
	    		(3) 변경 전 나 보다 큰 값은 그대로 유지
	
	     	2) 입력한 값이 변경 전 값보다 클 경우
	     		(1) 변경 전 나보다 큰 값 이면서 입력한 값 보다 클 경우 그대로 유지
	     		(2) 변경 전 나보다 큰 값 이면서 입력한 값과 같거나 작을 경우 -1
	     		(3) 변경 전 나보다 작은 값일 경우 그대로 유지
	
	     	3) 입력한 값과 변경 전 값이 같다면 그대로 유지

    *********************************************************/
    function priority_auto_sort(){
     	if(vipInstTable.rows().data().length == 0 || (vipInstTable.row('.selected').data() != null && vipInstTable.rows().data().length == 1)){
     		return;
     	}else{
     		showSwalIcon('<spring:message code="eXperDB_proxy.msg8" />', '<spring:message code="common.close" />', '', 'success');
     	 	var newVal = Number($("#instReg_priority", "#insVipInstForm").val());
	     	var oldArray = vipInstTable.column(getColIndex(vipInstTable, "priority")).data();	
	     	if(oldArray.indexOf(newVal)> -1){ //같은 값이 있을 경우만~ 
		     	var minVal = vipInstTable.column(getColIndex(vipInstTable, "priority")).data().sort()[0];
		     	
		     	if(vipInstTable.row('.selected').data() == null){//등록 일 경우
		     		if(newVal < minVal){//최소 값보다 더 작을 경우 최소 -1 값으로 셋팅
		         		$("#instReg_priority", "#insVipInstForm").val(Number(minVal)-1);
		         		newVal = Number(minVal-1);
		         	}
		     		for(var i=0; i< oldArray.length; i++){
		    			if(newVal >= oldArray[i]) vipInstTable.row(i).data().priority=Number(oldArray[i])-1;
		    		}
		    	}else{//수정 일 경우
		    		if(newVal < minVal){ //최소 값보다 더 작을 경우 최소 값으로 셋팅
		         		$("#instReg_priority", "#insVipInstForm").val(Number(minVal));
		         		newVal = Number(minVal);
		         	}
		    		var oldVal = vipInstTable.row('.selected').data().priority;
		    	    if(newVal < oldVal ){//1) 입력한 값이 변경 전 값보다 작을 경우
		    			for(var i=0; i< oldArray.length; i++){
		    				if(vipInstTable.rows('.selected').indexes()[0] != i){
		    					if((oldVal > oldArray[i]) && (newVal <= oldArray[i])){ //(1) 변경 전 나 보다 작은 값이 내가 입력한 값보다 같거나 클 경우 +1
				    				vipInstTable.row(i).data().priority=Number(oldArray[i])+1; 
				    			}
		    				}else{
		    					vipInstTable.row(i).data().priority=Number(newVal);
		    				}
		    			}
		    		}else if(newVal > oldVal){//2) 입력한 값이 변경 전 값보다 클 경우
		    			for(var i=0; i< oldArray.length; i++){
		    				if(vipInstTable.rows('.selected').indexes()[0] != i){
		    					if((oldVal < oldArray[i]) && (newVal >= oldArray[i])){ //(1) 변경 전 나보다 큰거나 같은 값 이면서 입력한 값과 같거나 작을 경우 -1
				    				vipInstTable.row(i).data().priority=Number(oldArray[i])-1; 
				    			}
		    				}else{
		    					vipInstTable.row(i).data().priority=Number(newVal);
		    				}
		    			}
		    		}
		    	}
	     	}
     	}
    }
	
	/* ********************************************************
     * priority가 가장 큰 걸 자동으로 Master로 변경, 그 외 모두 Backup으로 수정
    ******************************************************** */
    function master_gbn_auto_edit(){
    	//vip 하나만 등록 시, peer나 나 둘 중 하나는 state가 Backup 으로 들어가야됨. 
    	if(vipInstTable.rows().data().length == 1){
    		if($("#instReg_priority", "#insVipInstForm").val() < (weightInit-1)) {
    			vipInstTable.row(0).data().state_nm = "BACKUP";
    		}else{
    			vipInstTable.row(0).data().state_nm = "MASTER";
    		}
    	}else{
	    	var nonSortedPriority = vipInstTable.column(getColIndex(vipInstTable, "priority")).data();
			var sortedPriority = vipInstTable.column(getColIndex(vipInstTable, "priority")).data().sort();
			var dataLen = vipInstTable.rows().data().length;
			var maxPriority = sortedPriority[dataLen -1];
			
			//Master 지정
			for(var i=0; i<dataLen; i++){
				if(maxPriority == vipInstTable.row(i).data().priority) vipInstTable.row(i).data().state_nm = "MASTER";
				else vipInstTable.row(i).data().state_nm = "BACKUP";
			}
    	}
    	var tempTableDatas = vipInstTable.rows().data();
		vipInstTable.clear().draw();
		vipInstTable.rows.add(tempTableDatas).draw();
	}
	/* ********************************************************
     * 등록 후 저장 클릭 시 
    ******************************************************** */
	function instReg_add_vip_instance(){
		$("#modYn").val("Y");
		$("#warning_init_detail_info").html('&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="eXperDB_proxy.msg5"/>');
		priority_auto_sort();
		vipInstTable.row.add({
			"state_nm" : $("#instReg_state_nm", "#insVipInstForm").val(),
			"v_ip" : $("#instReg_v_ip", "#insVipInstForm").val(),
			"v_rot_id" : $("#instReg_v_rot_id", "#insVipInstForm").val(),
			"v_if_nm" : $("#instReg_v_if_nm", "#insVipInstForm").val(),
			"priority" : Number($("#instReg_priority", "#insVipInstForm").val()),
			"chk_tm" : $("#instReg_chk_tm", "#insVipInstForm").val(),
			"vip_cng_id" : $("#instReg_vip_cng_id", "#insVipInstForm").val(),
			"pry_svr_id" : $("#instReg_pry_svr_id", "#insVipInstForm").val()
		});
		selConfInfo = null;
		$('#pop_layer_proxy_inst_reg').modal("hide");
		master_gbn_auto_edit();
		
	}
	/* ********************************************************
     * 수정 후 저장 클릭 시 
    ******************************************************** */
	function instReg_mod_vip_instance(){
		$("#modYn").val("Y");
		$("#warning_init_detail_info").html('&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="eXperDB_proxy.msg5"/>');
		priority_auto_sort();
		var dataLen = vipInstTable.rows().data().length;
		var oriData = vipInstTable.rows().data();
		for(var i=0; i<dataLen; i++){
			if(vipInstTable.rows('.selected').indexes()[0] == i){
				oriData[i].state_nm = $("#instReg_state_nm", "#insVipInstForm").val();
				oriData[i].v_ip = $("#instReg_v_ip", "#insVipInstForm").val();
				oriData[i].v_rot_id = $("#instReg_v_rot_id", "#insVipInstForm").val();
				oriData[i].v_if_nm = $("#instReg_v_if_nm", "#insVipInstForm").val();
				oriData[i].priority = Number($("#instReg_priority", "#insVipInstForm").val());
				oriData[i].chk_tm = $("#instReg_chk_tm", "#insVipInstForm").val();
				
				var tempData = vipInstTable.rows().data();
				vipInstTable.clear();
				vipInstTable.rows.add(tempData);
			}
		}
		selConfInfo = null;
		$('#pop_layer_proxy_inst_reg').modal("hide");
		master_gbn_auto_edit();
		
	}
	
	function fn_change_v_if_nm_sel(){
		$("#instReg_v_if_nm", "#insVipInstForm").val($("#instReg_v_if_nm_sel", "#insVipInstForm").val());
	}
	function fn_change_v_ip_sel(){
		$("#instReg_v_ip", "#insVipInstForm").val($("#instReg_v_ip_sel", "#insVipInstForm").val());
		var tempData = selVipInstancePeerList;
		var tempDataLen = tempData.length;
		for(var i=0; i <tempDataLen ; i++){
			if(tempData[i].v_ip == $("#instReg_v_ip_sel", "#insVipInstForm").val()){
				$("#instReg_v_rot_id", "#insVipInstForm").val(tempData[i].v_rot_id);
			}
		}
	}
	function fn_change_priority_sel(){
		$("#instReg_priority", "#insVipInstForm").val(weightInit - $("#instReg_priority_sel", "#insVipInstForm").val());
	}
	function getColIndex(table, dataStr){
		var colIndexs = table.columns().indexes();
		var colIndexSize = colIndexs.length;
		
		for(var i=0; i< colIndexSize; i++){
			if(table.column(colIndexs[i]).dataSrc() ==  dataStr) return i;
		}
	}
</script>
<div class="modal fade" id="pop_layer_proxy_inst_reg" tabindex="-1" role="dialog" aria-labelledby="ModalVipInstance" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 200px 400px;">
		<div class="modal-content" style="width:800px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalVipInstance" style="padding-left:5px;">
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
									<label for="instReg_v_ip" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip" />/Prefix(*)
										</span>
									</label>
									<div class="col-sm-3_75">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_v_ip_sel" id="instReg_v_ip_sel" onchange="fn_change_v_ip_sel();"  tabindex=4 >
										</select>
									</div>
									<div class="col-sm-3_75">
										<input type="text" class="form-control form-control-xsm instReg_v_ip" maxlength="20" id="instReg_v_ip" name="instReg_v_ip" onblur="this.value=this.value.trim()" placeholder="xxx.xxx.xxx.xxx/xx" tabindex=1 />
									</div>
								</div>
								<div class="form-group row">
									<label for="instReg_v_if_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_interface_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip_interface" />(*)
										</span>
									</label>
									<div class="col-sm-3_75">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_v_if_nm_sel" id="instReg_v_if_nm_sel" onchange="fn_change_v_if_nm_sel();"  tabindex=4 >
										</select>
									</div>
									<div class="col-sm-3_75">
										<input type="text" class="form-control form-control-xsm instReg_v_if_nm" maxlength="20" id="instReg_v_if_nm" name="instReg_v_if_nm" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
								<div class="form-group row">
									<label for="instReg_state_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_state_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip_state" />(*)
										</span>
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_state_nm" id="instReg_state_nm"  tabindex=4 >
											<%-- <option value="MASTER"><spring:message code="eXperDB_proxy.master" /></option>
											<option value="BACKUP"><spring:message code="eXperDB_proxy.backup" /></option> --%>
											<option value="MASTER">Master</option>
											<option value="BACKUP">Backup</option>
										</select>
									</div>
									<label for="instReg_priority" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_priority_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip_priority" />(*)
										</span>
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="instReg_priority_sel" id="instReg_priority_sel" onchange="fn_change_priority_sel();"  tabindex=4 >
											<option value=1>1</option>
											<option value=2>2</option>
											<option value=3>3</option>
											<option value=4>4</option>
											<option value=5>5</option>
											<option value=6>6</option>
											<option value=7>7</option>
											<option value=8>8</option>
											<option value=9>9</option>
											<option value=10>10</option>
										</select>
										<input type="hidden" class="form-control form-control-xsm instReg_priority" maxlength="20" id="instReg_priority" name="instReg_priority" onblur="this.value=this.value.trim()" placeholder="" tabindex=5 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="instReg_v_rot_id" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_router_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip_router" />(*)
										</span>
									</label>
									<div class="col-sm-3" id="div_min_data_del_term">
										<input type="number" class="form-control form-control-xsm instReg_v_rot_id" maxlength="20" id="instReg_v_rot_id" name="instReg_v_rot_id" onblur="this.value=this.value.trim()" placeholder="" tabindex=3 />
									</div>
									<label for="instReg_chk_tm" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span data-toggle="tooltip" data-html="true" data-placement="bottom" title='<spring:message code="eXperDB_proxy.vip_check_tm_tooltip" />'>
										<spring:message code="eXperDB_proxy.vip_check_tm" />(*)
										</span>
									</label>
									<div class="col-sm-2">
										<input type="number" class="form-control form-control-xsm instReg_chk_tm" maxlength="18" id="instReg_chk_tm" name="instReg_chk_tm" onblur="this.value=this.value.trim()" placeholder="" tabindex=6 /> 
									</div>
									<label class="col-sm-1 col-form-label-sm pop-label-index" style="padding-left: 0px;">
									<spring:message code="eXperDB_proxy.sec" />
									</label>
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