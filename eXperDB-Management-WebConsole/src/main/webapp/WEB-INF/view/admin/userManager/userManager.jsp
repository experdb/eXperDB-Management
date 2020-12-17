<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../cmmn/cs2.jsp"%>
<%
	/**
	* @Class Name : userManager.jsp
	* @Description : UserManager 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>

<script type="text/javascript">
	var table = null; 
	var confirm_title = "";
	var del_rowList = [];

	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		//권한 버튼설정
		fn_buttonAut();
		
		//테이블 설정
		fn_init();
		
		//조회
		fn_select();
	});

	/* ********************************************************
	 * 권한에 따른 버튼설정
	 ******************************************************** */
	 function fn_buttonAut(){
		 if("${wrt_aut_yn}" == "Y"){
			$("#btnInsert").show();
			$("#btnUpdate").show();
			$("#btnDelete").show();
		 } else {
			$("#btnInsert").hide();
			$("#btnUpdate").hide();
			$("#btnDelete").hide();
		 }
		 
		 if("${read_aut_yn}" == "Y"){
			$("#btnSelect").show();
		 } else {
			$("#btnSelect").hide();
		 }
	}

	/* ********************************************************
	 * 테이블 설정
	 ******************************************************** */
	function fn_init() {
		table = $('#userListTable').DataTable({
			scrollY : "330px",
			scrollX: true,	
			bDestroy: true,
			paging : true,
			processing : true,
			searching : false,	
			deferRender : true,
			bSort: false,
			columns : [
						{data : "rownum", defaultContent : "", targets : 0, orderable : false, 
							 checkboxes : {'selectRow' : true}
						}, 
						{ data : "idx", className : "dt-center", defaultContent : ""}, 
						{ data : "usr_id", defaultContent : ""}, 
						{ data : "bln_nm", defaultContent : ""}, 
						{ data : "usr_nm", defaultContent : ""}, 
						{ data : "cpn", defaultContent : ""}, 
						{
							data : "use_yn",
							render : function(data, type, full, meta) {
								var html = "";
								if (data == "Y") {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-spin fa-spinner mr-2'></i>";
									html += "<spring:message code='dbms_information.use' />";
									html += "</div>";
								} else {
									html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-times-circle mr-2'></i>";
									html += "<spring:message code='dbms_information.unuse' />";
									html += "</div>";
								}
								return html;
							},
							defaultContent : ""
						},
						{
							data : "encp_use_yn",
							render : function(data, type, full, meta) {
								var html = "";
								if (data == "Y") {
									html += "<div class='badge badge-pill badge-info' style='color: #fff;margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-spin fa-spinner mr-2'></i>";
									html += "<spring:message code='dbms_information.use' />";
									html += "</div>";
								} else {
									html += "<div class='badge badge-pill badge-danger' style='margin-top:-5px;margin-bottom:-5px;'>";
									html += "<i class='fa fa-times-circle mr-2'></i>";
									html += "<spring:message code='dbms_information.unuse' />";
									html += "</div>";
								}
								return html;
							},
							defaultContent : ""
						},
						{ data : "usr_expr_dt", defaultContent : ""}
						],'select': {'style': 'multi'}
		});

		table.tables().header().to$().find('th:eq(0)').css('width', '40px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		
		$(window).trigger('resize');
		
		//더블 클릭시
		if("${wrt_aut_yn}" == "Y"){
			$('#userListTable tbody').on('dblclick','tr',function() {
/* 				var data = table.row(this).data();
				var usr_id = data.usr_id;				
				var popUrl = "/popup/userManagerRegReForm.do?usr_id=" + encodeURI(usr_id); // 서버 url 팝업경로
				var width = 1000;
				var height = 570;
				var left = (window.screen.width / 2) - (width / 2);
				var top = (window.screen.height /2) - (height / 2);
				var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				window.open(popUrl,"",popOption); */
			});
		}
	}

	/* ********************************************************
	 * 조회 버튼 클릭
	 ******************************************************** */
	function fn_select(){
		$.ajax({
			url : "/selectUserManager.do",
			data : {
				type : $("#sch_type").val(),
				search : "%" + $("#sch_search").val() + "%",
				use_yn : $("#sch_use_yn").val(),
				encp_use_yn : $("#sch_encp_use_yn").val()
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
				
				if (result != null) {
					table.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * 등록버튼 클릭시
	 ******************************************************** */
	function fn_insert(){
		var selectDbList = "";
		$.ajax({
			url : "/popup/userManagerRegForm.do",
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
				//초기화
				fn_insert_chogihwa("reg");

				if (result != null) {
					//update setting
					fn_update_setting("reg", result);
				}
				
				$('#pop_layer_user_reg').modal("show");
			}
		});
	}

	/* ********************************************************
	 * 수정 팝업
	 ******************************************************** */
	function fn_update(){
		var rowCnt = table.rows('.selected').data().length;

		if (rowCnt <= 0) {
			showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}else if(rowCnt > 1){
			showSwalIcon('<spring:message code="message.msg04" />', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		var usr_id = table.row('.selected').data().usr_id;
		$('#mod_usr_id_param', '#findList').val(usr_id);
		
 		$.ajax({
			url : "/popup/userManagerRegReForm.do",
			data : {
				usr_id : encodeURI(usr_id)
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
				fn_insert_chogihwa("mod");
				
				if (result != null) {
					//update setting
					fn_update_setting("mod", result);
				}

				$('#pop_layer_user_mod').modal("show");
			}
		});	
	}
	
	/* ********************************************************
	 * 등록 팝업 초기화
	 ******************************************************** */
	function fn_insert_chogihwa(gbn) {
		if (gbn == "reg") {
			
			$("#ins_usr_id", "#insUserForm").val(""); //아이디
			$("#ins_usr_nm", "#insUserForm").val(""); //이름

			$("#ins_pwdCheck", "#insUserForm").val(""); //패스워드체크
			$("#ins_pwd", "#insUserForm").val(""); //패스워드
			
			$("#pwdCheck_alert-danger", "#insUserForm").hide(); //패스워드 체크
			$("#idCheck_alert-danger", "#insUserForm").hide(); //id 체크
			$("#ins_pwd_alert-danger", "#insUserForm").html("");
			$("#ins_pwd_alert-danger", "#insUserForm").hide();
			$("#ins_pwd_alert-light", "#insUserForm").html("");
			$("#ins_pwd_alert-light", "#insUserForm").hide();
			
			$("#ins_bln_nm", "#insUserForm").val(""); //소속
			$("#ins_dept_nm", "#insUserForm").val(""); //부서
			$("#ins_pst_nm", "#insUserForm").val(""); //직급
			$("#ins_rsp_bsn_nm", "#insUserForm").val(""); //담당업무
			$("#ins_idCheck_set", "#insUserForm").val(""); //id 체크
			$("#ins_cpn", "#insUserForm").val(""); //휴대폰번호
			
			$("#ins_use_yn", "#insUserForm").val("Y"); //사용여부
			$("input:checkbox[id='ins_use_yn_chk']").prop("checked", true); 

			$("#ins_usr_expr_dt", "#insUserForm").val(""); //사용만료일

			$("#ins_idCheck", "#insUserForm").val("0");
			$("#ins_passCheck_hid", "#insUserForm").val("0");
			
			$("#ins_save_submit", "#insUserForm").removeAttr("disabled");
			$("#ins_save_submit", "#insUserForm").removeAttr("readonly");
		} else {
			$("#mod_usr_id", "#modUserForm").val(""); //아이디
			$("#mod_usr_nm", "#modUserForm").val(""); //이름
			
			$("#mod_pwdCheck", "#modUserForm").val(""); //패스워드체크
			$("#mod_pwd", "#modUserForm").val(""); //패스워드
			
			$("#mod_pwdCheck_alert-danger", "#modUserForm").hide(); //패스워드 체크
			$("#mod_pwd_alert-danger", "#modUserForm").html("");
			$("#mod_pwd_alert-danger", "#modUserForm").hide();
			$("#mod_pwd_alert-light", "#modUserForm").html("");
			$("#mod_pwd_alert-light", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(""); //소속
			$("#mod_dept_nm", "#modUserForm").val(""); //부서
			$("#mod_pst_nm", "#modUserForm").val(""); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(""); //담당업무
			$("#mod_cpn", "#modUserForm").val(""); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val("Y"); //사용여부
			$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			
			$("#mod_usr_expr_dt", "#modUserForm").val(""); //사용만료일
			
			$("#mod_encp_use_yn", "#modUserForm").val("Y"); //암호화사용여부
			$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			
			$("#mod_save_submit", "#modUserForm").removeAttr("disabled");
			$("#mod_save_submit", "#modUserForm").removeAttr("readonly");

			$("#mod_passCheck_cho", "#modUserForm").val("");
			$("#mod_passCheck_hid", "#modUserForm").val("0");
		}
	}
	
	/* ********************************************************
	 * 수정 팝업셋팅
	 ******************************************************** */
	function fn_update_setting(gbn, result) {
		if (gbn == "mod") {
			$("#mod_usr_id", "#modUserForm").val(nvlPrmSet(result.get_usr_id, "")); //아이디
			$("#mod_usr_nm", "#modUserForm").val(nvlPrmSet(result.get_usr_nm, "")); //이름

			$("#mod_pwd", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			$("#mod_pwdCheck", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			$("#mod_passCheck_cho", "#modUserForm").val(nvlPrmSet(result.pwd, ""));
			
			//password 안전성 확인
			$("#mod_pwd_chk_msg_div", "#modUserForm").show();
			$("#mod_pwd_chk_div", "#modUserForm").hide();
			
			$("#mod_bln_nm", "#modUserForm").val(nvlPrmSet(result.bln_nm, "")); //소속
			$("#mod_dept_nm", "#modUserForm").val(nvlPrmSet(result.dept_nm, "")); //부서
			$("#mod_pst_nm", "#modUserForm").val(nvlPrmSet(result.pst_nm, "")); //직급
			$("#mod_rsp_bsn_nm", "#modUserForm").val(nvlPrmSet(result.rsp_bsn_nm, "")); //담당업무
			$("#mod_cpn", "#modUserForm").val(nvlPrmSet(result.cpn, "")); //휴대폰번호
			
			$("#mod_use_yn", "#modUserForm").val(nvlPrmSet(result.use_yn, "")); //사용여부
			if (nvlPrmSet(result.use_yn, "") == "Y") {
				$("input:checkbox[id='mod_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='mod_use_yn_chk']").prop("checked", false); 
			}
			
			$("#mod_usr_expr_dt", "#modUserForm").val(nvlPrmSet(result.usr_expr_dt, "")); //사용만료일

			//datapicker 설정
			fn_modDateUpdateSetting(nvlPrmSet(result.usr_expr_dt, ""));
			
			$("#mod_encp_use_yn", "#modUserForm").val(nvlPrmSet(result.encp_use_yn, "")); //암호화사용여부

			if (nvlPrmSet(result.encp_use_yn, "") == "Y") {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("checked", false); 
			}

			//암호화 여부가 n일때는 check box disabled
			if (nvlPrmSet(result.encp_yn, "") == "Y") {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("disabled", false); 
				$("#mod_encp_use_yn_msg", "#modUserForm").html('');
			} else {
				$("input:checkbox[id='mod_encp_use_yn_chk']").prop("disabled", true); 
				$("#mod_encp_use_yn_msg", "#modUserForm").html('<spring:message code="user_management.msg15" />');
			}

			$("#mod_passCheck_hid", "#modUserForm").val("1");
		} else {
			//암호화 여부가 n일때는 check box disabled
			if (nvlPrmSet(result.encp_yn, "") == "Y") {
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("disabled", false);
				$("#ins_encp_use_yn_msg", "#insUserForm").html('');
				
				$("#ins_encp_use_yn", "#insUserForm").val("Y"); //암호화사용여부
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("checked", true); 
			} else {
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("disabled", true); 
				$("#ins_encp_use_yn_msg", "#insUserForm").html('<spring:message code="user_management.msg15" />');

				$("#ins_encp_use_yn", "#insUserForm").val("N"); //암호화사용여부
				$("input:checkbox[id='ins_encp_use_yn_chk']").prop("checked", false); 
				
			}	
		}

	}

	/* ********************************************************
	 * confirm modal open
	 ******************************************************** */
	function fn_multiConfirmModal(gbn) {
		
		if (gbn == "ins") {
			confirm_title = '<spring:message code="menu.user_management" />' + " " + '<spring:message code="common.registory" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg143" />');
		} else if (gbn == "ins_menu") {
			confirm_title = '<spring:message code="menu.user_management" />' + " " + '<spring:message code="user_management.msg14" />';
			$('#confirm_multi_msg').html(fn_strBrReplcae('<spring:message code="user_management.msg13" />'));
		} else if (gbn == "del") {
			confirm_title = '<spring:message code="menu.user_management" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
		} else 	if (gbn == "mod") {
			confirm_title = '<spring:message code="menu.user_management" />' + " " + '<spring:message code="common.registory" />';
			$('#confirm_multi_msg').html('<spring:message code="message.msg147" />');
		}

		if (gbn == "ins_menu") {
			$('#con_only_gbn', '#findConfirmOnly').val(gbn);
			$('#confirm_tlt').html(confirm_title);

			$('#confirm_msg').html('<spring:message code="user_management.msg13" />');
			$('#pop_confirm_md').modal("show");
		} else {
			$('#con_multi_gbn', '#findConfirmMulti').val(gbn);
			$('#confirm_multi_tlt').html(confirm_title);
 			$('#pop_confirm_multi_md').modal("show");
		}
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
 	function fnc_confirmRst(){
		fn_insPop_menu();
	}

	/* ********************************************************
	 * confirm result
	 ******************************************************** */
	function fnc_confirmMultiRst(gbn){
		if (gbn == "del") {
			fn_delete();
		} else if (gbn == "ins") {
			fn_insPop_insert();
		} else if (gbn == "ins_menu") {
			fn_insPop_menu();
		} else if (gbn == "mod") {
			fn_modPop_update();
		}
	}
	
	/* ********************************************************
	 * confirm cancel result
	 ******************************************************** */
	function fnc_confirmCancelRst(gbn){
		if (gbn == "ins_menu") {
			//$('#pop_layer_user_reg').modal('hide');

			//조회
			fn_select();
		}
	}

	/* ********************************************************
	 * 삭제버튼 클릭시
	 ******************************************************** */
	function fn_del_confirm(){
		var usr_id = "${sessionScope.session.usr_id}";
		var iAdminCnt = 0;
		var iMyId = 0;
		
		var datas = table.rows('.selected').data();

		if (datas.length <= 0) {
			showSwalIcon('<spring:message code="message.msg04"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		del_rowList = [];

		for (var i = 0; i < datas.length; i++) {
			if(datas[i].usr_id=="admin"){
				iAdminCnt = iAdminCnt + 1;
			}else if(datas[i].usr_id==usr_id){
				iMyId = iMyId + 1;
			}else{
				del_rowList += datas[i].usr_id + ',';	
			}
		}

		//admin 데이터 존재 경우
		if (iAdminCnt > 0) {
			showSwalIcon('<spring:message code="message.msg10"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}

		//본인 아이디 존재 경우
		if (iMyId > 0) {
			showSwalIcon('<spring:message code="message.msg11"/>', '<spring:message code="common.close" />', '', 'error');
			return;
		}
		
		fn_multiConfirmModal("del");
	}
	
	/* ********************************************************
	 * 삭제 로직 처리
	 ******************************************************** */
	function fn_delete(){
		$.ajax({
			url : "/deleteUserManager.do",
		  	data : {
		  		usr_id:del_rowList
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
			success : function(data) {
				if(data.resultCode == "0000000000"){
					showSwalIcon('<spring:message code="message.msg37" />', '<spring:message code="common.close" />', '', 'success');
					fn_select();
				}else if(data.resultCode == "8000000002"){
					showSwalIcon('<spring:message code="message.msg05" />', '<spring:message code="common.close" />', '', 'error');
					return;
				}else if(data.resultCode == "8000000003"){
					showSwalIcon(data.resultMessage, '<spring:message code="common.close" />', '', 'error');
					location.href="/securityKeySet.do";
				}else{
					showSwalIcon(data.resultMessage +"("+data.resultCode+")", '<spring:message code="common.close" />', '', 'error');
					return;
				}
			}
		});
	}
</script>

<%@include file="./../../popup/userManagerRegForm.jsp"%>
<%@include file="./../../popup/userManagerRegReForm.jsp"%>
<%@include file="./../../popup/confirmMultiForm.jsp"%>
<%@include file="./../../popup/confirmForm.jsp"%>

<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
	<input type="hidden" name="mod_usr_id_param" id="mod_usr_id_param" value=""/>
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
												<i class="ti-desktop menu-icon"></i>
												<span class="menu-title"><spring:message code="menu.user_management"/></span>
												<i class="menu-arrow_user" id="titleText" ></i>
											</a>
										</h6>
									</div>
									<div class="col-7">
					 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">
					 							ADMIN
					 						</li>
					 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.user_management" /></li>
											<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page"><spring:message code="menu.user_management"/></li>
										</ol>
									</div>
								</div>
							</div>
							
							<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<p class="mb-0"><spring:message code="help.user_management_01"/></p>
											<p class="mb-0"><spring:message code="help.user_management_02"/></p>
											<p class="mb-0"><spring:message code="help.user_management_03"/></p>
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
							<form class="form-inline row">
								<div class="input-group mb-2 mr-sm-2 col-sm-1_5">
									<select class="form-control" style="margin-right: -1.8rem;" name="sch_type" id="sch_type">
										<option value="usr_nm"><spring:message code="user_management.user_name" /></option>
										<option value="usr_id"><spring:message code="user_management.id" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-3">
									<input hidden="hidden" />
									<input type="text" class="form-control" style="margin-right: -0.7rem;" maxlength="15" id="sch_search" name="sch_search" onblur="this.value=this.value.trim()" />
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" style="margin-right: -0.7rem;" name="sch_use_yn" id="sch_use_yn">
										<option value="%"><spring:message code="user_management.use_yn" />&nbsp;<spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /></option>
									</select>
								</div>

								<div class="input-group mb-2 mr-sm-2 col-sm-2">
									<select class="form-control" name="sch_encp_use_yn" id="sch_encp_use_yn">
										<option value="%">Encrypt&nbsp;<spring:message code="user_management.use_yn" />&nbsp;<spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /></option>
									</select>
								</div>

								<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" id="btnSearch" onClick="fn_select();" >
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
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnDelete" onClick="fn_del_confirm();" >
									<i class="ti-trash btn-icon-prepend "></i><spring:message code="common.delete" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnUpdate" onClick="fn_update();" data-toggle="modal">
									<i class="ti-pencil-alt btn-icon-prepend "></i><spring:message code="common.modify" />
								</button>
								<button type="button" class="btn btn-outline-primary btn-icon-text float-right" id="btnInsert" onClick="fn_insert();" data-toggle="modal">
									<i class="ti-pencil btn-icon-prepend "></i><spring:message code="common.registory" />
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

	 								<table id="userListTable" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
										<thead>
 											<tr class="bg-info text-white">
												<th width="40"></th>
												<th width="40"><spring:message code="common.no" /></th>
												<th width="100"><spring:message code="user_management.id" /></th>
												<th width="100"><spring:message code="user_management.company" /></th>
												<th width="100"><spring:message code="user_management.user_name" /></th>
												<th width="100"><spring:message code="user_management.contact" /></th>
												<th width="100"><spring:message code="user_management.use_yn" /></th>
												<th width="100"><spring:message code="encrypt_log_decode.Encryption"/> <spring:message code="user_management.use_yn" /></th>
												<th width="100"><spring:message code="user_management.expiration_date" /></th>
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