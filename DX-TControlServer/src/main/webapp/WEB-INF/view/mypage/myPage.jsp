<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	var width = 920;
	var height = 430;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	window.open(popUrl,"",popOption);
}
	
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
				alert("저장하였습니다.");
				
			},
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		});
	}
</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>사용자정보관리<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>- 현재 로그인한 사용자의 정보를 조회 또는 수정합니다.</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>My PAGE</li>
					<li class="on">사용자정보관리</li>
				</ul>
			</div>
		</div>

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
							<th scope="row">사용자 아이디 (*)</th>
							<td>${usr_id}</td>
						</tr>
						<tr>
							<th scope="row">사용자명 (*)</th>
							<td><input type="text" class="txt" name="usr_nm" id="usr_nm" value="${usr_nm}" /></td>
						</tr>
						<tr>
							<th scope="row">패스워드 (*)</th>
							<td><a href="#n" onclick="fn_pwdPopup()"><img src="../images/ico_pwd_ud.png" alt="패스워드변경" /></a></td>
						</tr>
						<tr>
							<th scope="row">소속</th>
							<td><input type="text" class="txt" name="bln_nm" id="bln_nm" value="${bln_nm}" /></td>
						</tr>
						<tr>
							<th scope="row">부서</th>
							<td><input type="text" class="txt" name="dept_nm" id="dept_nm" value="${dept_nm}" /></td>
						</tr>
						<tr>
							<th scope="row">직급</th>
							<td><input type="text" class="txt" name="pst_nm" id="pst_nm" value="${pst_nm}" /></td>
						</tr>
						<tr>
							<th scope="row">휴대폰 번호</th>
							<td><input type="text" class="txt" name="cpn" id="cpn" value="${cpn}" /></td>
						</tr>
						<tr>
							<th scope="row">담당 업무</th>
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