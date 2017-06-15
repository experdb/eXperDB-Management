<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
</head>
<style>
li.total{
   list-style-type: none;
   float: left;
   padding: 3px 0px 2px 0px;
   text-align:left;
   width: 100%;
   font-family: "돋움";
   font-size: 12px;
   font-weight: bold;
   color: #000000;
}

li.title{
   list-style-type: none;
   float: left;
   padding: 3px 0px 2px 0px;
   text-align:left;
   width: 110px;
   font-family: "돋움";
   font-size: 12px;
   color: #000000;
   text-
}

li.content{
   list-style-type: none;
   float: left;
   padding: 3px 0px 2px 0px;
   text-align:left;
   width: 520px;
   font-family: "돋움";
   font-size: 12px;
   color: #000000;
}

li.title1{
   list-style-type: none;
   float: left;
   padding: 3px 0px 2px 0px;
   text-align:left;
   width: 170px;
   font-family: "돋움";
   font-size: 12px;
   color: #000000;
}

li.content1{
   list-style-type: none;
   float: left;
   padding: 3px 0px 2px 0px;
   text-align:left;
   width: 125px;
   font-family: "돋움";
   font-size: 12px;
   color: #000000;
}
</style>
<script type="text/javascript">
// 저장후 작업ID
var wrk_id = null;

function fn_insert_work(){
	var cps_yn = "N";
	var log_file_bck_yn = "N";
	
	if( $("#cps_yn").is(":checked")) cps_yn = "Y";
	if( $("#log_file_bck_yn").is(":checked")) log_file_bck_yn = "Y";
	
	if(valCheck()){
		$.ajax({
			async : false,
			url : "/popup/workDumpWrite.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		db_id : $("#db_id").val(),
		  		bck_bsn_dscd : "dump",
		  		save_pth : $("#save_pth").val(),
		  		file_fmt_cd : $("#file_fmt_cd").val(),
		  		cprt : $("#cprt").val(),
		  		encd_mth_nm : $("#encd_mth_nm").val(),
		  		usr_role_nm : $("#usr_role_nm").val(),
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val()
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
			},
			success : function(data) {
				fn_insert_opt(data);
			}
		});  
	}
}

function fn_insert_opt(data){

	var sn = 1;
	if(data != "0"){
		$("input[name=opt]").each(function(){
			if( $(this).not(":disabled") && $(this).is(":checked")){
				fn_insert_optval(data,sn,$(this).attr("grp_cd"),$(this).attr("opt_cd"),"Y");
			}else{
				fn_insert_optval(data,sn,$(this).attr("grp_cd"),$(this).attr("opt_cd"),"N");
			}
			//alert(sn);
			sn++;
		});
	}
	opener.location.reload();
	alert("등록이 완료되었습니다.");
	self.close();
}

function fn_insert_optval(wrk_id, opt_sn, grp_cd, opt_cd, bck_opt_val){
	
	$.ajax({
		async : false,
		url : "/popup/workOptWrite.do",
	  	data : {
	  		wrk_id : wrk_id,
	  		opt_sn : opt_sn,
	  		grp_cd : grp_cd,
	  		opt_cd : opt_cd,
	  		bck_opt_val : bck_opt_val
	  	},
		type : "post",
		error : function(request, xhr, status, error) {
			alert("백업옵션 저장실패");
		},
		success : function() {
		}
	});  
}

function valCheck(){
	if($("#wrk_nm").val() == ""){
		alert("Work명을 입력해 주세요.");
		$("#wrk_nm").focus();
		return false;
	}
	if($("#wrk_exp").val() == ""){
		alert("Work설명을 입력해 주세요.");
		$("#wrk_exp").focus();
		return false;
	}
	if($("#bck_opt_cd").val() == ""){
		alert("백업옵션을 선택해 주세요.");
		$("#bck_opt_cd").focus();
		return false;
	}
	
	return true;
}



function fn_find_list(){
	getDataList($("#wrk_nm").val(), $("#bck_opt_cd").val());
}

function changeFileFmtCd(){
	if($("#file_fmt_cd").val() == "TC000401"){
		$(".cprt_1").show();
	}else{
		$(".cprt_1").hide();
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

/** sections 체크시 Object형태중 Only data, Only Schema를 비활성화 시킨다. **/
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

</script>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><img
					src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
					alt="" /> RMAN백업 등록</li>
			</ul>
		</div>
		<!-- // 타이틀 -->
		
		<div id="regForm">
			<form name="workRegForm">
			<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
			<div>
				<ul style="padding-top:10px;float:left;">
					<li class="title"><span>Work명</span></li>
					<li class="content"><input type="text" name="wrk_nm" id="wrk_nm" maxlength=50/></li>
					<li class="title"><span>Work설명</span></li>
					<li class="content"><textarea name="wrk_exp" id="wrk_exp" maxlength=200 style="width:95%;height:50px;"></textarea></li>
					</li>
				</ul>
				<ul id="cps_opt" style="padding-top:20px;float:left;">
					<li class="title"><span>Database</span></li>
					<li class="content">
						<select name="db_id" id="db_id">
							<option value="">선택</option>
							<c:forEach var="result" items="${dbList}" varStatus="status">
							<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
							</c:forEach>
						</select>
					</li>
				</ul>
				<ul id="file_opt" style="float:left;border:1px solid black;">
					<li class="title"><span>저장경로</span></li>
					<li class="content"><input type="text" name="save_pth" id="save_pth" style="width:400px"/></li>
					
					<li class="title1"><span>파일포맷</span></li>
					<li class="content1">
						<select name="file_fmt_cd" id="file_fmt_cd" onChange="changeFileFmtCd();">
							<option value="">선택</option>
							<option value="TC000401">tar</option>
							<option value="TC000402">plain</option>
							<option value="TC000403">directory</option>
						</select>
					</li>
					<li class="title1"><span class="cprt_1" style="display:none;">압축률</span></li>
					<li class="content1"><span class="cprt_1" style="display:none;"><input type="text" name="cprt" id="cprt" maxlength=3 value="0" style="width:50px;"/></span></li>
					
					<li class="title1"><span>인코딩방식</span></li>
					<li class="content1">
						<select name="encd_mth_nm" id="encd_mth_nm">
							<c:forEach var="result" items="${incodeList}" varStatus="status">
								<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${result.sys_cd == 'TC000507'}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
							</c:forEach>
						</select>
					</li>
					<li class="title1"><span>Rolename</span></li>
					<li class="content1">
						<select name="usr_role_nm" id="usr_role_nm">
							<option value="">선택</option>
						</select>
					</li>
					<li class="title1"><span>파일보관일수</span></li>
					<li class="content1"><input type="text" name="file_stg_dcnt" id="file_stg_dcnt" maxlength=3 style="width:50px;"/></li>
					<li class="title1"><span>백업유지갯수</span></li>
					<li class="content1"><input type="text" name="bck_mtn_ecnt" id="bck_mtn_ecnt" maxlength=3 style="width:50px;"/></li>
				</ul>
				<ul id="opt1" style="float:left;border:1px solid black;">
					<li class="total"><span>부가옵션 #1</span></li>
					<li class="title"><span>Sections</span></li>
					<li class="content">
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000601" onClick="checkSection();"/>Pre-data
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000602" onClick="checkSection();"/>Data
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0006" opt_cd="TC000603" onClick="checkSection();"/>Post-data
					</li>
					<li class="title"><span>Object 형태</span></li>
					<li class="content">
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000701" onClick="checkObject('TC000701');"/>Only data
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000702" onClick="checkObject('TC000702');"/>Only Schema
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0007" opt_cd="TC000703"/>Blobs
					</li>
					<li class="title"><span>저장안함 선택</span></li>
					<li class="content">
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000801" disabled/>Owner
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000802"/>Privilege
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000803"/>Tablespace
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0008" opt_cd="TC000804"/>Unlogged TableData
					</li>
				</ul>
				<ul id="opt1" style="float:left;border:1px solid black;">
					<li class="total"><span>부가옵션 #2</span></li>
					<li class="title"><span>쿼리</span></li>
					<li class="content">
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000901" onClick="checkOid();"/>Use Column Inserts
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000902" onClick="checkOid();"/>Use Insert Commands
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000903" disabled/>CREATE DATABASE포함
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0009" opt_cd="TC000904" disabled/>DROP DATABASE포함
					</li>
					<li class="title"><span>기타</span></li>
					<li class="content">
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001001"/>OIDS포함					
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001002"/>인용문포함
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001003"/>식별자에 ""적용						
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001004"/>Set Session authorization사용
						<input type="checkbox" name="opt" value="Y" grp_cd="TC0010" opt_cd="TC001005"/>자세한 메시지 포함
					</li>
				</ul>
			</div>
			</form>
		</div>
		<!-- // 리스트 -->
				<!-- //등록버튼 -->
		<div id="sysbtn">
			<ul>
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_insert_work();">등록</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
			</ul>
		</div>
	</div>
</body>
</html>