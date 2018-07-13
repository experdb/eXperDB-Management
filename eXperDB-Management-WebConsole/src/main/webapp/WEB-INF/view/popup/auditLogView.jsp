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
	* @Class Name : auditLogList.jsp
	* @Description : Audit 로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
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

	function is_ie() {
	  if(navigator.userAgent.toLowerCase().indexOf("chrome") != -1) return false;
	  if(navigator.userAgent.toLowerCase().indexOf("msie") != -1) return true;
	  if(navigator.userAgent.toLowerCase().indexOf("windows nt") != -1) return true;
	  return false;
	}
	 
	function copy_to_clipboard(str) {
	  if ( window.clipboardData ){ 
	    window.clipboardData.setData("Text", str);
	    alert('<spring:message code="message.msg65" />');
	    return;
	  }
	  else {
		  var textArea = document.getElementById("auditlog");
		  textArea.select();

		  var successful = document.execCommand( "copy", false, null ); 
		  if(successful) {
			  alert('<spring:message code="message.msg65" />');
		  }

	  }

	}
	
	function fn_copy() {
		//var v_log = $("#auditlog").val();
		var v_log =document.getElementById("auditlog").innerText;
		//alert(v_log);
		copy_to_clipboard(v_log);
	}
	
	$(window.document).ready(function() {
		fn_addView();
	});
	
	function fn_Show() {
		$("#auditlog").scrollTop($("#auditlog")[0].scrollHeight);
		
	}
	
	function fn_sec(sec) {
		if (sec < 60) {
		 	sec = sec + '<spring:message code="schedule.second" />';
		} else if (sec < 3600){
		 	sec = Math.floor(sec%3600/60) + '<spring:message code="schedule.minute" />' + sec%60 + '<spring:message code="schedule.second" />';
		} else {
		 	sec = Math.floor(sec/3600) + '<spring:message code="history_management.time" /> ' + Math.floor(sec%3600/60) + '<spring:message code="schedule.minute" /> ' + sec%60 + '<spring:message code="schedule.second" />';
		}
		
		
		return sec;
	}
	
	function fn_addView() {
		var v_db_svr_id = $("#db_svr_id").val();
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
		
		//alert(v_dwLen);
		
		
		$.ajax({
			url : "/audit/auditLogViewAjax.do",
			dataType : "json",
			type : "post",
 			data : {
 				db_svr_id : v_db_svr_id,
 				seek : v_seek,
 				file_name : v_file_name,
 				dwLen : v_dwLen,
 				readLine : v_log_line
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

				$("#auditlog").append(result.data); 

				var v_fileSize = Number($("#fSize").val()) + result.fSize;

				$("#fSize").val(v_fileSize);
				$("#seek").val(result.seek);
				$("#endFlag").val(result.endFlag);
				$("#dwLen").val(result.dwLen);
				
				
				v_fileSize = byteConvertor(v_fileSize);
				document.getElementById("fSizeDev").innerHTML = v_fileSize;
				

				//fn_Show();
			}
		});
	}

	function byteConvertor(bytes) {

		bytes = parseInt(bytes);

		var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];

		var e = Math.floor(Math.log(bytes)/Math.log(1024));

		if(e == "-Infinity") return "0 "+s[0]; 

		else return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];

	}

</script>
<input type="hidden" id="seek" name="seek" value="0">
<input type="hidden" id="dwLen" name="dwLen" value="0">
<input type="hidden" id="db_svr_id" name="db_svr_id" value="${db_svr_id}">
<input type="hidden" id="file_name" name="file_name" value="${file_name}">
<input type="hidden" id="fSize" name="fSize">
<input type="hidden" id="endFlag" name="endFlag" value="0">
<input type="hidden" id="fChrSize" name="fChrSize" value="0">


<div class="pop_container">
	<div class="pop_cts">
		<p class="tit"><spring:message code="auth_management.auditHistoryView"/></p>
		<div>
			<table  class="log_table">
				<tr>
					<td>
						<select class="select" name="log_line" id="log_line">
								<option value="500">500 Line</option>
								<option value="1000" selected>1000 Line</option>
								<option value="3000">3000 Line</option>
								<option value="5000">5000 Line</option>
						</select>
					</td>
					<td>
						<div class="btn_type_01">
							<span class="btn btnC_01"><button type="button" onClick="fn_addView();"><spring:message code="auth_management.viewMore"/></button></span>
							<!--  <span class="btn btnC_01"><button onClick="fn_copy();">복사</button></span>-->
							<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
						</div>
					</td>
				</tr>
			</table>
		</div>

		
		<div class="pop_cmm">
			<table class="write">
				<caption><spring:message code="auth_management.auditHistoryView"/></caption>
				<colgroup>

					<col />
				</colgroup>
				<tbody>
					<tr>
						<td>
						 
						<div class="overflow_area3" name="auditlog"  id="auditlog">
						</div>
						
						<!-- 
							<div class="textarea_grp">
								
								<textarea name="auditlog"  id="auditlog" style="height:550px"></textarea>
								
							</div>
					  -->
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td><spring:message code="access_control_management.log_file_name" /> : &nbsp;&nbsp;</td>
									<td><b>${file_name}</b> &nbsp;&nbsp;</td>
									<td>size : </td>
									<td><b><div id="fSizeDev"></div></b></td>
								</tr>
							</table>

						</td>

					</tr>
				</tbody>
			</table>
		</div>

	

	</div>
</div>
</body>
</html>