<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs2.jsp"%>
    <script>
    function fn_validation(){
    	var arySrtDt = $('#from').val(); // ex) 시작일자(2007-10-09)
     	var aryEndDt = $('#to').val(); // ex) 종료일자(2007-12-05)
    	var startDt = new Date(arySrtDt);
    	var endDt	= new Date(aryEndDt);
    	resultDt	= Math.round((endDt.valueOf() - startDt.valueOf())/(1000*60*60*24*365/12));
    	if(resultDt>6){
    		showSwalIcon('<spring:message code="message.msg34" />', '<spring:message code="common.close" />', '', 'error');
    		return false; 
    	}
    	return true;
    }
    
	$(window.document).ready(function() {
		fn_buttonAut();		
		
		//작업기간 calender setting
		dateCalenderSetting();
		
		var lgi_dtm_start = "${lgi_dtm_start}";
		var lgi_dtm_end = "${lgi_dtm_end}";
		if (lgi_dtm_start != "" && lgi_dtm_end != "") {
			$('#from').val(lgi_dtm_start);
			$('#to').val(lgi_dtm_end);
		}
		
		var exe_result = "${exe_result}";
		var svr_nm = "${svr_nm}";
		var scd_nm = "${scd_nm}";
		var wrk_nm = "${wrk_nm}";
		
		if(exe_result == "" || exe_result==null){
			document.getElementById("exe_result").value="%";
		}else{
			document.getElementById("exe_result").value=exe_result;
		}
// 		fn_SelectDBMS(svr_nm);
// 		fn_ScheduleNmList(scd_nm);

		fn_init_scdH();
	
	});
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate());
		var day_start = today.toJSON().slice(0,10); 

		$("#from").val(day_start);
		$("#to").val(day_end);

		if ($("#wrk_strt_dtm_div").length) {
			$('#wrk_strt_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}

		if ($("#wrk_end_dtm_div").length) {
			$('#wrk_end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    }); //값 셋팅
		}
		
		$("#from").datepicker('setDate', day_start);
	    $("#to").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	}
	
	function fn_buttonAut(){
		var read_button = document.getElementById("read_button"); 
		if("${read_aut_yn}" == "Y"){
			read_button.style.display = '';
		}else{
			read_button.style.display = 'none';
		}
	}
	
	/*조회버튼 클릭시*/
	function fn_selectScheduleHistory() {
		if (!fn_validation()) return false;
		document.selectScheduleHistory.pageIndex.value = 1;
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}

	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo) {
		document.selectScheduleHistory.pageIndex.value = pageNo;
		document.selectScheduleHistory.action = "/selectScheduleHistory.do";
		document.selectScheduleHistory.submit();
	}
	
// 	/* DBMS 조회 [SELECT BOX] */
// 	function fn_SelectDBMS(svr_nm){
// 	  	$.ajax({
// 			url : "/selectScheduleDBMSList.do",
// 			data : {
// 				wrk_start_dtm : $('#from').val(),
// 				wrk_end_dtm : 	$('#to').val()	
// 			},
// 			dataType : "json",
// 			type : "post",
// 			beforeSend: function(xhr) {
// 		        xhr.setRequestHeader("AJAX", true);
// 		     },
// 			error : function(xhr, status, error) {
// 				if(xhr.status == 401) {
// 					alert("<spring:message code='message.msg02' />");
// 					top.location.href = "/";
// 				} else if(xhr.status == 403) {
// 					alert("<spring:message code='message.msg03' />");
// 					top.location.href = "/";
// 				} else {
// 					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
// 				}
// 			},
// 			success : function(result) {		
// 				$("#db_svr_nm").children().remove();
// 				$("#db_svr_nm").append("<option value='%'><spring:message code='common.total' /></option>");
// 				if(result.length > 0){
// 					for(var i=0; i<result.length; i++){
// 						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
// 					}									
// 				}
// 				$("#db_svr_nm").val(svr_nm).attr("selected", "selected");
// 			}
// 		});	 
// 	}
	
	function setSearchDate(start){
		$('input:not(:checked)').parent(".chkbox2").removeClass("on");
        $('input:checked').parent(".chkbox2").addClass("on");       
        
		var num = start.substring(0,1);
		var str = start.substring(1,2);

		var today = new Date();

		//var year = today.getFullYear();
		//var month = today.getMonth() + 1;
		//var day = today.getDate();
		
		var endDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#to').val(endDate);
		
		if(str == 'd'){
			today.setDate(today.getDate() - num);
		}else if (str == 'w'){
			today.setDate(today.getDate() - (num*7));
		}else if (str == 'm'){
			today.setMonth(today.getMonth() - num);
			today.setDate(today.getDate() + 1);
		}

		var startDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#from').val(startDate);
				
		// 종료일은 시작일 이전 날짜 선택하지 못하도록 비활성화
		$("#to").datepicker( "option", "minDate", startDate );
		
		// 시작일은 종료일 이후 날짜 선택하지 못하도록 비활성화
		$("#from").datepicker( "option", "maxDate", endDate );

	}

// 	function fn_ScheduleNmList(scd_nm){
// 	  	$.ajax({
// 			url : "/selectScheduleNmList.do",
// 			data : {
// 				wrk_start_dtm : $('#from').val(),
// 				wrk_end_dtm : 	$('#to').val()				
// 			},
// 			dataType : "json",
// 			type : "post",
// 			beforeSend: function(xhr) {
// 		        xhr.setRequestHeader("AJAX", true);
// 		     },
// 			error : function(xhr, status, error) {
// 				if(xhr.status == 401) {
// 					alert("<spring:message code='message.msg02' />");
// 					top.location.href = "/";
// 				} else if(xhr.status == 403) {
// 					alert("<spring:message code='message.msg03' />");
// 					top.location.href = "/";
// 				} else {
// 					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
// 				}
// 			},
// 			success : function(result) {		
// 				$("#scd_nm").children().remove();
// 				$("#scd_nm").append("<option value='%'><spring:message code='schedule.total' /></option>");
// 				if(result.length > 0){
// 					for(var i=0; i<result.length; i++){
// 						$("#scd_nm").append("<option value='"+result[i].scd_nm+"'>"+result[i].scd_nm+"</option>");	
// 					}									
// 				}
// 				$("#scd_nm").val(scd_nm).attr("selected", "selected");		
// // 				fn_selectedWork(scd_nm);
// 			}
// 		});	 
// 	}
	
	
// 	function fn_dtm(){
// 		fn_ScheduleNmList();
// 	}
	
// 	function fn_selectedWork(scd_nm){
// 	  	 $.ajax({
// 			url : "selectWrkNmList.do",
// 			data : {
// 				scd_nm : scd_nm
// 			},
// 			dataType : "json",
// 			type : "post",
// 			error : function(request, status, error) {
// 				alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
// 			},
// 			success : function(result) {		
// 				$("#wrk_nm").children().remove();
// 				$("#wrk_nm").append("<option value='%'>전체</option>");
// 				if(result.length > 0){
// 					for(var i=0; i<result.length; i++){
// 						$("#wrk_nm").append("<option value='"+result[i].wrk_nm+"'>"+result[i].wrk_nm+"</option>");	
// 					}									
// 				}
// 				//$("#wrk_nm").val(wrk_nm).attr("selected", "selected");	
// 			}
// 		});
// 	}
	
// 	function fn_selectWrkNmList(scd_nm){
// 	  	 $.ajax({
// 			url : "selectWrkNmList.do",
// 			data : {
// 				scd_nm : scd_nm.value
// 			},
// 			dataType : "json",
// 			type : "post",
// 			beforeSend: function(xhr) {
// 		        xhr.setRequestHeader("AJAX", true);
// 		     },
// 			error : function(xhr, status, error) {
// 				if(xhr.status == 401) {
// 					alert("<spring:message code='message.msg02' />");
// 					top.location.href = "/";
// 				} else if(xhr.status == 403) {
// 					alert("<spring:message code='message.msg03' />");
// 					top.location.href = "/";
// 				} else {
// 					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
// 				}
// 			},
// 			success : function(result) {		
// 				$("#wrk_nm").children().remove();
// 				$("#wrk_nm").append("<option value='%'><spring:message code='common.total' /></option>");
// 				if(result.length > 0){
// 					for(var i=0; i<result.length; i++){
// 						$("#wrk_nm").append("<option value='"+result[i].wrk_nm+"'>"+result[i].wrk_nm+"</option>");	
// 					}									
// 				}
// 			}
// 		});
// 	}

	function fn_detail(exe_sn){
		$.ajax({
			url : "/selectScheduleHistoryWorkDetail.do",
			data : {
				exe_sn : exe_sn
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
				workTable_history.clear().draw();
				workTable_history.rows.add(result).draw();
				fn_scd_deatil(exe_sn);
				$('#pop_layer_scd_history').modal("show");
			}
		});
		
	}
	
	function fn_scd_deatil(exe_sn){
		$.ajax({
			url : "/popup/scheduleHistoryDetail.do",
			data : {
				exe_sn : exe_sn,
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
				var results= result.result[0];
				$("#scd_history_info").empty();
				var html ='<table class="table table-striped system-tlb-scroll" style="border:1px solid #99abb0;">';
				html +='<colgroup><col style="width:15%;" /><col style="width:85%;" /></colgroup>';
				html +='<tbody>';
				html +='<tr><td><spring:message code="schedule.schedule_name" /></td><td style="text-align: left"><span onClick="javascript:fn_scdLayer('+results.scd_id+');" class="bold">'+results.scd_nm+'</span></td></tr>'
				html +='<tr><td><spring:message code="schedule.work_start_datetime" /></td><td style="text-align: left">'+results.wrk_strt_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.work_end_datetime" /></td><td style="text-align: left">'+results.wrk_end_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.jobTime"/></td><td style="text-align: left">'+results.wrk_dtm+'</td></tr>';
				html +='<tr><td><spring:message code="schedule.scheduleExp"/></td><td style="text-align: left">'+results.scd_exp+'</td></tr>';
				html  +='</tbody></table>';
				$("#scd_history_info").append(html);
			}
		});	
	}
    </script>
    
<%@include file="../../cmmn/scheduleInfo.jsp"%>
<%@include file="../../cmmn/wrkLog.jsp"%>
<%@include file="../../popup/scheduleHistoryDetail.jsp"%>

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
									<div class="col-5">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="ti-calendar menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.shedule_execution_history" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">Function</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.schedule_information" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.shedule_execution_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.shedule_execution_history" /></p>
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
		
		<form:form commandName="pagingVO" name="selectScheduleHistory" id="selectScheduleHistory" method="post" class="form-inline">
		<div class="col-12 div-form-margin-cts stretch-card">
			<div class="card">
				<div class="card-body">
					<!-- search param start -->
					<div class="card">
						<div class="card-body">
							<div class="form-inline">
								<div class="row">
									<div class="input-group mb-2 mr-sm-2">
										<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="from" name="lgi_dtm_start" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
										<div class="input-group align-items-center">
											<span style="border:none; padding: 0px 10px;"> ~ </span>
										</div>
										<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker">
											<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="to" name="lgi_dtm_end" readonly>
											<span class="input-group-addon input-group-append border-left">
												<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
											</span>
										</div>
									</div> 
									<div class="input-group mb-2 mr-sm-2">
										<input type="text" class="form-control" style="width:200px;margin-right: 2rem;" id="scd_nm" name="scd_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="schedule.schedule_name" />' value="${scd_nm}"/>		
									</div>
									<div class="input-group mb-2 mr-sm-2">
										<input type="text" class="form-control" style="width:200px;margin-right: 2rem;" id="db_svr_nm" name="db_svr_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.dbms_name" />' value="${svr_nm}"/>		
									</div>
									<div class="input-group mb-2 mr-sm-2">
										<select class="form-control" style="width:150px; margin-right: 1rem;" name="exe_result" id="exe_result">
											<option value="%"><spring:message code="schedule.result" />&nbsp;<spring:message code="schedule.total" /></option>
											<option value="TC001701"><spring:message code="common.success" /></option>
											<option value="TC001702"><spring:message code="common.failed" /></option>
										</select>
									</div>
									<div class="input-group mb-2 mr-sm-2">
										<select class="form-control" style="width:150px; margin-right: 1rem;" name="order_type" id="order_type">
											<option value="wrk_strt_dtm" ${order_type == 'wrk_strt_dtm' ? 'selected="selected"' : ''}><spring:message code="schedule.work_start_datetime" /></option>
											<option value="wrk_end_dtm" ${order_type == 'wrk_end_dtm' ? 'selected="selected"' : ''}><spring:message code="schedule.work_end_datetime" /></option>
										</select>
									</div>
									<div class="input-group mb-2 mr-sm-2">
										<select class="form-control" style="width:150px; margin-right: 1rem;" name="order" id="order">
											<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option>
											<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>		
										</select>
									</div>
									<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button"onclick="fn_selectScheduleHistory()" >
										<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
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

										<table class="table table-hover table-striped" id="accessHistoryTable">
											<colgroup>
												<col style="width: 5%;" />
												<col style="width: 10%;" />
												<col style="width: 10%;" />
												<col style="width: 15%;" />
												<col style="width: 10%;" />
												<col style="width: 10%;" />
												<col style="width: 10%;" />
												<col style="width: 10%;" />
												<col style="width: 10%;" />
											</colgroup>
											<thead>
												<tr class="bg-primary text-white" style="border-bottom: 1px solid #b8c3c6;">
													<th scope="col"><spring:message code="common.no" /></th>
													<th scope="col"><spring:message code="schedule.schedule_name" /></th>
													<th scope="col"><spring:message code="common.dbms_name" /></th>
													<th scope="col"><spring:message code="dbms_information.dbms_ip" /></th>							
													<th scope="col"><spring:message code="schedule.work_start_datetime" /></th>
													<th scope="col"><spring:message code="schedule.work_end_datetime" /></th>
													<th scope="col"><spring:message code="schedule.jobTime"/></th>
													<th scope="col"><spring:message code="schedule.result" /></th>
													<th scope="col"><spring:message code="schedule.detail_view" /></th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="result" items="${result}" varStatus="status">
													<tr>
														<td><c:out value="${pagingVO.pageSize*(pagingVO.pageIndex-1) + result.rownum}" /></td>
														<td style="text-align: left;"><span onclick="fn_scdLayer('${result.scd_id}');" class="bold" title="${result.scd_nm}"><c:out value="${result.scd_nm}" /></span></td>
														<td style="text-align: left;"><c:out value="${result.db_svr_nm}" /></td>		
														<td style="text-align: left;"><c:out value="${result.ipadr}" /></td>				
														<td style="text-align: left;"><c:out value="${result.wrk_strt_dtm}" /></td>
														<td style="text-align: left;"><c:out value="${result.wrk_end_dtm}" /></td>
														<td style="text-align: left;"><c:out value="${result.wrk_dtm}" /></td>
														<td>
															<c:choose>
																<c:when test="${result.exe_rslt_cd eq 'TC001701'}">
																	<div class='badge badge-pill badge-success'><i class='ti-face-smile  mr-2'></i>Success</div>
																</c:when>
														    	<c:when test="${result.exe_rslt_cd eq 'TC001702'}">
														    		<div class='badge badge-pill badge-danger'><i class='ti-face-sad  mr-2'></i>Fail</div>
														    	</c:when>
														    	<c:otherwise>
														    		<div class='badge badge-pill badge-warning'><i class='fa fa-spin fa-spinner mr-2'></i><spring:message code="etc.etc28"/></div>
														    	</c:otherwise>
															</c:choose>
														</td>
														<td>
															<button type="button" id="detail" class="btn btn-outline-primary btn-sm" onclick="fn_detail(${result.exe_sn})"><spring:message code="schedule.detail_view" /> </button>
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
							 	</div>
						 	</div>
					</div>
					<div class="card-body" >
						 <div class="row">
							<div class="col-sm-12 col-md-12">
								 <ul id='pagininfo' class='pagination justify-content-center'> 
							 		<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_egov_link_page" /> 
							 		<form:hidden path="pageIndex" /> 
							 	</ul>
							</div>
						</div>
					</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
		</div>
		</form:form>
	</div>
</div>