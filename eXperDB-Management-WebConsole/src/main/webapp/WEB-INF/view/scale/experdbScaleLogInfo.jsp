<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_log" class="pop-layer">
	<div class="pop-container" style="padding: 0px;">
		<div class="pop_cts" style="width: 50%; height: 450px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="workinfo">
			<p class="tit" style="margin-bottom: 15px;"><spring:message code="menu.scale_execute_hist"/>
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_log'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="position: fixed;"/></a>
			</p>

			<table class="list" style="border:1px solid #b8c3c6;">
				<caption><spring:message code="menu.scale_execute_hist"/></caption>	
				<p><h3 style="height: 20px;"><spring:message code="schedule.detail_view" /></h3></p>

				<tbody>						
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.process_id"/></td>
						<td style="width: 70%;text-align: left;word-break:break-all;" id="d_process_id"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.ipadr"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_ipadr"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.scale_type"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_scale_type_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.wrk_type"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_wrk_type_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.auto_policy_nm"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_auto_policy_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.clusters"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_clusters"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.work_start_time"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_wrk_strt_dtm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.work_end_time"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_wrk_end_dtm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.progress"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_wrk_stat"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="common.status"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_exe_rslt_cd_nm"></td>
					</tr>				
				</tbody>
			</table>
			
		</div>
	</div><!-- //pop-container -->
</div>