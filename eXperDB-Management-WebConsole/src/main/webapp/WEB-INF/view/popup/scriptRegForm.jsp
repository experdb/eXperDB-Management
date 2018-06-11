<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
// 저장후 작업ID
var wrk_id = null;
var wrk_nmChk ="fail";
var db_svr_id = "${db_svr_id}";
var haCnt =0;


$(window.document).ready(function() {

});





/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#wrk_nm").val() == ""){
		alert('<spring:message code="message.msg107" />');
		$("#wrk_nm").focus();
		return false;
	}else if(wrk_nmChk =="fail"){
		alert('<spring:message code="backup_management.work_overlap_check"/>');
		return false;
	}else if($("#wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
		$("#wrk_exp").focus();
		return false;
	}
}



//work명 중복체크
function fn_check() {
	var wrk_nm = document.getElementById("wrk_nm");
	if (wrk_nm.value == "") {
		alert('<spring:message code="message.msg107" />');
		document.getElementById('wrk_nm').focus();
		return;
	}
	$.ajax({
		url : '/wrk_nmCheck.do',
		type : 'post',
		data : {
			wrk_nm : $("#wrk_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert('<spring:message code="backup_management.reg_possible_work_nm"/>');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";		
			} else {
				scd_nmChk = "fail";
				alert('<spring:message code="backup_management.effective_work_nm"/>');
				document.getElementById("wrk_nm").focus();
			}
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
</script>


</head>
<body>
<form name="workRegForm">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
<!-- <input type="hidden" name="check_path1" id="check_path1" value="N"/> -->
<input type="hidden" name="check_path2" id="check_path2" value="N"/>
</form>	
		<div class="pop_container">
			<div class="pop_cts">
				<p class="tit">스크립트 명령어등록</p>
				<div class="pop_cmm">
					<table class="write">
						<caption>스크립트 명령어등록</caption>
						<colgroup>
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
								<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()"/>
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
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
								<th scope="row" class="ico_t1">실행명령어</th>
							</tr>
							<tr>
								<td>
									<div class="textarea_grp">
										<textarea name="exeCmd" id="exeCmd"  style="height: 250px;" maxlength="100" ></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_type_02">
					<span class="btn btnC_01" onClick="fn_insert_work();return false;"><button><spring:message code="common.registory" /></button></span>
					<span class="btn" onclick="self.close();return false;"><button><spring:message code="common.cancel" /></button></span>
				</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>