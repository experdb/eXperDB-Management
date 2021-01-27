<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : dataRegForm2.jsp
	* @Description : 데이터 이관 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2020.12.30     최초 생성
	*
	* author 신예은
	* since 2020.12.30
	*
	*/
%>
<script type="text/javascript">
var db2pg_trsf_wrk_nmChk ="fail";

// 테이블선택 
var infoTableMig = null;
var extTableMig = null;
var sqlTable = null;
var tableList_mig = [];

// sql 입력
var sqlCount = 0;
var sqlContent = [];
var sqlTable = [];

$(window.document).ready(function(){
	fn_init_tables_mig();
});

function fn_init_tables_mig(){
	infoTableMig = $('#info_tableList_mig').DataTable({
		scrollY : "220px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : true,
		bSort: false,
		columns : [
			{data : "table_name", defaultContent : "", className : "dt-center"},
			{data : "obj_type", defaultContent : "", className : "dt-center"},
			{data : "obj_description", defaultContent : "", className : "dt-center"},
		], 'select': {'style' : 'multi'}
	});
	infoTableMig.tables().header().to$().find('th:eq(0)').css('min-width', '150px');
	infoTableMig.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
	infoTableMig.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	
	extTableMig = $('#ext_tableList_mig').DataTable({
		scrollY : "220px",
		scrollX: true,	
		processing : true,
		searching : false,
		paging : true,
		bSort: false,
		columns : [
			{data : "table_name", defaultContent : "", className : "dt-center"},
			{data : "obj_type", defaultContent : "", className : "dt-center"},
			{data : "obj_description", defaultContent : "", className : "dt-center"},
		], 'select': {'style' : 'multi'}
	});
	extTableMig.tables().header().to$().find('th:eq(0)').css('min-width', '150px');
	extTableMig.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
	extTableMig.tables().header().to$().find('th:eq(2)').css('min-width', '150px');
	
}


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
		return valCheck_usrqryReg();
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
		return valCheck_usrqryReg();
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
	 var db2pg_trsf_wrk_nm = $("#db2pg_trsf_wrk_nm").val().replace(/ /g, '_');
	 $("#db2pg_trsf_wrk_nm").val(db2pg_trsf_wrk_nm);
	console.log("checkcheck : " + $("#db2pg_trsf_wrk_nm").val());
	// var db2pg_trsf_wrk_nm = document.getElementById("db2pg_trsf_wrk_nm");
	if (db2pg_trsf_wrk_nm.value == "") {
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		document.getElementById('db2pg_trsf_wrk_nm').focus();
		return;
	}
	
	
	
//	if(fnCheckNotKorean(db2pg_trsf_wrk_nm.value)){
	if(fnCheckNotKorean(db2pg_trsf_wrk_nm)){
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
/* ********************************************************
 * work name change check
 ******************************************************** */
function fn_checkWrkNm_change_mig() {
	db2pg_trsf_wrk_nmChk = "fail";
}

/* 한글입력 체크 */
function fnCheckNotKorean(koreanStr){
    for(var i=0;i<koreanStr.length;i++){
        var koreanChar = koreanStr.charCodeAt(i);
        if( !( 0xAC00 <= koreanChar && koreanChar <= 0xD7A3 ) && !( 0x3131 <= koreanChar && koreanChar <= 0x318E ) ) {
        }else{
        	showSwalIcon('<spring:message code="encrypt_msg.msg22" />', '<spring:message code="common.close" />', '', 'error');
            return false;
        }
    }
    return true;
}

/* ********************************************************
 * user query validation check
 ******************************************************** */
// user query add check
 function valCheck_usrqry(){
	sqlContent = [];
	sqlTable = [];

	for(var i=1;i <= sqlCount; i++){
		sqlContent.push($("#user_qry"+i, "#userSqls").val());
		sqlTable.push($("#sqlTable"+i, "#userSqls").val());
	}

	if(sqlCount == 0 ){
		return true;
	}else if(sqlTable.includes("")){
		showSwalIcon('<spring:message code="migration.user_query_table" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(sqlContent.includes("")){
		showSwalIcon('<spring:message code="migration.user_query_content" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(duplicate(sqlTable)){
		showSwalIcon('<spring:message code="migration.user_query_table_dup" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} else {
		return true;
	}
}

// user query save check
function valCheck_usrqryReg(){
	sqlContent = [];
	sqlTable = [];

	for(var i=1;i <= sqlCount; i++){
		sqlContent.push($("#user_qry"+i, "#userSqls").val());
		sqlTable.push($("#sqlTable"+i, "#userSqls").val());
	}

	if(sqlCount == 1 && sqlTable.includes("") && sqlTable.includes("")){
		return true;
	}else if (sqlTable.includes("")){
		showSwalIcon('<spring:message code="migration.user_query_table" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(sqlContent.includes("")){
		showSwalIcon('<spring:message code="migration.user_query_content" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if(duplicate(sqlTable)){
		showSwalIcon('<spring:message code="migration.user_query_table_dup" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	} else {
		return true;
	}
}

// 중복 확인 함수
// 중복이 존재한다면 true 리턴
function duplicate(arr){
	const dup = arr.some(function(x){
		return arr.indexOf(x) !== arr.lastIndexOf(x);
	});
	return dup;
}


/* ********************************************************
 * table clear
 ******************************************************** */
function fn_table_clear_mig(){
	infoTableMig.clear().draw();
	extTableMig.clear().draw();
}

/* ********************************************************
 * reset 
 ******************************************************** */
function fn_reset_mig() {
	
	// user query reset
	sqlCount = 0;
	$("#userSqls").empty();
	fn_addSql();
	
	// table selection  reset
	fn_table_clear_mig();
	
	$('#db2pg_trsf_wrk_nm').prop('readonly', false);

	$("#mod_button_data_work").hide();
	$("#inset_button_data_work").show();
	$("#inset_button_data_work2").show();
	$("#inset_title").show();
	$("#mod_title").hide();
	$("#src_tables_trsf").val("include");
	$("#src_cnd_qry").val("");
	
	// tab 선택
	$('a[href="#insDumpOptionTab1"]').tab('show');
	$('#con_multi_gbn', '#findConfirmMulti').val("data_reg");
	
	//$('.system-tlb-scroll').scrollTop(0);
	$("#db2pg_trsf_wrk_nm").focus();
}

function fn_reset_mig_modi(result){
	sqlContent = [];
	sqlTable = [];
	sqlCount = result.length;

	$("#userSqls").empty();
	
	if(sqlCount <1){
		fn_addSql();
	}else{
		for(var i=0;i<sqlCount; i++){
			sqlTable.push(result[i].tar_tb_name);
			sqlContent.push(result[i].usr_qry_exp);
		}
		fn_drawSql();
	}
	
}

/* ********************************************************
 * 등록 버튼 클릭시
 ******************************************************** */
function fn_insert_trsf_work(){
	if(valCheck_trsf()){
		var rowList = [];
		var infoLength = infoTableMig.rows().data().length;
		var extLength = extTableMig.rows().data().length;
		var totalLength = infoLength + extLength;
		if(totalLength == ""){
			var src_table_total_cnt_trsf = 0;
		}else{
			var src_table_total_cnt_trsf = totalLength;
		}
		for(var i=0;i<extLength;i++){
			rowList.push(extTableMig.rows().data()[i].table_name);
		}
		if($("#src_tables_trsf").val() == "include"){
			$('#src_include_table_nm_trsf').val(rowList);
		}else {
			$('#src_exclude_table_nm_trsf').val(rowList);
		}
		console.log("sqlTable : " + sqlTable);
		console.log("sqlTable.length : " + sqlTable.length);
		console.log("sqlContent : " + sqlContent);
		console.log("sqlContent.length : " + sqlContent.length);
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
						  		src_table_total_cnt : src_table_total_cnt_trsf,
						  		usr_qry_use_tf : $('input[name="usr_qry_use_tf"]:checked').val(),
								db2pg_usrqry_content : sqlContent,
								db2pg_usrqry_table : sqlTable,  
						  		db2pg_uchr_lchr_val : $("#dat_db2pg_uchr_lchr_val").val(),
						  	},
							type : "post",
							traditional : true,
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
		var rowList = [];
		var infoLength = infoTableMig.rows().data().length;
		var extLength = extTableMig.rows().data().length;
		var totalLength = infoLength + extLength;
		if(totalLength == ""){
			var src_table_total_cnt_trsf = 0;
		}else{
			var src_table_total_cnt_trsf = totalLength;
		}
		for(var i=0;i<extLength;i++){
			rowList.push(extTableMig.rows().data()[i].table_name);
		}
		if($("#src_tables_trsf").val() == "include"){
			$('#src_include_table_nm_trsf').val(rowList);
		}else {
			$('#src_exclude_table_nm_trsf').val(rowList);
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
				db2pg_usrqry_content : sqlContent,
				db2pg_usrqry_table : sqlTable,  
		  		db2pg_uchr_lchr_val : $("#dat_db2pg_uchr_lchr_val").val()
			  },
			traditional : true,
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
	 $('#src_include_table_nm_trsf').val("");
	 $('#src_exclude_table_nm_trsf').val("");
	 fn_dbmsInfo_set();
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

/*******************************************************
 * DBMS 등록 후 정보 넣어주기
 ******************************************************/
function fn_dbmsInfo_set(){
	if($('#db2pg_source_system_nm').val() == ""){
		showSwalIcon('<spring:message code="migration.msg03" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	if($("#src_tables_trsf").val() == 'include'){
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
			tableGbn : $("#src_tables_trsf").val()
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
			tableList_mig = result.tableList;
			$("#mig_sys_nm_reg").val(nvlPrmSet(result.dbmsInfo[0].db2pg_sys_nm, ""));
			$("#mig_ipadr_reg").val(nvlPrmSet(result.dbmsInfo[0].ipadr, ""));
			$("#mig_scm_nm_reg").val(nvlPrmSet(result.dbmsInfo[0].scm_nm, ""));
			$("#mig_dbms_dscd_table").val(nvlPrmSet(result.dbmsInfo[0].dbms_dscd, ""));
			$("#mig_dtb_nm_table").val(nvlPrmSet(result.dbmsInfo[0].dtb_nm, ""));
			$("#mig_spr_usr_id_table").val(nvlPrmSet(result.dbmsInfo[0].spr_usr_id, ""));
			$("#mig_pwd_table").val(nvlPrmSet(result.dbmsInfo[0].pwd, ""));
			$("#mig_portno_table").val(nvlPrmSet(result.dbmsInfo[0].portno, ""));
			$("#mig_object_type_reg").val("");
			
			extTableMig.clear().draw();
			fn_search_tableInfo_mig();
		}
	});
	
	
}

/*********************************************************
 * dbms 등록 후 정보 불러오기
 ******************************************************* */
function fn_search_tableInfo_mig(){
	var table_nm = null;
	
	if($("#mig_table_nm_reg").val() == ""){
		table_nm="%";
	}else{
		table_nm=$("#mig_table_nm_reg").val();
	}

	$.ajax({
		url : "/selectTableList.do",
		data : {
 		 	ipadr : $("#mig_ipadr_reg").val(),
 		 	portno : $("#mig_portno_table").val(),
 		  	dtb_nm : $("#mig_dtb_nm_table").val(),
 		  	spr_usr_id : $("#mig_spr_usr_id_table").val(),
 		  	pwd : $("#mig_pwd_table").val(),
 		  	dbms_dscd : $("#mig_dbms_dscd_table").val(),
 		  	table_nm : table_nm,
 		  	scm_nm : $("#mig_scm_nm_reg").val(),
 		  	object_type : $("#mig_object_type_reg").val()
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
						
			infoTableMig.rows({selected: true}).deselect();
			infoTableMig.clear().draw();
			
			if (result.RESULT_DATA != null) {
				infoTableMig.rows.add(result.RESULT_DATA).draw();
				var infoLength = infoTableMig.rows().data().length;
				var extLength = extTableMig.rows().data().length;
				if(tableList_mig == ""){
					if(extLength>0){
						for(var i=0;i<infoLength;i++){
							for(var j=0;j<extLength;j++){
								if(infoTableMig.row(i).data().table_name == extTableMig.row(j).data().table_name){
									infoTableMig.row(i).select();
									break;
								}
							}
						}
						infoTableMig.rows('.selected').remove().draw();;
					}
				}else {
					for(var i=0;i<infoLength;i++){
						for(var j=0;j<tableList_mig.length; j++){
							if(infoTableMig.row(i).data().table_name == tableList_mig[j]){
								infoTableMig.row(i).select();
								break;
							}
						}
					}
					tableList_mig = "";
					fn_rightMove_mig();
				}				

			}

		}
	});
}
/***********************************************************
 * 조회 버튼 눌렀을 때
 ***********************************************************/
 /*
 function fn_search_tableInfo_mig(){
		var table_nm = null;
		
		if($("#mig_table_nm_reg").val() == ""){
			table_nm="%";
		}else{
			table_nm=$("#mig_table_nm_reg").val();
		}

		$.ajax({
			url : "/selectTableList.do",
			data : {
	 		 	ipadr : $("#mig_ipadr_reg").val(),
	 		 	portno : $("#mig_portno_table").val(),
	 		  	dtb_nm : $("#mig_dtb_nm_table").val(),
	 		  	spr_usr_id : $("#mig_spr_usr_id_table").val(),
	 		  	pwd : $("#mig_pwd_table").val(),
	 		  	dbms_dscd : $("#mig_dbms_dscd_table").val(),
	 		  	table_nm : table_nm,
	 		  	scm_nm : $("#mig_scm_nm_reg").val(),
	 		  	object_type : $("#mig_object_type_reg").val()
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
							
				infoTableMig.rows({selected: true}).deselect();
				infoTableMig.clear().draw();
				
				if (result.RESULT_DATA != null) {
					infoTableMig.rows.add(result.RESULT_DATA).draw();
					var infoLength = infoTableMig.rows().data().length;
					var extLength = extTableMig.rows().data().length;
									
					if(extLength>0){
						for(var i=0;i<infoLength;i++){
							for(var j=0;j<extLength;j++){
								if(infoTableMig.row(i).data().table_name == extTableMig.row(j).data().table_name){
									infoTableMig.row(i).select();
									break;
								}
							}
						}
						infoTableMig.rows('.selected').remove().draw();;
					}

				}

			}
		});
	}
	*/
///////////////////////////////////////////////////////////////
/////////////////////// 테이블 리스트 조정 ///////////////////////////
///////////////////////////////////////////////////////////////

/*
 * 우측 이동 (>)
 */
 function fn_rightMove_mig(){
	var datas = infoTableMig.rows('.selected').data();
	var rows = [];
	
	if(datas.length <1) {
		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
		return;
	}
	
	for(var i =0; i<datas.length;i++){
		rows.push(infoTableMig.rows('.selected').data()[i]);
	}
	
	extTableMig.rows.add(rows).draw();
	infoTableMig.rows('.selected').remove().draw();
	
}

 /*
  * 좌측 이동 (<)
  */
  function fn_leftMove_mig() {
 	var datas = extTableMig.rows('.selected').data();
 	var rows = [];
 	
 	if(datas.length < 1) {
 		showSwalIcon('<spring:message code="message.msg35" />', '<spring:message code="common.close" />', '', 'warning');
 		return;
 	}
 	
 	for (var i = 0;i<datas.length;i++) {
 		rows.push(extTableMig.rows('.selected').data()[i]); 
 	}
 	
 	infoTableMig.rows.add(rows).draw();
 	extTableMig.rows('.selected').remove().draw();
 	
 }

 /*
  * 전체 우측 이동 (>>)
  */
  function fn_allRightMove_mig() {
 	 var datas = infoTableMig.rows().data();
 		var rows = [];

 		//row 존재 확인
 		if(datas.length < 1) {
 			showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'warning');
 			return;
 		}

 		for (var i = 0;i<datas.length;i++) {
 			rows.push(infoTableMig.rows().data()[i]); 	
 		}
 	
 		extTableMig.rows.add(rows).draw(); 	
 		infoTableMig.rows({selected: true}).deselect();
 		infoTableMig.rows().remove().draw();
 }

 /*
  * 전체 좌측 이동 (<<)
  */
  function fn_allLeftMove_mig() {
 		var datas = extTableMig.rows().data();
 		var rows = [];

 		//row 존재 확인
 		if(datas.length < 1) {
 			showSwalIcon('<spring:message code="message.msg01" />', '<spring:message code="common.close" />', '', 'warning');
 			return;
 		}

 		for (var i = 0;i<datas.length;i++) {
 			rows.push(extTableMig.rows().data()[i]); 	
 		}
 	
 		infoTableMig.rows.add(rows).draw(); 	
 		extTableMig.rows({selected: true}).deselect();
 		extTableMig.rows().remove().draw();
 }


/* ********************************************************
 * select box control
 ******************************************************** */
 $(function() {
	 $("#src_tables_trsf").change(function(){
		 $("#src_include_table_nm_trsf").val("");
		 $("#src_exclude_table_nm_trsf").val("");
	});		
});

 
/* ********************************************************
 * 소스옵션 #4 function
 ******************************************************** */

 // + 버튼 눌렀을 때 (add Sql)
 function fn_addSql() {
	 if(valCheck_usrqry()){
		 $("button").remove("#addSqlBtn");
		 sqlCount++;
		 $("#userSqls").append(
			 '<div class="form-inline" id="sqlDiv' + sqlCount + '" style="width:1230px; margin-left: 30px; margin-bottom: 10px;">\n' +
			 '	<label for="ins_dump_cprt" class="col-sm-1_5 col-form-label" style="padding-top:7px;"> SQL ' + sqlCount + ' </label>\n' +
			'	<div id="userQry' + sqlCount +'" class="col-sm-9">	\n' +
			'		<input type="text" class="sqlTable form-control form-control-sm" id="sqlTable' + sqlCount +'" name="sqlTable0" style="width:220px;height:30px;margin-bottom: 5px;" placeholder="<spring:message code="migration.user_query_table" />"/> \n' +
			 '		<textarea name="user_qry' + sqlCount +'" id="user_qry' + sqlCount +'" style="height: 100px;width: 870px;padding-left: 12px;" class="form-control" placeholder="<spring:message code="migration.user_query_sql" />""></textarea>\n' +
			 '	</div>\n' +
			'	<button type="button" id="delSqlBtn" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_delCheck(' + sqlCount +')"style="margin-right: 10px;margin-top: 8px;font-size: 16px;">\n' +
			'		<strong>-</strong>\n' +
			'	</button>\n' +
			'	<button type="button" id = "addSqlBtn" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_addSql()" style="margin-top: 8px;font-size: 16px;">\n' +
			'		<strong>+</strong>\n' +
			'	</button>\n' +
			 '</div> \n'
		 );
		 $("#sqlTable"+sqlCount).focus();
		 $('.system-tlb-scroll').scrollTop(10000);
	 }
 }

 // - 버튼 눌렀을 때 확인
 function fn_delCheck(id){
	$("#usrqry_del_id").val(id);
	confile_title = '<spring:message code="migration.user_query" />' + " " + '<spring:message code="button.delete" />' + " " + '<spring:message code="common.request" />';
	$('#con_multi_gbn', '#findConfirmMulti').val("usrqry_del");
	$('#confirm_multi_tlt').html(confile_title);
	$('#confirm_multi_msg').html('<spring:message code="message.msg162" />');
	$('#pop_confirm_multi_md').modal("show");

 }
 
 // sql 삭제
 function fn_delSql(){
	sqlContent = [];
	sqlTable = [];
	var id = $("#usrqry_del_id").val();

	 for(var i=1;i <= sqlCount; i++){
		 if(i != id){
			 sqlContent.push($("#user_qry"+i, "#userSqls").val());
			 sqlTable.push($("#sqlTable"+i, "#userSqls").val());
		 }
	}
	
	if(sqlCount == 1){ // sql 1개 있을때 누를 경우 (내용만 지워줌)
		$("#userSqls").empty();
		// sqlCount=1;
		sqlCount=0;
		fn_addSql();
	}else{
		fn_drawSql();
	}
 }
 
 // sql 입력칸 그려주기
 function fn_drawSql(){
	 $("#userSqls").empty();
	 sqlCount = sqlContent.length;
	 for(var i=1; i<=sqlCount; i++){
		$("#userSqls").append(
			'<div class="form-inline" id="sqlDiv' + i + '" style="width:1230px; margin-left: 30px; margin-bottom: 10px;">\n' +
			'	<label for="ins_dump_cprt" class="col-sm-1_5 col-form-label" style="padding-top:7px;"> SQL ' + i + ' </label>\n' +
			'	<div id="userQry' + i +'" class="col-sm-9">	\n' +
			'		<input type="text" class="sqlTable form-control form-control-sm" id="sqlTable' + i +'" name="sqlTable0" style="width:220px;height:30px;margin-bottom: 5px;" value="' + sqlTable[i-1] + '" placeholder="<spring:message code="migration.user_query_table" />"> \n' +
			'		<textarea name="user_qry' + i +'" id="user_qry' + i +'" style="height: 100px;width: 870px;padding-left: 12px;" class="form-control" placeholder="<spring:message code="migration.user_query_sql" />">' + sqlContent[i-1] + '</textarea>\n' +
			'	</div>\n' +
			'	<button type="button" id="delSqlBtn" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_delCheck(' + i +')"style="margin-right: 10px;margin-top: 8px;font-size: 16px;">\n' +
			'		<strong>-</strong>\n' +
			'	</button>\n' +
			'</div> \n'	
		 );
	}
	$("#sqlDiv"+sqlCount).append(
			'	<button type="button" id = "addSqlBtn" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onclick="fn_addSql()" style="margin-top: 8px;font-size: 16px;">\n' +
			'		<strong>+</strong>\n' +
			'	</button>\n' 
	);
	// sqlCount++;
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
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 20px 150px;">
		<div class="modal-content" style="width:1400px; ">		 	 
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
												<input type="text" class="form-control form-control-sm" maxlength="20" id="db2pg_trsf_wrk_nm" name="db2pg_trsf_wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onchange="fn_checkWrkNm_change_mig();" onblur="this.value=this.value.trim()"/>
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
										<!-- tab 선택 버튼 -->
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-10px;">
											<div class="col-12" >
												<ul class="nav nav-pills nav-pills-setting nav-justified" style="border-bottom:0px;" id="server-tab" role="tablist">
													<li class="nav-item">
														<a class="nav-link active" id="ins-dump-tab-1" data-toggle="pill" href="#insDumpOptionTab1" role="tab" aria-controls="insDumpOptionTab1" aria-selected="true" >
															<spring:message code="migration.source_option"/> #1
														</a>
													</li>
													<li class="nav-item">
														<a class="nav-link" id="ins-dump-tab-2" data-toggle="pill" href="#insDumpOptionTab2" role="tab" aria-controls="insDumpOptionTab2" aria-selected="false" >
															<spring:message code="migration.source_option"/> #2
														</a>
													</li>
													<li class="nav-item">
														<a class="nav-link" id="ins-dump-tab-3" data-toggle="pill" href="#insDumpOptionTab3" role="tab" aria-controls="insDumpOptionTab3" aria-selected="false">
															<spring:message code="migration.source_option"/> #3
														</a>
													</li>
													<li class="nav-item">
														<a class="nav-link" id="ins-dump-tab-4" data-toggle="pill" href="#insDumpOptionTab4" role="tab" aria-controls="insDumpOptionTab4" aria-selected="false">
															<spring:message code="migration.source_option"/> #4
														</a>
													</li>
												</ul>
											</div>
										</div>
										<!-- tab 선택 버튼 end -->
						
										<!-- tab화면 -->
										<div class="tab-content" id="pills-tabContent" style="border-top: 1px solid #c9ccd7;margin-bottom:-10px;">
											<!-- 소스옵션 #1 -->
											<div class="tab-pane fade show active" role="tabpanel" id="insDumpOptionTab1">
												<!-- 테이블 옵션 검색 -->
												<div class="card-body" style="border: 1px solid #dee1e4;margin-top: -15px;padding-bottom: 10px;padding-top: 10px;">
													<div class="form-inline row" style="margin-bottom: -10px;">											
														<div class="input-group mb-2 mr-sm-2 col-sm-1_9"style="padding-right: 0px; margin-right: 0px;">
															<select name="src_tables_trsf" id="src_tables_trsf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;height:41px;">
																<option value="include"><spring:message code="migration.inclusion_table"/></option>
																<option value="exclude"><spring:message code="migration.exclusion_table"/></option>
															</select>
														</div>
														<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
															<input type="text" class="form-control" id="mig_sys_nm_reg" name="mig_sys_nm_reg" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.system_name'/>'  />
														</div>
														<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
															<input type="text" class="form-control" id="mig_ipadr_reg" name="mig_ipadr_reg" onblur="this.value=this.value.trim()" placeholder='<spring:message code='data_transfer.ip'/>'  />
														</div>
														<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
															<input type="text" class="form-control" id="mig_scm_nm_reg" name="mig_scm_nm_reg" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.schema_Name'/>'  />
														</div>
														<div class="input-group mb-2 mr-sm-2 col-sm-2">
															<select class="form-control" name="work" id="mig_object_type_reg" style="height:41px;">
																<option value=""><spring:message code="migration.table_type"/> 전체</option>
																<option value="TABLE">TABLE</option>
																<option value="VIEW">VIEW</option>
															</select>
														</div>
														<div class="input-group mb-2 mr-sm-2 col-sm-1_7">
															<input type="text" class="form-control" id="mig_table_nm_reg" name="mig_table_nm_reg" onblur="this.value=this.value.trim()" placeholder='<spring:message code='migration.table_name'/>'  />
														</div>
														<button type="button" class="btn btn-inverse-primary btn-icon-text mb-2 btn-search-disable" onClick="fn_search_tableInfo_mig();" >
															<i class="ti-search btn-icon-prepend "></i><spring:message code="common.search" />
														</button>
													</div>
												</div>
												<input type="hidden" class="txt t4" name="mig_dbms_dscd_table" id="mig_dbms_dscd_table"  />
												<input type="hidden" class="txt t4" name="mig_dtb_nm_table" id="mig_dtb_nm_table" />
												<input type="hidden" class="txt t4" name="mig_spr_usr_id_table" id="mig_spr_usr_id_table" />
												<input type="hidden" class="txt t4" name="mig_pwd_table" id="mig_pwd_table" />
												<input type="hidden" class="txt t4" name="mig_portno_table" id="mig_portno_table" />
												<!-- 테이블 옵션 검색 End -->
												<!-- 테이블 -->
												<br/>
												<div class="card-body" style="border: 1px solid #dee1e4;">
													<!-- 검색한 테이블 (Left Table) -->
													<div class="row">
														<div class="col-7 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="left_list">
															<div class="card" style="border:0px;">
																<div class="card-body" style="padding-left:0px;padding-right:0px;padding-top: 0px;">
																	<h4 class="card-title">
																		<i class="item-icon fa fa-dot-circle-o"></i>
																		<spring:message code="data_transfer.tableList" />
																	</h4>
						
														 			<table id="info_tableList_mig" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
																		<thead>
																			<tr class="bg-info text-white">
																				<th width="150" class="dt-center"><spring:message code="migration.table_name" /></th>
																				<th width="150" class="dt-center"><spring:message code="migration.table_type" /></th>	
																				<th width="150" class="dt-center"><spring:message code="migration.table_comment"/></th>
																			</tr>
																		</thead>
																	</table>
																</div>
															</div>
														</div>
						 								<!-- Left Table End -->
				 										<!-- 화살표 -->
														<div class="col-1 stretch-card div-form-margin-table" style="max-width: 6%;" id="center_div">
															<div class="card" style="background-color: transparent !important;border:0px;">
																<div class="card-body">	
																	<div class="card my-sm-2 connectRegForm2" style="border:0px;background-color: transparent !important;">
																		<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-top:15px;margin-bottom:-15px;">
																			<a href="#" class="tip" onclick="fn_allRightMove_mig();">
																				<i class="fa fa-angle-double-right" style="font-size: 35px;cursor:pointer;"></i>
																				<!-- 
																				<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
																				 -->
																			</a>
																		</label>
																		
																		<br/>
																			
																		<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
																			<a href="#" class="tip" onclick="fn_rightMove_mig();">
																				<i class="fa fa-angle-right" style="font-size: 35px;cursor:pointer;"></i>
																				<!-- 
																				<span style="width: 200px;"><spring:message code="data_transfer.move_right_line" /></span>
																				 -->
																			</a>
																		</label>
																		
																		<br/>
						
																		<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
																			<a href="#" class="tip" onclick="fn_leftMove_mig();">
																				<i class="fa fa-angle-left" style="font-size: 35px;cursor:pointer;"></i>
																				<!--
																				<span style="width: 200px;"><spring:message code="data_transfer.move_left_line" /></span>
																				 -->
																			</a>
																		</label>
																		
																		<br/>
						
																		<label for="com_auto_run_cycle" class="col-sm-12 col-form-label pop-label-index" style="margin-left:-30px;margin-bottom:-15px;">
																			<a href="#" class="tip" onclick="fn_allLeftMove_mig();">
																				<i class="fa fa-angle-double-left" style="font-size: 35px;cursor:pointer;"></i>
																				<!--
																				<span style="width: 200px;"><spring:message code="data_transfer.move_all_left" /></span>
																				-->
																			</a>
																		</label>
																	</div>
																</div>
															</div>
														</div>
														<!-- 화살표 End -->
														<!-- 작업 대상 테이블 (Right Table) -->	
														<div class="col-7 stretch-card div-form-margin-table" style="max-width: 47%;margin-top:5px;" id="right_list">
															<div class="card" style="border:0px;">
																<div class="card-body" style="padding-left:0px;padding-right:0px;padding-top: 0px;">
																	<h4 class="card-title">
																		<i class="item-icon fa fa-dot-circle-o"></i>
																		<spring:message code="migration.mig_table_list" />
																	</h4>
						
													 				<table id="ext_tableList_mig" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
																		<thead>
																			<tr class="bg-info text-white">
																				<th width="150" class="dt-center" ><spring:message code="migration.table_name" /></th>
																				<th width="150" class="dt-center" ><spring:message code="migration.table_type" /></th>	
																				<th width="150" class="dt-center"><spring:message code="migration.table_comment"/></th>	
																			</tr>
																		</thead>
																	</table>
																</div>
															</div>
														</div>
														<!-- 작업 대상 테이블 End -->
													</div>
												</div>
											</div>											
											<!-- 소스옵션 #1 end -->
											<!-- 소스옵션 #2 -->
											<div class="tab-pane fade show" role="tabpanel" id="insDumpOptionTab2">
												<div class="form-group row div-form-margin-z" style="margin-top:-5px;">
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.data_fetch_size" />
													</label>
													<div class="col-sm-3">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_dat_ftch_sz" id="exrt_dat_ftch_sz" value="3000"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.data_fetch_buffer_size" />
													</label>
													<div class="col-sm-3">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="dat_ftch_bff_sz" id="dat_ftch_bff_sz" value="10"/>
													</div>
												</div>
												
												<br>

												<div class="form-group row div-form-margin-z" style="margin-top:-5px;">
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.number_of_parallel_worker" />
													</label>
													<div class="col-sm-3">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_prl_prcs_ecnt" id="exrt_prl_prcs_ecnt" value="1"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.lob_buffer_size" />
													</label>
													<div class="col-sm-3">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="lob_dat_bff_sz" id="lob_dat_bff_sz" value="100"/>
													</div>
												</div>
												
												<br>
												<div class="form-group row div-form-margin-z" style="margin-top:-5px;">
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.number_of_rows_extracted" />
													</label>
													<div class="col-sm-3">
														<input type="number" style="width: 150px;" class="form-control form-control-sm" name="exrt_dat_cnt" id="exrt_dat_cnt" value="-1" min="-1"/>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.specify_case" />
													</label>
													<div class="col-sm-3">
														<select name="dat_db2pg_uchr_lchr_val" id="dat_db2pg_uchr_lchr_val"  class="form-control form-control-xsm" style="margin-right: 1rem;width:150px; height:40px;">
															<c:forEach var="codeLetter" items="${codeLetter}">
																<option value="${codeLetter.sys_cd_nm}">${codeLetter.sys_cd_nm}</option>
															</c:forEach>
														</select>
													</div>
												</div>
												<div class="form-group row div-form-margin-z">
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.table_rebuild" />
													</label>
													<div class="col-sm-3">
														<select name="tb_rbl_tf" id="tb_rbl_tf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:150px; height:40px;">
															<c:forEach var="codeTF" items="${codeTF}">
																<option value="${codeTF.sys_cd_nm}" ${false eq codeTF.sys_cd_nm ? "selected='selected'" : ""}>${codeTF.sys_cd_nm}</option>
															</c:forEach>
														</select>
													</div>
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.input_mode" />
													</label>
													<div class="col-sm-3">
														<select name="ins_opt_cd" id="ins_opt_cd"  class="form-control form-control-xsm" style="margin-right: 1rem;width:150px; height:40px;">
															<c:forEach var="codeInputMode" items="${codeInputMode}">
																<option value="${codeInputMode.sys_cd_nm}">${codeInputMode.sys_cd_nm}</option>
															</c:forEach>
														</select>
													</div>
												</div>
												<div class="form-group row div-form-margin-z" style="margin-top:5px; margin-bottom:-30px;">
													<label for="ins_dump_cprt" class="col-sm-2_3 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.contraint_extraction" />
													</label>
													<div class="col-sm-3">
														<select name="cnst_cnd_exrt_tf" id="cnst_cnd_exrt_tf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:150px; height:40px;">
															<c:forEach var="codeTF" items="${codeTF}">
																<option value="${codeTF.sys_cd_nm}" ${false eq codeTF.sys_cd_nm ? "selected='selected'" : ""}>${codeTF.sys_cd_nm}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<!-- 소스옵션 #2 end -->
											
											<!-- 소스옵션 #3 -->
											<div class="tab-pane fade" role="tabpanel" id="insDumpOptionTab3">
												<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
													<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
														<spring:message code="migration.conditional_statement" />
													</label>
													<div id="include_trsf" class="form-inline">
														<div class="col-sm-10">
															<textarea name="src_cnd_qry" id="src_cnd_qry" style="height: 300px; width: 900px;" class="form-control"></textarea>
														</div>
													</div>
												</div>
											</div>
											<!-- 소스옵션 #3 end -->
											<!-- 소스옵션 #4 -->
											<input type="hidden" class="txt t4" name="usrqry_del_id" id="usrqry_del_id" />
											<div class="tab-pane fade" role="tabpanel" id="insDumpOptionTab4" style="outline:#ffffff">
												<div class="form-group row div-form-margin-z" id="userSqls" style="margin-top:-10px;">
													<!-- sql 입력칸 들어가는 곳 -->
													 
												</div>
											</div>
											<!-- 소스옵션 #4 end -->
										</div>
										<!-- tab 화면 end -->
										
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
