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
	var dbTable = null;
	var dbServerTable = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			scrollY : "378px",
			searching : false,
			paging : false,
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
		
		dbTable = $('#db').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
	}

	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectDBAutUserManager.do",
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
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
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {	
				var parseData = $.parseJSON(result);
			 	var html1 = "";
			 	html1+='<table class="db_table">';
				html1+='<caption>DB서버 권한</caption>';
				html1+='<colgroup>';
				html1+=	'<col style="width:70%" />';
				html1+=	'<col style="width:30%" />';
				html1+='</colgroup>';
				html1+='<thead>';
				html1+=	'<tr>';
				html1+=		'<th scope="col">DB서버 권한</th>';
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
					html1+='				<input type="checkbox" id="'+item.db_svr_nm+'_bck_cng" name="'+item.db_svr_nm+'_bck_cng"  />';
					html1+='       		<label for="db_server_1_1"></label>';
					html1+='			</div>';
					html1+='		</td>';
					html1+='	</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">백업이력</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_bck_hist" name="'+item.db_svr_nm+'_bck_hist"  />';
					html1+=			'<label for="db_server_1_2"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">서버접근제어</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_acs_cntr" name="'+item.db_svr_nm+'_acs_cntr"  />';
					html1+=			'<label for="db_server_1_3"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">감사설정</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_cng" name="'+item.db_svr_nm+'_adt_cng" />';
					html1+=			'<label for="db_server_1_4"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>';
					html1+='<tr>';
					html1+=	'<th scope="row">감사이력</th>';
					html1+=	'<td>';
					html1+=		'<div class="inp_chk">';
					html1+=			'<input type="checkbox" id="'+item.db_svr_nm+'_adt_hist" name="'+item.db_svr_nm+'_adt_hist" />';
					html1+=			'<label for="db_server_1_4"></label>';
					html1+=		'</div>';
					html1+=	'</td>';
					html1+='</tr>	';	
					html1+='</tbody>';
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
		         * 선택된 유저 대한 메뉴권한 조회
		        ******************************************************** */
 		     	$.ajax({
		    		url : "/selectUsrDBSrvAutInfo.do",
		    		data : {
		    			usr_id: usr_id,			
		    		},
		    		dataType : "json",
		    		type : "post",
		    		error : function(xhr, status, error) {
		    			alert("실패")
		    		},
		    		success : function(result) {
	       	 		 	for(var i = 0; i<result.length; i++){  
	      	 			      	 				
		     					//백업설정 권한
		  						if(result[i].bck_cng_aut_yn == "Y"){	  									
		  							document.getElementById(result[i].db_svr_nm+"_bck_cng").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_bck_cng").checked = false;
		  						}
		
		  						//백업이력 권한
		  						if(result[i].bck_hist_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_bck_hist").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_bck_hist").checked = false;
		  						}
		  						
		  						//서버접근제어 권한
		  						if(result[i].acs_cntr_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_acs_cntr").checked = false;
		  						}
		  						
		  						//감사설정 권한
		  						if(result[i].adt_cng_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_adt_cng").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_adt_cng").checked = false;
		  						}
		  						
		  						//감사이력 권한
		  						if(result[i].adt_hist_aut_yn == "Y"){
		  							document.getElementById(result[i].db_svr_nm+"_adt_hist").checked = true;
		  						}else{
		  							document.getElementById(result[i].db_svr_nm+"_adt_hist").checked = false;
		  						}
		  						
	    				}	   	   			
		    		} 
		    	});	 
		        
		    } );   
	} );
</script>



<body>
	<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>DB 권한 관리 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li class="on">DB 권한 관리</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="db_roll_grp">
								<div class="db_roll_lt">
									<div class="btn_type_01">
										<div class="search_area">
											<input type="text" class="txt search">
											<button class="search_btn">검색</button>
										</div>
									</div>
									<div class="inner">
										<p class="tit">사용자 선택</p>
										<div class="overflow_area">
											<table id="user" class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th>No</th>
														<th>아이디</th>
														<th>사용자명</th>
													</tr>
												</thead>
											</table>
										</div>
									</div>
								</div>
								
								
								<div class="db_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button>저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">DB서버 권한</p>
										<div class="overflow_area">
											<div id="svrAutList"></div>
										</div>
									</div>
								</div>
								
								
								
								<div class="db_roll_last">
									<div class="btn_type_01">
										<span class="btn"><button>저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">DB 권한</p>
										<div class="overflow_area">
											<table class="db_table">
												<caption>DB 권한</caption>
												<colgroup>
													<col style="width:70%" />
													<col style="width:30%" />
												</colgroup>
												<thead>
													<tr>
														<th scope="col">DB 권한</th>
														<th scope="col">권한</th>
													</tr>
												</thead>
												<tbody>
													<tr class="db_tit">
														<th scope="row">DB server 1</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_all" name="db_1_all" checked="checked" />
																<label for="db_1_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_1" name="db_1" checked="checked" />
																<label for="db_1_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_2" name="db_1" checked="checked" />
																<label for="db_1_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_3" name="db_1" checked="checked" />
																<label for="db_1_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_4" name="db_1" checked="checked" />
																<label for="db_1_4"></label>
															</div>
														</td>
													</tr>
													<tr class="db_tit">
														<th scope="row">DB server 2</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_all" name="db_2_all" checked="checked" />
																<label for="db_2_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_1" name="db_2" checked="checked" />
																<label for="db_2_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_2" name="db_2" checked="checked" />
																<label for="db_2_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_3" name="db_2" checked="checked" />
																<label for="db_2_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_4" name="db_2" checked="checked" />
																<label for="db_2_4"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_5" name="db_2" checked="checked" />
																<label for="db_2_5"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_6" name="db_2" checked="checked" />
																<label for="db_2_6"></label>
															</div>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->