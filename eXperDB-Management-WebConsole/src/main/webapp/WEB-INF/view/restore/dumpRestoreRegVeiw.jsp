<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%@include file="../cmmn/passwordConfirm.jsp"%>

<%
	/**
	* @Class Name : restoreHistory.jsp
	* @Description : restoreHistory 화면
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
<script>
var exe_sn = "${exe_sn}";
var db_svr_id = "${db_svr_id}";
var wrk_id = "${wrk_id}";
var flag = "dump";
var restore_nmChk ="fail";
/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(function() {

	$.ajax({
		url : "/selectBckInfo.do",
	  	data : {
	  		exe_sn : exe_sn,
	  		db_svr_id : db_svr_id
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
			document.getElementById("wrk_nm").value = result[0].wrk_nm;
			document.getElementById("exe_rslt_cd_nm").value = result[0].exe_rslt_cd_nm;
			document.getElementById("ipadr").value = result[0].ipadr;
			document.getElementById("db_nm").value = result[0].db_nm;
			document.getElementById("bck_file_pth").value = result[0].bck_file_pth;
			document.getElementById("bck_filenm").value = result[0].bck_filenm;
			document.getElementById("wrk_strt_dtm").value = result[0].wrk_strt_dtm;
			document.getElementById("wrk_end_dtm").value = result[0].wrk_end_dtm;		
			document.getElementById("file_fmt_cd").value = result[0].file_fmt_cd;
			document.getElementById("file_fmt_cd_nm").value = result[0].file_fmt_cd_nm;
			document.getElementById("usr_role_nm").value = result[0].usr_role_nm;
		}
	});
});


/* ********************************************************
 * 부가옵션 Section 선택 시
 ******************************************************** */
function checkSection(){
	var section = $(option_1_1).is(":checked");
	var section2 = $(option_1_2).is(":checked");
	var section3 = $(option_1_3).is(":checked");
	if(section==true || section2==true || section3==true){
		$('#option_2_1').attr('disabled', 'true');
		$('#option_2_2').attr('disabled', 'true');
	}else{
		$('#option_2_1').removeAttr('disabled');
		$('#option_2_2').removeAttr('disabled');
	}
}

/* ********************************************************
 * 부가옵션 Object 선택 시
 ******************************************************** */
function checkObject(){
	var object = $(option_2_1).is(":checked");
	var object2 = $(option_2_2).is(":checked");
	if(object==true){
		$('#option_1_1').attr('disabled', 'true');
		$('#option_1_2').attr('disabled', 'true');
		$('#option_1_3').attr('disabled', 'true');
		$('#option_2_2').attr('disabled', 'true');
	}else{
		if(object2==true){
			$('#option_1_1').attr('disabled', 'true');
			$('#option_1_2').attr('disabled', 'true');
			$('#option_1_3').attr('disabled', 'true');
			$('#option_2_1').attr('disabled', 'true');
		}else{
			$('#option_1_1').removeAttr('disabled');
			$('#option_1_2').removeAttr('disabled');
			$('#option_1_3').removeAttr('disabled');
			$('#option_2_1').removeAttr('disabled');
			$('#option_2_2').removeAttr('disabled');
		}
	} 
	
}

/* ********************************************************
 * Validation
 ******************************************************** */
function fn_Validation() {
	var restore_nm = document.getElementById('restore_nm');
	var restore_exp = document.getElementById('restore_exp');
	
	if (restore_nm.value == "" || restore_nm.value == "undefind" || restore_nm.value == null) {
		alert("복원명을 넣어주세요.");
		restore_nm.focus();
		return false;
	}else if(restore_nmChk =="fail"){
		alert('복원명 중복체크 바랍니다.');
		return false;
	}else if (restore_exp.value == "" || restore_exp.value == "undefind" || restore_exp.value == null) {
		alert("복원 설명을 넣어주세요.");
		restore_exp.focus();
		return false;
	}
	
	fn_passwordConfilm('dump');
}


/* ********************************************************
 * Dump 복구명 중복체크
 ******************************************************** */
function fn_check(){
	var restore_nm = document.getElementById("restore_nm");
	if (restore_nm.value == "") {
		alert('복원명을 입력해주세요.');
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
				alert('<spring:message code="restore.msg221" />');
				document.getElementById("restore_nm").focus();
				restore_nmChk = "success";
			} else {
				restore_nmChk = "fail";
				alert('<spring:message code="restore.msg222" />');
				document.getElementById("restore_nm").focus();
			}
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if (xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : " + xhr.status + "\n\n"
						+ "ERROR Message : " + error + "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		}
	});
}

/* ********************************************************
 * Dump Restore 정보 저장
 ******************************************************** */
function fn_execute() {
	$("input[name=opt]").each(function(){
		if( $(this).is(":checked")){
			$(this).val("Y");
		}
	})
	
	$.ajax({
		url : "/insertDumpRestore.do",
		data : {			
			db_svr_id : db_svr_id,
			bck_file_pth : $("#bck_file_pth").val(),
			restore_nm : $("#restore_nm").val(),
			restore_exp : $("#restore_exp").val(),
			wrk_id : wrk_id,
			wrkexe_sn : exe_sn,
			restore_cndt : 1,
			format : $("#file_fmt_cd_nm").val(),
			filename : $("#bck_filenm").val(),
			jobs : $("#jobs").val(),
			role : $("#usr_role_nm").val(),
			pre_data_yn : $("#option_1_1").val(),
			data_yn : $("#option_1_2").val(),
			post_data_yn : $("#option_1_3").val(),
			data_only_yn : $("#option_2_1").val(),
			schema_only_yn : $("#option_2_2").val(),
			no_owner_yn : $("#option_3_1").val(),
			no_privileges_yn : $("#option_3_2").val(),
			no_tablespaces_yn : $("#option_3_3").val(),
			create_yn : $("#option_4_1").val(),
			clean_yn : $("#option_4_2").val(),
			single_transaction_yn : $("#option_4_3").val(),
			disable_triggers_yn : $("#option_5_1").val(),
			no_data_for_failed_tables_yn : $("#option_5_2").val(),
			verbose_yn : $("#option_6_1").val(),
			use_set_sesson_auth_yn : $("#option_6_2").val(),
			exit_on_error_yn : $("#option_6_3").val()
		},
		dataType : "json",
		type : "post",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if (xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : " + xhr.status + "\n\n"
						+ "ERROR Message : " + error + "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			alert('<spring:message code="restore.msg220" />');
			fn_dumpRestoreLogCall();
		}
	});
}


function fn_dumpRestoreLogCall() {
	$.ajax({
		url : '/dumpRestoreLogCall.do',
		type : 'post',
		data : {
			db_svr_id : db_svr_id
		},
		success : function(result) {
			$("#exelog").append(result.strResultData);
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if (xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : " + xhr.status + "\n\n"
						+ "ERROR Message : " + error + "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		}
	});
}

</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="restore.Dump_Recovery" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.Dump_Recovery" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on"><spring:message code="restore.Dump_Recovery" /></li>
				</ul>
			</div>
		</div>
		<div class="contents" style="min-height: 950px">
			<div class="btn_type_01">
				<span class="btn"><button type="button" id="btnSelect" onClick="fn_Validation();"><spring:message code="schedule.run" /></button></span>
			</div>
			<div class="sch_form">
				<table class="write">
					<colgroup>
						<col style="width: 140px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_name" /></th>
							<td>
								<input type="text" class="txt t2" name="restore_nm" id="restore_nm" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()" style="width: 250px;" /> 
								<span class="btn btnF_04 btnC_01"><button type="button" class="btn_type_02" onclick="fn_check()" style="width: 100px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_Description" /></th>
							<td colspan="3">
								<div class="textarea_grp">
									<textarea name="restore_exp" id="restore_exp" maxlength="150" onkeyup="fn_checkWord(this,150)" placeholder="150<spring:message code='message.msg188'/>"></textarea>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="restore_dump_grp">
				<div class="restore_lt">
					<div class="pop_cmm">
						<table class="write">
							<colgroup>
								<col style="width: 20%;" />
								<col />
								<col style="width: 20%;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled" /></td>
									<th scope="row" class="ico_t1"><spring:message code="common.status" /></th>
									<td><input type="text" class="txt t4" name="exe_rslt_cd_nm" id="exe_rslt_cd_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="dbms_information.dbms_ip" /></th>
									<td><input type="text" class="txt t4" name="ipadr" id="ipadr" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1">Database</th>
									<td><input type="text" class="txt t4" name="db_nm" id="db_nm" onblur="this.value=this.value.trim()"disabled="disabled" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="etc.etc08" /></th>
									<td><input type="text" class="txt t4" name="bck_file_pth" id="bck_file_pth" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.fileName" /></th>
									<td><input type="text" class="txt t4" name="bck_filenm" id="bck_filenm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.work_start_time" /></th>
									<td><input type="text" class="txt t4" name="wrk_strt_dtm" id="wrk_strt_dtm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.work_end_time" /></th>
									<td><input type="text" class="txt t4" name="wrk_end_dtm" id="wrk_end_dtm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="pop_cmm">
						<table class="write">
							<colgroup>
								<col style="width: 115px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1">Format</th>
									<td><input type="text" class="txt t9" name="file_fmt_cd_nm" id="file_fmt_cd_nm" onblur="this.value=this.value.trim()" disabled="disabled"/>
											<input type="hidden" name="file_fmt_cd" id="file_fmt_cd" >
									</td>
									<%-- <td>
										<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t10">
											<option value="0000"><spring:message code="common.choice" /></option>
											<option value="TC000401">auto</option>
											<option value="TC000402">custom</option>
											<option value="TC000403">directory</option>
											<option value="TC000404">tar</option>
										</select>
									</td> --%>
								</tr>
								<!-- <tr>
									<th scope="row" class="ico_t1">FileName</th>
									<td><input type="text" class="txt t9" name="file_nm" id="file_nm" onblur="this.value=this.value.trim()" /></td>
								</tr> -->								
								<tr>
									<th scope="row" class="ico_t1">Role name</th>
									<td><input type="text" class="txt t9" name="usr_role_nm" id="usr_role_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<%-- 
									<td>
										<select name="usr_role_nm" id="usr_role_nm" class="select t10">
											<option value="0000"><spring:message code="common.choice" /></option>
											<c:forEach var="result" items="${roleList.data}" varStatus="status">
												<option value="<c:out value="${result.rolname}"/>"><c:out value="${result.rolname}" /></option>
											</c:forEach>
										</select>
									</td>
								</tr> --%>
								<tr>
									<th scope="row" class="ico_t1">Number of Jobs</th>
									<td><input type="text" class="txt t9" name="jobs" id="jobs" onblur="this.value=this.value.trim()" /></td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="pop_cmm">
						<div class="addOption_restore_grp">
							<ul class="tab">
								<li class="on"><a href="#n"><spring:message code="backup_management.add_option" /> #1</a></li>
								<li><a href="#n"><spring:message code="backup_management.add_option" /> #2</a></li>
							</ul>
							<div class="tab_view">
								<div class="view on addOption_inr">
									<ul>
										<li>
											<p class="op_tit"><spring:message code="backup_management.sections" /></p>
											<div class="inp_chk">
													<span>
														<input type="checkbox" id="option_1_1" name="opt" value="N" grp_cd="TC0006" opt_cd="TC000601" onClick="checkSection();"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000601'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_1_1"><spring:message code="backup_management.pre-data" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_1_2" name="opt" value="N" grp_cd="TC0006" opt_cd="TC000602" onClick="checkSection();"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000602'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_1_2"><spring:message code="backup_management.data" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_1_3" name="opt" value="N" grp_cd="TC0006" opt_cd="TC000603" onClick="checkSection();"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000603'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_1_3"><spring:message code="backup_management.post-data" /></label>
													</span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="backup_management.object_type" /></p>
											<div class="inp_chk">
													<span>
														<input type="checkbox" id="option_2_1" name="opt" value="N" grp_cd="TC0007" opt_cd="TC000701" onClick="checkObject('TC000701');"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000701'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_2_1"><spring:message code="backup_management.only_data" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_2_2" name="opt" value="N" grp_cd="TC0007" opt_cd="TC000702" onClick="checkObject('TC000702');"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000702'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_2_2"><spring:message code="backup_management.only_schema" /></label>
													</span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="backup_management.save_yn_choice" /></p>
											<div class="inp_chk">
													<span>
														<input type="checkbox" id="option_3_1" name="opt" value="N" grp_cd="TC0008" opt_cd="TC000801"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000801'}">checked</c:if>
														</c:forEach>
														 />
														<label for="option_3_1"><spring:message code="backup_management.owner" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_3_2" name="opt" value="N" grp_cd="TC0008" opt_cd="TC000802"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000802'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_3_2"><spring:message code="backup_management.privilege" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_3_3" name="opt" value="N" grp_cd="TC0008" opt_cd="TC000803"
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000803'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_3_3"><spring:message code="backup_management.tablespace" /></label>
													</span>
											</div>
										</li>
									</ul>
								</div>
								<div class="view addOption_inr">
									<ul>
										<li>
											<p class="op_tit"><spring:message code="backup_management.query" /></p>
											<div class="inp_chk">
													<span>
														<input type="checkbox" id="option_4_1" name="opt" value="N" grp_cd="TC0009" opt_cd="TC000903" 
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000903'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_4_1"><spring:message code="backup_management.create_database_include" /></label>
													</span>
													<span>
														<input type="checkbox" id="option_4_2" name="opt" value="N" grp_cd="TC0009" opt_cd="TC000905" 
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000905'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_4_2">Clean before restore</label>
													</span>
													<span>
														<input type="checkbox" id="option_4_3" name="opt" value="N" grp_cd="TC0009" opt_cd="TC000906" 
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000906'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_4_3">Single transaction</label>
													</span>
											</div>
										</li>
										<li>
											<p class="op_tit">Disable</p>
											<div class="inp_chk">
													<span>
														<input type="checkbox" id="option_5_1" name="opt" value="N" grp_cd="TC0021" opt_cd="TC002101" 
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0021' && optVal.opt_cd eq 'TC002101'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_5_1">Trigger</label>
													</span>
													<span>
														<input type="checkbox" id="option_5_2" name="opt" value="N" grp_cd="TC0021" opt_cd="TC002102" 
														<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
															<c:if test="${optVal.grp_cd eq 'TC0021' && optVal.opt_cd eq 'TC002102'}">checked</c:if>
														</c:forEach>
														/>
														<label for="option_5_2">NoData for Failed Table</label>
													</span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="common.etc" /></p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_6_1" name="opt" value="Y" checked="checked"/> <label for="option_6_1">Verbose Message </label></span> 
												<span>
													<input type="checkbox" id="option_6_2" name="opt" value="N" grp_cd="TC0010" opt_cd="TC001004"
													<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
														<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001004'}">checked</c:if>
													</c:forEach>
													/>
													<label for="option_6_2"><spring:message code="backup_management.set_session_auth_use" /></label>
												</span> 
												<span>
													<input type="checkbox" id="option_6_3" name="opt" value="N" grp_cd="TC0010" opt_cd="TC001004"
													<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
														<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001004'}">checked</c:if>
													</c:forEach>
													/>
													<label for="option_6_3">Exit on Error </label>
												</span>
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
								
				<div class="restore_rt">
					<p class="ly_tit"><h8>Restore <spring:message code="restore.Execution_log" /></h8></p>
					<div class="overflow_area4" name="exelog" id="exelog"></div>
				</div>
				
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
