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
<script language="javascript">

	function fnCheckAllRole() {
		var form = document.getElementById("auditForm");
		var chkRoles = document.getElementsByName("chkRoles");
		
		if(document.getElementById("chkRoleAll").checked){
	
			for(i=0; i<form.chkRoles.length; i++) {
				chkRoles[i].checked = true;
			}
	
		} else {
			for(i=0;i<form.chkRoles.length; i++) {
				chkRoles[i].checked = false;
			}
		}
		
	
	}
	
	function fnChkLogActive() {
		var form = document.getElementById("auditForm");
		var chkRole = document.getElementsByName("chkRole");
		
		if(document.getElementById("chkLogActive").checked){

		} else {
			document.getElementById("chkRead").checked = false;
			document.getElementById("chkWrite").checked = false;
			document.getElementById("chkFunction").checked = false;
			document.getElementById("chkRole").checked = false;
			document.getElementById("chkDdl").checked = false;
			document.getElementById("chkMisc").checked = false;
			

		}
	}
	
	$(function() {
		var extName = "${extName}";
		
		fn_chkExtName(extName)
		
		$("#btnSave").click(function () { 
			fn_save();
		});
		
	});
	
	function fn_chkExtName(extName) {
		if(extName == "") {
			alert("서버에 pgaudit Extension 이 설치되지 않았습니다.");
			history.go(-1);
		} else if(extName == "agent") {
			alert("서버에 experdb엔진이 설치되지 않았습니다.");
			history.go(-1);
		}
		
	}
	
	function fn_save() {
 		var extName = "${extName}";
		if(extName == "") {
			alert("서버에 pgaudit Extension 이 설치되지 않았습니다.");
			
			return false;

		} else { 
			
			var formData = $("#auditForm").serialize();
			
			$.ajax({
				url : "/saveAudit.do",
				dataType : "json",
				type : "post",
				data : formData,
				error : function(request, status, error) {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				},
				success : function(result) {
					if(result == false) {
						alert("audit 적용이 실패하였습니다.");
					} else {
						alert("적용하였습니다.");
					}
					
				}
			});
		}
	}
	
</script>

<form name="auditForm" id="auditForm" method="post" onSubmit="return false;">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id }">
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>감사설정<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li>데이터베이스 접근 및 작업에 대한 감사로그를 설정합니다.</li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li class="bold">${serverName}</li>
								<li>접근제어관리</li>
								<li class="on">감사설정</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn btnC_01"><button id="btnSave">적용</button></span>
							</div>
							<div class="sch_form p1">
								<div class="inp_chk chk3">
									<input type="checkbox" id="chkLogActive" name="chkLogActive"<c:if test="${fn:toLowerCase(audit.isActive) == 'on'}"> checked="checked"</c:if>  onClick="javascript:fnChkLogActive();">
									<label for="chkLogActive"><span class="chk_img"><img src="../images/popup/ico_box_1.png" alt="" /></span>감사활성화</label>
								</div>
							</div>
							<div class="layout_grp">
								<div class="layout_lt">
									<table class="log_table">
										<caption>로그수준</caption>
										<colgroup>
											<col style="width:128px" />
											<col />
											<col style="width:128px" />
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row">로그수준</th>
												<td colspan="3">
													<select class="select" name="log_level" id="log_level">
														<option value="DEBUG"<c:if test="${fn:toUpperCase(audit.log_level) == 'DEBUG'}"> selected</c:if>>DEBUG</option>
														<option value="INFO"<c:if test="${fn:toUpperCase(audit.log_level) == 'INFO'}"> selected</c:if>>INFO</option>
														<option value="NOTICE"<c:if test="${fn:toUpperCase(audit.log_level) == 'NOTICE'}"> selected</c:if>>NOTICE</option>
														<option value="WARNING"<c:if test="${fn:toUpperCase(audit.log_level) == 'WARNING'}"> selected</c:if>>WARNING</option>
														<option value="LOG"<c:if test="${fn:toUpperCase(audit.log_level) == 'LOG'}"> selected</c:if>>LOG</option>
													</select>
												</td>
											</tr>
											<tr>
												<th scope="row">로그종류</th>
												<td colspan="3">
													<div class="log_list">
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkRead" name="chkRead"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'READ')}"> checked="checked"</c:if>>
																<label for="chkRead">read</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkWrite" name="chkWrite"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'WRITE')}"> checked="checked"</c:if>>
																<label for="chkWrite">write</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkFunction" name="chkFunction"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'FUNCTION')}"> checked="checked"</c:if>>
																<label for="chkFunction">function</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkRole" name="chkRole"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'ROLE')}"> checked="checked"</c:if>>
																<label for="chkRole">role</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkDdl" name="chkDdl"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'DDL')}"> checked="checked"</c:if>>
																<label for="chkDdl">ddl</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="chkMisc" name="chkMisc"<c:if test="${fn:contains(fn:toUpperCase(audit.log), 'MISC')}"> checked="checked"</c:if>>
																<label for="chkMisc">misc</label>
															</div>
														</span>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row">로그카탈로그</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="chkCatalog" name="chkCatalog"<c:if test="${fn:toLowerCase(audit.log_catalog) == 'on'}"> checked="checked"</c:if>>
														<label for="chkCatalog">활성화</label>
													</div>
												</td>
												<th scope="row" class="double">로그 Parameter</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="chkParameter" name="chkParameter"<c:if test="${fn:toLowerCase(audit.log_parameter) == 'on'}"> checked="checked"</c:if>>
														<label for="chkParameter">활성화</label>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row">로그 Relation</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="chkRelation" name="chkRelation"<c:if test="${fn:toLowerCase(audit.log_relation) == 'on'}"> checked="checked"</c:if>>
														<label for="chkRelation">활성화</label>
													</div>
												</td>
												<th scope="row" class="double">로그 Statement</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="chkStatement" name="chkStatement"<c:if test="${fn:toLowerCase(audit.log_statement_once) == 'on'}"> checked="checked"</c:if>>
														<label for="chkStatement">활성화</label>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="layout_rt">
									<p class="ly_tit">Role</p>
									<div class="overflow_area">
										<table class="list">
											<caption>Role 리스트</caption>
											<colgroup>
												<col style="width:12%;" />
												<col style="width:12%;" />
												<col />
											</colgroup>
											<thead>
												<tr>
													<th scope="col">
														<div class="inp_chk">
															<input type="checkbox" id="chkRoleAll" name="chkRoleAll" onClick="javascript:fnCheckAllRole();"/>
															<label for="chkRoleAll"></label>
														</div>
													</th>
													<th scope="col">NO</th>
													<th scope="col">감사 대상 계정</th>
												</tr>
											</thead>
											<tbody>
											<c:if test="${fn:length(roleList) == 0}">
												<tr>
													<td>
														<div class="inp_chk">
														</div>
													</td>
													<td></td>
													<td></td>
												</tr>
											</c:if>
											<c:forEach var="role" items="${roleList}" varStatus="status">
												<tr>
													<td>
														<div class="inp_chk">
															<input type="checkbox" id="chkRole_${status.count}" name="chkRoles"  value="${role.rolname}" <c:if test="${fn:contains(fn:toLowerCase(audit.log_roles), fn:toLowerCase(role.rolname))}"> checked="checked"</c:if> />
															<label for="chkRole_${status.count}"></label>
														</div>
													</td>
													<td>${status.count}</td>
													<td>${role.rolname}</td>
												</tr>
											</c:forEach>
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