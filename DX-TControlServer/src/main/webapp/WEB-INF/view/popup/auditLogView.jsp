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
	    alert("클립보드에 복사되었습니다. \n [Ctrl+v]를 사용하여 원하는 곳에 붙여넣기 하세요.");
	    return;
	  }
	  else {
		  var textArea = document.getElementById("auditlog");
		  textArea.select();

		  var successful = document.execCommand( "copy", false, null ); 
		  if(successful) {
			  alert("클립보드에 복사되었습니다. \n [Ctrl+v]를 사용하여 원하는 곳에 붙여넣기 하세요.");
		  }

	  }

	}
	
	function fn_copy() {
		var v_log = $("#auditlog").val();
		copy_to_clipboard(v_log);
	}
	
	$(window.document).ready(function() {
		//document.getElementById("auditlog").scrollTop = document.getElementById("auditlog").scrollHeight;
		setTimeout(function(){
		    var t = performance.timing;
		    console.log(t.loadEventEnd - t.responseEnd);
		    var loadTime = (t.loadEventEnd - t.responseEnd) / 60;
		    
		    $("#recTime").text("응답시간 :" + fn_sec(loadTime.toFixed(1)));
		    //alert(fn_sec(loadTime.toFixed(1)));
		  }, 0);

	});
	
	function fn_Show() {
		$("#auditloading").hide();
		$("#auditlog").scrollTop($("#auditlog")[0].scrollHeight);
		
	}
	
	function fn_sec(sec) {
		if (sec < 60) {
		 	sec = sec + '초';
		} else if (sec < 3600){
		 	sec = Math.floor(sec%3600/60) + '분 ' + sec%60 + '초';
		} else {
		 	sec = Math.floor(sec/3600) + '시간 ' + Math.floor(sec%3600/60) + '분 ' + sec%60 + '초';
		}
		
		
		return sec;
	}
	

</script>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">감사이력 보기</p>
		<div class="btn_type_01">
			<span class="btn btnC_01"><button onClick="fn_copy();">복사</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
		
	<div id="auditloading">
			<img src="/images/spin.gif" alt="" />
	</div>
	
		<div class="pop_cmm">
			<table class="write">
				<caption>감사이력 보기</caption>
				<colgroup>

					<col />
				</colgroup>
				<tbody>
					<tr>
						<td>
							50MB load 시 약 1분 소요됩니다.
							
						</td>
					</tr>
					<tr>
						<td>
							<div class="textarea_grp">
								
								<textarea name="auditlog"  id="auditlog" style="height:550px">${logView}</textarea>
								
							</div>
							
						</td>
					</tr>
					<tr>
						<td> <div id="recTime"></div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	

	</div>
</div>
<script>fn_Show();</script>
</body>
</html>