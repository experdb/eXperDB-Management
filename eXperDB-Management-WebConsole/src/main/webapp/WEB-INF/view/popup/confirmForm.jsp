<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
	//return
	function fnc_confirmSuccess() {
		$('#pop_confirm_md').modal('hide');
		fnc_confirmRst ();
	}
</script>

 <div class="modal fade" id="pop_confirm_md" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel-3" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog modal-sm" role="document" style="margin: 200px 650px;">
		<div class="modal-content" style="width:400px;height:250px;">
			<div class="modal-header bg-info text-white" style="border-bottom:0px;">
				<h4 class="modal-title fa fa-dot-circle-o" id="confirm_tlt"></h4>
				
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="margin-top:-20px;">
				<div class="modal-body" style="height:80px;">
					<p class="item-icon fa fa-check-square-o text-info" id="confirm_msg"></p>
				</div>
				
				<div class="modal-footer_con">
					<button type="button" class="btn btn-success" onclick="fnc_confirmSuccess();"><spring:message code="common.confirm" /></button>
					<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel" /></button>
				</div>
			</div>
		</div>
	</div>
</div>