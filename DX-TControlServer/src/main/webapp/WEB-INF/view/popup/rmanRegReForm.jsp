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
		  		wrk_id : $("#wrk_id").val(),
		  		wrk_nm : $("#wrk_nm").val(),
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
		  		acv_file_mtncnt : $("#acv_file_mtncnt").val()
		  	},
			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
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
		alert("수정이 완료되었습니다.");
		self.close();
	}else{
		alert("동일Work명이 존재합니다. 다른 Work명을 입력해주세요.");
		$("#wrk_nm").val();
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
	}else if($("#check_path1").val() != "Y"){
		alert("데이터경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
		$("#data_pth").focus();
		return false;
	}else if($("#check_path2").val() != "Y"){
		alert("백업경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
		$("#bck_pth").focus();
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
	}else{
		save_path = $("#bck_pth").val();
	}

	if(save_path == "" && keyType == 1){
		alert("데이터경로를 입력해 주세요.");
		$("#data_pth").focus();
	}else if(save_path == ""){
		alert("백업경로를 입력해 주세요.");
		$("#bck_pth").focus();
	}else{
		$.ajax({
			async : false,
			url : "/existDirCheck.do",
		  	data : {
		  		db_svr_id : $("#db_svr_id").val(),
		  		path : save_path
		  	},
			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						if(keyType == 1){
							$("#check_path1").val("Y");
						}else{
							$("#check_path2").val("Y");
						}
						alert("유효한 경로입니다.");
							var volume = data.result.RESULT_DATA.CAPACITY;
						if(keyType == 1){
							$("#dataVolume").empty();
							$( "#dataVolume" ).append(volume);
						}else{
							$("#backupVolume").empty();
							$( "#backupVolume" ).append(volume);
						}
					}else{
						alert("유효하지 않는 경로입니다.");
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
<form name="workRegForm">
<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
<input type="hidden" name="wrk_id" id="wrk_id" value="${wrk_id}"/>
<input type="hidden" name="check_path1" id="check_path1" value="Y"/>
<input type="hidden" name="check_path2" id="check_path2" value="Y"/>
	<div id="pop_layer">
		<div class="pop-container">
			<div class="pop_cts">
				<p class="tit">Rman 백업 수정</p>
				<div class="pop_cmm">
					<table class="write">
						<caption>Rman 백업 수정</caption>
						<colgroup>
							<col style="width:85px;" />
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
					<div class="bak_option">
						<div class="option">
							<span class="tit">백업옵션</span>
							<span>
								<select name="bck_opt_cd" id="bck_opt_cd" class="select">
									<option value="">선택</option>
									<option value="TC000301"<c:if test="${workInfo[0].bck_opt_cd == 'TC000301'}"> selected</c:if>>FULL</option>
									<option value="TC000302"<c:if test="${workInfo[0].bck_opt_cd == 'TC000302'}"> selected</c:if>>incremental</option>
									<option value="TC000303"<c:if test="${workInfo[0].bck_opt_cd == 'TC000303'}"> selected</c:if>>archive</option>
								</select>
							</span>
							<span class="chk">
								<div class="inp_chk chk3">
									<input type="checkbox" name="cps_yn" id="cps_yn" value="Y" <c:if test="${workInfo[0].cps_yn eq 'Y'}"> checked</c:if>/>
									<label for="cps_yn">압축하기</label>
								</div>
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
										<td><input type="text" class="txt" name="data_pth" id="data_pth" maxlength=200  value="<c:out value="${workInfo[0].data_pth}"/>" style="width:230px" onKeydown="$('#check_path1').val('N')"/>
											<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
										</td>
										<th scope="row" class="ico_t1">백업경로</th>
										<td><input type="text" class="txt" name="bck_pth" id="bck_pth" maxlength=200  value="<c:out value="${workInfo[0].bck_pth}"/>" style="width:230px" onKeydown="$('#check_path2').val('N')"/>
											<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
										</td>
									</tr>
									
									<tr>										
										<th> 용량 : </th>
										<td><div id="dataVolume"></div></td>
										</div>
										<th> 용량 :</th>
										<td><div id="backupVolume"></div></td>
									</tr>
									
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
												<p>Full 백업파일 보관일</p>
												<span><input type="number" class="txt" name="file_stg_dcnt" id="file_stg_dcnt" value="<c:out value="${workInfo[0].file_stg_dcnt}"/>" maxlength="3" min="0"/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>Full 백업파일 유지갯수</p>
												<span><input type="number" class="txt" name="bck_mtn_ecnt" id="bck_mtn_ecnt" value="<c:out value="${workInfo[0].bck_mtn_ecnt}"/>" maxlength="3" min="0"/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>아카이브 파일보관일</p>
												<span><input type="number" class="txt" name="acv_file_stgdt" id="acv_file_stgdt" value="<c:out value="${workInfo[0].acv_file_stgdt}"/>" maxlength="3" min="0"/> 일</span>
											</div>
										</li>
										<li>
											<div class="inner">
												<p>아카이브 파일유지갯수</p>
												<span><input type="number" class="txt" name="acv_file_mtncnt" id="acv_file_mtncnt" value="<c:out value="${workInfo[0].acv_file_mtncnt}"/>" maxlength="3" min="0"/> 일</span>
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
											<input type="checkbox" name="log_file_bck_yn" id="log_file_bck_yn" value="Y" <c:if test="${workInfo[0].log_file_bck_yn eq 'Y'}"> checked</c:if>/>
											<label for="log_file_bck_yn">로그파일백업 여부</label>
										</div>
									</div>
									<div class="option_list">
										<ul>
											<li>
												<div class="inner">
													<p>서버로그 파일 보관일수</p>
													<span><input type="number" class="txt" name="log_file_stg_dcnt" id="log_file_stg_dcnt" value="<c:out value="${workInfo[0].log_file_stg_dcnt}"/>" maxlength="3" min="0"/> 일</span>
												</div>
											</li>
											<li>
												<div class="inner">
													<p>서버로그 파일 유지갯수</p>
													<span><input type="number" class="txt" name="log_file_mtn_ecnt" id="log_file_mtn_ecnt" value="<c:out value="${workInfo[0].log_file_mtn_ecnt}"/>" maxlength="3" min="0"/> 일</span>
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
					<span class="btn btnC_01" onClick="fn_update_work();return false;"><button>수정</button></span>
					<span class="btn" onclick="self.close();return false;"><button>취소</button></span>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
</form>	
</body>
</html>