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
				<img src="../images/error500.png">
				<div class="btn_wrap">
					<button onclick="history.go(-1)">뒤로가기</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>