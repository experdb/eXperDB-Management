<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : transDbmsSetting.jsp
	* @Description : transDbmsSetting 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.04.07     최초 생성
	*
	* author 변승우 과장
	* since 2017.07.24
	*
	*/
%>
<script type="text/javascript">
	var trans_dbms_table = null;
	var trans_dbms_id_List = [];
	
	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//테이블 셋팅
		fn_trans_dbms_init();

		//화면 조회
		fn_dbms_select();
	});

	/* ********************************************************
	 * table 초기화 및 설정
	 ******************************************************** */
	function fn_trans_dbms_init(){
		trans_dbms_table = $('#transDbmsSettingList').DataTable({
			scrollY : "330px",
			deferRender : true,
			scrollX: true,
			searching : false,
			bSort: false,
			columns : [
 						{ data : "index", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}},
 						{data : "rownum",  className : "dt-center", defaultContent : ""},        
 						{data : "trans_sys_nm", className : "dt-center", defaultContent : ""},
 						{data : "dbms_dscd_nm", className : "dt-center", defaultContent : ""},
 						{data : "ipadr", className : "dt-center", defaultContent : ""},
 						{data : "dtb_nm", className : "dt-center", defaultContent : ""},
 						{data : "scm_nm", className : "dt-center", defaultContent : ""},
 						{data : "portno", className : "dt-center", defaultContent : ""},
 					    {data : "spr_usr_id", className : "dt-center", defaultContent : ""},
 						{data : "trans_sys_id",  defaultContent : "", visible: false }
 			],'select': {'style': 'multi'}
		});

		trans_dbms_table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		trans_dbms_table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
		trans_dbms_table.tables().header().to$().find('th:eq(2)').css('min-width', '170px');
		trans_dbms_table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		trans_dbms_table.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
		trans_dbms_table.tables().header().to$().find('th:eq(5)').css('min-width', '120px');
		trans_dbms_table.tables().header().to$().find('th:eq(6)').css('min-width', '150px');
		trans_dbms_table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');		
		trans_dbms_table.tables().header().to$().find('th:eq(8)').css('min-width', '138px');	
		trans_dbms_table.tables().header().to$().find('th:eq(9)').css('min-width', '0px');

		$(window).trigger('resize');
	}

	/* ********************************************************
	 * DBMS 조회
	 ******************************************************** */
	function fn_dbms_select(){
		$.ajax({
			url : "/selectTransDBMS.do",
			data : {
				trans_sys_nm : nvlPrmSet($("#trans_sys_nm").val(), ''),
				ipadr : nvlPrmSet($("#ipadr").val(), ''),
				dtb_nm : nvlPrmSet($("#dtb_nm").val(), '')
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
				trans_dbms_table.rows({selected: true}).deselect();
				trans_dbms_table.clear().draw();
				if (nvlPrmSet(result, '') != '') {
					trans_dbms_table.rows.add(result).draw();
				}
			}
		});
	}

	/* ********************************************************
	 * DBMS 등록 팝업페이지 호출
	 ******************************************************** */
	function fn_dbmsInsert(){
		$('#pop_layer_trans_dbms_reg').modal("hide");

 		$.ajax({ 
			url : "/popup/transTargetDbmsIns.do",
			data : {
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
				fn_transDbmsRegPopStart(result);
				
				$('#pop_layer_trans_dbms_reg').modal("show");
			}
		});
	}
	
	/* ********************************************************
	 * DBMS 사용여부 체크
	 ******************************************************** */
	function fn_dbmsChk(selGbn) {
		var datas = trans_dbms_table.rows('.selected').data();
		
		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		if (selGbn == "update") {
			if(datas.length > 1){
				showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
				return;
			}
		}
		
		trans_dbms_id_List = [];

		for (var i = 0; i < datas.length; i++) {
 			trans_dbms_id_List.push(datas[i].trans_sys_id);   
		}

		//사용중이거나 활성활 일경우
		$.ajax({
			url : "/selectTransDmbsIngChk.do",
			data : {
				trans_dbms_id_List : JSON.stringify(trans_dbms_id_List),
				exeGbn : selGbn
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
 				var msgResult = "";

				if (result != null) {
					if (result == "S") {
 						if (selGbn =="update") {
							fn_transDbmsUpd();
						} else {
							fn_dbms_del_confirm();
						}
					} else if (result == "O") {
						msgResult = fn_strBrReplcae('<spring:message code="data_transfer.msg22" />');
						showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
						return;
					} else {
						msgResult = fn_strBrReplcae('<spring:message code="data_transfer.msg21" />');
						showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
						return;
					}
				} else {
					msgResult = fn_strBrReplcae('<spring:message code="data_transfer.msg21" />');
					showSwalIcon(msgResult, '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
	
	/* ********************************************************
	 * trans dbms 삭제버튼 클릭시
	 ******************************************************** */
	function fn_dbms_del_confirm(){
		confile_title = '<spring:message code="data_transfer.btn_title01" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
		$('#con_multi_gbn', '#findConfirmMulti').val("trans_dbms_del");
		$('#confirm_multi_tlt').html(confile_title);
		$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		$('#pop_confirm_multi_md').modal("show");
	}
	
	/* ********************************************************
	 * DBMS 수정 팝업페이지 호출
	 ******************************************************** */
	function fn_transDbmsUpd(){
		
		var trans_sys_id = trans_dbms_table.row('.selected').data().trans_sys_id;
		
		$.ajax({
			url : "/popup/transTargetDbmsUpd.do",
			data : {
				trans_sys_id : trans_sys_id
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
				if (result.resultInfo != null) {
					fn_tansDbmsModPopStart(result);
					
					$('#pop_layer_trans_dbms_reg_re').modal("show");
				} else {
					showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'error');
					$('#pop_layer_trans_dbms_reg_re').modal("hide");
					return;
				}
			}
		});
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "trans_dbms_del") {
			fn_dbms_delete_loc();
		}
	}

	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_dbms_delete_loc(){
		$.ajax({
			url : "/deleteTransDBMS.do",
		  	data : {
				trans_dbms_id_List : JSON.stringify(trans_dbms_id_List)
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
				if(result == true){
					showSwalIcon('<spring:message code="message.msg60" />', '<spring:message code="common.close" />', '', 'success');
					fn_dbms_select();
				}else{
					msgVale = "<spring:message code='data_transfer.btn_title01' />";
					showSwalIcon('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
</script>

<%@include file="../popup/transDbmsRegForm.jsp"%>
<%@include file="../popup/transDbmsRegReForm.jsp"%>
<%@include file="./../popup/confirmMultiForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
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
									<div class="col-5"  style="padding-top:3px;">
										<h6 class="mb-0">
											<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
												<i class="fa fa-database"></i>
												<span class="menu-title"><spring:message code="data_transfer.btn_title01"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							<a class="nav-link_title" href="/property.do?db_svr_id=${db_svr_id}" style="padding-right: 0rem;">${db_svr_nm}</a>
					 						</li>
						 					<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.data_transfer" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="data_transfer.btn_title01"/></li>
										</ol>
									</div>
								</div>
							</div>
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.data_transfer_target_dbms_management_01"/></p>
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
						<div class="card-body" style="margin:-10px -10px -15px -10px;">
							<form class="form-inline row" onsubmit="return false">
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="trans_sys_nm" name="trans_sys_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="migration.system_name" />'/>		
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="ipadr" name="ipadr" onblur="this.value=this.value.trim()" placeholder='<spring:message code="history_management.ip" />'/>		
								</div>
									
								<div class="input-group mb-2 mr-sm-2 col-sm-2_6">
									<input type="text" class="form-control" style="margin-right: -0.7rem;" id="dtb_nm" name="dtb_nm" onblur="this.value=this.value.trim()" placeholder='<spring:message code="common.database" />'/>		
								</div>
							
								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_dbms_select();" >
									<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-12 div-form-margin-table stretch-card">
			<div class="card">
				<div class="card-body">
					<div class="row" style="margin-top:-20px;">
						<div class="col-12">
							<div class="template-demo">	
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsDelete" onClick="fn_dbmsChk('delete');" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsModify" onClick="fn_dbmsChk('update');" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDmbsInsert" onClick="fn_dbmsInsert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
								</button>
							</div>
						</div>
					</div>

					<div class="card my-sm-2" style="margin-botom:-10px;">
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

		 							<table id="transDbmsSettingList" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
	 										<tr class="bg-info text-white">
												<th width="10"></th>
												<th width="40" height="0"><spring:message code="common.no" /></th>
												<th width="170"><spring:message code="migration.system_name"/></th>
												<th width="100">DBMS<spring:message code="common.division" /></th>
												<th width="150"><spring:message code="data_transfer.ip" /></th>
												<th width="100">Database</th>
												<th width="150">Schema</th>
												<th width="100"><spring:message code="data_transfer.port" /></th>
												<th width="130"><spring:message code="dbms_information.account" /></th>
												<th width="0"><spring:message code="common.modify_datetime" /></th>
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