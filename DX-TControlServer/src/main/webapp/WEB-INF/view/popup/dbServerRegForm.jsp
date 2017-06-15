<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbServerRegForm.jsp
	* @Description : 디비 서버 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.01     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
<title>Insert title here</title>
<script type="text/javascript">
//연결테스트 확인여부
var connCheck = 0;

//숫자체크
function valid_numeric(objValue)
{
	if (objValue.match(/^[0-9]+$/) == null)
	{	return false;	}
	else
	{	return true;	}
}


function fn_dbServerValidation(){
	var db_svr_nm = document.getElementById("db_svr_nm");
		if (db_svr_nm.value == "") {
			   alert("서버명을 입력하여 주십시오.");
			   db_svr_nm.focus();
			   return false;
		}
		var dft_db_nm = document.getElementById("dft_db_nm");
 		if (dft_db_nm.value == "") {
  			   alert("데이터베이스명을 입력하여 주십시오.");
  			 dft_db_nm.focus();
  			   return false;
  		}
 		var ipadr = document.getElementById("ipadr");
 		if (ipadr.value == "") {
  			   alert("IP를 입력하여 주십시오.");
  			 ipadr.focus();
  			   return false;
  		}

 		var portno = document.getElementById("portno");
		if (portno.value == "") {
			   alert("포트를 입력하여 주십시오.");
			   portno.focus();
			   return false;
		}
 		if(!valid_numeric(portno.value))
	 	{
 			 alert("포트는 숫자만 입력가능합니다.");
 			portno.focus();
		 	return false;
		}

		var svr_spr_usr_id = document.getElementById("svr_spr_usr_id");
 		if (svr_spr_usr_id.value == "") {
  			   alert("유저명을 입력하여 주십시오.");
  			 svr_spr_usr_id.focus();
  			   return false;
  		}
 		var svr_spr_scm_pwd = document.getElementById("svr_spr_scm_pwd");
 		if (svr_spr_scm_pwd.value == "") {
  			   alert("비밀번호를 입력하여 주십시오.");
  			 svr_spr_scm_pwd.focus();
  			   return false;
  		}		
 		return true;
}



function fn_insertDbServer(){

	if (!fn_dbServerValidation()) return false;
	
  	$.ajax({
		url : "/insertDbServer.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			ipadr : $("#ipadr").val(),
			portno : $("#portno").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val()
		},
		type : "post",
		error : function(xhr, status, error) {
			alert("실패");
		},
		success : function(result) {
			opener.location.reload();
			self.close();	 
		}
	}); 
} 


	
</script>
</head>
<body>
<h3>DB 서버 등록</h3>


<!--메인 등록 폼  -->
<table style="border: 1px solid black; padding: 10px;" width="100%">
	<tr>
	  	<td class="tbtd_caption1">◎서버명(*)</td>
	  	<td class="tbtd_content"> <input type="text" name="db_svr_nm" id="db_svr_nm"></td>
	 	<td class="tbtd_caption1">◎Database(*) </td>
	 	<td class="tbtd_content"> <input type="text" name="dft_db_nm" id="dft_db_nm"></td>
	</tr>
	<tr>
	  	<td class="tbtd_caption1">◎IP(*)</td>
	  	<td class="tbtd_content"><input type="text" name="ipadr" id="ipadr"></td>
	 	<td class="tbtd_caption1">◎Port(*)</td>
	 	<td class="tbtd_content"><input type="text" name="portno" id="portno"></td>
	</tr>
	<tr>
	  	<td class="tbtd_caption1">◎User(*)</td>
	  	<td class="tbtd_content"><input type="text" name="svr_spr_usr_id" id="svr_spr_usr_id"></td>
	 	<td class="tbtd_caption1">◎Password(*)</td>
	 	<td class="tbtd_content"><input type="password" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd"></td>
	</tr>		
</table>

<table style="padding: 10px;" width="100%">
	<tr>
		<td>	 	 		
 			<div id="button" align="center">
 				<a href="#" onClick="fn_insertDbServer();"><input type="button" value="저장"  id="btnSelect"></a>
				<a href="#" onClick="fn_dbServerConnTest();"><input type="button" value="연결테스트"></a>
				<input type="button" value="취소">
			</div>
		 </td>
	</tr>
</table>
<!--/메인 등록 폼  -->


</body>
</html>