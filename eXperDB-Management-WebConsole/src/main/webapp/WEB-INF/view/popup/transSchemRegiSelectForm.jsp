<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transSchemaRegiSelectForm.jsp
	* @Description : trans Schema Registry 선택창
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2021.11.09     최초 생성
	*
	* author 
	* since 2021.11.09
	*
	*/
%>    

<script>
   var cho_schem_table = null;
   var cho_schema_gbn = "";

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_init_schem_regi();
	
	  	$(function() {	
	  		//row 클릭시
	  		$('#sel_trans_schem_List tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
	  	     	}else {	        	
	  	     		cho_schem_table.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');	            
				} 
	  		})
	
			//더블 클릭시
			$('#sel_trans_schem_List tbody').on('dblclick','tr',function() {
				var datas = cho_schem_table.row(this).data();

				var regi_id = datas.regi_id;		
				var regi_nm = datas.regi_nm;
				var regi_ip = datas.regi_ip;		
				var regi_port = datas.regi_port;
				
				if (cho_schema_gbn == 'ins') {
					fn_trans_schema_AddCallback(regi_id,regi_nm, regi_ip, regi_port);
				} else {
					fn_trans_com_conModCallback(regi_id,regi_nm, regi_ip, regi_port);
				} 
				
				$('#pop_layer_trans_sel_schem').modal("hide");
				
			});			
	  	});
	});

	/* ********************************************************
	 * 테이블 초기화
	 ******************************************************** */
	function fn_init_schem_regi() {
		cho_schem_table = $('#sel_trans_schem_List').DataTable({
			scrollY : "330px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			columns : [
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
 						{data : "regi_nm", className : "dt-left", defaultContent : "",
 							"render": function (data, type, full) {				
		    				  return '<span class="bold">' + full.regi_nm + '</span>';
		    				}
 						},
 						{data : "regi_ip", className : "dt-center", defaultContent : ""},
 						{data : "regi_port", className : "dt-center", defaultContent : ""},
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
 						{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false},
 						{data : "regi_id",  defaultContent : "", visible: false }
 			]
		});

		cho_schem_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		cho_schem_table.tables().header().to$().find('th:eq(1)').css('min-width', '10px');
		cho_schem_table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		cho_schem_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		cho_schem_table.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
		cho_schem_table.tables().header().to$().find('th:eq(5)').css('min-width', '0px');
		cho_schem_table.tables().header().to$().find('th:eq(6)').css('min-width', '0px');
	}
</script>

<div class="modal fade" id="pop_layer_trans_sel_schem" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 50px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					<spring:message code="data_transfer.default_setting"/> <spring:message code="common.choice"/>
				</h4>

				<div class="card" style="margin-top:10px;border:0px;">
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<div class="form-inline row">
							<div class="input-group mb-2 mr-sm-2 col-sm-4">
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="cho_regi_nm" name="cho_regi_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code='data_transfer.default_setting_name'/>'  />
							</div>

							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_cho_trans_search_schema();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i><spring:message code="data_transfer.default_setting"/> LIST</p>
						<table id="sel_trans_schem_List" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
							<thead>
								<tr class="bg-info text-white">
									<th width="20" height="0"><spring:message code="common.no" /></th>
									<th width="150"><spring:message code="eXperDB_CDC.schema_registr_nm" /></th>
 									<th width="100"><spring:message code="data_transfer.ip" /></th>
									<th width="50"><spring:message code="data_transfer.port" /></th>
									<th width="80"><spring:message code="data_transfer.connection_status" /></th>
									<th width="0"><spring:message code="common.modify_datetime" /></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="cho_trans_sel_schem_add" onclick="fn_sel_trans_schem_Add()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="cho_trans_sel_schem_mod" onclick="fn_sel_trans_schem_Mod()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>