<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : auditLogView.jsp
	* @Description : Audit 로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
	*
	*/
%>
<script>
	/* ********************************************************
	 * view 실행
	 ******************************************************** */
	function fn_addView() {
		var v_db_svr_id = $("#db_svr_id", "#findList").val();
		var v_seek = $("#seek", "#auditViewForm").val();
		var v_file_name = $("#info_file_name", "#auditViewForm").val();
		var v_endFlag = $("#endFlag", "#auditViewForm").val();
		var v_dwLen = $("#dwLen", "#auditViewForm").val();
		var v_log_line = $("#log_line", "#auditViewForm").val();

		if(v_endFlag > 0) {
			showSwalIcon('<spring:message code="message.msg66" />', '<spring:message code="common.close" />', '', 'warning');
			$("#endFlag").val("0");
			return;
		}
		
		$.ajax({
			url : "/audit/auditLogViewAjax.do",
			dataType : "json",
			type : "post",
 			data : {
 				db_svr_id : v_db_svr_id,
 				seek : v_seek,
 				file_name : v_file_name,
 				dwLen : v_dwLen,
 				readLine : v_log_line
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
					var v_fileSize = Number($("#fSize", "#auditViewForm").val());
					
					if (result.data != null) {
						$("#auditlog", "#auditViewForm").append(result.data);
						
						v_fileSize = Number(v_fileSize) + result.fSize;
					}

					$("#fSize", "#auditViewForm").val(v_fileSize);
					
					$("#seek", "#auditViewForm").val(result.seek);
					$("#endFlag", "#auditViewForm").val(result.endFlag);
					$("#dwLen", "#auditViewForm").val(result.dwLen);
					
					v_fileSize = byteConvertor(v_fileSize);
					
					$("#view_file_size", "#auditViewForm").html(v_fileSize);
				}
			}
		});
	}

	/* ********************************************************
	 * byte 설정
	 ******************************************************** */
	function byteConvertor(bytes) {
		bytes = parseInt(bytes);
		var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(bytes)/Math.log(1024));

		if(e == "-Infinity") return "0 "+s[0]; 
		else return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
	}
</script>

<div class="modal fade" id="pop_layer_audit_info" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 20px 250px;">
		<div class="modal-content" style="width:1200px;">		 
			<div class="modal-body" style="margin-bottom:-10px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="auth_management.auditHistoryView"/>
				</h4>
				
				<form class="cmxform" id="auditViewForm" name="auditViewForm" >
					<input type="hidden" id="seek" name="seek" value="0">
					<input type="hidden" id="info_file_name" name="info_file_name" value="">
					<input type="hidden" id="endFlag" name="endFlag" value="0">
					<input type="hidden" id="dwLen" name="dwLen" value="0">
					<input type="hidden" id="fSize" name="fSize">
				
					<fieldset>
						<div class="card" style="margin-top:10px;border:0px;margin-bottom:-40px;">
							<div class="card-body">
								<div class="form-group row">
									<div class="col-sm-2">
										<select class="form-control form-control-xsm" name="log_line" id="log_line" tabindex=1 >
											<option value="500">500 Line</option>
											<option value="1000" selected>1000 Line</option>
											<option value="3000">3000 Line</option>
											<option value="5000">5000 Line</option>
										</select>
									</div>
									<div class="col-sm-10">
										<input class="btn btn-inverse-info btn-sm btn-icon-text mdi mdi-lan-connect" type="button" onClick="fn_addView();" value='<spring:message code="auth_management.viewMore" />' />
									</div>
								</div>

								<div class="form-group" style="border:none;" >
									<table id="mod_connector_tableList" class="table system-tlb-scroll" style="width:100%;">
										<tbody>
											<tr>
												<td width="100%" colspan="5">
											 		<div class="overflow_area3" id="auditlog" style="width:1065px;">
													</div>
												</td>
											</tr>
											<tr>
												<td class="py-1" style="width:10%;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													<spring:message code="access_control_management.log_file_name" /> : &nbsp;&nbsp;
												</td>
												<td id="view_file_name" style="width:30%;">
												</td>
												<td style="width:10%;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													size : 
												</td>
												<td style="width:30%;" id="view_file_size">
												</td>
												<td style="width:20%;">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</fieldset>
				</form>
			</div>

			<div class="top-modal-footer" style="text-align: center !important;" >
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>