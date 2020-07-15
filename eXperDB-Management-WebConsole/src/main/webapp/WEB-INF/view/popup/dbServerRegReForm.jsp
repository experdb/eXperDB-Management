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

var connCheck = "fail";
/* var pghomeCheck="fail";
var pgdataCheck ="fail"; */
var db_svr_id = ${db_svr_id};

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
		{data : "svr_host_nm",  defaultContent : "", visible: false}
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
	
	if(connCheck != "success"){
		alert('<spring:message code="message.msg89" />');
		return false;
	}
	
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
	

    $.ajax({
		url : "/selectIpadrList.do",
		data : {
			db_svr_id : db_svr_id
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
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
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
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
	
	
	var list = $("input[name='port']");
	
	
	for(var i = 0; i < ipadrCnt; i++){
		 var datas = new Object();
		 datas.SERVER_NAME = $("#db_svr_nm").val();
	     datas.SERVER_IP = table.rows().data()[i].ipadr;
	     datas.SERVER_PORT = list[i].value;	  
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
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
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
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
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
	var list = $("input[name='port']");
	 var useyn = $(":input:radio[name=useyn]:checked").val();

	if (!fn_dbServerValidation()) return false;
	if (!fn_saveValidation()) return false;
	
	var datas = table.rows().data();
	
	var arrmaps = [];
	for (var i = 0; i < datas.length; i++){
		var tmpmap = new Object();
		tmpmap["ipadr"] = table.rows().data()[i].ipadr;
        tmpmap["portno"] = list[i].value;	  
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
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
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
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
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
						top.location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
						top.location.href = "/";
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
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
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
<div class="modal fade" id="pop_layer_dbserver_mod" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 250px;">
		<div class="modal-content" style="width:1100px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					DBMS <spring:message code="common.modify" />
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" name="dbserverInsert" id="dbserverInsert" method="post">
							<fieldset>
								<div class="form-group row border-bottom">
									<label for="com_db_svr_nm" class="col-sm-3 col-form-label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.dbms_ip" />
									</label>
									<div class="col-sm-9">
										<a data-toggle="modal" href="#pop_layer_ip_reg"><span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span></a>
										<span onclick="fn_ipadrDelForm();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
										<table id="serverIpadr" class="table table-hover table-striped" cellspacing="0" align="left">
											<thead>
												<tr class="bg-primary text-white">
													<th width="10"></th>
													<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="120"><spring:message code="data_transfer.port" /></th>
													<th width="130"><spring:message code="common.division" /></th>
													<th width="130"><spring:message code="dbms_information.conn_YN"/></th>	
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
									<div class="col-sm-4">
										<input type="text" class="form-control" id="db_svr_nm" name="db_svr_nm"  readonly="readonly">
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
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="dbms_information.use_yn" />
									</label>
									<div class="col-sm-4">
										<spring:message code="dbms_information.use" /><input type="radio" name="useyn" id="useyn_Y" value="Y"> 
										<spring:message code="dbms_information.unuse" /><input type="radio" name="useyn"  id="useyn_N" value="N">
									</div>
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button"  onClick="fn_updateDbServer();" value='<spring:message code="common.registory" />' />
									<input class="btn btn-primary" width="200px" style="vertical-align:middle;" type="button" onClick="fn_dbServerConnTest();" value='<spring:message code="dbms_information.conn_Test" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
							<input type="hidden" id="db_svr_id" name="db_svr_id">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>