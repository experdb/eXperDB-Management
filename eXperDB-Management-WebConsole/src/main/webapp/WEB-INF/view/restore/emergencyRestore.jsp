<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%@include file="../cmmn/passwordConfirm.jsp"%>

<%
	/**
	* @Class Name : emergencyRestore.jsp
	* @Description : emergencyRestore 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.09     최초 생성
	*
	* author 변승우 대리
	* since 2019.01.09
	*
	*/
%>
<script type="text/javascript">
var db_svr_id = "${db_svr_id}";

$(window.document).ready(function() {
	fn_inti();
});


/* ********************************************************
 * 초기설정
 ******************************************************** */
 function fn_inti(){
	 $("#storage_view").hide();
}
 

/* ********************************************************
 * Storage 경로 선택 (기존/신규)
 ******************************************************** */
 function fn_storage_path_set(){
	 var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

	if(asis_flag == "0"){
		$("#storage_view").hide();
	}else{
		$("#storage_view").show();
	}
}


 /* ********************************************************
  * 신규 Storage 경로 확인
  ******************************************************** */
  function fn_new_storage_check(){
	 var new_storage = "/"+$("#restore_dir").val();
	 
	$("#dtb_pth").val(new_storage+$("#dtb_pth").val());
	$("#svrlog_pth").val(new_storage+$("#svrlog_pth").val());
 }
 
 
  /* ********************************************************
   * RMAN Restore 정보 저장
   ******************************************************** */
 function fn_execute(){
	 var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

	$.ajax({
			url : "/insertRmanRestore.do",
			data : {
				db_svr_id : db_svr_id,
				asis_flag : asis_flag,
				restore_dir : $("#restore_dir").val(),
				dtb_pth : $('#dtb_pth').val(),
				pgalog_pth : $('#pgalog_pth').val(),
				svrlog_pth : $('#svrlog_pth').val(),
				bck_pth : $('#bck_pth').val(),
				restore_cndt : 1,
				restore_flag : 0,		
				restore_nm : $('#restore_nm').val(),
				restore_exp : $('#restore_exp').val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				alert("긴급 복구를 시작합니다.");			
				fn_restoreLogCall();
			}
		}); 
 }
  
  
//복구명 중복체크
 function fn_check() {
 	var restore_nm = document.getElementById("restore_nm");
 	if (restore_nm.value == "") {
 		alert('<spring:message code="message.msg107" />');
 		document.getElementById('restore_nm').focus();
 		return;
 	}
 	$.ajax({
 		url : '/restore_nmCheck.do',
 		type : 'post',
 		data : {
 			restore_nm : $("#restore_nm").val()
 		},
 		success : function(result) {
 			if (result == "true") {
 				alert('등록 가능한 복구명 입니다.');
 				document.getElementById("restore_nm").focus();
 				wrk_nmChk = "success";		
 			} else {
 				scd_nmChk = "fail";
 				alert('이미 존재하는 복구명 입니다.');
 				document.getElementById("restore_nm").focus();
 			}
 		},
 		beforeSend: function(xhr) {
 	        xhr.setRequestHeader("AJAX", true);
 	     },
 		error : function(xhr, status, error) {
 			if(xhr.status == 401) {
 				alert('<spring:message code="message.msg02" />');
 				top.location.href = "/";
 			} else if(xhr.status == 403) {
 				alert('<spring:message code="message.msg03" />');
 				top.location.href = "/";
 			} else {
 				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
 			}
 		}
 	});
 } 



 function fn_restoreLogCall(){
	 	$.ajax({
	 		url : '/restoreLogCall.do',
	 		type : 'post',
	 		data : {
				db_svr_id : db_svr_id
	 		},	
	 		success : function(result) {
	 			$("#exelog").append(result.strResultData); 
	 		},
	 		beforeSend: function(xhr) {
	 	        xhr.setRequestHeader("AJAX", true);
	 	     },
	 		error : function(xhr, status, error) {
	 			if(xhr.status == 401) {
	 				alert('<spring:message code="message.msg02" />');
	 				top.location.href = "/";
	 			} else if(xhr.status == 403) {
	 				alert('<spring:message code="message.msg03" />');
	 				top.location.href = "/";
	 			} else {
	 				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
	 			}
	 		}
	 	}); 
 }
</script>





<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="restore.Emergency_Recovery" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="restore.Emergency_Recovery" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on"><spring:message code="restore.Emergency_Recovery" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
		<div class="btn_type_01">
			<span class="btn"><button type="button" id="btnSelect" onClick="fn_passwordConfilm();"><spring:message code="schedule.run" /></button></span>
		</div>

					<table class="write" style="border:1px solid #b8c3c6; border-collapse: separate;">
						<colgroup>
							<col style="width:130px;" />
							<col />
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_name" /></th>
								<td><input type="text" class="txt" name="restore_nm" id="restore_nm" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()"/>
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_Description" /></th>
								<td>
									<div class="textarea_grp">
										<textarea name="restore_exp" id="restore_exp" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="data_transfer.server_name" /></th>
								<td>
									<input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" readonly="readonly"  value="${db_svr_nm}">
								</td>
								<th scope="row" class="ico_t1"><spring:message code="restore.Server_IP" /></th>
								<td>
									<input type="text" class="txt" name="ipadr" id="ipadr" readonly="readonly"  value="${ipadr}">					
								</td>
							</tr>
						</tbody>
					</table>


		
				
				<div class="restore_grp">				
						<div class="restore_lt">	
					
					<table class="write" >
						<colgroup>
							<col style="width:120px;" />
							<col style="width:65px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>		
								<th scope="row" class="ico_t1">Storage <spring:message code="common.path" /></th>					
								<td>
									<input type="radio" name="asis_flag" id="storage_path_org" value="0"  onClick="fn_storage_path_set();" checked> <spring:message code="restore.existing" />
								</td>
								<td>
									<input type="radio" name="asis_flag" id="storage_path_new" value="1" onClick="fn_storage_path_set();"> <spring:message code="restore.new" />
								</td>
							</tr>
						</tbody>
					</table>
								
					<table class="write" id="storage_view">
						<colgroup>
							<col style="width:80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_Path" /></th>
								<td><input type="text" class="txt" name="restore_dir" id="restore_dir" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_new_storage_check()" style="width: 50px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>
								</td>
							</tr>
						</tbody>
					</table>
								
	
					<table class="write" style="border:1px solid #b8c3c6;padding:10px; margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Database Storage</th>							
							</tr>
							<tr>
								<td><input type="text" class="txt" name="dtb_pth" id="dtb_pth" style="width: 99%;" readonly="readonly" value="${pgdata}" />
							</tr>
						</tbody>
					</table>
					
					<table class="write" style="border:1px solid #b8c3c6;padding:10px; margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Archive WAL Storage</th>							
							</tr>
							<tr>
								<td><input type="text" class="txt" name="pgalog_pth" id="pgalog_pth" style="width: 99%;" readonly="readonly" value="${pgalog}" />
							</tr>
						</tbody>
					</table>
					
					<table class="write" style="border:1px solid #b8c3c6;padding:10px; margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Server Log Storage</th>							
							</tr>
							<tr>
								<td><input type="text" class="txt" name="svrlog_pth" id="svrlog_pth" style="width: 99%;" readonly="readonly" value="${srvlog}"/>
							</tr>
						</tbody>
					</table>
					
					<table class="write" style="border:1px solid #b8c3c6;padding:10px; margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Backup Storage</th>							
							</tr>
							<tr>
								<td><input type="text" class="txt" name="bck_pth" id="bck_pth" style="width: 99%;" readonly="readonly" value="${pgrbak}"/>
							</tr>
						</tbody>
					</table>
					</div>
								
								
				<div class="restore_rt">
						<p class="ly_tit"><h8>Restore <spring:message code="restore.Execution_log" /></h8></p>								
						<div class="overflow_area4" name="exelog_view"  id="exelog_view">
								<textarea name="exelog"  id="exelog" style="height:455px"></textarea>	
						</div>
				</div>
		</div> 
	</div>
</div>
<!-- // contents -->