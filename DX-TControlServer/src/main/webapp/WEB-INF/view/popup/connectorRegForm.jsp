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
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>
	
	/* 숫자체크 */
	function valid_numeric(objValue) {
		if (objValue.match(/^[0-9]+$/) == null) {
			return false;
		} else {
			return true;
		}
	}

	/* Validation */
	function fn_connectorValidation() {
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
		if (!valid_numeric(cnr_portno.value)) {
			alert("포트는 숫자만 입력가능합니다.");
			cnr_portno.focus();
			return false;
		}
		return true;
	}

	
	/* 등록버튼 클릭시 */
	function fn_insert() {
		if (!fn_connectorValidation()) return false;
			if (!confirm("저장하시겠습니까?")) return false;
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
					alert("저장하였습니다.");
					opener.location.reload();
					window.close();
				},
				error : function(request, status, error) {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			});
	}

	/* 수정버튼 클릭시 */
	function fn_update() {
		if (!fn_connectorValidation()) return false;
			if (!confirm("수정하시겠습니까?")) return false;
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
					opener.location.reload();
					window.close();
				},
				error : function(request, status, error) {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			});
	}

</script>
<body>
	<div class="pop-container">
			<div class="pop_cts">
				<input type="hidden" name="cnr_id" id="cnr_id" value="${cnr_id}">
				<p class="tit">
					<c:if test="${act == 'i'}">커넥터 등록하기</c:if>
					<c:if test="${act == 'u'}">커넥터 수정하기</c:if>
				</p>
				<table class="write">
					<caption>
						<c:if test="${act == 'i'}">커넥터 등록하기</c:if>
						<c:if test="${act == 'u'}">커넥터 수정하기</c:if>
					</caption>
					<colgroup>
						<col style="width: 140px;" />
						<col />
						<col style="width: 80px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">Connector 명</th>
							<td><input type="text" class="txt" name="cnr_nm" id="cnr_nm" value="${cnr_nm}" maxlength="20"/></td>
							<th scope="row" class="ico_t1">IP(*)</th>
							<td><input type="text" class="txt" name="cnr_ipadr" id="cnr_ipadr" value="${cnr_ipadr}"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">연결유형(*)</th>
							<td>
								<select class="select" name="cnr_cnn_tp_cd" id="cnr_cnn_tp_cd">
									<option value="HDFS" ${cnr_cnn_tp_cd == 'HDFS' ? 'selected="selected"' : ''}>HDFS</option>
								</select>
							</td>
							<th scope="row" class="ico_t1">Port(*)</th>
							<td><input type="text" class="txt" name="cnr_portno" id="cnr_portno" value="${cnr_portno}"/></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<c:if test="${act == 'i'}">
						<span class="btn"><button type="button" onclick="fn_insert()">저장</button></span>
					</c:if>
					<c:if test="${act == 'u'}">
						<span class="btn"><button type="button" onclick="fn_update()">수정</button></span>
					</c:if>
					<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
				</div>
		</div>
	</div>
	<!-- //pop-container -->

</body>
</html>