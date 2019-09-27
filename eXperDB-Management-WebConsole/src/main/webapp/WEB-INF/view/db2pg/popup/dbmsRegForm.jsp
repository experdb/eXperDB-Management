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
var table = null;
var connCheck = "fail";
var idCheck = "fail";
var db_svr_nmChk ="fail";

var agentPort = null;
var ipadr = null;
var port = null;

/* var pghomeCheck="fail";
var pgdataCheck ="fail"; */



/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	$("#pgbtn").hide();
});

$(function() {
	//DBMS구분 PG일경우 불러오기 버튼 호출	
	$( ".select" ).change(function() {
		if($("#bck_opt_cd").val() == "POG"){
			$("#pgbtn").show();
		}else{
			$("#pgbtn").hide();
		}
	});
});

/* ********************************************************
 * 시스템명 중복체크
 ******************************************************** */
 
 
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
	 $('#db_nm').val(pgDBMS[0].db_nm);
	 $('#portno').val(pgDBMS[0].portno);
	 $('#svr_spr_usr_id').val(pgDBMS[0].svr_spr_usr_id);
	 $('#svr_spr_scm_pwd').val(pgDBMS[0].svr_spr_scm_pwd);
 }
 
 /* ********************************************************
  * Validation Check
  ******************************************************** */
 
/* ********************************************************
 * Source DBMS 연결테스트
 ******************************************************** */
 
/* ********************************************************
 * Source DBMS 등록
 ******************************************************** */
 
 
</script>

</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Source DBMS 등록</p>
		<form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>Source DBMS 등록</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:330px;" />
				<col style="width:100px;" />
				<col />
				
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1" >시스템명</th>
					<td colspan="3"><input type="text" class="txt t3" name="db_svr_nm" id="db_svr_nm"  maxlength="20"   style="width:635px" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_svrnmCheck()" style="width: 85px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span></td>
				</tr>
							
				<tr>
					<th scope="row" class="ico_t1" >DBMS구분</th>
						<td><select name="bck_opt_cd" id="bck_opt_cd" class="select"  style="width:205px;" >
										<option value=""><spring:message code="common.choice" /></option>
										<option value="ORA">Oracle</option>
										<option value="MSS">MS-SQL</option>
										<option value="MYS">MySQL</option>
										<option value="POG">PostgreSQL</option>
										<option value="DB2">DB2</option>
										<option value="CUB">Cubrid</option>
										<option value="TBR">Tibero</option>
									</select>
						<span class="btn btnC_01" id="pgbtn"><button type="button" class= "btn_type_02" onclick="fn_pgdbmsCall()" style="width: 85px; margin-right: -60px; margin-top: 0;">불러오기</button></span></td>
				</tr>
				
				<tr>
					<th scope="row" class="ico_t1">IP</th>
					<td><input type="text" class="txt" name="ipadr" id="ipadr" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
					<th scope="row" class="ico_t1">Database</th>
					<td><input type="text" class="txt" name="db_nm" id="db_nm" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
				</tr>	
				
				<tr>
				<th scope="row" class="ico_t1">스키마</th>
					<td><input type="text" class="txt" name="schema" id="schema" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
					<th scope="row" class="ico_t1">Port</th>
					<td><input type="text" class="txt" name="portno" id="portno" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
				</tr>	
				
				<tr>
					<th scope="row" class="ico_t1">User(Super)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id" maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>"/></td>
					<th scope="row" class="ico_t1"><spring:message code="user_management.password" />(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>	
							
				<tr>
					<th scope="row" class="ico_t1">케릭터셋</th>
						<td><select name="" id="" class="select"  style="width:725px" >
										<option value=""><spring:message code="common.choice" /></option>
						
									</select>
						</td>				
				</tr>			
					
			</tbody>
		</table>
		</form>
		<div class="btn_type_02">
			<span class="btn"><button type="button" onClick="fn_insertDbServer();"><spring:message code="common.registory" /></button></span>
			<span class="btn btnF_01 btnC_01"><button type="button" onClick="fn_dbServerConnTest();"><spring:message code="dbms_information.conn_Test"/></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /> </span></a>
		</div>
	</div>
</div>

</body>
</html>