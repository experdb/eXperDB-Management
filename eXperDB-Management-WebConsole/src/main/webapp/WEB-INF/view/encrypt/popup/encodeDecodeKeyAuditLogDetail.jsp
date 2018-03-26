<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : encodeDecodeKeyAuditLogDetail.jsp
	* @Description : encodeDecodeKeyAuditLogDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.03.19     최초 생성
	*
	* author 김주영 사원
	* since 2018.03.19
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>암호화 키 상세보기</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>
</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="encrypt_log_key.Encryption_Key_Detail"/></p>
			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="encrypt_log_key.Encryption_Key_Detail"/></p>
				<table class="list" style="border: 1px solid #99abb0;">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 85%;" />
					</colgroup>
					<tbody>
							<tr>
								<td><spring:message code="encrypt_log_key.Access_Date"/></td>
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
</html>