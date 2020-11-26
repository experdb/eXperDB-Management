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
	* @Class Name : experdbScale.jsp
	* @Description : experdbScale 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*
	*/
%>
<script>
	var table = null;
	var statusChk="";
	//scale 체크 조회
	var install_yn = "";

	$(window.document).ready(function() {
		//scale 테이블 setting
		fn_init();
		
		var table = $('#scaleDataTable').DataTable();
		$('#select').on( 'keyup', function () {
			 table.search( this.value ).draw();
		});
		$('.dataTables_filter').hide();

		fn_selectScaleInstallChk();
	});
	

	/* ********************************************************
	 * aws 서버 확인
	 ******************************************************** */
	function fn_selectScaleInstallChk() {
		var errorMsg = "";
		var titleMsg = "";

		$.ajax({
			url : "/scale/selectScaleInstallChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					install_yn = result.install_yn;
				}

				//AWS 서버인경우
				if (install_yn == "Y") {
					fn_selectScaleAuto();
				} else {
					showDangerToast('top-right', '<spring:message code="eXperDB_scale.msg10" />', '<spring:message code="eXperDB_scale.msg14" />');
					
					//설치안된경우 버튼 막아야함
					$("#btnScaleIn").prop("disabled", "disabled");
					$("#btnScaleOut").prop("disabled", "disabled");
					$("#btnScaleSearch").prop("disabled", "disabled");
					$("#search_instance_id").prop("disabled", "disabled");
				}
			}
		});
	}

	/* ********************************************************
	 * 테이블 setting
	 ******************************************************** */
	function fn_init() {
		table = $('#scaleDataTable').DataTable({
			scrollY : "420px",
			paging: false,
			searching : false,
			scrollX: true,
			deferRender : true,
			bDestroy: true,
			processing : true,
			bSort: false,
			columns : [
				{ data : "rownum", 
 					render: function (data, type, full){
 						var html = "";
						if(full.instance_status_name == "pending" || full.instance_status_name == "shutting-down"){
							html = '<img src="../images/spinner_loading.png" alt="" style="width:50%;position: relative; display: block; margin: 0px auto;"/>  ';
						}else{
							html = full.rownum;
						}
						return html;
					},
					className : "dt-center",
					defaultContent : "" 	
				},
				{data : "tagsValue", className : "dt-left", defaultContent : "",
					render: function (data, type, full){
 						var html = "";
						if(full.default_chk == "Y"){
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-exclamation mr-2'></i>";
							html += full.tagsValue;
							html += "</div>";

							html+='<input type="hidden" name="default_chk" class="default_hide" value="'+ full.default_chk +'" />'; 
						}else{
							html+= full.tagsValue;
							html+='<input type="hidden" name="default_chk" class="default_hide" value="'+ full.default_chk +'" />'; 
						}
						return html;
					},
				},
				{ data : "instance_id", className : "dt-left", defaultContent : ""
					,render: function (data, type, full) {
						  return '<span onClick=javascript:fn_scaleLayer("'+full.instance_id+'"); class="bold" data-toggle="modal" >' + full.instance_id + '</span>';
					}
				}, 
				{ data : "instance_type", className : "dt-left", defaultContent : ""},
				{ data : "availability_zone", className : "dt-left", defaultContent : ""}, 
				{data : "instance_status_name", 
					render: function (data, type, full){
						var html = "";
						if(full.instance_status_name == "running"){
							html += "<div class='badge badge-pill badge-success'>";
						}else if(full.instance_status_name == "pending"){
							html += "<div class='badge badge-pill badge-warning'>";
						} else {
							html += "<div class='badge badge-pill badge-danger'>";
						}
						html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
						html += full.instance_status_name;
						html += "</div>";

						return html;
					},
					className : "dt-left",
					defaultContent : "" 	
				},
				{ data : "start_time", className : "dt-left", defaultContent : ""}, 
				{ data : "IPv4_public_ip",  defaultContent : ""
					,render: function (data, type, full) {
						if(full.IPv4_public_ip == null){
							var html = '-';
							return html;
						}
					  return data;
				}}, 
				{ data : "private_ip_address",  defaultContent : ""
					,render: function (data, type, full) {
						if(full.private_ip_address == null){
							var html = '-';
							return html;
						}
					  return data;
				}}, 
				{ data : "key_name", className : "dt-left", defaultContent : ""},
				{ data : "security_group", className : "dt-left", defaultContent : ""},
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '120px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * scale 조회 자동 실행
	 ******************************************************** */
	function fn_selectScaleAuto() {
		$.ajax({
			url : "/scale/selectScaleList.do",
			data : {
				scale_id : $("#search_instance_id").val(),
				db_svr_id : '${db_svr_id}'
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

				if (nvlPrmSet(result.data, '') != '') {
					table.rows.add(result.data).draw();
				}

				fn_selectScaleChk("first");
			}
		});
		$('#loading').hide();
	}

	/* ********************************************************
	 * scale 실행여부 체크
	 ******************************************************** */
	function fn_selectScaleChk(gbn) {
		//scale 체크 조회
		var wrk_id = "";
		var scale_set = "";
		
		if (typeof gbn == "undefined" || gbn == null || gbn == "") {
			gbn = "";
		}

		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;
					scale_set = result.scale_type;
				}

				if (gbn == null || gbn == "") {
					if (wrk_id == "1") {
						fn_buttonAut(wrk_id, scale_set);
						setTimeout(fn_selectScaleChk, 3000);
					} else {
						setTimeout(fn_buttonAut, 7000, wrk_id, scale_set);
						setTimeout(fn_selectScale, 5000, "");
					}
				} else if (gbn == "first") {
					if (wrk_id == "1") {
						fn_buttonAut(wrk_id, scale_set);
						setTimeout(fn_selectScaleChk, 3000);
					} else {
						fn_buttonAut(wrk_id, scale_set);
					}
				} else {
					fn_buttonAut(wrk_id, scale_set);
				}
			}
		});
		$('#loading').hide();
	}
	
	/* ********************************************************
	 * button 제어
	 ******************************************************** */
	function fn_buttonAut(wrk_id, scale_set){
		var strMsg = "";
 		if(wrk_id == "1"){
			if (scale_set == "1") {	
				strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
				strMsg += '<spring:message code="etc.etc38" />' + ' ' + '<spring:message code="restore.progress" />';
				$("#btnScaleIn").html(strMsg);
			} else {
				strMsg = "<i class='fa fa-spin fa-spinner btn-icon-prepend'></i>";
				strMsg += '<spring:message code="etc.etc39" />' + ' ' + '<spring:message code="restore.progress" />';
				$("#btnScaleOut").html(strMsg);
			}
			
			$("#btnScaleIn").prop("disabled", "disabled");
			$("#btnScaleOut").prop("disabled", "disabled");
		}else{
			strMsg = '<i class="ti-pencil-alt btn-icon-prepend "></i>';
			$("#btnScaleIn").html(strMsg + '<spring:message code="etc.etc38" />');
			$("#btnScaleOut").html(strMsg + '<spring:message code="etc.etc39" />');
			
			$("#btnScaleIn").prop("disabled", "");
			$("#btnScaleOut").prop("disabled", "");
		} 
	}

	/* ********************************************************
	 * 조회 버튼 클릭시
	 ******************************************************** */
	function fn_selectScale(gbn) {
 		var wrk_id = "";
		var scale_set = "";

		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;
					scale_set = result.scale_type;

					if (wrk_id == "1" && statusChk == "") {
						setTimeout(fn_selectScaleChk, 3000);
					} else {
						statusChk = "";
					}
				}
				fn_buttonAut(wrk_id, scale_set);
				
				fn_selectScaleMain(gbn);
			}
		}); 

		if (gbn == null || gbn == "") {
			$('#loading').hide();
		}

	}
	
	function fn_selectScaleMain(gbn) {
		
 		$.ajax({
			url : "/scale/selectScaleList.do",
			data : {
				scale_id : $("#search_instance_id").val(),
				db_svr_id : '${db_svr_id}'
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

				if (nvlPrmSet(result.data, '') != '') {
					table.rows.add(result.data).draw();
				}
			}
		});
 
		if (gbn == null || gbn == "") {
			$('#loading').hide();
		}
	}
	
	/* ********************************************************
	 * scale 설정 상세
	 ******************************************************** */
	function fn_scaleLayer(scale_id){
		var msgVale = "";
		var instance_status_name_chk = "";
		var instance_status_html = "";
		var source_dest_check_html = "";
		var ebs_optimized_html = "";
		var hiber_configured_html = "";
		
		$.ajax({
			url : "/scale/selectScaleInfo.do",
			data : {
				scale_id : scale_id,
				db_svr_id : '${db_svr_id}'
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
					msgVale = "<spring:message code='eXperDB_scale.node' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'warning');
					
					$('#pop_layer_scale').modal('hide');
					return;
				}else{
					//초기화
					layerReset();
					
					$("#d_name").html(result[0].tagsValue);												//name
					$("#d_instance_id").html(result[0].instance_id);									//instance_id
					$("#d_public_IPv4").html(nvlPrmSet(result[0].public_IPv4, "-"));					//public_IPv4

					instance_status_name_chk = result[0].instance_status_name;
					if(instance_status_name_chk == "running"){
						instance_status_html += "<div class='badge badge-pill badge-success'>";
					} else if(instance_status_name_chk == "pending"){
						instance_status_html += "<div class='badge badge-pill badge-warning'>";
					}else{
						instance_status_html += "<div class='badge badge-pill badge-danger'>";
					}
					instance_status_html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
					instance_status_html += instance_status_name_chk;
					instance_status_html += "</div>";

					$("#d_instance_status_name").html(instance_status_html);							//instance_status_name

					$("#d_IPv4_public_ip").html(nvlPrmSet(result[0].IPv4_public_ip, "-"));				//IPv4_public_ip
					$("#d_instance_type").html(nvlPrmSet(result[0].instance_type, "-"));				//instance_type
					$("#d_IPv6_ip").html(nvlPrmSet(result[0].IPv6_ip, "-"));							//IPv6_ip
					$("#d_state_reason").html(nvlPrmSet(result[0].stateReason_message, "-"));			//state_reason
					$("#d_private_dns_name").html(nvlPrmSet(result[0].private_dns_name, "-"));			//private_dns_name
					$("#d_availability_zone").html(nvlPrmSet(result[0].availability_zone, "-"));		//가용상태
					$("#d_private_ip_address").html(nvlPrmSet(result[0].private_ip_address, "-"));		//private_ip_address
					$("#d_security_group").html(nvlPrmSet(result[0].security_group, "-"));				//security_group  -- 각각 나누어서 check 되도록
					$("#d_vpc_id").html(nvlPrmSet(result[0].vpc_id, "-"));								//vpc_id
					$("#d_subnet_id").html(nvlPrmSet(result[0].subnet_id, "-"));						//d_subnet_id
					$("#d_network_interfaces").html(nvlPrmSet(result[0].network_interfaces, "-"));		//network_interfaces
					$("#d_key_name").html(nvlPrmSet(result[0].key_name, "-"));							//key_name
					
					//source_dest_check
					var source_dest_check_val = nvlPrmSet(result[0].source_dest_check, "-");
					if (source_dest_check_val != "-") {
						if (source_dest_check_val == "false") {
							source_dest_check_html += "<div class='badge badge-pill badge-danger'>";
							source_dest_check_html += "	<i class='fa fa-times-circle mr-2'></i>";
							source_dest_check_html += "<spring:message code='agent_monitoring.no' />";
							source_dest_check_html += "</div>";
						} else {
							source_dest_check_html += "<div class='badge badge-pill badge-info'  style='color: #fff;'>";
							source_dest_check_html += "	<i class='fa fa-check-circle mr-2'></i>";
							source_dest_check_html += "<spring:message code='agent_monitoring.yes' />";
							source_dest_check_html += "</div>";
						}
					}
					$("#d_source_dest_check").html(source_dest_check_html);

					$("#d_productcodeid").html(nvlPrmSet(result[0].productcodeid, "-"));				//제품코드

					//ebs_optimized
					if (result[0].ebs_optimized != null && result[0].ebs_optimized == "false") {
						ebs_optimized_html += "<div class='badge badge-pill badge-danger'>";
						ebs_optimized_html += "	<i class='fa fa-times-circle mr-2'></i>";
						ebs_optimized_html += "<spring:message code='agent_monitoring.no' />";
						ebs_optimized_html += "</div>";
					} else {
						ebs_optimized_html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
						ebs_optimized_html += "	<i class='fa fa-check-circle mr-2'></i>";
						ebs_optimized_html += "<spring:message code='agent_monitoring.yes' />";
						ebs_optimized_html += "</div>";
					}
					$("#d_ebs_optimized").html(ebs_optimized_html);

					$("#d_owner").html(nvlPrmSet(result[0].owner, "-"));								//owner
					$("#d_root_device_type").html(nvlPrmSet(result[0].root_device_type, "-"));			//root_device_type
					$("#d_start_time").html(nvlPrmSet(result[0].start_time, "-"));						//start_time
					$("#d_root_device_name").html(nvlPrmSet(result[0].root_device_name, "-"));			//root_device_name
					$("#d_monitoring").html(nvlPrmSet(result[0].monitoring_state, "-"));				//monitoring
					$("#d_block_device_name").html(nvlPrmSet(result[0].block_device_name, "-"));		//block_device_name
					$("#d_virtualization_type").html(nvlPrmSet(result[0].virtualization_type, "-"));	//virtualization_type
					$("#d_capacity_reservation_id").html(nvlPrmSet(result[0].capacity_reservation_id, "-"));	//capacity_reservation_id
					$("#d_reservation_id").html(nvlPrmSet(result[0].reservation_id, "-"));						//reservation_id
					$("#d_cct_revt_spect_re_id").html(nvlPrmSet(result[0].cct_revt_spect_re_id, "-"));			//cct_revt_spect_re_id
					$("#d_ami_launch_index").html(nvlPrmSet(result[0].ami_launch_index, "-"));					//ami_launch_index
					$("#d_tenancy").html(nvlPrmSet(result[0].tenancy, "-"));									//tenancy
					$("#d_image_id").html(nvlPrmSet(result[0].image_id, "-"));									//image_id

					//hiber_configured
					if (result[0].hiber_configured != null && result[0].hiber_configured == "true") {
						hiber_configured_html += "<div class='badge badge-pill badge-danger'>";
						hiber_configured_html += "	<i class='fa fa-times-circle mr-2'></i>";
						hiber_configured_html += "<spring:message code='etc.etc40' />";
						hiber_configured_html += "</div>";
					} else {
						hiber_configured_html += "<div class='badge badge-pill badge-info' style='color: #fff;'>";
						hiber_configured_html += "	<i class='fa fa-check-circle mr-2'></i>";
						hiber_configured_html += "<spring:message code='etc.etc41' />";
						hiber_configured_html += "</div>";
					}
					$("#d_hiber_configured").html(hiber_configured_html);

					$("#d_core_count").html(nvlPrmSet(result[0].core_count, "-"));								//core_count
					
					$('#pop_layer_scale').modal("show");
				}
			}
		});
	}

	/* ********************************************************
	 * 상세화면 초기화
	 ******************************************************** */
	function layerReset() {
 		$("#d_name").html("");						//name
 		$("#d_instance_id").html("");				//instance_id
 		$("#d_public_IPv4").html("");				//public_IPv4
 		$("#d_instance_status_name").html("");		//instance_status_name
		$("#d_IPv4_public_ip").html("");			//IPv4_public_ip
		$("#d_instance_type").html("");				//instance_type
		$("#d_IPv6_ip").html("");					//IPv6_ip
		$("#d_state_reason").html("");				//state_reason
		$("#d_private_dns_name").html("");			//private_dns_name
		$("#d_availability_zone").html("");			//가용상태
		$("#d_private_ip_address").html("");		//private_ip_address
		$("#d_security_group").html("");			//security_group
		$("#d_vpc_id").html("");					//vpc_id
		$("#d_subnet_id").html("");					//d_subnet_id
		$("#d_network_interfaces").html("");		//network_interfaces
		$("#d_key_name").html("");					//key_name
		$("#d_source_dest_check").html("");			//source_dest_check
		$("#d_productcodeid").html("");				//제품코드
		$("#d_ebs_optimized").html("");				//ebs_optimized
		$("#d_owner").html("");						//owner
		$("#d_root_device_type").html("");			//root_device_type
		$("#d_start_time").html("");				//start_time
		$("#d_root_device_name").html("");			//root_device_name
		$("#d_monitoring").html("");				//monitoring
		$("#d_block_device_name").html("");			//block_device_name
		$("#d_virtualization_type").html("");		//virtualization_type
		$("#d_capacity_reservation_id").html("");	//capacity_reservation_id
		$("#d_reservation_id").html("");			//reservation_id
		$("#d_cct_revt_spect_re_id").html("");		//cct_revt_spect_re_id
		$("#d_ami_launch_index").html("");			//ami_launch_index
		$("#d_tenancy").html("");					//tenancy
		$("#d_image_id").html("");					//image_id
		$("d_hiber_configured").html("");			//hiber_configured
		$("#d_core_count").html("");				//core_count 
	}

	/* ********************************************************
	 * scale ing check
	 ******************************************************** */
	function fn_scaleInOutChk(gbn) {
		var wrk_id_val =  "";
		var defaultCnt = 0;

		if (gbn == 'scaleIn') {
			//scale in 일때 default 만 있는 경우
			if ($(".default_hide").length > 0) {
				$(".default_hide").each(function(){
					if ($(this).val() == 'N') {
						defaultCnt = defaultCnt + 1;
					}
				});
			}
			
			if (defaultCnt <= 0) {
				showSwalIcon('<spring:message code="eXperDB_scale.msg13" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}
		
		$("#mainTableRowCnt", "#frmExecutePopup").val(defaultCnt);

		//scale 이 실행되고 있는 지 체크 후 진행
 		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
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
					wrk_id_val = result.wrk_id;

					if (wrk_id_val == "1") {
						alert("<spring:message code='eXperDB_scale.msg4' />");
						fn_selectScaleAuto();
						return;
					} else {
						fn_scaleInOut(gbn);
					}
				}
			}
		});
		$('#loading').hide();
	}
	
	/* ********************************************************
	 * scale_in_out count pop
	 ******************************************************** */
	function fn_scaleInOut(gbn){
	    $('#title_gbn', '#frmExecutePopup').val(gbn);
	    $('#db_svr_id', '#frmExecutePopup').val('${db_svr_id}');

 		$.ajax({
			url : "/scale/popup/scaleInOutCountForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				title_gbn : gbn
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
				if(result != null){
					//max Node
					$("#exe_title_gbn", "#scaleExecuteForm").val(nvlPrmSet(result.title_gbn, ""));
				} else {
					$("#exe_title_gbn", "#scaleReregForm").val($('#title_gbn', '#frmExecutePopup').val());
				}
				
				$("#exe_scale_count", "#scaleExecuteForm").val("1");
				
				if (gbn == "scaleOut") {
					$("#executeTitle").html("<spring:message code='menu.eXperDB_scale_out_execute' />");
				} else {
					$("#executeTitle").html("<spring:message code='menu.eXperDB_scale_in_execute' />");
				}

				fn_scaleExeSet();

				$('#pop_layer_scale_exe').modal("show");
			}
		});
	}

	/* ********************************************************
	 * scale 실행 result
	 ******************************************************** */
	function fn_scale_status_chk() {
		fn_selectScaleChk("ing");
		setTimeout(fn_selectScaleChk, 3000);
		setTimeout(fn_selectScale, 4000);
		
		statusChk = "scale";
	}
</script>

<%@include file="./experdbScaleInfo.jsp"%>
<%@include file="./../popup/scaleExecuteForm.jsp"%>

<form name="frmExecutePopup" id="frmExecutePopup">
	<input type="hidden" name="title_gbn"  id="title_gbn" />
	<input type="hidden" name="db_svr_id"  id="db_svr_id" />
	<input type="hidden" name="mainTableRowCnt"  id="mainTableRowCnt" />
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
									<div class="col-5" style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-expand"></i>
												<span class="menu-title"><spring:message code="menu.scale_manual"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.eXperDB_scale"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.scale_manual"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_scale"/></p>
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
								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input type="text" class="form-control" maxlength="100" id="search_instance_id" name="search_instance_id" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_scale.instance_id" />'/>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnScaleSearch" onClick="fn_selectScale('serch');" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 stretch-card div-form-margin-table">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">		
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScaleOut" onClick="fn_scaleInOutChk('scaleOut');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="etc.etc39" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnScaleIn" onClick="fn_scaleInOutChk('scaleIn');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="etc.etc38" />
								</button>
							</div>
						</div>
					</div>
				
					<div class="card my-sm-2" >
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

	 								<table id="scaleDataTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="40"><spring:message code="common.no" /></th>
												<th width="130"><spring:message code="eXperDB_scale.name" /></th>
												<th width="120"><spring:message code="eXperDB_scale.instance_id" /></th>
												<th width="80"><spring:message code="eXperDB_scale.instance_type" /></th>
												<th width="100"><spring:message code="eXperDB_scale.availability_zone" /></th>
												<th width="100"><spring:message code="eXperDB_scale.instance_state" /></th>
												<th width="150"><spring:message code="eXperDB_scale.start_time" /></th>
												<th width="80"><spring:message code="eXperDB_scale.IPv4_public_ip" /></th>
												<th width="80"><spring:message code="eXperDB_scale.private_ip_address" /></th>
												<th width="100"><spring:message code="eXperDB_scale.keyname" /></th>
												<th width="120"><spring:message code="eXperDB_scale.security_group" /></th>
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>