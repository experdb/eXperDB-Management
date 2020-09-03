<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : myPage.jsp
	* @Description : myPage 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.20
	*
	*/
%>
<script type="text/javascript">
	$(window.document).ready(function() {
		$("#cpn", "#myPageForm").mask("999-9999-9999");

 		$("#myPageForm").validate({
			rules: {
				usr_nm: {
					required: true
				}
			},
			messages: {
				usr_nm: {
					required: '<spring:message code="message.msg58" />'
				}
			},
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_update();
			},
			errorPlacement: function(label, element) {
				label.addClass('mt-2 text-danger');
				label.insertAfter(element);
		    },
		    highlight: function(element, errorClass) {
		        $(element).parent().addClass('has-danger')
		        $(element).addClass('form-control-danger')
		    }
		});
	});


	/* ********************************************************
	 * update 실행
	 ******************************************************** */
	function fn_updateSubmit () {
		$('#myPageForm').submit();

		fn_update();
	}
	

	/* ********************************************************
	 * update 로직실행
	 ******************************************************** */
	function fn_update () {
		$.ajax({
			url : '/updateMypage.do',
			type : 'post',
			data : {
				usr_id : '${usr_id}',
				usr_nm : $("#usr_nm", "#myPageForm").val(),
				bln_nm : $("#bln_nm", "#myPageForm").val(),
				dept_nm : $("#dept_nm", "#myPageForm").val(),
				pst_nm : $("#pst_nm", "#myPageForm").val(),
				cpn : $("#cpn", "#myPageForm").val(),
				rsp_bsn_nm : $("#rsp_bsn_nm", "#myPageForm").val()
			},
			success : function(result) {
				showSwalIcon('<spring:message code="message.msg57" />', '<spring:message code="common.close" />', '', 'success');
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
			}
		});
	}

	/* ********************************************************
	 * 패스워드 변경 클릭
	 ******************************************************** */
	 function fn_pwdPopup() {
	 	$.ajax({
			url : "/popup/pwdRegForm.do",
			data : {
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
				//초기화
				$("#nowpwd", "#pwdChgForm").val("");
				$("#newpwd", "#pwdChgForm").val("");
				$("#pwd", "#pwdChgForm").val("");
				
 				$("#newpw_alert-danger", "#pwdChgForm").html("");
				$("#newpw_alert-danger", "#pwdChgForm").hide();
				$("#newpw_alert-light", "#pwdChgForm").html("");
				$("#newpw_alert-light", "#pwdChgForm").hide();
				$("#pwd_submit", "#pwdChgForm").removeAttr("disabled");
				$("#pwd_submit", "#pwdChgForm").removeAttr("readonly");
				
				$('#pop_layer_pwd_chg').modal("show");
			}
		});
	}
</script>

<%@include file="./../popup/pwdRegForm.jsp"%>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
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
												<i class="ti-user menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.user_information_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
 					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">My PAGE</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.user_information_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.user_information_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.user_information_management"/></p>
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

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">																				
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave" onClick="fn_updateSubmit();">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.save" />
								</button>
							</div>
						</div>
					</div>
				
					<div class="card my-sm-2" >
						<div class="table-responsive system-tlb-scroll" style="overflow:auto;max-height: 540px; ">
							<form class="cmxform" id="myPageForm">
								<fieldset>
									<table class="table table-striped">
										<tbody>
											<tr>
												<th class="py-1" style="width: 20%; padding: 0.875rem 0.9375rem;" >
													<spring:message code="user_management.id" /> <font color="red">*</font>
												</th>
												<td style="width: 80%; padding: 0.875rem 0.9375rem; word-break:break-all;">${usr_id}</td>
											</tr>
											<tr>
												<th class="py-1" style="width: 20%;" >
													<spring:message code="user_management.user_name" /> <font color="red">*</font>
												</th>
												<td style="width: 80%;">
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="usr_nm" name="usr_nm" maxlength="50" placeholder='<spring:message code='message.msg58'/>' onblur="this.value=this.value.trim()" value="${usr_nm}" tabindex=1 />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="user_management.password" /> <font color="red">*</font>
												</th>
												<td>
													<input class="btn btn-inverse-info btn-sm btn-icon-text mdi mdi-lan-connect" style="margin-top:-5px;margin-bottom:-5px;" type="button" onclick="fn_pwdPopup();" value='<spring:message code="user_management.edit_password" />' />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="user_management.company" />
												</th>
												<td>
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="bln_nm" name="bln_nm" maxlength="50" placeholder='<spring:message code='user_management.msg4'/>' onblur="this.value=this.value.trim()" value="${bln_nm}" tabindex=2 />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="history_management.department" />
												</th>
												<td>
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="dept_nm" name="dept_nm" maxlength="50" placeholder='<spring:message code='user_management.msg3'/>' onblur="this.value=this.value.trim()" value="${dept_nm}" tabindex=3 />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="user_management.position" />
												</th>
												<td>
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="pst_nm" name="pst_nm" maxlength="50" placeholder='<spring:message code='user_management.msg2'/>' onblur="this.value=this.value.trim()" value="${pst_nm}" tabindex=4 />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="user_management.mobile_phone_number" />
												</th>
												<td>
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="cpn" name="cpn" placeholder='<spring:message code='user_management.msg12'/>' onblur="this.value=this.value.trim()" value="${cpn}" tabindex=5 />
												</td>
											</tr>
											<tr>
												<th class="py-1" >
													<spring:message code="user_management.Responsibilities" />
												</th>
												<td>
													<input type="text" class="form-control form-control-xsm" style="width:500px;margin-top:-5px;margin-bottom:-5px;" id="rsp_bsn_nm" name="rsp_bsn_nm" maxlength="50" placeholder='<spring:message code='user_management.msg1'/>' onblur="this.value=this.value.trim()" value="${rsp_bsn_nm}" tabindex=6 />
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="user_management.use_yn" />
												</th>
												<td style="word-break:break-all;margin-top:-5px;margin-bottom:-5px;">
													<c:choose>
														<c:when test="${use_yn eq 'Y'}">
															<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>
																<i class='fa fa-spin fa-spinner mr-2'></i>
																<spring:message code='dbms_information.use' />
															</div>
														</c:when>
														<c:otherwise>
															<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>
																<i class='fa fa-times-circle mr-2'></i>
																<spring:message code='dbms_information.unuse' />
															</div>
														</c:otherwise>
													</c:choose>										
												</td>
											</tr>
											<tr>
												<th class="py-1">
													<spring:message code="encrypt_log_decode.Encryption"/> <spring:message code="user_management.use_yn" />
												</th>
												<td style="word-break:break-all;">
													<c:choose>
														<c:when test="${encp_use_yn eq 'Y'}">
															<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>
																<i class='fa fa-spin fa-spinner mr-2'></i>
																<spring:message code='dbms_information.use' />
															</div>
														</c:when>
														<c:otherwise>
															<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>
																<i class='fa fa-times-circle mr-2'></i>
																<spring:message code='dbms_information.unuse' />
															</div>
														</c:otherwise>
													</c:choose>
												</td>
											</tr>
											<tr>
												<th class="py-1" style='padding: 0.875rem 0.9375rem;'>
													<spring:message code="user_management.expiration_date" />
												</th>
												<td style="word-break:break-all;padding: 0.875rem 0.9375rem;">
													<fmt:parseDate value="${usr_expr_dt}" var="usrExprFmt" pattern="yyyyMMdd"/>
													<fmt:formatDate value="${usrExprFmt}" pattern="yyyy-MM-dd"/>
												</td>
											</tr>
										</tbody>
									</table>
								</fieldset>
							</form>
				 		</div>

						<!-- content-wrapper ends -->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>