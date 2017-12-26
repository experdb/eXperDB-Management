<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dumpRegForm.jsp
	* @Description : rman 백업 등록 화면
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
//저장후 작업ID
var wrk_nmChk ="fail";
var db_svr_id = "${db_svr_id}";
var haCnt = 0;

$(window.document).ready(function() {
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
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				haCnt = result[0].hacnt;			
			}
		}); 
	 
	
	 $.ajax({
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
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				document.getElementById("log_file_pth").value=result[1].PGDLOG;
				document.getElementById("save_pth").value=result[1].PGDBAK;		
			}
		}); 
});


/* ********************************************************
 * Dump Backup Insert
 ******************************************************** */
function fn_insert_work(){
	if (!valCheck()) return false;
		$.ajax({
			async : false,
			url : "/popup/workDumpWrite.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		db_id : $("#db_id").val(),
		  		bck_bsn_dscd : "TC000202",
		  		save_pth : $("#save_pth").val(),
		  		log_file_pth : $("#log_file_pth").val(),
		  		file_fmt_cd : $("#file_fmt_cd").val(),
		  		cprt : $("#cprt").val(),
		  		encd_mth_nm : $("#encd_mth_nm").val(),
		  		usr_role_nm : $("#usr_role_nm").val(),
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val(),
		  		bck_filenm : $("#bck_filenm").val()
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {
				fn_insert_opt(data);
			}
		});  
}

/* ********************************************************
 * Dump Backup Option Insert
 ******************************************************** */
function fn_insert_opt(data){
	var sn = 1;
	if(data != "0"){
		$("input[name=opt]").each(function(){
			if( $(this).not(":disabled") && $(this).is(":checked")){
				fn_insert_opt_val(data,sn,$(this).attr("grp_cd"),$(this).attr("opt_cd"),"Y");
			}
			sn++;
		});
		fn_insert_object(data);
	}else{
		/* alert("동일Work명이 존재합니다. 다른 Work명을 입력해주세요.");
		$("#wrk_nm").val("");
		$("#wrk_nm").focus(); */
	}
}

/* ********************************************************
 * Dump Backup Each Option Insert
 ******************************************************** */
function fn_insert_opt_val(bck_wrk_id, opt_sn, grp_cd, opt_cd, bck_opt_val){
	$.ajax({
		async : false,
		url : "/popup/workOptWrite.do",
	  	data : {
	  		bck_wrk_id : bck_wrk_id,
	  		opt_sn : opt_sn,
	  		grp_cd : grp_cd,
	  		opt_cd : opt_cd,
	  		bck_opt_val : bck_opt_val
	  	},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function() {
		}
	});
}

/* ********************************************************
 * Dump Backup Object Insert
 ******************************************************** */
function fn_insert_object(data){
	$("input[name=tree]").each(function(){
		if( $(this).is(":checked")){
			fn_insert_object_val(data,$(this).attr("otype"),$(this).attr("schema"),$(this).val());
		}
	});

	opener.fn_dump_find_list();
	alert('<spring:message code="message.msg106" />');
	self.close();
}


/* ********************************************************
 * Dump Backup Each Object Insert
 ******************************************************** */
 function fn_insert_object_val(bck_wrk_id,otype,scm_nm,obj_nm){
		var db_id = $("#db_id").val();

		if(otype != "table") obj_nm = "";
		$.ajax({
			async : false,
			url : "/popup/workObjWrite.do",
		  	data : {
		  		bck_wrk_id : bck_wrk_id,
		  		db_id : db_id,
		  		scm_nm : scm_nm,
		  		obj_nm : obj_nm
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function() {
			}
		});
	}

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($( "#db_id option:selected" ).val() == ""){
		alert('<spring:message code="backup_management.bck_database_choice"/>');
		return false;
	}
	else if($("#wrk_nm").val() == ""){
		alert('<spring:message code="message.msg107" />');
		$("#wrk_nm").focus();
		return false;
	}
	else if($("#wrk_exp").val() == ""){
		alert('<spring:message code="message.msg108" />');
		$("#wrk_exp").focus();
		return false;
	}else if($("#log_file_pth").val() == ""){
		alert('<spring:message code="message.msg78" />');
		$("#log_file_pth").focus();
		return false;
	}else if($("#save_pth").val() == ""){
		alert('<spring:message code="message.msg79" />');
		$("#save_pth").focus();
		return false;
	}else if($("#check_path1").val() != "Y"){
		alert('<spring:message code="message.msg72" />');
		$("#log_file_pth").focus();
		return false;
	}else if($("#check_path2").val() != "Y"){
		alert('<spring:message code="backup_management.bckPath_effective_check"/>');		
		$("#save_pth").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * Get Selected Database`s Object List
 ******************************************************** */
function fn_get_object_list(){
	var db_nm = $( "#db_id option:selected" ).text();
	var db_id = $( "#db_id option:selected" ).val();

	if(db_nm != "" && db_id != ""){
		$.ajax({
			async : false,
			url : "/getObjectList.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		db_nm : db_nm
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {
				fn_make_object_list(data);
			}
		});
	}else{
		$(".tNav").html("");
	}
}

function fn_checkAll(schema_id, schema_name) {
    var schemaChkBox = document.getElementById("schema"+schema_id);

    if(schemaChkBox.checked) { 
    	$("input[name=tree]").each(function(){
    		if($(this).attr("schema") == schema_name) {
    			this.checked = true;
    		}
    	});
    } else { 
    	$("input[name=tree]").each(function(){
    		if($(this).attr("schema") == schema_name) {
    			this.checked = false;
    		}
    	});
    }
}


/* ********************************************************
 * Make Object Tree
 ******************************************************** */
function fn_make_object_list(data){
	var html = "<ul>";
	var schema = "";
	var schemaCnt = 0;
	$(data.data).each(function (index, item) {
		var inSchema = item.schema;
		
		if(schemaCnt > 0 && schema != inSchema){
			html += "</ul></li>\n";
		}
		if(schema != inSchema){
			html += "<li class='active'><a href='#'>"+item.schema+"</a>";
			html += "<div class='inp_chk'>";
			html += "<input type='checkbox' onClick=fn_checkAll('" + schemaCnt + "','"+item.schema+"') id='schema"+schemaCnt+"' name='tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"'/><label for='schema"+schemaCnt+"'></label>";
			html += "</div>";
			html += "<ul>\n";
		}
		
		html += "<li><a href='#'>"+item.name+"</a>";
		html += "<div class='inp_chk'>";
		html += "<input type='checkbox' id='table"+index+"' name='tree' value='"+item.name+"' otype='table' schema='"+item.schema+"'/><label for='table"+index+"'></label>";
		html += "</div>";
		html += "</li>\n";

		if(schema != inSchema){
			schema = inSchema;
			schemaCnt++;
		}
	});
	if(schemaCnt > 0) html += "</ul></li>";
	html += "</ul>";

	$(".tNav").html("");
	$(".tNav").html(html);
	$.getScript( "/js/common.js", function() {});
}



/* ********************************************************
 * File Format에 따른 Checkbox disabled Check
 ******************************************************** */
function changeFileFmtCd(){
	if($("#file_fmt_cd").val() == "TC000401"){
		$("#cprt").removeAttr("disabled");
	}else{
		$("#cprt").attr("disabled",true);
	}
	
	if($("#file_fmt_cd").val() == "TC000402"){
		$("input[name=opt]").each(function(){
			if( $(this).attr("opt_cd") == "TC000801" || $(this).attr("opt_cd") == "TC000903" || $(this).attr("opt_cd") == "TC000904" ){
				$(this).removeAttr("disabled");
			}
		});
	}else{
		$("input[name=opt]").each(function(){
			if( $(this).attr("opt_cd") == "TC000801" || $(this).attr("opt_cd") == "TC000903" || $(this).attr("opt_cd") == "TC000904" ){
				$(this).attr("disabled",true);
			}
		});
	}
}

/* ********************************************************
 * Sections에 체크시 Object형태중 Only data, Only Schema를 비활성화 시킨다.
 ******************************************************** */
function checkSection(){
	var check = false;
	$("input[name=opt]").each(function(){
		if( ($(this).attr("opt_cd") == "TC000601" || $(this).attr("opt_cd") == "TC000602" || $(this).attr("opt_cd") == "TC000603") && $(this).is(":checked")){
			check = true;
		}
	});
	$("input[name=opt]").each(function(){
		if( $(this).attr("opt_cd") == "TC000701" || $(this).attr("opt_cd") == "TC000702" ){
			if(check){
				$(this).attr("disabled",true);
			}else{
				$(this).removeAttr("disabled");
			}
		}
	});
}

/* ********************************************************
 * Object형태 중 Only data, Only Schema 중 1개만 체크가능
 ******************************************************** */
function checkObject(code){
	var check1 = false;
	var check2 = false;

	$("input[name=opt]").each(function(){
		if(code == "TC000701" && $(this).attr("opt_cd") == "TC000701" && $(this).is(":checked") ){
			check1 = true;
		}else if(code == "TC000702" && $(this).attr("opt_cd") == "TC000702" && $(this).is(":checked") ){
			check2 = true;
		}
	});
	
	$("input[name=opt]").each(function(){
		if(check1 && code == "TC000701" && $(this).attr("opt_cd") == "TC000702"){
			$(this).attr('checked', false);
		}else if(check2 && code == "TC000702" && $(this).attr("opt_cd") == "TC000701"){
			$(this).attr('checked', false);
		}
	});
}

/* ********************************************************
 * 쿼리에서 Use Column Inserts, Use Insert Commands선택시 "OIDS포함" disabled
 ******************************************************** */
function checkOid(){
	var check = false;
	$("input[name=opt]").each(function(){
		if( ($(this).attr("opt_cd") == "TC000901" || $(this).attr("opt_cd") == "TC000902") && $(this).is(":checked")){
			check = true;
		}
	});
	
	$("input[name=opt]").each(function(){
		if( $(this).attr("opt_cd") == "TC001001" ){
			if(check){
				$(this).attr("disabled",true);
			}else{
				$(this).removeAttr("disabled");
			}
		}
	});
}

/* ********************************************************
 * 저장경로의 존재유무 체크
 ******************************************************** */
function checkFolder(keyType){
	var save_path ="";
	
	if(keyType == 1){
		save_path = $("#log_file_pth").val();
	}else{
		save_path = $("#save_pth").val();
	}
	
	
	if(save_path == "" && keyType == 1){
		alert('<spring:message code="message.msg78" />');
		$("#log_file_pth").focus();
	}else if(save_path == "" && keyType == 2){
		alert('<spring:message code="message.msg79" />');
		$("#save_pth").focus();
	}else{
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
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						if(keyType == 1){
							$("#check_path1").val("Y");
						}else if(keyType == 2){
							$("#check_path2").val("Y");
						}
						alert('<spring:message code="message.msg100" />');
						var volume = data.result.RESULT_DATA.CAPACITY;
						if(keyType == 1){
							$("#logVolume").empty();
							$( "#logVolume" ).append("<spring:message code='common.volume' /> : "+volume);						
						}else if(keyType == 2) {
							$("#backupVolume").empty();
							$( "#backupVolume" ).append("<spring:message code='common.volume' /> : "+volume);
						}
					}else{
						if(haCnt > 1){
							alert('<spring:message code="backup_management.ha_configuration_cluster"/>'+data.SERVERIP+'<spring:message code="backup_management.node_path_no"/>');
						}else{
							alert('<spring:message code="backup_management.invalid_path"/>');
						}							
					}
				}else{
					alert('<spring:message code="message.msg76" /> ')
				}
			}
		});
	}
}

//work명 중복체크
function fn_check() {
	var wrk_nm = document.getElementById("wrk_nm");
	if (wrk_nm.value == "") {
		alert('<spring:message code="message.msg107" /> ');
		document.getElementById('wrk_nm').focus();
		return;
	}
	$.ajax({
		url : '/wrk_nmCheck.do',
		type : 'post',
		data : {
			wrk_nm : $("#wrk_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert('<spring:message code="backup_management.reg_possible_work_nm"/>');
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";
			} /* else {
				scd_nmChk = "fail";
				alert("중복된 WORK명이 존재합니다.");
				document.getElementById("wrk_nm").focus();
			} */
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		}
	});
}


</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Dump <spring:message code="dashboard.Register.backup" /></p>
		<div class="pop_cmm">
			<form name="workRegForm">
			<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
			<input type="hidden" name="check_path1" id="check_path1" value="N"/>
			<input type="hidden" name="check_path2" id="check_path2" value="N"/>
			<table class="write">
				<caption>Dump <spring:message code="dashboard.Register.backup" /></caption>
				<colgroup>
					<col style="width:105px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.work_name" /></th>
						<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength="20"/>
						<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.work_description" /></th>
						<td>
							<div class="textarea_grp">
								<textarea name="wrk_exp" id="wrk_exp" maxlength=25></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<colgroup>
					<col style="width:105px;" />
					<col />
					<col style="width:105px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.database" /></th>
						<td>
							<select name="db_id" id="db_id" class="select"  onChange="fn_get_object_list();">
								<option value=""><spring:message code="schedule.total" /></option>
								<c:forEach var="result" items="${dbList}" varStatus="status">
								<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<caption><spring:message code="dashboard.Register backup" /></caption>
				<colgroup>
					<col style="width:105px;" />
					<col style="width:178px;" />
					<col style="width:95px;" />
					<col style="width:178px;" />
					<col style="width:95px;" />
					<col style="width:150px;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.backup_log_dir" /></th>
						<td colspan="5"><input type="text" class="txt t4" name="log_file_pth" id="log_file_pth" style="width:530px" onKeydown="$('#check_path1').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>							
							<span id="logVolume" style="margin:63px;"></span>	
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.backup_dir" /></th>
						<td colspan="5"><input type="text" class="txt t4" name="save_pth" id="save_pth" style="width:530px" onKeydown="$('#check_path2').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.dir_check" /></button></span>							
							<span id="backupVolume" style="margin:63px;"></span>	
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.file_format" /></th>
						<td>
							<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t5">
								<option value=""><spring:message code="schedule.total" /></option>
								<option value="TC000401">tar</option>
								<option value="TC000402">plain</option>
								<option value="TC000403">directory</option>
							</select>
						</td>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.incording_method" /></th>
						<td>
							<select name="encd_mth_nm" id="encd_mth_nm" class="select t5">
								<option value=""><spring:message code="schedule.total" /></option>
								<c:forEach var="result" items="${incodeList}" varStatus="status">
									<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.rolename" /></th>
						<td>
							<select name="usr_role_nm" id="usr_role_nm" class="select t4">
								<option value=""><spring:message code="schedule.total" /></option>
								<c:forEach var="result" items="${roleList.data}" varStatus="status">
								<option value="<c:out value="${result.rolname}"/>"><c:out value="${result.rolname}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.compressibility" /></th>
						<td>
							<select name="cprt" id="cprt" class="select t4" style="width:80px;">
								<option value="0"><spring:message code="backup_management.uncompressed" /></option>
								<option value="1">1Level</option>
								<option value="2">2Level</option>
								<option value="3">3Level</option>
								<option value="4">4Level</option>
								<option value="5">5Level</option>
								<option value="6">6Level</option>
								<option value="7">7Level</option>
								<option value="8">8Level</option>
								<option value="9">9Level</option>
							</select> %</td>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.file_keep_day" /></th>
						<td><input type="number" class="txt t6" name="file_stg_dcnt" id="file_stg_dcnt" maxlength=3 min=0 value="0"/> <spring:message code="common.day" /></td>
						<th scope="row" class="ico_t2"><spring:message code="backup_management.backup_maintenance_count" /></th>
						<td><input type="number" class="txt t6" name="bck_mtn_ecnt" id="bck_mtn_ecnt" maxlength=3 min=0 value="0"/><spring:message code="backup_management.count"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm c2 mt25">
			<div class="addOption_grp">
				<ul class="tab">
					<li class="on"><a href="#n"><spring:message code="backup_management.add_option" /> #1</a></li>
					<li><a href="#n"><spring:message code="backup_management.add_option" /> #2</a></li>
					<li><a href="#n"><spring:message code="backup_management.object_choice" /></a></li>
				</ul>
				<div class="tab_view">
					<div class="view on addOption_inr">
						<ul>
							<li>
								<p class="op_tit"><spring:message code="backup_management.sections" /></p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_1_1" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000601" onClick="checkSection();" />
										<label for="option_1_1"><spring:message code="backup_management.pre-data" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_1_2" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000602" onClick="checkSection();"/>
										<label for="option_1_2"><spring:message code="backup_management.data" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_1_3" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000603" onClick="checkSection();"/>
										<label for="option_1_3"><spring:message code="backup_management.post-data" /></label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit"><spring:message code="backup_management.object_type" /></p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_2_1" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000701" onClick="checkObject('TC000701');"/>
										<label for="option_2_1"><spring:message code="backup_management.only_data" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_2_2" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000702" onClick="checkObject('TC000702');"/>
										<label for="option_2_2"><spring:message code="backup_management.only_schema" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_2_3" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000703"/>
										<label for="option_2_3"><spring:message code="backup_management.blobs" /></label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit"><spring:message code="backup_management.save_yn_choice" /></p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_3_1" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000801" disabled/>
										<label for="option_3_1"><spring:message code="backup_management.owner" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_3_2" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000802"/>
										<label for="option_3_2"><spring:message code="backup_management.privilege" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_3_3" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000803"/>
										<label for="option_3_3"><spring:message code="backup_management.tablespace" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_3_4" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000804"/>
										<label for="option_3_4"><spring:message code="backup_management.unlogged_table_data" /></label>
									</span>
								</div>
							</li>
						</ul>
					</div>
					<div class="view addOption_inr">
						<ul>
							<li>
								<p class="op_tit"><spring:message code="backup_management.query" /></p>
								<div class="inp_chk double">
									<span>
										<input type="checkbox" id="option_4_1" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000901" onClick="checkOid();"/>
										<label for="option_4_1"><spring:message code="backup_management.use_column_inserts" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_4_2" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000902" onClick="checkOid();"/>
										<label for="option_4_2"><spring:message code="backup_management.use_column_commands" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_4_3" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000903" disabled/>
										<label for="option_4_3"><spring:message code="backup_management.create_database_include" /></label>
									</span>
									<span>
										<input type="checkbox" id="option_4_4" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000904" disabled/>
										<label for="option_4_4"><spring:message code="backup_management.drop_database_include" /></label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">기타</p>
								<div class="inp_chk third">
									<span>
										<input type="checkbox" id="option_5_1" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001001"/>
										<label for="option_5_1"><spring:message code="backup_management.oids_include" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_5_2" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001002"/>
										<label for="option_5_2"><spring:message code="backup_management.quote_include" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_5_3" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001003"/>
										<label for="option_5_3"><spring:message code="backup_management.Identifier_quotes_apply" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_5_4" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001004"/>
										<label for="option_5_4"><spring:message code="backup_management.set_session_auth_use" /> </label>
									</span>
									<span>
										<input type="checkbox" id="option_5_5" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001005"/>
										<label for="option_5_5"><spring:message code="backup_management.detail_message_include" /></label>
									</span>
								</div>
							</li>
						</ul>
					</div>
					<div class="view">
						<div class="tNav" >						
						</div>
					</div>
				</div>
			</div>
			</form>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01" onClick="fn_insert_work();"><button><spring:message code="common.registory" /></button></span>
			<a href="#n" class="btn" onclick="self.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>
