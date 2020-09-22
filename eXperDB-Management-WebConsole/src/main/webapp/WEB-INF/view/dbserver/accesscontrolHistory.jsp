<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : accesscontrolHistory.jsp
	* @Description : accesscontrolHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.09.18     최초 생성
	*
	* author 김주영 사원
	* since 2017.09.18
	*
	*/
%>
<script type="text/javascript">
	var table = null;
	var confile_title = "";

	/* ********************************************************
	 * setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_init();

		//조회
		if (nvlPrmSet($("#lst_mdf_dtm").val(), "") != "") {
			fn_select("init");
			
	 		if ($(".selectSearch").length) {
				$(".selectSearch").select2();
			}
		} else {
 			$("#btnSearch").prop("disabled", "disabled");
			$("#btnInsert").prop("disabled", "disabled");

			showDangerToast('top-right', '<spring:message code="access_control_management.msg4" />', '<spring:message code="access_control_management.msg5" />');
		}
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_init(){
		table = $('#accesscontrolHistoryTable').DataTable({
			scrollY : "400px",
			paging: false,
			searching : false,
			scrollX: true,
			bSort: false,
			columns : [
					{ data : "rownum", className : "dt-center", defaultContent : ""}, 
					{ data : "ctf_tp_nm", defaultContent : ""}, 
					{ data : "dtb",
							render : function(data, type, full, meta) {	 	
								var html = '';					

			    				if (nvlPrmSet(full.dtb, "") == "all") {
		 	    					html += "<div class='badge badge-pill badge-success'>";
		 	    					html += "	<i class='mdi mdi-check-all mr-2'></i>";
		 	    					html += full.dtb;
		 	    					html += "</div>";
		 	    				} else {
		 	    					html += '<span title="'+full.dtb+'">' + full.dtb + '</span>';
		 	    				}
								
								return html;
							},
						defaultContent : ""
					}, 
					{ data : "prms_usr_id",
							render : function(data, type, full, meta) {	 	
								var html = '';					

			    				if (nvlPrmSet(full.prms_usr_id, "") == "all") {
		 	    					html += "<div class='badge badge-pill badge-success'>";
		 	    					html += "	<i class='mdi mdi-check-all mr-2'></i>";
		 	    					html += full.prms_usr_id;
		 	    					html += "</div>";
		 	    				} else {
		 	 						html += '<span title="'+full.prms_usr_id+'">' + full.prms_usr_id + '</span>';
		 	    				}
								
								return html;
							},
						defaultContent : ""
					},
					{ data : "prms_ipadr", defaultContent : ""},
					{ data : "prms_ipmaskadr", defaultContent : ""}, 
					{ data : "ctf_mth_nm", defaultContent : ""}, 
					{ data : "opt_nm", defaultContent : ""}, 
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '90px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 조회버튼 클릭
	 ******************************************************** */
	function fn_select(gbn){
		if (gbn != "init") {
			if($("#lst_mdf_dtm").val()==null){
				showSwalIcon('<spring:message code="access_control_management.msg4" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}
		}

		$.ajax({
				url : "/selectAccessControlHistory.do",
				data : {
						svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
				},
				dataType : "json",
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
				success : function(result) {
					$("#accesscontrolHistory").show();
					$("#lst_date").html(result[0].lst_mdf_dtm);
					$("#lst_id").html(result[0].lst_mdfr_id);
		
					table.clear().draw();

					if (nvlPrmSet(result, '') != '') {
						table.rows.add(result).draw();
					}
				}
			});
	}

	/* ********************************************************
	 * 복원버튼 클릭
	 ******************************************************** */
	function fn_recovery_confirm() {
		if($("#lst_mdf_dtm").val()==null){
			showSwalIcon('<spring:message code="message.msg30" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		confile_title = '<spring:message code="menu.policy_changes_history" />' + " " + '<spring:message code="common.restore" />' + " " + '<spring:message code="common.request" />';

		$('#con_multi_gbn', '#findConfirmMulti').val("restore");
		
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg138" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "restore") {
			fn_recovery();
		}
	}

	/* ********************************************************
	 * 복원실행
	 ******************************************************** */
	function fn_recovery(){
		$.ajax({
			url : "/recoveryAccessControlHistory.do",
			data : {
				db_svr_id : "${db_svr_id}",
				svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
			},
			dataType : "json",
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
			success : function(result) {			
				if (result=="true") {
					showSwalIconRst('<spring:message code="message.msg31" />', '<spring:message code="common.close" />', '', 'success', "reload");
				}else if(result=="adminpack"){
					showSwalIcon('<spring:message code="message.msg215" />', '<spring:message code="common.close" />', '', 'error');
				}else if(result=="agent"){
					showSwalIcon('<spring:message code="message.msg25" />', '<spring:message code="common.close" />', '', 'error');
				}else if(extName == "agentfail"){
					showSwalIcon('<spring:message code="message.msg27" />', '<spring:message code="common.close" />', '', 'error');
				}else {
					showSwalIcon('<spring:message code="message.msg32" />', '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}
</script>

<%@include file="./../popup/confirmMultiForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
</form>

<div class="content-wrapper main_scroll"  style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">

					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-history"></i>
												<span class="menu-title"><spring:message code="menu.policy_changes_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.access_control_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.policy_changes_history"/></li>
										</ol>
									</div>
								</div>
							</div>

							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.policy_changes_history"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body">
							<form class="form-inline row" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2 ">
									<select class="form-control selectSearch w-100" style="width:200px; margin-right: 2rem;" name="lst_mdf_dtm" id="lst_mdf_dtm" title="수정일자" onchange="fn_select();" >
										<c:forEach var="result" items="${lst_mdf_dtm}">
											<option value="${result.svr_acs_cntr_his_id}">${result.lst_mdf_dtm}</option>
										</c:forEach>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body">						
							<div class="row">
								<div class="col-7" style="margin-bottom:-35px;">
									<div class="form-group row" id="accesscontrolHistory" style="margin-bottom:-135px;display:none;">
										<p class="card-description col-sm-2 " style="padding-top:20px;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="common.modify_datetime" />
										</p>
										<p class="card-description col-sm-4 " style="padding-top:20px;" id="lst_date"></p>
										<p class="card-description col-sm-2 " style="padding-top:20px;">
											<i class="item-icon fa fa-dot-circle-o"></i>
											<spring:message code="common.modifier"/>
										</p>
										<p class="card-description col-sm-4" style="padding-top:20px;" id="lst_id"></p>
									</div>
							 	</div>
								<div class="col-5" style="margin-bottom:-35px;">
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_recovery_confirm();">
										<i class="mdi mdi-backup-restore btn-icon-prepend "></i><spring:message code="common.restore" />
									</button>
							 	</div>
						 	</div>
						</div>
					
						<div class="card-body" >						
							<div class="row">
								<div class="col-12">
	 								<table id="accesscontrolHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="20"><spring:message code="common.no" /></th>
												<th width="40"><spring:message code="access_control_management.type" /></th>
												<th width="100"><spring:message code="access_control_management.database" /></th>
												<th width="100"><spring:message code="access_control_management.user" /></th>
												<th width="100"><spring:message code="access_control_management.ip_address" /></th>
												<th width="100"><spring:message code="access_control_management.ip_mask" /></th>
												<th width="80"><spring:message code="access_control_management.method" /></th>
												<th width="90"><spring:message code="access_control_management.option" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>