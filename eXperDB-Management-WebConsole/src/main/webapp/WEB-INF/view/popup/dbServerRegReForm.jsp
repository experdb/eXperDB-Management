<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : dbServerRegReForm.jsp
	* @Description : 디비 서버 수정 화면
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

var connCheck = "fail";
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


function fn_dbServerValidation(){
/* 	 if(pghomeCheck != "success"){
			alert("PG_HOME경로 확인 하셔야합니다.");
			return false;
		}
 		if(pgdataCheck != "success"){
			alert("PG_DATA경로 확인 하셔야합니다.");
			return false;
		} */
 		if(connCheck != "success"){
			alert('<spring:message code="message.msg89" /> ');
			return false;
		}
 		return true;
}


function fn_ipadrValidation(){
	var ipadr = document.getElementById("ipadr");
	var portno = document.getElementById("portno");
		if (ipadr.value == "%") {
			   alert('<spring:message code="message.msg90" />');
			   ipadr.focus();
			   return false;
		}else if(portno.value == ""){
			alert('<spring:message code="message.msg83" />');
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
		alert('<spring:message code="message.msg98" />');
		return false;
	}else if(mCnt > 1){
		alert('<spring:message code="message.msg91" />');
		return false;
	}
	return true;
}

$(window.document).ready(function() {
	fn_init();
	var db_svr_id = <%= request.getParameter("db_svr_id") %>

    $.ajax({
		url : "/selectIpadrList.do",
		data : {
			db_svr_id : parseInt(db_svr_id)
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
			
			fn_selectDbServerList(db_svr_id);
		}
	});   
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

function fn_selectDbServerList(db_svr_id){
    $.ajax({
		url : "/selectDbServerList.do",
		data : {
			db_svr_id : parseInt(db_svr_id)
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			document.getElementById('db_svr_id').value= result[0].db_svr_id;
			document.getElementById('db_svr_nm').value= result[0].db_svr_nm;
			document.getElementById('dft_db_nm').value= result[0].dft_db_nm;
			document.getElementById('svr_spr_usr_id').value= result[0].svr_spr_usr_id;
			document.getElementById('svr_spr_scm_pwd').value= result[0].svr_spr_scm_pwd;
			document.getElementById('pghome_pth').value= result[0].pghome_pth;
			document.getElementById('pgdata_pth').value= result[0].pgdata_pth;
			if(result[0].useyn == 'Y'){
				$("#useyn_Y").prop("checked", true);
			}else{
				$("#useyn_N").prop("checked", true);
			}
			
		}
    });  
}


//DBserver 연결테스트
function fn_dbServerConnTest(){
	
	var datasArr = new Array();
	var ipadrCnt = table.column(0).data().length;
	
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
			ipadr : table.rows().data()[0].ipadr,
			datasArr : JSON.stringify(datasArr)
		},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			if(result.legnth != 0 ){
				for(var i=0; i<result.length; i++){
					if(result[i].result_code == 0){				
						if(table.rows().data()[i].ipadr == result[i].result_data[0].SERVER_IP){
							table.cell(i, 3).data(result[i].result_data[0].MASTER_GBN).draw();
							table.cell(i, 4).data(result[i].result_data[0].CONNECT_YN).draw();
							if(result[i].result_data[0].CMD_HOSTNAME != undefined){
								table.cell(i, 5).data(result[i].result_data[0].CMD_HOSTNAME).draw();
							}
						}
						if(result[i].result_data[0].MASTER_GBN == "N" || result[i].result_data[0].CONNECT_YN == "N"){
								connCheck = "fail"
								alert('<spring:message code="message.msg92" />');
								return false;
						}
					}else{
						connCheck = "fail"
							alert('<spring:message code="message.msg92" />');
							return false;
					}		
				}
				connCheck = "success";
				alert('<spring:message code="message.msg93" />');
				fn_pathCall(ipadr, datasArr);
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
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
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

//DBserver 수정
function fn_updateDbServer(){
	 var useyn = $(":input:radio[name=useyn]:checked").val();

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
	
	if (confirm('<spring:message code="etc.etc13"/>')){	
	$.ajax({
		url : "/updateDbServer.do",
		data : {
			db_svr_id: $("#db_svr_id").val(),
			db_svr_nm: $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
			pghome_pth : $("#pghome_pth").val(),
			pgdata_pth : $("#pgdata_pth").val(),
			useyn : useyn,
			ipadrArr : JSON.stringify(arrmaps)
		},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
	             location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			alert('<spring:message code="message.msg84" />');
			opener.location.reload();
			self.close();			
		}
	}); 
	}else{
		return false;
	}	
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
		alert('<spring:message code="message.msg98" />');
		return false;
	}
	
	var save_pth = $("#pghome_pth").val();
	if(save_pth == ""){
		alert('<spring:message code="message.msg99" />');
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
		  		flag : "m"
		  	},
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						$("#check_path").val("Y");
						pghomeCheck = "success";
						alert('<spring:message code="message.msg100" />');
					}else{
						alert('<spring:message code="message.msg75" />');
					}
				}else{
					alert('<spring:message code="message.msg76" />')
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
			alert('<spring:message code="message.msg98" />');
			return false;
		}
		
		var save_pth = $("#pgdata_pth").val();
		if(save_pth == ""){
			alert('<spring:message code="message.msg99" />');
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
			  		flag : "m"
			  	},
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
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
							alert('<spring:message code="message.msg104" />');
						}else{
							alert('<spring:message code="backup_management.invalid_path"/>');
						}
					}else{
						alert('<spring:message code="message.msg76" />')
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
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				$("#ipadr").children().remove();
				$("#ipadr").append("<option value='%'><spring:message code='common.choice' /></option>");
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
				alert('<spring:message code="message.msg170"/>');
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
				<p class="tit"><spring:message code="dbms_information.dbms_ip_reg"/></p>
					<form name="ipadr_form">
						<table class="write">
							<caption><spring:message code="dbms_information.dbms_ip_reg"/></caption>
							<colgroup>
								<col style="width:130px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="dbms_information.dbms_ip" />(*)</th>
									<td>
										<select class="select"  id="ipadr" name="ipadr" onChange="fn_ipadrChange();" >
											<option value="%"><spring:message code="schedule.total" /></option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t1"><spring:message code="data_transfer.port" />(*)</th>
									<td><input type="text" class="txt" name="portno" id="portno"/></td>
								</tr>
							</tbody>
						</table>
					</form>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="fn_ipadrAdd();"><span><spring:message code="common.add" /></span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span><spring:message code="common.cancel" /></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">DBMS <spring:message code="common.modify" /></p>
		 <form name="dbserverInsert" id="dbserverInsert" method="post">
		<table class="write">
			<caption>DBMS <spring:message code="common.modify" /></caption>
			<colgroup>
				<col style="width:120px;" />
				<col />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" class="ico_t1" ><spring:message code="dbms_information.dbms_ip" />(*)</th>
					<td colspan="3">
						<!-- 메인 테이블 -->
						<span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span>
						<span onclick="fn_ipadrDelForm();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
							<table id="serverIpadr" class="cell-border display" cellspacing="0" align="left">
								<thead>
									<tr>
										<th width="10"></th>
										<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
										<th width="117"><spring:message code="data_transfer.port" /></th>
										<th width="130"><spring:message code="common.division" /></th>
										<th width="130"><spring:message code="dbms_information.conn_YN"/></th>	
										<th width="0"></th>									
									</tr>
								</thead>
							</table>
					</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="common.dbms_name" />(*)</th>
					<td><input type="text" class="txt bg1" name="db_svr_nm" id="db_svr_nm"  readonly="readonly"  /></td>
					<th scope="row" class="ico_t1">Database(*)</th>
					<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="dbms_information.account" />(*)</th>
					<td><input type="text" class="txt" name="svr_spr_usr_id" id="svr_spr_usr_id"  /></td>
					<th scope="row" class="ico_t1">Password(*)</th>
					<td><input type="password" class="txt" name="svr_spr_scm_pwd" id="svr_spr_scm_pwd" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="dbms_information.pgHomePath"/>(*)</th>
					<td>
					<input type="text" class="txt" name="pghome_pth" id="pghome_pth" style="width:750px" readonly="readonly"/></td>
<!-- 					<th scope="row" class="ico_t1"></th>
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkPghome()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
					</td>		 -->			
				</tr>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="dbms_information.pgDataPath"/>(*)</th>
					<td>
					<input type="text" class="txt" name="pgdata_pth" id="pgdata_pth" style="width:750px" readonly="readonly"/></td>
					<!-- <th scope="row" class="ico_t1"></th>
					<td>
					<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="checkPgdata()" style="width: 60px; margin-left: 237px; margin-top: 0;">경로체크</button></span>
					</td> -->					
				</tr>	
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="dbms_information.use_yn" /></th>
					<td>
					<spring:message code="dbms_information.use" /><input type="radio" name="useyn" id="useyn_Y" value="Y"> 
					<spring:message code="dbms_information.unuse" /><input type="radio" name="useyn"  id="useyn_N" value="N"></td>			
				</tr>	
			</tbody>
		</table>
		<input type="hidden" id="db_svr_id" name="db_svr_id">
		</form>
		<div class="btn_type_02">
			<span class="btn"><button onClick="fn_updateDbServer();"><spring:message code="common.save"/></button></span>
			<span class="btn btnF_01 btnC_01"><button onClick="fn_dbServerConnTest();"><spring:message code="dbms_information.conn_Test"/></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>