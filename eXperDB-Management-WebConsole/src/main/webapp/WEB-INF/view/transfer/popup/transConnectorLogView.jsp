<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : transConnectorLogView.jsp
	* @Description : trans connector 로그 화면 popup
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*
	*/
%>
<script>
	
	/* ********************************************************
	 * view 실행
	 ******************************************************** */
	function fn_logViewAjax() {
		var v_seek = $("#seek", "#connectorViewForm").val();
		var v_file_name = $("#info_file_name", "#connectorViewForm").val();
		var v_endFlag = $("#endFlag", "#connectorViewForm").val();
		var v_dwLen = $("#dwLen", "#connectorViewForm").val();
		var v_log_line = $("#log_line", "#connectorViewForm").val();
		var v_trans_id = $("#trans_id", "#connectorViewForm").val();
		var v_db_svr_id = $("#db_svr_id", "#connectorViewForm").val();
		var v_type = $("#type", "#connectorViewForm").val();
		var v_date = $("#date", "#connectorViewForm").val();
		var v_todayYN = $("#todayYN", "#connectorViewForm").val();
// 		var v_aut_id = $("#aut_id", "#connectorViewForm").val();
		
		if(v_endFlag > 0) {
			showSwalIcon('<spring:message code="message.msg66" />', '<spring:message code="common.close" />', '', 'warning');
			$("#endFlag").val("0");
			return;
		}
		if(v_date.slice(0,10) == new Date().toJSON().slice(0,10)){
			v_todayYN = 'Y';
		} else {
			v_todayYN = 'N';
		}
		$.ajax({
			url : "/transConnectorLogViewAjax",
			dataType : "json",
			type : "post",
 			data : {
 				db_svr_id : v_db_svr_id,
 				trans_id : v_trans_id,
 				date : v_date,
				seek : v_seek,
 				dwLen : v_dwLen,
 				readLine : v_log_line,
 				todayYN : v_todayYN
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
					var v_fileSize = Number($("#fSize", "#connectorViewForm").val());
					
					if (result.data != null) {
						$("#connectorlog", "#connectorViewForm").html(result.data);
						
						v_fileSize = result.fSize;
					}

					$("#fSize", "#connectorViewForm").val(v_fileSize);
					
					$("#dwLen", "#connectorViewForm").val(result.dwLen);
					$("#view_file_name", "#connectorViewForm").html(result.file_name);
					$("#date", "#connectorViewForm").val(v_date);
					$("#status", "#connectorViewForm").val(result.status);
					
					v_fileSize = byteConvertor(v_fileSize);
					
					$("#view_file_size", "#connectorViewForm").html(v_fileSize);
					
				}

// 				if(v_aut_id != 1){
// 					$('#start_btn').hide();
// 					$('#stop_btn').hide();
// 					$('#download_btn').hide();
// 				} else {
// 					if($("#status", "#connectorViewForm").val() == 'TC001502'){
// 						$('#start_btn').show();
// 						$('#stop_btn').hide();
// 					} else {
// 						$('#stop_btn').show();
// 						$('#start_btn').hide();
// 					}
// 					$('#download_btn').hide();
// 				}
			}
		});
		$('#loading').hide();
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
	
	/* ********************************************************
	 * log calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var s_date = $("#date", "#connectorViewForm").val();
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate() - 1);
		var day_start = today.toJSON().slice(0,10);
		var sys_date = s_date.slice(0,10);
		$("#wrk_strt_dtm").val(sys_date);

		if ($("#wrk_strt_dtm_div").length) {
			$('#wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', sys_date)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    });
		}
		
		$("#wrk_strt_dtm").datepicker('setDate', sys_date);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	}
	
	/* ********************************************************
	 * 날짜 변경
	 ******************************************************** */ 
	function fn_date_cng(){
    	$("#date", "#connectorViewForm").val($("#wrk_strt_dtm").val());
		$("#dwLen", "#connectorViewForm").val("0");
		$('#connectorlog').scrollTop(0);
		fn_logViewAjax();
	}

	
	/* ********************************************************
	 * log 팝업 닫기
	 ******************************************************** */
	function fn_connectorLogViewPopcl() {
		var contentsGbn_chk = $("#contents_gbn", "#configForm").val();
		$("#log_line", "#connectorViewForm").val("0");
		$('#connectorlog').scrollTop(0);
		$("#pop_layer_log_view").modal("hide");
		if (contentsGbn_chk != null && contentsGbn_chk != "") {
			$("#"+ contentsGbn_chk).modal("show");
		}
	}
	
	
</script>

<div class="modal fade" id="pop_layer_log_view" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 20px 250px;">
		<div class="modal-content" style="width:1200px;">		 
			<div class="modal-body" style="margin-bottom:-10px;">
			<div class="row">
				<div class="col-sm-9">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					커넥터 로그 보기
				</h4>
				</div>
<!-- 				<div class="col-sm-3"> -->
					
<!-- 					<button type="button" class="btn btn-outline-success btn-icon-text" id="download_btn" style="margin-left:50px;" onclick="fn_pry_log_download()"> -->
<!-- 						<i class='ti-download btn-icon-prepend' > -->
<%-- 						&nbsp;<spring:message code='migration.download' /></i> --%>
<!-- 					</button> -->
<!-- 				</div> -->
			</div>
				
				<form class="cmxform" id="connectorViewForm" name="connectorViewForm" >
					<input type="hidden" id="db_svr_id" name="db_svr_id" value="${db_svr_id}">
					<input type="hidden" id="seek" name="seek" value="0">
					<input type="hidden" id="info_file_name" name="info_file_name" value="">
					<input type="hidden" id="endFlag" name="endFlag" value="0">
					<input type="hidden" id="dwLen" name="dwLen" value="0">
					<input type="hidden" id="fSize" name="fSize">
<!-- 					<input type="hidden" id="type" name="type"> -->
					<input type="hidden" id="date" name="date">
					<input type="hidden" id="aut_id" name="aut_id">
					<input type="hidden" id="todayYN" name="todayYN">
					<input type="hidden" id="status" name="status">
					<input type="hidden" id="agt_cndt_cd" name="agt_cndt_cd">
					<fieldset>
						<div class="card" style="margin-top:10px;border:0px;margin-bottom:-40px;">
							<div class="card-body">
								<div class="form-group row">
									<div class="col-sm-2">
										<select class="form-control" name="log_line" id="log_line" tabindex=1 >
											<option value="500">500 Line</option>
											<option value="1000" selected>1000 Line</option>
											<option value="3000">3000 Line</option>
											<option value="5000">5000 Line</option>
										</select>
									</div>
									<div class="col-sm-6">
										<input class="btn btn-inverse-info btn-icon-text mdi mdi-lan-connect" type="button" onClick="fn_logViewAjax();" value='<spring:message code="auth_management.viewMore" />' />
										<input class="btn btn-inverse-info btn-icon-text mdi mdi-lan-connect" id="start_btn" type="button" onClick="fn_log_act_confirm_modal('TC001502')" value="중지" />
										<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" id="stop_btn" type="button" onClick="fn_log_act_confirm_modal('TC001501')" value="기동" />
									</div>
									<div class="col-sm-2" style="margin-left:-17px;">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px; height:44px;" id="wrk_strt_dtm" name="wrk_strt_dtm" onchange="fn_date_cng()" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div>
								</div>

								<div class="form-group" style="border:none;" >
									<table id="mod_connector_tableList" class="table-borderless system-tlb-scroll" style="width:100%;">
										<tbody>
											<tr>
												<td width="100%" colspan="5">
											 		<div class="overflow_area3" id="connectorlog" style="width:1065px;">
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
												<td style="width:6%;">
													<i class="item-icon fa fa-dot-circle-o"></i>
													size : 
												</td>
												<td style="width:30%;" id="view_file_size">
												</td>
												<td style="width:10%;">
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