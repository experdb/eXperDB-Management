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

/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
});

 
 /* ********************************************************
  * Validation Check
  ******************************************************** */
  function fn_validation(){

		if(connection != "success"){
			alert('<spring:message code="message.msg89" />');
			return false;
		}
		
 		return true;
 }

  
/* ********************************************************
 * DBMS 연결테스트
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
 * DBMS 수정
 ******************************************************** */
 	function fn_updateDBMS(){

 	 if (!fn_validation()) return false;

 	$.ajax({
  		url : "/updateDb2pgDBMS.do",
  		data : {
  			db2pg_sys_id : $("#db2pg_sys_id").val(),
  			db2pg_sys_nm : $("#db2pg_sys_nm").val(),
  			ipadr : $("#ipadr").val(),
  		 	portno : $("#portno").val(),
  		  	dtb_nm : $("#dtb_nm").val(),
  		  	scm_nm : $("#scm_nm").val(),
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
		<p class="tit">DBMS 수정</p>
		<form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DBMS 수정</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:330px;" />
				<col style="width:100px;" />
				<col />
				
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1" >시스템명</th>
					<td colspan="3"><input type="text" class="txt t2" name="db2pg_sys_nm" id="db2pg_sys_nm"  maxlength="20" value="${resultInfo[0].db2pg_sys_nm}" readonly/>
					</td>
				</tr>
							
				<tr>
					<th scope="row" class="ico_t1" >DBMS구분</th>
						<td><select name="dbms_dscd" id="dbms_dscd" class="select"  style="width:205px;" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
										<option value=""><spring:message code="common.choice" /></option>				
											<c:forEach var="result" items="${result}" varStatus="status">				
											<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${resultInfo[0].dbms_dscd_nm eq result.sys_cd_nm}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>								 
 												<%-- <option value="<c:out value="${result.sys_cd}"/><c:if test="${resultInfo[0].dbms_dscd eq result.sys_cd_nm}"> selected</c:if>" ><c:out value="${result.sys_cd_nm}"/></option> --%>
 											</c:forEach>
									</select>
						<span class="btn btnC_01" id="pgbtn"><button type="button" class= "btn_type_02" onclick="fn_pgdbmsCall()" style="width: 85px; margin-right: -60px; margin-top: 0;">불러오기</button></span></td>
				</tr>
				
				<tr>
					<th scope="row" class="ico_t1">IP</th>
					<td><input type="text" class="txt" name="ipadr" id="ipadr"  value="${resultInfo[0].ipadr}"/></td>
					<th scope="row" class="ico_t1">Database</th>
					<td><input type="text" class="txt" name="dtb_nm" id="dtb_nm" value="${resultInfo[0].dtb_nm}"/></td>
				</tr>	
				
				<tr>
				<th scope="row" class="ico_t1">스키마</th>
					<td>	
							<input type="text" class="txt" name="scm_nm" id="scm_nm" value="${resultInfo[0].scm_nm}"/>
					</td>
					<th scope="row" class="ico_t1">Port</th>
					<td><input type="text" class="txt" name="portno" id="portno" value="${resultInfo[0].portno}"/></td>
				</tr>	
				
				<tr>
					<th scope="row" class="ico_t1">User(Super)</th>
					<td><input type="text" class="txt" name="spr_usr_id" id="spr_usr_id" value="${resultInfo[0].spr_usr_id}"/></td>
					<th scope="row" class="ico_t1"><spring:message code="user_management.password" />(*)</th>
					<td><input type="password" class="txt" name="pwd" id="pwd" value="${pwd}" /></td>
				</tr>	
							
				<tr>
					<th scope="row" class="ico_t1">캐릭터셋</th>
						<td><select name="crts_nm" id="crts_nm" class="select t9">			
										<c:forEach var="dbmsChar" items="${dbmsChar}" varStatus="status">				
											<option value="<c:out value="${dbmsChar.sys_cd}"/>"<c:if test="${resultInfo[0].crts eq dbmsChar.sys_cd}"> selected</c:if>><c:out value="${dbmsChar.sys_cd_nm}"/></option>								 
 												<%-- <option value="<c:out value="${result.sys_cd}"/><c:if test="${resultInfo[0].dbms_dscd eq result.sys_cd_nm}"> selected</c:if>" ><c:out value="${result.sys_cd_nm}"/></option> --%>
 										</c:forEach>
								</select>
								<input type="hidden" name="db2pg_sys_id" id="db2pg_sys_id" value="${resultInfo[0].db2pg_sys_id}"/>
						</td>				
				</tr>			
					
			</tbody>
		</table>
		</form>
		<div class="btn_type_02">
			<span class="btn"><button type="button" onClick="fn_updateDBMS();"><spring:message code="common.modify" /></button></span>
			<span class="btn btnF_01 btnC_01"><button type="button" onClick="fn_connTest();"><spring:message code="dbms_information.conn_Test"/></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /> </span></a>
		</div>
	</div>
</div>

</body>
</html>