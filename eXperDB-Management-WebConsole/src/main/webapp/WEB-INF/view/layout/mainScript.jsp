<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	//treemenu 강제클릭이벤트
	function fn_treeMenu_move(id) {
		$("#" + id + "c").get(0).click();
	}
	
	function fn_serverMenuChk(id) {
		alert(id);
	}
</script>