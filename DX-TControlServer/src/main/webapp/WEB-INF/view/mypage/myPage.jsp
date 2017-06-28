<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>개인정보수정</title>
</head>
<script>
	/* 개인정보수정 Validation */
	function fn_mypageValidation() {
		var usr_nm = document.getElementById("usr_nm");
		if (usr_nm.value == "") {
			alert("사용자명을 입력하여 주십시오.");
			usr_nm.focus();
			return false;
		}
		return true;
	}

	/*개인정보수정 저장 버튼 클릭시*/
	function fn_update() {
		if (!fn_mypageValidation())
			return false;

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
				alert("저장하였습니다.");
				
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
	
	/*패스워드변경 Validation*/
	function fn_pwdValidation(){
		var nowpwd = document.getElementById("nowpwd");
		if (nowpwd.value == "") {
			   alert("현재 패스워드를 입력하여 주십시오.");
			   nowpwd.focus();
			   return false;
		}
		var newpwd = document.getElementById("newpwd");
		if (newpwd.value == "") {
			   alert("새 패스워드를 입력하여 주십시오.");
			   newpwd.focus();
			   return false;
		}
		var pwd = document.getElementById("pwd");
		if (pwd.value == "") {
			   alert("새 패스워드 확인를 입력하여 주십시오.");
			   pwd.focus();
			   return false;
		}
		if (newpwd.value != pwd.value) {
			alert("새 패스워드 정보가 일치하지 않습니다.");
			return false;
		}
		return true;
	}
	
	/*패스워드 변경*/
	function fn_updatepwd(){
		if (!fn_pwdValidation()) return false;
		$.ajax({
			url : '/checkPwd.do',
			type : 'post',
			data : {
				nowpwd : $("#nowpwd").val()
			},
			success : function(result) {
				if(result){
					$.ajax({
						url : '/updatePwd.do',
						type : 'post',
						data : {
							pwd : $("#pwd").val()
						},
						success : function(result) {
							alert("저장하였습니다.");							
							$('#nowpwd').val('');
							$('#newpwd').val('');
							$('#pwd').val('');
							document.getElementById("pop_layer").style.visibility = "hidden";
						},
						error : function(request, status, error) {
							alert("실패");
						}
					});
				}
				else{
					alert("현재 비밀번호가 틀렸습니다.");
				}

			},
			error : function(request, status, error) {
				alert("실패");
			}
		});		
	}
</script>
<body>
	<div id="lay_mask"><!-- 마스크로 띄워질 Div --></div>
	<!--  popup -->
	<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts">
				<p class="tit">패스워드 변경하기</p>
				<table class="write">
					<caption>패스워드 변경하기</caption>
					<colgroup>
						<col style="width:120px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">현재 패스워드</th>
							<td><input type="password" class="txt" name="nowpwd" id="nowpwd" value=""/></td>
						</tr>
					</tbody>
				</table>
				<div class="pop_cmm2">
					<table class="write">
						<caption>패스워드 변경하기</caption>
						<colgroup>
							<col style="width:120px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">새 패스워드</th>
								<td><input type="password" class="txt" name="newpwd" id="newpwd" value=""/></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">새 패스워드 확인</th>
								<td><input type="password" class="txt" name="pwd" id="pwd" value=""/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_type_02">
					<span class="btn btnC_01"><button onclick="fn_updatepwd()">저장</button></span>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
	<!-- container -->
	<div id="container">
		<!-- contents -->
		<div id="contents">
			<div class="location">
				<ul>
					<li>My PAGE</li>
					<li class="on">개인정보 수정</li>
				</ul>
			</div>

			<div class="contents_wrap">
				<h4>개인정보 수정</h4>
				<div class="contents">
					<div class="cmm_grp">
						<div class="btn_type_01">
							<span class="btn"><button onclick="fn_update()">저장</button></span>
						</div>
						<table class="write2">
							<caption>개인정보 수정 저장 폼</caption>
							<colgroup>
								<col style="width: 122px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">사용자 아이디</th>
									<td>${usr_id}</td>
								</tr>
								<tr>
									<th scope="row">사용자명 (*)</th>
									<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${usr_nm}" /></td>
								</tr>
								<tr>
									<th scope="row">패스워드 (*)</th>
									<td><a href="#n" onclick="toggleLayer($('#pop_layer'), 'on');"><img src="../images/ico_pwd_ud.png" alt="패스워드변경" /></a></td>
								</tr>
								<tr>
									<th scope="row">권한 구분</th>
									<td>${aut_id}</td>
								</tr>
								<tr>
									<th scope="row">소속 (*)</th>
									<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" /></td>
								</tr>
								<tr>
									<th scope="row">부서 (*)</th>
									<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" /></td>
								</tr>
								<tr>
									<th scope="row">직급 (*)</th>
									<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" /></td>
								</tr>
								<tr>
									<th scope="row">휴대폰 번호 (*)</th>
									<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" /></td>
								</tr>
								<tr>
									<th scope="row">담당 업무 (*)</th>
									<td><input type="text" class="txt" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}" /></td>
								</tr>
								<tr>
									<th scope="row">사용자 만료일</th>
									<td>${usr_expr_dt}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- // contents -->
	</div>
	<!-- // container -->



	<%-- 	<h2>개인정보수정</h2>
	<div id="button" style="float: right;">
		<button onclick="fn_update()">저장</button>
	</div>
	<br><br>
	<table border="1px solid #ccc" width="500px" style="border-collapse: collapse;">
		<tr>
			<td>사용자아이디</td>
			<td><input type="text" name="usr_id" id="usr_id" value="${usr_id}" readonly="readonly"></td>
		</tr>
		<tr>
			<td>사용자명(*)</td>
			<td><input type="text" name="usr_nm" id="usr_nm" value="${usr_nm}"></td>
		</tr>
		<tr>
			<td>패스워드(*)</td>
			<td><button type="button" onclick="fn_pwdPopup()">패스워드변경</button></td>
		</tr>
		<tr>
			<td>권한구분</td>
			<td><input type="text" name="aut_id" id="aut_id" value="${aut_id}" readonly="readonly"></td>
		</tr>
		<tr>
			<td>소속(*)</td>
			<td><input type="text" name="bln_nm" id="bln_nm" value="${bln_nm}"></td>
		</tr>
		<tr>
			<td>부서(*)</td>
			<td><input type="text" name="dept_nm" id="dept_nm" value="${dept_nm}"></td>
		</tr>
		<tr>
			<td>직급(*)</td>
			<td><input type="text" name="pst_nm" id="pst_nm" value="${pst_nm}"></td>
		</tr>
		<tr>
			<td>휴대폰번호(*)</td>
			<td><input type="text" name="cpn" id="cpn" value="${cpn}"></td>
		</tr>
		<tr>
			<td>담당업무(*)</td>
			<td><input type="text" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}"></td>
		</tr>
		<tr>
			<td>사용자만료일</td>
			<td><input type="text" name="usr_expr_dt" id="usr_expr_dt" value="${usr_expr_dt}" readonly="readonly"></td>
		</tr>
	</table> --%>
</body>
</html>