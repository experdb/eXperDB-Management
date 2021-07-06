<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : recPwChkForm.jsp
	* @Description : 복구 비밀번호 확인 폼
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-06-15	신예은 매니저		최초 생성
	*
	*
	* author 신예은 매니저
	* since 2021.06.15
	*
	*/
%>

<script type="text/javascript">

	$(window.document).ready(function() {
		fn_pwCheckFormReset();
	});
	
	function fn_pwCheckFormReset(){
		$("#recoveryPW").val("");
		$("#recoveryPW").focus();
	}


</script>
	
<div class="modal fade" id="pop_layer_popup_recoveryPasswordCheckForm" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl" role="document" style="width: 450px;margin-top: 220px;margin-right: 700px;">
		<div class="modal-content" >
			<div class="modal-body" style="margin-bottom:-30px;padding-top: 30px;">
				<div class="row">
					<h5 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel_Reg" style="padding-left:5px;">
						비밀변호 확인
					</h5>
				</div>
				<div class="card" style="border:0px;padding-top: 10px;">
					<div class="card-body" style="padding-top: 0px;padding-bottom: 10px;">
						<div class="form-group row" style="border: 1px solid rgb(200, 200, 200); height: 90px;margin-bottom: 0px;padding-top: 25px;padding-left: 10px;">
							<div  class="col-4 col-form-label pop-label-index" style="padding-top:7px;">
							비밀번호
							</div>
							<div class="col-6" style="padding-left: 0px;">
								<input type="password" id="recoveryPW" name="recoveryPW" class="form-control form-control-sm" style="height: 40px;"/>
							</div>
						</div>
					</div>
					<div class="card-body">
						<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
							<button type="button" class="btn btn-primary" id="regButton" onclick="fn_recoveryRun()">실행</button>
							<button type="button" class="btn btn-light" data-dismiss="modal" onclick=""><spring:message code="common.cancel"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>