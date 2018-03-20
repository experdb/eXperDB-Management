<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="shortcut icon" type="image/x-icon" href="/css/images/favicon.ico" />
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>eXperDB for PostgreSQL</title>

<script>
function fn_logout(){
	var frm = document.sessionOut;
	frm.submit();	
}	

</script>

</head>


<body onLoad="fn_logout();">
<form name='sessionOut' method='post' target='_top' action='/logout.do'></form>

</body>
</html>