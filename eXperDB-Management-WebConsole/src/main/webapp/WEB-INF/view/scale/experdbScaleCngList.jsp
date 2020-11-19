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
	* @Class Name : experdbScaleCngList.jsp
	* @Description : Auto scale 설정
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
<style>
/*툴팁 스타일*/
a.tip {
    position: relative;
    color:black;
}

a.tip span {
    display: none;
    position: absolute;
    top: 20px;
    left: -10px;
    width: 200px;
    padding: 5px;
    z-index: 100;
    background: #000;
    color: #fff;
    line-height: 20px;
    -moz-border-radius: 5px; /* 파폭 박스 둥근 정도 */
    -webkit-border-radius: 5px; /* 사파리 박스 둥근 정도 */
}

a:hover.tip span {
    display: block;
}

</style>
<script type="text/javascript">
	var msgVale = "";
	//scale 체크 조회
	var install_yn = "";
	var wrk_id_List = [];
	
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_init();

		//aws 서버 확인
		fn_selectScaleInstallChk();
	});
	
	/* ********************************************************
	 * 선택 활성화 클릭
	 ******************************************************** */
	function fn_autoScaleUseTot_click(tot_con_gbn){
		//scale 이 실행되고 있는 지 체크
		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
			},
			timeout: 8000,
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
				} else  if(status == "timeout") {
					showSwalIcon('<spring:message code="eXperDB_scale.msg23" />', '<spring:message code="common.close" />', '', 'error');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;

					if (wrk_id == "1") {
						showSwalIcon('<spring:message code="eXperDB_scale.msg4" />', '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						fn_autoScaleUseTot_exec(tot_con_gbn);
					}
				}
			}
		});
	}
	
	/* ********************************************************
	 * 선택 활성화 진행
	 ******************************************************** */
	function fn_autoScaleUseTot_exec(tot_con_gbn){
		var validateMsg = "";
		var datas = table.rows('.selected').data();
		var i_exe_status = 0;
		var i_un_exe_status = 0;
		wrk_id_List = [];

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (tot_con_gbn == "active") {
			for (var i = 0; i < datas.length; i++) {
	 			if(datas[i].useyn == "Y"){
					i_exe_status = i_exe_status + 1;
				} else {
					i_un_exe_status = i_un_exe_status + 1;

					wrk_id_List.push(datas[i].wrk_id);
				}
			}
			
			//실행 내역이 없는 경우
			if (i_un_exe_status <= 0) {
				showSwalIcon('<spring:message code="eXperDB_scale.msg26" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}

			if (i_exe_status > 0) {
				validateMsg = '<spring:message code="eXperDB_scale.msg27"/>';
			} else {
				validateMsg = '<spring:message code="eXperDB_scale.msg28"/>';
			}
		} else {
			for (var i = 0; i < datas.length; i++) {
 	 			if(datas[i].useyn == "Y"){
	 				i_exe_status = i_exe_status + 1;
	 				
	 				wrk_id_List.push(datas[i].wrk_id);
				} else {
					i_un_exe_status = i_un_exe_status + 1;
				}
			}
			
			//실행 내역이 없는 경우
			if (i_exe_status <= 0) {
				showSwalIcon('<spring:message code="eXperDB_scale.msg26" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}

			if (i_un_exe_status > 0) {
				validateMsg = '<spring:message code="eXperDB_scale.msg29"/>';
			} else {
				validateMsg = '<spring:message code="eXperDB_scale.msg30"/>';
			}
		}

		confile_title = '<spring:message code="menu.eXperDB_scale_settings" />' + " " + '<spring:message code="dbms_information.use_yn" />';

		$('#con_multi_gbn', '#findConfirmMulti').val(tot_con_gbn);
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html(validateMsg);
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_init(){
		var scale_type_nm_init = "";
		
		table = $('#scaleSetTable').DataTable({
			scrollY : "320px",
			scrollX : true,
			searching : false,
			deferRender : true,
			bSort: false,
			columns : [
				{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{data : "idx", className : "dt-center", defaultContent : ""}, 
				{data : "scale_type_nm", className : "dt-center", defaultContent : ""
						,"render": function (data, type, full) {
	 						if (full.scale_type == "1") {
	 							scale_type_nm_init = '<spring:message code="etc.etc38" />';
	 						} else {
	 							scale_type_nm_init = '<spring:message code="etc.etc39" />';
	 						}
							return '<span onClick=javascript:fn_wrkLayer("'+full.wrk_id+'"); class="bold" data-toggle="modal">' + scale_type_nm_init + '</span>';
						}
				},
				{
					data : "policy_type_nm", 
					render : function(data, type, full, meta) {
						var html = '';

						if (full.policy_type_nm == "CPU") {
							html += '<i class="mdi mdi-vector-square"></i>';
						} else {
							html += '<i class="mdi mdi-gender-transgender"></i>';
						}

						html += "&nbsp;" + full.policy_type_nm;
						return html;
					},
					className : "dt-center", defaultContent : ""
				},
				{
					data : "auto_policy_contents", 
					render : function(data, type, full, meta) {
						var html = '';

						if (full.auto_policy_set_div == "1") {
							html += '<spring:message code="eXperDB_scale.policy_time_1" />';
						} else {
							html += '<spring:message code="eXperDB_scale.policy_time_2" />';
						}

						html += "&nbsp;&nbsp;&nbsp;&nbsp;" + full.auto_policy_time + '&nbsp;' + '<spring:message code="eXperDB_scale.time_minute" />';
						return html;
					},
					className : "dt-left", defaultContent : ""
				},
				{
					data : "auto_level",
					render : function(data, type, full, meta) {
						var html = "";
						var rownum = full.rownum;
						var scale_type_id = full.scale_type;

						if (full.policy_type == "TC003501") {
							html += "<div class='row' style='width:150px;'><div class='col-8'>";
							
							if ( scale_type_id == '2' ) {
								html += "<div class='progress progress-lg mt-2' style='width:100%;'>";
								html += "	<div id='prgLevel_"+ rownum + "' class='progress-bar bg-info progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>";
								html += "</div>";
							} else {
								html += "<div class='progress progress-lg mt-2' style='width:100%;'>";
								html += "	<div id='prgLevel_"+ rownum + "' class='progress-bar bg-danger progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>";
								html += "</div>";
							}
							
							html += "</div>";
							
							html += "<div class='col-4' style='text-align: left;margin-left: -8px; margin-top: 6px;'>";
							html += full.auto_level + " %";
							html += "</div>";

							html += "</div></div>";
							
							html += "<input type='hidden' name='autoLevelHd' id='autoLevelHd_" + rownum + "' value='" + full.auto_level + "'>";
						} else {
							html += full.auto_level;
						}

						return html;
					},
					className : "dt-center", defaultContent : ""
				},
				{
					data : "execute_type_nm", 
					render : function(data, type, full, meta) {
						var html = '';
						
						if (full.execute_type == 'TC003402') {
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += full.execute_type_nm;
							html += "</div>";
						} else {
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-bell-o mr-2'></i>";
							html += full.execute_type_nm;
							html += "</div>";
						}

						return html;
					},
					className : "dt-center", defaultContent : ""
				},
				{
					data : "useyn", 
					render : function(data, type, full, meta) {
						var html = '';

						html += '<div class="onoffswitch-scale">';
						if(full.useyn == "Y"){
							html += '<input type="checkbox" name="useyn" class="onoffswitch-scale-checkbox" id="useyn'+ full.rownum +'" onclick="fn_use_scaleChk('+ full.rownum +')" checked>';
						}else {
							html += '<input type="checkbox" name="useyn" class="onoffswitch-scale-checkbox" id="useyn'+ full.rownum +'" onclick="fn_use_scaleChk('+ full.rownum +')" >';
						}
						html += '<label class="onoffswitch-scale-label" for="useyn'+ full.rownum +'">';
						html += '<span class="onoffswitch-scale-inner"></span>';
						html += '<span class="onoffswitch-scale-switch"></span></label>';
						 
						html += '<input type="hidden" name="chk_wrk_id" id="chk_wrk_id'+ full.rownum +'" value="'+ full.wrk_id +'"/>';

						return html;
					},
					className : "dt-center", defaultContent : ""
				},
				{data : "expansion_clusters", 
					render : function(data, type, full, meta) {
						var html = '';
						
						if (full.expansion_clusters != null && full.expansion_clusters != "") {
							html += full.expansion_clusters;
						} else {
							html += "N/A";
						}

						return html;
					},
					className : "dt-right", defaultContent : ""},
				{
					data : "min_clusters", 
					render : function(data, type, full, meta) {
						var html = '';
							
						if (full.min_clusters != null && full.min_clusters != "") {
							html += full.min_clusters;
						} else {
							html += "N/A";
						}

						return html;
					},
					className : "dt-right", defaultContent : ""},
				{data : "max_clusters", 
					render : function(data, type, full, meta) {
						var html = '';
								
						if (full.max_clusters != null && full.max_clusters != "") {
							html += full.max_clusters;
						} else {
							html += "N/A";
						}

						return html;
					},
					className : "dt-right", defaultContent : ""},
				{data : "frst_regr_id", defaultContent : ""},
				{data : "frst_reg_dtm", defaultContent : ""},
				{data : "lst_mdfr_id", defaultContent : ""},
				{data : "lst_mdf_dtm", defaultContent : ""},
				{data : "wrk_id", defaultContent : "", visible: false },
				{data : "useyn", defaultContent : "", visible: false }
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(14)').css('min-width', '100px');

		$(window).trigger('resize'); 
	}
	
	/* ********************************************************
	 * 활성화 클릭
	 ******************************************************** */
	function fn_autoScaleUse_click(row){
		if($("#useyn"+row).is(":checked") == true){
			$('#con_multi_gbn', '#findConfirmMulti').val("use_start");
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_scale.msg21" />');
		} else {
			$('#con_multi_gbn', '#findConfirmMulti').val("use_end");
			$('#confirm_multi_msg').html('<spring:message code="eXperDB_scale.msg25" />');
		}
		
		confile_title = '<spring:message code="menu.eXperDB_scale_settings" />' + " " + '<spring:message code="dbms_information.use_yn" />';
		$('#confirm_multi_tlt').html(confile_title);
		$('#chk_use_row', '#findList').val(row);
		
		$('#pop_confirm_multi_md').modal("show");
	}


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
					fn_search_list();
				} else {
					showDangerToast('top-right', '<spring:message code="eXperDB_scale.msg10" />', '<spring:message code="eXperDB_scale.msg14" />');
					
					//설치안된경우 버튼 막아야함
					$("#btnInsert").prop("disabled", "disabled");
					$("#btnModify").prop("disabled", "disabled");
					$("#btnDelete").prop("disabled", "disabled");
					$("#btnCommonInsert ").prop("disabled", "disabled");
 					$("#btnChoUse").prop("disabled", "disabled");
					$("#btnChoUnused").prop("disabled", "disabled");
					$("#btnCngSearch").prop("disabled", "disabled");

					$("#scale_type_cd").prop("disabled", "disabled");
					$("#policy_type_cd").prop("disabled", "disabled");
					$("#execute_type_cd").prop("disabled", "disabled");
				}
			}
		});
	}

	/* ********************************************************
	 * Scale Data Fetch List
	 ******************************************************** */
	function fn_search_list(){
		$.ajax({
			url : "/scale/selectScaleCngList.do", 
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				scale_type_cd : $("#scale_type_cd").val(),
				execute_type_cd : $("#execute_type_cd").val(),
				policy_type_cd : $("#policy_type_cd").val()
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

				if (nvlPrmSet(result, '') != '') {
					table.rows.add(result).draw();
				}
				
				//progres bar 설정
				fnc_progresbar_setting();
			}
		});
	}
	
	//cpu progres bar setting
	function fnc_progresbar_setting() {
		var autoLevelHdCnt = $("input[name=autoLevelHd]").length;

		if (autoLevelHdCnt > 0) {
			setTimeout(function()
				{
					for (var i = 1; i <= autoLevelHdCnt; i++) {
						if ($("#prgLevel_" + i) != null) {
							$("#prgLevel_" + i).val($("#autoLevelHd_" + i).val());
							$("#prgLevel_" + i).css("width", $("#autoLevelHd_" + i).val() + "%"); 
							$("#prgLevel_" + i).html($("#autoLevelHd_" + i).val() + "%"); 
						}
					}
				},1000);
		}
	}
	
	//sebu_cpu progres bar setting
	function fnc_sebu_progresbar_setting() {
		var autoLevelHdCnt = $("input[name=autoLevelHd]").length;

		if (autoLevelHdCnt > 0) {
			setTimeout(function()
				{
					$("#prgSsLevel").val($("#autoLevelSsHd").val());
					$("#prgSsLevel").css("width", $("#autoLevelSsHd").val() + "%"); 
					$("#prgSsLevel").html($("#autoLevelSsHd").val() + "%"); 
				},500);
		}
	}
	

	/* ********************************************************
	 * scale 설정 상세
	 ******************************************************** */
	function fn_wrkLayer(wrk_id){
		var auto_policy_set_div_nm = "";
		var level_nm = "";
		var execute_type_nm = "";
		var scale_type_nm = "";
		var policy_type_nm = "";
		var scale_type_id = "";
		var useyn_nm = "";
	
		$.ajax({
			url : "/scale/selectAutoScaleCngInfo.do",
			data : {
				wrk_id : wrk_id,
				db_svr_id : $("#db_svr_id", "#findList").val()
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
					msgVale = "<spring:message code='menu.eXperDB_scale_settings' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					
					$('#pop_layer_cng').modal('hide');
					return;
				}else{	
					$('#pop_layer_cng').modal("show");
					
					scale_type_id = result.scale_type;
			
					//확장유형
					if (result.scale_type == "1") {
						scale_type_nm = '<spring:message code="etc.etc38" />';
 					} else {
 						scale_type_nm = '<spring:message code="etc.etc39" />';
 					}
					$("#d_scale_type_nm").html(scale_type_nm);
					
					//정책유형
					if (nvlPrmSet(result.policy_type_nm, '') != "") {
						if (result.policy_type_nm == "CPU") {
							policy_type_nm += '<i class="mdi mdi-vector-square"></i>';
						} else {
							policy_type_nm += '<i class="mdi mdi-gender-transgender"></i>';
						}
						
						policy_type_nm += "&nbsp;" + nvlPrmSet(result.policy_type_nm, '');
					} else {
						policy_type_nm = "-";
					}
					$("#d_policy_type_nm").html(policy_type_nm);

					//정책 시간 구분
					if (result.auto_policy_set_div == "1") {
						auto_policy_set_div_nm = '<spring:message code="eXperDB_scale.policy_time_1" />';
 					} else {
 						auto_policy_set_div_nm = '<spring:message code="eXperDB_scale.policy_time_2" />';
 					}
					$("#d_auto_policy_set_div_nm").html(auto_policy_set_div_nm);

					//정책 시간
					$("#d_auto_policy_time").html(nvlPrmSet(result.auto_policy_time + ' ' +'<spring:message code="eXperDB_scale.time_minute" />', ''));
					
					//실행유형
					if (result.execute_type == 'TC003402') {
						execute_type_nm += "<div class='badge badge-pill badge-success'>";
						execute_type_nm += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
						execute_type_nm += result.execute_type_nm;
						execute_type_nm += "</div>";
 					} else {
 						execute_type_nm += "<div class='badge badge-pill badge-warning'>";
 						execute_type_nm += "	<i class='fa fa-bell-o mr-2'></i>";
 						execute_type_nm += result.execute_type_nm;
 						execute_type_nm += "</div>";
 					}
					$("#d_execute_type_nm").html(execute_type_nm);

					
					//사용여부
					if (result.useyn == 'Y') {
						useyn_nm += "<div class='badge badge-pill badge-primary'>";
						useyn_nm += "	<i class='fa fa-spin fa-refresh mr-2'></i>";
						useyn_nm += '<spring:message code="dbms_information.use" />';
						useyn_nm += "</div>";
 					} else {
 						useyn_nm += "<div class='badge badge-pill badge-danger'>";
 						useyn_nm += "	<i class='fa fa-times-circle mr-2'></i>";
 						useyn_nm += '<spring:message code="dbms_information.unuse" />';
 						useyn_nm += "</div>";
 					}
					$("#d_useyn").html(useyn_nm);

					//대상값
					if (result.auto_policy_set_div != null) {
						if (result.policy_type_nm == "CPU") {
							level_nm += "<div class='row' style='width:150px;'><div class='col-8'>";
							
							if ( scale_type_id == '2' ) {
								level_nm += "<div class='progress progress-lg mt-2' style='width:100%;'>";
								level_nm += "	<div id='prgSsLevel' class='progress-bar bg-info progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>";
								level_nm += "</div>";
							} else {
								level_nm += "<div class='progress progress-lg mt-2' style='width:100%;'>";
								level_nm += "	<div id='prgSsLevel' class='progress-bar bg-danger progress-bar-striped' role='progressbar' style='width: 0%' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'>0%</div>";
								level_nm += "</div>";
							}
							level_nm += "</div>";
							
							level_nm += "<div class='col-4' style='text-align: left;margin-left: -8px; margin-top: 6px;'>";
							level_nm += nvlPrmSet(result.auto_level, "-");

							if (nvlPrmSet(result.auto_level, "-") != "-") {
								level_nm += " %";
							}
							
							level_nm += "</div>";
							level_nm += "</div></div>";
							
							level_nm += "<input type='hidden' name='autoLevelSsHd' id='autoLevelSsHd' value='" + nvlPrmSet(result.auto_level, "") + "'>";
							
						} else {
							level_nm = nvlPrmSet(result.auto_level, "-");
						}
					} else {
						level_nm = "-";
					}
					$("#d_level").html(level_nm);
					
					//확장 노드수
					$("#d_expansion_clusters").html(nvlPrmSet(result.expansion_clusters,"N/A"));
					
					//최소 노드수
					$("#d_min_clusters").html(nvlPrmSet(result.min_clusters,"N/A"));

					//최대 노드수
					$("#d_max_clusters").html(nvlPrmSet(result.max_clusters,"N/A"));

					//등록자
					$("#d_frst_regr_id").html(nvlPrmSet(result.frst_regr_id,"-"));
					
					//등록일시
					$("#d_frst_reg_dtm").html(nvlPrmSet(result.frst_reg_dtm,"-"));

					//대상값 setting
					fnc_sebu_progresbar_setting();
				}
		
			}
		});	
	}
	
	/* ********************************************************
	* scale ing check
	******************************************************** */
	function fn_scaleChk(gbn) {
		//scale 이 실행되고 있는 지 체크
		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
			},
			timeout: 8000,
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
				} else  if(status == "timeout") {
					showSwalIcon('<spring:message code="eXperDB_scale.msg23" />', '<spring:message code="common.close" />', '', 'error');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;
					scale_set = result.scale_type;

					if (wrk_id == "1") {
						showSwalIcon('<spring:message code="eXperDB_scale.msg4" />', '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						if (gbn =="mod") {
							fn_mod_popup();
						} else if (gbn =="comIns") {
							fn_common_reg_popup();
						} else {
							fn_del_confirm();
						}
						
						
					}
				}
			}
		});
	}

	/* ********************************************************
	 * Scale common reg Btn click
	 ******************************************************** */
	function fn_common_reg_popup() {
		$.ajax({
			url : "/scale/selectAutoScaleComCngInfo.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
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
					msgVale = "<spring:message code='menu.eXperDB_scale_settings' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					
					$('#pop_layer_com_ins_cng').modal('hide');
					return;
				}else{
					//dbms 명
					$("#com_db_svr_nm").val(nvlPrmSet(result.db_svr_nm, ""));

					//dbms 명
					$("#com_ipadr").val(nvlPrmSet(result.ipadr, ""));
					
					//최대노드수
					$("#com_max_clusters").val(nvlPrmSet(result.max_clusters, ""));
					
					//최소노드수
					$("#com_min_clusters").val(nvlPrmSet(result.min_clusters, ""));
					
					// auto scale 실행 주기
					$("#com_auto_run_cycle").val(nvlPrmSet(result.auto_run_cycle, ""));
					
					$('#pop_layer_com_ins_cng').modal("show");
				}
			}
		});	
	}
	
	/* ********************************************************
	 * Scale reg Btn click
	 ******************************************************** */
	function fn_reg_popup(){
 		$.ajax({
			url : "/scale/popup/scaleAutoRegForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
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
					$("#ins_max_clusters_hd", "#insRegForm").val(nvlPrmSet(result.max_clusters, ""));

					//min Node
					$("#ins_min_clusters_hd", "#insRegForm").val(nvlPrmSet(result.min_clusters, ""));
				} else {
					$("#ins_max_clusters_hd", "#insRegForm").val("");
					$("#ins_min_clusters_hd", "#insRegForm").val("");
				}
				
				$("#ins_scale_type_cd", "#insRegForm").val("");
				$("#ins_execute_type_cd", "#insRegForm").val("");
				$("#ins_policy_type_cd", "#insRegForm").val("");
				$("#ins_auto_policy_time", "#insRegForm").val("");
				$("#ins_auto_level", "#insRegForm").val("");
				$("#ins_min_clusters", "#insRegForm").val("");
				$("#ins_max_clusters", "#insRegForm").val("");
				$("#ins_expansion_clusters", "#insRegForm").val("");
				$(':radio[name="ins_auto_policy_set_div"]:checked').val("1");
				$(':radio[name="ins_useyn"]:checked').val("Y");
				
				$("#ins_expansion_clusters", "#insRegForm").prop('disabled', true);
				
				$("#ins_check_execute_sp", "#insRegForm").hide();

				$('#pop_layer_ins_cng').modal("show");
			}
		});
	}

	/* ********************************************************
	 * scale setting Data Delete
	 ******************************************************** */
	function fn_del_confirm(){
		var wrk_id = "";
		var scale_set = "";
		var confile_title = "";
		var i_exe_status = 0;

		var datas = table.rows('.selected').data();

		if(datas.length < 1){
			showSwalIcon('<spring:message code="message.msg16" />', '<spring:message code="common.close" />', '', 'warning');
			return false;
		}
		
		for (var i = 0; i < datas.length; i++) {
 			if(datas[i].useyn == "Y"){
				i_exe_status = i_exe_status + 1;
			}
		}

		if (i_exe_status > 0) {
			validateMsg = '<spring:message code="eXperDB_scale.msg33"/>';
			showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
			return;
		}

		confile_title = '<spring:message code="menu.eXperDB_scale_settings" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';

		$('#con_multi_gbn', '#findConfirmMulti').val("del");
		
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg17" />');
		$('#pop_confirm_multi_md').modal("show");
	}

	/* ********************************************************
	 * scale setting Data Delete
	 ******************************************************** */
	function fn_del_data(){
		var scale_set = "";
		
		var datas = table.rows('.selected').data();

		var wrk_id_List = [];
		for (var i = 0; i < datas.length; i++) {
			wrk_id_List.push( table.rows('.selected').data()[i].wrk_id); 
		}

 		$.ajax({
			url : "/scale/scaleWrkIdDelete.do",
			data : {
				wrk_id_List : JSON.stringify(wrk_id_List),
				db_svr_id : $("#db_svr_id", "#findList").val()
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
				if(result == "O" || result == "F"){//저장실패
					msgVale = "<spring:message code='menu.eXperDB_scale_settings' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'success');
					return;
				}else{
					showSwalIcon('<spring:message code="message.msg60"/>', '<spring:message code="common.close" />', '', 'success');
					fn_search_list();
				}
			}
		});
	}

	/* ********************************************************
	 * scale Aotu Reregist Window Open
	 ******************************************************** */
	function fn_mod_popup(){
		var datas = table.rows('.selected').data();
		var validateMsg = "";
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if(table.row('.selected').data().useyn == "Y"){
			validateMsg = '<spring:message code="eXperDB_scale.msg33"/>';
			showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
			return;
		}

		$('#wrk_id', '#frmRegPopup').val(table.row('.selected').data().wrk_id);

 		$.ajax({
			url : "/scale/popup/scaleAutoReregForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
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
					$("#mod_max_clusters_hd", "#scaleReregForm").val(nvlPrmSet(result.max_clusters, ""));

					//min Node
					$("#mod_min_clusters_hd", "#scaleReregForm").val(nvlPrmSet(result.min_clusters, ""));
				} else {
					$("#mod_max_clusters_hd", "#scaleReregForm").val("");
					$("#mod_min_clusters_hd", "#scaleReregForm").val("");
				}
				
				$("#mod_scale_type_cd", "#scaleReregForm").val("");
				$("#mod_execute_type_cd", "#scaleReregForm").val("");
				$("#mod_policy_type_cd", "#scaleReregForm").val("");
				$("#mod_auto_policy_time", "#scaleReregForm").val("");
				$("#mod_auto_level", "#scaleReregForm").val("");
				$("#mod_min_clusters", "#scaleReregForm").val("");
				$("#mod_max_clusters", "#scaleReregForm").val("");
				$("#mod_expansion_clusters", "#scaleReregForm").val("");
				$(':radio[name="mod_auto_policy_set_div"]:checked').val("1");
				$(':radio[name="mod_useyn"]:checked').val("Y");

				$("#mod_expansion_clusters", "#scaleReregForm").prop('disabled', true);
				$("#mod_check_execute_sp", "#scaleReregForm").hide();
				
				$('#pop_layer_mod_cng').modal("show");
				
				//데이터 조회
				fnc_mod_search();
			}
		});
	}
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		if ($('#chk_use_row', '#findList') != null) {
			var canCheckId = 'useyn' + $('#chk_use_row', '#findList').val();
			
			if (gbn == "use_start") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", false); 
			} else if (gbn == "use_end") {
				$("input:checkbox[id='" + canCheckId + "']").prop("checked", true); 
			}
		}
	}
	
	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "del") {
			fn_del_data();
		} else if (gbn == "use_start" || gbn == "use_end") {
			fn_use_execute(gbn);
		} else if (gbn == "active" || gbn == "disabled") {
			fn_tot_use_execute(gbn);
		}
	}
	
	/* ********************************************************
	 * 사용여부 선택실행
	 ******************************************************** */
	function fn_tot_use_execute(use_gbn) {
		var validateMsg ="";

		$.ajax({
			url : "/scale/scaleTotCngUseUpdate.do",
			data : {
				use_gbn : use_gbn,
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_id_List : JSON.stringify(wrk_id_List)
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				//버튼제어
				fn_buttonExecuteAut("end", "");
				
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg03" />', '<spring:message code="common.close" />', '', 'error', 'top');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				//버튼제어
				if (result == null) {
					validateMsg = '<spring:message code="eXperDB_scale.msg24"/>';
					showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
					return;
				} else {
					if (result == "success") {
						showSwalIcon('<spring:message code="data_transfer.msg16" />', '<spring:message code="common.close" />', '', 'success');
						fn_search_list();
					} else {
						validateMsg = '<spring:message code="eXperDB_scale.msg24"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						return;
					}
				}
			}
		});
	}
	
	

	/* ********************************************************
	 * 사용여부 단건실행
	 ******************************************************** */
	function fn_use_execute(use_gbn) {
		var ascRow =  $('#chk_use_row', '#findList').val();
		var useVal = "";
		var validateMsg ="";
		var checkId = "";

		if (use_gbn == "use_start") {
			useVal = "Y";
		} else {
			useVal = "N";
		}

		$.ajax({
			url : "/scale/scaleCngUseUpdate.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_id : $('#chk_wrk_id' + ascRow).val(),
				useyn : useVal
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
				checkId = 'transActivation' + ascRow;

				if (result == null) {
					validateMsg = '<spring:message code="eXperDB_scale.msg24"/>';
					showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						
					$("input:checkbox[id='" + checkId + "']").prop("checked", false); 
					return;
				} else {
					if (result == "success") {
						fn_search_list();
					} else {
						validateMsg = '<spring:message code="eXperDB_scale.msg24"/>';
						showSwalIcon(fn_strBrReplcae(validateMsg), '<spring:message code="common.close" />', '', 'error');
						
						$("input:checkbox[id='" + checkId + "']").prop("checked", false);
						return;
					}
				}
			}
		});
	}
	
	/* ********************************************************
	* scale 사용여부관련 scale 체크
	******************************************************** */
	function fn_use_scaleChk(row) {
		//scale 이 실행되고 있는 지 체크
		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
			},
			timeout: 8000,
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
				} else  if(status == "timeout") {
					showSwalIcon('<spring:message code="eXperDB_scale.msg23" />', '<spring:message code="common.close" />', '', 'error');
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;

					if (wrk_id == "1") {
						showSwalIcon('<spring:message code="eXperDB_scale.msg4" />', '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						fn_autoScaleUse_click(row);
					}
				}
			}
		});
	}
</script>

<%@include file="./../popup/scaleAutoRegForm.jsp"%>
<%@include file="./../popup/scaleAutoComRegForm.jsp"%>
<%@include file="./../popup/scaleAutoReregForm.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>

<%@include file="./experdbScaleCngInfo.jsp"%>

<form name="frmRegPopup" id="frmRegPopup" method="post">
	<input type="hidden" name="wrk_id" id="wrk_id" value=""/>
</form>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
		<input type="hidden" name="chk_use_row" id="chk_use_row" value=""/>
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
												<i class="fa fa-cog"></i>
												<span class="menu-title"><spring:message code="menu.eXperDB_scale_settings"/></span>
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
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.eXperDB_scale_settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_scale_settings"/></p>
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

							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="scale_type_cd" id="scale_type_cd">
										<option value=""><spring:message code="eXperDB_scale.scale_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
										<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
									</select>
								</div> 

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="policy_type_cd" id="policy_type_cd">
										<option value=""><spring:message code="eXperDB_scale.policy_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${policyTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" name="execute_type_cd" id="execute_type_cd">
										<option value=""><spring:message code="eXperDB_scale.execute_type" />&nbsp;<spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${executeTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnCngSearch" onClick="fn_search_list();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnCommonInsert" onClick="fn_scaleChk('comIns');" data-toggle="modal">
									<i class="fa fa-cog btn-icon-prepend "></i><spring:message code="common.reg_default_setting" />
								</button>
	 							<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnChoUse" onClick="fn_autoScaleUseTot_click('active');" data-toggle="modal">
									<i class="fa fa-spin fa-cog btn-icon-prepend "></i><spring:message code="eXperDB_scale.save_select_use" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnChoUnused" onClick="fn_autoScaleUseTot_click('disabled');" data-toggle="modal">
									<i class="fa fa-spin fa-cog btn-icon-prepend "></i><spring:message code="eXperDB_scale.save_select_unused" />
								</button>

								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_scaleChk('del');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onClick="fn_scaleChk('mod');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_reg_popup();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
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

	 								<table id="scaleSetTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="40" height="0"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="eXperDB_scale.scale_type" /></th> <!-- scale 유형 -->
												<th width="100"><spring:message code="eXperDB_scale.policy_type" /></th> <!-- 정책 유형 -->
												<th width="200"><spring:message code="eXperDB_scale.policy_type_time" /></th> <!-- 정책 유형 시간 -->
												<th width="100"><spring:message code="eXperDB_scale.target_value" /></th> <!-- level -->
												<th width="100"><spring:message code="eXperDB_scale.execute_type" /></th> <!-- 실행 유형 -->
												<th width="100"><spring:message code="dbms_information.use_yn" /></th> <!-- 사용여부 -->
												<th width="100"><spring:message code="eXperDB_scale.expansion_clusters" /></th> <!-- 확장 노드수 -->
												<th width="100"><spring:message code="eXperDB_scale.min_clusters" /></th> <!-- 최소 노드수 -->
												<th width="100"><spring:message code="eXperDB_scale.max_clusters" /></th> <!-- 최대 노드수 -->
												<th width="100"><spring:message code="common.register" /></th> <!-- 등록자 -->
												<th width="100"><spring:message code="common.regist_datetime" /></th> <!-- 등록일시 -->
												<th width="100"><spring:message code="common.modifier" /></th> <!-- 수정자 -->
												<th width="100"><spring:message code="common.modify_datetime" /></th> <!-- 수정일시 -->
											</tr>
										</thead>
									</table>
							 	</div>
						 	</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
	</div>
</div>