<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : securityPolicyRegForm.jsp
	* @Description : securityPolicyRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>암복호화 정책 등록</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>

$(window.document).ready(function() {
	var cipherAlgorithmCode = document.getElementById("cipherAlgorithmCode");
	fn_changeBinUid(cipherAlgorithmCode);
	
	if("${act}" =='u'){
		if("${length}" == '끝까지'){
			$("#last").prop('checked', true) ;
			$('#length').attr('disabled', true);
		}else{
			$('#length').val('${length}');
		}
	}
});

/*숫자체크*/
function NumObj(obj) {
	if (event.keyCode >= 48 && event.keyCode <= 57) {
		return true;
	} else {
		event.returnValue = false;
	}
}

/*validation 체크*/
function fn_validation(){
	var offset = document.getElementById('offset');
	var length = document.getElementById('length');
	var cipherAlgorithmCode = document.getElementById('cipherAlgorithmCode');
	var binUid = document.getElementById('binUid');
	
	if (offset.value == "" || offset.value == "undefind" || offset.value == null) {
		alert("시작위치를 입력해주세요.");
		offset.focus();
		return false;
	}
	
	if($("input:checkbox[id='last']").is(":checked")){
		$('#length').val('끝까지');
	}
	
	if (length.value == "" || length.value == "undefind" || length.value == null) {
		alert("길이를 입력해주세요.");
		length.focus();
		return false;
	}
	
	if (binUid.value == "" || binUid.value == "undefind" || binUid.value == null) {
		alert("암호화키를 먼저 등록해주세요.");
		return false;
	}
	
	return true;
	
}

/*저장버튼 클릭시*/
function fn_save(){
	if (!fn_validation()) return false;
	
	Result = new Object();
	
	Result.offset = $("#offset").val();
	Result.length = $("#length").val();
	Result.cipherAlgorithmCode = $("#cipherAlgorithmCode").val();
	Result.binUid = $("#binUid").val();
	Result.initialVectorTypeCode = $("#initialVectorTypeCode").val();
	Result.operationModeCode = $("#operationModeCode").val();
	
	var returnCheck= opener.fn_SecurityAdd(Result);
	if(returnCheck==true){
		window.close();
	}else{
		$('#length').val('');
		$("#last").prop('checked', false) ;
		$('#length').attr('disabled', false);
		alert("길이가 [끝까지]인 경우는 하나의 시작위치에만 지정할 수 있습니다.");
	}
}

/*수정버튼 클릭시*/
function fn_update(){
	if (!fn_validation()) return false;
	
	Result = new Object();
	
	Result.rnum = "${rnum}";
	Result.offset = $("#offset").val();
	Result.length = $("#length").val();
	Result.cipherAlgorithmCode = $("#cipherAlgorithmCode").val();
	Result.binUid = $("#binUid").val();
	Result.initialVectorTypeCode = $("#initialVectorTypeCode").val();
	Result.operationModeCode = $("#operationModeCode").val();
	
	var returnCheck= opener.fn_SecurityUpdate(Result);   
	if(returnCheck==true){
		window.close();
	}
}

/*길이 끝까지 선택시*/
function fn_lastCheck(){
	if($("input:checkbox[id='last']").is(":checked")){
		$('#length').val('');
		$('#length').attr('disabled', 'true');
	}else{
		$('#length').removeAttr('disabled');
	}
}

/*알고리즘 선택시*/
function fn_changeBinUid(selectObj){
	$("#binUid").empty();
	var html = "";
	<c:forEach var="binUid" items="${binUid.data}">
	if(selectObj.value == "${binUid.cipherAlgorithmName}"){
		html += "<option value=${binUid.resourceName}>${binUid.resourceName}</option>"
	}
	</c:forEach> 
	$("#binUid").append(html);
}

</script>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">암복호화 정책 등록</p>
			<table class="write">
				<caption>암복호화 정책 등록</caption>
				<colgroup>
					<col style="width: 130px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">시작위치</th>
						<td><input type="text" class="txt" name="offset" id="offset" onKeyPress="NumObj(this);" value="${offset}"/></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">길이</th>
						<td>
							<input type="text" class="txt" name="length" id="length" onKeyPress="NumObj(this);"/> 
							<div class="inp_chk">
								<input type="checkbox" id="last" name="last" onchange="fn_lastCheck()"/>
								<label for="last">끝까지</label>	
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">암호화 알고리즘</th>
						<td>
							<select class="select" id="cipherAlgorithmCode" name="cipherAlgorithmCode" onChange="fn_changeBinUid(this)">
								<c:forEach var="cipherAlgorithmCode" items="${cipherAlgorithmCode}" varStatus="status">
									<option value="<c:out value="${cipherAlgorithmCode.sysCodeName}"/>" ${cipherAlgorithmCodeValue eq cipherAlgorithmCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${cipherAlgorithmCode.sysCodeName}"/></option>
								</c:forEach> 
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">암호화 키</th>
						<td>
							<select class="select" id="binUid" name="binUid"></select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">초기 벡터</th>
						<td>
							<select class="select" id="initialVectorTypeCode" name="initialVectorTypeCode">
								<c:forEach var="initialVectorTypeCode" items="${initialVectorTypeCode}">
									<option value="${initialVectorTypeCode.sysCodeName}" ${initialVectorTypeCodeValue eq initialVectorTypeCode.sysCodeName ? "selected='selected'" : ""}/><c:out value="${initialVectorTypeCode.sysCodeName}"/></option>
								</c:forEach> 
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">운영모드</th>
						<td>
							<select class="select" id="operationModeCode" name="operationModeCode">
								<c:forEach var="operationModeCode" items="${operationModeCode}">
									<option value="${operationModeCode.sysCodeName}" ${operationModeCodeValue eq operationModeCode.sysCodeName ? "selected='selected'" : ""}><c:out value="${operationModeCode.sysCodeName}"/></option>
								</c:forEach> 
							</select>
						</td>
					</tr>
				</tbody>
			</table>

			<div class="btn_type_02">
				<c:if test="${act == 'i'}">
					<a href="#n" class="btn"><span onclick="fn_save()">저장</span></a> 
				</c:if>
				<c:if test="${act == 'u'}">
					<a href="#n" class="btn"><span onclick="fn_update()">수정</span></a> 
				</c:if>
				<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
			</div>
		</div>
	</div>
</body>
</html>