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

<script type="text/javascript">

var connCheckReg = "fail";
var dbServerRegTable = null;
/* var pghomeCheck="fail";
var pgdataCheck ="fail"; */
// var db_svr_id = ${db_svr_id};

function fn_init3() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	 dbServerRegTable = $('#serverIpadrReg').DataTable({
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
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "ipadr",  defaultContent : ""},		
		{data : "portno", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="text" class="txt" name="port" value="' +full.portno + '" style="width: 132px; height: 25px;" id="port">';      
	           }
	           
	           return data;
	      }}, 		
		{data : "master_gbn",  defaultContent : ""},
		{data : "connYn",  defaultContent : ""},
		{data : "svr_host_nm",  defaultContent : "", visible: false},
		{data : "db_svr_ipadr_id",  defaultContent : "", visible: false},
		]
	});
	
	dbServerRegTable.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	dbServerRegTable.tables().header().to$().find('th:eq(1)').css('min-width', '260px');
	dbServerRegTable.tables().header().to$().find('th:eq(2)').css('min-width', '170px');
	dbServerRegTable.tables().header().to$().find('th:eq(3)').css('min-width', '190px');
	dbServerRegTable.tables().header().to$().find('th:eq(4)').css('min-width', '190px');
	dbServerRegTable.tables().header().to$().find('th:eq(5)').css('min-width', '10px');

    $(window).trigger('resize'); 
}


function fn_dbServerValidation2(){
	if(connCheckReg != "success"){
		showSwalIcon('<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	return true;
}


function fn_ipadrValidation2(){
	var ipadr = document.getElementById("ipadr_reg");
	var portno = document.getElementById("portno_reg");
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

function fn_saveValidation2(){
	var mCnt = 0;
	var dataCnt = dbServerRegTable.column(0).data().length;
	
	if(connCheckReg != "success"){
		showSwalIcon('<spring:message code="message.msg89" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	
	for(var i=0; i<dataCnt; i++){
		if(dbServerRegTable.rows().data()[i].master_gbn == "M"){
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


$(function() {		
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#serverIpadrReg tbody').on( 'click', 'tr', function () {
    	
    	var vCheck =  dbServerRegTable.row(this).data().rownum;
    	
//     	var check = dbServerRegTable.row( this ).index()+1
//     	$(":radio[name=input:radio][value="+check+"]").prop("checked", true);
         if ( $(this).hasClass('selected') ) {
        	 //$("input:radio[name='radio']:radio[value="+vCheck+"]").prop('checked', false);
        }
        else {    	
        	dbServerRegTable.$('tr.selected').removeClass('selected');
        	 $("input:radio[name='radio']:radio[value="+vCheck+"]").prop('checked', true);
            $(this).addClass('selected');       
        } 
    });
});

//DBserver 연결테스트
function fn_dbServerConnTest2(){
	var datasArr = new Array();

	if (dbServerRegTable.column(0).data().length > 0) {
		var ipadrCnt = dbServerRegTable.column(0).data().length;
		var list = $("input[name='port']");
		
		for(var i = 0; i < ipadrCnt; i++){
			 var datas = new Object();
			 datas.SERVER_NAME = $("#md_db_svr_nm").val();
		     datas.SERVER_IP = dbServerRegTable.rows().data()[i].ipadr;
		     datas.SERVER_PORT = list[i].value;	  
		     datas.DATABASE_NAME = $("#md_dft_db_nm").val();	
		     datas.USER_ID = $("#md_svr_spr_usr_id").val();	
		     datas.USER_PWD = $("#md_svr_spr_scm_pwd").val();	
		     datasArr.push(datas);
		 }
		
		$.ajax({
			url : "/dbServerConnTest.do",
			data : {
				ipadr : dbServerRegTable.rows().data()[0].ipadr,
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
				if(result.legnth != 0 ){
					for(var i=0; i<result.length; i++){
						if(result[i].result_code == 0){				
							if(dbServerRegTable.rows().data()[i].ipadr == result[i].result_data[0].SERVER_IP){
								dbServerRegTable.cell(i, 3).data(result[i].result_data[0].MASTER_GBN).draw();
								dbServerRegTable.cell(i, 4).data(result[i].result_data[0].CONNECT_YN).draw();
								if(result[i].result_data[0].CMD_HOSTNAME != undefined){
									dbServerRegTable.cell(i, 5).data(result[i].result_data[0].CMD_HOSTNAME).draw();
								}
							}
							if(result[i].result_data[0].MASTER_GBN == "N" || result[i].result_data[0].CONNECT_YN == "N"){
								connCheckReg = "fail"
								showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
								return false;
							}
						}else{
							connCheckReg = "fail"
							showSwalIcon('<spring:message code="message.msg92" />', '<spring:message code="common.close" />', '', 'error');
							return false;
						}		
					}
					connCheckReg = "success";
					showSwalIcon('<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
					fn_pathCall2(dbServerRegTable.rows().data()[0].ipadr, datasArr);
				}
			}
		}); 
	} else {
		showSwalIcon('<spring:message code="dbms_information.msg01" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
}


function fn_pathCall2(ipadr, datasArr){
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
			document.getElementById("md_pghome_pth").value=result.CMD_DBMS_PATH;
			document.getElementById("md_pgdata_pth").value=result.DATA_PATH;
		}
	}); 
}

//DBserver 수정
function fn_updateDbServer(){
	var list = $("input[name='port']");
	 var useyn = $(":input:radio[name=useyn]:checked").val();

	if (!fn_dbServerValidation2()) return false;
	if (!fn_saveValidation2()) return false;
	
	confile_title = '<spring:message code="menu.dbms_registration" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("mod_DBServer");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="etc.etc13" />');
	$('#pop_confirm_multi_md').modal("show");
	
}

//DBserver 수정
function fn_updateDbServer2(){
	var list = $("input[name='port']");
	 var useyn = $(":input:radio[name=useyn]:checked").val();

	var datas = dbServerRegTable.rows().data();
	
	var arrmaps = [];
	var ipmaps = [];
	
	for (var i = 0; i < datas.length; i++){
		var tmpmap = new Object();
		var ipmap = new Object();
		tmpmap["ipadr"] = dbServerRegTable.rows().data()[i].ipadr;
        tmpmap["portno"] = list[i].value;	  
        tmpmap["master_gbn"] = dbServerRegTable.rows().data()[i].master_gbn;
        tmpmap["svr_host_nm"] = dbServerRegTable.rows().data()[i].svr_host_nm;
        
        if(dbServerRegTable.rows().data()[i].db_svr_ipadr_id == undefined){
        	tmpmap["db_svr_ipadr_id"] = "-1";
        }else{
        	tmpmap["db_svr_ipadr_id"] = dbServerRegTable.rows().data()[i].db_svr_ipadr_id;
        }
        arrmaps.push(tmpmap);	
    

        ipmaps.push(dbServerRegTable.rows().data()[i].db_svr_ipadr_id);
		}


		
	$.ajax({
		url : "/updateDbServer.do",
		data : {
			db_svr_id: $("#md_db_svr_id").val(),
			db_svr_nm: $("#md_db_svr_nm").val(),
			dft_db_nm : $("#md_dft_db_nm").val(),
			svr_spr_usr_id : $("#md_svr_spr_usr_id").val(),
			svr_spr_scm_pwd : $("#md_svr_spr_scm_pwd").val(),
			pghome_pth : $("#md_pghome_pth").val(),
			pgdata_pth : $("#md_pgdata_pth").val(),
			useyn : useyn,
			ipmaps : JSON.stringify(ipmaps),
			ipadrArr : JSON.stringify(arrmaps)
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
			showSwalIconRst('<spring:message code="message.msg84" />', '<spring:message code="common.close" />', '', 'success', "reload");			
		}
	}); 
}

/* ********************************************************
 * PG_HOME 경로의 존재유무 체크
 ******************************************************** */
function checkPghome(){
	var ipadr = null;
	var portno = null;
	
	var dataCnt = dbServerRegTable.column(0).data().length;
	
	for(var i=0; i<dataCnt; i++){
		if(dbServerRegTable.rows().data()[i].master_gbn == "M"){
			ipadr = dbServerRegTable.rows().data()[i].ipadr;
			portno = dbServerRegTable.rows().data()[i].portno;
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
				db_svr_nm : $("#md_db_svr_nm").val(),
				dft_db_nm : $("#md_dft_db_nm").val(),
				ipadr : ipadr,
				portno : portno,
				svr_spr_usr_id : $("#md_svr_spr_usr_id").val(),
				svr_spr_scm_pwd : $("#md_svr_spr_scm_pwd").val(),
		  		path : save_pth,
		  		flag : "m"
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
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						$("#check_path").val("Y");
						pghomeCheck = "success";
						showSwalIcon('<spring:message code="message.msg100"/>', '<spring:message code="common.close" />', '', 'success');
					}else{
						showSwalIcon('<spring:message code="message.msg75" />', '<spring:message code="common.close" />', '', 'error');
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
		
		var dataCnt = dbServerRegTable.column(0).data().length;
		
		for(var i=0; i<dataCnt; i++){
			if(dbServerRegTable.rows().data()[i].master_gbn == "M"){
				ipadr = dbServerRegTable.rows().data()[i].ipadr;
				portno = dbServerRegTable.rows().data()[i].portno;
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
					db_svr_nm : $("#md_db_svr_nm").val(),
					dft_db_nm : $("#md_dft_db_nm").val(),
					ipadr : ipadr,
					portno : portno,
					svr_spr_usr_id : $("#md_svr_spr_usr_id").val(),
					svr_spr_scm_pwd : $("#md_svr_spr_scm_pwd").val(),
			  		path : save_pth,
			  		flag : "m"
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
				success : function(data) {
					if(data.result.ERR_CODE == ""){
						if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
							$("#check_path").val("Y");
							pgdataCheck = "success";
							showSwalIcon('<spring:message code="message.msg104"/>', '<spring:message code="common.close" />', '', 'success');
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

 function fn_ipadrAddForm2(){
		
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
				$("#ipadr_reg").children().remove();
				$("#ipadr_reg").append("<option value='%'><spring:message code='common.choice' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#ipadr_reg").append("<option value='"+result[i].ipadr+"'>"+result[i].ipadr+"</option>");	
					}									
				}
			}
		});
	  	
		document.ipadr_form_reg.reset();
	}	
		
		
	function fn_ipadrAdd2(){
		if (!fn_ipadrValidation2()) return false;
		var dataCnt = dbServerRegTable.column(0).data().length;
		for(var i=0; i<dataCnt; i++){
			if(dbServerRegTable.rows().data()[i].ipadr == $("#ipadr_reg").val()){
				showSwalIcon('<spring:message code="message.msg170" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}
		}
		
		dbServerRegTable.row.add( {
	        "ipadr":		$("#ipadr_reg").val(),
	        "portno":	$("#portno_reg").val()
	    } ).draw();	
		
		$('#pop_layer_ip_reg_re').modal("hide");
	}

	function fn_ipadrDelForm2(){
		dbServerRegTable.row('.selected').remove().draw();
	}	
</script>
<div class="modal fade" id="pop_layer_ip_reg_re" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="display: none; z-index: 1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 250px 300px;">
		<div class="modal-content" style="width:1000px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="dbms_information.dbms_ip_reg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" name="ipadr_form_reg" id="ipadr_form_reg" method="post">
							<fieldset>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip" />(*)
									</label>
									<div class="col-sm-4">
										<select class="form-control"  id="ipadr_reg" name="ipadr_reg" onChange="fn_ipadrChange();" >
											<option value="%"><spring:message code="schedule.total" /> </option>
										</select>
									</div>
									
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="portno_reg" name=portno_reg  maxlength="5" onkeyup="fn_checkWord(this,5)" placeholder="5<spring:message code='message.msg188'/>">
									</div>
									
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onclick="fn_ipadrAdd2();" value='<spring:message code="common.add" />' />
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

<div class="modal fade" id="pop_layer_dbserver_mod" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 250px;">
		<div class="modal-content" style="width:1100px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					DBMS <spring:message code="common.modify" />
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
										<a data-toggle="modal" href="#pop_layer_ip_reg_re"><span onclick="fn_ipadrAddForm2();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span></a>
										<span onclick="fn_ipadrDelForm2();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
										<table id="serverIpadrReg" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="10"></th>
													<th width="260"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="170"><spring:message code="data_transfer.port" /></th>
													<th width="190"><spring:message code="common.division" /></th>
													<th width="190"><spring:message code="dbms_information.conn_YN"/></th>	
													<th width="10"></th>								
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
									<div class="col-sm-4">
										<input type="text" class="form-control" id="md_db_svr_nm" name="db_svr_nm"  readonly="readonly">
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Database(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="md_dft_db_nm" name="dft_db_nm"  maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>">
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.account" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="md_svr_spr_usr_id" name="svr_spr_usr_id"  maxlength="30" onkeyup="fn_checkWord(this,30)" placeholder="30<spring:message code='message.msg188'/>">
									</div>
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.password" />(*)
									</label>
									<div class="col-sm-4">
										<input type="password" class="form-control" id="md_svr_spr_scm_pwd" name="svr_spr_scm_pwd" >
									</div>
								</div>
								<div class="form-group row">
									<label for="com_ipadr" class="col-sm-2 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.pgHomePath"/>(*)
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control" id="md_pghome_pth" name="pghome_pth"  readonly="readonly">
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.pgDataPath"/>(*)
									</label>
									<div class="col-sm-10">
										<input type="text" class="form-control" id="md_pgdata_pth" name="pgdata_pth"  readonly="readonly">
									</div>
								</div>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="user_management.use_yn" />
									</label>
									<div class="col-sm-4">
										<div class="form-group row" style="margin-top:5px;">
											<div class="col-sm-6">
												<div class="form-check">
													<label class="form-check-label" for="useyn_Y">
														<input type="radio" class="form-check-input" name="useyn" id="useyn_Y" value="Y" checked/>
                          								<spring:message code="dbms_information.use"/>
                          							</label>
                          						</div>
                          					</div>
                          					<div class="col-sm-6">
                          						<div class="form-check">
                          							<label class="form-check-label" for="useyn_N">
                          								<input type="radio" class="form-check-input" name="useyn" id="useyn_N" value="N" />
                          								<spring:message code="dbms_information.unuse"/>
                          							</label>
                          						</div>
                          					</div>
                          				</div>				
									</div>
									<div class="col-sm-6">			
									</div>
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button"  onClick="fn_updateDbServer();" value='<spring:message code="common.save" />' />
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button" onClick="fn_dbServerConnTest2();" value='<spring:message code="dbms_information.conn_Test" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
							<input type="hidden" id="md_db_svr_id" name="db_svr_id">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>