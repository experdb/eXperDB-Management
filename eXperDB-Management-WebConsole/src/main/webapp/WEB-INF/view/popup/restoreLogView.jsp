<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : restoreLogList.jsp
	* @Description : 복구로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.31     최초 생성
	*
	* author 변승우
	* since 2019.01.31
	*
	*/
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="../../css/common.css">
<script type="text/javascript" src="../../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../../js/common.js"></script>
</head>
<body>
<script language="javascript">

var restore_sn = "${restore_sn}";
var db_svr_id = "${db_svr_id}"

$(window.document).ready(function() {
	fn_addView();
});


	
	//로그 더보기
function fn_addView() {
/* 		var v_db_svr_id = $("#db_svr_id").val();
		var v_seek = $("#seek").val();
		var v_file_name = $("#file_name").val();

		var v_endFlag = $("#endFlag").val();
		
		var v_dwLen = $("#dwLen").val();
		var v_log_line = $("#log_line").val();
		
		if(v_endFlag > 0) {
			alert("<spring:message code='message.msg66' />");
			$("#endFlag").val("0");
			return;
		}
		 */
		$.ajax({
			url : "/restoreLogInfo.do",
			dataType : "json",
			type : "post",
 			data : {
 				db_svr_id : db_svr_id,
 				restore_sn : restore_sn
 			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href="/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href="/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				$("#restoreHistorylog").append(result.strResultData); 

/* 				var v_fileSize = Number($("#fSize").val()) + result.fSize;

				$("#fSize").val(v_fileSize);
				$("#seek").val(result.seek);
				$("#endFlag").val(result.endFlag);
				$("#dwLen").val(result.dwLen);
				
				
				v_fileSize = byteConvertor(v_fileSize);
				document.getElementById("fSizeDev").innerHTML = v_fileSize; */
				

				//fn_Show();
			}
		});
	}
</script>
<input type="hidden" id="restoreLog" name="restoreLog" value="${result}">

<div id="pop_container">
	<div class="pop_cts">
		<p class="tit">복구 로그</p>
		<div>
			<table  class="log_table">
				<tr>
					<td>
						<div class="btn_type_01">
							<span class="btn btnC_01"><button type="button" onClick="fn_addView();"><spring:message code="auth_management.viewMore"/></button></span>
							<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
						</div>
					</td>
				</tr>
			</table>
		</div>

		<div class="pop_cmm">
			<table class="write">
				<caption>복구 로그</caption>
				<tbody>
					<tr>
						<td>						 
							<div class="overflow_area4" name="exelog_view"  id="exelog_view">
								<textarea name="restoreHistorylog"  id="restoreHistorylog" style="height:100%"></textarea>	
							</div>						
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

</body>
</html>