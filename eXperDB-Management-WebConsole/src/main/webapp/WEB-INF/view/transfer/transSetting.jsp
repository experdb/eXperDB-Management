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
	* @Class Name : transferTarget.jsp
	* @Description : TransferTarget 화면
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
<style>
/*툴팁 스타일*/
a.tip {
    position: relative;
    color:black;
}

a.tip span {
    display: none;
    position: absolute;
    top: 20px;
    left: -10px;
    width: 200px;
    padding: 5px;
    z-index: 100;
    background: #000;
    color: #fff;
    line-height: 20px;
    -moz-border-radius: 5px; /* 파폭 박스 둥근 정도 */
    -webkit-border-radius: 5px; /* 사파리 박스 둥근 정도 */
}

a:hover.tip span {
    display: block;
}
</style>
<script type="text/javascript">
	var table = null;
	var confile_title = "";
	
	var trans_id_List = [];
	var trans_exrt_trg_tb_id_List = [];
	var kc_ip_List = [];
	var kc_port_List = [];
	var connect_nm_List = [];

	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_init();

		//화면 조회
		fn_select();
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_init(){
		table = $('#transSettingTable').DataTable({
			scrollY : "330px",
			deferRender : true,
			scrollX: true,
			searching : false,
			columnDefs: [
			                 {orderable: false, targets: [0] }
			              ],
			columns : [
  						{ data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
						{data : "rownum",  className : "dt-center", defaultContent : ""}, 	
						{data : "status", 
							render: function (data, type, full){
								var html = "";

								html += '<div class="onoffswitch">';
								if(full.exe_status == "TC001501"){
									html += '<input type="checkbox" name="transActivation" class="onoffswitch-checkbox" id="transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +')" checked>';
								}else if(full.exe_status == "TC001502"){
									html += '<input type="checkbox" name="transActivation" class="onoffswitch-checkbox" id="transActivation'+ full.rownum +'" onclick="fn_transActivation_click('+ full.rownum +')" >';
								}
								html += '<label class="onoffswitch-label" for="transActivation'+ full.rownum +'">';
								html += '<span class="onoffswitch-inner"></span>';
								html += '<span class="onoffswitch-switch"></span></label>';
								
								html += '<input type="hidden" name="act_db_svr_id" id="act_db_svr_id'+ full.rownum +'" value="'+ full.db_svr_id +'"/>';
								html += '<input type="hidden" name="act_trans_exrt_trg_tb_id" id="act_trans_exrt_trg_tb_id'+ full.rownum +'" value="'+ full.trans_exrt_trg_tb_id +'"/>';
								html += '<input type="hidden" name="act_trans_id" id="act_trans_id'+ full.rownum +'" value="'+ full.trans_id +'"/>';
								html += '<input type="hidden" name="act_kc_port" id="act_kc_port'+ full.rownum +'" value="'+ full.kc_port +'"/>';
								html += '<input type="hidden" name="act_kc_ip" id="act_kc_ip'+ full.rownum +'" value="'+ full.kc_ip +'"/>';
								html += '<input type="hidden" name="act_connect_nm" id="act_connect_nm'+ full.rownum +'" value="'+ full.connect_nm +'"/>';

								html += '</div>';

								return html;
							},
							className : "dt-center",
							 defaultContent : "" 	
						},

						{ data : "kc_ip",  className : "dt-center", defaultContent : "",orderable : false},
						{ data : "kc_port",  className : "dt-center", defaultContent : "",orderable : false},
						{ data : "db_svr_nm",  className : "dt-center", defaultContent : "",orderable : false},
						{ data : "connect_nm",  
			    			"render": function (data, type, full) {				
			    				  return '<span onClick=javascript:fn_transLayer("'+full.rownum+'"); class="bold">' + full.connect_nm + '</span>';
			    			},
							className : "dt-center", defaultContent : "",orderable : false},
						{ data : "db_nm",  className : "dt-center", defaultContent : "",orderable : false},
						{ data : "snapshot_nm",  className : "dt-center", defaultContent : "",orderable : false},
						{ data : "compression_nm",  
			    			"render": function (data, type, full) {				
			    				var html = "";
			    				var compression_type_info = nvlPrmSet(full.compression_type, "");
			    				
			    				//메타데이타 설정
								if (compression_type_info != "") {
									if (compression_type_info == 'TC003701') {
										html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
										html += "	<i class='fa fa-times text-danger mr-2'></i>";
										html += nvlPrmSet(full.compression_nm, "");
										html += "</div>";
									} else {
										html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
										html += "	<i class='fa fa-file-zip-o text-success mr-2'></i>";
										html += nvlPrmSet(full.compression_nm, "");
										html += "</div>";
									}
								}

			    				return html;
			    			},
							className : "dt-center", defaultContent : "",orderable : false},
						{ data : "meta_data",  
			    			"render": function (data, type, full) {				
			    				var html = "";
			    				
			    				//메타데이타 설정
			    				if (nvlPrmSet(full.meta_data, "") == "OFF" || nvlPrmSet(full.meta_data, "") == "") {
			    					html += "<div class='badge badge-pill badge-light' style='background-color: #EEEEEE;'>";
			    					html += "	<i class='fa fa-power-off mr-2'></i>";
			    					html += "OFF";
			    					html += "</div>";
			    				} else {
			    					html += "<div class='badge badge-pill badge-info text-white'>";
			    					html += "	<i class='fa fa-power-off mr-2'></i>";
			    					html += "ON";
			    					html += "</div>";
			    				}

			    				return html;
			    			},
							className : "dt-center", defaultContent : "",orderable : false},
						{data : "db_svr_id", defaultContent : "", visible: false },
						{data : "db_id", defaultContent : "", visible: false },
						{data : "snapshot_mode", defaultContent : "", visible: false },
						{data : "trans_exrt_trg_tb_id", defaultContent : "", visible: false },
						{data : "trans_id", defaultContent : "", visible: false },
						{data : "exe_status", defaultContent : "", visible: false }
					],'select': {'style': 'multi'}
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		
		table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');

	    $(window).trigger('resize'); 
	    
		table.on( 'order.dt search.dt', function () {
			table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
	}

	/* ********************************************************
	 * 활성화 클릭
	 ******************************************************** */
	function fn_transActivation_click(row){
		if($("#transActivation"+row).is(":checked") == true){
			$('#con_multi_gbn', '#findConfirmMulti').val("con_start");
			$('#confirm_multi_msg').html('<spring:message code="data_transfer.msg8" />');
		} else {
			$('#con_multi_gbn', '#findConfirmMulti').val("con_end");
			$('#confirm_multi_msg').html('<spring:message code="data_transfer.msg9" />');
		}
		
		confile_title = '<spring:message code="menu.trans_management" />' + " " + '<spring:message code="data_transfer.transfer_activity" />';
		$('#confirm_multi_tlt').html(confile_title);
		$('#chk_act_row', '#findList').val(row);
		
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * transfer Data Fetch List
	 ******************************************************** */
	function fn_select(){
		$.ajax({
			url : "/selectTransSetting.do", 
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				connect_nm : $("#connect_nm").val()
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
				table.rows({selected: true}).deselect();
				table.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					table.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * 등록버튼 클릭시
	 ******************************************************** */
	function fn_newInsert(){
		var selectDbList = "";
		$.ajax({
			url : "/popup/connectRegForm2.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "i"
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
				fn_insert_chogihwa("reg");

				$('#pop_layer_con_reg_two').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * 수정버튼 클릭시
	 ******************************************************** */
	function fn_newUpdate(){
		var datas = table.rows('.selected').data();
		var validateMsg = "";

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if(table.row('.selected').data().exe_status == "TC001501"){
			validateMsg = '<spring:message code="data_transfer.msg11"/>';
			showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		var trans_id_chk = table.row('.selected').data().trans_id;
		var trans_exrt_trg_tb_id_chk = table.row('.selected').data().trans_exrt_trg_tb_id;
		
		$('#mod_trans_id', '#findList').val(trans_id_chk);
		$('#mod_trans_exrt_trg_tb_id', '#findList').val(trans_exrt_trg_tb_id_chk);

 		$.ajax({
			url : "/popup/connectRegReForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "u",
				trans_exrt_trg_tb_id : trans_exrt_trg_tb_id_chk,
				trans_id : trans_id_chk
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
				fn_insert_chogihwa("mod");
				
				//update setting
				fn_update_setting(result);

				$('#pop_layer_con_re_reg_two').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * 수정 팝업셋팅
	 ******************************************************** */
	function fn_update_setting(result) {
		$("#mod_kc_ip", "#searchModForm").val(nvlPrmSet(result.kc_ip, ""));
		$("#mod_kc_port", "#searchModForm").val(nvlPrmSet(result.kc_port, ""));
		
		$("#mod_connect_nm", "#modRegForm").val(nvlPrmSet(result.connect_nm, ""));
		$("#mod_db_id", "#modRegForm").val(nvlPrmSet(result.db_nm, ""));
		$("#mod_db_id_set", "#modRegForm").val(nvlPrmSet(result.db_id, ""));
		$("#mod_trans_id", "#modRegForm").val(nvlPrmSet(result.trans_id, ""));
		$("#mod_trans_exrt_trg_tb_id","#modRegForm").val(nvlPrmSet(result.trans_exrt_trg_tb_id, ""));

		//스냅샷 모드 추가
		var snapshot_mode_re = nvlPrmSet(result.snapshot_mode, "");
		$("#mod_snapshot_mode", "#modRegForm").val(snapshot_mode_re).prop("selected", true);

		//압축형태 추가
		$("#mod_compression_type", "#modRegForm").val(nvlPrmSet(result.compression_type, "TC003701")).prop("selected", true);
		
		//메타데이타 설정
		$("#mod_meta_data", "#modRegForm").val(nvlPrmSet(result.meta_data, ""));
		
		if (nvlPrmSet(result.meta_data, "") == "ON") {
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", true);
		} else {
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", false); 
		}
	
		//스냅샷 모드 change
		if(snapshot_mode_re == "TC003601"){
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg2" />'); //(초기스냅샷 1회만 수행)
		}else if(snapshot_mode_re == "TC003602"){
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg3" />'); //(스냅샷 항상 수행)
		}else if (snapshot_mode_re == "TC003603"){
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg1" />'); //(스냅샷 수행하지 않음)
		}else if (snapshot_mode_re == "TC003604"){
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg4" />'); //(스냅샷만 수행하고 종료)
		}else if (snapshot_mode_re == "TC003605"){
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg5" />'); //(복제슬롯이 생성된 시접부터의 스냅샷 lock 없는 효율적방법)
		}
		
		mod_connector_tableList.rows({selected: true}).deselect();
		mod_connector_tableList.clear().draw();
		
		if (result.tables.data != null) {
			mod_connector_tableList.rows.add(result.tables.data).draw();	
		}
	}
	
	/* ********************************************************
	 * 등록 팝업 초기화
	 ******************************************************** */
	function fn_insert_chogihwa(gbn) {
		if (gbn == "reg") {
			$("#ins_db_id", "#insRegForm").val("");
			$("#ins_table_nm").val("");

			//스냅샷 모드 추가
			$("#ins_snapshot_mode", "#insRegForm").val('TC003603').prop("selected", true); //값이 1인 option 선택

			//압축형태 추가
			$("#ins_compression_type", "#insRegForm").val('TC003701').prop("selected", true); //값이 1인 option 선택
			
			//입력관련 초기화
			$("#ins_kc_ip", "#searchRegForm").val("");
			$("#ins_kc_port", "#searchRegForm").val("");

			$("#ins_connect_nm", "#insRegForm").val("");
			$("#ins_snapshotModeDetail", "#insRegForm").html('<spring:message code="data_transfer.msg1" />');

			//메타데이타 설정
			$("#ins_meta_data", "#insRegForm").val("OFF");
			$("input:checkbox[id='ins_meta_data_chk']").prop("checked", false); 
			
			ins_tableList.clear().draw();
			ins_connector_tableList.clear().draw();
			
			ins_connect_status_Chk = "fail";
			ins_connect_nm_Chk = "fail";
			
			$('a[href="#insSettingTab"]').tab('show');
		} else {
			$("#mod_db_id", "#modRegForm").val("");
			$("#mod_db_id_set", "#modRegForm").val("");
			$("#mod_table_nm").val("");
			$("#mod_trans_id", "#modRegForm").val("");
			$("#mod_trans_exrt_trg_tb_id","#modRegForm").val("");
			
			//스냅샷 모드 추가
			$("#mod_snapshot_mode", "#modRegForm").val('TC003603').prop("selected", true); //값이 1인 option 선택

			//압축형태 추가
			$("#mod_compression_type", "#modRegForm").val('TC003701').prop("selected", true); //값이 1인 option 선택
			
			//입력관련 초기화
			$("#mod_kc_ip", "#searchRegForm").val("");
			$("#mod_kc_port", "#searchRegForm").val("");

			$("#mod_connect_nm", "#modRegForm").val("");
			$("#mod_snapshotModeDetail", "#modRegForm").html('<spring:message code="data_transfer.msg1" />');

			//메타데이타 설정
			$("#mod_meta_data", "#modRegForm").val("OFF");
			$("input:checkbox[id='mod_meta_data_chk']").prop("checked", false); 
			
			mod_tableList.clear().draw();
			mod_connector_tableList.clear().draw();
			
			mod_connect_status_Chk = "fail";
			mod_connect_nm_Chk = "fail";
			
			$('a[href="#modSettingTab"]').tab('show');
		}

	}

	/* ********************************************************
	 * 삭제버튼 클릭시
	 ******************************************************** */
	function fn_del_confirm(){
		var validateMsg = "";
		var datas = table.rows('.selected').data();
		var i_exe_status = 0;
		trans_id_List = [];
		trans_exrt_trg_tb_id_List = [];

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		for (var i = 0; i < datas.length; i++) {
 			if(datas[i].exe_status == "TC001501"){
				i_exe_status = i_exe_status + 1;
			}
 			
 			trans_id_List.push(datas[i].trans_id);   
 			trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
		}

		if (i_exe_status > 0) {
			validateMsg = '<spring:message code="data_transfer.msg7"/>';
			showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		confile_title = '<spring:message code="menu.trans_management" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';

		$('#con_multi_gbn', '#findConfirmMulti').val("del");
		
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "del") {
			fn_delete();
		} else if (gbn == "con_start" || gbn == "con_end") {
			fn_act_execute(gbn);
		} else if (gbn == "active" || gbn == "disabled") {
			fn_tot_act_execute(gbn);
		}
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		if ($('#chk_act_row', '#findList') != null) {
			var canCheckId = 'transActivation' + $('#chk_act_row', '#findList').val();
			
			if (gbn == "con_start") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", false); 
			} else if (gbn == "con_end") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
			} else if (gbn == "check_con_end") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
			} else if (gbn == "check_con_start") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
			}
		}
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_delete(){
		$.ajax({
			url : "/deleteTransSetting.do",
		  	data : {
		  		trans_id_List : JSON.stringify(trans_id_List),
		  		trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List)
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
					fn_select();
				}else{
					msgVale = "<spring:message code='menu.script_settings' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * 활성화 단건실행
	 ******************************************************** */
	function fn_act_execute(act_gbn) {
		var ascRow =  $('#chk_act_row', '#findList').val();
		var validateMsg ="";
		var checkId = "";
		
		if (act_gbn == "con_start") {
			$.ajax({
				url : "/transStart.do",
				data : {
					db_svr_id : $('#act_db_svr_id' + ascRow).val(),
					trans_exrt_trg_tb_id : $('#act_trans_exrt_trg_tb_id' + ascRow).val(),
					trans_id : $('#act_trans_id' + ascRow).val()
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
					checkId = 'transActivation' + ascRow;

					if (result == null) {
						validateMsg = '<spring:message code="data_transfer.msg10"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						
						$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
						return;
					} else {
						if (result == "success") {
							fn_select();
						} else {
							validateMsg = '<spring:message code="data_transfer.msg10"/>';
							showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
							
							$("input:checkbox[id='" + checkId + "']").prop("checked", false);
							return;
						}
					}
				}
			});
		} else {
			$.ajax({
				url : "/transStop.do",
				data : {
					db_svr_id : $('#act_db_svr_id' + ascRow).val(),
					trans_id : $('#act_trans_id' + ascRow).val(),
					kc_ip : $('#act_kc_ip' + ascRow).val(),
					kc_port : $('#act_kc_port' + ascRow).val(),
					connect_nm : $('#act_connect_nm' + ascRow).val()
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
					checkId = 'transActivation' + ascRow;

					if (result == null) {
						validateMsg = '<spring:message code="data_transfer.msg10"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						
						$("input:checkbox[id='" + checkId + "']").prop("checked", true); 
						return;
					} else {
						if (result == "success") {
							fn_select();
						} else {
							validateMsg = '<spring:message code="data_transfer.msg10"/>';
							showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
							
							$("input:checkbox[id='" + checkId + "']").prop("checked", true);
							return;
						}
					}
				}
			});
		}
	}
	
	/* ********************************************************
	 * 전송관리 상세
	 ******************************************************** */
	function fn_transLayer(row){
		$.ajax({
			url : "/selectTransSettingInfo.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				act : "u",
				trans_exrt_trg_tb_id : $('#act_trans_exrt_trg_tb_id' + row).val(),
				trans_id : $('#act_trans_id' + row).val()
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
				if(result == null){
					msgVale = "<spring:message code='menu.trans_management' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					
					$('#pop_layer_trans_info').modal('hide');
					return;
				} else {
					//상세 조회 셋팅
					fn_info_setting(result);

					$('#pop_layer_trans_info').modal('show');
				}
			}
		});	
	}
	
	/* ********************************************************
	 * 상세 팝업셋팅
	 ******************************************************** */
	function fn_info_setting(result) {
		//스냅샷 모드 추가
		var snapshot_mode_re = nvlPrmSet(result.snapshot_mode, "");
		var snapshot_mode_nm = nvlPrmSet(result.snapshot_nm, "");
		var info_meta_data_chk = "";
		
		//압축형태
		var compression_type_info_val = "";
		var compression_type_info = nvlPrmSet(result.compression_type, "");

		$("#d_kc_ip", "#searchInfoForm").html(nvlPrmSet(result.kc_ip, ""));
		$("#d_kc_port", "#searchInfoForm").html(nvlPrmSet(result.kc_port, ""));

		$("#d_connect_nm", "#infoRegForm").html(nvlPrmSet(result.connect_nm, ""));
		$("#d_db_id", "#infoRegForm").html(nvlPrmSet(result.db_nm, ""));

		//스냅샷 모드 change
		if(snapshot_mode_re == "TC003601"){
			snapshot_mode_nm += ' ' + '<spring:message code="data_transfer.msg2" />';
		}else if(snapshot_mode_re == "TC003602"){
			snapshot_mode_nm += ' ' + '<spring:message code="data_transfer.msg3" />';
		}else if (snapshot_mode_re == "TC003603"){
			snapshot_mode_nm += ' ' + '<spring:message code="data_transfer.msg1" />';
		}else if (snapshot_mode_re == "TC003604"){
			snapshot_mode_nm += ' ' + '<spring:message code="data_transfer.msg4" />';
		}else if (snapshot_mode_re == "TC003605"){
			snapshot_mode_nm += ' ' + '<spring:message code="data_transfer.msg5" />';
		}
		$("#d_snapshot_mode_nm", "#infoRegForm").html(snapshot_mode_nm);
		
		//압축모드
		if (compression_type_info != "") {
			if (compression_type_info == 'TC003701') {
				compression_type_info_val += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				compression_type_info_val += "	<i class='ti-close text-danger mr-2'></i>";
				compression_type_info_val += nvlPrmSet(result.compression_nm, "");
				compression_type_info_val += "</div>";
			} else {
				compression_type_info_val += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				compression_type_info_val += "	<i class='fa fa-file-zip-o text-success mr-2'></i>";
				compression_type_info_val += nvlPrmSet(result.compression_nm, "");
				compression_type_info_val += "</div>";
			}
		}

		$("#d_compression_type_nm", "#infoRegForm").html(compression_type_info_val);
		
		//메타데이타 설정
		if (nvlPrmSet(result.meta_data, "") == "OFF" || nvlPrmSet(result.meta_data, "") == "") {
			info_meta_data_chk += "<div class='badge badge-pill badge-light' style='background-color: #EEEEEE;'>";
			info_meta_data_chk += "	<i class='fa fa-power-off mr-2'></i>";
			info_meta_data_chk += "OFF";
			info_meta_data_chk += "</div>";
		} else {
			info_meta_data_chk += "<div class='badge badge-pill badge-info text-white'>";
			info_meta_data_chk += "	<i class='fa fa-power-off mr-2'></i>";
			info_meta_data_chk += "ON";
			info_meta_data_chk += "</div>";
		}
		$("#d_meta_data_chk", "#infoRegForm").html(info_meta_data_chk);

		info_connector_tableList.rows({selected: true}).deselect();
		info_connector_tableList.clear().draw();
		
		if (result.tables.data != null) {
			info_connector_tableList.rows.add(result.tables.data).draw();
		}

		$('a[href="#infoSettingTab"]').tab('show');
	}
	
	/* ********************************************************
	 * 선택 활성화 클릭
	 ******************************************************** */
	function fn_activaExecute_click(tot_con_gbn){
		var validateMsg = "";
		var datas = table.rows('.selected').data();
		var i_exe_status = 0;
		var i_un_exe_status = 0;
		trans_id_List = [];
		trans_exrt_trg_tb_id_List = [];

		kc_ip_List = [];
		kc_port_List = [];
		connect_nm_List = [];

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (tot_con_gbn == "active") {
			for (var i = 0; i < datas.length; i++) {
	 			if(datas[i].exe_status == "TC001501"){
					i_exe_status = i_exe_status + 1;
				} else {
					i_un_exe_status = i_un_exe_status + 1;

		 			trans_id_List.push(datas[i].trans_id);   
		 			trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
				}
			}
			
			//실행 내역이 없는 경우
			if (i_un_exe_status <= 0) {
				showSwalIcon('<spring:message code="data_transfer.msg17" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}

			if (i_exe_status > 0) {
				validateMsg = '<spring:message code="data_transfer.msg13"/>';
			} else {
				validateMsg = '<spring:message code="data_transfer.msg12"/>';
			}
		} else {
			for (var i = 0; i < datas.length; i++) {
				console.log("===datas[i].exe_status==" + datas[i].exe_status);
 	 			if(datas[i].exe_status == "TC001501"){
	 				i_exe_status = i_exe_status + 1;
	 				
		 			trans_id_List.push(datas[i].trans_id);   
		 			trans_exrt_trg_tb_id_List.push(datas[i].trans_exrt_trg_tb_id);
		 			kc_ip_List.push(datas[i].kc_ip);
		 			kc_port_List.push(datas[i].kc_port);
		 			connect_nm_List.push(datas[i].connect_nm);
		 			
				} else {
					i_un_exe_status = i_un_exe_status + 1;
				}
			}
			
			//실행 내역이 없는 경우
			if (i_exe_status <= 0) {
				showSwalIcon('<spring:message code="data_transfer.msg17" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}

			if (i_un_exe_status > 0) {
				validateMsg = '<spring:message code="data_transfer.msg15"/>';
			} else {
				validateMsg = '<spring:message code="data_transfer.msg14"/>';
			}
		}

		confile_title = '<spring:message code="menu.trans_management" />' + " " + '<spring:message code="data_transfer.transfer_activity" />';

		$('#con_multi_gbn', '#findConfirmMulti').val(tot_con_gbn);
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html(validateMsg);
		$('#pop_confirm_multi_md').modal("show");
	}
	
	
	/* ********************************************************
	 * 선택 활성화 실행
	 ******************************************************** */
	function fn_tot_act_execute(exeGbn){
		//버튼 제어
		fn_buttonExecuteAut("start", exeGbn);

		if (exeGbn == "active") {
			$.ajax({
				url : "/transTotExecute.do",
			  	data : {
			  		execute_gbn : exeGbn,
					db_svr_id : $("#db_svr_id", "#findList").val(),
			  		trans_id_List : JSON.stringify(trans_id_List),
			  		trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List)
			  	},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", true);
				},
				error : function(xhr, status, error) {
					//버튼제어
					fn_buttonExecuteAut("end", "");
					
					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(result) {
					//버튼제어
					fn_buttonExecuteAut("end", "");

					if (result == null) {
						validateMsg = '<spring:message code="data_transfer.msg10"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						if (result == "success") {
							showSwalIcon('<spring:message code="data_transfer.msg16" />', '<spring:message code="common.close" />', '', 'success');
							fn_select();
						} else {
							validateMsg = '<spring:message code="data_transfer.msg10"/>';
							showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
							return;
						}
					}
				}
			});
		} else {
			$.ajax({
				url : "/transTotExecute.do",
			  	data : {
			  		execute_gbn : exeGbn,
					db_svr_id : $("#db_svr_id", "#findList").val(),
			  		trans_id_List : JSON.stringify(trans_id_List),
			  		trans_exrt_trg_tb_id_List : JSON.stringify(trans_exrt_trg_tb_id_List),
			  		kc_ip_List : JSON.stringify(kc_ip_List),
			  		kc_port_List : JSON.stringify(kc_port_List),
			  		connect_nm_List : JSON.stringify(connect_nm_List)
			  	},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", true);
				},
				error : function(xhr, status, error) {
					//버튼제어
					fn_buttonExecuteAut("end", "");

					if(xhr.status == 401) {
						showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else if(xhr.status == 403) {
						showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
					} else {
						showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
					}
				},
				success : function(result) {	
					//버튼제어
					fn_buttonExecuteAut("end", "");

					if (result == null) {
						validateMsg = '<spring:message code="data_transfer.msg10"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						if (result == "success") {
							showSwalIcon('<spring:message code="data_transfer.msg16" />', '<spring:message code="common.close" />', '', 'success');
							fn_select();
						} else {
							validateMsg = '<spring:message code="data_transfer.msg10"/>';
							showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
							return;
						}
					}
				}
			});
		}
	}
	
	/* ********************************************************
	 * button 제어
	 ******************************************************** */
	function fn_buttonExecuteAut(autIngGbn, exeIngGbn){
		var strMsg = "";
 		if(autIngGbn == "start"){
 			if (exeIngGbn == "active") {
				strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
				strMsg += '<spring:message code="data_transfer.save_select_active" />' + ' ' + '<spring:message code="restore.progress" />';

				$("#btnChoActive").html(strMsg);
 			} else {
				strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
				strMsg += '<spring:message code="data_transfer.save_select_disabled" />' + ' ' + '<spring:message code="restore.progress" />';

				$("#btnChoDisabled").html(strMsg);
 			}

			$("#btnChoActive").prop("disabled", "disabled");
			$("#btnChoDisabled").prop("disabled", "disabled");

			$("#btnDelete").prop("disabled", "disabled");
			$("#btnModify").prop("disabled", "disabled");
			$("#btnInsert").prop("disabled", "disabled");
			$("#btnSearch").prop("disabled", "disabled");
		}else{
			strMsg = '<i class="fa fa-spin fa-cog btn-icon-prepend"></i>';
			$("#btnChoActive").html(strMsg + '<spring:message code="data_transfer.save_select_active" />');
			$("#btnChoDisabled").html(strMsg + '<spring:message code="data_transfer.save_select_disabled" />');
			
			$("#btnChoActive").prop("disabled", "");
			$("#btnChoDisabled").prop("disabled", "");

			$("#btnDelete").prop("disabled", "");
			$("#btnModify").prop("disabled", "");
			$("#btnInsert").prop("disabled", "");
			$("#btnSearch").prop("disabled", "");
		} 
	}
	
</script>

<%@include file="./../popup/connectRegReForm.jsp"%>
<%@include file="./../popup/connectRegForm2.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>
<%@include file="./tansSettingInfo.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="mod_trans_id" id="mod_trans_id" value=""/>
	<input type="hidden" name="mod_trans_exrt_trg_tb_id" id="mod_trans_exrt_trg_tb_id" value=""/>
	<input type="hidden" name="chk_act_row" id="chk_act_row" value=""/>
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
									<div class="col-5">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-check-square"></i>
												<span class="menu-title"><spring:message code="menu.trans_management"/></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.trans_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.connector_settings_01"/></p>
											<p class="mb-0"><spring:message code="help.connector_settings_02"/></p>
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
							<form class="form-inline" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2">
									<input type="text" class="form-control" style="width:400px;" maxlength="25" id="connect_nm" name="connect_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="data_transfer.connect_name_set" />'/>					
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnChoActive" onClick="fn_activaExecute_click('active');" data-toggle="modal">
									<i class="fa fa-spin fa-cog btn-icon-prepend "></i><spring:message code="data_transfer.save_select_active" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnChoDisabled" onClick="fn_activaExecute_click('disabled');" data-toggle="modal">
									<i class="fa fa-spin fa-cog btn-icon-prepend "></i><spring:message code="data_transfer.save_select_disabled" />
								</button>
													
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_del_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onClick="fn_newUpdate();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_newInsert();" data-toggle="modal">
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

	 								<table id="transSettingTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="40" height="0"><spring:message code="common.no" /></th>
												<th width="50"><spring:message code="access_control_management.activation" /></th> <!-- 활성화 -->
												<th width="100">Kafka-Connect <spring:message code="data_transfer.ip" /></th> <!-- Kafka-Connect 아이피 -->
												<th width="100">Kafka-Connect <spring:message code="data_transfer.port" /></th> <!-- Kafka-Connect 포트 -->
												<th width="100"><spring:message code="data_transfer.server_name" /></th> <!-- 서버명 -->
												<th width="100"><spring:message code="data_transfer.connect_name_set" /></th> <!-- Connect 명 -->
												<th width="100"><spring:message code="data_transfer.database" /></th> <!-- DBMS명 -->
												<th width="100"><spring:message code="data_transfer.snapshot_mode" /></th> <!-- 스냅샷 모드 -->
												<th width="100"><spring:message code="data_transfer.compression_type" /></th> <!-- 압축형태 -->
												<th width="100"><spring:message code="data_transfer.metadata" /> 
												</th> <!-- 메타데이타 -->
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												<th width="0"></th>
												
												<!-- <th width="30">구동상태</th> -->
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