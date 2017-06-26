<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>

<body>
	<div id="wrap">
		<div id="header">
			<tiles:insertAttribute name="topMenu" />
		</div>

		<div id="tree">
			<tiles:insertAttribute name="treeMenu" />
		</div>

		<div id="contents">
			<tiles:insertAttribute name="contents" />
		</div>
	</div>
</body>
</html>