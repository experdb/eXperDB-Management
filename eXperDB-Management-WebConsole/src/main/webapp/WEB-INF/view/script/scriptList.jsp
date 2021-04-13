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
	* @Class Name : scriptList.jsp
	* @Description : 배치목록
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  2018.06.08     최초 생성
    *	
	* author 변승우
	* since 2018.06.08
	*
	*/
%>
<script type="text/javascript">
	var table = null;
	var confile_title = "";
	
	var bck_wrk_id_List = [];
	var wrk_id_List = [];
	
	var scheduleTable = null;
	var scd_cndt = null;
	
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		$('#right_test').hide();
		
		
		//테이블 setting
		fn_init();
		
		//스케줄 테이즐 setting
		fn_init_schedule();

		//배치 내역 조회
		fn_mainsearch();
	});

	/* ********************************************************
	 * 배치설정 리스트
	 ******************************************************** */
	function fn_init(){
		table = $('#scriptTable').DataTable({
			scrollY : "305px",
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
				{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 				
				{data : "idx", className : "dt-center", defaultContent : ""}, 
				{data : "wrk_nm", className : "dt-left", defaultContent : ""
					,"render": function (data, type, full) {				
						  return '<span onClick=javascript:fn_scriptLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
					}
				},
/* 				{data : "wrk_id", className : "dt-center", defaultContent : ""
					,"render": function (data, type, full) {				
						  return '<button class="btn btn-outline-primary" onClick=javascript:fn_schduleList("'+full.wrk_id+'");>View</button>';
					}
				}, */
				{ data : "wrk_exp",
					render : function(data, type, full, meta) {	 	
						var html = '';					
						html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
						return html;
					},
					defaultContent : ""
				},
				{data : "frst_regr_id", defaultContent : ""},
				{data : "frst_reg_dtm", defaultContent : ""},
				{data : "lst_mdfr_id", defaultContent : ""},
				{data : "lst_mdf_dtm", defaultContent : ""},
				{data : "wrk_id", defaultContent : "", visible: false },
				{data : "bck_wrk_id", defaultContent : "", visible: false }
			], 'select': {'style': 'multi'}
		});
	
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
/* 		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px'); */
		table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '110px');  
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');

		$(window).trigger('resize'); 
/* 	
		//더블 클릭시
		$('#scriptTable tbody').on('dblclick','tr',function() {
			var wrk_id_up = table.row(this).data().wrk_id;
			
			fn_dblclick_updateform(wrk_id_up);
		});
		 */
		$('#scriptTable tbody').on('click','tr',function() {
			var wrk_id_up = table.row(this).data().wrk_id;
			
			fn_schdule_pop_List(wrk_id_up);
		});
	}

	/* ********************************************************
	 * script setting Data Fetch List
	 ******************************************************** */	
	function fn_mainsearch(){
		fn_schedule_leftListSize();

		$.ajax({
			url : "/selectScriptList.do", 
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_nm : $("#wrk_nm").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', "top");
				} else if(xhr.status == 403) {
					showSwalIconRst('<spring:message code="message.msg02" />', '<spring:message code="common.close" />', '', 'error', "top");
					top.location.href = "/";
				} else {
					showSwalIcon("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""), '<spring:message code="common.close" />', '', 'error');
				}
			},
			success : function(data) {
				table.rows({selected: true}).deselect();
				table.clear().draw();
	
					if (nvlPrmSet(data, '') != '') {
					table.rows.add(data).draw();
				}
			}
		}); 
	}

	/* ********************************************************
	 * script reg Btn click
	 ******************************************************** */
	function fn_reg_popup(){
		fn_schedule_leftListSize();

		$('#pop_layer_ins_script').modal("hide");

		$.ajax({
			url : "/popup/scriptRegForm.do",
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
				$('#pop_layer_ins_script').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * script rereg Btn click
	 ******************************************************** */
	 function fn_dblclick_updateform(wrk_id_up) {
		 fn_schedule_leftListSize();

		$('#wrk_id', '#findList').val(wrk_id_up);

	 	$.ajax({
			url : "/popup/scriptReregForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_id : $('#wrk_id', '#findList').val()
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
				//초기화
				if (result.length > 0) {
					$("#mod_wrk_nm", "#modRegForm").val(nvlPrmSet(result[0].wrk_nm, ""));
					$("#mod_wrk_exp", "#modRegForm").val(nvlPrmSet(result[0].wrk_exp, ""));
					$("#mod_exe_cmd", "#modRegForm").val(nvlPrmSet(result[0].exe_cmd, ""));
					
					$('#pop_layer_mod_script').modal("show");
				} else {
					showSwalIcon('<spring:message code="info.nodata.msg" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * script rereg Btn click
	 ******************************************************** */
	 function fn_rereg_popup(){
		 fn_schedule_leftListSize();

		var datas = table.rows('.selected').data();
			
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(datas.length > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		$('#wrk_id', '#findList').val(table.row('.selected').data().wrk_id);

 		$.ajax({
			url : "/popup/scriptReregForm.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				wrk_id : $('#wrk_id', '#findList').val()
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
				//초기화
				if (result.length > 0) {
					$("#mod_wrk_nm", "#modRegForm").val(nvlPrmSet(result[0].wrk_nm, ""));
					$("#mod_wrk_exp", "#modRegForm").val(nvlPrmSet(result[0].wrk_exp, ""));
					$("#mod_exe_cmd", "#modRegForm").val(nvlPrmSet(result[0].exe_cmd, ""));
					
					$('#pop_layer_mod_script').modal("show");
				} else {
					showSwalIcon('<spring:message code="info.nodata.msg" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
		
	/* ********************************************************
	 * 스케줄 활용여부 체크
	 ******************************************************** */
	 function fn_scheduleCheck(){
		 fn_schedule_leftListSize();

		bck_wrk_id_List = [];
		wrk_id_List = [];

		var datas = table.rows('.selected').data();

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		for (var i = 0; i < datas.length; i++) {
			bck_wrk_id_List.push( table.rows('.selected').data()[i].bck_wrk_id);   
			wrk_id_List.push( table.rows('.selected').data()[i].wrk_id);   
		}

		$.ajax({
			url : "/popup/scheduleCheck.do",
			data : {
				wrk_id_List : JSON.stringify(wrk_id_List)
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
			success : function(data) {
				if (data != null && data == 0) {
					fn_del_confirm();
				} else {
					showSwalIcon('<spring:message code="backup_management.reg_schedule_delete_no" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
		
	/* ********************************************************
	 * scale setting Data Delete
	 ******************************************************** */
	function fn_del_confirm(){

		confile_title = '<spring:message code="menu.script_settings" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
				
		$('#confirm_tlt').html(confile_title);
		$('#confirm_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_md').modal("show");
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmRst(){
		fn_delete();
	}

	/* ********************************************************
	 * 배치 설정 삭제
	 ******************************************************** */
	function fn_delete(){
		$.ajax({
			url : "/deleteScript.do", 
			data : {
				wrk_id_List : JSON.stringify(wrk_id_List)
			},
			//dataType : "json",
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
			success : function(data) {
				if(data == "O" || data == "F"){//저장실패
					msgVale = "<spring:message code='menu.script_settings' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}else{
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_mainsearch();
				}
			}
		});
	}

	//스케줄 테이블
	function fn_init_schedule(){
		/* ********************************************************
		* work리스트
		******************************************************** */
		scheduleTable = $('#scheduleList').DataTable({
			scrollY : "305px",
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
				{data : "rownum",  className : "dt-center", defaultContent : ""}, 		
				{data : "scd_nm", className : "dt-left", defaultContent : ""
					,render: function (data, type, full) {
						  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold" title="'+full.scd_nm+'">' + full.scd_nm + '</span>';
					}
				},
				{ data : "scd_exp",
						render : function(data, type, full, meta) {	 	
							var html = '';					
							html += '<span title="'+full.scd_exp+'">' + full.scd_exp + '</span>';
							return html;
						},
						defaultContent : ""
					},
				{data : "wrk_cnt",  className : "dt-right", defaultContent : ""}, //work갯수
				{data : "prev_exe_dtm",  defaultContent : ""
					,render: function (data, type, full) {
					if(full.prev_exe_dtm == null){
						var html = '-';
						return html;
					}
				  return data;
				}}, 
				{data : "nxt_exe_dtm",  defaultContent : ""
					,render: function (data, type, full) {
						if(full.nxt_exe_dtm == null){
							var html = '-';
							return html;
						}
					  return data;
				}}, 
				{data : "status", 
					render: function (data, type, full){
						var html = "";
						if(full.scd_cndt == "TC001801"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-minus-circle mr-2'></i>";
							html += "<spring:message code='common.waiting' />";
							html += "</div>";
						}else if(full.scd_cndt == "TC001802"){
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "<spring:message code='dashboard.running' />";
							html += "</div>";
						}else{
							html += "<div class='badge badge-pill badge-danger'>";
							html += "	<i class='ti-close mr-2'></i>";
							html += "<spring:message code='schedule.stop' />";
							html += "</div>";
						}

						return html;
					},
					className : "dt-center",
					 defaultContent : "" 	
				},

				{data : "status", 
					render: function (data, type, full){	
						var html = "";
						if(full.scd_cndt == "TC001801"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-minus-circle mr-2'></i>";
							html += "<spring:message code='access_control_management.activation' />";
							html += "</div>";
						}else if(full.scd_cndt == "TC001802"){
							html += "<div class='badge badge-pill badge-warning'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "<spring:message code='dashboard.running' />";
							html += "</div>";
						}else{
							html += "<div class='badge badge-pill badge-danger'>";
							html += "	<i class='ti-close mr-2'></i>";
							html += "<spring:message code='etc.etc41' />";
							html += "</div>";
						}		

						return html;
					},
					className : "dt-center",
					defaultContent : "" 	
				},
				{
					data : "",
					render: function (data, type, full) {				
						  return '<button id="detail" class="btn btn-outline-primary" onClick=javascript:fn_dblclick_pop_scheduleInfo("'+full.scd_id+'");><spring:message code="data_transfer.detail_search" /> </button>';
					},
					className : "dt-center",
					defaultContent : "",
					orderable : false
				},
				{data : "scd_id",  defaultContent : "", visible: false },
				{data : "exe_dt",  defaultContent : "", visible: false },
			]
		});

		//더블 클릭시
		$('#scheduleList tbody').on('dblclick','tr',function() {
			var scd_id_up = scheduleTable.row(this).data().scd_id;

			fn_dblclick_pop_scheduleInfo(scd_id_up);
		});
		
		scheduleTable.tables().header().to$().find('th:eq(1)').css('min-width', '30px');	  
		scheduleTable.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		scheduleTable.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
		scheduleTable.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
		scheduleTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(7)').css('min-width', '80px');  
		scheduleTable.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		scheduleTable.tables().header().to$().find('th:eq(10)').css('min-width', '0px');
		scheduleTable.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
	    $(window).trigger('resize'); 
	}

	/* ********************************************************
	 * 배치 즉시 실행
	 ******************************************************** */
	function fn_ImmediateStart(){
		var db_svr_id = '<c:out value="${db_svr_id}"/>';
		var datas = table.rows('.selected').data();
		var rowCnt = table.rows('.selected').data().length;

		if(rowCnt <= 0){
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;	
		}else if(rowCnt > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		if (confirm("즉시실행 하시겠습니까?")) {			
		 $.ajax({
			url : "/scriptImmediateExe.do",
		  	data : {
		  		wrk_id:datas[0].wrk_id,
		  		wrk_exp:datas[0].wrk_exp,
		  		db_svr_id:db_svr_id, 
		  		exe_cmd:datas[0].exe_cmd
		  	},
		  	timeout : 1000,    
			type : "post",
			async: true,
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {		
			}
		});		 
	}	
}
</script>

<%@include file="../cmmn/workScriptInfo.jsp"%>
<%@include file="./../popup/scriptRegForm.jsp"%>
<%@include file="./../popup/scriptReregForm.jsp"%>
<%@include file="./../popup/confirmForm.jsp"%>
<%@include file="./../popup/scheduleWrkList.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="wrk_id" id="wrk_id" value=""/>
	<input type="hidden" name="scd_id" id="scd_id" value=""/>
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
												<span class="menu-title"><spring:message code="menu.script_settings"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.script_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.script_settings"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.script_settings_01"/></p>
											<p class="mb-0"><spring:message code="help.script_settings_02"/></p>
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
							<form class="form-inline row" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2 col-sm-3" style="padding-right:10px;">
									<input type="text" class="form-control" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.work_name" />' maxlength="25" />
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_mainsearch();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-12 stretch-card div-form-margin-table" id="left_list">
			<div class="card">
				<div class="card-body">	
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
<%-- 								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnImmediately" onClick="fn_ImmediateStart();" data-toggle="modal">
									<i class="fa fa-cog btn-icon-prepend "></i><spring:message code="migration.run_immediately" />
								</button> --%>

								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_scheduleCheck();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnModify" onClick="fn_rereg_popup();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_reg_popup();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>
				
					<div class="card my-sm-2">
						<div class="card-body">
	 						<div class="table-responsive">
								<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
									<div class="row">
										<div class="col-sm-12 col-md-6">
											<div class="dataTables_length" id="order-listing_length">
											</div>
										</div>
									</div>
								</div>
							</div>

		 					<table id="scriptTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="10"></th>
										<th width="30"><spring:message code="common.no" /></th>
										<th width="100"><spring:message code="common.work_name" /></th>
<%-- 										<th width="100"><spring:message code="menu.schedule_information" /></th> --%>
										<th width="300"><spring:message code="common.work_description" /></th>
										<th width="100"><spring:message code="common.register" /></th>
										<th width="110"><spring:message code="common.regist_datetime" /></th>
										<th width="100"><spring:message code="common.modifier" /></th>
										<th width="100"><spring:message code="common.modify_datetime" /></th>
										<th width="0"></th>
										<th width="0"></th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-sm-0_5" style="display:none;" id="center_div" >
			<div class="card" style="background-color: transparent !important;border:0px;top:30%;position: inline-block;">
				<div class="card-body" style="" onclick="fn_schedule_leftListSize();">	
					<i class='fa fa-angle-double-right text-info' style="font-size: 35px;cursor:pointer;"></i>
				</div>
			</div>
		</div>

		<div class="col-sm-6_3 stretch-card div-form-margin-table" id="right_list" style="display:none;" >
			<div class="card">
				<div class="card-body">	
					<div class="card my-sm-2">
						<div class="card-body" >
							<div class="table-responsive">
								<div id="order-listing_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
									<div class="row">
										<div class="col-sm-12 col-md-6">
											<div class="dataTables_length" id="order-listing_length">
											</div>
										</div>
									</div>
								</div>
							</div>
	
							<table id="scheduleList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="30"><spring:message code="common.no" /></th>							
										<th width="120"><spring:message code="schedule.schedule_name" /></th>
										<th width="200"><spring:message code="schedule.scheduleExp"/></th>
										<th width="50"><spring:message code="schedule.work_count" /></th>
										<th width="100"><spring:message code="schedule.pre_run_time" /></th>
										<th width="100"><spring:message code="schedule.next_run_time" /></th>
										<th width="80"><spring:message code="common.run_status" /></th>
										<th width="100"><spring:message code="etc.etc26"/></th>
										<th width="100"><spring:message code="data_transfer.detail_search" /></th>
										<th width="0"></th>
										<th width="0"></th>
									</tr>
								</thead>
							</table>
					 	</div>	
				 	</div>
				</div>
			</div>
		</div>
	</div>
	<!-- content-wrapper ends -->
</div>