<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : encryptAgentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 변승우 대리
	* since 2018.04.23
	*
	*/
%>
<script>
var table = null;

function fn_init(){
	table = $('#monitoring').DataTable({
		scrollY : "420px",
		searching : false,
		deferRender : true,
		scrollX: true,
		columns : [
			{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]],  className : "dt-center", defaultContent : ""},
			{ data : "monitoredName", defaultContent : ""}, 
			{ data : "status", defaultContent : "", className : "dt-center", render: function (data, type, full){
				if(full.status == "start"){
					var html = '<img src="../images/ico_agent_1.png" alt="" />';
						return html;
				}else{
					var html = '<img src="../images/ico_agent_2.png" alt="" />';
					return html;
				}
				return data;
			},},
			{ data : "targetType", defaultContent : "", visible: false},
			{ data : "targetUid", defaultContent : "", visible: false},
			{ data : "targetName", defaultContent : "", visible: false},
			{ data : "monitorType", defaultContent : "", visible: false},
			{ data : "resultLevel", defaultContent : "", visible: false},
			{ data : "logMessage", defaultContent : "", visible: false},
		 ]
	});
	
	table.on( 'order.dt search.dt', function () {
    	table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
}

$(window.document).ready(function() {
	fn_init();
	fn_refresh();
});


function fn_refresh(){
	$.ajax({
		url : "/selectEncryptAgentMonitoring.do", 
	  	data : {},
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
		success : function(data) {
			if(data.list.length != 0){
				if(data.resultCode == "0000000000"){
					table.clear().draw();
					table.rows.add(data.list).draw();
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href = "/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");
				}
			}
		}
	});	
}
</script>
	<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4><spring:message code="agent_monitoring.Encrypt_agent"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="encrypt_help.Encrypt_agent"/></li>
								<li><spring:message code="help.agent_monitoring_02" /> </li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.agent_monitoring" /></li>
								<li class="on"><spring:message code="agent_monitoring.Encrypt_agent"/></li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button onclick="fn_refresh()"><spring:message code="encrypt_agent.Refresh"/></button></span>
							</div>

							<div class="overflow_area">
								<table id="monitoring" class="display" cellspacing="0" width="100%">
									<caption>Encrypt Agent 모니터링 리스트</caption>
									<colgroup>
										<col style="width:5%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><spring:message code="common.no" /></th>
											<th scope="col">Agent IP</th>
											<th scope="col">Agent <spring:message code="properties.status" /></th>
										</tr>
									</thead>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->