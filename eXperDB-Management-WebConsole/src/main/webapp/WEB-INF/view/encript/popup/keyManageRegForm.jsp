<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : keyManageRegForm.jsp
	* @Description : keyManageRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.08
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>암복호화 키 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<script>
$(window.document).ready(function() {
	$.datepicker.setDefaults({
		dateFormat : 'yy-mm-dd',
		changeYear: true,
	});
	$("#datepicker3").datepicker();
});

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">암복호화 키 등록</p>
				<table class="write">
					<caption>암복호화 키 등록</caption>
					<colgroup>
						<col style="width: 130px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">암호화 키 이름</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">적용 알고리즘</th>
							<td>
								<select class="select t5" id="">
										<option value="SEED-128">SEED-128</option>
										<option value="ARIA-128">ARIA-128</option>
										<option value="ARIA-192">ARIA-192</option>
										<option value="ARIA-256">ARIA-256</option>
										<option value="AES-128">AES-128</option>
										<option value="AES-256">AES-256</option>
										<option value="SHA-256">SHA-256</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">암호화 키 설명</th>
							<td><input type="text" class="txt" name="" id="" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">유효기간 만료일</th>
							<td>
								<div class="calendar_area big">
									<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker3"  readonly="readonly">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			<div class="btn_type_02">
				<a href="#n" class="btn"><span>저장</span></a> 
				<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>
</body>
</html>