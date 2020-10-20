<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : dbAuthority.jsp
	* @Description : DbAuthority 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.29     최초 생성
	*
	* author 변승우 사원
	* since 2017.05.29
	*
	*/
%>
<script>
	var userTable = null;
	var dbServerTable = null;
	var svr_server = null;
	var confile_title = "";
	var datasArr = new Array();
	
	var scale_yn_chk = "${scale_yn_chk}";

	$(window.document).ready(function() {
		fn_buttonAut();
		fn_init();

		$.ajax({
			url : "/selectDBSvrAutUserManager.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				userTable.clear().draw();
				userTable.rows.add(result).draw();
			}
		});

		$.ajax({
			url : "/selectDBSrvAutInfo.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				svr_server = result;
			//	var parseData = $.parseJSON(result);
			 	var html1 = "";	
			 	html1+='<table  class="table table-hover" style="width:100%;">';
				html1+='<colgroup>';
				html1+=	'<col style="width:85%" />';
				html1+=	'<col style="width:15%" />';
				html1+='</colgroup>';
				html1+='<thead>';
				html1+=	'<tr class="bg-info text-white ">';
				html1+=		'<th scope="col"><spring:message code="auth_management.db_server_menu" /></th>';
				html1+=		'<th scope="col"><spring:message code="auth_management.auth" /></th>';
				html1+=	'</tr>';
				html1+='</thead>';
	 			$(result).each(function (index, item) {
					//var html = "";
 					html1+='<tbody>';
					html1+='<tr class="bg-primary text-white">';
					html1+='		<td>'+item.db_svr_nm+'</td>';
					html1+='		<td><div class="inp_chk"><input type="checkbox" id="'+item.db_svr_id+'" onClick="fn_allCheck(\''+item.db_svr_id+'\');">';
					html1+='		<label for="'+item.db_svr_id+'"></lavel></div></td>';
					html1+='	</tr>';
					
					if (scale_yn_chk == "Y") {
						/* 2020.04.09 scale_cng 추가 start */
						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="menu.eXperDB_scale_settings" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_scale_cng" name="eXperDB_scale_cng" onClick="fn_userCheck();"/>';
						html1+='       		<label for="'+item.db_svr_id+'_scale_cng"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';
						/* 2020.04.09 scale_cng 추가 end */

						/* 2020.03.03 scale 추가 start */
						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="menu.scale_manual" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_scale" name="eXperDB_scale" onClick="fn_userCheck();"/>';
						html1+='       		<label for="'+item.db_svr_id+'_scale"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';
						/* 2020.03.03 scale 추가 end */
						
						/* 2020.04.03 scale_hist 추가 start */
						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="menu.eXperDB_scale_history" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_scale_hist" name="eXperDB_scale_hist" onClick="fn_userCheck();"/>';
						html1+='       		<label for="'+item.db_svr_id+'_scale_hist"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';
						/* 2020.04.03 scale_hist 추가 end */
					}

					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.backup_settings" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_bck_cng" name="bck_cng_aut" onClick="fn_userCheck();"/>';
					html1+='       		<label for="'+item.db_svr_id+'_bck_cng"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.backup_history" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_bck_hist" name="bck_hist_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_bck_hist"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.backup_scheduler" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_bck_scdr" name="bck_scdr_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_bck_scdr"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="restore.Emergency_Recovery" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_emergency_restore" name="emergency_restore_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_emergency_restore"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="restore.Point-in-Time_Recovery" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_point_restore" name="point_restore_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_point_restore"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="restore.Dump_Recovery" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_dump_restore" name="dump_restore_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_dump_restore"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="restore.Recovery_history" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_restore_hist" name="restore_hist_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_restore_hist"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					
					/* 전송관리 */
					if("${sessionScope.session.transfer}" == "Y"){
						
						//2020.09.23
						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="data_transfer.btn_title01" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_trans_dbms_aut" name="trans_dbms_aut" onClick="fn_userCheck();" />';
						html1+='				<label for="'+item.db_svr_id+'_trans_dbms_aut"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';
						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="data_transfer.btn_title02" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_trans_con_aut" name="trans_con_aut" onClick="fn_userCheck();" />';
						html1+='				<label for="'+item.db_svr_id+'_trans_con_aut"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';

						html1+='	<tr>';
						html1+='		<td class="pl-4"><spring:message code="menu.trans_management" /></td>';
						html1+='		<td>';
						html1+='			<div class="inp_chk">';
						html1+='				<input type="checkbox" id="'+item.db_svr_id+'_transSetting" name="transSetting_aut" onClick="fn_userCheck();" />';
						html1+='				<label for="'+item.db_svr_id+'_transSetting"></label>';
						html1+='			</div>';
						html1+='		</td>';
						html1+='	</tr>';
					}
					
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.access_control" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_acs_cntr" name="acs_cntr_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_acs_cntr"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.policy_changes_history" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_policy_change_his" name="policy_change_his_aut" onClick="fn_userCheck();" />';
					html1+='				<label for="'+item.db_svr_id+'_policy_change_his"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					
					if("${sessionScope.session.pg_audit}"== "Y"){
						html1+='<tr>';
						html1+='	<td class="pl-4"><spring:message code="menu.audit_settings" /></td>';
						html1+='	<td>';
						html1+='		<div class="inp_chk">';
						html1+='			<input type="checkbox" id="'+item.db_svr_id+'_adt_cng" name="adt_cng_aut" onClick="fn_userCheck();"/>';
						html1+='			<label for="'+item.db_svr_id+'_adt_cng"></label>';
						html1+='		</div>';
						html1+='	</td>';
						html1+='</tr>';
						html1+='<tr>';
						html1+='	<td class="pl-4"><spring:message code="menu.audit_history" /></td>';
						html1+='	<td>';
						html1+='		<div class="inp_chk">';
						html1+='			<input type="checkbox" id="'+item.db_svr_id+'_adt_hist" name="adt_hist_aut"  onClick="fn_userCheck();"/>';
						html1+='			<label for="'+item.db_svr_id+'_adt_hist"></label>';
						html1+='		</div>';
						html1+='	</td>';
						html1+='</tr>	';			
					}
					
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.script_settings" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_script_cng" name="script_cng_aut"  onClick="fn_userCheck();"/>';
					html1+='				<label for="'+item.db_svr_id+'_script_cng"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>	';
					html1+='	<tr>';
					html1+='		<td class="pl-4"><spring:message code="menu.script_history" /></td>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_id+'_script_his" name="script_his_aut"  onClick="fn_userCheck();"/>';
					html1+='				<label for="'+item.db_svr_id+'_script_his"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>	';	
					
					html1+='</tbody>';
					html1+='<input type="hidden"  name="db_svr_id" value="'+item.db_svr_id+'">';
				})
				html1+='</table>';
				$( "#svrAutList" ).append(html1);
			}
		});

		$('#user tbody').on( 'click', 'tr', function () {
			if ( $(this).hasClass('selected') ) {
			} else {
				userTable.$('tr.selected').removeClass('selected');
				$(this).addClass('selected');
			}

			var usr_id = userTable.row('.selected').data().usr_id;

			if (svr_server.length == 0){
				showSwalIcon('<spring:message code="message.msg214" />', '<spring:message code="common.close" />', '', 'warning');
				return;
			}

			/* ********************************************************
			* 선택된 유저 대한 디비서버권한 조회
			******************************************************** */
			$.ajax({
				url : "/selectUsrDBSrvAutInfo.do",
				data : {
					usr_id: usr_id,
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", true);
				},
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
						top.location.href = "/";
					} else if(xhr.status == 403) {
						showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
						top.location.href = "/";
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(result) {
					if(result.length != 0){
						for(var i = 0; i<result.length; i++){  
 							if (scale_yn_chk == "Y") {
 								/* 2020.04.09 scale 설정 추가 */
 								if(result.length != 0 && result[i].scale_cng_aut_yn == "Y"){
 									document.getElementById(result[i].db_svr_id+"_scale_cng").checked = true;
 								}else{
 									document.getElementById(result[i].db_svr_id+"_scale_cng").checked = false;
 								}
 								
 								/* 2020.03.03 scale 추가 */
 								if(result.length != 0 && result[i].scale_aut_yn == "Y"){
 									document.getElementById(result[i].db_svr_id+"_scale").checked = true;
 								}else{
 									document.getElementById(result[i].db_svr_id+"_scale").checked = false;
 								}
 								
 								/* 2020.04.03 scale_hist 추가 */
 								if(result.length != 0 && result[i].scale_hist_aut_yn == "Y"){
 									document.getElementById(result[i].db_svr_id+"_scale_hist").checked = true;
 								}else{
 									document.getElementById(result[i].db_svr_id+"_scale_hist").checked = false;
 								}
							}

							//백업설정 권한
							if(result.length != 0 && result[i].bck_cng_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_bck_cng").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_bck_cng").checked = false;
							}

	  						//백업이력 권한
	  						if(result.length != 0 && result[i].bck_hist_aut_yn == "Y"){
	  							document.getElementById(result[i].db_svr_id+"_bck_hist").checked = true;
	  						}else{
	  							document.getElementById(result[i].db_svr_id+"_bck_hist").checked = false;
	  						}

							//백업스케줄러 권한
							if(result.length != 0 && result[i].bck_scdr_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_bck_scdr").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_bck_scdr").checked = false;
							}

							//긴급복구 권한
							if(result.length != 0 && result[i].emergency_restore_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_emergency_restore").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_emergency_restore").checked = false;
							}

							//시점복구 권한
							if(result.length != 0 && result[i].point_restore_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_point_restore").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_point_restore").checked = false;
							}

							//덤프복구 권한
							if(result.length != 0 && result[i].dump_restore_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_dump_restore").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_dump_restore").checked = false;
							}

							//복구이력 권한
							if(result.length != 0 && result[i].restore_his_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_restore_hist").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_restore_hist").checked = false;
							}
							
							if("${sessionScope.session.transfer}"== "Y"){
								//전송설정(2020-08-31)
								if(result.length != 0 && result[i].transsetting_aut_yn == "Y"){
									document.getElementById(result[i].db_svr_id+"_transSetting").checked = true;
								}else{
									document.getElementById(result[i].db_svr_id+"_transSetting").checked = false;
								}
								
								//전송설정(2020-09-23)
								if(result.length != 0 && result[i].trans_dbms_cng_aut_yn == "Y"){
									document.getElementById(result[i].db_svr_id+"_trans_dbms_aut").checked = true;
								}else{
									document.getElementById(result[i].db_svr_id+"_trans_dbms_aut").checked = false;
								}
								
								//전송설정(2020-08-31)
								if(result.length != 0 && result[i].trans_con_cng_aut_yn == "Y"){
									document.getElementById(result[i].db_svr_id+"_trans_con_aut").checked = true;
								}else{
									document.getElementById(result[i].db_svr_id+"_trans_con_aut").checked = false;
								}
							}

							//서버접근제어 권한
							if(result.length != 0 && result[i].acs_cntr_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_acs_cntr").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_acs_cntr").checked = false;
							}
							
							//정책변경이력 권한
							if(result.length != 0 && result[i].policy_change_his_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_policy_change_his").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_policy_change_his").checked = false;
							}

							if("${sessionScope.session.pg_audit}"== "Y"){
								//감사설정 권한
								if(result.length != 0 && result[i].adt_cng_aut_yn == "Y"){
									document.getElementById(result[i].db_svr_id+"_adt_cng").checked = true;
								}else{
									document.getElementById(result[i].db_svr_id+"_adt_cng").checked = false;
								}

								//감사이력 권한
								if(result.length != 0 && result[i].adt_hist_aut_yn == "Y"){
									document.getElementById(result[i].db_svr_id+"_adt_hist").checked = true;
								}else{
									document.getElementById(result[i].db_svr_id+"_adt_hist").checked = false;
								}
							}

							//배치설정 권한
							if(result.length != 0 && result[i].script_cng_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_script_cng").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_script_cng").checked = false;
							}

							//배치설정 권한
							if(result.length != 0 && result[i].script_his_aut_yn == "Y"){
								document.getElementById(result[i].db_svr_id+"_script_his").checked = true;
							}else{
								document.getElementById(result[i].db_svr_id+"_script_his").checked = false;
							}
						}
					}else{
						if (scale_yn_chk == "Y") {
							document.getElementById(svr_server[0].db_svr_id+"_scale_cng").checked = false;
							document.getElementById(svr_server[0].db_svr_id+"_scale").checked = false;
							document.getElementById(svr_server[0].db_svr_id+"_scale_hist").checked = false;
						}

						document.getElementById(svr_server[0].db_svr_id+"_bck_cng").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_bck_hist").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_bck_scdr").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_emergency_restore").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_point_restore").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_dump_restore").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_restore_hist").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_acs_cntr").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_policy_change_his").checked = false;
						if("${sessionScope.session.pg_audit}"== "Y"){
							document.getElementById(svr_server[0].db_svr_id+"_adt_cng").checked = false;
							document.getElementById(svr_server[0].db_svr_id+"_adt_hist").checked = false;
						}
						document.getElementById(svr_server[0].db_svr_id+"_script_cng").checked = false;
						document.getElementById(svr_server[0].db_svr_id+"_script_his").checked = false;
						
						if("${sessionScope.session.transfer}"== "Y"){
							document.getElementById(svr_server[0].db_svr_id+"_transSetting").checked = false;
							document.getElementById(svr_server[0].db_svr_id+"_trans_dbms_aut").checked = false;
							document.getElementById(svr_server[0].db_svr_id+"_trans_con_aut").checked = false;
						}
					}
				}
			});
		});
	});

	/* 버튼제어 */
	function fn_buttonAut(){
		var server_button = document.getElementById("server_button");

		if("${wrt_aut_yn}" == "Y"){
			server_button.style.display = '';
		}else{
			server_button.style.display = 'none';
		}
	}

	/* table setting */
	function fn_init() {
		userTable = $('#user').DataTable({
			scrollY : "500px",
			scrollX: true,
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [
				{data : "rownum", className : "dt-center", defaultContent : ""}, 
				{data : "usr_id", defaultContent : ""}, 
				{data : "usr_nm", defaultContent : ""} 
			]
		});

		dbServerTable = $('#dbserver').DataTable({
			searching : false,
			paging : false,
			bSort: false,
			columns : [ 
				{data : "", defaultContent : ""}, 
				{data : "", defaultContent : ""} 
			]
		});

		userTable.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		userTable.tables().header().to$().find('th:eq(1)').css('min-width', '90px');
		userTable.tables().header().to$().find('th:eq(2)').css('min-width', '90px');

		$(window).trigger('resize');
	}

	/* 전체체크 */
	function fn_allCheck(db_svr_id){
		fn_userCheck();

		/* 2020.03.03 scale 추가 */
		if("${sessionScope.session.pg_audit}"== "Y"){
			if (scale_yn_chk == "Y") {
				if("${sessionScope.session.transfer}"== "Y"){
					var array = new Array("_scale_cng", "_scale", "_scale_hist", "_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_transSetting", "_trans_dbms_aut", "_trans_con_aut", "_acs_cntr","_policy_change_his","_adt_cng","_adt_hist","_script_cng","_script_his");
				}else{
					var array = new Array("_scale_cng", "_scale", "_scale_hist", "_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_acs_cntr","_policy_change_his","_adt_cng","_adt_hist","_script_cng","_script_his");
				}		
			} else {
				if("${sessionScope.session.transfer}"== "Y"){
					var array = new Array("_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_transSetting", "_trans_dbms_aut", "_trans_con_aut", "_acs_cntr","_policy_change_his","_adt_cng","_adt_hist","_script_cng","_script_his");
				}else{
					var array = new Array("_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_acs_cntr","_policy_change_his","_adt_cng","_adt_hist","_script_cng","_script_his");
				}
			}
		}else{
			if (scale_yn_chk == "Y") {
				if("${sessionScope.session.transfer}"== "Y"){
					var array = new Array("_scale_cng", "_scale", "_scale_hist", "_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_transSetting", "_trans_dbms_aut", "_trans_con_aut", "_acs_cntr","_policy_change_his","_script_cng","_script_his");
				}else{
					var array = new Array("_scale_cng", "_scale", "_scale_hist", "_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_acs_cntr","_policy_change_his","_script_cng","_script_his");
				}	
			} else {				
				if("${sessionScope.session.transfer}"== "Y"){
					var array = new Array("_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_transSetting", "_trans_dbms_aut", "_trans_con_aut", "_acs_cntr","_policy_change_his","_script_cng","_script_his");
				}else{
					var array = new Array("_bck_cng","_bck_hist","_bck_scdr","_emergency_restore","_point_restore","_dump_restore","_restore_hist","_acs_cntr","_policy_change_his","_script_cng","_script_his");
				}	
			}
		}

		for(var i=0; i<array.length; i++){
			if ($("#"+db_svr_id).prop("checked")) {
				document.getElementById(db_svr_id+array[i]).checked = true;
			}else{
				document.getElementById(db_svr_id+array[i]).checked = false;
			}
		}
	}

	/* 전체체크 validate */
	function fn_userCheck(){
		var datas = userTable.row('.selected').length;
		if(datas != 1){
			showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			$("input[type=checkbox]").prop("checked",false);
			return false;
		}
	}

	/* 저장 */
	function fn_svr_save(){
		datasArr = new Array();
		var datas = userTable.row('.selected').length;

		if(datas != 1){
			showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}else{
			var usr_id = userTable.row('.selected').data().usr_id;
			
			var transSetting_aut = null;
			var trans_dbms_aut = null;
			var trans_con_aut = null;
			
			/* 2020.03.03 scale 추가 */
			var db_svr_id = $("input[name='db_svr_id']");
			var bck_cng_aut = $("input[name='bck_cng_aut']");
			var bck_hist_aut = $("input[name='bck_hist_aut']");
			var bck_scdr_aut = $("input[name='bck_scdr_aut']");
			var emergency_restore_aut  = $("input[name='emergency_restore_aut']");
			var point_restore_aut = $("input[name='point_restore_aut']");
			var dump_restore_aut = $("input[name='dump_restore_aut']");
			var restore_hist_aut = $("input[name='restore_hist_aut']");
					
			/* 2020-08-31 전송관리 추가 */
			if("${sessionScope.session.transfer}"== "Y"){
				transSetting_aut = $("input[name='transSetting_aut']");
				trans_dbms_aut = $("input[name='trans_dbms_aut']");
				trans_con_aut = $("input[name='trans_con_aut']");
			}
			
			var acs_cntr_aut = $("input[name='acs_cntr_aut']");
			var policy_change_his_aut = $("input[name='policy_change_his_aut']");
			var adt_cng_aut;
			var adt_hist_aut;
			
			var eXperDB_scale_cng;
			var eXperDB_scale;
			var eXperDB_scale_hist;
			if (scale_yn_chk == "Y") {
				eXperDB_scale_cng = $("input[name='eXperDB_scale_cng']");
				eXperDB_scale = $("input[name='eXperDB_scale']");
				eXperDB_scale_hist = $("input[name='eXperDB_scale_hist']");
			}

			if("${sessionScope.session.pg_audit}"== "Y"){
				adt_cng_aut = $("input[name='adt_cng_aut']");
				adt_hist_aut = $("input[name='adt_hist_aut']");
			}

			var script_cng_aut = $("input[name='script_cng_aut']");
			var script_his_aut = $("input[name='script_his_aut']");

			for(var i = 0; i < svr_server.length; i++){
				var autCheck = 0;
				var rows = new Object();
				rows.usr_id = usr_id;
				rows.db_svr_id = db_svr_id[i].value;

				if (scale_yn_chk == "Y") {
					if(eXperDB_scale_cng[i].checked){ //선택되어 있으면 배열에 값을 저장함 scale cng
						rows.scale_cng_aut_yn = "Y";   
						autCheck++;
					}else{
						rows.scale_cng_aut_yn = "N";
					}
					
					if(eXperDB_scale[i].checked){ //선택되어 있으면 배열에 값을 저장함 scale
						rows.scale_aut_yn = "Y";   
						autCheck++;
					}else{
						rows.scale_aut_yn = "N";
					}

					if(eXperDB_scale_hist[i].checked){ //선택되어 있으면 배열에 값을 저장함 scale hist
						rows.scale_hist_aut_yn = "Y";   
						autCheck++;
					}else{
						rows.scale_hist_aut_yn = "N";
					}
				}

				if(bck_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.bck_cng_aut_yn = "Y";   
					autCheck++;
				}else{
					rows.bck_cng_aut_yn = "N";
				}

				if(bck_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.bck_hist_aut_yn = "Y"; 
					autCheck++;
				}else{
					rows.bck_hist_aut_yn = "N";
				}

				if(bck_scdr_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.bck_scdr_aut_yn = "Y"; 
					autCheck++;
				}else{
					rows.bck_scdr_aut_yn = "N";
				}

				if(emergency_restore_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.emergency_restore_aut_yn= "Y"; 
					autCheck++;
				}else{
					rows.emergency_restore_aut_yn = "N";
				}

				if(point_restore_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.point_restore_aut_yn = "Y"; 
					autCheck++;
				}else{
					rows.point_restore_aut_yn = "N";
				}

				if(dump_restore_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.dump_restore_aut_yn = "Y"; 
					autCheck++;
				}else{
					rows.dump_restore_aut_yn = "N";
				}

				if(restore_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.restore_his_aut_yn = "Y"; 
					autCheck++;
				}else{
					rows.restore_his_aut_yn = "N";
				}
				
				/* 전송관리 추가 (2020-08-31) */
				if("${sessionScope.session.transfer}"== "Y"){
					if(transSetting_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함			
						rows.transSetting_aut_yn = "Y"; 
						autCheck++;
					}else{				
						rows.transSetting_aut_yn = "N";
					}
					
					if(trans_dbms_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함			
						rows.trans_dbms_cng_aut_yn = "Y"; 
						autCheck++;
					}else{				
						rows.trans_dbms_cng_aut_yn = "N";
					}
					
					if(trans_con_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함			
						rows.trans_con_cng_aut_yn = "Y"; 
						autCheck++;
					}else{				
						rows.trans_con_cng_aut_yn = "N";
					}
				}
					
				if(acs_cntr_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.acs_cntr_aut_yn = "Y";   
					autCheck++;
				}else{
					rows.acs_cntr_aut_yn = "N";
				}

				if(policy_change_his_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.policy_change_his_aut_yn = "Y";   
					autCheck++;
				}else{
					rows.policy_change_his_aut_yn = "N";
				}

				if("${sessionScope.session.pg_audit}"== "Y"){
					if(adt_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
						rows.adt_cng_aut_yn = "Y";   
						autCheck++;
					}else{
						rows.adt_cng_aut_yn = "N";
					}

					if(adt_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
						rows.adt_hist_aut_yt = "Y";   
						autCheck++;
					}else{
						rows.adt_hist_aut_yt = "N";
					}
				}

				if(script_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.script_cng_aut_yn = "Y";   
					autCheck++;
				}else{
					rows.script_cng_aut_yn = "N";
				}

				if(script_his_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
					rows.script_his_aut_yn = "Y";   
					autCheck++;
				}else{
					rows.script_his_aut_yn = "N";
				}
				datasArr.push(rows);

				/*DB서버 메뉴권한이 있으면 해당 DB서버 DB권한 가지기*/
				if(autCheck > 0){
					$.ajax({
						url : "/updateServerDBAutInfo.do",
						data : {
							db_svr_id : rows.db_svr_id,
							usr_id : rows.usr_id
						},
					//	dataType : "json",
						type : "post",
						beforeSend: function(xhr) {
							xhr.setRequestHeader("AJAX", true);
						},
						error : function(xhr, status, error) {
							if(xhr.status == 401) {
								showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else if(xhr.status == 403) {
								showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
								top.location.href = "/";
							} else {
								showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
							}
						},
						success : function(result) {
						}
					}); 
				}
			}
		}

		confile_title = '<spring:message code="common.dbServer" />' + '<spring:message code="auth_management.auth" />' + " " + '<spring:message code="encrypt_policyOption.Settings" />' + " " + '<spring:message code="common.request" />';
		$('#confirm_tlt').html(confile_title);
		$('#confirm_msg').html('<spring:message code="message.msg166" />');
		$('#pop_confirm_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmRst(){
		fn_UsrDBSrvAutInfo();
	}

	/* ********************************************************
	 * db서버권한 등록
	 ******************************************************** */
	function fn_UsrDBSrvAutInfo() {
		$.ajax({
			url : "/updateUsrDBSrvAutInfo.do",
			data : {
				datasArr : JSON.stringify(datasArr)
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if (result == "S") {
					showSwalIcon('<spring:message code="message.msg07"/>', '<spring:message code="common.close" />', '', 'success');
				} else {
					showSwalIcon('<spring:message code="migration.msg06"/>', '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	/* 유저조회버튼 클릭시 */
 	function fn_search(){
		$.ajax({
			url : "/selectMenuAutUserManager.do",
			data : {
				type : "usr_id",
				search : "%" + $("#search").val() + "%",
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				$("input[type=checkbox]").prop("checked",false);
				userTable.clear().draw();
				userTable.rows.add(result).draw();
			}
		});
	}
</script>

<%@include file="./../../popup/confirmForm.jsp"%>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
 											<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.server_auth_management" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.auth_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.server_auth_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.server_auth_management" /></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>

		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body" style=" height: 100%;">
					<h5 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="auth_management.user_choice" />
					</h5>

					<div class="row" >
						<div class="col-3"></div>
						<div class="col-6">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;margin-right:-5rem;">
									<input hidden="hidden" />
									<input type="text" class="form-control" style="width:250px;" id="search">&nbsp;&nbsp;
								</form>
							</div>
						</div>
						<div class="col-3">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;">
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="button.search" />
									</button>
								</form>
							</div>
						</div>
					</div>

					<table id="user" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
						<thead>
							<tr class="bg-info text-white">
								<th width="20"><spring:message code="common.no"/></th>
								<th width="90"><spring:message code="user_management.id" /></th>
								<th width="90"><spring:message code="user_management.user_name" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
            
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="auth_management.db_server_menu_auth_mng" />
					</h5>
	
					<div class="row" style="margin-top:-10px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable float-right" id="server_button" onClick="fn_svr_save()">
									<i class="ti-import btn-icon-prepend "></i><spring:message code="common.save"/>
								</button>
							</div>
						</div>
					</div>

					<div class="row">
						<div id="svrAutList" class="col-12 system-tlb-scroll" style="height:560px;overflow-y:auto;"></div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>