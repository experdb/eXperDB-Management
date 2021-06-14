<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : proxyLogView.jsp
	* @Description : Proxy 로그 화면 popup
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
		var v_seek = $("#seek", "#proxyViewForm").val();
		var v_file_name = $("#info_file_name", "#proxyViewForm").val();
		var v_endFlag = $("#endFlag", "#proxyViewForm").val();
		var v_dwLen = $("#dwLen", "#proxyViewForm").val();
		var v_log_line = $("#log_line", "#proxyViewForm").val();
		var v_pry_svr_id = $("#pry_svr_id", "#proxyViewForm").val();
		var v_type = $("#type", "#proxyViewForm").val();
		var v_date = $("#date", "#proxyViewForm").val();
		var v_todayYN = $("#todayYN", "#proxyViewForm").val();
		var v_aut_id = $("#aut_id", "#proxyViewForm").val();
		var v_kal_install_yn = $("#kal_install_yn", "#proxyViewForm").val();
		
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
			url : "/proxyMonitoring/proxyLogViewAjax.do",
			dataType : "json",
			type : "post",
 			data : {
 				pry_svr_id : v_pry_svr_id,
 				type : v_type,
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
					var v_fileSize = Number($("#fSize", "#proxyViewForm").val());
					
					if (result.data != null) {
						$("#proxylog", "#proxyViewForm").html(result.data);
						
						v_fileSize = result.fSize;
					}

					$("#fSize", "#proxyViewForm").val(v_fileSize);
					
					$("#dwLen", "#proxyViewForm").val(result.dwLen);
					$("#view_file_name", "#proxyViewForm").html(result.file_name);
					$("#date", "#proxyViewForm").val(v_date);
					$("#status", "#proxyViewForm").val(result.status);
					if(type == 'KEEPALIVED') {
						$('#log_cng').val("Proxy Log");
					} else {
						$('#log_cng').val("Keep Log");
					}
					
					v_fileSize = byteConvertor(v_fileSize);
					
					$("#view_file_size", "#proxyViewForm").html(v_fileSize);
					
				}

				if(v_aut_id != 1){
					$('#start_btn').hide();
					$('#stop_btn').hide();
					$('#download_btn').hide();
				} else {
					if($("#status", "#proxyViewForm").val() == 'TC001502'){
						$('#start_btn').show();
						$('#stop_btn').hide();
					} else {
						$('#stop_btn').show();
						$('#start_btn').hide();
					}
					$('#download_btn').show();
				}
				
				if(v_kal_install_yn == "N"){
					$('#log_type').hide();
				} else {
					$('#log_type').show();
				}
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
		var s_date = $("#date", "#proxyViewForm").val();
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
    	$("#date", "#proxyViewForm").val($("#wrk_strt_dtm").val());
		$("#dwLen", "#proxyViewForm").val("0");
		$('#proxylog').scrollTop(0);
		fn_logViewAjax();
	}

	/* ********************************************************
	 * 시스템 기동 / 정지
	 ******************************************************** */ 
	function fn_actExeCng(){
		var v_pry_svr_id = $("#pry_svr_id", "#proxyViewForm").val();
		var v_type = $("#type", "#proxyViewForm").val();
		var v_status = $("#status", "#proxyViewForm").val();

		$.ajax({
			url : '/proxyMonitoring/actExeCng.do',
			type : 'post',
			data : {
				pry_svr_id : v_pry_svr_id,
				type : v_type,
				status : v_status,
				act_exe_type : 'TC004001'
			},
			success : function(result) {	
	 			if(result.result){
	 				showSwalIcon(result.errMsg, '<spring:message code="common.close" />', '', 'success');
	 			}else{
	 				showSwalIcon(result.errMsg, '<spring:message code="common.close" />', '', 'error');
		 		}
				rowChkCnt = $("#serverSsChkNum", "#proxyMonViewForm").val();
				fn_getProxyInfo(select_pry_svr_id, rowChkCnt);
				fn_logViewAjax();
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insProxyListenForm").val("0");
					
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
		
		$('#loading').hide();
	}
	
	/* ********************************************************
	 * log download 셋팅
	 ******************************************************** */
	function fn_pry_log_download(){
		var v_type = $("#type", "#proxyViewForm").val();
		
		location.href="/proxyMonitoring/logDownload.do?file_type="+v_type;
	}

	
	/* ********************************************************
	 * log download 셋팅
	 ******************************************************** */
	function fn_pry_log_download_old(){
		location.href="/proxyMonitoring/logDownload.do?file_name="+v_file_name;
	}
	
	
	/* ********************************************************
	 * 기동-정지 확인창
	 ******************************************************** */
	function fn_log_act_confirm_modal(act_status){
		cng_pry_svr_id = $("#pry_svr_id", "#proxyViewForm").val();
		act_sys_type = $("#type", "#proxyViewForm").val();
		type = $("#type", "#proxyViewForm").val();
		agt_cndt_cd = $("#agt_cndt_cd", "#proxyViewForm").val();
		
		if(agt_cndt_cd == "TC001502"){
			if (act_status == "TC001501") {
				if(type == "P") {
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg35"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg36"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				}
			}else if (act_status == "TC001502") {
				if(type == "P"){
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg37"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg38"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				}
			}
		
		} else {
			if (act_status == "TC001501") {
				var gbn = "sys_stop";
			
				if(act_sys_type == "PROXY") {
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg15"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg19"/>'));
				}
			}else if (act_status == "TC001502") {
				var gbn = "sys_start";
			
				if(act_sys_type == "PROXY"){
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg16"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg16"/>'));
				}
			}
		}
		
		$('#con_only_gbn', '#findConfirmOnly').val(gbn);
		$('#confirm_tlt').html(confirm_title);
		$('#pop_confirm_md').modal("show");
	}
	
	/* ********************************************************
	 * confirm 결과에 따른 작업
	 ******************************************************** */
	function fnc_confirmRst(){
		agt_cndt_cd = $("#agt_cndt_cd", "#proxyViewForm").val();
		if(agt_cndt_cd == "T001501"){
			fn_actExeCng();
		}
	}
	
	 
	/* *************************************************w*******
	 * log system change
	 ******************************************************** */
	function fn_sys_type_cng(){
		var langSelect = document.getElementById("log_type");
		var selectValue = langSelect.options[langSelect.selectedIndex].value;
		$("#type", "#proxyViewForm").val(selectValue);
		$("#dwLen", "#proxyViewForm").val("0");
		$('#proxylog').scrollTop(0);
		fn_logViewAjax();
	}
	
	/* ********************************************************
	 * log 팝업 닫기
	 ******************************************************** */
	function fn_proxyLogViewPopcl() {
		var contentsGbn_chk = $("#contents_gbn", "#configForm").val();
		$("#log_line", "#proxyViewForm").val("0");
		$('#proxylog').scrollTop(0);
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
					<spring:message code="eXperDB_proxy.log_view"/>
				</h4>
				</div>
				<div class="col-sm-3">
					
					<button type="button" class="btn btn-outline-success btn-icon-text" id="download_btn" style="margin-left:50px;" onclick="fn_pry_log_download()">
						<i class='ti-download btn-icon-prepend' >
						&nbsp;<spring:message code='migration.download' /></i>
					</button>
				</div>
			</div>
				
				<form class="cmxform" id="proxyViewForm" name="proxyViewForm" >
					<input type="hidden" id="seek" name="seek" value="0">
					<input type="hidden" id="info_file_name" name="info_file_name" value="">
					<input type="hidden" id="endFlag" name="endFlag" value="0">
					<input type="hidden" id="dwLen" name="dwLen" value="0">
					<input type="hidden" id="fSize" name="fSize">
					<input type="hidden" id="type" name="type">
					<input type="hidden" id="pry_svr_id" name="pry_svr_id">
					<input type="hidden" id="date" name="date">
					<input type="hidden" id="aut_id" name="aut_id">
					<input type="hidden" id="todayYN" name="todayYN">
					<input type="hidden" id="status" name="status">
					<input type="hidden" id="agt_cndt_cd" name="agt_cndt_cd">
					<input type="hidden" id="kal_install_yn" name="kal_install_yn">
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
										<input class="btn btn-inverse-info btn-icon-text mdi mdi-lan-connect" id="start_btn" type="button" onClick="fn_log_act_confirm_modal('TC001502')" value="<spring:message code="eXperDB_proxy.act_start"/>" />
										<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" id="stop_btn" type="button" onClick="fn_log_act_confirm_modal('TC001501')" value="<spring:message code="eXperDB_proxy.act_stop"/>" />
									</div>
									<div class="col-sm-2" style="margin-left:-17px;">
										<select class="form-control" name="log_type" id="log_type" tabindex=1 onchange="fn_sys_type_cng()">
											<option value="PROXY">PROXY</option>
											<option value="KEEPALIVED">KEEPALIVED</option>
										</select>
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
											 		<div class="overflow_area3" id="proxylog" style="width:1065px;">
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