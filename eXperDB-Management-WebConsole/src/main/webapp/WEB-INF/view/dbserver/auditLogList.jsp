<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
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
var table = null;

function fn_init() {
	table = $('#auditLogTable').DataTable({
		scrollY : "400px",
		bSort: false,
		paging: false,
		scrollX: true,
		columns : [
		{ data : "", defaultContent : ""}, 
		{data : "file_name", defaultContent : ""
			,"render": function (data, type, full) {				
				  return "<a href='#' class='bold' id='openLogView'>"+data+"</a>";
			}
		}, 
		{ data : "file_size", defaultContent : ""}, 
		{ data : "file_lastmodified", defaultContent : ""}
		 ]
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '80px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');

    $(window).trigger('resize');
    
	table.on( 'order.dt search.dt', function () {
		table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
	

	 $('#auditLogTable tbody').on('click','#openLogView', function () {
	 		var $this = $(this);
	    	var $row = $this.parent().parent();
	    	$row.addClass('select-detail');
	    	var datas = table.rows('.select-detail').data();
	    	var row = datas[0];
		    $row.removeClass('select-detail');		
		    var file_name = row.file_name;
		    var file_size= row.file_size;
		    	
		    var db_svr_id = $("#db_svr_id").val();
			var param = "db_svr_id=" + db_svr_id + "&file_name=" + file_name + "&dwLen=1";
			var v_size = file_size.replace("Mb", "");

			window.open("/audit/auditLogView.do?" + param  ,"popLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=1200,height=970,top=0,left=0");
	    	
		});
}

$(window.document).ready(function() {
	fn_init();
	$('.dataTables_filter').hide();
	var lgi_dtm_start = "${start_date}";
	var lgi_dtm_end = "${end_date}";
	if (lgi_dtm_start != "" && lgi_dtm_end != "") {
		$('#from').val(lgi_dtm_start);
		$('#to').val(lgi_dtm_end);
	} else {
		$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
	}
	
	$.ajax({
		url : "/selectAuditManagement.do",
		data : {
			lgi_dtm_start : $("#from").val(),
			lgi_dtm_end : $("#to").val(),
			db_svr_id : $("#db_svr_id").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
	
	
	
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
			alert("<spring:message code='message.msg26' />");
			history.go(-1);
		} else if(extName == "agent") {
			alert("<spring:message code='message.msg27' />");
			history.go(-1);
		}
		
	}

	function fn_search() {
		$.ajax({
			url : "/selectAuditManagement.do",
			data : {
				lgi_dtm_start : $("#from").val(),
				lgi_dtm_end : $("#to").val(),
				db_svr_id : $("#db_svr_id").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		});
		
	}
	
	
	/*사용 안함*/
	function fn_openLogView(file_name, file_size) {
		var db_svr_id = $("#db_svr_id").val();
		var param = "db_svr_id=" + db_svr_id + "&file_name=" + file_name + "&dwLen=1";
		
		var v_size = file_size.replace("Mb", "");
		
/* 		if(v_size >60) {
			if(confirm("다운로드 후 확인가능합니다. 다운로드하시겠습니까?")) {
				fn_download(file_name, file_size);
			}
		} else {
			window.open("/audit/auditLogView.do?" + param  ,"popLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=915,height=800,top=0,left=0");
		} */
		window.open("/audit/auditLogView.do?" + param  ,"popLogView","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=1200,height=970,top=0,left=0");
	}
	
	function fn_download(file_name, file_size) {
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
		fn_buttonState(false);
		//$("#btnDownload").prop("disabled", false);
	}
</script>

<iframe id="frmDownload" name="frmDownload" width="0px" height="0px"></iframe>
<input type="hidden" id="db_svr_id" name="db_svr_id" value="${db_svr_id}">
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				<spring:message code="menu.audit_history" />
				<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul><li><spring:message code="help.audit_history" /></li></ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${serverName}</li>
					<li><spring:message code="menu.access_control_management" /></li>
					<li class="on"><spring:message code="menu.audit_history" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onClick="javascript:fn_search();"><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 80px;" />
							<col style="width: 200px;" />
							<col style="width: 80px;" />
							<col style="width: 200px;" />
							<col style="width: 80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10"><spring:message code="access_control_management.log_term" /></th>
								<td colspan="4">
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="from" name="start_date" title="기간검색 시작날짜" readonly="readonly" /> 
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="to" name="end_date" title="기간검색 종료날짜" readonly="readonly" />
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="auditLogTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"><spring:message code="common.no" /></th>
								<th width="200"><spring:message code="access_control_management.log_file_name" /></th>
								<th width="80"><spring:message code="common.size" /></th>
								<th width="100"><spring:message code="common.modify_datetime" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

