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

$(window.document).ready(function() {
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				document.getElementById("log_file_pth").value=result[1].PGDLOG;
				document.getElementById("save_pth").value=result[1].PGDBAK;		
				
				fn_checkFolderVol(1);
				fn_checkFolderVol(2);
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
		alert("동일Work명이 존재합니다. 다른 Work명을 입력해주세요.");
		$("#wrk_nm").val("");
		$("#wrk_nm").focus();
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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
	alert("등록이 완료되었습니다.");
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
		alert("백업할 Database를 선택하세요.");
		return false;
	}
	else if($("#wrk_nm").val() == ""){
		alert("Work명을 입력해 주세요.");
		$("#wrk_nm").focus();
		return false;
	}
	else if($("#wrk_exp").val() == ""){
		alert("Work설명을 입력해 주세요.");
		$("#wrk_exp").focus();
		return false;
	}else if($("#log_file_pth").val() == ""){
		alert("백업로그경로를 입력해 주세요.");
		$("#log_file_pth").focus();
		return false;
	}else if($("#save_pth").val() == ""){
		alert("백업경로를 입력해 주세요.");
		$("#save_pth").focus();
		return false;
	}else if($("#check_path1").val() != "Y"){
		alert("백업로그경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
		$("#log_file_pth").focus();
		return false;
	}else if($("#check_path2").val() != "Y"){
		alert("백업경로에 유효한 경로를 입력후 경로체크를 해 주세요.");		
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
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
	if(keyType == 1){
		save_path = $("#log_file_pth").val();
	}else{
		save_path = $("#save_pth").val();
	}
	
	
	if(save_path == "" && keyType == 1){
		alert("백업로그 경로를 입력해 주세요.");
		$("#log_file_pth").focus();
	}else if(save_path == "" && keyType == 2){
		alert("백업경로를 입력해 주세요.");
		$("#save_pth").focus();
	}else{
		$.ajax({
			async : false,
			url : "/existDirCheck.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		path : save_pth
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
						alert("유효한 경로입니다.");
						var volume = data.result.RESULT_DATA.CAPACITY;
						if(keyType == 1){
							$("#logVolume").empty();
							$( "#logVolume" ).append("용량 : "+volume);						
						}else if(keyType == 2) {
							$("#backupVolume").empty();
							$( "#backupVolume" ).append("용량 : "+volume);
						}
					}else{
						alert("HA 구성된 클러스터 중 해당 경로가 존재하지 않는 클러스터가 있습니다.");
					}
				}else{
					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
				}
			}
		});
	}
}

//work명 중복체크
function fn_check() {
	var wrk_nm = document.getElementById("wrk_nm");
	if (wrk_nm.value == "") {
		alert("WORK명을 입력하세요.");
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
				alert("등록 가능한 WORK명 입니다.");
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";
			} else {
				scd_nmChk = "fail";
				alert("중복된 WORK명이 존재합니다.");
				document.getElementById("wrk_nm").focus();
			}
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
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
		<p class="tit">Dump 백업 등록</p>
		<div class="pop_cmm">
			<form name="workRegForm">
			<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
			<input type="hidden" name="check_path1" id="check_path1" value="N"/>
			<input type="hidden" name="check_path2" id="check_path2" value="N"/>
			<table class="write">
				<caption>Dump 백업 등록</caption>
				<colgroup>
					<col style="width:105px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Work명</th>
						<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=25/>
						<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Work<br/>설명</th>
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
						<th scope="row" class="ico_t1">Database</th>
						<td>
							<select name="db_id" id="db_id" class="select"  onChange="fn_get_object_list();">
								<option value="">선택</option>
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
				<caption>백업 등록</caption>
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
						<th scope="row" class="ico_t2">백업로그경로</th>
						<td colspan="5"><input type="text" class="txt t4" name="log_file_pth" id="log_file_pth" style="width:530px" onKeydown="$('#check_path1').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>							
							<span id="logVolume" style="margin:63px;"></span>	
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">백업경로</th>
						<td colspan="5"><input type="text" class="txt t4" name="save_pth" id="save_pth" style="width:530px" onKeydown="$('#check_path2').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>							
							<span id="backupVolume" style="margin:63px;"></span>	
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">파일포맷</th>
						<td>
							<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t5">
								<option value="">선택</option>
								<option value="TC000401">tar</option>
								<option value="TC000402">plain</option>
								<option value="TC000403">directory</option>
							</select>
						</td>
						<th scope="row" class="ico_t2">인코딩방식</th>
						<td>
							<select name="encd_mth_nm" id="encd_mth_nm" class="select t5">
								<option value="">선택</option>
								<c:forEach var="result" items="${incodeList}" varStatus="status">
									<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row" class="ico_t2">Rolename</th>
						<td>
							<select name="usr_role_nm" id="usr_role_nm" class="select t4">
								<option value="">선택</option>
								<c:forEach var="result" items="${roleList.data}" varStatus="status">
								<option value="<c:out value="${result.rolname}"/>"><c:out value="${result.rolname}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">압축률</th>
						<td>
							<select name="cprt" id="cprt" class="select t4" style="width:80px;">
								<option value="0">미압축</option>
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
						<th scope="row" class="ico_t2">파일보관일수</th>
						<td><input type="number" class="txt t6" name="file_stg_dcnt" id="file_stg_dcnt" maxlength=3 min=0 value="0"/> 일</td>
						<th scope="row" class="ico_t2">백업유지갯수</th>
						<td><input type="number" class="txt t6" name="bck_mtn_ecnt" id="bck_mtn_ecnt" maxlength=3 min=0 value="0"/>개</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm c2 mt25">
			<div class="addOption_grp">
				<ul class="tab">
					<li class="on"><a href="#n">부가옵션 #1</a></li>
					<li><a href="#n">부가옵션 #2</a></li>
					<li><a href="#n">오브젝트 선택</a></li>
				</ul>
				<div class="tab_view">
					<div class="view on addOption_inr">
						<ul>
							<li>
								<p class="op_tit">Sections</p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_1_1" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000601" onClick="checkSection();" />
										<label for="option_1_1">Pre-data</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_2" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000602" onClick="checkSection();"/>
										<label for="option_1_2">data</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_3" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000603" onClick="checkSection();"/>
										<label for="option_1_3">Post-data</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">오브젝트 형태</p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_2_1" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000701" onClick="checkObject('TC000701');"/>
										<label for="option_2_1">Only data</label>
									</span>
									<span>
										<input type="checkbox" id="option_2_2" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000702" onClick="checkObject('TC000702');"/>
										<label for="option_2_2">Only Schema</label>
									</span>
									<span>
										<input type="checkbox" id="option_2_3" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000703"/>
										<label for="option_2_3">Blobs</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">저장여부선택</p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_3_1" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000801" disabled/>
										<label for="option_3_1">Owner</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_2" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000802"/>
										<label for="option_3_2">Privilege</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_3" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000803"/>
										<label for="option_3_3">Tablespace</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_4" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000804"/>
										<label for="option_3_4">Unlogged Table data</label>
									</span>
								</div>
							</li>
						</ul>
					</div>
					<div class="view addOption_inr">
						<ul>
							<li>
								<p class="op_tit">쿼리</p>
								<div class="inp_chk double">
									<span>
										<input type="checkbox" id="option_4_1" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000901" onClick="checkOid();"/>
										<label for="option_4_1">Use Column Inserts</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_2" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000902" onClick="checkOid();"/>
										<label for="option_4_2">Use Insert Commands</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_3" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000903" disabled/>
										<label for="option_4_3">CREATE DATABASE포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_4" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000904" disabled/>
										<label for="option_4_4">DROP DATABASE포함</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">기타</p>
								<div class="inp_chk third">
									<span>
										<input type="checkbox" id="option_5_1" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001001"/>
										<label for="option_5_1">OIDS포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_2" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001002"/>
										<label for="option_5_2">인용문포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_3" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001003"/>
										<label for="option_5_3">식별자에 ""적용</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_4" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001004"/>
										<label for="option_5_4">Set Session authorization사용</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_5" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001005"/>
										<label for="option_5_5">자세한 메시지 포함</label>
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
			<span class="btn btnC_01" onClick="fn_insert_work();"><button>등록</button></span>
			<a href="#n" class="btn" onclick="self.close();"><span>취소</span></a>
		</div>
	</div>
</div>
</body>
</html>
