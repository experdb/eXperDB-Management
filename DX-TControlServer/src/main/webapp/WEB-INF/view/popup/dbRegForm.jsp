<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbRegForm.jsp
	* @Description : 디비 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.23     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.12
	*
	*/
%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<title>Insert title here</title>
<script type="text/javascript">
var table_db = null;

function fn_init(){
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

	/* 
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 */
	  	$.ajax({
			url : "/selectSvrList.do",
			data : {},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {		
				$("#db_svr_nm").children().remove();
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	
});


</script>
</head>
<body>

	<!-- 조회 조건 -->
	  <table style="border: 1px solid black; padding: 10px;" width="100%">
	  <tr>
	  	<td>
	 		◎서버명 <select id="db_svr_nm" name="db_svr_nm" style="width:200px;"></select>
	 	</td>
	 	<td>
	 		◎아이피 <input type="text" name="ipadr" id="ipadr">
	 	</td>
	 	<td>
	 		◎DB명 <input type="text" name="dft_db_nm" id="dft_db_nm">
	 	</td>
	 </tr>
	 </table>
	 <!-- /조회 조건 -->
	 
	 
	<table id="dbList" class="display" cellspacing="0"  align="left">
		<thead>
			<tr>
				<th>메뉴</th>
				<th>등록선택</th>
			</tr>
		</thead>
	</table>
</body>
</html>