<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_cng" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body" style="margin-bottom:-40px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="menu.eXperDB_scale_settings"/>
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
											<spring:message code="eXperDB_scale.scale_type"/>
										</td>
										<td style="width: 70%; word-break:break-all;" id="d_scale_type_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.policy_type"/>
										</td>
										<td style="word-break:break-all;" id="d_policy_type_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.policy_time_div"/>
										</td>
										<td style="word-break:break-all;" id="d_auto_policy_set_div_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.policy_time"/>
										</td>
										<td style="word-break:break-all;" id="d_auto_policy_time"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.execute_type"/>
										</td>
										<td style="word-break:break-all;" id="d_execute_type_nm"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="dbms_information.use_yn"/>
										</td>
										<td style="word-break:break-all;" id="d_useyn"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.target_value"/>
										</td>
										<td style="word-break:break-all;" id="d_level"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.expansion_clusters"/>
										</td>
										<td style="word-break:break-all;" id="d_expansion_clusters"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.min_clusters"/>
										</td>
										<td style="word-break:break-all;" id="d_min_clusters"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="eXperDB_scale.max_clusters"/>
										</td>
										<td style="word-break:break-all;" id="d_max_clusters"></td>
									</tr>
									<tr>
										<td class="py-1" style="word-break:break-all;">
											<spring:message code="common.register"/>
										</td>
										<td style="word-break:break-all;" id="d_frst_regr_id"></td>
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