<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : experdbProxyMon.jsp
	* @Description : experdbProxy Monitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*
	*/
%>
<script>

	var proxyLogTable = "";
	var proxyStatTable = "";
	
	$(window).ready(function(){
		//서버정보 리스트 setting
		fn_serverListSetting();	
		// 프록시 모니터링 setting
		fn_proxyMonInfo();
		// 프록시 연결 db 모니터링 setting
		fn_dbMonInfo();
		// 프록시 log 테이블
		fn_proxy_log_init();
		// 프록시 리스너 통계 테이블
		fn_proxy_stat_init();
	});
	
	/* ********************************************************
	 * 프록시 기동 상태 로그 셋팅
	 ******************************************************** */
	function fn_proxy_log_init(){
		proxyLogTable = $('#proxyLog').DataTable({			
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : "데이터가 없습니다."
			},
			columns : [
				{data : "rownum", className : "dt-center", defaultContent : "", targets : 0, visible:false, orderable : false},
				{data : "pry_svr_id", className : "dt-center", defaultContent : "", visible: false},
				{data : "pry_svr_nm", 
					render : function(data, type, full, meta) {
						var html = "";
						html += '<a href="#">'+data+'</a>';
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "sys_type", 
					render : function(data, type, full, meta) {
						var html = "";
						if(data.sys_type == "proxy"){
							html += '<spring:message code="menu.proxy"/>';
						} else if(data.sys_type == "keepalived"){
							html += '<spring:message code="eXperDB_proxy.keepalived"/>';
						}
						return html;
					},	
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "act_type", 
					render : function(data, type, full, meta){
						var html = "";
						if(data.act_type == 'A'){
							html += '<div class="badge badge-pill badge-success">';
							html += '	<i class="fa fa-circle-o-notch fa-spin mr-2"></i>';
							html += '	start';
							html += '</div>';
						} else if(data.act_type == 'R') {
							html += '<div class="badge badge-pill badge-info">';
							html += '	<i class="fa fa-circle-o-notch fa-spin mr-2"></i>';
							html += '	restart';
							html += '</div>';
						} else if(data.act_type == 'S'){
							html += '<div class="badge badge-pill badge-danger">';
							html += '	<i class="fa fa-circle-o-notch mr-2"></i>';
							html += '	stop';
							html += '</div>';
						}
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "wrk_dtm", className : "dt-center", defaultContent : ""}
			]
		});

		proxyLogTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); //rownum
		proxyLogTable.tables().header().to$().find('th:eq(1)').css('min-width', '0px'); //proxy server id
		proxyLogTable.tables().header().to$().find('th:eq(2)').css('min-width', '50px'); // proxy server name
		proxyLogTable.tables().header().to$().find('th:eq(3)').css('min-width', '50px'); // proxy or keepavlied
		proxyLogTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px'); // start or restart or stop
		proxyLogTable.tables().header().to$().find('th:eq(5)').css('min-width', '50px'); // first reg date
	}



	/* ********************************************************
	 * 서버 리스트 셋팅
	 ******************************************************** */
	function fn_serverListSetting(){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		
		var proxyServerTotInfo_cnt = "${fn:length(proxyServerTotInfo)}";

		if (proxyServerTotInfo_cnt == 0) {
			html += "<div class='col-md-12 grid-margin stretch-card'>\n";
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
			html += '</div>\n';
		} else {
			<c:forEach items="${proxyServerTotInfo}" var="serverinfo" varStatus="status">
				master_gbn = nvlPrmSet("${serverinfo.master_gbn}", "");
				rowCount = rowCount + 1;
				listCnt = parseInt("${fn:length(proxyServerTotInfo)}");

				pry_svr_id_val = nvlPrmSet("${serverinfo.pry_svr_id}", '');
	 			if (pry_svr_id == "") {
					html += '<div class="col-md-12 grid-margin stretch-card">\n';
					html += '	<div class="card news_text">\n';
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_proxyMonInfo(' + pry_svr_id_val + ', '+ rowCount +')" style="cursor:pointer;">\n';
					html += '			<div class="row">\n';
				} else if(pry_svr_id != nvlPrmSet("${serverinfo.pry_svr_id}", '')  && master_gbn == "M") {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto;">\n';
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" id="iProxy' + pry_svr_id_val + '" style="font-size: 3.0em;"></i>\n';
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
					html += "<div class='col-md-12 grid-margin stretch-card'>\n";
					html += "	<div class='card news_text'>\n";
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_proxyMonInfo('+ pry_svr_id_val +', '+ rowCount +')" style="cursor:pointer;">\n';
					html += '			<div class="row">\n';
				}
	 			
	 			if(master_gbn == "M") {
					html += '			<div class="col-sm-9">';
	 				html += '				<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
	 				html += '					<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
	 				if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
					} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') { // TC001501
	 	 				html += '					<div class="badge badge-pill badge-success" title="">M</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') { // TC001502
	 	 				html += '					<div class="badge badge-pill badge-danger">M</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<c:out value="${serverinfo.pry_svr_nm}"/><br/></h5>\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
	 				html += '					(<c:out value="${serverinfo.ipadr}"/>)</h6>\n';
	 			}

				if (master_gbn == "B") {
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;padding-top:10px;">\n';
					if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') {
	 	 				html += '					<div class="badge badge-pill badge-success">B</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') {
	 	 				html += '					<div class="badge badge-pill badge-danger">B</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<c:out value="${serverinfo.pry_svr_nm}"/><br/></h6>';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:64px;">';
	 				html += '					(<c:out value="${serverinfo.ipadr}"/>)</h6>';
	 			}

				if (rowCount == listCnt) {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto;">\n';
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
				}

				pry_svr_id = nvlPrmSet("${serverinfo.pry_svr_id}", '') ;

			</c:forEach>
		}

		$("#serverTabList").html(html);
		$("#serverSsCnt", "#proxyMonViewForm").val(proxyServerTotInfo_cnt);
		$("#proxy_master_nm").text("${proxyServerTotInfo[0].pry_svr_nm}").val();
		if (proxyServerTotInfo_cnt > 0) {
			$("#serverSs1").click();
		}
	}

	/* ********************************************************
	* 프록시 서버 모니터링 셋팅
	******************************************************** */

	function fn_proxyMonInfo(){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";

		var proxyServerByMasId_cnt = "${fn:length(proxyServerByMasId)}";

		if (proxyServerByMasId_cnt == 0) {
			html += "<div class='col-md-12 grid-margin stretch-card'>\n";
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
			html += '</div>\n';
		} else {
			<c:forEach items="${proxyServerByMasId}" var="proxyinfo" varStatus="status">
				master_gbn = nvlPrmSet("${proxyinfo.master_gbn}", "");
				rowCount = rowCount + 1;
				listCnt = parseInt("${fn:length(proxyServerByMasId)}");

				pry_svr_id_val = nvlPrmSet("${proxyinfo.pry_svr_id}", '');
				html += '								<table class="table-borderless">\n';
				html += '									<tr>\n'
				html += '										<td colspan="2">\n';
				html += '											<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">\n';
				if(master_gbn == "M") {
					if(nvlPrmSet("${proxyinfo.agt_cndt_cd}", '') == 'TC001101'){
						html += '												<div class="badge badge-pill badge-success" title="">M</div>\n';
					} else {
						html += '												<div class="badge badge-pill badge-danger" title="">M</div>\n';
					}
				} else if(master_gbn == "B"){
					if(nvlPrmSet("${proxyinfo.agt_cndt_cd}", '') == 'TC001101'){
						html += '												<div class="badge badge-pill badge-success">B</div>\n'
					} else {
						html += '												<div class="badge badge-pill badge-danger">B</div>\n'
					}
				}
				html += '												${proxyinfo.pry_svr_nm}\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '										<td rowspan="4">\n';
				if(nvlPrmSet("${proxyinfo.agt_cndt_cd}", '') == 'TC001101'){
					html += '											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i>\n';
				} else if(nvlPrmSet("${proxyinfo.agt_cndt_cd}", '') == 'TC001102'){
					html += '											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db" style="font-size: 3em;"></i>\n'
				}
				html += '											<h6 class="text-muted">agent</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				html += '												VIP : ${proxyinfo.v_ip}\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				if(master_gbn == "M"){
					html += '												PORT : 5430\n';
				} else if(master_gbn == "B"){
					html += '												PORT : 5431\n';
				}
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				html += '												IP : ${proxyinfo.ipadr}\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td class="text-center">\n';
				html += '											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info blink_db" style="font-size: 2em;"></i>\n';
				html += '											<h6 class="text-muted"><a href="#" onclick="fn_configView(${proxyinfo.pry_svr_id}, \'P\')">Proxy</a></h6>\n';
				html += '										</td>\n';
				html += '										<td class="text-center">\n';
				html += '											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info blink_db text-center" style="font-size: 2em;"></i>\n';
				html += '											<h6 class="text-muted"><a href="#" onclick="fn_configView(${proxyinfo.pry_svr_id}, \'K\')">Keepalived</a></h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '								</table>\n';
		
				pry_svr_id = nvlPrmSet("${proxyinfo.pry_svr_id}", '') ; 
			
			</c:forEach>
		}
		
		$("#proxyMonitoringList").html(html);
	}

	/* ********************************************************
	* 디비 서버 모니터링 셋팅
	******************************************************** */
	function fn_dbMonInfo(){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";

		

		// $("#dbMonitoringList").html(html);
	}
	
	/* ********************************************************
	 * 리스너 통계 테이블 셋팅
	 ******************************************************** */
	function fn_proxy_stat_init(){
		proxyStatTable = $('#proxyStat').DataTable({
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : "데이터가 없습니다."
			},
			columns : [
				{data : "rownum", className : "dt-center", visible : false},
				{data : "pry_svr_id", className : "dt-center", visible : false},
				{data : "pry_svr_nm", className : "dt-center"},
				{data : "lsn_nm", className : "dt-center"},
				{data : "db_con_addr", className : "dt-center"},
				{data : "svr_status", className : "dt-center"},
				{data : "lst_status_chk_desc", className : "dt-center"},
				{data : "fail_chk_cnt", className : "dt-center"},
				{data : "max_session", className : "dt-center"},
				{data : "session_limit", className : "dt-center"},
				{data : "cumt_sso_con_cnt", className : "dt-center"},
				{data : "byte_receive", className : "dt-center"},
				{data : "byte_transmit", className : "dt-center"}
			],
		});

		proxyStatTable.tables().header().to$().find('th:eq(0)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(1)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(2)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(3)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(4)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(5)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(6)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(7)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(8)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(9)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(10)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(11)').css('min-width');
		proxyStatTable.tables().header().to$().find('th:eq(12)').css('min-width');
	}
	
	function fn_lsnStat(){
		$.ajax({
			url : "/listenerstatistics.do", 
			data : {
				pry_svr_id : $("#db_svr_id", "#findList").val(),
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst(message_msg02, closeBtn, '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst(message_msg03, closeBtn, '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				proxyStatTable.rows({selected: true}).deselect();
				proxyStatTable.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					proxyStatTable.rows.add(result).draw();
				}

		  		var tableRows = $('#proxyStatTable tbody tr');
		 		console.log("cells===1111=" + tableRows.length);
		  		if (tableRows.length > 1) {
			  		$('#proxyStatTable').rowspan(0); 
			  		$('#proxyStatTable').rowspan(1); 
			  		// $('#transTargetSettingTable').rowspan(5); 
/*			  console.log("cells===444=");
			  $.each(tableRows, function (index, value) {
console.log("====value===" + $(value).data());
				  
				//  var cells = $(value).find('kc_ip');
				//  console.log("cells555====" + cells);
				  
				//  $(cells[1]).remove();
				//  $(cells[0]).attr('colspan','2');
				  
			  });*/
		  		}
			}
		});
	}


	/* ********************************************************
	 * config 파일 view popup
	 ******************************************************** */
	function fn_configView(pry_svr_id, type){
		console.log(pry_svr_id, type);
		$.ajax({
			url : '/proxyMonitoring/configView.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
				type : type
			},
			success : function(result) {
				// if (result == "true") {
				// 	$("#ins_idCheck", "#insProxyListenForm").val("1");
					
				// 	//$("#idCheck_alert-danger", "#insProxyListenForm").show();
				// } else {
				// 	showSwalIcon('<spring:message code="message.msg123" />', '<spring:message code="common.close" />', '', 'error');
				// 	$("#ins_idCheck", "#insProxyListenForm").val("0");
					
				// 	//$("#idCheck_alert-danger", "#insProxyListenForm").hide();
				// }
// 				fn_configView(pry_svr_id, type);
				$('#pop_layer_config_view').modal("show");
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insProxyListenForm").val("0");
				
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}

	/* ********************************************************
	 * rowspan
	 ******************************************************** */
	$.fn.rowspan = function(colIdx, isStats){
		return this.each(function(){      
		    var that;     
		    $('tr', this).each(function(row) {      
		        $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
		        	console.log("==$(this).html()===" + $(this).html());
		            console.log("==$(that).html()===" + $(that).html());
		            if ($(this).html() == $(that).html() && (!isStats || isStats && $(this).prev().html() == $(that).prev().html())) {            
		                rowspan = $(that).attr("rowspan") || 1;
		                rowspan = Number(rowspan)+1;
		 
		                $(that).attr("rowspan",rowspan);
		                    
		                // do your action for the colspan cell here            
		                $(this).hide();
		                    
		                //$(this).remove(); 
		                // do your action for the old cell here
		                    
		            } else {            
		                that = this;         
		            }          
		                
		            // set the that if not already set
		            that = (that == null) ? this : that;      
		        });     
		    });    
		});
	}
	
</script>
<%@include file="./../popup/proxyLogView.jsp"%>
<%@include file="./../popup/proxyConfigViewPop.jsp"%>

<form name="proxyMonViewForm" id="proxyMonViewForm">
	<input type="hidden" name="serverSsCnt"  id="serverSsCnt" />
</form>
<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">

	<!-- 서버 모니터링 -->
	<div class="row">
		<div class="col-12 div-form-margin-srn stretch-card">
			<div class="card">
				<div class="card-body">

					<!-- title start -->
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom: 0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row">
									<div class="col-5" style="padding-top: 3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')"> 
											<i class="mdi mdi-server"></i> 
											<span class="menu-title"><spring:message code="menu.proxy_monitoring"/></span> 
											<i class="menu-arrow_user" id="titleText"></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
										<ol class="mb-0 breadcrumb_main justify-content-end bg-info">
											<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
												<a class="nav-link_title" href="/proxyMonitor.do" style="padding-right: 0rem;">vip_master_proxy</a>
											</li>
											<li class="breadcrumb-item_main active"	style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_monitoring"/></li>
											<li class="breadcrumb-item_main active"	style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy"/></li>
										</ol>
									</div>
								</div>
							</div>

							<div id="page_header_sub" class="collapse" role="tabpanel"	aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.proxy_monitoring_01" /></p>
											<p class="mb-0"><spring:message code="help.proxy_monitoring_02" /></p>
											<p class="mb-0"><spring:message code="help.proxy_monitoring_03" /></p>
											<p class="mb-0"><spring:message code="help.proxy_monitoring_04" /></p>
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
		
		<!-- 서버 리스트 -->
		<div class="col-3">
			<div class="card">
				<div class="card-body" style="padding:10px;">
					<div class="col-12">

						<!-- 서버정보 title -->
						<div class="row" style="height:100%">
							<div class="accordion_main accordion-multi-colored col-12"	id="accordion" role="tablist" style="margin-bottom: 10px;">
								<div class="card" style="margin-bottom: 0px;">
									<div class="card-header" role="tab" id="page_header_div">
										<div class="row" style="height: 15px;">
											<div class="col-12">
												<h6 class="mb-0">
													<i class="mdi mdi-server menu-icon"></i><span class="menu-title"><spring:message code="eXperDB_proxy.server_information"/></span>
<!-- 													<i class="mdi mdi-server menu-icon"></i><span class="menu-title">Proxy 서버정보</span> -->
												</h6>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<!-- 서버목록 -->
						<div class="row" id="serverTabList"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 서버 리스트 end-->
		
		<!-- 모니터링 -->
		<div class="col-9">
			<div class="card">
				<div class="card-body">
				
				<!-- Proxy 서버 이름 -->
					<div class="accordion_main accordion-multi-colored col-12"	id="accordion" role="tablist" style="margin-bottom: 10px;">
						<div class="card" style="margin-bottom: 0px;">
							<div class="card-header" role="tab" id="page_header_div">
								<div class="row" style="height: 15px;">
									<div class="col-12">
										<h6 class="mb-0">
											<i class="mdi mdi-server menu-icon"></i><span class="menu-title" id="proxy_master_nm"></span>
										</h6>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col-md-12" style="margin-top: -2px; min-height: 80px;">
							<h3 class="card-title" style="margin-bottom: 10px; text-transform: none; font-size:1rem;">
								<i class="item-icon mdi mdi-server"></i><span class="text-info" id="proxy_master_nm"></span>
							</h3>
						</div>
					</div>
				
					
					<!-- 모니터링 세부 title -->
					<div class="row" style="margin-left:10px;">
						<div class="col-md-4" style="margin-top: -2px; min-height: 80px;">
							<h4 class="card-title" style="margin-bottom: 10px; text-transform: none;">
								<i class="item-icon fa fa-dot-circle-o"></i><span class="text-info"> <spring:message code="eXperDB_proxy.server"/> </span>
							</h4>
						</div>
						<div class="col-md-3" style="margin-top: -2px; min-height: 80px;">
							<h4 class="card-title" style="margin-bottom: 10px; text-transform: none;">
								<i class="item-icon fa fa-dot-circle-o"></i><span class="text-info"> DB 서버 </span>
							</h4>
						</div>
						<div class="col-md-4" style="margin-top: -2px; min-height: 80px;">
							<h4 class="card-title" style="margin-bottom: 10px; text-transform: none;">
								<i class="item-icon fa fa-dot-circle-o"></i><span class="text-info"> <spring:message code="eXperDB_proxy.server_logging"/> </span>
							</h4>
						</div>
					</div>
					
					<!-- 모니터링 content -->
					<div class="row">
						
						<!-- Proxy 서버 -->
						<div class="col-md-4" style="margin-left:10px; margin-top: -50px;">
							<div class="card" id="proxyMonitoringList">
<!-- 								<table class="table-borderless">  -->
<!-- 									<tr> -->
<!-- 										<td colspan="2"> -->
<!-- 											<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"> -->
<!-- 												<div class="badge badge-pill badge-success" title="">M</div> -->
<!-- 												vip_master -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td rowspan="4"> -->
<!-- 											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i><br> -->
<!-- 											<h6 class="text-muted">agent</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												VIP : 192.168.50.115 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												PORT : 5430 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												IP : 192.168.50.110 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td class="text-center"> -->
<!-- 											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info blink_db" style="font-size: 2em;"></i><br> -->
<!-- 											<h6 class="text-muted">Proxy</h6> -->
<!-- 										</td> -->
<!-- 										<td class="text-center"> -->
<!-- 											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info blink_db text-center" style="font-size: 2em;"></i><br> -->
<!-- 											<h6 class="text-muted">Keepalived</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</table> -->
<!-- 								<table class="table-borderless" style="margin-left:40px;">  -->
<!-- 									<tr> -->
<!-- 										<td colspan="2"> -->
<!-- 											<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"> -->
<!-- 												<div class="badge badge-pill badge-success" title="">B</div> -->
<!-- 												vip_backup -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td rowspan="4"> -->
<!-- 											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i><br> -->
<!-- 											<h6 class="text-muted">agent</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												VIP : 192.168.50.116 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												PORT : 5431 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												IP : 192.168.50.111 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td class="text-center"> -->
<!-- 											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info blink_db" style="font-size: 2em;"></i><br> -->
<!-- 											<h6 class="text-muted">Proxy</h6> -->
<!-- 										</td> -->
<!-- 										<td class="text-center"> -->
<!-- 											<i class="fa fa-times-circle icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db text-center" style="font-size: 2em;"></i><br> -->
<!-- 											<h6 class="text-muted">Keepalived</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</table> -->
							</div>
						</div>
						<!-- Proxy 서버 end -->
						
						<!-- DB 서버 -->
						<div class="col-md-3" style="margin-left:10px; margin-top: -50px;">
							<div class="card" id="dbMonitoringList">
								<c:forEach items="${dbServerConProxy}" var="dbinfo" varStatus="status">
									<table class="table-borderless">
										<tr>
											<td colspan="2">
												<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">
													<c:choose>
														<c:when test="${dbinfo.agt_cndt_cd eq 'TC001101'}">
															<div class="badge badge-pill badge-success" title="">${dbinfo.master_gbn}</div>
														</c:when>
														<c:otherwise>
															<div class="badge badge-pill badge-danger" title="">${dbinfo.master_gbn}</div>
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${dbinfo.master_gbn eq 'M'}">
															master
														</c:when>
														<c:otherwise>
															standby
														</c:otherwise>
													</c:choose>
													
													
<%-- 													<c:choose> --%>
<%-- 														<c:when test="${dbinfo.master_gbn} eq 'M'"> --%>
<%-- 															<c:choose> --%>
<%-- 																<c:when test="${dbinfo.agt_cndt_cd} eq 'TC001101'"> --%>
<!-- 																	<div class="badge badge-pill badge-success" title="">M</div> -->
<%-- 																</c:when> --%>
<%-- 																<c:otherwise> --%>
<!-- 																	<div class="badge badge-pill badge-danger" title="">M</div> -->
<%-- 																</c:otherwise> --%>
<%-- 															</c:choose> --%>
<!-- 															master -->
<%-- 														</c:when> --%>
<%-- 														<c:otherwise> --%>
<%-- 															<c:choose> --%>
<%-- 																<c:when test="${dbinfo.agt_cndt_cd} eq 'TC001101'"> --%>
<!-- 																	<div class="badge badge-pill badge-success" title="">S</div> -->
<%-- 																</c:when> --%>
<%-- 																<c:otherwise> --%>
<!-- 																	<div class="badge badge-pill badge-danger" title="">S</div> -->
<%-- 																</c:otherwise> --%>
<%-- 															</c:choose> --%>
<!-- 															standby -->
<%-- 														</c:otherwise> --%>
<%-- 													</c:choose>  --%>
												</h6>
											</td>
											<td rowspan="2">
												<c:choose>
														<c:when test="${dbinfo.agt_cndt_cd eq 'TC001101'}">
															<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i><br>
														</c:when>
														<c:otherwise>
															<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db" style="font-size: 3em;"></i><br>
														</c:otherwise>
												</c:choose>
												<h6 class="text-muted"><spring:message code="eXperDB_proxy.agent"/></h6>
											</td>
										</tr>
										<tr>
											<td>
												<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">
													IP : ${dbinfo.ipadr} 	
												</h6>
											</td>
											<td>
												<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">
													PORT : ${dbinfo.portno}
												</h6>
											</td>
										</tr>
									</table>
								</c:forEach>
<!-- 								<table class="table-borderless" style="margin-left:30px;"> -->
<!-- 									<tr> -->
<!-- 										<td colspan="2"> -->
<!-- 											<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info"> -->
<!-- 												<div class="badge badge-pill badge-success" title="">S</div> -->
<!-- 												standby -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td rowspan="2"> -->
<!-- 											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i><br> -->
<!-- 											<h6 class="text-muted">agent</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												IP : 192.168.50.114 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted"> -->
<!-- 												PORT : 5432 -->
<!-- 											</h6> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</table> -->
							</div>
						</div>
						<!-- DB 서버 end -->
						
						<!-- Proxy 서버 기록 -->
						<div class="col-md-4" style="margin-left:10px; margin-top:-50px;">
							<table id="proxyLog" class="table table-bordered system-tlb-scroll" style="width:100%;"> 
								<thead>
									<tr class="bg-info text-white">
										<th>rownum</th>
										<th>proxy_id</th>
										<th><spring:message code="data_transfer.server_name"/></th>
										<th>데몬</th>
										<th><spring:message code="common.status"/></th>
										<th><spring:message code="history_management.time"/></th>
									</tr>
								</thead>
<!-- 								<tbody> -->
<!-- 									<tr> -->
<!-- 										<td>vip_master</td> -->
<%-- 										<td><a href="#"><spring:message code="menu.proxy"/></a></td> --%>
<!-- 										<td> -->
<!-- 											<div class="badge badge-pill badge-success"> -->
<!-- 											<i class="fa fa-circle-o-notch fa-spin mr-2"></i> -->
<!-- 												start -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td>2021-02-26 17:15:40</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td>vip_master</td> -->
<!-- 										<td><a href="#">proxy</a></td> -->
<!-- 										<td> -->
<!-- 											<div class="badge badge-pill badge-danger"> -->
<!-- 											<i class="fa fa-circle-o-notch mr-2"></i> -->
<!-- 												stop -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td>2021-02-26 15:05:59</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
							</table>
						</div>
						
					</div>
					
				</div>
			</div>
		</div>
		
	</div>
	<!-- 서버 모니터링 end-->
	
	
	<!-- Proxy stat -->
	<div class="row">
		<div class="col-md-12 grid-margin stretch-card" style="margin-top:10px;">
			<div class="card">
				<div class="card-body">	
					
					<!-- 리스너 정보 title -->
					<div class="row">
						<div class="accordion_main accordion-multi-colored col-12"	id="accordion" role="tablist" style="margin-bottom: 10px;">
							<div class="card" style="margin-bottom: 0px;">
								<div class="card-header" role="tab" id="page_header_div">
									<div class="row" style="height: 15px;">
										<div class="col-12">
											<h6 class="mb-0">
												<i class="fa fa-bar-chart-o menu-icon"></i> <span class="menu-title">리스너 정보</span>
											</h6>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 리스너 정보 title end-->
					
					<!-- 리스너 stat chart -->
					<div class="row">
						<div class="col-lg-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-md-12" style="margin-top: -2px; min-height: 80px;">
											<h6 class="card-title" style="margin-bottom: 10px; text-transform: none;">
											<i class="item-icon mdi mdi-chart-bar"></i><span class="text-muted"> 리스너 통계</span>
											</h6>
										</div>
									</div>
									
									<div class="row">
										<div class="col-md-12 col-xl-12 d-flex flex-column justify-content-center">
												<!-- 스케줄이력 chart -->
												<div class="table-responsive mb-3 mb-md-0">
													<table id="scheduleHistChart" class="table table-borderless" style="position: relative; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);">
														<canvas id="scriptHistChart" style="height:27vh; width:15vw;"></canvas>
<!-- 														<svg height="342" version="1.1" width="462" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative; left: -0.796875px; top: -0.0625px;"> -->
<!-- 															<desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Raphaël 2.1.4</desc> -->
<!-- 															<defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></defs> -->
<!-- 															<text x="35.359375" y="301" text-anchor="end" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: end; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0</tspan> -->
<!-- 															</text> -->
<!-- 															<path fill="none" stroke="#aaaaaa" d="M47.859375,301H437" stroke-width="0.5" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path> -->
<!-- 															<text x="35.359375" y="232" text-anchor="end" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: end; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0.25</tspan> -->
<!-- 															</text> -->
<!-- 															<path fill="none" stroke="#aaaaaa" d="M47.859375,232H437" stroke-width="0.5" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path> -->
<!-- 															<text x="35.359375" y="163" text-anchor="end" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: end; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0.5</tspan> -->
<!-- 															</text> -->
<!-- 															<path fill="none" stroke="#aaaaaa" d="M47.859375,163H437" stroke-width="0.5" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path> -->
<!-- 															<text x="35.359375" y="94" text-anchor="end" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: end; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">0.75</tspan> -->
<!-- 															</text> -->
<!-- 															<path fill="none" stroke="#aaaaaa" d="M47.859375,94H437" stroke-width="0.5" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path> -->
<!-- 															<text x="35.359375" y="25" text-anchor="end" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: end; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">1</tspan> -->
<!-- 															</text> -->
<!-- 															<path fill="none" stroke="#aaaaaa" d="M47.859375,25H437" stroke-width="0.5" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path> -->
<!-- 															<text x="339.71484375" y="313.5" text-anchor="middle" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal" transform="matrix(1,0,0,1,0,8)"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">배치</tspan> -->
<!-- 															</text> -->
<!-- 															<text x="145.14453125" y="313.5" text-anchor="middle" font-family="sans-serif" font-size="12px" stroke="none" fill="#888888" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-anchor: middle; font-family: sans-serif; font-size: 12px; font-weight: normal;" font-weight="normal" transform="matrix(1,0,0,1,0,8)"> -->
<!-- 																<tspan dy="4" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">백업</tspan> -->
<!-- 															</text> -->
<!-- 															<rect x="72.1806640625" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#76c1fa" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 															<rect x="121.8232421875" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#63cf72" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 															<rect x="171.4658203125" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#f36368" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 															<rect x="266.7509765625" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#76c1fa" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 															<rect x="316.3935546875" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#63cf72" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 															<rect x="366.0361328125" y="301" width="46.642578125" height="0" rx="0" ry="0" fill="#f36368" stroke="none" fill-opacity="1" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0); fill-opacity: 1;"></rect> -->
<!-- 														</svg> -->
<!-- 														<div class="morris-hover morris-default-style" style="left: 118.418px; top: 126px;"> -->
<!-- 														<div class="morris-hover-row-label">백업</div> -->
<!-- 														<div class="morris-hover-point" style="color: #76C1FA"> -->
<!-- 															진행: 0 -->
<!-- 														</div> -->
<!-- 														<div class="morris-hover-point" style="color: #63CF72"> -->
<!-- 															성공: 0 -->
<!-- 														</div> -->
<!-- 														<div class="morris-hover-point" style="color: #F36368"> -->
<!-- 															실패:	0 -->
<!-- 														</div> -->
													</div>
												</table>
											</div>
										</div>
									</div>
									
								</div>
							</div>
						</div>
					</div>
					<!-- 리스너 stat chart end -->
					
					<!-- 리스너 stat table -->
					<div class="row">
						<div class="col-md-12">
							<table id="proxyStatTable" class="table table-bordered system-tlb-scroll text-center"> 
								<thead>
									<tr class="bg-info text-white">
										<th rowspan="2"><spring:message code="eXperDB_proxy.server_name"/></th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.listener_name"/></th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.ipadr"/></th>
										<th rowspan="2"><spring:message code="properties.status"/></th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.health_check_time"/></th>
										<th rowspan="2">Chk</th>
										<th colspan="3"><spring:message code="eXperDB_proxy.session"/></th>
										<th colspan="2"><spring:message code="eXperDB_proxy.byte"/></th>
									</tr>
									<tr class="bg-info text-white">
										<th>max</th>
										<th>limit</th>	
										<th>total</th>
										<th>in</th>
										<th>out</th>
									</tr>
								</thead>
								
<!-- 								<tbody> -->
<!-- 									<tr> -->
<!-- 										<td rowspan="4">vip_master</td> -->
<!-- 										<td rowspan="2"><a href="#">pgReadWrite</a></td> -->
<!-- 										<td> -->
<!-- 											192.168.50.113 -->
<!-- 										</td> -->
<!-- 										<td>											 -->
<!-- 											<div class="badge badge-pill badge-success"> -->
<!-- 											<i class="fa fa-circle-o-notch fa-spin mr-2"></i> -->
<!-- 												L7OK -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											20ms 전 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1131(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>25) -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											- -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											5 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											645 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1414 -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											192.168.50.114 -->
<!-- 										</td> -->
<!-- 										<td>											 -->
<!-- 											<div class="badge badge-pill badge-danger"> -->
<!-- 											<i class="fa fa-circle-o-notch mr-2"></i> -->
<!-- 												L7RSP -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											0 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											- -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											0 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											0 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											0 -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td rowspan="2"><a href="#">pgReadOnly</a></td> -->
<!-- 										<td> -->
<!-- 											192.168.50.113 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<div class="badge badge-pill badge-info text-white"> -->
<!-- 											<i class="fa fa-circle-o-notch fa-spin mr-2"></i> -->
<!-- 												L7OK -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td></td> -->
<!-- 										<td>1139</td> -->
<!-- 										<td>0</td> -->
<!-- 										<td>-</td> -->
<!-- 										<td>0</td> -->
<!-- 										<td>0</td> -->
<!-- 										<td>0</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											192.168.50.114 -->
<!-- 										</td> -->
<!-- 										<td>											 -->
<!-- 											<div class="badge badge-pill badge-success"> -->
<!-- 											<i class="fa fa-circle-o-notch fa-spin mr-2"></i> -->
<!-- 												L7OK -->
<!-- 											</div> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1129 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											1 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											- -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											2 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											302 -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											904 -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
							</table>
						</div>
					</div>
					<!-- 리스너 stat table end -->
					
					
				</div>
			</div>
		</div>	
	</div>
	
</div>