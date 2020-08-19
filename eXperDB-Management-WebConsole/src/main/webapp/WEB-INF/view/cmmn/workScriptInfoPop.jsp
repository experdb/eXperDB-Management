<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : workScriptInfoPop.jsp
	* @Description : 배치 상세 화면
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

<script type="text/javascript">
	/* ********************************************************
	 * 창닫기
	 ******************************************************** */
	function fn_workScriptInfoPopcl() {
		var contentsGbn_chk = $("#contents_gbn", "#rsltMsgWorkForm").val();
		$("#pop_layer_script_work").modal("hide");
		
		if (contentsGbn_chk != null && contentsGbn_chk != "") {
			$("#"+ contentsGbn_chk).modal("show");
		}
	}
</script>

<div class="modal fade" id="pop_layer_script_work" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.script_execution_command"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="rsltMsgWorkForm">
							<input type="hidden" name="contents_gbn" id="contents_gbn" value="" />

							<fieldset>
								<div class="form-group row">
									<div class="col-sm-12">
										<textarea class="form-control" id="info_exe_cmd" name="info_exe_cmd" style="height: 400px;" readonly></textarea>
									</div>
								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<button type="button" class="btn btn-light" onclick="fn_workScriptInfoPopcl();"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>