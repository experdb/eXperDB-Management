<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : transKafkaConSetting.jsp
	* @Description : transKafkaConSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2017.07.24
	*
	*/
%>
<script type="text/javascript">
	var trans_connect_table = null;
	var trans_regi_table = null;
	var trans_connect_id_List = [];
	var trans_regi_id_List = [];
	
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_trans_connect_init();

		//화면 조회
		fn_connect_select();
		fn_regi_select();
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_trans_connect_init(){
		trans_connect_table = $('#transKfkConnectList').DataTable({
			scrollY : "300px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			paging: false,
			columns : [
 						{data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
 						{data : "kc_nm", className : "dt-left", defaultContent : ""},
 						{data : "kc_ip", className : "dt-center", defaultContent : ""},
 						{data : "kc_port", className : "dt-center", defaultContent : ""},
 						{data : "exe_status", 
 							render: function (data, type, full){
 								var html = "";
 								if(full.exe_status == "TC001501"){
 									html += "<div class='badge badge-pill badge-success'>";
 									html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
 									html += "	<spring:message code='eXperDB_CDC.connecting' />";
 								} else {
 									html += "<div class='badge badge-pill badge-danger'>";
 									html += "	<i class='ti-close mr-2'></i>";
 									html += "	<spring:message code='schedule.stop' />";
 								}

 								html += "</div>";

 								return html;
 							},
 							className : "dt-left",
 							defaultContent : "" 	
 						},
 						{data : "conn_test_btn", className : "dt-center", defaultContent : "",
 							render: function (data, type, full){
 								var html =""; 
 								html +="<span onclick=\"fn_connect_con_test_btn('"+full.kc_ip+"','"+full.kc_port+"','kafka',"+full.rownum+")\" class=\"bold\">";
 								html +="	<i class='mdi mdi-lan-connect'></i> ";
 								html +="	<spring:message code='dbms_information.conn_Test' />";
								html +="</span>";
								return html;
 							}
 						},
 						{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
 						{data : "kc_id",  defaultContent : "", visible: false }
 			],'select': {'style': 'multi'}
		});

		trans_connect_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		trans_connect_table.tables().header().to$().find('th:eq(1)').css('min-width', '10px');
		trans_connect_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		trans_connect_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		trans_connect_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		trans_connect_table.tables().header().to$().find('th:eq(5)').css('min-width', '80px');
		trans_connect_table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		trans_connect_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		trans_connect_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');

		
		//transRegiConnectList
		trans_regi_table = $('#transRegiConnectList').DataTable({
			scrollY : "300px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			paging: false,
			columns : [
 						{data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
 						{data : "regi_nm", className : "dt-left", defaultContent : ""},
 						{data : "regi_ip", className : "dt-center", defaultContent : ""},
 						{data : "regi_port", className : "dt-center", defaultContent : ""},
 						{data : "exe_status", 
 							render: function (data, type, full){
 								var html = "";
 								if(full.exe_status == "TC001501"){
 									html += "<div class='badge badge-pill badge-success'>";
 									html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
 									html += "	<spring:message code='eXperDB_CDC.connecting' />";
 								} else {
 									html += "<div class='badge badge-pill badge-danger'>";
 									html += "	<i class='ti-close mr-2'></i>";
 									html += "	<spring:message code='schedule.stop' />";
 								}

 								html += "</div>";

 								return html;
 							},
 							className : "dt-left",
 							defaultContent : "" 	
 						},
 						{data : "conn_test_btn", className : "dt-center", defaultContent : "",
 							render: function (data, type, full){
 								var html =""; 
 								html +="<span onclick=\"fn_connect_con_test_btn('"+full.regi_ip+"','"+full.regi_port+"','schema',"+full.rownum+")\" class=\"bold\">";
 								html +="	<i class='mdi mdi-lan-connect'></i> ";
 								html +="	<spring:message code='dbms_information.conn_Test' />";
								html +="</span>";
								return html;
 							}
 						},
 						{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
 						{data : "regi_id",  defaultContent : "", visible: false }
 			],'select': {'style': 'multi'}
		});

		trans_regi_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		trans_regi_table.tables().header().to$().find('th:eq(1)').css('min-width', '10px');
		trans_regi_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		trans_regi_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		trans_regi_table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		trans_regi_table.tables().header().to$().find('th:eq(5)').css('min-width', '80px');
		trans_regi_table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		trans_regi_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		trans_regi_table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');


		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 연결테스트
	 ******************************************************** */
	function fn_connect_con_test_btn(ip,port,conn_gbn,r){

		var kafkaIp;
		var kafkaPort;
		var regiIP;
		var regiPort;
		var messge;
		
		if(conn_gbn=='kafka'){
			kafkaIp = ip;
			kafkaPort = port;
			messge = 'kafka-Connection ';
		}else{
			regiIP=ip;
			regiPort=port;
			messge = 'Schema Registry-Connection ';
		}
		
		$.ajax({
			url : '/kafkaConnectionTest.do',
			type : 'post',
			data : {
				db_svr_id : $("#db_svr_id","#findList").val(),
				kafkaIp : nvlPrmSet(kafkaIp,''),
				kafkaPort : nvlPrmSet(kafkaPort,''),
				regiIP : nvlPrmSet(regiIP,''),
				regiPort : nvlPrmSet(regiPort,''),
				connect_gbn : conn_gbn
			},
			success : function(result) {
				var tempTable ;
				if(conn_gbn=='kafka'){
					tempTable =trans_connect_table;
				}else{
					tempTable=trans_regi_table;
				}
				if(result.RESULT_DATA =="success"){
					tempTable.row(r-1).data().exe_status='TC001501';
					showSwalIcon(messge + '<spring:message code="message.msg93"/>', '<spring:message code="common.close" />', '', 'success');
				}else{
					tempTable.row(r-1).data().exe_status='TC001502';
					showSwalIcon(messge + '<spring:message code="message.msg92"/>', '<spring:message code="common.close" />', '', 'error');
				}
				var newData = tempTable.rows().data();
				tempTable.clear().draw();
				tempTable.rows.add(newData).draw();
				tempTable.rows({selected: true}).deselect();
				
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			}
		});
		$('#loading').hide();
	}
	
	/* ********************************************************
	 * kafka connect 조회
	 ******************************************************** */
	function fn_connect_select(){
		$.ajax({
			url : "/selectTransKafkaConList.do",
			data : {
				kc_nm : nvlPrmSet($("#trans_kafka_con_nm").val(), '')
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
				trans_connect_table.rows({selected: true}).deselect();
				trans_connect_table.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					trans_connect_table.rows.add(result).draw();
				}
			}
		});
	}
	/* ********************************************************
	 * schema registry 조회
	 ******************************************************** */
	function fn_regi_select(){
		$.ajax({
			url : "/selectTransRegiList.do",
			data : {
				regi_nm : nvlPrmSet($("#trans_kafka_con_nm").val(), '')
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
				trans_regi_table.rows({selected: true}).deselect();
				trans_regi_table.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					trans_regi_table.rows.add(result).draw();
				}
			}
		});
	}
	


	/* ********************************************************
	 * kafka connect 등록 팝업페이지 호출
	 ******************************************************** */
	function fn_kafka_con_insert(){
		$('#pop_layer_trans_kfk_con_reg').modal("hide");

 		$.ajax({ 
			url : "/popup/transTargetKfkConIns.do",
			data : {
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
				fn_transKfkConRegPopStart(result);
				
				$('#pop_layer_trans_kfk_con_reg').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * Schema Registry 등록 팝업페이지 호출
	 ******************************************************** */
	function fn_sche_regi_insert(){
		$('#pop_layer_trans_sche_regi_reg').modal("hide");

 		$.ajax({ 
			url : "/popup/transSchemaRegistryIns.do",
			data : {
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
				fn_transKfkConRegPopStart(result);
				
				$('#pop_layer_trans_sche_regi_reg').modal("show");
			}
		});
	}
	
	
	
	/* ********************************************************
	 * trans connect 삭제버튼 클릭시
	 ******************************************************** */
	function fn_kafka_con_delete(){
/* 		var datas = trans_connect_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		trans_connect_id_List = [];

		for (var i = 0; i < datas.length; i++) {
			trans_connect_id_List.push(datas[i].kc_id);   
		} */

		confile_title = 'Kafka' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("trans_connect_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * schema registry 삭제버튼 클릭시
	 ******************************************************** */
	function fn_sche_regi_delete(){

		confile_title = 'Schema Registry' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("trans_regi_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "trans_connect_del") {
			fn_connect_delete_loc();
		}else if (gbn == "trans_regi_del") {
			fn_regi_delete_loc();
		}
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_connect_delete_loc(){
		$.ajax({
			url : "/deleteTransKafkaConnect.do",
		  	data : {
		  		trans_connect_id_List : JSON.stringify(trans_connect_id_List)
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
				if(result == true){
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_connect_select();
				}else{
					msgVale = "<spring:message code='eXperDB_CDC.btn_title02' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * schema registry 삭제 로직 처리
	 ******************************************************** */
	function fn_regi_delete_loc(){
		$.ajax({
			url : "/deleteTransSchemaRegistry.do",
		  	data : {
		  		trans_regi_id_List : JSON.stringify(trans_regi_id_List)
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
				if(result == true){
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_regi_select();
				}else{
					msgVale = "<spring:message code='eXperDB_CDC.btn_title02' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * kafka 수정 팝업페이지 호출
	 ******************************************************** */
	function fn_kafka_con_update(gbn){
/* 
		var datas = trans_connect_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		} */

		var kc_id = trans_connect_table.row('.selected').data().kc_id;
		
		$.ajax({
			url : "/popup/transTargetKfkConUdt.do",
			data : {
				kc_id : kc_id
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
				if (result.resultInfo != null) {
					fn_transKafkaConModPopStart(result);
					
					if (gbn == "O") {
						$("#mod_trans_kafka_con_ip", "#modTransKfkConRegForm").prop("disabled", true); 
						$("#mod_trans_kafka_con_port", "#modTransKfkConRegForm").prop("disabled", true); 
					} else {
						$("#mod_trans_kafka_con_ip", "#modTransKfkConRegForm").prop("disabled", false); 
						$("#mod_trans_kafka_con_port", "#modTransKfkConRegForm").prop("disabled", false); 
					}
	
					$('#pop_layer_trans_kfk_con_reg_re').modal("show");
				} else {
					showSwalIcon(message_msg01, closeBtn, '', 'error');
					$('#pop_layer_trans_kfk_con_reg_re').modal("hide");
					return;
				}
			}
		});
	}
	

	/* ********************************************************
	 * Schema Registry  수정 팝업페이지 호출
	 ******************************************************** */
	function fn_sche_regi_update(gbn){

		var regi_id = trans_regi_table.row('.selected').data().regi_id;
		
		$.ajax({
			url : "/popup/transTargetScheRegiUdt.do",
			data : {
				regi_id : regi_id
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
				if (result.resultInfo != null) {
					fn_transSchemRegiModPopStart(result);
					
					if (gbn == "O") {
						$("#mod_trans_regi_ip", "#modTransScheRegiRegForm").prop("disabled", true); 
						$("#mod_trans_regi_port", "#modTransScheRegiRegForm").prop("disabled", true); 
					} else {
						$("#mod_trans_regi_ip", "#modTransScheRegiRegForm").prop("disabled", false); 
						$("#mod_trans_regi_port", "#modTransScheRegiRegForm").prop("disabled", false); 
					}
	
					$('#pop_layer_trans_sche_regi_reg_re').modal("show");
				} else {
					showSwalIcon(message_msg01, closeBtn, '', 'error');
					$('#pop_layer_trans_sche_regi_reg_re').modal("hide");
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * kafka 사용여부 체크
	 ******************************************************** */
	function fn_kafkaConChk(selGbn) {
		var datas = trans_connect_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if (selGbn == "update") {
			if(datas.length > 1){
				showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}
		
		trans_connect_id_List = [];

		for (var i = 0; i < datas.length; i++) {
			trans_connect_id_List.push(datas[i].kc_id);   
		}

		//사용중이거나 활성활 일경우
		$.ajax({
			url : "/selectTransKafkaConIngChk.do",
			data : {
				trans_connect_id_List : JSON.stringify(trans_connect_id_List),
				exeGbn : selGbn
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
 				var msgResult = "";

				if (result != null) {
					if (result == "S") {
 						if (selGbn =="update") {
 							fn_kafka_con_update("S");
						} else {
							fn_kafka_con_delete();
						}
					} else if (result == "O") {
						
						if (selGbn == "update") {
							if (datas[0].exe_status != "TC001501") {
								fn_kafka_con_update("O");
							} else {
								msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg31" />');
								showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
								return;
							}
						} else {
							msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg31" />');
							showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
							return;
						}

					} else {
						msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg21" />');
						showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
						return;
					}
				} else {
					msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg21" />');
					showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	

	/* ********************************************************
	 * schema registry 사용여부 체크
	 ******************************************************** */
	function fn_schemaRegiChk(selGbn) {
		var datas = trans_regi_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if (selGbn == "update") {
			if(datas.length > 1){
				showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}
		
		trans_regi_id_List = [];

		for (var i = 0; i < datas.length; i++) {
			trans_regi_id_List.push(datas[i].regi_id);   
		}

		//사용중이거나 활성활 일경우
		 $.ajax({
			url : "/selectTransScheRegiIngChk.do",
			data : {
				trans_regi_id_List : JSON.stringify(trans_regi_id_List),
				exeGbn : selGbn
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
 				var msgResult = "";

				if (result != null) {
					if (result == "S") {
 						if (selGbn =="update") {
 							fn_sche_regi_update("S");
						} else {
							fn_sche_regi_delete();
						}
					} else if (result == "O") {
						
						if (selGbn == "update") {
							if (datas[0].exe_status != "TC001501") {
								fn_sche_regi_update("O");
							} else {
								msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg31" />');
								showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
								return;
							}
						} else {
							msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg31" />');
							showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
							return;
						}

					} else {
						msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg21" />');
						showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
						return;
					}
				} else {
					msgResult = fn_strBrReplcae('<spring:message code="eXperDB_CDC.msg21" />');
					showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		}); 
	}
</script>

<%@include file="../popup/transSchemaRegiRegForm.jsp"%>
<%@include file="../popup/transSchemaRegiRegReForm.jsp"%>
<%@include file="../popup/transKafkaConRegForm.jsp"%>
<%@include file="../popup/transKafkaConRegReForm.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
</form>

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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-database"></i>
												<span class="menu-title"><spring:message code="eXperDB_CDC.connector_server_settings"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
						 					<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_transfer" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_CDC.connector_server_settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_CDC_kafka_connect_01"/></p>
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

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px -10px;">
							<form class="form-inline row" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2 col-sm-4">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="trans_kafka_con_nm" name="trans_kafka_con_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_CDC.connector_server_nm" />'/>				
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_connect_select();fn_regi_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-6 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> Kafka <spring:message code="common.infomation" />
					</h4>
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsDelete" onClick="fn_kafkaConChk('delete');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsModify" onClick="fn_kafkaConChk('update');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsInsert" onClick="fn_kafka_con_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" style="margin-botom:-10px;">
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

		 							<table id="transKfkConnectList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
	 										<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="20" height="0"><spring:message code="common.no" /></th>
												<th width="150"><spring:message code="etc.etc04"/></th>
			 									<th width="100"><spring:message code="data_transfer.ip" /></th>
												<th width="50"><spring:message code="data_transfer.port" /></th>
												<th width="80"><spring:message code="eXperDB_CDC.connection_status" /></th>
												<th width="100"><spring:message code="dbms_information.conn_Test" /></th>
												<th width="100"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
		<div class="col-6 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<h4 class="card-title">
						<i class="item-icon fa fa-dot-circle-o"></i> Schema Registry <spring:message code="common.infomation" />
					</h4>
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnRegiDelete" onClick="fn_schemaRegiChk('delete');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnRegiModify" onClick="fn_schemaRegiChk('update');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnRegiInsert" onClick="fn_sche_regi_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" style="margin-botom:-10px;">
						<div class="card-body" >
							<div class="row">
								<div class="col-12">
 									<div class="table-responsive">
										<div id="order-listing_wrapper"
											class="dataTables_wrapper dt-bootstrap4 no-footer">
											<div class="row">
												<div class="col-sm-12 col-md-6">
													<div class="dataTables_length" id="order-listing_length">
													</div>
												</div>
											</div>
										</div>
									</div>

		 							<table id="transRegiConnectList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
	 										<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="20" height="0"><spring:message code="common.no" /></th>
												<th width="150">Schema Registry명</th>
			 									<th width="100"><spring:message code="data_transfer.ip" /></th>
												<th width="50"><spring:message code="data_transfer.port" /></th>
												<th width="80"><spring:message code="eXperDB_CDC.connection_status" /></th>
												<th width="100"><spring:message code="dbms_information.conn_Test" /></th>
												<th width="100"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>