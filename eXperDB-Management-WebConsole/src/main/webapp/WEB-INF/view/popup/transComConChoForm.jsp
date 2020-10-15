<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : transComConInfoForm.jsp
	* @Description : trans 기본설정 선택
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
	var cho_table_com_con = null;
	var cho_proc_gbn = "";

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_init_cho_com_con();
	
	  	$(function() {	
	  		//row 클릭시
	  		$('#cho_trans_com_con_List tbody').on( 'click', 'tr', function () {
				if ( $(this).hasClass('selected') ) {
	  	     	}else {	        	
	  	     		cho_table_com_con.$('tr.selected').removeClass('selected');
					$(this).addClass('selected');	            
				} 
	  		})
	
			//더블 클릭시
			$('#cho_trans_com_con_List tbody').on('dblclick','tr',function() {
				var datas = cho_table_com_con.row(this).data();

				var trans_com_id = datas.trans_com_id;		
				var trans_com_cng_nm = datas.trans_com_cng_nm;
	
				if (cho_proc_gbn == 'ins') {
					fn_trans_com_conAddCallback(trans_com_id,trans_com_cng_nm);
				} else {
					fn_trans_com_conModCallback(trans_com_id,trans_com_cng_nm);
				}

				$('#pop_layer_trans_com_con_cho').modal("hide");
				
			});			
	  	});
	});

	/* ********************************************************
	 * 추가 버튼 클릭
	 ******************************************************** */
	function fn_cho_trans_com_con_Add(){
		var datas = cho_table_com_con.rows('.selected').data();

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		}

		var trans_com_id = datas[0].trans_com_id;		
		var trans_com_cng_nm = datas[0].trans_com_cng_nm;

		fn_trans_com_conAddCallback(trans_com_id,trans_com_cng_nm);
		$('#pop_layer_trans_com_con_cho').modal("hide");
	}

	/* ********************************************************
	 * 추가 수정시 등록
	 ******************************************************** */
	function fn_cho_trans_com_con_Mod(){
		var datas = cho_table_com_con.rows('.selected').data();
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return false;
		} 

		var trans_com_id = datas[0].trans_com_id;		
		var trans_com_cng_nm = datas[0].trans_com_cng_nm;

		fn_trans_com_conModCallback(trans_com_id,trans_com_cng_nm);
		$('#pop_layer_trans_com_con_cho').modal("hide");
	}

	/* ********************************************************
	 * 테이블 초기화
	 ******************************************************** */
	function fn_init_cho_com_con() {
		cho_table_com_con = $('#cho_trans_com_con_List').DataTable({
			scrollY : "330px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			columns : [
 						{data : "rownum",  className : "dt-center", defaultContent : ""},
						{ data : "trans_com_cng_nm",  
			    			"render": function (data, type, full) {				
			    				  return '<span class="bold">' + full.trans_com_cng_nm + '</span>';
			    			},
							className : "dt-center", defaultContent : "",orderable : false},
 						{data : "plugin_name", className : "dt-center", defaultContent : ""},
 						{data : "heartbeat_interval_ms", className : "dt-right", defaultContent : ""},
 						{data : "heartbeat_action_query", className : "dt-left", defaultContent : ""},
 						{data : "max_batch_size", className : "dt-right", defaultContent : ""},
 						{data : "max_queue_size", className : "dt-right", defaultContent : ""},
 						{data : "offset_flush_interval_ms", className : "dt-right", defaultContent : ""}, 						
 						{data : "offset_flush_timeout_ms", className : "dt-right", defaultContent : ""},
 						{data : "transforms_yn", className : "dt-center", defaultContent : ""},
 						{data : "trans_com_id",  defaultContent : "", visible: false }
 			]
		});

		cho_table_com_con.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		cho_table_com_con.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
		cho_table_com_con.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		cho_table_com_con.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		cho_table_com_con.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		cho_table_com_con.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		cho_table_com_con.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		cho_table_com_con.tables().header().to$().find('th:eq(7)').css('min-width', '100px');  
		cho_table_com_con.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		cho_table_com_con.tables().header().to$().find('th:eq(9)').css('min-width', '100px');  
		cho_table_com_con.tables().header().to$().find('th:eq(10)').css('min-width', '0px');  

		$(window).trigger('resize');		
	}

	/* ********************************************************
	 * 조회
	 ******************************************************** */
	function fn_cho_trans_search_com_con(){
		$.ajax({
			url : "/selectTransComConPopList.do",
			data : {
				trans_com_cng_nm : nvlPrmSet($("#cho_trans_com_cng_nm").val(), '')
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
	  			if(result.length > 0){
	  				cho_table_com_con.clear().draw();
	  				cho_table_com_con.rows.add(result).draw();
	  			}else{
	  				cho_table_com_con.clear().draw();
	  			}
	  		}
		});
	}
</script>

<div class="modal fade" id="pop_layer_trans_com_con_cho" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" style="z-index:1060;">
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
								<input type="text" class="form-control" style="margin-right: -0.7rem;" id="cho_trans_com_cng_nm" name="cho_trans_com_cng_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code='data_transfer.default_setting_name'/>'  />
							</div>

							<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_cho_trans_search_com_con();" >
								<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
							</button>
						</div>
					</div>
					<br>
					
					<div class="card-body" style="border: 1px solid #adb5bd;">
						<p class="card-description"><i class="item-icon fa fa-dot-circle-o"></i><spring:message code="data_transfer.default_setting"/> LIST</p>
						<table id="cho_trans_com_con_List" class="table table-hover table-striped system-tlb-scroll" cellspacing="0" width="100%">
							<thead>
								<tr class="bg-info text-white">
									<th width="30"><spring:message code="common.no" /></th>
									<th width="150"><spring:message code="data_transfer.default_setting_name" /></th>
									<th width="120">plugin.name</th>
 									<th width="100">heartbeat.interval.ms</th>
 									<th width="200">heartbeat.action.query</th>
									<th width="100">max.batch.size</th>
									<th width="100">max.queue.size</th>
									<th width="100">offset.flush.interval.ms</th>
									<th width="100">offset.flush.timeout.ms</th>
									<th width="100">transform route <spring:message code="user_management.use_yn" /></th>
									<th width="0"></th>
								</tr>
							</thead>
						</table>
					</div>
					<br>
					<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 0 -20px;" >
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="cho_trans_com_con_cho_add" onclick="fn_cho_trans_com_con_Add()" value='<spring:message code="common.add" />' />
						<input class="btn btn-primary" width="200px"style="vertical-align:middle;display: none;" type="button" id="cho_trans_com_con_cho_mod" onclick="fn_cho_trans_com_con_Mod()" value='<spring:message code="common.add" />' />
						<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>