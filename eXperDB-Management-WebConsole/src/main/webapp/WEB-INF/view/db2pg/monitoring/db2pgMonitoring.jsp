<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : db2pgMonitoring.jsp
	* @Description : db2pgMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.07.23     최초 생성
	*
	* author 신예은 매니저
	* since 2021.07.23
	*
	*/
%>

<script>
var table;

$(window.document).ready(function(){
	fn_init();
	fn_getStatus();
});

function fn_init() {
	table = $("#monitoring").DataTable({
		scrollY : "330px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
			{data : "tableName",  className : "dt-center", defaultContent : ""},
			{data : "dataCount", className : "dt-center", defaultContent : ""},
			{data : "migCount", className : "dt-center", defaultContent : ""},
			{data : "startTime", className : "dt-center", defaultContent : ""},
			{data : "endTime", className : "dt-center", defaultContent : ""},
			{data : "runTime", className : "dt-center", defaultContent : ""},
			{data : "result", className : "dt-center", defaultContent : ""}
		]
	});

	table.tables().header().to$().find('th:eq(0)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '130px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
	
}

function fn_getStatus(){
	console.log("fn_getStatus CALLED!!");
	$.ajax({
		url : "/db2pg/monitoring/getData.do",
		data : {
			
		},
		dataType : "json",
		type : "post",
		success : function(result){
			console.log("getStatus end!");
		}
	})
}

</script>
<!-- <%@include file="./../../popup/confirmMultiForm.jsp"%> -->


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
												<i class="ti-server menu-icon"></i>
												<span class="menu-title">모니터링</span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page">MIGRATION</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_migration" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">모니터링</li>
										</ol>
									</div>
								</div>
							</div>
							<!-- 수정필요 -->
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0">모니터링 설명</p>
										</div>
									</div>
								</div>
							</div>
							<!-- ///////// -->
						</div>
					</div>
					<!-- title end -->
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
									<table id="monitoring" class="table table-hover system-tlb-scroll" cellspacing="0" width="100%">
										<thead>
											<tr class="bg-info text-white">
												<th width="130">테이블명</th>
												<th width="130">총건수</th>
												<th width="130">이행건수</th>
												<th width="130">시작시간</th>
												<th width="130">종료시간</th>
												<th width="130">걸린시간</th>
												<th width="80">완료여부</th>
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