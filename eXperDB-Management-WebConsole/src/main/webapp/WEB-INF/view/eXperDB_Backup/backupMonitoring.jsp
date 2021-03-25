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


var dataSearch = 0;
var progress = 0;
var jobend = 0;

var monitoringData;
var table_policy;

/* ********************************************************
 * 페이지 시작시
 ******************************************************* */
$(window.document).ready(function() {
	fn_init();
	fn_jobStatusList();		
});

function fn_init() {
	/* ********************************************************
	 * backup storage list table setting
	 ******************************************************** */
	 monitoringData = $('#monitoringData').DataTable({
		scrollY : "470px",
		scrollX: true,	
		searching : false,
		processing : true,
		paging : false,
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
				html += "<div class='badge badge-light' style='background-color: transparent !important;font-size: 0.875rem;'>";
				html += "	<i class='fa fa-check-circle text-primary' >";
				html += '&nbsp; Active</i>';
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
		/* {data : "executeTime", className : "dt-center", defaultContent : ""},
		{data : "elapsedtime", className : "dt-center", defaultContent : ""},	
		{data : "jobPhase", className : "dt-center", defaultContent : ""},
		{data : "processedData", className : "dt-center", defaultContent : ""},
		{data : "throughput", className : "dt-center", defaultContent : ""},
		{data : "writeThroughput", className : "dt-center", defaultContent : ""}, */
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
					html += '&nbsp;취소</i>';
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
		},	
		{data : "progress", 
			render : function(data, type, full, meta) {	 						
				var html = '';											
				html += "<div class='progress progress-xl'>";
				html += "	<div class='progress-bar bg-success progress-bar-striped progress-bar-animated' role='progressbar' id='progressing'>";
				html += "60%"
				html += "</div>";
				html += "</div>";
				return html;
			},			
			className : "dt-center", defaultContent : ""}
		]
	});

	 monitoringData.tables().header().to$().find('th:eq(0)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(1)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(2)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(3)').css('min-width');
  	 monitoringData.tables().header().to$().find('th:eq(4)').css('min-width');
	/* monitoringData.tables().header().to$().find('th:eq(5)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(6)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(7)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(8)').css('min-width');
	 monitoringData.tables().header().to$().find('th:eq(9)').css('min-width'); */
	
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
		showSwalIcon('서버를 선택해 주세요 !', '', 'warning');
		return false;
	}else{
		var jobname = monitoringData.row('.selected').data().jobname;
	}

	$("#pop_jobname").val(jobname);
	$("#pop_runNow").modal("show");
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
			monitoringData.clear().draw();
			monitoringData.rows.add(data).draw();
			fn_jobCheck();
		}
	});
	$('#loading').hide();
}





function fn_jobCheck(jobend){
	
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
			 if(data[0].jobstatus == 5){
				 if(dataSearch == 0){
					monitoringData.clear().draw();
					monitoringData.rows.add(data).draw();
					dataSearch++;
				 }
				 if(progress == 0){
					progressBar(7000);
					progress++;
				}
				setTimeout(fn_selectJobEnd, 1000); 
			}else{
				if(jobend == 1){
					monitoringData.clear().draw();
					monitoringData.rows.add(data).draw();
				}
				setTimeout(fn_jobCheck, 1000);
			} 
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
			 if(data == 1){		
				 dataSearch = 0;
				 progress=0;
				 progressBar();
				 /* if(pCount == 100){
					 setTimeout(fn_jobCheck(1), 10000);
				 } */
			}else{				
				setTimeout(fn_selectJobEnd, 10000);
			} 						
		}
	});
	$('#loading').hide();	
}



function fn_random(){
	var random2 = Math.floor(Math.random() * max)+700;
	alert(random2);
	return random2
}


function rand(min, max) {
	  return Math.floor(Math.random() * (max - min + 1)) + min;
	}



function progressBar(rNum) {
	//var rNum = rand(7000, 10000);
    var elem = document.getElementById("progressing");   
   
    var width = 1;
    
    var id = setInterval(function(){
        if (width >= 100) {
            clearInterval(id);
        } else {
            width++; 
            elem.style.width = width + '%'; 
            elem.innerHTML = width * 1  + '%';
        }
    }, rNum);
    
    return width;
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
												<span class="menu-title">백업 모니터링</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">BACKUP</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">백업관리</li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">백업모니터링</li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<!-- /////////////////////////// 내용 수정 필요 ///////////////////////////// -->
											<p class="mb-0"><spring:message code="help.dbms_registration_01" /></p>
											<p class="mb-0"><spring:message code="help.dbms_registration_02" /></p>
											<!-- //////////////////////////////////////////////////////////////////////// -->
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
							<i class="mdi mdi-stop "></i> 중지
						</button>
					</div>
				</div>
			</div>
		</div>
		<!-- backup monitoring list -->
		<div class="col-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="table-responsive" style="overflow:hidden;min-height:600px;">
						<div class="card my-sm-2" >
							<div class="card card-inverse-info"  style="height:25px;">
								<i class="mdi mdi-blur" style="margin-left: 10px;;"> 백업 스토리지 리스트 </i>
							</div>						
							<div class="card-body">
								<div class="row">
									<div class="col-12">
										 <form class="cmxform" id="optionForm">
											<fieldset>	
												<table id="monitoringData" class="table table-hover table-striped system-tlb-scroll" style="width:100%; align:dt-center;">
													<thead>
														<tr class="bg-info text-white">
															<th width="50">Server</th>
															<th width="30">Type</th>
															<th width="30">Status</th>
															<!-- <th width="50">Execute Time</th>
															<th width="50">Elapsed Time</th>
															<th width="50">Job Phase</th>
															<th width="50">Processed Data</th>
															<th width="50">Read Throughput(MB/min)</th>
															<th width="50">Write Throughput(MB/min)</th> -->
															<th width="100">Backup Destination</th>
															<th width="100">Last Result</th>
															<th width="150">Progress</th>
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
		</div>
		<!-- backup monitoring list end -->
	</div>
</div>