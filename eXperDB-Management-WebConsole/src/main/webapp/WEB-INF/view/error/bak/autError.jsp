<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/common.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>eXperDB</title>
</head>
<script>
</script>
<body class="bg">
	<div id="login_wrap">
		<div class="inr" style="width: 800px; float: center;">
			<div id="error">
				<c:set var="data" value="${pageContext.response.locale}" />
					<c:choose>
				    <c:when test="${data eq 'en'}">
				       <img src="../imag es/en_error403.png">
				    </c:when>
				    <c:otherwise>
				      <img src="../images/error403.png">
				    </c:otherwise>
				</c:choose>
				<div class="btn_wrap">
					<button type="button" onclick="history.go(-1)"><spring:message code="common.back"/></button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>