<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>


<%
	/**
	* @Class Name : restoreHistory.jsp
	* @Description : 복원이력 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-02-05	신예은 매니저		최초 생성
	*  2021-02-25	변승우 책임		    기능 구현
	*
	* author 신예은 매니저
	* since 2021.02.05
	*
	*/
%>

<script>
var bckHistoryList;
var bckLogList;
var serverList=[];

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();
	//selectJobHistory();
	dateCalenderSetting();
	fn_getSvrList();
	fn_searchHistory();
	$('#bckHistoryList tbody').on('click','tr',function() {
		var jobid = bckHistoryList.row(this).data().jobid;
		selectActivityLog(jobid);
	});
	
});

function dateCalenderSetting() {
	var today = new Date();
	var day_end = today.toJSON().slice(0,10);

	today.setDate(today.getDate() - 7);
	var day_start = today.toJSON().slice(0,10);

	$("#bckStartDate").val(day_start);
	$("#bckEndDate").val(day_end);

	if ($("#bck_strt_dtm_div").length) {
		$('#bck_strt_dtm_div').datepicker({
		}).datepicker('setDate', day_start)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    })
	    .on('changeDate', function(selected){
	    	day_start = new Date(selected.date.valueOf());
	    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
	        $("#bck_strt_dtm_div").datepicker('setStartDate', day_start);
	        $("#bckEndDate").datepicker('setStartDate', day_start);
		}); //값 셋팅
	}

	if ($("#bck_end_dtm_div").length) {
		$('#bck_end_dtm_div').datepicker({
		}).datepicker('setDate', day_end)
		.on('hide', function(e) {
			e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
	    })
	    .on('changeDate', function(selected){
	    	day_end = new Date(selected.date.valueOf());
	    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
	        $('#bck_strt_dtm_div').datepicker('setEndDate', day_end);
	        $('#bckStartDate').datepicker('setEndDate', day_end);
		}); //값 셋팅
	}
	
	$("#bckStartDate").datepicker('setDate', day_start);
    $("#bckEndDate").datepicker('setDate', day_end);
    $('#bck_strt_dtm_div').datepicker('updateDates');
    $('#bck_end_dtm_div').datepicker('updateDates');
}


function fn_init() {
	
	/* ********************************************************
	 * backup history list table setting
	 ******************************************************** */
	 bckHistoryList = $('#bckHistoryList').DataTable({
		scrollY : "300px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : true,
		lengthChange: true,
		deferRender : true,
		bSort : false,
		columns : [
		{
				data : "status",
				render : function(data, type, full, meta) {	 						
					var html = '';
					//성공
					if (full.status == 1) {
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-check-circle text-primary' >";
					html += '&nbsp;<spring:message code="common.success" /></i>';
					html += "</div>";
					//취소
					}else if(full.status == 2){
						html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
						html += "	<i class='fa fa-ban text-danger' >";
						html += '&nbsp;<spring:message code="common.cancel" /></i>';
						html += "</div>";
					//실패
					}  else if(full.status == 3){
						html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
						html += "	<i class='fa fa-times text-danger' >";
						html += '&nbsp;<spring:message code="common.failed" /></i>';
						html += "</div>";
					//incomplete
					} else if(full.status == 4){
						html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
						html += "	<i class='fa fa-exclamation text-primary' >";
						html += '&nbsp;<spring:message code="common.failed" /></i>';
						html += "</div>";
					} 

					return html;
				},
				className : "dt-center",
				defaultContent : ""
			},	
		{data : "targetname", className : "dt-center", defaultContent : ""},
		{data : "rpoint", className : "dt-center", defaultContent : ""},
		{data : "jobtype_nm", className : "dt-center", defaultContent : ""},			
		{data : "executetime", className : "dt-center", defaultContent : ""},	
		{data : "finishtime", className : "dt-center", defaultContent : ""},
		{data : "reducetime", className : "dt-center", defaultContent : ""},
		{data : "datasize", className : "dt-center", defaultContent : ""},
		{data : "destinationlocation", className : "dt-center", defaultContent : ""}
		]
	});

	bckHistoryList.tables().header().to$().find('th:eq(0)').css('min-width');
	bckHistoryList.tables().header().to$().find('th:eq(1)').css('min-width');
	bckHistoryList.tables().header().to$().find('th:eq(2)').css('min-width');
	bckHistoryList.tables().header().to$().find('th:eq(3)').css('min-width');
    bckHistoryList.tables().header().to$().find('th:eq(4)').css('min-width');
	bckHistoryList.tables().header().to$().find('th:eq(5)').css('min-width');
	bckHistoryList.tables().header().to$().find('th:eq(6)').css('min-width'); 

	bckLogList = $('#bckLogList').DataTable({
		scrollY : "500px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		lengthChange: false,
		deferRender : true,
		info : false,
		bSort : false,
		columns : [
		{
			data : "type",
			render : function(data, type, full, meta) {	 						
				var html = '';
				// TYPE_INFO
				if (full.type == 1) {
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-info-circle text-primary' /> </i>";
				//html += '&nbsp;<spring:message code="common.success" /></i>';
				html += "</div>";
				// TYPE_ERROR
				}else if(full.type == 2){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-times-circle text-danger' /> </i>";
					//html += '&nbsp;취소</i>';
					html += "</div>";
				// TYPE_WARNING
				}  else if(full.type == 3){
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-warning text-warning' /> </i>";
				//html += '&nbsp;<spring:message code="common.failed" /></i>';
				html += "</div>";				
				} 

				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},	
		
		{data : "time", className : "dt-center", defaultContent : ""},	
		{data : "message", className : "dt-left", defaultContent : ""}
		]
	});
	// css('min-width').
	bckLogList.tables().header().to$().find('th:eq(0)').css('min-width');
	bckLogList.tables().header().to$().find('th:eq(1)').css('min-width');
	bckLogList.tables().header().to$().find('th:eq(2)').css('min-width');

    $(window).trigger('resize'); 
	
} // fn_init();


$(function() {
	   $('#bckHistoryList tbody').on( 'click', 'tr', function () {
	         if ( $(this).hasClass('selected') ) {
	         }
	        else {	        	
	        	bckHistoryList.$('tr.selected').removeClass('selected');
	            $(this).addClass('selected');	   
	        } 
	    } );   
	} );  
	
function fn_getSvrList() {
	console.log("fn_getSvrList");
	$.ajax({
		url : "/experdb/backupNodeList.do",
		data : {
			
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
		success : function(data) {
			console.log("success : " + data);
			fn_setServerList(data);
			
		}
	});
}

function fn_setServerList(data){
	serverList.length=0;
	serverList = data;
	var html;
	console.log("fn_setServerList");
	$("#bckServer").empty();
	html +='<option value="0"> <spring:message code="eXperDB_backup.msg25" /></option>'
	for(var i =0; i<serverList.length; i++){			
		html += '<option value="'+serverList[i].ipadr+'">'+serverList[i].ipadr+'</option>';
	}
	$("#bckServer").append(html);
}

function selectJobHistory() {
	$.ajax({
		url : "/experdb/restoreJobHistoryList.do",
		data : {
			
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
		success : function(data) {
			bckHistoryList.clear().draw();
			bckHistoryList.rows.add(data).draw();			
		}
	});
}



function selectActivityLog(jobid) {
	$.ajax({
		url : "/experdb/backupActivityLogList.do",
		data : {
			jobid : jobid
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
		success : function(data) {
			bckLogList.clear().draw();
			bckLogList.rows.add(data).draw();			
		}
	});
}
function fn_searchHistory(){
	console.log("fn_searchHistory : " + $("#bckStartDate").val());
	console.log("endDate : " + $("#bckEndDate").val());
	console.log("bckServer : " + $("#bckServer").val());
	console.log("bckType : " + $("#bckType").val());
	console.log("bckStatus : " + $("#bckStatus").val());
	$.ajax({
		url : "/experdb/restoreJobHistoryList.do",
		data : {
			startDate : $("#bckStartDate").val(),
			endDate : $("#bckEndDate").val(),
			server : $("#bckServer").val(),
			type : $("#bckType").val(),
			status : $("#bckStatus").val()
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
		success : function(data) {
			bckHistoryList.clear().draw();
			bckHistoryList.rows.add(data).draw();			
		}
	});
	
}

</script>

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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="eXperDB_backup.msg33" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BnR</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_backup.msg24" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_backup.msg33" /></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_backup_restoreHistory01" /></p>
											<p class="mb-0"><spring:message code="help.eXperDB_backup_restoreHistory02" /></p>
											<p class="mb-0"><spring:message code="help.eXperDB_backup_restoreHistory03" /></p>
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
					<!-- <div class="card"> -->
						<div class="card-body" style="margin:-10px -10px -15px -10px;">

							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" style="margin-left: 0px;" >
									<div id="bck_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="bckStartDate" name="bckStartDate" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
									<div id="bck_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="bckEndDate" name="bckEndDate" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="bckServer" id="bckServer">										
									</select>
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="bckType" id="bckType">
										<option value="0"> <spring:message code="eXperDB_backup.msg34" /></option>
										<option value="21"> Restore BMR</option>
										<option value="23"> Restore File</option>
									</select>
								</div>
								<div class="input-group mb-2 mr-sm-2  col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="bckStatus" id="bckStatus">
										<option value="0"> <spring:message code="eXperDB_backup.msg29" /></option>
										<option value="1"> <spring:message code="common.success" /></option>
										<option value="3"> <spring:message code="common.failed" /></option>
									</select>
								</div>
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button" onClick="fn_searchHistory();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					<!-- </div> -->
				</div>
			</div>
		</div>
		
		
		<!-- backup storage list -->
		<div class="col-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div class="card-body" style="padding-top: 0px;">
							<div class="row">
								<div class="col-12">
									 <form class="cmxform">
										<fieldset>	
											<table id="bckHistoryList" class="table table-hover table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
												<thead>
													<tr class="bg-info text-white">
														<th width="50">Status</th>
														<th width="80"><spring:message code="eXperDB_backup.msg25" /></th>
														<th width="80">Recovery Point</th>
														<th width="80"><spring:message code="eXperDB_backup.msg84" /></th>															
														<th width="60"><spring:message code="eXperDB_backup.msg30" /></th>
														<th width="60"><spring:message code="eXperDB_backup.msg31" /></th>
														<th width="60"><spring:message code="eXperDB_backup.msg32" /></th>
														<th width="50">Data Size</th>
														<th width="100">Backup Destination</th>
													</tr>
												</thead>
											</table>							
										</fieldset>
									</form>		
								 </div>
							 </div>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-12">
									<form class="cmxform">
										<fieldset>
											<!-- activity log -->
											<table id="bckLogList" class="table table-hover system-tlb-scroll" style="width:100%; align:dt-center; ">
												<thead>
													<tr class="bg-info text-white">
														<th width="70" style="background-color: #7e7e7e;">Status</th>
														<th width="70" style="background-color: #7e7e7e;">Time</th>
														<th width="500" style="background-color: #7e7e7e;">Message</th>
													</tr>
												</thead>
											</table>		
										</fieldset>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- backup storage list end -->
	</div>
</div>