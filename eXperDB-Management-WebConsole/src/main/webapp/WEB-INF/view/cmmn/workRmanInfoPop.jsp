<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_rman" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 30%; height: 550px; overflow: auto;">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="backup_management.work_info"/> 
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_rman'), 'off');"><img src="/images/ico_state_01.png" style="margin-left: 245px;"/></a>					
				</p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.work_info"/></caption>					
					<p><h3 style="height: 20px;"><spring:message code="properties.basic_info" /></h3></p>
					<tbody>						
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.bck_div"/></td>
							<td style="width: 110px; text-align: left" id="r_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="etc.etc07"/></td>
							<td style="width: 110px; text-align: left" id="bck_opt_cd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.work_name" /></td>
							<td style="width: 110px; text-align: left" id="r_wrk_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.work_description" /></td>
							<td style="width: 110px; text-align: left" id="r_wrk_exp"></td>
						</tr>							
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.compress" /></td>
							<td style="width: 110px; text-align: left" id="cps_yn"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.backup_log_dir" /></td>
							<td style="width: 110px; text-align: left" id="log_file_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.data_dir" /></td>
							<td style="width: 110px; text-align: left" id="data_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.backup_dir" /></td>
							<td style="width: 110px; text-align: left" id="bck_pth"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.backup_file_option" /></h3></p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.backup_file_option" /></caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.full_backup_file_keep_day" /></td>
							<td style="width: 110px; text-align: left" id="r_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.full_backup_file_maintenance_count" /></td>
							<td style="width: 110px; text-align: left" id="r_bck_mtn_ecnt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.archive_file_keep_day" /></td>
							<td style="width: 110px; text-align: left" id="acv_file_stgdt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.archive_file_maintenance_count" /></td>
							<td style="width: 110px; text-align: left" id="acv_file_mtncnt"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.log_file_option" /></h3></p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.log_file_option" /></caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.log_file_backup_yn" /></td>
							<td style="width: 110px; text-align: left" id="log_file_bck_yn"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.server_log_file_keep_day" /></td>
							<td style="width: 110px; text-align: left" id="r_log_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td style="width: 110px; height: 20px;"><spring:message code="backup_management.server_log_file_maintenance_count" /></td>
							<td style="width: 110px; text-align: left" id="r_log_file_mtn_ecnt"></td>
						</tr>								
					</tbody>
				</table>			
			</div>
		</div><!-- //pop-container -->
	</div>