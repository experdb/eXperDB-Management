<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : scaleExecuteForm.jsp
	* @Description : scale 실행 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>

<style>
/*툴팁 스타일*/
a.tip {
    position: relative;
    color:black;
}

a.tip span {
    display: none;
    position: absolute;
    top: 20px;
    left: -10px;
    width: 200px;
    padding: 5px;
    z-index: 100;
    background: #000;
    color: #fff;
    line-height: 20px;
    -moz-border-radius: 5px; /* 파폭 박스 둥근 정도 */
    -webkit-border-radius: 5px; /* 사파리 박스 둥근 정도 */
}

a:hover.tip span {
    display: block;
}
</style>


<script type="text/javascript">

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		
		var title_gbn_param = "${title_gbn}";
		if (title_gbn_param == "scaleIn") {
			$("#msg_scale_type").html('<spring:message code="etc.etc38"/>');
			$("#spNodrCnt").html('<spring:message code="eXperDB_scale.reduction_node_cnt"/>');
		} else {
			$("#msg_scale_type").html('<spring:message code="etc.etc39"/>');
			$("#spNodrCnt").html('<spring:message code="eXperDB_scale.expansion_node_cnt"/>');
		}
		
	});

	/* ********************************************************
	 * NUMBER check
	 ******************************************************** */
	function NumObj() {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			(event.preventDefault) ? event.preventDefault() : event.returnValue = false;
		}
	}
	
	/* ********************************************************
	 * null체크
	 ******************************************************** */
	function nvlSet(val, reVal) {
		var strValue = val;
		if( strValue == null || strValue == 'undefined') {
			strValue = reVal;
		}
		
		return strValue;
	}
	
	/* ********************************************************
	 * scale in Out 실행
	 ******************************************************** */
	function fn_scaleInOutExecute() {
		//화면 valid check
		if (!valCheck()) return false;
		var scaleMsg = "";

		//중복 체크
		$.ajax({
			async : false,
			url : "/scale/scaleInOutSet.do",
		  	data : {
		  		scaleSet : $("#title_gbn", "#scaleExecuteForm").val(),
				db_svr_id : $("#db_svr_id", "#scaleExecuteForm").val(),
				scale_count : $("#scale_count", "#scaleExecuteForm").val()
		  	},
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				if ($("#title_gbn", "#scaleExecuteForm").val() == "scaleIn") {
					scaleMsg = '<spring:message code="eXperDB_scale.scale_in" />';
				} else {
					scaleMsg = '<spring:message code="eXperDB_scale.scale_out" />';
				}
					
				if (result.RESULT == "FAIL" || result == "") {
					alert(scaleMsg + ' ' + '<spring:message code="eXperDB_scale.msg2" />');
					return false;
				} else {
					alert(scaleMsg + ' ' + '<spring:message code="eXperDB_scale.msg1" />');
					window.close();
					opener.fn_scale_status_chk();
				}
			}
		});
	}

	/* ********************************************************
	 * screen valid check
	 ******************************************************** */
	function valCheck(){
		var msgVale="";
		if(nvlSet($("#scale_count").val(),"") == "" || nvlSet($("#scale_count").val(),"") < "1") { //scale type
			alert('<spring:message code="eXperDB_scale.msg6" arguments="1" />');

			$('input[name=scale_count]').focus();
			return false;
		}

		return true;
	}
</script>
</head>
<body>
	<div class="pop_container">
		<div class="pop_cts" style="min-width:500px;min-height:315px;">
			<p class="tit"><spring:message code="menu.eXperDB_scale_execute" /></p>
			<div class="pop_cmm">
				<form name="scaleExecuteForm" id="scaleExecuteForm">
					<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
					<input type="hidden" name="title_gbn" id="title_gbn" value="${title_gbn}"/>

					<table class="write">
						<caption><spring:message code="menu.eXperDB_scale_execute" /></caption>
						<colgroup>
							<col style="width:40px;" />
							<col style="width:60px;" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">
									<spring:message code="eXperDB_scale.scale_type" />
								</th>
								<td>
									<span id="msg_scale_type"></span>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<span id="spNodrCnt"></span>
								</th>
								<td>
									<input type="text" class="txt" name="scale_count" id="scale_count" value="1" style="width: 200px;" maxlength="10" onKeyPress="NumObj();" placeholder="<spring:message code='eXperDB_scale.msg6' arguments='1' />" onblur="this.value=this.value.trim()" />
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01" onClick="fn_scaleInOutExecute();"><button type="button"><spring:message code="schedule.run" /></button></span>
				<span class="btn" onclick="self.close();return false;"><button type="button"><spring:message code="common.cancel" /></button></span>
			</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>