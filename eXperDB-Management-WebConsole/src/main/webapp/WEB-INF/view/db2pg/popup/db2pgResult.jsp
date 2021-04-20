<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	/**
	* @Class Name : db2pgHistory.jsp
	* @Description : db2pgHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.11.06     최초 생성
	*  2020.08.24   변승우 과장		UI 디자인 변경
	*
	* author 김주영 사원
	* since 2019.11.06
	*
	*/
%>
<script>
/* ********************************************************
 *파일 다운로드
 ******************************************************** */
function fn_dn_report(path){
	location.href="/db2pg/popup/db2pgFileDownload.do?name=report.html&path="+path;
}
</script>

<div class="modal fade" id="pop_layer_db2pgResult" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 350px;">
		<div class="modal-content" style="width:1000px;">		 
			<div class="modal-body" >
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;">
					Migration <spring:message code="migration.performance_history"/> <spring:message code="schedule.detail_view"/>		
				</h4>													
						<div class="tab-content" id="pills-tabContent" style="border:0; height:650px;">			
							<div class="card card-inverse-info" >
								<i class="mdi mdi-blur" style="margin-left: 10px;"><spring:message code="migration.job_information"/> </i>
							</div>
									<div class="tab-pane fade show active" role="tabpanel" >
										<form class="cmxform" id="baseForm">											
											<fieldset>
												<div class="card-body" style="border: 1px solid #adb5bd;">
													<div class="table-responsive">
														<table id="connectModPopList" class="table system-tlb-scroll" style=" border: 1px solid #adb5bd; width:100%;">
															<colgroup>
																<col style="width: 15%;" />
																<col style="width: 85%;" />
															</colgroup>
															<tbody>
																<tr>
																	<td class="bg-info text-white"><spring:message code="common.work_name" /></td>
																	<td style="text-align: left"><div id="mig_result_wrk_nm" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="common.work_description" /></td>
																	<td style="text-align: left"><div id="mig_result_wrk_exp" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="schedule.work_start_datetime" /></td>
																	<td style="text-align: left"><div id="mig_result_wrk_strt_dtm" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="schedule.work_end_datetime" /></td>
																	<td style="text-align: left"><div id="mig_result_wrk_end_dtm" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="schedule.jobTime" /></td>
																	<td style="text-align: left"><div id="mig_result_wrk_dtm" ></div></td>
																</tr>
																<tr>
																	<td class="bg-info text-white"><spring:message code="schedule.result" /></td>
																	<td style="text-align: left"><div id="mig_result_exe_rslt_cd" ></div>																
																	</td>
																</tr>
																<tr>
																	<td style="text-align: center" colspan="2"><div id="mig_result_exe_rslt_report" ></div></td>
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
									<i class="mdi mdi-blur" style="margin-left: 10px;"><spring:message code="backup_management.job_log_info"/> </i>
								</div>
								 <div class="tab-content" id="pills-tabContent" style="border: 1px solid #adb5bd; height:250px;">
									<div class="tab-pane fade show active" role="tabpanel" >
										<form class="cmxform" id="migSubForm">
											<fieldset>																			
												<textarea name="mig_result_msg" id="mig_result_msg" style="height: 200px; width: 100%;" readonly="readonly" ></textarea>
											</fieldset>
										</form>	
									</div>
								</div>		
															
						</div>				
					</div>				
						<div class="top-modal-footer" style="text-align: center !important; margin: -15px 0 0 -20px;" >
								<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
						</div>				
				</div>
			</div>
		</div> 





