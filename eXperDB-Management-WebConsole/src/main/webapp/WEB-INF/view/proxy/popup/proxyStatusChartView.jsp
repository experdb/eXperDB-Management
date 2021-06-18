<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : proxyStatusChartView.jsp
	* @Description : 프록시 상태 차트  화면 수정 중
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>
<script type="text/javascript">
var serverChart;
var sessionChart;
var byteChart;
/* ********************************************************
* 통계차트 생성
******************************************************** */
$(window.document).ready(function() {
	serverChart = Morris.Line({
		element: 'chart-line-server',
		lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
		data: [
				{
					exe_dtm_date: '',//기본값
					svr_pro_req_sel_cnt : 0,
					bakup_ser_cnt: 0,
					svr_status_chg_cnt: 0,
					fail_chk_cnt: 0
			    }
		],
		xkey: 'exe_dtm_date',
		xLabelAngle: 30,
		ykeys: ['svr_pro_req_sel_cnt', 'bakup_ser_cnt', 'svr_status_chg_cnt', 'fail_chk_cnt'],
		labels: [fn_strBrRemove('<spring:message code="eXperDB_proxy.req_sel_cnt"/>'), fn_strBrRemove('<spring:message code="eXperDB_proxy.backup_svr_cnt"/>'), fn_strBrRemove('<spring:message code="eXperDB_proxy.status_chg_cnt"/>'), fn_strBrRemove('<spring:message code="eXperDB_proxy.chart_health_check_failed"/>')]
	});
	
	sessionChart = Morris.Line({
		element: 'chart-line-session',
		lineColors: ['#63CF72', '#F36368', '#76C1FA', '#FABA66'],
		data: [
				{
					exe_dtm_date: '',//기본값
					cur_session: 0,
					max_session: 0,
					session_limit: 0,
					cumt_sso_con_cnt: 0
			    }
		],
		xkey: 'exe_dtm_date',
		xLabelAngle: 30,
		ykeys: ['cur_session', 'max_session', 'session_limit', 'cumt_sso_con_cnt'],
		labels: ['<spring:message code="eXperDB_proxy.current"/> <spring:message code="eXperDB_proxy.session_count"/>', '<spring:message code="eXperDB_proxy.max"/><br/><spring:message code="eXperDB_proxy.session_count"/>', '<spring:message code="eXperDB_proxy.session"/> <spring:message code="eXperDB_proxy.limit"/>', fn_strBrRemove('<spring:message code="eXperDB_proxy.session_total"/>')]
	});
	
	byteChart = Morris.Line({
		element: 'chart-line-byte',
		lineColors: ['#63CF72', '#F36368'],
		data: [
				{
					exe_dtm_date: '',//기본값
					byte_receive: 0,
					byte_transmit: 0
			    }
		],
		xkey: 'exe_dtm_date',
		xLabelAngle: 30,
		ykeys: ['byte_receive', 'byte_transmit'],
		labels: [fn_strBrRemove('<spring:message code="eXperDB_proxy.chart_byte_in"/>'), fn_strBrRemove('<spring:message code="eXperDB_proxy.chart_byte_out"/>')]
	});

});
/* ********************************************************
 * br 제거
 ******************************************************** */
function fn_strBrRemove(msg) {
	if (nvlPrmSet(msg, "") != "") {
		msg = msg.replaceAll("<br/>","");
	}

	return msg;
}
/* ********************************************************
* 데이터 그리기
******************************************************** */
function fn_draw_chart(chartData){
	
	setTimeout(function(){
		//데이터 적용
		serverChart.setData(chartData.serverChartData);
		sessionChart.setData(chartData.sessionChartData);
		byteChart.setData(chartData.byteChartData);
		//사이즈 조절
		serverChart.resizeHandler();
		sessionChart.resizeHandler();
		byteChart.resizeHandler();
	},250);	
}

/* ********************************************************
 * Chart Tab Click
 ******************************************************** */
function selectChartTab(tab){
	if(tab == "server"){
		$(".server_chart_div").show();
		$(".session_chart_div").hide();
		$(".byte_chart_div").hide();
		$("#chart-tab-1").addClass("active");
		$("#chart-tab-2").removeClass("active");
		$("#chart-tab-3").removeClass("active");
		serverChart.resizeHandler();
	}else if(tab == "session"){
		$(".server_chart_div").hide();
		$(".session_chart_div").show();
		$(".byte_chart_div").hide();
		$("#chart-tab-1").removeClass("active");
		$("#chart-tab-2").addClass("active");
		$("#chart-tab-3").removeClass("active");
		sessionChart.resizeHandler();
	}else if(tab == "byte"){ 
		$(".server_chart_div").hide();
		$(".session_chart_div").hide();
		$(".byte_chart_div").show();
		$("#chart-tab-1").removeClass("active");
		$("#chart-tab-2").removeClass("active");
		$("#chart-tab-3").addClass("active");
		byteChart.resizeHandler();
	}
}
</script>
<div class="modal fade config-modal" id="pop_pry_status_chart_view" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_proxy.daily_log_statistics"/>
				</h4>
				<h6 class="modal-title chart-title" id="ModalLabel" style="padding-left:5px;"></h6>
				<div class="card" style="margin-top:10px;border:0px;">
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="chart-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="chart-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectChartTab('server');" >
								<spring:message code="dashboard.server"/>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="chart-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectChartTab('session');">
								<spring:message code="eXperDB_proxy.session"/>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="chart-tab-3" data-toggle="pill" href="#subTab-3" role="tab" aria-controls="subTab-3" aria-selected="false" onclick="javascript:selectChartTab('byte');">
								<spring:message code="eXperDB_proxy.byte_in_out"/>
							</a>
						</li>
					</ul>
					<div class="card server_chart_div">
						<div class="card-body">
							<div id="chart-line-server"></div>
						</div>
					</div>
					<div class="card session_chart_div">
						<div class="card-body">
							<div id="chart-line-session"></div>
						</div>
					</div>
					<div class="card byte_chart_div">
						<div class="card-body">
							<div id="chart-line-byte"></div>
						</div>
					</div>
				</div>
				<fieldset>
					<div class="top-modal-footer" style="text-align: center !important; margin: -10px 0 0 -10px;" >
						<button type="button" class="btn btn-light" data-dismiss="modal" onclick=""><spring:message code="common.close"/></button>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
</div>
