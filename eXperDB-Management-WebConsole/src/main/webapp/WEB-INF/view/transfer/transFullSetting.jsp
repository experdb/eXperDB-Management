<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../cmmn/cs2.jsp"%>
<%@include file="../cmmn/commonLocaleTrans.jsp" %> 

<%
	/**
	* @Class Name : transFullSetting.jsp
	* @Description : transFullSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2017.07.24
	*
	*/
%>
<style>
/*툴팁 스타일*/
a.tip {
    position: relative;
    color:black;
}

a.tip span {
    display: none;
    position: absolute;
    top: 20px;
    left: -10px;
    width: 200px;
    padding: 5px;
    z-index: 100;
    background: #000;
    color: #fff;
    line-height: 20px;
    -moz-border-radius: 5px; /* 파폭 박스 둥근 정도 */
    -webkit-border-radius: 5px; /* 사파리 박스 둥근 정도 */
}

a:hover.tip span {
    display: block;
}
</style>

<script src="/vertical-dark-sidebar/js/trans_common.js"></script>

<script type="text/javascript">
	var source_table = null;
	var target_table = null;
	var confile_title = "";
	var trans_id_List = [];
	var trans_exrt_trg_tb_id_List = [];
	var kc_ip_List = [];
	var kc_port_List = [];
	var connect_nm_List = [];
	var connect_yn = "";

	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 setting
		fn_source_init();
		fn_target_init();

		//kafka connect 확인
		fn_selectKafkaConnectChk();

	  	$(function() {	
			$('#transSourceSettingTable tbody').on( 'click', 'tr', function () {
				fn_another_checkAll("transSourceSettingTable");
			});
			
			$('#transTargetSettingTable tbody').on( 'click', 'tr', function () {
				fn_another_checkAll("transTargetSettingTable");
			});
	  	});
	});
	
	/* ********************************************************
	 * kafka 체크
	 ******************************************************** */
	function fn_selectKafkaConnectChk() {
		var errorMsg = "";
		var titleMsg = "";

		$.ajax({
			url : "/selectTransKafkaConList.do",
			data : {
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					if (result.length > 0) {
						connect_yn = "Y";
					} else {
						connect_yn = "N";
					}
				} else {
					connect_yn = "N";
				}

				//AWS 서버인경우
				if (connect_yn == "Y") {
					//화면 조회
					fn_tot_select();
					
				} else {
					showDangerToast('top-right', '<spring:message code="data_transfer.msg29" />', '<spring:message code="data_transfer.msg30" />');
					
					//설치안된경우 버튼 막아야함
					$("#btnChoActive").prop("disabled", "disabled");
					$("#btnChoDisabled").prop("disabled", "disabled");

					$("#btnScDelete").prop("disabled", "disabled");
					$("#btnTgDelete").prop("disabled", "disabled");
					$("#btnScModify").prop("disabled", "disabled");
					$("#btnTgModify").prop("disabled", "disabled");
					$("#btnScInsert").prop("disabled", "disabled");
					$("#btnTgInsert").prop("disabled", "disabled");
					$("#btnSearch").prop("disabled", "disabled");
					$("#btnCommonConSetInsert").prop("disabled", "disabled");
				}
			}
		});
	}

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_source_init(){
		var sebuSsGbn = "source";
		
		source_table = $('#transSourceSettingTable').DataTable({
			scrollY : "390px",
			scrollX : true,
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [
			  			{data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
						{data : "status", 
							render: function (data, type, full){
								var html = "";

								html += '<div class="onoffswitch">';
								if(full.exe_status == "TC001501"){
									html += '<input type="checkbox" name="source_transActivation" class="onoffswitch-checkbox" id="source_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 1)" checked>';
								}else if(full.exe_status == "TC001502"){
									html += '<input type="checkbox" name="source_transActivation" class="onoffswitch-checkbox" id="source_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 1)" >';
								}
								html += '<label class="onoffswitch-label" for="source_transActivation'+ full.rownum +'">';
								html += '<span class="onoffswitch-inner"></span>';
								html += '<span class="onoffswitch-switch"></span></label>';

								html += '<input type="hidden" name="source_db_svr_id" id="source_db_svr_id'+ full.rownum +'" value="'+ full.db_svr_id +'"/>';
								html += '<input type="hidden" name="source_trans_exrt_trg_tb_id" id="source_trans_exrt_trg_tb_id'+ full.rownum +'" value="'+ full.trans_exrt_trg_tb_id +'"/>';
								html += '<input type="hidden" name="source_trans_id" id="source_trans_id'+ full.rownum +'" value="'+ full.trans_id +'"/>';
								html += '<input type="hidden" name="source_kc_port" id="source_kc_port'+ full.rownum +'" value="'+ full.kc_port +'"/>';
								html += '<input type="hidden" name="source_kc_ip" id="source_kc_ip'+ full.rownum +'" value="'+ full.kc_ip +'"/>';
								html += '<input type="hidden" name="source_connect_nm" id="source_connect_nm'+ full.rownum +'" value="'+ full.connect_nm +'"/>';

								html += '</div>';

								return html;
							},
							className : "dt-center",
							 defaultContent : "" 	
						},
						{data : "kc_ip",  className : "dt-center", defaultContent : "",orderable : false},
						{data : "kc_port",  className : "dt-center", defaultContent : "",orderable : false},
						{data : "connect_nm",
							"render": function (data, type, full) {
								return '<span onClick=javascript:fn_transLayer("'+full.rownum+'","' + sebuSsGbn + '"); class="bold" data-toggle="modal">' + full.connect_nm + '</span>';
							},
							className : "dt-center", defaultContent : "",orderable : false
						},
						{ data : "db_nm",  className : "dt-center", defaultContent : "",orderable : false},
						{data : "db_svr_id", defaultContent : "", visible: false },
						{data : "db_id", defaultContent : "", visible: false },
						{data : "snapshot_mode", defaultContent : "", visible: false },
						{data : "trans_exrt_trg_tb_id", defaultContent : "", visible: false },
						{data : "trans_id", defaultContent : "", visible: false },
						{data : "exe_status", defaultContent : "", visible: false }
				],'select': {'style': 'multi'}
		});

		source_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		source_table.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
		source_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		source_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		source_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');				
		source_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');

		source_table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
		source_table.tables().header().to$().find('th:eq(7)').css('min-width', '0px');
		source_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
		source_table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
		source_table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		source_table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');	

		$(window).trigger('resize'); 

		source_table.on( 'order.dt search.dt', function () {
			source_table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
			cell.innerHTML = i+1;
			});
		}).draw();
	}

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_target_init(){
		var sebuSsGbn = "target";
		
		target_table = $('#transTargetSettingTable').DataTable({
			scrollY : "390px",
			scrollX : true,
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [
			  			{data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
						{data : "status", 
							render: function (data, type, full){
								var html = "";

								html += '<div class="onoffswitch">';

								if(full.exe_status == "TC001501"){
									html += '<input type="checkbox" name="target_transActivation" class="onoffswitch-checkbox" id="target_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 2)" checked>';
								}else if(full.exe_status == "TC001502"){
									html += '<input type="checkbox" name="target_transActivation" class="onoffswitch-checkbox" id="target_transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +', 2)" >';
								}
								
								html += '<label class="onoffswitch-label" for="target_transActivation'+ full.rownum +'">';
								html += '<span class="onoffswitch-inner"></span>';
								html += '<span class="onoffswitch-switch"></span></label>';
										
								html += '<input type="hidden" name="target_db_svr_id" id="target_db_svr_id'+ full.rownum +'" value="'+ full.db_svr_id +'"/>';
								html += '<input type="hidden" name="target_trans_exrt_trg_tb_id" id="target_trans_exrt_trg_tb_id'+ full.rownum +'" value="'+ full.trans_exrt_trg_tb_id +'"/>';
								html += '<input type="hidden" name="target_trans_id" id="target_trans_id'+ full.rownum +'" value="'+ full.trans_id +'"/>';
								html += '<input type="hidden" name="target_kc_port" id="target_kc_port'+ full.rownum +'" value="'+ full.kc_port +'"/>';
								html += '<input type="hidden" name="target_kc_ip" id="target_kc_ip'+ full.rownum +'" value="'+ full.kc_ip +'"/>';
								html += '<input type="hidden" name="target_connect_nm" id="target_connect_nm'+ full.rownum +'" value="'+ full.connect_nm +'"/>';

								html += '</div>';

								return html;
							},
							className : "dt-center",
							 defaultContent : "" 	
						},
						{data : "kc_ip",  className : "dt-center", defaultContent : "",orderable : false},
						{data : "kc_port",  className : "dt-center", defaultContent : "",orderable : false},
						{data : "connect_nm",
							"render": function (data, type, full) {
								return '<span onClick=javascript:fn_transLayer("'+full.rownum+'","' + sebuSsGbn + '"); class="bold" data-toggle="modal">' + full.connect_nm + '</span>';
							},
							className : "dt-center", defaultContent : "",orderable : false
						},
						{data : "trans_sys_nm",  className : "dt-center", defaultContent : "",orderable : false},
						
						{data : "db_svr_id", defaultContent : "", visible: false },
						{data : "trans_id", defaultContent : "", visible: false },
						{data : "trans_exrt_trg_tb_id", defaultContent : "", visible: false },
						{data : "exe_status", defaultContent : "", visible: false }
					],'select': {'style': 'multi'}
		});

		target_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		target_table.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
		target_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		target_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		target_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');				
		target_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');

		target_table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
		target_table.tables().header().to$().find('th:eq(7)').css('min-width', '0px');
		target_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');	
		target_table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');

		$(window).trigger('resize'); 

 		target_table.on( 'order.dt search.dt', function () {
			target_table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				 cell.innerHTML = i+1;
			});
		}).draw();
	}
	
	/* ********************************************************
	 * 활성화 클릭
	 ******************************************************** */
	function fn_transActivation_click(row, activeGbn){
		//activeGbn 1이면 source 2이면 target
		var con_gbn = "";
		var con_msg = "";

		if (activeGbn  == "1") {
			if($("#source_transActivation"+row).is(":checked") == true){
				con_gbn = "con_start";
				con_msg = 'source ' + '<spring:message code="data_transfer.msg8" />';
			} else {
				con_gbn = "con_end";
				con_msg = 'source ' + '<spring:message code="data_transfer.msg9" />';
			}
		} else {
			if($("#target_transActivation"+row).is(":checked") == true){
				con_gbn = "target_con_start";
				con_msg = 'target ' + '<spring:message code="data_transfer.msg8" />';
			} else {
				con_gbn = "target_con_end";
				con_msg = 'target ' + '<spring:message code="data_transfer.msg9" />';
			}
		}

		$('#con_multi_gbn', '#findConfirmMulti').val(con_gbn);
		$('#confirm_multi_msg').html(con_msg);
		
		confile_title = '<spring:message code="menu.trans_management" />' + " " + '<spring:message code="data_transfer.transfer_activity" />';
		$('#confirm_multi_tlt').html(confile_title);
		$('#chk_act_row', '#findList').val(row);
		
		$('#pop_confirm_multi_md').modal("show");
	}
	
	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_delete(action_gbn){
		$.ajax({
			url : "/deleteTransSetting.do",
			data : {
				trans_id_List : JSON.stringify(trans_id_List),
				trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List),
				trans_active_gbn : action_gbn
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
				if(result == true){
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_tot_select();
				}else{
					msgVale = "<spring:message code='menu.trans_management' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 전송관리 상세
	 ******************************************************** */
	function fn_transLayer(row, active_gbn){
		var trans_id_ss = "";
		var trans_exrt_trg_tb_id_ss = "";
		var trans_active_gbn = "";

		if (active_gbn == "source") {
			trans_id_ss = $('#source_trans_id' + row).val();
			trans_exrt_trg_tb_id_ss = $('#source_trans_exrt_trg_tb_id' + row).val();
			trans_active_gbn = "source";
		} else {
			trans_id_ss = $('#target_trans_id' + row).val();
			trans_exrt_trg_tb_id_ss = $('#target_trans_exrt_trg_tb_id' + row).val();
			trans_active_gbn = "target";
		}

		$.ajax({
			url : "/selectTransSettingInfo.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "u",
				trans_exrt_trg_tb_id : trans_exrt_trg_tb_id_ss,
				trans_id : trans_id_ss,
				trans_active_gbn : trans_active_gbn
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
				if(result == null){
					msgVale = "<spring:message code='menu.trans_management' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');

					if (trans_active_gbn == "source") {
						$('#pop_layer_trans_info').modal('hide');
					} else {
						$('#pop_layer_target_trans_info').modal('hide');
					}
					return;

				} else {
					//상세 조회 셋팅
					fn_info_setting(result, trans_active_gbn);

					if (trans_active_gbn == "source") {
						$('#pop_layer_trans_info').modal('show');
					} else {
						$('#pop_layer_target_trans_info').modal('show');
					}
				}
			}
		});
	}
</script>

<%@include file="./tansSettingInfo.jsp"%>
<%@include file="./transTargetSettingInfo.jsp"%>
<%@include file="./../popup/connectRegReForm.jsp"%>
<%@include file="./../popup/connectRegForm2.jsp"%>
<%@include file="./../popup/connectTargetRegForm.jsp"%>
<%@include file="./../popup/connectTargetRegReForm.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./../popup/transTargetDbmsInfoForm.jsp"%>
<%@include file="./../popup/transConnectListForm.jsp"%>
<%@include file="./../popup/transComConSetForm.jsp"%>
<%@include file="./../popup/transComConChoForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="mod_prm_trans_id" id="mod_prm_trans_id" value=""/>
	<input type="hidden" name="mod_prm_trans_exrt_trg_tb_id" id="mod_prm_trans_exrt_trg_tb_id" value=""/>
	<input type="hidden" name="chk_act_row" id="chk_act_row" value=""/>
</form>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">

					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-send"></i>
												<span class="menu-title"><spring:message code="menu.trans_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_transfer" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.trans_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.connector_settings_01"/></p>
											<p class="mb-0"><spring:message code="help.connector_settings_02"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px -10px;">
							<form class="form-inline row" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0" style="padding-right:10px;">
									<input type="text" class="form-control" maxlength="25" id="connect_nm" name="connect_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="data_transfer.connect_name_set" />'/>					
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_tot_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>

					<div class="row">
						<div class="col-12" style="margin-top:-10px;margin-bottom:-10px;">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text mb-2 btn-search-disable" id="btnKafkaInsert" onClick="fn_common_kafka_ins();" data-toggle="modal">
									<i class="fa fa-spin fa-cog btn-icon-prepend "></i><spring:message code="data_transfer.btn_title02" /> <spring:message code="common.search" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text mb-2 btn-search-disable" id="btnCommonConSetInsert" onClick="fn_common_con_set_pop();" data-toggle="modal">
									<i class="fa fa-cog btn-icon-prepend "></i><spring:message code="common.reg_default_setting" />
								</button>
												
								<button type="button" class="btn btn-outline-primary btn-icon-text mb-2 btn-search-disable float-right" id="btnChoDisabled" onClick="fn_activaExecute_click('disabled');" data-toggle="modal">
									<i class="fa fa-stop btn-icon-prepend "></i><spring:message code="data_transfer.save_select_disabled" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text mb-2 btn-search-disable float-right" id="btnChoActive" onClick="fn_activaExecute_click('active');" data-toggle="modal">
									<i class="fa fa-play btn-icon-prepend "></i><spring:message code="data_transfer.save_select_active" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="data_transfer.sub_title01" />
					</h4>

					<div class="row" style="margin-top:-20px;" id="save_button">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScDelete" onClick="fn_del_confirm('source');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScModify" onClick="fn_newUpdate('source');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScInsert" onClick="fn_newInsert('source');" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>
					
					<div class="table-responsive" style="overflow:hidden;min-height:400px;">
						<table id="transSourceSettingTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"></th>
									<th width="50"><spring:message code="access_control_management.activation" /></th> <!-- 활성화 -->
									<th width="100">Kafka-Connect <spring:message code="data_transfer.ip" /></th> <!-- Kafka-Connect 아이피 -->
									<th width="100">Kafka-Connect <spring:message code="data_transfer.port" /></th> <!-- Kafka-Connect 포트 -->
									<th width="100"><spring:message code="data_transfer.connect_name_set" /></th> <!-- Connect 명 -->
									<th width="100"><spring:message code="data_transfer.database" /></th> <!-- DBMS명 -->
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>

		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="data_transfer.sub_title02" />
					</h4>

					<div class="row" style="margin-top:-20px;" id="save_button">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTgDelete" onClick="fn_del_confirm('target');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTgModify" onClick="fn_newUpdate('target');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnTgInsert" onClick="fn_newInsert('target');" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>

					<div class="table-responsive" style="overflow:hidden;min-height:400px;">

						<table id="transTargetSettingTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"></th>
									<th width="50"><spring:message code="access_control_management.activation" /></th> <!-- 활성화 -->
									<th width="100">Kafka-Connect <spring:message code="data_transfer.ip" /></th> <!-- Kafka-Connect 아이피 -->
									<th width="100">Kafka-Connect <spring:message code="data_transfer.port" /></th> <!-- Kafka-Connect 포트 -->
									<th width="100"><spring:message code="data_transfer.connect_name_set" /></th> <!-- Connect 명 -->
									<th width="100"><spring:message code="common.dbms_name" /></th> <!-- DBMS명 -->
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>