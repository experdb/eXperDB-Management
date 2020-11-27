<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : dbServerRegForm.jsp
	* @Description : 디비 서버 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.01     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>   
<script type="text/javascript">

//연결테스트 확인여부
var connection = "fail";

var table = null;
var db2pg_sys_nmChk = "fail";

/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	//$("#crts_nm_self").hide();
	$("#pgbtn").hide();
	$("#schema_any_reg").show();
	$("#schema_pg_reg").hide();
});



/* ********************************************************
 * 시스템명 중복체크
 ******************************************************** */
 function fn_sysnmCheck(){
		if ($("#db2pg_sys_nm_reg").val() == "") {
			showSwalIcon('<spring:message code="migration.msg01" />', '<spring:message code="common.close" />', '', 'error');
			document.getElementById('db2pg_sys_nm_reg').focus();
			return;
		}
		
		$.ajax({
			url : '/db2pg_sys_nmCheck.do',
			type : 'post',
			data : {
				db2pg_sys_nm : $("#db2pg_sys_nm_reg").val()
			},
			success : function(result) {
				if (result == "true") {
					showSwalIcon('<spring:message code="migration.msg04"/>', '<spring:message code="common.close" />', '', 'success');
					document.getElementById("db2pg_sys_nm_reg").focus();
					db2pg_sys_nmChk = "success";
				} else {
					db2pg_sys_nmChk = "fail";
					showSwalIcon('<spring:message code="migration.msg05" />', '<spring:message code="common.close" />', '', 'error');
					document.getElementById("db2pg_sys_nm_reg").focus();
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
}
 
 /* ********************************************************
  * 기 등록된 PostgreSQL 서버 호출 팝업 (현재는 등록되어 있는 PG모두)
  ******************************************************** */
 function fn_pgdbmsCall(){
	 $('#pop_layer_pgdbms_reg').modal("show");		
}
 
 
 /* ********************************************************
  * 기 등록된 PostgreSQL 서버 호출하여 입력
  ******************************************************** */
 function fn_pgDbmsAddCallback(pgDBMS){
	 
	 $('#ipadr_reg').val(pgDBMS[0].ipadr);
	 $('#dtb_nm_reg').val(pgDBMS[0].db_nm);
	 $('#portno_reg').val(pgDBMS[0].portno);
	 $('#spr_usr_id_reg').val(pgDBMS[0].svr_spr_usr_id);
	 $('#pwd_reg').val(pgDBMS[0].svr_spr_scm_pwd);
	 
	 $.ajax({
			url : "/selectPgSchemaList.do",
			data : {
				ipadr : pgDBMS[0].ipadr,
				dtb_nm : pgDBMS[0].db_nm,
				portno : pgDBMS[0].portno,
				spr_usr_id : pgDBMS[0].svr_spr_usr_id,
				pwd : pgDBMS[0].svr_spr_scm_pwd
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {		
				$("#schema_any_reg").hide();
				$("#schema_pg_reg").show();
				$('#schema_pg_reg').empty();
				for(var i=0; i<result.data.length; i++){
					$('<option value="'+ result.data[i].schema +'">' + result.data[i].schema + '</option>').appendTo('#schema_pg_reg');
					}
			}
		});  
 }
 
 /* ********************************************************
  * DBMS선택시 해당 케릭터셋 출력
  ******************************************************** */
function fn_charSet(){

	$('#ipadr_reg').val('');
	$('#dtb_nm_reg').val('');
	$('#spr_usr_id_reg').val('');
	$('#portno_reg').val('');
	$('#pwd_reg').val('');
	$('#schema_pg_reg').val('');
	$('#schema_any_reg').val('');
	 
	//DBMS구분 PG일경우 불러오기 버튼 호출		
	if($("#dbms_dscd_reg").val() == "TC002204"){
		$("#pgbtn").show();
	}else{
		$("#pgbtn").hide();
		$("#schema_any_reg").show();
		$("#schema_pg_reg").hide();
	}
	
	 var dbms_dscd = $("#dbms_dscd_reg option:selected").val();

	 $.ajax({
			url : "/selectCharSetList.do",
			data : {
				dbms_dscd : dbms_dscd
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
		 		$('#crts_nm_reg').empty();
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$('<option value="'+ result[i].sys_cd+'">' + result[i].sys_cd_nm + '</option>').appendTo('#crts_nm_reg');
						}
				}else{

				} 
			}
		}); 
 }
  
  
 /* ********************************************************
  * Validation Check
  ******************************************************** */
  function fn_validation(){
		if(connection != "success"){
			showSwalIcon('<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		 if (db2pg_sys_nmChk =="fail") {
			 showSwalIcon('<spring:message code="migration.msg14" />', '<spring:message code="common.close" />', '', 'error');
			 return false;
		 }	 
		var ipadr = document.getElementById("ipadr_reg");
		if (ipadr.value == "") {
			 showSwalIcon('<spring:message code="migration.msg15" />', '<spring:message code="common.close" />', '', 'error');
			   ipadr.focus();
			   return false;
		}
		var dtb_nm = document.getElementById("dtb_nm_reg");
 		if (dtb_nm.value == "") {
 			 showSwalIcon('<spring:message code="migration.msg16" />', '<spring:message code="common.close" />', '', 'error');
  			 dft_db_nm.focus();
  			   return false;
  		}


 		if($("#dbms_dscd_reg").val()  == 'TC002204'){
			var schema_pg = document.getElementById("schema_pg_reg");
			var schema_any = document.getElementById("schema_any_reg");
		 		if (schema_pg.value == "") {
		 			if (schema_any.value == "") {
		 				showSwalIcon('<spring:message code="migration.msg17" />', '<spring:message code="common.close" />', '', 'error');
			  			schema_any.focus();
			  			return false;
			  		}
		  		}
		}else{
			var schema_any = document.getElementById("schema_any_reg");
	 		if (schema_any.value == "") {
	 			showSwalIcon('<spring:message code="migration.msg17" />', '<spring:message code="common.close" />', '', 'error');
	  			schema_any.focus();
	  			return false;
	  		}
		}
		
 		var portno = document.getElementById("portno_reg");
		if (portno.value == "") {
			showSwalIcon('<spring:message code="migration.msg18" />', '<spring:message code="common.close" />', '', 'error');
			portno.focus();
			return false;
		}
 		if(!valid_numeric(portno.value))
	 	{
 			showSwalIcon('<spring:message code="message.msg49" />', '<spring:message code="common.close" />', '', 'error');
 			portno.focus();
		 	return false;
		}		
 		
 		var spr_usr_id = document.getElementById("spr_usr_id_reg");
 		if (spr_usr_id.value == "") {
 			showSwalIcon('<spring:message code="migration.msg19" />', '<spring:message code="common.close" />', '', 'error');
  			spr_usr_id.focus();
  			return false;
  		}		
 		
 		var pwd = document.getElementById("pwd_reg");
 		if (pwd.value == "") {
 			showSwalIcon('<spring:message code="migration.msg20" />', '<spring:message code="common.close" />', '', 'error');
  			pwd.focus();
  			return false;
  		}	
 		
 		return true;
 }
  
  /* ********************************************************
   * Validation Check 숫자체크
   ******************************************************** */
  function valid_numeric(objValue)
  {
  	if (objValue.match(/^[0-9]+$/) == null)
  	{	return false;	}
  	else
  	{	return true;	}
  } 
  
  
/* ********************************************************
 * Source DBMS 연결테스트
 ******************************************************** */
 function fn_connTest2(){

	if ($("#ipadr_reg").val() == null || $("#ipadr_reg").val() == "") {
		showSwalIcon('<spring:message code="migration.msg15" />', '<spring:message code="common.close" />', '', 'error');
		return;
	}

	if ($("#portno_reg").val()==null || $("#portno_reg").val() == "") {
		showSwalIcon('<spring:message code="migration.msg18" />', '<spring:message code="common.close" />', '', 'error');
		return;
	}

     $.ajax({
 		url : "/dbmsConnTest.do",
 		data : {
 		 	ipadr : $("#ipadr_reg").val(),
 		 	portno : $("#portno_reg").val(),
 		  	dtb_nm : $("#dtb_nm_reg").val(),
 		   	spr_usr_id : $("#spr_usr_id_reg").val(),
 		   	pwd : $("#pwd_reg").val(),
 		  	dbms_dscd : $("#dbms_dscd_reg").val()
 		},
 		type : "post",
 		beforeSend: function(xhr) {
 	        xhr.setRequestHeader("AJAX", true);
 	     },
 		error : function(xhr, status, error) {
 			if(xhr.status == 401) {
 				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
 			} else if(xhr.status == 403) {
 				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
 			} else {
 				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
 			}
 		},
 		success : function(result) {
 			if(result.RESULT_CODE == 0){		
 				connection= "success";			
 				showSwalIcon(result.RESULT_Conn, '<spring:message code="common.close" />', '', 'success');
 			}else{
 				connection = "fail";
 				showSwalIcon(result.ERR_MSG, '<spring:message code="common.close" />', '', 'error');
 				return false;
 			}		
 		}
 	});     
 }
 

/* ********************************************************
 * DBMS 등록
 ******************************************************** */
 	function fn_insertDBMS(){
		
 		var crts_nm = null;
		
 		// Validation 체크
 		 if (!fn_validation()) return false;


 		if($("#dbms_dscd_reg").val()  == 'TC002204'){
 			if(document.getElementById("schema_pg_reg").value == ""){
 				var scm_nm = document.getElementById("schema_any_reg").value;	
 			}else{
 				var scm_nm = document.getElementById("schema_pg_reg").value;
 			}
 		}else{
 			var scm_nm = document.getElementById("schema_any_reg").value;	
 		}
 		
 	$.ajax({
  		url : "/insertDb2pgDBMS.do",
  		data : {
  		 	db2pg_sys_nm : $("#db2pg_sys_nm_reg").val(),
  			ipadr : $("#ipadr_reg").val(),
  		 	portno : $("#portno_reg").val(),
  		  	dtb_nm : $("#dtb_nm_reg").val(),
  		  	scm_nm : scm_nm,
  		   	spr_usr_id : $("#spr_usr_id_reg").val(),
  		   	pwd : $("#pwd_reg").val(),
  		  	dbms_dscd : $("#dbms_dscd_reg").val(),
  		  	crts_nm : $("#crts_nm_reg").val()
  		},
  		type : "post",
  		beforeSend: function(xhr) {
  	        xhr.setRequestHeader("AJAX", true);
  	     },
  		error : function(xhr, status, error) {
  			if(xhr.status == 401) {
  				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
  			} else if(xhr.status == 403) {
  				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
  			} else {
  				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
  			}
  		},
  		success : function(result) {
			showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success', "reload");
			$('#pop_layer_db2pg_dbms_reg').modal("hide");
  		}
  	});    
	}
	
	
/* function fn_charChange(){
	
	if($("#dbms_dscd").val() == "TC002202"){
		if($("#crts_nm").val() == "TC003805"){
			$("#crts_nm_self").show();
		}else{
			$("#crts_nm_self").hide();
		}		
	}
}	 */
 
</script>
<div class="modal fade" id="pop_layer_db2pg_dbms_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="migration.source/target_dbms_register"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" name="dbmsInsert" id="dbmsInsert" method="post">
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.system_name" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 100%;" autocomplete="off" maxlength="20" id="db2pg_sys_nm_reg" name="db2pg_sys_nm_reg" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" placeholder="20<spring:message code='message.msg188'/>" tabindex=1 />
									</div>
									<div class="col-sm-1_5">
										<input class="btn btn-inverse-danger btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" type="button" onclick="fn_sysnmCheck();" value='<spring:message code="common.overlap_check" />' />
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										DBMS<spring:message code="properties.division"/>(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="margin-right: 1rem;width: 100% !important;" name="dbms_dscd_reg" id="dbms_dscd_reg" onChange ="fn_charSet()">
											<option value=""><spring:message code="common.choice" /></option>				
											<c:forEach var="dbmsGrb_reg" items="${dbmsGrb_reg}" varStatus="status">												 
					 							<option value="<c:out value="${dbmsGrb_reg.sys_cd}"/>" ><c:out value="${dbmsGrb_reg.sys_cd_nm}"/></option>
					 						</c:forEach>
										</select>
									</div>
									<div class="col-sm-1_5">
										<input class="btn btn-inverse-primary btn-icon-text mdi mdi-lan-connect" style="margin-left:-20px;" id="pgbtn" type="button" onclick="fn_pgdbmsCall();" value='<spring:message code="migration.loading" />' />
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<%-- <input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="ipadr_reg" name="ipadr_reg" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" /> --%>
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" id="ipadr_reg" name="ipadr_reg" onblur="this.value=this.value.trim()"  />
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="portno_reg" name="portno_reg" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="dtb_nm_reg" name="dtb_nm_reg" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="schema_any_reg" name="scm_nm_reg" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
										<select name="scm_nm" id="schema_pg_reg" class="form-control" style="margin-right: 1rem;width: 100% !important;"></select>
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account"/>(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="spr_usr_id_reg" name="spr_usr_id_reg" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="password" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="pwd_reg" name="pwd_reg" />
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:-15px;">
									<label for="ins_usr_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.character_set"/>(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control" style="margin-right: 1rem;width: 100% !important;" name="crts_nm_reg" id="crts_nm_reg" onChange ="fn_charChange()"></select>
									</div>
								</div>
							</div>
							<br/>
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_insertDBMS();" value='<spring:message code="common.registory" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_connTest2();" value='<spring:message code="dbms_information.conn_Test" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>