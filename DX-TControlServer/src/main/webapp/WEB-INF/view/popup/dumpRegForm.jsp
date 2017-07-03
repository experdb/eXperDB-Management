<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
	<form name="workRegForm">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
		<p class="tit">Dump 백업 등록하기</p>
		<div class="pop_cmm">
			<table class="write">
				<caption>Dump 백업 등록하기</caption>
				<colgroup>
					<col style="width:95px;" />
					<col />
					<col style="width:95px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Work명</th>
						<td><input type="text" class="txt" name="wrk_nm" id="wrk_nm" maxlength=50/></td>
						<th scope="row" class="ico_t1">Database</th>
						<td>
							<select name="db_id" id="db_id" class="select">
								<c:forEach var="result" items="${dbList}" varStatus="status">
								<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Work<br/>설명</th>
						<td colspan="3">
							<div class="textarea_grp">
								<textarea name="wrk_exp" id="wrk_exp" maxlength=200></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<caption>백업 등록하기</caption>
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
						<th scope="row" class="ico_t2">저장경로</th>
						<td colspan="5"><input type="text" class="txt t4" name="save_pth" id="save_pth"/></td>
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
								<c:forEach var="result" items="${incodeList}" varStatus="status">
									<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${result.sys_cd == 'TC000507'}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th scope="row" class="ico_t2">Rolename</th>
						<td>
							<select name="usr_role_nm" id="usr_role_nm" class="select t4">
								<option value="">선택</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t2">압축률</th>
						<td>
							<select name="cprt" id="cprt" class="select t4">
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
						<td><input type="text" class="txt t6" name="file_stg_dcnt" id="file_stg_dcnt" maxlength=3/> 일</td>
						<th scope="row" class="ico_t2">백업유지갯수</th>
						<td><input type="text" class="txt t6" name="bck_mtn_ecnt" id="bck_mtn_ecnt" maxlength=3/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm c2 mt25">
			<div class="addOption_grp">
				<ul class="tab">
					<li class="on"><a href="#n">부가옵션 #1</a></li>
					<li><a href="#n">부가옵션 #2</a></li>
					<li><a href="#n">object 선택</a></li>
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
								<p class="op_tit">Object 형태</p>
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
						<div class="tNav">
							<ul>
								<li class="active"><a href="#">Test1 Database</a>
									<div class="inp_chk">
										<input type="checkbox" id="tree_1_1" name="tree" checked="checked"  />
										<label for="tree_1_1"></label>
									</div>
									<ul>
										<li class="active"><a href="#">Test1 Schema</a>
											<div class="inp_chk">
												<input type="checkbox" id="tree_2_1" name="tree" checked="checked"  />
												<label for="tree_2_1"></label>
											</div>
											<ul>
												<li><a href="#">Test_table1</a>
													<div class="inp_chk">
														<input type="checkbox" id="tree_3_1" name="tree" checked="checked"  />
														<label for="tree_3_1"></label>
													</div>
													<ul>
														<li><a href="#">Test_table1-1</a>
															<div class="inp_chk">
																<input type="checkbox" id="tree_4_1" name="tree" checked="checked"  />
																<label for="tree_4_1"></label>
															</div>
														</li>
														<li><a href="#">Test_table1-2</a>
															<div class="inp_chk">
																<input type="checkbox" id="tree_4_2" name="tree" checked="checked"  />
																<label for="tree_4_2"></label>
															</div>
														</li>
													</ul>
												</li>
												<li><a href="#">Test_table2</a>
													<div class="inp_chk">
														<input type="checkbox" id="tree_3_2" name="tree" checked="checked"  />
														<label for="tree_3_2"></label>
													</div>
													<ul>
														<li><a href="#">Test_table2-1</a>
															<div class="inp_chk">
																<input type="checkbox" id="tree_4_3" name="tree" checked="checked"  />
																<label for="tree_4_3"></label>
															</div>
														</li>
														<li><a href="#">Test_table2-2</a>
															<div class="inp_chk">
																<input type="checkbox" id="tree_4_4" name="tree" checked="checked"  />
																<label for="tree_4_4"></label>
															</div>
														</li>
													</ul>
												</li>
											</ul>
										</li>
										<li><a href="#">Test2 Schema</a>
											<div class="inp_chk">
												<input type="checkbox" id="tree_2_2" name="tree" checked="checked"  />
												<label for="tree_2_2"></label>
											</div>
										</li>
									</ul>
								</li>
								<li><a href="#">TEST2 Database</a>
									<div class="inp_chk">
										<input type="checkbox" id="tree_1_2" name="tree" checked="checked"  />
										<label for="tree_1_2"></label>
									</div>
									<ul>
										<li><a href="#">Test3 Schema</a></li>
										<li><a href="#">Test4 Schema</a></li>
									</ul>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01" onClick="fn_insert_work();"><button>등록</button></span>
			<a href="#n" class="btn" onclick="self.close();"><span>취소</span></a>
		</div>
	</div>
	</form>
</div>
</body>
</html>
