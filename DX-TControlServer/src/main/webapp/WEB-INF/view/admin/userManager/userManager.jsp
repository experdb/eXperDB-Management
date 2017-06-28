<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자 관리</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<!-- 체크박스css -->
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<!-- 체크박스js -->
<script src="js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>
<script>
	var table = null;
	
	function fn_init() {
		table = $('#userListTable').DataTable({
			scrollY : "250px",
			searching : false,
			columns : [
			{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "idx", className : "dt-center", defaultContent : ""}, 
			{ data : "usr_id", className : "dt-center", defaultContent : ""}, 
			{ data : "aut_id", className : "dt-center", defaultContent : ""}, 
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
			} ]
		});

		//더블 클릭시
		$('#userListTable tbody').on('dblclick','tr',function() {
				var data = table.row(this).data();
				var usr_id = data.usr_id;
				document.location.href = "userManagerForm.do?act=u&usr_id="+ usr_id;
			});
		}

	$(function() {
		//조회버튼 클릭시
		$("#btnSelect").click(function() {
			$.ajax({
				url : "/selectUserManager.do",
				data : {
					type : $("#type").val(),
					search : "%" + $("#search").val() + "%",
					use_yn : $("#use_yn").val(),
				},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {
					table.clear().draw();
					table.rows.add(result).draw();
				}
			});
		});

		//수정 버튼 클릭시
		$("#btnUpdate").click(function() {
			var datas = table.rows('.selected').data();
				if (datas.length == 1) {
					var usr_id = table.row('.selected').data().usr_id;
					document.location.href = "userManagerForm.do?act=u&usr_id="+ usr_id;
				} else {
					alert("하나의 항목을 선택해주세요.");
				}
			});

		//삭제 버튼 클릭시
		$("#btnDelete").click(function() {
			var datas = table.rows('.selected').data();
			if (datas.length <= 0) {
				alert("하나의 항목을 선택해주세요.");
				return false;
			} else {
				if (!confirm("삭제하시겠습니까?")) return false;
				var rowList = [];
				for (var i = 0; i < datas.length; i++) {
					rowList += datas[i].usr_id + ',';
				}
					$.ajax({
						url : "/deleteUserManager.do",
						data : {
							usr_id : rowList,
						},
						dataType : "json",
						type : "post",
						error : function(xhr, status, error) {
							alert("실패")
						},
						success : function(result) {
							if (result) {
								alert("삭제되었습니다.");
								$("#btnSelect").click();
							} else {
								alert("처리 실패");
							}
						}
					});
				}
			});
	});

	$(window.document).ready(function() {
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
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		});

	});
</script>
<body>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li class="on">사용자 관리</li>
				</ul>
			</div>

			<div class="contents_wrap">
				<h4>사용자 관리화면</h4>
				<div class="contents">
					<div class="cmm_grp">
						<div class="btn_type_01">
							<span class="btn"><button id="btnSelect">조회</button></span> <span
								class="btn" onclick="toggleLayer($('#pop_layer'), 'on');"><button>등록</button></span>
							<span class="btn" onclick="toggleLayer($('#pop_layer2'), 'on');"><button>수정</button></span>
							<a href="#n" class="btn" id="btnDelete"><span>삭제</span></a>
						</div>
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 90px;" />
									<col style="width: 200px;" />
									<col style="width: 80px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t9">
											<select class="select t5" id="type">
												<option value="usr_nm">사용자명</option>
												<option value="usr_id">아이디</option>
											</select>
										</th>
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
							<table id="userListTable" class="list pd_type3" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th></th>
										<th>No</th>
										<th>아이디</th>
										<th>권한구분</th>
										<th>소속</th>
										<th>사용자명</th>
										<th>연락처</th>
										<th>사용여부</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>





	<!-- 	<h2>사용자 관리</h2>
	<div id="button" style="float: right;">
		<input type="button" value="조회" id="btnSelect"> 
		<a href="userManagerForm.do?act=i"><input type="button" value="등록"></a>
		<input type="button" value="수정" id="btnUpdate">
		<input type="button" value="삭제" id="btnDelete">
	</div>
	<br><br>
	<table style="border: 1px solid black; padding: 10px;" width="100%">
		<tr>
			<td>
				<select id="type">
				<option value="usr_nm">사용자명</option>
				<option value="usr_id">아이디</option>
				</select>
			</td>
			<td>
				<input type="text" id="search">
			</td>
			<td>사용여부</td>
			<td>
				<select id="use_yn">
				<option value="%">전체</option>
				<option value="Y">사용</option>
				<option value="N">미사용</option>
				</select>
			</td>
		</tr>
	</table>
	<br>
	<table id="userListTable" class="display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th></th>
				<th>No</th>
				<th>아이디</th>
				<th>권한구분</th>
				<th>소속</th>
				<th>사용자명</th>
				<th>연락처</th>
				<th>사용여부</th>
			</tr>
		</thead>
	</table> -->
</body>
</html>