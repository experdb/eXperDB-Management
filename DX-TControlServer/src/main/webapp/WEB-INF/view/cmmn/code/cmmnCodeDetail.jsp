<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>공통코드 등록</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script type="text/javaScript" language="javascript" defer="defer"></script>
</head>
<script type="text/javascript">

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_selectCmmnCode(){
	location.href = "<c:url value='/cmmnCodeList.do' />";
}


/* ********************************************************
 * 수정 처리 함수
 ******************************************************** */
function fn_updateCmmnCode(){	
	if (confirm("수정 하시겠습니까?")) {
		var frm = document.dtlCmmnCode;
		frm.action = "/updateCmmnCode.do";
		frm.submit();
	}
}

/* ********************************************************
 * 삭제 처리 함수
 ******************************************************** */
function fn_deleteCmmnCode(){
	if (confirm("삭제 하시겠습니까?")) {
		var frm = document.dtlCmmnCode;
		frm.action = "/deleteCmmnCode.do";
		frm.submit();
	}
}
</script>

<body>
	<div id="container">
		<!-- contents -->
		<div id="contents">
			<div class="location">
				<ul>
					<li>그룹코드 상세정보</li>
				</ul>
			</div>
			<div class="contents_wrap">
			<h4>그룹코드상세정보</h4>
			<div class="contents">
			<form name="dtlCmmnCode" id="dtlCmmnCode" method="post">
				<div class="contsBody">
					<div class="Btn">
						<span class="bbsBtn"><a
							href="javascript:fn_selectCmmnCode()">목록</a></span> <span
							class="bbsBtn"><a href="javascript:fn_updateCmmnCode();">수정</a></span>
						<span class="bbsBtn"><a
							href="javascript:fn_deleteCmmnCode();">삭제</a></span>
					</div>

					<div class="bbsDetail">
						<table>
							<colgroup>
								<col style="width: 20%">
								<col style="width: auto">
							</colgroup>
							<tbody>
								<c:forEach items="${resultList}" var="result" varStatus="status">
									<tr>
										<th><img src="/images/egovframework/example/blt4.gif"
											alt="필수입력" />코드ID</th>
										<td colspan="3"><input type="text" readonly="readonly"
											size="10" maxlength="10" name="grp_cd" id="grp_cd"
											value='${result.grp_cd}' /></td>
									</tr>

									<tr>
										<th><img src="/images/egovframework/example/blt4.gif"
											alt="필수입력" />코드명</th>
										<td><input type="text" size="60" maxlength="60"
											name="grp_cd_nm" id="grp_cd_nm" value='${result.grp_cd_nm}' />
										</td>
									</tr>

									<tr>
										<th><img src="/images/egovframework/example/blt4.gif"
											alt="필수입력" />코드설명</th>
										<td><textarea rows="3" cols="60" id="grp_cd_exp"
												name="grp_cd_exp">${result.grp_cd_exp}</textarea></td>
									</tr>

									<tr>
										<th><img src="/images/egovframework/example/blt4.gif"
											alt="필수입력" />사용여부</th>
										<td colspan="3"><select name="use_yn" id="use_yn">
												<option value="Y"
													<c:if test="${result.use_yn == 'Y'}">selected="selected"</c:if>>사용</option>
												<option value="N"
													<c:if test="${result.use_yn == 'N'}">selected="selected"</c:if>>미사용</option>
										</select></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</form>
			</div>
			</div>
		</div>
	</div>
</body>
</html>
