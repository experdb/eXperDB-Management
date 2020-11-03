<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : connectRegForm.jsp
	* @Description : connectRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2020. 04. 07
	*
	*/
%>

<script type="text/javascript">
	var mod_tableList = null;
	var mod_connector_tableList = null;
	var mod_trans_com_cng_nm_val = '<spring:message code="data_transfer.default_setting" />';

	$(window.document).ready(function() {
		//테이블셋팅
		fn_mod_init();
		$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg1" />');	

		//스냅샷 모드 change
		$("#mod_snapshot_mode", "#modRegForm").change(function(){ 
			 if(this.value == "TC003601"){
				 $("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg2" />'); //(초기스냅샷 1회만 수행)
			 }else if(this.value == "TC003602"){
				 $("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg3" />'); //(스냅샷 항상 수행)
			 }else if (this.value == "TC003603"){
				 $("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg1" />'); //(스냅샷 수행하지 않음)
			 }else if (this.value == "TC003604"){
				 $("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg4" />'); //(스냅샷만 수행하고 종료)
			 }else if (this.value == "TC003605"){
				 $("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg5" />'); //(복제슬롯이 생성된 시접부터의 스냅샷 lock 없는 효율적방법)
			 }
		});

		//table 탭 이동시
		$('a[href="#modTableTab"]').on('shown.bs.tab', function (e) {
			mod_tableList.columns.adjust().draw();
			mod_connector_tableList.columns.adjust().draw();
  			
  			var tableDatas = mod_tableList.rows().data();

  			//재조회
  			if(tableDatas.length == 0){
  				fn_table_search_mod();
  			}
		});
	});

	/* ********************************************************
	 * 테이블 설정
	 ******************************************************** */
	function fn_mod_init(){
		mod_tableList = $('#mod_tableList').DataTable({
			scrollY : "220px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : false,
			bSort: false,
			columns : [
				{
					data : "schema_name", className : "dt-center", defaultContent : ""
				},
				{
					data : "table_name", className : "dt-center", defaultContent : ""
				},
			],'select': {'style': 'multi'}
		});

		mod_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '161px');
		mod_tableList.tables().header().to$().find('th:eq(1)').css('min-width', '162px');
 		
		mod_connector_tableList = $('#mod_connector_tableList').DataTable({
			scrollY : "220px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : false,	
			bSort: false,
			columns : [
				{data : "schema_name", className : "dt-center", defaultContent : ""},
				{data : "table_name", className : "dt-center", defaultContent : ""},			
			 ],'select': {'style': 'multi'}
		});
		
		mod_connector_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '161px');
		mod_connector_tableList.tables().header().to$().find('th:eq(1)').css('min-width', '162px');

		$(window).trigger('resize'); 
	}
	

	/* ********************************************************
	 * 테이블 리스트 조회
	 ******************************************************** */
	function fn_table_search_mod(){
		
		var db_svr_id = $("#db_svr_id","#findList").val();
		var db_nm = $("#mod_db_id").val();
		
		var table_nm = null;

		if(nvlPrmSet($("#mod_table_nm").val(), '') == ""){
			table_nm = "%";
		}else{
			table_nm = nvlPrmSet($("#mod_table_nm").val(), '');
		}

		$.ajax({
			url : "/selectTableMappList.do",
			data : {
				db_svr_id : db_svr_id,
				db_nm : db_nm,
				table_nm : table_nm
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

				//크기고정 및 현재고정
/* 				mod_connector_tableList.columns.adjust().draw();
				 */
				mod_tableList.rows({selected: true}).deselect();
				mod_tableList.clear().draw();

				//조회 후, connector_tableList과 비교 후 같으면 리스트에서 제외
				if (result.RESULT_DATA != null) {
					fn_trableListModRemove(result.RESULT_DATA);
				}
			}
		});
	}

	/* ********************************************************
	 * 조회 데이터 중복 내역 방지
	 ******************************************************** */
 	function fn_trableListModRemove(result){
		var connTableRows = mod_connector_tableList.rows().data();
		var iChkCnt = 0;

		if (connTableRows.length > 0 && result.length > 0) {
			for(var i=0; i<result.length; i++){
				for(var j=0; j<connTableRows.length; j++){
 					if (result[i].table_name != null && connTableRows[j].table_name != null) {
						if(result[i].table_name == connTableRows[j].table_name){
							iChkCnt = iChkCnt + 1;
						}
						if (j == (connTableRows.length -1) && iChkCnt > 0 ) {
							
							result.splice(i, 1);
							iChkCnt = 0;
							i--; //row 삭제로 인해 추가로 -1 필요
						}
					}
				}
			}
		}
		
		mod_tableList.rows.add(result).draw();
	}
	
	/*================ 테이블 리스트 조정 ======================= */
	/* ********************************************************
	 * 선택 우측이동 (> 클릭)
	 ******************************************************** */
	function fn_mod_t_rightMove() {
		var datas = mod_tableList.rows('.selected').data();
		var rows = [];

		//선택 건수 없는 경우
		if(datas.length < 1) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}

		for (var i = 0;i<datas.length;i++) {
			rows.push(mod_tableList.rows('.selected').data()[i]); 
		}
		
		mod_connector_tableList.rows.add(rows).draw();
		mod_tableList.rows('.selected').remove().draw();
	}

	/* ********************************************************
	 * 선택 좌측이동 (< 클릭)
	 ******************************************************** */
	function fn_mod_t_leftMove() {
		var datas = mod_connector_tableList.rows('.selected').data();
		var rows = [];

		//선택 건수 없는 경우
		if(datas.length < 1) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}

		for (var i = 0;i<datas.length;i++) {
			rows.push(mod_connector_tableList.rows('.selected').data()[i]); 
		}
		
		mod_tableList.rows.add(rows).draw();
		mod_connector_tableList.rows('.selected').remove().draw();
	}
	
	/* ********************************************************
	 * 전체 우측이동 (>> 클릭)
	 ******************************************************** */	
	function fn_mod_t_allRightMove() {
		var datas = mod_tableList.rows().data();
		var rows = [];

		//row 존재 확인
		if(datas.length < 1) {
			showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}

		for (var i = 0;i<datas.length;i++) {
			rows.push(mod_tableList.rows().data()[i]); 	
		}
	
		mod_connector_tableList.rows.add(rows).draw(); 	
		mod_tableList.rows({selected: true}).deselect();
		mod_tableList.rows().remove().draw();
	}

	/* ********************************************************
	 * 전체 좌측이동 (<< 클릭)
	 ******************************************************** */	
	function fn_mod_t_allLeftMove() {
		var datas = mod_connector_tableList.rows().data();
		var rows = [];

		//row 존재 확인
		if(datas.length < 1) {
			showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}

		for (var i = 0;i<datas.length;i++) {
			rows.push(mod_connector_tableList.rows().data()[i]); 	
		}
	
		mod_tableList.rows.add(rows).draw(); 	
		mod_connector_tableList.rows({selected: true}).deselect();
		mod_connector_tableList.rows().remove().draw();
	}

	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function mod_source_valCheck(){
		//전성대상테이블 length 체크
		if(nvlPrmSet($("#mod_trans_com_id", "#modRegForm").val(), '') == "") {
			showSwalIcon('<spring:message code="errors.required" arguments="'+ mod_trans_com_cng_nm_val +'" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		} else if (mod_connector_tableList.rows().data().length <= 0) {
			showSwalIcon('<spring:message code="data_transfer.msg24"/>', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		return true;
	}
	
	/* ********************************************************
	 * 커넥터 설정 수정
	 ******************************************************** */
	function fn_mod_update() {
		var table_mapp = [];

		if(!mod_source_valCheck()) {
			return;
		}

		var tableDatas = mod_connector_tableList.rows().data();
			
		if(tableDatas.length > 0){
			var tableRowList = [];
			for (var i = 0; i < tableDatas.length; i++) {
				tableRowList.push( mod_connector_tableList.rows().data()[i]);    
		        table_mapp.push(mod_connector_tableList.rows().data()[i].schema_name+"."+mod_connector_tableList.rows().data()[i].table_name);
		  	}
			
			$("#mod_table_mapp_nm", "#modRegForm").val(table_mapp);
		}

		var schema_total_cnt= 0;
		var table_total_cnt = 0;

		if($("#mod_meta_data_chk", "#modRegForm").is(":checked") == true){
			$("#mod_meta_data", "#modRegForm").val("ON");
		} else {
			$("#mod_meta_data", "#modRegForm").val("OFF");
		}

		$.ajax({
			async : false,
			url : "/updateConnectInfo.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id","#findList").val(),
		  		snapshot_mode : $("#mod_snapshot_mode", "#modRegForm").val(),
				exrt_trg_tb_nm : nvlPrmSet($("#mod_table_mapp_nm", "#modRegForm").val(), ''),
				schema_total_cnt : schema_total_cnt,
				table_total_cnt : table_total_cnt,
				compression_type : $("#mod_compression_type", "#modRegForm").val(),
				meta_data : nvlPrmSet($("#mod_meta_data", "#modRegForm").val(), 'OFF'),
				trans_id : $("#mod_trans_id","#modRegForm").val(),
				trans_exrt_trg_tb_id : $("#mod_trans_exrt_trg_tb_id","#modRegForm").val(),
				trans_com_id : parseInt($("#mod_trans_com_id", "#modRegForm").val())
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
				
				if(result == true){
					showSwalIcon('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_con_re_reg_two').modal('hide');

					//자동활성화 등록
					if($("#mod_source_transActive_act", "#modRegForm").is(":checked") == true){
						fn_auto_trans_active_start("mod_source", $("#mod_trans_exrt_trg_tb_id","#modRegForm").val(), $("#mod_trans_id","#modRegForm").val());
					} else {
						fn_tot_select();
					}
				}else{
					showSwalIcon('<spring:message code="eXperDB_scale.msg22"/>', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_con_re_reg_two').modal('show');
					return false;
				}
			}
		});	
	}

	/* ********************************************************
	 * DBMS 시스템 등록 버튼 클릭시
	 ******************************************************** */
	function fn_mod_sc_comConCho(){
		$('#cho_trans_com_con_cho_mod').show();
		$('#cho_trans_com_con_cho_add').hide();
		
		$('#cho_trans_com_cng_nm').val("");
		
		cho_proc_gbn = "mod";

		fn_cho_trans_search_com_con();

		$('#pop_layer_trans_com_con_cho').modal("show");
	}

	/* ********************************************************
	 * DBMS 서버 호출하여 입력
	 ******************************************************** */
	function fn_trans_com_conModCallback(trans_com_id, trans_com_cng_nm){
		 $("#mod_trans_com_id", "#modRegForm").val(nvlPrmSet(trans_com_id, ''));
		 $("#mod_trans_com_cng_nm", "#modRegForm").val(nvlPrmSet(trans_com_cng_nm, ''));
	}
</script>

<form name="frmTablePopup">
	<input type="hidden" name="mod_db_svr_id"  id="mod_db_svr_id">
	<input type="hidden" name="mod_include_table_nm"  id="mod_include_table_nm" >
	<input type="hidden" name="mod_exclude_table_nm"  id="mod_exclude_table_nm" >
	<input type="hidden" name="mod_db_nm"  id="mod_db_nm" >
	<input type="hidden" name="mod_tableGbn"  id="mod_tableGbn" >
	<input type="hidden" name="mod_table_total_cnt" id="mod_table_total_cnt">
	<input type="hidden" name="mod_act" id="mod_act">
</form>

<div class="modal fade" id="pop_layer_con_re_reg_two" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.mod_transfer_set"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="searchModForm">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="table-responsive">
									<table id="connectModPopList" class="table system-tlb-scroll" style="width:100%;">
										<colgroup>
											<col style="width: 44%;" />
											<col style="width: 36%;" />
											<col style="width: 20%;" />
										</colgroup>
										<thead>
											<tr class="bg-info text-white">
												<th class="table-text-align-c">Kafka-Connect <spring:message code="data_transfer.server_name" /></th>
												<th class="table-text-align-c"><spring:message code="data_transfer.ip" /></th>
												<th class="table-text-align-c"><spring:message code="data_transfer.port" /></th>
											</tr>
										</thead>
										<tbody>
											<tr style="border-bottom: 1px solid #adb5bd;">
												<td class="table-text-align-c">
													<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_source_kc_nm" id="mod_source_kc_nm"  disabled>
														<option value=""><spring:message code="common.choice" /></option>
														<c:forEach var="result" items="${kafkaConnectList}" varStatus="status">
															<option value="<c:out value="${result.kc_id}"/>"><c:out value="${result.kc_nm}"/></option>
														</c:forEach>
													</select>
												</td>	
			
												<td class="table-text-align-c">
													<input type="text" class="form-control form-control-xsm" maxlength="50" id="mod_kc_ip" name="mod_kc_ip" onblur="this.value=this.value.trim()" readonly />
												</td>												
												<td class="table-text-align-c">
													<input type="text" class="form-control form-control-xsm" maxlength="5" id="mod_kc_port" name="mod_kc_port" onblur="this.value=this.value.trim()" onKeyUp="chk_Number(this);" readonly />						
												</td>								
											</tr>					
										</tbody>
									</table>
								</div>
							</div>
						</fieldset>
					</form>

					<br/>
	
					<div class="card-body" style="padding: 0px 0px 0px 0px;">
						<div class="form-group row div-form-margin-z">
							<div class="col-12" >
								<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
									<li class="nav-item">
										<a class="nav-link active" id="mod-tab-1" data-toggle="pill" href="#modSettingTab" role="tab" aria-controls="modSettingTab" aria-selected="true" >
											<spring:message code="data_transfer.connect_set" />
										</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" id="mod-tab-2" data-toggle="pill" href="#modTableTab" role="tab" aria-controls="modTableTab" aria-selected="false">
											<spring:message code="data_transfer.table_mapping" />
										</a>
									</li>
								</ul>
							</div>
						</div>
						
						<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;margin-bottom:-10px;">
							<div class="tab-pane fade show active" role="tabpanel" id="modSettingTab">
								<form class="cmxform" id="modRegForm">
									<input type="hidden" name="mod_table_mapp_nm" id="mod_table_mapp_nm" />
									<input type="hidden" name="mod_meta_data" id="mod_meta_data" value="OFF"/>
									<input type="hidden" name="mod_db_id_set" id="mod_db_id_set" />
									<input type="hidden" name="mod_trans_id" id="mod_trans_id" />
									<input type="hidden" name="mod_trans_exrt_trg_tb_id" id="mod_trans_exrt_trg_tb_id" />
									<input type="hidden" name="mod_trans_com_id" id="mod_trans_com_id" />

									<fieldset>
										<div class="form-group row" style="margin-bottom:10px;">
											<label for="mod_connect_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.connect_name_set" />
											</label>
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-xsm" id="mod_connect_nm" name="mod_connect_nm" maxlength="50" readonly />
											</div>
											<div class="col-sm-2">
												&nbsp;
											</div>
										</div>
	
										<div class="form-group row" style="margin-bottom:10px;">
											<label for="mod_db_id" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.database" />
											</label>
											<div class="col-sm-4">
												<input type="text" class="form-control form-control-xsm" id="mod_db_id" name="mod_db_id" readonly />
											</div>
											<label for="mod_compression_type" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.metadata" />
											</label>
											<div class="col-sm-4">
												<div class="onoffswitch-pop">
													<input type="checkbox" name="mod_meta_data_chk" class="onoffswitch-pop-checkbox" id="mod_meta_data_chk" />
													<label class="onoffswitch-pop-label" for="mod_meta_data_chk">
														<span class="onoffswitch-pop-inner"></span>
														<span class="onoffswitch-pop-switch"></span>
													</label>
												</div>
											</div>
										</div>

										<div class="form-group row" style="margin-bottom:10px;">
											<label for="mod_snapshot_mode" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.snapshot_mode" />
											</label>
											<div class="col-sm-4">
											<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_snapshot_mode" id="mod_snapshot_mode" tabindex=5>
													<c:forEach var="result" items="${snapshotModeList}">
													<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
													</c:forEach>
												</select>
											</div>
											<div class="col-sm-6" style="height:30px;display: flex;align-items: center;">
												<span class="text-sm-left" style="font-size: 0.875rem;" id="mod_snapshotModeDetail"></span>	
											</div>
										</div>

										<div class="form-group row" style="margin-bottom:10px;">
											<label for="mod_trans_com_cng_nm" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.default_setting"/>
											</label>
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-xsm" id="mod_trans_com_cng_nm" name="mod_trans_com_cng_nm" readonly="readonly" />
											</div>
											<div class="col-sm-2">
												<button type="button" class="btn btn-inverse-info btn-sm" style="width: 100px;" onclick="fn_mod_sc_comConCho()"><spring:message code="button.create" /></button>
											</div>
										</div>

										<div class="form-group row" style="margin-bottom:1px;">
											<label for="mod_compression_type" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="data_transfer.compression_type" />
											</label>
											<div class="col-sm-4">
												<select class="form-control form-control-xsm" style="margin-right: 1rem;" name="mod_compression_type" id="mod_compression_type" tabindex=5>
													<c:forEach var="result" items="${compressionTypeList}">
														<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
													</c:forEach>
												</select>
											</div>
											<label for="mod_compression_type" class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="access_control_management.activation" />
											</label>
											<div class="col-sm-4">
												<div class="onoffswitch-pop-play">
													<input type="checkbox" name="mod_source_transActive_act" class="onoffswitch-pop-play-checkbox" id="mod_source_transActive_act" onclick="fn_transActivation_msg_set('mod_source')" >
													<label class="onoffswitch-pop-play-label" for="mod_source_transActive_act">
														<span class="onoffswitch-pop-play-inner"></span>
														<span class="onoffswitch-pop-play-switch"></span>
													</label>
												</div>
											</div>
										</div>
										
										<div class="form-group row div-form-margin-z" id="mod_source_trans_active_div" style="display:none;">
											<div class="col-sm-12">
												<div class="alert alert-info" style="margin-top:5px;margin-bottom:-15px;" >
													<spring:message code="data_transfer.msg27" />
												</div>
											</div>
										</div>
									</fieldset>
								</form>	
							</div>

							<div class="tab-pane fade" role="tabpanel" id="modTableTab">
								<div class="card"  style="margin-top:-20px;">
									<div class="card-body" style="margin:-10px -10px -15px -10px;">
										<form class="form-inline row" onsubmit="return false">
											<div class="input-group mb-2 mr-sm-2 col-sm-6">
												<input type="text" class="form-control form-control-xsm" maxlength="25" id="mod_table_nm" name="mod_table_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="migration.table_name" />'/>				
											</div>
				
											<button type="button" class="btn btn-inverse-primary btn-sm btn-icon-text mb-2 btn-search-disable" id="btnConModSearch" onClick="fn_table_search_mod();" >
												<i class="ti-search btn-icon-prepend "></i><spring:message code="data_transfer.tableList" />
											</button>
										</form>
									</div>
								</div>
									
								<div class="row">
									<div class="col-5 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="left_list">
										<div class="card" style="border:0px;">
											<div class="card-body" style="padding-left:0px;padding-right:0px;">
												<h4 class="card-title">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="data_transfer.tableList" />
												</h4>
	
									 			<table id="mod_tableList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="161" class="dt-center" ><spring:message code="migration.schema_Name" /></th>
															<th width="162" class="dt-center" ><spring:message code="migration.table_name" /></th>	
														</tr>
													</thead>
												</table>
											</div>
										</div>
									</div>
	 									
									<div class="col-1 stretch-card div-form-margin-table" style="max-width: 6%;" id="center_div">
										<div class="card" style="background-color: transparent !important;border:0px;">
											<div class="card-body">	
												<div class="card my-sm-2 row" style="border:0px;background-color: transparent !important;">
													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-top:15px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_allRightMove();">
															<i class="fa fa-angle-double-right" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
														</a>
													</label>
												
													<br/>

													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_rightMove();">
															<i class="fa fa-angle-right" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
														</a>
													</label>
													
													<br/>
	
													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_leftMove();">
															<i class="fa fa-angle-left" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_left_line" /></span>
														</a>
													</label>
													
													<br/>
	
													<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
														<a href="#" class="tip" onclick="fn_mod_t_allLeftMove();">
															<i class="fa fa-angle-double-left" style="font-size: 35px;cursor:pointer;"></i>
															<span style="width: 200px;"><spring:message code="data_transfer.move_all_left" /></span>
														</a>
													</label>
												</div>
											</div>
										</div>
									</div>
											
									<div class="col-5 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="right_list">
										<div class="card" style="border:0px;">
											<div class="card-body" style="padding-left:0px;padding-right:0px;">
												<h4 class="card-title">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="data_transfer.transfer_table" />
												</h4>
	
								 				<table id="mod_connector_tableList" class="table table-hover system-tlb-scroll" style="width:100%;">
													<thead>
														<tr class="bg-info text-white">
															<th width="161" class="dt-center" ><spring:message code="migration.schema_Name" /></th>
															<th width="162" class="dt-center" ><spring:message code="migration.table_name" /></th>	
														</tr>
													</thead>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>			

			<br/>

			<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
				<button type="button" class="btn btn-primary" onclick="fn_mod_update();"><spring:message code="common.modify"/></button>
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>