<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/sample.css'/>" />
</head>
<script type="text/javascript">
$(window.document).ready(
	function() {
		getDataList(); 
});

function fn_find_list(){
	getDataList($("#wrk_nm").val(), $("#bck_opt_cd").val());
}

function fn_reg_popup(){
	window.open("/popup/dumpRegForm.do?db_svr_id=${db_svr_id}","dumpRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=800,height=800,top=0,left=0");
}

function fn_reg_reform_popup(wrk_id){
	window.open("/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&wrk_id="+wrk_id,"dumpRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=800,height=800,top=0,left=0");
}

function getDataList(wrk_nm, bck_opt_cd){
	$.ajax({
		url : "/backup/workList.do",
	  	data : {
	  		db_svr_id : '<c:out value="${db_svr_id}"/>',
	  		bck_opt_cd : bck_opt_cd,
	  		wrk_nm : wrk_nm,
	  		bck_bsn_dscd : "dump"
	  	},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(data) {
			dataList(data);
		}
	});
}

function dataList(data){
	
	$("#dataTable > tbody:last > tr").remove();
	$(data).each(function (index, item) {	
		var html = "";
		html += "<tr>";
		html += "<td align='center'><input type='checkBox' name='workId' value='"+item.wrk_id+"' onClick=\"fn_check_close()\"></td>";
		html += "<td align='center' class='listtd'>"+item.wrk_id+"</td>";
		html += "<td align='center' class='listtd'>"+item.bck_bsn_dscd+"</td>";
		html += "<td align='center' class='listtd'><a href='javascript:fn_reg_reform_popup(\""+item.wrk_id+"\")'>"+item.wrk_nm+"&nbsp;</a></td>";
		html += "<td align='left' class='listtd'>"+item.db_nm+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.file_fmt_cd+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.file_stg_dcnt+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.bck_mtn_ecnt+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.frst_regr_id+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.frst_reg_dtm+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.lst_mdfr_id+"&nbsp;</td>";
		html += "<td align='center' class='listtd'>"+item.lst_mdf_dtm+"&nbsp;</td>";
		html += "</tr>";
		$("#dataTable > tbody:last").append(html);
	});
	
	if(data.length == 0){
		var html = "";
		
		$("#dataTable > tbody:last > tr:last").remove();
		
		html += "<tr><td colspan=12 align='center'>등록된 내역이 없습니다.</td></tr>";
		$("#dataTable > tbody:last").append(html);
	}
}

function fn_check_close(){
	$("#CheckAll").checked = false;
}

function fn_check_all(){
	if($("#CheckAll").is(":checked")){
		$("input:checkbox[name='workId']").each(function(){
			this.checked = true;
		});
	}else{
		$("input:checkbox[name='workId']").each(function(){
			this.checked = false;
		});
	}
}

function fn_work_delete(){
	var checkCnt = 0;	
	$("input:checkbox[name='workId']").each(function(){
		if(this.checked) checkCnt++;
	});
	
	if(checkCnt < 1){
		alert("삭제할 작업을 선택해 주세요.")
	}else if(confirm("선택하신 작업을 삭제하시겠습니까?")){
		$("input:checkbox[name='workId']").each(function(){
			if(this.checked){
				alert(this.value);
			}
			/**
				$.ajax({
					url : "/popup/workDelete.do",
				  	data : {
				  		db_svr_id : '<c:out value="${db_svr_id}"/>',
				  		wrk_id : this.value
				  	},
					dataType : "json",
					type : "post",
					error : function(xhr, status, error) {
						alert("실패")
					},
					success : function(data) {
						
					}
				});
			**/
		});
	}
}
</script>
<body>
	<div id="content_pop">
		<!-- 타이틀 -->
		<div id="title">
			<ul>
				<li><a href="/backup/rmanList.do?db_svr_id=${db_svr_id}"> RMAN백업</a></li>
				<li><img
					src="<c:url value='/images/egovframework/example/title_dot.gif'/>"
					alt="" /> DUMP백업</li>
			</ul>
		</div>
		<!-- // 타이틀 -->
		<!-- //등록버튼 -->
		<div id="sysbtn">
			<ul>
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_find_list();">조회</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_reg_popup()">등록</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
				<!-- <li><span class="btn_blue_l"> <a
						href="javascript:fn_egov_addView();">수정</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>-->
				<li><span class="btn_blue_l"> <a
						href="javascript:fn_egov_addView();">삭제</a> <img
						src="<c:url value='/images/egovframework/example/btn_bg_r.gif'/>"
						style="margin-left: 6px;" alt="" />
				</span></li>
			</ul>
		</div>
		<!-- // 검색창 -->
		<form name="findList" id="findList" method="post" action="/backup/rmanList.do">
		<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
		<div id="search">
		Work명 : <input type="text" name="wrk_nm" id="wrk_nm"/>
		Database명 : <select name="db_id" id="db_id">
			<option value="">선택</option>
			<c:forEach var="result" items="${dbList}" varStatus="status">
			<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option>
			</c:forEach>
		</select>
		</div>
		<!-- // 검색창 -->


		<!-- // 리스트 -->
		<div id="table">
			<table width="100%" border="1" cellpadding="0" cellspacing="0" id="dataTable">
				<caption style="visibility: hidden">RMAN백업목록</caption>
				<tr>
					<th align="center"><input type="checkBox" name="CheckAll" id="CheckAll" onClick="fn_check_all()"></th>
					<th align="center">No</th>
					<th align="center">백업구분</th>
					<th align="center">work명</th>
					<th align="center">database</th>
					<th align="center">파일포맷</th>
					<th align="center">파일보관일</th>
					<th align="center">백업파일유지수</th>
					<th align="center">등록자</th>
					<th align="center">등록일시</th>
					<th align="center">수정자</th>
					<th align="center">수정일시</th>
				</tr>
				<tbody></tbody>
			</table>
		</div>
		</form>

		<!-- // 리스트 -->
	</div>
</body>
</html>