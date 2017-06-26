<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbTree.jsp
	* @Description : dbTree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.31
	*
	*/
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>" />
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="js/dt/dataTables.colVis.js" type="text/javascript"></script>
<script src="js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
<title>Insert title here</title>
<script>
var table_dbServer = null;
var table_db = null;

function fn_init() {
	
	/* 디비서버 정보 */
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "600px",
		processing : true,
		searching : false,
		columns : [
		{data : "rownum", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "idx", className : "dt-center", defaultContent : "" ,visible: false},
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : "", visible: false},
		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "portno", className : "dt-center", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_regr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false}			
		]
	});

	/* 선택된 서버에 대한 데이터베이스 정보 */
	table_db = $('#dbList').DataTable({
		scrollY : "600px",
		searching : false,
		columns : [
		{data : "dft_db_nm", className : "dt-center", defaultContent : ""}, 
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 		
		]
	});
	
}



$(window.document).ready(function() {
	fn_init();
	
  	$.ajax({
		url : "/selectDbServerList.do",
		data : {},
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			table_dbServer.clear().draw();
			table_dbServer.rows.add(result).draw();
		}
	});
  	
  	

});

$(function() {		
    $('#dbServerList tbody').on( 'click', 'tr', function () {
    	var check = table_dbServer.row( this ).index()+1
    	$(":radio[name=input:radio][value="+check+"]").attr("checked", true);
         if ( $(this).hasClass('selected') ) {
        }
        else {
        	
        	table_dbServer.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
            
        } 
         var db_svr_nm = table_dbServer.row('.selected').data().db_svr_nm;
      
       	$.ajax({
    		url : "/selectServerDBList.do",
    		data : {
    			db_svr_nm: db_svr_nm,			
    		},
    		dataType : "json",
    		type : "post",
    		error : function(xhr, status, error) {
    			alert("실패")
    		},
    		success : function(result) {
    			table_db.clear().draw();
    			table_db.rows.add(result.data).draw();
    			fn_dataCompareChcek(result);
    		}
    	});
        
    } );
    
})

//DB서버 등록 팝업 호출
function fn_reg_popup(){
	window.open("/popup/dbServerRegForm.do","dbServerRegPop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=800,height=270,top=0,left=0");
}


//DB서버 등록 팝업 수정
function fn_regRe_popup(){
	var datas = table_dbServer.rows('.selected').data();
	if (datas.length < 1) {
		var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;
		window.open("/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id,"dbServerRegRePop","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=800,height=270,top=0,left=0");
	} else {
		alert("하나의 항목을 선택해주세요.");
	}	
}


//DB 등록
function fn_insertDB(){
	var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;

	var datas = table_db.rows('.selected').data();
	if (datas.length > 0) {
		var rows = [];
    	for (var i = 0;i<datas.length;i++) {
    		rows.push(table_db.rows('.selected').data()[i]);
		}
    	if (confirm("선택된 DB를 저장하시겠습니까?")){
			$.ajax({
				url : "/insertDB.do",
				data : {
					db_svr_id : db_svr_id,
					rows : JSON.stringify(rows)
				},
				async:true,
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패");
				},
				success : function(result) {
					alert("저장되었습니다.");
				}
			});	
    	}else{
    		return false;
    	}
	}else{
		alert("하나의 항목을 선택해주세요.");
	}
}

// repository DB 검색 비교
function fn_dataCompareChcek(svrDbList){
	$.ajax({
		url : "/selectDBList.do",
		data : {},
		async:true,
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패");
		},
		success : function(result) {
			var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id
			
			if(svrDbList.data.length>0){
 				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
							 $('input', table_db.rows(i).nodes()).prop('checked', false); 	
							 table_db.rows(i).nodes().to$().removeClass('selected');	
					}
				}	 	
				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
						 if(db_svr_id == result[j].db_svr_id && svrDbList.data[i].dft_db_nm == result[j].db_nm){										 
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
						}
					}
				}		
			} 
		}
	});	

}


</script>
</head>
<body>
 DB Tree
<table style="padding: 10px;" width="100%">
 	<tr>	
 		<td width="500">
 			<strong>DB Server 리스트</strong>		
 			<div id="button" style="margin-left: 74%;">
				<input type="button" value="등록" onClick="fn_reg_popup()">
				<input type="button" value="수정" onClick="fn_regRe_popup()">
				<input type="button" value="삭제" id="btnDelete">
			</div>		
			<table id="dbServerList" class="display" cellspacing="0"  align="right">
				<thead>
					<tr>
						<th></th>
						<th></th>
						<th></th>
						<th>DB 서버</th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
					</tr>
				</thead>
			</table>
 		</td>
 		
 		<td width="200">
 		</td>
 		
 		<td width="500">
 			<strong>Database 리스트</strong>
 			<div id="button" style="margin-left: 90%;">
				<input type="button" value="저장" onClick="fn_insertDB()">
			</div>			
			<table id="dbList" class="display" cellspacing="0"  align="left">
				<thead>
					<tr>
						<th>메뉴</th>
						<th>등록선택</th>
					</tr>
				</thead>
			</table>
 		</td>
 	</tr>
 </table> 
</body>
</html>