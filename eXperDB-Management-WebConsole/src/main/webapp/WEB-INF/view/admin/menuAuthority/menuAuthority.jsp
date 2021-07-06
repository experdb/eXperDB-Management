<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>
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
var confirm_title = ""; 

var userTable = null;
var menuTable = null;

function fn_init() {
	userTable = $('#user').DataTable({
		scrollY : "500px",
		processing : true,
		searching : false,
		paging: false,
		bSort: false,
		columns : [
		{data : "rownum", className : "dt-center", defaultContent : ""}, 
		{data : "usr_id", defaultContent : ""}, 
		{data : "usr_nm", defaultContent : ""}
		 ]
	});
	
	
	menuTable = $('#menu').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		paging: false,
		bSort: false,
		columns : [
		{data : "mnu_id", defaultContent : ""}, 
		{data : "mnu_cd", defaultContent : ""}, 
		{data : "mnu_nm", defaultContent : ""}
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
    				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
    			} else if(xhr.status == 403) {
    				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
    			} else {
    				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
    			}
    		},
    		success : function(result) {
  				for(var i = 0; i<result.length; i++){  
  					if(result[i].mnu_cd != "MN0001" && result[i].mnu_cd != "MN0002" && result[i].mnu_cd != "MN0003" && result[i].mnu_cd != "MN0005" && result[i].mnu_cd != "MN0006" && result[i].mnu_cd != "MN0007" && result[i].mnu_cd != "MN0009" && result[i].mnu_cd != "MN00010" && result[i].mnu_cd != "MN00011" && result[i].mnu_cd != "MN00012" && result[i].mnu_cd != "MN00013"  && result[i].mnu_cd != "MN00014" && result[i].mnu_cd != "MN00018" && result[i].mnu_cd != "MN0001804" && result[i].mnu_cd != "MN00019" && result[i].mnu_cd != "MN00020"){
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
	
	if('${encrypt_useyn}'=='N'){
		$('.encrypt').hide();
	}
	
	if('${bnr_useyn}'=='N'){
		$('.bnr').hide();
	}

	if(nvlPrmSet('${proxy_menu_useyn}','N') == 'N'){
		$('.proxy_yn').hide();
	} else {
		if(nvlPrmSet('${proxy_useyn}','N') == 'N'){
			$('.proxy_yn').hide();
		}
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
	    				showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
	    			} else if(xhr.status == 403) {
	    				showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
	    			} else {
	    				showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
	    			}
	    		},
	    		success : function(result) {
      				for(var i = 0; i<result.length; i++){  
      					if(result[i].mnu_cd != "MN0001" && result[i].mnu_cd != "MN0002" && result[i].mnu_cd != "MN0003" && result[i].mnu_cd != "MN0005" && result[i].mnu_cd != "MN0006" && result[i].mnu_cd != "MN0007" && result[i].mnu_cd != "MN0009" && result[i].mnu_cd != "MN00010" && result[i].mnu_cd != "MN00011" && result[i].mnu_cd != "MN00012" && result[i].mnu_cd != "MN00013" && result[i].mnu_cd != "MN00014" && result[i].mnu_cd != "MN00018" && result[i].mnu_cd != "MN0001804" && result[i].mnu_cd != "MN00019" && result[i].mnu_cd != "MN00020"){
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#functions").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
				document.getElementById("schinfo").checked = true;
				document.getElementById("transferinfo").checked = true;
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
				document.getElementById("schinfo").checked = false;
				document.getElementById("transferinfo").checked = false;
			}
		});
		
		//admin 선택 전체 체크박스 
		$("#admin").click(function() { 
			var array = new Array("MN000301","MN000302","MN000303","MN0004","MN000501","MN000502","MN000503","MN000601","MN000701","MN000702","MN0008");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#admin").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
				document.getElementById("dbmsinfo").checked = true;
				document.getElementById("authmanage").checked = true;
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
				document.getElementById("dbmsinfo").checked = false;
				document.getElementById("authmanage").checked = false;
			}
		});
		
		//스케줄정보 선택 전체 체크박스
		$("#schinfo").click(function() { 
			var array = new Array("MN000101","MN000102","MN000103");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
		
		//Encrypt 선택 전체 체크박스
		$("#encrypt").click(function() { 
			var array = new Array("MN0001101","MN0001102","MN0001201","MN0001202","MN0001203","MN0001301","MN0001302","MN0001303","MN0001304","MN0001401");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#encrypt").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
				document.getElementById("securitykey").checked = true;
				document.getElementById("auditlog").checked = true;
				document.getElementById("setting").checked = true;
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
				document.getElementById("securitykey").checked = false;
				document.getElementById("auditlog").checked = false;
				document.getElementById("setting").checked = false;
			}
		});
		
		//정책관리/키관리 선택 전체 체크박스
		$("#securitykey").click(function() { 
			var array = new Array("MN0001101","MN0001102");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#securitykey").prop("checked")) {
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
		
		//감사로그 선택 전체 체크박스
		$("#auditlog").click(function() { 
			var array = new Array("MN0001201","MN0001202","MN0001203");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#auditlog").prop("checked")) {
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
		
		
		//설정 선택 전체 체크박스
		$("#setting").click(function() { 
			var array = new Array("MN0001301","MN0001302","MN0001303","MN0001304");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#setting").prop("checked")) {
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
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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
		
		//Migration 선택 전체 체크박스
		$("#migration").click(function() { 
			var array = new Array("MN00015","MN00016","MN00017");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#migration").prop("checked")) {
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
		
		//VirtualIP 선택 전체 체크박스
		$("#VirtualIP").click(function() { 
			var array = new Array("MN0001801","MN0001802","MN0001803","MN0001805");
			//var array = new Array("MN0001801","MN0001802");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#VirtualIP").prop("checked")) {
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
		
		
		/* 백업메뉴 권한체크 추가 2021-04-13 변승우 */		
		//BnR 선택 전체 체크박스 
		$("#bnr").click(function() { 
			var array = new Array("MN0001901","MN0001902","MN0001903","MN0002001","MN0002002");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#bnr").prop("checked")) {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = true;
					document.getElementById("w_"+array[i]).checked = true;
				}
				document.getElementById("bnrSetting").checked = true;
				document.getElementById("backup").checked = true;
			} else {
				for(var i=0; i<array.length; i++){
					document.getElementById("r_"+array[i]).checked = false;
					document.getElementById("w_"+array[i]).checked = false;
				}
				document.getElementById("bnrSetting").checked = false;
				document.getElementById("backup").checked = false;
			}
		});	
		
		
		//BnR 설정 선택 전체 체크박스
		$("#bnrSetting").click(function() { 
			var array = new Array("MN0001901","MN0001902","MN0001903");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#bnrSetting").prop("checked")) {
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
		
		//Backup 선택 전체 체크박스
		$("#backup").click(function() { 
			var array = new Array("MN0002001","MN0002002");
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
				 return false;
			 }
			if ($("#backup").prop("checked")) {
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
		
		/* 백업메뉴 권한체크 추가 종료*/
		
		
		
		//체크박스 클릭시 사용자 선택 검사
		$(".inp_chk").click(function() { 
			var datas = userTable.row('.selected').length;
			 if(datas != 1){
				 showSwalIcon('<spring:message code="message.msg165" />', '<spring:message code="common.close" />', '', 'error');
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

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "ins") {
		fn_save2();
	}
}

function fn_save(){
	 var datasArr = new Array();	
	 var datas = userTable.row('.selected').length;
	 if(datas != 1){
		 showSwalIcon('<spring:message code="message.msg165"/>', '<spring:message code="common.close" />', '', 'warning');
		 return false;
	 }else{
			confile_title = '<spring:message code="auth_management.menu_auth" />' + " " + '<spring:message code="common.save" />' + " " + '<spring:message code="common.request" />';
			$('#con_multi_gbn', '#findConfirmMulti').val("ins");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('<spring:message code="message.msg148" />');
			$('#pop_confirm_multi_md').modal("show");    
	 }
}

function fn_save2(){
		var datasArr = new Array();
	 	var usr_id = userTable.row('.selected').data().usr_id;
	 	var read_aut = $("input[name='r_mnu_nm']");
	    var wrt_aut = $("input[name='w_mnu_nm']");
	   
	    for(var i = 0; i < read_aut.length; i++){
	     	var datas = new Object();
	        datas.usr_id = usr_id;
			var mnu_cd = $(read_aut[i]).val();
			datas.mnu_cd= mnu_cd;
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
	    
			$.ajax({
				url : "/updateUsrMnuAut.do",
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
	$("input[type=checkbox]").prop("checked",false);
}
</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
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
												<span class="menu-title"><spring:message code="menu.menu_auth_management" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.auth_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.menu_auth_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.menu_auth_management_01" /></p>
											<p class="mb-0"><spring:message code="help.menu_auth_management_02" /></p>
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
				<div class="card-body" style="height: 100%;">
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
						<spring:message code="auth_management.menu_auth" />
					</h4>

					<div class="row" >
						<div class="col-9"></div>
						<div class="col-3">
							<div class="template-demo">	
								<form class="form-inline" style="float: right;">
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="save_button" onClick="fn_save()">
										<i class="ti-import btn-icon-prepend "></i><spring:message code="common.save"/>
									</button>
								</form>
							</div>
						</div>
					</div>
					
					<div class="table-responsive system-tlb-scroll" style="height: 560px;overflow-y:auto;">

						<table id="menuAuthTable" class="table text-center" style="width:100%;">
							<colgroup>
								<col />
								<col style="width:30%" />
								<col style="width:30%" />
								<col style="width:10%" />
								<col style="width:10%" />
							</colgroup>
							<thead>
								<tr class="bg-info text-white">
									<td scope="col" colspan="3"><spring:message code="common.menu"/></td>
									<th scope="col">
										<spring:message code="common.read"/>
										<div class="inp_chk" style="margin-top: 5px;">
											<input type="checkbox" id="read" name="read" />
											<label for="read"></label>
										</div>
									</th>
									<th scope="col">
										<spring:message code="common.write"/>
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
									<td scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="schinfo" name="schinfo"/>
											<label for="schinfo"><spring:message code="menu.schedule_information" /></label>
										</div>
									</td>
									<td><spring:message code="menu.schedule_registration" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000101" name="r_mnu_nm" value="MN000101"/>
											<label for="r_MN000101"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN000101" name="w_mnu_nm"/>
											<label for="w_MN000101"></label>
										</div>
									</td>
								</tr>
								<tr>
									<td><spring:message code="etc.etc27" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000102" name="r_mnu_nm" value="MN000102"/>
											<label for="r_MN000102"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN000102" name="w_mnu_nm"/>
											<label for="w_MN000102"></label>
										</div>
									</td>													
								</tr>
								<tr>
									<td><spring:message code="menu.shedule_execution_history" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000103" name="r_mnu_nm"  value="MN000103"/>
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
									<td scope="row" rowspan="2">
										<div class="inp_chk">
											<input type="checkbox" id="transferinfo" name="transferinfo"/>
											<label for="transferinfo"><spring:message code="menu.data_transfer_information" /></label>
										</div>
									</td>
									<td><spring:message code="menu.transfer_server_settings" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000201" name="r_mnu_nm" value="MN000201"/>
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
											<input type="checkbox" id="r_MN000202" name="r_mnu_nm" value="MN000202"/>
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
									<th scope="row" rowspan="11">
										<div class="inp_chk">
											<input type="checkbox" id="admin" name="admin"/>
											<label for="admin">Admin</label>
										</div>
									</th>
									<td scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="dbmsinfo" name="dbmsinfo"/>
											<label for="dbmsinfo"><spring:message code="menu.dbms_information" /></label>
										</div>
									</td>
									<td><spring:message code="menu.dbms_registration" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000301" name="r_mnu_nm" value="MN000301"/>
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
											<input type="checkbox" id="r_MN000302" name="r_mnu_nm" value="MN000302"/>
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
											<input type="checkbox" id="r_MN000303" name="r_mnu_nm" value="MN000303"/>
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
											<input type="checkbox" id="r_MN0004" name="r_mnu_nm" value="MN0004"/>
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
									<td scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="authmanage" name="authmanage"/>
											<label for="authmanage"><spring:message code="menu.auth_management" /></label>
										</div>
									</td>
									<td><spring:message code="menu.menu_auth_management" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000501" name="r_mnu_nm" value="MN000501"/>
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
											<input type="checkbox" id="r_MN000502" name="r_mnu_nm" value="MN000502"/>
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
											<input type="checkbox" id="r_MN000503" name="r_mnu_nm" value="MN000503"/>
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
									<td scope="row" rowspan="1"><spring:message code="menu.history_management" /></td>
									<td><spring:message code="menu.screen_access_history" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000601" name="r_mnu_nm" value="MN000601"/>
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
									<td scope="row" rowspan="2"><spring:message code="menu.agent_monitoring" /></td>
									<td><spring:message code="agent_monitoring.Management_agent" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000701" name="r_mnu_nm" value="MN000701"/>
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
									<td><spring:message code="agent_monitoring.Encrypt_agent" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN000702" name="r_mnu_nm" value="MN000702"/>
											<label for="r_MN000702"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN000702" name="w_mnu_nm" />
											<label for="w_MN000702"></label>
										</div>
									</td>											
								</tr>
								<tr>
									<td colspan="2"><spring:message code="menu.extension_pack_installation_information" /></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0008" name="r_mnu_nm" value="MN0008"/>
											<label for="r_MN0008"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0008" name="w_mnu_nm"  />
											<label for="w_MN0008"></label>
										</div>
									</td>											
								</tr>	
								
																		
								<!-- Backup 권한 추가 2021-04-13 변승우 -->
								<tr class="bnr">
									<th scope="row" rowspan="5">
										<div class="inp_chk">
											<input type="checkbox" id="bnr" name="bnr"/>
											<label for="bnr">BnR</label>
										</div>
									</th>
									<td scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="bnrSetting" name="bnrSetting"/>
											<label for="bnrSetting">BnR 설정</label>
										</div>
									</td>
									<td>모니터링</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001901" name="r_mnu_nm" value="MN0001901"/>
											<label for="r_MN0001901"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001901" name="w_mnu_nm"/>
											<label for="w_MN0001901"></label>
										</div>
									</td>
								</tr>
								<tr class="bnr">
									<td>백업이력 관리</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001902" name="r_mnu_nm" value="MN0001902"/>
											<label for="r_MN0001902"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001902" name="w_mnu_nm"/>
											<label for="w_MN0001902"></label>
										</div>
									</td>													
								</tr>
								<tr class="bnr">
									<td>복구이력 관리</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001903" name="r_mnu_nm"  value="MN0001903"/>
											<label for="r_MN0001903"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001903" name="w_mnu_nm"  />
											<label for="w_MN0001903"></label>
										</div>
									</td>										
								</tr>
								<tr class="bnr">
									<td scope="row" rowspan="2">
										<div class="inp_chk">
											<input type="checkbox" id="backup" name="backup"/>
											<label for="backup">Backup</label>
										</div>
									</td>
									<td>Storage 설정</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0002001" name="r_mnu_nm" value="MN0002001"/>
											<label for="r_MN0002001"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0002001" name="w_mnu_nm"  />
											<label for="w_MN0002001"></label>
										</div>
									</td>										
								</tr>
								<tr class="bnr">
									<td>정책설정</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0002002" name="r_mnu_nm" value="MN0002002"/>
											<label for="r_MN0002002"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0002002" name="w_mnu_nm"  />
											<label for="w_MN0002002"></label>
										</div>
									</td>											
								</tr>								
								<!-- Backup 권한 추가 끝 -->
													
								<tr class="encrypt">
									<th scope="row" rowspan="10">
										<div class="inp_chk">
											<input type="checkbox" id="encrypt" name="encrypt"/>
											<label for="encrypt">Encrypt</label>
										</div>
									</th>
									<td scope="row" rowspan="2">
										<div class="inp_chk">
											<input type="checkbox" id="securitykey" name="securitykey"/>
											<label for="securitykey"><spring:message code="encrypt_policy_management.Policy_Key_Management"/></label>
										</div>
										</td>
									<td><spring:message code="encrypt_policy_management.Security_Policy_Management"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001101" name="r_mnu_nm" value="MN0001101"/>
											<label for="r_MN0001101"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001101" name="w_mnu_nm" />
											<label for="w_MN0001101"></label>
										</div>
									</td>																																				
								</tr>
								<tr class="encrypt">
									<td><spring:message code="encrypt_key_management.Encryption_Key_Management"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001102" name="r_mnu_nm" value="MN0001102"/>
											<label for="r_MN0001102"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001102" name="w_mnu_nm" />
											<label for="w_MN0001102"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt">
									<td scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="auditlog" name="auditlog"/>
											<label for="auditlog"><spring:message code="encrypt_log.Audit_Log"/></label>
										</div></td>
									<td><spring:message code="encrypt_log_decode.Encryption_Decryption"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001201" name="r_mnu_nm" value="MN0001201"/>
											<label for="r_MN0001201"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001201" name="w_mnu_nm" />
											<label for="w_MN0001201"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt">
									<td><spring:message code="encrypt_log_sever.Management_Server"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001202" name="r_mnu_nm" value="MN0001202"/>
											<label for="r_MN0001202"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001202" name="w_mnu_nm" />
											<label for="w_MN0001202"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt">
									<td><spring:message code="encrypt_policy_management.Encryption_Key"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001203" name="r_mnu_nm" value="MN0001203"/>
											<label for="r_MN0001203"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001203" name="w_mnu_nm" />
											<label for="w_MN0001203"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt" style="display: none;">
									<td>자원사용</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001204" name="r_mnu_nm" value="MN0001204"/>
											<label for="r_MN0001204"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001204" name="w_mnu_nm" />
											<label for="w_MN0001204"></label>
										</div>
									</td>	
								</tr>	
								<tr class="encrypt">
									<td scope="row" rowspan="4">
										<div class="inp_chk">
											<input type="checkbox" id="setting" name="setting"/>
											<label for="setting"><spring:message code="encrypt_policyOption.Settings"/></label>
										</div>
									</td>
									<td><spring:message code="encrypt_policyOption.Security_Policy_Option_Setting"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001301" name="r_mnu_nm" value="MN0001301"/>
											<label for="r_MN0001301"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001301" name="w_mnu_nm" />
											<label for="w_MN0001301"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt">
									<td><spring:message code="encrypt_encryptSet.Encryption_Settings"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001302" name="r_mnu_nm" value="MN0001302"/>
											<label for="r_MN0001302"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001302" name="w_mnu_nm" />
											<label for="w_MN0001302"></label>
										</div>
									</td>	
								</tr>	
								<tr class="encrypt">
									<td><spring:message code="encrypt_serverMasterKey.Setting_the_server_master_key_password"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001303" name="r_mnu_nm" value="MN0001303"/>
											<label for="r_MN0001303"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001303" name="w_mnu_nm" />
											<label for="w_MN0001303"></label>
										</div>
									</td>	
								</tr>
								<tr class="encrypt">
									<td><spring:message code="encrypt_agent.Encryption_agent_setting"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001304" name="r_mnu_nm" value="MN0001304"/>
											<label for="r_MN0001304"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001304" name="w_mnu_nm" />
											<label for="w_MN0001304"></label>
										</div>
									</td>	
								</tr>	
								<tr class="encrypt">
									<td scope="row"><spring:message code="encrypt_Statistics.Statistics"/></td>
									<td><spring:message code="encrypt_Statistics.Encrypt_Statistics"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001401" name="r_mnu_nm" value="MN0001401"/>
											<label for="r_MN0001401"></label>
										</div>
									</td>	
										<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001401" name="w_mnu_nm" />
											<label for="w_MN0001401"></label>
										</div>
									</td>
								</tr>	
								<tr>
									<th scope="row" rowspan="3">
										<div class="inp_chk">
											<input type="checkbox" id="migration" name="migration"/>
											<label for="migration">MIGRATION</label>
										</div>
									</th>
									<td colspan="2"><spring:message code="migration.source/target_dbms_management"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN00015" name="r_mnu_nm" value="MN00015"/>
											<label for="r_MN00015"></label>
										</div>
									</td>	
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN00015" name="w_mnu_nm" />
											<label for="w_MN00015"></label>
										</div>
									</td>
								</tr>										
								<tr>
									<td colspan="2"><spring:message code="migration.setting_information_management"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN00016" name="r_mnu_nm" value="MN00016"/>
											<label for="r_MN00016"></label>
										</div>
									</td>	
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN00016" name="w_mnu_nm" />
											<label for="w_MN00016"></label>
										</div>
									</td>
								</tr>	
								<tr>
									<td colspan="2"><spring:message code="migration.performance_history"/></td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN00017" name="r_mnu_nm" value="MN00017"/>
											<label for="r_MN00017"></label>
										</div>
									</td>	
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN00017" name="w_mnu_nm" />
											<label for="w_MN00017"></label>
										</div>
									</td>
								</tr>
								<!-- Proxy -->
								<tr class="proxy_yn">
									<th scope="row" rowspan="4">
										<div class="inp_chk">
											<input type="checkbox" id="VirtualIP" name="VirtualIP"/>
											<label for="functions">Proxy</label>
										</div>
									</th>
									<td colspan="2"><spring:message code="menu.proxy_agent" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001805" name="r_mnu_nm" value="MN0001805"/>
											<label for="r_MN0001805"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001805" name="w_mnu_nm"/>
											<label for="w_MN0001805"></label>
										</div>
									</td>
								</tr>
								
								<tr class="proxy_yn">
									<td colspan="2"><spring:message code="menu.proxy_monitoring" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001801" name="r_mnu_nm" value="MN0001801"/>
											<label for="r_MN0001801"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001801" name="w_mnu_nm"/>
											<label for="w_MN0001801"></label>
										</div>
									</td>

								</tr>
																
								<tr class="proxy_yn">
									<td colspan="2"><spring:message code="menu.proxy_config" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001802" name="r_mnu_nm" value="MN0001802"/>
											<label for="r_MN0001802"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001802" name="w_mnu_nm"/>
											<label for="w_MN0001802"></label>
										</div>
									</td>
								</tr>
								<tr class="proxy_yn">
									<td colspan="2"><spring:message code="menu.proxy_hist" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001803" name="r_mnu_nm" value="MN0001803"/>
											<label for="r_MN0001803"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001803" name="w_mnu_nm"/>
											<label for="w_MN0001803"></label>
										</div>
									</td>
								</tr>
								<%-- <tr>
									<td scope="row" rowspan="2">
										<div class="inp_chk">
											<input type="checkbox" id="vipHist" name="vipHist"/>
											<label for="schinfo"><spring:message code="menu.history_management" /></label>
										</div>
									</td>
									<td><spring:message code="menu.proxy_hist" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001803" name="r_mnu_nm" value="MN0001803"/>
											<label for="r_MN0001803"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001803" name="w_mnu_nm"/>
											<label for="w_MN0001803"></label>
										</div>
									</td>
								</tr>
								<tr>
									<td><spring:message code="menu.proxy_change_hist" /> </td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="r_MN0001804" name="r_mnu_nm" value="MN0001804"/>
											<label for="r_MN0001804"></label>
										</div>
									</td>
									<td>
										<div class="inp_chk">
											<input type="checkbox" id="w_MN0001804" name="w_mnu_nm"/>
											<label for="w_MN0001804"></label>
										</div>
									</td>
								</tr> --%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>