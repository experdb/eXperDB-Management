<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : transferSetting.jsp
	* @Description : TransferSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.19     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.19
	*
	*/
%>
<script>
	/* 숫자체크 */
	function valid_numeric(objValue)
	{
		if (objValue.match(/^[0-9]+$/) == null)
		{	return false;	}
		else
		{	return true;	}
	}

	/* Validation */
	function fn_transferValidation(){
		var filter = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
		var kafka_broker_ip = document.getElementById("kafka_broker_ip");
		if (kafka_broker_ip.value == "") {
			alert('<spring:message code="message.msg47" />');
			kafka_broker_ip.focus();
			return false;
		}
		if (filter.test(kafka_broker_ip.value) == false){
			alert('Kafka Broker <spring:message code="message.msg175" />');
			return false;
		}
 		var kafka_broker_port = document.getElementById("kafka_broker_port");
		if (kafka_broker_port.value == "") {
			alert('<spring:message code="message.msg48" />');
			kafka_broker_port.focus();
			return false;
		}
 		if(!valid_numeric(kafka_broker_port.value))
	 	{
 			alert('<spring:message code="message.msg49" />');
 			kafka_broker_port.focus();
		 	return false;
		}		
 		var schema_registry_ip = document.getElementById("schema_registry_ip");
		if (schema_registry_ip.value == "") {
			alert('<spring:message code="message.msg50" />');
			schema_registry_ip.focus();
			return false;
		}	
		if (filter.test(schema_registry_ip.value) == false){
			alert('Schema registry <spring:message code="message.msg175" />');
			return false;
		}
 		var schema_registry_port = document.getElementById("schema_registry_port");
		if (schema_registry_port.value == "") {
			alert('<spring:message code="message.msg51" />');
			schema_registry_port.focus();
			return false;
		}
 		if(!valid_numeric(schema_registry_port.value))
	 	{
 			alert('<spring:message code="message.msg49" />');
 			srportno.focus();
		 	return false;
		}
 		var zookeeper_ip = document.getElementById("zookeeper_ip");
		if (zookeeper_ip.value == "") {
			alert('<spring:message code="message.msg52" />');
			zookeeper_ip.focus();
			return false;
		}
		if (filter.test(zookeeper_ip.value) == false){
			alert('Zookeeper <spring:message code="message.msg175" />');
			return false;
		}
 		var zookeeper_port = document.getElementById("zookeeper_port");
		if (zookeeper_port.value == "") {
			alert('<spring:message code="message.msg53" />');
			zookeeper_port.focus();
			return false;
		}
 		if(!valid_numeric(zookeeper_port.value))
	 	{
 			alert('<spring:message code="message.msg49" />');
 			zookeeper_port.focus();
		 	return false;
		}
 		var teng_ip = document.getElementById("teng_ip");
		if (teng_ip.value == "") {
			alert('<spring:message code="message.msg54" />');
			teng_ip.focus();
			return false;
		}
		if (filter.test(teng_ip.value) == false){
			alert('experdb엔진 <spring:message code="message.msg175" />');
			return false;
		}
 		var teng_port = document.getElementById("teng_port");
		if (teng_port.value == "") {
			alert('<spring:message code="message.msg55" />');
			teng_port.focus();
			return false;
		}
 		if(!valid_numeric(teng_port.value))
	 	{
 			alert('<spring:message code="message.msg49" />');
 			teng_port.focus();
		 	return false;
		}
 		var bw_home = document.getElementById("bw_home");
		if (bw_home.value == "") {
			alert('<spring:message code="message.msg161"/>');
			bw_home.focus();
			return false;
		}
 		return true;		
	}
	
	/* 저장버튼 클릭시(전송설정 값이 없는 경우) */
	function fn_insert() {
		if (!fn_transferValidation()) return false;	
		$.ajax({
			url : '/insertTransferSetting.do',
			type : 'post',
			data : {
				kafka_broker_ip : $("#kafka_broker_ip").val(),
				kafka_broker_port : $("#kafka_broker_port").val(),
				schema_registry_ip : $("#schema_registry_ip").val(),
				schema_registry_port : $("#schema_registry_port").val(),
				zookeeper_ip : $("#zookeeper_ip").val(),
				zookeeper_port : $("#zookeeper_port").val(),
				teng_ip : $("#teng_ip").val(),
				teng_port : $("#teng_port").val(),
				bw_home : $("#bw_home").val(),
			},
			success : function(result) {
				alert('<spring:message code="message.msg57" />');
				window.location.reload();
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}
	
	/* 저장버튼 클릭시(전송설정 값이 있는 경우) */
	function fn_update() {
		if (!fn_transferValidation()) return false;	
		$.ajax({
			url : '/updateTransferSetting.do',
			type : 'post',
			data : {
				kafka_broker_ip : $("#kafka_broker_ip").val(),
				kafka_broker_port : $("#kafka_broker_port").val(),
				schema_registry_ip : $("#schema_registry_ip").val(),
				schema_registry_port : $("#schema_registry_port").val(),
				zookeeper_ip : $("#zookeeper_ip").val(),
				zookeeper_port : $("#zookeeper_port").val(),
				teng_ip : $("#teng_ip").val(),
				teng_port : $("#teng_port").val(),
				bw_home : $("#bw_home").val(),
				trf_cng_id : $("#trf_cng_id").val()
			},
			success : function(result) {
				alert('<spring:message code="message.msg57" />');
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}
	
	$(window.document).ready(function() {
		$.ajax({
			url : "/selectTransferSetting.do",
			data : {},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(data) {
 				if(data==null){
 					$('<button onclick="fn_insert()" id="btnInsert"></button>').text('<spring:message code="common.save"/>').appendTo('.btnC_01');
 				}else{
 				  $('<button onclick="fn_update()" id="btnInsert"></button>').text('<spring:message code="common.save"/>').appendTo('.btnC_01');
 				  $("#kafka_broker_ip").val(data.kafka_broker_ip);
 				  $("#kafka_broker_port").val(data.kafka_broker_port);
 				  $("#schema_registry_ip").val(data.schema_registry_ip);
 				  $("#schema_registry_port").val(data.schema_registry_port);
 				  $("#zookeeper_ip").val(data.zookeeper_ip);
 				  $("#zookeeper_port").val(data.zookeeper_port);
 				  $("#teng_ip").val(data.teng_ip);
 				  $("#teng_port").val(data.teng_port);
 				  $("#bw_home").val(data.bw_home); 	
 				  $("#trf_cng_id").val(data.trf_cng_id);
 				}
 				fn_buttonAut();
			}
		});
	});

	function fn_buttonAut(){
		var btnInsert = document.getElementById("btnInsert"); 
		if("${wrt_aut_yn}" == "Y"){
			btnInsert.style.display = '';
		}else{
			btnInsert.style.display = 'none';
		}
	}	
	
	function NumObj(obj) {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			event.returnValue = false;
		}
	}
</script>
<input type="hidden" id="trf_cng_id">
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				<spring:message code="menu.transfer_server_settings" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.transfer_server_settings_01" /> </li>
					<li><spring:message code="help.transfer_server_settings_02" /> </li>	
				</ul>
			</div>		
			<div class="location">
				<ul>
					<li>Function</li>
					<li><spring:message code="menu.data_transfer_information" /></li>
					<li class="on"><spring:message code="menu.transfer_server_settings" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_center">
				<table class="list">
					<caption>전송설정 화면 리스트</caption>
					<colgroup>
						<col style="width: 165px;" />
						<col style="width: 187px;" />
						<col style="width: 164px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><spring:message code="data_transfer.server_name" /></th>
							<th scope="col"><spring:message code="data_transfer.ip" /></th>
							<th scope="col"><spring:message code="data_transfer.port" /></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><spring:message code="data_transfer.kafka_broker" /></td>
							<td><input type="text" class="txt" name="kafka_broker_ip" id="kafka_broker_ip" /></td>
							<td class="type2"><input type="text" class="txt" name="kafka_broker_port" id="kafka_broker_port" onKeyPress="NumObj(this);"/></td>
						</tr>
						<tr>
							<td><spring:message code="data_transfer.schema_registry" /></td>
							<td><input type="text" class="txt" name="schema_registry_ip" id="schema_registry_ip" /></td>
							<td class="type2"><input type="text" class="txt" name="schema_registry_port" id="schema_registry_port" onKeyPress="NumObj(this);"/></td>
						</tr>
						<tr>
							<td><spring:message code="data_transfer.zookeeper" /></td>
							<td><input type="text" class="txt" name="zookeeper_ip" id="zookeeper_ip" /></td>
							<td class="type2"><input type="text" class="txt" name="zookeeper_port" id="zookeeper_port" onKeyPress="NumObj(this);"/></td>
						</tr>
						<tr>
							<td><spring:message code="data_transfer.experdb_agent" /></td>
							<td><input type="text" class="txt" name="teng_ip" id="teng_ip" /></td>
							<td class="type2"><input type="text" class="txt" name="teng_port" id="teng_port" onKeyPress="NumObj(this);"/></td>
						</tr>
						<tr>
							<td><spring:message code="data_transfer.bottledwater_home" /></td>
							<td colspan="2"><input type="text" class="txt" name="bw_home" id="bw_home" /></td>	
						</tr>
					</tbody>
				</table>
				<div class="btn_type_04">
					<span class="btn btnC_01"></span>
				</div>
			</div>
		</div>
	</div>
</div>