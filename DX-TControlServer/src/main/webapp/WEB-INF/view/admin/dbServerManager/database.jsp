<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	/**
	* @Class Name : database.jsp
	* @Description : database 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.23     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.23
	*
	*/
%>

<script>
var table = null;

function fn_init() {
	
		/* ********************************************************
		 * Repository 디비 리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#repoDBList').DataTable({
		scrollY : "300px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : false,
		deferRender : true,
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},		
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
		{data : "db_nm", className : "dt-center", defaultContent : ""},
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "db_id", className : "dt-center", defaultContent : "", visible: false}
		]
	});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(8)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
	    $(window).trigger('resize'); 
}

$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	
	 /* ********************************************************
	  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
	  ******************************************************** */
	  	$.ajax({
			url : "/selectDatabaseSvrList.do",
			data : {},
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
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {				
				$("#db_svr_nm").children().remove();
				$("#db_svr_nm").append("<option value='%'>전체</option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	 
function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	var int_button = document.getElementById("int_button"); 
	var del_button = document.getElementById("del_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		del_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		del_button.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
}	 
	 
 /* ********************************************************
  * Repository 디비 리스트 조회
  ******************************************************** */
  	$.ajax({
		url : "/selectDatabaseRepoDBList.do",
		data : {},
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
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
});


/* ********************************************************
 * Repository 디비 리스트 조회 (검색조건 입력)
 ******************************************************** */
function fn_search(){
  	$.ajax({
		url : "/selectDatabaseRepoDBList.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val().trim(),
			ipadr : $("#ipadr").val().trim(),
			dft_db_nm : $("#dft_db_nm").val().trim()
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
				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
}


/* ********************************************************
 * 디비 등록 팝업 호출
 ******************************************************** */
function fn_reg_popup(){
	window.open("/popup/dbRegForm.do","dbRegPop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=915,height=555,top=0,left=0");
}


</script>


<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>DataBase 관리 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>관리 대상 데이터베이스 정보를 조회합니다.</li>
					<li>관리 대상 데이터베이스를 신규로 등록하거나 삭제합니다.</li>						
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li>DBMS 정보</li>
					<li class="on">DataBase 관리</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onClick="fn_search();" id="read_button"><button>조회</button></span>
					<span class="btn" onclick="fn_reg_popup();" id="int_button"><button>등록</button></span>
					<a href="#n" class="btn" id="del_button"><span>삭제</span></a>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>DataBase 조회</caption>
						<colgroup>
							<col style="width: 90px;" />
							<col />
							<col style="width: 100px;" />
							<col />
							<col style="width: 90px;" />
							<col />
							<col style="width: 70px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t2">DBMS명</th>
								<td><select id="db_svr_nm" name="db_svr_nm">
										<option value="%">전체</option>
								</select></td>
								<th scope="row" class="t3">DBMS 아이피</th>
								<td><input type="text" class="txt" name="ipadr" id="ipadr" /></td>
								<th scope="row" class="t4">Database</th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 메인 테이블 -->
				<table id="repoDBList" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th width="10"></th>
							<th width="20">No</th>
							<th width="130">DBMS명</th>
							<th width="150">DBMS 아이피</th>
							<th width="70">포트</th>
							<th width="130">Database</th>
							<th width="65">등록자</th>
							<th width="100">등록일시</th>
							<th width="65">수정자</th>
							<th width="100">수정일시</th>
							<th width="0"></th>
						</tr>
					</thead>
				</table>
				<!-- /메인 테이블 -->
			</div>
		</div>
	</div>
</div>