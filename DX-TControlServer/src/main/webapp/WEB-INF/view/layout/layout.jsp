<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Insert title here</title>
</head>
<style>
@media screen and (min-width: 246px) and (max-width:1200px) {
	#container {
		width: 90%;
		height: 93vh;
		margin: 0px auto;
		padding: 20px;
	}
	#header {
		padding: 20px;
		height: 5%;
		margin-bottom: 20px;
		border: 1px solid #bcbcbc;
		font-size: 15px;
	}
	#contents {
		width: 70%;
		padding: 5px;
		float: right;
	}
	#tree {
		width: 200px;
		float: left;
	}
}

@media screen and (min-width: 1200px) and (max-width:1400px) {
	#container {
		width: 90%;
		height: 93vh;
		margin: 0px auto;
		padding: 20px;
	}
	#header {
		padding: 20px;
		height: 5%;
		margin-bottom: 20px;
		border: 1px solid #bcbcbc;
		font-size: 15px;
	}
	#contents {
		width: 75%;
		padding: 5px;
		float: right;
	}
	#tree {
		width: 200px;
		float: left;
	}
}
@media screen and (min-width: 1400px) and (max-width:1500px) {
	#container {
		width: 90%;
		height: 93vh;
		margin: 0px auto;
		padding: 20px;
	}
	#header {
		padding: 20px;
		height: 5%;
		margin-bottom: 20px;
		border: 1px solid #bcbcbc;
		font-size: 15px;
	}
	#contents {
		width: 77%;
		padding: 5px;
		float: right;
	}
	#tree {
		width: 200px;
		float: left;
	}
}

@media screen and (min-width: 1500px) {
	#container {
		width: 90%;
		height: 93vh;
		margin: 0px auto;
		padding: 20px;
	}
	#header {
		padding: 20px;
		height: 5%;
		margin-bottom: 20px;
		border: 1px solid #bcbcbc;
		font-size: 15px;
	}
	#contents {
		width: 80%;
		padding: 5px;
		float: right;
	}
	#tree {
		width: 200px;
		float: left;
	}
}
</style>
<body>
	<div id="container">

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