<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	var trans_kafka_con_pop_table = null;
	
	$(window.document).ready(function() {
		fn_trans_kafka_con_pop_init();
		
	  	$(function() {	
	  		//row 클릭시
	  		$('#transKfkConPopList tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
	  	     	}else {	        	
	  	     		trans_kafka_con_pop_table.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');	            
				} 
	  		})		
	  	});
	});
	

	/* ********************************************************
	 * 테이블 셋팅
	 ******************************************************** */
	function fn_trans_kafka_con_pop_init() {
		/* ********************************************************
		 * 리스트
		 ******************************************************** */
		trans_kafka_con_pop_table = $('#transKfkConPopList').DataTable({
			scrollY : "260px",
			searching : false,
			deferRender : true,
			scrollX: true,
			bSort: false,
			paging: false,
			columns : [
				{data : "rownum",  className : "dt-center", defaultContent : ""},
				{data : "kc_nm", className : "dt-left", defaultContent : ""},
				{data : "kc_ip", className : "dt-center", defaultContent : ""},
				{data : "kc_port", className : "dt-center", defaultContent : ""},

				{data : "exe_status", 
					render: function (data, type, full){
						var html = "";
						if(full.exe_status == "TC001501"){
							html += "<div class='badge badge-pill badge-success'>";
							html += "	<i class='fa fa-spin fa-spinner mr-2'></i>";
							html += "	<spring:message code='data_transfer.connecting' />";
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
				
				{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
				{data : "kc_id",  defaultContent : "", visible: false }
			]
		});
		 

		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(2)').css('min-width', '123px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(4)').css('min-width', '130px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		trans_kafka_con_pop_table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');

		$(window).trigger('resize');
	}


	/* ********************************************************
	 * kafka connect 조회
	 ******************************************************** */
	function fn_trans_kafka_con_pop_search(){

		$.ajax({
			url : "/selectTransKafkaConList.do",
			data : {
				kc_nm : nvlPrmSet($("#pop_trans_kafka_con_nm").val(), '')
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
			success : function(result) {
				trans_kafka_con_pop_table.rows({selected: true}).deselect();
				trans_kafka_con_pop_table.clear().draw();
				if (nvlPrmSet(result, '') != '') {
					trans_kafka_con_pop_table.rows.add(result).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * 팝업시작
	 ******************************************************** */
	function fn_transKafkaConPopStart() {
		//조회
		fn_trans_kafka_con_pop_search();

	  	$(function() {	
			$('#transKfkConPopList tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
				}else {
					tans_dbms_pop_table.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');
				}
			})
		});
	}
</script>

<div class="modal fade" id="pop_layer_trans_con_list" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 60px 300px;">
		<div class="modal-content" style="width:1000px;">
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					<spring:message code="data_transfer.btn_title02"/>
				</h4>
		
				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row" style="margin-top:-10px;margin-bottom:-20px;">
							<div class="input-group mb-2 mr-sm-2 col-sm-4">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="pop_trans_kafka_con_nm" name="pop_trans_kafka_con_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="etc.etc04" />'/>		
							</div>
							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_trans_kafka_con_pop_search();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					
					<br />

					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i> Kafka Connect LIST</p>
						
						<table id="transKfkConPopList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="200"><spring:message code="etc.etc04"/></th>
 									<th width="123"><spring:message code="data_transfer.ip" /></th>
									<th width="100"><spring:message code="data_transfer.port" /></th>
									<th width="130"><spring:message code="data_transfer.connection_status" /></th>
									<th width="100"><spring:message code="common.modify_datetime" /></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
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