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
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../css/common.css">
<script type="text/javascript" src="../../js/common.js"></script>

<title>eXperDB</title>
<script type="text/javascript">
//연결테스트 확인여부
var connCheck = "fail";
var idCheck = "fail";

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
 		var istpath = document.getElementById("istpath");
 		if (istpath.value == "") {
  			   alert("저장경로를 입력하여 주십시오.");
  			 istpath.focus();
  			   return false;
  		}	
 		return true;
}


// DBserver 등록
function fn_insertDbServer(){

	if (!fn_dbServerValidation()) return false;
	
	if(connCheck == "success" && idCheck == "success"){
  	$.ajax({
		url : "/insertDbServer.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			ipadr : $("#ipadr").val(),
			portno : $("#portno").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			istpath : $("#istpath").val()
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
	}else{
		alert("IP중복확인 / 연결 테스트 후 등록이 가능합니다.")
	}
} 


//DBserver 연결테스트
function fn_dbServerConnTest(){
	
	if (!fn_dbServerValidation()) return false;

	$.ajax({
		url : "/dbServerConnTest.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			ipadr : $("#ipadr").val(),
			portno : $("#portno").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			istpath : $("#istpath").val(),
			check : "i",
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
			alert("[ 연결 테스트 실패! ]");
			return false;
			}		
			alert(result.result_data);
		}
	}); 

}


//DBserver 취소
function fn_dbServerCancle(){
	document.dbserverInsert.reset();
}


//아이디 중복체크
function fn_ipCheck() {
	var ipadr = document.getElementById("ipadr");
	if (ipadr.value == "") {
		alert("IP를 입력하세요.");
		document.getElementById('ipadr').focus();
		return;
	}
	$.ajax({
		url : '/dbServerIpCheck.do',
		type : 'post',
		data : {
			ipadr : $("#ipadr").val()
		},
		success : function(result) {
			if (result == "true") {
				alert("등록가능한 IP 입니다.");
				document.getElementById("ipadr").focus();
				idCheck = "success";
			} else {
				alert("중복된 IP가 존재합니다.");
				document.getElementById("ipadr").focus();
			}
		},
		error : function(request, status, error) {
			alert("실패");
		}
	});
}
	
	
/* ********************************************************
 * 저장경로의 존재유무 체크
 ******************************************************** */
function checkFolder(){
	var save_pth = $("#istpath").val();
	if(save_pth == ""){
		alert("저장경로를 입력해 주세요.");
		$("#istpath").focus();
	}else{
		$.ajax({
			async : false,
			url : "/isDirCheck.do",
		  	data : {
				db_svr_nm : $("#db_svr_nm").val(),
				dft_db_nm : $("#dft_db_nm").val(),
				ipadr : $("#ipadr").val(),
				portno : $("#portno").val(),
				svr_spr_usr_id : $("#svr_spr_usr_id").val(),
				svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
		  		path : save_pth
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
			},
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA == 0){
						$("#check_path").val("Y");
						alert("입력하신 경로는 존재합니다.");
					}else{
						alert("입력하신 경로는 존재하지 않습니다.");
					}
				}else{
					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
				}
			}
		});
	}
}	
</script>
</head>
<body>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">DB Server 등록하기</p>
		<form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DB Server 등록하기</caption>
			<colgroup>
				<col style="width:100px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1">서버명(*)</th>
					<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" /></td>
					<th scope="row" class="ico_t1">Database(*)</th>
					<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">IP(*)</th>
					<td><input type="text" class="txt" name="ipadr" id="ipadr" style="width:230px"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_ipCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
					</td>
					<th scope="row" class="ico_t1">Port(*)</th>
					<td><input type="text" class="txt" name="portno" id="portno" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">User(*)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id" /></td>
					<th scope="row" class="ico_t1">Password(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">서버 설치경로</th>
					<td>
					<input type="text" class="txt" name="istpath" id="istpath" style="width:640px" /></td>
					<th scope="row" class="ico_t1"></th>
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
					</td>					
				</tr>
			</tbody>
		</table>
		</form>
		<div class="btn_type_02">
			<span class="btn"><button onClick="fn_insertDbServer();">저장</button></span>
			<span class="btn btnF_01 btnC_01"><button onClick="fn_dbServerConnTest();">연결테스트</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>