<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : connectorRegForm.jsp
	* @Description : connectorRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.08     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.08 
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Connector 등록/수정</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
</head>
<script>
	//숫자체크
	function valid_numeric(objValue)
	{
		if (objValue.match(/^[0-9]+$/) == null)
		{	return false;	}
		else
		{	return true;	}
	}

	//Validation
	function fn_connectorValidation(){
		var cnr_nm = document.getElementById("cnr_nm");
		if (cnr_nm.value == "") {
			   alert("Connector명을 입력하여 주십시오.");
			   cnr_nm.focus();
			   return false;
		}
 		var cnr_ipadr = document.getElementById("cnr_ipadr");
 		if (cnr_ipadr.value == "") {
  			 	alert("IP를 입력하여 주십시오.");
  			 	cnr_ipadr.focus();
  			   	return false;
  		}

 		var cnr_portno = document.getElementById("cnr_portno");
		if (cnr_portno.value == "") {
			   alert("포트를 입력하여 주십시오.");
			   cnr_portno.focus();
			   return false;
		}
 		if(!valid_numeric(cnr_portno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			cnr_portno.focus();
		 	return false;
		}
 		return true;
	}

	//등록버튼 클릭시
	function fn_create() {
		if (!fn_connectorValidation()) return false;
		
		$.ajax({
			url : '/insertConnectorRegister.do',
			type : 'post',
			data : {
				cnr_nm : $("#cnr_nm").val(),
				cnr_ipadr : $("#cnr_ipadr").val(),
				cnr_portno : $("#cnr_portno").val(),
				cnr_cnn_tp_cd : $("#cnr_cnn_tp_cd").val()
			},
			success : function(result) {
				opener.location.reload();
				alert("등록하였습니다.");
				window.close();
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
	
	//수정버튼 클릭시
	function fn_update() {
		if (!fn_connectorValidation()) return false;
		
		$.ajax({
			url : '/updateConnectorRegister.do',
			type : 'post',
			data : {
				cnr_id : $("#cnr_id").val(),
				cnr_nm : $("#cnr_nm").val(),
				cnr_ipadr : $("#cnr_ipadr").val(),
				cnr_portno : $("#cnr_portno").val(),
				cnr_cnn_tp_cd : $("#cnr_cnn_tp_cd").val()
			},
			success : function(result) {		
				alert("수정하였습니다.");
				window.close();
				opener.location.reload();
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
	
	//연결TEST
	function fn_connectorConnTest(){
		if (!fn_connectorValidation()) return false;	
		$.ajax({
			url : '/connectorConnTest.do',
			type : 'post',
			data : {},
			success : function(result) {
				alert("연결테스트!");
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
	
</script>
<body>
	<h3>
		<c:if test="${act == 'i'}">Connector 등록</c:if>
		<c:if test="${act == 'u'}">Connector 수정</c:if>
	</h3>
	<form name="connectorForm" id="connectorForm" method="post">
	<input type="hidden" name="cnr_id" id="cnr_id" value="${cnr_id}">
		<div style="border: 1px solid black; padding: 20px; margin: 10px;">
			<table>
				<tr>
					<td>Connector명</td>
					<td><input type="text" name="cnr_nm" id="cnr_nm" value="${cnr_nm}"></td>
				</tr>
				<tr>
					<td>IP</td>
					<td><input type="text" name="cnr_ipadr" id="cnr_ipadr" value="${cnr_ipadr}"></td>
				</tr>
				<tr>
					<td>Port</td>
					<td><input type="text" name="cnr_portno" id="cnr_portno" value="${cnr_portno}"></td>
				</tr>
				<tr>
					<td>연결유형</td>
					<td><select id="cnr_cnn_tp_cd"><option value="HDFS">HDFS</option></select></td>
				</tr>
			</table>
		</div>
	</form>
	<br>
	<div style="text-align: center;">
		<c:if test="${act == 'i'}">
			<button type="button" onclick="fn_create()">등록</button>
		</c:if>
		<c:if test="${act == 'u'}">
			<button type="button" onclick="fn_update()">수정</button>
		</c:if>
		<button type="button" onclick="fn_connectorConnTest()">연결TEST</button>
		<input type="button" value="취소" onclick="self.close()">
	</div>
</body>
</html>