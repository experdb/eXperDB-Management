<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
	//return
	function fnc_confirmSuccess() {
		$('#pop_confirm_multi_md').modal('hide');
		fnc_confirmMultiRst ($('#con_multi_gbn').val());
	}
	
	//cancel
	function fnc_confirmCancel() {
		if ($('#con_multi_gbn').val() == "con_start" || $('#con_multi_gbn').val() == "con_end" || $('#con_multi_gbn').val() == "ins_menu") {
			fnc_confirmCancelRst ($('#con_multi_gbn').val());
		}
		
		$('#pop_confirm_multi_md').modal('hide');
	}
	
</script>

<form name="findConfirmMulti" id="findConfirmMulti" method="post">
	<input type="hidden" name="con_multi_gbn" id="con_multi_gbn" value=""/>
</form>

 <div class="modal fade" id="pop_confirm_multi_md" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel-3" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog modal-sm" role="document" style="margin: 190px 650px;">
		<div class="modal-content" style="width:420px;height:260px;">
			<div class="modal-header" style="height:50px;padding-top:15px;">
				<h3 class="modal-title fa fa-dot-circle-o" id="confirm_multi_tlt"></h3>
				
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="margin-top:-40px;">
				<div class="modal-body" style="height:140px;display: table-cell;vertical-align: middle;">
					<h5 class="modal-title" id="confirm_multi_msg"></h5>
				</div>

				<div class="modal-footer_con">
					<button type="button" class="btn btn-primary" onclick="fnc_confirmSuccess();"><spring:message code="common.confirm" /></button>
					<button type="button" class="btn btn-light" onclick="fnc_confirmCancel();"><spring:message code="common.cancel" /></button>
				</div>
			</div>
		</div>
	</div>
</div>