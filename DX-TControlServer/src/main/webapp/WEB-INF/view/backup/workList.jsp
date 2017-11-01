<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	/**
	* @Class Name : workList.jsp
	* @Description : 백업 목록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*  2017.10.23 	 변승우			테이블 -> 데이터테이블 변환
    *	
	* author YoonJH
	* since 2017.06.07
	*
	*/
%>


<script type="text/javascript">
var tableRman = null;
var tableDump = null;
function fn_init(){
	
	/* ********************************************************
	 * RMAN 백업설정 리스트
	 ******************************************************** */
	tableRman = $('#rmanDataTable').DataTable({
	scrollY : "245px",
	scrollX : true,
	paging : false,
	searching : false,	
	deferRender : true,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-center", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_nm+'"); style=cursor:pointer>' + full.wrk_nm + '</span>';
			}
		}, //work명
		{data : "wrk_exp", className : "dt-center", defaultContent : ""},	
		{data : "bck_opt_cd_nm", className : "dt-center", defaultContent : ""
			,"render": function (data, type, full) {
				if(full.bck_opt_cd=="TC000301"){
					var html = '전체백업';
						return html;
				}else if(full.bck_opt_cd=="TC000302"){
					var html = '증분백업';
					return html;
				}else{
					var html = '변경로그백업';
					return html;
				}
				return data;
			}
		},
		{data : "data_pth", className : "dt-center", defaultContent : ""},	
		{data : "bck_pth", className : "dt-center", defaultContent : ""},	
		{data : "log_file_pth", className : "dt-center", defaultContent : ""},	
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "bck_wrk_id", className : "dt-center", defaultContent : "", visible: false }
	]
	});
	
	
	/* ********************************************************
	 * DUMP 백업설정 리스트
	 ******************************************************** */
	tableDump = $('#dumpDataTable').DataTable({
		scrollY : "245px",
		scrollX : true,
		paging : false,
		searching : false,	
		deferRender : true,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-center", defaultContent : ""
			,"render": function (data, type, full) {				
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_nm+'"); style=cursor:pointer>' + full.wrk_nm + '</span>';
			}
		},
		{data : "wrk_exp", className : "dt-center", defaultContent : ""},
		{data : "db_nm", className : "dt-center", defaultContent : ""}, 
		{data : "save_pth", className : "dt-center", defaultContent : ""},
		{data : "file_fmt_cd_nm", className : "dt-center", defaultContent : ""}, 
		{data : "cprt", className : "dt-center", defaultContent : ""}, 
		{data : "encd_mth_nm", className : "dt-center", defaultContent : ""}, 
		{data : "usr_role_name", className : "dt-center", defaultContent : ""}, 
		{data : "file_stg_dcnt", className : "dt-center", defaultContent : ""}, 	
		{data : "bck_mtn_ecnt", className : "dt-center", defaultContent : ""}, 		
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "bck_wrk_id", className : "dt-center", defaultContent : "" , visible: false }
	]
	});
	
	tableRman.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	tableRman.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableRman.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	tableRman.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableRman.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(5)').css('min-width', '230px');
	tableRman.tables().header().to$().find('th:eq(6)').css('min-width', '230px');
	tableRman.tables().header().to$().find('th:eq(7)').css('min-width', '230px');
	tableRman.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(9)').css('min-width', '100px');  
	tableRman.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	tableRman.tables().header().to$().find('th:eq(12)').css('min-width', '0px');


	tableDump.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    tableDump.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	tableDump.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	tableDump.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	tableDump.tables().header().to$().find('th:eq(5)').css('min-width', '250px');
	tableDump.tables().header().to$().find('th:eq(6)').css('min-width', '60px');
	tableDump.tables().header().to$().find('th:eq(7)').css('min-width', '60px');
	tableDump.tables().header().to$().find('th:eq(8)').css('min-width', '100px');  
	tableDump.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(10)').css('min-width', '90px');  
	tableDump.tables().header().to$().find('th:eq(11)').css('min-width', '90px');
	tableDump.tables().header().to$().find('th:eq(12)').css('min-width', '70px');
	tableDump.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(14)').css('min-width', '70px');  
	tableDump.tables().header().to$().find('th:eq(15)').css('min-width', '100px');
	tableDump.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
	$(window).trigger('resize'); 
}


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(
	function() {	
		fn_init();		
		getRmanDataList();
		getDumpDataList();			
		$("#rmanDataTable").show();
		$("#rmanDataTable_wrapper").show();
		$("#dumpDataTable").hide();
		$("#dumpDataTable_wrapper").hide();		
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
	var height = 600;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"rmanRegPop",popOption);
	winPop.focus();
}

/* ********************************************************
 * Rman Backup Reregist Window Open
 ******************************************************** */
function fn_rman_regreg_popup(){
	
		var datas = tableRman.rows('.selected').data();
		var bck_wrk_id = tableRman.row('.selected').data().bck_wrk_id;
		if (datas.length <= 0) {
			alert("선택된 항목이 없습니다.");
			return false;
		}else if(datas.length > 1){
			alert("하나의 항목을 선택해주세요.");
			return false;
		}else{
			var popUrl = "/popup/rmanRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
			var width = 954;
			var height = 650;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
			var winPop = window.open(popUrl,"rmanRegPop",popOption);
			winPop.focus();	
		}
		
}

/* ********************************************************
 * Rman Backup Reregist Window Open
 ******************************************************** */
function fn_rman_reform_popup(bck_wrk_id){
	var popUrl = "/popup/rmanRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
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
function fn_dump_regreg_popup(){
	var datas = tableDump.rows('.selected').data();
	var bck_wrk_id = tableDump.row('.selected').data().bck_wrk_id;
	if (datas.length <= 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	}else if(datas.length > 1){
		alert("하나의 항목을 선택해주세요.");
		return false;
	}else{
		var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
		var width = 954;
		var height = 900;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
		var winPop = window.open(popUrl,"dumpRegPop",popOption);
		winPop.focus();			
	}
}

/* ********************************************************
 * Dump Backup Reregist Window Open
 ******************************************************** */
function fn_dump_reform_popup(bck_wrk_id){
	var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&bck_wrk_id="+bck_wrk_id;
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
			tableRman.clear().draw();
			tableRman.rows.add(data).draw();
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
			tableDump.clear().draw();
			tableDump.rows.add(data).draw();
		}
	});
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
		$("#dumpDataTable").show();
		$("#dumpDataTable_wrapper").show();
		$("#rmanDataTable").hide();
		$("#rmanDataTable_wrapper").hide();
		$("#tab1").hide();
		$("#tab2").show();
		$("#searchRman").hide();
		$("#searchDump").show();
		$("#btnRman").hide();
		$("#btnDump").show();
	}else{
		$("#rmanDataTable").show();
		$("#rmanDataTable_wrapper").show();
		$("#dumpDataTable").hide();
		$("#dumpDataTable_wrapper").hide();
		$("#tab1").show();
		$("#tab2").hide();
		$("#searchRman").show();
		$("#searchDump").hide();
		$("#btnRman").show();
		$("#btnDump").hide();
	}
}
</script>

<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>

	
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
					<span class="btn" onClick="fn_rman_regreg_popup()"><button>수정</button></span>
					<span class="btn" onClick="fn_rman_work_delete()"><button>삭제</button></span>
				</div>
				<div class="btn_type_01" id="btnDump" style="display:none;">
					<span class="btn" onclick="fn_dump_find_list()"><button>조회</button></span>
					<span class="btn" onclick="fn_dump_reg_popup()"><button>등록</button></span>
					<span class="btn" onclick="fn_dump_regreg_popup()"><button>수정</button></span>
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
							<col style="width:90px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t8">Work명</th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t3"/></td>
								<th scope="row" class="t9" >백업옵션</th>
								<td><select name="bck_opt_cd" id="bck_opt_cd" class="txt t3" style="width:150px;">
										<option value="">선택</option>
										<option value="TC000301">전체백업</option>
										<option value="TC000302">증분백업</option>
										<option value="TC000303">변경로그백업</option>
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
					<table id="rmanDataTable" class="cell-border" >
						<caption>Rman백업관리 화면 리스트</caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30">No</th>
									<th width="200">Work명</th>
									<th width="200">Work설명</th>
									<th width="100">백업옵션</th>
									<th width="230">데이터경로</th>
									<th width="230">백업경로</th>
									<th width="230">로그경로</th>
									<th width="100">등록자</th>
									<th width="100">등록일시</th>
									<th width="100">수정자</th>
									<th width="100">수정일시</th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>	
				

	
					<table id="dumpDataTable" class="cell-border" >
						<caption>Dump백업관리 화면 리스트</caption>
							<thead>
								<tr>
									<th width="10"></th>
									<th width="30">No</th>
									<th width="200">Work명</th>
									<th width="200">Work설명</th>
									<th width="130">Database</th>
									<th width="250">저장경로</th>
									<th width="60">파일포맷</th>
									<th width="60">압축률</th>
									<th width="100">인코딩방식</th>
									<th width="100">Rolename</th>
									<th width="90">파일보관일</th>
									<th width="90">백업파일유지수</th>
									<th width="70">등록자</th>
									<th width="100">등록일시</th>
									<th width="70">수정자</th>
									<th width="100">수정일시</th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
				</form>				
			</div>
		</div>
	</div>
</div><!-- // contents -->

		</div><!-- // container -->
	</div>
