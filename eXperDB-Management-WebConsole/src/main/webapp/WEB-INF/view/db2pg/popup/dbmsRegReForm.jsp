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

 /* ********************************************************
  * Validation Check
  ******************************************************** */
  function fn_validation_reg_re(){
		if(connection != "success"){
			showSwalIcon('<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
 		return true;
 }

  
/* ********************************************************
 * DBMS 연결테스트
 ******************************************************** */
 function fn_connTest_reg_re(){
     $.ajax({
 		url : "/dbmsConnTest.do",
 		data : {
 		 	ipadr : $("#ipadr_reg_re").val(),
 		 	portno : $("#portno_reg_re").val(),
 		  	dtb_nm : $("#dtb_nm_reg_re").val(),
 		   	spr_usr_id : $("#spr_usr_id_reg_re").val(),
 		   	pwd : $("#pwd_reg_re").val(),
 		  	dbms_dscd : $("#dbms_dscd_reg_re").val()
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
 * DBMS 수정
 ******************************************************** */
 	function fn_updateDBMS(){

 	 if (!fn_validation_reg_re()) return false;

 	$.ajax({
  		url : "/updateDb2pgDBMS.do",
  		data : {
  			db2pg_sys_id : $("#db2pg_sys_id_reg_re").val(),
  			db2pg_sys_nm : $("#db2pg_sys_nm_reg_re").val(),
  			ipadr : $("#ipadr_reg_re").val(),
  		 	portno : $("#portno_reg_re").val(),
  		  	dtb_nm : $("#dtb_nm_reg_re").val(),
  		  	scm_nm : $("#scm_nm_reg_re").val(),
  		   	spr_usr_id : $("#spr_usr_id_reg_re").val(),
  		   	pwd : $("#pwd_reg_re").val(),
  		  	dbms_dscd : $("#dbms_dscd_reg_re").val(),
  		  	crts_nm : $("#crts_nm_reg_re").val()
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
  		}
  	});    
	}
 
</script>
<div class="modal fade" id="pop_layer_db2pg_dbms_reg_re" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="migration.source/target_dbms_modify"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" name="dbserverMod" id="dbserverMod" method="post">
					<input type="hidden" name="db2pg_sys_id_reg_re" id="db2pg_sys_id_reg_re"/>
						<fieldset>
							<div class="card-body" style="border: 1px solid #adb5bd;">
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.system_name" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 100%;" autocomplete="off" maxlength="20" id="db2pg_sys_nm_reg_re" name="db2pg_sys_nm_reg_re" onkeyup="fn_checkWord(this,20)" readonly />
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										DBMS<spring:message code="properties.division"/>(*)
									</label>
									<div class="col-sm-4">
										<select name="dbms_dscd_reg_re" id="dbms_dscd_reg_re" class="form-control"  style="margin-right: 1rem;width: 100% !important;" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
											<option value=""><spring:message code="common.choice" /></option>				
											<c:forEach var="dbmsGrb_reg_re" items="${dbmsGrb_reg_re}" varStatus="status">				
											<option value="<c:out value="${dbmsGrb_reg_re.sys_cd}"/>"<c:if test="${resultInfo[0].dbms_dscd_nm eq dbmsGrb_reg_re.sys_cd_nm}"> selected</c:if>><c:out value="${dbmsGrb_reg_re.sys_cd_nm}"/></option>								 
 											</c:forEach>
										</select>
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.ip" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="ipadr_reg_re" name="ipadr_reg_re" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>"/>
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="portno_reg_re" name="portno_reg_re" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>"/>
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="dtb_nm_reg_re" name="dtb_nm_reg_re" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;" >
										<i class="item-icon fa fa-dot-circle-o"></i>
										Schema(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="scm_nm_reg_re" name="scm_nm_reg_re"/>
									</div>
								</div>
								<div class="form-group row">
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account"/>(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="text" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="spr_usr_id_reg_re" name="spr_usr_id_reg_re" onkeyup="fn_checkWord(this,30)" onblur="this.value=this.value.trim()" placeholder="30<spring:message code='message.msg188'/>" />
									</div>
									<label for="ins_usr_id" class="col-sm-2 col-form-label pop-label-index" style="margin-right:0px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input style="display:none" aria-hidden="true">
										<input type="password" class="form-control" style="width: 250px;" autocomplete="off" maxlength="30" id="pwd_reg_re" name="pwd_reg_re" />
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:-15px;">
									<label for="ins_usr_nm" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="migration.character_set"/>(*)
									</label>
									<div class="col-sm-4">
										<select name="crts_nm_reg_re" id="crts_nm_reg_re" class="form-control" style="margin-right: 1rem;width: 100% !important;"></select>
									</div>
								</div>
							</div>
							<br/>
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_updateDBMS();" value='<spring:message code="common.modify" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_connTest_reg_re();" value='<spring:message code="dbms_information.conn_Test" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
