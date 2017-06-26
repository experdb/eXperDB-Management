<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbServerRegReForm.jsp
	* @Description : 디비 서버 수정 화면
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

var connCheck = "fail";

$(window.document).ready(function() {
	
	
	var db_svr_id = <%= request.getParameter("db_svr_id") %>

    $.ajax({
		url : "/selectDbServerList.do",
		data : {
			db_svr_id : parseInt(db_svr_id),
		},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			document.getElementById('db_svr_id').value= result[0].db_svr_id;
			document.getElementById('db_svr_nm').value= result[0].db_svr_nm;
			document.getElementById('dft_db_nm').value= result[0].dft_db_nm;
			document.getElementById('ipadr').value= result[0].ipadr;
			document.getElementById('portno').value= result[0].portno;
			document.getElementById('svr_spr_usr_id').value= result[0].svr_spr_usr_id;
			document.getElementById('svr_spr_scm_pwd').value= result[0].svr_spr_scm_pwd;
		}
	});   

});


//DBserver 연결테스트
function fn_dbServerConnTest(){
	
	$.ajax({
		url : "/dbServerConnTest.do",
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
			if(result.result_code == 0){
			connCheck = "success"
			}else{
			connCheck = "fail"
			alert("[연결 테스트 실패!]");
			return false;
			}		
			alert(result.result_data);
		}
	}); 

}


//DBserver 수정
function fn_updateDbServer(){
	
	//if(connCheck == "success"){
	
	$.ajax({
		url : "/updateDbServer.do",
		data : {
			db_svr_id: $("#db_svr_id").val(),
			db_svr_nm: $("#db_svr_nm").val(),
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
			alert("수정 되었습니다.");
			//opener.location.reload();
			opener.fn_search();
			self.close();			
		}
	}); 
	//}else{
	//	alert("연결 테스트 성공후 수정이 가능합니다.")
	//}
}



</script>
</head>
<body>
<h3>DB 서버 수정</h3>

 <form name="dbserverInsert" id="dbserverInsert" method="post">
<!--메인 등록 폼  -->
<table style="border: 1px solid black; padding: 10px;" width="100%">

	<tr>
	  	<td class="tbtd_caption1">◎서버명(*)</td>
	  	<td class="tbtd_content"> <input type="text" name="db_svr_nm" id="db_svr_nm"  readonly="readonly" style="background-color: rgba(211, 211, 211, 1)"></td>
	 	<td class="tbtd_caption1">◎Database(*) </td>
	 	<td class="tbtd_content"> <input type="text" name="dft_db_nm" id="dft_db_nm" ></td>
	</tr>
	<tr>
	  	<td class="tbtd_caption1">◎IP(*)</td>
	  	<td class="tbtd_content"><input type="text" name="ipadr" id="ipadr" ></td>
	 	<td class="tbtd_caption1">◎Port(*)</td>
	 	<td class="tbtd_content"><input type="text" name="portno" id="portno" ></td>
	</tr>
	<tr>
	  	<td class="tbtd_caption1">◎User(*)</td>
	  	<td class="tbtd_content"><input type="text" name="svr_spr_usr_id" id="svr_spr_usr_id" ></td>
	 	<td class="tbtd_caption1">◎Password(*)</td>
	 	<td class="tbtd_content"><input type="password" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" ></td>
	</tr>		
</table>

<table style="padding: 10px;" width="100%">
	<tr>
		<td>	 	 		
 			<div id="button" align="center">
 				<a href="#" onClick="fn_updateDbServer();"><input type="button" value="수정"  id="btnSelect"></a>
				<a href="#" onClick="fn_dbServerConnTest();"><input type="button" value="연결테스트"></a>
				<a href="#" onClick="fn_dbServerCancle();"><input type="button" value="취소"></a>
			</div>
		 </td>
	</tr>
</table>
<!--/메인 등록 폼  -->

<input type="hidden" id="db_svr_id" name="db_svr_id">
</form>
</body>
</html>