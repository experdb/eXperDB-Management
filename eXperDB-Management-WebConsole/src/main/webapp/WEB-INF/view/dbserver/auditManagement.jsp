<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : auditManagement.jsp
	* @Description : Audit 등록/수정 화면
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
<script type="text/javascript">
	var extName = "${extName}";
	var roleTable = null;
	
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//agent 상태확인
		if (!fn_chkExtName(extName)) {
 			$("#btnSave").prop("disabled", "disabled");
			return;	
		}

		//save 버튼 클릭
		$("#btnSave").click(function () { 
			fn_save();
		});
		
		//전체 체크박스 체크
		$("#chkRoleAll").click(function(){
			if ($("input[name=chkRoles]") != null && $("input[name=chkRoles]").length > 0) {
				if($("input:checkbox[name=chkRoleAll]").is(":checked") == true) {
					$("input[name=chkRoles]:checkbox").prop("checked", true);
				} else {
					$("input[name=chkRoles]:checkbox").prop("checked", false);
				}
			}
		});
	});
	
	/* ********************************************************
	 * agent 연결상태 체크
	 ******************************************************** */
	function fn_chkExtName(extName) {
		var title = '<spring:message code="menu.audit_settings"/>' + ' ' + '<spring:message code="access_control_management.msg6" />';
 		if(extName == "") {
			showDangerToast('top-right', '<spring:message code="message.msg26" />', title);
			return false;
 		} else if(extName == "agent") {
			showDangerToast('top-right', '<spring:message code="message.msg25" />', title);
			return false;
		}else if(extName == "agentfail"){
			showDangerToast('top-right', '<spring:message code="message.msg27" />', title);
			return false;
		}
 		
 		return true;
	}
	
	/* ********************************************************
	 * 적용 진행
	 ******************************************************** */
	function fn_save() {
		//agent 상태확인
		if(extName == "") {
			showSwalIcon('<spring:message code="message.msg26" />', '<spring:message code="common.close" />', '', 'error');
			return;
		} else {
			var formData = $("#auditForm").serialize();
	 
			$.ajax({
				url : "/saveAudit.do",
				dataType : "json",
				type : "post",
				data : formData,
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
					if(result == false) {
						showSwalIcon('<spring:message code="message.msg33" />', '<spring:message code="common.close" />', '', 'error');
					} else {
						showSwalIcon('<spring:message code="message.msg29" />', '<spring:message code="common.close" />', '', 'success');
					}
				}
			});
		}
	}
</script>

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
												<span class="menu-title"><spring:message code="menu.audit_settings"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${serverName}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.audit_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.audit_settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.audit_settings"/></p>
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
	
		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="card my-sm-2" >
						<div class="card-body">						
							<div class="row">
								<div class="col-12" style="margin-bottom:-35px;">
									<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnSave">
										<i class="ti-check btn-icon-prepend "></i><spring:message code="common.apply" />
									</button>
							 	</div>
						 	</div>
						</div>
						
						<form class="form-inline" name="auditForm" id="auditForm" method="post" onsubmit="return false;">
							<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>

							<div class="card-body">		
								<div class="row">
									<div class="col-6">
										<div class="card">
											<div class="card-body">
												<div class="form-group row border-bottom">
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="access_control_management.log_level" />
													</label>
													<div class="col-sm-9">
														<select class="form-control" style="width:200px; margin-right: 1rem;" name="log_level" id="log_level" tabindex=1 >
															<option value="DEBUG"<c:if test="${fn:toUpperCase(audit.log_level) == 'DEBUG'}"> selected</c:if>>DEBUG</option>
															<option value="INFO"<c:if test="${fn:toUpperCase(audit.log_level) == 'INFO'}"> selected</c:if>>INFO</option>
															<option value="NOTICE"<c:if test="${fn:toUpperCase(audit.log_level) == 'NOTICE'}"> selected</c:if>>NOTICE</option>
															<option value="WARNING"<c:if test="${fn:toUpperCase(audit.log_level) == 'WARNING'}"> selected</c:if>>WARNING</option>
															<option value="LOG"<c:if test="${fn:toUpperCase(audit.log_level) == 'LOG'}"> selected</c:if>>LOG</option>
														</select>
													</div>
												</div>
										
												<div class="form-group row border-bottom" style="margin-top:10px;">
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label">
														<i class="item-icon fa fa-dot-circle-o"></i>
														<spring:message code="access_control_management.log_type" />
													</label>
													<div class="col-sm-9">
														<div class="form-group">
															<div class="form-check">
																<label for="chkRead" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkRead" name="chkRead" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'READ')}"> checked="checked"</c:if>>
																	read
																</label>
															</div>
															<div class="form-check">
																<label for="chkWrite" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkWrite" name="chkWrite" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'WRITE')}"> checked="checked"</c:if>>
																	write
																</label>
															</div>
															<div class="form-check">
																<label for="chkFunction" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkFunction" name="chkFunction" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'FUNCTION')}"> checked="checked"</c:if>>
																	function
																</label>
															</div>
														</div>
														
														<div class="form-group">
															<div class="form-check">
																<label for="chkRole" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkRole" name="chkRole" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'ROLE')}"> checked="checked"</c:if>>
																	role
																</label>
															</div>
															<div class="form-check">
																<label for="chkDdl" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkDdl" name="chkDdl" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'DDL')}"> checked="checked"</c:if>>
																	ddl
																</label>
															</div>
															<div class="form-check">
																<label for="chkMisc" class="form-check-label" style="width:130px;">
																	<input type="checkbox" id="chkMisc" name="chkMisc" class="form-check-input" <c:if test="${fn:contains(fn:toUpperCase(audit.log), 'MISC')}"> checked="checked"</c:if>>
																	misc
																</label>
															</div>
														</div>                            
													</div>
												</div>
										
												<div class="form-group row border-bottom" style="margin-top:10px;">
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o" style="padding-right:5px;"></i>
														<spring:message code="access_control_management.log_catalog" />
													</label>
													<div class="col-sm-3">
														<div class="form-group">
															<div class="form-check">
																<label for="chkCatalog" class="form-check-label" style="width:150px;">
																	<input type="checkbox" id="chkCatalog" name="chkCatalog" class="form-check-input" <c:if test="${fn:toLowerCase(audit.log_catalog) == 'on'}"> checked="checked"</c:if>>
																	<spring:message code="access_control_management.activation" />
																</label>
															</div>
														</div>
													</div>
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o" style="padding-right:5px;"></i>
														<spring:message code="access_control_management.log_parameter" />
													</label>
													<div class="col-sm-3">
														<div class="form-group">
															<div class="form-check">
																<label for="chkParameter" class="form-check-label" style="width:150px;">
																	<input type="checkbox" id="chkParameter" name="chkParameter" class="form-check-input" <c:if test="${fn:toLowerCase(audit.log_parameter) == 'on'}"> checked="checked"</c:if>>
																	<spring:message code="access_control_management.activation" />
																</label>
															</div>
														</div>
													</div>
												</div>

												<div class="form-group row border-bottom" style="margin-top:10px;">
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o" style="padding-right:5px;"></i>
														<spring:message code="access_control_management.log_relation" />
													</label>
													<div class="col-sm-3">
														<div class="form-group">
															<div class="form-check">
																<label for="chkRelation" class="form-check-label" style="width:150px;">
																	<input type="checkbox" id="chkRelation" name="chkRelation" class="form-check-input" <c:if test="${fn:toLowerCase(audit.log_relation) == 'on'}"> checked="checked"</c:if>>
																	<spring:message code="access_control_management.activation" />
																</label>
															</div>
														</div>
													</div>
													<label for="ins_db_svr_nm" class="col-sm-3 col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o" style="padding-right:5px;"></i> <spring:message code="access_control_management.log_statement" />
													</label>
													<div class="col-sm-3">
														<div class="form-group">
															<div class="form-check">
																<label for="chkStatement" class="form-check-label" style="width:150px;">
																	<input type="checkbox" id="chkStatement" name="chkStatement" class="form-check-input" <c:if test="${fn:toLowerCase(audit.log_statement_once) == 'on'}"> checked="checked"</c:if>>
																	<spring:message code="access_control_management.activation" />
																</label>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="col-6">
										<div class="card">
											<div class="card-body">
												<div class="form-group" style="margin-bottom:-20px;">
													<label for="ins_db_svr_nm" class="col-form-label" style="margin-top:5px;">
														<i class="item-icon fa fa-dot-circle-o" style="padding-right:5px;"></i> Role
													</label>
												</div>

												<div class="table-responsive form-group">
													<table class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
														<thead>
															<tr class="bg-info text-white">
																<th width="11%">
																	<div class="form-check form-check-light_new" style="margin-bottom:-9px;">
																		<label class="form-check-label" for="chkRoleAll">
																			<input type="checkbox" id="chkRoleAll" name="chkRoleAll" class="form-check-input">
												                       	</label>
																	</div>
																</th>
																<th width="11%"><spring:message code="common.no" /></th>
																<th width="78%"><spring:message code="access_control_management.audit_target_account" /></th>
															</tr>
														</thead>
													</table>

													<div class="table-responsive" style="max-height:400px;">
														<table id="roleList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
			 												<tbody>
																<c:forEach var="role" items="${roleList}" varStatus="status">
																	<c:set var="checkName" value="" />
																	<c:forEach var="roleName" items="${fn:split(audit.log_roles,',')}">
																		<c:if test="${fn:toLowerCase(roleName) == fn:toLowerCase(role.rolname)}" >
																			<c:set var="checkName" value="checked" />
																		</c:if>
																	</c:forEach>
		
																	<tr>
																		<td class="py-1" width="12%">
																			<div class="form-check">
																				<label class="form-check-label" for="ch kRole_${status.count}">
																					<input type="checkbox" id="chkRole_${status.count}" name="chkRoles" ${checkName} value="${role.rolname}" class="form-check-input">
												                            	</label>
																			</div>
																		</td>
																		<td width="12%">
																			${status.count}
																		</td>
																		<td width="76%">
																			${role.rolname}
																		</td>
																	</tr>
																</c:forEach>
															
																<c:if test="${fn:length(roleList) == 0}">
																	<tr>
																		<td class="py-1 text-sm-center" colspan="3" width="100%;" height="20px;">
																			No data available in table
																		</td>
																	</tr>
																</c:if>
															</tbody>
														</table>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>