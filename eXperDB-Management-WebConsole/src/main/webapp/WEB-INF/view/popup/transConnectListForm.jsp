<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transConnectListForm.jsp
	* @Description : trans KAFKA CONNECT 팝업
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.01     최초 생성
	*
	* author 
	* since 2017.06.01
	*
	*/
%>    

<script>
	var trans_kafka_con_pop_table = null;
	var trans_regi_con_pop_table = null;
	
	$(window.document).ready(function() {
		fn_trans_kafka_con_pop_init();
		fn_trans_schema_re_con_pop_init();
		
	  	$(function() {	
	  		//row 클릭시
/* 	  		$('#transKfkConPopList tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
	  	     	}else {	        	
	  	     		trans_kafka_con_pop_table.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');	            
				} 
	  		})		 */
	  	});
	});

	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_trans_kafka_con_pop_init() {
		trans_kafka_con_pop_table = $('#transKfkConPopList').DataTable({
			scrollY : "260px",
			searching : false,
			deferRender : true,
			scrollX: true,
			bSort: false,
			paging: false,
			columns : [
				{data : "kc_nm", className : "dt-left", defaultContent : ""},
				{data : "kc_ip", className : "dt-center", defaultContent : ""},
				{data : "kc_port", className : "dt-center", defaultContent : ""},

				{data : "exe_status", 
					render: function (data, type, full){
						var html = "";
						if(full.exe_status == "TC001501"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "	<spring:message code='eXperDB_CDC.connecting' />";
						} else {
							html += "<div class='badge badge-pill badge-danger'>";
							html += "	<i class='ti-close mr-2'></i>";
							html += "	<spring:message code='schedule.stop' />";
						}

						html += "</div>";

						return html;
					},
					className : "dt-left",
					defaultContent : "" 	
				},
				{data : "kc_id",  defaultContent : "", visible: false }
			]
		});

		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '150px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '93px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '70px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '0px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_trans_schema_re_con_pop_init() {
		trans_regi_con_pop_table = $('#transRegiConnectPopList').DataTable({
			scrollY : "260px",
			searching : false,
			deferRender : true,
			scrollX: true,
			bSort: false,
			paging: false,
			columns : [
					{data : "regi_nm", className : "dt-left", defaultContent : ""},
 					{data : "regi_ip", className : "dt-center", defaultContent : ""},
 					{data : "regi_port", className : "dt-center", defaultContent : ""},
					{data : "exe_status", 
						render: function (data, type, full){
							var html = "";
							if(full.exe_status == "TC001501"){
								html += "<div class='badge badge-pill badge-success'>";
								html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
								html += "	<spring:message code='eXperDB_CDC.connecting' />";
							} else {
								html += "<div class='badge badge-pill badge-danger'>";
								html += "	<i class='ti-close mr-2'></i>";
								html += "	<spring:message code='schedule.stop' />";
							}
	
							html += "</div>";
	
							return html;
						},
						className : "dt-left",
						defaultContent : "" 	
					},
					{data : "regi_id",  defaultContent : "", visible: false }
			]
		});

		trans_regi_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '150px');
		trans_regi_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '90px');
		trans_regi_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '70px');
		trans_regi_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '80px');
		trans_regi_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '0px');

		$(window).trigger('resize');
	}
</script>

<div class="modal fade" id="pop_layer_trans_con_list" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 60px 250px;">
		<div class="modal-content" style="width:1200px;">
			<div class="modal-body" style="margin-bottom:-30px;">
			
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="eXperDB_CDC.connector_server_settings" />
				</h4>
		
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row" style="margin-top:-10px;margin-bottom:-20px;">
							<div class="input-group mb-2 mr-sm-2 col-sm-4">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_trans_kafka_con_nm" name="pop_trans_kafka_con_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="eXperDB_CDC.connector_server_nm" />'/>		
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_trans_kafka_con_pop_search();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					
					<br />
			
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="row">
							<div class="col-6">
 								<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i> Kafka Connect <spring:message code="button.list"/></p>
 								
								<table id="transKfkConPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
									<thead>
										<tr class="bg-info text-white">
											<th width="150"><spring:message code="etc.etc04"/></th>
		 									<th width="93"><spring:message code="data_transfer.ip" /></th>
											<th width="70"><spring:message code="data_transfer.port" /></th>
											<th width="80"><spring:message code="eXperDB_CDC.connection_status" /></th>
											<th width="0"></th>
										</tr>
									</thead>
								</table>
							</div>
							 	
							<div class="col-6">
 								<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i> Schema Registry <spring:message code="common.infomation" /></p>
 								
		 						<table id="transRegiConnectPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
									<thead>
	 									<tr class="bg-info text-white">
											<th width="150"><spring:message code="eXperDB_CDC.schema_registr_nm" /></th>
			 								<th width="90"><spring:message code="data_transfer.ip" /></th>
											<th width="70"><spring:message code="data_transfer.port" /></th>
											<th width="80"><spring:message code="eXperDB_CDC.connection_status" /></th>
											<th width="0"></th>
										</tr>
									</thead>
								</table>
						 	</div>
						 </div>
					</div>
					
					<br/>
					
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>