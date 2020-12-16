<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="../../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : ddlRegForm.jsp
	* @Description : ddl추출 등록 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.09.17     최초 생성
	*
	* author kimjy
	* since 2019.09.17
	*
	*/
%>
<script type="text/javascript">
var db2pg_ddl_wrk_nmChk ="fail";
var output_path ="fail";

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck_reg(){
	if($("#db2pg_ddl_wrk_nm").val() == ""){
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_ddl_wrk_nm").focus();
		return false;
	}else if(db2pg_ddl_wrk_nmChk =="fail"){
		showSwalIcon('<spring:message code="backup_management.work_overlap_check" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}else if($("#db2pg_ddl_wrk_exp").val() == ""){
		showSwalIcon('<spring:message code="message.msg108" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_ddl_wrk_exp").focus();
		return false;
	}else if($("#db2pg_sys_id").val() == ""){
		showSwalIcon('<spring:message code="migration.msg07" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_sys_id").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * WORK NM Validation Check
 ******************************************************** */
function fn_check_reg() {
	var db2pg_ddl_wrk_nm = document.getElementById("db2pg_ddl_wrk_nm");
	if (db2pg_ddl_wrk_nm.value == "") {
		showSwalIcon('<spring:message code="message.msg107" />', '<spring:message code="common.close" />', '', 'error');
		document.getElementById('db2pg_ddl_wrk_nm').focus();
		return;
	}
	
	
	if(fnCheckNotKorean(db2pg_ddl_wrk_nm.value)){	
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $("#db2pg_ddl_wrk_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					showSwalIcon('<spring:message code="backup_management.reg_possible_work_nm"/>', '<spring:message code="common.close" />', '', 'success');
					document.getElementById("db2pg_ddl_wrk_nm").focus();
					db2pg_ddl_wrk_nmChk = "success";		
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					document.getElementById("db2pg_ddl_wrk_nm").focus();
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
 * output path Validation Check
 ******************************************************** */
function fn_pathCheck() {
	var ddl_save_pth = document.getElementById("ddl_save_pth");
	if (ddl_save_pth.value == "") {
		showSwalIcon('경로를 입력하세요.', '<spring:message code="common.close" />', '', 'error');
		document.getElementById('ddl_save_pth').focus();
		return;
	}
	$.ajax({
		url : '/db2pgPathCheck.do',
		type : 'post',
		data : {
			ddl_save_pth : $("#ddl_save_pth").val()
		},
		success : function(result) {
			if (result == true) {
				showSwalIcon('유효한 경로입니다.', '<spring:message code="common.close" />', '', 'success');
				output_path = "success";		
			} else {
				showSwalIcon('유효하지 않은 경로입니다.', '<spring:message code="common.close" />', '', 'error');
				document.getElementById("ddl_save_pth").focus();
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

/* ********************************************************
 * 등록 버튼 클릭시
 ******************************************************** */
function fn_insert_work(){
	if(valCheck_reg()){
		
		if($("#src_table_total_cnt").val() == ""){
			var src_table_total_cnt = 0
		}else{
			var src_table_total_cnt = $("#src_table_total_cnt").val()
		}

		//등록하기 전 work명 한번 더 중복 체크
		$.ajax({
			url : '/wrk_nmCheck.do',
			type : 'post',
			data : {
				wrk_nm : $("#db2pg_ddl_wrk_nm").val()
			},
			success : function(result) {
				if (result == "true") {
						$.ajax({
							url : "/db2pg/insertDDLWork.do",
						  	data : {
						  		db2pg_ddl_wrk_nm : $("#db2pg_ddl_wrk_nm").val().trim(),
						  		db2pg_ddl_wrk_exp : $("#db2pg_ddl_wrk_exp").val(),
						  		db2pg_sys_id : $("#db2pg_sys_id").val(),
						  		db2pg_uchr_lchr_val : $("#db2pg_uchr_lchr_val").val(),
						  		src_tb_ddl_exrt_tf : $("#src_tb_ddl_exrt_tf").val(),
						  		src_include_tables : $("#src_include_table_nm").val(),
						  		src_exclude_tables : $("#src_exclude_table_nm").val(),
						  		src_table_total_cnt : src_table_total_cnt
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
									$('#pop_layer_ddl_reg').modal("hide");
									selectTab("ddlWork");

								}else{
									showSwalIcon('<spring:message code="migration.msg06" />', '<spring:message code="common.close" />', '', 'error');
								}	
							}
						});	
				} else {
					showSwalIcon('<spring:message code="backup_management.effective_work_nm" />', '<spring:message code="common.close" />', '', 'error');
					document.getElementById("db2pg_ddl_wrk_nm").focus();
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
 * DBMS 서버 호출하여 입력
 ******************************************************** */
 function fn_dbmsAddCallback(db2pg_sys_id,db2pg_sys_nm){
	 $('#db2pg_sys_id').val(db2pg_sys_id);
	 $('#db2pg_sys_nm').val(db2pg_sys_nm);
}

/* ********************************************************
 * DBMS 시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_dbmsInfo(){
	document.getElementById("sourceSystem_add").style.display ='block';
	document.getElementById("sourceSystem_mod").style.display ='none';
	$('#pop_layer_dbmsInfo_reg').modal("show");
}

/* ********************************************************
 * 추출 대상 테이블, 추출 제외 테이블 등록 버튼 클릭시
 ******************************************************** */
function fn_tableList(gbn){
	if($('#db2pg_sys_nm').val() == ""){
		showSwalIcon('<spring:message code="migration.msg03" />', '<spring:message code="common.close" />', '', 'error');
		return false;
	}
	if(gbn == 'include'){
		var src_include_table_nm = $('#src_include_table_nm').val();  
	}else{
		var src_exclude_table_nm = $('#src_exclude_table_nm').val();  
	}
	$.ajax({
		url : "/db2pg/popup/tableInfo.do",
		data : {
			src_include_table_nm : src_include_table_nm,
			src_exclude_table_nm : src_exclude_table_nm,
			db2pg_sys_id : $('#db2pg_sys_id').val(),
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
 			document.getElementById("add").style.display ='block';
 			document.getElementById("mod").style.display ='none';
 			document.getElementById("add_data").style.display ='none';
 			document.getElementById("mod_data").style.display ='none';
			$('#pop_layer_tableInfo_reg').modal("show");
		}
	});
}

/* ********************************************************
 * select box control
 ******************************************************** */
 $(function() {
	 $("#src_tables").change(function(){
		 $("#src_include_tables").val("");
		 $("#src_exclude_tables").val("");
		 $("#src_include_table_nm").val("");
		 $("#src_exclude_table_nm").val("");
		    if(this.value=="include"){
		        $("#include").show();
			    $("#exclude").hide(); 
		    }else{
		        $("#exclude").show();
			    $("#include").hide(); 
		    }
		});
 });
 
function fn_tableAddCallback(rowList, tableGbn, totalCnt){
	if(tableGbn == 'include'){
		$('#src_include_tables').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_include_table_nm').val(rowList);
		$('#src_table_total_cnt').val(totalCnt);
	}else{
		$('#src_exclude_tables').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_exclude_table_nm').val(rowList);
		$('#src_table_total_cnt').val(totalCnt);
	}
}
</script>
<form name="frmPopup">
	<input type="hidden" name="db2pg_sys_id"  id="db2pg_sys_id">
	<input type="hidden" name="src_include_table_nm"  id="src_include_table_nm" >
	<input type="hidden" name="src_exclude_table_nm"  id="src_exclude_table_nm" >
	<input type="hidden" name="tableGbn"  id="tableGbn" >
	<input type="hidden" name="src_table_total_cnt" id="src_table_total_cnt">
</form>

<div class="modal fade" id="pop_layer_ddl_reg" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 40px 250px;">
		<div class="modal-content" style="width:1200px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					DDL <spring:message code="common.registory" />
				</h4>
				<div class="card" style="border:0px;max-height:698px;">
					<form class="cmxform" id="ddlRegForm">
						<fieldset>
							<div class="row">
								<div class="col-md-12 system-tlb-scroll" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_name" />
											</label>
											<div class="col-sm-8">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="db2pg_ddl_wrk_nm" name="db2pg_ddl_wrk_nm" onkeyup="fn_checkWord(this,20)" placeholder='20<spring:message code='message.msg188'/>' onblur="this.value=this.value.trim()"/>
											</div>
											<div class="col-sm-2">
												<button type="button" class="btn btn-inverse-danger btn-fw" style="width: 115px;" onclick="fn_check_reg()"><spring:message code="common.overlap_check" /></button>
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:-10px;">
											<label for="ins_dump_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_description" />
											</label>
											<div class="col-sm-10">
												<textarea class="form-control" id="db2pg_ddl_wrk_exp" name="db2pg_ddl_wrk_exp" rows="2" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
											</div>
										</div>
									</div>

									<br/>
									
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-15px;">
											<label for="ins_dump_save_pth" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<spring:message code="migration.source_system" />
											</label>
											<div class="col-sm-6">
												<input type="text" class="form-control form-control-sm" id="db2pg_sys_nm" name="db2pg_sys_nm" readonly="readonly" />
											</div>
											<div class="col-sm-4">
												<div class="input-group input-daterange d-flex align-items-center" >
													<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_dbmsInfo()"><spring:message code="button.create" /></button>
												</div>
											</div>
										</div>
									</div>
									
									<br/>
									
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<h4 class="card-title"><spring:message code="migration.option_information"/></h4>
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<spring:message code="migration.specify_case" />
											</label>
											<div class="col-sm-10">
												<select name="db2pg_uchr_lchr_val" id="db2pg_uchr_lchr_val"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeLetter" items="${codeLetter}">
														<option value="${codeLetter.sys_cd_nm}">${codeLetter.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
										</div>
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<spring:message code="migration.view_table_exclusion" />
											</label>
											<div class="col-sm-10">
												<select name="src_tb_ddl_exrt_tf" id="src_tb_ddl_exrt_tf"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeTF" items="${codeTF}">
														<option value="${codeTF.sys_cd_nm}">${codeTF.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
										</div>
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-15px;">
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" >
												<select name="src_tables" id="src_tables"  class="form-control form-control-xsm" style="margin-right: 1rem; margin-top:-7px;width:130px;">
													<option value="include"><spring:message code="migration.inclusion_table"/></option>
													<option value="exclude"><spring:message code="migration.exclusion_table"/></option>
												</select>
											</label>

											<div id="include" class="form-inline col-sm-10 row">
												<div class="col-sm-5">
													<input type="text" class="form-control form-control-sm" style="width:100%;margin-top:-10px;" name="src_include_tables" id="src_include_tables" readonly="readonly" />
												</div>
												<div class="col-sm-3">
													<button type="button" class="btn btn-inverse-primary btn-fw" style="margin-top:-10px;" onclick="fn_tableList('include')" ><spring:message code="button.create" /></button>
												</div>
												
											</div>
											
											<div id="exclude" style="display: none;" class="form-inline col-sm-10 row">
												<div class="col-sm-5">
													<input type="text" class="form-control form-control-sm" style="width:100%;margin-top:-10px;" name="src_exclude_tables" id="src_exclude_tables" readonly="readonly" />
												</div>
												<div class="col-sm-3">
													<button type="button" class="btn btn-inverse-primary btn-fw" style="margin-top:-10px;" onclick="fn_tableList('exclude')" ><spring:message code="button.create" /></button>
												</div>
											</div>	
										</div>
									</div>
									
									<br/>
									
									<div class="card-body">
										<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0px -20px 0px;" >
											<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button" onclick="fn_insert_work()" value='<spring:message code="common.registory" />' />
											<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.cancel"/></button>
										</div>
									</div>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
