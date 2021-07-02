<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : proxyServerRegForm.jsp
	* @Description : Proxy 서버 등록 화면
	* @Modification Information
	*
	*   수정일                      	수정자               수정내용
	*  ----------   ------  -----------    ---------------------------
	*  2021.03.05	김민정		최초 생성
	*
	* author 김민정 사원
	* since 2021.03.05
	*
	*/
%>

<script type="text/javascript">
var mgmtDbmsTable = null;

	
	function fn_mgmtDbmsTable_init() {
		
		/* ********************************************************
		 * 서버 (데이터테이블)
		 ******************************************************** */
		 mgmtDbmsTable = $('#mgmtDbms').DataTable({
			scrollY : "100px",
			scrollX: true,	
			searching : false,
			processing:true,
			paging : false,
			deferRender : true,
			bSort: false,
			columns : [
			    {data : "svr_host_nm",className : "dt-center",  defaultContent : ""},//hostname
			    {data : "master_gbn",className : "dt-center",  defaultContent : "",
			    render: function (data, type, full){
            		var html = "";
					if (full.master_gbn == "M") {
						return "Master";
					}else{ 
						return "Slave";
					}				
				}
				},//마스터 구분
				{data : "ipadr", className : "dt-center", defaultContent : ""},//IP
				{data : "intl_ipadr", className : "dt-center", defaultContent : ""},//내부IP
				{data : "portno", className : "dt-center",  defaultContent : ""},//Port
				{data : "db_svr_id", defaultContent : "", visible: false}// DBMS ID
			]
		});
		
		mgmtDbmsTable.tables().header().to$().find('th:eq(0)').css('min-width', '150px');//server명
		mgmtDbmsTable.tables().header().to$().find('th:eq(1)').css('min-width', '150px');//마스터 구분
		mgmtDbmsTable.tables().header().to$().find('th:eq(2)').css('min-width', '150px');//ip 주소
		mgmtDbmsTable.tables().header().to$().find('th:eq(3)').css('min-width', '150px');//내부 ip 주소
		mgmtDbmsTable.tables().header().to$().find('th:eq(4)').css('min-width', '100px');//포트 번호
		mgmtDbmsTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');//db server id
		
	}
	
	$(window.document).ready(function() {
		fn_mgmtDbmsTable_init();
		
		 $("#svrRegProxyServerForm").validate({
		        rules: {
		        	svrReg_ipadr: {
						required:true
					},
					svrReg_pry_svr_nm: {
						required: true
					},
					svrReg_day_data_del_term: {
						required: true
					},
					svrReg_min_data_del_term: {
						required: true
					},
					svrReg_master_gbn: {
						required: true
					},
					svrReg_master_svr_id:{
						required: function(){
							if($("#svrReg_master_gbn", "#svrRegProxyServerForm").val() == "S"){
								return true;
							}else{
								return false;
							}
						}
					},
					svrReg_db_svr_id: {
						required: true
					}
		        },
		        messages: {
		        	svrReg_ipadr: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					svrReg_pry_svr_nm: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
						,maxlength: '25'+'<spring:message code="message.msg211"/>'	
					},
					svrReg_day_data_del_term: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					svrReg_min_data_del_term: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					svrReg_master_gbn: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					},
					svrReg_master_svr_id : {
						required: function (str, element, param) {
							if($("#svrReg_master_svr_id > option").length > 1){
								return '<spring:message code="eXperDB_proxy.msg2" />';
							} 
							return '<spring:message code="eXperDB_proxy.msg26" />';
						}
					},
					svrReg_db_svr_id: {
						required: '<spring:message code="eXperDB_proxy.msg2" />'
					}
		        },
				submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
					fn_reg_svr_check();
				},
		        errorPlacement: function(label, element) {
		          label.addClass('mt-2 text-danger');
		          label.insertAfter(element);
		        },
		        highlight: function(element, errorClass) {
		          $(element).parent().addClass('has-danger');
		          $(element).addClass('form-control-danger');
		        }
			});

	});

	/* ********************************************************
	 * Master 구분 변경 시 이벤트
	 ******************************************************** */
	function fn_changeMasterGbn(){
		
		$("#svrReg_master_svr_id-error", "#svrRegProxyServerForm").hide();
		
		if($("#svrReg_master_gbn", "#svrRegProxyServerForm").val() == "S"){
			$("#svrReg_master_svr_id_label", "#svrRegProxyServerForm").show();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").show();

			if ($("#svrReg_master_svr_id_val", "#svrRegProxyServerForm").val() != "" && $("#svrReg_master_svr_id_val", "#svrRegProxyServerForm").val() != "0") {
				$("#svrReg_master_svr_id", "#svrRegProxyServerForm").val($("#svrReg_master_svr_id_val", "#svrRegProxyServerForm").val());
			} else {
				$("#svrReg_master_svr_id option:eq(0)", "#svrRegProxyServerForm").prop("selected", true);
			}
			$("#svrReg_master_svr_id").valid();
		}else{
			$("#svrReg_master_svr_id_label", "#svrRegProxyServerForm").hide();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").hide();
			$("#svrReg_master_svr_id", "#svrRegProxyServerForm").val("");
		}
	}
	
	/* ********************************************************
	 * Proxy Master Proxy 서버 select 생성
	 ******************************************************** */
	function fn_create_mstSvr_select(data, value){
		var innerHtml ="";
		var len = data.length;
		$( "#svrReg_master_svr_id > option", "#svrRegProxyServerForm" ).remove();
		
		innerHtml += '<option value=""> <spring:message code="common.choice" /> </option>';
	
		for(var i=0; i<len; i++){
			var id = data[i].pry_svr_id;
			var nm = data[i].pry_svr_nm;
			innerHtml += '<option value='+id+'>'+nm+'</option>';
		}
	
		$( "#svrReg_master_svr_id", "#svrRegProxyServerForm" ).append(innerHtml);
		
		if (value != null && value != "") {
			$( "#svrReg_master_svr_id", "#svrRegProxyServerForm" ).val(value);
		} else {
			$("#svrReg_master_svr_id option:eq(0)", "#svrRegProxyServerForm").prop("selected", true);
		}
		
	}

	/* ********************************************************
	 * Proxy 연결 DBMS select 생성
	 ******************************************************** */
	function fn_create_dbms_select(data, value){
		var innerHtml ="";
		var len = data.length;
		
		$( "#svrReg_db_svr_id > option", "#svrRegProxyServerForm" ).remove();
	
		for(var i=0; i<len; i++){
			var id = data[i].db_svr_id;
			var nm = data[i].db_svr_nm;
			innerHtml += '<option value='+id+'>'+nm+'</option>';
		}
	
		$( "#svrReg_db_svr_id", "#svrRegProxyServerForm" ).append(innerHtml);
		
		if (value != null && value != "") {
			$( "#svrReg_db_svr_id", "#svrRegProxyServerForm" ).val(value);
		} else {
			$("#svrReg_db_svr_id option:eq(0)", "#svrRegProxyServerForm").prop("selected", true);
		}
	}
	
	/* ********************************************************
     * Proxy DBMS onchange
    ******************************************************** */		
 	function fn_svr_dbms_onChange(){
		var svrReg_db_svr_id = $("#svrReg_db_svr_id", "#svrRegProxyServerForm").val();
		var ServerNm = "";
		var ServerServe = "";
		if (svrReg_db_svr_id != "") {
	 		$("#svrReg_db_svr_id_val", "#svrRegProxyServerForm").val(svrReg_db_svr_id);
	 		ServerNm = $("#svrReg_db_svr_id option:checked", "#svrRegProxyServerForm").text() + "-Proxy_"
		}

		if (ServerNm != "") {
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val(ServerNm); //서버명
		} else {
			$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val(""); //서버명
		}

		fn_svr_dbms_list_search();
		
		//master svr 리스트 변경
		fn_dbmsChange_mstSvrId();
		
		//서버명 변경
		if (ServerNm != "") {
			fn_dbmsChange_ServerNm();
		}

	}
	
	/* ********************************************************
	 * 서버명 셋팅
	 ******************************************************** */
	function fn_dbmsChange_ServerNm(){

		var dbSvrId = $( "#svrReg_db_svr_id", "#svrRegProxyServerForm" ).val();
		var returnStr = "";

		$.ajax({
				url : "/proxySetServerNmChange.do",
	 			data : { db_svr_id : dbSvrId,
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
	 				if (result != null) {
	 					if (result != "") {
	 						returnStr = result;
	 					} else {
	 						returnStr = "1";
	 					}
	 				} else {
	 					returnStr = "1";
	 				}
	 				
	 				var ServerNm = $("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val();

	 				$("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val(ServerNm + returnStr); //서버명
	 			}
	 	});
	}

	/* ********************************************************
	 * Proxy IP 주소 변경 시 이벤트
	 ******************************************************** */
	function fn_dbmsChange_mstSvrId(){
		
		var prySvrID;
		var dbSvrId = $("#svrReg_db_svr_id_val", "#svrRegProxyServerForm").val();
		
 		if($("#svrReg_mode", "#svrRegProxyServerForm").val()=="reg") {
			prySvrID= "";
		}else{
			prySvrID =$("#svrReg_pry_svr_id", "#svrRegProxyServerForm" ).val();
			$("#svrMod_ipadr", "#svrRegProxyServerForm" ).val(prySvrID);
		}
		
		$.ajax({
				url : "/proxySetMstSvrChange.do",
	 			data : { pry_svr_id : prySvrID,
	 				db_svr_id : dbSvrId,
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
	 				if($("#svrReg_mode", "#svrRegProxyServerForm").val()=="reg"){
	 					var index = 0; 

	 					fn_create_mstSvr_select(result.mstSvr_sel_list, "");
	 					fn_svr_dbms_list_search();
	 				}else{
	 					var selSvrInfo = proxyServerTable.row('.selected').data();
	 					
	 					fn_create_mstSvr_select(result.mstSvr_sel_list, selSvrInfo.master_svr_id);
	 					fn_svr_dbms_list_search();
	 				}
	 				
	 			}
	 	});
	}
	
	/* ********************************************************
     * Proxy Server의  연결 DBMS List 검색
    ******************************************************** */		
 	function fn_svr_dbms_list_search(){
		
		var dbSvrId = $("#svrReg_db_svr_id_val", "#svrRegProxyServerForm").val();
 		$.ajax({
 			url : "/selectIpadrList.do",
 			data : {
 				db_svr_id : dbSvrId
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
 				mgmtDbmsTable.rows({selected: true}).deselect();
 				mgmtDbmsTable.clear().draw();
				
				if (result != null) {
					mgmtDbmsTable.rows.add(result).draw();
				}
 			}
 		});
 	}
  	/* ********************************************************
     * Proxy Server의  연결 Test 
     ******************************************************** */		
	function fn_prySvrConnTest(){
		$('#loading_pop').show();
		$.ajax({
 			url : "/prySvrConnTest.do",
 			data : {
 				pry_svr_id : $("#svrReg_pry_svr_id", "#svrRegProxyServerForm").val(),
 				ipadr : $("#svrReg_ipadr", "#svrRegProxyServerForm").val()
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
 				$('#loading_pop').hide();
 				//console.log(result);
 				if (result != null) {
					if(!result.agentConn){
						showSwalIcon(result.errmsg, '<spring:message code="common.close" />', '', 'error');
						
						$("#svrReg_conn_result", "#svrRegProxyServerForm").val("false");
						$("#svrReg_save_submit", "#svrRegProxyServerForm").attr("disabled", "disabled");
						
					}else{
						showSwalIcon('<spring:message code="message.msg93" />', '<spring:message code="common.close" />', '', 'success');
						$("#svrReg_conn_result", "#svrRegProxyServerForm").val("true");
						$("#svrReg_save_submit", "#svrRegProxyServerForm").removeAttr("disabled");
						
					}
				}
 			}
 		});
	}
	/* ********************************************************
     * Proxy Server의  등록 
     ******************************************************** */		
	function fn_reg_svr_check(){
		//연결 테스트를 했는지, 안했다면 
		if($("#svrReg_conn_result", "#svrRegProxyServerForm").val() != "true"){
			showSwalIcon('<spring:message code="message.msg89"/>', '<spring:message code="common.close" />', '', 'warning');
		}else{
			if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
				fn_multiConfirmModal("pry_svr_reg");
			}else{
				fn_multiConfirmModal("pry_svr_mod");
			}			
		}
	}
	/* ********************************************************
     * Proxy Server의  등록 
     ******************************************************** */		
	function fn_reg_svr(){
		
		var setIpadr = "";
		
		if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
			setIpadr = $("#svrReg_ipadr", "#svrRegProxyServerForm").val();
		} else {
			setIpadr = $("#svrMod_ipadr", "#svrRegProxyServerForm").val();
		}
		$('#loading_pop').show();
		$.ajax({
 			url : "/prySvrReg.do",
 			data : {
 				pry_svr_id : $("#svrReg_pry_svr_id", "#svrRegProxyServerForm").val()
 				,agt_sn : $("#svrReg_agt_sn", "#svrRegProxyServerForm").val()
 				,pry_svr_nm : $("#svrReg_pry_svr_nm", "#svrRegProxyServerForm").val()
 				,day_data_del_term : $("#svrReg_day_data_del_term", "#svrRegProxyServerForm").val()
 				,min_data_del_term : $("#svrReg_min_data_del_term", "#svrRegProxyServerForm").val()
 				,master_svr_id : $("#svrReg_master_svr_id", "#svrRegProxyServerForm").val()
 				,use_yn : $("#svrReg_use_yn", "#svrRegProxyServerForm").val()
 				,master_gbn : $("#svrReg_master_gbn", "#svrRegProxyServerForm").val()
 				,db_svr_id : $("#svrReg_db_svr_id", "#svrRegProxyServerForm").val()
 				,reg_mode: $("#svrReg_mode", "#svrRegProxyServerForm").val()
 				,ipadr: setIpadr
 				,kal_install_yn : $("#svrReg_kal_install_yn", "#svrRegProxyServerForm").val()
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
 				$('#loading_pop').hide();
 				if(result.result){
 					var msg ="";
 					if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
 						msg ='<spring:message code="message.msg144"/>';
 						if(result.reRegResult){
 							msg = fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg54"/>');
 						}
 					}else{
 						msg ='<spring:message code="message.msg155"/>';
 					}
 					showSwalIcon(msg, '<spring:message code="common.close" />', '', 'success');
 					
 					//창 닫기
 					$('#pop_layer_svr_reg').modal("hide");
 					
 				}else{
 					var msg ="";
 					if($("#svrReg_mode", "#svrRegProxyServerForm").val() == "reg"){
 						msg ='<spring:message code="migration.msg06"/>';
 					}else{
 						msg ='<spring:message code="eXperDB_scale.msg22"/>';
 					}
 					showSwalIcon(msg +' '+result.errMsg, '<spring:message code="common.close" />', '', 'error');
	 			}
 				//검색
				fn_serverList_search();
 			}
 		});
	}
</script>
<div class="modal fade" id="pop_layer_svr_reg" tabindex="-1" role="dialog" aria-labelledby="ModalProxyServer" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div id="loading_pop" style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); z-index:2000; display:none;">
		<div class="flip-square-loader mx-auto" style="border: 0px !important;"></div>
	</div>
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 80px 330px;">
		<div class="modal-content" style="width:1040px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalProxyServer" style="padding:0 5px 5px 0;">
					<spring:message code="eXperDB_proxy.server_reg"/>
				</h4>
				<h4 class="text-danger" id="warning_init_svr_reg" style="font-size: 0.875rem;"></h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<form class="cmxform" id="svrRegProxyServerForm">
						<input type="hidden" id="svrReg_mode" name="svrReg_mode">
						<input type="hidden" id="svrReg_exe_status" name="svrReg_exe_status">
						<input type="hidden" id="svrReg_kal_exe_status" name="svrReg_kal_exe_status">
						<input type="hidden" id="svrReg_conn_result" name="svrReg_conn_result">
						<input type="hidden" id="svrReg_pry_svr_id" name="svrReg_pry_svr_id">
						<input type="hidden" id="svrReg_master_svr_id_val" name="svrReg_master_svr_id_val">
						<input type="hidden" id="svrReg_db_svr_id_val" name="svrReg_db_svr_id_val">
						<input type="hidden" id="svrReg_agt_sn" name="svrReg_agt_sn">	
						<input type="hidden" id="svrReg_use_yn" name="svrReg_use_yn" value="Y">	
						<input type="hidden" id="svrReg_kal_install_yn" name="svrReg_kal_install_yn" value="N">	
																	
						<fieldset>
						<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="svrReg_ipadr" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.ip" />(*)
									</label>

									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm" style="display:none;" maxlength="18" id="svrMod_ipadr" name="svrMod_ipadr" onkeyup="fn_checkWord(this,18)" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem;" name="svrReg_ipadr" id="svrReg_ipadr" onchange="fn_changeSvrId('mod');">
										</select>
									</div>
									<label for="svrReg_pry_svr_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.server_name" />(*)
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm" maxlength="25" id="svrReg_pry_svr_nm" name="svrReg_pry_svr_nm" onblur="this.value=this.value.trim()" placeholder="25<spring:message code='message.msg188'/>" tabindex=2 />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="svrReg_day_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.day_data_del_term" />(*)
									</label>
									<div class="col-sm-3" id="div_day_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="svrReg_day_data_del_term" id="svrReg_day_data_del_term">
											<option value="5">5<spring:message code="common.day" /></option>
											<option value="10">10<spring:message code="common.day" /></option>
											<option value="15">15<spring:message code="common.day" /></option>
											<option value="20">20<spring:message code="common.day" /></option>
											<option value="25">25<spring:message code="common.day" /></option>
											<option value="30">30<spring:message code="common.day" /></option>
										</select>
									</div>
									
									<label for="svrReg_min_data_del_term" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.min_data_del_term" />(*)
									</label>
									<div class="col-sm-auto" id="div_min_data_del_term">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="svrReg_min_data_del_term" id="svrReg_min_data_del_term">
											<option value="1">1<spring:message code="common.day" /></option>
											<option value="2">2<spring:message code="common.day" /></option>
											<option value="3">3<spring:message code="common.day" /></option>
											<option value="4">4<spring:message code="common.day" /></option>
											<option value="5">5<spring:message code="common.day" /></option>
											<option value="6">6<spring:message code="common.day" /></option>
											<option value="7">7<spring:message code="common.day" /></option>
										</select>
									</div>
								</div>
							</div> 
							<br/>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="svrReg_master_gbn" class="col-sm-3 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.proxy_gbn" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100px;" name="svrReg_master_gbn" id="svrReg_master_gbn" onchange="fn_changeMasterGbn();">
											<option value="M" selected="selected">Master</option>
											<option value="S">Standby</option>
										</select>
									</div>
									<!-- <div class="col-sm-1"></div> -->
									<label for="svrReg_master_svr_id" class="col-sm-3 col-form-label-sm pop-label-index" id="svrReg_master_svr_id_label">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.master_proxy" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="svrReg_master_svr_id" id="svrReg_master_svr_id">
										</select>
									</div>
								</div>
								<div class="form-group row" style="margin-bottom:0px;">
									<label for="svrReg_db_svr_id" class="col-sm-3 col-form-label-sm">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.con_dbms" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="svrReg_db_svr_id" id="svrReg_db_svr_id" onchange="fn_svr_dbms_onChange();">
										</select>
									</div>
									<div class="col-sm-auto"></div>
								</div>
								<div class="form-group row">
									<div class="col-sm-12">
										<table id="mgmtDbms" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="150"><spring:message code="common.dbms_name" /></th>
													<th width="150"><spring:message code="common.division" /></th>
													<th width="150"><spring:message code="dbms_information.dbms_ip" /></th>
													<th width="150">내부 아이피</th>
													<th width="100"><spring:message code="data_transfer.port" /></th>
													<th width="0">DBMS_ID</th>									
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
							<br/>
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="svrReg_save_submit" value='<spring:message code="common.save" />' />
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onClick="fn_prySvrConnTest();" id="svrReg_conn_test" value='연결테스트' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>