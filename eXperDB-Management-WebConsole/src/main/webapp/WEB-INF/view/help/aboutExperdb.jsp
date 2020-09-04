<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../cmmn/cs.jsp"%>

<%
	/**
	* @Class Name : aboutExperdb.jsp
	* @Description : aboutExperdb 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.08.18     최초 생성
	*
	* author 김주영 사원
	* since 2017.08.18
	*
	*/
%>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents">
			<table class="view">
				<caption>version,copyright</caption>
				<colgroup>
					<col style="width: 170px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="t1">Version</th>
						<td>1.1</td>
					</tr>
					<tr>
						<th scope="row" class="t1">Copyright</th>
						<td>2017, The eXperDB-Management Development Team</td>
					</tr>
				</tbody>
			</table>
			<div class="pop_logo">
				<img src="../../login/img/help.png" alt="eXperDB" style="width :350px; position: absolute; bottom: 130px;left: 50%; margin-left: -113px;"/>
			</div>
		</div>
	</div>
</div>