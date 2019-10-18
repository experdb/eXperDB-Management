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
var db2pg_ddl_wrk_nmChk ="fail";
var output_path ="fail";
$(window.document).ready(function() {
	 
});

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#db2pg_ddl_wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
		$("#db2pg_ddl_wrk_exp").focus();
		return false;
	}else if($("#db2pg_sys_id").val() == ""){
		alert("소스 시스템정보를 등록해주세요.");
		$("#db2pg_sys_id").focus();
		return false;
	}else if($("#ddl_save_pth").val() == ""){
		alert("저장경로를 입력해주세요.");
		$("#ddl_save_pth").focus();
		return false;
	}else if(output_path =="fail"){
		alert('저장경로를 체크해주세요.');		
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * output path Validation Check
 ******************************************************** */
function fn_pathCheck() {
	var ddl_save_pth = document.getElementById("ddl_save_pth");
	if (ddl_save_pth.value == "") {
		alert("경로를 입력하세요.");
		document.getElementById('ddl_save_pth').focus();
		return;
	}
	$.ajax({
		url : '/db2pgPathCheck.do',
		type : 'post',
		data : {
			ddl_save_pth : $("#ddl_save_pth").val()
		},
		success : function(result) {
			if (result == true) {
				alert('유효한 경로입니다.');
				output_path = "success";		
			} else {
				alert('유효하지 않은 경로입니다.');
				document.getElementById("ddl_save_pth").focus();
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
			url : "/db2pg/updateDDLWork.do",
		  	data : {
		  		db2pg_ddl_wrk_id : "${db2pg_ddl_wrk_id}",
		  		db2pg_ddl_wrk_nm : $("#db2pg_ddl_wrk_nm").val().trim(),
		  		db2pg_ddl_wrk_exp : $("#db2pg_ddl_wrk_exp").val(),
		  		db2pg_sys_id : $("#db2pg_sys_id").val(),
		  		db2pg_uchr_lchr_val : $("#db2pg_uchr_lchr_val").val(),
		  		src_tb_ddl_exrt_tf : $("#src_tb_ddl_exrt_tf").val(),
		  		src_include_tables : $("#src_include_table_nm").val(),
		  		src_exclude_tables : $("#src_exclude_table_nm").val(),
		  		ddl_save_pth : $("#ddl_save_pth").val()
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
				if(result.resultCode == "0000000000"){
					alert('<spring:message code="message.msg07" /> ');
					opener.location.reload();
					self.close();
				}else{
					alert('등록에 실패했습니다.');
				}	
			}
		});
	}
}

/* ********************************************************
 * DBMS 서버 호출하여 입력
 ******************************************************** */
 function fn_dbmsAddCallback(db2pg_sys_id,db2pg_sys_nm){
	 $('#db2pg_sys_id').val(db2pg_sys_id);
	 $('#db2pg_sys_nm').val(db2pg_sys_nm);
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
function fn_tableList(gbn){
	if($('#db2pg_sys_nm').val() == ""){
		alert("소스시스템을 선택해주세요.");
		return false;
	}
	
	var frmPop= document.frmPopup;
	var url = '/db2pg/popup/tableInfo.do';
	window.open('','popupView','width=930, height=500');  
	     
	frmPop.action = url;
	frmPop.target = 'popupView';
	frmPop.db2pg_sys_id.value = $('#db2pg_sys_id').val();
	frmPop.tableGbn.value = gbn;
	if(gbn == 'include'){
		frmPop.src_include_table_nm.value = $('#src_include_table_nm').val();  
	}else{
		frmPop.src_exclude_table_nm.value = $('#src_exclude_table_nm').val();  
	}
	frmPop.submit();   
}


function fn_tableAddCallback(rowList, tableGbn){
	if(tableGbn == 'include'){
		$('#src_include_tables').val(rowList.length+"개");
		$('#src_include_table_nm').val(rowList);
	}else{
		$('#src_exclude_tables').val(rowList.length+"개");
		$('#src_exclude_table_nm').val(rowList);
	}
}
</script>
</head>
<body>
<form name="frmPopup">
	<input type="hidden" name="db2pg_sys_id"  id="db2pg_sys_id" value="${db2pg_sys_id}">
	<input type="hidden" name="src_include_table_nm"  id="src_include_table_nm" value="${exrt_trg_tb_nm}">
	<input type="hidden" name="src_exclude_table_nm"  id="src_exclude_table_nm" value="${exrt_exct_tb_nm}" >
	<input type="hidden" name="tableGbn"  id="tableGbn" >
</form>
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
						<td><input type="text" class="txt" name="db2pg_ddl_wrk_nm" id="db2pg_ddl_wrk_nm" value="${db2pg_ddl_wrk_nm}" maxlength="20" onkeyup="fn_checkWord(this,20)" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.work_description" /></th>
						<td>
							<div class="textarea_grp">
								<textarea name="db2pg_ddl_wrk_exp" id="db2pg_ddl_wrk_exp" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"><c:out value="${db2pg_ddl_wrk_exp}"/></textarea>
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
						<td><input type="text" class="txt" name="db2pg_sys_nm" id="db2pg_sys_nm"  value="${db2pg_sys_nm}" readonly="readonly"/>
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
							<select name="db2pg_uchr_lchr_val" id="db2pg_uchr_lchr_val" class="select t5">
								<c:forEach var="codeLetter" items="${codeLetter}">
									<option value="${codeLetter.sys_cd_nm}" ${db2pg_uchr_lchr_val == codeLetter.sys_cd_nm ? 'selected="selected"' : ''}>${codeLetter.sys_cd_nm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">소스 Table DDL 추출(View 제외) 여부</th>
						<td>
							<select name="src_tb_ddl_exrt_tf" id="src_tb_ddl_exrt_tf" class="select t5">
								<c:forEach var="codeTF" items="${codeTF}">
									<option value="${codeTF.sys_cd_nm}" ${src_tb_ddl_exrt_tf == codeTF.sys_cd_nm ? 'selected="selected"' : ''}>${codeTF.sys_cd_nm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 대상 테이블</th>
						<td><input type="text" class="txt" name="src_include_tables" id="src_include_tables" readonly="readonly" value="${exrt_trg_tb_cnt}개"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList('include')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 제외 테이블</th>
						<td><input type="text" class="txt" name="src_exclude_tables" id="src_exclude_tables" readonly="readonly" value="${exrt_exct_tb_cnt}개"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList('exclude')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">DDL 저장경로</th>
						<td><textarea rows="3" cols="60" id="ddl_save_pth" name="ddl_save_pth" style="width: 80%"><c:out value="${ddl_save_pth}"/></textarea>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_pathCheck()" style="width: 60px; margin-right: -60px; margin-top: 0; height: 58px;">경로체크</button></span>							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01" onClick="fn_update_work();"><button type="button"><spring:message code="common.modify" /></button></span>
			<a href="#n" class="btn" onclick="self.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>
