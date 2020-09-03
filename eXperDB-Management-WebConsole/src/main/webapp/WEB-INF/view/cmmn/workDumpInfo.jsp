<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_dump" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 180px;">
		<div class="modal-content" style="width:1400px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="backup_management.work_info"/>
				</h4>

				<div class="card" style="border:0px;height: 570px; ">
					<div class="row">
						<div class="col-md-9" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
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
													<spring:message code="backup_management.bck_div"/>
												</td>
												<td colspan="3" style="width: 83%; word-break:break-all;" id="d_bck_bsn_dscd_nm"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.work_name"/>
												</td>	
												<td style="width: 33%; word-break:break-all;" id="d_wrk_nm"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.work_description"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_wrk_exp"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.database"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_db_nm"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.backup_dir"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_save_pth"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.file_format"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_file_fmt_cd_nm"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.compressibility"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_cprt"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.incording_method"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_encd_mth_nm"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.rolename"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_usr_role_nm"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.file_keep_day"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_file_stg_dcnt"></td>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.backup_maintenance_count"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_bck_mtn_ecnt"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="card-body-modal">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="backup_management.add_option" />1
								</h3>
						
								<div class="table-responsive system-tlb-scroll">
									<table class="table table-striped">
										<tbody>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.sections"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_sections"></td>
												
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.object_type"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_objectType"></td>
											</tr>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.save_yn_choice"/>
												</td>
												<td colspan="3" style="width: 83%; word-break:break-all;" id="d_save_yn"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>

							<div class="card-body-modal">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="backup_management.add_option" />2
								</h3>
		
								<div class="table-responsive system-tlb-scroll">
									<table class="table table-striped">
										<tbody>
											<tr>
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="backup_management.query"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_query"></td>
												
												<td class="py-1" style="width: 17%; word-break:break-all;">
													<spring:message code="common.etc"/>
												</td>
												<td style="width: 33%; word-break:break-all;" id="d_etc"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						
						<div class="col-md-3 system-tlb-scroll" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
							<div class="card-body-modal">
								<!-- title -->
								<h3 class="card-title fa fa-dot-circle-o">
									<spring:message code="backup_management.add_option" />3 - <spring:message code="backup_management.object_choice" />
								</h3>
		
								<div class="table-responsive system-tlb-scroll">
									<table class="table">
										<tbody>
											<tr>
												<td class="py-1" style="width: 100%; word-break:break-all;">
													<form>
														<div class="row">
															<div class="col-md-12">
																<div class="form-group tNav_new" >
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