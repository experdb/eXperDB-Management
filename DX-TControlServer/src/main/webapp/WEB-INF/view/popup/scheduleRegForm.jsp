<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>


<script>
var table = null;

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#workList').DataTable({
		scrollY : "271px",
		
		processing : true,
		searching : false,
		paging : false,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false },
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "db_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "bsn_dscd", className : "dt-center", defaultContent : "", visible: false},
		{data : "bsn_dscd_nm", className : "dt-center", defaultContent : ""},
		{data : "bck_bsn_dscd", className : "dt-center", defaultContent : "", visible: false},
		{data : "bck_bsn_dscd_nm", className : "dt-center", defaultContent : ""},
		{data : "wrk_nm", className : "dt-center", defaultContent : ""},
		{data : "wrk_exp", className : "dt-center", defaultContent : ""},	
		{data : "bck_opt_cd", className : "dt-center", defaultContent : "", visible: false},
		{data : "bck_opt_cd_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "bck_mtn_ecnt", className : "dt-center", defaultContent : "", visible: false},
		{data : "log_file_bck_yn", className : "dt-center", defaultContent : "", visible: false},
		{data : "log_file_stg_dcnt", className : "dt-center", defaultContent : "", visible: false},
		{data : "log_file_mtn_ecnt", className : "dt-center", defaultContent : "", visible: false},
		{data : "cprt", className : "dt-center", defaultContent : "", visible: false},
		{data : "save_pth", className : "dt-center", defaultContent : "", visible: false},
		{data : "file_fmt_cd", className : "dt-center", defaultContent : "", visible: false},
		{data : "file_stg_dcnt", className : "dt-center", defaultContent : "", visible: false},
		{data : "encd_mth_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "usr_role_nm", className : "dt-center", defaultContent : "", visible: false},	
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false}
		]
	});
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	
	 /* ********************************************************
	  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
	  ******************************************************** */
	  	$.ajax({
			url : "/selectSvrList.do",
			data : {},
			dataType : "json",
			type : "post",
			error : function(request, status, error) {
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {		
				$("#db_svr_nm").children().remove();
				$("#db_svr_nm").append("<option value='%'>선택</option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	 
	 
		 /* ********************************************************
		  * 페이지 시작시, work 구분
		  ******************************************************** */
		  	$.ajax({
				url : "/selectWorkDivList.do",
				data : {},
				dataType : "json",
				type : "post",
				error : function(request, status, error) {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				},
				success : function(result) {		
					$("#work").children().remove();
					$("#work").append("<option value='%'>전체</option>");
					if(result.length > 0){
						for(var i=0; i<result.length; i++){
							$("#work").append("<option value='"+result[i].bsn_dscd+"'>"+result[i].bsn_dscd_nm+"</option>");	
						}									
					}
				}
			}); 
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search(){
	var db_svr_nm = $("#db_svr_nm").val();
	
	if(db_svr_nm == '%'){
		alert("서버명을 선택하셔야 합니다.");
		return false;
	}

	$.ajax({
		url : "/selectWorkList.do",
		data : {
			bsn_dscd : $("#work").val(),
			db_svr_nm : $("#db_svr_nm").val(),
			wrk_nm : $("#wrk_nm").val()
		},
		dataType : "json",
		type : "post",
		error : function(request, status, error) {
			alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}


/* ********************************************************
 * work 등록
 ******************************************************** */
function fn_workAdd(){
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].wrk_id);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
	opener.fn_workAddCallback(JSON.stringify(rowList));
	self.close();
}
</script>

</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Work등록</p>
			<div class="btn_type_01">
				<span class="btn"><button onClick="fn_search();">조회</button></span>
			</div>
		<div class="pop_cmm">							
			<table class="write bdtype1">
				<caption>스케줄 등록</caption>				
				<colgroup>
					<col style="width:30px;" />
					<col style="width:50px;" />
					<col style="width:30px;" />
					<col style="width:50px;" />
					<col style="width:30px;" />
					<col style="width:100px;" />			
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">DBMS명</th>
						<td>
						<select class="select t8" name="db_svr_nm" id="db_svr_nm" style="width: 170px;">
								<option value="%">선택</option>
						</select>	
						<th scope="row" class="ico_t1">구분</th>
						<td>
						<select class="select t8" name="work" id="work">
								<option value="%">전체</option>
						</select>						
						</td>									
						<th scope="row" class="ico_t1" style="magin-left:50px;" >Work명</th>
						<td><input type="text" class="txt t4" name="wrk_nm" id="wrk_nm" /></td>				
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pop_cmm3">
			<p class="pop_s_tit">Work 리스트</p>
			<div class="overflow_area">
				<table id="workList" class="cell-border display" >
				<thead>
					<tr>
						<th></th>
						<th>No</th>
						<th></th>
						<th></th>
						<th>DBMS명</th>
						<th></th>
						<th></th>
						<th></th>
						<th>구분</th>
						<th></th>
						<th>백업구분</th>
						<th>Work명</th>
						<th>Work설명</th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th>등록자</th>
						<th>등록일시</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
			</table>		
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onClick="fn_workAdd();">추가</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

	<div id="loading">
			<img src="/images/spin.gif" alt="" />
	</div>
</body>
</html>