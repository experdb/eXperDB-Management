<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : userManagerForm.jsp
	* @Description : UserManagerForm 화면
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
<title>사용자 정보 등록/수정</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>

<!-- 달력을 사용 script -->
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/calendar.js"></script>
</head>
<script>
	var idCheck = 0;
	var act = "${act}";

	/* Validation */
	function fn_userManagerValidation(formName) {
		var id = document.getElementById('usr_id');
		var nm = document.getElementById('usr_nm');
		var pwd = document.getElementById('pwd');
		var pwdCheck = document.getElementById('pwdCheck');

		if (id.value == "" || id.value == "undefind" || id.value == null) {
			alert("사용자 아이디를 넣어주세요");
			id.focus();
			return false;
		}
		if (nm.value == "" || nm.value == "undefind" || nm.value == null) {
			alert("사용자명을 넣어주세요");
			nm.focus();
			return false;
		}
		if (pwd.value == "" || pwd.value == "undefind" || pwd.value == null) {
			alert("패스워드를 넣어주세요");
			pwd1.focus();
			return false;
		}
		if (pwdCheck.value == "" || pwdCheck.value == "undefind" || pwdCheck.value == null) {
			alert("패스워드확인을 넣어주세요");
			pwd.focus();
			return false;
		}
		if (pwd.value != pwdCheck.value) {
			alert("패스워드 정보가 일치하지 않습니다.");
			return false;
		}
		if (idCheck != 1) {
			alert("아이디를 입력 후 중복체크를 해주세요.");
			return false;
		}
		return true;
	}

	//등록버튼 클릭시
	function fn_insert() {
		if (!fn_userManagerValidation())return false;
		if (!confirm("등록하시겠습니까?")) return false;
		$.ajax({
			url : '/insertUserManager.do',
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
			},
			success : function(result) {
				alert("등록하였습니다.");
				if (confirm("사용자에게 메뉴권한을 주시겠습니까?")) {
					window.close();
					opener.location.href = "/menuAuthority.do?usr_id="+$("#usr_id").val();
				} else {
					window.close();
					opener.fn_select();
				}
			},
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
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}

	//수정버튼 클릭시
	function fn_update() {
		var session_usr_id = "<%=(String)session.getAttribute("usr_id")%>"
		var usr_id=$("#usr_id").val();
		if(usr_id=='admin'){
			if(session_usr_id!=usr_id){
				alert("관리자는 수정할 수 없습니다.");
				return false;
			}
		}
		
		idCheck = 1;
		if (!fn_userManagerValidation())return false;
		if (!confirm("수정하시겠습니까?")) return false;
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
			},
			success : function(result) {
				alert("수정하였습니다.");
				window.close();
				opener.fn_select();
			},
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
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}

	//아이디 중복체크
	function fn_idCheck() {
		var usr_id = document.getElementById("usr_id");
		if (usr_id.value == "") {
			alert("사용자 아이디를 넣어주세요");
			document.getElementById('usr_id').focus();
			idCheck = 0;
			return;
		}
		$.ajax({
			url : '/UserManagerIdCheck.do',
			type : 'post',
			data : {
				usr_id : $("#usr_id").val()
			},
			success : function(result) {
				if (result == "true") {
					alert("사용자아이디를 사용하실 수 있습니다.");
					document.getElementById("usr_nm").focus();
					idCheck = 1;
				} else {
					alert("중복된 사용자아이디가 존재합니다.");
					document.getElementById("usr_id").focus();
					idCheck = 0;
				}
			},
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
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}

	$(window.document).ready(function() {
		$.datepicker.setDefaults({
			dateFormat : 'yy-mm-dd',
		});
		$("#datepicker3").datepicker();
	})
	
	function NumObj(obj) {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			event.returnValue = false;
		}
	}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">
				<c:if test="${act == 'i'}">사용자 등록</c:if>
				<c:if test="${act == 'u'}">사용자 수정</c:if>
			</p>
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}">사용자 등록</c:if>
					<c:if test="${act == 'u'}">사용자 수정</c:if>
				</caption>
				<colgroup>
					<col style="width: 110px;" />
					<col />
					<col style="width: 110px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">사용자아이디(*)</th>
						<td>
							<c:if test="${act == 'i'}">
								<input type="text" class="txt" name="usr_id" id="usr_id" value="${get_usr_id}" maxlength="15" style="width: 230px;" />
								<span class="btn btnC_01"><button type="button" class="btn_type_02" onclick="fn_idCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
							</c:if> 
							<c:if test="${act == 'u'}">
								<input type="text" class="txt" name="usr_id" id="usr_id" value="${get_usr_id}" readonly="readonly" />
							</c:if>
						</td>
						<th scope="row" class="ico_t1">사용자명(*)</th>
						<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${get_usr_nm}" maxlength="9" /></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">패스워드(*)</th>
						<td><input type="password" class="txt" name="pwd" id="pwd" value="${pwd}" maxlength="50" /></td>
						<th scope="row" class="ico_t1">패스워드확인(*)</th>
						<td><input type="password" class="txt" name="pwdCheck" id="pwdCheck" value="${pwd}" maxlength="50" /></td>
					</tr>
				</tbody>
			</table>
			<div class="pop_cmm2">
				<table class="write">
					<caption>사용자 등록</caption>
					<colgroup>
						<col style="width: 100px;" />
						<col />
						<col style="width: 100px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1">소속</th>
							<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" maxlength="25" /></td>
							<th scope="row" class="ico_t1">부서</th>
							<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" maxlength="25" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">직급</th>
							<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" maxlength="25" /></td>
							<th scope="row" class="ico_t1">담당업무</th>
							<td><input type="text" class="txt" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}" maxlength="25" /></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">휴대폰번호</th>
							<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" maxlength="20"  onKeyPress="NumObj(this);"/></td>
							<th scope="row" class="ico_t1">사용여부</th>
							<td>
								<select class="select" id="use_yn" name="use_yn">
									<option value="Y" ${use_yn == 'Y' ? 'selected="selected"' : ''}>사용</option>
									<option value="N" ${use_yn == 'N' ? 'selected="selected"' : ''}>미사용</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">사용자만료일</th>
							<td>
								<div class="calendar_area big">
									<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker3" title="사용자 만료일 날짜 검색" value="${usr_expr_dt}" readonly />
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01"> <c:if test="${act == 'i'}">
						<button type="button" onclick="fn_insert()">등록</button>
					</c:if> <c:if test="${act == 'u'}">
						<button type="button" onclick="fn_update()">수정</button>
					</c:if>
				</span> <a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>			
			</div>
		</div>
	</div>
	
<div id="loading"><img src="/images/spin.gif" alt="" /></div>
</body>
</html>