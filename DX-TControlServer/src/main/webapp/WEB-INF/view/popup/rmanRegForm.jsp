<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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

function fn_insert_work(){
	var cps_yn = "N";
	var log_file_bck_yn = "N";
	
	if( $("#cps_yn").is(":checked")) cps_yn = "Y";
	if( $("#log_file_bck_yn").is(":checked")) log_file_bck_yn = "Y";
	
	if(valCheck()){
		$.ajax({
			async : false,
			url : "/popup/workRmanWrite.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
		  		wrk_exp : $("#wrk_exp").val(),
		  		bck_opt_cd : $("#bck_opt_cd").val(),
		  		bck_mtn_ecnt : $("#bck_mtn_ecnt").val(),
		  		cps_yn : cps_yn,
		  		log_file_bck_yn : log_file_bck_yn,
		  		db_id : 0,
		  		bck_bsn_dscd : "TC000201",
		  		file_stg_dcnt : $("#file_stg_dcnt").val(),
		  		log_file_stg_dcnt : $("#log_file_stg_dcnt").val(),
		  		log_file_mtn_ecnt : $("#log_file_mtn_ecnt").val()
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
			},
			success : function(data) {
				opener.fn_rman_find_list();
				alert("등록이 완료되었습니다.");
				self.close();
			}
		});  
	}
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
</head>
<body>
<form name="workRegForm">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
	<div id="pop_layer">
		<div class="pop-container">
			<div class="pop_cts">
				<p class="tit">Rman 백업 등록하기</p>
				<div class="pop_cmm">
					<table class="write">
						<caption>Rman 백업 등록하기</caption>
						<colgroup>
							<col style="width:85px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Work명</th>
								<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=50/></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">Work<br/>설명</th>
								<td>
									<div class="textarea_grp">
										<textarea name="wrk_exp" id="wrk_exp" maxlength=200></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="pop_cmm mt25">
					<div class="bak_option">
						<div class="option">
							<span class="tit">백업옵션</span>
							<span>
								<select name="bck_opt_cd" id="bck_opt_cd" class="select">
									<option value="TC000301">전체백업</option>
									<option value="TC000302">증분백업</option>
									<option value="TC000303">아카이브백업</option>
								</select>
							</span>
							<span class="chk">
								<div class="inp_chk chk3">
									<input type="checkbox" name="cps_yn" id="cps_yn" value="Y" />
									<label for="cps_yn">압축하기</label>
								</div>
							</span>
						</div>
						<div class="bak_inner">
							<div class="bak_lt">
								<p class="tit">백업파일옵션</p>
								<div class="option_list">
									<ul>
										<li>
											<div class="inner">
												<p>백업파일 보관일</p>
												<span><input type="text" class="txt" name="file_stg_dcnt" id="file_stg_dcnt" value="0" maxlength=3/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>백업파일 유지갯수</p>
												<span><input type="text" class="txt" name="bck_mtn_ecnt" id="bck_mtn_ecnt" value="0" maxlength=3/> 일</span>
											</div>
										</li>
									</ul>
								</div>
							</div>
							<div class="bak_rt">
								<p class="tit">로그파일옵션</p>
								<div class="bak_rt_inr">
									<div class="option_yn">
										<div class="inp_chk chk3">
											<input type="checkbox" name="log_file_bck_yn" id="log_file_bck_yn" value="Y" />
											<label for="log_file_bck_yn">로그파일백업 여부</label>
										</div>
									</div>
									<div class="option_list">
										<ul>
											<li>
												<div class="inner">
													<p>서버로그 파일 보관일수</p>
													<span><input type="text" class="txt" name="log_file_stg_dcnt" id="log_file_stg_dcnt" value="0" maxlength=3/> 일</span>
												</div>
											</li>
											<li>
												<div class="inner">
													<p>서버로그 파일 유지갯수</p>
													<span><input type="text" class="txt" name="log_file_mtn_ecnt" id="log_file_mtn_ecnt" value="0" maxlength=3/> 일</span>
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
					<span class="btn btnC_01" onClick="fn_insert_work();"><button>등록</button></span>
					<span class="btn" onclick="self.close();"><button>취소</button></span>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
</form>	
</body>
</html>