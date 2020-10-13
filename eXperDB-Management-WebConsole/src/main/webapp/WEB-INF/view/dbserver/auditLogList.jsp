<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../cmmn/cs2.jsp"%>

<%
	/**
	* @Class Name : auditLogList.jsp
	* @Description : Audit 로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
	*
	*/
%>
<script type="text/javascript">
	var table = null;

	/* ********************************************************
	 * setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_init();

		//agent 확인
		var extName = "${extName}";
		
 		if (!fn_chkExtName(extName)) {
			$("#btnSelect").prop("disabled", "disabled");
			return;
		}
		
		//작업기간 calender setting
		dateCalenderSetting();
		
		$('.dataTables_filter').hide();
		
		//조회
		fn_search();

		/* ********************************************************
		 * Click Search Button
		 ******************************************************** */
		$("#btnSelect").click(function() {
			var start_dtm = $("#start_dtm").val();
			var end_dtm = $("#end_dtm").val();

			if (start_dtm != "" && end_dtm == "") {
				showSwalIcon('<spring:message code="message.msg14" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}

			if (end_dtm != "" && start_dtm == "") {
				showSwalIcon('<spring:message code="message.msg15" />', '<spring:message code="common.close" />', '', 'error');
				return false;
			}

			fn_search();
		}); 

		/* ********************************************************
		 * Ajax 파일 다운로드
		 ******************************************************** */
		jQuery.download = function(url, data, method){
		    // url과 data를 입력받음
		    if( url && data ){ 
		        // data 는  string 또는 array/object 를 파라미터로 받는다.
		        data = typeof data == 'string' ? data : jQuery.param(data);
		        // 파라미터를 form의  input으로 만든다.
		        var inputs = '';
		        jQuery.each(data.split('&'), function(){ 
		            var pair = this.split('=');
		            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
		        });
		        // request를 보낸다.
		        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
		        .appendTo('body').submit().remove();
		    };
		};
	});

	/* ********************************************************
	 * agent 상태 확인
	 ******************************************************** */
	function fn_chkExtName(extName) {
		var title = '<spring:message code="menu.audit_history"/>' + ' ' + '<spring:message code="access_control_management.msg6" />';

 		if(extName == "") {
			showDangerToast('top-right', '<spring:message code="message.msg26" />', title);
			return false;
 		} else if(extName == "agent") {
			showDangerToast('top-right', '<spring:message code="message.msg25" />', title);
			return false;
		}else if(extName == "agentfail"){
			showDangerToast('top-right', '<spring:message code="message.msg27" />', title);
			return false;
		}
 		
 		return true;
	}
	
	/* ********************************************************
	 * 작업기간 calender 셋팅
	 ******************************************************** */
	function dateCalenderSetting() {
		var today = new Date();
		var day_end = today.toJSON().slice(0,10);
		var day_start = today.toJSON().slice(0,10);

		$("#start_dtm").val(day_start);
		$("#end_dtm").val(day_end);

		if ($("#start_dtm_div").length) {
			$('#start_dtm_div').datepicker({
			}).datepicker('setDate', day_start)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_start = new Date(selected.date.valueOf());
		    	day_start.setDate(day_start.getDate(new Date(selected.date.valueOf())));
		        $("#end_dtm_div").datepicker('setStartDate', day_start);
		        $("#end_dtm").datepicker('setStartDate', day_start);
			}); //값 셋팅
		}

		if ($("#end_dtm_div").length) {
			$('#end_dtm_div').datepicker({
			}).datepicker('setDate', day_end)
			.on('hide', function(e) {
				e.stopPropagation(); // 모달 팝업도 같이 닫히는걸 막아준다.
		    })
		    .on('changeDate', function(selected){
		    	day_end = new Date(selected.date.valueOf());
		    	day_end.setDate(day_end.getDate(new Date(selected.date.valueOf())));
		        $('#start_dtm_div').datepicker('setEndDate', day_end);
		        $('#start_dtm').datepicker('setEndDate', day_end);
			}); //값 셋팅
		}
		
		$("#start_dtm").datepicker('setDate', day_start);
	    $("#end_dtm").datepicker('setDate', day_end);
	    $('#start_dtm_div').datepicker('updateDates');
	    $('#end_dtm_div').datepicker('updateDates');
	}
	

	/* ********************************************************
	 * 테이블 setting
	 ******************************************************** */
	function fn_init(){
		table = $('#auditLogTable').DataTable({
			scrollY : "400px",
			bSort: false,
			paging: false,
			scrollX: true,
		//	searching : false,
			columns : [
		         	{data : "", className : "dt-center", defaultContent : ""},
		    		{data : "file_name", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return "<a href='#' class='bold' id='openLogView'>"+data+"</a>";
		    			}
		    		},
		    		{ data : "file_size", defaultContent : ""}, 
		    		{ data : "file_lastmodified", defaultContent : ""}
		    ]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');

    	$(window).trigger('resize'); 

     	table.on( 'order.dt search.dt', function () {
			table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
    			cell.innerHTML = i+1;
    		});
    	}).draw();
   	
    	$('#auditLogTable tbody').on('click','#openLogView', function () {
    		var $this = $(this);
	    	var $row = $this.parent().parent();
	    	
	    	$row.addClass('select-detail');
	    	var datas = table.rows('.select-detail').data();
	    	var row = datas[0];
		    $row.removeClass('select-detail');
		    
		    //상세팝업 호출
		    fn_logFileView(row);
		});
	}
	
	/* ********************************************************
	 * 조회 실행
	 ******************************************************** */
	function fn_search() {
		$.ajax({
			url : "/selectAuditManagement.do",
			data : {
				lgi_dtm_start : $("#start_dtm").val(),
				lgi_dtm_end : $("#end_dtm").val(),
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
				table.clear().draw();

				if (nvlPrmSet(result, '') != '') {
					table.rows.add(result).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * 전송관리 상세
	 ******************************************************** */
	function fn_logFileView(row){
	    var file_name_param = row.file_name;
	    var file_size_param = row.file_size;
	    var v_size = file_size_param.replace("Mb", "");

		$.ajax({
			url : "/audit/auditLogView.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
				file_name : file_name_param,
				dwLen : 1
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
				
				if (result != null) {
					$("#view_file_name", "#auditViewForm").html("<b>" + file_name_param + "</b>");
					$("#view_file_size", "#auditViewForm").html("<b>" + file_size_param + "</b>");
				} else {
					$("#view_file_name", "#auditViewForm").html("");
					$("#view_file_size", "#auditViewForm").html("");
				}

				$("#log_line", "#auditViewForm").val("1000");
				$("#auditlog", "#auditViewForm").html("");
				
				$("#seek", "#auditViewForm").val("0");
				$("#info_file_name", "#auditViewForm").val(file_name_param.trim());
				$("#endFlag", "#auditViewForm").val("0");
				$("#dwLen", "#auditViewForm").val("0");
				$("#fSize", "#auditViewForm").val("");

				//내역 조회
				fn_addView();
				
				$('#pop_layer_audit_info').modal('show');
			}
		});	
	}
</script>

<%@include file="./../popup/auditLogView.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
</form>

<div class="content-wrapper main_scroll"  style="min-height: calc(100vh);" id="contentsDiv">
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
												<i class="fa fa-history"></i>
												<span class="menu-title"><spring:message code="menu.audit_history"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${serverName}</a>
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.audit_management"/></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.audit_history"/></li>
										</ol>
									</div>
								</div>
							</div>

							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.audit_history"/></p>
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
								<div class="input-group mb-2 mr-sm-2 col-sm-3_0 row">
									<div id="start_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="start_dtm" name="start_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>

									<div class="input-group align-items-center col-sm-1">
										<span style="border:none; padding: 0px 10px;"> ~ </span>
									</div>
		
									<div id="end_dtm_div" class="input-group align-items-center date datepicker totDatepicker col-sm-5_5">
										<input type="text" class="form-control totDatepicker" style="width:150px;height:44px;" id="end_dtm" name="end_dtm" readonly>
										<span class="input-group-addon input-group-append border-left">
											<span class="ti-calendar input-group-text" style="cursor:pointer"></span>
										</span>
									</div>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSelect">
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
					<div class="card my-sm-2" >
						<div class="card-body" >
	 						<table id="auditLogTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
								<thead>
									<tr class="bg-info text-white">
										<th width="20"><spring:message code="common.no" /></th>
										<th width="200"><spring:message code="access_control_management.log_file_name" /></th>
										<th width="80"><spring:message code="common.size" /></th>
										<th width="100"><spring:message code="common.modify_datetime" /></th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<!-- content-wrapper ends -->
				</div>
			</div>
		</div>
	</div>
</div>

<iframe id="frmDownload" name="frmDownload" width="0px" height="0px"></iframe>