<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : accessControlRegForm.jsp
	* @Description : accessControlRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근제어 등록/수정 팝업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>
	/* Validation */
	function fn_accessControl(){
		var prms_ipadr = document.getElementById("prms_ipadr");	
		var prms_ipadr_val = prms_ipadr.value;
		if (prms_ipadr_val == "") {
			   alert("IP를 입력하여 주십시오.");
			   prms_ipadr.focus();
			   return false;
		}
		
		//ABCDEF0123456789 
		// '/'하나만 체크
		var checkFlag = prms_ipadr_val.indexOf('/');
		if(checkFlag<0){
			alert("형식에 맞게 입력하여 주십시오.");
			prms_ipadr.focus();
			return false;
		}	
		return true;
	}
	
	/* 등록 버튼 클릭시*/
	function fn_insert() {
		if (!fn_accessControl()) return false;
		$.ajax({
			url : "/insertAccessControl.do",
			data : {
				db_svr_id : '${db_svr_id}',
				db_id : '${db_id}',
				prms_ipadr : $("#prms_ipadr").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val(),
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
				opener.fn_select();
			}
		});
	}

	/* 수정 버튼 클릭시*/
	function fn_update() {
		if (!fn_accessControl()) return false;
		$.ajax({
			url : "/updateAccessControl.do",
			data : {
				prms_seq : '${prms_seq}',
				db_svr_id : '${db_svr_id}',
				db_id : '${db_id}',
				prms_ipadr : $("#prms_ipadr").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val(),
				cmd_cnts : $("#cmd_cnts").val(),
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
				opener.fn_select();
			}
		});
	}
</script>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
			<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
		</p>
		<div class="pop_cmm">
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
					<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
				</caption>
				<colgroup>
					<col style="width:85px;" />
					<col />
					<col style="width:85px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">서버명</th>
						<td><input type="text" class="txt bg1" value="${db_svr_nm}" readonly="readonly"/></td>
						<th scope="row" class="ico_t1">Database</th>
						<td><input type="text" class="txt bg1 t4" value="${db_nm}" readonly="readonly"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
					<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
				</caption>
				<colgroup>
					<col style="width:110px;" />
					<col />
					<col style="width:85px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">IP<br>(127.0.0.1/32)</th>
						<td><input type="text" class="txt" name="prms_ipadr" id="prms_ipadr" value="${prms_ipadr}"/></td>
						<th scope="row" class="ico_t1">User</th>
						<td>
									
							<select id="prms_usr_id" name="prms_usr_id" class="select t4">
								<option value="all" ${prms_usr_id == 'all' ? 'selected="selected"' : ''}>all</option>
								<c:forEach var="result" items="${result.data}">
									<option value="${result.rolname}" ${prms_usr_id eq result.rolname ? "selected='selected'" : ""}>${result.rolname}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Method</th>
						<td>
							<select id="ctf_mth_nm" name="ctf_mth_nm" id="ctf_mth_nm" class="select">
								<option value="trust"  ${ctf_mth_nm == 'trust' ? 'selected="selected"' : ''}>trust</option>
								<option value="reject" ${ctf_mth_nm == 'reject' ? 'selected="selected"' : ''}>reject</option>
								<option value="md5" ${ctf_mth_nm == 'md5' ? 'selected="selected"' : ''}>md5</option>
								<option value="password" ${ctf_mth_nm == 'password' ? 'selected="selected"' : ''}>password</option>
								<option value="Krb4" ${ctf_mth_nm == 'Krb4' ? 'selected="selected"' : ''}>Krb4</option>
								<option value="krb5" ${ctf_mth_nm == 'krb5' ? 'selected="selected"' : ''}>krb5</option>
								<option value="ident" ${ctf_mth_nm == 'ident' ? 'selected="selected"' : ''}>ident</option>
								<option value="pam" ${ctf_mth_nm == 'pam' ? 'selected="selected"' : ''}>pam</option>
								<option value="ldap" ${ctf_mth_nm == 'ldap' ? 'selected="selected"' : ''}>ldap</option>
								<option value="gss" ${ctf_mth_nm == 'gss' ? 'selected="selected"' : ''}>gss</option>
								<option value="Sspi" ${ctf_mth_nm == 'Sspi' ? 'selected="selected"' : ''}>Sspi</option>
								<option value="cert" ${ctf_mth_nm == 'cert' ? 'selected="selected"' : ''}>cert</option>
								<option value="crypt" ${ctf_mth_nm == 'crypt' ? 'selected="selected"' : ''}>crypt</option>
								<option value="radius" ${ctf_mth_nm == 'radius' ? 'selected="selected"' : ''}>radius</option>
								<option value="peer" ${ctf_mth_nm == 'peer' ? 'selected="selected"' : ''}>peer</option>
							</select>
						</td>
						<th scope="row" class="ico_t1">Type</th>
						<td>					
							<select id="ctf_tp_nm" name="ctf_tp_nm" id="ctf_tp_nm" class="select t4">
								<option value="local" ${ctf_tp_nm == 'local' ? 'selected="selected"' : ''}>local</option>
								<option value="host" ${ctf_tp_nm == 'host' ? 'selected="selected"' : ''}>host</option>
								<option value="hostssl" ${ctf_tp_nm == 'hostssl' ? 'selected="selected"' : ''}>hostssl</option>
								<option value="hostnossl" ${ctf_tp_nm == 'hostnossl' ? 'selected="selected"' : ''}>hostnossl</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Option</th>
						<td colspan="3"><input type="text" class="txt t4" name="opt_nm" id="opt_nm" value="${opt_nm}"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01">					
				<c:if test="${act == 'i'}">
					<button type="button" onclick="fn_insert()">저장</button>
				</c:if>
				<c:if test="${act == 'u'}">
					<button type="button" onclick="fn_update()">저장</button>
				</c:if>
			</span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>