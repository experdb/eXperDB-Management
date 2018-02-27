<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : encodeDecodeAuditLog.jsp
	* @Description : encodeDecodeAuditLog 화면
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
		table = $('#passwordDecodeTable').DataTable({
			scrollY : "310px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},  
				{ data : "agentLogDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "agentRemoteAddress", className : "dt-center", defaultContent : ""}, 
				{ data : "profileName", className : "dt-center", defaultContent : ""}, 
				{ data : "instanceId", className : "dt-center", defaultContent : ""}, 
				{ data : "siteAccessAddress", className : "dt-center", defaultContent : ""}, 
				{ data : "macAddr", className : "dt-center", defaultContent : ""}, 
				{ data : "osLoginId", className : "dt-center", defaultContent : ""}, 
				{ data : "serverLoginId", className : "dt-center", defaultContent : ""}, 
				{ data : "adminLoginId", className : "dt-center", defaultContent : ""}, 
				{ data : "applicationName", className : "dt-center", defaultContent : ""}, 
				{ data : "extraName", className : "dt-center", defaultContent : ""}, 
				{ data : "hostName", className : "dt-center", defaultContent : ""}, 
				{ data : "locationInfo", className : "dt-center", defaultContent : ""}, 
				{ data : "moduleInfo", className : "dt-center", defaultContent : ""}, 
				{ data : "weekday", className : "dt-center", defaultContent : ""}, 
				{ data : "encryptTrueFalse", className : "dt-center", defaultContent : ""}, 
				{ data : "successTrueFalse", className : "dt-center", defaultContent : ""}, 
				{ data : "count", className : "dt-center", defaultContent : ""}, 
				{ data : "siteIntegrityResult", className : "dt-center", defaultContent : ""}, 
				{ data : "serverIntegrityResult", className : "dt-center", defaultContent : ""}, 
				{ data : "createDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "updateDateTime", className : "dt-center", defaultContent : ""}
	
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(16)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(19)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(20)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(21)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(22)').css('min-width', '150px');
	
	    $(window).trigger('resize');
	    
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
			url : "/selectEncodeDecodeAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				agentUid : $('#agentUid').val(),
				successTrueFalse : $('#successTrueFalse').val(),
				searchFieldName : $('#searchFieldName').val(),
				searchOperator : $('#searchOperator').val(),
				searchFieldValueString : $('#searchFieldValueString').val()
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
			url : "/selectEncodeDecodeAuditLog.do",
			data : {
				from : $('#from').val(),
				to : 	$('#to').val(),
				resultcode : $('#resultcode').val(),
				agentUid : $('#agentUid').val(),
				successTrueFalse : $('#successTrueFalse').val(),
				searchFieldName : $('#searchFieldName').val(),
				searchOperator : $('#searchOperator').val(),
				searchFieldValueString : $('#searchFieldValueString').val()
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
			<h4>암복호화<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>암복호화설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>데이터암호화</li>
					<li>감사로그</li>
					<li class="on">암복호화</li>
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
							<col style="width: 500px;" />
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
								<th scope="row" class="t9">에이전트</th>
								<td>
									<select class="select t3" id="agentUid" name="agentUid">
										<c:forEach var="result" items="${result}" varStatus="status">
										<option value="" ><c:out value="전체"/></option>
											<option value="<c:out value="${result.entityUid}"/>" ><c:out value="${result.entityName}"/></option>
										</c:forEach> 
									</select>
								</td>
								<th scope="row" class="t9">성공/실패</th>
								<td>
									<select class="select t8" id="successTrueFalse" name="successTrueFalse">
										<option value="">전체</option>
										<option value="true">성공</option>
										<option value="false">실패</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row" class="t9">조회필드</th>
								<td>
									<select class="select t5" id="searchFieldName" name="searchFieldName">
										<option value="">전체</option>
										<option value="PROFILE_NM">정책 이름</option>
										<option value="SITE_ACCESS_ADDRESS">클라이언트 주소</option>
										<option value="HOST_NM">호스트 이름</option>
										<option value="EXTRA_NM">추가 필드</option>
										<option value="MODULE_INFO">모듈 정보</option>
										<option value="LOCATION_INFO">DB 컬럼</option>
										<option value="SERVER_LOGIN_ID">DB 사용자 아이디</option>
										<option value="ADMIN_LOGIN_ID">eXperDB 사용자 아이디</option>
										<option value="OS_LOGIN_ID">사용자 아이디</option>
										<option value="APPLICATION_NM">프로그램 이름</option>
										<option value="INSTANCE_ID">서버 인스턴스</option>										
									</select>
									<select class="select t8" id="searchOperator" name="searchOperator">
										<option value="%">Like</option>
										<option value="%">=</option>
										<option value="<">&lt;</option>
										<option value=">">&gt;</option>
									</select>
									<input type="text" class="txt t3" id="searchFieldValueString" name="searchFieldValueString"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="passwordDecodeTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40">No</th>
								<th width="100">에이전트 로그일시</th>
								<th width="100">에이전트 주소</th>
								<th width="100">보안정책</th>
								<th width="100">서버 인스턴스</th>
								<th width="100">클라이언트 주소</th>
								<th width="100">Mac주소</th>
								<th width="100">OS사용자</th>
								<th width="100">DB사용자</th>
								<th width="100">eXperDB 사용자</th>
								<th width="100">프로그램</th>
								<th width="100">Extra Name</th>
								<th width="100">Host 이름</th>
								<th width="100">DB컬럼</th>
								<th width="100">모듈정보</th>
								<th width="100">요일</th>
								<th width="100">동작</th>
								<th width="100">결과</th>
								<th width="100">횟수</th>
								<th width="100">사이트 무결성</th>
								<th width="100">서버 무결성</th>
								<th width="150">관리서버 로그 생성일시</th>
								<th width="150">관리서버 로그 갱신일시</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
