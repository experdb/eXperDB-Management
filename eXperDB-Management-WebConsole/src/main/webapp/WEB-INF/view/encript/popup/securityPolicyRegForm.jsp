<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : securityPolicyRegForm.jsp
	* @Description : securityPolicyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>암복호화 정책 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body>
		<div class="pop_container">
			<div class="pop_cts" >
				<p class="tit">암복호화 정책 등록</p>
					<form name="ipadr_form">
						<table class="write">
							<caption>암복호화 정책 등록</caption>
							<colgroup>
								<col style="width:130px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1">시작위치</th>
									<td><input type="text" class="txt" name="" id="" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">길이</th>
									<td><input type="text" class="txt" name="" id="" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">암호화 알고리즘</th>
									<td><select class="select" id="" name="">
									<option value="SEED-128">SEED-128</option>
									<option value="ARIA-128">ARIA-128</option>
									<option value="ARIA-192">ARIA-192</option>
									<option value="ARIA-256">ARIA-256</option>
									<option value="AES-128">AES-128</option>
									<option value="AES-256">AES-256</option>
									<option value="SHA-256">SHA-256</option>
									</select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">암호화 키</th>
									<td><select class="select" id="" name="">
									<option value="AES-256">AES-256</option></select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">초기 벡터</th>
									<td><select class="select" id="" name="">
									<option value="FIXED">FIXED</option>
									<option value="RANDOM">RANDOM</option>
									</select></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">운영모드</th>
									<td><select class="select" id="" name="">
									<option value="CBC">CBC</option>
									<option value="CTR">CTR</option>
									</select></td>
								</tr>
							</tbody>
						</table>
					</form>
				<div class="btn_type_02">
					<a href="#n" class="btn"><span>저장</span></a>
					<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
				</div>
			</div>
		</div>
</body>
</html>