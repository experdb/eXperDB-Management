<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_rman" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:9999;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 400px;">
		<div class="modal-content" style="width:1000px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="backup_management.work_info"/>
				</h4>

				<div class="card" style="border:0px;">
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
										<td style="width: 33%; word-break:break-all;" id="r_bck_bsn_dscd_nm"></td>
										
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.backup_option"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_bck_opt_cd_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="common.work_name"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_wrk_nm"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="common.work_description"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_wrk_exp"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.compress"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_cps_yn"></td>
										
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.backup_log_dir"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_log_file_pth"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.data_dir"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_data_pth"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.backup_dir"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_bck_pth"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<div class="card-body-modal">
						<!-- title -->
						<h3 class="card-title fa fa-dot-circle-o">
							<spring:message code="backup_management.backup_file_option" />
						</h3>
				
						<div class="table-responsive system-tlb-scroll">
							<table class="table table-striped">
								<tbody>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.full_backup_file_keep_day"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_file_stg_dcnt"></td>
										
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.full_backup_file_maintenance_count"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_bck_mtn_ecnt"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.archive_file_keep_day"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_acv_file_stgdt"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.archive_file_maintenance_count"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_acv_file_mtncnt"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card-body-modal">
						<!-- title -->
						<h3 class="card-title fa fa-dot-circle-o">
							<spring:message code="backup_management.log_file_option" />
						</h3>
				
						<div class="table-responsive system-tlb-scroll">
							<table class="table table-striped">
								<tbody>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.log_file_backup_yn"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_log_file_bck_yn"></td>
										
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.server_log_file_keep_day"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="r_log_file_stg_dcnt"></td>
									</tr>
									
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="backup_management.server_log_file_maintenance_count"/>
										</td>
										<td colspan="3" style="width: 83%; word-break:break-all;" id="r_log_file_mtn_ecnt"></td>
									</tr>
								</tbody>
							</table>
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