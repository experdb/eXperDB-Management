<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
    <div id="pop_layer_dump" class="pop-layer">
		<div class="pop-container" style="padding: 0px;">
			<div class="pop_cts" style="width: 35%; height: 750px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0;" id="workinfo">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="backup_management.work_info"/>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_dump'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="position: fixed;"/></a>
				</p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.work_info"/></caption>						
					<p><h3 style="height: 20px;"><spring:message code="properties.basic_info" /></h3></p>
					<tbody>
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.bck_div"/></td>
							<td style="text-align: left" id="d_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="common.work_name" /></td>
							<td style="text-align: left" id="d_wrk_nm"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="common.work_description" /></td>
							<td style="text-align: left" id="d_wrk_exp"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="common.database" /></td>
							<td style="text-align: left" id="db_nm"></td>
						</tr>							
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.backup_dir" /></td>
							<td style="text-align: left" id="save_pth"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.file_format" /></td>
							<td style="text-align: left" id="file_fmt_cd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.compressibility" /></td>
							<td style="text-align: left" id="cprt"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.incording_method" /></td>
							<td style="text-align: left" id="encd_mth_nm"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.rolename" /></td>
							<td style="text-align: left" id="usr_role_nm"></td>
						</tr>		
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.file_keep_day" /></td>
							<td style="text-align: left" id="d_file_stg_dcnt"></td>
						</tr>			
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.backup_maintenance_count" /></td>
							<td style="text-align: left" id="d_bck_mtn_ecnt"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;""><spring:message code="backup_management.add_option" />1</h3></p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.add_option" />1</caption>
					<tbody>
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.sections" /></td>
							<td style="text-align: left" id="sections"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.object_type" /></td>
							<td style="text-align: left" id="objectType"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.save_yn_choice" /></td>
							<td style="text-align: left" id="save_yn"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.add_option" />2</h3></p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.add_option" />2</caption>
					<tbody>
						<tr>
							<td style="width: 170px;"><spring:message code="backup_management.query" /></td>
							<td style="text-align: left" id="query"></td>
						</tr>	
						<tr>
							<td style="width: 170px;"><spring:message code="common.etc"/></td>
							<td style="text-align: left" id="etc"></td>
						</tr>									
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.add_option" />3 - <spring:message code="backup_management.object_choice" /></h3></p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.add_option" />3 - <spring:message code="backup_management.object_choice" /></caption>
					<tbody>
						<tr>
							<div class="view">
								<div class="tNav" >								
								</div>
							</div>
						</tr>									
					</tbody>
				</table>
				
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_dump'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>	
			</div>
		</div><!-- //pop-container -->
	</div>