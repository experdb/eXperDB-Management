<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../cmmn/commonLocale.jsp"%>  
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>

<script>
var work_table = null;
function fn_init2() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		work_table = $('#workList2').DataTable({
		scrollY : "245px",
		scrollX: true,	
		bSort: false,
		processing : true,
		searching : false,
		paging : true,	
		columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""},
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
			}
		},
		{ data : "wrk_exp",
				render : function(data, type, full, meta) {	 	
					var html = '';					
					html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
					return html;
				},
				defaultContent : ""
		},
		{data : "bsn_dscd_nm",  defaultContent : ""},
		{data : "bck_bsn_dscd_nm",  defaultContent : ""},
		{data : "db_svr_nm",  defaultContent : ""},		
		{data : "frst_regr_id",  defaultContent : ""},
		{data : "frst_reg_dtm",  defaultContent : ""},		
		{data : "wrk_id",  defaultContent : "", visible: false },
		{data : "db_svr_id",  defaultContent : "", visible: false},		
		{data : "db_id",  defaultContent : "", visible: false},
		{data : "db_nm",  defaultContent : "", visible: false},
		{data : "bsn_dscd",  defaultContent : "", visible: false},		
		{data : "bck_bsn_dscd",  defaultContent : "", visible: false},	
		{data : "bck_opt_cd",  defaultContent : "", visible: false},
		{data : "bck_opt_cd_nm",  defaultContent : "", visible: false},
		{data : "bck_mtn_ecnt",  defaultContent : "", visible: false},
		{data : "log_file_bck_yn",  defaultContent : "", visible: false},
		{data : "log_file_stg_dcnt",  defaultContent : "", visible: false},
		{data : "log_file_mtn_ecnt",  defaultContent : "", visible: false},
		{data : "cprt",  defaultContent : "", visible: false},
		{data : "save_pth",  defaultContent : "", visible: false},
		{data : "file_fmt_cd",  defaultContent : "", visible: false},
		{data : "file_stg_dcnt",  defaultContent : "", visible: false},
		{data : "encd_mth_nm",  defaultContent : "", visible: false},
		{data : "usr_role_nm",  defaultContent : "", visible: false},	
		{data : "lst_mdfr_id",  defaultContent : "", visible: false},
		{data : "lst_mdf_dtm",  defaultContent : "", visible: false}
		],'select': {'style': 'multi'}
	});
		
		
		work_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		work_table.tables().header().to$().find('th:eq(1)').css('min-width', '35px');
		work_table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
		work_table.tables().header().to$().find('th:eq(3)').css('min-width', '300px');
		work_table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		work_table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
		work_table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		work_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  
		work_table.tables().header().to$().find('th:eq(8)').css('min-width', '130px');
		work_table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(10)').css('min-width', '0px');  
		work_table.tables().header().to$().find('th:eq(11)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(12)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(14)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(15)').css('min-width', '0px');  
		work_table.tables().header().to$().find('th:eq(16)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(17)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(18)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(19)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(20)').css('min-width', '0px');  
		work_table.tables().header().to$().find('th:eq(21)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(22)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(23)').css('min-width', '0px');  
		work_table.tables().header().to$().find('th:eq(24)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(25)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(26)').css('min-width', '0px');  
		work_table.tables().header().to$().find('th:eq(27)').css('min-width', '0px');
		work_table.tables().header().to$().find('th:eq(28)').css('min-width', '0px');
		
		$(window).trigger('resize'); 
}

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	
	fn_init2();
	
	 /* ********************************************************
	  * 페이지 시작시, Repository DB에 등록되어 있는 디비의 서버명 SelectBox 
	  ******************************************************** */
	  	$.ajax({
			url : "/selectSvrList.do",
			data : {},
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
				$("#db_svr_nm").children().remove();
				$("#db_svr_nm").append("<option value='%'><spring:message code='common.dbms_name' /></option>");
				if(result.length > 0){
					for(var i=0; i<result.length; i++){
						$("#db_svr_nm").append("<option value='"+result[i].db_svr_nm+"'>"+result[i].db_svr_nm+"</option>");	
					}									
				}
			}
		}); 
	 
	 
		 /* ********************************************************
		  * 페이지 시작시, work 구분
		  ******************************************************** */
		  	$.ajax({
				url : "/selectWorkDivList.do",
				data : {},
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
					$("#work").children().remove();
					$("#work").append("<option value='%'><spring:message code="common.division" /></option>");
					if(result.length > 0){
						for(var i=0; i<result.length; i++){
							$("#work").append("<option value='"+result[i].bsn_dscd+"'>"+result[i].bsn_dscd_nm+"</option>");	
						}									
					}
				}
			}); 
});

/* ********************************************************
 * 조회
 ******************************************************** */
function fn_search(){
	if($("#db_svr_nm").val() == "%"){
		showSwalIcon('<spring:message code="message.msg152" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}

	$.ajax({
		url : "/selectWorkList.do",
		data : {
			bsn_dscd : $("#work").val(),
			db_svr_nm : $("#db_svr_nm").val(),
			wrk_nm : $("#wrk_nm").val()
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
			work_table.rows({selected: true}).deselect();
			work_table.clear().draw();
			work_table.rows.add(result).draw();
		}
	});
}


/* ********************************************************
 * work 등록
 ******************************************************** */
function fn_workAdd2(){
	var datas = work_table.rows('.selected').data();
	if (datas.length <= 0) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( work_table.rows('.selected').data()[i].wrk_id);   
	   //rowList.push( table.rows('.selected').data()[i]);     
  }	
	fn_workAddCallback(JSON.stringify(rowList));
	
	$('#pop_layer_scd_reg').modal("hide");
}
</script>

<style>
#scdinfo{
	width: 35% !important;
	margin-top: 0px !important;
}

#workinfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}

#scriptInfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}
</style>
<div class="modal fade" id="pop_layer_scd_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 30px 180px;">
		<div class="modal-content" style="width:1300px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="schedule.workReg"/>
				</h4>
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<select class="form-control" name="db_svr_nm" id="db_svr_nm">
									<option value="%"><spring:message code="common.dbms_name" />&nbsp;<spring:message code="schedule.total" /></option>
								</select>
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2">
								<select class="form-control" name="work" id="work">
									<option value="%"><spring:message code="common.choice" />&nbsp;<spring:message code="common.division" /></option>
								</select>
							</div>
							<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
								<input type="text" class="form-control" id="wrk_nm" name="wrk_nm" onblur="this.value=this.value.trim()" />
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><spring:message code="schedule.workList"/></p>
						
						<table id="workList2" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="10"></th>
									<th width="35"><spring:message code="common.no" /></th>
									<th width="200" class="dt-center"><spring:message code="common.work_name" /></th>
									<th width="300" class="dt-center"><spring:message code="common.work_description" /></th>
									<th width="70"><spring:message code="common.division" /></th>
									<th width="100"><spring:message code="backup_management.detail_div"/></th>
									<th width="150"><spring:message code="common.dbms_name" /></th>
									<th width="100"><spring:message code="common.register" /></th>
									<th width="100"><spring:message code="common.regist_datetime" /></th>						
									<th width="0"></th>
									<th width="0"></th>						
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;" type="button" onclick="fn_workAdd2()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>