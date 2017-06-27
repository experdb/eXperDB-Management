<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>상세코드</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script type="text/javaScript" language="javascript" defer="defer">	
</script>
</head>
<script type="text/javascript">

/* ********************************************************
 * pagination 페이지 링크
 ******************************************************** */
function fn_egov_link_page(pageNo){
	document.dtlListForm.pageIndex.value = pageNo;
	document.dtlListForm.action = "<c:url value='/cmmnCodeDtlList.do'/>";
   	document.dtlListForm.submit();
}


/* ********************************************************
 * 조회 처리
 ******************************************************** */
function fn_search(){
	//document.dtlListForm.pageIndex.value = 1;
	var frm = document.dtlListForm;
	frm.action = "/cmmnDtlCodeSearch.do";
	frm.submit();	
}


/* ********************************************************
 * 공통코드 리스트
 ******************************************************** */
function fn_cmmnCodeList(){
	location.href = "<c:url value='/cmmnCodeList.do' />";
}


/* ********************************************************
 * 등록 처리 함수
 ******************************************************** */
function fn_cmmnCodeDtlRegist(){
	frm = document.dtlListForm;
	frm.action = "/cmmnCodeDtlRegist.do?regFlag=insert";
	frm.submit();
}


/* ********************************************************
 * 삭제 처리 함수
 ******************************************************** */
function fn_deleteCmmnDtlCode(sys_cd){
	if(confirm("삭제 하시겠습니까?")){
		frm = document.dtlListForm;
		frm.action = "/deleteCmmnDtlCode.do";
		frm.sys_cd.value = sys_cd;
		frm.submit();
	}
}


function fncChangeCondition(){
	if(document.dtlListForm.searchCondition.value == ''){
		document.dtlListForm.searchKeyword.value="검색조건을 선택하세요";
		document.dtlListForm.searchKeyword.disabled="disabled";
	}else{
		document.dtlListForm.searchKeyword.value="";
		document.dtlListForm.searchKeyword.disabled="";
	}
}


function fncSearchList(){
	if(!document.dtlListForm.searchKeyword.disabled){
			fn_search();	
	}else{
		window.alert("검색조건을 선택하세요");
		document.dtlListForm.searchCondition.focus();
	}
	
}

</script>

<body onLoad="fncChangeCondition();">
	<div id="container">
		<!-- contents -->
		<div id="contents">
			<div class="location">
				<ul>
					<li>코드관리</li>
				</ul>
			</div>
			<div class="contents_wrap">
				<h4>코드</h4>
				<div class="contents">
					<form:form commandName="pageVO" name="dtlListForm" method="post"
						onkeypress="if(event.keyCode==13) return false;" action="">
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
											<c:if test="${pageVO.searchCondition == '1'}">selected="selected"</c:if>>코드ID</option>
										<option value='2'
											<c:if test="${pageVO.searchCondition == '2'}">selected="selected"</c:if>>코드명</option>
									</select> <label for="searchKeyword" class="disp_none">검색어</label> <input
										id="searchKeyword" name="searchKeyword" class="inptext"
										title="검색어 입력란" type="text"
										<c:if test="${pageVO.searchKeyword ne ''}">value="<c:out value='${pageVO.searchKeyword}'/>"</c:if>
										<c:if test="${pageVO.searchKeyword eq ''}">value="검색조건을 선택하세요" disabled="disabled"</c:if> />
									<input type="image" class="searchbtn" title="검색"
										src="/images/egovframework/example/btn_search.gif" alt="검색"
										onclick="fncSearchList(); " />
								</fieldset>
							</div>
							<!-- //검색영역 -->

							<div class="Btn">
								<span class="bbsBtn"><a
									href="javascript:fn_cmmnCodeList()">그룹코드 리스트</a></span> <span class="bbsBtn"><a
									href="javascript:fn_cmmnCodeDtlRegist()">등록</a></span>
							</div>

							<div class="bbsList">
								<table>
									<colgroup>
										<col style="width: 10%">
										<col style="width: 15%">
										<col style="width: 15%">
										<col style="width: auto">
										<col style="width: 7%">
										<col style="width: 7%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">순번</th>
											<th scope="col">그룹코드ID</th>
											<th scope="col">코드ID</th>
											<th scope="col">코드명</th>
											<th scope="col">사용여부</th>
											<th scope="col">삭제</th>
										</tr>
									</thead>

									<tbody>
										<c:forEach items="${resultList}" var="result"
											varStatus="status">
											<tr>
												<td>${result.rownum}</td>
												<td>${result.grp_cd}</td>
												<td>${result.sys_cd}</td>
												<td>${result.sys_cd_nm}</td>
												<td>${result.use_yn}</td>
												<td><input type="button" value="삭제"
													onClick="fn_deleteCmmnDtlCode('${result.sys_cd}');"></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
							<c:if test="${!empty pageVO.pageIndex }">
								<!-- /List -->
								<div id="paging">
									<ui:pagination paginationInfo="${paginationInfo}" type="image"
										jsFunction="fn_egov_link_page" />
									<form:hidden path="pageIndex" />
								</div>
							</c:if>
						</div>

						<input type="hidden" name="grp_cd" value="${grp_cd}">
						<input type="hidden" name="sys_cd">
					</form:form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
