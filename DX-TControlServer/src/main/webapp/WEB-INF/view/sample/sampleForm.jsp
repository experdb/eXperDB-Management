<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : sampleForm.jsp
	* @Description : Sample Form 화면
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="<c:url value='/css/egovframework/sample.css'/>" />
<title>Insert title here</title>
<script>
	/* 글 등록 function */
	function fn_egov_save() {
		frm = document.detailForm;
		frm.action = "/insertSampleList.do";
		frm.submit();
	}
	/* 글 수정 function */
	function fn_egov_modify() {
		frm = document.detailForm;
		frm.action = "/updateSampleList.do";
		frm.submit();
	}
	/* 글 삭제 function */
	function fn_egov_delete() {
		frm = document.detailForm;
		frm.action = "/deleteSampleList.do";
		frm.submit();
	}
</script>
</head>
<body>
	<form:form commandName="sampleListVo" id="detailForm" name="detailForm">
		<div id="content_pop">
			<!-- 타이틀 -->
			<div id="title">
				<ul>
					<li><img
						src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
						alt="" /> Sample List</li>
				</ul>
			</div>
			<!-- // 타이틀 -->

			<c:if test="${registerFlag == 'create'}">
				<!-- 등록 폼 -->
				<div id="table">
					<table width="100%" border="1" cellpadding="0" cellspacing="0"
						style="bordercolor: #D3E2EC; bordercolordark: #FFFFFF; BORDER-TOP: #C2D0DB 2px solid; BORDER-LEFT: #ffffff 1px solid; BORDER-RIGHT: #ffffff 1px solid; BORDER-BOTTOM: #C2D0DB 1px solid; border-collapse: collapse;">
						<tr>
							<td class="tbtd_caption">카테고리명</td>
							<td class="tbtd_content"><input type="text"
								name="category_nm" id="category_nm" maxlength="30"></td>
						</tr>
						<tr>
							<td class="tbtd_caption">사용여부</td>
							<td class="tbtd_content"><select name="use_yn" id="use_yn">
									<option value="Y" label="사용" />
									<option value="N" label="미사용" />
							</select></td>
						</tr>
						<tr>
							<td class="tbtd_caption">내용</td>
							<td class="tbtd_content"><textarea name="contents" rows="3"
									cols="80"></textarea></td>
						</tr>
						<tr>
							<td class="tbtd_caption">등록자</td>
							<td class="tbtd_content"><input type="text" name="reg_nm"
								id="reg_nm" maxlength="10" />&nbsp;</td>
						</tr>
					</table>
				</div>
				<!-- //등록 폼 -->
			</c:if>


			<c:if test="${registerFlag == 'update'}">
				<!-- 수정 폼 -->
				<div id="table">
					<table width="100%" border="1" cellpadding="0" cellspacing="0"
						style="bordercolor: #D3E2EC; bordercolordark: #FFFFFF; BORDER-TOP: #C2D0DB 2px solid; BORDER-LEFT: #ffffff 1px solid; BORDER-RIGHT: #ffffff 1px solid; BORDER-BOTTOM: #C2D0DB 1px solid; border-collapse: collapse;">
						<c:forEach var="result" items="${result}" varStatus="status">
							<input type="hidden" name="no" value="${result.no}">
							<tr>
								<td class="tbtd_caption">카테고리명</td>
								<td class="tbtd_content"><input type="text"
									name="category_nm" id="category_nm" maxlength="30"
									value="${result.category_nm}"></td>
							</tr>
							<tr>
								<td class="tbtd_caption">사용여부</td>
								<td class="tbtd_content"><select name="use_yn" id="use_yn">
										<option value="Y"
											${result.use_yn == 'Y' ? 'selected="selected"' : ''}
											label="사용" />
										<option value="N"
											${result.use_yn == 'N' ? 'selected="selected"' : ''}
											label="미사용" />
								</select></td>
							</tr>
							<tr>
								<td class="tbtd_caption">내용</td>
								<td class="tbtd_content"><textarea name="contents" rows="3"
										cols="80">${result.contents}</textarea></td>
							</tr>
							<tr>
								<td class="tbtd_caption">등록자</td>
								<td class="tbtd_content"><input type="text" name="reg_nm"
									id="reg_nm" maxlength="10" value="${result.reg_nm}" />&nbsp;</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 수정 폼 -->
			</c:if>

			<!-- 버튼 -->
			<div id="sysbtn">
				<ul>
					<li><span class="btn_blue_l"> <a href="selectSampleList.do">목록</a>
							<img
							src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
							style="margin-left: 6px;" alt="" />
					</span></li>

					<c:if test="${registerFlag == 'create'}">
						<li><span class="btn_blue_l"> <a
								href="javascript:fn_egov_save();">등록</a> <img
								src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
								style="margin-left: 6px;" alt="" />
						</span></li>
					</c:if>

					<c:if test="${registerFlag == 'update'}">
						<li><span class="btn_blue_l"> <a
								href="javascript:fn_egov_modify();">수정</a> <img
								src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
								style="margin-left: 6px;" alt="" />
						</span></li>
						<!-- 수정인경우 삭제 가능하도록 -->
						<li><span class="btn_blue_l"> <a
								href="javascript:fn_egov_delete();">삭제</a> <img
								src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
								style="margin-left: 6px;" alt="" />
						</span></li>
					</c:if>
				</ul>
			</div>
			<!-- //버튼 -->
		</div>
	</form:form>
</body>
</html>