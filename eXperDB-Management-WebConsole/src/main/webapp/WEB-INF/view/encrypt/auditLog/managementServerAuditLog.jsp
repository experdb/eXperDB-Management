<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : managementServerAuditLog.jsp
	* @Description : managementServerAuditLog 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.07.22    변승우 과장		UI 변경
	*
	* author 김주영 사원
	* since 2018.01.09
	*
	*/
%>

<script>
	var table = null;

	
	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_init() {
		table = $('#table').DataTable({
			scrollY : "410px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "rnum", className : "dt-center", defaultContent : ""}, 
				{ data : "logDateTime", defaultContent : ""}, 
				{ data : "entityName", defaultContent : ""}, 
				{ data : "remoteAddress", defaultContent : ""}, 
				{ data : "requestPath", defaultContent : ""}, 
				{ data : "resultCode", defaultContent : ""}, 
				/* {
					data : "",
					render : function(data, type, full, meta) {
						var html = "<button teype='button' class='btn btn-outline-primary btn-icon-text'><i class='ti-file btn-icon-prepend' id='detail'> <spring:message code='schedule.detail_view' /> </i></button>";
						return html;
					},
					className : "dt-center",
					defaultContent : "",
					orderable : false
				}, */
				{data : "parameter", className : "dt-center", defaultContent : "", visible: false },
				{data : "resultMessage", className : "dt-center", defaultContent : "", visible: false }
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '250px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '0px');
	    $(window).trigger('resize');
	    
	    
	    
	    

		/* ********************************************************
		 * 상세보기 클릭시
		 ******************************************************** */		
		$('table tbody').on('click','#detail',function() {
			
		 	var $this = $(this);
		    var $row = $this.parent().parent().parent();
		    $row.addClass('detail');
		    var datas = table.rows('.detail').data();
		    
		    if(datas.length==1) {
		    	var row = datas[0];
			    $row.removeClass('detail');
			    
		 		var logDateTime  = row.logDateTime;
		 		var entityName  = row.entityName;
		 		var remoteAddress  = row.remoteAddress;
		 		var requestPath  = row.requestPath;
		 		var resultCode  = row.resultCode;
		 		var parameter  = row.parameter;
		 		var resultMessage  = row.resultMessage;
		 		
		 		
		 		$.ajax({
					url : "/popup/managementServerAuditLogDetail.do",
					data : {	
						entityName : encodeURI(entityName),
						logDateTime : encodeURI(logDateTime),
						remoteAddress : encodeURI(remoteAddress),
						requestPath : encodeURI(requestPath),
						resultCode : encodeURI(resultCode),
						parameter : encodeURI(parameter),
						resultMessage : encodeURI(resultMessage)
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
						$('#pop_managementServerAuditLogDetail').modal("show");
					}
				});	
		    }
		});	
		
		
		
		   $('#table tbody').on('click', 'tr', function() {

				table.$('tr.selected').removeClass('selected');
	            $(this).addClass('selected');	
	            	
			    var datas = table.rows('.selected').data();

			    if(datas.length==1) {
			    	
			    	var row = datas[0];
			    	

			    	$("#logDateTime")[0].innerText = row.logDateTime;
			    	$("#entityName")[0].innerText = row.entityName;
			    	$("#remoteAddress")[0].innerText = row.remoteAddress;
			    	$("#requestPath")[0].innerText = row.requestPath;
			    	$("#resultCode")[0].innerText = row.resultCode;
			    	$("#parameter")[0].innerText = row.parameter;
			    	$("#resultMessage")[0].innerText = row.resultMessage;
			    	
			    	
			    	$("#parameter").val(row.parameter);
			    	
			    	
			 		/* var logDateTime  = row.logDateTime;
			 		var entityName  = row.entityName;
			 		var remoteAddress  = row.remoteAddress;
			 		var requestPath  = row.requestPath;
			 		var resultCode  = row.resultCode;
			 		var parameter  = row.parameter;
			 		var resultMessage  = row.resultMessage; */

					 if ($("#left_list").hasClass("col-12")) {
						$("#left_list").attr('class', 'col-13 stretch-card div-form-margin-table');
					} 
					
					$('#right_list').show();
					$('#center_div').show();			
			    } 

		    });   
		   
	}

	
	/* ********************************************************
	 * 설정초기설정
	 ******************************************************** */	
	$(window.document).ready(function() {
		dateCalenderSetting();
		fn_init();
		fn_select();
	});
	
	
	/* ********************************************************
	 * 스크립트 리스트 100%
	 ******************************************************** */
	function fn_leftListSize() {
		$("#left_list").attr('class', 'col-12 stretch-card div-form-margin-table');
		$('#right_list').hide();
		$('#center_div').hide();
	}

	/* ********************************************************
	 * 조회 버튼 클릭시
	 ******************************************************** */	
	function fn_select() {
		$.ajax({
			url : "/selectManagementServerAuditLog.do",
			data : {
				from : $('#lgi_dtm_start').val(),
				to : 	$('#lgi_dtm_end').val(),
				resultcode : $('#resultcode').val(),
				entityuid : $('#entityuid').val()
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
				if(data.resultCode == "0000000000"){
					table.clear().draw();
					if(data.list!=null){
						table.rows.add(data.list).draw();
					}
				}else if(data.resultCode == "8000000002"){
					showSwalIconRst('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error', 'top');	
				}else if(data.resultCode == "8000000003"){
					showSwalIconRst(data.resultMessage, '<spring:message code="common.close" />', '', 'error','securityKeySet');
				}else if(data.resultCode == "0000000003"){		
					showSwalIcon('<spring:message code="encrypt_permissio.error" />', '<spring:message code="common.close" />', '', 'error');
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
				}
			}
		});
	}
	
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate() - 7);
		var day_start = today.toJSON().slice(0,10);

		$("#wrk_strt_dtm").val(day_start);
		$("#wrk_end_dtm").val(day_end);

		if ($("#wrk_strt_dtm_div").length) {
			$('#wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_start = new Date(selected.date.valueOf());
		    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
		        $("#wrk_end_dtm_div").datepicker('setStartDate', day_start);
		        $("#wrk_end_dtm").datepicker('setStartDate', day_start);
			}); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_end = new Date(selected.date.valueOf());
		    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
		        $('#wrk_strt_dtm_div').datepicker('setEndDate', day_end);
		        $('#wrk_strt_dtm').datepicker('setEndDate', day_end);
			}); //값 셋팅
		}
		
		$("#wrk_strt_dtm").datepicker('setDate', day_start);
	    $("#wrk_end_dtm").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	}	
	
	
	
</script>

<%@include file="../popup/managementServerAuditLogDetail.jsp"%> 

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
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="encrypt_log_sever.Management_Server"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ENCRYPT
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_log.Audit_Log"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="encrypt_log_sever.Management_Server"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="encrypt_help.Management_Server"/></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body" style="margin:-10px -10px -15px 0px;">
							<form class="form-inline row" onsubmit="return false;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_start" name="lgi_dtm_start" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
									
									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>

									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_end" name="lgi_dtm_end" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-left: -1rem;margin-right: -0.7rem;" name="entityuid" id="entityuid">
										<option value=""><spring:message code="encrypt_log_key.Access_User"/>&nbsp;<spring:message code="common.total" /></option>
										<c:forEach var="entityuid" items="${entityuid}">
											<option value="${entityuid.getEntityUid}">${entityuid.getEntityName}</option>							
										</c:forEach>
									</select>
								</div>
	
								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" name="resultcode" id="resultcode">
										<option value=""><spring:message code="encrypt_log_decode.Success_Failure"/>&nbsp;<spring:message code="common.total" /></option>
										<option value="0000000000"><spring:message code="common.success" /></option>
										<option value="9999999999"><spring:message code="common.failed" /></option>
									</select>
								</div>
								
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSelect" onClick="fn_select();">
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>	
						</div>
					</div>
				</div>
			</div>
		</div>		

		<div class="col-12 stretch-card div-form-margin-table" id="left_list">
			<div class="card">
				<div class="card-body">
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

	 								<table id="table" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
											<tr class="bg-info text-white">
												<th width="30"><spring:message code="common.no" /></th>
												<th width="150"><spring:message code="encrypt_log_key.Access_Date"/></th>
												<th width="100"><spring:message code="encrypt_log_key.Access_User"/></th>
												<th width="100"><spring:message code="encrypt_log_key.Access_Address"/></th>
												<th width="250"><spring:message code="encrypt_log_key.Access_Path"/></th>
												<th width="100"><spring:message code="encrypt_log_key.Result_Code"/></th>
												<%-- <th width="100"><spring:message code="schedule.detail_view" /></th> --%>
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
		
		<div class="col-1 stretch-card div-form-margin-table" style="display:none;max-width: 5.33333%;margin-right: -20px;margin-left: -20px;" id="center_div" >
			<div class="card" style="background-color: transparent !important;border:0px;">
				<div class="card-body">	
					<div class="card my-sm-2" style="border:0px;background-color: transparent !important;">
						<div class="card-body" style="margin-left: -25px;" onclick="fn_leftListSize();">
							<i class='fa fa-angle-double-right text-info' style="font-size: 35px;cursor:pointer;"></i>
						</div>
					</div>
				</div>
			</div>
		</div>
			
		<div class="col-7 stretch-card div-form-margin-table" id="right_list" style="display:none; max-width:35%;" >
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

							<table class="table system-tlb-scroll"  style="border: 1px solid #99abb0; table-layout: fixed;">
								<colgroup>
									<col style="width: 25%;" />
									<col style="width: 75%; " />
								</colgroup>										
								<thead>
									<tr class="bg-info text-white">
										<th class="table-text-align-c"><spring:message code="common.property"/></th>
										<th class="table-text-align-c" ><spring:message code="data_transfer.value"/></th>
									</tr>
								</thead>												
								<tbody >														
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Access_Date"/></td>
										<td id="logDateTime" ></td>
									</tr>
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Access_User"/></td>
										<td  id="entityName" ></td>
									</tr>
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Access_Address"/></td>
										<td id="remoteAddress" ></td>
									</tr>
									<tr>
										<td class="table-text-align-c"> <spring:message code="encrypt_log_key.Access_Path"/></td>
										<td><textarea id="requestPath" name="requestPath" style="width:100%; height: 40px;  border: 0;" ></textarea></td> 
									</tr>
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Main_Text"/></td>
										<!-- <td style="text-align: left; height: 60px; word-break:break-all;" id ="parameter"></td> -->
										<td><textarea id="parameter" name="parameter" style="width:100%; height: 240px;  border: 0;" ></textarea></td> 
									</tr>
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Result_Code"/></td>
										<td id="resultCode" ></td>
									</tr>											
									<tr>
										<td class="table-text-align-c"><spring:message code="encrypt_log_key.Result_Message"/></td>
										<td  id="resultMessage" ></td>
									</tr>										
								</tbody> 									
							</table>				
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div>
</div>