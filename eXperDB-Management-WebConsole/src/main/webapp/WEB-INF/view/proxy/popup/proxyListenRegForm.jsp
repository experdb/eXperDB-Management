<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : proxyListenRegForm.jsp
	* @Description : proxyListenRegForm 화면
	* @Modification Information
	*
	*   수정일         		수정자                   	수정내용
	*  ----------	-------		--------    ---------------------------
	*  2021.03.18	김민정  		최초 생성
	*
	* author 김민정
	* since 2021.03.18
	*
	*/
%>

<script type="text/javascript">
var serverListTable = null;
/* ********************************************************
 * Listener Server List 초기화
 ******************************************************** */
function fn_serverListTable_init() {
	
	 serverListTable = $('#serverList').DataTable({
		scrollY : "100px",
		bSort: false,
		scrollX: true,	
		searching : false,
		paging : false,
		deferRender : true,
		columns : [	{data : "db_con_addr", className : "dt-center", defaultContent : ""},
					{data : "chk_portno", className : "dt-center",  defaultContent : ""},
					{data : "backup_yn", defaultContent : "",
						render : function(data, type, full, meta) {
							var html = "";
							html += '<div class="onoffswitch-pop">';
							if(full.backup_yn == "Y"){
								html += '<input type="checkbox" class="onoffswitch-pop-checkbox" id="backup_yn_'+ meta.row +'" onclick="fn_backupYn_click(\''+ meta.row +'\')" checked>';
							}else{
								html += '<input type="checkbox" class="onoffswitch-pop-checkbox" id="backup_yn_'+ meta.row +'" onclick="fn_backupYn_click(\''+ meta.row +'\')">';
							}
							html += '<label class="onoffswitch-pop-label" for="backup_yn_'+ meta.row +'">';
							html += '<span class="onoffswitch-pop-inner_YN"></span>';
							html += '<span class="onoffswitch-pop-switch"></span></label>';
							html += '</div>';

							return html;	
						}
					},
					{data : "lsn_svr_id", className : "dt-center", defaultContent : "", visible: false},
					{data : "pry_svr_id", className : "dt-center", defaultContent : "", visible: false},	
					{data : "lsn_id", className : "dt-center", defaultContent : "", visible: false},
					{data : "edit_yn", className : "dt-center", defaultContent : "N", visible: false},
		]
	});

	serverListTable.tables().header().to$().find('th:eq(0)').css('min-width', '200px');
	serverListTable.tables().header().to$().find('th:eq(1)').css('min-width', '100px');
	serverListTable.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
	serverListTable.tables().header().to$().find('th:eq(3)').css('min-width', '0px');
	serverListTable.tables().header().to$().find('th:eq(4)').css('min-width', '0px');
	serverListTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px');

	$('#serverList tbody').on('click','tr',function() {
		if ( !$(this).hasClass('selected') ){	        	
			serverListTable.$('tr.selected').removeClass('selected');
	           $(this).addClass('selected');	            
		} 
	});	
}

	$(window.document).ready(function() {
		fn_serverListTable_init();
		
		$.validator.addMethod("validatorIpFormat3", function (str, element, param) {
			var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
		    if (ipformat.test(str) || str.indexOf("*") >= 0) {
		        return true;
		    }
		    return false;
		});
		
		$.validator.addMethod("validatorIpPortFormat", function (str, element, param) {
			var ip = str.substring(0,str.indexOf(":"));
			var port = str.substring(str.indexOf(":")+1);
			var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
		    if (ipformat.test(ip) && (port >= 0 && port < 65536)) {
		        return true;
		    }
		    return false;
		});
		
		$.validator.addMethod("validatorPort", function (port, element, param) {
			if ((port >= 0 && port < 65536)) {
		        return true;
		    }
		    return false;
		});
		
		$.validator.addMethod("duplCheckListenerNm", function (str, element, param) {
			var cnt = 0;
		    var listLen = proxyListenTable.rows().data().length;
		    var tblData = proxyListenTable.rows().data();
		    
		    for(var i=0; i< listLen; i++){
		    	if( $("#lstnReg_lsn_nm", "#insProxyListenForm").val() == tblData[i].lsn_nm){
		    		if($("#lstnReg_mode", "#insProxyListenForm").val()=="mod" && proxyListenTable.rows('.selected').indexes()[0] != i){
		    			cnt++;
		    		}else if($("#lstnReg_mode", "#insProxyListenForm").val() =="reg"){
		    			cnt++;
		    		}
		    	}
		    }
		    if(cnt > 0){
		    	return false;
		    }
		    return true;
		});
		
		$("#ipadr_form").validate({
	        rules: {
	        	ipadr: {
					required:true
				},
				portno: {
					required: true
				}
	        },
	        messages: {
	        	ipadr: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>'
				},
				portno: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>',
					maxlength: '5'+'<spring:message code="message.msg211"/>'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				fn_add_server_list();
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
		
		$("#insProxyListenForm").validate({
	        rules: {
	        	lstnReg_lsn_nm_sel: {
					required:true,
					duplCheckListenerNm : true
				},
				lstnReg_con_bind_ip: {
					required: true,
					maxlength: 15,
					validatorIpFormat3 :true
				},
				lstnReg_con_bind_port: {
					required: true,
					validatorPort: true
				},
				lstnReg_lsn_desc: {
					required:true,
					maxlength: 250
				},
				lstnReg_db_nm: {
					required: true
				},
				lstnReg_con_sim_query: {
					required: true
				},
				lstnReg_field_nm: {
					required: true
				},
				lstnReg_field_val: {
					required: true
				}
	        },
	        messages: {
	        	lstnReg_lsn_nm_sel: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>',
					duplCheckListenerNm: '<spring:message code="errors.duplicate"/>'
				},
	        	lstnReg_con_bind_ip: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>',
					maxlength: '15'+'<spring:message code="message.msg211"/>',
					validatorIpFormat3 : '<spring:message code="errors.format" arguments="'+ 'IP주소' +'"/>'
				},
				lstnReg_con_bind_port: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>',
					validatorPort: '<spring:message code="eXperDB_proxy.msg13"/>',
					maxlength: '5'+'<spring:message code="message.msg211"/>'
				},
				lstnReg_lsn_desc: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>',
					maxlength: '250'+'<spring:message code="message.msg211"/>'
				},
				lstnReg_db_nm: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>'
				},
				lstnReg_con_sim_query: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>'
				},
				lstnReg_field_nm: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>'
				},
				lstnReg_field_val: {
					required: '<spring:message code="eXperDB_proxy.msg2"/>'
				}
	        },
			submitHandler: function(form) { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
				var dataLen = serverListTable.rows().data().length;
				if(dataLen == 0){
					showSwalIcon('<spring:message code="eXperDB_proxy.msg25" />', '<spring:message code="common.close" />', '', 'warning');
					return;	
				}else{
					if($("#lstnReg_mode", "#insProxyListenForm").val() == "reg"){
						lstnReg_add_listener();
					}else{
						lnstReg_mod_listener();
					}
				}
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
 * Proxy Server의  연결 DBMS List 검색
******************************************************** */		
	function fn_listener_svr_list_search(){
		$.ajax({
			url : "/selectListenServerList.do",
			data : {
				pry_svr_id : parseInt($("#lstnReg_pry_svr_id", "#insProxyListenForm").val()),
				lsn_id : parseInt($("#lstnReg_lsn_id", "#insProxyListenForm").val())
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
				serverListTable.rows({selected: true}).deselect();
				serverListTable.clear().draw();
			
				if (result != null) {
					serverListTable.rows.add(result).draw();
				}
			}
		});
	}
	/* ********************************************************
	 * Listener 추가
	 ******************************************************** */
	function lstnReg_add_listener(){
		//입력받은 데이터를 Table에 저장하지 않고,DataTable에만 입력 
		//showSwalIcon('상단의 [적용]을 실행해야 \n변경 사항에 대해 저장/적용 됩니다.', '<spring:message code="common.close" />', '', 'success');
		$("#modYn").val("Y");
		$("#warning_init_detail_info").html('&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="eXperDB_proxy.msg5"/>');
		var svrListLen = serverListTable.rows().data().length;
		var svrListDatas = new Array();
		for(var j =0; j<svrListLen ; j++){
			if(serverListTable.row(j).data().edit_yn=="Y"){
				svrListDatas[svrListDatas.length] = serverListTable.row(j).data();
			}
		}
		proxyListenTable.row.add({
			"lsn_nm" : $("#lstnReg_lsn_nm", "#insProxyListenForm").val(),
			"con_bind_port" : $("#lstnReg_con_bind_ip", "#insProxyListenForm").val()+":"+$("#lstnReg_con_bind_port", "#insProxyListenForm").val(),
			"lsn_desc" : $("#lstnReg_lsn_desc", "#insProxyListenForm").val(),
			"db_usr_id" : $("#lstnReg_db_usr_id", "#insProxyListenForm").val(),
			"db_id" : parseInt($("#lstnReg_db_nm", "#insProxyListenForm").val()),
			"db_nm" : $("#lstnReg_db_nm", "#insProxyListenForm").children("option:selected").text(),
			"con_sim_query" : $("#lstnReg_con_sim_query", "#insProxyListenForm").val(),
			"field_val" : $("#lstnReg_field_val", "#insProxyListenForm").val(),
			"field_nm" : $("#lstnReg_field_nm", "#insProxyListenForm").val(),
			"pry_svr_id" : parseInt($("#lstnReg_pry_svr_id", "#insProxyListenForm").val()),
			"lsn_id" : parseInt($("#lstnReg_lsn_id", "#insProxyListenForm").val()),
			"lsn_svr_edit_list" : svrListDatas
		}).draw();
		selListenerInfo =null;
		$('#pop_layer_proxy_listen_reg').modal("hide"); 
	}
	/* ********************************************************
	 * Listener 수정
	 ******************************************************** */
	function lnstReg_mod_listener(){
		//입력받은 데이터를 Table에 저장하지 않고,DataTable에만 입력 
		//showSwalIcon('상단의 [적용]을 실행해야 \n변경 사항에 대해 저장/적용 됩니다.', '<spring:message code="common.close" />', '', 'success');
		$("#modYn").val("Y");
		$("#warning_init_detail_info").html('&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="eXperDB_proxy.msg5"/>');
		
		//수정된 내용 반영
		var dataLen = proxyListenTable.rows().data().length;
		var oriData = proxyListenTable.rows().data();
		for(var i=0; i<dataLen; i++){
			if(proxyListenTable.rows('.selected').indexes()[0] == i){
				oriData[i].con_bind_port = $("#lstnReg_con_bind_ip", "#insProxyListenForm").val()+":"+$("#lstnReg_con_bind_port", "#insProxyListenForm").val();
				oriData[i].lsn_desc = $("#lstnReg_lsn_desc", "#insProxyListenForm").val();
				oriData[i].db_usr_id = $("#lstnReg_db_usr_id", "#insProxyListenForm").val();
				oriData[i].db_nm = $("#lstnReg_db_nm", "#insProxyListenForm").children("option:selected").text();
				oriData[i].db_id = parseInt($("#lstnReg_db_nm", "#insProxyListenForm").val());
				oriData[i].field_val = $("#lstnReg_field_val", "#insProxyListenForm").val();
				oriData[i].field_nm = $("#lstnReg_field_nm", "#insProxyListenForm").val();
				oriData[i].con_sim_query = $("#lstnReg_con_sim_query", "#insProxyListenForm").val();
				var svrListLen = serverListTable.rows().data().length;
				var svrListDatas = new Array();
				for(var j =0; j<svrListLen ; j++){
					if(serverListTable.row(j).data().edit_yn=="Y"){
						svrListDatas[svrListDatas.length] = serverListTable.row(j).data();
					}
				}
				oriData[i].lsn_svr_edit_list = svrListDatas; 
				oriData[i].lsn_svr_del_list = delListnerSvrRows;
				
				var tempData = proxyListenTable.rows().data();
				proxyListenTable.clear().draw();
				proxyListenTable.rows.add(tempData).draw();
				delListnerSvrRows = new Array();
			}
		}
		selListenerInfo =null;
		$('#pop_layer_proxy_listen_reg').modal("hide");
	}
	/* ********************************************************
	 * Listener Server List 값 변경 event
	 ******************************************************** */
	function fn_edit_serverList(index,id){
		$("#modYn").val("Y");
		
		$("#db_con_addr_"+index).rules( "add", {
			required: true,
			validatorIpPortFormat: true,
			messages: {
				required: '<spring:message code="eXperDB_proxy.msg2"/>',
				validatorIpPortFormat: '<spring:message code="errors.format" arguments="'+ 'IP : port' +'"/>'
			}
		});
		
		$("#chk_portno_"+index).rules( "add", {
			required: true,
			validatorPort: true,
			messages: {
				required: '<spring:message code="eXperDB_proxy.msg2"/>',
				validatorPort: '<spring:message code="eXperDB_proxy.msg13"/>',
			}
		});
		
		if(id == "db_con_addr"){
			serverListTable.row(index).data().db_con_addr = $("#db_con_addr_"+index).val();
		}else if(id == "chk_portno"){
			serverListTable.row(index).data().chk_portno = parseInt($("#chk_portno_"+index).val());
		}
		serverListTable.row(index).data().edit_yn = "Y";
	}
	/* ********************************************************
	 * Listener Server List 추가
	 ******************************************************** */
	function fn_add_server_list(){
		serverListTable.row.add({
			"backup_yn" : "N",
			"chk_portno" : $("#portno").val(),
			"db_con_addr" : $("#ipadr").val(),
			"lsn_svr_id" : "",
			"lsn_id" : parseInt($("#lstnReg_lsn_id", "#insProxyListenForm").val()),
			"pry_svr_id" : parseInt($("#lstnReg_pry_svr_id", "#insProxyListenForm").val()),
			"edit_yn" : "Y"
		}).draw();
		
		var tempData =serverListTable.rows().data();
		serverListTable.clear();
		serverListTable.rows.add(tempData).draw(); // row 인덱스 재정비, 삭제 후 row 생성 하면 index 중복 발생하여 생성 시 새로 그려줌

		$('#pop_layer_ip_reg').modal("hide");
	}
	/* ********************************************************
	 * Listener Server List 삭제
	 ******************************************************** */
	function fn_del_server_list(){
		if(serverListTable.rows('.selected').data().length==0){
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
			return;
		}else{
			$("#modYn").val("Y");
			if(serverListTable.row('.selected').data().lsn_svr_id!=""){
				delListnerSvrRows[delListnerSvrRows.length] = serverListTable.row('.selected').data(); 
			}
			serverListTable.row('.selected').remove().draw();
		}
	}
	/* ********************************************************
	 *  backup 여부 클릭 이벤트
	 ******************************************************** */
	function fn_backupYn_click(index){
		if(serverListTable.row('.selected').data().backup_yn == 'N'){
			$("input:checkbox[id=backup_yn_" + index +"]").prop("checked", true);
			serverListTable.row('.selected').data().backup_yn = "Y";
		}else{
			$("input:checkbox[id=backup_yn_" + index + "]").prop("checked", false);
			serverListTable.row('.selected').data().backup_yn = "N";
		}
		serverListTable.row('.selected').data().edit_yn = "Y";
	}
	

	function fn_ipadrAddForm(){
		$.ajax({
			url : "/proxy/selectIpList.do",
			data : {pry_svr_id : parseInt($("#lstnReg_pry_svr_id", "#insProxyListenForm").val())},
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
				console.log(result);
				var dataLen = serverListTable.rows().data().length;
				var datas = serverListTable.rows().data();
				$("#ipadr").children().remove();
				$("#ipadr").append("<option value='%'><spring:message code='common.choice' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						var inclu = false;
						var inner_inclu = false;
						for(var j=0 ; j < dataLen ; j++){
							if(datas[j].db_con_addr == result[i].db_con_addr) inclu=true;
							if(datas[j].db_con_addr == result[i].intl_ipadr || result[i].intl_ipadr ==null || result[i].intl_ipadr =="") inner_inclu=true;
							
						}
						if(!inclu){
							$("#ipadr").append("<option value='"+result[i].db_con_addr+"'>"+result[i].db_con_addr+"</option>");	
						}
						if(!inner_inclu){
							if(result[i].intl_ipadr != null && result[i].intl_ipadr!="")	$("#ipadr").append("<option value='"+result[i].intl_ipadr+"'>"+result[i].intl_ipadr+" (내부)</option>");	
						}
					}									
				}
			}
		});
	  	
		document.ipadr_form.reset();
	}
	function fn_change_ipadr(){
		var ipadr = $("#ipadr").val();
		$("#portno").val(ipadr.substr(ipadr.indexOf(":")+1,ipadr.length));
	}
	
	/* ********************************************************
	 *  리스너명 변경 시 이벤트
	 ******************************************************** */
	function fn_change_lsn_nm(){
		if($("#lstnReg_lsn_nm_sel", "#insProxyListenForm").val() !=""){
			$("#lstnReg_lsn_nm", "#insProxyListenForm").val($("#lstnReg_lsn_nm_sel").children("option:selected").text());
			if($("#lstnReg_lsn_nm_sel", "#insProxyListenForm").val() == "TC004201"){//pgReadWrite
				$("#lstnReg_con_sim_query", "#insProxyListenForm").val("select haproxy_check();");
				$("#lstnReg_field_nm", "#insProxyListenForm").val("haproxy_check");
				$("#lstnReg_field_val", "#insProxyListenForm").val("false");
				//$("#lstnReg_con_sim_query_sel", "#insProxyListenForm").val("TC004101"); 
			}else if($("#lstnReg_lsn_nm_sel", "#insProxyListenForm").val() == "TC004202"){//pgReadOnly
				$("#lstnReg_con_sim_query", "#insProxyListenForm").val("select 1;");
				$("#lstnReg_field_nm", "#insProxyListenForm").val("?column?");
				$("#lstnReg_field_val", "#insProxyListenForm").val("1");
				$("#lstnReg_con_sim_query_sel", "#insProxyListenForm").val("TC004102"); 
			}
		}else{
			$("#lstnReg_lsn_nm", "#insProxyListenForm").val("");
			$("#lstnReg_con_sim_query", "#insProxyListenForm").val("");
			$("#lstnReg_field_nm", "#insProxyListenForm").val("");
			$("#lstnReg_field_val", "#insProxyListenForm").val("");
			//$("#lstnReg_con_sim_query_sel", "#insProxyListenForm").val(""); 
		}
	}
	
	function fn_change_con_bind_ip_sel(){
		$("#lstnReg_con_bind_ip", "#insProxyListenForm").val($("#lstnReg_con_bind_ip_sel", "#insProxyListenForm").val());
	}
	
	function fn_db_nm_change(){
		$("#lstnReg_db_id", "#insProxyListenForm").val($("#lstnReg_db_nm", "#insProxyListenForm").val());
	}
	
</script>

<div class="modal fade" id="pop_layer_ip_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="display: none; z-index: 1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 250px 300px;">
		<div class="modal-content" style="width:1000px;">			 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.con_dbms_reg" />
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<form class="cmxform" name="ipadr_form" id="ipadr_form" method="post">
							<fieldset>
								<div class="form-group row">
									<label for="com_max_clusters" class="col-sm-3 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.dbms_con_adr" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control"  id="ipadr" name="ipadr" onchange="fn_change_ipadr();">
											<option value="%"><spring:message code="schedule.total" /> </option>
										</select>
									</div>
									
									<label for="com_max_clusters" class="col-sm-2 col-form-label pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="data_transfer.port" />(*)
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="portno" name="portno"  maxlength="5" placeholder="5<spring:message code='message.msg188'/>">
									</div>
									
								</div>
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
									<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" value='<spring:message code="common.add" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="pop_layer_proxy_listen_reg" tabindex="-1" role="dialog" aria-labelledby="ModalProxyListen" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 330px;">
	<form class="cmxform" id="insProxyListenForm">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalProxyListen" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.listener_reg"/>
				</h4>
				
				<div class="card" style="margin-top:10px;border:0px;">
						<input type="hidden" name="lstnReg_pry_svr_id" id="lstnReg_pry_svr_id"/>
						<input type="hidden" name="lstnReg_lsn_id" id="lstnReg_lsn_id"/>
						<input type="hidden" name="lstnReg_db_id" id="lstnReg_db_id"/>
						<input type="hidden" name="lstnReg_mode" id="lstnReg_mode"/>
						<input type="hidden" name="lstnReg_db_usr_id" id="lstnReg_db_usr_id" value="reqmgr"/>
						<input type="hidden" name="lstnReg_field_val" id="lstnReg_field_val"/>
						<input type="hidden" name="lstnReg_field_nm" id="lstnReg_field_nm"/>
						<fieldset>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label class="col-sm-3 col-form-label-xsm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.basic_setting" />
									</label>
								</div>
								<div class="form-group row">
									<label for="lstnReg_lsn_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.listener_nm" />(*)
									</label>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm lstnReg_lsn_nm" autocomplete="off" maxlength="15" id="lstnReg_lsn_nm" name="lstnReg_lsn_nm" onblur="this.value=this.value.trim()"  placeholder="" tabindex=1 />
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="lstnReg_lsn_nm_sel" id="lstnReg_lsn_nm_sel" onchange="fn_change_lsn_nm();"  tabindex=4 >
											<option value=""><spring:message code="common.choice"/></option>
											<c:forEach var="result" items="${listenerNmList}">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:forEach>
										</select>
									</div>
									<div class="col-sm-auto"></div>
								</div>
								<div class="form-group row">
									<label for="lstnReg_con_bind" class="col-sm-3 col-form-label-sm pop-label-index">
										&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.bind_ip_port" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="lstnReg_con_bind_ip_sel" id="lstnReg_con_bind_ip_sel" tabindex=4 onchange="fn_change_con_bind_ip_sel();">
											<option value="*">*</option>
										</select>
									</div>
									<div class="col-sm-3">
										<input type="text" class="form-control form-control-xsm" id="lstnReg_con_bind_ip" name="lstnReg_con_bind_ip" onblur="this.value=this.value.trim()" placeholder="IP" tabindex=2 />
									</div>
									<div class="col-sm-auto col-form-label-sm">
										:
									</div>
									<div class="col-sm-1_5">
										<input type="number" class="form-control form-control-xsm" maxlength="5" id="lstnReg_con_bind_port" name="lstnReg_con_bind_port"  onKeyPress="chk_Number(this);" onblur="this.value=this.value.trim()" placeholder="port" tabindex=2 />
									</div>
									<div class="col-sm-auto"></div>
								</div>
								<div class="form-group row">
									<label for="lstnReg_db_nm" class="col-sm-3 col-form-label-sm pop-label-index">
										&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
										Check <spring:message code="eXperDB_proxy.database" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="lstnReg_db_nm" id="lstnReg_db_nm" onchange="fn_db_nm_change();" tabindex=4 >
										</select>
									</div>
									<label for="lstnReg_con_sim_query" class="col-sm-2 col-form-label-sm pop-label-index" style="display: none;">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.check_query" />(*)
									</label>
									<div class="col-sm-5" style="display: none;">
										<input type="text" class="form-control form-control-xsm lstnReg_con_sim_query" id="lstnReg_con_sim_query" name="lstnReg_con_sim_query" />
									</div>
								</div>
								<div class="form-group row row-last">
									<label for="lstnReg_lsn_desc" class="col-sm-3 col-form-label-sm pop-label-index">
										&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.desc" />
									</label>
									<div class="col-sm-9">
										<input type="text" class="form-control form-control-xsm" maxlength="250" id="lstnReg_lsn_desc" name="lstnReg_lsn_desc" onblur="this.value=this.value.trim()" placeholder="" tabindex=2 />
									</div>
								</div>
							</div>
							<%-- <br/>
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label class="col-sm-3 col-form-label-xsm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										Health Check
									</label>
								</div>
								<div class="form-group row row-last">
									<label for="lstnReg_db_nm" class="col-sm-2 col-form-label-sm pop-label-index">
										&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.database" />(*)
									</label>
									<div class="col-sm-3">
										<select class="form-control form-control-xsm" style="margin-right: -1.8rem; width:100%;" name="lstnReg_db_nm" id="lstnReg_db_nm" onchange="fn_db_nm_change();" tabindex=4 >
										</select>
									</div>
									<label for="lstnReg_con_sim_query" class="col-sm-2 col-form-label-sm pop-label-index">
										<i class="item-icon fa fa-angle-double-right"></i>
										<spring:message code="eXperDB_proxy.check_query" />(*)
									</label>
									<div class="col-sm-5">
										<input type="text" class="form-control form-control-xsm lstnReg_con_sim_query" id="lstnReg_con_sim_query" name="lstnReg_con_sim_query" />
									</div>
								</div>
							</div> --%>
							<br/>
							
							<div class="card-body card-body-xsm card-body-border">
								<div class="form-group row">
									<label for="lstnReg_lsn_nm" class="col-sm-2 col-form-label-xsm pop-label-index">
										<i class="item-icon fa fa-dot-circle-o"></i>
										<spring:message code="eXperDB_proxy.con_dbms" />
									</label>
								</div>
								<div class="form-group row">
										<label for="com_db_svr_nm" class="col-sm-12 col-form-label-sm" style="margin-bottom:-50px;">
											&nbsp;&nbsp;&nbsp;<i class="item-icon fa fa-angle-double-right"></i>
											<spring:message code="dbms_information.dbms_list" />
										</label>
									</div>
									<div class="form-group row">
										<div class="col-sm-12">
											<a data-toggle="modal" href="#pop_layer_ip_reg"><span onclick="fn_ipadrAddForm();" style="cursor:pointer"><img src="../images/popup/plus.png" alt="" style="margin-left: 88%;"/></span></a>
											<span onclick="fn_del_server_list();" style="cursor:pointer"><img src="../images/popup/minus.png" alt=""  /></span>
											<table id="serverList" class="table table-hover table-striped system-tlb-scroll input-table" style="width:100%;">
												<thead>
													<tr class="bg-info text-white">
														<th width="200"><spring:message code="eXperDB_proxy.dbms_con_adr" /></th>
														<th width="100"><spring:message code="eXperDB_proxy.port" /></th>
														<th width="100"><spring:message code="eXperDB_proxy.backup_yn" /></th>
														<th width="0"></th>
														<th width="0"></th>
														<th width="0"></th>			
														<th width="0"></th>							
													</tr>
												</thead>
											</table>
										
										</div>
									</div>
							</div>
							
							<br/>
							
							<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
								<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="submit" id="lstnReg_save_submit" value='<spring:message code="common.save" />' />
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
							</div>
						</fieldset>
				</div>
			</div>
		</div>
		</form>
	</div>
</div>