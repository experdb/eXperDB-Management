<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>

<%
	/**
	* @Class Name : backupRunNow.jsp
	* @Description : 백업 즉시실행 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021. 02. 02     최초 생성
	*
	* author 신예은
	* since 2021.02.03
	*
	*/
%>

<script type="text/javascript">



	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {	
		fn_runNowReset();
	});
	
	function fn_runNowReset(){
		$("input:radio[name='backupType']:radio[value='1']").prop('checked', true);
	}
	
	function fn_cancel() {
		$("#pop_runNow").modal("hide");
	}
	
	
	function fn_runnow() {
		var jobtype = 	$(":radio[name='backupType']:checked").val();
		var jobname =  $("#pop_jobname").val();			
		
		$("#pop_runNow").modal("hide");	
		
		$.ajax({
			url : "/experdb/runNow.do",
			data : {				
				jobname:jobname,
				jobtype:jobtype		
				},
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {	
				fn_selectJob();	
			}
		});
	}


</script>
	
<div class="modal fade" id="pop_runNow" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel-3" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog modal-sm" role="document" style="margin: 190px 650px;">
		<div class="modal-content" style="width:420px;height:300px;">
			<div class="modal-header" style="height:50px;padding-top:15px;">
				<h3 class="modal-title fa fa-dot-circle-o" id="confirm_multi_tlt"> <spring:message code="migration.run_immediately" /></h3>
			</div>
			<div class="modal-body" style="margin-top:-40px;">
				<div class="modal-body" style="height:140px;display: table-cell; vertical-align: middle; padding-left: 50px; padding-bottom: 10px;">
					<h5 class="modal-title" id="confirm_multi_msg">Backup Type</h5>
					<div>
						<div class="form-check" style="margin-left: 20px;">
							<label class="form-check-label" for="incre">
								<input type="radio" class="form-check-input" id="incre" name="backupType"  value="1" />
								Incremental Backup
								<i class="input-helper"></i>
							</label>
						</div>
						<div class="form-check" style="margin-left: 20px;">
							<label class="form-check-label" for="verify">
								<input type="radio" class="form-check-input" id="verify" name="backupType"  value="2" />
								Verify Backup
								<i class="input-helper"></i>
							</label>
						</div>
						<div class="form-check" style="margin-left: 20px;">
							<label class="form-check-label" for="full">
								<input type="radio" class="form-check-input" id="full" name="backupType"  value="0"/>
								Full Backup
								<i class="input-helper"></i>
							</label>
						</div>
						
						<input type="hidden" name="pop_jobname" id="pop_jobname">
						
					</div>
				</div>

				<div class="modal-footer_con">
					<button type="button" class="btn btn-primary"   onclick="fn_runnow()"><spring:message code="common.confirm" /></button>
					<button type="button" class="btn btn-light" onclick="fn_cancel()"><spring:message code="common.cancel" /></button>
				</div>
			</div>
		</div>
	</div>
</div>