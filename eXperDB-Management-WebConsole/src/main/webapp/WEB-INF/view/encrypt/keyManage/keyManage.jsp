<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : keyManage.jsp
	* @Description : keyManage 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.08     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.09 
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#keyManageTable').DataTable({
			scrollY : "420px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "no", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "no", className : "dt-center", defaultContent : ""}, 
				{ data : "resourceName", defaultContent : ""}, 
				{ data : "resourceTypeName", defaultContent : ""}, 
				{ data : "cipherAlgorithmName", defaultContent : ""}, 
				{ data : "createName", defaultContent : ""}, 
				{ data : "createDateTime", defaultContent : ""}, 
				{ data : "updateName", defaultContent : ""}, 
				{ data : "updateDateTime", defaultContent : ""},
				{ data : "resourceTypeCode", defaultContent : "", visible: false},
				{ data : "resourceNote", defaultContent : "", visible: false},
				{ data : "keyUid", defaultContent : "", visible: false},
				{ data : "keyStatusCode", defaultContent : "", visible: false},
				{ data : "keyStatusName", defaultContent : "", visible: false},
				{ data : "cipherAlgorithmCode", defaultContent : "", visible: false}
	
			 ],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '150px');
	
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
	    $(window).trigger('resize');
	    
		//더블 클릭시
		$('#keyManageTable tbody').on('dblclick', 'tr', function() {
			var data = table.row(this).data();
			
 			var frmPop= document.frmPopup;
 			
			var popUrl = "/popup/keyManageRegReForm.do"; // 서버 url 팝업경로
			var width = 1300;
			var height = 735;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
						
			frmPop.action = popUrl;
		    frmPop.target = 'popupView';
		    frmPop.method = "post";
		    
		    window.open(popUrl,"popupView",popOption);	
		    
		    frmPop.resourceName.value = data.resourceName;
		    frmPop.resourceNote.value = data.resourceNote;  
		    frmPop.keyUid.value = data.keyUid;
		    frmPop.keyStatusCode.value = data.keyStatusCode; 
		    frmPop.keyStatusName.value = data.keyStatusName;
		    frmPop.cipherAlgorithmName.value = data.cipherAlgorithmName; 
		    frmPop.cipherAlgorithmCode.value = data.cipherAlgorithmCode;
		    frmPop.submit();   
		});
	}
	
	$(window.document).ready(function() {
		fn_buttonAut();
		fn_init();
		fn_select();
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
			url : "/selectCryptoKeyList.do", 
		  	data : {
		  		resourceName: $('#resourceName').val(),
		  		cipherAlgorithmName : $('#cipherAlgorithmName').val()
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
				} else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(xhr.status == 403) {
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
						top.location.href = "/";
					}else if(data.resultCode == "8000000003"){
						alert( data.resultMessage);
						location.href = "/securityKeySet.do";
					}else{
						alert(data.resultMessage +"("+data.resultCode+")");		
					}
				}	
		});
	}

	/* 등록 버튼 클릭시*/
	function fn_insert(){
		var popUrl = "/popup/keyManageRegForm.do"; // 서버 url 팝업경로
		var width = 1000;
		var height = 410;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);	
	}
	
	/* 수정 버튼 클릭시*/
	function fn_update() {
 		var datas = table.rows('.selected').data();
 		var data =  table.row('.selected').data();

 		if (datas.length <= 0) {
 			alert('<spring:message code="message.msg35" />');
 			return false;
 		}else if (datas.length >1){
			alert('<spring:message code="message.msg38" />');
 		}else{
 			var frmPop= document.frmPopup;
 			
			var popUrl = "/popup/keyManageRegReForm.do"; // 서버 url 팝업경로
			var width = 1300;
			var height = 735;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
						
			frmPop.action = popUrl;
		    frmPop.target = 'popupView';
		    frmPop.method = "post";
		    
		    window.open(popUrl,"popupView",popOption);	
		    
		    frmPop.resourceName.value = data.resourceName;
		    frmPop.resourceNote.value = data.resourceNote;  
		    frmPop.keyUid.value = data.keyUid;
		    frmPop.keyStatusCode.value = data.keyStatusCode; 
		    frmPop.keyStatusName.value = data.keyStatusName;
		    frmPop.cipherAlgorithmName.value = data.cipherAlgorithmName; 
		    frmPop.cipherAlgorithmCode.value = data.cipherAlgorithmCode;
		    frmPop.submit();   
		    
 		}
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
 			alert('<spring:message code="message.msg35" />');
 			return false;
 		}else if (datas.length >1){
			alert('<spring:message code="message.msg38" />');
 		}else{
 			if (!confirm('<spring:message code="message.msg162"/>'))return false;
 			
 			var keyUid = table.row('.selected').data().keyUid;
 			var resourceName = table.row('.selected').data().resourceName;
 			var resourceTypeCode = table.row('.selected').data().resourceTypeCode;
 			
			$.ajax({
				url : "/deleteCryptoKeySymmetric.do", 
			  	data : {
			  		keyUid: keyUid,
			  		resourceName:resourceName,
			  		resourceTypeCode:resourceTypeCode
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
						location.href = "/securityKeySet.do";
					}else{
						alert(data.resultMessage +"("+data.resultCode+")");		
					}				
				}
			});
 		}	
	}
</script>

<form name="frmPopup" id="frmPopup">
	<input type="hidden" name="resourceName"  id="resourceName">
	<input type="hidden" name="resourceNote"  id="resourceNote">
	<input type="hidden" name="keyUid"  id="keyUid">
	<input type="hidden" name="keyStatusCode"  id="keyStatusCode">
	<input type="hidden" name="keyStatusName"  id="keyStatusName">
	<input type="hidden" name="cipherAlgorithmName"  id="cipherAlgorithmName">
	<input type="hidden" name="cipherAlgorithmCode"  id="cipherAlgorithmCode">
</form>


<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="encrypt_key_management.Encryption_Key_Management"/><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="encrypt_help.Encryption_Key_Management_01"/></li>
					<li><spring:message code="encrypt_help.Encryption_Key_Management_02"/></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Encrypt</li>
					<li><spring:message code="encrypt_policy_management.Policy_Key_Management"/></li>
					<li class="on"><spring:message code="encrypt_key_management.Encryption_Key_Management"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
<!-- 					<span class="btn" onclick="fn_select();"><button>조회</button></span> -->
					<span class="btn" onclick="fn_insert();"><button id="btnInsert"><spring:message code="common.registory" /></button></span>
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
<!-- 								<th scope="row" class="t9">키이름</th> -->
<!-- 								<td><input type="text" class="txt t2" id="resourceName" name="resourceName"/></td> -->
<!-- 								<th scope="row" class="ico_t1">적용 알고리즘</th> -->
<!-- 								<td> -->
<!-- 									<select class="select t5" id="cipherAlgorithmCode" name="cipherAlgorithmCode" > -->
<%-- 												<option value="<c:out value=""/>" ><c:out value="전체"/></option> --%>
<%-- 											<c:forEach var="result" items="${result}" varStatus="status">												 --%>
<%-- 												<option value="<c:out value="${result.sysCode}"/>" <c:if test="${result.sysCode == cipherAlgorithmCode }">selected="selected"</c:if>><c:out value="${result.sysCodeName}"/></option> --%>
<%-- 											</c:forEach>  --%>
<!-- 									</select> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 						</tbody> -->
<!-- 					</table> -->
<!-- 				</div> -->

				<div class="overflow_area">
					<table id="keyManageTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"></th>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="200"><spring:message code="encrypt_key_management.Key_Name"/></th>
								<th width="80"><spring:message code="encrypt_key_management.Key_Type"/></th>
								<th width="130"><spring:message code="encrypt_key_management.Encryption_Algorithm"/></th>
								<th width="80"><spring:message code="common.register" /></th>
								<th width="150"><spring:message code="common.regist_datetime" /></th>
								<th width="80"><spring:message code="common.modifier" /></th>
								<th width="150"><spring:message code="common.modify_datetime" /></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>
								<th width="0"></th>		
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
