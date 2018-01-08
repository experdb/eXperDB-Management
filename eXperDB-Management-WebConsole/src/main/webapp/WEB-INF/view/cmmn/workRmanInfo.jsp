<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_rman" class="pop-layer">
		<div class="pop-container" style="padding: 0px;">
			<div class="pop_cts" style="width: 35%; height: 730px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0;" id="workinfo">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="backup_management.work_info"/>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_rman'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="margin-left: 235px;"/></a>
				</p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.work_info"/></caption>
					<colgroup>
						<col style="width:30%;" />
						<col style="width:70%;" />
					</colgroup>
							
					<p><h3 style="height: 20px;"><spring:message code="properties.basic_info" /></h3></p>
					<tbody>						
						<tr>
							<td><spring:message code="backup_management.bck_div"/></td>
							<td style="text-align: left" id="r_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.backup_option"/></td>
							<td style="text-align: left" id="bck_opt_cd_nm"></td>
						</tr>	
						<tr>
							<td><spring:message code="common.work_name" /></td>
							<td style="text-align: left" id="r_wrk_nm"></td>
						</tr>	
						<tr>
							<td><spring:message code="common.work_description" /></td>
							<td style="text-align: left" id="r_wrk_exp" ></td>
						</tr>							
						<tr>
							<td><spring:message code="backup_management.compress" /></td>
							<td style="text-align: left" id="cps_yn"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.backup_log_dir" /></td>
							<td style="text-align: left" id="log_file_pth"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.data_dir" /></td>
							<td style="text-align: left" id="data_pth"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.backup_dir" /></td>
							<td style="text-align: left" id="bck_pth"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.backup_file_option" /></h3></p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.backup_file_option" /></caption>
					<colgroup>
						<col style="width:30%;" />
						<col style="width:70%;" />
					</colgroup>
					<tbody>
						<tr>
							<td><spring:message code="backup_management.full_backup_file_keep_day" /></td>
							<td style="text-align: left" id="r_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.full_backup_file_maintenance_count" /></td>
							<td style="text-align: left" id="r_bck_mtn_ecnt"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.archive_file_keep_day" /></td>
							<td style="text-align: left" id="acv_file_stgdt"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.archive_file_maintenance_count" /></td>
							<td style="text-align: left" id="acv_file_mtncnt"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.log_file_option" /></h3></p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.log_file_option" /></caption>
					<colgroup>
						<col style="width:30%;" />
						<col style="width:70%;" />
					</colgroup>
					<tbody>
						<tr>
							<td><spring:message code="backup_management.log_file_backup_yn" /></td>
							<td style="text-align: left" id="log_file_bck_yn"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.server_log_file_keep_day" /></td>
							<td style="text-align: left" id="r_log_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td><spring:message code="backup_management.server_log_file_maintenance_count" /></td>
							<td style="text-align: left" id="r_log_file_mtn_ecnt"></td>
						</tr>								
					</tbody>
				</table>		
				
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_rman'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>		
			</div>
		</div><!-- //pop-container -->
	</div>