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

<script language="javascript">
$(window.document).ready(function() {
	var lgi_dtm_start = "${start_date}";
	var lgi_dtm_end = "${end_date}";
	if (lgi_dtm_start != "" && lgi_dtm_end != "") {
		$('#from').val(lgi_dtm_start);
		$('#to').val(lgi_dtm_end);
	} else {
		$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
	}
	

	// Ajax 파일 다운로드
	jQuery.download = function(url, data, method){
	    // url과 data를 입력받음
	    if( url && data ){ 
	        // data 는  string 또는 array/object 를 파라미터로 받는다.
	        data = typeof data == 'string' ? data : jQuery.param(data);
	        // 파라미터를 form의  input으로 만든다.
	        var inputs = '';
	        jQuery.each(data.split('&'), function(){ 
	            var pair = this.split('=');
	            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
	        });
	        // request를 보낸다.
	        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
	        .appendTo('body').submit().remove();
	    };
	};
	
});

$(function() {
	var extName = "${extName}";
	
	fn_chkExtName(extName)
	
	var dateFormat = "yyyy-mm-dd", from = $("#from").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#to").datepicker("option", "minDate", selectedDate);
		}
	})

	to = $("#to").datepicker({
		changeMonth : false,
		changeYear : false,
		onClose : function(selectedDate) {
			$("#from").datepicker("option", "maxDate", selectedDate);
		}
	})

	function getDate(element) {
		var date;
		try {
			date = $.datepicker.parseDate(dateFormat, element.value);
		} catch (error) {
			date = null;
		}
		return date;
	}
});

function fn_chkExtName(extName) {
	if(extName == "") {
		alert("서버에 pgaudit Extension 이 설치되지 않았습니다.");
		history.go(-1);
	} else if(extName == "agent") {
		alert("서버에 T엔진이 설치되지 않았습니다.");
		history.go(-1);
	}
	
}

	function fn_search() {
		var form = document.auditForm;
		
		form.action = "/audit/auditLogSearchList.do";
		form.submit();
		return;
	}
	
	function fn_openLogView(file_name, file_size) {
		var db_svr_id = $("#db_svr_id").val();
		var param = "db_svr_id=" + db_svr_id + "&file_name=" + file_name;
		
		var v_size = file_size.replace("Mb", "");
		
		if(v_size >60) {
			if(confirm("다운로드 후 확인가능합니다. 다운로드하시겠습니까?")) {
				fn_download(file_name, file_size);
			}
		} else {
			window.open("/audit/auditLogView.do?" + param  ,"popLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=915,height=800,top=0,left=0");
		}
		
	}
	
	function fn_download(file_name, file_size) {
		$("#auditloading").show();
		var db_svr_id = $("#db_svr_id").val();
		var param = "db_svr_id=" + db_svr_id + "&file_name=" + file_name;

		var v_size = file_size.replace("Mb", "");
		var v_time = 100 * v_size;
		
		fn_buttonState(true);
		//$("#btnDownload").prop("disabled", true);

		//$.download('/audit/auditLogDownload.do', param,'post' );
		setTimeout("fn_progressClose()", v_time);
		

		var form = document.auditForm;
		//form.target = "frmDownload";
		form.action = "/audit/auditLogDownload.do?" + param ;
		form.submit();
		return;

	}
	
	function fn_buttonState(blnState) {
		var btnLength = document.all("btnDownload").length;
		for(i=0; i<btnLength; i++) {
			document.all("btnDownload")[i].disabled = blnState;
		}
		
	}
	
	function fn_progressClose() {
		$("#auditloading").hide();
		fn_buttonState(false);
		//$("#btnDownload").prop("disabled", false);
	}
</script>

<iframe id="frmDownload" name="frmDownload" width="0px" height="0px"></iframe>
<form name="auditForm" id="auditForm" method="post">
<input type="hidden" id="db_svr_id" name="db_svr_id" value="${db_svr_id}">
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>감사이력<a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li class="bold">${serverName}</li>
								<li>접근제어관리</li>
								<li class="on">감사 이력</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button onClick="javascript:fn_search();">조회</button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col />
									</colgroup>
									<tbody>

										<tr>
											<th scope="row" class="t10">작업기간</th>
											<td colspan="4">
												<div class="calendar_area">
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="from" name="start_date" title="기간검색 시작날짜" readonly="readonly" />
													<span class="wave">~</span>
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="to" name="end_date" title="기간검색 종료날짜" readonly="readonly" />
												</div>
											</td>
											<td>
												<div id="auditloading" style="display:none">
														<img src="/images/spin.gif" alt="" /> 다운로드 중입니다... ......... .. <a href="javascript:fn_progressClose();">확인</a>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="overflow_area">
								<table class="list">
									<caption>Rman 백업관리 이력화면 리스트</caption>
									<colgroup>
										<col style="width:5%;" />
										<col style="width:50%;" />
										<col style="width:15%;" />
										<col style="width:20%;" />
										<col style="width:10%;" />

									</colgroup>
									<thead>
										<tr>
											<th scope="col">No</th>
											<th scope="col">로그파일명</th>
											<th scope="col">Size</th>
											<th scope="col">수정일시</th>
											<th scope="col">다운로드</th>
										</tr>
									</thead>
									<tbody>
									
									<c:if test="${fn:length(logFileList) == 0}">
										<tr>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											
										</tr>
									</c:if>
									<c:forEach var="log" items="${logFileList}" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td><a href="javascript:fn_openLogView('${log.file_name}', '${log.file_size}')" style="font-weight:bold; color:#F56600;">${log.file_name}</a></td>
											<td>${log.file_size}</td>
											<td>${log.file_lastmodified}</td>
											<td><span class="btn"><button id="btnDownload" name="btnDownload" onClick="javascript:fn_download('${log.file_name}', '${log.file_size}');">다운로드</button></span></td>
											
										</tr>
									</c:forEach>
									
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
</form>