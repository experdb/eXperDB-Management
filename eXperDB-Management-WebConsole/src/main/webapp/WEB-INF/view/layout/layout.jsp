<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>eXperDB-Management</title>
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/ti-icons/css/themify-icons.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/css/vendor.bundle.base.css">
<!-- endinject -->
<!-- plugin css for this page -->
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/datatables.net-bs4/dataTables.bootstrap4.css">
<!-- End plugin css for this page -->
<!-- inject:css -->
<link rel="stylesheet" href="/vertical-dark-sidebar/css/style.css">
<!-- endinject -->
<link rel="shortcut icon" href="../../../../images/favicon.png" />
<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
</head>

<body class="sidebar-dark">
	 <div class="container-scroller">
			<tiles:insertAttribute name="topMenu" />
			<div class="container-fluid page-body-wrapper">
				<tiles:insertAttribute name="treeMenu" />
				<div class="main-panel">
				<tiles:insertAttribute name="contents" />
				<!-- partial:partials/_footer.html -->
		        <footer class="footer">
		          <div class="d-sm-flex justify-content-center justify-content-sm-between">
		            <span class="text-muted text-center text-sm-left d-block d-sm-inline-block">Copyright © 2020 <a href="https://www.bootstrapdash.com/" target="_blank">INZENT</a>. All rights reserved.</span>
		            <span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center">Hand-crafted & made with <i class="ti-heart text-danger ml-1"></i></span>
		          </div>
		        </footer>
		        <!-- partial -->
		        </div>
			</div>
	</div>
</body>

<!-- plugins:js -->
<script src="/vertical-dark-sidebar/js/vendors/js/vendor.bundle.base.js"></script>
<!-- endinject -->
<!-- Plugin js for this page-->
<script src="/vertical-dark-sidebar/js/vendors/datatables.net/jquery.dataTables.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/datatables.net-bs4/dataTables.bootstrap4.js"></script>
<!-- End plugin js for this page-->
<!-- inject:js -->
<script src="/vertical-dark-sidebar/js/off-canvas.js"></script>
<script src="/vertical-dark-sidebar/js/hoverable-collapse.js"></script>
<script src="/vertical-dark-sidebar/js/template.js"></script>
<script src="/vertical-dark-sidebar/js/settings.js"></script>
<script src="/vertical-dark-sidebar/js/todolist.js"></script>
<!-- endinject -->
<!-- Custom js for this page-->
<script src="/vertical-dark-sidebar/js/data-table.js"></script>
<!-- End custom js for this page-->
</html>