<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : menuAuthority.jsp
	* @Description : MenuAuthority 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.08.07     최초 생성
	*
	* author 변승우 대리
	* since 2017.08.07
	*
	*/
%>
<script>
var userTable = null;
var menuTable = null;

function fn_init() {
	userTable = $('#user').DataTable({
		scrollY : "405px",
		processing : true,
		searching : false,
		paging: false,
		bSort: false,
		columns : [
		{data : "rownum", className : "dt-center", defaultContent : ""}, 
		{data : "usr_id", className : "dt-center", defaultContent : ""}, 
		{data : "usr_nm", className : "dt-center", defaultContent : ""}
		 ]
	});
	
	
	menuTable = $('#menu').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		paging: false,
		bSort: false,
		columns : [
		{data : "mnu_id", className : "dt-center", defaultContent : ""}, 
		{data : "mnu_cd", className : "dt-center", defaultContent : ""}, 
		{data : "mnu_nm", className : "dt-center", defaultContent : ""}
		 ]
	});
}



$(window.document).ready(function() {

	fn_buttonAut();
	fn_init();
	var usr_id = "${usr_id}";
	if(usr_id == null || usr_id == ""){
		$.ajax({
			url : "/selectMenuAutUserManager.do",
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
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
	}else{
		$.ajax({
			url : "/selectMenuAutUserManager.do",
			data : {
				type : "usr_id",
				search : usr_id,
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				userTable.clear().draw();
				userTable.rows.add(result).draw();
				$('.odd').addClass('selected');
			}
		});
     	$.ajax({
    		url : "/selectUsrmnuautList.do",
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
    				 location.href = "/";
    			} else if(xhr.status == 403) {
    				alert("<spring:message code='message.msg03' />");
    	             location.href = "/";
    			} else {
    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
    			}
    		},
    		success : function(result) {
  				for(var i = 0; i<result.length; i++){  
  					if(result[i].mnu_cd != "MN0001" && result[i].mnu_cd != "MN0002" && result[i].mnu_cd != "MN0003" && result[i].mnu_cd != "MN0005" && result[i].mnu_cd != "MN0006" && result[i].mnu_cd != "MN0007" && result[i].mnu_cd != "MN0009" && result[i].mnu_cd != "MN00010"){
     					//읽기권한
  						if(result[i].read_aut_yn == "Y"){	  									
  							document.getElementById("r_"+result[i].mnu_cd).checked = true;
  						}else{
  							document.getElementById("r_"+result[i].mnu_cd).checked = false;
  						}

  						//쓰기권한
  						if(result[i].wrt_aut_yn == "Y"){
  							document.getElementById("w_"+result[i].mnu_cd).checked = true;
  						}else{
  							document.getElementById("w_"+result[i].mnu_cd).checked = false;
  						}
  					}
				}	  			    				
    		}
    	});
	}
	
});


$(function() {
	
	   $('#user tbody').on( 'click', 'tr', function () {
		   $("input[type=checkbox]").prop("checked",false);
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
	    		url : "/selectUsrmnuautList.do",
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
	    				 location.href = "/";
	    			} else if(xhr.status == 403) {
	    				alert("<spring:message code='message.msg03' />");
	    	             location.href = "/";
	    			} else {
	    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
	    			}
	    		},
	    		success : function(result) {
      				for(var i = 0; i<result.length; i++){  
      					if(result[i].mnu_cd != "MN0001" && result[i].mnu_cd != "MN0002" && result[i].mnu_cd != "MN0003" && result[i].mnu_cd != "MN0005" && result[i].mnu_cd != "MN0006" && result[i].mnu_cd != "MN0007" && result[i].mnu_cd != "MN0009" && result[i].mnu_cd != "MN00010"){
	     					//읽기권한
	  						if(result[i].read_aut_yn == "Y"){	  									
	  							document.getElementById("r_"+result[i].mnu_cd).checked = true;
	  						}else{
	  							document.getElementById("r_"+result[i].mnu_cd).checked = false;
	  						}
	
	  						//쓰기권한
	  						if(result[i].wrt_aut_yn == "Y"){
	  							document.getElementById("w_"+result[i].mnu_cd).checked = true;
	  						}else{
	  							document.getElementById("w_"+result[i].mnu_cd).checked = false;
	  						}
      					}
    				}	  			    				
	    		}
	    	});	
	        
	    } );   
	   
	   
		//읽기 선택 전체 체크박스 
		$("#read").click(function() { 
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#read").prop("checked")) {
				
				$("input[name=r_mnu_nm]").prop("checked", true);
			} else {
				$("input[name=r_mnu_nm]").prop("checked", false);
			}
		});
		
		//쓰기 선택 전체 체크박스 
		$("#write").click(function() { 
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#write").prop("checked")) {
				$("input[name=w_mnu_nm]").prop("checked", true);
			} else {
				$("input[name=w_mnu_nm]").prop("checked", false);
			}
		});

		//functions 선택 전체 체크박스 
		$("#functions").click(function() { 
			var array = new Array("MN000101","MN000102","MN000103","MN000201","MN000202");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#functions").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//admin 선택 전체 체크박스 
		$("#admin").click(function() { 
			var array = new Array("MN000301","MN000302","MN000303","MN0004","MN000501","MN000502","MN000503","MN000601","MN000701","MN0008","MN0001101","MN0001102","MN0001201","MN0001202","MN0001203","MN0001204","MN0001301","MN0001302");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#admin").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//스케줄정보 선택 전체 체크박스
		$("#schinfo").click(function() { 
			var array = new Array("MN000101","MN000102","MN000103");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#schinfo").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//데이터전송정보 선택 전체 체크박스
		$("#transferinfo").click(function() { 
			var array = new Array("MN000201","MN000202");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#transferinfo").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//DBMS정보 선택 전체 체크박스
		$("#dbmsinfo").click(function() { 
			var array = new Array("MN000301","MN000302","MN000303");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#dbmsinfo").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//권한관리 선택 전체 체크박스
		$("#authmanage").click(function() { 
			var array = new Array("MN000501","MN000502","MN000503");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
			if ($("#authmanage").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
			}
		});
		
		//체크박스 클릭시 사용자 선택 검사
		$(".inp_chk").click(function() { 
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 alert("<spring:message code='message.msg165'/>");
				 return false;
			 }
		});
		
		

} );

function fn_buttonAut(){
	var save_button = document.getElementById("save_button"); 

	if("${wrt_aut_yn}" == "Y"){
		save_button.style.display = '';
	}else{
		save_button.style.display = 'none';
	}
}

function fn_save(){
	 var datasArr = new Array();	
	 var datas = userTable.row('.selected').length;
	 if(datas != 1){
		 alert("<spring:message code='message.msg165'/>");
		 return false;
	 }else{
	 var usr_id = userTable.row('.selected').data().usr_id;
	
	    var mnu_id = $("input[name='mnu_id']");
	 	var read_aut = $("input[name='r_mnu_nm']");
	    var wrt_aut = $("input[name='w_mnu_nm']");
	   
	    for(var i = 0; i < read_aut.length; i++){
	     	var datas = new Object();
	        datas.usr_id = usr_id;
	        datas.mnu_id = mnu_id[i].value;
	    	if(read_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
	        	datas.read_aut_yn = "Y";   
	        }else{
	        	datas.read_aut_yn = "N";
	        }
	        
	        if(wrt_aut[i].checked){ //선택되어 있으면 배열에 값을 저장함
	        	datas.wrt_aut_yn = "Y";   	
	        }else{
	        	datas.wrt_aut_yn = "N";
	        }
	        datasArr.push(datas);
	    }	    

		if (confirm('<spring:message code="message.msg148"/>')){
			$.ajax({
				url : "/updateUsrMnuAut.do",
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
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("<spring:message code='message.msg03' />");
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
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
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
	
	$("input[type=checkbox]").prop("checked",false);
}

</script>
			<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4><spring:message code="menu.menu_auth_management" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
						<div class="infobox"> 
							<ul>
								<li><spring:message code="help.menu_auth_management_01" /> </li>
								<li><spring:message code="help.menu_auth_management_02" /> </li>	
							</ul>
						</div>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li><spring:message code="menu.auth_management" /></li>
								<li class="on"><spring:message code="menu.menu_auth_management" /></li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="menu_roll_grp">
								<div class="menu_roll_lt">
									<div class="btn_type_01">
										<div class="search_area">
											<input type="text" class="txt search" id="search">
											<button class="search_btn" onClick="fn_search()"><spring:message code="button.search" /></button>
										</div>
									</div>
									<div class="inner">
										<p class="tit"><spring:message code="auth_management.user_choice" /></p>
										<div class="overflow_area">
											<table id="user" class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th><spring:message code="common.no" /></th>
														<th><spring:message code="user_management.id" /> </th>
														<th><spring:message code="user_management.user_name" /> </th>
													</tr>
													</thead>
											</table>
										</div>
									</div>
								</div>
								<div class="menu_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button onClick="fn_save()"; id="save_button"><spring:message code="common.save"/></button></span>
									</div>
									<div class="inner">
										<p class="tit"><spring:message code="auth_management.menu_auth" /></p>
										<div class="overflow_area">
											<table class="menu_table">
												<caption><spring:message code="auth_management.menu_auth" /></caption>
												<colgroup>
													<col />
													<col style="width:30%" />
													<col style="width:30%" />
													<col style="width:10%" />
													<col style="width:10%" />
												</colgroup>
												<thead>
													<tr>
														<th scope="col" colspan="3"><spring:message code="common.menu"/></th>
														<th scope="col"><spring:message code="common.read"/>
															<div class="inp_chk" style="margin-top: 5px;">
																<input type="checkbox" id="read" name="read" />
																<label for="read"></label>
															</div>
														</th>
														<th scope="col"><spring:message code="common.write"/>
															<div class="inp_chk" style="margin-top: 5px;">
																<input type="checkbox" id="write" name="write" />
																<label for="write"></label>
															</div>
														</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th scope="row" rowspan="5">
															<div class="inp_chk">
																<input type="checkbox" id="functions" name="functions"/>
																<label for="functions">Functions</label>
															</div>
														</th>
														<th scope="row" rowspan="3">
															<div class="inp_chk">
																<input type="checkbox" id="schinfo" name="schinfo"/>
																<label for="schinfo"><spring:message code="menu.schedule_information" /></label>
															</div>
														</th>
														<td><spring:message code="menu.schedule_registration" /> </td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000101" name="r_mnu_nm" />
																<label for="r_MN000101"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000101" name="w_mnu_nm"  />
																<label for="w_MN000101"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td><spring:message code="menu.schedule_run_stop" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000102" name="r_mnu_nm" />
																<label for="r_MN000102"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000102" name="w_mnu_nm" />
																<label for="w_MN000102"></label>
															</div>
														</td>													
													</tr>
													<tr>
														<td><spring:message code="menu.shedule_execution_history" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000103" name="r_mnu_nm"  />
																<label for="r_MN000103"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000103" name="w_mnu_nm"  />
																<label for="w_MN000103"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<th scope="row" rowspan="2">
															<div class="inp_chk">
																<input type="checkbox" id="transferinfo" name="transferinfo"/>
																<label for="transferinfo"><spring:message code="menu.data_transfer_information" /></label>
															</div>
														</th>
														<td><spring:message code="menu.transfer_server_settings" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000201" name="r_mnu_nm" />
																<label for="r_MN000201"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000201" name="w_mnu_nm"  />
																<label for="w_MN000201"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td><spring:message code="menu.connector_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000202" name="r_mnu_nm" />
																<label for="r_MN000202"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000202" name="w_mnu_nm"  />
																<label for="w_MN000202"></label>
															</div>
														</td>											
													</tr>
													<tr>
														<th scope="row" rowspan="10">
															<div class="inp_chk">
																<input type="checkbox" id="admin" name="admin"/>
																<label for="admin">Admin</label>
															</div>
														</th>
														<th scope="row" rowspan="3">
															<div class="inp_chk">
																<input type="checkbox" id="dbmsinfo" name="dbmsinfo"/>
																<label for="dbmsinfo"><spring:message code="menu.dbms_information" /></label>
															</div>
														</th>
														<td><spring:message code="menu.dbms_registration" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000301" name="r_mnu_nm" />
																<label for="r_MN000301"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000301" name="w_mnu_nm" />
																<label for="w_MN000301"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td><spring:message code="menu.dbms_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000302" name="r_mnu_nm" />
																<label for="r_MN000302"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000302" name="w_mnu_nm"  />
																<label for="w_MN000302"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td><spring:message code="menu.database_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000303" name="r_mnu_nm" />
																<label for="r_MN000303"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000303" name="w_mnu_nm" />
																<label for="w_MN000303"></label>
															</div>
														</td>											
													</tr>
													<tr>
														<td colspan="2"><spring:message code="menu.user_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN0004" name="r_mnu_nm"  />
																<label for="r_MN0004"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN0004" name="w_mnu_nm"  />
																<label for="w_MN0004"></label>
															</div>
														</td>								
													</tr>
													
													
													<tr>
														<th scope="row" rowspan="3">
															<div class="inp_chk">
																<input type="checkbox" id="authmanage" name="authmanage"/>
																<label for="authmanage"><spring:message code="menu.auth_management" /></label>
															</div>
														</th>
														<td><spring:message code="menu.menu_auth_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000501" name="r_mnu_nm" />
																<label for="r_MN000501"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000501" name="w_mnu_nm" />
																<label for="w_MN000501"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td><spring:message code="menu.server_auth_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000502" name="r_mnu_nm" />
																<label for="r_MN000502"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000502" name="w_mnu_nm"  />
																<label for="w_MN000502"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td><spring:message code="menu.database_auth_management" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000503" name="r_mnu_nm" />
																<label for="r_MN000503"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000503" name="w_mnu_nm" />
																<label for="w_MN000503"></label>
															</div>
														</td>											
													</tr>
													<tr>
														<th scope="row" rowspan="1"><spring:message code="menu.history_management" /></th>
														<td><spring:message code="menu.screen_access_history" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000601" name="r_mnu_nm" />
																<label for="r_MN000601"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000601" name="w_mnu_nm" />
																<label for="w_MN000601"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<th scope="row" rowspan="1"><spring:message code="menu.monitoring" /></th>
														<td><spring:message code="menu.agent_monitoring" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN000701" name="r_mnu_nm" />
																<label for="r_MN000701"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN000701" name="w_mnu_nm" />
																<label for="w_MN000701"></label>
															</div>
														</td>										
													</tr>
													<tr>
														<td colspan="2"><spring:message code="menu.extension_pack_installation_information" /></td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="r_MN0008" name="r_mnu_nm"  />
																<label for="r_MN0008"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="w_MN0008" name="w_mnu_nm"  />
																<label for="w_MN0008"></label>
															</div>
													<input type="hidden"  name="mnu_id" value="2">		
													<input type="hidden"  name="mnu_id" value="3">		
													<input type="hidden"  name="mnu_id" value="4">		
													<input type="hidden"  name="mnu_id" value="6">		
													<input type="hidden"  name="mnu_id" value="7">		
													<input type="hidden"  name="mnu_id" value="9">		
													<input type="hidden"  name="mnu_id" value="10">		
													<input type="hidden"  name="mnu_id" value="11">			
													<input type="hidden"  name="mnu_id" value="12">			
													<input type="hidden"  name="mnu_id" value="14" >		
													<input type="hidden"  name="mnu_id" value="15">		
													<input type="hidden"  name="mnu_id" value="16" >		
													<input type="hidden"  name="mnu_id" value="18">	
													<input type="hidden"  name="mnu_id" value="20">
													<input type="hidden"  name="mnu_id" value="21">	
													
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
