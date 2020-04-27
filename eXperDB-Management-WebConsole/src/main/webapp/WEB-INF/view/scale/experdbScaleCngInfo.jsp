<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_cng" class="pop-layer">
	<div class="pop-container" style="padding: 0px;">
		<div class="pop_cts" style="width: 50%; height: 530px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="workinfo">
			<p class="tit" style="margin-bottom: 15px;"><spring:message code="menu.eXperDB_scale_settings"/>
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_cng'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="position: fixed;"/></a>
			</p>

			<table class="list" style="border:1px solid #b8c3c6;">
				<caption><spring:message code="menu.scale_execute_hist"/></caption>	
				<p><h3 style="height: 20px;"><spring:message code="schedule.detail_view" /></h3></p>

				<tbody>	
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.scale_type"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_scale_type_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.policy_type"/></td>
						<td style="width: 70%;text-align: left;word-break:break-all;" id="d_policy_type_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.policy_time_div"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_auto_policy_set_div_nm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.policy_time"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_auto_policy_time"></td>
					</tr>
					<tr>
						<td style="width: 30px; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.target_value"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_level"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.execute_type"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_execute_type_nm"></td>
					</tr>
					<tr>
						<td style="width: 30px; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.expansion_clusters"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_expansion_clusters"></td>
					</tr>	
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.min_clusters"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_min_clusters"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="eXperDB_scale.max_clusters"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_max_clusters"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="common.register"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_frst_regr_id"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="common.regist_datetime"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_frst_reg_dtm"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="common.modifier"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_lst_mdfr_id"></td>
					</tr>
					<tr>
						<td style="width: 30%; height: 20px;word-break:break-all;"><spring:message code="common.modify_datetime"/></td>
						<td style="width: 70%; text-align: left;word-break:break-all;" id="d_lst_mdf_dtm"></td>
					</tr>
				</tbody>
			</table>
			
		</div>
	</div><!-- //pop-container -->
</div>