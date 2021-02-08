<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : dbmsInformation.jsp
	* @Description : dbmsInformation 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.11.09     최초 생성
	*
	* author 김주영 사원
	* since 2017.11.09 
	*
	*/
%>

<script type="text/javascript">
	var extName = "${extName}";
	var shown = true;
	
	/* ********************************************************
	 * Data initialization
	 ******************************************************** */
	$(window.document).ready(function() {
		//agent 상태확인
		if (!fn_chkExtName(extName)) {
			return;	
		}

		//시스템 정보
		fn_systemInfoAdd();
		
		fn_serverListSetting();
		
 		$('a[href="#dbmisinfoDiv"]').on('shown.bs.tab', function (e) {
			//사이즈 ui변경
			fn_dbmisinfSizeUI();
		});
 		
		
 		$('a[href="#tablespaceinfoDiv"]').on('shown.bs.tab', function (e) {
			//사이즈 ui변경
			fn_tablespaceinfSizeUI();
			
			setTimeout(fn_tavlespaceinfProgress, 1000);
		});
	});

	/* ********************************************************
	 * 테이블스페이스 정보 프로그레스바
	 ******************************************************** */
 	function fn_tavlespaceinfProgress() {
		var iCount = 0;
		var use = "";

		<c:forEach items="${result.CMD_TABLESPACE_INFO}" var="tablespaceinfo" varStatus="status">
			use = nvlPrmSet("${tablespaceinfo.use}", "");

			if (use != "") {
				use = use.slice(0,-1);

				if ($("#prgUse_" + iCount) != null) {
					$("#prgUse_" + iCount).val(use);
					$("#prgUse_" + iCount).css("width", use + "%"); 
					$("#prgUse_" + iCount).html(use + "%"); 
				}
			}

			iCount = iCount + 1;

		</c:forEach>
	}

	/* ********************************************************
	 * 테이블스페이스 정보
	 ******************************************************** */
 	function fn_tablespaceinfSizeUI() {
		var size = "";
		var fsize = "";
		var used = "";
		var avail = "";
		var sizeLastVal = "";
		var sizeLast2Val = "";
		var iCount = 0;
		var html = "";
		<c:forEach items="${result.CMD_TABLESPACE_INFO}" var="tablespaceinfo" varStatus="status">
			size = nvlPrmSet("${tablespaceinfo.size}", "");
			html = "";
			if (size != "") {
				
				sizeLastVal = size.substr(size.length - 2);
				html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				
				if (sizeLastVal.toLowerCase() == "es" || sizeLastVal.toLowerCase() == "kb") {
					html += "	<i class='ti-files text-info'>";
				} else if (sizeLastVal.toLowerCase() == "mb") {
					html += "	<i class='ti-files text-success' >";
				} else if (sizeLastVal.toLowerCase() == "gb") {
					html += "	<i class='ti-files text-warning' >";
				} else {
					if (size != "0") {
						html += "	<i class='ti-files text-black' >";
					}
				}
				
				html += '&nbsp;' + size + '</i>';
				html += "</div>";
			}
			$("#tablespaceinfoSizeTd_" + iCount).html(html);
			
			//파일시스템 사이즈
			fsize = nvlPrmSet("${tablespaceinfo.fsize}", "");
			html = "";
			if (fsize != "") {
				
				sizeLast2Val = fsize.substr(fsize.length - 2);
				sizeLastVal = fsize.substr(fsize.length - 1);
				html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				
				if (sizeLast2Val.toLowerCase() == "es" || sizeLast2Val.toLowerCase() == "kb"  || sizeLastVal.toLowerCase() == "k") {
					html += "	<i class='ti-files text-info'>";
				} else if (sizeLast2Val.toLowerCase() == "mb" || sizeLastVal.toLowerCase() == "m") {
					html += "	<i class='ti-files text-success' >";
				} else if (sizeLast2Val.toLowerCase() == "gb" || sizeLastVal.toLowerCase() == "g") {
					html += "	<i class='ti-files text-warning' >";
				} else {
					if (fsize != "0") {
						html += "	<i class='ti-files text-black' >";
					}
				}
				
				html += '&nbsp;' + fsize + '</i>';
				html += "</div>";
			}
			$("#tablespaceinfoFSizeTd_" + iCount).html(html);
			
			//파일시스템 used
			used = nvlPrmSet("${tablespaceinfo.used}", "");
			html = "";
			if (used != "") {
				
				sizeLast2Val = used.substr(used.length - 2);
				sizeLastVal = used.substr(used.length - 1);
				html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				
				if (sizeLast2Val.toLowerCase() == "es" || sizeLast2Val.toLowerCase() == "kb"  || sizeLastVal.toLowerCase() == "k") {
					html += "	<i class='ti-files text-info'>";
				} else if (sizeLast2Val.toLowerCase() == "mb" || sizeLastVal.toLowerCase() == "m") {
					html += "	<i class='ti-files text-success' >";
				} else if (sizeLast2Val.toLowerCase() == "gb" || sizeLastVal.toLowerCase() == "g") {
					html += "	<i class='ti-files text-warning' >";
				} else {
					if (used != "0") {
						html += "	<i class='ti-files text-black' >";
					}
				}
				
				html += '&nbsp;' + used + '</i>';
				html += "</div>";
			}
			$("#tablespaceinfoUsedTd_" + iCount).html(html);
			
			//AVAIL
			avail = nvlPrmSet("${tablespaceinfo.avail}", "");
			html = "";
			if (avail != "") {
				
				sizeLast2Val = avail.substr(avail.length - 2);
				sizeLastVal = avail.substr(avail.length - 1);

				html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				
				if (sizeLast2Val.toLowerCase() == "es" || sizeLast2Val.toLowerCase() == "kb"  || sizeLastVal.toLowerCase() == "k") {
					html += "	<i class='ti-files text-info'>";
				} else if (sizeLast2Val.toLowerCase() == "mb" || sizeLastVal.toLowerCase() == "m") {
					html += "	<i class='ti-files text-success' >";
				} else if (sizeLast2Val.toLowerCase() == "gb" || sizeLastVal.toLowerCase() == "g") {
					html += "	<i class='ti-files text-warning' >";
				} else {
					if (used != "0") {
						html += "	<i class='ti-files text-black' >";
					}
				}
				
				html += '&nbsp;' + avail + '</i>';
				html += "</div>";
			}
			$("#tablespaceinfoAvailTd_" + iCount).html(html);

			iCount = iCount + 1;

		</c:forEach>
	}

	/* ********************************************************
	 * DBMS 정보 체크
	 ******************************************************** */
	function fn_dbmisinfSizeUI() {
		var size = "";
		var sizeLastVal = "";
		var iCount = 0;
		var html = "";
		<c:forEach items="${result.CMD_DATABASE_INFO}" var="datasbaseInfo" varStatus="status">
			size = nvlPrmSet("${datasbaseInfo.size}", "");
			html = "";
			if (size != "") {
				
				sizeLastVal = size.substr(size.length - 2);
				html += "<div class='badge badge-light' style='background-color: transparent !important;'>";
				
				if (sizeLastVal.toLowerCase() == "es" || sizeLastVal.toLowerCase() == "kb") {
					html += "	<i class='ti-files text-info' >";
				} else if (sizeLastVal.toLowerCase() == "mb") {
					html += "	<i class='ti-files text-success' >";
				} else if (sizeLastVal.toLowerCase() == "gb") {
					html += "	<i class='ti-files text-warning' >";
				} else {
					html += "	<i class='ti-files text-black' >";
				}
				
				html += '&nbsp;' + size + '</i>';
				html += "</div>";
			}
			
			$("#databaseSizeTd_" + iCount).html(html);

			iCount = iCount + 1;

		</c:forEach>
	}

	/* ********************************************************
	 * agent 연결상태 체크
	 ******************************************************** */
	function fn_chkExtName(extName) {
 		if(extName == "agent") {
 			showSwalIconRst('<spring:message code="message.msg25" />', '<spring:message code="common.close" />', '', 'error', 'top');
 			return false;
		}else if(extName == "agentfail"){
			showSwalIconRst('<spring:message code="message.msg27" />', '<spring:message code="common.close" />', '', 'error', 'top');
			return false;
		}

 		return true;
	}
	
	/* ********************************************************
	 * 시스템 정보 리스트 setting
	 ******************************************************** */
	function fn_systemInfoAdd() {
		var html = '';
		var count = 0;
		var cpuCmdTdVal = "";
		var cpuMemoryTdVal = "";
		
		//cpu setting
		if (nvlPrmSet("${result.CMD_CPU}", "") != "") {
			cpuCmdTdVal += '<i class="mdi mdi-vector-square text-info"></i>';
			cpuCmdTdVal += "${result.CMD_CPU}";
		}
		$("#cmdCpuTd").html(cpuCmdTdVal);

		//memory setting
		if (nvlPrmSet("${result.CMD_MEMORY}", "") != "") {
			cpuMemoryTdVal += '<i class="mdi mdi-memory text-info h4" ></i>';
			cpuMemoryTdVal += "${result.CMD_MEMORY}";
		}
		$("#cmdMemoryTd").html(cpuMemoryTdVal);

		<c:forEach items="${result.CMD_NETWORK}" var="networkinfo" varStatus="status">
			count = '${status.count}';
		</c:forEach>

		//count = count*2;

		html += '<tr>';
		html += '	<td class="table-text-align-c bg-info text-white" colspan="3" rowspan="'+count+'"><spring:message code="properties.network" /></td>';
	
		<c:forEach items="${result.CMD_NETWORK}" var="networkinfo" varStatus="status">
			if('${status.index}'!=0){
				html +='<tr>'
			}
			
			html += '<td class="table-text-align-c bg-info text-white">${networkinfo.CMD_NETWORK_INTERFACE}</td>';
			html += '<td class="table-text-align-c bg-info text-white">ip</td>';
			html += '<td><i class="mdi mdi-account-network text-info" ></i> ${networkinfo.CMD_NETWORK_IP}</td>';
			html += '<td class="table-text-align-c bg-info text-white">mac</td>';
			html += '<td><i class="mdi mdi-desktop-mac text-info" ></i> ${networkinfo.CMD_MACADDRESS}</td></tr>';
		</c:forEach>

		$("#systemInfoList").append(html);
	}

	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(tab) {
  		if (tab == "systeminfo") {
			$("#systemInfoDiv").show();
			$("#dbmisinfoDiv").hide();
			$("#settinginfoDiv").hide();
			$("#tablespaceinfoDiv").hide();
		} else if (tab == "dbmisinfo") {
			$("#systemInfoDiv").hide();
			$("#dbmisinfoDiv").show();
			$("#settinginfoDiv").hide();
			$("#tablespaceinfoDiv").hide();
		} else if (tab == "settinginfo") {
			$("#systemInfoDiv").hide();
			$("#dbmisinfoDiv").hide();
			$("#settinginfoDiv").show();
			$("#tablespaceinfoDiv").hide();
		} else {
			$("#systemInfoDiv").hide();
			$("#dbmisinfoDiv").hide();
			$("#settinginfoDiv").hide();
			$("#tablespaceinfoDiv").show();
			
			var autoLevelCnt = $("input[name=autoLevel]").length;

			if (autoLevelCnt > 0) {
				for (var i = 0; i < autoLevelCnt; i++) {
					if ($("#prgUse_" + i) != null) {
						$("#prgUse_" + i).val("0");
						$("#prgUse_" + i).css("width", "0%"); 
						$("#prgUse_" + i).html("0%"); 
					}
				}
			}
		}
	}

	/* ********************************************************
	 * 서버 setting
	 ******************************************************** */
	function fn_serverListSetting() {
		var html = "";
 		var rowCount = 0;
		var master_gbn = "";
		var db_svr_id = "";
		var listCnt = 0;
		var db_svr_id_val = "";
		var master_state="";
		
		var serverTotInfo_cnt = "${fn:length(serverInfoVOSelectTot)}";
		
		if (serverTotInfo_cnt > 0) {
			<c:forEach items="${serverInfoVOSelectTot}" var="serverinfo" varStatus="status">
				master_gbn = nvlPrmSet("${serverinfo.master_gbn}", '') ;
				rowCount = rowCount + 1;
				listCnt = parseInt("${fn:length(serverInfoVOSelectTot)}");

				//setting value
				db_svr_id_val = nvlPrmSet("${serverinfo.db_svr_id}", '');
				
	 			if (db_svr_id == "") {
					html += "<div class='col-md-12 grid-margin stretch-card' style='height:370px;overflow-y:auto;'>\n";
					html += "	<div class='card' style='border:0px;'>\n";
					html += '		<div class="card-body" id="serverSs'+ rowCount +'">\n';
					html += '			<div class="row">\n';
				} else if (db_svr_id != nvlPrmSet("${serverinfo.db_svr_id}", '')  && master_gbn == "M") {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto;">\n';
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-info" id="iDatabase' + db_svr_id_val + '" style="font-size: 3.0em;"></i>\n';
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
					html += "<div class='col-md-12 grid-margin stretch-card'>\n";
					html += "	<div class='card'>\n";
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" >\n';
					html += '			<div class="row">\n';
				}

 			if (master_gbn == "M") {
 				html += '			<div class="col-sm-9">';
 				html += '				<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
 				html += '					<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
 				
				if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') {
 	 				html += '					<div class="badge badge-pill badge-success" title="">M</div>\n';
 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') {
 	 				html += '					<div class="badge badge-pill badge-danger">M</div>\n';
 				} else {
 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
 				}
				
				master_state = nvlPrmSet("${serverinfo.agt_cndt_cd}", '');
				
 				html += '					<span class="text-info"><c:out value="${serverinfo.db_svr_nm}"/></span><br/></h5>\n';
 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
 				html += '					IP : <c:out value="${serverinfo.ipadr}"/>&nbsp;&nbsp;&nbsp;PORT : <c:out value="${serverinfo.portno}"/></h6>\n';
 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
				html += '					<spring:message code="dbms_information.account" /> : <c:out value="${serverinfo.dft_db_nm}"/>\n';
 				html += '					</h6>\n';
 				
 				
 			}
 			
 			if (master_gbn == "S") {
 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;padding-top:10px;">\n';
 				
					if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == '') {
 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001101') {
 	 				html += '					<div class="badge badge-pill badge-success">S</div>\n';
 				} else if (nvlPrmSet("${serverinfo.agt_cndt_cd}", '') == 'TC001102') {
 	 				html += '					<div class="badge badge-pill badge-danger">S</div>\n';

 				} else {
 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
 				}
 				html += '					<span class="text-info"><c:out value="${serverinfo.svr_host_nm}"/></span><br/></h6>';
 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:64px;">\n';
 				html += '					IP : <c:out value="${serverinfo.ipadr}"/>&nbsp;&nbsp;&nbsp;PORT : <c:out value="${serverinfo.portno}"/></h6>\n';
 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:64px;">\n';
				html += '					<spring:message code="dbms_information.account" /> : <c:out value="${serverinfo.dft_db_nm}"/>\n';
 				html += '					</h6>\n';
 				
 			}

			if (rowCount == listCnt) {
				html += '				</div>\n';
				html += '			</div>\n';
				html += '			<div class="col-sm-3" style="margin:auto;">\n';
				
				if (master_state == '') {
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-warning blink_db" style="font-size: 3.0em;"></i>\n';
				} else if (master_state == 'TC001101') {
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success blink_db" style="font-size: 3.0em;"></i>\n';
 				} else if (master_state == 'TC001102') {
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger blink_db" style="font-size: 3.0em;"></i>\n';
 				} else {
					html += '				<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-warning blink_db" style="font-size: 3.0em;"></i>\n';
 				}

				html += '			</div>\n';
				html += "		</div>\n";
				html += "		</div>\n";
				html += "	</div>\n";
				html += '</div>\n';
				
			}
			db_svr_id = nvlPrmSet("${serverinfo.db_svr_id}", '') ;

		</c:forEach> 
		}

		$("#dbServerImg").html(html);

		if (master_state == 'TC001101') {
			setInterval(iDatabase_toggle, 300);
		}
	}
	
	function iDatabase_toggle() {
		if(shown) {
			$(".blink_db").hide();
			shown = false;
		} else {
			$(".blink_db").show();
			shown = true;
		}
	}
</script>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id"  id="db_svr_id"  value="${db_svr_id}">
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
												<i class="mdi mdi-server"></i>
												<span class="menu-title"><spring:message code="menu.server_property"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.server_property"/></li>
										</ol>

									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.properties_01"/></p>
											<p class="mb-0"><spring:message code="help.properties_02"/></p>
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
					<div class="form-group row div-form-margin-z">
						<div class="col-12" >
							<ul class="nav nav-pills nav-pills-setting" style="border-bottom:0px;" id="server-tab" role="tablist">
								<li class="nav-item">
									<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#systemInfoDiv" role="tab" aria-controls="systemInfoDiv" aria-selected="true" onclick="selectTab('systeminfo');" >
										<spring:message code="properties.system_info" />
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#dbmisinfoDiv" role="tab" aria-controls="dbmisinfoDiv" aria-selected="false" onclick="selectTab('dbmisinfo');">
										<spring:message code="menu.dbms_information" />
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#settinginfoDiv" role="tab" aria-controls="settinginfoDiv" aria-selected="false" onclick="selectTab('settinginfo');">
										<spring:message code="properties.about_preferences" />
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#tablespaceinfoDiv" role="tab" aria-controls="tablespaceinfoDiv" aria-selected="false" onclick="selectTab('tablespaceinfo');">
										<spring:message code="properties.tablespace_info" />
									</a>
								</li>
							</ul>

							<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;">
								<div class="tab-pane fade show active" role="tabpanel" id="systemInfoDiv">
									<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
										<div class="col-md-12" style="border:0px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.system_info" />
											</h5>
										</div>

										<div class="col-md-4" style="border:0px;" id="dbServerImg">

										</div>
										<div class="col-md-8 table-responsive" style="border:0px;">
											<table id="systemInfoList" class="table table-bordered system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 10%;" />
													<col style="width: 5%;" />
													<col style="width: 5%;" />
													<col style="width: 7%;" />
													<col style="width: 7%;" />
													<col style="width: 30%;" />
													<col style="width: 8%;" />
													<col style="width: 30%;" />
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c" colspan="5"><spring:message code="properties.item" /></th>
														<th class="table-text-align-c" colspan="3"><spring:message code="properties.description" /></th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td class="table-text-align-c bg-info text-white" colspan="5" ><spring:message code="properties.host" /></td>				
														<td colspan="3">
															${result.CMD_HOSTNAME}
														</td>																					
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" colspan="2" rowspan="2"><spring:message code="properties.os_info" /></td>
														<td class="table-text-align-c bg-info text-white" colspan="3"><spring:message code="properties.version" /></td>
														<td colspan="3">
															${result.CMD_OS_VERSION}
														</td>																					
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" colspan="3"><spring:message code="properties.kernel" /></td>
														<td colspan="3">
															${result.CMD_OS_KERNUL}
														</td>																					
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" colspan="5"><spring:message code="properties.cpu" /></td>
														<td colspan="3" id="cmdCpuTd"></td>																					
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" colspan="5"><spring:message code="properties.memory" /></td>
														<td colspan="3" id="cmdMemoryTd"></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>

									<div class="form-group row div-form-margin-z" style="margin-top:-10px;">		
										<div class="col-md-12" style="border:0px;margin-top:25px;margin-bottom:-15px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.ha_config" />
											</h5>
										</div>
 
										<div class="col-md-12 table-responsive" style="border:0px;">
											<table id="haConfigList" class="table table-bordered system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 25%;">
													<col style="width: 25%;">
													<col style="width: 25%;">
													<col style="width: 25%;">
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c" ><spring:message code="properties.ip" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.server_type" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.host" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.status" /></th>	
													</tr>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${empty resultIpadr}">
															<tr>
																<td class="table-text-align-c" colspan="4">
																	<spring:message code="properties.msg01" />
																</td>
															</tr>
														</c:when>
														<c:otherwise>
															<c:forEach var="hainfo" items="${resultIpadr}">
																<tr>
																	<td class="table-text-align-c">
																		<c:if test="${not empty hainfo.ipadr}">
																			<i class="mdi mdi-account-network text-info" ></i>
							 											</c:if>	
																		${hainfo.ipadr}
																	</td>
																	<td class="table-text-align-c">
																		<c:choose>
																			<c:when test="${hainfo.master_gbn eq 'M'}">
																				<i class="ti-server text-success" >
																					master
																				</i>
																			</c:when>
																			<c:when test="${hainfo.master_gbn eq 'S'}">
																				<i class="mdi mdi-server-network text-warning" >
																					slave
																				</i>
																			</c:when>
																			<c:otherwise></c:otherwise>
																		</c:choose>
																	</td>
																	<td class="table-text-align-c">${hainfo.svr_host_nm}</td>
																	<td class="table-text-align-c">
																		<c:choose>
																			<c:when test="${hainfo.db_cndt eq 'Y'}">
																				<div class='badge badge-pill badge-success'>
																					<i class='fa fa-spin fa-spinner mr-2'></i>
																					<spring:message code='dashboard.running' />
																				</div>
																			</c:when>
																			<c:when test="${hainfo.db_cndt eq 'N'}">
																				<div class='badge badge-pill badge-danger'>
																					<i class='fa fa-minus-circle mr-2'></i>
																					<spring:message code='schedule.stop' />
																				</div>
																			</c:when>
																		</c:choose>
																	</td>
																</tr>
															</c:forEach>
														</c:otherwise>
													</c:choose>	
												</tbody>
											</table>
										</div>
									</div>
								</div>
								
								<div class="tab-pane fade show active" role="tabpanel" id="dbmisinfoDiv" style="display:none;">
									<div class="form-group row div-form-margin-z system-tlb-scroll" style="margin-top:-10px;height:530px;overflow-x: hidden; overflow-y: auto;">
										<div class="col-md-12" style="border:0px;margin-bottom:-15px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.basic_info" />
											</h5>
										</div>

										<div class="col-md-12 table-responsive" style="border:0px;">
											<table id="dbmsBasicList" class="table table-bordered system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 25%;" />
													<col style="width: 75%;" />
													<col />
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c" ><spring:message code="properties.item" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.description" /></th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td class="table-text-align-c bg-info text-white" ><spring:message code="properties.postgresql_version" /></td>
														<td>${result.POSTGRESQL_VERSION}</td>																				
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" ><spring:message code="properties.dbms_path" /></td>
														<td>${result.CMD_DBMS_PATH}</td>																				
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white"><spring:message code="properties.data_path" /></td>
														<td>${result.DATA_PATH}</td>																					
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" ><spring:message code="properties.log_path" /></td>
														<td>${result.LOG_PATH}</td>																			
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" >Online <spring:message code="properties.backup_path" /></td>
														<td>${result.CMD_BACKUP_PATH}</td>
													</tr>
													<tr>
														<td class="table-text-align-c bg-info text-white" >DUMP <spring:message code="properties.backup_path" /></td>
														<td>${result.PGDBAK}</td>
													</tr>
												</tbody>
											</table>
										</div>

										<div class="col-md-12" style="border:0px;margin-top:25px;margin-bottom:-15px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.db_information" />
											</h5>
										</div>

										<div class="col-md-12 table-responsive" style="border:0px;">
											<table id="dbmsDetailList" class="table table-bordered system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 20%;">
													<col style="width: 10%;">
													<col style="width: 10%;">
													<col style="width: 10%;">
													<col style="width: 10%;">
													<col style="width: 10%;">
													<col style="width: 10%;">
													<col style="width: 20%;">
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c" ><spring:message code="properties.name" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.owner" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.incording" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.collate" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.ctype" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.size" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.tablespace" /></th>
														<th class="table-text-align-c" ><spring:message code="properties.explanation" /></th>
													</tr>
												</thead>

												<tbody>
													<c:set var="iDbmsDetail" value="0" />
													<c:forEach var="databaseInfo" items="${result.CMD_DATABASE_INFO}">
														<tr>
															<td style="word-break:break-all">
																<c:choose>
																	<c:when test="${empty resultRepoDB}">
																		${databaseInfo.name}
																	</c:when>
																	<c:otherwise>
																		<c:forEach var="dbnmInfo" items="${resultRepoDB}">
																			<c:if test="${dbnmInfo.db_nm eq databaseInfo.name}" >
																				<i class='fa fa-spin fa-spinner mr-2 text-success'></i>
																			</c:if>
																		</c:forEach>
																		${databaseInfo.name}
																	</c:otherwise>
																</c:choose>
															</td>
															<td style="word-break:break-all">${databaseInfo.owner}</td>
															<td style="word-break:break-all">${databaseInfo.encoding}</td>
															<td style="word-break:break-all">${databaseInfo.collate}</td>
															<td style="word-break:break-all">${databaseInfo.ctype}</td>
															<td style="word-break:break-all"  id="databaseSizeTd_${iDbmsDetail}">
																${databaseInfo.size}
															</td>
															<td style="word-break:break-all">${databaseInfo.tablespace}</td>
															<td style="word-break:break-all">
																<c:choose>
																	<c:when test="${empty databaseInfo.description}">
																		<c:forEach var="dbnmInfo" items="${resultRepoDB}">
																			<c:if test="${dbnmInfo.db_nm eq databaseInfo.name}" >${dbnmInfo.db_exp}</c:if>	
																		</c:forEach>
																	</c:when>
																	<c:otherwise>
																		${databaseInfo.description}
																	</c:otherwise>
																</c:choose>							
															</td>
														</tr>
														
														
														<c:set var = "iDbmsDetail" value="${iDbmsDetail + 1}" />
													</c:forEach>
													
													<c:forEach var="deleteDB" items="${deleteDB}">
														<tr>
															<td>
																<i class="mdi mdi-close-circle text-danger" ></i> ${deleteDB}
															</td>
															<td>-</td>
															<td>-</td>
															<td>-</td>
															<td>-</td>
															<td>-</td>
															<td>-</td>
															<td>-</td>
														</tr>
													</c:forEach>
													
													<c:if test="${empty deleteDB && empty result.CMD_DATABASE_INFO}" >
														<tr>
															<td class="table-text-align-c" colspan="8">
																<spring:message code="properties.msg01" />
															</td>
														</tr>
													</c:if>
												</tbody>
											</table>
										</div>
									</div>
								</div>

								<div class="tab-pane fade show active" role="tabpanel" id="settinginfoDiv" style="display:none;">
									<div class="form-group row div-form-margin-z system-tlb-scroll" style="margin-top:-10px;height:530px;overflow: hidden;">
										<div class="col-md-12" style="border:0px;margin-bottom:-15px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.about_preferences" />
											</h5>
										</div>

										<div class="col-md-12 table-responsive system-tlb-scroll" style="border:0px;height:500px;overflow: auto;">
											<table id="mainEnvSettingList" class="table table-bordered" style="width:100%;">
												<colgroup>
													<col style="width: 10%;">
													<col style="width: 23%;">
													<col style="width: 15%;">
													<col style="width: 6%;">
													<col style="width: 7%;">
													<col style="width: 10%;">
													<col style="width: 29%;">
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c"><spring:message code="properties.category" /></th>
														<th class="table-text-align-c"><spring:message code="properties.item" /></th>
														<th class="table-text-align-c"><spring:message code="properties.setting_value" /></th>
														<th class="table-text-align-c"><spring:message code="properties.unit" /></th>
														<th class="table-text-align-c"><spring:message code="properties.min_value" /></th>
														<th class="table-text-align-c"><spring:message code="properties.max_value" /></th>
														<th class="table-text-align-c"><spring:message code="properties.short_desc" /></th>
													</tr>
												</thead>
												<tbody>
													<c:set var="i" value="0" />
													<c:choose>
														<c:when test="${empty result.CMD_DBMS_INFO}">
															<tr >
																<td class="table-text-align-c" colspan="8">
																	<spring:message code="properties.msg01" />
																</td>
															</tr>
														</c:when>
														<c:otherwise>
															<c:forEach var="dbmsinfo" items="${result.CMD_DBMS_INFO}">
																 <c:choose>
															       	<c:when test="${dbmsinfo.rnum == '1' && i=='0'}">
																        <tr>
																       		<td>${dbmsinfo.category}</td>
																			<td>${dbmsinfo.name}</td>
																			<td>
																				<c:choose>
																					<c:when test="${not empty dbmsinfo.min_val && not empty dbmsinfo.max_val}">
																						<c:choose>
																							<c:when test="${dbmsinfo.min_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-danger' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:when test="${dbmsinfo.max_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-info' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:otherwise>
																								${dbmsinfo.setting}
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:otherwise>
																						${dbmsinfo.setting}
																					</c:otherwise>
																				</c:choose>
																			</td>
																			<td>${dbmsinfo.unit}</td>
																			<td>${dbmsinfo.min_val}</td>
																			<td>${dbmsinfo.max_val}</td>
																			<td>${dbmsinfo.short_desc}</td>
																		</tr>
															       	</c:when>
 
																	<c:when test="${dbmsinfo.rnum > '1' && i=='0'}">
																		<tr>
																			<td rowspan="${dbmsinfo.rnum}">${dbmsinfo.category}</td>
																			<td>${dbmsinfo.name}</td>
																			<td>
																				<c:choose>
																					<c:when test="${not empty dbmsinfo.min_val && not empty dbmsinfo.max_val}">
																						<c:choose>
																							<c:when test="${dbmsinfo.min_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-danger' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:when test="${dbmsinfo.max_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-info' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:otherwise>
																								${dbmsinfo.setting}
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:otherwise>
																						${dbmsinfo.setting}
																					</c:otherwise>
																				</c:choose>
																			</td>
																			<td>${dbmsinfo.unit}</td>
																			<td>${dbmsinfo.min_val}</td>
																			<td>${dbmsinfo.max_val}</td>
																			<td>${dbmsinfo.short_desc}</td>
																		</tr>
																		<c:set var="i" value="1" />
																	</c:when>
															       
															       <c:when test="${dbmsinfo.rnum >= '1' && i!='0'}">
																       <tr>
																			<td>${dbmsinfo.name}</td>
																			<td>
																				<c:choose>
																					<c:when test="${not empty dbmsinfo.min_val && not empty dbmsinfo.max_val}">
																						<c:choose>
																							<c:when test="${dbmsinfo.min_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-danger' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:when test="${dbmsinfo.max_val eq dbmsinfo.setting}">
																								<div class='badge badge-light text-info' style='background-color: transparent !important;'>
																									${dbmsinfo.setting}
																								</div>
																							</c:when>
																							<c:otherwise>
																								${dbmsinfo.setting}
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:otherwise>
																						${dbmsinfo.setting}
																					</c:otherwise>
																				</c:choose>
																			</td>
																			<td>${dbmsinfo.unit}</td>
																			<td>${dbmsinfo.min_val}</td>
																			<td>${dbmsinfo.max_val}</td>
																			<td>${dbmsinfo.short_desc}</td>
																		</tr>
																		<c:if test="${dbmsinfo.rnum == 1}">
																			<c:set var="i" value="0" />
							 											</c:if>	
															       </c:when>
															  	</c:choose>
															</c:forEach>
														</c:otherwise>
													</c:choose>	
												</tbody>
											</table>
										</div>
									</div>
								</div>

								<div class="tab-pane fade show active" role="tabpanel" id="tablespaceinfoDiv" style="display:none;">
									<div class="form-group row div-form-margin-z system-tlb-scroll" style="margin-top:-10px;">
										<div class="col-md-12" style="border:0px;margin-bottom:-15px;">
											<h5 class="card-title">
												<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="properties.tablespace_info" />
											</h5>
										</div>

										<div class="col-md-12 table-responsive system-tlb-scroll" style="border:0px;height:500px;overflow: auto;">
											<table id="mainEnvSettingList" class="table table-bordered system-tlb-scroll" style="width:100%;">
												<colgroup>
													<col style="width: 10%;">
													<col style="width: 7%;">
													<col style="width: 6%;">
													<col style="width: 7%;">
													<col style="width: 8%;">
													<col style="width: 10%;">
													<col style="width: 8%;">
													<col style="width: 8%;">
													<col style="width: 11%;">
													<col style="width: 8%;">
													<col style="width: 7%;">
													<col style="width: 10%;">
												</colgroup>
												<thead>
													<tr class="bg-info text-white">
														<th class="table-text-align-c" colspan="6"><spring:message code="properties.filesystem" /></th>
														<th class="table-text-align-c" colspan="6"><spring:message code="properties.tablespace" /></th>
													</tr>
													<tr class="bg-info text-white">
														<td class="table-text-align-c">Mounted on</td>
														<td class="table-text-align-c">Filesystem</td>
														<td class="table-text-align-c">Size</td>
														<td class="table-text-align-c">Used</td>
														<td class="table-text-align-c">Avail</td>
														<td class="table-text-align-c">Use%</td>
														
														<td class="table-text-align-c">Name</td>
														<td class="table-text-align-c">Owner</td>
														<td class="table-text-align-c">Location</td>
														<td class="table-text-align-c">Options</td>
														<td class="table-text-align-c">Size</td>
														<td class="table-text-align-c">Description</td>
													</tr>
												</thead>
												<tbody>
													<c:set var="iTable" value="0" />
													<c:choose>
														<c:when test="${empty result.CMD_TABLESPACE_INFO}">
															<tr>
																<td class="table-text-align-c" colspan="12">
																	<spring:message code="properties.msg01" />
																</td>
															</tr>
														</c:when>
														<c:otherwise>
															<c:forEach var="tablespaceinfo" items="${result.CMD_TABLESPACE_INFO}">
																<tr>
																	<td>${tablespaceinfo.mounton}</td>
																	<td>${tablespaceinfo.filesystem}</td>
																	<td id="tablespaceinfoFSizeTd_${iTable}"></td>
																	<td id="tablespaceinfoUsedTd_${iTable}"></td>
																	<td id="tablespaceinfoAvailTd_${iTable}"></td>
																	<td id="tablespaceinfoUseTd_${iTable}">
																		<div class='row' style='width:150px;'>
																			<div class='col-8'>
																				<c:choose>
																					<c:when test="${not empty tablespaceinfo.use}">
																						<c:choose>
																							<c:when test="${iTable % 2 == 0}">
																								<div class='progress progress-lg mt-2' style='width:100%;'>
																									<div id='prgUse_${iTable}' class='progress-bar bg-info progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>
																								</div>
																							</c:when>
																							<c:when test="${dbmsinfo.max_val eq dbmsinfo.setting}">
																								<div class='progress progress-lg mt-2' style='width:100%;'>
																									<div id='prgUse_${iTable}' class='progress-bar bg-danger progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>
																								</div>
																								
																							</c:when>
																						</c:choose>
																					</c:when>
																				</c:choose>
																			</div>
																			<div class='col-4' style='text-align: left;margin-left: -8px; margin-top: 6px;'>
																				${tablespaceinfo.use}
																			</div>
																		</div>
																		<input type='hidden' name='autoLevel' value='' />
																	</td>

																	<td>${tablespaceinfo.name}</td>
																	<td>${tablespaceinfo.owner}</td>
																	<td>${tablespaceinfo.location}</td>
																	<td>${tablespaceinfo.options}</td>
																	<td id="tablespaceinfoSizeTd_${iTable}"></td>

																	<td>${tablespaceinfo.description}</td>
																</tr>
																
																<c:set var = "iTable" value="${iTable + 1}" />
															</c:forEach>
														</c:otherwise>
													</c:choose>	
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>