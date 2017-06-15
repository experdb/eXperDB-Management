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
		  		wrk_id : $("#wrk_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		bck_opt_cd : $("#bck_opt_cd").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val(),
		  		cps_yn : cps_yn,
		  		log_file_bck_yn : log_file_bck_yn,
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		log_file_stg_dcnt : $("#log_file_stg_dcnt").val(),
		  		log_file_mtn_ecnt : $("#log_file_mtn_ecnt").val()
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
			},
			success : function(data) {
				fn_insert_opt();
			}
		});  
	}
}

function fn_insert_opt(){
	var sn = 1;
	$("input[name=opt]").each(function(){
		fn_insert_optval($("#wrk_id").val(),sn,$(this).attr("grp_cd"),$(this).attr("opt_cd"),$(this).val());
		sn++;
	});
	opener.location.reload();	
	alert("수정이 완료되었습니다.");
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

</script>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><img
					src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
					alt="" /> RMAN백업 수정</li>
			</ul>
		</div>
		<!-- // 타이틀 -->
		
		<div id="regForm">
			<form name="workRegForm">
			<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
			<input type="hidden" name="wrk_id" id="wrk_id" value="${wrk_id}"/> 
			<div>
				<ul style="padding-top:10px;float:left;">
					<li class="title"><span>Work명</span></li>
					<li class="content"><input type="text" name="wrk_nm" id="wrk_nm" value="<c:out value="${workInfo[0].wrk_nm}"/>" maxlength=50/></li>
					<li class="title"><span>Work설명</span></li>
					<li class="content"><textarea name="wrk_exp" id="wrk_exp" maxlength=200 style="width:95%;height:50px;"><c:out value="${workInfo[0].wrk_exp}"/></textarea></li>
					<li class="title"><span>백업옵션</span></li>
					<li class="content">
						<select name="bck_opt_cd" id="bck_opt_cd">
							<option value="">선택</option>
							<option value="full"<c:if test="${workInfo[0].bck_opt_cd == 'full'}"> selected</c:if>>전체백업</option>
							<option value="incr"<c:if test="${workInfo[0].bck_opt_cd == 'incr'}"> selected</c:if>>증분백업</option>
							<option value="achi"<c:if test="${workInfo[0].bck_opt_cd == 'achi'}"> selected</c:if>>아카이브백업</option>
						</select>
					</li>
				</ul>
				<ul id="cps_opt" style="padding-top:20px;float:left;">
					<li class="title"><span>압축</span></li>
					<li class="content"><input type="checkbox" name="cps_yn" id="cps_yn" value="Y" <c:if test="${workInfo[0].cps_yn eq 'Y'}"> checked</c:if>/></li>					
				</ul>
				<ul id="back_opt" style="padding-top:0px;float:left;border:1px solid black;">
					<li class="total"><span>백업파일옵션</span></li>
					<li class="title1"><span>백업파일 보관일</span></li>
					<li class="content1"><input type="text" name="file_stg_dcnt" id="file_stg_dcnt" value="<c:out value="${workInfo[0].file_stg_dcnt}"/>" maxlength=3 style="width:50px;"/></li>
					<li class="title1"><span>백업파일 유지갯수</span></li>
					<li class="content1"><input type="text" name="bck_mtn_ecnt" id="bck_mtn_ecnt" value="<c:out value="${workInfo[0].bck_mtn_ecnt}"/>" maxlength=3 style="width:50px;"/></li>
				</ul>
				<ul id="log_opt" style="float:left;border:1px solid black;">
					<li class="total"><span>로그파일옵션</span></li> 
					<li class="title"><span>로그파일백업여부</span></li>
					<li class="content"><input type="checkbox" name="log_file_bck_yn" id="log_file_bck_yn" value="Y" <c:if test="${workInfo[0].log_file_bck_yn eq 'Y'}"> checked</c:if>/></li>
					<li class="title1"><span>서버로그 파일보관일수</span></li>
					<li class="content1"><input type="text" name="log_file_stg_dcnt" id="log_file_stg_dcnt" value="<c:out value="${workInfo[0].log_file_stg_dcnt}"/>" maxlength=3 style="width:50px;"/></li>
					<li class="title1"><span>서버로그 파일유지갯수</span></li>
					<li class="content1"><input type="text" name="log_file_mtn_ecnt" id="log_file_mtn_ecnt" value="<c:out value="${workInfo[0].log_file_mtn_ecnt}"/>" maxlength=3 style="width:50px;"/></li>
				</ul>
			</div>
			</form>
		</div>
		<!-- // 리스트 -->
				<!-- //등록버튼 -->
		<div id="sysbtn">
			<ul>
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_update_work();">수정</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
			</ul>
		</div>
	</div>
</body>
</html>