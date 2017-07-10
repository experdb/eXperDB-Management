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
		  		cps_yn : cps_yn,
		  		log_file_bck_yn : log_file_bck_yn
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
					<c:forEach var="result" items="${opt1}" varStatus="status">
						<li class="title1"><span><c:out value="${result.opt_cd_nm}"/></span></li>
						<c:set var="optDbVal" value="${result.dft_cd_val}"/>
						<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
							<c:if test="${optVal.grp_cd == result.grp_cd && optVal.opt_cd == result.opt_cd}">
								<c:set var="optDbVal" value="${optVal.bck_opt_val}"/>
							</c:if>
						</c:forEach>
						<li class="content1"><input type="text" name="opt" grp_cd="<c:out value="${result.grp_cd}"/>" opt_cd="<c:out value="${result.opt_cd}"/>" value="<c:out value="${optDbVal}"/>" maxlength=3 style="width:50px;"/></li>						
					</c:forEach>
				</ul>
				<ul id="log_opt" style="float:left;border:1px solid black;">
					<li class="total"><span>로그파일옵션</span></li> 
					<li class="title"><span>로그파일백업여부</span></li>
					<li class="content"><input type="checkbox" name="log_file_bck_yn" id="log_file_bck_yn" value="Y" <c:if test="${workInfo[0].log_file_bck_yn eq 'Y'}"> checked</c:if>/></li>
					<c:forEach var="result" items="${opt2}" varStatus="status">
						<li class="title1"><span><c:out value="${result.opt_cd_nm}"/></span></li>
						<c:set var="optDbVal" value="${result.dft_cd_val}"/>
						<c:forEach var="optVal" items="${workOptInfo}" varStatus="status">
							<c:if test="${optVal.grp_cd == result.grp_cd && optVal.opt_cd == result.opt_cd}">
								<c:set var="optDbVal" value="${optVal.bck_opt_val}"/>
							</c:if>
						</c:forEach>
						<li class="content1"><input type="text" name="opt" grp_cd="<c:out value="${result.grp_cd}"/>" opt_cd="<c:out value="${result.opt_cd}"/>" value="<c:out value="${optDbVal}"/>" maxlength=3 style="width:50px;"/></li>
					</c:forEach>
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