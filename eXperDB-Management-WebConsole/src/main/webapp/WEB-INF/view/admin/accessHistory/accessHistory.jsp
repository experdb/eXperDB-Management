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
	var table = null;

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
			$('#lgi_dtm_start_prm').val(lgi_dtm_start);
			$('#lgi_dtm_end_prm').val(lgi_dtm_end);
		}
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
   		table = $('#accessHistoryTable').DataTable({	
		scrollY: "305px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data: "exedtm_date", className : "dt-left", defaultContent : ""},
		    		{data: "exedtm_hour", className: "dt-left", defaultContent: ""}, 
		    		{data: "sys_cd_nm", className: "dt-left", defaultContent: ""}, 
		    		{data: "usr_id", className: "dt-left", defaultContent: ""}, 
		    		{data: "usr_nm", className: "dt-left", defaultContent: ""}, 
		    		{data: "dept_nm", className: "dt-left", defaultContent: ""}, 
		    		{data: "pst_nm", className: "dt-left", defaultContent: ""},
		    		{data: "lgi_ipadr", className: "dt-left", defaultContent: ""}
 		        ]
		});
   	
	   	table.tables().header().to$().find('th:eq(0)').css('min-width', '5%');
	   	table.tables().header().to$().find('th:eq(1)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(2)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(3)').css('min-width', '15%');
	   	table.tables().header().to$().find('th:eq(4)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(5)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(6)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(7)').css('min-width', '10%');
	   	table.tables().header().to$().find('th:eq(8)').css('min-width', '10%');

    	$(window).trigger('resize'); 
	}

	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);

		today.setDate(today.getDate());
		var day_start = today.toJSON().slice(0,10); 

		$("#lgi_dtm_start_prm").val(day_start);
		$("#lgi_dtm_end_prm").val(day_end);

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
		
		$("#lgi_dtm_start_prm").datepicker('setDate', day_start);
	    $("#lgi_dtm_end_prm").datepicker('setDate', day_end);
	    $('#wrk_strt_dtm_div').datepicker('updateDates');
	    $('#wrk_end_dtm_div').datepicker('updateDates');
	}
	
	/* ********************************************************
	 *  엑셀다운로드
	 ******************************************************** */
	function fn_ExportExcel() {
		var table = document.getElementById("accessHistoryTable");
		var dataCnt = table.rows.length;

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
	 *  이력 리스트 조회
	 ******************************************************** */
	 function fn_select(){
		var lgi_dtm_start = $("#lgi_dtm_start_prm").val();
		var lgi_dtm_end = $("#lgi_dtm_end_prm").val();

		if (lgi_dtm_start != "" && lgi_dtm_end == "") {
			showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		if (lgi_dtm_end != "" && lgi_dtm_start == "") {
			showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		$.ajax({
			url : "/selectSearchAccessHistoryNew.do",
			data : {
				lgi_dtm_start : $("#lgi_dtm_start_prm").val(),
				lgi_dtm_end : $("#lgi_dtm_end_prm").val(),
				type : $("#type").val(),
				search : $("#search").val(),
				sys_cd : $("#sys_cd").val(),
				order_type : $("#order_type").val(),
				order : $('#order').val()
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
	
				if (nvlPrmSet(result, "") != '') {
					table.rows.add(result).draw();
				}
			}
		});
	}
</script>
<form name="excelForm" method="post">
	<input type="hidden" name="lgi_dtm_start" id="lgi_dtm_start">
	<input type="hidden" name="lgi_dtm_end" id="lgi_dtm_end"> 
	<input type="hidden" name="excel_type" id="excel_type">
	<input type="hidden" name="excel_search" id="excel_search">
	<input type="hidden" name="excel_order_type" id="excel_order_type">
	<input type="hidden" name="excel_order" id="excel_order">
	<input type="hidden" name="excel_sys_cd" id="excel_sys_cd">
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
												<i class="ti-lock menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.screen_access_history" /></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">ADMIN</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.history_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.screen_access_history"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.screen_access_history_01" /></p>
											<p class="mb-0"><spring:message code="help.screen_access_history_02" /></p>
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
						<div class="card-body" style="margin:-10px -10px -15px 0px;">
							<form class="form-inline row" onsubmit="return false;">
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row" >
									<div id="wrk_strt_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_start_prm" name="lgi_dtm_start_prm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none;"> ~ </span>
									</div>
		
									<div id="wrk_end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="lgi_dtm_end_prm" name="lgi_dtm_end_prm" readonly>
										<span class="input-group-addon input-group-append border-left" >
											<span class="ti-calendar input-group-text" style="cursor:pointer;"></span>
										</span>
									</div>
								</div>
										
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-left: -1rem;margin-right: -1.8rem;" name="type" id="type">
	 									<option value="usr_nm" ${type == 'usr_nm' ? 'selected="selected"' : ''}><spring:message code="history_management.user_name" /></option> 
	 									<option value="usr_id" ${type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /> </option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="search" name="search" value="${search}" maxlength="15"  onblur="this.value=this.value.trim()" placeholder='<spring:message code="history_management.user" />' />	
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
									<select class="form-control" style="margin-right: -0.7rem;" name="sys_cd" id="sys_cd">
										<option value="" ${sys_cd == '' ? 'selected="selected"' : ''}><spring:message code="common.total" /></option>	
										<c:forEach var="ScreenNames" items="${ScreenNames}">
											<option value="${ScreenNames.sys_cd}" ${ScreenNames.sys_cd == sys_cd ? 'selected="selected"' : ''}>${ScreenNames.sys_cd_nm}</option>							
										</c:forEach>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -0.7rem;" name="order_type" id="order_type">
										<option value="exedtm" ${order_type == 'exedtm' ? 'selected="selected"' : ''}><spring:message code="history_management.bydate" /></option>
										<option value="usr_id" ${order_type == 'usr_id' ? 'selected="selected"' : ''}><spring:message code="history_management.id" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" name="order" id="order">
										<option value="desc" ${order == 'desc' ? 'selected="selected"' : ''}><spring:message code="history_management.descending_order" /></option>
										<option value="asc" ${order == 'asc' ? 'selected="selected"' : ''}><spring:message code="history_management.ascending_order" /> </option>	
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="read_button"onclick="fn_select()" >
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
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text" id="btnExcel" onclick="fn_ExportExcel()" data-toggle="modal">
									<i class="fa fa-file-excel-o btn-icon-prepend "></i><spring:message code="history_management.excel_save" />
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

	 								<table id="accessHistoryTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
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
											<tr class="bg-info text-white">
												<th scope="col"><spring:message code="common.no" /></th>
												<th scope="col"><spring:message code="history_management.date" /></th>
												<th scope="col"><spring:message code="history_management.time" /></th>
												<th scope="col"><spring:message code="history_management.screen" /></th>
												<th scope="col"><spring:message code="history_management.id" /></th>
												<th scope="col"><spring:message code="history_management.user_name" /></th>
												<th scope="col"><spring:message code="history_management.department" /></th>
												<th scope="col"><spring:message code="history_management.position" /></th>
												<th scope="col"><spring:message code="history_management.ip" /></th>
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