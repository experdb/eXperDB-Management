<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * @Class Name : sampleLocale.jsp
  * @Description : Sample Locale 화면
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
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="title.name" /></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>"/>
    <script type="text/javaScript" language="javascript" defer="defer">
    </script>
</head>
<script>
	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo){
		document.selectList.pageIndex.value = pageNo;
		document.selectList.action = "<c:url value='/selectsampleLocaleList.do'/>";
	   	document.selectList.submit();
	}
</script>
<body>
			<div id="content_pop">
        	<!-- 타이틀 -->
        	<div id="title">
        		<ul>
        			<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="title.name" /></li>
        		</ul>
        	</div>
        	<!-- // 타이틀 -->
        	
        	
        	<!-- // 리스트 -->
        	<form:form commandName="searchVO" name="selectList" id="selectList" method="post">
        	<div id="table">
        		<table width="100%" border="0" cellpadding="0" cellspacing="0">
        			<colgroup>
        				<col width="40"/>
        				<col width="100"/>
        				<col width="150"/>
        				<col width="80"/>
        				<col width="?"/>
        				<col width="60"/>
        			</colgroup>
        				<tr>
        					<th align="center"><spring:message code="table.head.no" /></th>
        					<th align="center"><spring:message code="table.head.id" /></th>
        					<th align="center"><spring:message code="table.head.name" /></th>
        					<th align="center"><spring:message code="table.head.use_yn" /></th>
        					<th align="center"><spring:message code="table.head.Contents" /></th>
        					<th align="center"><spring:message code="table.head.regUser" /></th>
        				</tr>
					<c:forEach var="result" items="${resultList}" varStatus="status">
            			<tr>
            				<td align="center" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
            				<td align="center" class="listtd"><c:out value="${result.category_id}" />&nbsp;</td>
            				<td align="left" class="listtd"><c:out value="${result.category_nm}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.use_yn}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.contents}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.reg_nm}"/>&nbsp;</td>
            			</tr>
        			</c:forEach>
        		</table>
        		</div>
        		
	        	<!-- /List -->
	        	<div id="paging">
	        		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
	        		<form:hidden path="pageIndex" />
	        	</div>
        	     			
        	</form:form>
        	</div>
        	<!-- // 리스트 -->
</body>
</html>