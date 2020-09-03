<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div class="modal fade" id="pop_layer_db2pgConfig" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 320px;">
		<div class="modal-content" style="width:1000px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					Configuration
				</h4>
				<div class="card" style="border:0px;">
					<div class="card-body-modal">
						<div class="table-responsive system-tlb-scroll">
							<table class="table table-striped" style="border:1px solid #b8c3c6;">
								<tbody>						
										<tr>
											<td>
												<div class="textarea_grp">
													<textarea name="config" id="config"  style="height: 440px; width: 100%;" readonly></textarea>
												</div>
											</td>
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