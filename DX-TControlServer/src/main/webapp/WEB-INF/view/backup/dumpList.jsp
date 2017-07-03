<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
$(window.document).ready(
	function() {
		getDataList(); 
});

function fn_find_list(){
	getDataList($("#wrk_nm").val(), $("#bck_opt_cd").val());
}

function fn_reg_popup(){
	var popUrl = "/popup/dumpRegForm.do?db_svr_id=${db_svr_id}"; // 서버 url 팝업경로
	var width = 954;
	var height = 810;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=auto, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
}

function fn_reg_reform_popup(wrk_id){
	var popUrl = "/popup/dumpRegReForm.do?db_svr_id=${db_svr_id}&wrk_id="+wrk_id; // 서버 url 팝업경로
	var width = 954;
	var height = 810;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=auto, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"dumpRegPop",popOption);
	winPop.focus();
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
	
	var i = 1;
	$("#dataTable > tbody:last > tr").remove();
	$(data).each(function (index, item) {	
		var html = "";
		html += "<tr>";
		html += "<td align='center'><div class='inp_chk'><input type='checkBox' name='workId' id='workId"+i+"' value='"+item.wrk_id+"' onClick=\"fn_check_close()\"><label for='workId"+i+"'></label></div></td>";
		html += "<td align='center'>"+item.wrk_id+"</td>";
		html += "<td align='center'>"+item.bck_bsn_dscd+"</td>";
		html += "<td align='center'><a href='javascript:fn_reg_reform_popup(\""+item.wrk_id+"\")'>"+item.wrk_nm+"&nbsp;</a></td>";
		html += "<td align='left'>"+item.db_nm+"</td>";
		html += "<td align='center'>"+item.file_fmt_cd+"</td>";
		html += "<td align='center'>"+item.file_stg_dcnt+"</td>";
		html += "<td align='center'>"+item.bck_mtn_ecnt+"</td>";
		html += "<td align='center'>"+item.frst_regr_id+"</td>";
		html += "<td align='center'><div class='date_area'><span>"+item.frst_reg_dtm+"</span><span>"+item.lst_mdfr_id+"</span><span>"+item.lst_mdf_dtm+"<span></td>";
		html += "</tr>";
		$("#dataTable > tbody:last").append(html);
		
		i++;
	});
	
	if(data.length == 0){
		var html = "";
		
		$("#dataTable > tbody:last > tr:last").remove();
		
		html += "<tr><td colspan=10 align='center'>등록된 내역이 없습니다.</td></tr>";
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
			//if(this.checked){
			//	alert(this.value);
			//}
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
		});
		alert("선택한 작업이 삭제되었습니다.");
		document.location.reload();		
	}
}
</script>
<!-- contents -->
<div id="contents">
	<div class="location">
		<ul>
			<li>${db_svr_nm}</li>
			<li>백업관리</li>
			<li class="on">백업 설정</li>
		</ul>
	</div>

	<div class="contents_wrap">
		<h4>백업 설정 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
		<div class="contents">
			<div class="cmm_tab">
				<ul>
					<li><a href="/backup/rmanList.do?db_svr_id=${db_svr_id}">Rman 백업</a></li>
					<li class="atv"><a href="/backup/dumpList.do?db_svr_id=${db_svr_id}">Dump 백업</a></li>
				</ul>
			</div>
		<form name="findList" id="findList" method="post" action="/backup/dumpList.do">
		<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_find_list()"><button>조회</button></span>
					<span class="btn" onclick="fn_reg_popup()"><button>등록</button></span>
					<!-- <span class="btn"><button>수정</button></span> -->
					<span class="btn" onclick="fn_work_delete()"><button>삭제</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
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
								<td><input type="text" class="txt t3" name="wrk_nm" id="wrk_nm"/></td>
								<th scope="row" class="t4">DB명</th>
								<td>
									<select name="db_id" id="db_id" class="txt t3" style="width:100px;">
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
					<table class="list pd_type3" id="dataTable">
						<caption>Rman백업관리 화면 리스트</caption>
						<colgroup>
							<col style="width:5%;" />
							<col style="width:5%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">
									<div class="inp_chk">
										<input type="checkbox"  name="CheckAll" id="CheckAll" onClick="fn_check_all()" />
										<label for="CheckAll"></label>
									</div>
								</th>
								<th scope="col">NO</th>
								<th scope="col">백업구분</th>
								<th scope="col">Work명</th>
								<th scope="col">database</th>
								<th scope="col">파일포맷</th>
								<th scope="col">파일보관일</th>
								<th scope="col">백업파일유지수</th>
								<th scope="col">등록자</th>
								<th scope="col">등록일시/수정자/수정일시</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
			</form>
		</div>
	</div>
</div><!-- // contents -->


		</div><!-- // container -->
	</div>
</body>
</html>