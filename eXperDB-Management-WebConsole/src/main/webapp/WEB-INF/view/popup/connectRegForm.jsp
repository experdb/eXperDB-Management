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
<title><spring:message code="etc.etc11"/></title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>

var connect_status_Chk = "fail";
var connect_nm_Chk = "fail";

var schemaList = ${schemas};
var tableList = ${tables};


	$(window.document).ready(function() {

		if("${act}" =="u"){	
			$("#db_id option").not(":selected").attr("disabled", "disabled");
			/* $("#snapshot_mode option").not(":selected").attr("disabled", "disabled"); */

			if(schemaList == ""){
				$('#trans_include_schema').val("");
			}else{
				$('#trans_include_schema').val("<spring:message code='migration.total_schema'/>${schema_total_cnt}<spring:message code='migration.selected_out_of'/>"+schemaList.length+"<spring:message code='migration.items'/>");
			}
			
			
			if(tableList == ""){
				$('#trans_include_table').val("");
			}else{
				$('#trans_include_table').val("<spring:message code='migration.total_table'/>${table_total_cnt}<spring:message code='migration.selected_out_of'/>"+tableList.length+"<spring:message code='migration.items'/>");
			}
			
			//$('#trans_include_schema').val("<spring:message code='migration.total_schema'/>${schema_total_cnt}<spring:message code='migration.selected_out_of'/>"+schemaList.length+"<spring:message code='migration.items'/>");
			//$('#trans_include_table').val("<spring:message code='migration.total_table'/>${table_total_cnt}<spring:message code='migration.selected_out_of'/>"+tableList.length+"<spring:message code='migration.items'/>");
		}
		
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
		
		if(valCheck()){
				var kafkaIp = $("#kc_ip").val();
				var kafkaPort=	$("#kc_port").val();
				var db_svr_id = "${db_svr_id}";
				var connect_nm=	$("#connect_nm").val();
				var db_id = $("#db_id").val();
				var snapshot_mode=	$("#snapshot_mode").val();
				var exrt_trg_scm_nm = $("#include_schema_nm").val() 
				var exrt_trg_tb_nm = $("#table_mapp_nm").val();
				var schema_total_cnt= $('#schema_total_cnt').val();
				var table_total_cnt = $('#table_total_cnt').val()
									
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
						table_total_cnt : table_total_cnt
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
					table_total_cnt : table_total_cnt
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
	 * 스키마 리스트
	 ******************************************************** */
	function fn_schemaList(gbn){
	
		if($('#db_id').val() == ""){
			alert("데이터베이스를 선택해주세요.");
			return false;
		}
		
		var frmSchemaPop= document.frmSchemaPopup;
		var url = '/popup/schemaMapp.do';
		window.open('','popupView','width=950, height=650');  
		     
		frmSchemaPop.action = url;
		frmSchemaPop.target = 'popupView';
		frmSchemaPop.db_svr_id.value = "${db_svr_id}";
		frmSchemaPop.db_nm.value = $("#db_id option:checked").text();
		frmSchemaPop.schemaGbn.value = gbn;
		
		
		if("${act}" =="u"){
			 if(gbn == 'include'){
					frmSchemaPop.include_schema_nm.value = schemaList;  
				}else{
					frmSchemaPop.exclude_schema_nm.value = schemaList;  
				} 
		}else{
			 if(gbn == 'include'){
					frmSchemaPop.include_schema_nm.value = $('#include_schema_nm').val();  
				}else{
					frmSchemaPop.exclude_schema_nm.value = $('#exclude_schema_nm').val();  
				} 
		}

		frmSchemaPop.submit();   
	}	


	/* ********************************************************
	 * 테이블 리스트
	 ******************************************************** */
	function fn_tableList(gbn){

		if($('#db_id').val() == ""){
			alert("데이터베이스를 선택해주세요.");
			return false;
		}
		
		var frmTablePop= document.frmTablePopup;
		
		var url = '/popup/tableMapp.do';
		
		window.open('','popupView','width=950, height=650');  
		

		frmTablePop.action = url;
		frmTablePop.target = 'popupView';
		frmTablePop.db_svr_id.value = "${db_svr_id}";
		frmTablePop.tableGbn.value = gbn;
		frmTablePop.db_nm.value = $("#db_id option:checked").text();
		
		frmTablePop.act.value = "${act}";
		
		
		if("${act}" =="u"){
			 if(gbn == 'include'){
				 frmTablePop.include_table_nm.value = tableList;  
				}else{
				frmTablePop.exclude_table_nm.value = tableList;  
				} 
		}else{
			 if(gbn == 'include'){
					frmTablePop.include_table_nm.value = $('#include_table_nm').val();  
				}else{
					frmTablePop.exclude_table_nm.value = $('#exclude_table_nm').val();  
				} 
		}

		frmTablePop.submit();   
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
 * 스키마 맵핑 콜백 함수
 ******************************************************** */
function fn_schemaAddCallback(rowList, schemaGbn, totalCnt){
	if(schemaGbn == 'include'){
		 $('#trans_include_schema').val("<spring:message code='migration.total_schema'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#include_schema_nm').val(rowList);
		$('#schema_total_cnt').val(totalCnt);
	}else{
		$('#trans_exclude_schema').val("<spring:message code='migration.total_schema'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#exclude_schema_nm').val(rowList);
		$('#schema_total_cnt').val(totalCnt);
	}
}



/* ********************************************************
 * 테이블 맵핑 콜백 함수
 ******************************************************** */
function fn_tableAddCallback(rowList, tableGbn, totalCnt, table_mapp){
	
	if(tableGbn == 'include'){
		 $('#trans_include_table').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#include_table_nm').val(JSON.stringify(rowList));
		$('#table_total_cnt').val(totalCnt);
		$('#table_mapp_nm').val(table_mapp);		
	}else{
		$('#trans_exclude_table').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#exclude_table_nm').val(JSON.stringify(rowList));
		$('#table_total_cnt').val(totalCnt);
		$('#table_mapp_nm').val(table_mapp);
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
			<c:if test="${act == 'i'}">전송설정 등록</c:if>
			<c:if test="${act == 'u'}"> 전송설정 수정</c:if>
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
									<c:if test="${act == 'i'}">
									<input type="text" class="txt" name="kc_ip" id="kc_ip"  />
									</c:if>
									<c:if test="${act == 'u'}">
									<input type="text" class="txt" name="kc_ip" id="kc_ip" value="${kc_ip}"  readonly="readonly"/>
									</c:if>
								</td>					
							
							<td class="type2">
								<c:if test="${act == 'i'}">
									<input type="text" class="txt" name="kc_port" id="kc_port"  />								
								</c:if>
								<c:if test="${act == 'u'}">
										<input type="text" class="txt" name="kc_port" id="kc_port" value="${kc_port}" maxlength="20" readonly="readonly"/>
								</c:if>
							</td>
							<c:if test="${act == 'i'}">	
							<td><button style="width: 90px;height: 35px;" onClick="fn_kcConnectTest();">연결 테스트</button></td>	
							</c:if>											
						</tr>					
					</tbody>
				</table>
		</div>
		
		
		<div class="pop_cmm mt25">
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}"><spring:message code="menu.access_control" /> <spring:message code="common.registory" /></c:if>
					<c:if test="${act == 'u'}"><spring:message code="menu.access_control" />  <spring:message code="common.modify" /></c:if>
				</caption>
				<colgroup>
					<col style="width:140px;" />
					<col style="width:300px;" />
					<col style="width:400px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Connect명</th>
						<td colspan="2">		
						<c:if test="${act == 'i'}">
							<input type="text" class="txt"  name="connect_nm"  id="connect_nm"/>			
							<span class="btn btnC_01"><button type="button" class="btn_type_02" onclick="fn_check()" style="width: 85px; height: 38px; margin-right: -60px; margin-top: 0;">
							<spring:message code="common.overlap_check" /></button></span>
						</c:if>		
						<c:if test="${act == 'u'}">
									<input type="text" class="txt" name="connect_nm" id="connect_nm" value="${connect_nm}" readonly="readonly"/>
						</c:if>											
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1"><spring:message code="common.database" /></th>
						<td colspan="2">
							<select name="db_id" id="db_id" class="select" >
								<option value=""><spring:message code="common.choice" /></option>
								<c:forEach var="result" items="${dbList}" varStatus="status">
								<option value="<c:out value="${result.db_id}"/>"<c:if test="${db_nm eq result.db_nm}"> selected</c:if>><c:out value="${result.db_nm}"/></option>
								<%-- <option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}"/></option> --%>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">스냅샷 모드</th>
						<td>
							<select id="snapshot_mode" name="snapshot_mode" class="select" >
								<c:forEach var="result" items="${snapshotModeList}">
								<c:if test="${act == 'i'}">
								<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${result.sys_cd ==  'TC003603'}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
								</c:if>
								<c:if test="${act == 'u'}">
								
									<option value="<c:out value="${result.sys_cd}"/>"<c:if test="${snapshot_nm eq result.sys_cd_nm}"> selected</c:if>><c:out value="${result.sys_cd_nm}"/></option>
								</c:if>
								</c:forEach>							
							</select>							
						</td>
						<td style="font-size:13px; font-style:italic;">
							<span id="snapshotModeDetail" name="snapshotModeDetail"></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">
							<select name="src_tables" id="src_tables" class="select" >
								<option value="include">대상 스키마</option>
								<!-- <option value="exclude">제외 스키마</option> -->
							</select>
						</th>
						<td>
							<div id="include">
								<input type="text" class="txt" name="trans_include_schema" id="trans_include_schema" readonly="readonly" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_schemaList('include')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>		
							</div>
							<div id="exclude" style="display: none;">
								<input type="text" class="txt" name="trans_exclude" id="trans_exclude" readonly="readonly" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_schemaList('exclude')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>												
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">
							<select name="src_tables" id="src_tables" class="select" >
								<option value="include">대상 테이블</option>
								<!-- <option value="exclude">제외 테이블</option> -->
							</select>
						</th>
						<td>
							<div id="include">
								<input type="text" class="txt" name="trans_include_table" id="trans_include_table" readonly="readonly" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList('include')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>		
							</div>
							<div id="exclude" style="display: none;">
								<input type="text" class="txt" name="trans_exclude_table" id="trans_exclude_table" readonly="readonly" />
								<span class="btn btnC_01"><button type="button" class= "btn_type_02" onclick="fn_tableList('exclude')" style="width: 60px; margin-right: -60px; margin-top: 0;">등록</button></span>												
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01">					
				<c:if test="${act == 'i'}">
					<button type="button" onclick="fn_insert()" ><spring:message code="common.save"/></button>
				</c:if>
				<c:if test="${act == 'u'}">
					<button type="button" onclick="fn_update()"><spring:message code="common.save"/></button>
				</c:if>
			</span>
		</div>
	</div>
</div>

</body>
</html>