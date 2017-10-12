<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	/**
	* @Class Name : dbServer.jsp
	* @Description : dbServer 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>

<script>
var table = null;

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#serverList').DataTable({
		scrollY : "300px",
		scrollX: true,	
		processing : true,
		paging : false,
		searching : false,	
		deferRender : true,
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "dft_db_nm", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : ""},
        {data : "useyn", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(full.useyn == 'Y'){
	              data = '사용';      
	           }else{
	        	  data ='미사용';
	           }
	           return data;
	        }},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""}
		]
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '65px');  
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
	    $(window).trigger('resize'); 
}


/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	
  	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "
						+ xhr.status
						+ "\n\n"
						+ "ERROR Message : "
						+ error
						+ "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(
								/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
 
});


function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	var int_button = document.getElementById("int_button"); 
	var mdf_button = document.getElementById("mdf_button"); 
	var del_button = document.getElementById("del_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		mdf_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		mdf_button.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
}

/* ********************************************************
 * 서버리스트 조회 (검색조건 입력)
 ******************************************************** */
function fn_search(){
	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			ipadr : $("#ipadr").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			useyn: $("#useyn").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
 			if(xhr.status == 401) {
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
			} else {
				alert("ERROR CODE : "
						+ xhr.status
						+ "\n\n"
						+ "ERROR Message : "
						+ error
						+ "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(
								/(<([^>]+)>)/gi, ""));
			} 
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}


/* ********************************************************
 * 서버 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	window.open("/popup/dbServerRegForm.do?flag=server","dbServerRegPop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=950,height=470,top=0,left=0");
}


/* ********************************************************
 * 서버 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	var datas = table.rows('.selected').data();
	if (datas.length == 1) {
		var db_svr_id = table.row('.selected').data().db_svr_id;
		window.open("/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=server","dbServerRegRePop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=950,height=495,top=0,left=0");
	} else {
		alert("하나의 항목을 선택해주세요.");
	}	
}
</script>




<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>DBMS 관리 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>- 관리 대상 데이터베이스 서버 정보를 조회합니다.</li>
					<li>- 관리 대상 데이터베이스 서버를 신규로 등록하거나 이미 등록된 서버를 수정 또는 삭제합니다.</li>						
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li>DBMS 정보</li>
					<li class="on">DBMS 관리</li>
				</ul>
			</div>
		</div>


		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
						<span class="btn" onClick="fn_search()" id="read_button"><button>조회</button></span>
						<span class="btn" onclick="fn_reg_popup();" id="int_button"><button>등록</button></span>
						<span class="btn" onclick="fn_regRe_popup();" id="mdf_button"><button>수정</button></span>
						
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>DB Server 조회하기</caption>
						<colgroup>
							<col style="width: 70px;" />
							<col />
							<col style="width: 70px;" />
							<col />
							<col style="width: 80px;" />
							<col />
							<col style="width: 80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t2">서버명</th>
								<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" /></td>
								<th scope="row" class="t3">아이피</th>
								<td><input type="text" class="txt" name="ipadr" id="ipadr" /></td>
								<th scope="row" class="t4">Database</th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
								<th scope="row" class="t9">사용유무</th>
								<td>
									<select class="select t5" id="useyn">
										<option value="%">전체</option>
										<option value="Y">사용</option>
										<option value="N">미사용</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<table id="serverList" class="cell-border display" width="100%">
					<thead>
						<tr>
							<th width="10"></th>
							<th width="20">No</th>
							<th width="130">서버명</th>
							<th width="100">아이피</th>
							<th width="130">database</th>
							<th width="70">포트</th>
							<th width="70">User</th>
							<th width="70">사용유무</th>
							<th width="65">등록자</th>
							<th width="100">등록일시</th>
							<th width="65">수정자</th>
							<th width="100">수정일시</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
</div>
