<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
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


$(window.document).ready(function() {
	 
});


/* ********************************************************
 * 등록 버튼 클릭시
 ******************************************************** */
function fn_insert_work(){
	
}

/* ********************************************************
 * 소스시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_sourceInfo(){
	var popUrl = "/popup/sourceInfo.do";
	var width = 920;
	var height = 670;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"sourceInfoPop",popOption);
}

/* ********************************************************
 * 추출 대상 테이블, 추출 제외 테이블 등록 버튼 클릭시
 ******************************************************** */
function fn_tableList(){
	var popUrl = "/popup/tableInfo.do";
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
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_sourceInfo()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
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
							<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t5">
								<option value="0000"><spring:message code="common.choice" /></option>
								<option value="TC000401">변경없음</option>
								<option value="TC000402">모두 대문자</option>
								<option value="TC000403">모두 소문자</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">소스 Table DDL 추출(View 제외) 여부</th>
						<td>
							<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t5">
								<option value="0000"><spring:message code="common.choice" /></option>
								<option value="TC000401">TRUE</option>
								<option value="TC000402">FALSE</option>
	
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 대상 테이블</th>
						<td><input type="text" class="txt" name="save_pth" id="save_pth"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">추출 제외 테이블</th>
						<td><input type="text" class="txt" name="save_pth" id="save_pth"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList()" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">DDL 저장경로</th>
						<td><input type="text" class="txt" name="save_pth" id="save_pth"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01" onClick="fn_insert_work();"><button type="button"><spring:message code="common.registory" /></button></span>
			<a href="#n" class="btn" onclick="self.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>
