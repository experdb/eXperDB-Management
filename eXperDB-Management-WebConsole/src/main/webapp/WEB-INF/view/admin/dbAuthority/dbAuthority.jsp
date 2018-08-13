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
	var dbTable = null;
	var dbServerTable = null;
	var svr_server = null;
	var db = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			scrollY : "370px",
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
					db=result;
					fn_dbAut(svr_server, result);
				}
			});
		}

		
 		function fn_dbAut(svr_server, result){
		 	var html2 = "";
		 	html2+='<table class="db_table">';
			html2+='<caption>DB 권한</caption>';
			html2+='<colgroup>';
			html2+=	'<col style="width:70%" />';
			html2+=	'<col style="width:30%" />';
			html2+='</colgroup>';
			html2+='<thead>';
			html2+=	'<tr>';
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
				html2+='<tr class="db_tit">';
				html2+='		<th scope="row">'+item.db_svr_nm+'</th>';
				html2+='		<td><div class="inp_chk"><input type="checkbox" id="'+item.db_svr_id+'" onClick="fn_allCheck(\''+item.db_svr_id+'\', \''+ array+'\');">';
				html2+='		<label for="'+item.db_svr_id+'"></lavel></div></td>';
				html2+='	</tr>';
				
				for(var i = 0; i<result.length; i++){
					if(item.db_svr_nm == result[i].db_svr_nm){
						html2+='	<tr>';
						html2+='		<th scope="row">'+result[i].db_nm+'</th>';
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
			 alert("<spring:message code='message.msg165'/>");
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
	
	
 	function fn_db_save(){
		 var datasArr = new Array();	
		 var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 alert("<spring:message code='message.msg165'/>");
			 return false;
		 }else{
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

			 
// 			 var db_svr_id = $("input[name='db_svr_id']");
// 			 var db_id = $("input[name='db_id']");
// 			 var aut_yn = $("input[name='aut_yn']");
// 			 console.log(aut_yn);
// 	 		 for(var i = 0; i < aut_yn.length; i++){
// 	 			 var datas = new Object();
// 				 datas.usr_id = usr_id;
// 			     datas.db_svr_id = db_svr_id[i].value;
// 			     datas.db_id = db_id[i].value;		  
			     
// 			     if(aut_yn[i].checked){ //선택되어 있으면 배열에 값을 저장함
// 			        	datas.aut_yn = "Y";   
// 			        }else{
// 			        	datas.aut_yn = "N";
// 			        }		     
// 			     datasArr.push(datas);
// 			     console.log(datas);
// 			 } 

		 }
			if (confirm('<spring:message code="message.msg167"/>')){
				$.ajax({
					url : "/updateUsrDBAutInfo.do",
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
						<h4><spring:message code="menu.database_auth_management" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.database_auth_management" /> </li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.auth_management" /></li>
								<li class="on"><spring:message code="menu.database_auth_management" /></li>
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
								
								
								<div class="db_roll_last">
									<div class="btn_type_01">
										<span class="btn"><button type="button" onClick="fn_db_save();" id="db_button"><spring:message code="common.save"/></button></span>
									</div>
									<div class="inner">
										<p class="tit"><spring:message code="auth_management.db_auth" /></p>
										<div class="overflow_area">
											<div id="dbAutList"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->