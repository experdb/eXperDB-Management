<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : ddlRegForm.jsp
	* @Description : ddl추출 수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.09.17     최초 생성
	*
	* author kimjy
	* since 2019.09.17
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
var wrk_nmChk ="fail";
var output_path ="fail";
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
	}else if($("#source_info").val() == ""){
		alert("소스 시스템정보를 등록해주세요.");
		$("#source_info").focus();
		return false;
	}else if($("#src_file_output_path").val() == ""){
		alert("저장경로를 입력해주세요.");
		$("#src_file_output_path").focus();
		return false;
	}else if(output_path =="fail"){
		alert('저장경로를 체크해주세요.');		
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * WORK NM Validation Check
 ******************************************************** */
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

/* ********************************************************
 * output path Validation Check
 ******************************************************** */
function fn_pathCheck() {
	var src_file_output_path = document.getElementById("src_file_output_path");
	if (src_file_output_path.value == "") {
		alert("경로를 입력하세요.");
		document.getElementById('src_file_output_path').focus();
		return;
	}
	$.ajax({
		url : '/db2pgPathCheck.do',
		type : 'post',
		data : {
			src_file_output_path : $("#src_file_output_path").val()
		},
		success : function(result) {
			if (result == "true") {
				alert('유효한 경로입니다.');
				output_path = "success";		
			} else {
				alert('유효하지 않은 경로입니다.');
				document.getElementById("src_file_output_path").focus();
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

/* ********************************************************
 * 수정 버튼 클릭시
 ******************************************************** */
function fn_update_work(){
	if(valCheck()){
		$.ajax({
			async : false,
			url : "/db2pg/updateWork.do",
		  	data : {
		  		wrk_nm : $("#wrk_nm").val().trim(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		source_info : $("#source_info").val(),
		  		src_classify_string : $("#src_classify_string").val(),
		  		src_table_ddl : $("#src_table_ddl").val(),
		  		src_include_tables : $("#src_include_tables").val(),
		  		src_exclude_tables : $("#src_exclude_tables").val(),
		  		src_file_output_path : $("#src_file_output_path").val()
		  	},
			type : "post",
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
			},
			success : function(result) {
				alert(result);
			}
		});
	}
}

/* ********************************************************
 * DBMS 시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_dbmsInfo(){
	var popUrl = "/db2pg/popup/dbmsInfo.do";
	var width = 920;
	var height = 670;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dbmsInfoPop",popOption);
}

/* ********************************************************
 * 추출 대상 테이블, 추출 제외 테이블 등록 버튼 클릭시
 ******************************************************** */
function fn_tableList(){
	var popUrl = "/db2pg/popup/tableInfo.do";
	var width = 930;
	var height = 675;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"tableInfoPop",popOption);
}

</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">DDL 추출 수정</p>
		<div class="pop_cmm">
			<table class="write">
				<caption>DDL 추출 수정</caption>
				<colgroup>
					<col style="width:105px;" />
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
		<div class="sub_tit"><p>시스템정보</p></div>
			<table class="write">
				<colgroup>
					<col style="width:105px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t2">소스시스템</th>
						<td><input type="text" class="txt" name="source_info" id="source_info"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_dbmsInfo()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
		<div class="sub_tit"><p>옵션정보</p></div>
			<table class="write">
				<caption>옵션정보</caption>
				<colgroup>
					<col style="width:30%" />
					</col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t2">DDL&데이터 대소문자 지정</th>
						<td>
							<select name="src_classify_string" id="src_classify_string" class="select t5">
								<c:forEach var="codeLetter" items="${codeLetter}">
									<option value="${codeLetter.sys_cd_nm}" ${sys_cd_nm eq codeLetter.sys_cd_nm ? "selected='selected'" : ""}>${codeLetter.sys_cd_nm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">소스 Table DDL 추출(View 제외) 여부</th>
						<td>
							<select name="src_table_ddl" id="src_table_ddl" class="select t5">
								<c:forEach var="codeTF" items="${codeTF}">
									<option value="${codeTF.sys_cd_nm}" ${sys_cd_nm eq codeTF.sys_cd_nm ? "selected='selected'" : ""}>${codeTF.sys_cd_nm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 대상 테이블</th>
						<td><input type="text" class="txt" name="src_include_tables" id="src_include_tables"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 제외 테이블</th>
						<td><input type="text" class="txt" name="src_exclude_tables" id="src_exclude_tables"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">DDL 저장경로</th>
						<td><textarea rows="3" cols="60" id="src_file_output_path" name="src_file_output_path" style="width: 80%"></textarea>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_pathCheck()" style="width: 60px; margin-right: -60px; margin-top: 0; height: 58px;">경로체크</button></span>							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01" onClick="fn_update_work();"><button type="button">수정</button></span>
			<a href="#n" class="btn" onclick="self.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>
