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
<link rel="stylesheet" type="text/css" href="../../css/common.css">
<script type="text/javascript" src="../../js/common.js"></script>
<link rel="stylesheet" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>" />
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>" />
<script src="/js/jquery/jquery-1.12.4.js" type="text/javascript"></script>
<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>
<title>Insert title here</title>
<script type="text/javascript">
var table_db = null;

function fn_init(){
	/* 선택된 서버에 대한 데이터베이스 정보 */
     table_db = $('#dbList').DataTable({
		scrollY : "300px",
		searching : false,
		paging :false,
		columns : [
		{data : "dft_db_nm", className : "dt-center", defaultContent : ""}, 
		{data : "db_exp", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="text" class="txt" name="db_exp" value="' +full.db_exp + '" style="width: 350px; height: 25px;">';      
	           }
	           return data;
	        }}, 
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
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {		
				$("#db_svr_id").children().remove();
				$("#db_svr_nm").children().remove();
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_id+"'>"+result[i].db_svr_nm+"</option>");					
					}									
				}									
				document.serverList.ipadr.value = result[0].ipadr;
				document.serverList.portno.value = result[0].portno;
				fn_svr_db(result[0].db_svr_nm, result[0].db_svr_id);
			}
		}); 
	
});


/* ********************************************************
 * 서버에 등록된 디비 리스트 조회
 ******************************************************** */
function fn_svr_db(db_svr_nm, db_svr_id){
   	$.ajax({
		url : "/selectServerDBList.do",
		data : {
			db_svr_nm: db_svr_nm,			
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
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table_db.clear().draw();
			if(result.data == null){
				alert("서버상태를 확인해주세요.");
			}else{
				table_db.rows.add(result.data).draw();
				fn_dataCompareChcek(result,db_svr_id);
			}
		}
	});	
}


/* ********************************************************
 * 서버에 등록된 디비,  <=>  Repository에 등록된 디비 비교
 ******************************************************** */
function fn_dataCompareChcek(svrDbList,db_svr_id){
	$.ajax({
		url : "/selectDBList.do",
		data : {
			db_svr_id:db_svr_id
		},
		async:true,
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
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			//DB목록 그리드의 설명 부분을 리스트로 가지고옴
			var list = $("input[name='db_exp']");
			
			//서버디비 갯수
			for(var i = 0; i<svrDbList.data.length; i++){
				//repo디비 갯수
				for(var j = 0; j<result.length; j++){				
					list[j].value = result[j].db_exp;
					if(result[j].useyn == "Y"){
						 if(db_svr_id == result[j].db_svr_id && svrDbList.data[i].dft_db_nm == result[j].db_nm){		
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
						}
					}
				}
			}	 
/* 			if(svrDbList.data.length>0){
 				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
							 $('input', table_db.rows(i).nodes()).prop('checked', false); 	
							 table_db.rows(i).nodes().to$().removeClass('selected');	
					}
				}	 	
				for(var i = 0; i<svrDbList.data.length; i++){
					var list = $("input[name='db_exp']");
					for(var j = 0; j<result.length; j++){	
						list[j].value = result[j].db_exp;
						if(result[j].useyn == "Y"){
						 if(db_svr_id == result[j].db_svr_id && svrDbList.data[i].dft_db_nm == result[j].db_nm){										 
							 $('input', table_db.rows(i).nodes()).prop('checked', true); 
							 table_db.rows(i).nodes().to$().addClass('selected');	
							}
						}
					}
				}		
			}  */
		}
	});	
}
 
 
 /* ********************************************************
  * SelectBox  변경시 해당 디비서버 및 디비 등록상태 조회
  ******************************************************** */
 function fn_dbserverChange(){
		/* 
		 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
		 */
		  	$.ajax({
				url : "/selectSvrList.do",
				data : {
					db_svr_id : $("#db_svr_nm").val()		
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
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {		
					document.serverList.ipadr.value = result[0].ipadr;
					document.serverList.portno.value = result[0].portno;
					fn_svr_db(result[0].db_svr_nm, result[0].db_svr_id);
				}
			}); 	 
 }
 
 
 /* ********************************************************
  * 디비 등록
  ******************************************************** */
 function fn_insertDB(){
	var list = $("input[name='db_exp']");
	var datasArr = new Array();
 	var db_svr_id =  $("#db_svr_nm").val();	
 	var ipadr = $("#ipadr").val();	
 	var datas = table_db.rows().data();
 	
 	var checkCnt = table_db.rows('.selected').data().length;
 	if (datas.length > 0) {
 		var rows = [];
     	for (var i = 0;i<datas.length;i++) {
     		var rows = new Object();     		
     		var org_dbName = table_db.rows().data()[i].dft_db_nm;
			var returnValue = false;
     		
     		for(var j=0; j<checkCnt; j++) {    			           	 	
     			var chkDBName = table_db.rows('.selected').data()[j].dft_db_nm;
     			if(org_dbName  == chkDBName) {
     				returnValue = true;
     				break;
     			}
     		}
     		if(returnValue == true){
     	 		rows.db_exp = list[i].value;
     			rows.useyn = "Y";
     			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
     		}else{
     			rows.db_exp = list[i].value;
     			rows.useyn = "N";
     			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
     		}   		 
    		datasArr.push(rows);
 		}
     	if (confirm("선택된 DB를 저장하시겠습니까?")){
 			$.ajax({
 				url : "/insertDB.do",
 				data : {
 					db_svr_id : db_svr_id,
 					ipadr : ipadr,
 					rows : JSON.stringify(datasArr)
 				},
 				async:true,
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
 						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
 					}
 				},
 				success : function(result) {
 					alert("저장되었습니다.");
 					opener.location.reload();
 					self.close();	 
 				}
 			});	
     	}else{
     		return false;
     	}
 	}else{
 		alert("하나의 항목을 선택해주세요.");
 	}
 }
 
</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Datebase 등록</p>
		<div class="pop_cmm mt25" >
			<div class="pop_lt">			
				<form name="serverList" id="serverList">
				<table class="write">
					<caption>Datebase 등록</caption>
					<colgroup>
					<col style="width:110px;" />
					<col style="width:250px;" />
					<col style="width:75px;" />
					<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1 type2">DBMS명</th>
							<td>
								<select class="select"  id="db_svr_nm" name="db_svr_nm" style="width: 200px;" onChange="fn_dbserverChange();">
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1">DBMS 아이피</th>
							<td><input type="text" class="txt bg1" name="ipadr" id="ipadr"  style="width: 200px;" readonly/></td>
					
							<th scope="row" class="ico_t1">포트</th>
							<td><input type="text" class="txt bg1" name="portno" id="portno"  style="width: 200px;" readonly/></td>
						</tr>
					</tbody>
				</table>
				</form>
			</div>
			<div class="pop_rt">
					<table id="dbList" class="cell-border display" cellspacing="0"  align="left">
						<thead>
							<tr>
								<th>Database</th>
								<th>설명</th>
								<th>등록선택</th>
							</tr>
						</thead>
					</table>
			</div>
		</div>
		
		<div class="btn_type_02">
			<span class="btn"><button onClick="fn_insertDB();">저장</button></span>
			<a href="#n" class="btn" onClick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>