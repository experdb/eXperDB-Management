<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_backrest" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 180px;">
		<div class="modal-content" style="width:1400px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="backup_management.work_info"/>
				</h4>

				<div class="card" style="border:0px;height: 570px; ">
					<div class="row">
						<div class="col-md-8" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
							<div class="card-body-modal">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="properties.basic_info" />
								</h3>
								
								<div class="table-responsive system-tlb-scroll">
									<table class="table table-striped">
										<tbody>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.bck_div"/>&nbsp; / &nbsp;<spring:message code="backup_management.storage"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_bsdn_storage"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.server"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_svr"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.work_name"/>
												</td>	
												<td style="width: 33%; word-break:break-all;" id="b_wrk_nm"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.work_description"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_wrk_exp"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.gbn"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_bgn"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.backup_dir"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_pth"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.backup_maintenance_count"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_cnt"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="properties.log_path"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_bck_log_pth"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="etc.etc22"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_compress_type"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.paralles"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="b_paralles"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="card-body-modal" id="remote_info">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="backup_management.remote" />
								</h3>
						
								<div class="table-responsive system-tlb-scroll">
									<table class="table table-striped">
										<tbody>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="data_transfer.ip"/>
												</td>
												<td style="width: 75%; word-break:break-all;" id="b_ip"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="data_transfer.port"/>
												</td>
												<td colspan="3" style="width: 75%; word-break:break-all;" id="b_port"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17; word-break:break-all;">
													<spring:message code="encrypt_policy_management.OS_User"/>
												</td>
												<td colspan="3" style="width: 75%; word-break:break-all;" id="b_usr"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						
						<div class="col-md-4 system-tlb-scroll" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
							<div class="card-body-modal">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="eXperDB_proxy.present_conf" />
								</h3>
		
								<div class="table-responsive system-tlb-scroll">
									<table class="table">
										<tbody>
											<tr>
												<td class="py-1" style="width: 100%; word-break:break-all;">
													<form>
														<div class="row">
															<div class="col-md-12">
																<div class="form-group " >
																	<textarea id="wrk_conf" style="height: 475px; width: 100%;" disabled></textarea>
																</div>
															</div>
														</div>
													</form>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>

			<div class="top-modal-footer" style="text-align: center !important;margin-bottom:10px;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>