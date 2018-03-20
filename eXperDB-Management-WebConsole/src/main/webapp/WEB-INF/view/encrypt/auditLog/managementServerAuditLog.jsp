<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : managementServerAuditLog.jsp
	* @Description : managementServerAuditLog 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.09     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.09
	*
	*/
%>
<script>
	var table = null;

	function fn_init() {
		table = $('#table').DataTable({
			scrollY : "310px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", className : "dt-center", defaultContent : ""}, 
				{ data : "logDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "entityName", className : "dt-center", defaultContent : ""}, 
				{ data : "remoteAddress", className : "dt-center", defaultContent : ""}, 
				{ data : "requestPath", className : "dt-center", defaultContent : ""}, 
				{ data : "resultCode", className : "dt-center", defaultContent : ""}, 
				{
					data : "",
					render : function(data, type, full, meta) {
						var html = "<span class='btn btnC_01 btnF_02'><button id='detail'>상세보기</button></span>";
						return html;
					},
					className : "dt-center",
					defaultContent : "",
					orderable : false
				},
				{data : "parameter", className : "dt-center", defaultContent : "", visible: false },
				{data : "resultMessage", className : "dt-center", defaultContent : "", visible: false }
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '250px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
	    $(window).trigger('resize');
	    
		//상세보기 클릭시
		$('table tbody').on('click','#detail',function() {
		 	var $this = $(this);
		    var $row = $this.parent().parent().parent();
		    $row.addClass('detail');
		    var datas = table.rows('.detail').data();
		    if(datas.length==1) {
		    	var row = datas[0];
			    $row.removeClass('detail');
		 		var logDateTime  = row.logDateTime;
		 		var entityName  = row.entityName;
		 		var remoteAddress  = row.remoteAddress;
		 		var requestPath  = row.requestPath;
		 		var resultCode  = row.resultCode;
		 		var parameter  = row.parameter;
		 		var resultMessage  = row.resultMessage;
		 		var popUrl = "/popup/managementServerAuditLogDetail.do?entityName="+entityName
		 				+"&&logDateTime="+logDateTime +"&&remoteAddress="+remoteAddress
		 				+"&&requestPath="+requestPath +"&&resultCode="+resultCode
		 				+"&&parameter="+encodeURI(parameter) +"&&resultMessage="+encodeURI(resultMessage)// 서버 url 팝업경로
		 		var width = 930;
		 		var height = 500;
		 		var left = (window.screen.width / 2) - (width / 2);
		 		var top = (window.screen.height /2) - (height / 2);
		 		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		 			
		 		window.open(popUrl,"",popOption);
		 			
		    }
		});	
	}
	
	$(window.document).ready(function() {
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
		
		$('#from').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		$('#to').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		
		fn_init();
		$.ajax({
			url : "/selectManagementServerAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				entityuid : $('#entityuid').val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				if(result.data!=null){
					table.rows.add(result.data).draw();
				}
			}
		});

	});
	

	/* 조회 버튼 클릭시*/
	function fn_select() {
		$.ajax({
			url : "/selectManagementServerAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				entityuid : $('#entityuid').val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				if(result.data!=null){
					table.rows.add(result.data).draw();
				}
			}
		});
	}
	

</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>관리서버<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>관리서버설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>데이터암호화</li>
					<li>감사로그</li>
					<li class="on">관리서버</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select();"><button>조회</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 300px;" />
							<col style="width: 100px;" />
							</col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10">로그기간</th>
								<td>
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="from" name="lgi_dtm_start" title="기간검색 시작날짜" readonly="readonly" /> <span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a> 
										<input type="text" class="calendar" id="to" name="lgi_dtm_end" title="기간검색 종료날짜" readonly="readonly" />
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">접근자</th>
								<td>
									<select class="select t5" id="entityuid">
										<option value="">전체</option>
											<c:forEach var="entityuid" items="${entityuid}">
												<option value="${entityuid.getEntityUid}">${entityuid.getEntityName}</option>							
											</c:forEach>
									</select>
								</td>
								<th scope="row" class="t9">성공/실패</th>
								<td>
									<select class="select t8" id="resultcode">
										<option value="">전체</option>
										<option value="0000000000">성공</option>
										<option value="9999999999">실패</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="table" class="display" cellspacing="0"width="100%">
						<thead>
							<tr>
								<th width="30">No</th>
								<th width="150">접근일시</th>
								<th width="100">접근자</th>
								<th width="100">접근주소</th>
								<th width="250">접근경로</th>
								<th width="100">결과코드</th>
								<th width="100">상세보기</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
