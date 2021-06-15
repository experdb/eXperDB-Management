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


/* ********************************************************
* 통계리스트 html 설정
******************************************************** */
function fn_create_chartTitle(data){
	var html = "";
	$("#listener_header_sub").html(html);
	var chartCnt = 0;

	html += '<div class="col-md-12 col-xl-12 justify-content-center" >\n';
	html += '	<div class="card" style="margin-left:-10px;border:none;">\n';
	html += '		<div class="card-body" style="border:none;">\n';
	html += '			<p class="card-title" style="margin-bottom:0px"><i class="item-icon mdi mdi-chart-bar text-info"></i>&nbsp;<spring:message code="eXperDB_proxy.listener_statistics"/>&nbsp;&nbsp;   &nbsp;<span class="text-info"><i class="mdi mdi-chevron-double-right menu-icon" style="font-size:1.1rem; margin-right:5px;"></i><spring:message code="eXperDB_proxy.msg4"/></span>&nbsp;</p>\n';
	html += '		</div>\n';
	html += '	</div>\n';
	html += '</div>\n';
	
	if (data != null && data > 0) {
		$(data).each(function (index, item) {
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

	$("#listener_header_sub").html(html);
	
	setTimeout(function() {
		fn_draw_chart(chartCnt, data);
	}, 7000);
}
/* ********************************************************
* 리스너 통계차트 생성
******************************************************** */
function fn_draw_chart(cnt, data){
	if(result.proxyStatisticsInfoChart != null && result.proxyStatisticsInfoChart.length > 0){
		var chartCntLoad = cnt;
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
</script>
<div class="modal fade config-modal" id="pop_pry_status_chart_view" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:9999;">
	<div class="modal-dialog  modal-xl" role="document">
		<div class="modal-content">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info config_title" id="ModalLabel" style="padding-left:5px;">
					<!-- 					Proxy Configuration -->
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body">
						<div id="listener_header_sub" class="collapse show row" role="tabpanel" aria-labelledby="listener_header_div" data-parent="#accordion_listner_his">
						<!-- chart -->
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
	</div>
</div>
