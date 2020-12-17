<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : dataRegForm.jsp
	* @Description : 데이터 이관 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.09.18     최초 생성
	*
	* author kimjy
	* since 2019.09.18
	*
	*/
%>
<script type="text/javascript">
var db2pg_trsf_wrk_nmChk ="fail";

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck_trsf(){
	if($("#db2pg_trsf_wrk_nm").val() == ""){
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_trsf_wrk_nm").focus();
		return false;
	}else if(db2pg_trsf_wrk_nmChk =="fail"){
		showSwalIcon('<spring:message code="backup_management.work_overlap_check" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if($("#db2pg_trsf_wrk_exp").val() == ""){
		showSwalIcon('<spring:message code="message.msg108" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_trsf_wrk_exp").focus();
		return false;
	}else if($("#db2pg_source_system_id").val() == ""){
		showSwalIcon('<spring:message code="migration.msg07" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_source_system_id").focus();
		return false;
	}else if($("#db2pg_trg_sys_id").val() == ""){
		showSwalIcon('<spring:message code="migration.msg08" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_trg_sys_id").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck_trsf2(){
	if($("#db2pg_trsf_wrk_exp").val() == ""){
		showSwalIcon('<spring:message code="message.msg108" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_trsf_wrk_exp").focus();
		return false;
	}else if($("#db2pg_source_system_id").val() == ""){
		showSwalIcon('<spring:message code="migration.msg07" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_source_system_id").focus();
		return false;
	}else if($("#db2pg_trg_sys_id").val() == ""){
		showSwalIcon('<spring:message code="migration.msg08" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_trg_sys_id").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * 사용자쿼리 체크박스 제어
 ******************************************************** */
function fn_checkBox(result){
	if(result == 'true'){
		$("#db2pg_usr_qry").removeAttr("readonly");
	}else{
		$('#db2pg_usr_qry').val('');
		$('#db2pg_usr_qry').attr('readonly', true);
	}
}

/* ********************************************************
 * WORK NM 중복 체크
 ******************************************************** */
function fn_check_ddl_reg() {
	var db2pg_trsf_wrk_nm = document.getElementById("db2pg_trsf_wrk_nm");
	if (db2pg_trsf_wrk_nm.value == "") {
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		document.getElementById('db2pg_trsf_wrk_nm').focus();
		return;
	}
	
	if(fnCheckNotKorean(db2pg_trsf_wrk_nm.value)){
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $("#db2pg_trsf_wrk_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					showSwalIcon('<spring:message code="backup_management.reg_possible_work_nm"/>', '<spring:message code="common.close" />', '', 'success');
					document.getElementById("db2pg_trsf_wrk_nm").focus();
					db2pg_trsf_wrk_nmChk = "success";
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					document.getElementById("db2pg_trsf_wrk_nm").focus();
				}
			},
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
			}
		});
	}
}



/* 한글입력 체크 */
function fnCheckNotKorean(koreanStr){
    for(var i=0;i<koreanStr.length;i++){
        var koreanChar = koreanStr.charCodeAt(i);
        if( !( 0xAC00 <= koreanChar && koreanChar <= 0xD7A3 ) && !( 0x3131 <= koreanChar && koreanChar <= 0x318E ) ) {
        }else{
        	showSwalIcon('한글은 사용할수 없습니다.', '<spring:message code="common.close" />', '', 'error');
            return false;
        }
    }
    return true;
}



/* ********************************************************
 * 등록 버튼 클릭시
 ******************************************************** */
function fn_insert_trsf_work(){
	if(valCheck_trsf()){
		
		if($("#src_table_total_cnt_trsf").val() == ""){
			var src_table_total_cnt_trsf = 0
		}else{
			var src_table_total_cnt_trsf = $("#src_table_total_cnt_trsf").val()
		}

		//등록하기 전 work명 한번 더 중복 체크
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $("#db2pg_trsf_wrk_nm").val()
			},
			success : function(result) {
				if (result == "true") {
						$.ajax({
							url : "/db2pg/insertDataWork.do",
						  	data : {  
						  		db2pg_trsf_wrk_nm : $("#db2pg_trsf_wrk_nm").val().trim(),
						  		db2pg_trsf_wrk_exp : $("#db2pg_trsf_wrk_exp").val(),
						  		db2pg_src_sys_id : $("#db2pg_sys_id_trsf").val(),
						  		db2pg_trg_sys_id : $("#db2pg_trg_sys_id").val(),
						  		exrt_dat_cnt : $("#exrt_dat_cnt").val(),
						  		src_include_tables : $("#src_include_table_nm_trsf").val(),
						  		src_exclude_tables : $("#src_exclude_table_nm_trsf").val(),
						  		exrt_dat_ftch_sz : $("#exrt_dat_ftch_sz").val(),
						  		dat_ftch_bff_sz : $("#dat_ftch_bff_sz").val(),
						  		exrt_prl_prcs_ecnt : $("#exrt_prl_prcs_ecnt").val(),
						  		lob_dat_bff_sz : $("#lob_dat_bff_sz").val(),
						  		tb_rbl_tf : $("#tb_rbl_tf").val(),
						  		ins_opt_cd : $("#ins_opt_cd").val(),
						  		cnst_cnd_exrt_tf : $("#cnst_cnd_exrt_tf").val(),
						  		src_cnd_qry : $("#src_cnd_qry").val(),
						  		usr_qry_use_tf : $('input[name="usr_qry_use_tf"]:checked').val(),
						  		db2pg_usr_qry : $("#db2pg_usr_qry").val(),
						  		src_table_total_cnt : src_table_total_cnt_trsf,
						  		db2pg_uchr_lchr_val : $("#dat_db2pg_uchr_lchr_val").val(),
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
								if(result.resultCode == "0000000000"){
//									showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success', "reload");
									showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
									$('#pop_layer_data_reg').modal("hide");
									selectTab("dataWork");
								}else{
									showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
								}		
							}
						});
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					document.getElementById("db2pg_trsf_wrk_nm").focus();
				}
			},
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
			}
		});
	}
}


/* ********************************************************
 * 수정 버튼 클릭시
 ******************************************************** */
function fn_update_trsf_work(){
	if(valCheck_trsf2()){
		if($("#src_table_total_cnt_trsf").val() == ""){
			var src_table_total_cnt_trsf = 0
		}else{
			var src_table_total_cnt_trsf = $("#src_table_total_cnt_trsf").val()
		}
		
		$.ajax({
			url : "/db2pg/updateDataWork.do",
		  	data : {
		  		db2pg_trsf_wrk_id : $("#db2pg_trsf_wrk_id").val(),
		  		db2pg_trsf_wrk_nm : $("#db2pg_trsf_wrk_nm").val().trim(),
		  		db2pg_trsf_wrk_exp : $("#db2pg_trsf_wrk_exp").val(),
		  		db2pg_src_sys_id : $("#db2pg_sys_id_trsf").val(),
		  		db2pg_trg_sys_id : $("#db2pg_trg_sys_id").val(),
		  		exrt_dat_cnt : $("#exrt_dat_cnt").val(),
		  		src_include_tables : $("#src_include_table_nm_trsf").val(),
		  		src_exclude_tables : $("#src_exclude_table_nm_trsf").val(),
		  		exrt_dat_ftch_sz : $("#exrt_dat_ftch_sz").val(),
		  		dat_ftch_bff_sz : $("#dat_ftch_bff_sz").val(),
		  		exrt_prl_prcs_ecnt : $("#exrt_prl_prcs_ecnt").val(),
		  		lob_dat_bff_sz : $("#lob_dat_bff_sz").val(),
		  		tb_rbl_tf : $("#tb_rbl_tf").val(),
		  		ins_opt_cd : $("#ins_opt_cd").val(),
		  		cnst_cnd_exrt_tf : $("#cnst_cnd_exrt_tf").val(),
		  		src_cnd_qry : $("#src_cnd_qry").val(),
		  		usr_qry_use_tf : $('input[name="usr_qry_use_tf"]:checked').val(),
		  		db2pg_usr_qry : $("#db2pg_usr_qry").val(),
		  		src_table_total_cnt : src_table_total_cnt_trsf,
		  		wrk_id : $("#wrk_id").val(),
		  		db2pg_uchr_lchr_val : $("#dat_db2pg_uchr_lchr_val").val()
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
				if(result.resultCode == "0000000000"){
					showSwalIconRst('<spring:message code="message.msg07" />', '<spring:message code="common.close" />', '', 'success');
					$('#pop_layer_data_reg').modal("hide");
					selectTab("dataWork");
				}else{
					showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
				}		
			}
		});
	}
}

/* ********************************************************
 * DBMS 서버 호출하여 입력
 ******************************************************** */
 function fn_dbmsAddCallback_source_trsf(db2pg_sys_id,db2pg_sys_nm){
	 $('#db2pg_sys_id_trsf').val(db2pg_sys_id);
	 $('#db2pg_source_system_nm').val(db2pg_sys_nm);
}

/* ********************************************************
  * DBMS 서버(PG) 호출하여 입력
  ******************************************************** */
  function fn_dbmsPgAddCallback(db2pg_sys_id,db2pg_sys_nm){
 	 $('#db2pg_trg_sys_id').val(db2pg_sys_id);
 	 $('#db2pg_trg_sys_nm').val(db2pg_sys_nm);
 }
 
/* ********************************************************
 * 소스시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_dbmsInfo_trsf(){
	document.getElementById("sourceSystem_trsf_add").style.display ='block';
	document.getElementById("sourceSystem_trsf_mod").style.display ='none';
	$('#pop_layer_dbmsInfo_trsf_reg').modal("show");
}

/* ********************************************************
 * 타겟시스템(PG) 등록 버튼 클릭시
 ******************************************************** */
function fn_dbmsPgInfo(){
	$('#pop_layer_dbmsInfo_trsf_pg_reg').modal("show");
}

/* ********************************************************
 * 추출 대상 테이블, 추출 제외 테이블 등록 버튼 클릭시
 ******************************************************** */
function fn_tableList_trsf(gbn){
	if($('#db2pg_source_system_nm').val() == ""){
		showSwalIcon('<spring:message code="migration.msg03" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	if(gbn == 'include'){
		var src_include_table_nm_trsf = $('#src_include_table_nm_trsf').val();  
	}else{
		var src_exclude_table_nm_trsf = $('#src_exclude_table_nm_trsf').val();  
	}
	
	$.ajax({
		url : "/db2pg/popup/tableInfo.do",
		data : {
			src_include_table_nm : src_include_table_nm_trsf,
			src_exclude_table_nm : src_exclude_table_nm_trsf,
			db2pg_sys_id : $('#db2pg_sys_id_trsf').val(),
			tableGbn : gbn
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
 			tableList = result.tableList;
 			tableGbn = result.tableGbn;
 			$("#db2pg_sys_nm_table").val(nvlPrmSet(result.dbmsInfo[0].db2pg_sys_nm, ""));
 			$("#ipadr_table").val(nvlPrmSet(result.dbmsInfo[0].ipadr, ""));
 			$("#scm_nm_table").val(nvlPrmSet(result.dbmsInfo[0].scm_nm, ""));
 			$("#dbms_dscd_table").val(nvlPrmSet(result.dbmsInfo[0].dbms_dscd, ""));
 			$("#dtb_nm_table").val(nvlPrmSet(result.dbmsInfo[0].dtb_nm, ""));
 			$("#spr_usr_id_table").val(nvlPrmSet(result.dbmsInfo[0].spr_usr_id, ""));
 			$("#pwd_table").val(nvlPrmSet(result.dbmsInfo[0].pwd, ""));
 			$("#portno_table").val(nvlPrmSet(result.dbmsInfo[0].portno, ""));
 			$("#object_type_table").val("");
		
			fn_search_tableInfo();
 			document.getElementById("add").style.display ='none';
 			document.getElementById("mod").style.display ='none';
 			document.getElementById("add_data").style.display ='block';
 			document.getElementById("mod_data").style.display ='none';
			$('#pop_layer_tableInfo_reg').modal("show");
		}
	});
}

/* ********************************************************
 * select box control
 ******************************************************** */
 $(function() {
	 $("#src_tables_trsf").change(function(){
		 $("#src_include_tables_trsf").val("");
		 $("#src_exclude_tables_trsf").val("");
		 $("#src_include_table_nm_trsf").val("");
		 $("#src_exclude_table_nm_trsf").val("");
		    if(this.value=="include"){
		        $("#include_trsf").show();
			    $("#exclude_trsf").hide(); 
		    }else{
		        $("#exclude_trsf").show();
			    $("#include_trsf").hide(); 
		    }
		});
 });

function fn_tableAddCallback3(rowList, tableGbn, totalCnt){
	if(tableGbn == 'include'){
		 $('#src_include_tables_trsf').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_include_table_nm_trsf').val(rowList);
		$('#src_table_total_cnt_trsf').val(totalCnt);
	}else{
		$('#src_exclude_tables_trsf').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_exclude_table_nm_trsf').val(rowList);
		$('#src_table_total_cnt_trsf').val(totalCnt);
	}
}
</script>
<form name="frmPopup">
	<input type="hidden" name="db2pg_sys_id_trsf"  id="db2pg_sys_id_trsf">
	<input type="hidden" name="src_include_table_nm_trsf"  id="src_include_table_nm_trsf" >
	<input type="hidden" name="src_exclude_table_nm_trsf"  id="src_exclude_table_nm_trsf" >
	<input type="hidden" name="tableGbn_trsf"  id="tableGbn_trsf" >
	<input type="hidden" name="src_table_total_cnt_trsf" id="src_table_total_cnt_trsf">
</form>

<input type="hidden" name="wrk_id" id="wrk_id">
<input type="hidden" name="db2pg_trsf_wrk_id" id="db2pg_trsf_wrk_id">

<div class="modal fade" id="pop_layer_data_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 40px 180px;">
		<div class="modal-content" style="width:1300px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="inset_title" style="padding-left:5px;margin-bottom:10px;">
					Migration <spring:message code="common.registory" />
				</h4>
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="mod_title" style="padding-left:5px;margin-bottom:10px;">
					Migration <spring:message code="common.modify" />
				</h4>
				<div class="card" style="border:0px;max-height:698px;">
					<form class="cmxform" id="dataRegForm">
						<fieldset>
							<div class="row">
								<div class="col-md-12 system-tlb-scroll" style="border:0px;height: 620px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_name" />
											</label>
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="db2pg_trsf_wrk_nm" name="db2pg_trsf_wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()"/>
											</div>
											<div class="col-sm-2">
												<button type="button" id="inset_button_data_work" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_check_ddl_reg()"><spring:message code="common.overlap_check" /></button>
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:-10px;">
											<label for="ins_dump_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_description" />
											</label>
											<div class="col-sm-10">
												<textarea class="form-control" id="db2pg_trsf_wrk_exp" name="db2pg_trsf_wrk_exp" rows="2" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
											</div>
										</div>
									</div>
									<br/>
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_save_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<spring:message code="migration.source_system" />
											</label>
											<div class="col-sm-6">
												<input type="text" class="form-control form-control-sm" id="db2pg_source_system_nm" name="db2pg_source_system_nm" readonly="readonly" />
											</div>
											<div class="col-sm-4">
												<div class="input-group input-daterange d-flex align-items-center" >
													<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_dbmsInfo_trsf()"><spring:message code="button.create" /></button>
												</div>
											</div>
											
											
											<label for="ins_dump_save_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<spring:message code="migration.target_system" />
											</label>
											<div class="col-sm-6">
											<input type="hidden" name="db2pg_trg_sys_id" id="db2pg_trg_sys_id"/>
												<input type="text" class="form-control form-control-sm" id="db2pg_trg_sys_nm" name="db2pg_trg_sys_nm" readonly="readonly" />
											</div>
											<div class="col-sm-4">
												<div class="input-group input-daterange d-flex align-items-center" >
													<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_dbmsPgInfo()"><spring:message code="button.create" /></button>
												</div>
											</div>
										</div>
									</div>
									<br/>
									
									
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-10px;">
											<div class="col-12" >
												<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
													<li class="nav-item">
														<a class="nav-link active" id="ins-dump-tab-1" data-toggle="pill" href="#insDumpOptionTab1" role="tab" aria-controls="insDumpOptionTab1" aria-selected="true" >
															<spring:message code="migration.source_option"/> #1
														</a>
													</li>
													<li class="nav-item">
														<a class="nav-link" id="ins-dump-tab-2" data-toggle="pill" href="#insDumpOptionTab2" role="tab" aria-controls="insDumpOptionTab2" aria-selected="false">
															<spring:message code="migration.source_option"/> #2
														</a>
													</li>
												</ul>
											</div>
										</div>
						
										<!-- tab화면 -->
										<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;margin-bottom:-10px;">
											<div class="tab-pane fade show active" role="tabpanel" id="insDumpOptionTab1">
												<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<select name="src_tables_trsf" id="src_tables_trsf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
															<option value="include_trsf"><spring:message code="migration.inclusion_table"/></option>
															<option value="exclude_trsf"><spring:message code="migration.exclusion_table"/></option>
														</select>
													</label>
													<div id="include_trsf" class="form-inline col-sm-10 row">
														<div class="col-sm-5">
															<input type="text" class="form-control form-control-sm" style="width: 100%;" name="src_include_tables_trsf" id="src_include_tables_trsf" readonly="readonly" />
														</div>
														<div class="col-sm-3">
															<button type="button" class="btn btn-inverse-primary btn-fw" onclick="fn_tableList_trsf('include')" ><spring:message code="button.create" /></button>
														</div>
													</div>
													<div id="exclude_trsf" style="display: none;" class="form-inline col-sm-10 row">
														<div class="col-sm-5">
															<input type="text" class="form-control form-control-sm" style="width: 100%;" name="src_exclude_tables_trsf" id="src_exclude_tables_trsf" readonly="readonly" />
														</div>
														<div class="col-sm-3">
															<button type="button" class="btn btn-inverse-primary btn-fw" onclick="fn_tableList_trsf('exclude')" ><spring:message code="button.create" /></button>
														</div>
													</div>	
												</div>
										
												<br>
												<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.data_fetch_size" />
													</label>
													<div class="col-sm-4">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_dat_ftch_sz" id="exrt_dat_ftch_sz" value="3000"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.data_fetch_buffer_size" />
													</label>
													<div class="col-sm-4">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="dat_ftch_bff_sz" id="dat_ftch_bff_sz" value="10"/>
													</div>
												</div>
												
												<br>

												<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.number_of_parallel_worker" />
													</label>
													<div class="col-sm-4">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_prl_prcs_ecnt" id="exrt_prl_prcs_ecnt" value="1"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.lob_buffer_size" />
													</label>
													<div class="col-sm-4">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="lob_dat_bff_sz" id="lob_dat_bff_sz" value="100"/>
													</div>
												</div>
												
												<br>
												<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-30px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.number_of_rows_extracted" />
													</label>
													<div class="col-sm-4">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_dat_cnt" id="exrt_dat_cnt" value="-1" min="-1"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.specify_case" />
													</label>
													<div class="col-sm-4">
														<select name="dat_db2pg_uchr_lchr_val" id="dat_db2pg_uchr_lchr_val"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
															<c:forEach var="codeLetter" items="${codeLetter}">
																<option value="${codeLetter.sys_cd_nm}">${codeLetter.sys_cd_nm}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											
											<div class="tab-pane fade" role="tabpanel" id="insDumpOptionTab2">
												<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.conditional_statement" />
													</label>
													<div id="include_trsf" class="form-inline">
														<div class="col-sm-10">
															<textarea name="src_cnd_qry" id="src_cnd_qry" style="height: 250px; width: 900px;" class="form-control"></textarea>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									
									
									<!-- 추후 -->
									<div class="view addOption_inr" style="display: none">
										<ul>
											<li style="border-bottom: none;">
												<p class="op_tit" style="width: 70px;"><spring:message code="user_management.use_yn" /></p>
												<div class="inp_rdo">
													<input name="usr_qry_use_tf" id="rdo_r_1" type="radio" value="true" onchange="fn_checkBox('true')">
														<label for="rdo_r_1"><spring:message code="dbms_information.use" /></label> 
													<input name="usr_qry_use_tf" id="rdo_r_2" type="radio" value="false" checked="checked" onchange="fn_checkBox('false')"> 
														<label for="rdo_r_2"><spring:message code="dbms_information.unuse" /></label>
												</div>
											</li>
											<li style="border-bottom: none;">
												<p class="op_tit">사용자 쿼리</p>
												<span>
													<div class="textarea_grp">
														<textarea name="db2pg_usr_qry" id="db2pg_usr_qry" style="height: 250px; width: 700px;" readonly="readonly"></textarea>
													</div>
												</span>
											</li>
										</ul>
									</div>				
									
									<br/>
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-5px;margin-bottom:-25px;">
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:5px;">
												<spring:message code="migration.table_rebuild" />
											</label>
											<div class="col-sm-2">
												<select name="tb_rbl_tf" id="tb_rbl_tf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeTF" items="${codeTF}">
														<option value="${codeTF.sys_cd_nm}" ${false eq codeTF.sys_cd_nm ? "selected='selected'" : ""}>${codeTF.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:5px;">
												<spring:message code="migration.input_mode" />
											</label>
											<div class="col-sm-2">
												<select name="ins_opt_cd" id="ins_opt_cd"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeInputMode" items="${codeInputMode}">
														<option value="${codeInputMode.sys_cd_nm}">${codeInputMode.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:5px;">
												<spring:message code="migration.contraint_extraction" />
											</label>
											<div class="col-sm-2">
												<select name="cnst_cnd_exrt_tf" id="cnst_cnd_exrt_tf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeTF" items="${codeTF}">
														<option value="${codeTF.sys_cd_nm}" ${false eq codeTF.sys_cd_nm ? "selected='selected'" : ""}>${codeTF.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="card-body">
								<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0 -30px -20px;" >
									<input class="btn btn-primary" width="200px;" id="inset_button_data_work2" style="vertical-align:middle;" type="button" onclick="fn_insert_trsf_work()" value='<spring:message code="common.registory" />' />
									<input class="btn btn-primary" width="200px;" id="mod_button_data_work" style="vertical-align:middle;" type="button" onclick="fn_update_trsf_work()" value='<spring:message code="common.modify" />' />
									<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
