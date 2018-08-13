<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs.jsp"%>

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
	var userTable = null;
	var dbServerTable = null;
	var svr_server = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			scrollY : "370px",
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [ 
			            {data : "rownum", className : "dt-center", defaultContent : ""}, 
			            {data : "usr_id", defaultContent : ""}, 
			            {data : "usr_nm", defaultContent : ""} 
			          ]
		});
		
		dbServerTable = $('#dbserver').DataTable({
			searching : false,
			paging : false,
			bSort: false,
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
		var server_button = document.getElementById("server_button"); 
		
		if("${wrt_aut_yn}" == "Y"){
			server_button.style.display = '';
		}else{
			server_button.style.display = 'none';
		}
	}

	$(window.document).ready(function() {
		fn_buttonAut();		
		fn_init();
		
		$.ajax({
			url : "/selectDBSvrAutUserManager.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
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
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {	
				svr_server = result;
				var parseData = $.parseJSON(result);
			 	var html1 = "";
			 	html1+='<table class="db_table">';
				html1+='<caption>DB서버 메뉴</caption>';
				html1+='<colgroup>';
				html1+=	'<col style="width:70%" />';
				html1+=	'<col style="width:30%" />';
				html1+='</colgroup>';
				html1+='<thead>';
				html1+=	'<tr>';
				html1+=		'<th scope="col"><spring:message code="auth_management.db_server_menu" /></th>';
				html1+=		'<th scope="col"><spring:message code="auth_management.auth" /></th>';
				html1+=	'</tr>';
				html1+='</thead>';
	 			$(result).each(function (index, item) {
					//var html = "";
 					html1+='<tbody>';
					html1+='<tr class="db_tit">';
					html1+='		<th scope="row">'+item.db_svr_nm+'</th>';
					html1+='		<td><div class="inp_chk"><input type="checkbox" id="'+item.db_svr_nm+'" onClick="fn_allCheck(\''+item.db_svr_nm+'\');">';
					html1+='		<label for="'+item.db_svr_nm+'"></lavel></div></td>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<th scope="row"><spring:message code="menu.backup_settings" /></th>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_nm+'_bck_cng" name="bck_cng_aut" onClick="fn_userCheck();"/>';
					html1+='       		<label for="'+item.db_svr_nm+'_bck_cng"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.backup_history" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_bck_hist" name="bck_hist_aut" onClick="fn_userCheck();" />';
					html1+=			'<label for="'+item.db_svr_nm+'_bck_hist"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.backup_scheduler" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_bck_scdr" name="bck_scdr_aut" onClick="fn_userCheck();" />';
					html1+=			'<label for="'+item.db_svr_nm+'_bck_scdr"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.access_control" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_acs_cntr" name="acs_cntr_aut" onClick="fn_userCheck();" />';
					html1+=			'<label for="'+item.db_svr_nm+'_acs_cntr"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.policy_changes_history" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_policy_change_his" name="policy_change_his_aut" onClick="fn_userCheck();" />';
					html1+=			'<label for="'+item.db_svr_nm+'_policy_change_his"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					
					if("${sessionScope.session.pg_audit}"== "Y"){
						html1+='<tr>';
						html1+=	'<th scope="row"><spring:message code="menu.audit_settings" /></th>';
						html1+=	'<td>';
						html1+=		'<div class="inp_chk">';
						html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_cng" name="adt_cng_aut" onClick="fn_userCheck();"/>';
						html1+=			'<label for="'+item.db_svr_nm+'_adt_cng"></label>';
						html1+=		'</div>';
						html1+=	'</td>';
						html1+='</tr>';
						html1+='<tr>';
						html1+=	'<th scope="row"><spring:message code="menu.audit_history" /></th>';
						html1+=	'<td>';
						html1+=		'<div class="inp_chk">';
						html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_hist" name="adt_hist_aut"  onClick="fn_userCheck();"/>';
						html1+=			'<label for="'+item.db_svr_nm+'_adt_hist"></label>';
						html1+=		'</div>';
						html1+=	'</td>';
						html1+='</tr>	';			
					}
					
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.script_settings" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_script_cng" name="script_cng_aut"  onClick="fn_userCheck();"/>';
					html1+=			'<label for="'+item.db_svr_nm+'_script_cng"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>	';	
					html1+='<tr>';
					html1+=	'<th scope="row"><spring:message code="menu.script_history" /></th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_script_his" name="script_his_aut"  onClick="fn_userCheck();"/>';
					html1+=			'<label for="'+item.db_svr_nm+'_script_his"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>	';	
					
					
					html1+='</tbody>';
					html1+='<input type="hidden"  name="db_svr_id" value="'+item.db_svr_id+'">';
				})		
				html1+='</table>';
				$( "#svrAutList" ).append(html1);
			}			
		});
	});
		
	function fn_userCheck(){
		var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 alert("<spring:message code='message.msg165'/>");
			 $("input[type=checkbox]").prop("checked",false);
			 return false;
		 }
	}
	
	function fn_allCheck(db_svr_nm){
		fn_userCheck();
		var array = new Array("_bck_cng","_bck_hist","_bck_scdr","_acs_cntr","_policy_change_his","_adt_cng","_adt_hist","_script_cng","_script_his");
		for(var i=0; i<array.length; i++){
			if ($("#"+db_svr_nm).prop("checked")) {
					document.getElementById(db_svr_nm+array[i]).checked = true;
			}else{
					document.getElementById(db_svr_nm+array[i]).checked = false;
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
		         		         
		         if (svr_server.length == 0){
		        	 alert("<spring:message code='message.msg214'/>");
		        	 return false;
		         }
		         
		        /* ********************************************************
		         * 선택된 유저 대한 디비서버권한 조회
		        ******************************************************** */
 		     	$.ajax({
		    		url : "/selectUsrDBSrvAutInfo.do",
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
		    				alert("<spring:message code='message.msg02' />");
		    				top.location.href = "/";
		    			} else if(xhr.status == 403) {
		    				alert("<spring:message code='message.msg03' />");
		    				top.location.href = "/";
		    			} else {
		    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
		    			}
		    		},
		    		success : function(result) {
		    			if(result.length != 0){
	       	 		 		for(var i = 0; i<result.length; i++){  
		     					//백업설정 권한
		  						if(result.length != 0 && result[i].bck_cng_aut_yn == "Y"){	  									
		  							document.getElementById(result[i].db_svr_nm+"_bck_cng").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_bck_cng").checked = false;
		  						}
		
		  						//백업이력 권한
		  						if(result.length != 0 && result[i].bck_hist_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_bck_hist").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_bck_hist").checked = false;
		  						}
		  						
		  						//백업스케줄러 권한
		  						if(result.length != 0 && result[i].bck_scdr_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_bck_scdr").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_bck_scdr").checked = false;
		  						}
		  						
		  						//서버접근제어 권한
		  						if(result.length != 0 && result[i].acs_cntr_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = false;
		  						}
		  						
		  						//정책변경이력 권한
		  						if(result.length != 0 && result[i].policy_change_his_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_policy_change_his").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_policy_change_his").checked = false;
		  						}
		  						
		  						if("${sessionScope.session.pg_audit}"== "Y"){
			  						//감사설정 권한
			  						if(result.length != 0 && result[i].adt_cng_aut_yn == "Y"){
			  							document.getElementById(result[i].db_svr_nm+"_adt_cng").checked = true;
			  						}else{
			  							document.getElementById(result[i].db_svr_nm+"_adt_cng").checked = false;
			  						}		  						
			  						//감사이력 권한
			  						if(result.length != 0 && result[i].adt_hist_aut_yn == "Y"){
			  							document.getElementById(result[i].db_svr_nm+"_adt_hist").checked = true;
			  						}else{
			  							document.getElementById(result[i].db_svr_nm+"_adt_hist").checked = false;
			  						}		  	
		  						}
		  						
		  						//스크립트설정 권한
		  						if(result.length != 0 && result[i].script_cng_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_script_cng").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_script_cng").checked = false;
		  						}	
		  						
		  						//스크립트설정 권한
		  						if(result.length != 0 && result[i].script_his_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_script_his").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_script_his").checked = false;
		  						}	
	    					} 
		    			}else{
		    				document.getElementById(svr_server[0].db_svr_nm+"_bck_cng").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_bck_hist").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_bck_scdr").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_acs_cntr").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_policy_change_his").checked = false;
		    				if("${sessionScope.session.pg_audit}"== "Y"){
		    					document.getElementById(svr_server[0].db_svr_nm+"_adt_cng").checked = false;
			    				document.getElementById(svr_server[0].db_svr_nm+"_adt_hist").checked = false;
		    				}
		    				document.getElementById(svr_server[0].db_svr_nm+"_script_cng").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_script_his").checked = false;
    					}	
		    		} 
		    	});	 	 	   	 
		    } );   
	} );
	
	
	
 	function fn_svr_save(){
		 var datasArr = new Array();	
		 var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 alert("<spring:message code='message.msg165'/>");
			 return false;
		 }else{
			 var usr_id = userTable.row('.selected').data().usr_id;
			 
			 var db_svr_id = $("input[name='db_svr_id']");
			 var bck_cng_aut = $("input[name='bck_cng_aut']");
			 var bck_hist_aut = $("input[name='bck_hist_aut']");
			 var bck_scdr_aut = $("input[name='bck_scdr_aut']");
			 var acs_cntr_aut = $("input[name='acs_cntr_aut']");
			 var policy_change_his_aut = $("input[name='policy_change_his_aut']");
			 var adt_cng_aut = $("input[name='adt_cng_aut']");
			 var adt_hist_aut = $("input[name='adt_hist_aut']");
			 var script_cng_aut = $("input[name='script_cng_aut']");
			 var script_his_aut = $("input[name='script_his_aut']");
			 
			 
	 		 for(var i = 0; i < svr_server.length; i++){
	 			var autCheck = 0;
				 var rows = new Object();
				 rows.usr_id = usr_id;
				 rows.db_svr_id = db_svr_id[i].value;
			    		     
			     if(bck_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.bck_cng_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.bck_cng_aut_yn = "N";
			        }
			     
			     if(bck_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    		rows.bck_hist_aut_yn = "Y"; 
			    		autCheck++;
			        }else{
			        	rows.bck_hist_aut_yn = "N";
			        }
			     
			     if(bck_scdr_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    		rows.bck_scdr_aut_yn = "Y"; 
			    		autCheck++;
			        }else{
			        	rows.bck_scdr_aut_yn = "N";
			        }
			     
			     if(acs_cntr_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.acs_cntr_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.acs_cntr_aut_yn = "N";
			        }
			     
			     if(policy_change_his_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.policy_change_his_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.policy_change_his_aut_yn = "N";
			        }
			     
			     if(adt_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.adt_cng_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.adt_cng_aut_yn = "N";
			        }
			     
			     if(adt_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.adt_hist_aut_yt = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.adt_hist_aut_yt = "N";
			        }
			     
			     if(script_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.script_cng_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.script_cng_aut_yn = "N";
			        }
			     
			     if(script_his_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.script_his_aut_yn = "Y";   
			    	 	autCheck++;
			        }else{
			        	rows.script_his_aut_yn = "N";
			        }
			     datasArr.push(rows);
			     
			     
			     /*DB서버 메뉴권한이 있으면 해당 DB서버 DB권한 가지기*/
			     if(autCheck > 0){
			    	 $.ajax({
							url : "/updateServerDBAutInfo.do",
							data : {
								db_svr_id : rows.db_svr_id,
								usr_id : rows.usr_id
							},
							dataType : "json",
							type : "post",
							beforeSend: function(xhr) {
						        xhr.setRequestHeader("AJAX", true);
						     },
							error : function(xhr, status, error) {
								if(xhr.status == 401) {
									alert("<spring:message code='message.msg02' />");
									top.location.href = "/";
								} else if(xhr.status == 403) {
									alert("<spring:message code='message.msg03' />");
									top.location.href = "/";
								} else {
									alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
								}
							},
							success : function(result) {
							}
						}); 
			     }
			     
			     
					
			 } 
		 }
		 
		 
			if (confirm('<spring:message code="message.msg166"/>')){
				$.ajax({
					url : "/updateUsrDBSrvAutInfo.do",
					data : {
						datasArr : JSON.stringify(datasArr)
					},
					dataType : "json",
					type : "post",
					beforeSend: function(xhr) {
				        xhr.setRequestHeader("AJAX", true);
				     },
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							alert("<spring:message code='message.msg02' />");
							top.location.href = "/";
						} else if(xhr.status == 403) {
							alert("<spring:message code='message.msg03' />");
							top.location.href = "/";
						} else {
							alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
						}
					},
					success : function(result) {
						alert("<spring:message code='message.msg07' />");
					}
				}); 	
			}else{
				return false;
			}
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
 					alert("<spring:message code='message.msg02' />");
 					top.location.href = "/";
 				} else if(xhr.status == 403) {
 					alert("<spring:message code='message.msg03' />");
 					top.location.href = "/";
 				} else {
 					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
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
	<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4><spring:message code="menu.server_auth_management" /> <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.server_auth_management" /></li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.auth_management" /></li>
								<li class="on"><spring:message code="menu.server_auth_management" /></li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="db_roll_grp">
								<div class="db_roll_lt">
									<div class="btn_type_01">
										<div class="search_area">
											<input type="text" class="txt search" id="search">
											<button type="button" class="search_btn" onClick="fn_search()"><spring:message code="button.search" /></button>
										</div>
									</div>
									<div class="inner">
										<p class="tit"><spring:message code="auth_management.user_choice" /></p>
										<div class="overflow_area">
											<table id="user" class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th width="20"><spring:message code="common.no"/></th>
														<th width="90"><spring:message code="user_management.id" /></th>
														<th width="90"><spring:message code="user_management.user_name" /></th>
													</tr>
												</thead>
											</table>
										</div>
									</div>
								</div>
								
								
								<div class="db_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button type="button" onClick="fn_svr_save();" id="server_button"><spring:message code="common.save"/></button></span>
									</div>
									<div class="inner">
										<p class="tit"><spring:message code="auth_management.db_server_menu_auth_mng" /></p>
										<div class="overflow_area">
											<div id="svrAutList"></div>
										</div>
									</div>
								</div>
								
								
								

							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->