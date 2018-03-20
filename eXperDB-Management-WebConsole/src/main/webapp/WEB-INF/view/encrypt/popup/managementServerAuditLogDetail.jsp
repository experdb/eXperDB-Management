<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : managementServerAuditLogDetail.jsp
	* @Description : managementServerAuditLogDetail 화면
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
			<p class="tit">관리서버 상세보기</p>
			<div class="pop_cmm3">
				<p class="pop_s_tit">관리서버 상세보기</p>
				<table class="list" style="border: 1px solid #99abb0;">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 85%;" />
					</colgroup>
					<tbody>
							<tr>
								<td>접근일시</td>
								<td style="text-align: left">${logDateTime}</td>
							</tr>
							<tr>
								<td>접근자</td>
								<td style="text-align: left">${entityName}</td>
							</tr>
							<tr>
								<td>접근주소</td>
								<td style="text-align: left">${remoteAddress}</td>
							</tr>
							<tr>
								<td>접근경로</td>
								<td style="text-align: left">${requestPath}</td>
							</tr>
							<tr>
								<td>본문</td>
								<td style="text-align: left; height: 60px;">${parameter}</td>
							</tr>
							<tr>
								<td>결과코드</td>
								<td style="text-align: left">${resultCode}</td>
							</tr>
							<tr>
								<td>결과메세지</td>
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
	<div id="loading">
		<img src="/images/spin.gif" alt="" />
	</div>
</body>
</html>