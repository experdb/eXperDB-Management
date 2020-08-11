<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
    <div id="pop_layer_dump" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 30%; height: 570px; overflow: auto;">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="backup_management.work_info"/>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_dump'), 'off');"><img src="/images/ico_state_01.png"  style="margin-left: 245px;"/></a>
				</p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.work_info"/></caption>							
					<p><h3 style="height: 20px;"><spring:message code="properties.basic_info" /></h3></p>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.bck_div"/></td>
							<td style="width: 70%; text-align: left" id="d_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.work_name" /></td>
							<td style="width: 70%; text-align: left" id="d_wrk_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.work_description" /></td>
							<td style="width: 70%; text-align: left; text-overflow:ellipsis; overflow:hidden; white-space:nowrap;" id="d_wrk_exp"  title="d_wrk_exp"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.database" /></td>
							<td style="width: 70%; text-align: left" id="db_nm"></td>
						</tr>							
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.backup_dir" /></td>
							<td style="width: 70%; text-align: left" id="save_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.file_format" /></td>
							<td style="width: 70%; text-align: left" id="file_fmt_cd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.compressibility" /></td>
							<td style="width: 70%; text-align: left" id="cprt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.incording_method" /></td>
							<td style="width: 70%; text-align: left" id="encd_mth_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.rolename" /></td>
							<td style="width: 70%; text-align: left" id="usr_role_nm"></td>
						</tr>		
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.file_keep_day" /></td>
							<td style="width: 70%; text-align: left" id="d_file_stg_dcnt"></td>
						</tr>			
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.backup_maintenance_count" /></td>
							<td style="width: 70%; text-align: left" id="d_bck_mtn_ecnt"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.add_option" />1</h3></p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.add_option" />1</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.sections" /></td>
							<td style="width: 70%; text-align: left" id="sections"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.object_type" /></td>
							<td style="width: 70%; text-align: left" id="objectType"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.save_yn_choice" /></td>
							<td style="width: 70%; text-align: left" id="save_yn"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.add_option" />2</h3></p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.add_option" />2</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="backup_management.query" /></td>
							<td style="width: 70%; text-align: left" id="query"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;"><spring:message code="common.etc"/></td>
							<td style="width: 70%; text-align: left" id="etc"></td>
						</tr>									
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"><spring:message code="backup_management.add_option" />3</h3></p>
				<table border="1" class="list">
					<caption><spring:message code="backup_management.add_option" />3</caption>
					<tbody>
						<tr>
							<td>
								<div class="view">
									<div class="tNav" >								
									</div>
								</div>
							</td>
						</tr>									
					</tbody>
				</table>
			</div>
		</div><!-- //pop-container -->
	</div>