<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : fixRsltMsg.jsp
	* @Description : 조치입력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>
<div class="modal fade" id="pop_layer_fix_rslt_msg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="etc.etc32"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="rsltMsgForm">
							<input type="hidden" name="fix_update_view_gbn" id="fix_update_view_gbn" value=""/>

							<fieldset>
								<div class="form-group row div-form-margin-z">
									<label for="rdo_2_3" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="etc.etc42"/>
									</label>

									<div class="col-sm-2">
										<div class="form-check">
											<label class="form-check-label" for="rdo_2_3">
												<input type="radio" class="form-check-input" name="rdo" id="rdo_2_3" value="TC002001" checked tabindex=1 />
                          						<spring:message code="etc.etc29"/>
                          					</label>
                          				</div>
                          			</div>
                          			<div class="col-sm-2">
                          				<div class="form-check">
                          					<label class="form-check-label" for="rdo_2_4">
                          						<input type="radio" class="form-check-input" name="rdo" id="rdo_2_4" value="TC002002" tabindex=2 />
                          						<spring:message code="etc.etc30" />
                          					</label>
                          				</div>
                          			</div>
                          			<div class="col-sm-5">
                          				&nbsp;
                          			</div>
								</div>

								<div class="form-group row div-form-margin-z">
									<label for="lst_mdfr_id" class="col-sm-2 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="etc.etc35"/>
									</label>
									
									<div class="col-sm-4">
										<input type="text" class="form-control" name="lst_mdfr_id"  id="lst_mdfr_id" readonly>
                          			</div>
                          			
									<label for="lst_mdf_dtm" class="col-sm-2 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="etc.etc36"/>
									</label>
									
                          			<div class="col-sm-4">
                          				<input type="text" class="form-control" name="lst_mdf_dtm"  id="lst_mdf_dtm" readonly>
                          			</div>
								</div>
	
								<div class="form-group">
									<div class= "row div-form-margin-z">
										<div class="col-sm-12" style="padding-left:0px;">
											<label for="fix_rslt_msg" class="col-sm-3 col-form-label">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="etc.etc43"/>
											</label>
										</div>
									</div>
									<div class= "row">
										<div class="col-sm-12">
											<textarea class="form-control" id="fix_rslt_msg" name="fix_rslt_msg" style="height: 250px;" maxlength="500" tabindex=3></textarea>
											<input type="hidden" name="exe_sn" id="exe_sn">
										</div>
									</div>

								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<button type="button" class="btn btn-primary" onclick="fn_fix_rslt_msg_modify();"><spring:message code="common.modify"/></button>
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>