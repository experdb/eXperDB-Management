<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			scrollY : "378px",
			scrollX: true,	
			searching : false,
			paging : false,
			deferRender : true,
			columns : [ 
			            {data : "rownum",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_id",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_nm",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
		dbServerTable = $('#dbserver').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
			          ]
		});	
		
		
		userTable.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		userTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
		userTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');

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
				html1+=		'<th scope="col">DB서버 메뉴</th>';
				html1+=		'<th scope="col">권한</th>';
				html1+=	'</tr>';
				html1+='</thead>';
	 			$(result).each(function (index, item) {
					//var html = "";
 					html1+='<tbody>';
					html1+='<tr class="db_tit">';
					html1+='		<th scope="row" colspan="2">'+item.db_svr_nm+'</th>';
					html1+='	</tr>';
					html1+='	<tr>';
					html1+='		<th scope="row">백업설정</th>';
					html1+='		<td>';
					html1+='			<div class="inp_chk">';
					html1+='				<input type="checkbox" id="'+item.db_svr_nm+'_bck_cng" name="bck_cng_aut"  />';
					html1+='       		<label for="'+item.db_svr_nm+'_bck_cng"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">백업이력</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_bck_hist" name="bck_hist_aut"  />';
					html1+=			'<label for="'+item.db_svr_nm+'_bck_hist"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">접근제어</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_acs_cntr" name="acs_cntr_aut"  />';
					html1+=			'<label for="'+item.db_svr_nm+'_acs_cntr"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">감사설정</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_cng" name="adt_cng_aut" />';
					html1+=			'<label for="'+item.db_svr_nm+'_adt_cng"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">감사이력</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_hist" name="adt_hist_aut" />';
					html1+=			'<label for="'+item.db_svr_nm+'_adt_hist"></label>';
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
		  						
		  						//서버접근제어 권한
		  						if(result.length != 0 && result[i].acs_cntr_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = false;
		  						}
		  						
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
		    			}else{
		    				document.getElementById(svr_server[0].db_svr_nm+"_bck_cng").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_bck_hist").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_acs_cntr").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_adt_cng").checked = false;
		    				document.getElementById(svr_server[0].db_svr_nm+"_adt_hist").checked = false;
    					}	
		    		} 
		    	});	 	 	   	 
		    } );   
	} );
	
	
	
 	function fn_svr_save(){
		 var datasArr = new Array();	
		 var datas = userTable.row('.selected').length;
		 if(datas != 1){
			 alert("선택된 유저가 없습니다.");
			 return false;
		 }else{
			 var usr_id = userTable.row('.selected').data().usr_id;
			 
			 var db_svr_id = $("input[name='db_svr_id']");
			 var bck_cng_aut = $("input[name='bck_cng_aut']");
			 var bck_hist_aut = $("input[name='bck_hist_aut']");
			 var acs_cntr_aut = $("input[name='acs_cntr_aut']");
			 var adt_cng_aut = $("input[name='adt_cng_aut']");
			 var adt_hist_aut = $("input[name='adt_hist_aut']");
			 
	 		 for(var i = 0; i < svr_server.length; i++){
				 var rows = new Object();
				 rows.usr_id = usr_id;
				 rows.db_svr_id = db_svr_id[i].value;
			    		     
			     if(bck_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.bck_cng_aut_yn = "Y";   
			        }else{
			        	rows.bck_cng_aut_yn = "N";
			        }
			     
			     if(bck_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    		rows.bck_hist_aut_yn = "Y";   
			        }else{
			        	rows.bck_hist_aut_yn = "N";
			        }
			     
			     if(acs_cntr_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.acs_cntr_aut_yn = "Y";   
			        }else{
			        	rows.acs_cntr_aut_yn = "N";
			        }
			     
			     if(adt_cng_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.adt_cng_aut_yn = "Y";   
			        }else{
			        	rows.adt_cng_aut_yn = "N";
			        }
			     
			     if(adt_hist_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
			    	 	rows.adt_hist_aut_yt = "Y";   
			        }else{
			        	rows.adt_hist_aut_yt = "N";
			        }
			     datasArr.push(rows);
			 } 
		 }
		 
			if (confirm("DB서버권한 설정 하시겠습니까?")){
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
						location.reload();
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
						<h4>서버권한관리 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li>사용자에게 각 데이터베이스 서버에서 수행할 수 있는 작업에 대하여 권한을 부여합니다.</li>
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li>권한관리</li>
								<li class="on">서버권한관리</li>
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
											<button class="search_btn" onClick="fn_search()">검색</button>
										</div>
									</div>
									<div class="inner">
										<p class="tit">사용자 선택</p>
										<div class="overflow_area">
											<table id="user" class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th width="30">No</th>
														<th width="100">아이디</th>
														<th width="100">사용자명</th>
													</tr>
												</thead>
											</table>
										</div>
									</div>
								</div>
								
								
								<div class="db_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button onClick="fn_svr_save();" id="server_button">저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">DB서버 메뉴권한 관리</p>
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