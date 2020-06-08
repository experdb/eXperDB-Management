<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs2.jsp"%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>eXperDB</title>
</head>

<body>
	<div class="container-scroller">
		<div class="container-fluid page-body-wrapper full-page-wrapper">
			<div class="content-wrapper d-flex align-items-center text-center error-page bg-info">
				<div class="row flex-grow">
					<div class="col-lg-7 mx-auto text-white">
						<div class="row align-items-center d-flex flex-row">
							<div class="col-lg-6 text-lg-right pr-lg-4">
								<h1 class="display-1 mb-0">Auth Fail</h1>
							</div>
							<div class="col-lg-6 error-page-divider text-lg-left pl-lg-4">
								<h2><spring:message code="message.msg220" /></h2>
								<br/>
								<h4 class="font-weight-light"><spring:message code="message.msg177" /></h4>
							</div>
						</div>
						<div class="row mt-5">
							<div class="col-12 text-center mt-xl-2">
								<a class="text-white font-weight-medium" href="javascript:void(0);" onclick="history.go(-1)"><spring:message code="common.back"/></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>