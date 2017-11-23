<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : userManager.jsp
	* @Description : UserManager 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>
<script>
var table = null;

function fn_init() {
	table = $('#userListTable').DataTable({
		scrollY : "245px",
		searching : false,
		deferRender : true,
		scrollX: true,
		columns : [
		{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{ data : "idx", className : "dt-center", defaultContent : ""}, 
		{ data : "usr_id", className : "dt-center", defaultContent : ""}, 
		{ data : "bln_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "usr_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "cpn", className : "dt-center", defaultContent : ""}, 
		{
			data : "use_yn",
			render : function(data, type, full, meta) {
				var html = "";
				if (data == "Y") {
					html += "사용";
				} else {
					html += "미사용";
				}
				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},
		{ data : "usr_expr_dt", className : "dt-center", defaultContent : ""}
		]
	});

	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    $(window).trigger('resize'); 
    
	//더블 클릭시
	if("${wrt_aut_yn}" == "Y"){
		$('#userListTable tbody').on('dblclick','tr',function() {
			var data = table.row(this).data();
			var usr_id = data.usr_id;				
			var popUrl = "/popup/userManagerRegForm.do?act=u&usr_id=" + usr_id; // 서버 url 팝업경로
			var width = 920;
			var height = 480;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			window.open(popUrl,"",popOption);
		});	
	}
}
$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	$.ajax({
		url : "/selectUserManager.do",
		data : {
			type : $("#type").val(),
			search : "%" + $("#search").val() + "%",
			use_yn : $("#use_yn").val(),
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

});

function fn_buttonAut(){
	var btnSelect = document.getElementById("btnSelect"); 
	var btnInsert = document.getElementById("btnInsert"); 
	var btnUpdate = document.getElementById("btnUpdate"); 
	var btnDelete = document.getElementById("btnDelete"); 
	
	if("${wrt_aut_yn}" == "Y"){
		btnInsert.style.display = '';
		btnUpdate.style.display = '';
		btnDelete.style.display = '';
	}else{
		btnInsert.style.display = 'none';
		btnUpdate.style.display = 'none';
		btnDelete.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		btnSelect.style.display = '';
	}else{
		btnSelect.style.display = 'none';
	}
}	

/*조회버튼 클릭시*/
function fn_select(){
	$.ajax({
		url : "/selectUserManager.do",
		data : {
			type : $("#type").val(),
			search : "%" + $("#search").val() + "%",
			use_yn : $("#use_yn").val(),
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


/* 등록버튼 클릭시*/
function fn_insert() {
	var popUrl = "/popup/userManagerRegForm.do?act=i"; // 서버 url 팝업경로
	var width = 920;
	var height = 480;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	window.open(popUrl,"",popOption);
}

/* 수정버튼 클릭시*/
function fn_update() {
	var rowCnt = table.rows('.selected').data().length;
	if (rowCnt == 1) {
		var usr_id = table.row('.selected').data().usr_id;
		var popUrl = "/popup/userManagerRegForm.do?act=u&usr_id=" + usr_id; // 서버 url 팝업경로
		var width = 920;
		var height = 480;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";			
		window.open(popUrl,"",popOption);
	} else {
		alert("하나의 항목을 선택해주세요.");
		return false;
	}
}

/*삭제 버튼 클릭시*/
function fn_delete(){
	var usr_id = "<%=(String)session.getAttribute("usr_id")%>"
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		alert("하나의 항목을 선택해주세요.");
		return false;
	} else {
		if (!confirm("삭제하시겠습니까?"))return false;
		var rowList = [];
		for (var i = 0; i < datas.length; i++) {
			if(datas[i].usr_id=="admin"){
				alert("관리자는 삭제할 수 없습니다.");
				return false;
			}else if(datas[i].usr_id==usr_id){
				alert("본인은 삭제할 수 없습니다.");
				return false;
			}else{
				rowList += datas[i].usr_id + ',';	
			}				
		}
		$.ajax({
			url : "/deleteUserManager.do",
			data : {
				usr_id : rowList,
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
				if (result) {
					alert("삭제되었습니다.");
					fn_select();
				}else{
					alert("유저삭제를 실패하였습니다.");
				}
			}
		});
	}
}	
</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>사용자 관리<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>eXperDB 통합 관리 시스템에 접근 가능한 사용자를 관리합니다.</li>
					<li>신규로 등록하거나 등록된 사용자를 조회, 수정, 삭제할 수 있습니다.</li>	
					<li>신규로 사용자를 등록하는 경우 해당 사용자가 접근할 수 있는 메뉴 설정을 병행할 수 있습니다.</li>					
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li class="on">사용자 관리</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()" id="btnSelect">조회</button></span>
					<span class="btn"><button onclick="fn_insert()" id="btnInsert">등록</button></span>
					<span class="btn"><button onclick="fn_update()" id="btnUpdate">수정</button></span>
					<a href="#n" class="btn" id="btnDelete" onclick="fn_delete()"><span>삭제</span></a>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 120px;" />
							<col style="width: 180px;" />
							<col style="width: 200px;" />
							<col style="width: 80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">검색조건</th>
								<td>
									<select class="select t5" id="type">
										<option value="usr_nm">사용자명</option>
										<option value="usr_id">아이디</option>
									</select>
								</td>
								<td><input type="text" class="txt t2" id="search" /></td>
								<th scope="row" class="t9">사용여부</th>
								<td>
									<select class="select t5" id="use_yn">
										<option value="%">전체</option>
										<option value="Y">사용</option>
										<option value="N">미사용</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="userListTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="10"></th>
								<th width="20">No</th>
								<th width="120">아이디</th>
								<th width="100">소속</th>
								<th width="100">사용자명</th>
								<th width="100">연락처</th>
								<th width="80">사용여부</th>
								<th width="100">사용자만료일</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>