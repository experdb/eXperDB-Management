<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>공통코드</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script type="text/javaScript" language="javascript" defer="defer">
</script>
</head>
<script type="text/javascript">


/* ********************************************************
 * pagination 페이지 링크
 ******************************************************** */
function fn_egov_link_page(pageNo){
	document.listForm.pageIndex.value = pageNo;
	document.listForm.action = "<c:url value='/cmmnCodeList.do'/>";
   	document.listForm.submit();
}


/* ********************************************************
 * 조회 처리
 ******************************************************** */
function fn_search(){
	var frm = document.listForm;
	frm.action = "/cmmnCodeSearch.do";
	frm.submit();	
}


/* ********************************************************
 * 등록 처리 함수
 ******************************************************** */
function fnRegist(){
	location.href = "<c:url value='/cmmnCodeRegist.do?regFlag=insert' />";
}


/* ********************************************************
 * 상세화면 처리 함수
 ******************************************************** */
 function fn_cmmnCodeDetail(grp_cd){
		frm = document.listForm;
		frm.action = "/cmmnCodeRegist.do?regFlag=detail";
		frm.grp_cd.value = grp_cd;
		frm.submit();
}
	

/* ********************************************************
 * 코드 처리 함수
 ******************************************************** */
function fn_cmmnCodeDtl(grp_cd){
	frm = document.listForm;
	frm.action = "/cmmnCodeDtlList.do";
	frm.grp_cd.value = grp_cd;
	frm.submit();
}


/* ********************************************************
 * 코드 Validation
 ******************************************************** */
function fncChangeCondition(){
	if(document.listForm.searchCondition.value == ''){
		document.listForm.searchKeyword.value="검색조건을 선택하세요";
		document.listForm.searchKeyword.disabled="disabled";
	}else{
		document.listForm.searchKeyword.value="";
		document.listForm.searchKeyword.disabled="";
	}
}

/* ********************************************************
 * 코드 리스트 조회(검색조건입력)
 ******************************************************** */
function fncSearchList(){
	if(!document.listForm.searchKeyword.disabled){
			fn_search();	
	}else{
		window.alert("검색조건을 선택하세요");
		document.listForm.searchCondition.focus();
	}
	
}
</script>


<body onLoad="fncChangeCondition();">
	<div id="container">
		<!-- contents -->
		<div id="contents">
			<div class="location">
				<ul>
					<li>그룹코드 리스트</li>
				</ul>
			</div>
			<div class="contents_wrap">
			<h4>그룹코드 관리</h4>
			<div class="contents">
			<form:form commandName="pageVO" name="listForm" id="listForm"
				method="post">
				<div class="contsBody">
					<!-- 검색영역 -->
					<div class="search">
						<fieldset class="searchboxA">
							<select id="searchCondition" name="searchCondition"
								class="serSel" style="" title="검색어 선택"
								onchange="fncChangeCondition();">
								<option value="">검색조건선택</option>
								<option value='0'
									<c:if test="${pageVO.searchCondition == '0'}">selected="selected"</c:if>>전체</option>
								<option value='1'
									<c:if test="${pageVO.searchCondition == '1'}">selected="selected"</c:if>>그룹코드ID</option>
								<option value='2'
									<c:if test="${pageVO.searchCondition == '2'}">selected="selected"</c:if>>그룹코드명</option>
							</select> <label for="searchKeyword" class="disp_none">검색어</label> <input
								id="searchKeyword" name="searchKeyword" class="inptext"
								title="검색어 입력란" type="text" onkeyPress="fncPress();"
								<c:if test="${pageVO.searchKeyword ne ''}">value="<c:out value='${pageVO.searchKeyword}'/>"</c:if>
								<c:if test="${pageVO.searchKeyword eq ''}">value="검색조건을 선택하세요" disabled="disabled"</c:if> />
							<input type="image" class="searchbtn" title="검색"
								src="/images/egovframework/example/btn_search.gif" alt="검색"
								onclick="fncSearchList(); return false;" />
						</fieldset>
					</div>
					<!-- //검색영역 -->

					<div class="Btn">
						<span class="bbsBtn"><a href="javascript:fnRegist()"
							title="그룹코드 등록화면으로 이동">등록</a></span>
					</div>

					<div class="bbsList">
						<table>
							<colgroup>
								<col style="width: 10%">
								<col style="width: 30%">
								<col style="width: auto">
								<col style="width: 10%">
								<col style="width: 7%">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">순번</th>
									<th scope="col">그룹코드ID</th>
									<th scope="col">그룹코드명</th>
									<th scope="col">사용여부</th>
									<th scope="col">상세보기</th>
								</tr>
							</thead>

							<tbody>
								<c:forEach items="${resultList}" var="result" varStatus="status">
									<tr>
										<td>${result.rownum}</td>
										<td><a href='#'
											onClick="fn_cmmnCodeDtl('${result.grp_cd}');">${result.grp_cd}</a></td>
										<td>${result.grp_cd_nm}</td>
										<td>${result.use_yn}</td>
										<td><input type="button" value="상세보기"
											onClick="fn_cmmnCodeDetail('${result.grp_cd}');"></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- // 리스트 -->
					<c:if test="${!empty pageVO.pageIndex }">
						<!-- /List -->
						<div id="paging">
							<ui:pagination paginationInfo="${paginationInfo}" type="image"
								jsFunction="fn_egov_link_page" />
							<form:hidden path="pageIndex" />
						</div>
					</c:if>
				</div>
				<input type="hidden" name="grp_cd">
			</form:form>
			</div>
			</div>
		</div>
	</div>
</body>
</html>
