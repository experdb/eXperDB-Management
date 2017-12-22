<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<style>
#error {
	float: left;
	position: relative;
	right: 50%;
	margin-top: 50%;
}
</style>
<body class="bg">
	<div id="login_wrap">
		<div class="inr">
			<div id="error">
				<img src="../images/error403.png">
				<div class="btn_wrap">
					<button onclick="history.go(-1)"><spring:message code="common.back"/></button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>