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
	*  2017.06.19     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.19
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
	
	/* 숫자체크 */
	function valid_numeric(objValue)
	{
		if (objValue.match(/^[0-9]+$/) == null)
		{	return false;	}
		else
		{	return true;	}
	}

	/* Validation */
	function fn_transferValidation(){
 		var kbipadr = document.getElementById("kbipadr");
		if (kbipadr.value == "") {
			alert("kafka Broker 아이피를 입력하여 주십시오.");
			kbipadr.focus();
			return false;
		}

 		var kbportno = document.getElementById("kbportno");
		if (kbportno.value == "") {
			alert("kafka Broker 포트를 입력하여 주십시오.");
			kbportno.focus();
			return false;
		}
 		if(!valid_numeric(kbportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			kbportno.focus();
		 	return false;
		}		
 		var sripadr = document.getElementById("sripadr");
		if (sripadr.value == "") {
			alert("schema registry 아이피를 입력하여 주십시오.");
			sripadr.focus();
			return false;
		}	
 		var srportno = document.getElementById("srportno");
		if (srportno.value == "") {
			alert("schema registry 포트를 입력하여 주십시오.");
			srportno.focus();
			return false;
		}
 		if(!valid_numeric(srportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			srportno.focus();
		 	return false;
		}
 		var zipadr = document.getElementById("zipadr");
		if (zipadr.value == "") {
			alert("zookeeper 아이피를 입력하여 주십시오.");
			zipadr.focus();
			return false;
		}
 		var zportno = document.getElementById("zportno");
		if (zportno.value == "") {
			alert("zookeeper 포트를 입력하여 주십시오.");
			zportno.focus();
			return false;
		}
 		if(!valid_numeric(zportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			zportno.focus();
		 	return false;
		}	
 		var bipadr = document.getElementById("bipadr");
		if (bipadr.value == "") {
			alert("BottledWater 아이피를 입력하여 주십시오.");
			bipadr.focus();
			return false;
		}
 		var bportno = document.getElementById("bportno");
		if (bportno.value == "") {
			alert("BottledWater 포트를 입력하여 주십시오.");
			bportno.focus();
			return false;
		}
 		if(!valid_numeric(bportno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			bportno.focus();
		 	return false;
		}
	
 		return true;		
	}
	
	
	/* 저장버튼 클릭시 */
	function fn_insert() {
		if (!fn_transferValidation()) return false;	
		$.ajax({
			url : '/insertTransferSetting.do',
			type : 'post',
			data : {
 				ipadrs : $("#kbipadr").val()+","+$("#sripadr").val()+","+$("#zipadr").val()+","+$("#bipadr").val(),
 				portnos : $("#kbportno").val()+","+$("#srportno").val()+","+$("#zportno").val()+","+$("#bportno").val(),
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
					<td align="center" class="listtd"><input type="text" name="kbipadr" id="kbipadr"></td>
					<td align="center" class="listtd"><input type="text" name="kbportno" id="kbportno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">schema registry</td>
					<td align="center" class="listtd"><input type="text" name="sripadr" id="sripadr"></td>
					<td align="center" class="listtd"><input type="text" name="srportno" id="srportno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">zookeeper</td>
					<td align="center" class="listtd"><input type="text" name="zipadr" id="zipadr"></td>
					<td align="center" class="listtd"><input type="text" name="zportno" id="zportno"></td>
				</tr>
				<tr>
					<td align="center" class="listtd">BottledWater</td>
					<td align="center" class="listtd"><input type="text" name="bipadr" id="bipadr"></td>
					<td align="center" class="listtd"><input type="text" name="bportno" id="bportno"></td>
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
			</ul>
		</div>

	</div>
</body>
</html>