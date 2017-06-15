<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : transferSetting.jsp
	* @Description : TransferSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.13     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.13
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>전송설정</title>
</head>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script>
	/* 저장버튼 클릭시*/
	function fn_insert() {
		$.ajax({
			url : '/insertTransferSetting.do',
			type : 'post',
			data : {
				ipadr : $("#ipadr").val(),
				portno : $("#portno").val()
			},
			success : function(result) {
				alert("저장하였습니다.");
			},
			error : function(request, status, error) {
				 alert("실패");
			}
		});
	}
</script>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><img src="<c:url value='/images/egovframework/example/title_dot.gif'/>" alt="" /> 전송설정</li>
			</ul>
		</div>
		<!-- // 타이틀 -->
		<!-- 리스트 -->
		<div id="table">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="40" />
					<col width="100" />
					<col width="150" />
				</colgroup>
				<tr>
					<th align="center">서버명</th>
					<th align="center">아이피</th>
					<th align="center">포트</th>
				</tr>
				<tr>
					<td align="center" class="listtd">kafka Broker</td>
					<td align="center" class="listtd"><input type="text" name="ipadr" id="ipadr"></td>
					<td align="center" class="listtd"><input type="text" name="portno" id="portno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">schema registry</td>
					<td align="center" class="listtd"><input type="text" name="ipadr" id="ipadr"></td>
					<td align="center" class="listtd"><input type="text" name="portno" id="portno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">zookeeper</td>
					<td align="center" class="listtd"><input type="text" name="ipadr" id="ipadr"></td>
					<td align="center" class="listtd"><input type="text" name="portno" id="portno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">BottledWater</td>
					<td align="center" class="listtd"><input type="text" name="ipadr" id="ipadr"></td>
					<td align="center" class="listtd"><input type="text" name="portno" id="portno"></td>
				</tr>
			</table>
		</div>
		<!-- // 리스트 -->

		<!-- //등록버튼 -->
		<div id="sysbtn" style="text-align: center;">
			<ul>
				<li><span class="btn_blue_l"> 
				<a href="#" onclick="fn_insert()">저장</a> 
				<img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"alt="" />
				</span></li>
				<li><span class="btn_blue_l"> 
				<a href="#">취소</a> 
				<img src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>" alt="" />
				</span></li>
			</ul>
		</div>

	</div>
</body>
</html>