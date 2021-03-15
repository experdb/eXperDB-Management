<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : proxyServerRegForm.jsp
	* @Description : Proxy 서버 등록 화면
	* @Modification Information
	*
	*   수정일                      	수정자               수정내용
	*  ----------   ------  -----------    ---------------------------
	*  2021.03.05	김민정		최초 생성
	*
	* author 김민정 사원
	* since 2021.03.05
	*
	*/
%>

<script type="text/javascript">
var mgmtDbmsTable = null;

	
	function fn_mgmtDbmsTable_init() {
		
		/* ********************************************************
		 * 서버 (데이터테이블)
		 ******************************************************** */
		 mgmtDbmsTable = $('#mgmtDbms').DataTable({
			scrollY : "100px",
			bSort: false,
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			columns : [
			    {data : "svr_host_nm",className : "dt-center",  defaultContent : ""},//hostname
			    {data : "master_gbn",className : "dt-center",  defaultContent : ""},//마스터 구분
				{data : "ipadr", className : "dt-center", defaultContent : ""},//IP
				{data : "portno", className : "dt-center",  defaultContent : ""},//Port
				{data : "db_svr_id", defaultContent : "", visible: false}// DBMS ID
			]
		});
		
		mgmtDbmsTable.tables().header().to$().find('th:eq(0)').css('min-width', '150px');//server명
		mgmtDbmsTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');//마스터 구분
		mgmtDbmsTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');//ip 주소
		mgmtDbmsTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');//포트 번호
		mgmtDbmsTable.tables().header().to$().find('th:eq(4)').css('min-width', '0px');//db server id
		
	}
	
	$(window.document).ready(function() {
		$("#pwd_check_msg_div", "#svrRegProxyServerForm").hide();
		fn_mgmtDbmsTable_init();

	});

	/* ********************************************************
	 * Master 구분 변경 시 이벤트
	 ******************************************************** */
	function fn_changeMasterGbn(){
		if($("#svrReg_master_gbn", "#svrRegProxyServerForm").val() == "B"){
			$("#svrReg_master_svr_id_label", "#svrRegProxyServerForm").show();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").show();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").val($("#svrReg_master_svr_id_val", "#svrRegProxyServerForm").val());
		}else{
			$("#svrReg_master_svr_id_label", "#svrRegProxyServerForm").hide();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").hide();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").val("");
		}
	}
	
	/* ********************************************************
	 * Proxy Master Proxy 서버 select 생성
	 ******************************************************** */
	function fn_create_mstSvr_select(data, value){
		var innerHtml ="";
		var len = data.length;
		$( "#svrReg_master_svr_id > option", "#svrRegProxyServerForm" ).remove();
		
		//innerHtml += '<option value="">-</option>';
	
		for(var i=0; i<len; i++){
			var id = data[i].pry_svr_id;
			var nm = data[i].pry_svr_nm;
			innerHtml += '<option value='+id+'>'+nm+'</option>';
		}
	
		$( "#svrReg_master_svr_id", "#svrRegProxyServerForm" ).append(innerHtml);
		$( "#svrReg_master_svr_id", "#svrRegProxyServerForm" ).val(value);
			
	}
	/* ********************************************************
	 * Proxy 연결 DBMS select 생성
	 ******************************************************** */
	function fn_create_dbms_select(data, value){
		var innerHtml ="";
		var len = data.length;
		
		$( "#svrReg_db_svr_id > option", "#svrRegProxyServerForm" ).remove();
	
		for(var i=0; i<len; i++){
			var id = data[i].db_svr_id;
			var nm = data[i].db_svr_nm;
			innerHtml += '<option value='+id+'>'+nm+'</option>';
		}
	
		$( "#svrReg_db_svr_id", "#svrRegProxyServerForm" ).append(innerHtml);
		$( "#svrReg_db_svr_id", "#svrRegProxyServerForm" ).val(value);
			
			
	}
	/* ********************************************************
     * Proxy Server의  연결 DBMS List 검색
    ******************************************************** */		
 	function fn_svr_dbms_list_search(){
		
		var dbSvrId = $("#svrReg_db_svr_id_val", "#svrRegProxyServerForm").val();
 		$.ajax({
 			url : "/selectIpadrList.do",
 			data : {
 				db_svr_id : dbSvrId
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
 				mgmtDbmsTable.rows({selected: true}).deselect();
 				mgmtDbmsTable.clear().draw();
				
				if (result != null) {
					mgmtDbmsTable.rows.add(result).draw();
				}
 			}
 		});
 	}
  	/* ********************************************************
     * Proxy Server의  연결 Test 
     ******************************************************** */		
	function fn_prySvrConnTest(){
		$.ajax({
 			url : "/prySvrConnTest.do",
 			data : {
 				pry_svr_id : $("#svrReg_pry_svr_id", "#svrRegProxyServerForm").val()
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
 				if (result != null) {
					if(!result.agentConn){
						showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
						
						$("#svrReg_conn_result", "#svrRegProxyServerForm").val("false");
						$("#svrReg_save_submit", "#svrRegProxyServerForm").attr("disabled", "disabled");
						
					}else{
						showSwalIcon('<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
						$("#svrReg_conn_result", "#svrRegProxyServerForm").val("true");
						$("#svrReg_save_submit", "#svrRegProxyServerForm").removeAttr("disabled");
						
					}
				}
 			}
 		});
	}
	/* ********************************************************
     * Proxy Server의  등록 
     ******************************************************** */		
	function fn_reg_svr_check(){
		//연결 테스트를 했는지, 안했다면 
		if($("#svrReg_conn_result", "#svrRegProxyServerForm").val() != "true"){
			fn_multiConfirmModal("conn_test");
		}else{
			if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
				fn_multiConfirmModal("pry_svr_reg");
			}else{
				fn_multiConfirmModal("pry_svr_mod");
			}			
		}
	}
	/* ********************************************************
     * Proxy Server의  등록 
     ******************************************************** */		
	function fn_reg_svr(){
		
		var useYn = "N";
		if($("#svrReg_use_yn", "#svrRegProxyServerForm").is(":checked") == true){
			useYn ="Y";
		}
		$.ajax({
 			url : "/prySvrReg.do",
 			data : {
 				pry_svr_id : $("#svrReg_pry_svr_id", "#svrRegProxyServerForm").val()
 				,agt_sn : $("#svrReg_agt_sn", "#svrRegProxyServerForm").val()
 				,pry_svr_nm : $("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val()
 				,day_data_del_term : $("#svrReg_day_data_del_term", "#svrRegProxyServerForm").val()
 				,min_data_del_term : $("#svrReg_min_data_del_term", "#svrRegProxyServerForm").val()
 				,use_yn : useYn
 				,master_gbn : $("#svrReg_master_gbn", "#svrRegProxyServerForm").val()
 				,db_svr_id : $("#svrReg_db_svr_id", "#svrRegProxyServerForm").val()
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
 				if(result.result){
 					var msg ="";
 					if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
 						msg ='<spring:message code="message.msg144"/>';
 					}else{
 						msg ='<spring:message code="message.msg155"/>';
 					}
 					showSwalIcon(msg, '<spring:message code="common.close" />', '', 'success');
 					
 					//창 닫기
 					$('#pop_layer_svr_reg').modal("hide");
 					//검색
 					fn_serverList_search();
 					
 				}else{
 					var msg ="";
 					if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
 						msg ='<spring:message code="migration.msg06"/>';
 					}else{
 						msg ='<spring:message code="eXperDB_scale.msg22"/>';
 					}
 					showSwalIcon(msg +' '+result.errMsg, '<spring:message code="common.close" />', '', 'error');
 					
	 			}
 			}
 		});
	}
</script>
<div class="modal fade" id="pop_layer_svr_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.server_reg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="svrRegProxyServerForm">
						<input type="hidden" id="svrReg_mode" name="svrReg_mode">
						<input type="hidden" id="svrReg_conn_result" name="svrReg_conn_result">
						<input type="hidden" id="svrReg_pry_svr_id" name="svrReg_pry_svr_id">
						<input type="hidden" id="svrReg_master_svr_id_val" name="svrReg_master_svr_id_val">
						<input type="hidden" id="svrReg_db_svr_id_val" name="svrReg_db_svr_id_val">
						<input type="hidden" id="svrReg_agt_sn" name="svrReg_agt_sn">												
						<fieldset>
						<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="svrReg_ipadr" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.id" /> --%>
										IP주소(*)
									</label>

									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm" style="display:none;" maxlength="25" id="svrMod_ipadr" name="svrMod_ipadr" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem;" name="svrReg_ipadr" id="svrReg_ipadr" onchange="fn_changeSvrId();">
										</select>
									</div>
									<label for="svrReg_pry_svr_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.user_name" /> --%>
										서버명(*)
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="svrReg_pry_svr_nm" name="svrReg_pry_svr_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
									</div>
								</div>
								<%-- <div class="form-group row" >
									<label for="svrReg_root_pwd" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Root <spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-3">
										<input type="hidden" id="svrReg_root_pwd_result" name="svrReg_root_pwd_result">
										<input type="password" style="display:none" aria-hidden="true">
										<input type="password" class="form-control form-control-xsm svrReg_root_pwd" autocomplete="new-password" maxlength="20" id="svrReg_root_pwd" name="svrReg_root_pwd" onkeyup="fn_passCheck();" onblur="this.value=this.value.trim()" placeholder="" tabindex=3 />
									</div>
									<label for="svrReg_root_pwdChk" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Root <spring:message code="user_management.confirm_password" />(*)
									</label>
									<div class="col-sm-auto">
										<input type="password" class="form-control form-control-xsm svrReg_root_pwdChk" maxlength="20" id="svrReg_root_pwdChk" name="svrReg_root_pwdChk" onkeyup="fn_passCheck();" onblur="this.value=this.value.trim()" placeholder="" tabindex=4 />
									</div>
								</div>
								<div class="form-group row" id="pwd_check_msg_div">
									<div class="col-sm-6">
									</div>
									<div class="col-sm-6">
										<div class="alert alert-danger" style="margin-top:5px;" id="pwdCheck_alert-danger"><spring:message code="etc.etc14" /></div>
									</div>
								</div> --%>
								
								<div class="form-group row">
									<label for="svrReg_day_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.position" /> --%>
										일별 데이터 보관 기간(*)
									</label>
									<div class="col-sm-3" id="div_day_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="svrReg_day_data_del_term" id="svrReg_day_data_del_term">
											<option value="30">30일</option>
											<option value="40">40일</option>
											<option value="50">50일</option>
											<option value="60">60일</option>
											<option value="70">70일</option>
											<option value="80">80일</option>
											<option value="90">90일</option>
										</select>
									</div>
									
									<label for="svrReg_min_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.Responsibilities" /> --%>
										분별 데이터 보관 기간(*)
									</label>
									<div class="col-sm-auto" id="div_min_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="svrReg_min_data_del_term" id="svrReg_min_data_del_term">
											<option value="1">1일</option>
											<option value="2">2일</option>
											<option value="3">3일</option>
											<option value="4">4일</option>
											<option value="5">5일</option>
											<option value="6">6일</option>
											<option value="7">7일</option>
										</select>
										<%-- <input type="text" class="form-control form-control-xsm" maxlength="25" id="svrReg_rsp_bsn_nm" name="svrReg_rsp_bsn_nm" onkeyup="fn_checkWord(this,25)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=8 /> --%>
									</div>
								</div>
								<div class="form-group row">
									<div class="col-sm-6">
										<div class="alert alert-info" style="margin-top:5px;display:none;" id="prySvrId_alert-danger">IP주소를 선택해주세요.</div>
									</div>
									<div class="col-sm-6">
										<div class="alert alert-info" style="margin-top:5px;display:none;" id="prySvrNm_alert-danger">서버명을 입력해주세요.</div>
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="svrReg_use_yn" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.use_yn" />
									</label>
									<div class="col-sm-auto">
										<div class="onoffswitch-pop" style="margin-top:0.250rem;">
											<input type="checkbox" name="svrReg_use_yn" class="onoffswitch-pop-checkbox" id="svrReg_use_yn" />
											<label class="onoffswitch-pop-label" for="svrReg_use_yn">
												<span class="onoffswitch-pop-inner"></span>
												<span class="onoffswitch-pop-switch"></span>
											</label>
										</div>	
									</div>
									<!-- <div class="col-sm-auto"></div> -->
								</div>
							</div> 
							<br/>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="svrReg_master_gbn" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										Proxy 구분(*)
									</label>
									<div class="col-sm-2">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="svrReg_master_gbn" id="svrReg_master_gbn" onchange="fn_changeMasterGbn();">
											<option value="M" selected="selected">Master</option>
											<option value="B">Backup</option>
										</select>
									</div>
									<div class="col-sm-2"></div>
									<label for="svrReg_master_svr_id" class="col-sm-3 col-form-label-sm pop-label-index" id="svrReg_master_svr_id_label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<%-- <spring:message code="user_management.company" /> --%>
										Master Proxy 서버(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="svrReg_master_svr_id" id="svrReg_master_svr_id">
											<option value="m">proxy_server_1</option>
											<option value="b">proxy_server_10</option>
										</select>
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:0px;">
									<label for="svrReg_db_svr_id" class="col-sm-2 col-form-label-sm">
										<i class="item-icon fa fa-dot-circle-o"></i>
										연결 DBMS
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="svrReg_db_svr_id" id="svrReg_db_svr_id">
											<option value="2">vip_primary</option>
											<option value="db_svr_id">test_dbms</option>
										</select>
									</div>
									<div class="col-sm-auto"></div>
								</div>
								<div class="form-group row">
									<div class="col-sm-12">
										<table id="mgmtDbms" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="150"><%-- <spring:message code="common.division" /> --%>DBMS명</th>
													<th width="150"><spring:message code="common.division" /></th>
													<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="100"><spring:message code="data_transfer.port" /></th>
													<th width="0">DBMS_ID</th>									
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
							<br/>
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" id="svrReg_save_submit" onClick="fn_reg_svr_check();" value='<spring:message code="common.save" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_prySvrConnTest();" id="svrReg_conn_test" value='연결테스트' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>