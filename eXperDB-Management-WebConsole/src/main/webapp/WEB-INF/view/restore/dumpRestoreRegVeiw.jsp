<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
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

</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="restore.Dump_Recovery" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="restore.Dump_Recovery" /></li>
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
				<span class="btn"><button type="button" id="btnSelect" onClick="fn_passwordConfilm();"><spring:message code="schedule.run" /></button></span>
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
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="dbms_information.dbms_ip" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1">Database</th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()"disabled="disabled" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="etc.etc08" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.fileName" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.work_start_time" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.work_end_time" /></th>
									<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" disabled="disabled"/></td>
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
									<td>
										<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t10">
											<option value="0000"><spring:message code="common.choice" /></option>
											<option value="TC000401">auto</option>
											<option value="TC000402">custom</option>
											<option value="TC000403">directory</option>
											<option value="TC000404">tar</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">FileName</th>
									<td><input type="text" class="txt t9" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">Number of Jobs</th>
									<td><input type="text" class="txt t9" name="wrk_nm" id="wrk_nm" onblur="this.value=this.value.trim()" /></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">Role name</th>
									<td>
										<select name="usr_role_nm" id="usr_role_nm" class="select t10">
											<option value="0000"><spring:message code="common.choice" /></option>
											<c:forEach var="result" items="${roleList.data}" varStatus="status">
												<option value="<c:out value="${result.rolname}"/>"><c:out value="${result.rolname}" /></option>
											</c:forEach>
										</select>
									</td>
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
												<span><input type="checkbox" id="option_1_1" name="opt" value="Y" onClick="checkSection();" /><label for="option_1_1"><spring:message code="backup_management.pre-data" /></label></span> 
												<span><input type="checkbox" id="option_1_2" name="opt" value="Y" onClick="checkSection();" /><label for="option_1_2">Data</label></span>
												<span><input type="checkbox" id="option_1_3" name="opt" value="Y" onClick="checkSection();" /><label for="option_1_3"><spring:message code="backup_management.post-data" /></label></span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="backup_management.object_type" /></p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_2_1" name="opt" value="Y" onClick="checkObject();"/><label for="option_2_1"><spring:message code="backup_management.only_data" /></label></span> 
												<span><input type="checkbox" id="option_2_2" name="opt" value="Y" onClick="checkObject();"/><label for="option_2_2"><spring:message code="backup_management.only_schema" /> </label></span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="backup_management.save_yn_choice" /></p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_3_1" name="opt" value="Y"/><label for="option_3_1"><spring:message code="backup_management.owner" /> </label></span> 
												<span><input type="checkbox" id="option_3_2" name="opt" value="Y"/><label for="option_3_2"><spring:message code="backup_management.privilege" /></label></span> 
												<span><input type="checkbox" id="option_3_3" name="opt" value="Y"/><label for="option_3_3"><spring:message code="backup_management.tablespace" /></label></span>
											</div>
										</li>
									</ul>
								</div>
								<div class="view addOption_inr">
									<ul>
										<li>
											<p class="op_tit"><spring:message code="backup_management.query" /></p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_4_1" name="opt" value="Y"/><label for="option_4_1"><spring:message code="backup_management.create_database_include" /></label></span> 
												<span><input type="checkbox" id="option_4_2" name="opt" value="Y"/><label for="option_4_2">Clean before restore</label></span> 
												<span><input type="checkbox" id="option_4_3" name="opt" value="Y"/><label for="option_4_3">Single transaction</label></span>
											</div>
										</li>
										<li>
											<p class="op_tit">Disable</p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_5_1" name="opt" value="Y"/><label for="option_5_1">Trigger</label></span> 
												<span><input type="checkbox" id="option_5_2" name="opt" value="Y"/><label for="option_5_2">NoData for Failed Table</label></span>
											</div>
										</li>
										<li>
											<p class="op_tit"><spring:message code="common.etc" /></p>
											<div class="inp_chk">
												<span><input type="checkbox" id="option_6_1" name="opt" value="Y" checked="checked"/> <label for="option_6_1">Verbose Message </label></span> 
												<span><input type="checkbox" id="option_6_2" name="opt" value="Y"/><label for="option_6_2">Use SET SESSION AUTHORIZATION </label></span> 
												<span><input type="checkbox" id="option_6_3" name="opt" value="Y"/><label for="option_6_3">Exit on Error </label></span>
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>
						</form>
					</div>
				</div>

				<div class="restore_rt">
					<p class="ly_tit"><h8>Restore <spring:message code="restore.Execution_log" /></h8></p>
					<div class="overflow_area4" name="restoreExeLog" id="restoreExeLog"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
