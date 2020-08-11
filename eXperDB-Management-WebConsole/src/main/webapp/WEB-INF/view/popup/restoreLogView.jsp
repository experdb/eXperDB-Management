<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : restoreLogList.jsp
	* @Description : 복구로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.31     최초 생성
	*
	* author 변승우
	* since 2019.01.31
	*
	*/
%>

<script type="text/javascript">
	var popFlag = "";
	var popRestore_sn = "";
	
	/* ********************************************************
	 * 로그 더보기
	 ******************************************************** */
	function fn_addView() {
		popFlag = $("#pop_flag", "#findList").val();
		popRestore_sn = $("#pop_restore_sn", "#findList").val();

		$.ajax({
			url : "/restoreLogInfo.do",
			dataType : "json",
			type : "post",
			async : false,
 			data : {
 				db_svr_id : $("#db_svr_id", "#findList").val(),
 				restore_sn : popRestore_sn,
 				flag : popFlag
 			},
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
			success : function(result) {
				if (popFlag == "rman") {
					$("#restoreRmanHistorylog").append(result.strResultData); 
				} else {
					$("#restoreDumpHistorylog").append(result.strResultData); 
				}

			}
		});
	}
</script>

<div class="modal fade" id="pop_layer_restore_log" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl" role="document" style="margin-top: 50px;">
		<div class="modal-content" style="height: 700px; ">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="restore.Recovery_history"/> <spring:message code="restore.log"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<div class="form-group row">
							<div class="col-sm-12">
								<textarea class="form-control" id="restoreRmanHistorylog" name="restoreRmanHistorylog" style="height:500px;"></textarea>
								
								<textarea class="form-control" id="restoreDumpHistorylog" name="restoreDumpHistorylog" style="height:500px;" readonly></textarea>
							</div>
						</div>

						<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
							<button type="button" class="btn btn-info btn-icon-text" onClick="fn_addView();"><spring:message code="auth_management.viewMore"/></button>
							<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>