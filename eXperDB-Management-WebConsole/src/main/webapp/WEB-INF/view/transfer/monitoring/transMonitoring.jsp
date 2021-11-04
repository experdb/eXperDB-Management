<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<%@include file="../../cmmn/commonLocaleTrans.jsp" %> 

<%
	/**
	* @Class Name : transMonitoring.jsp
	* @Description : 전송관리 모니터링
	* @Modification Information
	*
	*	수정일			수정자						 수정내용
	*  ------------	 -----------	 ---------------------------
	*  2021.07.26	  최초 생성
	*
	* author 윤정 매니저
	* since 2021.07.26
	*
	*/
%>

<script src="/vertical-dark-sidebar/js/trans_monitoring.js"></script>

<script type="text/javascript">
	var cpuChart = "";
	var memChart = "";
// 	var allErrorChart = "";
	var connectorActTable = "";
	var sinkChart = "";
	var sinkCompleteChart = "";
	var sinkErrorChart = "";

	/* ********************************************************
	* 화면 onload
	******************************************************** */
	$(window).ready(function(){
		//금일 날짜 setting
		fn_todaySetting();

		// cpu, memory error chart
		fn_cpu_mem_err_chart();

		// connector 기동정지 table init
		fn_connector_act_init();

		// 소스 connect setting info init - connect 설정정보
		fn_src_setting_info_init();

		// 소스 connect mapping table init - 전송대상 테이블 정보
		fn_src_mapping_list_init();

		// 소스 connect init	  -- 실시간리스트
		fn_src_connect_init();
		
		// 타겟 connect 토픽 리스트 init -- 전송대상 토픽리스트 정보
		fn_tar_topic_list_init();

		// 타겟 connect 리스트 init	  -- 실시간리스트
		fn_tar_connect_init();
		
		// 소스 snapshot init
		//fn_src_snapshot_init();

		// 소스 streaming init
		//fn_src_streaming_init();

		// 소스 error 리스트 init
		//fn_src_error_init();

		// 타겟 error 리스트 init
		//fn_tar_error_init();
	});

	/* ********************************************************
	* 소스 커넥터 select box 변경
	******************************************************** */
	function fn_srcConnectInfo() {
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		fn_tar_init();
		fn_src_init();
		
		if(selectValue != ""){
			$.ajax({
				url : "/transSrcConnectInfo.do",
				dataType : "json",
				type : "post",
				data : {
					trans_id : selectValue,
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
				},
				success : function(result) {
					if (result != null) {
						//소스커넥터 테이블수, 전체완료수, 오류수 setting
						$('#table_cnt').html(result.table_cnt);
						$('#ssconDBResultTable').show();
						if(result.connectInfo[0] != null && result.connectInfo[0] != undefined){
							$('#src_total_poll_cnt').html(result.connectInfo[0].source_record_poll_total);
							$('#src_total_error_cnt').html(result.connectInfo[0].total_record_errors);
							$('#ssconResultCntTable').show();
							$('#ssconResultCntTableNvl').hide();
						}

						//하단 상세화면 출력
						$('#trans_monitoring_source_info').show();
						$('#trans_monitoring_target_info').show();

						//싱크커넥터 select 활성화
						$('#tar_connector_list').empty();
						$('#tar_connector_list').append('<option value=\"\">타겟 Connector</option>');

						if (nvlPrmSet(result.targetConnectorList, '') != '') {
							for (i = 0; i < result.targetConnectorList.length; i++) {
								if(i == 0){
									$('#tar_connector_list').append('<option selected value=\"'+result.targetConnectorList[i].trans_id+'\">'+result.targetConnectorList[i].connect_nm+'</option>');
									fn_tarConnectInfo();
								} else {
									$('#tar_connector_list').append('<option value=\"'+result.targetConnectorList[i].trans_id+'\">'+result.targetConnectorList[i].connect_nm+'</option>');
								}
							}
						} else {
							fn_tarConnectInfo();
						}

						//Kafka Connect 별 기동정지이력 setting
						connectorActTable.clear().draw();
						if (nvlPrmSet(result.kafkaActCngList, '') != '') {
							connectorActTable.rows.add(result.kafkaActCngList).draw();
						}

						//소스시스템 connect 설정정보  setting
						srcConnectSettingInfoTable.clear().draw();
						if (nvlPrmSet(result.connectInfo, '') != '') {
							srcConnectSettingInfoTable.rows.add(result.connectInfo).draw();
						}

						//소스시스템 connect 전송대상테이블  setting
						srcMappingListTable.clear().draw();
						if (nvlPrmSet(result.table_name_list, '') != '') {
							srcMappingListTable.rows.add(result.table_name_list).draw();
						}

						//소스시스템 - snapshot tap 선택
						document.getElementById('server-tab-1').click();
//						 selectTab('snapshot');

						//소스시스템 chart setting
						funcSsChartSetting(result);

						//소스시스템 리스트별 setting
						funcSsListSetting(result);

						//상단연결도 setting
						fn_dbmsConnect_digm("source", result);

						//상단연결도 setting
						fn_dbmsConnect_digm("kafka", result);
					}
				}
			});
		} else {
			$('#kc_id', '#transMonitoringForm').val("");

			$('#ssconResultCntTable').hide();
			$('#ssconResultCntTableNvl').show();
			$('#tar_connector_list').empty();
			$('#tar_connector_list').append('<option value=\"\">타겟 Connector</option>');

			//싱크 커넥터 select change
			fn_tarConnectInfo();

			$('#ssconDBResultTable').hide();
			connectorActTable.clear().draw();
		}
		$("#loading").hide();
	}

	/* ********************************************************
	 * 싱크 커넥터 select box 변경
	 ******************************************************** */
	function fn_tarConnectInfo(){
		var langSelect = document.getElementById("tar_connector_list");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		
		//싱크 커넥터 - 하단 상세화면 초기화
		fn_tar_init();

		if(selectValue != ""){
			$.ajax({
				url : "/transTarConnectInfo.do",
				dataType : "json",
				type : "post",
				data : {
					 trans_id : selectValue,
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
				},
				success : function(result) {
					if (result != null) {
						if (nvlPrmSet(result.targetDBMSInfo, '') != '') {
							//싱크커넥터 - 토픽수, 전체완료수, 오류수
							$('#topic_cnt').html(result.topic_cnt);
							if(result.targetConnectInfo != null && result.targetConnectInfo != undefined){
								$('#tarconResultCntTableNvl').hide();
								$('#tarconResultCntTable').show();
								$('#sink_record_send_total').html(result.targetConnectInfo.sink_record_send_total);
								$('#tar_total_error').html(result.targetConnectInfo.total_record_errors);
								$('#skconResultTable').show();
							} else {
								$('#tarconResultCntTable').hide();
								$('#tarconResultCntTableNvl').show();
							}

							//연결도 dbms setting
							$('#d_tg_connect_nm').text(langSelect.options[langSelect.selectedIndex].text);
							$('#d_tg_sys_nm').text(result.targetDBMSInfo[0].trans_sys_nm);
							$('#d_tg_dbms_type').text(result.targetDBMSInfo[0].dbms_type);
							$('#d_tg_dbms_nm').text(result.targetDBMSInfo[0].dtb_nm);
							$('#d_tg_schema_nm').text(result.targetDBMSInfo[0].scm_nm);
						}

//						if(nvlPrmSet(result.allErrorList, '') != '') {
//							 allErrorChart.setData(result.allErrorList);
//						}

						//싱크 커넥터 - connect 정보 리스트 setting
						funcTarListSetting(result, langSelect);
						
						//싱크 커넥터 - 차트 setting
						fn_sink_chart_init(selectValue);
						
						//상단연결도 setting
						fn_dbmsConnect_digm("tar", result);
					}

				}
			});
		} else {
			$('#tarconResultCntTable').hide();
			$('#tarconResultCntTableNvl').show();
			$('#skconResultTable').hide();
		}
		$("#loading").hide();
	}

	/* ********************************************************
	 * kafka / connector 로그 보기 - 클릭
	 ******************************************************** */
	function fn_logView(type){
		var todayYN = 'N';
		var langSelect = document.getElementById("src_connect");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		var date = new Date().toJSON();
		
		var v_db_svr_id = $("#db_svr_id", "#transMonitoringForm").val();
		var v_kc_id = $("#kc_id", "#transMonitoringForm").val();

		$.ajax({
			url : "/transLogView.do",
			type : 'post',
			data : {
				db_svr_id : v_db_svr_id,
				date : date,
				kc_id : v_kc_id
			},
			success : function(result) {
				$("#connectorlog", "#transLogViewForm").html("");
				$("#dwLen", "#transLogViewForm").val("0");
				$("#fSize", "#transLogViewForm").val("");
				$("#log_line", "#transLogViewForm").val("1000");
				$("#type", "#transLogViewForm").val(type);
				$("#date", "#transLogViewForm").val(date);
//				$("#aut_id", "#transLogViewForm").val(aut_id);
//				$("#todayYN", "#transLogViewForm").val(todayYN);
				$("#todayYN", "#transLogViewForm").val("Y");
				$("#view_file_name", "#transLogViewForm").html("");
				$("#trans_id","#transLogViewForm").val(selectValue);
				$("#kc_id", "#transLogViewForm").val(v_kc_id);
				if(type === 'connector'){
					dateCalenderSetting();
					$('#restart_btn').hide();
					$('#wrk_strt_dtm_div').show();
					$('.log_title').html(' Connector 로그');
				} else if(type === 'kafka'){
					$('#restart_btn').show();
					$('#wrk_strt_dtm_div').hide();
					$('.log_title').html('');
				}
				fn_transLogViewAjax();
				$('#pop_layer_log_view').modal("show");
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
	}
</script>

<!-- log 팝업 -->
<%@ include file="./../popup/transLogView.jsp" %>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/confirmForm.jsp"%>
		
<form name="transMonitoringForm" id="transMonitoringForm" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="kc_id" id="kc_id" value=""/>
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
												<span class="menu-title"><spring:message code="menu.monitoring" /></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.monitoring" /> </li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0">전송관리에서 등록한 소스 시스템과 타겟 시스템의  상태를 모니터링 할 수 있습니다.</p>
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

		<!-- 실시간 chart start -->
		<!-- cpu chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> CPU
					</h4>
					<div id="chart-cpu" style="max-height:200px;"></div>
				</div>
			</div>
		</div>
		<!-- cpu chart end -->
		
		<!-- memory chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> memory
					</h4>
					<div id="chart-memory" style="max-height:200px;"></div>
				</div>
			</div>
		</div>
		<!-- memory chart end -->
		
		<!-- error chart start -->
		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> error
					</h4>
					<div id="chart-allError" style="max-height:200px;"></div>
				</div>
			</div>
		</div>
		<!-- error chart end -->
		<!-- 실시간 chart end -->
		
		<!-- 연결 상태 그림 start -->
		<div class="col-8 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
<!--					 <h4 class="card-title"> -->
<!--						 <i class="item-icon fa fa-dot-circle-o"></i> 연결도 -->
<!--					 </h4> -->
					
					<div class="row" id="reg_trans_title">
						<div class="accordion_main accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_ss_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">소스커넥터</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
											
						<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_ss_connect_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												&nbsp;
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="accordion_main col-2" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_kafka_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												&nbsp;
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-header" role="tab" id="page_sk_connect_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												&nbsp;
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
											
						<div class="accordion_main accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_sk_server" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">싱크커넥터</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				
					<!-- proxy 데이터 있는 경우 -->	
					<div class="row" id="reg_trans_detail">
						<div class="accordion_cdc accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="border:none;" >
								<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="proxyMonitoringList">
									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:80%;" class="text-center" ">
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-12" style="margin-right: 1rem;" name="src_connect" id="src_connect" onChange="fn_srcConnectInfo()" onblur="this.value=this.value.trim()" tabindex=1>
													<option value="">소스 Connector</option>
													<c:forEach var="srcConnectorList" items="${srcConnectorList}">
														<option value="${srcConnectorList.trans_id}">${srcConnectorList.connect_nm}</option>							
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td style="width:80%;" class="text-center">
												 <table id="ssconResultTable" class="table table-striped system-tlb-scroll" style="width:100%; border-bottom:1px solid;">
													<thead>
														<tr class="bg-info text-white">
															<th style="width:25%;font-size:12px;">테이블 수</th>
															<th style="width:37%;font-size:12px;">전체 완료 수</th>
															<th style="width:38%;font-size:12px;">오류 수</th>
														</tr>
														<tr id="ssconResultCntTableNvl" >
<!--															 <td colspan="3" style="font-size:12px;"> -->
															<td colspan="3">
<%--																 <spring:message code="message.msg01" /> --%>
																커넥터를 선택해주세요
															</td>
														</tr>
														<tr id="ssconResultCntTable" style="display:none;">
															<td style="text-align:center;font-size:12px;" id="table_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="src_total_poll_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="src_total_error_cnt"></td>
														</tr>
													</thead>
												</table>
											</td>
										</tr>
										
										<tr>
											<td style="width:80%;" class="text-center">
												 <table id="ssconDBResultTable" class="table-borderless" style="width:100%; display:none;">
													<tr id="ssconDBResultCntTable">
														<td style="width:100%;">
															
															<table class="table-borderless" style="width:100%;text-align:left;">
																<tr>
																	<td colspan="2" style="width:85%;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;" id="sourceDbmsNm">
																		</h6>
																	</td>
																	<td rowspan="3" style="width:15%;" id="sourceDbmsImg">
																		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
																	</td>
																</tr>
																
																<tr>
																	<td colspan="2" style="padding-top:5px;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;" id="sourceDbmsIp"></h6>
																	</td>
																</tr>

																<tr>
																	<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
																		<h6 class="text-muted" style="padding-left:10px;" id="sourceDbmsStatus"></h6>
																	</td>
																</tr>
															</table>
															
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									
								</div>
							</div>
						</div>

						<div class="accordion_cdc accordion-multi-colored col-1" id="accordion" role="tablist" >
							<div class="card" style="margin-left:-10px;margin-right:-30px;border:none;box-shadow: 0 0 0px black;">
								<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyListnerConLineList">
								
									<table class="table-borderless" style="width:100%;margin-top:35px;">
										<tbody>
											<tr>
												<td style="margin-left:10px;" class="text-center" id="123">
													<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;width:120px;height:120px;" alt="">
												</td>
											</tr>
										</tbody>
									</table>

								</div>
							</div>
						</div>

						<div class="accordion_cdc_none accordion-multi-colored col-2" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;" >
								<div class="card-body" style="border:none;" id="proxyListnerMornitoringList">
								
									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:100%;height:100%;margin-left:-20px;" class="text-center">
												<i onClick="fn_logView('kafka')">
													<img src="../images/connector_icon.png" class="img-lg" style="max-width:140%;object-fit: contain;width:140px;height:140px;" alt="">
												</i>
												<!-- <h6 class="text-muted mb-0 mb-md-3 mb-xl-0" style="padding-left:10px;max-width:140%" id="kafkaConnectorNm"></h6>
												<h6 class="text-muted" style="padding-left:10px;"><i class="fa fa-refresh fa-spin text-success icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>진행중</h6> -->
											</td>
										</tr>
										<tr>
											<td class="text-center" style="vertical-align: middle;padding-top:5px;padding-left:10px;">
												<h6 class="text-muted" style="padding-left:10px;font-weight: bold;" id="kafkaConnectorNm"></h6>
											</td>
										</tr>
										<tr>
											<td class="text-center" style="vertical-align: middle;padding-top:5px;">
												<h6 class="text-muted" style="padding-left:10px;" id="kafkaStatus"></h6>
											</td>
										</tr>
									</table>
								
								<!--	 <i class="mdi mdi-cloud-sync menu-icon text-info" style="font-size: 3.0em;" onClick="fn_logView('kafka')"></i> -->
								</div>
							</div>
						</div>

						<div class="accordion_cdc accordion-multi-colored col-1" id="accordion" role="tablist" >
							<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
								<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyListnerConLineList">
								
									<table class="table-borderless" style="width:100%;margin-top:35px;">
										<tr>
											<td style="width:100%;height:100%;" class="text-center" id="123">
												<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;width:120px;height:120px;" alt=""/>
											</td>
										</tr>
									</table>

								</div>
							</div>
						</div>

						<div class="accordion_cdc accordion-multi-colored col-4" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;" >
								<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="dbListenerVipList">

									<table class="table-borderless" style="width:100%;">
										<tr>
											<td style="width:80%;" class="text-center" ">
												<select class="form-control form-control-xsm mb-2 mr-sm-2 col-sm-12" style="margin-right: 1rem;" name="tar_connector_list" id="tar_connector_list" onChange="fn_tarConnectInfo()" onblur="this.value=this.value.trim()"  tabindex=1>
													<option value="">타겟 Connector</option>
													<c:forEach var="tarConnectorList" items="${targetConnectorList}">
														<option value="${tarConnectorList.trans_id}">${tarConnectorList.connect_nm}</option>							
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td style="width:80%;" class="text-center">
												 <table id="tarconResultTable" class="table table-striped system-tlb-scroll" style="width:100%; border-bottom:1px solid;">
													<thead>
														<tr class="bg-info text-white">
															<th style="width:25%;font-size:12px;">토픽 수</th>
															<th style="width:37%;font-size:12px;">전체 완료 수</th>
															<th style="width:38%;font-size:12px;">오류 수</th>
														</tr>
														<tr id="tarconResultCntTableNvl">
															<td colspan="3" >
<%--																 <spring:message code="message.msg01" /> --%>
																커넥터를 선택해주세요
															</td>
														</tr>
														<tr id="tarconResultCntTable" style="display:none;">
															<td style="text-align:center;font-size:12px;" id="topic_cnt"></td>
															<td style="text-align:center;font-size:12px;" id="sink_record_send_total"></td>
															<td style="text-align:center;font-size:12px;" id="tar_total_error"></td>
														</tr>
													</thead>
												</table>
											</td>
										</tr>
										
										<tr>
											<td style="width:80%;" class="text-center">
												 <table id="skconResultTable" class="table-borderless" style="width:100%; display:none;">
													<tr id="skconResultCntTable" >
														<td style="width:100%;">
															
															
															<table class="table-borderless" style="width:100%;text-align:left;">
																<tr>
																	<td colspan="2" style="width:85%;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;" id="targetDbmsNm">
																			<!-- <div class="badge badge-pill badge-success" title="">M</div> -->
																			<img src="../images/oracle_icon.png" class="img-sm" style="max-width:120%;object-fit: contain;" alt=""/>
																		</h6>
																	</td>
																	<td rowspan="3" style="width:15%;" id="targetDbmsImg">
																		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>
																	</td>
																</tr>
																
																<tr>
																	<td colspan="2" style="padding-top:5px;">
																		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;" id="targetDbmsIp"></h6>
																	</td>
																</tr>

																<tr>
																	<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">
																		<h6 class="text-muted" style="padding-left:10px;" id="targetDbmsStatus"></h6>
																	</td>
																</tr>
																
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-4 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title -->
				
					<!-- Connector 기동 정지 이력 -->
					<div class="row">
						<!-- title -->
						<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:0px;">
								<div class="card-header" role="tab" id="page_serverlogging_div" >
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<span class="menu-title">Connector 기동 정지 이력</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<!-- connector 기동 정지 이력 리스트 -->
						 <div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" >
							<div class="card" style="margin-bottom:10px;border:none;">
								<div class="card-body" style="border:none;margin-top:-25px;margin-left:-25px;margin-right:-25px;">
									<div class="row">
										<div class="col-sm-8">
											<h6 class="mb-0 alert">
												<span class="menu-title text-success"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i>최근 3개 항목만 보여집니다.</span>
											</h6>
										</div>
										<div class="col-sm-4.5">
											<button class="btn btn-outline-primary btn-icon-text btn-sm btn-icon-text" type="button" id="connector_log_btn" onClick="fn_logView('connector')">
												<i class="mdi mdi-file-document"></i>
												connector 로그
											</button>
										</div>
									</div>
									 <table id="connectorActTable" class="table table-striped system-tlb-scroll" style="width:100%;border:none;">
										<thead>
											<tr class="bg-info text-white">
												<th width="0px;">rownum</th>
												<th width="100px;">Connector 명</th>
												<th width="100px;">실행결과</th>
												<th width="100px;">시간</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div>
					<!-- connector 기동 정지 이력 리스트 end -->
				</div>
			</div>
		</div>
		<!-- 연결 상태 그림 end -->
		
		<!-- 소스 시스템 start -->
		<%@ include file="./transSourceMonitoring.jsp" %>
		<!-- 소스 시스템 end -->
		
		<!-- 타겟 시스템 start -->
		<%@ include file="./transTargetMonitoring.jsp" %>
		<!-- 타겟 시스템 end -->
		
	</div>
</div>