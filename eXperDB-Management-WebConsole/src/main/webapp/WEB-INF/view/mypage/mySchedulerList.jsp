<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
    
 <%@include file="../cmmn/cs2.jsp"%>
    
    
<script>
var confirm_title = ""; 
var table = null;

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#scheduleList').DataTable({
	scrollY : "365px",
	bDestroy: true,
	processing : true,
	searching : false,	
	scrollX: true,
	bSort: false,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx",  className : "dt-center", defaultContent : ""}, 
		{data : "scd_nm", className : "dt-left", defaultContent : ""
			,render: function (data, type, full) {
				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
			}
		},
		{data : "scd_exp", className : "dt-left", defaultContent : ""}, 
		{data : "wrk_cnt",  className : "dt-right", defaultContent : ""}, 
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
				if(full.scd_cndt == "TC001801"){
					var html = "<i class='fa fa-circle mr-2 text-success' style='margin-right: 0px !important;'></i>";
					return html;
				}else if(full.scd_cndt == "TC001802"){
					var html = "<i class='fa fa-spin fa-refresh mr-2' style='margin-right: 0px !important;'></i>";
					return html;
				}else{
					var html = "<i class='fa fa-circle mr-2 text-danger' style='margin-right: 0px !important;'></i>";
					return html;
				}
				return data;
			},
			 className : "dt-center",
			 defaultContent : "" 	
		},
		{data : "status", 
			render: function (data, type, full){
				if(full.scd_cndt == "TC001801"){
					var html = "";
					html += '<div class="onoffswitch">';
					html += '<input type="checkbox" name="transActivation" class="onoffswitch-checkbox" id="scheduleStop'+ full.scd_id +'" onclick="fn_scheduleStop('+ full.scd_id +')" checked>';
					html += '<label class="onoffswitch-label" for="scheduleStop'+ full.scd_id +'">';
					html += '<span class="onoffswitch-inner"></span>';
					html += '<span class="onoffswitch-switch"></span></label>';
					html += '</div>';
					return html;
				}else if(full.scd_cndt == "TC001802"){
					var html = "<div class='badge badge-pill badge-primary' id='scheduleRunning'><i class='fa fa-spin fa-refresh mr-2' style='margin-right: 0px !important;'></i></div>";
					return html;
				}else{
					var html = "";
					html += '<div class="onoffswitch">';
					html += '<input type="checkbox" name="transActivation" class="onoffswitch-checkbox" id="scheduleStart'+ full.scd_id +'" onclick="fn_scheduleStart('+ full.scd_id +')">';
					html += '<label class="onoffswitch-label" for="scheduleStart'+ full.scd_id +'">';
					html += '<span class="onoffswitch-inner"></span>';
					html += '<span class="onoffswitch-switch"></span></label>';
					
					html += '<input type="hidden" name="exe_perd_cd" id="exe_perd_cd" value="'+ full.exe_perd_cd +'"/>';
					html += '<input type="hidden" name="exe_dt" id="exe_dt" value="'+ full.exe_dt +'"/>';
					html += '<input type="hidden" name="exe_month" id="exe_month" value="'+ full.exe_month +'"/>';
					html += '<input type="hidden" name="exe_day" id="exe_day" value="'+ full.exe_day +'"/>';
					html += '<input type="hidden" name="exe_hms" id="exe_hms" value="'+ full.exe_hms +'"/>';

					html += '</div>';
				return html;
				}	
				return data;
			},
			 className : "dt-center",
			 defaultContent : "" 	
		},	
		{
			data : "",
			render : function(data, type, full, meta) {
				 return '<button id="detail" class="btn btn-outline-primary" onClick=javascript:fn_dblclick_scheduleInfo("'+full.scd_id+'");><spring:message code="data_transfer.detail_search" /> </button>';
			},
			
			defaultContent : "",
			orderable : false
		},
		{data : "frst_regr_id",  defaultContent : ""},
		{data : "frst_reg_dtm",  defaultContent : ""},
		{data : "lst_mdfr_id",  defaultContent : ""},
		{data : "lst_mdf_dtm",  defaultContent : ""},
		{data : "scd_id",  defaultContent : "", visible: false },
	],'select': {'style': 'multi'}
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(10)').css('min-width', '60px');
	table.tables().header().to$().find('th:eq(11)').css('min-width', '110px');
	table.tables().header().to$().find('th:eq(12)').css('min-width', '60px');
	table.tables().header().to$().find('th:eq(13)').css('min-width', '110px');
	table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
    $(window).trigger('resize'); 
    
    

 	$('#scheduleList tbody').on('click','#scheduleRunning', function () {
 		showSwalIcon('<spring:message code="message.msg189" />', '<spring:message code="common.close" />', '', 'error');
 	    return false;
	}); 
 	
	//더블 클릭시
	 $('#scheduleList tbody').on('dblclick','tr',function() {
		var scd_id = table.row(this).data().scd_id;
		fn_dblclick_scheduleInfo(scd_id);
	});		 
	
}



/* ********************************************************
 * deatil rereg Btn click
 ******************************************************** */
 function fn_dblclick_scheduleInfo(scd_id_up) {
	$('#scd_id', '#findList').val(scd_id_up);
 	$.ajax({
		url : "selectWrkScheduleList.do",
		data : {
			scd_id : $("#scd_id", "#findList").val()	
		},
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
			//테이블 세팅
			fn_workpop_init();
			fn_workpop_search();
			$('#pop_layer_info_schedule').modal("show");
		}
	});
}

		
 function fn_scheduleStop(scd_id){
		confile_title = '<spring:message code="menu.schedule_run_stop" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("stop");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg131" />');
		$('#scd_id', '#findList').val(scd_id);
		
		$('#pop_confirm_multi_md').modal("show");
	}

	function fn_scheduleStop2(){
		var scd_id = $('#scd_id', '#findList').val();
		$.ajax({
			url : "/scheduleStop.do",
			data : {
				scd_id : scd_id
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
				location.reload();
			}
		});  
	}

	function fn_scheduleStart(scd_id){
		confile_title = '<spring:message code="menu.schedule_run_stop" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("start");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg130" />');
		$('#scd_id', '#findList').val(scd_id);
		$('#pop_confirm_multi_md').modal("show");
	}

	function fn_scheduleStart2(){
		var scd_id = $('#scd_id', '#findList').val();
		var exe_perd_cd = $('#exe_perd_cd').val();
		var exe_dt = $('#exe_dt').val()=='undefined'?'':$('#exe_dt').val();
		var exe_month = $('#exe_month').val()=='undefined'?'':$('#exe_month').val();
		var exe_day = $('#exe_day').val()=='undefined'?'':$('#exe_day').val();
		var exe_hms = $('#exe_hms').val();
		
		 if(exe_perd_cd == "TC001605"){
	    	 if (!fn_dateValidation(exe_dt)) return false;
		}	

	 	$.ajax({
			url : "/scheduleReStart.do",
			data : {
				scd_id : scd_id,
				exe_perd_cd : exe_perd_cd,
				exe_dt : exe_dt,
				exe_month : exe_month,
				exe_day : exe_day,
				exe_hms : exe_hms
					
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
				location.reload();
			}
		});  
	}
	
	
/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_selectScheduleList();
});


/* ********************************************************
 * 스케줄 리스트 조회
 ******************************************************** */
function fn_selectScheduleList(){
  	$.ajax({
		url : "/selectMyScheduleList.do",
		data : {
			scd_nm : $("#scd_nm").val(),
			scd_exp : $("#scd_exp").val()
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
			table.rows.add(result).draw();
		}
	}); 
}


/* ********************************************************
 * 스케줄 리스트 삭제
 ******************************************************** */
function fn_deleteScheduleList(){
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	
	confile_title = 'SCHEDULE' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("del");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="message.msg134" />');
	$('#pop_confirm_multi_md').modal("show");
  
}


/* ********************************************************
 * 스케줄 리스트 삭제2
 ******************************************************** */
function fn_deleteScheduleList2(){
	var datas = table.rows('.selected').data();
		var rowList = [];
	    for (var i = 0; i < datas.length; i++) {
	        rowList.push( table.rows('.selected').data()[i].scd_id);   
	       if(table.rows('.selected').data()[i].status == "s"){
	    	   showSwalIcon('<spring:message code="message.msg36" />', '<spring:message code="common.close" />', '', 'error');
	    	   return false;
	       }
	  }	
	  	$.ajax({
			url : "/deleteScheduleList.do",
			data : {
				rowList : JSON.stringify(rowList)
			},
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
				showSwalIconRst('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success', "reload");
			}
		}); 		   
}


/* ********************************************************
 * 스케줄 리스트 등록
 ******************************************************** */
function fn_insertScheduleListView(){
	location.href="/insertScheduleView.do";
}

/* ********************************************************
 * 스케줄 리스트 수정
 ******************************************************** */
function fn_modifyScheduleListView(){
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if (datas.length >1){
		showSwalIcon('<spring:message code="message.msg38" />', '<spring:message code="common.close" />', '', 'error');
	}
	
	var scd_id = table.row('.selected').data().scd_id;
	
	var form = document.modifyForm;
	form.action = "/modifyScheduleListVeiw.do?scd_id="+scd_id;
	form.submit();
	return;
	
}

/* ********************************************************
 * confirm result
 ******************************************************** */
function fnc_confirmMultiRst(gbn){
	if (gbn == "del") {
		fn_deleteScheduleList2();
	}else if(gbn == "stop"){
		fn_scheduleStop2();
	}else if(gbn == "start"){
		fn_scheduleStart2();
	}
}
/* ********************************************************
 * confirm cancel result
 ******************************************************** */
function fn_confirmCancelRst(gbn){
	if ($('#scd_id', '#findList') != null) {
		var scd_id = $('#scd_id', '#findList').val();
		if(gbn=="start"){
			$("input:checkbox[id=scheduleStart" + scd_id + "]").prop("checked", false);
		}else if("stop"){
			$("input:checkbox[id=scheduleStop" + scd_id + "]").prop("checked", true);
		}
	}
}
</script>
<%@include file="../popup/confirmMultiForm.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>
<%@include file="../popup/scheduleWrkList.jsp"%>
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="wrk_id" id="wrk_id" value=""/>
	<input type="hidden" name="scd_id" id="scd_id" value=""/>
</form>

<form name="modifyForm" method="post">
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
												<i class="ti-user menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.my_schedule_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
 					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">My PAGE</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.my_schedule_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.my_schedule_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.my_schedule_management01"/></p>
											<p class="mb-0"><spring:message code="help.my_schedule_management02"/></p>
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
							<div class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="20" id="scd_nm" name="scd_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="schedule.schedule_name" />'/>		
								</div>
								<div class="input-group mb-2 mr-sm-2 col-sm-4">
									<input type="text" class="form-control" maxlength="150" id="scd_exp" name="scd_exp" onblur="this.value=this.value.trim()" placeholder='<spring:message code="schedule.scheduleExp" />'/>		
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button" onClick="fn_selectScheduleList();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</div>
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="del_button" onClick="fn_deleteScheduleList();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="mdf_button" onClick="fn_modifyScheduleListView();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="int_button" onClick="fn_insertScheduleListView();" data-toggle="modal">
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
									<table id="scheduleList" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"></th>
												<th width="30"><spring:message code="common.no" /></th>							
												<th width="120"><spring:message code="schedule.schedule_name" /></th>
												<th width="200"><spring:message code="schedule.scheduleExp"/></th>
												<th width="50"><spring:message code="schedule.work_count" /></th>
												<th width="100"><spring:message code="schedule.pre_run_time" /></th>
												<th width="100"><spring:message code="schedule.next_run_time" /></th>
												<th width="80"><spring:message code="common.run_status" /></th>
												<th width="100"><spring:message code="etc.etc26"/></th>
												<th width="100"><spring:message code="data_transfer.detail_search" /></th>
												<th width="100"><spring:message code="common.register" /></th>
												<th width="100"><spring:message code="common.regist_datetime" /></th>
												<th width="100"><spring:message code="common.modifier" /></th>
												<th width="100"><spring:message code="common.modify_datetime" /></th>
												<th width="0"></th>
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
