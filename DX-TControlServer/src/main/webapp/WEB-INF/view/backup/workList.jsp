<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : workList.jsp
	* @Description : 백업 목록
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
<script type="text/javascript">
/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(
	function() {
		getRmanDataList();
		getDumpDataList();
});

/* ********************************************************
 * Rman Backup Find Button Click
 ******************************************************** */
function fn_rman_find_list(){
	getRmanDataList($("#wrk_nm").val(), $("#bck_opt_cd").val());
}

/* ********************************************************
 * Dump Backup Find Button Click
 ******************************************************** */
function fn_dump_find_list(){
	getDumpDataList($("#wrk_nm").val(), $("#db_id").val());
}

/* ********************************************************
 * Rman Backup Regist Window Open
 ******************************************************** */
function fn_rman_reg_popup(){
	var popUrl = "/popup/rmanRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 650;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"rmanRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Rman Backup Reregist Window Open
 ******************************************************** */
function fn_rman_reform_popup(wrk_id){
	var popUrl = "/popup/rmanRegReForm.do?db_svr_id=${db_svr_id}&wrk_id="+wrk_id;
	var width = 954;
	var height = 650;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"rmanRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Dump Backup Regist Window Open
 ******************************************************** */
function fn_dump_reg_popup(){
	var popUrl = "/popup/dumpRegForm.do?db_svr_id=${db_svr_id}";
	var width = 954;
	var height = 900;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Dump Backup Reregist Window Open
 ******************************************************** */
function fn_dump_reform_popup(wrk_id){
	var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&wrk_id="+wrk_id;
	var width = 954;
	var height = 900;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Rman Backup Data Fetch List
 ******************************************************** */
function getRmanDataList(wrk_nm, bck_opt_cd){
	$.ajax({
		url : "/backup/getWorkList.do",
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		bck_opt_cd : bck_opt_cd,
	  		wrk_nm : wrk_nm,
	  		bck_bsn_dscd : "TC000201"
	  	},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(data) {
			dataRmanList(data);
		}
	});
}

/* ********************************************************
 * Dump Backup Data Fetch List
 ******************************************************** */
function getDumpDataList(wrk_nm, db_id){
	if(db_id == "") db_id = 0;
	$.ajax({
		url : "/backup/getWorkList.do",
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		db_id : db_id,
	  		wrk_nm : wrk_nm,
	  		bck_bsn_dscd : "TC000202"
	  	},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(data) {
			dataDumpList(data);
		}
	});
}

/* ********************************************************
 * Make Rman Data Table
 ******************************************************** */
function dataRmanList(data){
	var i = 1;
	$("#rmanDataTable > tbody:last > tr").remove();
	$(data).each(function (index, item) {	
		var html = "";
		html += "<tr>";
		html += "<td align='center'><div class='inp_chk'><input type='checkBox' name='rmanWorkId' id='rmanWorkId"+i+"' value='"+item.wrk_id+"' onClick=\"fn_rman_check_close()\"><label for='rmanWorkId"+i+"'></label></div></td>";
		html += "<td align='center'>"+i+"</td>";
		html += "<td align='center'>"+item.bck_bsn_dscd_nm+"</td>";
		html += "<td align='center''><a href='javascript:fn_rman_reform_popup(\""+item.wrk_id+"\")'><b>"+item.wrk_nm+"</b></a></td>";
		html += "<td align='left'>"+item.bck_opt_cd_nm+"</td>";
		html += "<td align='center'>"+item.file_stg_dcnt+"</td>";
		html += "<td align='center'>"+item.frst_regr_id+"</td>";
		html += "<td align='center'>"+item.frst_reg_dtm+"</td>";
		html += "<td align='center'>"+item.lst_mdfr_id+"</td>";
		html += "<td align='center'>"+item.lst_mdf_dtm+"</td>";		
		html += "</tr>";
		$("#rmanDataTable > tbody:last").append(html);
		i++;
	});
	
	if(data.length == 0){
		var html = "";
		$("#rmanDataTable > tbody:last > tr:last").remove();
		html += "<tr><td colspan=10 align='center'>등록된 내역이 없습니다.</td></tr>";
		$("#rmanDataTable > tbody:last").append(html);
	}
}

/* ********************************************************
 * Make Dump Data Table
 ******************************************************** */
function dataDumpList(data){
	var i = 1;
	$("#dumpDataTable > tbody:last > tr").remove();
	$(data).each(function (index, item) {	
		var html = "";
		html += "<tr>";
		html += "<td align='center'><div class='inp_chk'><input type='checkBox' name='dumpWorkId' id='dumpWorkId"+i+"' value='"+item.wrk_id+"' onClick=\"fn_dump_check_close()\"><label for='dumpWorkId"+i+"'></label></div></td>";
		html += "<td align='center'>"+i+"</td>";
		html += "<td align='center'>"+item.bck_bsn_dscd_nm+"</td>";
		html += "<td align='center'><a href='javascript:fn_dump_reform_popup(\""+item.wrk_id+"\")'><b>"+item.wrk_nm+"</a></a></td>";
		html += "<td align='left'>"+item.db_nm+"</td>";
		html += "<td align='center'>"+item.file_fmt_cd_nm+"</td>";
		html += "<td align='center'>"+item.file_stg_dcnt+"</td>";
		html += "<td align='center'>"+item.bck_mtn_ecnt+"</td>";
		html += "<td align='center'>"+item.frst_regr_id+"</td>";
		html += "<td align='center'>"+item.frst_reg_dtm+"</td>";
		html += "<td align='center'>"+item.lst_mdfr_id+"</td>";
		html += "<td align='center'>"+item.lst_mdf_dtm+"</td>";		
		html += "</tr>";
		$("#dumpDataTable > tbody:last").append(html);
		i++;
	});
	
	if(data.length == 0){
		var html = "";
		$("#dumpDataTable > tbody:last > tr:last").remove();
		html += "<tr><td colspan=12 align='center'>등록된 내역이 없습니다.</td></tr>";
		$("#dumpDataTable > tbody:last").append(html);
	}
}

/* ********************************************************
 * Rman Data List Checkbox Check
 ******************************************************** */
function fn_rman_check_close(){
	var checkAll = true;
	$("input:checkbox[name='rmanWorkId']").each(function(){
		if(!$(this).is(":checked")) checkAll = false;
	});
	$("#rmanCheckAll").attr("checked",checkAll);
}

/* ********************************************************
 * Dump Data List Checkbox Check
 ******************************************************** */
function fn_dump_check_close(){
	var checkAll = true;
	$("input:checkbox[name='dumpWorkId']").each(function(){
		if(!$(this).is(":checked")) checkAll = false;
	});
	$("#dumpCheckAll").attr("checked",checkAll);
}

/* ********************************************************
 * Rman Data List Checkbox Check All
 ******************************************************** */
function fn_rman_check_all(){
	if($("#rmanCheckAll").is(":checked")){
		$("input:checkbox[name='rmanWorkId']").each(function(){
			this.checked = true;
		});
	}else{
		$("input:checkbox[name='rmanWorkId']").each(function(){
			this.checked = false;
		});
	}
}

/* ********************************************************
 * Dump Data List Checkbox Check All
 ******************************************************** */
function fn_dump_check_all(){
	if($("#dumpCheckAll").is(":checked")){
		$("input:checkbox[name='dumpWorkId']").each(function(){
			this.checked = true;
		});
	}else{
		$("input:checkbox[name='dumpWorkId']").each(function(){
			this.checked = false;
		});
	}
}

/* ********************************************************
 * Rman Data Delete
 ******************************************************** */
function fn_rman_work_delete(){
	var checkCnt = 0;	
	$("input:checkbox[name='rmanWorkId']").each(function(){
		if(this.checked) checkCnt++;
	});
	
	if(checkCnt < 1){
		alert("삭제할 작업을 선택해 주세요.")
	}else if(confirm("선택하신 작업을 삭제하시겠습니까?")){
		$("input:checkbox[name='rmanWorkId']").each(function(){
			if(this.checked){
				$.ajax({
					url : "/popup/workDelete.do",
				  	data : {
				  		db_svr_id : '<c:out value="${db_svr_id}"/>',
				  		wrk_id : this.value
				  	},
					dataType : "json",
					type : "post",
					error : function(request, status, error) {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
					},
					success : function(data) {
					}
				});
			}
		});
		alert("선택한 작업이 삭제되었습니다.");
		fn_rman_find_list();
	}
}

/* ********************************************************
 * Dump Data Delete
 ******************************************************** */
function fn_dump_work_delete(){
	var checkCnt = 0;	
	$("input:checkbox[name='dumpWorkId']").each(function(){
		if(this.checked) checkCnt++;
	});
	
	if(checkCnt < 1){
		alert("삭제할 작업을 선택해 주세요.")
	}else if(confirm("선택하신 작업을 삭제하시겠습니까?")){
		$("input:checkbox[name='dumpWorkId']").each(function(){
			if(this.checked){
				$.ajax({
					url : "/popup/workDelete.do",
				  	data : {
				  		db_svr_id : '<c:out value="${db_svr_id}"/>',
				  		wrk_id : this.value
				  	},
					dataType : "json",
					type : "post",
					error : function(request, status, error) {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
					},
					success : function(data) {
					}
				});
			}
		});
		alert("선택한 작업이 삭제되었습니다.");
		fn_dump_find_list();
	}
}

/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){
	if(tab == "dump"){
		$("#tab1").hide();
		$("#tab2").show();
		$("#rmanDataTable").hide();
		$("#dumpDataTable").show();
		$("#searchRman").hide();
		$("#searchDump").show();
		$("#btnRman").hide();
		$("#btnDump").show();
	}else{
		$("#tab1").show();
		$("#tab2").hide();
		$("#rmanDataTable").show();
		$("#dumpDataTable").hide();
		$("#searchRman").show();
		$("#searchDump").hide();
		$("#btnRman").show();
		$("#btnDump").hide();
	}
}
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>백업설정<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>데이터베이스 서버에 생성된 백업 작업을 조회하거나 신규로 등록 또는 삭제 합니다.</li>
					<li>작업 조회 목록에서 Work명을 클릭하여 해당 백업 작업을 수정합니다.</li>	
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>백업관리</li>
					<li class="on">백업설정</li>
				</ul>
			</div>
		</div>	
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('rman')">Rman 백업</a></li>
					<li><a href="javascript:selectTab('dump')">Dump 백업</a></li>
				</ul>
				<ul id="tab2" style="display:none;">
					<li><a href="javascript:selectTab('rman')">Rman 백업</a></li>
					<li class="atv"><a href="javascript:selectTab('dump')">Dump 백업</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div class="btn_type_01" id="btnRman">
					<a class="btn" onClick="fn_rman_find_list();"><button>조회</button></a>
					<span class="btn" onclick="fn_rman_reg_popup()"><button>등록</button></span>
					<!-- <span class="btn"><button>수정</button></span>-->
					<span class="btn" onClick="fn_rman_work_delete()"><button>삭제</button></span>
				</div>
				<div class="btn_type_01" id="btnDump" style="display:none;">
					<span class="btn" onclick="fn_dump_find_list()"><button>조회</button></span>
					<span class="btn" onclick="fn_dump_reg_popup()"><button>등록</button></span>
					<!-- <span class="btn"><button>수정</button></span> -->
					<span class="btn" onclick="fn_dump_work_delete()"><button>삭제</button></span>
				</div>
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>				
				<div class="sch_form">
					<table class="write" id="searchRman">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:80px;" />
							<col style="width:230px;" />
							<col style="width:60px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t8">Work명</th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3"/></td>
								<th scope="row" class="t9">Mode</th>
								<td><select name="bck_opt_cd" id="bck_opt_cd" class="txt t3" style="width:150px;">
										<option value="">선택</option>
										<option value="TC000301">FULL</option>
										<option value="TC000302">incremental</option>
										<option value="TC000303">archive</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					<table class="write" id="searchDump" style="display:none;">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:80px;" />
							<col style="width:230px;" />
							<col style="width:100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t8">Work명</th>
								<td><input type="text" class="txt t3" name="wrk_nm" id="wrk_nm"/></td>
								<th scope="row" class="t4">Database</th>
								<td>
									<select name="db_id" id="db_id" class="txt t3" style="width:150px;">
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
				<div class="overflow_area">
					<table class="list pd_type3" id="rmanDataTable">
						<caption>Rman백업관리 화면 리스트</caption>
						<thead>
							<tr>
								<th scope="col" style="width: 70px;">
									<div class="inp_chk">
										<input type="checkBox" name="rmanCheckAll" id="rmanCheckAll" onClick="fn_rman_check_all()">
										<label for="rmanCheckAll"></label>
									</div>
								</th>
								<th scope="col" style="width: 100px;">NO</th>
								<th scope="col">백업설정</th>
								<th scope="col" style="width: 300px;">Work명</th>
								<th scope="col" style="width: 200px;">백업구분</th>
								<th scope="col" style="width: 80px;">파일보관일</th>
								<th scope="col">등록자</th>
								<th scope="col">등록일시</th>
								<th scope="col">수정자</th>
								<th scope="col">수정일시</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
					<table class="list pd_type3" id="dumpDataTable" style="display:none;">
						<caption>Rman백업관리 화면 리스트</caption>
						<thead>
							<tr>
								<th scope="col" style="width: 70px;">
									<div class="inp_chk">
										<input type="checkbox"  name="dumpCheckAll" id="dumpCheckAll" onClick="fn_dump_check_all()" />
										<label for="dumpCheckAll"></label>
									</div>
								</th>
								<th scope="col" style="width: 100px;">NO</th>
								<th scope="col">백업구분</th>
								<th scope="col" style="width: 200px;">Work명</th>
								<th scope="col">Database</th>
								<th scope="col">파일포맷</th>
								<th scope="col">파일보관일</th>
								<th scope="col">백업파일유지수</th>
								<th scope="col">등록자</th>
								<th scope="col">등록일시</th>
								<th scope="col">수정자</th>
								<th scope="col">수정일시</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				</form>				
			</div>
		</div>
	</div>
</div><!-- // contents -->

		</div><!-- // container -->
	</div>
</body>
</html>