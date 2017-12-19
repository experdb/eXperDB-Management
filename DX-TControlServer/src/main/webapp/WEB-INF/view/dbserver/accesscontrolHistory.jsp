<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : accesscontrolHistory.jsp
	* @Description : accesscontrolHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.09.18     최초 생성
	*
	* author 김주영 사원
	* since 2017.09.18
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#accesscontrolHistoryTable').DataTable({
			scrollY : "270px",
			paging: false,
			searching : false,
			scrollX: true,
			sort: false,
			columns : [
			{ data : "rownum", className : "dt-center", defaultContent : ""}, 
			{ data : "ctf_tp_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "dtb", className : "dt-center", defaultContent : ""}, 
			{ data : "prms_usr_id", className : "dt-center", defaultContent : ""}, 
			{ data : "prms_ipadr", className : "dt-center", defaultContent : ""},
			{ data : "prms_ipmaskadr", className : "dt-center", defaultContent : ""}, 
			{ data : "ctf_mth_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "opt_nm", className : "dt-center", defaultContent : ""}, 
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');

	    $(window).trigger('resize');
	}
	
	$(window.document).ready(function() {
		fn_init();
		if($("#lst_mdf_dtm").val()!=null){
			$.ajax({
				url : "/selectAccessControlHistory.do",
				data : {
					svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
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

	});
	
	/*조회버튼 클릭시*/
	function fn_select(){
		if($("#lst_mdf_dtm").val()==null){
			alert('<spring:message code="message.msg30" />');
			return false;
		}
			$.ajax({
				url : "/selectAccessControlHistory.do",
				data : {
					svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
			             location.href = "/";
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
	
	/*복원버튼 클릭시*/
	function fn_recovery(){
		if($("#lst_mdf_dtm").val()==null){
			alert('<spring:message code="message.msg30" />');
			return false;
		}
		if (!confirm("정말 복원하시겠습니까?")) return false;
		$.ajax({
			url : "/recoveryAccessControlHistory.do",
			data : {
				db_svr_id : "${db_svr_id}",
				svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {			
				if (result=="true") {
					alert('<spring:message code="message.msg31" />');
				}else if(result=="pgaudit"){
					alert('<spring:message code="message.msg26" />');
				}else if(result=="agent"){
					alert('<spring:message code="message.msg25" />');
				}else if(extName == "agentfail"){
					alert('<spring:message code="message.msg27" /> ');
					history.go(-1);
				}else {
					alert('<spring:message code="message.msg32" />');
				}
			}
		});
	}
	

</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.policy_changes_history" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.policy_changes_history" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.access_control_management" /></li>
					<li class="on"><spring:message code="menu.policy_changes_history" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()"><spring:message code="common.search" /></button></span>
					<span class="btn"><button onclick="fn_recovery()"><spring:message code="common.restore" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.modify_datetime" /></th>
								<td><select class="select t3" id="lst_mdf_dtm">
										<c:forEach var="result" items="${lst_mdf_dtm}">
											<option value="${result.svr_acs_cntr_his_id}">${result.lst_mdf_dtm}</option>
										</c:forEach>
								</select></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="accesscontrolHistoryTable" class="display"
						cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"><spring:message code="common.no" /></th>
								<th width="60"><spring:message code="access_control_management.type" /></th>
								<th width="100"><spring:message code="access_control_management.database" /></th>
								<th width="100"><spring:message code="access_control_management.user" /></th>
								<th width="100"><spring:message code="access_control_management.ip_address" /></th>
								<th width="100"><spring:message code="access_control_management.ip_mask" /></th>
								<th width="100"><spring:message code="access_control_management.method" /></th>
								<th width="100"><spring:message code="access_control_management.option" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>