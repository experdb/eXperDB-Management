<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_err_msg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
 	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">
			<div class="modal-body">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="eXperDB_scale.scale_job_log_info"/>
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
										<td style="word-break:break-all;">
											<textarea class="form-control" id="d_scaleWrkLogInfo" style="height: 250px;" readonly="readonly"></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-primary" onclick="fnc_menuMove()" id="scale_wrk_menu_move"><spring:message code="menu.scale_manual"/><spring:message code="eXperDB_scale.move_menu"/></button>
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>