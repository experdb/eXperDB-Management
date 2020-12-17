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
	* @Description : ddl추출 수정 화면
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
var output_path ="fail";
$(window.document).ready(function() {
	fn_search_dbmsInfo();

});

/* ********************************************************
 * Validation Check
 ******************************************************** */
function valCheck(){
	if($("#db2pg_ddl_wrk_exp_reg_re").val() == ""){
		showSwalIcon('<spring:message code="message.msg108" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_ddl_wrk_exp_reg_re").focus();
		return false;
	}else if($("#db2pg_sys_id_reg_re").val() == ""){
		showSwalIcon('<spring:message code="migration.msg07" />', '<spring:message code="common.close" />', '', 'error');
		$("#db2pg_sys_id_reg_re").focus();
		return false;
	}else{
		return true;
	}
}

/* ********************************************************
 * output path Validation Check(사용X)
 ******************************************************** */
function fn_pathCheck() {
	var ddl_save_pth = document.getElementById("ddl_save_pth");
	if (ddl_save_pth.value == "") {
		alert("경로를 입력하세요.");
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
				alert('<spring:message code="message.msg100" />');
				output_path = "success";		
			} else {
				alert('<spring:message code="backup_management.invalid_path" />');
				document.getElementById("ddl_save_pth").focus();
			}
		},
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		}
	});	
}

/* ********************************************************
 * 수정 버튼 클릭시
 ******************************************************** */
function fn_update_work(){
	if(valCheck()){
		if($("#src_table_total_cnt_reg_re").val() == ""){
			var src_table_total_cnt_reg_re = 0
		}else{
			var src_table_total_cnt_reg_re = $("#src_table_total_cnt_reg_re").val()
		}

		$.ajax({
			url : "/db2pg/updateDDLWork.do",
		  	data : {
		  		db2pg_ddl_wrk_id : $("#db2pg_ddl_wrk_id_reg_re").val(),
		  		db2pg_ddl_wrk_nm : $("#db2pg_ddl_wrk_nm_reg_re").val().trim(),
		  		db2pg_ddl_wrk_exp : $("#db2pg_ddl_wrk_exp_reg_re").val(),
		  		db2pg_sys_id : $("#db2pg_sys_id_reg_re").val(),
		  		db2pg_uchr_lchr_val : $("#db2pg_uchr_lchr_val_reg_re").val(),
		  		src_tb_ddl_exrt_tf : $("#src_tb_ddl_exrt_tf_reg_re").val(),
		  		src_include_tables : $("#src_include_table_nm_reg_re").val(),
		  		src_exclude_tables : $("#src_exclude_table_nm_reg_re").val(),
		  		src_table_total_cnt : src_table_total_cnt_reg_re,
		  		wrk_id : $("#wrk_id_reg_re").val()
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
					$('#pop_layer_ddl_reg_re').modal("hide");
					selectTab("ddlWork");
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
 function fn_dbmsAddCallback2(db2pg_sys_id,db2pg_sys_nm){
	 $('#db2pg_sys_id_reg_re').val(db2pg_sys_id);
	 $('#db2pg_sys_nm_reg_re').val(db2pg_sys_nm);
}

/* ********************************************************
 * DBMS 시스템 등록 버튼 클릭시
 ******************************************************** */
function fn_dbmsInfo_reg_re(){
	document.getElementById("sourceSystem_add").style.display ='none';
	document.getElementById("sourceSystem_mod").style.display ='block';
	$('#pop_layer_dbmsInfo_reg').modal("show");
}

/* ********************************************************
 * 추출 대상 테이블, 추출 제외 테이블 등록 버튼 클릭시
 ******************************************************** */
function fn_tableList_reg_re(gbn){
	if($('#db2pg_sys_nm_reg_re').val() == ""){
		alert('<spring:message code="migration.msg03"/>');
		return false;
	}
	if(gbn == 'include'){
		var src_include_table_nm_reg_re = $('#src_include_table_nm_reg_re').val();  
	}else{
		var src_exclude_table_nm_reg_re = $('#src_exclude_table_nm_reg_re').val();  
	}
	$.ajax({
		url : "/db2pg/popup/tableInfo.do",
		data : {
			src_include_table_nm : src_include_table_nm_reg_re,
			src_exclude_table_nm : src_exclude_table_nm_reg_re,
			db2pg_sys_id : $('#db2pg_sys_id_reg_re').val(),
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
 			document.getElementById("mod").style.display ='block';
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
	 $("#src_tables_reg_re").change(function(){
		 $("#src_include_tables_reg_re").val("");
		 $("#src_exclude_tables_reg_re").val("");
		 $("#src_include_table_nm_reg_re").val("");
		 $("#src_exclude_table_nm_reg_re").val("");
		    if(this.value=="include"){
		        $("#include_reg_re").show();
			    $("#exclude_reg_re").hide(); 
		    }else{
		        $("#exclude_reg_re").show();
			    $("#include_reg_re").hide(); 
		    }
		});
 });
 
function fn_tableAddCallback2(rowList, tableGbn, totalCnt){
	if(tableGbn == 'include'){
		$('#src_include_tables_reg_re').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_include_table_nm_reg_re').val(rowList);
		$('#src_table_total_cnt_reg_re').val(totalCnt);
	}else{
		$('#src_exclude_tables_reg_re').val("<spring:message code='migration.total_table'/>"+totalCnt+ "<spring:message code='migration.selected_out_of'/>"+rowList.length+"<spring:message code='migration.items'/>");
		$('#src_exclude_table_nm_reg_re').val(rowList);
		$('#src_table_total_cnt_reg_re').val(totalCnt);
	}
}
</script>
<form name="frmPopup_reg_re">
	<input type="hidden" name="db2pg_sys_id_reg_re"  id="db2pg_sys_id_reg_re" >
	<input type="hidden" name="src_include_table_nm_reg_re"  id="src_include_table_nm_reg_re" >
	<input type="hidden" name="src_exclude_table_nm_reg_re"  id="src_exclude_table_nm_reg_re"  >
	<input type="hidden" name="src_table_total_cnt_reg_re" id="src_table_total_cnt_reg_re">
	<input type="hidden" name="tableGbn_reg_re"  id="tableGbn_reg_re" >
</form>
<div class="modal fade" id="pop_layer_ddl_reg_re" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 40px 250px;">
		<div class="modal-content" style="width:1200px; ">		 	 
			<div class="modal-body" style="margin-bottom:-30px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;margin-bottom:10px;">
					DDL <spring:message code="common.modify" />
				</h4>
				<div class="card" style="border:0px;max-height:698px;">
					<form class="cmxform" id="ddlRegReForm">
						<fieldset>
							<div class="row">
								<div class="col-md-12 system-tlb-scroll" style="border:0px;height: 570px; overflow-x: hidden;  overflow-y: auto; ">
									<div class="card-body" style="border: 1px solid #adb5bd;">
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;">
											<label for="ins_dump_wrk_nm" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_name" />
											</label>
											<div class="col-sm-10">
												<input type="text" class="form-control form-control-sm" maxlength="20" id="db2pg_ddl_wrk_nm_reg_re" name="db2pg_ddl_wrk_nm_reg_re" onkeyup="fn_checkWord(this,20)" onblur="this.value=this.value.trim()" readonly="readonly"/>
												<input type="hidden" name="wrk_id_reg_re" id="wrk_id_reg_re">
												<input type="hidden" name="db2pg_ddl_wrk_id_reg_re" id="db2pg_ddl_wrk_id_reg_re">
											</div>
										</div>
		
										<div class="form-group row div-form-margin-z" style="margin-bottom:-10px;">
											<label for="ins_dump_wrk_exp" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<i class="item-icon fa fa-dot-circle-o"></i>
												<spring:message code="common.work_description" />
											</label>
											<div class="col-sm-10">
												<textarea class="form-control" id="db2pg_ddl_wrk_exp_reg_re" name="db2pg_ddl_wrk_exp_reg_re" rows="2" maxlength="25" onkeyup="fn_checkWord(this,25)" placeholder="25<spring:message code='message.msg188'/>"></textarea>
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
												<input type="text" class="form-control form-control-sm" id="db2pg_sys_nm_reg_re" name="db2pg_sys_nm_reg_re" readonly="readonly" />
											</div>
											<div class="col-sm-4">
												<div class="input-group input-daterange d-flex align-items-center" >
													<button type="button" class="btn btn-inverse-info btn-fw" style="width: 115px;" onclick="fn_dbmsInfo_reg_re()"><spring:message code="button.create" /></button>
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
												<select name="db2pg_uchr_lchr_val_reg_re" id="db2pg_uchr_lchr_val_reg_re"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
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
												<select name="src_tb_ddl_exrt_tf_reg_re" id="src_tb_ddl_exrt_tf_reg_re"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<c:forEach var="codeTF" items="${codeTF}">
														<option value="${codeTF.sys_cd_nm}">${codeTF.sys_cd_nm}</option>
													</c:forEach>
												</select>
											</div>
										</div>
										<div class="form-group row div-form-margin-z" style="margin-top:-10px;margin-bottom:-15px;">
											<label for="ins_dump_cprt" class="col-sm-2 col-form-label pop-label-index" style="padding-top:7px;">
												<select name="src_tables_reg_re" id="src_tables_reg_re"  class="form-control form-control-xsm" style="margin-right: 1rem;width:130px;">
													<option value="include"><spring:message code="migration.inclusion_table"/></option>
													<option value="exclude"><spring:message code="migration.exclusion_table"/></option>
												</select>
											</label>

											<div id="include_reg_re" class="form-inline col-sm-10 row">
												<div class="col-sm-5">
													<input type="text" class="form-control form-control-sm" style="width:100%;margin-top:-10px;" name="src_include_tables_reg_re" id="src_include_tables_reg_re" readonly="readonly" />
												</div>
												<div class="col-sm-3">
													<button type="button" class="btn btn-inverse-primary btn-fw" style="margin-top:-10px;" onclick="fn_tableList_reg_re('include')" ><spring:message code="button.create" /></button>
												</div>
											</div>
											
											<div id="exclude_reg_re" style="display: none;" class="form-inline col-sm-10 row">
												<div class="col-sm-5">
													<input type="text" class="form-control form-control-sm" style="width:100%;margin-top:-10px;" name="src_exclude_tables_reg_re" id="src_exclude_tables_reg_re" readonly="readonly" />
												</div>
												<div class="col-sm-3">
													<button type="button" class="btn btn-inverse-primary btn-fw" style="margin-top:-10px;" onclick="fn_tableList_reg_re('exclude')" ><spring:message code="button.create" /></button>
												</div>
											</div>	
										</div>
									</div>
									
									<br/>
									
									<div class="card-body">
										<div class="top-modal-footer" style="text-align: center !important; margin: -20px 0px -20px 0px;" >
											<input class="btn btn-primary" width="200px;" style="vertical-align:middle;" type="button" onclick="fn_update_work()" value='<spring:message code="common.modify" />' />
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
