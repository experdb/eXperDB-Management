<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
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
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type="text/css" media="screen" href="/css/dt/jquery.dataTables.min.css"/>
<link rel = "stylesheet" type="text/css" media="screen" href="/css/dt/dataTables.jqueryui.min.css"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
<style>
#serverIpadr_wrapper{
	width:725px;
}
</style>
<script type="text/javascript">

//연결테스트 확인여부
var connection = "fail";

var table = null;
var db2pg_sys_nmChk = "fail";

/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	$("#pgbtn").hide();
	$("#schema_any").show();
	$("#schema_pg").hide();
});



/* ********************************************************
 * 시스템명 중복체크
 ******************************************************** */
 function fn_sysnmCheck(){

		if (db2pg_sys_nm.value == "") {
			alert('시스템명을 입력해주세요. ');
			document.getElementById('db2pg_sys_nm').focus();
			return;
		}
		
		$.ajax({
			url : '/db2pg_sys_nmCheck.do',
			type : 'post',
			data : {
				db2pg_sys_nm : $("#db2pg_sys_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert('등록가능한 시스템 명입니다.');
					document.getElementById("db2pg_sys_nm").focus();
					db2pg_sys_nmChk = "success";
				} else {
					db2pg_sys_nmChk = "fail";
					alert('중복된 시스템명이 존재합니다.');
					document.getElementById("db2pg_sys_nm").focus();
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
}
 
 /* ********************************************************
  * 기 등록된 PostgreSQL 서버 호출 팝업 (현재는 등록되어 있는 PG모두)
  ******************************************************** */
 function fn_pgdbmsCall(){
		var popUrl = "/db2pg/popup/pgDbmsRegForm.do"; // 서버 url 팝업경로
		var width = 1000;
		var height = 700;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);			
}
 
 
 /* ********************************************************
  * 기 등록된 PostgreSQL 서버 호출하여 입력
  ******************************************************** */
 function fn_pgDbmsAddCallback(pgDBMS){
	 
	 $('#ipadr').val(pgDBMS[0].ipadr);
	 $('#dtb_nm').val(pgDBMS[0].db_nm);
	 $('#portno').val(pgDBMS[0].portno);
	 $('#spr_usr_id').val(pgDBMS[0].svr_spr_usr_id);
	 $('#pwd').val(pgDBMS[0].svr_spr_scm_pwd);
	 
	 $.ajax({
			url : "/selectPgSchemaList.do",
			data : {
				ipadr : pgDBMS[0].ipadr,
				dtb_nm : pgDBMS[0].db_nm,
				portno : pgDBMS[0].portno,
				spr_usr_id : pgDBMS[0].svr_spr_usr_id,
				pwd : pgDBMS[0].svr_spr_scm_pwd
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {		
				$("#schema_any").hide();
				$("#schema_pg").show();
				$('#schema_pg').empty();
				for(var i=0; i<result.data.length; i++){
					$('<option value="'+ result.data[i].schema +'">' + result.data[i].schema + '</option>').appendTo('#schema_pg');
					}
			}
		});  
 }
 
 /* ********************************************************
  * DBMS선택시 해당 케릭터셋 출력
  ******************************************************** */
function fn_charSet(){

	$('#ipadr').val('');
	$('#dtb_nm').val('');
	$('#spr_usr_id').val('');
	$('#portno').val('');
	$('#pwd').val('');
	$('#schema_pg').val('');
	$('#schema_any').val('');
	 
	//DBMS구분 PG일경우 불러오기 버튼 호출		
	if($("#dbms_dscd").val() == "TC002204"){
		$("#pgbtn").show();
	}else{
		$("#pgbtn").hide();
		$("#schema_any").show();
		$("#schema_pg").hide();
	}
	
	 var dbms_dscd = $("#dbms_dscd option:selected").val();

	 $.ajax({
			url : "/selectCharSetList.do",
			data : {
				dbms_dscd : dbms_dscd
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
		 		$('#crts_nm').empty();
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$('<option value="'+ result[i].sys_cd+'">' + result[i].sys_cd_nm + '</option>').appendTo('#crts_nm');
						}
				}else{

				} 
			}
		}); 
 }
  
  
 /* ********************************************************
  * Validation Check
  ******************************************************** */
  function fn_validation(){

		if(connection != "success"){
			alert('<spring:message code="message.msg89" />');
			return false;
		}
		
		 if (db2pg_sys_nmChk =="fail") {
			 alert('시스템명 중복체크 바랍니다.');
			 return false;
		 }	 
		 
		var ipadr = document.getElementById("ipadr");
		if (ipadr.value == "") {
			   alert('아이피를 입력해주세요.');
			   ipadr.focus();
			   return false;
		}
		
		var dtb_nm = document.getElementById("dtb_nm");
 		if (dtb_nm.value == "") {
  			   alert('데이터베이스명을 입력해주세요.');
  			 dft_db_nm.focus();
  			   return false;
  		}


		if($("#dbms_dscd").val()  == 'TC002204'){
			var schema_pg = document.getElementById("schema_pg");
	 		if (schema_pg.value == "") {
	  			   alert('스키마명을 입력해주세요.');
	  			 schema_pg.focus();
	  			   return false;
	  		}
		}else{
			var schema_any = document.getElementById("schema_any");
	 		if (schema_any.value == "") {
	  			   alert('스키마명을 입력해주세요.');
	  			 schema_any.focus();
	  			   return false;
	  		}
		}
		
 		var portno = document.getElementById("portno");
		if (portno.value == "") {
			alert('포트를 입력해주세요.');
			portno.focus();
			return false;
		}
 		if(!valid_numeric(portno.value))
	 	{
 			alert('<spring:message code="message.msg49" />');
 			portno.focus();
		 	return false;
		}		
 		
 		var spr_usr_id = document.getElementById("spr_usr_id");
 		if (spr_usr_id.value == "") {
  			   alert('유저명을 입력해주세요.');
  			 spr_usr_id.focus();
  			   return false;
  		}		
 		
 		var pwd = document.getElementById("pwd");
 		if (pwd.value == "") {
  			   alert('패스워드를 입력해주세요.');
  			 pwd.focus();
  			   return false;
  		}	
 		
 		return true;
 }
  
  /* ********************************************************
   * Validation Check 숫자체크
   ******************************************************** */
  function valid_numeric(objValue)
  {
  	if (objValue.match(/^[0-9]+$/) == null)
  	{	return false;	}
  	else
  	{	return true;	}
  } 
  
  
/* ********************************************************
 * Source DBMS 연결테스트
 ******************************************************** */
 function fn_connTest(){
     $.ajax({
 		url : "/dbmsConnTest.do",
 		data : {
 		 	ipadr : $("#ipadr").val(),
 		 	portno : $("#portno").val(),
 		  	dtb_nm : $("#dtb_nm").val(),
 		   	spr_usr_id : $("#spr_usr_id").val(),
 		   	pwd : $("#pwd").val(),
 		  	dbms_dscd : $("#dbms_dscd").val()
 		},
 		type : "post",
 		beforeSend: function(xhr) {
 	        xhr.setRequestHeader("AJAX", true);
 	     },
 		error : function(xhr, status, error) {
 			if(xhr.status == 401) {
 				alert('<spring:message code="message.msg02" />');
 				top.location.href = "/";
 			} else if(xhr.status == 403) {
 				alert('<spring:message code="message.msg03" />');
 				top.location.href = "/";
 			} else {
 				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
 			}
 		},
 		success : function(result) {
 			if(result.RESULT_CODE == 0){		
 				connection= "success";
 				alert('<spring:message code="message.msg93" />');		
 			}else{
 				connection = "fail";
	 			alert(result.ERR_MSG);
 				return false;
 			}		
 		}
 	});     
 }
 

/* ********************************************************
 * DBMS 등록
 ******************************************************** */
 	function fn_insertDBMS(){

 		// Validation 체크
 		 if (!fn_validation()) return false;

 		if($("#dbms_dscd").val()  == 'TC002204'){
 			var scm_nm = document.getElementById("schema_pg").value;
 		}else{
 			var scm_nm = document.getElementById("schema_any").value;	
 		}
 		
 	$.ajax({
  		url : "/insertDb2pgDBMS.do",
  		data : {
  		 	db2pg_sys_nm : $("#db2pg_sys_nm").val(),
  			ipadr : $("#ipadr").val(),
  		 	portno : $("#portno").val(),
  		  	dtb_nm : $("#dtb_nm").val(),
  		  	scm_nm : scm_nm,
  		   	spr_usr_id : $("#spr_usr_id").val(),
  		   	pwd : $("#pwd").val(),
  		  	dbms_dscd : $("#dbms_dscd").val(),
  		  	crts_nm : $("#crts_nm").val()
  		},
  		type : "post",
  		beforeSend: function(xhr) {
  	        xhr.setRequestHeader("AJAX", true);
  	     },
  		error : function(xhr, status, error) {
  			if(xhr.status == 401) {
  				alert('<spring:message code="message.msg02" />');
  				top.location.href = "/";
  			} else if(xhr.status == 403) {
  				alert('<spring:message code="message.msg03" />');
  				top.location.href = "/";
  			} else {
  				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
  			}
  		},
  		success : function(result) {
  			alert("<spring:message code='message.msg07' />");
  			opener.location.reload();
			self.close();	 	
  		}
  	});    
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
				<col style="width:130px;" />
				<col style="width:330px;" />
				<col style="width:100px;" />
				<col />
				
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1" >시스템명</th>
					<td colspan="3"><input type="text" class="txt t3" name="db2pg_sys_nm" id="db2pg_sys_nm"  maxlength="20"   style="width:635px" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_sysnmCheck()" style="width: 85px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span></td>
				</tr>
							
				<tr>
					<th scope="row" class="ico_t1" >DBMS구분</th>
						<td><select name="dbms_dscd" id="dbms_dscd" class="select"  style="width:205px;" onChange ="fn_charSet()">
										<option value=""><spring:message code="common.choice" /></option>				
											<c:forEach var="result" items="${result}" varStatus="status">												 
 												<option value="<c:out value="${result.sys_cd}"/>" ><c:out value="${result.sys_cd_nm}"/></option>
 											</c:forEach>
									</select>
						<span class="btn btnC_01" id="pgbtn"><button type="button" class= "btn_type_02" onclick="fn_pgdbmsCall()" style="width: 85px; margin-right: -60px; margin-top: 0;">불러오기</button></span></td>
				</tr>
				
				<tr>
					<th scope="row" class="ico_t1">IP</th>
					<td><input type="text" class="txt" name="ipadr" id="ipadr" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
					<th scope="row" class="ico_t1">Database</th>
					<td><input type="text" class="txt" name="dtb_nm" id="dtb_nm" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
				</tr>	
				
				<tr>
				<th scope="row" class="ico_t1">스키마</th>
					<td>	
							<input type="text" class="txt" name="scm_nm" id="schema_any" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/>
							<select name="scm_nm" id="schema_pg" class="select">
							</select>
					</td>
					<th scope="row" class="ico_t1">Port</th>
					<td><input type="text" class="txt" name="portno" id="portno" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
				</tr>	
				
				<tr>
					<th scope="row" class="ico_t1">User(Super)</th>
					<td><input type="text" class="txt" name="spr_usr_id" id="spr_usr_id" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
					<th scope="row" class="ico_t1"><spring:message code="user_management.password" />(*)</th>
					<td><input type="password" class="txt" name="pwd" id="pwd" /></td>
				</tr>	
							
				<tr>
					<th scope="row" class="ico_t1">케릭터셋</th>
						<td><select name="crts_nm" id="crts_nm" class="select"  style="width:725px" >						
									</select>
						</td>				
				</tr>			
					
			</tbody>
		</table>
		</form>
		<div class="btn_type_02">
			<span class="btn"><button type="button" onClick="fn_insertDBMS();"><spring:message code="common.registory" /></button></span>
			<span class="btn btnF_01 btnC_01"><button type="button" onClick="fn_connTest();"><spring:message code="dbms_information.conn_Test"/></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /> </span></a>
		</div>
	</div>
</div>

</body>
</html>