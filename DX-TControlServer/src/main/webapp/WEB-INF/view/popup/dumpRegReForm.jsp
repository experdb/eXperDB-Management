<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dumpRegReForm.jsp
	* @Description : rman 백업 수정 화면
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

/* ********************************************************
 * DB Object initialization
 ******************************************************** */
var workObj = {"obj":[
	<c:forEach var="result" items="${workObjList}" varStatus="status">
	{"scm_nm":"${result.scm_nm}","obj_nm":"${result.obj_nm}"},
	</c:forEach>
	{"scm_nm":"","obj_nm":""}
]};

/* ********************************************************
 * Checkbox, Object List initialization
 ******************************************************** */
$(window.document).ready(
	function() {
		//fn_get_object_list("${workInfo[0].db_id}","${workInfo[0].db_nm}");
		checkSection();
		changeFileFmtCd();
		checkOid();

		setTimeout("fn_get_object_list('','')", 100); 
		
		fn_checkFolderVol(1);
		fn_checkFolderVol(2);

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
			}
		});  */

});

/* ********************************************************
 * Dump Backup Update
 ******************************************************** */
function fn_update_work(){
	if(valCheck()){
		$.ajax({
			async : false,
			url : "/popup/workDumpReWrite.do",
		  	data : {
		  		bck_wrk_id : $("#bck_wrk_id").val(),
		  		wrk_id : $("#wrk_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		db_id : $("#db_id").val(),
		  		bck_bsn_dscd : "TC000202",
		  		save_pth : $("#save_pth").val(),
		  		file_fmt_cd : $("#file_fmt_cd").val(),
		  		cprt : $("#cprt").val(),
		  		encd_mth_nm : $("#encd_mth_nm").val(),
		  		usr_role_nm : $("#usr_role_nm").val(),
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val(),
		  		bck_filenm : $("#bck_filenm").val(),
		  		log_file_pth : $("#log_file_pth").val()
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				alert("a");
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
					fn_insert_opt();
			}
		});  
	}
}

/* ********************************************************
 * Dump Backup Option Insert
 ******************************************************** */
function fn_insert_opt(){
	var sn = 1;
	$("input[name=opt]").each(function(){
		if( $(this).not(":disabled") && $(this).is(":checked")){
			fn_insert_opt_val($("#bck_wrk_id").val(),$("#wrk_id").val(),sn,$(this).attr("grp_cd"),$(this).attr("opt_cd"),"Y");
		}
		sn++;
	});

	fn_insert_object();
}

/* ********************************************************
 * Dump Backup Each Option Insert
 ******************************************************** */
function fn_insert_opt_val(bck_wrk_id, wrk_id, opt_sn, grp_cd, opt_cd, bck_opt_val){
	$.ajax({
		async : false,
		url : "/popup/workOptWrite.do",
	  	data : {
	  		bck_wrk_id: bck_wrk_id,
	  		wrk_id : wrk_id,
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
		success : function() {}
	});
}

/* ********************************************************
 * Dump Backup Object Insert
 ******************************************************** */
function fn_insert_object(){
	$("input[name=tree]").each(function(){
		if( $(this).is(":checked")){
			fn_insert_object_val($("#bck_wrk_id").val(),$("#wrk_id").val(),$(this).attr("otype"),$(this).attr("schema"),$(this).val());
		}
	});

	opener.fn_dump_find_list();
	alert("수정이 완료되었습니다.");
	self.close();
}

/* ********************************************************
 * Dump Backup Each Object Insert
 ******************************************************** */
function fn_insert_object_val(bck_wrk_id, wrk_id,otype,scm_nm,obj_nm){
	var db_id = $("#db_id").val();

	if(otype != "table") obj_nm = "";
	$.ajax({
		async : false,
		url : "/popup/workObjWrite.do",
	  	data : {
	  		bck_wrk_id : bck_wrk_id,
	  		wrk_id : wrk_id,
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
		success : function() {}
	});
}

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#db_id option:selected" ).val() == ""){
		alert("백업할 Database를 선택하세요.");
		return false;
	}else if($("#wrk_nm").val() == ""){
		alert("Work명을 입력해 주세요.");
		$("#wrk_nm").focus();
		return false;
	}else if($("#wrk_exp").val() == ""){
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
function fn_get_object_list(in_db_id,in_db_nm){
	var db_nm = in_db_nm;
	var db_id = in_db_id;
	
	if(in_db_id == "" || in_db_nm == ""){
		db_nm = $( "#db_id option:selected" ).text();
		db_id = $( "#db_id option:selected" ).val();
	}

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
			var checkStr = "";
			$(workObj.obj).each(function(i,v){
				if(v.scm_nm == item.schema && v.obj_nm == "") checkStr = " checked";
			});
			html += "<li class='active'><a href='#'>"+item.schema+"</a>";
			html += "<div class='inp_chk'>";
			html += "<input type='checkbox' onClick=fn_checkAll('" + schemaCnt + "','"+item.schema+"') id='schema"+schemaCnt+"' name='tree' value='"+item.schema+"' otype='schema' schema='"+item.schema+"'"+checkStr+"/><label for='schema"+schemaCnt+"'></label>";
			html += "</div>";
			html += "<ul>\n";
		}
		
		var checkStr = "";
		$(workObj.obj).each(function(i,v){
			if(v.scm_nm == item.schema && v.obj_nm == item.name) checkStr = " checked";
		});
		html += "<li><a href='#'>"+item.name+"</a>";
		html += "<div class='inp_chk'>";
		html += "<input type='checkbox' id='table"+index+"' name='tree' value='"+item.name+"' otype='table' schema='"+item.schema+"'"+checkStr+"/><label for='table"+index+"'></label>";
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
					if(data.result.RESULT_DATA == 0){
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
						alert("HA 구성된 클러스터 중 해당 경로가 존재하지 않는 클러스터가 있습니다." );
					}
				}else{
					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
				}
			}
		});
	}
}
</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Dump 백업 수정</p>
		<div class="pop_cmm">
			<form name="workRegForm">
			<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
			<input type="hidden" name="wrk_id" id="wrk_id" value="${wrk_id}"/>
			<input type="hidden" name="bck_wrk_id" id="bck_wrk_id" value="${bck_wrk_id}"/>
			<input type="hidden" name="check_path1" id="check_path1" value="N"/>
			<input type="hidden" name="check_path2" id="check_path2" value="N"/>
			<table class="write">
				<caption>Dump 백업 수정</caption>
				<colgroup>
					<col style="width:95px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Work명</th>
						<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=25 value="<c:out value="${workInfo[0].wrk_nm}"/>"/></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Work<br/>설명</th>
						<td>
							<div class="textarea_grp">
								<textarea name="wrk_exp" id="wrk_exp" maxlength=25><c:out value="${workInfo[0].wrk_exp}"/></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<colgroup>
					<col style="width:95px;" />
					<col />
					<col style="width:95px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Database</th>
						<td>
							<select name="db_id" id="db_id" class="select"  onChange="fn_get_object_list('','');">
								<option value="">선택</option>
								<c:forEach var="result" items="${dbList}" varStatus="status">
								<option value="<c:out value="${result.db_id}"/>" <c:if test="${result.db_id eq workInfo[0].db_id}"> selected</c:if>><c:out value="${result.db_nm}"/></option>
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
					<col style="width:80px;" />
					<col style="width:178px;" />
					<col style="width:95px;" />
					<col style="width:178px;" />
					<col style="width:95px;" />
					<col style="width:150px;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t2">백업로그경로</th>
						<td colspan="5"><input type="text" class="txt t4" name="log_file_pth" id="log_file_pth" style="width:650px" value="<c:out value="${workInfo[0].log_file_pth}"/>" onKeydown="$('#check_path1').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>							
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">백업경로</th>
						<td colspan="5"><input type="text" class="txt t4" name="save_pth" id="save_pth" style="width:650px" value="<c:out value="${workInfo[0].save_pth}"/>" onKeydown="$('#check_path2').val('N')"/>
							<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
						</td>
					</tr>					
					<tr>
						<th scope="row" class="ico_t2">파일포맷</th>
						<td>
							<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();" class="select t5">
								<option value="">선택</option>
								<option value="TC000401"<c:if test="${workInfo[0].file_fmt_cd eq 'TC000401' }"> selected</c:if>>tar</option>
								<option value="TC000402"<c:if test="${workInfo[0].file_fmt_cd eq 'TC000402' }"> selected</c:if>>plain</option>
								<option value="TC000403"<c:if test="${workInfo[0].file_fmt_cd eq 'TC000403' }"> selected</c:if>>directory</option>
							</select>
						</td>
						<th scope="row" class="ico_t2">인코딩방식</th>
						<td>
							<select name="encd_mth_nm" id="encd_mth_nm" class="select t5">
								<option value="">선택</option>
								<c:forEach var="result" items="${incodeList}" varStatus="status">
									<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${workInfo[0].encd_mth_nm eq result.sys_cd }"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row" class="ico_t2">Rolename</th>
						<td>
							<select name="usr_role_nm" id="usr_role_nm" class="select t4">
								<option value="">선택</option>
								<c:forEach var="result" items="${roleList.data}" varStatus="status">
								<option value="<c:out value="${result.rolname}"/>"<c:if test="${workInfo[0].usr_role_nm eq result.rolname }"> selected</c:if>><c:out value="${result.rolname}"/></option>
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
						<td><input type="number" class="txt t6" name="file_stg_dcnt" id="file_stg_dcnt" maxlength=3 min=0 value="<c:out value="${workInfo[0].file_stg_dcnt}"/>"/> 일</td>
						<th scope="row" class="ico_t2">백업유지갯수</th>
						<td><input type="number" class="txt t6" name="bck_mtn_ecnt" id="bck_mtn_ecnt" maxlength=3 min=0 value="<c:out value="${workInfo[0].bck_mtn_ecnt}"/>"/> 개</td>
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
										<input type="checkbox" id="option_1_1" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000601" onClick="checkSection();"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000601'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_1_1">Pre-data</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_2" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000602" onClick="checkSection();"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000602'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_1_2">data</label>
									</span>
									<span>
										<input type="checkbox" id="option_1_3" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000603" onClick="checkSection();"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0006' && optVal.opt_cd eq 'TC000603'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_1_3">Post-data</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">오브젝트 형태</p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_2_1" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000701" onClick="checkObject('TC000701');"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000701'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_2_1">Only data</label>
									</span>
									<span>
										<input type="checkbox" id="option_2_2" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000702" onClick="checkObject('TC000702');"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000702'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_2_2">Only Schema</label>
									</span>
									<span>
										<input type="checkbox" id="option_2_3" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000703"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0007' && optVal.opt_cd eq 'TC000703'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_2_3">Blobs</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">저장여부선택</p>
								<div class="inp_chk">
									<span>
										<input type="checkbox" id="option_3_1" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000801"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000801'}">checked</c:if>
										</c:forEach>
										 disabled/>
										<label for="option_3_1">Owner</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_2" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000802"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000802'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_3_2">Privilege</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_3" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000803"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000803'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_3_3">Tablespace</label>
									</span>
									<span>
										<input type="checkbox" id="option_3_4" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000804"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0008' && optVal.opt_cd eq 'TC000804'}">checked</c:if>
										</c:forEach>
										/>
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
										<input type="checkbox" id="option_4_1" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000901" onClick="checkOid();"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000901'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_4_1">Use Column Inserts</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_2" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000902" onClick="checkOid();"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000902'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_4_2">Use Insert Commands</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_3" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000903" disabled
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000903'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_4_3">CREATE DATABASE포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_4_4" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000904" disabled
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0009' && optVal.opt_cd eq 'TC000904'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_4_4">DROP DATABASE포함</label>
									</span>
								</div>
							</li>
							<li>
								<p class="op_tit">기타</p>
								<div class="inp_chk third">
									<span>
										<input type="checkbox" id="option_5_1" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001001"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001001'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_5_1">OIDS포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_2" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001002"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001002'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_5_2">인용문포함</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_3" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001003"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001003'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_5_3">식별자에 ""적용</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_4" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001004"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001004'}">checked</c:if>
										</c:forEach>
										/>
										<label for="option_5_4">Set Session authorization사용</label>
									</span>
									<span>
										<input type="checkbox" id="option_5_5" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001005"
										<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
											<c:if test="${optVal.grp_cd eq 'TC0010' && optVal.opt_cd eq 'TC001005'}">checked</c:if>
										</c:forEach>
										/>
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
			<span class="btn btnC_01" onClick="fn_update_work();return false;"><button>수정</button></span>
			<a href="#n" class="btn" onclick="self.close();return false;"><span>취소</span></a>
		</div>
	</div>
</div>
</body>
</html>
