<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : proxyAgentMonitoring.jsp
	* @Description : proxy 에이전트 모니터링
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.02.22     최초 생성
	*
	* author 김민정 책임
	* since 2021.02.22
	*
	*/
%>
<script>
	var proxyAgentTable = null; //Proxy Agent Table
	
 	var aut_id = '${aut_id}';

	/* ********************************************************
	 * proxy agent 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_proxy_agent_init();

		//화면 조회
		fn_agent_select();
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_proxy_agent_init(){
		proxyAgentTable = $('#proxyAgentList').DataTable({
			scrollY : "430px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			paging: false,
			columns : [
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
 						{data : "domain_nm", className : "dt-left", defaultContent : ""},
 						{data : "ipadr", className : "dt-center", defaultContent : ""},
 						{data : "strt_dtm", className : "dt-center", defaultContent : ""},
 						{data : "svr_use_yn", 
 							render: function (data, type, full){
 								var html = "";
								if (data == "Y") {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-spin fa-spinner mr-2'></i>";
									html += "<spring:message code='dbms_information.use' />";
									html += "</div>";
								} else {
									html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-times-circle mr-2'></i>";
									html += "<spring:message code='dbms_information.unuse' />";
									html += "</div>";
								}

 								return html;
 							},
 							className : "dt-center",
 							defaultContent : "" 	
 						},
 						{data : "pry_svr_nm", className : "dt-left", defaultContent : ""},
 						{data : "master_gbn", 
 							render: function (data, type, full){
 								var html = "";
 								if(full.master_gbn == "M"){
 									html += "<div class='badge badge-pill badge-outline-primary'>";
 									html += "	<i class='fa fa-database mr-2'></i>";
 									html += "master";
 									html += "</div>";
 								} else if(full.master_gbn == "S"){
 									html += "<div class='badge badge-pill badge-outline-warning'>";
 									html += "	<i class='fa fa-database mr-2'></i>";
 									html += "standby";
 									html += "</div>";
 								}

 								return html;
 							},
 							className : "dt-center",
 							defaultContent : "" 	
 						},
 						{data : "kal_install_yn", 
 							render: function (data, type, full){
 								var html = "";
								if (data == "Y") {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-spin fa-spinner mr-2'></i>";
									html += "<spring:message code='dbms_information.use' />";
									html += "</div>";
								} else {
									html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-times-circle mr-2'></i>";
									html += "<spring:message code='dbms_information.unuse' />";
									html += "</div>";
								}

 								return html;
 							},
 							className : "dt-center",
 							defaultContent : "" 	
 						},
 						{data : "agt_version", 
 							render: function (data, type, full){
 								var html = "";
 								if(full.agt_version != ""){
 									html += "<div class='badge badge-pill badge-outline-primary'>";
 									html += "	<i class='fa fa-check-square-o mr-2'></i>";
 									html += full.agt_version;
 									html += "</div>";	
 								}

 								return html;
 							},
 							className : "dt-center",
 							defaultContent : "" 	
 						},
 						{data : "agt_cndt_cd", 
 							render: function (data, type, full){
 								var html = "";
 								
/*  								if (aut_id == "1") {
 									if(full.agt_cndt_cd == "TC001501"){
 										html += '<div class="onoffswitch-scale">';
 										html += '<input type="checkbox" name="agtCndtCd" class="onoffswitch-scale-checkbox" id="agtCndtCd'+ full.rownum +'" onclick="fn_use_agentChk('+ full.rownum +')" checked>';
 										html += '<label class="onoffswitch-scale-label" for="agtCndtCd'+ full.rownum +'">';
 	 									html += '<span class="onoffswitch-scale-inner"></span>';
 	 									html += '<span class="onoffswitch-scale-switch"></span></label>';

 		  								html += '<input type="hidden" name="act_agt_sn" id="act_agt_sn'+ full.rownum +'" value="'+ full.agt_sn +'"/>';
 		  								html += '<input type="hidden" name="act_ipadr" id="act_ipadr'+ full.rownum +'" value="'+ full.ipadr +'"/>';
 		  								html += '<input type="hidden" name="act_socket_port" id="act_socket_port'+ full.rownum +'" value="'+ full.socket_port +'"/>';
 		  								html += '<input type="hidden" name="act_agt_cndt_cd" id="act_agt_cndt_cd'+ full.rownum +'" value="'+ full.agt_cndt_cd +'"/>';
 									}else {
	 									html += "<div class='badge badge-pill badge-danger'>";
 	 									html += "	<i class='ti-close mr-2'></i>";
 	 									html += "	<spring:message code='schedule.stop' />";
 	 								}
 								} else { */
 	  								if(full.agt_cndt_cd == "TC001501"){
 	 									html += "<div class='badge badge-pill badge-success'>";
 	 									html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
 	 									html += "	<spring:message code='dashboard.running' />";
 	 								} else {
 	 									html += "<div class='badge badge-pill badge-danger'>";
 	 									html += "	<i class='ti-close mr-2'></i>";
 	 									html += "	<spring:message code='schedule.stop' />";
 	 								}
/*  								} */

								html += "</div>";
								
 								return html;
 							},
 							className : "dt-center",
 							defaultContent : "" 	
 						},
 						{data : "agt_sn",  defaultContent : "", visible: false },
 						{data : "socket_port",  defaultContent : "", visible: false }
 			]
		});

		proxyAgentTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		proxyAgentTable.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
		proxyAgentTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(5)').css('min-width', '180px');
		proxyAgentTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		proxyAgentTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		proxyAgentTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * proxy agent 조회
	 ******************************************************** */
	function fn_agent_select(){
		$.ajax({
			url : "/proxyAgent/selectProxyAgentList.do",
			data : {
				sch_domain_nm : nvlPrmSet($("#sch_domain_nm").val(), ''),
				sch_ipadr : nvlPrmSet($("#sch_ipadr").val(), ''),
				sch_svr_use_yn : nvlPrmSet($("#sch_svr_use_yn").val(), '')
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
				proxyAgentTable.rows({selected: true}).deselect();
				proxyAgentTable.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					proxyAgentTable.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * agent 상태 클릭
	 ******************************************************** */
	function fn_use_agentChk(row){
		if($("#agtCndtCd"+row).is(":checked") == true){
			$('#con_multi_gbn', '#findConfirmMulti').val("con_start");
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_proxy.msg9" />');
		} else {
			$('#con_multi_gbn', '#findConfirmMulti').val("con_end");
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_proxy.msg10" />');
		}
		
		confile_title = '<spring:message code="menu.proxy_agent" />' + " " + '<spring:message code="eXperDB_proxy.state_change" />';
		$('#confirm_multi_tlt').html(confile_title);
		$('#chk_act_row', '#findList').val(row);
		
		$('#pop_confirm_multi_md').modal("show");
	}
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		if ($('#chk_act_row', '#findList') != null) {
			var canCheckId = 'agtCndtCd' + $('#chk_act_row', '#findList').val();
			
			if (gbn == "con_start") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", false); 
			} else if (gbn == "con_end") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
			}
		}
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "con_start" || gbn == "con_end") {
			fn_act_execute(gbn);
		}
	}
	

	/* ********************************************************
	 * agent 상태 단건실행
	 ******************************************************** */
	function fn_act_execute(act_gbn) {
		var ascRow =  $('#chk_act_row', '#findList').val();
		var validateMsg ="";
		var checkId = "";

		$.ajax({
			url : "/proxyAgent/proxyAgentExcute.do",
			data : {
				agt_sn : $('#act_agt_sn' + ascRow).val(),
				ipadr : $('#act_ipadr' + ascRow).val(),
				socket_port : $('#act_socket_port' + ascRow).val(),
				agt_cndt_cd : $('#act_agt_cndt_cd' + ascRow).val()
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
				checkId = 'agtCndtCd' + ascRow;

				if (result == null) {
					validateMsg = '<spring:message code="eXperDB_proxy.msg11"/>';
					showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
					
					if (act_gbn == "con_start") {
						$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
					} else {
						$("input:checkbox[id='" + checkId + "']").prop("checked", true); 
					}
					return;
				} else {
					if (result == "success") {
						setTimeout(fn_agent_select, 3000);
					} else {
						validateMsg = '<spring:message code="eXperDB_proxy.msg11"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						
						if (act_gbn == "con_start") {
							$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
						} else {
							$("input:checkbox[id='" + checkId + "']").prop("checked", true); 
						}
						return;
					}
				}
			}
		});
	}
</script>

<%@include file="./../../popup/confirmMultiForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" id="modYn" name="modYn" value="N"/>
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
												<i class="fa fa-database"></i>
												<span class="menu-title"><spring:message code="menu.proxy_agent"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;"><spring:message code="menu.proxy" /></li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_mgmt" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_agent"/></li>
										</ol>
									</div>
								</div>
							</div>

							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.proxy_agent_monitoring_01"/></p>
											<p class="mb-0"><spring:message code="help.proxy_agent_monitoring_02"/></p>
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
								<div class="input-group mb-2 mr-sm-2 col-sm-2_5">
									<input type="text" class="form-control" maxlength="100" style="margin-right: -0.7rem;" id="sch_domain_nm" name="sch_domain_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_proxy.agent_name" />'/>				
								</div>
								
								<div class="input-group mb-2 mr-sm-2 col-sm-2_5">
									<input type="text" class="form-control" maxlength="30" style="margin-right: -0.7rem;" id="sch_ipadr" name="sch_ipadr" value="" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_proxy.agent_ip" />'/>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control"  name="sch_svr_use_yn" id="sch_svr_use_yn">
										<option value=""><spring:message code="eXperDB_proxy.server_use" />&nbsp;<spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /> </option>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_agent_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

		 							<table id="proxyAgentList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
	 										<tr class="bg-info text-white">
												<th width="40" height="0"><spring:message code="common.no" /></th>
												<th width="200"><spring:message code="eXperDB_proxy.agent_name" /></th>
			 									<th width="100"><spring:message code="eXperDB_proxy.agent_ip" /></th>
												<th width="100"><spring:message code="agent_monitoring.run_date" /> </th>
												<th width="100"><spring:message code="eXperDB_proxy.proxy_use" /></th>
												<th width="180"><spring:message code="eXperDB_proxy.server_name" /></th>
												<th width="100"><spring:message code="eXperDB_proxy.master_div" /></th>
												<th width="100"><spring:message code="eXperDB_proxy.vip_use" /></th>
												<th width="100"><spring:message code="agent_monitoring.agent_version" /></th>
												<th width="100"><spring:message code="agent_monitoring.agent_status" /></th>
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
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>

