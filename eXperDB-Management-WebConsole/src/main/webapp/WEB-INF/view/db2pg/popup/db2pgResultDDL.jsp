<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%
	/**
	* @Class Name : db2pgResultDDL.jsp
	* @Description : db2pgResultDDL 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.11.29     최초 생성
	*  2020.08.21   변승우 과장		UI 디자인 변경
	*
	* author 김주영 사원
	* since 2019.11.29
	*
	*/
%>


<script>

var tableDdlResult = null;

function fn_ddlResultInit() {
	tableDdlResult = $('#ddlResult').DataTable({
		scrollY : "245px",
		scrollX : true,
		bDestroy: true,
		processing : true,
		searching : false,	
		bSort: false,
		columns : [
		{data : "idx",  className : "dt-center", defaultContent : ""}, 
		{data : "name", className : "dt-center", defaultContent : ""},
		{data : "path", className : "dt-left", defaultContent : ""},
		{data : "size", className : "dt-center", defaultContent : ""},
		{data : "date", className : "dt-center", defaultContent : ""},
		{
			data : "idx",
			className : "dt-center",
			render : function(data, type, full, meta) {				
				var html = "";
				html += '<button type="button" class="btn btn-success btn-icon-text" onclick="fn_download(\''+full.name+'\',\''+full.path+'/\')">';
				html += "	<i class='ti-download btn-icon-prepend' >";
				html += '&nbsp;<spring:message code='migration.download' /></i>';
				html += "</button>";		
				return html;
			},
			defaultContent : ""
		}
		]
	});
		
	tableDdlResult.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
	tableDdlResult.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
	tableDdlResult.tables().header().to$().find('th:eq(2)').css('min-width', '300px');
	tableDdlResult.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	tableDdlResult.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
	tableDdlResult.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		
		$(window).trigger('resize'); 
}



/* ********************************************************
 * DDL 수행이력 파일정보 데이터 가져오기
 ******************************************************** */
function getDataResultList(ddl_save_pth){
	$.ajax({
		url : "/db2pg/selectdb2pgResultDDLFile.do", 
	  	data : {
	  		ddl_save_pth : ddl_save_pth
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
			if(data.length > 0){
				tableDdlResult.clear().draw();
				tableDdlResult.rows.add(data).draw();
			}else{
				tableDdlResult.clear().draw();
			}
		}
	});
}

/* ********************************************************
 *파일 다운로드
 ******************************************************** */
function fn_download(name,path){
	location.href="/db2pg/popup/db2pgFileDownload.do?name="+name+"&&path="+path;
}
</script>


<%@include file="../../cmmn/commonLocale.jsp"%>



<div class="modal fade" id="pop_layer_db2pgResultDDL" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" >
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					DDL <spring:message code="migration.performance_history"/> <spring:message code="schedule.detail_view"/>			
				</h4>													
						<div class="tab-content" id="pills-tabContent" style="border: 0; height:700px;">			
							<div class="card card-inverse-info" >
								<i class="mdi mdi-blur" style="margin-left: 10px;"><spring:message code="migration.job_information"/> </i>
							</div>
									<div class="tab-pane fade show active" role="tabpanel" >
										<form class="cmxform" id="baseForm">											
											<fieldset>
												<div class="card-body" style="border:1px solid #adb5bd;">
													<div class="table-responsive">
														<table id="connectModPopList" class="table system-tlb-scroll" style=" border: 1px solid #adb5bd; width:100%;">
															<colgroup>
																<col style="width: 15%;" />
																<col style="width: 85%;" />
															</colgroup>
															<tbody>
																<tr>
																	<td class="bg-info text-white"><spring:message code="common.work_name" /></td>
																	<td style="text-align: left"><div id="ddl_result_wrk_nm" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="common.work_description" /></td>
																	<td style="text-align: left"><div id="ddl_result_wrk_exp" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="migration.result"/></td>
																	<td style="text-align: left">			
																		<div id="ddl_result_exe_rslt_cd" >	</div>					
																	</td>
																</tr> 
															</tbody>
														</table>
													</div>
												</div>
											</fieldset>
									</form>	
								</div>
								<br><br>
								<div class="card card-inverse-info" >
									<i class="mdi mdi-blur" style="margin-left: 10px;"><spring:message code="migration.file_information"/> </i>
								</div>
								 <div class="tab-content" id="pills-tabContent" style="border: 1px solid #adb5bd; height:435px;">
										<table id="ddlResult" class="table table-hover table-striped system-tlb-scroll" style="width:100%;">
											<thead>
												<tr class="bg-info text-white">
													<th width="30"><spring:message code="common.no" /></th>
													<th width="200" class="dt-center"><spring:message code="migration.file_name"/></th>
													<th width="300" class="dt-center"><spring:message code="migration.path"/></th>
													<th width="100" class="dt-center"><spring:message code="backup_management.size" /></th>
													<th width="200" class="dt-center"><spring:message code="migration.creation_date"/></th>
													<th width="100" class="dt-center"><spring:message code="migration.download"/></th>
												</tr>
											</thead>
										</table>
								</div>		
															
						</div>				
					</div>				
						<div class="top-modal-footer" style="text-align: center !important; margin: -15px 0 0 -20px;" >
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
						</div>				
				</div>
			</div>
		</div> 






