<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@include file="./commonLocale.jsp"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB for Management</title>
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/ti-icons/css/themify-icons.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/css/vendor.bundle.base.css">
<link rel="stylesheet" type="text/css" media="screen" href="/css/dt/jquery.dataTables.min.css"/>

<!-- endinject -->
<!-- plugin css for this page -->
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/datatables.net-bs4/dataTables.bootstrap4.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/jquery-toast-plugin/jquery.toast.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/font-awesome/css/font-awesome.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/mdi/css/materialdesignicons.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/jquery-bar-rating/css-stars.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/bootstrap-datepicker/bootstrap-datepicker.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/tempusdominus-bootstrap-4/tempusdominus-bootstrap-4.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/x-editable/bootstrap-editable.css">  
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/bootstrap4-toggle/bootstrap4-toggle.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/select2/select2.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/select2-bootstrap-theme/select2-bootstrap.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/fullcalendar/fullcalendar.min.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/jquery-bar-rating/bars-1to10.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/jquery-bar-rating/examples.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/morris.js/morris.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/vendors/c3/c3.min.css">

<!-- End plugin css for this page -->

<!-- inject:css -->
<link rel="stylesheet" href="/vertical-dark-sidebar/css/style.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/style_layout.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/bstreeview.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/myTooltip.css">
<link rel="stylesheet" href="/vertical-dark-sidebar/css/style_calender.css">


<!-- endinject -->
<link rel="shortcut icon" href="../../../../../login/img/favicon.ico" />

<!-- plugins:js -->
<script src="/vertical-dark-sidebar/js/vendors/js/vendor.bundle.base.js"></script>
<!-- endinject -->
<!-- Plugin js for this page-->
<script src="/vertical-dark-sidebar/js/vendors/datatables.net/jquery.dataTables.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/datatables.net-bs4/dataTables.bootstrap4.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/jquery-toast-plugin/jquery.toast.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/jquery-bar-rating/jquery.barrating.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/sweetalert/sweetalert.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/select2/select2.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/jquery-validation/jquery.validate.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap-maxlength/bootstrap-maxlength.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap-datepicker/bootstrap-datepicker.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap-datepicker/bootstrap-datepicker.kr.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap-datepicker/moment.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/x-editable/bootstrap-editable.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap4-toggle/bootstrap4-toggle.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/inputmask/jquery.inputmask.bundle.min.js"></script>

<!-- <script src="/vertical-dark-sidebar/js/vendors/moment/moment.min.js"></script> -->

<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<!-- End plugin js for this page-->
<!-- inject:js -->
<script src="/vertical-dark-sidebar/js/off-canvas.js"></script>
<script src="/vertical-dark-sidebar/js/hoverable-collapse.js"></script>
<script src="/vertical-dark-sidebar/js/template.js"></script>
<script src="/vertical-dark-sidebar/js/settings.js"></script>
<script src="/vertical-dark-sidebar/js/todolist.js"></script>
<script src="/vertical-dark-sidebar/js/myTooltip.js"></script>

<!-- Custom js for this page-->
<script src="/vertical-dark-sidebar/js/desktop-notification.js"></script>
<script src="/vertical-dark-sidebar/js/bstreeview.js"></script>
<script src="/vertical-dark-sidebar/js/bscalendar.js"></script>
<script src="/vertical-dark-sidebar/js/jquery.mask.min.js"></script>
<script src="/vertical-dark-sidebar/js/jquery.tablednd.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/fullcalendar/fullcalendar.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/calender/ko.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/bootstrap-datepicker/bootstrap-datetimepicker.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/tempusdominus-bootstrap-4/tempusdominus-bootstrap-4.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/calender/addEvent.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/calender/editEvent.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/calender/etcSetting.js"></script>
<script src="/vertical-dark-sidebar/js/form-addons.js"></script>

<script src="/vertical-dark-sidebar/js/vendors/raphael/raphael.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/morris.js/morris.min.js"></script>
<!-- <script src="/vertical-dark-sidebar/js/vendors/chart.js/Chart.min.js"></script> -->

<script src="/vertical-dark-sidebar/js/vendors/justgage/raphael-2.1.4.min.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/justgage/justgage.js"></script>
<script src="/vertical-dark-sidebar/js/vendors/chart.js/Chart.min.js"></script>

<script src="/vertical-dark-sidebar/js/vendors/c3/c3.js"></script>

<script src="/vertical-dark-sidebar/js/vendors/inputmask/jquery.inputmask.bundle.min.js"></script>
<!-- End custom js for this page-->

<!-- endinject -->
<!-- Custom js for this page-->
<script src="/vertical-dark-sidebar/js/data-table.js"></script>
<script src="/vertical-dark-sidebar/js/common.js"></script>
<script src="/vertical-dark-sidebar/js/hummingbird-treeview.js"></script>
<script src="/vertical-dark-sidebar/js/dashboard_serverSpace.js"></script>
<!-- <script src="/vertical-dark-sidebar/js/just-gage.js"></script> -->

<!-- End custom js for this page-->