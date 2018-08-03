<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : scriptRegForm.jsp
	* @Description : 스크립트등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018. 06. 08     최초 생성
	*
	* author 변승우
	* since 2017.06.07
	*
	*/
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">

var str = null;
var wrk_id = "${wrk_id}";
var db_svr_id = "${db_svr_id}";


$(window.document).ready(function() {
	fn_search();
});



function fn_search(){
	$.ajax({
		url : "/selectScriptList.do", 
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		wrk_id : '<c:out value="${wrk_id}"/>'
	  	},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			document.getElementById("wrk_nm").value=data[0].wrk_nm;
			document.getElementById("wrk_exp").value=data[0].wrk_exp;
			document.getElementById("exe_cmd").value=data[0].exe_cmd;
		}
	});
}




/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	 if($("#wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
		$("#wrk_exp").focus();
		return false;
	}else if($("#exe_cmd").val() == ""){
		alert('<spring:message code="message.msg216" />');
		$("#exe_cmd").focus();
		return false;
	}else{
		return true;
	}
}



function fn_update_work(){
	
	if(valCheck()){
		$.ajax({
			url : '/popup/updateScript.do',
			type : 'post',
			data : {
				wrk_id : wrk_id,
				wrk_exp : $("#wrk_exp").val(),
				exe_cmd : $("#exe_cmd").val()
			},
			success : function(result) {
				alert('<spring:message code="message.msg84" />');
				window.close();
				opener.fn_search();
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}
	
}
</script>


</head>
<body>
		<div class="pop_container">
			<div class="pop_cts">
				<p class="tit"><spring:message code="script_settings.Modify_Script_Command"/></p>
				<div class="pop_cmm">
					<table class="write">
						<caption>스크립트 명령어수정</caption>
						<colgroup>
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
								<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength="20" <spring:message code='message.msg188'/>" readonly/>					
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="common.work_description" /></th>
								<td>
									<div class="textarea_grp">
										<textarea name="wrk_exp" id="wrk_exp" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="pop_cmm mt25">
					<table class="write">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="script_settings.Execution_Command"/></th>
							</tr>
							<tr>
								<td>
									<div class="textarea_grp">
										<textarea name="exe_cmd" id="exe_cmd"  style="height: 250px;"></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_type_02">
					<span class="btn btnC_01" onClick="fn_update_work();"><button type="button"><spring:message code="common.modify" /></button></span>
					<span class="btn" onclick="self.close();return false;"><button type="button"><spring:message code="common.cancel" /></button></span>
				</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>