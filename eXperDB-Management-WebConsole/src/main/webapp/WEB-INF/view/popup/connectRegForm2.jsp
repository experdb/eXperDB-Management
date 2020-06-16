<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : connectRegForm.jsp
	* @Description : connectRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2020. 04. 07
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Database 매핑작업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>

var connect_status_Chk = "fail";
var connect_nm_Chk = "fail";

var schema_List=null;
var connector_schemaList = null;

var tableList = null;
var connector_tableList = null;

function fn_init(){
	
	schema_List = $('#schema_List').DataTable({
		scrollY : "340px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "schema_name", className : "dt-center", defaultContent : ""},
		],'select': {'style': 'multi'}
	});
		
	schema_List.tables().header().to$().find('th:eq(0)').css('min-width', '100px');
		
	connector_schemaList = $('#connector_schemaList').DataTable({
			scrollY : "340px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : true,
			columns : [
			{data : "schema_name", className : "dt-center", defaultContent : ""},
			],'select': {'style': 'multi'}
		});
			
	connector_schemaList.tables().header().to$().find('th:eq(0)').css('min-width', '100px');
	

	tableList = $('#tableList').DataTable({
		scrollY : "340px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "schema_name", className : "dt-center", defaultContent : ""},
		{data : "table_name", className : "dt-center", defaultContent : ""},
		],'select': {'style': 'multi'}
	});
		
	tableList.tables().header().to$().find('th:eq(0)').css('min-width', '161px');
	tableList.tables().header().to$().find('th:eq(1)').css('min-width', '162px');


		connector_tableList = $('#connector_tableList').DataTable({
			scrollY : "340px",
			scrollX: true,	
			processing : true,
			searching : false,
			paging : true,	
			columns : [
			{data : "schema_name", className : "dt-center", defaultContent : ""},
			{data : "table_name", className : "dt-center", defaultContent : ""},			
			 ],'select': {'style': 'multi'}
		});
		
		connector_tableList.tables().header().to$().find('th:eq(0)').css('min-width', '161px');
		connector_tableList.tables().header().to$().find('th:eq(1)').css('min-width', '162px');

		$(window).trigger('resize'); 
}



	$(window.document).ready(function() {
		fn_init();
		$("#snapshotModeDetail").html("(스냅샷 수행하지 않음)");		
	});



/* ********************************************************
 * select box control
 ******************************************************** */
 $(function() {
	 $("#snapshot_mode").change(function(){ 
			 if(this.value == "TC003601"){
				 $("#snapshotModeDetail").html("(초기스냅샷 1회만 수행)");
			 }else if(this.value == "TC003602"){
				 $("#snapshotModeDetail").html("(스냅샷 항상 수행)");
			 }else if (this.value == "TC003603"){
				 $("#snapshotModeDetail").html("(스냅샷 수행하지 않음)");
			 }else if (this.value == "TC003604"){
				 $("#snapshotModeDetail").html("(스냅샷만 수행하고 종료)");
			 }else if (this.value == "TC003605"){
				 $("#snapshotModeDetail").html("(복제슬롯이 생성된 시접부터의 스냅샷 lock 없는 효율적방법)");
			 }
		});
	 
	 
	 $("#db_id").change(function(){ 
		 tableList.clear().draw();
		 connector_tableList.clear().draw();
	});
 });



	/* ********************************************************
	 * Validation Check
	 ******************************************************** */
	function valCheck(){
		if($("#connect_nm").val() == ""){
			alert("커넥터명을 입력해주세요.");
			$("#connect_nm").focus();
			return false;
		}else if($("#db_id").val() ==""){
			alert("데이터베이스를 선택해주세요.");
			return false;
		}else if(connect_status_Chk == "fail"){
			alert('커넥터 연결상태를 확인해주세요.');
			return false;
		}else if(connect_nm_Chk == "fail"){
			alert("커넥터명이 중복 체크 바랍니다. ");
			return false;
		}else{
			return true;
		}
	}
	
	

	/* ********************************************************
	 * 커넥터 설정 등록
	 ******************************************************** */
	function fn_insert() {
		var schema_mapp = [];
		var table_mapp = [];

		
		var schemaDatas = connector_schemaList.rows().data();
		
		if(schemaDatas.length > 0){
			var schemaRowList = [];
			for (var i = 0; i < schemaDatas.length; i++) {
				schemaRowList.push( connector_schemaList.rows().data()[i]);    
		        schema_mapp.push(connector_schemaList.rows().data()[i].schema_name);
			  }	
		}
		
		var tableDatas = connector_tableList.rows().data();
		
		if(tableDatas.length > 0){
			var tableRowList = [];
			for (var i = 0; i < tableDatas.length; i++) {
				tableRowList.push( connector_tableList.rows().data()[i]);    
		        table_mapp.push(connector_tableList.rows().data()[i].schema_name+"."+connector_tableList.rows().data()[i].table_name);
		  	}
		}
		
		$('#include_schema_nm').val(schema_mapp);
		$('#table_mapp_nm').val(table_mapp);
		
		if(valCheck()){
				var kafkaIp = $("#kc_ip").val();
				var kafkaPort=	$("#kc_port").val();
				var db_svr_id = "${db_svr_id}";
				var connect_nm=	$("#connect_nm").val();
				var db_id = $("#db_id").val();
				var snapshot_mode=	$("#snapshot_mode").val();
				var exrt_trg_scm_nm = $("#include_schema_nm").val() 
				var exrt_trg_tb_nm = $("#table_mapp_nm").val();
				var schema_total_cnt= 0;
				var table_total_cnt = 0;
				var compression_type=	$("#compression_type").val();			
				
				$.ajax({
					url : '/insertConnectInfo.do',
					type : 'post',
					data : {
						kc_ip : kafkaIp,
						kc_port : kafkaPort,
						db_svr_id : db_svr_id,
						connect_nm : connect_nm,
						db_id : db_id,
						snapshot_mode : snapshot_mode,
						exrt_trg_scm_nm : exrt_trg_scm_nm,
						exrt_trg_tb_nm : exrt_trg_tb_nm,
						schema_total_cnt : schema_total_cnt,
						table_total_cnt : table_total_cnt,
						compression_type : compression_type
					},
					success : function(result) {
						if(result == true){
							alert("등록하였습니다.");
							opener.fn_select();
							self.close();
						}else{
							alert("등록에 실패 하였습니다.");
						}
					},
					beforeSend: function(xhr) {
				        xhr.setRequestHeader("AJAX", true);
				     },
					error : function(xhr, status, error) {
						if(xhr.status == 401) {
							alert('<spring:message code="message.msg02" />');
							top.location.href = "/";
						} else if(xhr.status == 403) {
							alert('<spring:message code="message.msg03" />');
							top.location.href = "/";
						} else {
							alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
						}
					}
				});	
		}
	}
	
	
	
	
	
	/* 수정 버튼 클릭시*/
	function fn_update() {
			
			var trans_id = "${trans_id}";
			var db_id = $("#db_id").val();
			var exrt_trg_scm_nm = $("#include_schema_nm").val() 
			var exrt_trg_tb_nm = $("#table_mapp_nm").val();
			var schema_total_cnt= $('#schema_total_cnt').val();
			var table_total_cnt = $('#table_total_cnt').val();
			var trans_exrt_trg_tb_id	 =	"${trans_exrt_trg_tb_id}";
			var snapshot_mode=	$("#snapshot_mode").val();
			var compression_type=	$("#compression_type").val();	
			
			$.ajax({
				url : '/updateConnectInfo.do',
				type : 'post',
				data : {
					trans_id : trans_id,
					trans_exrt_trg_tb_id : trans_exrt_trg_tb_id,
					exrt_trg_scm_nm : exrt_trg_scm_nm,
					snapshot_mode : snapshot_mode,
					exrt_trg_tb_nm : exrt_trg_tb_nm,
					schema_total_cnt : schema_total_cnt,
					table_total_cnt : table_total_cnt,
					compression_type : compression_type
				},
				success : function(result) {
					if(result == true){
						alert("수정하였습니다.");
						opener.fn_select();
						self.close();
					}else{
						alert("수정에 실패 하였습니다.");
					}
				},
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert('<spring:message code="message.msg02" />');
						top.location.href = "/";
					} else if(xhr.status == 403) {
						alert('<spring:message code="message.msg03" />');
						top.location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				}
			});	

	}

	
	
	/* ********************************************************
	 * 커넥터 연결테스트
	 ******************************************************** */
	function fn_kcConnectTest(){

		var kafkaIp = $("#kc_ip").val();
		var kafkaPort=	$("#kc_port").val();
			
		$.ajax({
			url : '/kafkaConnectionTest.do',
			type : 'post',
			data : {
				db_svr_id : "${db_svr_id}",
				kafkaIp : kafkaIp,
				kafkaPort : kafkaPort
			},
			success : function(result) {
				if(result.RESULT_DATA =="success"){
					connect_status_Chk ="success";
					alert("kafka-Connection SUCCESS")
				}else{
					connect_status_Chk ="fail";
					alert("kafka-Connection FAIL")
					
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});			
	}
	
	
	
/* ********************************************************
 * 커넥터명 중복체크
 ******************************************************** */
function fn_check() {
	var connect_nm = document.getElementById("connect_nm");
	
	if (connect_nm.value == "") {
		alert('<spring:message code="message.msg107" />');
		document.getElementById('connect_nm').focus();
		return;
	}
	
	$.ajax({
		url : '/connect_nm_Check.do',
		type : 'post',
		data : {
			connect_nm : $("#connect_nm").val()
		},
		success : function(result) {
			if (result == "true") {
				alert('사용가능한 커넥터명 입니다.');
				document.getElementById("connect_nm").focus();
				connect_nm_Chk = "success";
			} else {
				connect_nm_Chk = "fail";
				alert('이미 존재하는 커넥터명 입니다.');
				document.getElementById("connect_nm").focus();
			}
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", true);
		},
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if (xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : " + xhr.status + "\n\n"
						+ "ERROR Message : " + error + "\n\n"
						+ "Error Detail : "
						+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		}
	});
}	



/* ********************************************************
 *  스키마 리스트 조회
 ******************************************************** */
function fn_schema_search(){
	
	var db_svr_id = "${db_svr_id}";
	var db_nm = $("#db_id option:checked").text();
	
	var schema_nm = null;
	
	if($("#schema_nm").val() == ""){
		schema_nm="%";
	}else{
		schema_nm=$("#schema_nm").val();
	}
	
	$.ajax({
		url : "/selectSchemaList.do",
		data : {
			db_svr_id : db_svr_id,
			db_nm : db_nm,
			schema_nm : "%"
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			schema_List.rows({selected: true}).deselect();
			schema_List.clear().draw();
			schema_List.rows.add(result.RESULT_DATA).draw();	  
		}
	});
}



/* ********************************************************
 * 테이블 리스트 조회
 ******************************************************** */
function fn_table_search(){
	
	var db_svr_id = "${db_svr_id}";
	var db_nm = $("#db_id option:checked").text();
	
	var table_nm = null;
	
	if($("#table_nm").val() == ""){
		table_nm="%";
	}else{
		table_nm=$("#table_nm").val();
	}
	
	$.ajax({
		url : "/selectTableMappList.do",
		data : {
			db_svr_id : db_svr_id,
			db_nm : db_nm,
			table_nm : table_nm
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {				
			connector_tableList.columns.adjust().draw();
			tableList.rows({selected: true}).deselect();
			tableList.clear().draw();
			tableList.rows.add(result.RESULT_DATA).draw();
		}
	});
}

/* ********************************************************
 * Tab Click
 ******************************************************** */
function selectTab(tab){
	var db_svr_id = "${db_svr_id}";
	var db_nm = $("#db_id option:checked").text();
	
	if(tab == "schema"){		
		$("#tab1").hide();
		$("#tab2").show()
		$("#tab3").hide();
		
		if($('#db_id').val() == ""){	
			$('.tab li')[1].classList.remove('on');
			$('.tab li')[0].classList.add('on');
			
			$("#tab1").show();
			$("#tab2").hide()
			
			alert("데이터베이스를 선택해주세요.");

			return false;
		}
		
		fn_schema_search();
		
	}else if(tab == "table"){
		
		$("#tab1").hide();
		//$("#tab2").hide()
		$("#tab3").show();

		if($('#db_id').val() == ""){	
			alert("데이터베이스를 선택해주세요.");
			
			$('.tab li')[1].classList.remove('on');
			$('.tab li')[0].classList.add('on');
			
			$("#tab1").show();
			$("#tab3").hide()
			return false;
		}		
		
		//var tableDatas = tableList.rows().data();
		var tableDatas = connector_tableList.rows().data();
		
		if(tableDatas.length == 0){
			fn_table_search();
		}

		
	}else{
		$("#tab1").show();
		$("#tab2").hide()
		$("#tab3").hide();
	}
}



/*================ 스키마 리스트 조정 ======================= */

	/*-> 클릭시*/
	function fn_s_rightMove(){
		var datas = schema_List.rows('.selected').data();
		if(datas.length <1){
			alert('<spring:message code="message.msg35" />');	
		}else{
			var rows = [];
    	for (var i = 0;i<datas.length;i++) {
			rows.push(schema_List.rows('.selected').data()[i]); 
		}
    	
    	connector_schemaList.rows.add(rows).draw();
    	schema_List.rows('.selected').remove().draw();
		}	 		 
}
	
	/*->> 클릭시*/
	function fn_s_allRightMove(){
		var datas = schema_List.rows().data();
		if(datas.length <1){
			alert('<spring:message code="message.msg01" />');	
		}else{
	 		var rows = [];
	        for (var i = 0;i<datas.length;i++) {
				rows.push(schema_List.rows().data()[i]); 
			}
	        connector_schemaList.rows.add(rows).draw(); 	
	        schema_List.rows({selected: true}).deselect();
	        schema_List.rows().remove().draw();
		}

}
	
	
	/*<- 클릭시*/
	function fn_s_leftMove(){
		var datas = connector_schemaList.rows('.selected').data();
		if(datas.length <1){
			alert('<spring:message code="message.msg35" />');	
		}else{
			var rows = [];
    	for (var i = 0;i<datas.length;i++) {
			rows.push(connector_schemaList.rows('.selected').data()[i]); 
		}
    	schema_List.rows.add(rows).draw();
    	connector_schemaList.rows('.selected').remove().draw();	
		}	 
	}

	/*<<- 클릭시*/
	function fn_s_allLeftMove(){
		var datas = connector_schemaList.rows().data();
		if(datas.length <1){
			alert('<spring:message code="message.msg01" />');	
		}else{
	 		var rows = [];
	        for (var i = 0;i<datas.length;i++) {
				rows.push(connector_schemaList.rows().data()[i]); 
			}
	        schema_List.rows.add(rows).draw(); 
	        connector_schemaList.rows({selected: true}).deselect();
	        connector_schemaList.rows().remove().draw();
		}
	}

	
/*================ 테이블 리스트 조정 ======================= */
	/*-> 클릭시*/
	function fn_t_rightMove(){
		var datas = tableList.rows('.selected').data();
		if(datas.length <1){
			alert('<spring:message code="message.msg35" />');	
		}else{
			var rows = [];
    	for (var i = 0;i<datas.length;i++) {
			rows.push(tableList.rows('.selected').data()[i]); 
		}
    	
    	connector_tableList.rows.add(rows).draw();
    	tableList.rows('.selected').remove().draw();
		}	 		 
}
	
	/*->> 클릭시*/
	function fn_t_allRightMove(){
		var datas = tableList.rows().data();
		if(datas.length <1){
			alert('<spring:message code="message.msg01" />');	
		}else{
	 		var rows = [];
	        for (var i = 0;i<datas.length;i++) {
				rows.push(tableList.rows().data()[i]); 
			}
	        connector_tableList.rows.add(rows).draw(); 	
	        tableList.rows({selected: true}).deselect();
	        tableList.rows().remove().draw();
		}

}
	
	
	/*<- 클릭시*/
	function fn_t_leftMove(){
		var datas = connector_tableList.rows('.selected').data();
		if(datas.length <1){
			alert('<spring:message code="message.msg35" />');	
		}else{
			var rows = [];
    	for (var i = 0;i<datas.length;i++) {
			rows.push(connector_tableList.rows('.selected').data()[i]); 
		}
    	tableList.rows.add(rows).draw();
    	connector_tableList.rows('.selected').remove().draw();	
		}	 
	}

	/*<<- 클릭시*/
	function fn_t_allLeftMove(){
		var datas = connector_tableList.rows().data();
		if(datas.length <1){
			alert('<spring:message code="message.msg01" />');	
		}else{
	 		var rows = [];
	        for (var i = 0;i<datas.length;i++) {
				rows.push(connector_tableList.rows().data()[i]); 
			}
	        tableList.rows.add(rows).draw(); 
	        connector_tableList.rows({selected: true}).deselect();
	        connector_tableList.rows().remove().draw();
		}
	}
	</script>

<body>

<form name="frmSchemaPopup">
	<input type="hidden" name="db_svr_id"  id="db_svr_id">
	<input type="hidden" name="include_schema_nm"  id="include_schema_nm" >
	<input type="hidden" name="exclude_schema_nm"  id="exclude_schema_nm" >
	<input type="hidden" name="db_nm"  id="db_nm" >
	<input type="hidden" name="schemaGbn"  id="schemaGbn" >
 	<input type="hidden" name="schema_total_cnt" id="schema_total_cnt">
</form>

<form name="frmTablePopup">
	<input type="hidden" name="db_svr_id"  id="db_svr_id">
	<input type="hidden" name="include_table_nm"  id="include_table_nm" >
	<input type="hidden" name="exclude_table_nm"  id="exclude_table_nm" >
	<input type="hidden" name="db_nm"  id="db_nm" >
	<input type="hidden" name="tableGbn"  id="tableGbn" >
	<input type="hidden" name="table_total_cnt" id="table_total_cnt">
	<input type="hidden" name="table_mapp_nm" id="table_mapp_nm">
	<input type="hidden" name="act" id="act">
</form>

<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			전송설정 등록
		</p>
		<div class="pop_cmm">
		
		<table class="list">
					<caption>전송설정 화면 리스트</caption>
					<colgroup>
						<col style="width: 165px;" />
						<col style="width: 120px;" />
						<col style="width: 90px;" />
						<col style="width: 65px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><spring:message code="data_transfer.server_name" /></th>
							<th scope="col"><spring:message code="data_transfer.ip" /></th>
							<th scope="col"><spring:message code="data_transfer.port" /></th>
							<th scope="col" rowspan="2"></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>Kafka-Connect</td>				
							<td>
								<input type="text" class="txt" name="kc_ip" id="kc_ip"  />
							</td>												
							<td class="type2">
									<input type="text" class="txt" name="kc_port" id="kc_port"  />								
							<td><button style="width: 90px;height: 35px;" onClick="fn_kcConnectTest();">연결 테스트</button></td>											
						</tr>					
					</tbody>
				</table>
		</div>
		
		<div class="pop_cmm c2 mt25">
			<div class="addOption_grp">
				<ul class="tab" id="tabList">
					<li class="on"><a href="javascript:selectTab('seeting')">커넥터 설정</a></li>
					<!-- <li><a href="javascript:selectTab('schema')">스키마 맵핑</a></li> -->
					<li><a href="javascript:selectTab('table')">테이블 맵핑</a></li>
				</ul>	
				<div class="tab_view" >
					<div class="view on addOption_inr" id="tab1">
						<ul>
							<li>
								<p class="op_tit">Connect명 </p>
									<input type="text" class="txt"  name="connect_nm"  id="connect_nm"/ style="width:300px;">			
									<span class="btn btnC_01"><button type="button" class="btn_type_02" onclick="fn_check()" style="width: 85px; height: 38px; margin-right: -60px; margin-top: 0;">
									<spring:message code="common.overlap_check" /></button></span>
							</li>
							<li>
								<p class="op_tit">데이터베이스</p>			
									<select name="db_id" id="db_id" class="select"  style="width:300px;">
										<option value=""><spring:message code="common.choice" /></option>
										<c:forEach var="result" items="${dbList}" varStatus="status">
										<option value="<c:out value="${result.db_id}"/>"<c:if test="${db_nm eq result.db_nm}"> selected</c:if>><c:out value="${result.db_nm}"/></option>
										</c:forEach>
									</select>
							</li>
							<li>
								<p class="op_tit">스냅샷 모드</p>
									<select id="snapshot_mode" name="snapshot_mode" class="select"  style="width:300px;">
										<c:forEach var="result" items="${snapshotModeList}">
										<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${result.sys_cd ==  'TC003603'}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>							
									</select>									
									<span id="snapshotModeDetail" name="snapshotModeDetail"></span>					
							</li>
							<li>
								<p class="op_tit">압축모드</p>
									<select id="compression_type" name="compression_type" class="select"  style="width:300px;">
										<c:forEach var="result" items="${compressionTypeList}">
											<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${result.sys_cd ==  'TC003701'}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>							
									</select>									
									<span id="snapshotModeDetail" name="snapshotModeDetail"></span>					
							</li>
						</ul>
					</div>
					
					
					
					
					<!-- <div class="view" id="tab2">
						<div class="mapping_area" style="height:520px;">
							<div class="mapping_lt" style="width:400px;">
								<p class="tit">스키마 리스트</p>
						
								<table id="schema_List" class="display" cellspacing="0" width="100%">
									<thead>
										<tr>
											<th width="100" class="dt-center">스키마명</th>
										</tr>
									</thead>
								</table>											
								</div>
					
							<div class="mapping_rt" style="width:400px;">
								<p class="tit">전송대상 스키마</p>
								
								<table id="connector_schemaList" class="display" cellspacing="0" width="100%">
									<thead>
										<tr>
											<th width="100" class="dt-center">스키마명</th>
										</tr>
									</thead>
								</table>								
								
							</div>
							<div class="mapping_btn">
								<a href="#n" onclick="fn_s_allRightMove();"><img src="../../images/popup/ico_p_4.png" alt="전체우로" /></a>
								<a href="#n" onclick="fn_s_rightMove();"><img src="../../images/popup/ico_p_5.png" alt="한개우로" /></a>
								<a href="#n" onclick="fn_s_leftMove();"><img src="../../images/popup/ico_p_6.png" alt="한개좌로" /></a>
								<a href="#n" onclick="fn_s_allLeftMove();"><img src="../../images/popup/ico_p_7.png" alt="전체좌로" /></a>
							</div>
						</div>
					</div> -->
					
									
					
					<div class="view" id="tab3">					
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 115px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t9"><spring:message code="migration.table_name"/></th>
										<td><input type="text" class="txt t3" name="table_nm" id="table_nm" />
											<span class="btn" onclick="fn_table_search()" style="padding-left: 460px;">
												<button type="button" style="height: 25px;line-height: 0px;"><spring:message code="common.search" /></button>
											</span>
										</td>								
									</tr>
								</tbody>
							</table>
						</div>
					
						<div class="trans_mapping_area" style="height:520px;">		
								<div class="trans_mapping_lt" style="width:400px;">
										<p class="trans_tit"><spring:message code="data_transfer.tableList"/></p>		
											<table id=tableList  class="display" cellspacing="0" width="100%" >
												<thead>
													<tr>
														<th width="161"  class="dt-center" style="width:161px;">스키마명</th>
														<th width="162"  class="dt-center" style="width:162px;">테이블명</th>
													</tr>
												</thead>
											</table>																				
									</div>
									
									<div class="trans_mapping_rt" style="width:400px;">
										<p class="trans_tit"><spring:message code="data_transfer.transfer_table"/></p>
													
										<table id=connector_tableList class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th width="161" class="dt-center" >스키마명</th>
														<th width="162" class="dt-center" >테이블명</th>														
													</tr>
												</thead>
											</table>									
									</div>
									
									<div class="trans_mapping_btn">
										<a href="#n" onclick="fn_t_allRightMove();"><img src="../../images/popup/ico_p_4.png" alt="전체우로" /></a>
										<a href="#n" onclick="fn_t_rightMove();"><img src="../../images/popup/ico_p_5.png" alt="한개우로" /></a>
										<a href="#n" onclick="fn_t_leftMove();"><img src="../../images/popup/ico_p_6.png" alt="한개좌로" /></a>
										<a href="#n" onclick="fn_t_allLeftMove();"><img src="../../images/popup/ico_p_7.png" alt="전체좌로" /></a>
									</div>
								</div>
					</div>
					
					
					
				</div>
			</div>
			</form>
		</div>
		
		<div class="btn_type_02">
			<span class="btn btnC_01">					
					<button type="button" onclick="fn_insert()" ><spring:message code="common.save"/></button>
			</span>
		</div>
	</div>
</div>

</body>
</html>