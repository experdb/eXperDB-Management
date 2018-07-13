<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../cmmn/cs.jsp"%>

<%
	/**
	* @Class Name : myPage.jsp
	* @Description : myPage 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.20
	*
	*/
%>
<script>
	/* 패스워드변경 버튼 클릭시*/
	function fn_pwdPopup(){
	var popUrl = "/popup/pwdRegForm.do"; // 서버 url 팝업경로
	var width = 950;
	var height = 410;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	window.open(popUrl,"",popOption);
}
	
	/* 개인정보수정 Validation */
	function fn_mypageValidation() {
		var usr_nm = document.getElementById("usr_nm");
		if (usr_nm.value == "") {
			alert('<spring:message code="message.msg58" /> ');
			usr_nm.focus();
			return false;
		}
		return true;
	}

	/*개인정보수정 저장 버튼 클릭시*/
	function fn_update() {
		if (!fn_mypageValidation())return false;
		$.ajax({
			url : '/updateMypage.do',
			type : 'post',
			data : {
				usr_id : '${usr_id}',
				usr_nm : $("#usr_nm").val(),
				bln_nm : $("#bln_nm").val(),
				dept_nm : $("#dept_nm").val(),
				pst_nm : $("#pst_nm").val(),
				cpn : $("#cpn").val(),
				rsp_bsn_nm : $("#rsp_bsn_nm").val()
			},
			success : function(result) {
				alert('<spring:message code="message.msg57" />');
				
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
</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.user_information_management" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.user_information_management" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>My PAGE</li>
					<li class="on"><spring:message code="menu.user_information_management" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button type="button" onclick="fn_update()"><spring:message code="common.save"/></button></span>
				</div>
				<table class="write2">
					<caption>개인정보 수정 저장 폼</caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message code="user_management.id" /> (*)</th>
							<td>${usr_id}</td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.user_name" /> (*)</th>
							<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${usr_nm}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.password" /> (*)</th>
							<td><span class="btn btnC_01 btnF_02"><button type="button" onclick="fn_pwdPopup()"><spring:message code="user_management.edit_password" /></button></span></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.company" /></th>
							<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="history_management.department" /></th>
							<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.position" /></th>
							<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.mobile_phone_number" /></th>
							<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.Responsibilities" /> </th>
							<td><input type="text" class="txt" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="user_management.expiration_date" /></th>
							<td>${usr_expr_dt}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>