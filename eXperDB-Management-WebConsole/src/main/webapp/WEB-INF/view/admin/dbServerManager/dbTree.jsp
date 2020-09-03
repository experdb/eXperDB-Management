<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>

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

<script>
var confirm_title = ""; 

//연결테스트 확인여부
var connCheck = "fail";

var table_dbServer = null;
var table_db = null;
var severdb = null;

function fn_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "470px",
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
		{data : "ipadr", defaultContent : ""},
		{data : "db_svr_nm",  defaultContent : ""},		
		{data : "agt_cndt_cd", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        className : "dt-center",
	        render: function(data, type, full, meta){
	           if(full.agt_cndt_cd == 'TC001101'){
	              data = "<div class='badge badge-pill badge-primary' ><i class='fa fa-spin fa-refresh mr-2' style='margin-right: 0px !important;'></i></div>";    
	           }else{
	        	  data = "<div class='badge badge-pill badge-danger' ><i class='fa fa-times-circle mr-2' style='margin-right: 0px !important;'></i></div>";    
	           }
	           return data;
	        }}, 
        {data : "useyn", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(full.useyn == 'Y'){
	              data = '<spring:message code="dbms_information.use" />';      
	           }else{
	        	  data ='<spring:message code="dbms_information.unuse" />';
	           }
	           return data;
	        }}, 
/* 		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "portno", className : "dt-center", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_regr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "idx", className : "dt-center", defaultContent : "" ,visible: false},
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false} */
		]
	});

	/* ********************************************************
	 * 디비 (데이터테이블)
	 ******************************************************** */
	table_db = $('#dbList').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		paging : false,		
		deferRender : true,
		columns : [
		{data : "dft_db_nm", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}	,
		{data : "dft_db_nm", defaultContent : ""}, 
		{data : "db_exp", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="text" class="txt" name="db_exp" maxlength="100" value="' +full.db_exp + '" style="width: 360px; height: 25px;" id="db_exp">';      
	           }	           
	           return data;
	        }}, 
	        
		]
	});
	
	
	table_dbServer.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
	table_dbServer.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
	table_dbServer.tables().header().to$().find('th:eq(2)').css('min-width', '232px');
	table_dbServer.tables().header().to$().find('th:eq(3)').css('min-width', '70px');
	table_dbServer.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
/* 	table_dbServer.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(7)').css('min-width', '0px');  
	table_dbServer.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
	table_dbServer.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
    table_dbServer.tables().header().to$().find('th:eq(12)').css('min-width', '0px');  
    table_dbServer.tables().header().to$().find('th:eq(13)').css('min-width', '0px'); */
    
    table_db.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
    table_db.tables().header().to$().find('th:eq(1)').css('min-width', '110px');
    table_db.tables().header().to$().find('th:eq(2)').css('min-width', '360px');
    
    
    $(window).trigger('resize'); 
	
}


/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************* */
$(window.document).ready(function() {	
	fn_buttonAut();	
	fn_init();
	
	fn_selectTreeDbServerList();
	
	fn_init2();
	fn_init3();
	
});


function fn_selectTreeDbServerList(){
  	$.ajax({
		url : "/selectTreeDbServerList.do",
		data : {},
		//dataType : "json",
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
			table_dbServer.clear().draw();
			table_dbServer.rows.add(result).draw();
		}
	});
}

function fn_buttonAut(){
	var wrt_button = document.getElementById("wrt_button"); 
	var save_button = document.getElementById("save_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		wrt_button.style.display = '';
		save_button.style.display = '';
	}else{
		wrt_button.style.display = 'none';
		save_button.style.display = 'none';
	}
}

$(function() {		
	
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#dbServerList tbody').on( 'click', 'tr', function () {

    	var vCheck =  table_dbServer.row(this).data().rownum;
    	
    	var check = table_dbServer.row( this ).index()+1
         if ( $(this).hasClass('selected') ) {
        }
        else {
        	$("input:radio[name='radio']:radio[value="+vCheck+"]").prop('checked', true); 
        	table_dbServer.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        } 
         var db_svr_nm = table_dbServer.row('.selected').data().db_svr_nm;
         var ipadr = table_dbServer.row('.selected').data().ipadr;
        /* ********************************************************
         * 선택된 서버에 대한 디비 조회
        ******************************************************** */
       	$.ajax({
    		url : "/selectTreeServerDBList.do",
    		data : {
    			db_svr_nm: db_svr_nm
    		},
    		//dataType : "json",
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
    			if(result.data == null){
    				showSwalIcon('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error');
    			}else{
    				severdb = result;
    				table_db.rows({selected: true}).deselect();
    				table_db.clear().draw();
	    			table_db.rows.add(result.data).draw();
	    			fn_dataCompareChcek(result);
    			}
    		}
    	});
        
    } );
})


/* ********************************************************
 * 서버 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	$('#pop_layer_dbserver_reg').modal("show");
}


/* ********************************************************
 * 서버 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	var datas = table_dbServer.rows('.selected').data();
	if (datas.length == 1) {
	    $.ajax({
			url : "/selectIpadrList.do",
			data : {
				db_svr_id : table_dbServer.row('.selected').data().db_svr_id
			},
			dataType : "json",
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
			success : function(result) {
				dbServerRegTable.clear().draw();
				dbServerRegTable.rows.add(result).draw();
			    $.ajax({
					url : "/selectDbServerList.do",
					data : {
						db_svr_id : table_dbServer.row('.selected').data().db_svr_id
					},
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
						document.getElementById('md_db_svr_id').value= result[0].db_svr_id;
						document.getElementById('md_db_svr_nm').value= result[0].db_svr_nm;
						document.getElementById('md_dft_db_nm').value= result[0].dft_db_nm;
						document.getElementById('md_svr_spr_usr_id').value= result[0].svr_spr_usr_id;
						document.getElementById('md_svr_spr_scm_pwd').value= result[0].svr_spr_scm_pwd;
						document.getElementById('md_pghome_pth').value= result[0].pghome_pth;
						document.getElementById('md_pgdata_pth').value= result[0].pgdata_pth;
						if(result[0].useyn == 'Y'){
							$("#useyn_Y").prop("checked", true);
						}else{
							$("#useyn_N").prop("checked", true);
						}
						
					}
			    });
			}
		});  
  
		$('#pop_layer_dbserver_mod').modal("show");
	} else {
		showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
	}	
}


/* ********************************************************
 * 디비 등록
 ******************************************************** */
function fn_insertDB(){
	confile_title = '<spring:message code="common.database" />' + " " + '<spring:message code="common.save" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("ins_DB");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="message.msg160" />');
	$('#pop_confirm_multi_md').modal("show");

}

/* ********************************************************
 * 디비 등록
 ******************************************************** */
function fn_insertDB2(){
	var list = $("input[name='db_exp']");
	var datasArr = new Array();	
	var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;
	var ipadr = table_dbServer.row('.selected').data().ipadr;
	
	var datas = table_db.rows().data();
	var selectedDatas = table_db.rows('.selected').data();

	for(var i=0; i<datas.length; i++){
		var rows = new Object();
		var returnValue = false;
		
		for(var j=0; j<selectedDatas.length; j++){
			if(datas[i].dft_db_nm == selectedDatas[j].dft_db_nm){
				returnValue = true;
				break;
			}
		}
		
		if(returnValue == true){
			rows.useyn = "Y";
		}else{
			rows.useyn = "N";
		}
		
		rows.db_exp = list[i].value;
		rows.dft_db_nm = datas[i].dft_db_nm;	
		datasArr.push(rows);
	}
		
// 	// CheckBox 검사
// 	var chked = [];		
	
// 	//체크된갯수
// 	//var checkCnt = table_db.rows('.selected').data().length;
// 	var checkCnt = $("input:checkbox[name='chk']:checked").length;
// 	var rows = [];
//     	for (var i = 0; i<datas.length; i++) {
//      		var rows = new Object();
     		
//      		var org_dbName = table_db.rows().data()[i].dft_db_nm;	
//      		var returnValue = false;
     		 
//      		//체크된값 배열로 받음
//      		$("input[name=chk]:checked").each(function() {
//      			chked.push($(this).val());
//      		});

//      		  for(var j=0; j<checkCnt; j++) {     			
//      			var chkDBName = chked[j];
//      			if(org_dbName  == chkDBName) {
//      				returnValue = true;
//      				break;
//      			}
//      		}  

//      	 	if(returnValue == true){
//      	 		rows.db_exp = list[i].value;
//      			rows.useyn = "Y";
//      			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
//      		}else{
//      			rows.db_exp = list[i].value;
//      			rows.useyn = "N";
//      			rows.dft_db_nm = table_db.rows().data()[i].dft_db_nm;
//      		}   		 
//     		datasArr.push(rows);
// 		}

			$.ajax({
				url : "/insertTreeDB.do",
				data : {
					db_svr_id : db_svr_id,
					ipadr : ipadr,
					rows : JSON.stringify(datasArr)
				},
				async:true,
				//dataType : "json",
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
					showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success', "reload");
				}
			});	

}

/* ********************************************************
 * 서버에 등록된 디비,  <=>  Repository에 등록된 디비 비교
 ******************************************************** */
function fn_dataCompareChcek(svrDbList){
	var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;
	$.ajax({
		url : "/selectTreeDBList.do",
		data : {db_svr_id : db_svr_id},
		async:true,
		//dataType : "json",
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
			//DB목록 그리드의 설명 부분을 리스트로 가지고옴
			var list = $("input[name='db_exp']");
			
			//서버에서 가지고온 디비겟수가 적거나 같으면
			if(svrDbList.data.length >= result.length){
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
			}else{
				for(var i = 0; i<result.length; i++){				
					for(var j = 0; j<svrDbList.data.length; j++){
						if(result[i].db_nm == svrDbList.data[j].dft_db_nm){
							list[j].value = result[i].db_exp;
						}
						if(result[i].useyn == "Y"){
							//alert("["+i+"]"+result[i].db_nm+ "==["+j+"]"+ svrDbList.data[j].dft_db_nm);
							 if(db_svr_id == result[i].db_svr_id && result[i].db_nm == svrDbList.data[j].dft_db_nm){		
								 $('input', table_db.rows(i).nodes()).prop('checked', true); 
								 table_db.rows(i).nodes().to$().addClass('selected');	
							}
						}
					}
				}
			}
			
			
			
			
			

			

/* 			var list = $("input[name='db_exp']");
			//var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id
			if(svrDbList.data.length>0){
				for(var k=0; k<list.length; k++){
					list[k].value = result[k].db_exp;
				}		
 				for(var i = 0; i<svrDbList.data.length; i++){
					for(var j = 0; j<result.length; j++){						
							 $('input', table_db.rows(i).nodes()).prop('checked', false); 	
							 table_db.rows(i).nodes().to$().removeClass('selected');	
					}
				}	 	
 				for(var i = 0; i<svrDbList.data.length; i++){
					//var list = $("input[name='db_exp']");	
					for(var j = 0; j<result.length; j++){
						//list[j].value = result[j].db_exp;
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

 
	function fn_exeCheck(){
		var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;
		
		//실행중인 커넥터와 스케줄 확인
		$.ajax({
			url : "/exeCheck.do",
			data : {
				db_svr_id : db_svr_id,
			},
			async:true,
			//dataType : "json",
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
				if(result.connChk >0){
					showSwalIcon('<spring:message code="message.msg193" />', '<spring:message code="common.close" />', '', 'error');
				}else if(result.scheduleChk){
					showSwalIcon('<spring:message code="message.msg194" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					confile_title = '<spring:message code="migration.source/target_dbms_management" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
					$('#con_multi_gbn', '#findConfirmMulti').val("del");
					$('#confirm_multi_tlt').html(confile_title);
					$('#confirm_multi_msg').html('<spring:message code="message.msg206" />');
					$('#pop_confirm_multi_md').modal("show");
				}
			}
		});
	}
	
	function fn_delete(db_svr_id){	
		$.ajax({
			url : "/dbSvrDelete.do",
			data : {
				db_svr_id : db_svr_id,
			},
			async:true,
			//dataType : "json",
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
				showSwalIcon('<spring:message code="message.msg12"/>', '<spring:message code="common.close" />', '', 'success');
				fn_selectTreeDbServerList();
				table_db.clear().draw();
			}
		});
	}
	
function fn_dbSync(){	
	var datas = table_dbServer.rows('.selected').data().length;
	var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;

	if(datas == 0){
		showSwalIcon('<spring:message code="message.msg207" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		confile_title = '<spring:message code="dbms_information.Synchronization" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("db_sync");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg208" />');
		$('#pop_confirm_multi_md').modal("show");
	}
}	

function fn_dbSync2(){	
	var datas = table_dbServer.rows('.selected').data().length;
	var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;
			$.ajax({
				url : "/selectDBSync.do",
				data : {db_svr_id : db_svr_id},
				async:true,
				//dataType : "json",
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
					var arr = [];										
						for(var i = 0; i<result.length; i++){			
							var chk = 0;
							for(var j = 0; j<severdb.data.length; j++){	
								if(result[i].db_nm == severdb.data[j].dft_db_nm){									
									chk += 1;
								}							
							}
							if(chk == 0){
								arr.push(result[i].db_id);
							}	
					}					
					fn_syncUpdate(JSON.stringify(arr));
				}
			})
}

function fn_syncUpdate(db_id){
	$.ajax({
		url : "/syncUpdate.do",
		data : {
			db_id : db_id,
		},
		async:true,
		//dataType : "json",
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
			showSwalIcon('<spring:message code="message.msg212"/>', '<spring:message code="common.close" />', '', 'success');
		}
	});
}


/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "del") {
		var db_svr_id =  table_dbServer.row('.selected').data().db_svr_id;
		fn_delete(db_svr_id);
	}else if(gbn =="ins_DB"){
		fn_insertDB2()
	}else if(gbn =="db_sync"){
		fn_dbSync2();
	}else if(gbn =="ins_DBServer"){
		fn_insertDbServer2();		
	}else if(gbn =="mod_DBServer"){
		fn_updateDbServer2();
	}
}
</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/dbServerRegForm.jsp"%>
<%@include file="./../../popup/dbServerRegReForm.jsp"%>
<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom:0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
<!-- 												<i class="fa fa-check-square"></i> -->
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.dbms_registration" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.dbms_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.dbms_registration"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.dbms_registration_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_registration_02" /></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- title end -->
				</div>
			</div>
		</div>
		
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="dbms_information.dbms_list" />
					</h4>
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="wrt_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_reg_popup();">
								<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_regRe_popup();">
								<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_exeCheck()">
								<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
							</button>
						</div>

						<table id="dbServerList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"><spring:message code="common.choice" /></th>									
									<th width="200"><spring:message code="dbms_information.dbms_ip" /></th>
									<th width="130"><spring:message code="common.dbms_name" /></th>
									<th width="50"><spring:message code="dbms_information.agent_status" /></th>
									<th width="50"><spring:message code="dbms_information.use_yn" /></th>
									<!-- <th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th> -->
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="dbms_information.databaseList"/>
					</h4>
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div id="save_button" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_insertDB()">
								<i class="ti-import btn-icon-prepend "></i><spring:message code="common.save" />
							</button>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_dbSync()">
								<i class="ti-reload btn-icon-prepend "></i><spring:message code="dbms_information.Synchronization" />
							</button>
						</div>

						<table id="dbList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"><input name="select" value="1" type="checkbox"></th>
									<th width="110"><spring:message code="common.database" /></th>
									<th width="360"><spring:message code="common.desc" /></th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>