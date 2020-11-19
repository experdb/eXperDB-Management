<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_log" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-40px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="menu.scale_execute_hist"/>
				</h4>
		
				<div class="card" style="border:0px;">
					<div class="card-body-modal">
						<!-- title -->
						<h3 class="card-title fa fa-dot-circle-o">
							<spring:message code="schedule.detail_view" />
						</h3>
								
						<div class="table-responsive" style="overflow:auto;">
							<table class="table table-striped">
								<tbody>
									<tr>
										<td class="py-1" style="width: 30%; word-break:break-all;">
											<spring:message code="eXperDB_scale.process_id"/>
										</td>
										<td style="width: 70%; word-break:break-all;" id="d_process_id"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.ipadr"/>
										</td>
										<td style="word-break:break-all;" id="d_ipadr"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.scale_type"/>
										</td>
										<td style="word-break:break-all;" id="d_scale_type_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.wrk_type"/>
										</td>
										<td style="word-break:break-all;" id="d_wrk_type_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.auto_policy_nm"/>
										</td>
										<td style="word-break:break-all;" id="d_auto_policy_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.work_start_time"/>
										</td>
										<td style="word-break:break-all;" id="d_wrk_strt_dtm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.work_end_time"/>
										</td>
										<td style="word-break:break-all;" id="d_wrk_end_dtm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.working_time"/>
										</td>
										<td style="word-break:break-all;" id="d_wrk_dtm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.progress"/>
										</td>
										<td style="word-break:break-all;" id="d_wrk_stat"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="common.status"/>
										</td>
										<td style="word-break:break-all;" id="d_exe_rslt_cd_nm"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>