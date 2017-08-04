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
	var idCheck = null;
	var act = "${act}";
	
	/* Validation */
	function fn_userManagerValidation(formName){
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
		return true;	
	}
	
	//등록버튼 클릭시
	function fn_insert() {
		
		if (!fn_userManagerValidation()) return false;	
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
				usr_expr_dt : $("#datepicker1").val(),
				use_yn : $("#use_yn").val(),
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
				opener.fn_select();
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}
	
	//수정버튼 클릭시
	function fn_update() {
		if (!fn_userManagerValidation()) return false;	
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
					usr_expr_dt : $("#datepicker1").val(),
					use_yn : $("#use_yn").val(),
				},
				success : function(result) {
					alert("수정하였습니다.");
					window.close();
					opener.fn_select();
				},
				error : function(request, status, error) {
					alert("실패");
				}
			});
	}
	
	//아이디 중복체크
	function fn_idCheck() {
		idCheck = 1;
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
				} else {
					alert("중복된 사용자아이디가 존재합니다.");
					document.getElementById("usr_id").focus();
					idCheck = 0;
				}
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}

	$(function() {
		window.onload = function() {
			if (act == "i") {
				document.getElementById("usr_id").focus();
				$("#usr_nm").attr("onfocus", "idcheck_alert();");
				$("#pwd").attr("onfocus", "idcheck_alert();");
				$("#pwdCheck").attr("onfocus", "idcheck_alert();");
				$("#bln_nm").attr("onfocus", "idcheck_alert();");
				$("#dept_nm").attr("onfocus", "idcheck_alert();");
				$("#pst_nm").attr("onfocus", "idcheck_alert();");
				$("#rsp_bsn_nm").attr("onfocus", "idcheck_alert();");
				$("#cpn").attr("onfocus", "idcheck_alert();");
				$("#use_yn").attr("onfocus", "idcheck_alert();");
			}
		};
	});

	function idcheck_alert() {
		if (idCheck != 1) {
			alert("아이디를 입력한 후 중복 체크를 해주세요");
			document.getElementById('usr_id').focus();
		}
	}
	
	$(window.document).ready(function() {
		$.datepicker.setDefaults({
			dateFormat: 'yymmdd'
		});
		
	})
</script>
<body>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			<c:if test="${act == 'i'}">사용자 등록하기</c:if>
			<c:if test="${act == 'u'}">사용자 수정하기</c:if>
		</p>
		<table class="write">
			<caption>
				<c:if test="${act == 'i'}">사용자 등록하기</c:if>
				<c:if test="${act == 'u'}">사용자 수정하기</c:if>
			</caption>
			<colgroup>
				<col style="width:100px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1">사용자아이디</th>
					<td>
						<c:if test="${act == 'i'}">
							<input type="text" class="txt" name="usr_id" id="usr_id" value="${get_usr_id}" style="width: 230px;"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_idCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
						</c:if>
						<c:if test="${act == 'u'}">
							<input type="text" class="txt" name="usr_id" id="usr_id" value="${get_usr_id}" readonly="readonly"/>
						</c:if>							
					</td>
					<th scope="row" class="ico_t1">사용자명</th>
					<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${usr_nm}"/></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">패스워드</th>
					<td><input type="password" class="txt" name="pwd" id="pwd" value="${pwd}"/></td>
					<th scope="row" class="ico_t1">패스워드확인</th>
					<td><input type="password" class="txt" name="pwdCheck" id="pwdCheck" value="${pwd}"/></td>
				</tr>
			</tbody>
		</table>
		<div class="pop_cmm2">
			<table class="write">
				<caption>사용자 등록하기</caption>
				<colgroup>
					<col style="width:100px;" />
					<col />
					<col style="width:100px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">소속</th>
						<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" /></td>
						<th scope="row" class="ico_t1">부서</th>
						<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" /></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">직급</th>
						<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" /></td>
						<th scope="row" class="ico_t1">담당업무</th>
						<td><input type="text" class="txt" name="rsp_bsn_nm" id="rsp_bsn_nm" value="${rsp_bsn_nm}" /></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">휴대폰번호</th>
						<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" /></td>
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
								<a href="#n" class="calendar_btn">달력열기</a>
								<input type="text" class="calendar" id="datepicker1" title="사용자 만료일 날짜 검색"  value="${usr_expr_dt}" readonly />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01">
				<c:if test="${act == 'i'}"><button type="button" onclick="fn_insert()">등록</button></c:if> 
				<c:if test="${act == 'u'}"><button type="button" onclick="fn_update()">수정</button></c:if> 
			</span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>