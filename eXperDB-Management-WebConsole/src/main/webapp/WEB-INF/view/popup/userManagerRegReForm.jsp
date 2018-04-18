<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : userManagerRegReForm.jsp
	* @Description : userManagerRegReForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자 정보 수정</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<script>
	/* PW Validation*/
	function fn_pwValidation(str){
		 var reg_pwd = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,20}/;
		 if(!reg_pwd.test(str)){
		 	alert("<spring:message code='message.msg109' />");
		 	return false;
		 }
		 	return true;
	}
	
	/* Validation */
	function fn_userManagerValidation() {
		var nm = document.getElementById('usr_nm');
		var pwd = document.getElementById('pwd');
		var pwdCheck = document.getElementById('pwdCheck'); 
		var nowpwd ="${pwd}";
			
		
		if (nm.value == "" || nm.value == "undefind" || nm.value == null) {
			alert("<spring:message code='message.msg58' />");
			nm.focus();
			return false;
		}		
		
		if (pwd.value == "" || pwd.value == "undefind" || pwd.value == null) {
			alert("<spring:message code='message.msg140'/>");
			pwd.focus();
			return false;
		}
		
		if(pwd.value!=nowpwd){
			if (!fn_pwValidation(pwd.value))return false;
			if (!fn_pwValidation(pwdCheck.value))return false;
		}
					
		if (pwdCheck.value == "" || pwdCheck.value == "undefind" || pwdCheck.value == null) {
			alert('<spring:message code="message.msg141"/>');
			pwd.focus();
			return false;
		}
			
		if (pwd.value != pwdCheck.value) {
			alert("<spring:message code='etc.etc14'/>");
			return false;
		}

		return true;
	}

	
	//수정버튼 클릭시
	function fn_update() {
		var session_usr_id = "<%=(String)session.getAttribute("usr_id")%>"
		var usr_id=$("#usr_id").val();
		if(usr_id=='admin'){
			if(session_usr_id!=usr_id){
				alert("<spring:message code='message.msg120' />");
				return false;
			}
		}

		if (!fn_userManagerValidation())return false;
		if (!confirm("<spring:message code='message.msg147'/>")) return false;
		
		$.ajax({
			url : '/updateUserManager.do',
			type : 'post',
			data : {
				usr_id : $("#usr_id").val(),
				usr_nm : $("#usr_nm").val(),
				pwd : $("#pwd").val(),
				bln_nm : $("#bln_nm").val(),
				dept_nm : $("#dept_nm").val(),
				pst_nm : $("#pst_nm").val(),
				rsp_bsn_nm : $("#rsp_bsn_nm").val(),
				cpn : $("#cpn").val(),
				// 				aut_id : $("#aut_id").val(),
				usr_expr_dt : $("#datepicker3").val(),
				use_yn : $("#use_yn").val(),
				encp_use_yn : $("#encp_use_yn").val()
			},
			success : function(result) {
				if(result.resultCode == 0000000000){
					alert("<spring:message code='message.msg84' />");
					window.close();
					opener.fn_select();
				}else{
					alert(result.resultMessage);
					return false;
				}
				
			},
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
			}
		});
	}


	$(window.document).ready(function() {
		$.datepicker.setDefaults({
			dateFormat : 'yy-mm-dd',
// 			changeMonth: true, 
			changeYear: true,
			yearRange: '2018:2099',
		});
		$("#datepicker3").datepicker();
	})
	
	function NumObj(obj) {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			(event.preventDefault) ? event.preventDefault() : event.returnValue = false;
		}
	}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="user_management.userMod"/></p>
			<table class="write">
				<caption><spring:message code="user_management.userMod"/></caption>
				<colgroup>
					<col style="width: 110px;" />
					<col />
					<col style="width: 140px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="user_management.id" />(*)</th>
						<td>
							<input type="text" class="txt" name="usr_id" id="usr_id" value="${get_usr_id}" readonly="readonly" />
						</td>
						<th scope="row" class="ico_t1"><spring:message code="user_management.user_name" />(*)</th>
						<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${get_usr_nm}" maxlength="9" onkeyup="fn_checkWord(this,9)" placeholder="9<spring:message code='message.msg188'/>"/></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="user_management.password" />(*)</th>
						<td><input type="password" class="txt" name="pwd" id="pwd" value="${pwd}" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="<spring:message code='message.msg109'/>"/></td>
						<th scope="row" class="ico_t1"><spring:message code="user_management.confirm_password" />(*)</th>
						<td><input type="password" class="txt" name="pwdCheck" id="pwdCheck" value="${pwd}" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="<spring:message code='message.msg109'/>" /></td>
					</tr>
				</tbody>
			</table>
			<div class="pop_cmm2">
				<table class="write">
					<caption><spring:message code="user_management.userReg"/></caption>
					<colgroup>
						<col style="width: 110px;" />
						<col />
						<col style="width: 140px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="user_management.company" /></th>
							<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="user_management.department" /></th>
							<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="user_management.position" /></th>
							<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="user_management.Responsibilities" /></th>
							<td><input type="text" class="txt" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"/></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="user_management.mobile_phone_number" /></th>
							<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" maxlength="20"  onKeyPress="NumObj(this);" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>"/></td>
							<th scope="row" class="ico_t1"><spring:message code="dbms_information.use_yn" /></th>
							<td>
								<select class="select" id="use_yn" name="use_yn">
									<option value="Y" ${use_yn == 'Y' ? 'selected="selected"' : ''}><spring:message code="dbms_information.use" /></option>
									<option value="N" ${use_yn == 'N' ? 'selected="selected"' : ''}><spring:message code="dbms_information.unuse" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="user_management.expiration_date" /></th>
							<td>
								<div class="calendar_area big">
									<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker3" title="사용자 만료일 날짜 검색" value="${usr_expr_dt}" readonly />
								</div>
							</td>
							<c:if test = "${encp_yn eq 'Y'}">
								<th scope="row" class="ico_t1">Encrypt <spring:message code="user_management.use_yn" /></th>
								<td>
									<select class="select" id="encp_use_yn" name="encp_use_yn">
										<option value="Y" ${encp_use_yn == 'Y' ? 'selected="selected"' : ''}><spring:message code="dbms_information.use" /></option>
										<option value="N" ${encp_use_yn == 'N' ? 'selected="selected"' : ''}><spring:message code="dbms_information.unuse" /></option>
									</select>
								</td>
							</c:if>
							<c:if test = "${empty encp_yn}">
								<th scope="row" class="ico_t1">Encrypt <spring:message code="user_management.use_yn" /></th>
								<td>
									<select class="select" id="encp_use_yn" name="encp_use_yn" disabled="disabled">
										<option value="Y" ${encp_use_yn == 'Y' ? 'selected="selected"' : ''}><spring:message code="dbms_information.use" /></option>
										<option value="N" ${encp_use_yn == 'N' ? 'selected="selected"' : ''}><spring:message code="dbms_information.unuse" /></option>
									</select>
								</td>
							</c:if>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01">
				<button type="button" onclick="fn_update()"><spring:message code="button.modify" /></button>
				</span> <a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>			
			</div>
		</div>
	</div>
</body>
</html>