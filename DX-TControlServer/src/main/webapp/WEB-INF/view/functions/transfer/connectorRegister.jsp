<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : connectorRegister.jsp
	* @Description : connectorRegister 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.07
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Connector등록</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
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
		table = $('#connectorTable').DataTable({
			scrollY : "300px",
			processing : true,
			searching : false,
			columns : [ 
						{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
			            { data : "idx", className : "dt-center", defaultContent : ""}, 
			            { data : "cnr_nm", className : "dt-center", defaultContent : ""}, 
			            { data : "cnr_ipadr", className : "dt-center", defaultContent : ""},
			            { data : "cnr_portno", className : "dt-center", defaultContent : ""}, 
			            { data : "cnr_cnn_tp_cd", className : "dt-center", defaultContent : ""}, 
			            { data : "frst_regr_id", className : "dt-center", defaultContent : ""}, 
			            { data : "frst_reg_dtm", className : "dt-center", defaultContent : ""}, 
			            { data : "lst_mdfr_id", className : "dt-center", defaultContent : ""}, 
			            { data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
			         	//cnr_id
						{ data: "cnr_id" , visible: false}
			         ]
		});
		
		/* 더블 클릭시*/
		$('#connectorTable tbody').on('dblclick', 'tr', function () {
			var data = table.row( this ).data();
		    var cnr_id = data.cnr_id;
 			window.open("/popup/connectorRegForm.do?act=u&cnr_id="+cnr_id,"connectorRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=500,height=300,top=0,left=0");
		}); 
	}

	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectConnectorRegister.do",
		  	data : {},
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
	
	/* 조회버튼 클릭시*/
	function fn_select() {
		$.ajax({
			url : "/selectConnectorRegister.do",
		  	data : {
		  		cnr_nm : "%" + $("#cnr_nm").val() + "%",
		  		cnr_ipadr : "%" + $("#cnr_ipadr").val() + "%",
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
	}
	
	/* 등록버튼 클릭시*/
	function fn_insert() {
		window.open("/popup/connectorRegForm.do?act=i","connectorRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=500,height=300,top=0,left=0");
	}
	
	/* 수정버튼 클릭시*/
	function fn_update() {
		var rowCnt= table.rows('.selected').data().length;
 		if(rowCnt == 1){
 			var cnr_id = table.row('.selected').data().cnr_id;
 			window.open("/popup/connectorRegForm.do?act=u&cnr_id="+cnr_id,"connectorRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=500,height=300,top=0,left=0");
 		}else{
			alert("하나의 항목을 선택해주세요.");
			return false;
		} 	
	}
	
	/* 삭제버튼 클릭시*/
	function fn_delete() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert("하나의 항목을 선택해주세요.");
			return false;
		} else {
			if (!confirm("삭제하시겠습니까?")) return false;		
			var rowList = [];
			for (var i = 0; i < datas.length; i++) {
				rowList += datas[i].cnr_id + ',';
			}
			
			$.ajax({
				url : "/deleteConnectorRegister.do",
				data : {
					cnr_id : rowList,
				},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {
					if (result) {
						alert("삭제되었습니다.");
						fn_select();
					} else {
						alert("처리 실패");
					}
				}
			});		
			
		}
	}	
</script>
<body>
	<h2>connector 등록</h2>
	<div id="button" style="float: right;">
		<button type="button" onclick="fn_select()">조회</button>
		<button type="button" onclick="fn_insert()">등록</button>
		<button type="button" onclick="fn_update()">수정</button>
		<button type="button" onclick="fn_delete()">삭제</button>
	</div>
	<br><br>
	<table style="border: 1px solid black; padding: 10px;" width="100%">
		<tr>
			<td>Connector명</td>
			<td>
				<input type="text" id="cnr_nm">
			</td>
			<td>아이피</td>
			<td>
				<input type="text" id="cnr_ipadr">
			</td>
		</tr>
	</table>
	<br>
	<table id="connectorTable" class="display" cellspacing="0" width="100%">
		<thead>
			<tr>
				<th></th>
				<th>NO</th>
				<th>서버명</th>
				<th>아이피</th>
				<th>포트</th>
				<th>유형</th>
				<th>등록자</th>
				<th>등록일시</th>
				<th>수정자</th>
				<th>수정일시</th>
			</tr>
		</thead>
	</table>
</body>
</html>