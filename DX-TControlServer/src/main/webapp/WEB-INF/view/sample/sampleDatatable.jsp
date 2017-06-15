<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : sampleDatatable.jsp
	* @Description : Sample Datatable 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.22     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.22
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>데이터테이블 샘플</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>"/>
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript">
var table = null;

function fn_init(){
   	table = $('#example').DataTable({	
		scrollY: "300px",	
		"processing": true,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
 		         	{ 	data: "category_id", 
 		         		render : function (data, type, full, meta){
	 		         		var html = "<a href='/sampleDatatableForm.do?registerFlag=update&&category_id="+data+"'>"+data+"</a>";
			            	return html;
 		         		},
 		         		className: "dt-center", 
 		         		defaultContent: ""
 		         	}, 
 		         	{ data: "category_nm", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "use_yn", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "contents", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "reg_nm", className: "dt-center", defaultContent: ""}
 		        ] 
	});
}

$(window.document).ready(
		function() {
			fn_init();
			
			$.ajax({
				url : "/selectSampleDatatableList.do",
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
			
			$("#insert").click(function() {
				  document.location.href ="sampleDatatableForm.do?registerFlag=create";
				});
			
		});

</script>
</head>
<body>
<h3>Datatable Sample</h3>
    <button id="insert">등록</button>
	<table id="example" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>No</th>
                <th>카테고리ID</th>
                <th>카테고리명</th>
                <th>사용여부</th>
                <th>내용</th>
                <th>등록자</th>
            </tr>
        </thead>
    </table>

</body>
</html>