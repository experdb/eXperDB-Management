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
var wrk_nmChk ="fail";

$(window.document).ready(function() {

		$("#dataVolume").empty();
		$( "#dataVolume" ).append(0);

		$("#backupVolume").empty();
		$( "#backupVolume" ).append(0);
	
});
/* ********************************************************
 * Rman Backup Insert
 ******************************************************** */
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
		  		log_file_mtn_ecnt : $("#log_file_mtn_ecnt").val(),
		  		data_pth : $("#data_pth").val(),
		  		bck_pth : $("#bck_pth").val(),
		  		acv_file_stgdt : $("#acv_file_stgdt").val(),
		  		acv_file_mtncnt : $("#acv_file_mtncnt").val()
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
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
		alert("등록이 완료되었습니다.");
		self.close();
	}else{
		alert("동일Work명이 존재합니다. 다른 Work명을 입력해주세요.");
		$("#wrk_nm").val("");
		$("#wrk_nm").focus();
	}
}

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#wrk_nm").val() == ""){
		alert("Work명을 입력해 주세요.");
		$("#wrk_nm").focus();
		return false;
	}else if($("#wrk_exp").val() == ""){
		alert("Work설명을 입력해 주세요.");
		$("#wrk_exp").focus();
		return false;
	}else if($("#bck_opt_cd").val() == ""){
		alert("백업옵션을 선택해 주세요.");
		$("#bck_opt_cd").focus();
		return false;
	}else if($("#data_pth").val() == ""){
		alert("데이터경로를 입력해 주세요.");
		$("#data_pth").focus();
		return false;
	}else if($("#bck_pth").val() == ""){
		alert("백업경로를 입력해 주세요.");
		$("#bck_pth").focus();
		return false;
	}else if($("#log_pth").val() == ""){
		alert("로그경로를 입력해 주세요.");
		$("#log_pth").focus();
		return false;
	}else if($("#check_path1").val() != "Y"){
		alert("데이터경로에 서버에 존재하는 경로를 입력후 경로체크를 해 주세요.");
		$("#data_pth").focus();
		return false;
	}else if($("#check_path2").val() != "Y"){
		alert("백업경로에 서버에 존재하는 경로를 입력후 경로체크를 해 주세요.");
		$("#bck_pth").focus();
		return false;
	}else if($("#check_path3").val() != "Y"){
		alert("로그경로에 서버에 존재하는 경로를 입력후 경로체크를 해 주세요.");
		$("#log_pth").focus();
		return false;
	}else if(wrk_nmChk =="fail"){
		alert("WORK명 중복체크 바랍니다.");;
		return false;
	}else{
		return true;
	}

}

/* ********************************************************
 * 저장경로의 존재유무 체크
 ******************************************************** */
function checkFolder(keyType){
	var save_path = "";
	
	if(keyType == 1){
		save_path = $("#data_pth").val();
	}else if(keyType == 1){
		save_path = $("#bck_pth").val();
	}else{
		save_path = $("#log_pth").val();
	}

	if(save_path == "" && keyType == 1){
		alert("데이터경로를 입력해 주세요.");
		$("#data_pth").focus();
	}else if(save_path == "" && keyType == 2){
		alert("백업경로를 입력해 주세요.");
		$("#bck_pth").focus();
	}else if(save_path == "" && keyType == 3){
		alert("로그경로를 입력해 주세요.");
		$("#log_pth").focus();
	}else{
		$.ajax({
			async : false,
			url : "/existDirCheck.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		path : save_path
		  	},
			type : "post",
			error : function(request, xhr, status, error) {
				alert("실패");
			},
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						if(keyType == 1){
							$("#check_path1").val("Y");
						}else if(keyType == 2){
							$("#check_path2").val("Y");
						}else{
							$("#check_path3").val("Y");
						}
						alert("입력하신 경로는 존재합니다.");
							var volume = data.result.RESULT_DATA.CAPACITY;
						if(keyType == 1){
							$("#dataVolume").empty();
							$( "#dataVolume" ).append(volume);
						}else if(keyType == 2) {
							$("#backupVolume").empty();
							$( "#backupVolume" ).append(volume);
						}
					}else{
						alert("입력하신 경로는 존재하지 않습니다.");
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
				alert("등록가능한 WORK명 입니다.");
				document.getElementById("wrk_nm").focus();
				wrk_nmChk = "success";
			} else {
				scd_nmChk = "fail";
				alert("중복된 WORK명이 존재합니다.");
				document.getElementById("wrk_nm").focus();
			}
		},
		error : function(request, status, error) {
			alert("실패");
		}
	});
}
</script>
</head>
<body>
<form name="workRegForm">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
<input type="hidden" name="check_path1" id="check_path1" value="N"/>
<input type="hidden" name="check_path2" id="check_path2" value="N"/>
<input type="hidden" name="check_path3" id="check_path3" value="N"/>
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
								<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=50/>
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_check()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
								</td>
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
							<span class="chk">
								<div class="inp_chk chk3">
									<input type="checkbox" name="cps_yn" id="cps_yn" value="Y" />
									<label for="cps_yn">압축하기</label>
								</div>
							</span>
					<div class="bak_option">
						<div class="option">
							<span class="tit">백업옵션</span>
							<span>
								<select name="bck_opt_cd" id="bck_opt_cd" class="select">
									<option value="TC000301">FULL</option>
									<option value="TC000302">incremental</option>
									<option value="TC000303">archive</option>
								</select>
							</span>
							<span class="tit" style="margin-right: 5px;">로그경로</span>
							<span style="margin-right: 5px;">
								<input type="text" class="txt" name="log_pth" id="log_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path3').val('N')"/>
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(3)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
							</span>			
	
							<table class="write">
								<colgroup>
									<col style="width:90px;" />
									<col />
									<col style="width:90px;" />
									<col />
								</colgroup>
								<tbody>

									<tr>
										<th scope="row" class="ico_t1">데이터경로</th>
										<td><input type="text" class="txt" name="data_pth" id="data_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path1').val('N')"/>
											<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
										</td>
										<th scope="row" class="ico_t1">백업경로</th>
										<td><input type="text" class="txt" name="bck_pth" id="bck_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path2').val('N')"/>
											<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
										</td>
									</tr>
									
									
									<tr>										
										<th> 용량  </th>
										<td><div id="dataVolume"></div></td>
										</div>
										<th> 용량 </th>
										<td><div id="backupVolume"></div></td>
									</tr>
									</div>
								</tbody>
							</table>
						</div>
						<div class="bak_inner">
							<div class="bak_lt">
								<p class="tit">백업파일옵션</p>
								<div class="option_list">
									<ul>
										<li>
											<div class="inner">
												<p>Full 백업파일보관일</p>
												<span><input type="text" class="txt" name="file_stg_dcnt" id="file_stg_dcnt" value="0" maxlength=3/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>Full 백업파일 유지갯수</p>
												<span><input type="text" class="txt" name="bck_mtn_ecnt" id="bck_mtn_ecnt" value="0" maxlength=3/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>아카이브 파일보관일</p>
												<span><input type="text" class="txt" name="acv_file_stgdt" id="acv_file_stgdt" value="0" maxlength=3/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>아카이브 파일유지갯수</p>
												<span><input type="text" class="txt" name="acv_file_mtncnt" id="acv_file_mtncnt" value="0" maxlength=3/> 일</span>
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
					<span class="btn btnC_01" onClick="fn_insert_work();return false;"><button>등록</button></span>
					<span class="btn" onclick="self.close();return false;"><button>취소</button></span>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
</form>	
</body>
</html>