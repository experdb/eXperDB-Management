<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : rmanRegForm.jsp
	* @Description : rman 백업등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
// 저장후 작업ID
var wrk_id = null;
var bck_wrk_id = null;
var db_svr_id = "${db_svr_id}";
var wrk_id = "${wrk_id}";
var haCnt = 0;

$(window.document).ready(function() {
	//fn_checkFolderVol(1);
	fn_checkFolderVol(2);

	 $.ajax({
			async : false,
			url : "/selectHaCnt.do",
		  	data : {
		  		db_svr_id : db_svr_id
		  	},
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
				haCnt = result[0].hacnt;			
			}
		}); 
	 
	 /* $.ajax({
		async : false,
		url : "/selectPathInfo.do",
	  	data : {
	  		db_svr_id : db_svr_id
	  	},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			document.getElementById("data_pth").value=result[0].DATA_PATH;
			document.getElementById("log_file_pth").value=result[1].PGRLOG;
			document.getElementById("bck_pth").value=result[1].PGRBAK;
		}
	});  */
});

/* ********************************************************
 * Rman Backup Update
 ******************************************************** */
function fn_update_work(){
	var cps_yn = "N";
	var log_file_bck_yn = "N";
	
	if( $("#cps_yn").is(":checked")) cps_yn = "Y";
	if( $("#log_file_bck_yn").is(":checked")) log_file_bck_yn = "Y";

	if(valCheck()){
		$.ajax({
			async : false,
			url : "/popup/workRmanReWrite.do",
		  	data : {
		  		db_svr_id : db_svr_id,
		  		bck_wrk_id : $("#bck_wrk_id").val(),
		  		wrk_id : $("#wrk_id").val(),
		  		wrk_nm : $("#wrk_nm").val().trim(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		bck_opt_cd : $("#bck_opt_cd").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val(),
		  		cps_yn : cps_yn,
		  		log_file_bck_yn : log_file_bck_yn,
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		log_file_stg_dcnt : $("#log_file_stg_dcnt").val(),
		  		log_file_mtn_ecnt : $("#log_file_mtn_ecnt").val(),
		  		data_pth : $("#data_pth").val(),
		  		bck_pth : $("#bck_pth").val(),
		  		acv_file_stgdt : $("#acv_file_stgdt").val(),
		  		acv_file_mtncnt : $("#acv_file_mtncnt").val(),
		  		log_file_pth : $("#log_file_pth").val()
		  	},
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
			success : function(data) {
				result(data);
			}
		});
	}
}

/* ********************************************************
 * Result Process
 ******************************************************** */
function result(data){
	if($.trim(data) == "S"){
		opener.fn_rman_find_list();	
		alert('<spring:message code="message.msg155"/>');
		self.close();
	}else{
		alert('<spring:message code="message.msg105" />');
		$("#wrk_nm").val();
		$("#wrk_nm").focus();
	}
}

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#wrk_nm").val() == ""){
		alert('<spring:message code="message.msg107" />');
		$("#wrk_nm").focus();
		return false;
	}else if($("#wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
		$("#wrk_exp").focus();
		return false;
	}else if($("#bck_opt_cd").val() == ""){
		alert('<spring:message code="backup_management.bckOption_choice_please"/>');
		$("#bck_opt_cd").focus();
		return false;
	}/* else if($("#log_file_pth").val() == ""){
		alert('<spring:message code="message.msg78" />');
		$("#log_file_pth").focus();
		return false;
	} */else if($("#bck_pth").val() == ""){
		alert('<spring:message code="message.msg79" />');
		$("#bck_pth").focus();
		return false;
	}/* else if($("#check_path1").val() != "Y"){
		alert('<spring:message code="message.msg72" />');
		$("#log_file_pth").focus();
		return false;		
	} */else if($("#check_path2").val() != "Y"){
		alert('<spring:message code="backup_management.bckPath_effective_check"/>');
		$("#bck_pth").focus();
		return false;
	}else if($("#file_stg_dcnt").val() == ""){
		alert('<spring:message code="message.msg202"/>');		
		$("#file_stg_dcnt").focus();
		return false;
	}else if($("#bck_mtn_ecnt").val() == ""){
		alert('<spring:message code="message.msg197"/>');		
		$("#bck_mtn_ecnt").focus();
		return false;
	}else if($("#acv_file_stgdt").val() == ""){
		alert('<spring:message code="message.msg198"/>');		
		$("#acv_file_stgdt").focus();
		return false;
	}else if($("#acv_file_mtncnt").val() == ""){
		alert('<spring:message code="message.msg199"/>');		
		$("#acv_file_mtncnt").focus();
		return false;
	}else if($("#log_file_stg_dcnt").val() == ""){
		alert('<spring:message code="message.msg200"/>');
		$("#log_file_stg_dcnt").focus();
		return false;
	}else if($("#log_file_mtn_ecnt").val() == ""){
		alert('<spring:message code="message.msg201"/>');		
		$("#log_file_mtn_ecnt").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * 시작시 폴더 용량 가져오기
 ******************************************************** */
function fn_checkFolderVol(keyType){
	if(keyType == 2){
		/* save_path = $("#log_file_pth").val();
	}else{ */
		save_path = $("#bck_pth").val();
	}
	$.ajax({
		async : false,
		url : "/existDirCheck.do",
	  	data : {
	  		db_svr_id : $("#db_svr_id").val(),
	  		path : save_path
	  	},
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
		success : function(data) {
			if(data.result.ERR_CODE == ""){
				if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
					/* if(keyType == 1){
						$("#check_path1").val("Y");
					}else */ if(keyType == 2){
						$("#check_path2").val("Y");
					}
						var volume = data.result.RESULT_DATA.CAPACITY;
						/* if(keyType == 1){
							$("#logVolume").empty();
							$( "#logVolume" ).append("<spring:message code="common.volume" /> : "+volume);
						}else  */if(keyType == 2) {
							$("#backupVolume").empty();
							$( "#backupVolume" ).append("<spring:message code="common.volume" /> : "+volume);
						}
				}else{
					if(haCnt > 1){
						alert('<spring:message code="backup_management.ha_configuration_cluster"/>' +data.SERVERIP+ '<spring:message code="backup_management.node_path_no"/>');
					}else{
						alert('<spring:message code="backup_management.invalid_path"/>');
					}	
				}
			}else{
				alert('<spring:message code="message.msg76" />')
			}
		}
	});
}

/* ********************************************************
 * 저장경로의 존재유무 체크
 ******************************************************** */
function checkFolder(keyType){
	var save_path = "";
	
	if(keyType == 2){
		/* save_path = $("#log_file_pth").val();
	}else{ */
		save_path = $("#bck_pth").val();
	}

	/* if(save_path == "" && keyType == 1){
		alert('<spring:message code="message.msg78" />');
		$("#bck_pth").focus();
	}else  */if(save_path == ""){
		alert('<spring:message code="message.msg79" />');
		$("#bck_pth").focus();
	}else{
		$.ajax({
			async : false,
			//url : "/existDirCheck.do",
		  	url : "/existDirCheckMaster.do",   //2019-09-26 변승우 대리, 수정(경로체크 시 MASTER만)
			data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		path : save_path
		  	},
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
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						/* if(keyType == 1){
							$("#check_path1").val("Y");
						}else */ if(keyType == 2){
							$("#check_path2").val("Y");
						}
						alert('<spring:message code="message.msg100" />');
							var volume = data.result.RESULT_DATA.CAPACITY;
							/* if(keyType == 1){
								$("#logVolume").empty();
								$( "#logVolume" ).append("<spring:message code="common.volume" /> : "+volume);
							}else */ if(keyType == 2) {
								$("#backupVolume").empty();
								$( "#backupVolume" ).append("<spring:message code="common.volume" /> : "+volume);
							}
					}else{
						if(haCnt > 1){
							alert('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>');
						}else{
							alert('<spring:message code="backup_management.invalid_path"/>');
						}	
					}
				}else{
					alert('<spring:message code="message.msg76" />');
				}
			}
		});
	}
}
</script>
</head>
<body>
<form name="workRegForm">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
<input type="hidden" name="wrk_id" id="wrk_id" value="${wrk_id}"/>
<input type="hidden" name="bck_wrk_id" id="bck_wrk_id" value="${bck_wrk_id}"/>
<!-- <input type="hidden" name="check_path1" id="check_path1" value="Y"/> -->
<input type="hidden" name="check_path2" id="check_path2" value="Y"/>
</form>
	<div id="pop_layer">
		<div class="pop_container">
			<div class="pop_cts">
				<p class="tit">Online <spring:message code="backup_management.bck_mod"/></p>
				<div class="pop_cmm">
					<table class="write">
						<caption>Online <spring:message code="backup_management.bck_mod"/></caption>
						<colgroup>
							<col style="width:130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
								<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=20 value="<c:out value="${workInfo[0].wrk_nm}"/>" readonly="readonly"/></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="common.work_description" /></th>
								<td>
									<div class="textarea_grp">
										<textarea name="wrk_exp" id="wrk_exp" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"><c:out value="${workInfo[0].wrk_exp}"/></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="pop_cmm mt25">
					<div class="bak_option">
						<div class="option">						
							<table class="write">
								<colgroup>
									<col style="width:130px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="ico_t1"><spring:message code="backup_management.backup_option" /></th>
										<td>
											<select name="bck_opt_cd" id="bck_opt_cd" class="select">
												<option value=""><spring:message code="schedule.total" /></option>
												<option value="TC000301"<c:if test="${workInfo[0].bck_opt_cd == 'TC000301'}"> selected</c:if>><spring:message code="backup_management.full_backup" /></option>
												<option value="TC000302"<c:if test="${workInfo[0].bck_opt_cd == 'TC000302'}"> selected</c:if>><spring:message code="backup_management.incremental_backup" /></option>
												<option value="TC000303"<c:if test="${workInfo[0].bck_opt_cd == 'TC000303'}"> selected</c:if>><spring:message code="backup_management.change_log_backup" /></option>
											</select>									
										</td>
									</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="backup_management.data_dir" /></th>
									<td>
										<input type="text" class="txt" name="data_pth" id="data_pth" maxlength=200  value="<c:out value="${workInfo[0].data_pth}"/>" style="width:515px" readonly/>											
									</td>
								</tr>									
								<%-- <tr>		
									<th scope="row" class="ico_t1"><spring:message code="backup_management.backup_log_dir" /></th>
									<td>
										<input type="text" class="txt" name="log_file_pth" id="log_file_pth" maxlength=200  value="<c:out value="${workInfo[0].log_file_pth}"/>" style="width:450px" onKeydown="$('#check_path1').val('N')"/>
										<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>
										<span id="logVolume" style="margin:63px;"></span>	
									</td>
								</tr>	 --%>								
								<tr>	
										<th scope="row" class="ico_t1"><spring:message code="backup_management.backup_dir" /></th>
										<td>
											<input type="text" class="txt" name="bck_pth" id="bck_pth" maxlength=200  value="<c:out value="${workInfo[0].bck_pth}"/>" style="width:450px" onKeydown="$('#check_path2').val('N')"/>
											<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 100px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>
											<span id="backupVolume" style="margin:63px;"></span>	
										</td>
									</tr>	
								</tbody>
							</table>
						</div>
						<div class="bak_inner">
							<div class="bak_lt">
								<p class="tit"><spring:message code="backup_management.backup_file_option" /></p>
								<div class="option_list">
									<ul>
										<li>
											<div class="inner">
												<p><spring:message code="backup_management.full_backup_file_keep_day" /></p>
												<span><input type="number" class="txt" name="file_stg_dcnt" id="file_stg_dcnt" value="<c:out value="${workInfo[0].file_stg_dcnt}"/>" maxlength="3" min="0"/> <spring:message code="common.day" /></span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p><spring:message code="backup_management.full_backup_file_maintenance_count" /></p>
												<span><input type="number" class="txt" name="bck_mtn_ecnt" id="bck_mtn_ecnt" value="<c:out value="${workInfo[0].bck_mtn_ecnt}"/>" maxlength="3" min="0"/> <spring:message code="backup_management.count" /></span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p><spring:message code="backup_management.archive_file_keep_day" /></p>
												<span><input type="number" class="txt" name="acv_file_stgdt" id="acv_file_stgdt" value="<c:out value="${workInfo[0].acv_file_stgdt}"/>" maxlength="3" min="0"/> <spring:message code="common.day" /></span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p><spring:message code="backup_management.archive_file_maintenance_count" /></p>
												<span><input type="number" class="txt" name="acv_file_mtncnt" id="acv_file_mtncnt" value="<c:out value="${workInfo[0].acv_file_mtncnt}"/>" maxlength="3" min="0"/> <spring:message code="backup_management.count" /></span>
											</div>
										</li>
										<li>
											<span class="chk">
												<div class="inp_chk chk3">
													<input type="checkbox" name="cps_yn" id="cps_yn" value="Y" <c:if test="${workInfo[0].cps_yn eq 'Y'}"> checked</c:if>/>
													<label for="cps_yn"><spring:message code="backup_management.compress" /></label>
												</div>
											</span>
										</li>
									</ul>
								</div>
							</div>
							<div class="bak_rt">
								<p class="tit"><spring:message code="backup_management.log_file_option" /></p>
								<div class="bak_rt_inr">
									<div class="option_yn">
										<div class="inp_chk chk3">
											<input type="checkbox" name="log_file_bck_yn" id="log_file_bck_yn" value="Y" <c:if test="${workInfo[0].log_file_bck_yn eq 'Y'}"> checked</c:if>/>
											<label for="log_file_bck_yn"><spring:message code="backup_management.log_file_backup_yn" /></label>
										</div>
									</div>
									<div class="option_list">
										<ul>
											<li>
												<div class="inner">
													<p><spring:message code="backup_management.server_log_file_keep_day" /></p>
													<span><input type="number" class="txt" name="log_file_stg_dcnt" id="log_file_stg_dcnt" value="<c:out value="${workInfo[0].log_file_stg_dcnt}"/>" maxlength="3" min="0"/> <spring:message code="common.day" /></span>
												</div>
											</li>
											<li>
												<div class="inner">
													<p><spring:message code="backup_management.server_log_file_maintenance_count" /></p>
													<span><input type="number" class="txt" name="log_file_mtn_ecnt" id="log_file_mtn_ecnt" value="<c:out value="${workInfo[0].log_file_mtn_ecnt}"/>" maxlength="3" min="0"/> <spring:message code="backup_management.count" /></span>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="btn_type_02">
					<span class="btn btnC_01" onClick="fn_update_work();return false;"><button type="button"><spring:message code="common.modify" /></button></span>
					<span class="btn" onclick="self.close();return false;"><button type="button"><spring:message code="common.cancel" /></button></span>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>