<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
//연결테스트 확인여부
var dbServerTable = null;
var connCheck = "fail";
var idCheck = "fail";
var db_svr_nmChk ="fail";

var agentPort = null;
var ipadr = null;
var port = null;

function fn_init2() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	 dbServerTable = $('#serverIpadr').DataTable({
		scrollY : "100px",
		bSort: false,
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
		columns : [
		{data : "rownum", defaultContent : "",  
			targets: 0,
	        searchable: false,
	        orderable: false,
	        className : "dt-center",
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "ipadr",  defaultContent : ""},
		{data : "portno", className : "dt-right",  defaultContent : ""},
		{data : "master_gbn",  defaultContent : ""},
		{data : "connYn",  defaultContent : ""},	
		{data : "svr_host_nm",  defaultContent : "", visible: false}
		]
	});
	
	dbServerTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	dbServerTable.tables().header().to$().find('th:eq(1)').css('min-width', '230px');
	dbServerTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	dbServerTable.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	dbServerTable.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
	dbServerTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
    $(window).trigger('resize'); 
}


$(function() {		
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#serverIpadr tbody').on( 'click', 'tr', function () {
    	var vCheck =  dbServerTable.row(this).data().rownum;
//     	var check = dbServerTable.row( this ).index()+1
//     	$(":radio[name=input:radio][value="+check+"]").prop("checked", true);
         if ( $(this).hasClass('selected') ) {
        }
        else {    	
        	$("input:radio[name='radio']:radio[value="+vCheck+"]").prop('checked', true);
        	dbServerTable.$('tr.selected').removeClass('selected');
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
	if (dbServerTable != null) {
		if(dbServerTable.rows().data().length < 1){
			showSwalIcon('<spring:message code="message.msg184" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		
		var db_svr_nm = document.getElementById("db_svr_nm");
		if (db_svr_nm.value == "") {
			showSwalIcon('<spring:message code="message.msg85" />', '<spring:message code="common.close" />', '', 'error');
			db_svr_nm.focus();
			return false;
		}
		var dft_db_nm = document.getElementById("dft_db_nm");
 		if (dft_db_nm.value == "") {
 			showSwalIcon('<spring:message code="message.msg86" />', '<spring:message code="common.close" />', '', 'error');
  			dft_db_nm.focus();
  			return false;
  		}

		var svr_spr_usr_id = document.getElementById("svr_spr_usr_id");
 		if (svr_spr_usr_id.value == "") {
 			showSwalIcon('<spring:message code="message.msg87" />', '<spring:message code="common.close" />', '', 'error');
  			svr_spr_usr_id.focus();
  			return false;
  		}
 		var svr_spr_scm_pwd = document.getElementById("svr_spr_scm_pwd");
 		if (svr_spr_scm_pwd.value == "") {
 			showSwalIcon('<spring:message code="message.msg88" />', '<spring:message code="common.close" />', '', 'error');
  			svr_spr_scm_pwd.focus();
  			return false;
  		}
	} else {
		showSwalIcon('<spring:message code="dbms_information.msg01" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	return true;
}

function fn_ipadrValidation(){
	var ipadr = document.getElementById("ipadr");
	var portno = document.getElementById("portno");
		if (ipadr.value == "%") {
			showSwalIcon('<spring:message code="message.msg90" />', '<spring:message code="common.close" />', '', 'error');
			ipadr.focus();
			return false;
		}else if(portno.value == ""){
			showSwalIcon('<spring:message code="message.msg83" />', '<spring:message code="common.close" />', '', 'error');
			portno.focus();
			return false;
		}
 		return true;
}


function fn_saveValidation(){
	var mCnt = 0;
	var dataCnt = dbServerTable.column(0).data().length;
	
	if(connCheck != "success"){
		alert('<spring:message code="message.msg89" />');
		return false;
	}
		
	for(var i=0; i<dataCnt; i++){
		if(dbServerTable.rows().data()[i].master_gbn == "M"){
			mCnt += 1;
		}
	}
	if(mCnt == 0){
		showSwalIcon('<spring:message code="message.msg98" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(mCnt > 1){
		showSwalIcon('<spring:message code="message.msg91" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	return true;
}

// DBserver 등록
function fn_insertDbServer(){
	if (!fn_dbServerValidation()) return false;
	if (!fn_saveValidation()) return false;
	confile_title = '<spring:message code="menu.dbms_registration" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("ins_DBServer");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="message.msg169" />');
	$('#pop_confirm_multi_md').modal("show");
} 

//DBserver 등록
function fn_insertDbServer2(){
	var datas = dbServerTable.rows().data();
	var arrmaps = [];
	for (var i = 0; i < datas.length; i++){
		var tmpmap = new Object();
		tmpmap["ipadr"] = dbServerTable.rows().data()[i].ipadr;
        tmpmap["portno"] = dbServerTable.rows().data()[i].portno;      
        tmpmap["master_gbn"] = dbServerTable.rows().data()[i].master_gbn;
        tmpmap["svr_host_nm"] = dbServerTable.rows().data()[i].svr_host_nm;
		arrmaps.push(tmpmap);	
		}
	
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
				showSwalIcon('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				showSwalIcon('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error');
				top.location.href = "/";
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {	
			//서버등록 성공 후, PG_Audit Create
			fu_extensionCreate(arrmaps);
		}
	}); 
}

//EXTENSION 설치
function fu_extensionCreate(arrmaps){
	
	for (var i = 0; i < arrmaps.length; i++){
		if(arrmaps[i].master_gbn == "M"){
			ipadr = arrmaps[i].ipadr;
			port = arrmaps[i].portno;
		}
	} 
	
  	$.ajax({
		url : "/extensionCreate.do",
		data : {
			agentPort : agentPort,
			ipadr : ipadr,
			port :	port,
			db_svr_nm : $("#db_svr_nm").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			svr_spr_usr_id : $("#svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#svr_spr_scm_pwd").val(),
		},
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {
			showSwalIconRst('<spring:message code="message.msg144" />', '<spring:message code="common.close" />', '', 'success', "reload");
			$('#pop_layer_dbserver_reg').modal("hide");	 			
		}
	}); 
}


//DBserver 연결테스트
function fn_dbServerConnTest(){
	if (!fn_dbServerValidation()) return false;
	var datasArr = new Array();
	var ipadrCnt = dbServerTable.column(0).data().length;
	var ipadr = dbServerTable.rows().data()[0].ipadr;
	
	
	for(var i = 0; i < ipadrCnt; i++){
		 var datas = new Object();
		 datas.SERVER_NAME = $("#db_svr_nm").val();
	     datas.SERVER_IP = dbServerTable.rows().data()[i].ipadr;
	     datas.SERVER_PORT = dbServerTable.rows().data()[i].portno;		  
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
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		},
		success : function(result) {
			if(result[0].result_code == 0){				
				 for(var i=0; i<result.length; i++){		
					if(dbServerTable.rows().data()[i].ipadr == result[i].result_data[0].SERVER_IP){
						dbServerTable.cell(i, 3).data(result[i].result_data[0].MASTER_GBN).draw();
						dbServerTable.cell(i, 4).data(result[i].result_data[0].CONNECT_YN).draw();	
						 if(result[i].result_data[0].MASTER_GBN != "N" || result[i].result_data[0].CONNECT_YN != "N"){
							 dbServerTable.cell(i, 5).data(result[i].result_data[0].CMD_HOSTNAME).draw();	
						 }
					}				
					 if(result[i].result_data[0].MASTER_GBN == "N" || result[i].result_data[0].CONNECT_YN == "N"){
							connCheck = "fail"
							showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
							return false;
					}
				 }
				 
				connCheck = "success";
				showSwalIcon('<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
				fn_pathCall(ipadr, datasArr);
				
			}else{
			connCheck = "fail"
			showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
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
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
				alert('<spring:message code="message.msg94" />');
				return false;
			}			
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
			agentPort = result.agentPort;
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
			}
		}
	});
}
	
//서버명 중복체크
function fn_svrnmCheck() {
	var db_svr_nm = document.getElementById("db_svr_nm");
	if (db_svr_nm.value == "") {
		showSwalIcon('<spring:message code="message.msg85" />', '<spring:message code="common.close" />', '', 'error');
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
				showSwalIcon('<spring:message code="message.msg96"/>', '<spring:message code="common.close" />', '', 'success');
				document.getElementById("db_svr_nm").focus();
				db_svr_nmChk = "success";
			} else {
				showSwalIcon('<spring:message code="message.msg97" />', '<spring:message code="common.close" />', '', 'error');
				document.getElementById("db_svr_nm").focus();
			}
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				top.location.href = "/";
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
	
	var dataCnt = dbServerTable.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(dbServerTable.rows().data()[i].master_gbn == "M"){
			ipadr = dbServerTable.rows().data()[i].ipadr;
			portno = dbServerTable.rows().data()[i].portno;
		}
	}
	if(ipadr == null){
		showSwalIcon('<spring:message code="message.msg98" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	
	var save_pth = $("#pghome_pth").val();
	if(save_pth == ""){
		showSwalIcon('<spring:message code="message.msg99" />', '<spring:message code="common.close" />', '', 'error');
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
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {				
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY== 0){
						$("#check_path").val("Y");
						pghomeCheck = "success";
						showSwalIcon('<spring:message code="message.msg100"/>', '<spring:message code="common.close" />', '', 'success');
					}else{
						showSwalIcon('<spring:message code="message.msg101" />', '<spring:message code="common.close" />', '', 'error');
					}
				}else{
					showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');
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

		var dataCnt = dbServerTable.column(0).data().length;
		
		for(var i=0; i<dataCnt; i++){
			if(dbServerTable.rows().data()[i].master_gbn == "M"){
				ipadr = dbServerTable.rows().data()[i].ipadr;
				portno = dbServerTable.rows().data()[i].portno;
			}
		}
		if(ipadr == null){
			showSwalIcon('<spring:message code="message.msg98" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
		
		var save_pth = $("#pgdata_pth").val();
		if(save_pth == ""){
			showSwalIcon('<spring:message code="message.msg99" />', '<spring:message code="common.close" />', '', 'error');
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
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
						top.location.href = "/";
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
						top.location.href = "/";
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(data) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							$("#check_path").val("Y");
							pgdataCheck = "success";
							alert('<spring:message code="message.msg104" />');
						}else{
							showSwalIcon('<spring:message code="backup_management.invalid_path" />', '<spring:message code="common.close" />', '', 'error');
						}
					}else{
						showSwalIcon('<spring:message code="message.msg76" />', '<spring:message code="common.close" />', '', 'error');
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
				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else if(xhr.status == 403) {
				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
			} else {
				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
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
}	
	
	
function fn_ipadrAdd(){
	if (!fn_ipadrValidation()) return false;
	
	var dataCnt = dbServerTable.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(dbServerTable.rows().data()[i].ipadr == $("#ipadr").val()){
			showSwalIcon('<spring:message code="message.msg170" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}
	}
	
	dbServerTable.row.add( {
        "ipadr":		$("#ipadr").val(),
        "portno":	$("#portno").val()
    } ).draw();	
	
	$('#pop_layer_ip_reg').modal("hide");
}


function fn_ipadrDelForm(){
	dbServerTable.row('.selected').remove().draw();
}
</script>
<div class="modal fade" id="pop_layer_ip_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="display: none; z-index: 1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 250px 300px;">
		<div class="modal-content" style="width:1000px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="dbms_information.dbms_ip_reg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" name="ipadr_form" id="ipadr_form" method="post">
							<fieldset>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip" />(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control"  id="ipadr" name="ipadr" onChange="fn_ipadrChange();" >
											<option value="%"><spring:message code="schedule.total" /> </option>
										</select>
									</div>
									
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="portno" name="portno"  maxlength="5" onkeyup="fn_checkWord(this,5)" placeholder="5<spring:message code='message.msg188'/>">
									</div>
									
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onclick="fn_ipadrAdd();" value='<spring:message code="common.add" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	
<div class="modal fade" id="pop_layer_dbserver_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 250px;">
		<div class="modal-content" style="width:1100px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="menu.dbms_registration" />
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" name="dbserverInsert" id="dbserverInsert" method="post">
							<fieldset>
								<div class="form-group row">
									<label for="com_db_svr_nm" class="col-sm-12 col-form-label" style="margin-bottom:-50px;">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip" />
									</label>
								</div>
								<div class="form-group row border-bottom">
									<div class="col-sm-12" style="margin-bottom:10px;">
										<a data-toggle="modal" href="#pop_layer_ip_reg"><span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span></a>
										<span onclick="fn_ipadrDelForm();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
										<table id="serverIpadr" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="50"></th>
													<th width="230"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="150"><spring:message code="data_transfer.port" /></th>
													<th width="200"><spring:message code="common.division" /></th>
													<th width="200"><spring:message code="dbms_information.conn_YN"/></th>	
													<th width="0"></th>								
												</tr>
											</thead>
										</table>
									
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="common.dbms_name" />(*)
									</label>
									<div class="col-sm-4 form-inline">
										<input type="text" class="form-control" id="db_svr_nm" name="db_svr_nm"  maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" style="width: 55%;">
										&nbsp;<button type="button" class= "btn btn-inverse-danger btn-fw" onclick="fn_svrnmCheck()"><spring:message code="common.overlap_check" /></button>
										
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="dft_db_nm" name="dft_db_nm"  maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>">
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="svr_spr_usr_id" name="svr_spr_usr_id"  maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>">
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input type="password" class="form-control" id="svr_spr_scm_pwd" name="svr_spr_scm_pwd" >
									</div>
								</div>
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-2 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.pgHomePath"/>(*)
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control" id="pghome_pth" name="pghome_pth"  readonly="readonly">
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.pgDataPath"/>(*)
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control" id="pgdata_pth" name="pgdata_pth"  readonly="readonly">
									</div>
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button"  onClick="fn_insertDbServer();" value='<spring:message code="common.save" />' />
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button" onClick="fn_dbServerConnTest();" value='<spring:message code="dbms_information.conn_Test" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>