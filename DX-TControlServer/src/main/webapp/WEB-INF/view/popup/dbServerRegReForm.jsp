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
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../css/common.css">
<script type="text/javascript" src="../../js/common.js"></script>
<title>eXperDB</title>
<script type="text/javascript">

var connCheck = "fail";

$(window.document).ready(function() {
	
	
	var db_svr_id = <%= request.getParameter("db_svr_id") %>

    $.ajax({
		url : "/selectDbServerList.do",
		data : {
			db_svr_id : parseInt(db_svr_id)
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
			document.getElementById('istpath').value= result[0].istpath;
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
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			istpath : $("#istpath").val(),
			check : "u",
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
	
	if(connCheck == "success"){
	
	$.ajax({
		url : "/updateDbServer.do",
		data : {
			db_svr_id: $("#db_svr_id").val(),
			db_svr_nm: $("#db_svr_nm").val(),
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
			alert("수정 되었습니다.");
			self.close();			
		}
	}); 
	}else{
		alert("연결 테스트 성공후 수정이 가능합니다.")
	}
}


/* ********************************************************
 * 저장경로의 존재유무 체크
 ******************************************************** */
function checkFolder(){
	var save_pth = $("#save_pth").val();
	if(save_pth == ""){
		alert("저장경로를 입력해 주세요.");
		$("#save_pth").focus();
	}else{
		$.ajax({
			async : false,
			url : "/existDirCheck.do",
		  	data : {
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
		<p class="tit">DB Server 수정하기</p>
		 <form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DB Server 수정하기</caption>
			<colgroup>
				<col style="width:100px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1">서버명(*)</th>
					<td><input type="text" class="txt bg1" name="db_svr_nm" id="db_svr_nm"  readonly="readonly"  /></td>
					<th scope="row" class="ico_t1">Database(*)</th>
					<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">IP(*)</th>
					<td><input type="text" class="txt" name="ipadr" id="ipadr" style="width:300px"/></td>
					<th scope="row" class="ico_t1">Port(*)</th>
					<td><input type="text" class="txt" name="portno" id="portno" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">User(*)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id"  /></td>
					<th scope="row" class="ico_t1">Password(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">서버 설치경로</th>
					<td><input type="text" class="txt" name="save_pth" id="save_pth" style="width:700px" /></td>		
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
					</td>					
				</tr>
			</tbody>
		</table>
		<input type="hidden" id="db_svr_id" name="db_svr_id">
		</form>
		<div class="btn_type_02">
			<span class="btn"><button onClick="fn_updateDbServer();">저장</button></span>
			<span class="btn btnF_01 btnC_01"><button onClick="fn_dbServerConnTest();">연결테스트</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>
</body>
</html>