<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	/**
	* @Class Name : managementServerAuditLogDetail.jsp
	* @Description : managementServerAuditLogDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.07.24    변승우 과장		UI 변경
	*
	* author 김주영 사원
	* since 2018.03.19
	*
	*/
%>


<div class="modal fade" id="pop_managementServerAuditLogDetail" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" >
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="encrypt_log_sever.Management_Server_Detail"/> 
				</h4>
	
				<div class="card-body">
					<h4 class="card-title"> <spring:message code="encrypt_log_sever.Management_Server_Detail"/> </h4>
						<div class="d-flex align-items-center pb-3 border-bottom">
						
						</div>	
				</div>
			</div>
					
			<div class="top-modal-footer" style="text-align: center !important;" >
					<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
			
		</div>
	</div>
</div>












<%-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리서버 상세보기</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>
</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="encrypt_log_sever.Management_Server_Detail"/> </p>
			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="encrypt_log_sever.Management_Server_Detail"/> </p>
				<table class="list" style="border: 1px solid #99abb0;">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 85%;" />
					</colgroup>
					<tbody>
							<tr>
								<td><spring:message code="encrypt_log_key.Access_Date"/> </td>
								<td style="text-align: left">${logDateTime}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Access_User"/></td>
								<td style="text-align: left">${entityName}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Access_Address"/></td>
								<td style="text-align: left">${remoteAddress}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Access_Path"/></td>
								<td style="text-align: left">${requestPath}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Main_Text"/></td>
								<td style="text-align: left; height: 60px;">${parameter}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Result_Code"/></td>
								<td style="text-align: left">${resultCode}</td>
							</tr>
							<tr>
								<td><spring:message code="encrypt_log_key.Result_Message"/></td>
								<td style="text-align: left">${resultMessage}</td>
							</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close" /></span></a>
			</div>
		</div>
	</div>
</body>
</html> --%>