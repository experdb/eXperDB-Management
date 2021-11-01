<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%
	/**
	* @Class Name : transSourceMonitoring.jsp
	* @Description : 전송관리 소스 시스템 모니터링
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.07.26     최초 생성
	*
	* author 윤정 매니저
	* since 2021.07.26
	*
	*/
%>

<script type="text/javascript">

	var srcSnapshotTable = "";
	var srcStreamingTable = "";
	var srcConnectTable = "";
	var srcErrorTable = "";
	var srcMappingListTable = "";
	var snapshotChart = "";
	var streamingChart = "";
// 	var srcChart1 = "";
// 	var srcChart2 = "";
	var srcErrorChart = "";
	
	/* ********************************************************
	* TAB 선택 이벤트 
	******************************************************** */
	function selectTab(tab){	
		if(tab == "snapshot"){
			$(".snapshotDiv").show();
			$(".streamingDiv").hide();
			fn_snapshot_strem("snapshot");
		}else{
			$(".snapshotDiv").hide();
			$(".streamingDiv").show();

			fn_snapshot_strem("stream");
		}
	}
</script>

<div class="col-lg-6 grid-margin stretch-card" id="trans_monitoring_source_info" style="display:none;">
	<div class="card">
		<div class="card-body">
			<h4 class="card-title">
				<i class="item-icon fa fa-dot-circle-o"></i> 소스 시스템
			</h4>

			<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
				<li class="nav-item">
					<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('snapshot');" >
						snapshot
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('streaming');">
						streaming
					</a>
				</li>
			</ul>

			<div class="tab-content" id="pills-tabContent" style="border:none;">
				<div class="tab-pane fade show active snapshotDiv" style="margin-top:-30px;" role="tabpanel" id="subTab-1">
					<p class="card-title" style="margin-bottom:0px;">
						<i class="item-icon mdi mdi-snapchat text-info"></i>&nbsp;snapshot
					</p>
					<div id="src-chart-line-snapshot" style="height:170px;"></div>
				</div>
				<div class="tab-pane fade streamingDiv" style="margin-top:-30px;" role="tabpanel" id="subTab-2">	
					<p class="card-title" style="margin-bottom:0px;">
						<i class="item-icon mdi mdi-access-point text-info"></i>&nbsp;streaming
					</p>
					<div id="src-chart-line-streaming" style="height:170px;"></div>
				</div>
			</div>

			<div class="accordion_main accordion-multi-colored " id="accordion_src_connect_his" role="tablist">
				<div class="card " style="margin-bottom:0px;">
					<div class="card-header" role="tab" id="src_connect_header_div">
						<div class="row" style="height: 15px;">
							<div class="col-6">
								<h6 class="mb-0">
									<a data-toggle="collapse" href="#src_connect_header_sub" aria-expanded="true" aria-controls="src_connect_header_sub" onclick="fn_profileChk('SrcConnectTitleText')">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span class="menu-title">Connect 정보</span>
										<i class="menu-arrow_user_af" id="SrcConnectTitleText" ></i>
									</a>
								</h6>
							</div>
							<div class="col-6">
								<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
									<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_src_connect_his_today"></li>
								</ol>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- connect title end -->
			
			<!-- connect info start -->
			<div id="src_connect_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="src_connect_header_div" data-parent="#accordion_src_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center" >
					<div class="card " style="margin-bottom:0px;border:none;">
						<div class="card-body" style="border:none; box-shadow: 0px 1px 7px 1px rgba(211, 211, 211, 2);margin-bottom:8px;">
							<div class="form-group row" style="margin-bottom:-20px;margin-top:-20px;">
								<label class="col-sm-12 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									connect 설정 정보
								</label>
							</div>
							
							<div class="form-group row" style="margin-bottom:-10px;">
								<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
									<div class="card" style="border:0px;">
										<div class="card-body" style="padding-left:0px;padding-right:0px;">	
									 		<table id="srcConnectSettingInfoTable" class="table table-hover system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="100" class="dt-center" >connect명</th>
														<th width="500" class="dt-center" >데이터베이스</th>	
														<th width="500" class="dt-center" >메타데이터여부</th>	
														<th width="500" class="dt-center" >스냅샷여부</th>	
														<th width="500" class="dt-center" >압축형태</th>	
													</tr>
												</thead>
	<!-- 											<tbody> -->
	<!-- 												<tr> -->
	<!-- 													<td>inventory-connector -->
	<!-- 													</td> -->
	<!-- 													<td>inventory</td> -->
	<!-- 													<td> -->
	<!-- 														<div class="badge badge-pill badge-light" style="background-color: #EEEEEE;">	 -->
	<!-- 															<i class="fa fa-power-off mr-2"></i> -->
	<!-- 															OFF -->
	<!-- 														</div> -->
	<!-- 													</td> -->
	<!-- 													<td>NEVER </td> -->
	<!-- 													<td> -->
	<!-- 														<div class="badge badge-light" style="background-color: transparent !important;">	 -->
	<!-- 															<i class="fa fa-file-zip-o text-success mr-2"></i>GZIP -->
	<!-- 														</div> -->
	<!-- 													</td> -->
	<!-- 												</tr> -->
	<!-- 											</tbody> -->
											</table>
										</div>
									</div>
								</div>
							</div>
							<br/>
							<div class="form-group row" style="margin-bottom:-20px;">
								<label class="col-sm-12 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="data_transfer.transfer_table" />
								</label>
							</div>
							
							<div class="form-group row" style="margin-bottom:-10px;">
								<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
									<div class="card" style="border:0px;">
										<div class="card-body" style="padding-left:0px;padding-right:0px;">	
									 		<table id="srcMappingListTable" class="table table-hover system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="100" class="dt-center" >스키마명</th>
														<th width="500" class="dt-center" >테이블명</th>	
													</tr>
	<!-- 											</thead> -->
	<!-- 											<tbody> -->
	<!-- 												<tr> -->
	<!-- 													<td>experdb</td> -->
	<!-- 													<td>dumb_table</td> -->
	<!-- 												</tr> -->
	<!-- 											</tbody> -->
											</table>
										</div>
									</div>
								</div>
							</div>
									
						</div>
					</div>
				</div>
			</div>
			<!-- connect info end -->

			<div id="src_connect_header_sub_list" class="collapse show row" role="tabpanel" aria-labelledby="src_connect_header_div" data-parent="#accordion_src_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;border:none;">
						<div class="card-body" style="border:none;">
							<p class="card-title" style="margin-bottom:5px;margin-left:10px;">
								<i class="item-icon fa fa-bar-chart-o text-info"></i>
								&nbsp;connect 실시간 차트
<!-- 								<i class="fa fa-bar-chart-o menu-icon text-info"></i> -->
<!-- 								connect 실시간 차트 -->
							</p>
						</div>
					</div>
				</div>

				<!-- chart 1 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon mdi mdi-chart-line text-info"></i>&nbsp;실시간 전송 레코드
							</p>
							<div id="src-chart-line-1" style="height:200px;"></div>
						</div>
					</div>
				</div>
				
				<!-- chart 2 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon mdi mdi-chart-areaspline text-info"></i>&nbsp;평균 전송 레코드
							</p>
							<div id="src-chart-line-2" style="height:200px;"></div>
						</div>
					</div>
				</div>

				<!-- connect 리스트 -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;margin-top:-30px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="srcConnectTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">time</th>
										<th width="100px;">커넥터 미기록 최대 레코드 수</th>
										<th width="100px;">커넥터 기록된 평균 레코드 수 </th>
										<th width="100px;">커넥터 미기록 평균 레코드 수</th>
										<th width="100px;">커넥터 기록된 레코드 수 </th>
										<th width="100px;">커넥터 미기록 레코드 수 </th>
										<th width="100px;">폴링 총 레코드 수</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- connect 정보 end -->

			<!-- error 정보 start -->
			<div class="accordion_main accordion-multi-colored" id="accordion_src_error_his" role="tablist">
				<div class="card" style="margin-bottom:0px;">
					<div class="card-header" role="tab" id="src_error_header_div">
						<div class="row" style="height: 15px;">
							<div class="col-6">
								<h6 class="mb-0">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<span class="menu-title">Error 정보</span>
								</h6>
							</div>
							<div class="col-6">
								<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
									<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_src_error_his_today"></li>
								</ol>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- error chart -->
			<div class="col-md-12 col-xl-12 justify-content-center">
				<div class="card" style="margin-left:-20px;border:none;">
					<div class="card-body" style="border:none;">
						<div id="src-chart-line-error" style="max-height:200px;"></div>
					</div>
				</div>
			</div>

			<!-- error 리스트 -->
<!-- 			<div class="col-md-12 col-xl-12 justify-content-center"> -->
<!-- 				<div class="card" style="margin-left:-10px;border:none;"> -->
<!-- 					<div class="card-body" style="border:none;"> -->
<!-- 						<table id="srcErrorTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;"> -->
<!-- 							<thead class="bg-info text-white"> -->
<!-- 								<tr> -->
<!-- 									<th width="0px;">rownum</th> -->
<!-- 									<th width="100px;">last_error_timestamp </th> -->
<!-- 									<th width="100px;">total_errors_logged </th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_requests</th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_failures </th> -->
<!-- 									<th width="100px;">total_record_failures</th> -->
<!-- 									<th width="100px;">total_records_skipped </th> -->
<!-- 									<th width="100px;">total_record_errors</th> -->
<!-- 									<th width="100px;">total_retries</th> -->
<!-- 								</tr> -->
<!-- 							</thead> -->
<!-- 						</table> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
				
			<!-- error 정보 end -->
		</div>
	</div>
</div>
