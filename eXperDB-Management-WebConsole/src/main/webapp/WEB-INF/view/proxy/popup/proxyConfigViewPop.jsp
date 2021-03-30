<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : proxyConfigViewPop.jsp
	* @Description : 프록시 configuration 확인 화면
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
// 	var pry_svr_id = "${pry_svr_id}";
// 	var type = "${type}";
	$(window).ready(function(){
// 		config 파일 불러오기
// 		console.log('pry_svr_id : ' + pry_svr_id);
// 		console.log('type : ' + type);
// 		fn_configViewAjax();	
	});

	/* *******************************************************
 	* config 파일 불러오기
 	******************************************************** */
	function fn_configViewAjax(pry_svr_id, type) {
		// var pry_svr_id = $("pry_svr_id", "configForm").val();
		// var type = $("type", "configForm").val();
		console.log('pry_svr_id : ' + pry_svr_id);
		console.log('type : ' + type);
		$.ajax({
			url : "/proxyMonitoring/configViewAjax.do",
			dataType : "json",
			type : "post",
 			data : {
 				pry_svr_id : pry_svr_id,
				type : type
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
				if (result != null) {
					// var v_fileSize = Number($("#fSize", "#configForm").val());
					
					if (result.data != null) {
						$("#config", "#configForm").html(result.data);
						
						// v_fileSize = Number(v_fileSize) + result.fSize;
					}
					if(result.config_title != null) {
							$(".config_title").html(' '+result.config_title);
						
					}

					// $("#fSize", "#configForm").val(v_fileSize);
					
					// $("#seek", "#configForm").val(result.seek);
					// $("#endFlag", "#configForm").val(result.endFlag);
					// $("#dwLen", "#configForm").val(result.dwLen);
					
					// v_fileSize = byteConvertor(v_fileSize);
					
					// $("#view_file_size", "#configForm").html(v_fileSize);
				}
			}
		});
	}
 	
 	
	/* ********************************************************
	 * 창닫기
	 ******************************************************** */
	function fn_proxyConfigViewPopcl() {
		var contentsGbn_chk = $("#contents_gbn", "#configForm").val();
		$('#config').scrollTop(0);
		$("#pop_layer_config_view").modal("hide");
		
		if (contentsGbn_chk != null && contentsGbn_chk != "") {
			$("#"+ contentsGbn_chk).modal("show");
		}
	}
</script>

<div class="modal fade config-modal" id="pop_layer_config_view" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info config_title" id="ModalLabel" style="padding-left:5px;">
<!-- 					Proxy Configuration -->
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" id="configForm">
							<input type="hidden" name="contents_gbn" id="contents_gbn" value="" />
							<input type="hidden" name="pry_svr_id" id="pry_svr_id" value="${pry_svr_id}" />
							<input type="hidden" name="type" id="type" value="${type}" />
							<fieldset>
								<div class="form-group row">
									<div class="col-sm-12">
										<textarea class="form-control" id="config" name="config" style="height: 400px;" readonly></textarea>
<%-- 										<textarea class="form-control" id="config" name="config" style="height: 400px;" readonly>${data}</textarea> --%>
									</div>
								</div>

								<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
									<button type="button" class="btn btn-light" data-dismiss="modal" onclick="fn_proxyConfigViewPopcl();"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
