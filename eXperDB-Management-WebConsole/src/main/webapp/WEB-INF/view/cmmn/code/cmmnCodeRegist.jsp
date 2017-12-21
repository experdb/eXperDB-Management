<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>공통코드 등록</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
<script type="text/javaScript" language="javascript" defer="defer"></script>
</head>
<script type="text/javascript">

/**********************************************************
 * 목록 으로 가기
 *********************************************************/
function fn_cmmnCodeList(){
	location.href = "<c:url value='/cmmnCodeList.do' />";
}



/* ********************************************************
 * 저장 하기
 ******************************************************** */
function fn_egov_regist_CmmnCode(){
	
				if(fnCheckNotKorean(document.insertCmmnCode.grp_cd.value)){
					window.alert("코드에 한글을 사용할 수 없습니다.");
					document.insertCmmnCode.grp_cd.select();
					return;
				}
				
				if(fnCheck(document.insertCmmnCode.grp_cd.value)){
					window.alert("코드에 특수문자를 사용할 수 없습니다.");
					document.insertCmmnCode.grp_cd.select();
					return;
				}
				
				if(confirm("코드를 등록하시겠습니까?")){
					frm = document.insertCmmnCode;
					frm.action = "/insertCmmnCode.do";
					frm.submit();
				}
		}
	
	
/* 한글입력 체크 */
function fnCheckNotKorean(koreanStr){
    for(var i=0;i<koreanStr.length;i++){
        var koreanChar = koreanStr.charCodeAt(i);
        if( !( 0xAC00 <= koreanChar && koreanChar <= 0xD7A3 ) && !( 0x3131 <= koreanChar && koreanChar <= 0x318E ) ) {
        }else{
            //한글이 있을때
            return true;
        }
    }
    return false;
}


/* 특수문자체크 */
function fnCheck(str){
    var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
    if(special_pattern.test(str)){
    	/* 걸리면 true반환 */
        return true;
    } else {
   		return false;
	}
}

</script>
<body>
		<!-- contents -->
		<div id="contents">
				<div class="location">
				<ul>
					<li>그룹코드 등록</li>
				</ul>
			</div>
			<div class="contents_wrap">
			<h4>그룹코드 등록</h4>
			<div class="contents">
			<form name="insertCmmnCode" id="insertCmmnCode" method="post">
				<div class="contsBody">
					<div class="Btn">
						<span class="bbsBtn"><a href="javascript:fn_cmmnCodeList()">목록</a></span>
						<span class="bbsBtn"><a
							href="javascript:fn_egov_regist_CmmnCode();">등록</a></span>
					</div>

					<div class="bbsDetail">
						<table>
							<colgroup>
								<col style="width: 20%">
								<col style="width: auto">
							</colgroup>
							<tbody>

								<tr>
									<th><img src="/images/egovframework/example/blt4.gif"
										alt="필수입력" />코드ID</th>
									<td colspan="3"><input type="text" size="10"
										maxlength="10" name="grp_cd" id="grp_cd" /></td>
								</tr>

								<tr>
									<th><img src="/images/egovframework/example/blt4.gif"
										alt="필수입력" />코드명</th>
									<td><input type="text" size="60" maxlength="60"
										name="grp_cd_nm" id="grp_cd_nm" /></td>
								</tr>

								<tr>
									<th><img src="/images/egovframework/example/blt4.gif"
										alt="필수입력" />코드설명</th>
									<td><textarea rows="3" cols="60" id="grp_cd_exp"
											name="grp_cd_exp"></textarea></td>
								</tr>

								<tr>
									<th><img src="/images/egovframework/example/blt4.gif"
										alt="필수입력" />사용여부</th>
									<td colspan="3"><select name="use_yn" id="use_yn">
											<option value="Y">사용</option>
											<option value="N">미사용</option>
									</select></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
			</div>
			</div>
		</div>
</body>
</html>
