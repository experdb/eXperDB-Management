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

	$(window.document).ready(function() {
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
		}
		
		selectTab("settingChange");
		
	});
	
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
		         				var html = "";
			         			html += '<button type="button" class="btn btn-link btn-fw" onclick="fn_show_conf(\'P\','+full.pry_svr_id+',\''+full.pry_svr_nm+'\','+full.pry_cng_sn+')">';
								html += '<i class="item-icon fa fa-file-text-o"></i> 설정 보기';
								html += '</button>';
								return html;
		         			}
			         	}, 
			         	{data: "kal_pth", className: "dt-center", defaultContent: "",
			         		render: function (data, type, full){
		         				var html = "";
			         			html += '<button type="button" class="btn btn-link btn-fw" onclick="fn_show_conf(\'K\','+full.pry_svr_id+',\''+full.pry_svr_nm+'\','+full.pry_cng_sn+')">';
								html += '<i class="item-icon fa fa-file-text-o"></i> 설정 보기';
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
		settingChgHistoryTable.tables().header().to$().find('th:eq(5)').css('min-width', '15%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(7)').css('min-width', '10%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(8)').css('min-width', '0%');
		settingChgHistoryTable.tables().header().to$().find('th:eq(9)').css('min-width', '0%');

		   	
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
								return "Virtual IP";
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
								return "수동";
							}else if(full.act_exe_type == "TC004002"){
								return "자동";
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
	   	
	   	
	   	
    	$(window).trigger('resize'); 
    	
    	
    	
    	//더블클릭 하면 해당 서버 그 날짜의 로그 보여주기... 모니터링 페이지 참고 ㅎ
	}

	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate());
		var day_start = today.toJSON().slice(0,10); 

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
		
		
	}
	
	/* ********************************************************
	 *  엑셀다운로드
	 ******************************************************** */
	function fn_ExportExcel() {
		var table = document.getElementById("runStatusHistoryTable");
		var dataCnt = runStatusHistoryTable.rows.length;

		if (dataCnt ==1) {
			showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		} else {
			var lgi_dtm_start = $("#lgi_dtm_start_").val();
			var lgi_dtm_end = $("#to").val();
			var search = "%" + $("#search").val() + "%";
			var type = $("#type").val();
			var order_type = $("#order_type").val();
			var order = $("#order").val();
			var sys_cd = $("#sys_cd").val();
			
			var form = document.excelForm;

			$("#lgi_dtm_start").val(lgi_dtm_start);
			$("#lgi_dtm_end").val(lgi_dtm_end);
			$("#excel_search").val(search);
			$("#excel_type").val(type);
			$("#excel_order_type").val(order_type);
			$("#excel_order").val(order);
			$("#excel_sys_cd").val(sys_cd);
			
			//loading bar 호출
			setCookie("fileDownload","false"); //호출
			checkDownloadCheck();
			
			form.action = "/accessHistory_Excel.do";
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
	  * Tab Click
	  ******************************************************** */
	 function selectTab(tab){
	 	if(tab == "settingChange"){ //설정변경 이력
	 		
	 		$("#searchSettingChg").show();
	 		$("#searchActStatus").hide();
	 		
	 		$("#settingChgHistoryTableDiv").show();
	 		$("#runStatusHistoryTableDiv").hide();
	 		
	 		fn_setchg_select();
	 	}else if(tab == "ActStatus"){ //기동상태 변경 이력
	 		
	 		$("#searchSettingChg").hide();
	 		$("#searchActStatus").show();
	 		
	 		$("#settingChgHistoryTableDiv").hide();
	 		$("#runStatusHistoryTableDiv").show();
	 		
	 		fn_actstate_select();
	 	}else{ //실시간 상태 로그
	 		$("#searchSettingChg").hide();
	 		$("#searchActStatus").hide();
	 	
	 		$("#settingChgHistoryTableDiv").hide();
	 		$("#runStatusHistoryTableDiv").hide();
	 		
	 	}
	 }
	 
	 /* ********************************************************
	  * config file confirm button Click
	  ******************************************************** */
	 function fn_popup_conf(sysTeyp,svrId,svrNm, chgId){
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
	 }
	 /* ********************************************************
	  * config file 내용 갖고 오기
	  ******************************************************** */
	  function fn_show_conf(sysType,svrId,svrNm,chgId){
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
	 				console.log(result);
	 				if(result.errcd > -1){
	 					if(result.errcd==0){//정상
							$('#pop_layer_config_view').modal("show");
							$("#config", "#configForm").html(result.presentConf);
							$("#backup_config", "#configForm").html(result.backupConf);
							
							if(sysType == "P"){
								$(".config_title").html(' ' + svrNm + ' Proxy Configuration');
							} else {
								$(".config_title").html(' ' + svrNm + ' Vip Configuration');
							}
							
							var tableDatas = settingChgHistoryTable.rows().data();
							var datasLen = tableDatas.length;
							
							for(var i=0; i<datasLen; i++){
								if(tableDatas[i].pry_svr_id == svrId && tableDatas[i].pry_cng_sn == chgId){
									$("#backupConfTitle").html('<i class="item-icon fa fa-dot-circle-o"></i> 백업 Config : '+tableDatas[i].lst_dtm_date+' '+tableDatas[i].lst_dtm_hour);
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
	 
	function fn_showExeFailLog(prySvrId, pryActExeSn){
  		var datas = runStatusHistoryTable.rows().data();
  		var dataLen = datas.length;
  		
  		for(var i=0; i<dataLen; i++){
  			if(datas[i].pry_svr_id == prySvrId && datas[i].pry_act_exe_sn == pryActExeSn){
  				$("#wrkLogInfo").html(datas[i].rslt_msg);
  				$("#ModalLabel","#pop_layer_wrkLog").html("오류 메세지");
  				$("#pop_layer_wrkLog").modal("show");	
  			}
  		}
  		
		
	}
</script>
<%@include file="./../popup/proxyConfigDiffViewPop.jsp"%>
<%@include file="./../../cmmn/wrkLog.jsp"%>
<%-- <form name="excelForm" method="post">
	<input type="hidden" name="lgi_dtm_start" id="lgi_dtm_start">
	<input type="hidden" name="lgi_dtm_end" id="lgi_dtm_end"> 
	<input type="hidden" name="excel_type" id="excel_type">
	<input type="hidden" name="excel_search" id="excel_search">
	<input type="hidden" name="excel_order_type" id="excel_order_type">
	<input type="hidden" name="excel_order" id="excel_order">
	<input type="hidden" name="excel_sys_cd" id="excel_sys_cd">
</form> --%>

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
												<span class="menu-title">Proxy 이력 관리</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">Proxy</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">Proxy 관리</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">Proxy 이력 관리</li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<%-- <p class="mb-0"><spring:message code="help.screen_access_history_01" /></p>
											<p class="mb-0"><spring:message code="help.screen_access_history_02" /></p> --%>
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
								설정 변경 이력
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="server-tab-2" data-toggle="pill" href="#subTab-2" role="tab" aria-controls="subTab-2" aria-selected="false" onclick="javascript:selectTab('ActStatus');">
								기동 상태 변경 이력
							</a>
						</li>
						<!-- <li class="nav-item">
							<a class="nav-link" id="server-tab-3" data-toggle="pill" href="#subTab-3" role="tab" aria-controls="subTab-3" aria-selected="false" onclick="javascript:selectTab('SvrStatus');">
								실시간 상태 로그 
							</a>
						</li> -->
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
	 									<option value="">Proxy 명 <spring:message code="common.total" /></option>	
										<c:forEach var="prySvrList" items="${prySvrList}">
											<option value="${prySvrList.pry_svr_id}">${prySvrList.pry_svr_nm}</option>							
										</c:forEach>
									</select>
								</div>		
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="setchg_exe_rst_cd" id="setchg_exe_rst_cd">
										<option value="">실행 결과 <spring:message code="common.total" /></option>	
										<option value="TC001501">성공</option> 
	 									<option value="TC001502">실패</option>
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
									<select class="form-control" tyle="margin-right: -0.7rem;" name="actstate_pry_svr_id" id="actstate_pry_svr_id">
	 									<option value="">Proxy 명 <spring:message code="common.total" /></option>	
										<c:forEach var="prySvrList" items="${prySvrList}">
											<option value="${prySvrList.pry_svr_id}">${prySvrList.pry_svr_nm}</option>							
										</c:forEach>
									</select>
								</div>		
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" tyle="margin-right: -0.7rem;" name="actstate_sys_type" id="actstate_sys_type">
										<option value="">시스템 유형 <spring:message code="common.total" /></option>	
	 									<option value="PROXY">Proxy</option> 
	 									<option value="KEEPALIVED">Virtual IP</option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" tyle="margin-right: -0.7rem;" name="actstate_act_type" id="actstate_act_type">
										<option value="">기동 유형 <spring:message code="common.total" /></option>	
	 									<option value="A">기동</option> 
	 									<option value="R">재기동</option>
	 									<option value="S">중지</option>
									</select>	
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="actstate_act_exe_type" id="actstate_act_exe_type">
										<option value="">기동 실행 유형 <spring:message code="common.total" /></option>	
										<option value="TC004001">수동</option>
	 									<option value="TC004002">자동</option>
										<%-- <c:forEach var="actExeTypeCd" items="${actExeTypeCd}">
											<option value="${actExeTypeCd.sys_cd}">${actExeTypeCd.sys_cd_nm}</option>							
										</c:forEach> --%>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="actstate_exe_rslt_cd" id="actstate_exe_rslt_cd">
										<option value="">실행 결과 <spring:message code="common.total" /></option>	
										<option value="TC001501">성공</option> 
	 									<option value="TC001502">실패</option>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="actstate_button"onclick="fn_actstate_select()" >
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
												<th width="10">작업 일시</th>
												<th width="10">작업 시간</th>
												<th width="15">Proxy 명</th>
												<th width="15">Proxy</th>
												<th width="15">Virtaul IP</th>
												<th width="10">실행 결과</th>
												<th width="10">최종 수정자 ID</th>
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
												<th width="10">작업 일시</th>
												<th width="10">작업 시간</th>
												<th width="15">Proxy 명</th>
												<th width="10">시스템 유형</th>
												<th width="10">기동 유형</th>
												<th width="15">기동 실행 유형</th>
												<th width="10">실행 결과</th>
												<th width="15">오류 메세지</th>
												<th width="10">최종 수정자 ID</th>
												<th width="0">작업 시간</th>
												<th width="0">최종 수정일시</th>
												<th width="0">기동 실행 일련번호</th>
												<th width="0">Proxy ID</th>
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