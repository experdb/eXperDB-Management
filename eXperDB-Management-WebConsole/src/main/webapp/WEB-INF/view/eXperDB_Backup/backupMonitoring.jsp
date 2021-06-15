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

<script>

var monitoringData;
var bckLogList;
var jobend = 0;

var jobClick =""; 

var activity="";
var end ="";


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
	



	/* ********************************************************
	 * 로그,  출력 모니터링 서버 클릭
	 ******************************************************* */
	$(function() {
	   $('#monitoringData tbody').on( 'click', 'tr', function () {
	         if ( $(this).hasClass('selected') ) {
	         }
	        else {	        	
	        	monitoringData.$('tr.selected').removeClass('selected');	        	
	            $(this).addClass('selected');	         
	            
	             var jobstatus = monitoringData.row('.selected').data().jobstatus;
	             var jobname = monitoringData.row('.selected').data().jobname;

				 if(jobstatus == 5){
					 console.log('jobname= '+jobname);
					fn_selectMonitoring(jobname);
				}else{
					clearTimeout(end);
					clearTimeout(activity);					
					jobClick = "";
					end ="";
					activity = "";				
					bckLogList.clear().draw();
				}
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
		fn_runNowReset();
		$("#pop_runNow").modal("show");
	}



	function fn_selectJob(){
		
		$.ajax({
			url : "/experdb/jobStatusList.do",
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
				monitoringData.clear().draw();
				monitoringData.rows.add(data).draw();
				fn_jobStatusList();
			}
		});
		$('#loading').hide();
	}


function fn_jobStatusList(){
	
	setInterval(function() {
		$.ajax({
			url : "/experdb/jobStatusList.do",
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
				 for(var i=0; i<data.length; i++){				 
					 monitoringData.cell( {row:i, column:2} ).data(data[i].jobstatus).draw();
					 monitoringData.cell( {row:i, column:4} ).data(data[i].jobstatus).draw();
					}						
			}
		});
		$('#loading').hide();
	}, 10000);	
}



function fn_selectMonitoring(jobname){		
	
	//선택한 작업 jobId 추출
	var jobid = fn_selectJobId(jobname);
	
	//ActivityLog 조회 체크
	fn_selectActivityLogCheck(jobid, jobname);
	
}



function fn_selectJobId(jobname){
	$.ajax({
		url : "/experdb/selectJobId.do",
		data : {
			jobname:jobname
		},
		async: false, 
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
			result = data;
		}
	});
	return result;
	$('#loading').hide();	
}



function fn_selectActivityLogCheck(jobid, jobname){
	
	//console.log(jobClick+'=='+jobname);	
	
	//첫 수행
	if(jobClick == "" || jobClick != jobname){
		//console.log('첫수행');		
		jobClick = jobname;
		
		clearTimeout(end);
		clearTimeout(activity);

		//바로 1회조회
		fn_selectJobEnd(jobid,jobname);
		fn_selectActivityLog(jobid,jobname);		
	//두번째 부터 수행	
	}else if(jobClick == jobname){
		//console.log(jobClick+'=='+jobname);	
		end = setTimeout(fn_selectJobEnd, 8000, jobid,jobname);	
		activity = setTimeout(fn_selectActivityLog, 5000, jobid,jobname);			
	}
}


function fn_selectActivityLog(jobid, jobname) {
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
		}else{
			bckLogList.clear().draw();
		}
	}
});
$('#loading').hide();
} 


 function fn_selectJobEnd(jobid,jobname){
	
	$.ajax({
		url : "/experdb/selectJobEnd.do",
		data : {
			jobname:jobname
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
			//console.log('종료 데이터= '+data);		
			 if(data == 1){		
				jobend = 1;
				jobClick = "";
				activity = "";
				end ="";
				bckLogList.clear().draw();
				fn_selectJob();
			}else{	
				jobend = 0;
				fn_selectActivityLogCheck(jobid, jobname);
			} 						
		}
	});
	$('#loading').hide();	
}




	function fn_jobCancelConfirm(){
		var datas = monitoringData.row('.selected').length;
	
		if(datas != 1){
			showSwalIcon('<spring:message code="eXperDB_backup.msg23" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}else{			
			confile_title = '작업취소 요청';
			$('#con_multi_gbn', '#findConfirmMulti').val("jobCancel");
			$('#confirm_multi_tlt').html(confile_title);
			$('#confirm_multi_msg').html('작업을 취소 하시겠습니까?');
			$('#pop_confirm_multi_md').modal("show");	
		}
	}
	
	function fn_jobCancel(){
		var jobname = monitoringData.row('.selected').data().jobname;

		$.ajax({
			url : "/experdb/jobCancel.do",
			data : {
				jobname : jobname
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
			}
		});
	}
	
		
	  // confirm function
	 function fnc_confirmMultiRst(gbn){
		  if(gbn == "jobCancel"){
			  fn_jobCancel();
		  }
	  }

</script>
<%@include file="./../popup/confirmMultiForm.jsp"%>
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
						<button type="button" class="btn btn-danger btn-icon-text mb-2" onclick="fn_jobCancelConfirm()">
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
