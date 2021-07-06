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
	* @Class Name : proxyMonitoring.jsp
	* @Description : experdbProxy Monitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*	2021.03.02           윤정 매니저   		최초 생성
	*/
%>
<STYLE TYPE="text/css">
.proxyLog td {
	font-size: 50pt;
}

.blinking{ 
 -webkit-animation:blink 5.0s ease-in-out infinite alternate; 
 -moz-animation:blink 1.0s ease-in-out infinite alternate; 
 animation:blink 3.0s ease-in-out infinite alternate;
} 

.txt_line { width:70px; padding:0 5px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

@-webkit-keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
} 

@-moz-keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
} 

@keyframes blink{ 
 0% {opacity:0;} 
 100% {opacity:1;} 
}
</STYLE>

<script>
	var shown = true;
	var proxyLogTable = "";
	var proxyConfigCngLogTable = "";
	var proxyStatTable = "";
	var select_pry_svr_id = "";
	var cng_pry_svr_id = "";
	var act_sys_type = "";
	var aut_id = "";
	var todayYN = "";
	var proxyServerTotInfo_cnt = "";
	var kal_install_yn = "";
	
	var reload_nom = "0";
	
	/* ********************************************************
	 * 화면 onload
	 ******************************************************** */
	$(window).ready(function(){
		//금일 날짜 setting
		fn_todaySetting();
		
		//서버정보 리스트 setting
		fn_serverListSetting();

		// 프록시 log 테이블
		fn_proxy_log_init();

		// config 파일 수정 이력 테이블
		fn_config_cng_log_init();
		
		// 프록시 리스너 통계 테이블
		fn_proxy_stat_init();
		
		// 권한 id 넣기
		aut_id = "${aut_id}";
		
		//tooltip setting
		setTimeout(function(){
			$('[data-toggle="tooltip"]').tooltip({
				template: '<div class="tooltip tooltip-warning" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
			});
		},250);
		
		// 1분에 한번씩 reload
// 		setInterval(function() {
// 			var rowChkCnt = $("#serverSsChkNum", "#proxyMonViewForm").val();
// 			fn_proxySvrSsSearch(select_pry_svr_id, rowChkCnt);
// 			console.log(rowChkCnt);
// 			$("#serverSs1").click();
// 		}, 10000);
	});

	/* ********************************************************
	* 프록시 세부내역 조회
	******************************************************** */
	function fn_proxySvrReloadSearch() {

		//db서버 정보
		$.ajax({
			url : '/proxyMonitoring/selectReloadMonitoring.do',
			type : 'post',
			data : {
			},
			dataType : 'json',
			success : function(result) {
				// 프록시 모니터링 초기화 및 데이터 셋팅
				fn_serverListReloadSetting(result);
				fn_proxy_loadbar("stop");
			},
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
			}
		});
		$("#loading").hide();
	}

	/* ********************************************************
	 * 서버 리스트 셋팅
	 ******************************************************** */
	function fn_serverListReloadSetting(result){

		aut_id = result.aut_id;

		var rowCount = 0;
		var MstRowCount = 0;

		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		
		var html = "";
		proxyServerTotInfo_cnt = result.proxyServerTotInfo.length;

		if (proxyServerTotInfo_cnt == 0) {
			html += "<div class='col-md-12 grid-margin stretch-card'>\n";
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="eXperDB_proxy.msg40" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
			html += '</div>\n';
		} else {
			for(var i = 0; i < proxyServerTotInfo_cnt; i++){
				master_gbn = nvlPrmSet(result.proxyServerTotInfo[i].master_gbn, '');
				rowCount = rowCount + 1;
				listCnt = parseInt(proxyServerTotInfo_cnt);
				pry_svr_id_val = nvlPrmSet(result.proxyServerTotInfo[i].pry_svr_id, '');

				if (pry_svr_id == "") {
					html += '<div class="col-md-12 grid-margin stretch-card">\n';
					html += '	<div class="card news_text">\n';
					html += '		<div class="card-body" id="serverSs'+ rowCount +'" onClick="fn_getProxyInfo(' + pry_svr_id_val + ', '+ rowCount +')" style="cursor:pointer;">\n';
					html += '			<div class="row">\n';
				} else if(pry_svr_id != nvlPrmSet(result.proxyServerTotInfo[i].pry_svr_id, '')  && master_gbn == "M") {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto;">\n';
					html += '				<i class="mdi mdi-server icon-md mb-0 mb-md-3 mb-xl-0 text-info" id="iProxy' + pry_svr_id_val + '" style="font-size: 3.0em;"></i>\n';
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
	 				if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
					} else if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == 'TC001501') { // TC001501
	 	 				html += '					<div class="badge badge-pill badge-success" title="">M</div>\n';
	 				} else if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == 'TC001502') { // TC001502
	 	 				html += '					<div class="badge badge-pill badge-danger">M</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					' + result.proxyServerTotInfo[i].pry_svr_nm + '<br/></h5>\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
	 				html += '					(' + result.proxyServerTotInfo[i].ipadr + ')</h6>\n';
	 			}

				if (master_gbn == "S") {
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;padding-top:10px;">\n';
					if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				} else if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == 'TC001501') {
	 	 				html += '					<div class="badge badge-pill badge-success">S</div>\n';
	 				} else if (nvlPrmSet(result.proxyServerTotInfo[i].exe_status, '') == 'TC001502') {
	 	 				html += '					<div class="badge badge-pill badge-danger">S</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					' + result.proxyServerTotInfo[i].pry_svr_nm + '<br/></h6>';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:64px;">';
	 				html += '					(' + result.proxyServerTotInfo[i].ipadr + ')</h6>';
	 			}

				if (rowCount == listCnt) {
					html += '				</div>\n';
					html += '			</div>\n';
					html += '			<div class="col-sm-3" style="margin:auto;">\n';
					html += '				<i class="mdi mdi-server icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
				}

				pry_svr_id = nvlPrmSet(result.proxyServerTotInfo[i].pry_svr_id, '') ;
			}
		}

		$("#serverTabList").html(html);
		$("#serverSsCnt", "#proxyMonViewForm").val(proxyServerTotInfo_cnt);

		//첫번쨰 proxy 자동클릭
		if (proxyServerTotInfo_cnt > 0) {
			//첫번쨰 proxy 자동클릭 - fn_getProxyInfo
			$("#serverSs" + Number(reload_nom)).click();
		}
		
	}
	

	/* ********************************************************
	 * rowspan
	 ******************************************************** */
	$.fn.rowspan = function(colIdx, isStats){
		return this.each(function(){      
		    var that;     
		    $('tr', this).each(function(row) {      
		        $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
		            if ($(this).html() == $(that).html() && $(this).prev().html() == $(that).prev().html()) {            
		                rowspan = $(that).attr("rowspan") || 1;
		                rowspan = Number(rowspan)+1;
		 
		                $(that).attr("rowspan",rowspan);
		                    
		                // do your action for the colspan cell here            
		                $(this).hide();
		                    
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
	
	/* ********************************************************
	 * 화면시작 오늘날짜 셋팅
	 ******************************************************** */
	function fn_todaySetting() {
		today = new Date();
		var today_date = new Date();

		var today_ing = today.toJSON().slice(0,10).replace(/-/g,'-');
		var dayOfMonth = today.getDate();
		today_date.setDate(dayOfMonth - 7);

		var html = "<i class='fa fa-calendar menu-icon'></i> "+today_ing;

		$( "#tot_listner_his_today" ).append(html);	
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
		var prev_master_gbn = "";
		
		proxyServerTotInfo_cnt = "${fn:length(proxyServerTotInfo)}";

		if (proxyServerTotInfo_cnt == 0) {
			html += "<div class='col-md-12 grid-margin stretch-card'>\n";
			html += "	<div class='card'>\n";
			html += '		<div class="card-body">\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
			html += '				<spring:message code="eXperDB_proxy.msg40" /></h5>\n';
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
					html += '				<i class="mdi mdi-server icon-md mb-0 mb-md-3 mb-xl-0 text-info" id="iProxy' + pry_svr_id_val + '" style="font-size: 3.0em;"></i>\n';
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
	 				if (nvlPrmSet("${serverinfo.exe_status}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
					} else if (nvlPrmSet("${serverinfo.exe_status}", '') == 'TC001501') { // TC001501
	 	 				html += '					<div class="badge badge-pill badge-success" title="">M</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.exe_status}", '') == 'TC001502') { // TC001502
	 	 				html += '					<div class="badge badge-pill badge-danger">M</div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<c:out value="${serverinfo.pry_svr_nm}"/><br/></h5>\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
	 				html += '					(<c:out value="${serverinfo.ipadr}"/>)</h6>\n';
	 			}
	 			
	 			if((rowCount == 1 && master_gbn == "S") || (prev_master_gbn == "S" && master_gbn == "S")) {
					html += '			<div class="col-sm-9">';
	 				html += '				<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">\n';
	 				if (nvlPrmSet("${serverinfo.exe_status}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				} else {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				}
	 				html += '					<spring:message code="eXperDB_proxy.msg43"/><br/></h6>\n';
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;">\n';
	 				html += '					</h6>\n';
	 			}

				if (master_gbn == "S") {
	 				html += '					<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:32px;padding-top:10px;">\n';
					
	 				if (nvlPrmSet("${serverinfo.exe_status}", '') == '') {
	 	 				html += '					<div class="badge badge-pill badge-warning"><i class="fa fa-times text-white"></i></div>\n';
	 				} else if (nvlPrmSet("${serverinfo.exe_status}", '') == 'TC001501') {
	 	 				html += '					<div class="badge badge-pill badge-success">S</div>\n';
	 				} else if (nvlPrmSet("${serverinfo.exe_status}", '') == 'TC001502') {
	 	 				html += '					<div class="badge badge-pill badge-danger">S</div>\n';
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
					html += '				<i class="mdi mdi-server icon-md mb-0 mb-md-3 mb-xl-0 text-info" style="font-size: 3.0em;"></i>\n';
					html += '			</div>\n';
					html += "		</div>\n";
					html += "		</div>\n";
					html += "	</div>\n";
					html += '</div>\n';
					
				}

				pry_svr_id = nvlPrmSet("${serverinfo.pry_svr_id}", '') ;
				prev_master_gbn = master_gbn;
				
			</c:forEach>
		}

		$("#serverTabList").html(html);
		$("#serverSsCnt", "#proxyMonViewForm").val(proxyServerTotInfo_cnt);

		//첫번쨰 proxy 자동클릭
		if (proxyServerTotInfo_cnt > 0) {
			
			//첫번쨰 proxy 자동클릭 - fn_getProxyInfo
			$("#serverSs1").click();
			$("#reg_pry_title").show();
			$("#reg_pry_detail").show();
			$("#no_reg_pry_title").hide();
			$("#no_reg_pry_detail").hide();
		} else {
			$("#reg_pry_title").hide();
			$("#reg_pry_detail").hide();
			$("#no_reg_pry_title").show();
			$("#no_reg_pry_detail").show();
			$("#pry_mas_log_btn").hide();
		}
	}

	/* ********************************************************
	* 프록시 서버 정보 클릭
	******************************************************** */
	function fn_getProxyInfo(pry_svr_id, rowChkCnt) {
		var obj = $('#loading_dash');
		var iHeight = (($(window).height() - obj.outerHeight()) / 2) + $("#contentsDiv").scrollTop();
		var iWidth = (($(window).width() - obj.outerWidth()) / 2) + $("#contentsDiv").scrollLeft();
		obj.css({
	        position: 'absolute',
	        display:'block',
	        top: iHeight,
	        left: iWidth
	    });

	    $('#loading_dash').show();

	    //chart 초기화
	    $("#listenerStatChart").html("");

		//초기화
		var serverSsCnt_chk = parseInt(nvlPrmSet($("#serverSsCnt", "#proxyMonViewForm").val(),0));
		
		if (serverSsCnt_chk > 0) {
			for (var i = 1; i <= serverSsCnt_chk; i++) {
				$("#serverSs" + i).css('background-color','#fff');
			}
		}
		
		$("#serverSs" + rowChkCnt).css('background-color','#c2defe');
		
		reload_nom = rowChkCnt;
		
		fn_proxySvrSsSearch(pry_svr_id, rowChkCnt);
		select_pry_svr_id = pry_svr_id;
		
		setTimeout(function(){
			$('[data-toggle="tooltip"]').tooltip({
				template: '<div class="tooltip tooltip-warning" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
			});
		},250);
		
	}
	
	/* ********************************************************
	* 프록시 세부내역 조회
	******************************************************** */
	function fn_proxySvrSsSearch(pry_svr_id, rowChkCnt) {
		fn_proxy_loadbar("start");		
		
		//db서버 정보
		$.ajax({
			url : '/proxyMonitoring/selectInfoByPrySvrId.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
			},
			dataType : 'json',
			success : function(result) {
				// 프록시 모니터링 초기화 및 데이터 셋팅
// 				if(result.proxy_agent_status == "N"){
//  		 			showSwalIconRst('<spring:message code="eXperDB_proxy.msg42" />', '<spring:message code="common.close" />', '', 'error');
// 				}
				fn_proxyMonitoringInit(pry_svr_id, result);
				fn_proxy_loadbar("stop");
			},
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
			}
		});
		$("#loading").hide();
		//선택 server row
		$("#serverSsChkNum", "#proxyMonViewForm").val(rowChkCnt);
	}

	/* ********************************************************
	* 프록시 서버정보 상세 설정
	******************************************************** */
	function fn_proxyMonitoringInit(pry_svr_id, result) {
		// vip 모니터링
		fn_keepMonInfo(result);
		
		// 프록시 모니터링 setting
		fn_proxyMonInfo(result);
		
		// 프록시 연결 db 모니터링 setting
		fn_dbMonInfo(result);

		//서버 기록 테이블 설정
		proxyLogTable.clear().draw();
		if (nvlPrmSet(result.proxyLogList, '') != '') {
			proxyLogTable.rows.add(result.proxyLogList).draw();
		}
		$('#proxyLog').css('min-height','100px');

		// 프록시 리스너 통계 테이블
		fn_lsnStat(pry_svr_id);
		
		//통계리스트 html 설정
		fn_proxyMonChartSet(result);
		
		// 프록시 리스너 차트
		fn_lsnStat_chart(pry_svr_id);
		
		// config 파일 변경 이력 테이블
		proxyConfigCngLogTable.clear().draw();
		if(nvlPrmSet(result.selectPryCngList, '') != '') {
			proxyConfigCngLogTable.rows.add(result.selectPryCngList).draw();
		}
		
	}
	
	/* ********************************************************
	* vip 모니터링 셋팅
	******************************************************** */
	function fn_keepMonInfo(result){
		var rowCount = 0;
		var html_vip = "";
		var html_sebu = "";
		var html_vip_line = "";
		var html_listner = "";
		var master_gbn = "";
 		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		var proxyServerByMasId_cnt = result.proxyServerByMasId.length;
		var master_state = "";
		var exe_status_chk = "";
		var kal_exe_status_chk = "";
		var exe_status_css = "";
		var kal_exe_status_css = "";
		var strVip = "";
		
		//ROW 만들기
		for(var i = 0; i < proxyServerByMasId_cnt; i++){
			var agent_status = result.proxyServerByMasId[i].conn_result;
 			//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임
 			
			html_vip += '	<p class="card-title" style="margin-bottom:-25px;margin-left:10px;">\n';
			html_vip += '	<span id="vip_proxy_nm' + i + '"></span>\n';
			html_vip += '	</p>\n';
			
			html_vip += '	<table class="table-borderless" style="width:100%;">\n';
			html_vip += '		<tr>\n';

			html_vip += '			<td style="width:80%;height:225px;" class="text-center" id="keepVipDiv' + i + '">\n';
			html_vip += '			&nbsp;</td>\n';

			html_vip += '		</tr>\n';
			html_vip += '	</table>\n';
 			if(i == 0) {
				html_vip_line += '	<p class="card-title" style="margin-bottom:-15px;margin-left:10px;">\n';
 			} else {
				html_vip_line += '	<p class="card-title" style="margin-bottom:-15px;margin-left:10px;padding-top:2rem;">\n';
 			}
			html_vip_line += '	<span>&nbsp;</span>\n';
			html_vip_line += '	</p>\n';
			
			html_vip_line += '	<table class="table-borderless" style="width:100%;">\n';
			html_vip_line += '		<tr>\n';
			
			html_vip_line += '			<td style="width:100%;height:225px;" class="text-center" id="keepVipDivLine' + i + '">\n';
			html_vip_line += '			</td>\n';

			html_vip_line += '		</tr>\n';
			html_vip_line += '	</table>\n';
			
	 		if (i != proxyServerByMasId_cnt-1 && proxyServerByMasId_cnt > 1) {
	 			html_vip += '<hr>\n';
	 			html_vip_line += '<br/>\n';
	 		}
		}

 		$("#proxyMonitoringList").html(html_vip);
		$("#proxyVipConLineList").html(html_vip_line);

		var iVipChkCnt = 0;
 		if (result.proxyServerVipList != null && result.proxyServerVipList.length > 0) {
 			for(var i = 0; i < result.proxyServerVipList.length; i++){
 				var count = 0;
 				if (result.proxyServerVipList[i].kal_install_yn == "Y") {
 					if (result.proxyServerVipList[i].kal_exe_status == "TC001501") {
 						kal_exe_status_chk = "text-primary";
 						kal_exe_status_css = "fa-refresh fa-spin text-success";
						$("#kal_start_btn"+i+"").hide();
						$("#kal_stop_btn"+i+"").show();
 					} else {
 						kal_exe_status_chk = "text-danger";
 						kal_exe_status_css = "fa-times-circle text-danger";
 						$("#kal_start_btn"+i+"").show();
						$("#kal_stop_btn"+i+"").hide();
 					}
 					
 					html_sebu = "";
 					html_vip_line = "";
	 				html_sebu += '				<button type="button" class="btn btn-inverse-warning btn-xs" onclick="fn_configView('+result.proxyServerVipList[i].pry_svr_id+', \'K\')">';
	 				html_sebu += '					<i class="ti-vimeo-alt icon-md mb-0 mb-md-3 mb-xl-0 '+kal_exe_status_chk+'" style="font-size: 5em;margin-top:10px;" ></i>\n';
	 				html_sebu += '				</button>'
	
	 				strVip = result.proxyServerVipList[i].v_ip;

	 				if (strVip != null && strVip != "," && strVip != "") {
	 					//마지막 문자열 제거
	 					if (strVip.charAt(strVip.length-1) == ",") {
	 						strVip = strVip.slice(0,-1);
	 					}

	 					//첫 문자열 제거
	 					if (strVip.substr(0, 1) == ",") {
	 						strVip = strVip.substr(1);
	 					}

	 					var strVipSplit = strVip.split(',');
	 				    for ( var j in strVipSplit ) {
	 				    	var strVipSplit_val = strVipSplit[j].substr(0, strVipSplit[j].indexOf('/'));
			 				html_sebu += '				<h5 class="text-info"><i class="fa '+kal_exe_status_css+' icon-md mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>'
			 				html_sebu += '				' + strVipSplit_val + '</h5>\n';	
	 				    }	
	 				    
		 				//line 생성
		 				if(agent_status == "Y") {
			 				html_vip_line += '					<i class="mdi mdi-swap-horizontal icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;width:100%;" id="vip_line' + i + '"></i>\n';
		 				}
	 				}

	 				for(var j = 0; j < result.proxyServerByMasId.length; j++) {
	 					
	 					kal_install_yn = result.proxyServerByMasId[j].kal_install_yn;
	 					if (result.proxyServerByMasId[j].pry_svr_id == result.proxyServerVipList[i].pry_svr_id) {
							count++;	 						
		 					if (result.proxyServerVipList[i].pry_svr_nm != "") {
		 						var vip_btn_html = "";
		 						vip_btn_html += '<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;&nbsp;' + result.proxyServerVipList[i].pry_svr_nm;
		 						if(aut_id == 1){
		 							if(result.proxyServerVipList[i].kal_exe_status == "TC001501") {
		 								vip_btn_html += '	<input class="btn btn-inverse-danger btn-sm btn-icon-text mdi mdi-lan-connect" style="float: right;" id="kal_stop_btn' + i + '" type="button" onClick="fn_exe_confirm(' + result.proxyServerVipList[i].pry_svr_id + ', \'TC001501\', \'K\', \'' + result.proxyServerVipList[i].agt_cndt_cd + '\')" value="<spring:message code="eXperDB_proxy.act_stop"/>" />';
		 							} else {
		 								vip_btn_html += '	<input class="btn btn-inverse-info btn-sm btn-icon-text mdi mdi-lan-connect" style="float: right;" id="kal_start_btn' + i + '" type="button" onClick="fn_exe_confirm(' + result.proxyServerVipList[i].pry_svr_id + ', \'TC001502\', \'K\', \'' + result.proxyServerVipList[i].agt_cndt_cd + '\')" value="<spring:message code="eXperDB_proxy.act_start"/>" />';
		 							}
		 						}
		 						vip_btn_html +=	'<br/>&nbsp;';
			 					$("#vip_proxy_nm" + j).html(vip_btn_html);
		 					}

		 					$("#keepVipDiv"+ j).html(html_sebu);
		 					if(j > 0){
			 					$("#keepVipDiv" + j).attr('style', "width:80%;height:225px;")
		 					}
		 					$("#keepVipDivLine" + j).html(html_vip_line);
		 					
		 					iVipChkCnt = j;
	 					} else if(count == 0 && j == result.proxyServerByMasId.length-1){
	 						html_sebu = "";
	 		 				var vip_btn_html = "";
	 		 				vip_btn_html += '<br/>&nbsp;';
	 		 		 		html_sebu += '<h5 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i>&nbsp;<spring:message code="eXperDB_proxy.msg39"/> </h5>';
	 						$("#vip_proxy_nm" + j).html(vip_btn_html);
		 					$("#keepVipDiv"+ j).html(html_sebu);
		 	 				$("#keepVipDiv" + j).attr('style', "width:80%;height:220px;")
		 					$("#keepVipDivLine" + j).html(html_vip_line);
		 					$("#vip_line0","#keepVipDivLine" + j).hide();
	 					}
	 				}
 				} else {
 	 				html_sebu = "";
 	 				var vip_btn_html = "";
 	 				vip_btn_html += '<br/>&nbsp;';
 	 		 		html_sebu += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 2em;"></i>&nbsp;<spring:message code="eXperDB_proxy.msg39"/> </h6>';
 					$("#vip_proxy_nm" + i).html(vip_btn_html);
 	 				$("#keepVipDiv" + i).attr('style', "width:80%;height:220px;")
 	 				$("#keepVipDiv" + i).html(html_sebu);
 				}
 			}
 		} else if ( result.proxyServerVipList.length == 0 ){
 			for(var j = 0; j < result.proxyServerByMasId.length; j++) {
				kal_install_yn = result.proxyServerByMasId[j].kal_install_yn;
 				html_sebu = "";
 				var vip_btn_html = "";
 				vip_btn_html += '<br/>&nbsp;';
 		 		html_sebu += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 2em;"></i>&nbsp;<spring:message code="eXperDB_proxy.msg39"/> </h6>';
				$("#vip_proxy_nm" + j).html(vip_btn_html);
 				$("#keepVipDiv" + j).attr('style', "width:80%;height:220px;")
 				$("#keepVipDiv" + j).html(html_sebu);
 			}
 		}
 		
 		//vip 두번째 row가 없는 경우 row size 변경
 		if (result.proxyServerVipList.length  == 1 && proxyServerByMasId_cnt <= 1 && iVipChkCnt < 1) {
 			$("#keepVipDiv" + result.proxyServerVipList.length).attr('style', "width:80%;padding-left:20px;height:30px;");
 			
 			$("#keepVipDivLine" + result.proxyServerVipList.length).attr('style', "width:80%;padding-left:20px;height:30px;");
 		}

		if (master_state == 'TC001501') {
 			setInterval(iDatabase_toggle, 5000);
		}
	}

	/* ********************************************************
	* 프록시 서버 모니터링 셋팅
	******************************************************** */
	function fn_proxyMonInfo(result){
		var html_listner = "";
		var proxyServerByMasId_cnt = result.proxyServerByMasId.length;
		var iProxyChkCnt = 0;
		var iProxyChkTitleCnt = 0;
		var html_pry_title = "";
		var agent_state = "";
		var html_agent = "";
		var html_listner_ss = "";
		var lsn_status_chk = "";
		
		//연결 모니터링
		var html_listner_con = "";
		var html_listner_con_ss = "";
		
		//////////////////////////////////////
		//Proxy 연결 리스너
		for(var i = 0; i < proxyServerByMasId_cnt; i++) {
 			//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임
 			
 			html_listner += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';

			html_listner += '	<span id="proxy_listner_nm' + i + '"></span>\n';
			html_listner += '	</p>\n';
			
			html_listner += '	<table class="table-borderless" style="width:100%;">\n';
			html_listner += '		<tr>\n';
			html_listner += '			<td style="width:15%;padding-left:10px;" class="text-center" id="proxyAgentDiv' + i + '">\n';
			html_listner += '			</td>\n';
			html_listner += '			<td style="width:85%;height:220px;" class="text-center" id="proxyListnerDiv' + i + '">\n';
			html_listner += '			&nbsp;</td>\n';

			html_listner += '		</tr>\n';
			html_listner += '	</table>\n';

 			if (i != proxyServerByMasId_cnt-1 && proxyServerByMasId_cnt > 1) {
 				html_listner += '<hr>\n';
 			}
 			/////////////////////////////////////////////////////////////////////////////////////////////
			if(i == 1){
	 			html_listner_con += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;padding-top:2rem;">\n';
			} else {
	 			html_listner_con += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';
			}

 			html_listner_con += '	<span id="proxy_listner_con_nm' + i + '">&nbsp;<br/></span>\n';
 			html_listner_con += '	</p>\n';
			
 			html_listner_con += '	<table class="table-borderless" style="width:100%;">\n';
 			html_listner_con += '		<tr>\n';
 			html_listner_con += '			<td style="width:100%;height:220px;text-align:center;" id="dbProxyConDiv' + i + '">\n';
 			html_listner_con += '			&nbsp;</td>\n';

 			html_listner_con += '		</tr>\n';
 			html_listner_con += '	</table>\n';

 			if (i != 1 && proxyServerByMasId_cnt > 1) {
 				html_listner_con += '<br/>\n';
 			} 
 			
		}

		$("#proxyListnerMornitoringList").html(html_listner);
		$("#proxyListnerConLineList").html(html_listner_con);
		
		//////////////////////////////////////

		//제목 및 agent 상태
  		for(var j = 0; j < result.proxyServerByMasId.length; j++){
  			html_listner_ss = "";
  			html_listner_con_ss = "";
  			var lsnNulkCnt = 0;
  			var agent_status = result.proxyServerByMasId[j].conn_result;
  			
  			//title
			if (result.proxyServerByMasId[j].pry_svr_nm != "") {
				html_pry_title = '<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info">';
				if(nvlPrmSet(result.proxyServerByMasId[j].exe_status, '') == 'TC001501'){
					html_pry_title += '		<div class="badge badge-pill badge-success" title="">' + result.proxyServerByMasId[j].master_gbn + '</div>\n';
					html_pry_title += '			<a href="#" onclick="fn_configView('+ result.proxyServerByMasId[j].pry_svr_id +', \'P\')">'+result.proxyServerByMasId[j].pry_svr_nm+'</a>\n';
					if(aut_id == 1) {
						html_pry_title += '	<input class="btn btn-inverse-danger btn-sm btn-icon-text mdi mdi-lan-connect" style="float: right;" id="proxy_stop_btn' + j + '" type="button" onClick="fn_exe_confirm(' + result.proxyServerByMasId[j].pry_svr_id + ', \'TC001501\', \'P\', \'' + result.proxyServerByMasId[j].agt_cndt_cd + '\')" value="<spring:message code="eXperDB_proxy.act_stop"/>" />\n';
					}
				} else {
					html_pry_title += '		<div class="badge badge-pill badge-danger" title="">' +  result.proxyServerByMasId[j].master_gbn + '</div>\n';
					html_pry_title += '			<a href="#" onclick="fn_configView('+ result.proxyServerByMasId[j].pry_svr_id +', \'P\')">'+result.proxyServerByMasId[j].pry_svr_nm+'</a>\n';
					if(aut_id == 1) {
						html_pry_title += '	<input class="btn btn-inverse-info btn-sm btn-icon-text mdi mdi-lan-connect" style="float: right;" id="proxy_start_btn' + j + '" type="button" onClick="fn_exe_confirm(' + result.proxyServerByMasId[j].pry_svr_id + ', \'TC001502\', \'P\', \'' + result.proxyServerByMasId[j].agt_cndt_cd + '\')" value="<spring:message code="eXperDB_proxy.act_start"/>" />\n';
					}
				}
				
				html_pry_title += '</h5>\n';

				html_pry_title += '<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:30px;padding-top:3px;">';
				html_pry_title += '		IP : '+result.proxyServerByMasId[j].ipadr+'\n';
				html_pry_title += '</h6>\n';

				$("#proxy_listner_nm" + j).html(html_pry_title);
			}
			
			//agent 상태 체크
			if(result.proxyServerByMasId[j].agt_cndt_cd == 'TC001501' && agent_status == "Y"){
				html_agent = '					<i class="mdi mdi-server-network icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>\n';
				html_agent += '					<h6 class="text-muted"><spring:message code="eXperDB_proxy.agent"/></h6>\n';
			} else {
				html_agent = '					<i class="mdi mdi-server-network icon-md mb-0 mb-md-3 mb-xl-0 text-danger" style="font-size: 3em;"></i>\n';
				html_agent += '					<h6 class="text-muted"><spring:message code="eXperDB_proxy.agent"/></h6>\n';
			}
			
			$("#proxyAgentDiv" + j).html(html_agent);
			
			if (result.proxyServerLsnList.length > 0) {
				var count = 0;
				for(var k = 0; k < result.proxyServerLsnList.length; k++){
					if (result.proxyServerByMasId[j].pry_svr_id == result.proxyServerLsnList[k].pry_svr_id) {
						count++;
						//proxy 리스너 셋팅
						if(nvlPrmSet(result.proxyServerLsnList[k].lsn_exe_status, '') == 'TC001501'){
							lsn_status_chk = "text-primary";
						} else {
							lsn_status_chk = "text-danger";
						}
						html_listner_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
						html_listner_ss += '	<tr>';
						html_listner_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
						
 						html_listner_ss += '			<h5 class="mb-0 mb-sm-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:8%;padding-left:30px;text-align:left;">';
						
						if(nvlPrmSet(result.proxyServerLsnList[k].lsn_exe_status, '') == 'TC001501'){
							html_listner_ss += '			<div class="badge badge-pill badge-success" title="">L</div>\n';
						} else {
							html_listner_ss += '			<div class="badge badge-pill badge-danger" title="">L</div>\n';
						}	
 						html_listner_ss += '			<span data-toggle="tooltip" data-placement="bottom" data-html="true" title=\''+result.proxyServerLsnList[k].lsn_desc+'\'>';
						html_listner_ss += '			'+result.proxyServerLsnList[k].lsn_nm+'\n';
						html_listner_ss += '			</span>\n';
						html_listner_ss += '	</h5>\n';
 					
						html_listner_ss += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="text-align:left;padding-left:30px;padding-top:3px;">';
						html_listner_ss += '				Bind IP : Port(*) : '+result.proxyServerLsnList[k].con_bind_port+'\n';
						html_listner_ss += '			</h6>\n';
						
						html_listner_ss += '		</td>\n';
						html_listner_ss += '	</tr>\n';
						html_listner_ss += '</table>\n';
						
						///////////////////////////////////////////////////////
						// db 연결 셋팅
						html_listner_con_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
						html_listner_con_ss += '	<tr>';
						html_listner_con_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
 
						var db_conn_ip_num = "";
						var db_conn_ip_num_af = "";
						
						//agent가 살아있는 경우, proxy, keep은 kal_agent가 y일때 keepalived가 모두 살아있는 경우, kal_agent 'N' 일때
						if(result.proxyServerByMasId[j].agt_cndt_cd == 'TC001501' &&
							result.proxyServerByMasId[j].exe_status == 'TC001501' &&
							((result.proxyServerByMasId[j].kal_install_yn == '' || result.proxyServerByMasId[j].kal_install_yn != 'Y') ||
							  (result.proxyServerByMasId[j].kal_install_yn == 'Y' && result.proxyServerByMasId[j].kal_exe_status == 'TC001501')) &&
							  agent_status == 'Y'
							){
							if (result.proxyServerLsnList[k].db_conn_ip_num != null) {
								db_conn_ip_num = result.proxyServerLsnList[k].db_conn_ip_num.replace(/,\s*$/, "").replace(/,\s*/,"");
								if (db_conn_ip_num == '1') {
									if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
										//첫번째 오른쪽
										db_conn_ip_num_af = '<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""/>';

									} else {
										//두번째 상단
										db_conn_ip_num_af = '<img src="../images/arrow_up.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
									}
								} else if (db_conn_ip_num == '2') {
									if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
										//첫번째 하단
										db_conn_ip_num_af = '<img src="../images/arrow_down.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
									} else {
										//두번째 row 일자
										db_conn_ip_num_af = '<img src="../images/arrow_side.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
									}
								} else if(db_conn_ip_num != ''){
									//첫번째 row 일자, 하단
									if (k == 0 || (k > 0 && result.proxyServerLsnList[k-1].pry_svr_id != result.proxyServerLsnList[k].pry_svr_id)) {
										db_conn_ip_num_af = '<img src="../images/arrow_side_down.png" class="img-lg" style="max-width:120%;object-fit: contain;" alt=""  />';
									} else {
										//두번째 row 일자, 상단
										db_conn_ip_num_af = '<img src="../images/arrow_up_side.png" class="img-lg"  style="max-width:120%;object-fit: contain;" alt=""  />';
									}
								}
							}
						}

						html_listner_con_ss += '		<span class="image blinking"> '+db_conn_ip_num_af+' </span>\n';

						html_listner_con_ss += '		</td>\n';
						html_listner_con_ss += '	</tr>\n';
						html_listner_con_ss += '</table>\n';
						
						lsnNulkCnt ++;
					} else if(k == result.proxyServerLsnList.length-1 && count == 0){
						html_listner_ss = "";
		 				html_listner_ss += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i><spring:message code="eXperDB_proxy.msg41"/> </h6>';
		 				$("#proxyListnerDiv" + j).html(html_listner_ss);
					}
				}

 				if (lsnNulkCnt < 2) {
					html_listner_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_listner_ss += '	<tr>';
					html_listner_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
					html_listner_ss += '		&nbsp;</td>\n';
					html_listner_ss += '	</tr>\n';
					html_listner_ss += '</table>\n';
					
					html_listner_con_ss += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_listner_con_ss += '	<tr>';
					html_listner_con_ss += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
					html_listner_con_ss += '		&nbsp;</td>\n';
					html_listner_con_ss += '	</tr>\n';
					html_listner_con_ss += '</table>\n';
				}
				lsnNulkCnt = 0;

				$("#proxyListnerDiv" + j).html(html_listner_ss);
				$("#dbProxyConDiv" + j).html(html_listner_con_ss);
			} else {
				html_listner_ss = "";
 				html_listner_ss += '<h6 class="bg-inverse-muted" ><i class="mdi mdi-alert-circle-outline text-warning" style="font-size: 1.8em;"></i><spring:message code="eXperDB_proxy.msg41"/> </h6>';
 				$("#proxyListnerDiv" + j).html(html_listner_ss);
			}
		}
	}

	/* ********************************************************
	* 디비 서버 모니터링 셋팅
	******************************************************** */
	function fn_dbMonInfo(result){
		//스탠바이 여러건일때
		//마스터만 있거나 스탠바이만 있는경우 빈칸만들기'
		//proxy 서버별로 해야함
		//값이 아예없는 경우
		//서버 연결상태 지금은 agent 상태로 되어있는데 변경해야함
	
		var rowCount = 0;
		var dbNulkCnt = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		var db_exe_status_chk = "";
		var db_exe_status_css = "";
		var db_exe_status_val = "";
		
		var proxyServerByMasId_cnt = result.proxyServerByMasId.length;
		
		var html_db = "";
		
		//////////////////////////////////////
		//db 연결 리스너
		for(var i = 0; i < proxyServerByMasId_cnt; i++){
 			//vip 한건일때 proxy가 한건이면 2번째 row높이를 줄임
 			
 			html_db += '	<p class="card-title" style="margin-bottom:-5px;margin-left:10px;">\n';

 			html_db += '		<span id="db_proxy_nm' + i + '"></span>\n';
 			html_db += '	</p>\n';
			
 			html_db += '	<table class="table-borderless" style="width:100%;">\n';
 			html_db += '		<tr>\n';
 			html_db += '			<td style="width:100%;height:220px;" id="dbProxyDiv' + i + '">\n';
 			html_db += '			&nbsp;</td>\n';

 			html_db += '		</tr>\n';
 			html_db += '	</table>\n';

 			if (i != 1 && proxyServerByMasId_cnt > 1) {
 				html_db += '<hr>\n';
 			}
		}

		$("#dbListenerVipList").html(html_db);
		//////////////////////////////////////
		
		
		//////////////////////////////////////
		//Proxy 연결 db

		//제목 및 agent 상태
  		for(var j = 0; j < result.proxyServerByMasId.length; j++){
  			html_db = "";
  			//title
			if (result.proxyServerByMasId[j].pry_svr_nm != "") {
				$("#db_proxy_nm" + j).html('<i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;&nbsp;' + result.proxyServerByMasId[j].pry_svr_nm + '<br/>&nbsp;');
			}

 			if (result.dbServerConProxyList != null && result.dbServerConProxyList.length > 0) {
				for(var k = 0; k < result.dbServerConProxyList.length; k++){

					if (result.proxyServerByMasId[j].pry_svr_id == result.dbServerConProxyList[k].pry_svr_id) {
	
						html_db += '<table class="table-borderless" style="width:100%;height:100px;">\n';
						html_db += '	<tr>';
						
						html_db += '		<td colspan="2" style="width:85%;">';

						if(result.dbServerConProxyList[k].master_gbn == 'M'){
							html_db += '		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-top:10px;">';
						} else {
							html_db += '		<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-info" style="padding-left:10px;padding-top:10px;">';
						}
 
						if(result.dbServerConProxyList[k].db_cndt == 'Y'){
							html_db += '		<div class="badge badge-pill badge-success" title="">'+result.dbServerConProxyList[k].master_gbn+'</div>';
						} else {
							html_db += '		<div class="badge badge-pill badge-danger" title="">'+result.dbServerConProxyList[k].master_gbn+'</div>';
						}
						 
						if(result.dbServerConProxyList[k].svr_host_nm != null && result.dbServerConProxyList[k].svr_host_nm != ""){
							if(result.dbServerConProxyList[k].master_gbn == 'M'){
								html_db += '		Master(';
							} else {
								html_db += '		Standby(<a href="#" onclick="fn_standby_view(' + result.dbServerConProxyList[k].db_svr_id + ')">';
							}
							html_db += '			' + result.dbServerConProxyList[k].svr_host_nm;
							if(result.dbServerConProxyList[k].master_gbn == 'M'){
								html_db += '		)';
							} else {
								if(result.dbServerConProxyList[k].cnt_svr_id > 1){
									html_db += '	<spring:message code="eXperDB_proxy.and"/> ' + (result.dbServerConProxyList[k].cnt_svr_id -1) + '<spring:message code="eXperDB_proxy.others"/></a>)';
								} else {
									html_db += '	</a>)';
								}
							}
						} else {
							if(result.dbServerConProxyList[k].master_gbn == 'M'){
								html_db += '		Master';
							} else {
								html_db += '		Standby';
							}
						}
						html_db += '			</h6>';
						html_db += '		</td>';
						
						
						html_db += '		<td rowspan="3" style="width:15%;">';
						if(result.dbServerConProxyList[k].db_cndt == 'Y'){
							html_db += '		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-success" style="font-size: 3em;"></i>\n';
						} else {
							html_db += '		<i class="fa fa-database icon-md mb-0 mb-md-3 mb-xl-0 text-danger" style="font-size: 3em;"></i>';
						}

						html_db += '		</td>';
						
						html_db += '	</tr>';

						html_db += '	<tr>';
						html_db += '		<td colspan="2" style="padding-top:5px;">';

 						if(result.dbServerConProxyList[k].master_gbn == 'M'){
							html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : ' + result.dbServerConProxyList[k].ipadr + '/' + result.dbServerConProxyList[k].portno + '</h6>';
						} else {
							if(result.dbServerConProxyList[k].cnt_svr_id > 1){
								html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;"><spring:message code="eXperDB_proxy.representative_ip"/> : ' + result.dbServerConProxyList[k].ipadr + '</h6>';
							} else {
								html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:20px;">IP/PORT : ' + result.dbServerConProxyList[k].ipadr + '/' + result.dbServerConProxyList[k].portno + '</h6>';
							}
						}
						
						html_db += '		</td>';
						html_db += '	</tr>';
						
						//내부 ip setting
						if(result.dbServerConProxyList[k].intl_ipadr != null && result.dbServerConProxyList[k].intl_ipadr != "") {
							html_db += '	<tr>';
							html_db += '		<td colspan="2" style="padding-top:5px;">';
							html_db += '			<h6 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted" style="padding-left:70px;">(<spring:message code="eXperDB_proxy.internal_ip"/> : ' + result.dbServerConProxyList[k].intl_ipadr + ')</h6>';
							html_db += '		</td>';
							html_db += '	</tr>';
						}

						if(result.dbServerConProxyList[k].db_cndt == 'Y'){
							db_exe_status_chk = "text-success";
							db_exe_status_css = "fa-refresh fa-spin text-success";
							db_exe_status_val = 'running';
						} else {
							db_exe_status_chk = "text-danger";
							db_exe_status_css = "fa-times-circle text-danger";
							db_exe_status_val = 'stop';
						}

						html_db += '	<tr >\n';
						html_db += '		<td colspan="2" class="text-center" style="vertical-align: middle;padding-top:5px;">\n';
						html_db += '			<h6 class="text-muted" style="padding-left:10px;"><i class="fa '+db_exe_status_css+' icon-sm mb-0 mb-md-3 mb-xl-0" style="margin-right:5px;padding-top:3px;"></i>' + db_exe_status_val + '</h6>\n';			
						html_db += '		</td>\n';
						html_db += '	</tr>\n';
						html_db += '	</table>\n';
						
						dbNulkCnt ++;
					}
				}
				 
				if (dbNulkCnt < 2 ) {
					html_db += '<table class="table-borderless" style="width:100%;height:100px;">\n';
					html_db += '	<tr>';
					html_db += '		<td style="width:100%;padding-top:8px;padding-bottom:3px;">';
					html_db += '		&nbsp;</td>\n';
					html_db += '	</tr>\n';
					html_db += '</table>\n';
				}

				dbNulkCnt = 0;
				
				$("#dbProxyDiv" + j).html(html_db);
			}
  		}
	}

	/* ********************************************************
	* db standby ip list 조회
	******************************************************** */
	function fn_standby_view(db_svr_id){
		fn_proxyDBStandbyViewAjax(db_svr_id);
		setTimeout(function(){
			if(proxyDBStandbyListTable != null) proxyDBStandbyListTable.columns.adjust().draw();
		},200);
		$('#pop_db_standby_ip_list_view').modal("show");
		$('#loading').hide();
	}
	
	/* ********************************************************
	* 리스너 상세리스트 조회
	******************************************************** */
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
				if (nvlPrmSet(result.proxyStatisticsInfo, '') != '') {
					for(var i = 0; i < result.proxyStatisticsInfo.length; i++){	
						if(result.proxyStatisticsInfo[i].r == 1){
							if(i != result.proxyStatisticsInfo.length-1 && result.proxyStatisticsInfo[i+1].r == 2){
								result.proxyStatisticsInfo[i].fail_chk_cnt_cng = result.proxyStatisticsInfo[i].fail_chk_cnt-result.proxyStatisticsInfo[i+1].fail_chk_cnt;
								result.proxyStatisticsInfo[i].max_session_cng = result.proxyStatisticsInfo[i].max_session-result.proxyStatisticsInfo[i+1].max_session;
								result.proxyStatisticsInfo[i].cur_session_cng = result.proxyStatisticsInfo[i].cur_session-result.proxyStatisticsInfo[i+1].cur_session;
								result.proxyStatisticsInfo[i].session_limit_cng = result.proxyStatisticsInfo[i].session_limit-result.proxyStatisticsInfo[i+1].session_limit;
								result.proxyStatisticsInfo[i].cumt_sso_con_cnt_cng = result.proxyStatisticsInfo[i].cumt_sso_con_cnt-result.proxyStatisticsInfo[i+1].cumt_sso_con_cnt;
								result.proxyStatisticsInfo[i].byte_receive_cng = result.proxyStatisticsInfo[i].byte_receive-result.proxyStatisticsInfo[i+1].byte_receive;
								result.proxyStatisticsInfo[i].byte_transmit_cng = result.proxyStatisticsInfo[i].byte_transmit-result.proxyStatisticsInfo[i+1].byte_transmit;
							}
							proxyStatTable.row.add(result.proxyStatisticsInfo[i]).draw();
						}
					}
				}

		  		var tableRows = $('#proxyStatTable tbody tr');
		  		if (tableRows.length > 1) {
			  		$('#proxyStatTable').rowspan(0); 
			  		$('#proxyStatTable').rowspan(1); 
		  		}
		  		
			}
		});
	}
	
	/* ********************************************************
	 * 프록시  상태 로그 셋팅	
	 ******************************************************** */
	function fn_proxy_log_init(){
		proxyLogTable = $('#proxyLogTable').DataTable({
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : '<spring:message code="message.msg01" />'
			},
			columns : [
						{data : "pry_svr_nm", 
							render : function(data, type, full, meta) {
								var html = "";
 								html += '<a href="#" onclick="fn_logView(' + full.pry_svr_id + ', \'' + full.sys_type + '\', \'' + full.wrk_dtm + '\', \'' + full.agt_cndt_cd + '\')">'+data+'</a>';
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
									html += 'VIP<br/>Check';
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
									html += '	<i class="fa fa-spinner fa-spin mr-2 icon-sm text-success"></i>';
									html += '	<spring:message code="eXperDB_proxy.act_start"/>';
								} else if(data == 'R') {
									html += '	<i class="fa fa-refresh fa-spin mr-2 icon-sm text-warning"></i>';
									html += '	<spring:message code="eXperDB_proxy.act_restart"/>';
								} else if(data == 'S'){
									html += '	<i class="fa fa-circle-o-notch mr-2 icon-sm text-danger"></i>';
									html += '	<spring:message code="eXperDB_proxy.act_stop"/>';
								}
								return html;
							},
							className : "dt-center", 
							defaultContent : ""
						},
						{data : "exe_rslt_cd", 
							render : function(data, type, full, meta){
								var html = "";
								if(data == 'TC001501'){
									html += "<div class='badge badge-light' style='margin:0px;background-color: transparent !important;font-size: 1rem;'>";
									html += '<i class="item-icon fa fa-check-circle text-primary icon-sm"></i>';
									html += '&nbsp;<spring:message code="common.success" />';
									html += "</div>";
								} else if(data == 'TC001502'){
									html += '<button type="button" class="btn btn-inverse-danger btn-fw" onclick="fn_actExeFailLog(\''+full.pry_act_exe_sn+'\')">';
									html += '<i class="item-icon fa fa-times icon-sm"></i>';
									html += '<spring:message code="common.failed" />';
									html += "</button>";
								}
								
								return html;
							},
							className : "dt-center", 
							defaultContent : ""
						},
						{data : "wrk_dtm", className : "dt-center", defaultContent : ""},
						{data : "rownum", className : "dt-center", defaultContent : "", targets : 0, visible:false, orderable : false},
						{data : "pry_svr_id", className : "dt-center", defaultContent : "", visible: false},
						{data : "pry_act_exe_sn", className : "dt-center", defaultContent : "", visible: false}
			]
		});

		proxyLogTable.tables().header().to$().find('th:eq(0)').css('min-width', '50px'); // proxy server name
		proxyLogTable.tables().header().to$().find('th:eq(1)').css('min-width', '50px'); // proxy or keepavlied
		proxyLogTable.tables().header().to$().find('th:eq(2)').css('min-width', '50px'); // start or restart or stop
		proxyLogTable.tables().header().to$().find('th:eq(3)').css('min-width', '50px'); // manual or system
		proxyLogTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px'); // first reg date
		proxyLogTable.tables().header().to$().find('th:eq(5)').css('min-width', '0px'); //rownum
		proxyLogTable.tables().header().to$().find('th:eq(6)').css('min-width', '0px'); //proxy server id
		proxyLogTable.tables().header().to$().find('th:eq(7)').css('min-width', '0px'); // proxy act exe serial number
		
		$(window).trigger('resize');
	}

	/* ********************************************************
	* config 파일 수정 이력 table
	******************************************************** */
	function fn_config_cng_log_init(){
		proxyConfigCngLogTable = $('#proxyConfigCngLogTable').DataTable({
			searching : false,
			scrollY : true,
			scrollX: true,	
			paging : false,
			deferRender : true,
			info : false,
			sort: false, 
			"language" : {
				"emptyTable" : '<spring:message code="message.msg01" />'
			},
			columns : [
				{data : "rownum", className : "dt-center", defaultContent : "", visible: false},
				{data : "pry_svr_id", className : "dt-center", defaultContent : "", visible: false},
				{data : "pry_svr_nm", className : "dt-center", defaultContent : "" },
				{data : "exe_rst_cd", 
					render : function(data, type, full, meta){
						var html = "";
						if(data == 'TC001501'){
							html += "<div class='badge badge-light' style='margin:0px;background-color: transparent !important;font-size: 1rem;'>";
							html += '<i class="item-icon fa fa-check-circle text-primary icon-sm"></i>';
							html += '&nbsp;<spring:message code="common.success" />';
							html += "</div>";
						} else if(data == 'TC001502'){
							html += '<div class="badge badge-light" style="margin:0px;background-color: transparent !important;font-size: 1rem;">';
							html += '<i class="item-icon fa fa-times text-danger icon-sm"></i>';
							html += '&nbsp;<spring:message code="common.failed" />';
							html += "</div>";
						}
						return html;
					},
					className : "dt-center", 
					defaultContent : ""
				},
				{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "" },
			]
		});
		
		proxyConfigCngLogTable.tables().header().to$().find('th:eq(0)').css('min-width', '0px'); // rownum
		proxyConfigCngLogTable.tables().header().to$().find('th:eq(1)').css('min-width', '0px'); // proxy server id
		proxyConfigCngLogTable.tables().header().to$().find('th:eq(2)').css('min-width', '50px'); // proxy server name
		proxyConfigCngLogTable.tables().header().to$().find('th:eq(3)').css('min-width', '50px'); // success or fail
		proxyConfigCngLogTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px'); // first reg date
		
		$(window).trigger('resize');
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
				"emptyTable" : '<spring:message code="message.msg01" />'
			},
			columns : [
						{data : "pry_svr_nm", className : "dt-center", defaultContent : ""},
						{data : "lsn_nm", className : "dt-center", defaultContent : ""},
						{data : "db_con_addr",
							render : function(data, type, full, meta){
								var html = "";
								if(full.master_gbn == "M"){
									html += '<i class="mdi mdi-chart-bar text-warning"></i>';					
								}
								
						//		INTL_IPADR
								html += full.db_con_addr;
								
								if (full.intl_ipadr != null && full.intl_ipadr != "") {
									html += "<br/>(" + full.intl_ipadr + ")";
								}
						
								return html;
							},
							className : "dt-center", defaultContent : ""
						},
						{data : "svr_status", 
							render : function(data, type, full, meta){
								var html = "";
								if(data == 'UP'){
									html += '<div class="badge badge-pill badge-success">';
									html += '	<i class="fa fa-spin fa-spinner mr-2" style="font-size:1em;"></i>';
									html += '<spring:message code="eXperDB_proxy.status_up" />('+full.lst_status_chk_desc.substring(0, 2)+')';
									html += '</div>';
								} else if(data == 'DOWN'){
									html += '<div class="badge badge-pill badge-danger">';
									html += '	<i class="fa fa-circle-o-notch mr-2" style="font-size:1em;"></i>';
									html += '<spring:message code="eXperDB_proxy.status_down" />('+full.lst_status_chk_desc.substring(0, 2)+')';
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
						{data : "cur_session", 
							render : function(data, type, full, meta){
								var html = "";
								html += '<div>'+data;
								if(full['cur_session_cng'] > 0){
									html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success" style="font-size: 1rem;"></i>'+full['cur_session_cng']+')';
								} else if(full['cur_session_cng'] == 0 || typeof full['cur_session_cng'] === 'undefined') {
									html += '(<i class="mdi mdi-minus menu-icon text-muted" style="font-size: 1rem;"></i>0)'
								} else {
									html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger" style="font-size: 1rem;"></i>'+full['cur_session_cng']+')'
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
						},
						{data : "rownum", className : "dt-center", visible : false, defaultContent : ""},
						{data : "idx", className : "dt-center", visible : false, defaultContent : ""},
						{data : "pry_svr_id", className : "dt-center", visible : false, defaultContent : ""}
			]
		});


		proxyStatTable.tables().header().to$().find('th:eq(0)').css('min-width','145px');
		proxyStatTable.tables().header().to$().find('th:eq(1)').css('min-width','90px');
		proxyStatTable.tables().header().to$().find('th:eq(2)').css('min-width','105px');
		proxyStatTable.tables().header().to$().find('th:eq(3)').css('min-width','90px');
		proxyStatTable.tables().header().to$().find('th:eq(4)').css('min-width','70px');
		proxyStatTable.tables().header().to$().find('th:eq(5)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(6)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(7)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(8)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(9)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(10)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(11)').css('min-width','30px');
		proxyStatTable.tables().header().to$().find('th:eq(12)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(13)').css('min-width','0px');
		proxyStatTable.tables().header().to$().find('th:eq(14)').css('min-width','0px');
		
		$(window).trigger('resize');
	}

	/* ********************************************************
	* 통계리스트 html 설정
	******************************************************** */
	function fn_proxyMonChartSet(result){
		var html = "";
		var chartCnt = 0;

		html += '<div class="col-md-12 col-xl-12 justify-content-center" >\n';
		html += '	<div class="card" style="margin-left:-10px;border:none;">\n';
		html += '		<div class="card-body" style="border:none;">\n';
		html += '			<p class="card-title" style="margin-bottom:0px"><i class="item-icon mdi mdi-chart-bar text-info"></i>&nbsp;<spring:message code="eXperDB_proxy.listener_statistics"/>&nbsp;&nbsp;   &nbsp;<span class="text-info"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i><spring:message code="eXperDB_proxy.msg4"/></span>&nbsp;</p>\n';
		html += '		</div>\n';
		html += '	</div>\n';
		html += '</div>\n';
		
		if (result.proxyChartCntList != null && result.proxyChartCntList.length > 0) {
			$(result.proxyChartCntList).each(function (index, item) {
				chartCnt ++;
				
				html += '<div class="col-md-6 col-xl-6 justify-content-center">\n';
				html += '	<div class="card" style="margin-left:-10px;border:none;">\n';
				html += '		<div class="card-body" style="border:none;margin-top:-35px;">\n';
				html += '			<p class="card-title" style="margin-bottom:0px;margin-left:10px;"><i class="item-icon fa fa-toggle-right text-info"></i>&nbsp;' + item.pry_svr_nm + '-' + item.lsn_nm + '-' + item.db_con_addr +'</p>\n';
				html += '			<div id="chart-line-' + chartCnt + '" style="max-height:200px;"></div>\n';
				html += '		</div>\n';
				html += '	</div>\n';
				html += '</div>\n';
				
				if ( chartCnt % 2 == 0 ) {
					html += '<div class="col-md-12">\n';
					html += '	<div class="card" style="border:none;">\n';
					html += '		&nbsp;</div>\n';
					html += '</div>\n';
				}
			});
		} else {
			html += '<div class="col-md-3 col-xl-12 justify-content-center">\n';
			html += "	<div class='card'>\n";
			html += '		<div class="card-body"  style="background-color:#ededed;>\n';
			html += '			<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">\n';
			html += '				<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted text-center"">\n';
			html += '				<spring:message code="message.msg01" /></h5>\n';
			html += '			</div>\n';
			html += "		</div>\n";
			html += "	</div>\n";
			html += "</div>\n";
		}

		$("#chartCnt").val(chartCnt);
		$("#listener_header_sub").html(html);
	}

	/* ********************************************************
	* 리스너 통계차트 생성
	******************************************************** */
	function fn_lsnStat_chart(pry_svr_id){
		$.ajax({
			url : '/proxyMonitoring/listenerStatisticsChart.do', 
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
		  		if(result.proxyStatisticsInfoChart != null && result.proxyStatisticsInfoChart.length > 0){
		  			var chartCntLoad = $("#chartCnt").val();
		  			if (chartCntLoad > 0) {
			  			for(var i = 0; i < chartCntLoad; i++){
			  				if ($('#chart-line-' + (i+1)).length) {
			  					var statchart = Morris.Line({
			  				    					element: 'chart-line-' + (i+1),
			  				    					lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
			  				    					data: [
			  				    							{
			  				    								exe_dtm_ss: '',
			  				  									byte_receive: 0,
			  				  									byte_transmit: 0,
			  				  									cumt_sso_con_cnt: 0,
			  				  									fail_chk_cnt: 0
				  										    }
													],
													xkey: 'exe_dtm_ss',
													xkeyFormat: function(exe_dtm_ss) {
														return exe_dtm_ss.substring(10);
													},
													ykeys: ['byte_receive', 'byte_transmit', 'cumt_sso_con_cnt', 'fail_chk_cnt'],
													labels: ['<spring:message code="eXperDB_proxy.chart_byte_in"/>', '<spring:message code="eXperDB_proxy.chart_byte_out"/>', '<spring:message code="eXperDB_proxy.chart_session_total"/>', '<spring:message code="eXperDB_proxy.chart_health_check_failed"/>']
  			  					});
			  					
	 		  					var proxyStatChart = [];

			  					for(var j = 0; j<result.proxySettingChartresult.length; j++){
			  						if (result.proxyStatisticsInfoChart[j].dense_row_num == (i+1)) {
				  						proxyStatChart.push(result.proxySettingChartresult[j]);
				  						statchart.setData(proxyStatChart);
			  						}
			  					}
			  					
			  				}
			  			}
		  			}
		  		}
			}
		});
	}

	/* ********************************************************
	* 시스템  중지 / 시작
	******************************************************** */
	function fn_act_exe_cng(pry_svr_id, type, status){
		$.ajax({
			url : '/proxyMonitoring/actExeCng.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
				type : type,
				status : status,
				act_exe_type : 'TC004001'
			},
			success : function(result) {
				rowChkCnt = $("#serverSsChkNum", "#proxyMonViewForm").val();

 				if(result.result){
 					fn_proxy_loadbar("start");

 					setTimeout(function() {
 						fn_proxy_loadbar("stop");
 		 				showSwalIconRst(result.errMsg, '<spring:message code="common.close" />', '', 'success', 'proxyMoReload');
 					}, 7000);
 				}else{
 					showSwalIcon(result.errMsg, '<spring:message code="common.close" />', '', 'error');
	 			}

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
	* 프록시 서버 모니터링 agent toggle 시작
	******************************************************** */
	function iDatabase_toggle() {
		if(shown) {
			$(".blink_db").hide();
			shown = false;
		} else {
			$(".blink_db").show();
			shown = true;
		}
		
		setTimeout(iDatabase_toggle_end, 100);
	}

	/* ********************************************************
	* 프록시 서버 모니터링 agent toggle 종료
	******************************************************** */
	function iDatabase_toggle_end() {
		if(shown) {
			$(".blink_db").hide();
			shown = false;
		} else {
			$(".blink_db").show();
			shown = true;
		}
	}

	/* ********************************************************
	 * 리스너 db 연결도 셋팅
	 ******************************************************** */
	function fn_listenerDbConnect(result){
		var rowCount = 0;
		var html = "";
		var master_gbn = "";
		var pry_svr_id = "";
		var listCnt = 0;
		var pry_svr_id_val = "";
		var db_exe_status_chk = "";
		var db_exe_status_css = "";
		var db_exe_status_val = "";
		if(result.listenerDbConnect != null  && result.listenerDbConnect.length > 0) {
			
		}
		$("#listenerDbConnect").html(html);
	}

	/* ********************************************************
	 * config 파일 view popup
	 ******************************************************** */
	function fn_configView(pry_svr_id, type){
		$.ajax({
			url : '/proxyMonitoring/configView.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
				type : type
			},
			success : function(result) {
				$("#config", "#configForm").html("");
				$("#seek", "#configForm").val("0");
				$("#endFlag", "#auditViewForm").val("0");
				$("#dwLen", "#auditViewForm").val("0");
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
		$('#loading').hide();
	}

	/* ********************************************************
	 * log 파일 view popup
	 ******************************************************** */
	function fn_logView(pry_svr_id, type, date, agt_cndt_cd){
	
		todayYN = 'N';
		if(date == 'today'){
			pry_svr_id = select_pry_svr_id;
			date = new Date().toJSON();
			todayYN = 'Y';
		}
		$.ajax({
			url : '/proxyMonitoring/logView.do',
			type : 'post',
			data : {
				pry_svr_id : pry_svr_id,
				type : type,
				date : date,
			},
			success : function(result) {
				$("#proxylog", "#proxyViewForm").html("");
				$("#dwLen", "#proxyViewForm").val("0");
				$("#fSize", "#proxyViewForm").val("");
				$("#pry_svr_id", "#proxyViewForm").val(pry_svr_id);
				$("#log_line", "#proxyViewForm").val("1000");
				$("#type", "#proxyViewForm").val(type);
				$("#date", "#proxyViewForm").val(date);
				$("#aut_id", "#proxyViewForm").val(aut_id);
				$("#todayYN", "#proxyViewForm").val(todayYN);
				$("#view_file_name", "#proxyViewForm").html("");
				$("#agt_cndt_cd", "#proxyViewForm").html(agt_cndt_cd);
				$("#log_type").val(type).prop("selected", true);
				$("#kal_install_yn","#proxyViewForm").val(kal_install_yn);
				dateCalenderSetting();
				fn_logViewAjax();
				$('#pop_layer_log_view').modal("show");
			},
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
			}
		});
	}


	/* ********************************************************
	* -정지 실패 로그 popup
	******************************************************** */
	function fn_actExeFailLog(pry_act_exe_sn){
		$.ajax({
			url : "/proxyMonitoring/actExeFailLog.do",
			data : {
				pry_act_exe_sn : pry_act_exe_sn
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
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), closeBtn, '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					$("#wrkLogInfo").html(result.actExeFailLog.rslt_msg);
				}
				$("#pop_layer_wrkLog").modal("show");						
			}
		});
	}
	
	/* ********************************************************
	* confirm 창
	******************************************************** */
	function fn_exe_confirm(pry_svr_id, act_status, type, agt_cndt_cd){
		cng_pry_svr_id = pry_svr_id;
		act_sys_type = type;
		var confirm_title = "";
		
		if(agt_cndt_cd == "TC001502"){
			if (act_status == "TC001501") {
				if(type == "P") {
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg35"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg36"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				}
			}else if (act_status == "TC001502") {
				if(type == "P"){
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg37"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg38"/> <br> <spring:message code="eXperDB_proxy.msg34"/>'));
				}
			}
		
		} else {
			if (act_status == "TC001501") {
				var gbn = "exe_stop";
				if(type == "P") {
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg15"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_stop"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg19"/>'));
				}
			}else if (act_status == "TC001502") {
				var gbn = "exe_start";
				if(type == "P"){
					confirm_title = '<spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg16"/>'));
				} else {
					confirm_title = '<spring:message code="eXperDB_proxy.vip"/> <spring:message code="eXperDB_proxy.vip_health_check"/> <spring:message code="eXperDB_proxy.act_start"/>';
					$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="eXperDB_proxy.msg20"/>'));
				}
			}
		}
		
		$('#con_multi_gbn', '#findConfirmMulti').val(gbn);
		$('#confirm_multi_tlt').html(confirm_title);
		$('#pop_confirm_multi_md').modal("show");
	}
	
	function fnc_confirmMultiRst(gbn){
		if (gbn == "exe_stop") {
			//중지
			fn_act_exe_cng(cng_pry_svr_id, act_sys_type,"TC001501");
		}else if (gbn == "exe_start") {
			//실행
			fn_act_exe_cng(cng_pry_svr_id, act_sys_type,"TC001502");
		} 
	}
	
	
</script>

<%@include file="./../popup/proxyLogView.jsp"%>
<%@include file="./../popup/proxyConfigViewPop.jsp"%>
<%@include file="./../popup/proxyDBStandbyIPViewPop.jsp"%>
<%@include file="./../../cmmn/wrkLog.jsp"%>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/confirmForm.jsp"%>

<form name="proxyMonViewForm" id="proxyMonViewForm">
	<input type="hidden" name="serverSsCnt"  id="serverSsCnt" />
	<input type="hidden" name="serverSsChkNum"  id="serverSsChkNum" />
	<input type="hidden" name="chartCnt"  id="chartCnt" />
</form>

<div class="content-wrapper main_scroll" style="min-height: calc(100vh);" id="contentsDiv">

	<!-- 서버 모니터링 -->
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
												<span class="menu-title"><spring:message code="menu.proxy_monitoring"/></span>
												<i class="menu-arrow_monitoring" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
												<spring:message code="menu.proxy" />
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_mgmt" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_monitoring"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
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

		<!--  서버리스트 -->
		<div class="col-md-12 grid-margin stretch-card">
			<div class="card position-relative">
				<div class="card-body">
					<div class="row">
	                    <div class="col-3">
	                    	<!-- 서버정보 title -->
	                    	<div class="row">
								<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" style="margin-bottom:10px;">
								
									<div class="card" style="margin-bottom:0px;">
										<div class="card-header" role="tab" id="page_header_div" >
											<div class="row" style="height: 15px;">
												<div class="col-12">
													<h6 class="mb-0">
														<i class="ti-calendar menu-icon"></i>
														<span class="menu-title"><spring:message code="eXperDB_proxy.server_cluster"/></span>
													</h6>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- 서버목록 -->
							<div class="row" id="serverTabList" >
							
							</div>
						</div>

						<!-- 상세내역 -->
						<div class="col-9">
							<div id="detailedReports" class="carousel slide detailed-report-carousel position-static pt-2" data-ride="carousel">
								<div class="carousel-inner">
									<div class="carousel-item active" id="v-pills-home_test1">
									<!-- proxy 데이터 있는 경우 -->	
										<div class="row" id="reg_pry_title">
											<div class="accordion_main accordion-multi-colored col-3_2" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_keep_vip" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.vip"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
											
											<div class="accordion_main col-0_5" style="border:none;" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
													<div class="card-header" role="tab" id="page_connect_server" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	&nbsp;
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
 
											<!-- 프록시 서버 -->
											<div class="accordion_main accordion-multi-colored col-3_7" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_proxy_server" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.server"/> <spring:message code="eXperDB_proxy.con_lsn"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>

											<div class="accordion_main col-1" style="border:none;" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;border:none;box-shadow: 0 0 0px black;">
													<div class="card-header" role="tab" id="page_connect_server" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	&nbsp;
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
											
											<div class="accordion_main accordion-multi-colored col-3_4" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_db_server" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.con_db_server"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>

										</div>
										<!-- proxy 데이터 없는 경우 title -->	
										<div class="row" id="no_reg_pry_title">
											<div class="accordion_main accordion-multi-colored col-12" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_keep_vip" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.server"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<!-- proxy 데이터 있는 경우 -->	
										<div class="row" id="reg_pry_detail">
											<!-- vip 출력 -->
											<div class="accordion_main accordion-multi-colored col-3_2" id="accordion" role="tablist" >
												<div class="card" style="border:none;" >
													<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="proxyMonitoringList">
													</div>
												</div>
											</div>
											
											<div class="accordion_main accordion-multi-colored col-0_5" id="accordion" role="tablist" >
												<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
													<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyVipConLineList">
													</div>
												</div>
											</div>

											<div class="accordion_main accordion-multi-colored col-3_7" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;" >
													<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="proxyListnerMornitoringList">
													</div>
												</div>
											</div>
																						
											<div class="accordion_main accordion-multi-colored col-1" id="accordion" role="tablist" >
												<div class="card" style="margin-left:-20px;margin-right:-20px;border:none;box-shadow: 0 0 0px black;" >
													<div class="card-body" style="border:none;min-height: 220px;margin-left:-17px;" id="proxyListnerConLineList">
													</div>
												</div>
											</div>
											
											
											<!-- DB 서버  출력-->
											<div class="accordion_main accordion-multi-colored col-3_4" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;" >
													<div class="card-body" style="border:none;min-height: 220px;margin: -20px -20px 0px -20px;" id="dbListenerVipList">
													</div>
												</div>
											</div>
										</div>
										<!-- proxy 데이터 없는 경우 -->										
										<div class="row" id="no_reg_pry_detail">
											<div class='col-md-12 grid-margin stretch-card'>
												<div class='card'>
													<div class="card-body">
														<div class="d-block flex-wrap justify-content-between justify-content-md-center justify-content-xl-between align-items-center">
															<h5 class="mb-0 mb-md-2 mb-xl-0 order-md-1 order-xl-0 text-muted">
															<spring:message code="eXperDB_proxy.msg40" /></h5>
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<!-- Proxy 서버 기록 -->
										<div class="row">
											<!-- 서버기록 title -->
											<div class="accordion_main accordion-multi-colored col-7" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_serverlogging_div" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.server_logging"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
											
											<!-- conf 파일 수정 기록 title -->
											<div class="accordion_main accordion-multi-colored col-5" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="page_conf_cng_logging_div" >
														<div class="row" style="height: 15px;">
															<div class="col-12">
																<h6 class="mb-0">
																	<i class="item-icon fa fa-dot-circle-o"></i>
																	<span class="menu-title"><spring:message code="eXperDB_proxy.config_modify_log"/></span>
																</h6>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<!-- 서버 기록 -->
 											<div class="accordion_main accordion-multi-colored col-7" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;">
													<div class="card-body" style="border:none;margin-top:-25px;margin-left:-25px;margin-right:-25px;">
														<div class="row">
															<div class="col-sm-8">
																<h6 class="mb-0 alert">
																	<span class="menu-title text-success"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i><spring:message code="eXperDB_proxy.msg3"/></span>
																</h6>
															</div>
															<div class="col-sm-4">
																<button class="btn btn-outline-primary btn-icon-text btn-sm btn-icon-text" type="button" id="pry_mas_log_btn" onClick="fn_logView('', 'PROXY', 'today')">
																	<i class="mdi mdi-file-document"></i>
																	<spring:message code='eXperDB_proxy.current'/> <spring:message code="eXperDB_proxy.master"/> <spring:message code='eXperDB_proxy.proxy_log' />
																</button>
															</div>
														</div>
 														<table id="proxyLogTable" class="table table-striped system-tlb-scroll" style="width:100%;border:none;">
															<thead>
					 											<tr class="bg-info text-white">
																	<th width="50px;"><spring:message code="eXperDB_proxy.server_name"/></th>
																	<th width="50px;"><spring:message code="eXperDB_proxy.system"/></th>

																	<th width="50px;"><spring:message code="common.status"/></th>
																	<th width="50px;"><spring:message code="eXperDB_proxy.act_result"/></th>
																	<th width="50px;"><spring:message code="history_management.time"/></th>	
																	<th width="0px;">rownum</th>
																	<th width="0px;">proxy_id</th>
																</tr>
															</thead>
														</table>
													</div>
												</div>
											</div>
											<!-- 서버 기록 end --> 
											
											<!-- config 파일 수정 이력 -->
											<div class="accordion_main accordion-multi-colored col-5" id="accordion" role="tablist" >
												<div class="card" style="margin-bottom:10px;border:none;">
													<div class="card-body" style="border:none;margin-top:-25px;margin-left:-25px;margin-right:-25px;">
														<div class="row">
															<div class="col-sm-12">
																<h6 class="mb-0 alert">
																	<span class="menu-title text-success"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i><spring:message code="eXperDB_proxy.msg3"/></span>
																</h6>
															</div>
														</div>
 														<table id="proxyConfigCngLogTable" class="table table-striped system-tlb-scroll" style="width:100%;border:none;">
															<thead>
					 											<tr class="bg-info text-white">
					 												<th width="0px;">rownum</th>
																	<th width="0px;">proxy_id</th>
																	<th width="50px;"><spring:message code="eXperDB_proxy.server_name"/></th>
																	<th width="50px;"><spring:message code="eXperDB_proxy.act_result"/></th>
																	<th width="50px;"><spring:message code="history_management.time"/></th>	
																</tr>
															</thead>
														</table>
													</div>
												</div>
											</div>
										</div>

										<div class="row">
											<!-- 리스너정보 title -->
											<div class="accordion_main accordion-multi-colored col-12" id="accordion_listner_his" role="tablist">
												<div class="card" style="margin-bottom:0px;">
													<div class="card-header" role="tab" id="listener_header_div">
														<div class="row" style="height: 15px;">
															<div class="col-6">
																<h6 class="mb-0">
																	<a data-toggle="collapse" href="#listener_header_sub" aria-expanded="true" aria-controls="listener_header_sub" onclick="fn_profileChk('listenerTitleText')">
																		<i class="fa fa-bar-chart-o menu-icon"></i>
																		<span class="menu-title"><spring:message code="eXperDB_proxy.listener_info"/></span>
																		<i class="menu-arrow_user_af" id="listenerTitleText" ></i>
																	</a>
																</h6>
															</div>
															<div class="col-6">
											 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
																	<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_listner_his_today"></li>
																</ol>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										
										<div id="listener_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="listener_header_div" data-parent="#accordion_listner_his">
										</div>
										
										<div id="listener_header_sub_list" class="collapse show row" role="tabpanel" aria-labelledby="listener_header_div" data-parent="#accordion_listner_his">
											<div class="col-md-12 col-xl-12 justify-content-center">
												<div class="card" style="margin-left:-10px;border:none;">
													<div class="card-body" style="border:none;">
														<p class="card-title" style="margin-bottom:5px;margin-left:10px;">
															<i class="item-icon fa fa-toggle-right text-info"></i>
															&nbsp;<spring:message code="eXperDB_proxy.listener_detail_info"/>
														</p>
														<table id="proxyStatTable" class="table table-bordered system-tlb-scroll text-center" style="width:100%;">
															<thead class="bg-info text-white">
																<tr>
																	<th rowspan="2" scope="col" width="130px;"><spring:message code="eXperDB_proxy.server_name"/></th>
																	<th rowspan="2" scope="col" width="110px;"><spring:message code="eXperDB_proxy.listener_name"/></th>
																	<th rowspan="2" scope="col" width="100px;"><spring:message code="eXperDB_proxy.ipadr"/></th>
																	<th rowspan="2" scope="col" width="100px;"><spring:message code="properties.status"/></th>
																	<th rowspan="2" scope="col" width="90px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.downtime"/></th>
																	<th rowspan="2" scope="col" width="100px;" style="line-height:120%;"><spring:message code="common.failed"/><br/><spring:message code="eXperDB_proxy.check_count"/></th>
																	<th colspan="4" scope="col" width="300px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.session"/></th>
																	<th colspan="2" scope="col" width="200px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.byte_in_out"/></th>
																	<th rowspan="2" width="0px;">rownum</th>
																	<th rowspan="2" width="0px;">proxy_id</th>
																	<th rowspan="2" width="0px;">pry_svr_id</th>
																</tr>
																<tr>
																	<th scope="col" width="100px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.max"/><br/><spring:message code="eXperDB_proxy.session_count"/></th>
																	<th scope="col" width="100px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.current"/><br/><spring:message code="eXperDB_proxy.session_count"/></th>
																	<th scope="col" width="100px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.session"/><br/><spring:message code="eXperDB_proxy.limit"/></th>
																	<th scope="col" width="100px;" style="line-height:120%;"><spring:message code="eXperDB_proxy.session_total"/></th>
																	<th scope="col" width="100px;"><spring:message code="eXperDB_proxy.byte_in"/></th>
																	<th scope="col" width="100px;"><spring:message code="eXperDB_proxy.byte_out"/></th>
																</tr>
															</thead>
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
		</div>
	</div>		
</div>