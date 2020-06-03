<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs2.jsp"%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Required meta tags -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>eXperDB-Management</title>

<!-- endinject -->
</head>

<body class="sidebar-dark">
	<form name="treeView" id="treeView">
	</form>

	<div class="container-scroller" id="wrap">
		<tiles:insertAttribute name="topMenu" />
		
		<!-- container -->
		<div class="container-fluid page-body-wrapper">
			<!-- <div style="overflow-y:auto;position: fixed;line-height:0;max-height: calc(100vh - 70px);width:256px;float:left;"> -->
<!-- 			<div style="overflow-y:auto;line-height:0;max-height: calc(100vh - 70px);width:260px;float:left;"> -->
			<tiles:insertAttribute name="treeMenu" />
<!-- 			</div> -->
			
 			<div class="main-panel" style="float:left;">
 				<tiles:insertAttribute name="contents" />
				<tiles:insertAttribute name="footer" />
			</div>

		</div>
	</div>
</body>
</html>