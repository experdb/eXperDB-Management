<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : sampleList.jsp
	* @Description : Sample List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.22     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.22
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>리스트 샘플</title>
<link type="text/css" rel="stylesheet"
	href="<c:url value='/css/egovframework/sample.css'/>" />
<script type="text/javaScript" language="javascript" defer="defer">
	
</script>
</head>
<script type="text/javascript">
	/* 글 등록 화면 function */
	function fn_egov_addView() {
		document.selectList.action = "<c:url value='/sampleListForm.do?registerFlag=create'/>";
		document.selectList.submit();
	}
	
    /* pagination 페이지 링크 function */
    function fn_egov_link_page(pageNo){
    	document.selectList.pageIndex.value = pageNo;
    	document.selectList.action = "<c:url value='/selectSampleList.do'/>";
       	document.selectList.submit();
    }
</script>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><img
					src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
					alt="" /> <spring:message code="list.sample" /></li>
			</ul>
		</div>
		<!-- // 타이틀 -->

		<!-- // 검색창 -->
		<div id="search"></div>
		<!-- // 검색창 -->


		<!-- // 리스트 -->
		<form:form commandName="searchVO" name="selectList" id="selectList" method="post">
			<div id="table">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<caption style="visibility: hidden">카테고리ID, 케테고리명, 사용여부,
						Description, 등록자 표시하는 테이블</caption>
					<colgroup>
						<col width="40" />
						<col width="100" />
						<col width="150" />
						<col width="80" />
						<col width="?" />
						<col width="60" />
					</colgroup>
					<tr>
						<th align="center">No</th>
						<th align="center">카테고리ID</th>
						<th align="center">카테고리명</th>
						<th align="center">사용여부</th>
						<th align="center">내용</th>
						<th align="center">등록자</th>
					</tr>
					<c:forEach var="result" items="${resultList}" varStatus="status">
            			<tr>
            				<td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
            				<td align="center" class="listtd"><a href="/sampleListForm.do?registerFlag=update&&category_id=${result.category_id}"><c:out value="${result.category_id}" />&nbsp;</a></td>
            				<td align="left" class="listtd"><c:out value="${result.category_nm}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.use_yn}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.contents}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.reg_nm}"/>&nbsp;</td>
            				
            			</tr>
        			</c:forEach>
				</table>
			</div>

		<!-- // 리스트 -->
        	<!-- /List -->
        	<div id="paging">
        		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
        		<form:hidden path="pageIndex" />
        	</div>

		<!-- //등록버튼 -->
		<div id="sysbtn">
			<ul>
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_egov_addView();"><spring:message
								code="button.create" /></a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
			</ul>
		</div>
		</form:form>
	</div>
</html>