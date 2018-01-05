<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : agentMonitoringModifyForm.jsp
	* @Description : 암호화 에이전트 모니터링 수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.04
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
</head>


<body>
		<div class="pop_container">
			<div class="pop_cts">
				<p class="tit">암호화 에이전트 모니터링 수정</p>
				
				기본
				<div class="pop_cmm">
					<table class="write">
						<caption>기본</caption>
						<colgroup>
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Agent 이름</th>
								<td><input type="text" class="txt" name="" id="" />								
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">Agent 상태</th>
								<td><input type="text" class="txt" name="" id="" />								
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				부가정보
				<div class="pop_cmm">				
					<table class="write">
						<caption>부가정보</caption>
						<colgroup>
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">최근접속 주소</th>
								<td><input type="text" class="txt" name="" id="" />							
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">최근접속일시</th>
								<td><input type="text" class="txt" name="" id="" />								
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
											<div class="overflow_area">
								<table class="list">
									<caption>Ecnript Agent 모니터링 리스트</caption>
									<colgroup>
										<col style="width:10%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">No</th>
											<th scope="col">시스템 속성 키</th>
											<th scope="col">시스템 속성 값 </th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td></td>
											<td></td>
											<td></td>				
										</tr>
									</tbody>
								</table>
							</div>
				<div class="btn_type_02">
					<span class="btn btnC_01" onClick=""><button>저장</button></span>
					<span class="btn" onclick=""><button><spring:message code="common.cancel" /></button></span>
				</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>