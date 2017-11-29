<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbServerRegForm.jsp
	* @Description : 디비 서버 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.01     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
<style>
#serverIpadr_wrapper{
	width:750px;
}
</style>
<script type="text/javascript">



//연결테스트 확인여부
var table = null;
var connCheck = "fail";
var idCheck = "fail";
var db_svr_nmChk ="fail";

/* var pghomeCheck="fail";
var pgdataCheck ="fail"; */


function fn_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	table = $('#serverIpadr').DataTable({
		scrollY : "100px",
		bSort: false,
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
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
		{data : "ipadr", className : "dt-center", defaultContent : ""},
		{data : "portno", className : "dt-center", defaultContent : ""},
		{data : "master_gbn", className : "dt-center", defaultContent : ""},
		{data : "connYn", className : "dt-center", defaultContent : ""},	
		{data : "svr_host_nm", className : "dt-center", defaultContent : "", visible: false}
		]
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '177px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '117px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
    $(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
});

$(function() {		
	
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#serverIpadr tbody').on( 'click', 'tr', function () {
    	var check = table.row( this ).index()+1
    	$(":radio[name=input:radio][value="+check+"]").prop("checked", true);
         if ( $(this).hasClass('selected') ) {
        }
        else {    	
        	table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');       
        } 
    });
});

//숫자체크
function valid_numeric(objValue)
{
	if (objValue.match(/^[0-9]+$/) == null)
	{	return false;	}
	else
	{	return true;	}
}


function fn_dbServerValidation(){
	var db_svr_nm = document.getElementById("db_svr_nm");
		if (db_svr_nm.value == "") {
			   alert("서버명을 입력하여 주십시오.");
			   db_svr_nm.focus();
			   return false;
		}
		var dft_db_nm = document.getElementById("dft_db_nm");
 		if (dft_db_nm.value == "") {
  			   alert("데이터베이스명을 입력하여 주십시오.");
  			 dft_db_nm.focus();
  			   return false;
  		}
 		var portno = document.getElementById("portno");
		if (portno.value == "") {
			   alert("포트를 입력하여 주십시오.");
			   portno.focus();
			   return false;
		}
 		if(!valid_numeric(portno.value))
	 	{
 			alert("포트는 숫자만 입력가능합니다.");
 			portno.focus();
		 	return false;
		}

		var svr_spr_usr_id = document.getElementById("svr_spr_usr_id");
 		if (svr_spr_usr_id.value == "") {
  			   alert("유저명을 입력하여 주십시오.");
  			 svr_spr_usr_id.focus();
  			   return false;
  		}
 		var svr_spr_scm_pwd = document.getElementById("svr_spr_scm_pwd");
 		if (svr_spr_scm_pwd.value == "") {
  			   alert("비밀번호를 입력하여 주십시오.");
  			 svr_spr_scm_pwd.focus();
  			   return false;
  		}		
 		if(connCheck != "success"){
			alert("연결테스트를 하셔야합니다.");
			return false;
		}
 		return true;
}

function fn_ipadrValidation(){
	var ipadr = document.getElementById("ipadr");
	var portno = document.getElementById("portno");
		if (ipadr.value == "%") {
			   alert("아이피를 선택하여 주십시오.");
			   ipadr.focus();
			   return false;
		}else if(portno.value == ""){
			alert("포트를 입력하여 주십시오.");
			portno.focus();
			   return false;
		}
 		return true;
}


function fn_saveValidation(){
	var mCnt = 0;
	var dataCnt = table.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(table.rows().data()[i].master_gbn == "M"){
			mCnt += 1;
		}
	}
	if(mCnt == 0){
		alert("마스터가 존재하지 않습니다.");
		return false;
	}else if(mCnt > 1){
		alert("2개 이상의 마스터가 존재합니다.");
		return false;
	}
	return true;
}

// DBserver 등록
function fn_insertDbServer(){

	if (!fn_dbServerValidation()) return false;
	if (!fn_saveValidation()) return false;
	var datas = table.rows().data();
	
	var arrmaps = [];
	for (var i = 0; i < datas.length; i++){
		var tmpmap = new Object();
		tmpmap["ipadr"] = table.rows().data()[i].ipadr;
        tmpmap["portno"] = table.rows().data()[i].portno;      
        tmpmap["master_gbn"] = table.rows().data()[i].master_gbn;
        tmpmap["svr_host_nm"] = table.rows().data()[i].svr_host_nm;
		arrmaps.push(tmpmap);	
		}
	
	if (confirm("DBMS를 등록 하시겠습니까?")){	
  	$.ajax({
		url : "/insertDbServer.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			pghome_pth : $("#pghome_pth").val(),
			pgdata_pth : $("#pgdata_pth").val(),
			ipadrArr : JSON.stringify(arrmaps)
			
		},
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
			alert("등록하였습니다.");
			opener.location.reload();
			self.close();	 			
		}
	}); 
	}else{
		return false;
	}
} 


//DBserver 연결테스트
function fn_dbServerConnTest(){
	
	//if (!fn_dbServerValidation()) return false;
	var datasArr = new Array();
	var ipadrCnt = table.column(0).data().length;
	var ipadr = table.rows().data()[0].ipadr;
	
	
	for(var i = 0; i < ipadrCnt; i++){
		 var datas = new Object();
		 datas.SERVER_NAME = $("#db_svr_nm").val();
	     datas.SERVER_IP = table.rows().data()[i].ipadr;
	     datas.SERVER_PORT = table.rows().data()[i].portno;		  
	     datas.DATABASE_NAME = $("#dft_db_nm").val();	
	     datas.USER_ID = $("#svr_spr_usr_id").val();	
	     datas.USER_PWD = $("#svr_spr_scm_pwd").val();	

	     datasArr.push(datas);
	 }

	
	$.ajax({
		url : "/dbServerConnTest.do",
		data : {
			ipadr : ipadr,
			datasArr : JSON.stringify(datasArr)
		},
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
			if(result.result_code == 0){
				 for(var i=0; i<result.result_data.length; i++){
					if(table.rows().data()[i].ipadr == result.result_data[i].SERVER_IP){
						table.cell(i, 3).data(result.result_data[i].MASTER_GBN).draw();
						table.cell(i, 4).data(result.result_data[i].CONNECT_YN).draw();					
						table.cell(i, 5).data(result.result_data[i].CMD_HOSTNAME).draw();	
					}
					if(result.result_data[i].MASTER_GBN == "N" || result.result_data[i].CONNECT_YN == "N"){
							connCheck = "fail"
							alert("[ 연결 테스트 실패! ]");
							return false;
					}else{
						connCheck = "success";
						alert("[ 연결 테스트 성공! ]");
						fn_pathCall(ipadr, datasArr);
					}
				} 				
			}else{
			connCheck = "fail"
			alert("[ 연결 테스트 실패! ]");
			return false;
			}		
		}
	}); 

}

function fn_pathCall(ipadr, datasArr){
	$.ajax({
		url : "/pathCall.do",
		data : {
			ipadr : ipadr,
			datasArr : JSON.stringify(datasArr)
		},
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
			document.getElementById("pghome_pth").value=result.CMD_DBMS_PATH;
			document.getElementById("pgdata_pth").value=result.DATA_PATH;
		}
	}); 
}


//DBserver 취소
function fn_dbServerCancle(){
	document.dbserverInsert.reset();
}



function fn_ipadrChange() {
	var ipadr = document.getElementById("ipadr");

	$.ajax({
		url : '/dbServerIpCheck.do',
		type : 'post',
		data : {
			ipadr : $("#ipadr").val()
		},
		success : function(result) {
			if (result == "true") {
				idCheck = "success";
				if(document.getElementById("db_svr_nm").value==""){
					fn_getHostNm($("#ipadr").val());
				}
			} else {
				document.getElementById("db_svr_nm").value = "";
				alert("중복된 IP가 존재합니다.");
				return false;
			}			
		},
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
		}
	});
}
	
	
//호스트명 가져오기
function fn_getHostNm(ipadr) {
	$.ajax({
		url : '/getHostNm.do',
		type : 'post',
		data : {
			ipadr : ipadr
		},
		success : function(result) {
			document.getElementById("db_svr_nm").value = result.host;
		},
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
		}
	});
}
	
//서버명 중복체크
function fn_svrnmCheck() {
	var db_svr_nm = document.getElementById("db_svr_nm");
	if (db_svr_nm.value == "") {
		alert("서버명을 입력하세요.");
		document.getElementById('db_svr_nm').focus();
		return;
	}
	$.ajax({
		url : '/db_svr_nmCheck.do',
		type : 'post',
		data : {
			db_svr_nm : $("#db_svr_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert("등록가능한 서버명 입니다.");
				document.getElementById("db_svr_nm").focus();
				db_svr_nmChk = "success";
			} else {
				alert("중복된 서버명이 존재합니다.");
				document.getElementById("db_svr_nm").focus();
			}
		},
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
		}
	});
}

	
/* ********************************************************
 * PG_HOME 경로의 존재유무 체크
 ******************************************************** */
function checkPghome(){
	var ipadr = null;
	var portno = null;
	
	var dataCnt = table.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(table.rows().data()[i].master_gbn == "M"){
			ipadr = table.rows().data()[i].ipadr;
			portno = table.rows().data()[i].portno;
		}
	}
	if(ipadr == null){
		alert("마스터가 존재하지 않습니다.");
		return false;
	}
	
	var save_pth = $("#pghome_pth").val();
	if(save_pth == ""){
		alert("저장경로를 입력해 주세요.");
		$("#pghome_pth").focus();
	}else{
		$.ajax({
			async : false,
			url : "/isDirCheck.do",
		  	data : {
				db_svr_nm : $("#db_svr_nm").val(),
				dft_db_nm : $("#dft_db_nm").val(),
				ipadr : ipadr,
				portno : portno,
				svr_spr_usr_id : $("#svr_spr_usr_id").val(),
				svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
		  		path : save_pth,
		  		flag : "r"
		  	},
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
			success : function(data) {				
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY== 0){
						$("#check_path").val("Y");
						pghomeCheck = "success";
						alert("입력하신 경로는 존재합니다.");
					}else{
						alert("입력하신 경로는 존재하지 않습니다.");
					}
				}else{
					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
				}
			}
		});
	}
}	


/* ********************************************************
 * PG_DATA 경로의 존재유무 체크
 ******************************************************** */
 function checkPgdata(){
	 var ipadr = null;
	var portno = null;
		
		var dataCnt = table.column(0).data().length;
		
		for(var i=0; i<dataCnt; i++){
			if(table.rows().data()[i].master_gbn == "M"){
				ipadr = table.rows().data()[i].ipadr;
				portno = table.rows().data()[i].portno;
			}
		}
		if(ipadr == null){
			alert("마스터가 존재하지 않습니다.");
			return false;
		}
		
		var save_pth = $("#pgdata_pth").val();
		if(save_pth == ""){
			alert("저장경로를 입력해 주세요.");
			$("#pgdata_pth").focus();
		}else{
			$.ajax({
				async : false,
				url : "/isDirCheck.do",
			  	data : {
					db_svr_nm : $("#db_svr_nm").val(),
					dft_db_nm : $("#dft_db_nm").val(),
					ipadr : ipadr,
					portno : portno,
					svr_spr_usr_id : $("#svr_spr_usr_id").val(),
					svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			  		path : save_pth,
			  		flag : "r"
			  	},
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
				success : function(data) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							$("#check_path").val("Y");
							pgdataCheck = "success";
							alert("입력하신 경로는 존재합니다.");
						}else{
							alert("입력하신 경로는 존재하지 않습니다.");
						}
					}else{
						alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
					}
				}
			});
		}
	}	
function fn_ipadrAddForm(){
	
  	$.ajax({
		url : "/selectIpList.do",
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
			$("#ipadr").children().remove();
			$("#ipadr").append("<option value='%'>선택</option>");
			if(result.length > 0){
				for(var i=0; i<result.length; i++){
					$("#ipadr").append("<option value='"+result[i].ipadr+"'>"+result[i].ipadr+"</option>");	
				}									
			}
		}
	});
  	
	document.ipadr_form.reset();
	toggleLayer($('#pop_layer'), 'on');
}	
	
	
function fn_ipadrAdd(){
	if (!fn_ipadrValidation()) return false;
	
	var dataCnt = table.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(table.rows().data()[i].ipadr == $("#ipadr").val()){
			alert("이미 등록된 아이피가 존재 합니다.");
			return false;
		}
	}
	
	table.row.add( {
        "ipadr":		$("#ipadr").val(),
        "portno":	$("#portno").val()
    } ).draw();	
	toggleLayer($('#pop_layer'), 'off');
}


function fn_ipadrDelForm(){
	 table.row('.selected').remove().draw();
}
</script>
</head>
<body>
	<!--  popup -->
	<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width:530px;">
				<p class="tit">DBMS IP등록하기</p>
					<form name="ipadr_form">
						<table class="write">
							<caption>DBMS IP등록하기</caption>
							<colgroup>
								<col style="width:130px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1">DBMS 아이피(*)</th>
									<td>
										<select class="select"  id="ipadr" name="ipadr" onChange="fn_ipadrChange();" >
											<option value="%">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1">Port(*)</th>
									<td><input type="text" class="txt" name="portno" id="portno" maxlength="5"/></td>
								</tr>
							</tbody>
						</table>
					</form>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="fn_ipadrAdd();"><span><button>추가</button></span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>


<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">DBMS 등록</p>
		<form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DBMS 등록</caption>
			<colgroup>
				<col style="width:120px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1" >DBMS아이피(*)</th>
					<td colspan="3">
						<!-- 메인 테이블 -->
						<span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span>
						<span onclick="fn_ipadrDelForm();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
							<table id="serverIpadr" class="cell-border display" cellspacing="0" align="left">
								<thead>
									<tr>
										<th width="10"></th>
										<th width="150">DBMS아이피</th>
										<th width="117">포트</th>
										<th width="130">구분</th>
										<th width="130">연결여부</th>	
										<th width="0"></th>								
									</tr>
								</thead>
							</table>
					</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1" >DBMS명(*)</th>
					<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm"  style="width:230px" maxlength="20"/>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_svrnmCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span></td>
					<th scope="row" class="ico_t1" style="width: 60px; margin-right: -160px; margin-top: 0;">Database(*)</th>
					<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" maxlength="30"/></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">계정(*)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id" maxlength="30"/></td>
					<th scope="row" class="ico_t1">Password(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>				
				</tr>				
				<tr>
					<th scope="row" class="ico_t1">PG_HOME경로(*)</th>
					<td>
					<input type="text" class="txt" name="pghome_pth" id="pghome_pth" style="width:750px" readonly="readonly" /></td>				
				</tr>
				<tr>
					<th scope="row" class="ico_t1">PG_DATA경로(*)</th>
					<td>
					<input type="text" class="txt" name="pgdata_pth" id="pgdata_pth" style="width:750px" readonly="readonly" /></td>				
				</tr>				
			</tbody>
		</table>
		</form>
		<div class="btn_type_02">
			<span class="btn"><button onClick="fn_insertDbServer();">저장</button></span>
			<span class="btn btnF_01 btnC_01"><button onClick="fn_dbServerConnTest();">연결테스트</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>