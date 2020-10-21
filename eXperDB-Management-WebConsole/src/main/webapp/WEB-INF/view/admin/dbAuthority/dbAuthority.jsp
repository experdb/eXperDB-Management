<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : dbAuthority.jsp
	* @Description : DbAuthority 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.29     최초 생성
	*
	* author 변승우 사원
	* since 2017.05.29
	*
	*/
%>
<script>
var confirm_title = ""; 

	var userTable = null;
	var dbTable = null;
	var dbServerTable = null;
	var svr_server = null;
	var db = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			scrollY : "500px",
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			columns : [ 
			            {data : "rownum", className : "dt-center", defaultContent : ""}, 
			            {data : "usr_id", defaultContent : ""}, 
			            {data : "usr_nm", defaultContent : ""} 
			          ]
		});
			
		dbTable = $('#db').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "", defaultContent : ""}, 
			            {data : "", defaultContent : ""} 
			          ]
		});
		
		
		userTable.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		userTable.tables().header().to$().find('th:eq(1)').css('min-width', '90px');
		userTable.tables().header().to$().find('th:eq(2)').css('min-width', '90px');

	    $(window).trigger('resize'); 	
		
	}
	
	function fn_buttonAut(){
		var db_button = document.getElementById("db_button"); 
		
		if("${wrt_aut_yn}" == "Y"){
			db_button.style.display = '';
		}else{
			db_button.style.display = 'none';
		}
	}

	$(window.document).ready(function() {
		fn_buttonAut();		
		fn_init();
		
		$.ajax({
			url : "/selectDBAutUserManager.do",
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
				userTable.clear().draw();
				userTable.rows.add(result).draw();
			}
		});
		
		$.ajax({
			url : "/selectDBSrvAutInfo.do",
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
				svr_server = result;
				fn_dbAutInfo();
			}
		});
		

		function fn_dbAutInfo(){
			$.ajax({
				url : "/selectDBAutInfo.do",
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
					db=result;
					fn_dbAut(svr_server, result);
				}
			});
		}

		
 		function fn_dbAut(svr_server, result){
		 	var html2 = "";
		 	html2+='<table class="table">';
			html2+='<colgroup>';
			html2+=	'<col style="width:70%" />';
			html2+=	'<col style="width:30%" />';
			html2+='</colgroup>';
			html2+='<thead>';
			html2+=	'<tr class="bg-info text-white">';
			html2+=		'<th scope="col"><spring:message code="auth_management.db_auth" /> </th>';
			html2+=		'<th scope="col"><spring:message code="auth_management.auth" /></th>';
			html2+=	'</tr>';
			html2+='</thead>';
 			$(svr_server).each(function (index, item) {
				var array = new Array();
				for(var i = 0; i<result.length; i++){
					if(item.db_svr_nm == result[i].db_svr_nm){
						array.push(result[i].db_id);
					}
				}
				
				html2+='<tbody>';
				html2+='<tr class="bg-primary text-white">';
				html2+='		<td>'+item.db_svr_nm+'</td>';
				html2+='		<td><div class="inp_chk"><input type="checkbox" id="'+item.db_svr_id+'" onClick="fn_allCheck(\''+item.db_svr_id+'\', \''+ array+'\');">';
				html2+='		<label for="'+item.db_svr_id+'"></lavel></div></td>';
				html2+='	</tr>';
				
				for(var i = 0; i<result.length; i++){
					if(item.db_svr_nm == result[i].db_svr_nm){
						html2+='	<tr>';
						html2+='		<td class="pl-4">'+result[i].db_nm+'</td>';
						html2+='		<td>';
						html2+='			<div class="inp_chk">';
						html2+='				<input type="checkbox" id="'+result[i].db_svr_id+'_'+result[i].db_id+'" value="'+result[i].db_svr_id+'_'+result[i].db_id+'" name="aut_yn" onClick="fn_userCheck();" />';
						html2+='       		<label for="'+result[i].db_svr_id+'_'+result[i].db_id+'"></label>';
						html2+='			</div>';
						html2+='		</td>';
						html2+='	</tr>';
						html2+='<tr>';
					}
					html2+='<input type="hidden"  name="db_svr_id"  value="'+result[i].db_svr_id+'">';
					html2+='<input type="hidden"  name="db_id"  value="'+result[i].db_id+'">';
				}
				html2+='</tbody>';
	
			})		
			html2+='</table>';
			$( "#dbAutList" ).append(html2);
		}	
	});

	function fn_userCheck(){
		var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			 $("input[type=checkbox]").prop("checked",false);
			 return false;
		 }
	}
	
	function fn_allCheck(db_svr_id,db_id){
		fn_userCheck();
		var strArray = db_id.split(',');
		if ($("#"+db_svr_id).prop("checked")) {
			for(var i=0; i<strArray.length; i++){
				document.getElementById(db_svr_id+'_'+strArray[i]).checked = true;
			}
		}else{
			for(var i=0; i<strArray.length; i++){
				document.getElementById(db_svr_id+'_'+strArray[i]).checked = false;
			}
		}
		
	}
	
	$(function() {
		   $('#user tbody').on( 'click', 'tr', function () {
		         if ( $(this).hasClass('selected') ) {
		        	}
		        else {	        	
		        	userTable.$('tr.selected').removeClass('selected');
		            $(this).addClass('selected');	            
		        } 

		         var usr_id = userTable.row('.selected').data().usr_id;
		         
		        
		        /* ********************************************************
		         * 선택된 유저 대한 디비권한 조회
		        ******************************************************** */
 		     	$.ajax({
		    		url : "/selectUsrDBAutInfo.do",
		    		data : {
		    			usr_id: usr_id,			
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
		    			if(result.length != 0){
		       	 		 	for(var i = 0; i<result.length; i++){     	
			  						if(result[i].aut_yn == "Y"){	  									
			  							document.getElementById(result[i].db_svr_id+'_'+result[i].db_id).checked = true;
			  						}else{
			  							document.getElementById(result[i].db_svr_id+'_'+result[i].db_id).checked = false;
			  						}		
		    				}	
		    			}else{
		    				for(var j = 0; j<db.length; j++){ 
		    					document.getElementById(db[j].db_svr_id+'_'+db[j].db_id).checked = false;
		    				}
		    			}	
		    		} 
		    	});	 	 
		    } );   
	} );
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "ins") {
			fn_db_save2();
		}
	}
	
 	function fn_db_save(){
		 var datasArr = new Array();	
		 var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
			 return false;
		 }else{
				confile_title = '<spring:message code="menu.database_auth_management" />' + " "+'<spring:message code="common.registory" />' + " " + '<spring:message code="common.request" />';
				$('#con_multi_gbn', '#findConfirmMulti').val("ins");
				$('#confirm_multi_tlt').html(confile_title);
				$('#confirm_multi_msg').html('<spring:message code="message.msg167" />');
				$('#pop_confirm_multi_md').modal("show");
		 }
	}
 	
 	function fn_db_save2(){
		 var datasArr = new Array();	
		 var datas = userTable.row('.selected').length;
		var usr_id = userTable.row('.selected').data().usr_id;

			 $('input:checkbox[name=aut_yn]').each(function() {
		         if($(this).is(':checked')){
		        	var value=$(this).val();
	 			    var strArray = value.split('_');
	 			    var datas = new Object();
	 			    datas.usr_id = usr_id;
	 			    datas.db_svr_id = strArray[0];
	 	 			datas.db_id = strArray[1];
	 	 			datas.aut_yn = "Y";
		         }else{
			        var value=$(this).val();
		 			var strArray = value.split('_');
		 			var datas = new Object();
		 			datas.usr_id = usr_id;
		 			datas.db_svr_id = strArray[0];
		 	 		datas.db_id = strArray[1];
		 	 		datas.aut_yn = "N";
		         }
		         datasArr.push(datas);
		     });

			 
//			 var db_svr_id = $("input[name='db_svr_id']");
//			 var db_id = $("input[name='db_id']");
//			 var aut_yn = $("input[name='aut_yn']");
//			 console.log(aut_yn);
//	 		 for(var i = 0; i < aut_yn.length; i++){
//	 			 var datas = new Object();
//				 datas.usr_id = usr_id;
//			     datas.db_svr_id = db_svr_id[i].value;
//			     datas.db_id = db_id[i].value;		  
			     
//			     if(aut_yn[i].checked){ //선택되어 있으면 배열에 값을 저장함
//			        	datas.aut_yn = "Y";   
//			        }else{
//			        	datas.aut_yn = "N";
//			        }		     
//			     datasArr.push(datas);
//			     console.log(datas);
//			 } 

				$.ajax({
					url : "/updateUsrDBAutInfo.do",
					data : {
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
						showSwalIcon('<spring:message code="message.msg07"/>', '<spring:message code="common.close" />', '', 'success');
					}
				}); 	
			
	}
	
 	//유저조회버튼 클릭시
 	function fn_search(){
 		$.ajax({
 			url : "/selectMenuAutUserManager.do",
 			data : {
 				type : "usr_id",
 				search : "%" + $("#search").val() + "%",
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
 				userTable.clear().draw();
 				userTable.rows.add(result).draw();
 			}
 		});
 	} 	
</script>
<body>
<%@include file="./../../popup/confirmMultiForm.jsp"%>

<div class="content-wrapper main_scroll" id="contentsDiv">
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
												<span class="menu-title"><spring:message code="menu.database_auth_management" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.auth_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.database_auth_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.database_auth_management" /></p>
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
				<div class="card-body" style=" height: 100%;">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i>
						<spring:message code="auth_management.user_choice" />
					</h4>
					
					<div class="row" >
						<div class="col-3"></div>
						<div class="col-6">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;margin-right:-5rem;">
									<input hidden="hidden" />
									<input type="text" class="form-control" style="width:250px;" id="search">&nbsp;&nbsp;
								</form>
							</div>
						</div>
						<div class="col-3">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;">
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search()">
										<i class="ti-search btn-icon-prepend "></i><spring:message code="button.search" />
									</button>
								</form>
							</div>
						</div>
					</div>

					<table id="user" class="table table-hover table-striped" style="width:100%;">
						<thead>
							<tr class="bg-info text-white">
								<th width="20"><spring:message code="common.no"/></th>
								<th width="90"><spring:message code="user_management.id" /></th>
								<th width="90"><spring:message code="user_management.user_name" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
            
		<div class="col-lg-6 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i>
						<spring:message code="auth_management.db_auth" />
					</h4>
					<div class="table-responsive">
						<form class="form-inline" style="float: right;">
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="db_button" onClick="fn_db_save()">
								<i class="ti-import btn-icon-prepend "></i><spring:message code="common.save"/>
							</button>
						</form>
					</div>	
					
					<div id="dbAutList" style="height: 580px;overflow-y:auto;"></div>
					
				</div>
			</div>
		</div>
	</div>
</div>