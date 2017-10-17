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
var db_svr_nmChk ="fail";

var pghomeCheck="fail";
var pgdataCheck ="fail";


/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	
  	$.ajax({
		url : "/selectIpList.do",
		data : {},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "
						+ xhr.status
						+ "\n\n"
						+ "ERROR Message : "
						+ error
						+ "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(
								/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			$("#ipadr").children().remove();
			$("#ipadr").append("<option value='%'>선택</option>");
			if(result.length > 0){
				for(var i=0; i<result.length; i++){
					$("#ipadr").append("<option value='"+result[i].ipadr+"'>"+result[i].ipadr+"</option>");	
				}									
			}
			$("#ipadr").val(ipadr).attr("selected", "selected");
		}
	});
});

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
		}else if(db_svr_nmChk != "success"){
			alert("서버명 중복검사를 하셔야합니다.");
			return false;
		}
		var dft_db_nm = document.getElementById("dft_db_nm");
 		if (dft_db_nm.value == "") {
  			   alert("데이터베이스명을 입력하여 주십시오.");
  			 dft_db_nm.focus();
  			   return false;
  		}
/*  		var ipadr = document.getElementById("ipadr");
 		if (ipadr.value == "") {
  			   alert("IP를 입력하여 주십시오.");
  			 ipadr.focus();
  			   return false;
  		}else if(idCheck != "success"){
			alert("IP 중복검사를 하셔야합니다.");
			return false;
		} */

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
 		var pghome_pth = document.getElementById("pghome_pth");
 		if (pghome_pth.value == "") {
  			   alert("PG_HOME 경로를 입력하여 주십시오.");
  			 pghome_pth.focus();
  			   return false;
  		}else if(pghomeCheck != "success"){
			alert("PG_HOME경로 중복검사를 하셔야합니다.");
			return false;
		}
 		var pgdata_pth = document.getElementById("pgdata_pth");
 		if (pgdata_pth.value == "") {
  			  alert("PG_DATA경로를 입력하여 주십시오.");
  			 pgdata_pth.focus();
  			   return false;
  		}else if(pgdataCheck != "success"){
			alert("PG_DATA경로 중복검사를 하셔야합니다.");
			return false;
		}
 		if(connCheck != "success"){
			alert("연결테스트를 하셔야합니다.");
			return false;
		}
 		return true;
}


// DBserver 등록
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
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			pghome_pth : $("#pghome_pth").val(),
			pgdata_pth : $("#pgdata_pth").val()
		},
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(result) {
			opener.location.reload();
			self.close();	 			
		}
	}); 
} 


//DBserver 연결테스트
function fn_dbServerConnTest(){
	
	//if (!fn_dbServerValidation()) return false;

	$.ajax({
		url : "/dbServerConnTest.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			ipadr : $("#ipadr").val(),
			portno : $("#portno").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			pghome_pth : $("#pghome_pth").val(),
			pgdata_pth : $("#pgdata_pth").val(),
			check : "i",
		},
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
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
function fn_ipadrChange() {
	var ipadr = document.getElementById("ipadr");

	$.ajax({
		url : '/dbServerIpCheck.do',
		type : 'post',
		data : {
			ipadr : $("#ipadr").val()
		},
		success : function(result) {
			if (result == "true") {
				idCheck = "success";
				fn_getHostNm($("#ipadr").val());
			} else {
				document.getElementById("db_svr_nm").value = "";
				alert("중복된 IP가 존재합니다.");
				return false;
			}			
		},
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		}
	});
}
	
	
//호스트명 가져오기
function fn_getHostNm(ipadr) {
	$.ajax({
		url : '/getHostNm.do',
		type : 'post',
		data : {
			ipadr : ipadr
		},
		success : function(result) {
			document.getElementById("db_svr_nm").value = result.host;
		},
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		}
	});
}
	
//서버명 중복체크
function fn_svrnmCheck() {
	var db_svr_nm = document.getElementById("db_svr_nm");
	if (db_svr_nm.value == "") {
		alert("서버명을 입력하세요.");
		document.getElementById('db_svr_nm').focus();
		return;
	}
	$.ajax({
		url : '/db_svr_nmCheck.do',
		type : 'post',
		data : {
			db_svr_nm : $("#db_svr_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert("등록가능한 서버명 입니다.");
				document.getElementById("db_svr_nm").focus();
				db_svr_nmChk = "success";
			} else {
				alert("중복된 서버명이 존재합니다.");
				document.getElementById("db_svr_nm").focus();
			}
		},
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		}
	});
}

	
/* ********************************************************
 * PG_HOME 경로의 존재유무 체크
 ******************************************************** */
function checkPghome(){
	var save_pth = $("#pghome_pth").val();
	if(save_pth == ""){
		alert("저장경로를 입력해 주세요.");
		$("#pghome_pth").focus();
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
		  		path : save_pth,
		  		flag : "r"
		  	},
			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(data) {				
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY== 0){
						$("#check_path").val("Y");
						pghomeCheck = "success";
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


/* ********************************************************
 * PG_DATA 경로의 존재유무 체크
 ******************************************************** */
 function checkPgdata(){
		var save_pth = $("#pgdata_pth").val();
		if(save_pth == ""){
			alert("저장경로를 입력해 주세요.");
			$("#pgdata_pth").focus();
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
			  		path : save_pth,
			  		flag : "r"
			  	},
				type : "post",
				error : function(request, status, error) {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				},
				success : function(data) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							$("#check_path").val("Y");
							pgdataCheck = "success";
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
		<p class="tit">DBMS 등록</p>
		<form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DBMS 등록</caption>
			<colgroup>
				<col style="width:120px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1">DBMS 아이피(*)</th>
					<td>
						<select class="select"  id="ipadr" name="ipadr" onChange="fn_ipadrChange();" >
							<option value="%">선택</option>
						</select>
					</td>
<!-- 					<td><input type="text" class="txt" name="ipadr" id="ipadr" style="width:230px"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_ipCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
					</td> -->
					<th scope="row" class="ico_t1" style="width: 60px; margin-right: -160px; margin-top: 0;">Database(*)</th>
					<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1" >DBMS명(*)</th>
					<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm"  style="width:230px"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_svrnmCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span></td>
					<th scope="row" class="ico_t1">포트(*)</th>
					<td><input type="text" class="txt" name="portno" id="portno" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">계정(*)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id" /></td>
					<th scope="row" class="ico_t1">Password(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">PG_HOME경로(*)</th>
					<td>
					<input type="text" class="txt" name="pghome_pth" id="pghome_pth" style="width:640px" /></td>
					<th scope="row" class="ico_t1"></th>
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkPghome()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
					</td>					
				</tr>
				<tr>
					<th scope="row" class="ico_t1">PG_DATA경로(*)</th>
					<td>
					<input type="text" class="txt" name="pgdata_pth" id="pgdata_pth" style="width:640px" /></td>
					<th scope="row" class="ico_t1"></th>
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkPgdata()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
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