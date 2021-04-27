<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../cmmn/cs2.jsp"%>


<%
	/**
	* @Class Name : backupMonitoring.jsp
	* @Description : 백업모니터링 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021-03-02	신예은 매니저		최초 생성
	*  2021-03-04	변승우 책임매니저		
	*
	* author 신예은 매니저
	* since 2021.03.02
	*
	*/
%>

<style>
	.progress-bar{
		        width: 0%;
		        aria-valuenow: 90;
		        aria-valuemin:0;
		        aria-valuemax:100;
		    }
</style>

<script>

var monitoringData;
var bckLogList;

var jobend = 0;
var dataSearch=0;


/* ********************************************************
 * 모니터링 프로세스
 * 1. 실행 상태 주기적으로 조회 (1초마다)
 * 2. status==5 일 경우, 상태변경 Active
 * 2. Active일 경우
 *		2-1) 실행 상태 주기적으로 조회 정지
 *		2-2) 현재 수행중인 jobid 추출
* 		2-3) 해당 jobid의 Activity로그 출력
* 		2-4) ActivityLog 실시간 출력 (20초 마다)
* 		2-5) 종료상태 체크 (History테이블 Insert 여부)
* 		2-6) 종료상태 주기적으로 조회(1초마다)
* 	3. 백업 종료(History테이블 조회 카운트 = 1)
* 	4. status 상태 변경 Ready
* 
*  선택한 Job의 모니터링 프로세스
*  5. Job선택시, 선택한 Job의 jobid 추출
 ******************************************************* */



/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();
	fn_selectJob();		
});

function fn_init() {
	/* ********************************************************
	 * backup storage list table setting
	 ******************************************************** */
	 monitoringData = $('#monitoringData').DataTable({
		scrollY : "500px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
		info : false,
		deferRender : true,
		bSort : false,
		columns : [
		{data : "targetname", className : "dt-center", defaultContent : ""},	
		{data : "jobtype_nm", className : "dt-center", defaultContent : ""},	
		{
			data : "jobstatus",
			render : function(data, type, full, meta) {	 						
				var html = '';
				//Active
				if (full.jobstatus == 5) {
				html += "<div class='badge badge-light text-primary'' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-spin fa-spinner mr-2 text-primary'></i>";
				html += '&nbsp; Active';
				html += "</div>";
				//Ready
				}else{
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-check-circle text-secondary' >";
					html += '&nbsp; Ready</i>';
					html += "</div>";				
				} 
				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},		
		{data : "location", className : "dt-center", defaultContent : ""},
		{
			data : "jobstatus",
			render : function(data, type, full, meta) {	 						
				var html = '';
				//성공
				if (full.jobstatus == 1) {
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-check-circle text-primary' >";
				html += '&nbsp;<spring:message code="common.success" /></i>';
				html += "</div>";
				//취소
				}else if(full.jobstatus == 2){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-ban text-danger' >";
					html += '&nbsp;<spring:message code="common.cancel" /></i>';
					html += "</div>";
				//실패
				}  else if(full.jobstatus == 3){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-times text-danger' >";
					html += '&nbsp;<spring:message code="common.failed" /></i>';
					html += "</div>";
				//incomplete
				} else if(full.jobstatus == 4){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-exclamation text-primary' >";
					html += '&nbsp;<spring:message code="common.success" /></i>';
					html += "</div>";
				} 

				return html;
			},
			className : "dt-center",
			defaultContent : ""
		}
		]
	});

	 monitoringData.tables().header().to$().find('th:eq(0)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(1)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(2)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(3)').css('min-width');

	 
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
					html += "</div>";
					// TYPE_ERROR
					}else if(full.type == 2){
						html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
						html += "	<i class='fa fa-times-circle text-danger' /> </i>";
						html += "</div>";
					// TYPE_WARNING
					}  else if(full.type == 3){
					html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
					html += "	<i class='fa fa-warning text-warning' /> </i>";
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
	   $('#monitoringData tbody').on( 'click', 'tr', function () {
	         if ( $(this).hasClass('selected') ) {
	         }
	        else {	        	
	        	monitoringData.$('tr.selected').removeClass('selected');	        	
	            $(this).addClass('selected');	         
	        } 
	    } );   
	} );  



function fn_runNow() {

	var datas = monitoringData.row('.selected').length;

	if(datas != 1){
		showSwalIcon('<spring:message code="eXperDB_backup.msg23" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else{
		var jobname = monitoringData.row('.selected').data().jobname;
	}
	$("#pop_jobname").val(jobname);
	$("#pop_runNow").modal("show");
}



// 초기, 1회 조회 (계속 리드로우 하기때문에)
function fn_selectJob(){
	
	$.ajax({
		url : "/experdb/jobStatusList.do",
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
			monitoringData.clear().draw();
			monitoringData.rows.add(data).draw();
			fn_jobStatusList();
		}
	});
	$('#loading').hide();
}


function fn_jobStatusList(){
	
	$.ajax({
		url : "/experdb/jobStatusList.do",
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

			// 2. status==5 일 경우, 상태변경 Active
			 if(data[0].jobstatus == 5){
				 
				 jobend = 0;
				 
				 // 2-1) 실행 상태 주기적으로 조회 정지
				 if(dataSearch == 0){
						monitoringData.clear().draw();
						monitoringData.rows.add(data).draw();
						dataSearch++;
				}
				// 2-2) 현재 수행중인 jobid 추출
				fn_selectJobId();
				// 2-5) 종료상태 체크 (History테이블 Insert 여부)
				fn_selectJobEnd();
				
			 }
		
			// 1. 실행 상태 주기적으로 조회 (1초마다)
			setTimeout(fn_jobStatusList, 1000);

		}
	});
	$('#loading').hide();
}


function fn_selectJobEnd(){
	
	$.ajax({
		url : "/experdb/selectJobEnd.do",
		data : {},
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
				// 3. 백업 종료(History테이블 조회 카운트 = 1)
			 if(data == 1){		
				 dataSearch = 0;
				 jobend = 1;
				// 4. status 상태 변경 Ready	 
				fn_selectJob();
			}else{	
				// 2-6) 종료상태 주기적으로 조회(1초마다)
				setTimeout(fn_selectJobEnd, 10000);
			} 						
		}
	});
	$('#loading').hide();	
}


function fn_selectJobId(){
	
	$.ajax({
		url : "/experdb/selectJobId.do",
		data : {},
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
			// 2-3) 해당 jobid의 Activity로그 출력
			 fn_selectActivityLog(data);				
		}
	});
	$('#loading').hide();	
}



function fn_selectActivityLog(jobid) {
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
			if(jobend == 0){
				bckLogList.clear().draw();
				bckLogList.rows.add(data).draw();	
				//2-4) ActivityLog 실시간 출력 (20초 마다)
				setTimeout(fn_selectActivityLog(jobid), 20000)
			}else{
				bckLogList.clear().draw();
			}
		}
	});
}

</script>
<%@include file="./popup/backupRunNow.jsp"%>


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
												<span class="menu-title"><spring:message code="eXperDB_scale.monitoring" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BnR</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_backup.msg24" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="eXperDB_scale.monitoring" /></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.eXperDB_backup_monitoring01" /></p>
											<p class="mb-0"><spring:message code="help.eXperDB_backup_monitoring02" /></p>
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
		
		<div class="col-12 grid-margin stretch-card" style="margin-bottom: 0px;">
			<div class="card-body" style="padding-bottom:0px; padding-top: 0px;">
				<div class="table-responsive" style="overflow:hidden;">
					<div id="wrt_button" style="float: right;">
						<button type="button" class="btn btn-success btn-icon-text mb-2" onclick="fn_runNow()">
							<i class="ti-control-forward btn-icon-prepend "></i><spring:message code="migration.run_immediately" />
						</button>
						<button type="button" class="btn btn-danger btn-icon-text mb-2">
							<i class="mdi mdi-close "></i><spring:message code="common.cancel" />
						</button>
					</div>
				</div>
			</div>
		</div>
		<!-- backup monitoring list -->
		
		
		<div class="col-lg-5 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<table id="monitoringData" class="table nonborder table-hover system-tlb-scroll" style="width:100%;align:left;">
							<thead>
								<tr class="bg-info text-white">
									<th width="50">Server</th>
									<th width="30">Type</th>
									<th width="30">Status</th>
									<th width="100">Backup Destination</th>
									<th width="100">Last Result</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		
		
		
		<div class="col-lg-7 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<table id="bckLogList" class="table table-hover system-tlb-scroll" style="width:100%;" align:dt-center; ">
							<thead>
								<tr class="bg-info text-white">
									<th width="70" style="background-color: #7e7e7e;">Status</th>
									<th width="70" style="background-color: #7e7e7e;">Time</th>
									<th width="500" style="background-color: #7e7e7e;">Message</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
		<!-- backup monitoring list end -->
</div>
