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
	var shown = true;
	
	$(window).ready(function(){
		//서버정보 리스트 setting
		fn_serverListSetting();	
		// 프록시 모니터링 setting
// 		fn_proxyMonInfo();
		// 프록시 연결 db 모니터링 setting
// 		fn_dbMonInfo();
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
						html += '<a href="#" onclick="fn_logView(' + full.pry_svr_id + ', \'' + full.sys_type + '\', \'' + full.wrk_dtm + '\')">'+data+'</a>';
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "sys_type", 
					render : function(data, type, full, meta) {
						var html = "";
						if(data == "PROXY"){
							html += '<spring:message code="menu.proxy"/>';
						} else if(data == "KEEPALIVED"){
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
						if(data == 'A'){
							html += '<div class="badge badge-pill badge-success">';
							html += '	<i class="fa fa-spinner fa-spin mr-2"></i>';
// 							html += '	<i class="fa fa-circle-o-notch fa-spin mr-2"></i>';
							html += '	start';
							html += '</div>';
						} else if(data == 'R') {
							html += '<div class="badge badge-pill badge-success">';
							html += '	<i class="fa fa-spinner fa-spin mr-2"></i>';
							html += '	restart';
							html += '</div>';
						} else if(data == 'S'){
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
				{data : "exe_rslt_cd", 
					render : function(data, type, full, meta){
						if(data == 'TC001501'){
							return '성공';
						} else if(data == 'TC001502'){
							return '실패';
						}
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "wrk_dtm", className : "dt-center", defaultContent : ""},
			]
		});

		proxyLogTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); //rownum
		proxyLogTable.tables().header().to$().find('th:eq(1)').css('min-width', '0px'); //proxy server id
		proxyLogTable.tables().header().to$().find('th:eq(2)').css('min-width', '50px'); // proxy server name
		proxyLogTable.tables().header().to$().find('th:eq(3)').css('min-width', '50px'); // proxy or keepavlied
		proxyLogTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px'); // start or restart or stop
		proxyLogTable.tables().header().to$().find('th:eq(5)').css('min-width', '50px'); // manual or system
		proxyLogTable.tables().header().to$().find('th:eq(6)').css('min-width', '50px'); // first reg date
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
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_getProxyInfo(' + pry_svr_id_val + ', '+ rowCount +')" style="cursor:pointer;">\n';
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
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_getProxyInfo('+ pry_svr_id_val +', '+ rowCount +')" style="cursor:pointer;">\n';
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
		
		$("#listenerStatChart").html("");
	}

	function fn_proxyMonitoringInit(pry_svr_id, result) {
		// 프록시 모니터링 setting
		fn_proxyMonInfo(result);
		// 프록시 연결 db 모니터링 setting
		fn_dbMonInfo(result);
		// 프록시 log 테이블
// 		fn_proxy_log_init();
		
		proxyLogTable.clear().draw();
		if (nvlPrmSet(result.proxyLogList, '') != '') {
			proxyLogTable.rows.add(result.proxyLogList).draw();
		}
		// 프록시 리스너 통계 테이블
// 		fn_proxy_stat_init();
		fn_lsnStat(pry_svr_id);
	}
	
	/* ********************************************************
	* 프록시 서버 모니터링 셋팅
	******************************************************** */
	function fn_proxyMonInfo(result){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
 		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		var proxyServerByMasId_cnt = "${fn:length(proxyServerByMasId)}";
		var master_state = "";
		
		$("#proxy_master_nm").text("");
		if (result.proxyServerByMasId != null && result.proxyServerByMasId.length > 0) {
			$(result.proxyServerByMasId).each(function (index, item) {
				html += '								<table class="table-borderless">\n';
				html += '									<tr>\n'
				html += '										<td colspan="2">\n';
				html += '											<h6	class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">\n';
				if(item.master_gbn == "M") {
					$("#proxy_master_nm").text(item.pry_svr_nm);
					if(nvlPrmSet(item.agt_cndt_cd, '') == 'TC001101'){
						html += '												<div class="badge badge-pill badge-success" title="">M</div>\n';
					} else {
						html += '												<div class="badge badge-pill badge-danger" title="">M</div>\n';
					}
					master_state = nvlPrmSet(item.agt_cndt_cd, '');
				} else if(item.master_gbn == "B"){
					if(nvlPrmSet(item.agt_cndt_cd, '') == 'TC001101'){
						html += '												<div class="badge badge-pill badge-success">B</div>\n'
					} else {
						html += '												<div class="badge badge-pill badge-danger">B</div>\n'
					}
				}
				html += '												'+item.pry_svr_nm+'\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '										<td rowspan="4">\n';
				if(nvlPrmSet(item.agt_cndt_cd, '') == 'TC001101'){
					html += '											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db pry_agt" style="font-size: 3em;"></i>\n';
				} else if(nvlPrmSet(item.agt_cndt_cd, '') == 'TC001102'){
					html += '											<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db pry_agt" style="font-size: 3em;"></i>\n'
				}
				html += '											<h6 class="text-muted">agent</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				html += '												VIP : '+item.v_ip+'\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				if(item.master_gbn == "M"){
					html += '												PORT : 5430\n';
				} else if(item.master_gbn == "B"){
					html += '												PORT : 5431\n';
				}
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td>\n';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
				html += '												IP : '+item.ipadr+'\n';
				html += '											</h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '									<tr>\n';
				html += '										<td class="text-center">\n';
				html += '											<i class="mdi mdi-lan icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 2em;"></i>\n';
// 				html += '											<i class="mdi mdi-blur icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 2em;"></i>\n';
				html += '											<h6 class="text-muted"><a href="#" onclick="fn_configView('+item.pry_svr_id+', \'P\')">Proxy</a></h6>\n';
				html += '										</td>\n';
				html += '										<td class="text-center">\n';
				html += '											<i class="mdi mdi-checkbox-marked-circle-outline icon-md mb-0 mb-md-3 mb-xl-0 text-info text-center" style="font-size: 2em;"></i>\n';
// 				html += '											<i class="fa fa-check-circle icon-md mb-0 mb-md-3 mb-xl-0 text-info text-center" style="font-size: 2em;"></i>\n';
				html += '											<h6 class="text-muted"><a href="#" onclick="fn_configView('+item.pry_svr_id+', \'K\')">Keepalived</a></h6>\n';
				html += '										</td>\n';
				html += '									</tr>\n';
				html += '								</table>\n';
			});
		} else {
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
		}
		$("#proxyMonitoringList").html(html);
		
		if (master_state == 'TC001101') {
// 			setInterval(iDatabase_toggle, 1000);
		}
		
	}
	function iDatabase_toggle() {
		if(shown) {
			$(".pry_agt").hide();
			shown = false;
		} else {
			$(".pry_agt").show();
			shown = true;
		}
	}
	
	/* ********************************************************
	* 프록시 서버 정보 가져오기
	******************************************************** */
	function fn_getProxyInfo(pry_svr_id) {
		console.log('pry_svr_id : ' + pry_svr_id)
		$.ajax({
			url : '/proxyMonitoring/selectInfoByPrySvrId.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
			},
			dataType : 'json',
			success : function(result) {
				// 프록시 모니터링 초기화
				fn_proxyMonitoringInit(pry_svr_id, result);
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				$("#ins_idCheck", "#insProxyListenForm").val("0");
				console.log(error);
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
	* 디비 서버 모니터링 셋팅
	******************************************************** */
	function fn_dbMonInfo(result){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		
		if (result.dbServerConProxy != null && result.dbServerConProxy.length > 0) {
			$(result.dbServerConProxy).each(function (index, item) {
				html += '								<table class="table-borderless">';
				html += '									<tr>';
				html += '										<td colspan="2">';
				html += '											<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">';
				if(item.agt_cndt_cd == 'TC001101'){
					html += '												<div class="badge badge-pill badge-success" title="">'+item.master_gbn+'</div>';
				} else {
					html += '												<div class="badge badge-pill badge-danger" title="">'+item.master_gbn+'</div>';
				}
				if(item.master_gbn == 'M'){
					html += '													master';
				} else {
					html += '													standby';
				}
				html += '												</h6>';
				html += '											</td>';
				html += '											<td rowspan="2">';
				if(item.agt_cndt_cd == 'TC001101'){
					html += '												<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3em;"></i>';
				} else {
					html += '												<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db" style="font-size: 3em;"></i>';
				}
				html += '											<h6 class="text-muted"><spring:message code="eXperDB_proxy.agent"/></h6>';
				html += '			</td>';
				html += '		</tr>';
				html += '		<tr>';
				html += '			<td>';
				html += '				<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">IP : ' + item.ipadr + '</h6>';
				html += '			</td>'
				html += '			<td>'
				html += '				<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">PORT : ' + item.portno + '</h6>';
				html += '			</td>';
				html += '		</tr>';
				html += '	</table>'
			});
		} else {
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
		}
		$("#dbMonitoringList").html(html);
	}
	
	/* ********************************************************
	 * 리스너 통계 테이블 셋팅
	 ******************************************************** */
	function fn_proxy_stat_init(){
		
		proxyStatTable = $('#proxyStatTable').DataTable({
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
// 				{data : "r", className : "dt-center", visible : false},
				{data : "rownum", className : "dt-center", visible : false, defaultContent : ""},
				{data : "idx", className : "dt-center", visible : false, defaultContent : ""},
				{data : "pry_svr_id", className : "dt-center", visible : false, defaultContent : ""},
				{data : "pry_svr_nm", className : "dt-center", defaultContent : ""},
				{data : "lsn_nm", className : "dt-center", defaultContent : ""},
				{data : "db_con_addr", className : "dt-center", defaultContent : ""},
				{data : "svr_status", 
					render : function(data, type, full, meta){
						var html = "";
						if(data == 'UP'){
							html += '<div class="badge badge-pill badge-success">';
							html += '	<i class="fa fa-spin fa-spinner mr-2" style="font-size:1em;"></i>';
							html += '실행중('+full.lst_status_chk_desc.substring(2)+')';
							html += '</div>';
						} else if(data == 'DOWN'){
							html += '<div class="badge badge-pill badge-danger">';
							html += '	<i class="fa fa-circle-o-notch mr-2" style="font-size:1em;"></i>';
							html += '정지('+full.lst_status_chk_desc.substring(2)+')';
							html += '</div>';
						}
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "svr_stop_tm", 
					render : function(data, type, full, meta){
						var html = "";
						if(data == '0s'){
							html += '<div class="">';
// 							html += '	<i class="mdi mdi-alarm mr-2 text-success" style="font-size:1em;"></i>';
// 							html += data;
							html += '</div>';
						} else {
							html += '<div class="">';
							html += '	<i class="mdi mdi-alarm mr-2 text-danger" style="font-size:1em;"></i>';
							html += data ;
							html += '</div>';
						}
						return html;
					},
					className : "dt-center", defaultContent : ""
				},
				{data : "fail_chk_cnt", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['fail_chk_cnt_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['fail_chk_cnt_cng']+')';
						} else if(full['fail_chk_cnt_cng'] == 0 || typeof full['fail_chk_cnt_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['fail_chk_cnt_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "max_session", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['max_session_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['max_session_cng']+')';
						} else if(full['max_session_cng'] == 0 || typeof full['max_session_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['max_session_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "session_limit", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['session_limit_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['session_limit_cng']+')';
						} else if(full['session_limit_cng'] == 0 || typeof full['session_limit_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['session_limit_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "cumt_sso_con_cnt", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['cumt_sso_con_cnt_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['cumt_sso_con_cnt_cng']+')';
						} else if(full['cumt_sso_con_cnt_cng'] == 0 || typeof full['cumt_sso_con_cnt_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['cumt_sso_con_cnt_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "byte_receive", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['byte_receive_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['byte_receive_cng']+')';
						} else if(full['byte_receive_cng'] == 0 || typeof full['byte_receive_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['byte_receive_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "byte_transmit", 
					render : function(data, type, full, meta){
						var html = "";
						html += '<div>'+data;
						if(full['byte_transmit_cng'] > 0){
							html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['byte_transmit_cng']+')';
						} else if(full['byte_transmit_cng'] == 0 || typeof full['byte_transmit_cng'] === 'undefined') {
							html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
						} else {
							html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['byte_transmit_cng']+')'
						}
						html +='</div>'
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				}
			],
		});

		proxyStatTable.tables().header().to$().find('th:eq(0)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(1)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(2)').css('min-width','0px');
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
		proxyStatTable.tables().header().to$().find('th:eq(13)').css('min-width');
// 		proxyStatTable.tables().header().to$().find('th:eq(14)').css('min-width');
	}
	
	function fn_lsnStat(pry_svr_id){
		$.ajax({
			url : '/proxyMonitoring/listenerstatistics.do', 
			data : {
				pry_svr_id : pry_svr_id,
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
				$('#listenerStatChart').html("");
				
				if (nvlPrmSet(result.proxyStatisticsInfo, '') != '') {
					for(var i = 0; i < result.proxyStatisticsInfo.length; i++){
						console.log(result.proxyStatisticsInfo[i].r)
						if(result.proxyStatisticsInfo[i].r == 1){
							if(i != result.proxyStatisticsInfo.length-1 && result.proxyStatisticsInfo[i+1].r == 2){
								result.proxyStatisticsInfo[i].fail_chk_cnt_cng = result.proxyStatisticsInfo[i].fail_chk_cnt-result.proxyStatisticsInfo[i+1].fail_chk_cnt;
								result.proxyStatisticsInfo[i].max_session_cng = result.proxyStatisticsInfo[i].max_session-result.proxyStatisticsInfo[i+1].max_session;
								result.proxyStatisticsInfo[i].session_limit_cng = result.proxyStatisticsInfo[i].session_limit-result.proxyStatisticsInfo[i+1].session_limit;
								result.proxyStatisticsInfo[i].cumt_sso_con_cnt_cng = result.proxyStatisticsInfo[i].cumt_sso_con_cnt-result.proxyStatisticsInfo[i+1].cumt_sso_con_cnt;
								result.proxyStatisticsInfo[i].byte_receive_cng = result.proxyStatisticsInfo[i].byte_receive-result.proxyStatisticsInfo[i+1].byte_receive;
								result.proxyStatisticsInfo[i].byte_transmit_cng = result.proxyStatisticsInfo[i].byte_transmit-result.proxyStatisticsInfo[i+1].byte_transmit;
							}
							proxyStatTable.row.add(result.proxyStatisticsInfo[i]).draw();
						}
					}
					
// 					proxyStatTable.rows.add(result.proxyStatisticsInfo).draw();
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
		  		if(result.proxyStatisticsInfo != null && result.proxyStatisticsInfo.length > 0){
		  			if ($("#listenerStatChart").length) {
		  				var db_con_addr = nvlPrmSet(result.proxyStatisticsInfo[0].db_con_addr, 0);
// 		  				var byte_receive = nvlPrmSet(result.proxyStatisticsInfo[0].byte_receive, 0);
// 		  				var byte_transmit = nvlPrmSet(result.proxyStatisticsInfo[0].byte_transmit, 0);
// 		  				var fail_chk_cnt = nvlPrmSet(result.proxyStatisticsInfo[0].fail_chk_cnt, 0);	
// 		  				console.log('db_con_addr : ' + db_con_addr);
		  				var statchart = Morris.Bar({
		  							element: 'listenerStatChart',
		  							barColors: ['#76C1FA', '#FABA66', '#63CF72', '#F36368'],
		  							data: [{
		  									db_con_addr: db_con_addr,
		  									byte_receive: 0,
		  									byte_transmit: 0,
		  									cumt_sso_con_cnt: 0,
		  									fail_chk_cnt: 0,
		  								}
		  							],
		  							xkey: 'db_con_addr',
		  							ykeys: ['byte_receive', 'byte_transmit', 'cumt_sso_con_cnt', 'fail_chk_cnt'],
		  							labels: ['byte in', 'byte out', 'session total', 'fail check']
		  				});
					
		  			
		  				if (result.proxyStatisticsInfo != null) {
		  					if (result.proxyStatisticsInfo.length > 0) {
		  						var proxyStatChart = [];
		  						for(var i = 0; i<result.proxyStatisticsInfo.length; i++){
// 		  							if (result.proxyStatisticsInfo[i].bck_opt_cd == "TC000301") {
// 		  								result.proxyStatisticsInfo[i].bck_opt_cd_nm = backup_management_full_backup;
// 		  							} else if (result.proxyStatisticsInfo[i].bck_opt_cd == "TC000302") {
// 		  								result.proxyStatisticsInfo[i].bck_opt_cd_nm = backup_management_incremental_backup;
// 		  							} else {
// 		  								result.proxyStatisticsInfo[i].bck_opt_cd_nm = backup_management_change_log_backup;
// 		  							}
									if(result.proxyStatisticsInfo[i].r == 1) {
			  							proxyStatChart.push(result.proxyStatisticsInfo[i]);
									}
		  						}	
		  			
		  						statchart.setData(proxyStatChart);
		  					}
		  				}
		  			
// 		  			if (result.proxyStatisticsInfo != null) {
// 		  				if (result.proxyStatisticsInfo.length > 0) {
// 		  					statchart.setData(result.proxyStatisticsInfo);
// 		  				}
// 		  			}
		  			}
		  		}
			}
		});
	}

	/* ********************************************************
	 * config 파일 view popup
	 ******************************************************** */
	function fn_configView(pry_svr_id, type){
		console.log('pry_svr_id : ' + pry_svr_id);
		console.log('type : ' + type);
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
				fn_configViewAjax(pry_svr_id, type);
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
	 * log 파일 view popup
	 ******************************************************** */
	function fn_logView(pry_svr_id, type, date){
		console.log('pry_svr_id : ' + pry_svr_id);
		console.log('type : ' + type);
		console.log('date : ' + date);
		$.ajax({
			url : '/proxyMonitoring/logView.do',
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
				fn_logViewAjax(pry_svr_id, type, date);
				$('#pop_layer_log_view').modal("show");
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
							<div class="card" id="proxyMonitoringList"></div>
						</div>
						<!-- Proxy 서버 end -->
						
						<!-- DB 서버 -->
						<div class="col-md-3" style="margin-left:10px; margin-top: -50px;">
							<div class="card" id="dbMonitoringList"></div>
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
										<th>실행결과</th>
										<th><spring:message code="history_management.time"/></th>
									</tr>
								</thead>
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
					
					<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
						<div class="card" style="margin-bottom: 0px;">
							<div class="card-header" role="tab" id="listener_header_div">
								<div class="row">
									<div class="col-12">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#listener_header_sub" aria-expanded="false" aria-controls="listener_header_sub" onclick="fn_profileChk('listenerTitleText')">
											<i class="fa fa-bar-chart-o menu-icon"></i> 
											<span class="menu-title">리스너 정보</span> 
											<i class="menu-arrow_user_af" id="listenerTitleText"></i>
											</a>
										</h6>
									</div>
								</div>
							</div>

							<div id="listener_header_sub" class="collapse show row" role="tabpanel"	aria-labelledby="listener_header_div" data-parent="#accordion">
								<div class="card-body">








					<!-- 리스너 정보 title -->
<!-- 					<div class="row"> -->
<!-- 						<div class="accordion_main accordion-multi-colored col-12"	id="accordion" role="tablist" style="margin-bottom: 10px;"> -->
<!-- 							<div class="card" style="margin-bottom: 0px;"> -->
<!-- 								<div class="card-header" role="tab" id="page_header_div"> -->
<!-- 									<div class="row" style="height: 15px;"> -->
<!-- 										<div class="col-12"> -->
<!-- 											<h6 class="mb-0"> -->
<!-- 												<i class="fa fa-bar-chart-o menu-icon"></i> <span class="menu-title">리스너 정보</span> -->
<!-- 											</h6> -->
<!-- 										</div> -->
<!-- 									</div> -->
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> -->
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
													<div id="listenerStatChart" style="height:250px;"></div>
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
							<table id="proxyStatTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;"> 
								<thead class="bg-info text-white">
									<tr>
										<th rowspan="2">idx</th>
										<th rowspan="2">rownum</th>
<!-- 										<th rowspan="2">r</th> -->
										<th rowspan="2">pry_svr_id</th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.server_name"/></th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.listener_name"/></th>
										<th rowspan="2"><spring:message code="eXperDB_proxy.ipadr"/></th>
										<th rowspan="2"><spring:message code="properties.status"/></th>
<%-- 										<th rowspan="2"><spring:message code="eXperDB_proxy.health_check_time"/></th> --%>
										<th rowspan="2">desc</th>
										<th rowspan="2">Chk</th>
										<th rowspan="1" colspan="3"><spring:message code="eXperDB_proxy.session"/></th>
										<th rowspan="1" colspan="2"><spring:message code="eXperDB_proxy.byte"/></th>
									</tr>
									<tr>
										<th>max</th>
										<th>limit</th>	
										<th>total</th>
										<th>in</th>
										<th>out</th>
									</tr>
								</thead>
								
							</table>
						</div>
					</div>
					<!-- 리스너 stat table end -->
													</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
		</div>	
	</div>
	
</div>