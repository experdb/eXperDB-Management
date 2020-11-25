<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : dbServer.jsp
	* @Description : dbServer 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>

<script>
var table = null;

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#serverList').DataTable({	
		scrollY : "310px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "idx", className : "dt-center",  defaultContent : ""},
		{data : "db_svr_nm", defaultContent : ""},
		{data : "ipadr", defaultContent : ""},
		{data : "dft_db_nm", defaultContent : ""},
		{data : "portno", defaultContent : ""},
		{data : "svr_spr_usr_id", defaultContent : ""},
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
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""}
		]
	});
		

		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '65px');  
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	    $(window).trigger('resize'); 
}



     

/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	fn_init2();
	fn_init3();
	
  	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {},
		dataType : "json",
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
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
  	
  	
  	$(function() {	
  		$('#serverList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
  	
  	
 
});


function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	var int_button = document.getElementById("int_button"); 
	var mdf_button = document.getElementById("mdf_button"); 
	var del_button = document.getElementById("del_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		mdf_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		mdf_button.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
}

/* ********************************************************
 * 서버리스트 조회 (검색조건 입력)
 ******************************************************** */
function fn_search(){
	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {
			db_svr_nm : $("#init_db_svr_nm").val(),
			ipadr : $("#init_ipadr").val(),
			dft_db_nm : $("#init_dft_db_nm").val(),
			useyn: $("#useyn").val()
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
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}


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
	var datas = table.rows('.selected').data();
	if (datas.length == 1) {
	    $.ajax({
			url : "/selectIpadrList.do",
			data : {
				db_svr_id : table.row('.selected').data().db_svr_id
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
						db_svr_id : table.row('.selected').data().db_svr_id
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
		
// 		var db_svr_id = table.row('.selected').data().db_svr_id;
// 		var popUrl = "/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=server"; // 서버 url 팝업경로
// 		var width = 1000;
// 		var height = 660;
// 		var left = (window.screen.width / 2) - (width / 2);
// 		var top = (window.screen.height /2) - (height / 2);
// 		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
// 		window.open(popUrl,"",popOption);
		
// 		window.open("/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=server","dbServerRegRePop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=950,height=638,top=0,left=0");
	} else {
		showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
	}	
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if(gbn =="ins_DBServer"){
		fn_insertDbServer2();		
	}else if(gbn =="mod_DBServer"){
		fn_updateDbServer2();
	}
}
</script>
<%@include file="./../../popup/dbServerRegForm.jsp"%>
<%@include file="./../../popup/dbServerRegReForm.jsp"%>
<%@include file="./../../popup/confirmMultiForm.jsp" %>

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
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.dbms_management" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.dbms_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.dbms_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.dbms_management_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_management_02" /></p>
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

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px -10px;">
							<div class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" maxlength="100" style="margin-right: -0.7rem;" name="init_db_svr_nm" id="init_db_svr_nm"  placeholder='<spring:message code="common.dbms_name" />'/>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" maxlength="100" style="margin-right: -0.7rem;" name="init_ipadr" id="init_ipadr" placeholder='<spring:message code="dbms_information.dbms_ip" />'/>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" maxlength="100" style="margin-right: -0.7rem;" name="init_dft_db_nm" id="init_dft_db_nm" placeholder='<spring:message code="common.database" />'/>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
	 								<select class="form-control" id="useyn" >
										<option value="%"><spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /> </option>
	 								</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search()" id="read_button" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-lg-12 grid-margin stretch-card">
		  <div class="card">
		    <div class="card-body">
		    	<div class="row" style="margin-top:-20px;">
					<div class="col-12">
						<div class="template-demo">	
							<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_regRe_popup();" id="mdf_button" data-toggle="modal">
								<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
							</button>
							<button type="button" class="btn btn-outline-primary btn-icon-text float-right" onclick="fn_reg_popup();" id="int_button" data-toggle="modal">
								<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
							</button>
						</div>
					</div>
				</div>
				
				<div class="table-responsive">
					<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
						<div class="row">
							<div class="col-sm-12 col-md-6">
								<div class="dataTables_length" id="order-listing_length">
								</div>
								</div>
						</div>
					</div>
				</div>

		      	<table id="serverList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
					<thead>
						<tr class="bg-info text-white">
							<th width="30"><spring:message code="common.no" /></th>
							<th width="130"><spring:message code="common.dbms_name" /></th>
							<th width="100"><spring:message code="dbms_information.dbms_ip"/></th>
							<th width="130"><spring:message code="common.database" /></th>
							<th width="70"><spring:message code="data_transfer.port" /></th>
							<th width="70"><spring:message code="dbms_information.account" /></th>
							<th width="70"><spring:message code="dbms_information.use_yn" /></th>
							<th width="65"><spring:message code="common.register" /></th>
							<th width="100"><spring:message code="common.regist_datetime" /></th>
							<th width="65"><spring:message code="common.modifier" /></th>
							<th width="100"><spring:message code="common.modify_datetime" /></th>
						</tr>
					</thead>
				</table>

		    </div>
		  </div>
		</div>		
		
	</div>
</div>