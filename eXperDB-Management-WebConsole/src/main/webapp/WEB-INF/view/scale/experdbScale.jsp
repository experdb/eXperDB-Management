<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
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
<style>
.scaleIng {  display:inline-block; margin:0 2px; height:20px; padding:0 12px; color:red; text-align:left; font-weight: bold; font-size:13px;}

button:disabled,
button[disabled]{
  background-color: #fff;
  color: #324452;
  cursor:wait;
}

.btn input, .btn span, .btn button{
	width:117px;
}

</style>
<script>
	var table = null;
	var popOpen = null;
	var iCount_text = 1;
	var btnText = "";
	var statusChk="";

	$(window.document).ready(function() {
		fn_init();
		var table = $('#scaleDataTable').DataTable();
		$('#select').on( 'keyup', function () {
			 table.search( this.value ).draw();
		});	
		$('.dataTables_filter').hide();

		
		fn_selectScaleInstallChk();
	});
	
	/* ********************************************************
	 * 테이블 setting
	 ******************************************************** */
	function fn_init() {
		table = $('#scaleDataTable').DataTable({
			scrollY : "400px",
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
						if(full.instance_status_name == "pending" || full.instance_status_name == "shutting-down"){
							var html = '<img src="../images/spinner_loading.png" alt="" style="width:50%;position: relative; display: block; margin: 0px auto;"/>  ';
							return html;
						}else{
							var html = full.rownum;
							return html;
						}
						return data;
					},
					className : "dt-center",
					defaultContent : "" 	
				},
				{data : "tagsValue", className : "dt-left", defaultContent : ""},
				{ data : "instance_id", className : "dt-left", defaultContent : ""
					,render: function (data, type, full) {
						  return '<span onClick=javascript:fn_scaleLayer("'+full.instance_id+'"); class="bold" title="'+full.instance_id+'">' + full.instance_id + '</span>';
					}
				}, 
				{ data : "instance_type", className : "dt-left", defaultContent : ""},
				{ data : "availability_zone", className : "dt-left", defaultContent : ""}, 
				{data : "instance_status_name", 
					render: function (data, type, full){
						if(full.instance_status_name == "running"){
							var html = '<img src="../images/ico_agent_1.png" alt="" />  ' + full.instance_status_name;
							return html;
						}else{
							var html = '<img src="../images/ico_agent_2.png" alt="" />  ' + full.instance_status_name;
							return html;
						}
						return data;
					},
					className : "dt-left",
					defaultContent : "" 	
				},
				{ data : "start_time", className : "dt-left", defaultContent : ""}, 
				{ data : "public_IPv4", className : "dt-left", defaultContent : ""},
				{ data : "IPv4_public_ip",  defaultContent : ""
					,render: function (data, type, full) {
						if(full.IPv4_public_ip == null){
							var html = '-';
							return html;
						}
					  return data;
				}}, 
				{ data : "key_name", className : "dt-left", defaultContent : ""},
				{ data : "monitoring_state", className : "dt-left", defaultContent : ""}, 
				{ data : "security_group", className : "dt-left", defaultContent : ""
					,"render": function (data, type, full) {
						  return '<span onClick=javascript:fn_securityShow("'+full.instance_id+'","'+full.db_svr_id+'"); title="'+full.security_group+'" class="bold">' + full.security_group + '</span>';
					}
				},
			]
		//,'select': {'style': 'multi'}
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '180px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '120px');

	    $(window).trigger('resize');
	}
	
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
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.rows({selected: true}).deselect();
				table.clear().draw();
				if (nvlSet(result.data) != '' && nvlSet(result.data) != '-') {
					table.rows.add(result.data).draw();
				}
				
				fn_selectScaleChk("first");
			}
		});
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
			}
		}); 


		if (gbn == null || gbn == "") {
			$('#loading').hide();
		}
		
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
					alert("<spring:message code='message.msg02' />");
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.rows({selected: true}).deselect();
				table.clear().draw();
				if (nvlSet(result.data) != '' && nvlSet(result.data) != '-') {
					table.rows.add(result.data).draw();
				}
			}
		});
 
		if (gbn == null || gbn == "") {
			$('#loading').hide();
		}
	}

	function fn_selectScaleChk(gbn) {
		//scale 체크 조회
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
	 * scale 상세조회
	 ******************************************************** */
	function fn_scaleLayer(scale_id){
		var root_device = "";
		var security_group = "";
		var msgVale = "";

		$.ajax({
			url : "/scale/selectScaleInfo.do",
			data : {
				scale_id : scale_id,
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert(message_msg02);
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert(message_msg03);
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			success : function(result) {
				if(result.length==0){
					msgVale = "instance";
					alert('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />');
				}else{
					//초기화
					layerReset();

					$("#d_name").html(result[0].tagsValue);												//name
					$("#d_instance_id").html(result[0].instance_id);									//instance_id
					$("#d_instance_status_name").html(result[0].instance_status_name);					//instance_status_name
					$("#d_public_IPv4").html(nvlSet(result[0].public_IPv4));							//public_IPv4
					$("#d_IPv4_public_ip").html(nvlSet(result[0].IPv4_public_ip));						//IPv4_public_ip
					$("#d_instance_type").html(nvlSet(result[0].instance_type));						//instance_type
					$("#d_private_dns_name").html(nvlSet(result[0].private_dns_name));					//private_dns_name
					$("#d_availability_zone").html(nvlSet(result[0].availability_zone));				//가용상태
					$("#d_private_ip_address").html(nvlSet(result[0].private_ip_address));				//private_ip_address
					$("#d_security_group").html(nvlSet(result[0].security_group));						//security_group  -- 각각 나누어서 check 되도록
					$("#d_vpc_id").html(nvlSet(result[0].vpc_id));										//vpc_id
					$("#d_state_reason").html(nvlSet(result[0].stateReason_message));					//state_reason
					$("#d_subnet_id").html(nvlSet(result[0].subnet_id));								//d_subnet_id
					$("#d_IPv6_ip").html(nvlSet(result[0].IPv6_ip));									//IPv6_ip
					$("#d_network_interfaces").html(nvlSet(result[0].network_interfaces));				//network_interfaces

					//source_dest_check
					var source_dest_check_val = nvlSet(result[0].source_dest_check);
					if (source_dest_check_val != "-") {
						if (source_dest_check_val == "false") {
							source_dest_check_val = "<spring:message code='agent_monitoring.no' />";
						} else {
							source_dest_check_val = "<spring:message code='agent_monitoring.yes' />";
						}
					}
					$("#d_source_dest_check").html(source_dest_check_val);
					
					$("#d_productcodeid").html(nvlSet(result[0].productcodeid));						//제품코드
					
					//ebs_optimized
					if (result[0].ebs_optimized != null && result[0].ebs_optimized == "false") {
						$("#d_ebs_optimized").html("<spring:message code='agent_monitoring.no' />");
					} else {
						$("#d_ebs_optimized").html("<spring:message code='agent_monitoring.yes' />");
					}

					$("#d_key_name").html(nvlSet(result[0].key_name));									//key_name
					$("#d_owner").html(nvlSet(result[0].owner));										//owner
					$("#d_root_device_type").html(nvlSet(result[0].root_device_type));					//root_device_type
					$("#d_start_time").html(nvlSet(result[0].start_time));								//start_time
					$("#d_root_device_name").html(nvlSet(result[0].root_device_name));					//root_device_name
					$("#d_block_device_name").html(nvlSet(result[0].block_device_name));				//block_device_name
					$("#d_monitoring").html(nvlSet(result[0].monitoring_state));						//monitoring
					$("#d_virtualization_type").html(nvlSet(result[0].virtualization_type));			//virtualization_type
					$("#d_capacity_reservation_id").html(nvlSet(result[0].capacity_reservation_id));	//capacity_reservation_id
					$("#d_cct_revt_spect_re_id").html(nvlSet(result[0].cct_revt_spect_re_id));			//cct_revt_spect_re_id
					$("#d_reservation_id").html(nvlSet(result[0].reservation_id));						//reservation_id
					$("#d_ami_launch_index").html(nvlSet(result[0].ami_launch_index));					//ami_launch_index
					$("#d_tenancy").html(nvlSet(result[0].tenancy));									//tenancy
					$("#d_image_id").html(nvlSet(result[0].image_id));									//image_id
					
					//hiber_configured
					if (result[0].hiber_configured != null && result[0].hiber_configured == "true") {
						$("#d_hiber_configured").html("<spring:message code='etc.etc40' />");
					} else {
						$("#d_hiber_configured").html("<spring:message code='etc.etc41' />");
					}

					$("#d_core_count").html(nvlSet(result[0].core_count));								//core_count

					toggleLayer($('#pop_layer'), 'on');
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
		$("#d_instance_status_name").html("");		//instance_status_name
		$("#d_public_IPv4").html("");				//public_IPv4
		$("#d_IPv4_public_ip").html("");			//IPv4_public_ip
		$("#d_instance_type").html("");				//instance_type
		$("#d_private_dns_name").html("");			//private_dns_name
		$("#d_private_ip_address").html("");		//private_ip_address
		$("#d_availability_zone").html("");			//가용상태
		$("#d_security_group").html("");			//security_group
		$("#d_vpc_id").html("");					//vpc_id
		$("#d_subnet_id").html("");					//d_subnet_id
		$("#d_IPv6_ip").html("");					//IPv6_ip
		$("#d_network_interfaces").html("");		//network_interfaces
		$("#d_source_dest_check").html("");			//source_dest_check
		$("#d_productcodeid").html("");				//제품코드
		$("#d_ebs_optimized").html("");				//ebs_optimized
		$("#d_owner").html("");						//owner
		$("#d_root_device_type").html("");			//root_device_type
		$("#d_start_time").html("");				//start_time
		$("#d_key_name").html("");					//key_name
		$("#d_root_device_name").html("");			//root_device_name
		$("#d_block_device_name").html("");			//block_device_name
		$("#d_virtualization_type").html("");		//virtualization_type
		$("#d_capacity_reservation_id").html("");	//capacity_reservation_id
		$("#d_cct_revt_spect_re_id").html("");		//cct_revt_spect_re_id
		$("#d_reservation_id").html("");			//reservation_id
		$("#d_ami_launch_index").html("");			//ami_launch_index
		$("#d_tenancy").html("");					//tenancy
		$("#d_image_id").html("");					//image_id
		$("d_hiber_configured").html("");			//hiber_configured
		$("#d_core_count").html("");				//core_count
	}

	/* ********************************************************
	 * 보안그룹 상세조회
	 ******************************************************** */
	function fn_securityShow(instance_id, db_svr_id){
	    var url = '/scale/securityGroupShowView.do';
	    popOpen = window.open('','popupView','width=600, height=505');

	    $('#scale_id', '#frmSecurityPopup').val(instance_id);
	    $('#db_svr_id', '#frmSecurityPopup').val('${db_svr_id}');

	    $('#frmSecurityPopup').attr("action", url);
	    $('#frmSecurityPopup').attr("target", "popupView");

	    $('#frmSecurityPopup').submit();
	    
	    popOpen.focus();
	}
	
	/* ********************************************************
	 * scale_in_out count pop
	 ******************************************************** */
	function fn_scaleInOut(gbn){
	    var popUrl = '/scale/popup/scaleInOutCountForm.do';
		var width = 500;
		var height = 286;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no";

	    popOpen = window.open("","popupView",popOption);

	    $('#title_gbn', '#frmExecutePopup').val(gbn);
	    $('#db_svr_id', '#frmExecutePopup').val('${db_svr_id}');

	    $('#frmExecutePopup').attr("action", popUrl);
	    $('#frmExecutePopup').attr("target", "popupView");

	    $('#frmExecutePopup').submit();	
	}

	/* ********************************************************
	 * null체크
	 ******************************************************** */
	function nvlSet(val) {
		var strValue = val;
		if( strValue == null || strValue == '') {
			strValue = "-";
		}
		
		return strValue;
	}
	
	/* ********************************************************
	 * button 제어
	 ******************************************************** */
	function fn_buttonAut(wrk_id, scale_set){
		var strMsg = "";
 		if(wrk_id == "1"){
			if (scale_set == "1") {
				strMsg = '<spring:message code="etc.etc38" />' + ' ' + '<spring:message code="restore.progress" />';
				$("#btnScaleIn").html(strMsg);
			} else {
				strMsg = '<spring:message code="etc.etc39" />' + ' ' + '<spring:message code="restore.progress" />';
				$("#btnScaleOut").html(strMsg);
			}
			
			$("#btnScaleIn").prop("disabled", "disabled");
			$("#btnScaleOut").prop("disabled", "disabled");
		}else{
			$("#btnScaleIn").html('<spring:message code="etc.etc38" />');
			$("#btnScaleOut").html('<spring:message code="etc.etc39" />');
			
			$("#btnScaleIn").prop("disabled", "");
			$("#btnScaleOut").prop("disabled", "");
		} 
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
	
	/* ********************************************************
	 * aws 서버 확인
	 ******************************************************** */
	function fn_selectScaleInstallChk() {
		//scale 체크 조회
		var install_yn = "";

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
					$("#scaleIngMsg").hide();
					
					fn_selectScaleAuto();
				} else {
					$("#scaleIngMsg").show();

					//설치안된경우 버튼 막아야함
					$("#btnScaleIn").prop("disabled", "disabled");
					$("#btnScaleOut").prop("disabled", "disabled");
					$("#btnScaleSearch").prop("disabled", "disabled");
					$("#search_instance_id").prop("disabled", "disabled");
				}
			}
		});
		$('#loading').hide();
	}
</script>

<%@include file="./experdbScaleInfo.jsp"%>

<form name="frmSecurityPopup" id="frmSecurityPopup">
	<input type="hidden" name="scale_id"  id="scale_id" />
	<input type="hidden" name="db_svr_id"  id="db_svr_id" />
</form>

<form name="frmExecutePopup" id="frmExecutePopup">
	<input type="hidden" name="title_gbn"  id="title_gbn" />
	<input type="hidden" name="db_svr_id"  id="db_svr_id" />
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.scale_manual" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>

			<div class="infobox">
				<ul><li><spring:message code="help.eXperDB_scale" /></li></ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.eXperDB_scale" /></li>
					<li class="on"><spring:message code="menu.scale_manual" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="scaleIng" id="scaleIngMsg" style="display:none;">* <spring:message code="eXperDB_scale.msg10" /></span>
				
					<span class="btn"><button type="button" id="btnScaleSearch" onclick="fn_selectScale('serch')"><spring:message code="common.search" /></button></span>
					<span class="btn"><button type="button" id="btnScaleIn" onclick="fn_scaleInOut('scaleIn')" ><spring:message code="etc.etc38" /></button></span>
					<span class="btn"><button type="button" id="btnScaleOut" onclick="fn_scaleInOut('scaleOut')"><spring:message code="etc.etc39" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 450px;" />
							<col style="width: 100px;" />
						</colgroup> 
						<tbody>
								<tr>
									<th scope="row" class="t9 line" style="width:130px;"><spring:message code="eXperDB_scale.instance_id" /></th>
									<td><input type="text" class="txt t2" id="search_instance_id" name="search_instance_id" maxlength="100" onkeyup="fn_checkWord(this,100)" style="width:200px;"/></td>
								</tr>
						</tbody>
					</table>
				</div>
				
				<div class="overflow_area">
					<table id="scaleDataTable" class="display" cellspacing="0" style="width:100%">
						<thead>
							<tr>
								<th width="40" height="0"><spring:message code="common.no" /></th>
								<th width="130"><spring:message code="eXperDB_scale.name" /></th>
								<th width="120"><spring:message code="eXperDB_scale.instance_id" /></th>
								<th width="80"><spring:message code="eXperDB_scale.instance_type" /></th>
								<th width="100"><spring:message code="eXperDB_scale.availability_zone" /></th>
								<th width="100"><spring:message code="eXperDB_scale.instance_state" /></th>
								<th width="150"><spring:message code="eXperDB_scale.start_time" /></th>
								<th width="180"><spring:message code="eXperDB_scale.public_IPv4" /></th>
								<th width="80"><spring:message code="eXperDB_scale.IPv4_public_ip" /></th>
								<th width="100"><spring:message code="eXperDB_scale.keyname" /></th>
								<th width="60"><spring:message code="eXperDB_scale.monitoring" /></th>
								<th width="120"><spring:message code="eXperDB_scale.security_group" /></th>							
							</tr>
						</thead>
					</table>
					
				</div>
			</div>
		</div>
	</div>
</div>