<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%
	/**
	* @Class Name : transTargetMonitoring.jsp
	* @Description : 전송관리 타겟 시스템 모니터링
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
	var tarConnectTable = "";
	var tarErrorTable = "";
	var tarTopicListTable = "";
</script>

<div class="col-lg-6 grid-margin stretch-card" id="trans_monitoring_target_info" style="display:none;">
	<div class="card">
		<div class="card-body">
			<h4 class="card-title">
				<i class="item-icon fa fa-dot-circle-o"></i> 타겟 시스템
			</h4>
			
<!-- 			<div  style="display:none;"> -->

			<!-- 타겟 DBMS start -->
			<div class="row">
				<div class="accordion_main accordion-multi-colored col-12" id="accordion_tar_dbms_his" role="tablist">
					<div class="card" style="margin-bottom:0px;">
						<div class="card-header" role="tab" id="tar_dbms_header_div">
							<div class="row" style="height: 15px;">
								<div class="col-6">
									<h6 class="mb-0">
										<a data-toggle="collapse" href="#tar_dbms_header_sub" aria-expanded="true" aria-controls="tar_dbms_header_sub" onclick="fn_profileChk('TarDBMSTitleText')">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<span class="menu-title">타겟 DBMS 정보</span>
											<i class="menu-arrow_user_af" id="TarDBMSTitleText" ></i>
										</a>
									</h6>
								</div>
								<div class="col-6">
									<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
										<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_tar_dbms_his_today"></li>
									</ol>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>		
								
			<div id="tar_dbms_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="tar_dbms_header_div" data-parent="#accordion_tar_dbms_his">
				<div class="col-md-12 col-xl-12 justify-content-center" >
					<div class="card" style="border:none; box-shadow: 0px 1px 7px 1px rgba(211, 211, 211, 2);">
						<div class="card-body" style="border:none; margin-bottom:8px;">
							<div class="form-group row" style="margin-bottom:0px;margin-top:-10px;">
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="data_transfer.connect_name_set" />
								</label>
								<div class="col-sm-8">
									<span class="form-control-xsm float-left text-muted" id="d_tg_connect_nm" ></span>
								</div>
								<div class="col-sm-1">
									&nbsp;
								</div>
							</div>
						
							<div class="form-group row" style="margin-bottom:5px;">
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									시스템 명
								</label>
								<div class="col-sm-4">
									<span class="form-control-xsm float-left text-muted" id="d_tg_sys_nm" ></span>
								</div>
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									DBMS 구분
								</label>
								<div class="col-sm-4">
									<span class="form-control-xsm float-left text-muted" id="d_tg_dbms_type" ></span>
								</div>
							</div>
						
							<div class="form-group row" style="margin-bottom:5px;">
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									DB
								</label>
								<div class="col-sm-4">
									<span class="form-control-xsm float-left text-muted" id="d_tg_dbms_nm" ></span>
								</div>
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									스키마
								</label>
								<div class="col-sm-4">
									<span class="form-control-xsm float-left text-muted" id="d_tg_schema_nm" ></span>
								</div>
							</div>
							
						</div>
						<div class="card-body" style="border:none; margin-bottom:8px; height:205px; display:none;">
							데이터가 없습니다.
						</div>
					</div>
				</div>
			</div>
			<!-- 타겟 DBMS end -->
			
			<!-- connect 정보 start -->
			<!-- connect 정보 title -->
			<div class="row">
				<div class="accordion_main accordion-multi-colored col-12" id="accordion_tar_connect_his" role="tablist">
					<div class="card" style="margin-bottom:0px; margin-top:42px;">
						<div class="card-header" role="tab" id="tar_connect_header_div">
							<div class="row" style="height: 15px;">
								<div class="col-6">
									<h6 class="mb-0">
										<a data-toggle="collapse" href="#tar_connect_header_sub" aria-expanded="true" aria-controls="tar_connect_header_sub" onclick="fn_profileChk('TarConnectTitleText')">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<span class="menu-title">Connect 정보</span>
											<i class="menu-arrow_user_af" id="TarConnectTitleText" ></i>
										</a>
									</h6>
								</div>
								<div class="col-6">
									<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
										<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_tar_connect_his_today"></li>
									</ol>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>			
					
			<div id="tar_connect_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="tar_connect_header_div" data-parent="#accordion_tar_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center" >
					<div class="card" style="box-shadow: 0px 1px 7px 1px rgba(211, 211, 211, 2);">
						<div class="card-body" style=" margin-bottom:8px; border:none;">
							<div class="form-group row" style="margin-bottom:0px;margin-top:-10px;">
								<label class="col-sm-2 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="data_transfer.connect_name_set" />
								</label>
								<div class="col-sm-8">
									<span class="form-control-xsm float-left text-muted" id="tar_connect_nm" ></span>
								</div>
								<div class="col-sm-1">
									&nbsp;
								</div>
							</div>
						
							<div class="form-group row" style="margin-bottom:-20px;">
								<label class="col-sm-3 col-form-label-sm pop-label-index" style="padding-top:calc(0.5rem-1px);">
									<i class="item-icon fa fa-dot-circle-o"></i>
									<spring:message code="data_transfer.transfer_topic" />
								</label>
								<div class="col-sm-9">
								</div>
							</div>
						
							<div class="form-group row" style="margin-bottom:-10px;">
								<div class="col-12 stretch-card div-form-margin-table" style="margin-top:-15px;">
									<div class="card" style="border:0px;">
										<div class="card-body" style="padding-left:0px;padding-right:0px; ">	
								 			<table id="tarTopicListTable" class="table table-hover system-tlb-scroll" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="100" class="dt-center" ><spring:message code="common.order" /></th>
														<th width="500" class="dt-center" ><spring:message code="data_transfer.topic_nm" /></th>	
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
			
			<div id="tar_connect_header_sub_list" class="collapse show row" role="tabpanel" aria-labelledby="tar_connect_header_div" data-parent="#accordion_tar_connect_his">
				<div class="col-md-12 col-xl-12 justify-content-center" style="margin-top:42px;">
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
								<i class="item-icon mdi mdi-chart-line text-info"></i>&nbsp;실시간 레코드
							</p>
							<div id="tar-chart-line-sink" style="height:200px;"></div>
						</div>
					</div>
				</div>
						
				<!-- chart 2 -->
				<div class="col-md-6 col-xl-6 justify-content-center">
					<div class="card" style="border:none;">
						<div class="card-body" style="border:none;margin-top:-35px;">
							<p class="card-title" style="margin-bottom:0px;margin-left:10px;">
								<i class="item-icon mdi mdi-chart-areaspline text-info"></i>&nbsp;완료 레코드
							</p>
							<div id="tar-chart-line-complete" style="height:200px;"></div>
						</div>
					</div>
				</div>

				<!-- connect 리스트 -->
				<div class="col-md-12 col-xl-12 justify-content-center">
					<div class="card" style="margin-left:-10px;margin-top:-30px;border:none;">
						<div class="card-body" style="border:none;">
							<table id="tarConnectTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
								<thead class="bg-info text-white">
									<tr>
										<th width="100px;">time</th>
										<th width="100px;">sink_record_active_count</th>
										<th width="100px;">put_batch_avg_time_ms</th>
										<th width="100px;">offset_commit_completion_rate </th>
										<th width="100px;">sink_record_send_total </th>
										<th width="100px;">sink_record_active_count_avg</th>
										<th width="100px;">offset_commit_completion_total </th>
										<th width="100px;">offset_commit_skip_rate </th>
										<th width="100px;">offset_commit_skip_total </th>
										<th width="100px;">sink_record_read_total </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>

			</div>
			<!-- connect 정보 end -->
			
			
			<!-- error 정보 start -->
			<div class="row">
				<div class="accordion_main accordion-multi-colored col-12" id="accordion_tar_error_his" role="tablist">
					<div class="card" style="margin-bottom:0px;">
						<div class="card-header" role="tab" id="tar_error_header_div">
							<div class="row" style="height: 15px;">
								<div class="col-6">
									<h6 class="mb-0">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<span class="menu-title">Error 정보</span>
									</h6>
								</div>
								<div class="col-6">
									<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
										<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_tar_error_his_today"></li>
									</ol>
								</div>
							</div>
						</div>
					</div>
				</div>

			<!-- error chart -->
				<div class="col-md-12 col-xl-12 justify-content-center" id="tar-chart-error" >
					<div class="card" style="margin-left:-10px;border:none;">
<!-- 						<div class="card-body" style="border:none;"> -->
						<div class="card-body">
							<div id="tar-chart-line-sink-error" style="height:200px;"></div>
						</div>
					</div>
				</div>
				
				<div class="col-md-12 col-xl-12 justify-content-center" id="tar-chart-error-nvl" style="border:1px; display:none;">
					<div class="card" >
						<div class="card-body">
							<div id="tar-chart-line-sink-error-nvl" style="height:30px;">데이터가 없습니다.</div>
						</div>
					</div>
				</div>
								
			</div>			
			<!-- error 리스트 -->
<!-- 			<div class="col-md-12 col-xl-12 justify-content-center"> -->
<!-- 				<div class="card" style="margin-left:-10px;border:none;"> -->
<!-- 					<div class="card-body" style="border:none;"> -->
<!-- 						<table id="tarErrorTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;"> -->
<!-- 							<thead class="bg-info text-white"> -->
<!-- 								<tr> -->
<!-- 									<th width="100px;">last_error_timestamp </th> -->
<!-- 									<th width="100px;">total_errors_logged </th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_requests</th> -->
<!-- 									<th width="100px;">deadletterqueue_produce_failures </th> -->
<!-- 									<th width="100px;">total_record_failures</th> -->
<!-- 									<th width="100px;">total_records_skipped </th> -->
<!-- 									<th width="100px;">total_record_errors</th> -->
<!-- 								</tr> -->
<!-- 							</thead> -->
<!-- 						</table> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
			<!-- error 정보 end -->
			
<!-- 			</div> -->
			
			
			<div class="card" style="display:none;">
				커넥터를 선택해주세요.
			</div>
			
		</div>
	</div>
</div>
