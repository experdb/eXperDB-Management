<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">

<link rel = "stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel = "stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel = "stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>

<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>

<script language="javascript">
var scd_nmChk = "fail";
var db_svr_id = "${db_svr_id}";
var haCnt = 0;

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		
		 $.ajax({
				async : false,
				url : "/selectHaCnt.do",
			  	data : {
			  		db_svr_id : db_svr_id
			  	},
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
					haCnt = result[0].hacnt;			
				}
			}); 
		 
		$("#r_data_pth").hide();
		$("#r_log_pth").hide();
		$("#r_bck_pth").hide();
		$("#d_log_pth").hide();
		$("#d_bck_pth").hide();
		$("#rman_bck_opt").hide();
		$("#dump_bck_opt").hide();
		
		fn_makeHour();
		fn_makeMin();
	});
	
	
	function getTimeStamp() {
		  var d = new Date();
		  var s =
		    leadingZeros(d.getFullYear(), 4) + 
		    leadingZeros(d.getMonth() + 1, 2) + 
		    leadingZeros(d.getDate(), 2) + 
		    leadingZeros(d.getHours(), 2) +
		    leadingZeros(d.getMinutes(), 2) +
		    leadingZeros(d.getSeconds(), 2);
		  return s;
		}

		function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();
		  if (n.length < digits) {
		    for (i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
		}
		
	/* ********************************************************
	 * Validation Check
	 ******************************************************** */		
	function fn_validation(){		
		if($("#scd_nm").val() == ""){
			alert("스케줄명을 입력해 주세요.");
			$("#scd_nm").focus();
			return false;
		}else if($("#check_path1").val() != "Y"){
			alert("데이터경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
			$("#data_pth").focus();
			return false;
		}else if(scd_nmChk == "fail"){
			alert("스케줄명 중복체크 해주세요.");
			return false;
		}else if($("input[name=chk]:checkbox:checked").length == 0){
			alert("스케줄을 체크해 주세요.");
			return false;
		}
		
		if($('#bck').val() == "rman"){
			if($('#bck_opt_cd').val() == ""){
				alert("백업옵션을 선택해 주세요.");
				return false;
				}			
		}else{
			if($('#db_id').val() == ""){
				alert("데이터베이스를 선택해 주세요.");
				return false;
				}			
		}
		
		if($("#check_path1").val() != "Y"){
			alert("데이터경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
			$("#data_pth").focus();
			return false;
		}else if($("#check_path2").val() != "Y"){
			alert("백업로그경로에 유효한 경로를 입력후 경로체크를 해 주세요.");		
			$("#rlog_file_pth").focus();
			return false;
		}else if($("#check_path3").val() != "Y"){
			alert("백업경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
			$("#bck_pth").focus();
			return false;
		}else if($("#check_path4").val() != "Y"){
			alert("백업로그경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
			$("#dlog_file_pth").focus();
			return false;
		}else if($("#check_path5").val() != "Y"){
			alert("백업경로에 유효한 경로를 입력후 경로체크를 해 주세요.");
			$("#save_pth").focus();
			return false;
		}else{
			return true;
		}
	}
	
	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeHour(){
		var hour = "";
		var hourHtml ="";
		
		hourHtml += '<select class="select t7" name="exe_h" id="exe_h">';	
		for(var i=0; i<=23; i++){
			if(i >= 0 && i<10){
				hour = "0" + i;
			}else{
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">'+hour+'</option>';
		}
		hourHtml += '</select> 시';	
		$( "#hour" ).append(hourHtml);
	}


	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="select t7" name="exe_m" id="exe_m">';	
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		minHtml += '</select> 분';	
		$( "#min" ).append(minHtml);
	}



	//스케줄명 중복체크
	function fn_check() {
		var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			alert("스케줄명을 입력하세요.");
			document.getElementById('scd_nm').focus();
			return;
		}
		$.ajax({
			url : '/scd_nmCheck.do',
			type : 'post',
			data : {
				scd_nm : $("#scd_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert("등록가능한 스케줄명 입니다.");
					document.getElementById("scd_nm").focus();
					scd_nmChk = "success";
				} else {
					scd_nmChk = "fail";
					alert("중복된 스케줄명이 존재합니다.");
					document.getElementById("scd_nm").focus();
				}
			},
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
			}
		});
	}


	 function fn_bck(){
		 $.ajax({
				async : false,
				url : "/selectPathInfo.do",
			  	data : {
			  		db_svr_id : db_svr_id
			  	},
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
					document.getElementById("data_pth").value=result[0].DATA_PATH;
					document.getElementById("rlog_file_pth").value=result[1].PGRLOG;		
					document.getElementById("bck_pth").value=result[1].PGRBAK;
					document.getElementById("dlog_file_pth").value=result[1].PGDLOG;
					document.getElementById("save_pth").value=result[1].PGDBAK; 
					fn_checkFolderVol(1);
					fn_checkFolderVol(2);
					fn_checkFolderVol(3);
					fn_checkFolderVol(4);
					fn_checkFolderVol(5);
				}
			}); 
		 
		var bck = $("#bck").val();
		
		if(bck == "rman"){
			$("#rman_bck_opt").show();
			$("#r_log_pth").show();
			$("#r_data_pth").show();
			$("#r_bck_pth").show();
			$("#d_log_pth").hide();
			$("#d_bck_pth").hide();
			$("#dump_bck_opt").hide();
		}else if(bck == "dump"){
			$("#d_bck_pth").show();
			$("#d_log_pth").show();
			$("#dump_bck_opt").show();
			$("#r_log_pth").hide();
			$("#r_data_pth").hide();
			$("#r_bck_pth").hide();
			$("#rman_bck_opt").hide();
		}else{
			$("#d_bck_pth").hide();
			$("#d_log_pth").hide();
			$("#r_log_pth").hide();
			$("#r_data_pth").hide();
			$("#r_bck_pth").hide();
			$("#rman_bck_opt").hide();
			$("#dump_bck_opt").hide();
		}	
	} 	
	 
	 
	 
	 function fn_checkFolderVol(keyType){
		 var save_path = "";
		 	
		 	if(keyType == 1){
		 		save_path = $("#data_pth").val();
		 	}else if(keyType == 2){
		 		save_path = $("#rlog_file_pth").val();
		 	}else if(keyType == 3){
		 		save_path = $("#bck_pth").val();
		 	}else if(keyType == 4){
		 		save_path = $("#dlog_file_pth").val();
		 	}else{
		 		save_path = $("#save_pth").val();
		 	}
		 	
		 	$.ajax({
	 			async : false,
	 			url : "/existDirCheck.do",
	 		  	data : {
	 		  		db_svr_id : $("#db_svr_id").val(),
	 		  		path : save_path
	 		  	},
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
	 			success : function(data) {
	 				if(data.result.ERR_CODE == ""){
	 					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
	 						if(keyType == 1){
	 							$("#check_path1").val("Y");
	 						}else if(keyType == 2){
	 							$("#check_path2").val("Y");
	 						}else if(keyType == 3){
	 							$("#check_path3").val("Y");
	 						}else if(keyType == 4){
	 							$("#check_path4").val("Y");
	 						}else{
	 							$("#check_path5").val("Y");
	 						}
	 							var volume = "용량: "+data.result.RESULT_DATA.CAPACITY;
	 						if(keyType == 1){
	 							$("#dataVolume").empty();
	 							$( "#dataVolume" ).append(volume);
	 						}else if(keyType == 2) {
	 							$("#rlogVolume").empty();
	 							$( "#rlogVolume" ).append(volume);
	 						}else if(keyType == 3) {
	 							$("#backupVolume").empty();
	 							$( "#backupVolume" ).append(volume);
	 						}else if(keyType == 4) {
	 							$("#dlogVolume").empty();
	 							$( "#dlogVolume" ).append(volume);
	 						}else if(keyType == 5) {
	 							$("#saveVolume").empty();
	 							$( "#saveVolume" ).append(volume);
	 						}
	 					}else{
	 						if(haCnt > 1){
	 							alert("HA 구성된 클러스터 중 "+data.SERVERIP+" 노드에 해당 경로가 존재하지 않습니다.");
							}else{
								alert("유효하지 않은 경로입니다.");
							}	
	 					}
	 				}else{
	 					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
	 				}
	 			}
	 		});
	 }
	 
	 
	 /* ********************************************************
	  * 저장경로의 존재유무 체크
	  ******************************************************** */
	 function checkFolder(keyType){
	 	var save_path = "";
	 	
	 	if(keyType == 1){
	 		save_path = $("#data_pth").val();
	 	}else if(keyType == 2){
	 		save_path = $("#rlog_file_pth").val();
	 	}else if(keyType == 3){
	 		save_path = $("#bck_pth").val();
	 	}else if(keyType == 4){
	 		save_path = $("#dlog_file_pth").val();
	 	}else{
	 		save_path = $("#save_pth").val();
	 	}

	 	if(save_path == "" && keyType == 1){
	 		alert("데이터경로를 입력해 주세요.");
	 		$("#data_pth").focus();
	 	}else if(save_path == "" && keyType == 2){
	 		alert("백업로그경로를 입력해 주세요.");
	 		$("#rlog_file_pth").focus();
	 	}else if(save_path == "" && keyType == 3){
	 		alert("백업경로를 입력해 주세요.");
	 		$("#bck_pth").focus();
	 	}else if(save_path == "" && keyType == 4){
	 		alert("백업로그경로를 입력해 주세요.");
	 		$("#dlog_file_pth").focus();
	 	}else if(save_path == "" && keyType == 5){
	 		alert("백업경로를 입력해 주세요.");
	 		$("#save_pth").focus();
	 	}
	 	else{
	 		$.ajax({
	 			async : false,
	 			url : "/existDirCheck.do",
	 		  	data : {
	 		  		db_svr_id : $("#db_svr_id").val(),
	 		  		path : save_path
	 		  	},
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
	 			success : function(data) {
	 				if(data.result.ERR_CODE == ""){
	 					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
	 						if(keyType == 1){
	 							$("#check_path1").val("Y");
	 						}else if(keyType == 2){
	 							$("#check_path2").val("Y");
	 						}else if(keyType == 3){
	 							$("#check_path3").val("Y");
	 						}else if(keyType == 4){
	 							$("#check_path4").val("Y");
	 						}else{
	 							$("#check_path5").val("Y");
	 						}
	 						alert("유효한 경로입니다.");
	 						var volume = "용량: "+data.result.RESULT_DATA.CAPACITY;
	 						if(keyType == 1){
	 							$("#dataVolume").empty();
	 							$( "#dataVolume" ).append(volume);
	 						}else if(keyType == 2) {
	 							$("#rlogVolume").empty();
	 							$( "#rlogVolume" ).append(volume);
	 						}else if(keyType == 3) {
	 							$("#backupVolume").empty();
	 							$( "#backupVolume" ).append(volume);
	 						}else if(keyType == 4) {
	 							$("#dlogVolume").empty();
	 							$( "#dlogVolume" ).append(volume);
	 						}else if(keyType == 5) {
	 							$("#saveVolume").empty();
	 							$( "#saveVolume" ).append(volume);
	 						}
	 					}else{
	 						alert("HA 구성된 클러스터 중 해당 경로가 존재하지 않는 클러스터가 있습니다.");
	 					}
	 				}else{
	 					alert("경로체크 중 서버에러로 인하여 실패하였습니다.")
	 				}
	 			}
	 		});
	 	}
	 }
	 
	 
	 
	 /* ********************************************************
	  * Backup Insert
	  ******************************************************** */
	  function fn_insert_bckScheduler(){

		  if (!fn_validation()) return false;
		  var bck = $('#bck').val();

		  if(bck =="rman"){		  
 		 		$.ajax({
		 			async : false,
		 			url : "/popup/workRmanWrite.do",
		 		  	data : {
		 		  		db_svr_id : $("#db_svr_id").val(),
		 		  		wrk_nm : $("#scd_nm").val()+"_"+getTimeStamp(),
		 		  		wrk_exp : $("#scd_nm").val(),
		 		  		bck_opt_cd : $("#bck_opt_cd").val(),
		 		  		bck_mtn_ecnt : "7",
		 		  		cps_yn : "N",
		 		  		log_file_bck_yn : "N",
		 		  		db_id : 0,
		 		  		bck_bsn_dscd : "TC000201",
		 		  		file_stg_dcnt : "7",
		 		  		log_file_stg_dcnt : "7",
		 		  		log_file_mtn_ecnt : "7",
		 		  		data_pth : $("#data_pth").val(),
		 		  		bck_pth : $("#bck_pth").val(),
		 		  		acv_file_stgdt : "7",
		 		  		acv_file_mtncnt : "7",
		 		  		log_file_pth : $("#rlog_file_pth").val()
		 		  	},
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
		 			success : function(data) {
		 				fn_insert_scheduler();
		 			}
		 		}); 
		  }else{
				$.ajax({
					async : false,
					url : "/popup/workDumpWrite.do",
				  	data : {
				  		db_svr_id : $("#db_svr_id").val(),
				  		wrk_nm : $("#scd_nm").val()+"_"+getTimeStamp(),
				  		wrk_exp : $("#scd_nm").val(),
				  		db_id : $("#db_id").val(),
				  		bck_bsn_dscd : "TC000202",
				  		save_pth : $("#save_pth").val(),
				  		cprt : "0",
				  		file_stg_dcnt : "0",
				  		bck_mtn_ecnt : "0",
				  		log_file_pth : $("#dlog_file_pth").val()
				  	},
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
					success : function(data) {
						fn_insert_scheduler();
					}
				});  
		  }
	 } 
	 
	 
	  function fn_insert_scheduler(){
		  var dayWeek = new Array();
		    var list = $("input[name='chk']");
		    for(var i = 0; i < list.length; i++){
		        if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
		        	dayWeek.push(1);
		        }else{
		        	dayWeek.push(list[i].value);
		        }
		    }
		    
		    var exe_dt = dayWeek.toString().replace(/,/gi,'').trim();
		    
			$.ajax({
				url : "/insert_bckSchedule.do",
				data : {
					 scd_nm : $("#scd_nm").val(),
					 scd_exp : $("#scd_nm").val(),
					 exe_perd_cd : "TC001602",
					 exe_dt : exe_dt,
					 exe_month : "01",
					 exe_day : "01",
					 exe_h : $("#exe_h").val(),
					 exe_m : $("#exe_m").val(),
					 exe_s	 : "00",			 
					 exe_hms : "00"+$("#exe_m").val()+$("#exe_h").val()
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
					alert("스케줄이 등록되었습니다.");
					opener.location.reload();
					self.close();
				}
			}); 	
	  }
</script>
<body>
<div class="pop_container">
		<div class="pop_cts">
			<p class="tit">주별 스케줄등록</p>
			<div class="sch_form">
				<table class="write">
					<caption>주별 스케줄등록</caption>
					<colgroup>
						<col style="width: 110px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="t9 line">스케줄명</th>
							<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm" /> 
							<span class="btn btnF_04 btnC_01">
									<button type="button" class="btn_type_02" onclick="fn_check()"style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button>
							</span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="t9 line">백업설정</th>
							<td>
							<select name="bck" id="bck" class="txt t3" style="width: 150px;" onChange="fn_bck();">
									<option value="">선택</option>
									<option value="rman">RMAN</option>
									<option value="dump">DUMP</option>
							</select> 
							<span id="rman_bck_opt"> 
							<select name="bck_opt_cd" id="bck_opt_cd" class="txt t3" style="width: 150px;">
										<option value="">선택</option>
										<option value="TC000301">FULL</option>
										<option value="TC000302">incremental</option>
										<option value="TC000303">archive</option>
								</select>
							</span> 
							<span id="dump_bck_opt"> 
							<select name="db_id" id="db_id" class="txt t3" style="width: 150px;">
										<option value="">선택</option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
											<option value="<c:out value="${result.db_id}"/>"><c:out
													value="${result.db_nm}" /></option>
										</c:forEach>
								</select>
							</span></td>
						</tr>

						<tr id="r_data_pth">
							<th scope="row" class="t9 line">데이터경로</th>
							<td>
								<input type="text" class="txt" name="data_pth"id="data_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path1').val('N')" /> 
								<span class="btn btnF_04 btnC_01">
								<button type="button" class="btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button>
								</span>
								<span id="dataVolume" style="margin: 70px;"></span>
							</td>
						</tr>
						<tr id="r_log_pth">
							<th scope="row" class="t9 line">백업로그경로</th>
							<td>
								<input type="text" class="txt" name="rlog_file_pth" id="rlog_file_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path2').val('N')" /> 
								<span class="btn btnF_04 btnC_01"><button type="button" class="btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
								<span id="rlogVolume" style="margin: 70px;"></span>
							</td>
						</tr>

						<tr id="r_bck_pth" rowsapn="2">
							<th scope="row" class="t9 line">백업경로</th>
							<td>
								<input type="text" class="txt" name="bck_pth" id="bck_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path3').val('N')" /> 
								<span class="btn btnF_04 btnC_01"><button type="button" class="btn_type_02" onclick="checkFolder(3)"style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
								<span id="backupVolume" style="margin: 70px;"></span>
							</td>
						</tr>

						<tr id="d_log_pth">
							<th scope="row" class="t9 line">백업로그경로</th>
							<td>
								<input type="text" class="txt" name="dlog_file_pth" id="dlog_file_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path4').val('N')" /> 
								<span class="btn btnF_04 btnC_01">
								<button type="button" class="btn_type_02" onclick="checkFolder(4)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
								<span id="dlogVolume" style="margin: 70px;"></span>
							</td>
						</tr>

						<tr id="d_bck_pth">
							<th scope="row" class="t9 line">백업경로</th>
							<td>
								<input type="text" class="txt" name="save_pth" id="save_pth" maxlength=50 style="width: 450px" onKeydown="$('#check_path5').val('N')" /> 
								<span class="btn btnF_04 btnC_01">
								<button type="button" class="btn_type_02" onclick="checkFolder(5)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
								<span id="saveVolume" style="margin: 70px;"></span>
							</td>
						</tr>

						<tr>
							<th scope="row" class="t9 line">스케줄설정</th>
							<td>
								<div class="schedule_wrap">
									<span id="weekDay"> 일 <input type="checkbox" id="chk"name="chk" value="0"> 
									월 <input type="checkbox" id="chk" name="chk" value="0"> 
									화 <input type="checkbox" id="chk" name="chk" value="0"> 
									수 <input type="checkbox" id="chk" name="chk" value="0"> 
									목 <input type="checkbox" id="chk" name="chk" value="0"> 
									금 <input type="checkbox" id="chk" name="chk" value="0"> 
									토 <input type="checkbox" id="chk" name="chk" value="0">
									</span> <span>
										<div id="hour"></div>
									</span> <span>
										<div id="min"></div>
									</span>
								</div>
							</td>
						</tr>

						<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}" />
						<input type="hidden" name="check_path1" id="check_path1" value="N" />
						<input type="hidden" name="check_path2" id="check_path2" value="N" />
						<input type="hidden" name="check_path3" id="check_path3" value="N" />
						<input type="hidden" name="check_path4" id="check_path4" value="N" />
						<input type="hidden" name="check_path5" id="check_path5" value="N" />
					</tbody>
				</table>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01"
					onClick="fn_insert_bckScheduler();"><button>등록</button></span>
			</div>
		</div>
	</div>
</body>
</html>