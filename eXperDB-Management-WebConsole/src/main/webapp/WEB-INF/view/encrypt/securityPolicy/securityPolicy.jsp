<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : securityPolicy.jsp
	* @Description : securityPolicy 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#policyTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "rnum", className : "dt-center", defaultContent : ""},
				{ data : "profileName", defaultContent : ""},
				{ data : "profileNote",
 					render : function(data, type, full, meta) {	 	
 						var html = '';					
 						html += '<span title="'+full.profileNote+'">' + full.profileNote + '</span>';
 						return html;
 					},
 					defaultContent : ""
 				},
				{ data : "profileStatusName", defaultContent : ""},
				{ data : "createName", defaultContent : ""},
				{ data : "createDateTime", defaultContent : ""},
				{ data : "updateName", defaultContent : ""},
				{ data : "updateDateTime", defaultContent : ""},
				{ data : "profileUid",visible: false }
				
			 ],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
	
	    $(window).trigger('resize');
	    
		//더블 클릭시
		$('#policyTable tbody').on('dblclick', 'tr', function() {
			var datas = table.row(this).data();
			if (datas.length <= 0) {
				alert('<spring:message code="message.msg35" />');
			}else if (datas.length >1){
				alert('<spring:message code="message.msg38" />');			
			}else{
				var profileUid = datas.profileUid;
				var form = document.modifyForm;
				form.action = "/securityPolicyModify.do?profileUid="+profileUid;
				form.submit();
				return;
			}
		});
	}
	$(window.document).ready(function() {
		fn_buttonAut();
		fn_init();
		$.ajax({
			url : "/selectSecurityPolicy.do",
			data : {
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
			success : function(data) {
					if(data.resultCode == "0000000000"){
						table.clear().draw();
						if(data.list.length != 0){
							table.rows.add(data.list).draw();
						}
					}else if(data.resultCode == "8000000002"){
						alert("<spring:message code='message.msg05' />");
						top.location.href="/";
					}else if(data.resultCode == "8000000003"){
						alert(data.resultMessage);
						location.href="/securityKeySet.do";
					}else{
						alert(data.resultMessage +"("+data.resultCode+")");
					}
				}
		});
	});

	function fn_buttonAut(){
		var btnInsert = document.getElementById("btnInsert"); 
		var btnUpdate = document.getElementById("btnUpdate"); 
		var btnDelete = document.getElementById("btnDelete"); 
		
		if("${wrt_aut_yn}" == "Y"){
			btnInsert.style.display = '';
			btnUpdate.style.display = '';
			btnDelete.style.display = '';
		}else{
			btnInsert.style.display = 'none';
			btnUpdate.style.display = 'none';
			btnDelete.style.display = 'none';
		}
	}	
	
	/* 조회 버튼 클릭시*/
	function fn_select() {
		$.ajax({
			url : "/selectSecurityPolicy.do",
			data : {
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
			success : function(data) {
				if(data.resultCode == "0000000000"){
					table.clear().draw();
					table.rows.add(data.list).draw();
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");	
				}
			}
		});
	}

	/* 수정 버튼 클릭시*/
	function fn_update() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert('<spring:message code="message.msg35" />');
		}else if (datas.length >1){
			alert('<spring:message code="message.msg38" />');			
		}else{
			var profileUid = table.row('.selected').data().profileUid;
			var form = document.modifyForm;
			form.action = "/securityPolicyModify.do?profileUid="+profileUid;
			form.submit();
			return;
		}
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		var datas = table.rows('.selected').data();
		var profileUid = table.row('.selected').data().profileUid;
		if (datas.length <= 0) {
 			alert('<spring:message code="message.msg35" />');
 			return false;
 		}else{
 			if (!confirm('<spring:message code="message.msg162"/>'))return false;
 			
 			var rowList = [];
 			for (var i = 0; i < datas.length; i++) {
 				rowList += datas[i].profileUid + ',';				
 			}
		
			$.ajax({
				url : "/deleteSecurityPolicy.do", 
			  	data : {
			  		profileUid: rowList
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
				success : function(data) {		
					if(data.resultCode == "0000000000"){
						alert("<spring:message code='message.msg37' />");
						location.reload();
					}else if(data.resultCode == "8000000002"){
						alert("<spring:message code='message.msg05' />");
						top.location.href = "/";
					}else if(data.resultCode == "8000000003"){
						alert(data.resultMessage);
						location.href="/securityKeySet.do";
					}else{
						alert(data.resultMessage +"("+data.resultCode+")");	
					}
				}
			});
 		}	
	}
</script>
<form name="modifyForm" method="post">
</form>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_policy_management.Security_Policy_Management"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Security_Policy_Management" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policy_management.Policy_Key_Management"/></li>
					<li class="on"><spring:message code="encrypt_policy_management.Security_Policy_Management"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
<!-- 					<span class="btn" onclick="fn_select();"><button>조회</button></span> -->
					<span class="btn"><a href="/securityPolicyInsert.do"><button id="btnInsert"><spring:message code="common.registory" /></button></a></span>
					<span class="btn" onclick="fn_update();"><button id="btnUpdate"><spring:message code="common.modify" /></button></span>
					<span class="btn" onclick="fn_delete();"><button id="btnDelete"><spring:message code="common.delete" /></button></span>
				</div>
<!-- 				<div class="sch_form"> -->
<!-- 					<table class="write"> -->
<%-- 						<caption>검색 조회</caption> --%>
<%-- 						<colgroup> --%>
<%-- 							<col style="width: 100px;" /> --%>
<%-- 							<col /> --%>
<%-- 							<col style="width: 100px;" /> --%>
<%-- 							<col /> --%>
<%-- 						</colgroup> --%>
<!-- 						<tbody> -->
<!-- 							<tr> -->
<!-- 								<th scope="row" class="t9">정책이름</th> -->
<!-- 								<td><input type="text" class="txt t2" id="policyName" /></td> -->
<!-- 								<th scope="row" class="t9">정책상태</th> -->
<!-- 								<td><select class="select t5" id="policyStatus"> -->
<!-- 										<option value="Active">Active</option> -->
<!-- 								</select></td> -->
<!-- 							</tr>						 -->
<!-- 						</tbody> -->
<!-- 					</table> -->
<!-- 				</div> -->

				<div class="overflow_area">
					<table id="policyTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"></th>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="encrypt_policy_management.Policy_Name"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Description"/></th>
								<th width="100"><spring:message code="encrypt_policy_management.Status"/></th>
								<th width="100"><spring:message code="common.register" /></th>
								<th width="150"><spring:message code="common.regist_datetime" /></th>
								<th width="80"><spring:message code="common.modifier" /></th>
								<th width="150"><spring:message code="common.modify_datetime" /></th>
								<th width="0"></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
