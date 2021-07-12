<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<% 
	/**
	* @Class Name : accessHistory.jsp
	* @Description : AccessHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.07
	*
	*/
%>

<script>
	var runStatusHistoryTable = null;
	var settingChgHistoryTable = null;
	var statisTable = null;
	var selSvrId=null;
	var selSvrNm=null;
	var selChgId=null;
	
	$(window.document).ready(function() {
		
		//tooltip setting
		$('[data-toggle="tooltip"]').tooltip({
			template: '<div class="tooltip tooltip-info" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>'
		});
		
		//button setting
		fn_buttonAut();
		
		//table setting
		fn_init_main();

		//작업기간 calender setting
		dateCalenderSetting();
		var lgi_dtm_start_val = "${lgi_dtm_start}";
		var lgi_dtm_end_val = "${lgi_dtm_end}";
		if (lgi_dtm_start_val != "" && lgi_dtm_end_val != "") {
			$('#actstate_wlk_dtm_start_prm').val(lgi_dtm_start);
			$('#actstate_wlk_dtm_end_prm').val(lgi_dtm_end);
			$('#setchg_lst_dtm_start_prm').val(lgi_dtm_start);
			$('#setchg_lst_dtm_end_prm').val(lgi_dtm_end);
			$('#statis_wlk_dtm_start').val(lgi_dtm_start);
			$('#statis_wlk_dtm_end').val(lgi_dtm_end);
		}		
		selectTab("settingChange");
	});
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
	 * 버튼setting 셋팅
	 ******************************************************** */
	function fn_buttonAut(){
		if("${read_aut_yn}" == "Y"){
			$("#btnExcel").show();
			$("#btnSelect").show();
		}else{
			$("#btnExcel").hide();
			$("#btnSelect").hide();
		}	
	}

	/* ********************************************************
	 * 테이블 setting
	 ******************************************************** */
	function fn_init_main(){
		settingChgHistoryTable = $('#settingChgHistoryTable').DataTable({	
			scrollY: "275px",
			searching : false,
			scrollX: true,
			bSort: false,
		    columns : [	{data: "lst_dtm_date", className: "dt-center", defaultContent: ""}, 
		               	{data: "lst_dtm_hour", className: "dt-center", defaultContent: ""}, 
			         	{data: "pry_svr_nm", className: "dt-left", defaultContent: ""}, 
			         	{data: "pry_pth", className: "dt-center", defaultContent: "",
			         		render: function (data, type, full){
			         			var delYn="Y";
			         			if(full.lst_mdfr_id == null || full.lst_mdfr_id == ""){
			         				delYn="N";
			         			}
		         				var html = "";
			         			html += '<button type="button" class="btn btn-link btn-fw" onclick="fn_show_conf(\'P\','+full.pry_svr_id+',\''+full.pry_svr_nm+'\','+full.pry_cng_sn+',\''+delYn+'\')">';
								html += '<i class="item-icon fa fa-file-text-o"></i> <spring:message code="eXperDB_proxy.show_config" />';
								html += '</button>';
								return html;
		         			}
			         	}, 
			         	{data: "kal_pth", className: "dt-center", defaultContent: "",
			         		render: function (data, type, full){
			         			var delYn="Y";
			         			if(full.lst_mdfr_id == null || full.lst_mdfr_id == ""){
			         				delYn="N";
			         			}
		         				var html = "";
			         			html += '<button type="button" class="btn btn-link btn-fw" onclick="fn_show_conf(\'K\','+full.pry_svr_id+',\''+full.pry_svr_nm+'\','+full.pry_cng_sn+',\''+delYn+'\')">';
								html += '<i class="item-icon fa fa-file-text-o"></i> <spring:message code="eXperDB_proxy.show_config" />';
								html += '</button>';
								return html;
		         			}
			         	}, 
			         	{data: "exe_rst_cd", className: "dt-left", defaultContent: "",
		         		render: function (data, type, full){
		         				var html = "";
			         			if(data == 'TC001501'){
									html += "<div class='badge badge-light' style='margin:0px;background-color: transparent !important;font-size: 1rem;'>";
									html += '<i class="item-icon fa fa-check-circle text-primary icon-sm"></i>';
									html += '&nbsp;<spring:message code="common.success" />';
									html += "</div>";
								} else if(data == 'TC001502'){
									html += "<div class='badge badge-light' style='margin:0px;background-color: transparent !important;font-size: 1rem;'>";
									html += '<i class="item-icon fa fa-times text-danger icon-sm"></i>';
									html += '&nbsp;<spring:message code="common.failed" />';
									html += "</div>";
								}
			         			return html;
		         			}
			         	}, 
			    		{data: "frst_regr_id", className: "dt-center", defaultContent: ""},
			    		{data: "del_conf", className: "dt-center", defaultContent: "",
			         		render: function (data, type, full){
			         			var html = "";
			         			if(full.lst_mdfr_id == null || full.lst_mdfr_id == ""){
			         				html += '<button type="button" class="btn btn-link btn-fw" onclick="fn_before_del_conf('+full.pry_svr_id+',\''+full.pry_svr_nm+'\','+full.pry_cng_sn+')">';
									html += '<i class="item-icon fa fa-trash-o"></i> <spring:message code="eXperDB_proxy.del_config" />';
									html += '</button>';
								}else{
			         				html += '<i class="item-icon fa fa-trash-o"></i> <spring:message code="eXperDB_proxy.del_config" />';
								}
		         				return html;
		         			}
			         	},
			         	{data: "lst_mdfr_id", className: "dt-center", defaultContent: ""},
			    		{data: "lst_mdf_dtm", className: "dt-left", defaultContent: "", visible: false},
			    		{data: "pry_cng_sn", className : "dt-left", defaultContent : "", visible: false},
			         	{data: "pry_svr_id", className: "dt-center", defaultContent: "", visible: false}
	 		        ]
			});
	   	
		settingChgHistoryTable.tables().header().to$().find('th:eq(0)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(1)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(2)').css('min-width', '15%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(3)').css('min-width', '15%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(4)').css('min-width', '15%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(5)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(7)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(8)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(9)').css('min-width', '0%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(10)').css('min-width', '0%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(11)').css('min-width', '0%');

		if("${wrt_aut_yn}" == "Y"){
			settingChgHistoryTable.column(5).visible(true);
		}else {
			settingChgHistoryTable.column(5).visible(false);
		}
		   	
   		runStatusHistoryTable = $('#runStatusHistoryTable').DataTable({	
   		scrollY: "275px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [	{data: "wrk_dtm_date", className: "dt-left", defaultContent: ""}, 
	               	{data: "wrk_dtm_hour", className: "dt-left", defaultContent: ""}, 
		         	{data: "pry_svr_nm", className: "dt-left", defaultContent: ""}, 
		         	{data: "sys_type", className: "dt-left", defaultContent: "",
	         		render: function (data, type, full){
		            		if(full.sys_type == "PROXY"){
								return "Proxy";
							}else{
								return "VIP Check";
							}
	         			}
		         	},
		         	{data: "act_type", className: "dt-center", defaultContent: "",
		         		render: function (data, type, full){
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
	         			}
		         	}, 
		    		{data: "act_exe_type", className: "dt-center", defaultContent: "",
	         		render: function (data, type, full){
		            		if(full.act_exe_type == "TC004001"){
								return '<spring:message code="dashboard.manual" />';
							}else if(full.act_exe_type == "TC004002"){
								return '<spring:message code="dashboard.auto" />';
							}
	         			}
		         	}, 
		    		{data: "exe_rslt_cd", className: "dt-left", defaultContent: "",
	         		render: function (data, type, full){
	         				var html = "";
		         			if(data == 'TC001501'){
								html += "<div class='badge badge-light' style='margin:0px;background-color: transparent !important;font-size: 1rem;'>";
								html += '<i class="item-icon fa fa-check-circle text-primary icon-sm"></i>';
								html += '&nbsp;<spring:message code="common.success" />';
								html += "</div>";
							} else if(data == 'TC001502'){
								html += '<div class="badge badge-light" style="margin:0px;background-color: transparent !important;font-size: 1rem; cursor: pointer;"  onclick="fn_showExeFailLog('+full.pry_svr_id+','+full.pry_act_exe_sn+')" >';
								html += '<i class="item-icon fa fa-times text-danger icon-sm"></i>';
								html += '&nbsp;<spring:message code="common.failed" />';
								html += "</div>";
							}
		         			return html;
	         			}
		         	}, 
		    		{data: "rslt_msg", className: "dt-left", defaultContent: "", visible: false},
		    		{data: "lst_mdfr_id", className: "dt-left", defaultContent: ""},
		    		{data: "wrk_dtm", className: "dt-left", defaultContent: "", visible: false}, 
		    		{data: "lst_mdf_dtm", className: "dt-left", defaultContent: "", visible: false},
		    		{data: "pry_act_exe_sn", className : "dt-left", defaultContent : "", visible: false},
		         	{data: "pry_svr_id", className: "dt-center", defaultContent: "", visible: false}
 		        ]
		});
   	
   		runStatusHistoryTable.tables().header().to$().find('th:eq(0)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(1)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(2)').css('min-width', '15%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(3)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(4)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(5)').css('min-width', '15%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(7)').css('min-width', '15%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(8)').css('min-width', '10%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(9)').css('min-width', '0%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(10)').css('min-width', '0%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(11)').css('min-width', '0%');
	   	runStatusHistoryTable.tables().header().to$().find('th:eq(12)').css('min-width', '0%');
	   	
	   	statisTable = $('#statisTable').DataTable({	
	   		scrollY: "251px",
			searching : false,
			scrollX: true,
			bSort: false,
			paging : false,
			columns : [	{data: "db_con_addr", className: "dt-center", defaultContent: "",
				              	 render: function (data, type, full){
					               		return full.svr_host_nm+"<br/>("+full.db_con_addr+")";
									 }
								}, //DB_접속_주소SVR_HOST_NM
				               	{data: "pry_svr_nm", className: "dt-center", defaultContent: ""}, //Proxy명 *
				               	{data: "lsn_nm", className: "dt-left", defaultContent: "",
				               	 render: function (data, type, full){
				               		if(full.log_type == "TC003902"){//
				               			
				               			return '<a onclick="fn_show_chart(\''+full.db_con_addr+'\',\''+full.pry_svr_id+'\',\''+full.lsn_id+'\',\''+full.log_type+'\', \''+full.svr_host_nm+'\')" style="cursor: pointer; "><i class="mdi mdi-chart-bar text-warning"></i> '+full.lsn_nm+'</a>';
									}else{
										return full.lsn_nm;
									}
								 }
								}, //리스너 명 *
				               	{data: "exe_dtm_date", className: "dt-center", defaultContent: ""}, //실행 일자 *
				               	{data: "exe_rslt_cd", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										if(full.exe_rslt_cd == "TC001501"){
											return '<i class="fa fa-spinner fa-spin text-success"></i> <spring:message code="schedule.run" />';
										}else{
											return '<i class="fa fa-circle-o-notch text-danger"></i> <spring:message code="schedule.stop" />';
										}
									}
								}, //실행 결과 코드
				            	{data: "svr_status", className: "dt-right", defaultContent: "",
									render: function (data, type, full){
										if(full.svr_status == "UP"){
											return full.svr_status+' <i class="fa fa-arrow-up text-success"></i>';
										}else{
											return full.svr_status+' <i class="fa fa-arrow-down text-danger"></i>';
										}
									}
								}, //서버 상태
				            	{data: "lst_status_chk_desc", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html ='<span data-toggle="tooltip" data-html="true" data-placement="bottom" title="';
										switch(full.lst_status_chk_desc){
										case "UNK":
											html += '<spring:message code="eXperDB_proxy.status_tooltip1"/>">';
											break;
										case "INI":
											html += '<spring:message code="eXperDB_proxy.status_tooltip2"/>">';
											break;
										case "SOCKERR":
											html += '<spring:message code="eXperDB_proxy.status_tooltip3"/>">';
											break;
										case "L4OK":
											html += '<spring:message code="eXperDB_proxy.status_tooltip4"/>">';
											break;
										case "L4TOUT":
											html += '<spring:message code="eXperDB_proxy.status_tooltip5"/>">';
											break;
										case "L4CON":
											html += '<spring:message code="eXperDB_proxy.status_tooltip6"/>">';
											break;
										case "L6OK":
											html += '<spring:message code="eXperDB_proxy.status_tooltip7"/>">';
											break;
										case "L6TOUT":
											html += '<spring:message code="eXperDB_proxy.status_tooltip8"/>">';
											break;
										case "L6RSP":
											html += '<spring:message code="eXperDB_proxy.status_tooltip9"/>">';
											break;
										case "L7OK":
											html += '<spring:message code="eXperDB_proxy.status_tooltip10"/>">';
											break;
										case "L7OKC":
											html += '<spring:message code="eXperDB_proxy.status_tooltip11"/>">';
											break;
										case "L7TOUT":
											html += '<spring:message code="eXperDB_proxy.status_tooltip12"/>">';
											break;
										case "L7RSP":
											html += '<spring:message code="eXperDB_proxy.status_tooltip13"/>">';
											break;
										case "L7STS":
											html += '<spring:message code="eXperDB_proxy.status_tooltip14"/>">';
											break;
											
										}
										return html += full.lst_status_chk_desc +"</span>";
									}
								}, //마지막 상태 체크 내용
				            	{data: "svr_stop_tm", className: "dt-left", defaultContent: "",
									render: function (data, type, full){
										if(full.svr_stop_tm == "0s"){
											return "";
										}else{
											return '<i class="mdi mdi-alarm mr-2 text-danger" style="font-size:1em;"></i> '+full.svr_stop_tm;
										}
									}
								}, //서버 중단 시간
				               	{data: "svr_pro_req_sel_cnt", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.svr_pro_req_sel_cnt;
										if(full.svr_pro_req_sel_cnt_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.svr_pro_req_sel_cnt_gap+')';
										}else if(full.svr_pro_req_sel_cnt_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.svr_pro_req_sel_cnt_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.svr_pro_req_sel_cnt_gap+')';
										}
										return html;
									}
								}, //서버 처리 요청 선택 건수
				               	{data: "bakup_ser_cnt", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.bakup_ser_cnt;
										if(full.bakup_ser_cnt_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.bakup_ser_cnt_gap+')';
										}else if(full.bakup_ser_cnt_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.bakup_ser_cnt_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.bakup_ser_cnt_gap+')';
										}
										return html;
									}
								}, //백업 서버 수
				               	{data: "svr_status_chg_cnt", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.svr_status_chg_cnt;
										if(full.svr_status_chg_cnt_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.svr_status_chg_cnt_gap+')';
										}else if(full.svr_status_chg_cnt_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.svr_status_chg_cnt_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.svr_status_chg_cnt_gap+')';
										}
										return html;
									}
								}, //서버 상태 전환 건수
				               	{data: "fail_chk_cnt", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.fail_chk_cnt;
										if(full.fail_chk_cnt_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.fail_chk_cnt_gap+')';
										}else if(full.fail_chk_cnt_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.fail_chk_cnt_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.fail_chk_cnt_gap+')';
										}
										return html;
									}
								}, //실패 검사 수
				               	{data: "cur_session", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.cur_session;
										if(full.cur_session_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.cur_session_gap+')';
										}else if(full.cur_session_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.cur_session_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.cur_session_gap+')';
										}
										return html;
									}
								}, //현재 세션
				               	{data: "max_session", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.max_session;
										if(full.max_session_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.max_session_gap+')';
										}else if(full.max_session_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.max_session_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.max_session_gap+')';
										}
										return html;
									}
								}, //최대 세션
				               	{data: "session_limit", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.session_limit;
										if(full.session_limit_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.session_limit_gap+')';
										}else if(full.session_limit_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.session_limit_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.session_limit_gap+')';
										}
										return html;
									}
								}, //세션 제한수
				               	{data: "cumt_sso_con_cnt", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.cumt_sso_con_cnt;
										if(full.cumt_sso_con_cnt_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.cumt_sso_con_cnt_gap+')';
										}else if(full.cumt_sso_con_cnt_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.cumt_sso_con_cnt_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.cumt_sso_con_cnt_gap+')';
										}
										return html;
									}
								}, //누적 세션 연결 건수
				               	{data: "byte_receive", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.byte_receive;
										if(full.byte_receive_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.byte_receive_gap+')';
										}else if(full.byte_receive_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.byte_receive_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.byte_receive_gap+')';
										}
										return html;
									}
								}, //바이트 수신수
				               	{data: "byte_transmit", className: "dt-center", defaultContent: "",
									render: function (data, type, full){
										var html= full.cur_session;
										if(full.byte_transmit_gap == 0){
											html += '(<i class="mdi mdi-minus menu-icon text-muted"></i>'+full.byte_transmit_gap+')';
										}else if(full.byte_transmit_gap > 0){
											html += '(<i class="mdi mdi-arrow-up-bold menu-icon text-success"></i>'+full.byte_transmit_gap+')';
										}else{
											html += '(<i class="mdi mdi-arrow-down-bold menu-icon text-danger"></i>'+full.byte_transmit_gap+')';
										}
										return html;
									}
								}, //바이트 송신수
								{data: "exe_dtm_time", className: "dt-center", defaultContent: "", visible: false}, //실행 일시 *
				               	{data: "lst_con_rec_aft_tm", className: "dt-right", defaultContent: "", visible: false}, //마지막 연결 수신 이후 시간
				               	{data: "lsn_svr_id", className: "dt-left", defaultContent: "", visible: false}, //리스너 서버 ID
					    		{data: "lsn_id", className: "dt-left", defaultContent: "", visible: false},//리스너 ID
					    		{data: "pry_exe_status_sn", className : "dt-left", defaultContent : "", visible: false}, //실행 상태 일련번호
					    		{data: "log_type", className: "dt-left", defaultContent: "", visible: false}, //로그 유형
				               	{data: "pry_svr_id", className: "dt-left", defaultContent: "", visible: false},//Proxy ID
					    		{data: "exe_dtm", className: "dt-left", defaultContent: "", visible: false},//실행 일시
					    		{data: "lst_mdfr_id", className: "dt-left", defaultContent: "", visible: false},//최종 수정자 ID
					    		{data: "lst_mdf_dtm", className: "dt-left", defaultContent: "", visible: false},//최종 수정 일시
					    		{data: "frst_regr_id", className: "dt-left", defaultContent: "", visible: false}, //최초 등록자 ID
				               	{data: "frst_reg_dtm", className: "dt-left", defaultContent: "", visible: false}, //최초 등록 일시
				               	{data: "svr_host_nm", className: "dt-left", defaultContent: "", visible: false}//DB명
			 		        ]
					});
	   	 
	   	
	   	statisTable.tables().header().to$().find('th:eq(0)').css('min-width', '10%');
	  	statisTable.tables().header().to$().find('th:eq(1)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(2)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(3)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(4)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(5)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(7)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(8)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(9)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(10)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(11)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(12)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(13)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(14)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(15)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(16)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(17)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(18)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(19)').css('min-width', '10%');
	   	statisTable.tables().header().to$().find('th:eq(20)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(21)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(22)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(23)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(24)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(25)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(26)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(27)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(28)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(29)').css('min-width', '0%');
	   	statisTable.tables().header().to$().find('th:eq(30)').css('min-width', '0%');

    	$(window).trigger('resize'); 
    
	}
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);
		var day_start = today.toJSON().slice(0,10); 
		today.setDate(today.getDate()-1);
		var yesterday = today.toJSON().slice(0,10);
		
		$("#setchg_lst_dtm_start_prm").val(day_start);
		$("#setchg_lst_dtm_end_prm").val(day_end);

		if ($("#setchg_lst_strt_dtm_div").length) {
			$('#setchg_lst_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#setchg_lst_end_dtm_div").length) {
			$('#setchg_lst_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#setchg_lst_dtm_start_prm").datepicker('setDate', day_start);
	    $("#setchg_lst_dtm_end_prm").datepicker('setDate', day_end);
	    $('#setchg_lst_strt_dtm_div').datepicker('updateDates');
	    $('#setchg_lst_end_dtm_div').datepicker('updateDates');
		
	    $("#actstate_wlk_dtm_start_prm").val(day_start);
		$("#actstate_wlk_dtm_end_prm").val(day_end);
		
		if ($("#actstate_wrk_strt_dtm_div").length) {
			$('#actstate_wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#actstate_wrk_end_dtm_div").length) {
			$('#actstate_wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#actstate_wlk_dtm_start_prm").datepicker('setDate', day_start);
	    $("#actstate_wlk_dtm_end_prm").datepicker('setDate', day_end);
	    $('#actstate_wrk_strt_dtm_div').datepicker('updateDates');
	    $('#actstate_wrk_end_dtm_div').datepicker('updateDates');
		
	    $("#statis_wlk_dtm_start").val(yesterday);
		$("#statis_wlk_dtm_end").val(yesterday);
		
		if ($("#statis_wrk_strt_dtm_div").length) {
			$('#statis_wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', yesterday)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#statis_wrk_end_dtm_div").length) {
			$('#statis_wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', yesterday)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#statis_wlk_dtm_start").datepicker('setDate', yesterday);
	    $("#statis_wlk_dtm_end").datepicker('setDate', yesterday);
	    $('#statis_wrk_strt_dtm_div').datepicker('updateDates');
	    $('#statis_wrk_end_dtm_div').datepicker('updateDates');
		
	}
	
	/* ********************************************************
	 *  설정 변경 이력 이력 리스트 조회
	 ******************************************************** */
	 function fn_setchg_select(){
		var lst_dtm_start = $("#setchg_lst_dtm_start_prm").val();
		var lst_dtm_end = $("#setchg_lst_dtm_end_prm").val();

		if (lst_dtm_start != "" && lst_dtm_end == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		if (lst_dtm_end != "" && lst_dtm_start == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		$.ajax({
			url : "/selectProxySettingChgHistory.do",
			data : {
				lst_dtm_start : $("#setchg_lst_dtm_start_prm").val(),
				lst_dtm_end : $("#setchg_lst_dtm_end_prm").val(),
				pry_svr_id : $("#setchg_pry_svr_id").val(),
				exe_rst_cd : $("#setchg_exe_rst_cd").val()
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
				settingChgHistoryTable.rows({selected: true}).deselect();
				settingChgHistoryTable.clear().draw();
	
				if (nvlPrmSet(result, "") != '') {
					settingChgHistoryTable.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 *  기동 상태 변경 이력 리스트 조회
	 ******************************************************** */
	 function fn_actstate_select(){
		var lgi_dtm_start = $("#actstate_wlk_dtm_start_prm").val();
		var lgi_dtm_end = $("#actstate_wlk_dtm_end_prm").val();

		if (lgi_dtm_start != "" && lgi_dtm_end == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		if (lgi_dtm_end != "" && lgi_dtm_start == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		$.ajax({
			url : "/selectProxyActStateHistory.do",
			data : {
				wlk_dtm_start : $("#actstate_wlk_dtm_start_prm").val(),
				wlk_dtm_end : $("#actstate_wlk_dtm_end_prm").val(),
				pry_svr_id : $("#actstate_pry_svr_id").val(),
				sys_type : $("#actstate_sys_type").val(),
				act_type : $("#actstate_act_type").val(),
				act_exe_type : $("#actstate_act_exe_type").val(),
				exe_rslt_cd : $("#actstate_exe_rslt_cd").val()
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
				runStatusHistoryTable.rows({selected: true}).deselect();
				runStatusHistoryTable.clear().draw();
	
				if (nvlPrmSet(result, "") != '') {
					runStatusHistoryTable.rows.add(result).draw();
				}
			}
		});
	}
	 /* ********************************************************
		 *  통계 정보 리스트 조회
		 ******************************************************** */
		 function fn_statis_select(){
			var lgi_dtm_start = $("#statis_wlk_dtm_start").val();
			var lgi_dtm_end = $("#statis_wlk_dtm_end").val();

			if (lgi_dtm_start != "" && lgi_dtm_end == "") {
				showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}

			if (lgi_dtm_end != "" && lgi_dtm_start == "") {
				showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}
			
			var log_type = $("#statis_log_type").val();
			var pry_svr_id = $("#statis_pry_svr_id").val();
			var db_con_addr = $("#statis_db_con_addr").val();
			
			if (log_type == "") {
				showSwalIcon('데이터 구분을 선택해주세요.', '<spring:message code="common.close" />', '', 'error');
				return false;
			}else if(log_type == "TC003901"){//분별
				if(lgi_dtm_start!=lgi_dtm_end){
					showSwalIcon('분별 데이터는 조회 가능 기간이 1일 입니다.', '<spring:message code="common.close" />', '', 'error');
					return false;
				}
				if(db_con_addr ==""){
					showSwalIcon(fn_strBrReplcae('분별 데이터는 검색 조건 중 DB를  <br/>반드시 선택해야 조회가 가능 합니다.'), '<spring:message code="common.close" />', '', 'error');
					return false;
				}	
			}
			
			$.ajax({
				url : "/selectProxyStatusHistory.do",
				data : {
					exe_dtm_start :lgi_dtm_start,
					exe_dtm_end : lgi_dtm_end,
					pry_svr_id : $("#statis_pry_svr_id").val(),
					log_type : $("#statis_log_type").val(),
					db_con_addr : $("#statis_db_con_addr").val()
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
					statisTable.rows({selected: true}).deselect();
					statisTable.clear().draw();
		
					if (result.data != null) {
						statisTable.rows.add(result.data).draw();
					}
					
					var tableRows = $('#statisTable tbody tr');
			  		if (tableRows.length > 1) {
				  		$('#statisTable').rowspan(0); 
				  		$('#statisTable').rowspan(1); 
				  		$('#statisTable').rowspan(2); 
			  		}
					
				}
			});
		}
		 /* ********************************************************
			 *  엑셀다운로드
			 ******************************************************** */
			function fn_ExportExcel() {
				var table = document.getElementById("statisTable");
				var dataCnt = statisTable.rows().data().length;

				if (dataCnt ==0) {
					showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'error');
					return false;
				} else {
					var wlk_dtm_start = $("#statis_wlk_dtm_start").val();
					var wlk_dtm_end = $("#statis_wlk_dtm_end").val();
					var pry_svr_id = $("#statis_pry_svr_id").val();
					var log_type = $("#statis_log_type").val();
					var db_con_addr = $("#statis_db_con_addr").val();
					
					var form = document.excelForm;

					$("#excel_wlk_dtm_start").val(wlk_dtm_start);
					$("#excel_wlk_dtm_end").val(wlk_dtm_end);
					$("#excel_pry_svr_id").val(pry_svr_id);
					$("#excel_log_type").val(log_type);
					$("#excel_db_con_addr").val(db_con_addr);
					
					//loading bar 호출
					setCookie("fileDownload","false"); //호출
					checkDownloadCheck();
					
					form.action = "/proxyStatusHistory_Excel.do";
					form.submit();
					$('#loading').show();
					return;
				}
			}
			
			function setCookie(c_name,value){
			    var exdate=new Date();
			    var c_value=escape(value);
			    document.cookie=c_name + "=" + c_value + "; path=/";
			}
			
			function checkDownloadCheck(){
			    if (document.cookie.indexOf("fileDownload=true") != -1) {
					var date = new Date(1000);
					document.cookie = "fileDownload=; expires=" + date.toUTCString() + "; path=/";
					//프로그래스바 OFF
					$('#loading').hide();
					return;
				}
				setTimeout(checkDownloadCheck , 100);
			}
			
	 /* ********************************************************
	  * Tab Click
	  ******************************************************** */
	 function selectTab(tab){
	 	if(tab == "settingChange"){ //설정변경 이력
	 		
	 		$("#searchSettingChg").show();
	 		$("#searchActStatus").hide();
	 		$("#searchStatistics").hide();
	 		
	 		$("#settingChgHistoryTableDiv").show();
	 		$("#runStatusHistoryTableDiv").hide();
	 		$("#statisTableDiv").hide();
	 		
	 		fn_setchg_select();
	 	}else if(tab == "ActStatus"){ //기동상태 변경 이력
	 		
	 		$("#searchSettingChg").hide();
	 		$("#searchActStatus").show();
	 		$("#searchStatistics").hide();
	 		
	 		$("#settingChgHistoryTableDiv").hide();
	 		$("#runStatusHistoryTableDiv").show();
	 		$("#statisTableDiv").hide();
	 		
	 		fn_actstate_select();
	 	}else{ //pryStatistics
	 		$("#searchSettingChg").hide();
	 		$("#searchActStatus").hide();
	 		$("#searchStatistics").show();
	 	
	 		$("#settingChgHistoryTableDiv").hide();
	 		$("#runStatusHistoryTableDiv").hide();
	 		$("#statisTableDiv").show();
	 		
	 		$("#statis_log_type").val("TC003902");
	 		
	 		fn_statis_select();
	 		
	 	}
	 }
	 
	  /* ********************************************************
	  * config file confirm button Click
	  ******************************************************** */
	  /*function fn_popup_conf(sysTeyp,svrId,svrNm, chgId){
		 $.ajax({
				url : "/popup/proxyBackupConfForm.do",
				data : {},
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
					fn_show_conf(sysType,svrId,svrNm,chgId);
				}
			});
	 } */
	 /* ********************************************************
	  * config file 내용 갖고 오기
	  ******************************************************** */
	  function fn_show_conf(sysType,svrId,svrNm,chgId,delYn){
		  $.ajax({
				url : "/getBackupConfFile.do",
				data :{	sys_type : sysType,
					pry_svr_id : svrId,
					pry_svr_nm : svrNm,
					pry_cng_sn : chgId
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
	 				//console.log(result);
	 				if(result.errcd > -1){
	 					if(result.errcd==0){//정상
							$('#pop_layer_config_view').modal("show");
	 						$("#config", "#configForm").html(result.presentConf);
	 						
	 						if(delYn == "N")	$("#backup_config", "#configForm").html(result.backupConf);
	 						if(delYn == "Y")	$("#backup_config", "#configForm").html('<spring:message code="eXperDB_proxy.msg58" />');
	 						
							if(sysType == "P"){
								$(".config_title").html(' ' + svrNm + ' Proxy Configuration');
							} else {
								$(".config_title").html(' ' + svrNm + ' Vip Configuration');
							}
							
							var tableDatas = settingChgHistoryTable.rows().data();
							var datasLen = tableDatas.length;
							
							for(var i=0; i<datasLen; i++){
								if(tableDatas[i].pry_svr_id == svrId && tableDatas[i].pry_cng_sn == chgId){
									$("#backupConfTitle").html('<i class="item-icon fa fa-dot-circle-o"></i> <spring:message code="eXperDB_proxy.backup_conf" /> : '+tableDatas[i].lst_dtm_date+' '+tableDatas[i].lst_dtm_hour);
								}
							}
						}else{ //연결실패
							showSwalIcon(result.errmsg, '<spring:message code="common.close" />', '', 'error');
						}
	 				}else{
	 					showSwalIcon(result.errmsg, '<spring:message code="common.close" />', '', 'error');
	 				}
	 			}
	 		});
	 }
	  /* ********************************************************
		  * config file 삭제 전 확인창
		  ******************************************************** */
	 function fn_before_del_conf(svrId,svrNm,chgId){
		 
		 selSvrId = svrId;
		 selSvrNm = svrNm;
		 selChgId = chgId;
		 
		  fn_multiConfirmModal("del_backup_conf");
		  
	  }
	  /* ********************************************************
		  * config file 삭제
		  ******************************************************** */
		  function fn_del_conf(){
			  $.ajax({
					url : "/deleteBackupConfFile.do",
					data :{	
								pry_svr_id : selSvrId,
								pry_svr_nm : selSvrNm,
								pry_cng_sn : selChgId
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
		 				showSwalIcon('<spring:message code="eXperDB_proxy.msg45" />', '<spring:message code="common.close" />', '', 'success');
		 				fn_setchg_select();
		 			}	
		 		});
		 }
	  
		function fn_showExeFailLog(prySvrId, pryActExeSn){
		 		var datas = runStatusHistoryTable.rows().data();
		 		var dataLen = datas.length;
		 		
		 		for(var i=0; i<dataLen; i++){
		 			if(datas[i].pry_svr_id == prySvrId && datas[i].pry_act_exe_sn == pryActExeSn){
		 				$("#wrkLogInfo").html(datas[i].rslt_msg);
		 				$("#ModalLabel","#pop_layer_wrkLog").html('<spring:message code="eXperDB_proxy.error_msg" />');
		 				$("#pop_layer_wrkLog").modal("show");	
		 			}
		 		}
		 	}
		
		 /* ********************************************************
		  * chart 타이틀 생성 데이터 ///작성 중... 
		  ******************************************************** */
		function fn_show_chart(dbSvrIp,prySvrId,lsnId,type, hostNm){
			if(type=='TC003902'){
				$.ajax({
					url : "/popup/proxyStatusChartTitle.do",
					data : {
						exe_dtm_start : $("#statis_wlk_dtm_start").val(),
						exe_dtm_end : $("#statis_wlk_dtm_end").val(),
						db_con_addr: dbSvrIp,
						pry_svr_id : prySvrId,
						lsn_id : lsnId,
						log_type : type
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
						if(result.prySvrNm =="") return;
						$(".chart-title").html(" - "+hostNm+" ("+result.dbConAddr+") / "+result.prySvrNm+" / "+result.lsnNm);
						$('#pop_pry_status_chart_view').modal("show");
						fn_draw_chart(result);
						selectChartTab("server");
						
					}
				});
			}
		}
		 
		/* ********************************************************
		 * confirm modal open
		 ******************************************************** */
		function fn_multiConfirmModal(gbn) {
			var confirm_title = "";
			
			if (gbn == "del_backup_conf") { 			
				confirm_title =  '<spring:message code="eXperDB_proxy.del_config" />';//백업 삭제
				$('#confirm_multi_msg').html('<spring:message code="eXperDB_proxy.msg57"/>'); //이력은 남지만 파일 확인이 불가능합니다. 
			}
			
			$('#con_multi_gbn', '#findConfirmMulti').val(gbn);
			$('#confirm_multi_tlt').html(confirm_title);
			$('#pop_confirm_multi_md').modal("show");
		}
		/* ********************************************************
		 * confirm result
		 ******************************************************** */
		function fnc_confirmMultiRst(gbn){
			 if (gbn == "del_backup_conf") {
				 fn_del_conf();
			}
		}
	
</script>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../popup/proxyConfigDiffViewPop.jsp"%>
<%@include file="./../popup/proxyStatusChartView.jsp"%>
<%@include file="./../../cmmn/wrkLog.jsp"%>
<form name="excelForm" method="post">
	<input type="hidden" name="excel_wlk_dtm_start" id="excel_wlk_dtm_start">
	<input type="hidden" name="excel_wlk_dtm_end" id="excel_wlk_dtm_end"> 
	<input type="hidden" name="excel_pry_svr_id" id="excel_pry_svr_id">
	<input type="hidden" name="excel_log_type" id="excel_log_type">
	<input type="hidden" name="excel_db_con_addr" id="excel_db_con_addr">
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
												<i class="mdi mdi-format-list-bulleted menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.proxy_hist" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">Proxy</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_mgmt" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.proxy_hist" /></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="eXperDB_proxy.msg55" /></p>
											<p class="mb-0"><spring:message code="eXperDB_proxy.msg56" /></p>
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
					<ul class="nav nav-pills nav-pills-setting nav-justified" id="server-tab" role="tablist" style="border:none;">
						<li class="nav-item">
							<a class="nav-link active" id="server-tab-1" data-toggle="pill" href="#subTab-1" role="tab" aria-controls="subTab-1" aria-selected="true" onclick="javascript:selectTab('settingChange');" >
								<spring:message code="eXperDB_proxy.conf_change_hist" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('ActStatus');">
								<spring:message code="eXperDB_proxy.exe_change_hist" />
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-3" data-toggle="pill" href="#subTab-3" role="tab" aria-controls="subTab-3" aria-selected="false" onclick="javascript:selectTab('pryStatistics');">
								<spring:message code="menu.proxy_status_hist" />
							</a>
						</li>
					</ul>
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px 0px;">
							<form class="form-inline row" id="searchSettingChg">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
									<div id="setchg_lst_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="setchg_lst_dtm_start_prm" name="setchg_lst_dtm_start_prm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="setchg_lst_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="setchg_lst_dtm_end_prm" name="setchg_lst_dtm_end_prm" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="setchg_pry_svr_id" id="setchg_pry_svr_id">
	 									<option value=""><spring:message code="eXperDB_proxy.server_name" /> <spring:message code="common.total" /></option>	
										<c:forEach var="prySvrList" items="${prySvrList}">
											<option value="${prySvrList.pry_svr_id}">${prySvrList.pry_svr_nm}</option>							
										</c:forEach>
									</select>
								</div>		
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="setchg_exe_rst_cd" id="setchg_exe_rst_cd">
										<option value=""><spring:message code="eXperDB_proxy.exe_result" /> <spring:message code="common.total" /></option>	
										<option value="TC001501"><spring:message code="common.success" /></option> 
	 									<option value="TC001502"><spring:message code="common.failed" /></option>
									</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="setchg_button"onclick="fn_setchg_select()" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
							<form class="form-inline row" id="searchActStatus">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
									<div id="actstate_wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="actstate_wlk_dtm_start_prm" name="actstate_wlk_dtm_start_prm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="actstate_wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="actstate_wlk_dtm_end_prm" name="actstate_wlk_dtm_end_prm" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="actstate_pry_svr_id" id="actstate_pry_svr_id">
	 									<option value=""><spring:message code="eXperDB_proxy.server_name" /> <spring:message code="common.total" /></option>	
										<c:forEach var="prySvrList" items="${prySvrList}">
											<option value="${prySvrList.pry_svr_id}">${prySvrList.pry_svr_nm}</option>							
										</c:forEach>
									</select>
								</div>		
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="actstate_sys_type" id="actstate_sys_type">
										<option value=""><spring:message code="eXperDB_proxy.system" /> <spring:message code="common.total" /></option>	
	 									<option value="PROXY">Proxy</option> 
	 									<option value="KEEPALIVED">Virtual IP</option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="actstate_act_type" id="actstate_act_type">
										<option value=""><spring:message code="eXperDB_proxy.exe_type" /> <spring:message code="common.total" /></option>	
	 									<option value="A"><spring:message code="eXperDB_proxy.act_start" /></option> 
	 									<option value="R"><spring:message code="eXperDB_proxy.act_restart" /></option>
	 									<option value="S"><spring:message code="eXperDB_proxy.act_stop" /></option>
									</select>	
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="actstate_act_exe_type" id="actstate_act_exe_type">
										<option value=""><spring:message code="eXperDB_proxy.exe_run_type" /> <spring:message code="common.total" /></option>	
										<option value="TC004001"><spring:message code="dashboard.manual" /></option>
	 									<option value="TC004002"><spring:message code="dashboard.auto" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="actstate_exe_rslt_cd" id="actstate_exe_rslt_cd">
										<option value=""><spring:message code="eXperDB_proxy.exe_result" /> <spring:message code="common.total" /></option>	
										<option value="TC001501"><spring:message code="common.success" /></option> 
	 									<option value="TC001502"><spring:message code="common.failed" /></option>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="actstate_button"onclick="fn_actstate_select()" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
							<form class="form-inline row" id="searchStatistics">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
								<!-- <div class="input-group mb-2 mr-sm-2 col-sm-1_7" > -->
									<div id="statis_wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
									<!-- <div id="statis_wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
									 -->	<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="statis_wlk_dtm_start" name="statis_wlk_dtm_start" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1"> <!-- style="display:none; -->
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="statis_wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="statis_wlk_dtm_end" name="statis_wlk_dtm_end" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
								<%-- <div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="statis_log_type" id="statis_log_type">
										<option value="">데이터 구분 <spring:message code="common.choice" /></option>	
	 									<option value="TC003901">분별</option> 
	 									<option value="TC003902">일별</option>
	 								</select>
								</div>  --%>
								<input type="hidden" name="statis_log_type" id="statis_log_type" value ="TC003902"/>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="statis_db_con_addr" id="statis_db_con_addr">
	 									<option value="">DB <spring:message code="common.total" /></option>	
										<c:forEach var="dbSvrList" items="${dbSvrList}">
											<option value="${dbSvrList.db_con_addr}">${dbSvrList.svr_host_nm}</option>							
										</c:forEach>
									</select>
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="statis_pry_svr_id" id="statis_pry_svr_id">
	 									<option value=""><spring:message code="eXperDB_proxy.server_name" /> <spring:message code="common.total" /></option>	
										<c:forEach var="prySvrList" items="${prySvrList}">
											<option value="${prySvrList.pry_svr_id}">${prySvrList.pry_svr_nm}</option>							
										</c:forEach>
									</select>
								</div>		
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="statis_button"onclick="fn_statis_select()" >
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
					<div class="card my-sm-2" >
						<div class="card-body" >
							<div class="row">
								<div class="col-12" id="settingChgHistoryTableDiv">
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

	 								<table id="settingChgHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="10"><spring:message code="eXperDB_proxy.work_day" /></th>
												<th width="10"><spring:message code="eXperDB_proxy.work_time" /></th>
												<th width="15"><spring:message code="eXperDB_proxy.server_name" /></th>
												<th width="15">Proxy</th>
												<th width="15">Virtaul IP</th>
												<th width="10"><spring:message code="eXperDB_proxy.act_result" /></th>
												<th width="10"><spring:message code="common.modifier" /></th>
												<th width="10">백업 삭제</th>
												<th width="10">백업 삭제자</th>
												<th width="0">최종 수정일시</th>
												<th width="0">변경 일련번호</th>
												<th width="0">Proxy ID</th>
											</tr>
										</thead>
									</table>
							 	</div>
								<div class="col-12" id="runStatusHistoryTableDiv">
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

	 								<table id="runStatusHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="10"><spring:message code="eXperDB_proxy.work_day" /></th>
												<th width="10"><spring:message code="eXperDB_proxy.work_time" /></th>
												<th width="15"><spring:message code="eXperDB_proxy.server_name" /></th>
												<th width="10"><spring:message code="eXperDB_proxy.system" /></th>
												<th width="10"><spring:message code="eXperDB_proxy.exe_type" /></th>
												<th width="15"><spring:message code="eXperDB_proxy.exe_run_type" /></th>
												<th width="10"><spring:message code="eXperDB_proxy.exe_result" /></th>
												<th width="15">오류 메세지</th>
												<th width="10"><spring:message code="common.modifier" /></th>
												<th width="0">작업 시간</th>
												<th width="0">최종 수정일시</th>
												<th width="0">기동 실행 일련번호</th>
												<th width="0">Proxy ID</th>
											</tr>
										</thead>
									</table>
							 	</div>
							 	<div class="col-12" id="statisTableDiv">
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
									<div class="row" style="margin-top:-20px;">
										<div class="col-12">
											<div class="template-demo">	
												<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnExcel" onclick="fn_ExportExcel()" data-toggle="modal">
													<i class="fa fa-file-excel-o btn-icon-prepend "></i><spring:message code="history_management.excel_save" />
												</button>
											</div>
										</div>
									</div>
	 								<table id="statisTable" class="table table-bordered system-tlb-scroll" style="width:100%;">
										<thead class="bg-info text-white text-center">
											<tr>
												<th rowspan="2"><spring:message code="common.dbServer"/> (IP)</th>
												<th rowspan="2"><spring:message code="eXperDB_proxy.server_name"/></th>
												<th rowspan="2" class="text-center"><spring:message code="eXperDB_proxy.listener_name"/></th>
												<th rowspan="2"><spring:message code="eXperDB_proxy.date"/></th>
												<th rowspan="2"><spring:message code="eXperDB_proxy.act_result"/></th>
												<th colspan="7"><spring:message code="dashboard.server"/></th>
												<th colspan="4"><spring:message code="eXperDB_proxy.session"/></th>
												<th colspan="2"><spring:message code="eXperDB_proxy.byte_in_out"/></th>
												<th rowspan="2">실행 일시</th>
												<th rowspan="2" width="0">마지막 연결 수신 이후 시간</th>
												<th rowspan="2" width="0">리스너 서버 ID</th>
												<th rowspan="2" width="0">리스너 ID</th>
												<th rowspan="2" width="0">실행 상태 일련번호</th>
												<th rowspan="2" width="0">로그 유형</th>
												<th rowspan="2" width="0">Proxy ID</th>
												<th rowspan="2" width="0">실행 일시</th>
												<th rowspan="2" width="0">최종 수정자 ID</th>
												<th rowspan="2" width="0">최종 수정 일시</th>
												<th rowspan="2" width="0">최초 등록자 ID</th>
												<th rowspan="2" width="0">최초 등록 일시</th>
												<th rowspan="2" width="0">DB명</th>
											</tr>
											<tr class="bg-info text-white text-center">
												<th width="10" class="text-center"><spring:message code="etc.etc25"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.last_status_chk"/></th>
												<th width="10" class="text-center"><spring:message code="eXperDB_proxy.downtime"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.req_sel_cnt"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.backup_svr_cnt"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.status_chg_cnt"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.chart_health_check_failed"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.current"/><br/><spring:message code="eXperDB_proxy.session_count"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.max"/><br/><spring:message code="eXperDB_proxy.session_count"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.session"/><br/><spring:message code="eXperDB_proxy.limit"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.session_total"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.byte_in"/></th>
												<th width="10"><spring:message code="eXperDB_proxy.byte_out"/></th>
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