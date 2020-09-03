<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_scheduleInfo" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="menu.schedule_information" />
				</h4>

				<div class="card" style="border:0px;margin-bottom:-40px;">
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
											<spring:message code="schedule.schedule_name"/>
										</td>
										<td style="width: 70%; word-break:break-all;" id="d_scd_nm_info"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="schedule.exeState"/>
										</td>
										<td style="word-break:break-all;" id="d_scd_cndt_info"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="schedule.exeCycle"/>
										</td>
										<td style="word-break:break-all;" id="d_exe_perd_cd_info"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="schedule.exeDate"/>
										</td>
										<td style="word-break:break-all;" id="d_scd_exe_hms"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="schedule.scheduleExp"/>
										</td>
										<td style="word-break:break-all;" id="d_scd_exp_info"></td>
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