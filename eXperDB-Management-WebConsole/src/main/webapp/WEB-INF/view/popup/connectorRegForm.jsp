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
	var nmCheck = 0;

	/* Validation */
	function fn_connectorValidation() {
		var filter = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
		
		var cnr_nm = document.getElementById("cnr_nm");
		if (cnr_nm.value == "") {
			alert('<spring:message code="message.msg81" /> ');
			cnr_nm.focus();
			return false;
		}
		var cnr_ipadr = document.getElementById("cnr_ipadr");
		if (cnr_ipadr.value == "") {
			alert('<spring:message code="message.msg82" /> ');
			cnr_ipadr.focus();
			return false;
		}
		
		if (filter.test(cnr_ipadr.value) == false){
			alert('<spring:message code="message.msg175" /> ');
			return false;
		}
		
		var cnr_portno = document.getElementById("cnr_portno");
		if (cnr_portno.value == "") {
			alert('<spring:message code="message.msg83" />');
			cnr_portno.focus();
			return false;
		}
		
		if (nmCheck != 1) {
// 			alert('<spring:message code="message.msg142"/>');
			alert("커넥터명을 입력 후 중복체크를 해주세요.")
			return false;
		}
		
		return true;
	}

	
	/* 등록버튼 클릭시 */
	function fn_insert() {
		if (!fn_connectorValidation()) return false;
			if (!confirm('<spring:message code="message.msg148"/>')) return false;
			
			$.ajax({
				url : '/connectorNameCheck.do',
				type : 'post',
				data : {
					cnr_nm : $("#cnr_nm").val()
				},
				success : function(result) {
					if (result == "true") {
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
								alert('<spring:message code="message.msg57" />');
								opener.location.reload();
								window.close();
							},
							beforeSend: function(xhr) {
						        xhr.setRequestHeader("AJAX", true);
						     },
							error : function(xhr, status, error) {
								if(xhr.status == 401) {
									alert('<spring:message code="message.msg02" />');
									 location.href = "/";
								} else if(xhr.status == 403) {
									alert('<spring:message code="message.msg03" />');
						             location.href = "/";
								} else {
									alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
								}
							}
						});
					}else {
						alert('<spring:message code="message.msg119" />');
						document.getElementById("cnr_nm").focus();
						nmCheck = 0;
					}
				},
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				}
			});
			
	}

	/* 수정버튼 클릭시 */
	function fn_update() {
		nmCheck = 1;
		if (!fn_connectorValidation()) return false;
			if (!confirm('<spring:message code="message.msg147"/>')) return false;
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
					alert('<spring:message code="message.msg84" />');
					opener.location.reload();
					window.close();
				},
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				}
			});
	}
	
	function NumObj(obj) {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			event.returnValue = false;
		}
	}
	
	function fn_nmCheck(){
		var cnr_nm = document.getElementById("cnr_nm");
		if (cnr_nm.value == "") {
			alert('<spring:message code="message.msg81" /> ');
			cnr_nm.focus();
			return false;
		}
		
		$.ajax({
			url : '/connectorNameCheck.do',
			type : 'post',
			data : {
				cnr_nm : $("#cnr_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert('<spring:message code="message.msg118" />');
					document.getElementById("cnr_ipadr").focus();
					nmCheck = 1;
				}else {
					alert('<spring:message code="message.msg119" />');
					document.getElementById("cnr_nm").focus();
					nmCheck = 0;
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
		
	}
</script>
<body>
	<div class="pop_container">
			<div class="pop_cts">
				<input type="hidden" name="cnr_id" id="cnr_id" value="${cnr_id}">
				<p class="tit">
					<c:if test="${act == 'i'}"><spring:message code="etc.etc05"/></c:if>
					<c:if test="${act == 'u'}"><spring:message code="etc.etc06"/></c:if>
				</p>
				<table class="write">
					<caption>
						<c:if test="${act == 'i'}"><spring:message code="etc.etc05"/></c:if>
						<c:if test="${act == 'u'}"><spring:message code="etc.etc06"/></c:if>
					</caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
						<col style="width: 80px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="etc.etc04"/>(*)</th>
							<td>
								<c:if test="${act == 'i'}">
								<input type="text" class="txt" name="cnr_nm" id="cnr_nm" value="${cnr_nm}" maxlength="20" style="width: 180px;" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" />
									<span class="btn btnC_01">
										<button type="button" class= "btn_type_02" onclick="fn_nmCheck()" style="width: 110px; height: 38px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button>
									</span>
								</c:if>
								<c:if test="${act == 'u'}">
									<input type="text" class="txt" name="cnr_nm" id="cnr_nm" value="${cnr_nm}" maxlength="20" readonly="readonly"/>
								</c:if>
							</td>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.ip" />(*)</th>
							<td><input type="text" class="txt" name="cnr_ipadr" id="cnr_ipadr" value="${cnr_ipadr}"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.type" />(*)</th>
							<td>
								<select class="select" name="cnr_cnn_tp_cd" id="cnr_cnn_tp_cd">
									<option value="HDFS" ${cnr_cnn_tp_cd == 'HDFS' ? 'selected="selected"' : ''}>HDFS</option>
								</select>
							</td>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.port" />(*)</th>
							<td><input type="text" class="txt" name="cnr_portno" id="cnr_portno" value="${cnr_portno}" onKeyPress="NumObj(this);" /></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<c:if test="${act == 'i'}">
						<span class="btn"><button type="button" onclick="fn_insert()"><spring:message code="common.registory" /></button></span>
					</c:if>
					<c:if test="${act == 'u'}">
						<span class="btn"><button type="button" onclick="fn_update()"><spring:message code="common.modify" /></button></span>
					</c:if>
					<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
				</div>
		</div>
	</div>
	<!-- //pop-container -->

</body>
</html>