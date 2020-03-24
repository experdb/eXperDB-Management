<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div id="pop_layer" class="pop-layer">
		<div class="pop-container" style="padding: 0px;">
			<div class="pop_cts" style="width: 70%; height: 720px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="workinfo">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="menu.scale_information"/>(<span id ="d_name"></span>)
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="position: fixed;"/></a>
				</p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption><spring:message code="backup_management.work_info"/></caption>
					<tbody>
 						<tr>
							<td style="width: 17%;word-break:break-all;"><spring:message code="scale_management.instance_id" /></td>
							<td style="width: 33%;text-align: left;word-break:break-all;" id="d_instance_id"></td>
							<td style="width: 17%;word-break:break-all;"><spring:message code="scale_management.public_IPv4" /></td>
							<td style="width: 33%;text-align: left;word-break:break-all;" id="d_public_IPv4"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.instance_state" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_instance_status_name"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.IPv4_public_ip" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_IPv4_public_ip"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.instance_type" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_instance_type"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.IPv6_ip" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_IPv6_ip"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.state_reason" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_state_reason" colspan="3"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.private_dns_name" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_private_dns_name"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.availability_zone" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_availability_zone"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.private_ip_address" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_private_ip_address"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.security_group" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_security_group"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.vpc_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_vpc_id"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.subnet_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_subnet_id"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.network_interfaces" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_network_interfaces"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.keyname" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_key_name"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.source_dest_check" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_source_dest_check"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.product_code" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_productcodeid"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.ebs_optimized" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_ebs_optimized"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.owner" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_owner"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.root_device_type" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_root_device_type"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.start_time" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_start_time"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.root_device_name" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_root_device_name"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.monitoring" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_monitoring"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.block_device_name" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_block_device_name"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.virtualization_type" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_virtualization_type"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.capacity_reservation_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_capacity_reservation_id"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.reservation_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_reservation_id"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.cct_revt_spect_re_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_cct_revt_spect_re_id"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.ami_launch_index" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_ami_launch_index"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.image_id" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_image_id"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.tenancy" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_tenancy"></td>
						</tr>
						<tr>
							<td style="word-break:break-all;"><spring:message code="scale_management.hiber_configured" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_hiber_configured"></td>
							<td style="word-break:break-all;"><spring:message code="scale_management.core_count" /></td>
							<td style="text-align: left;word-break:break-all;" id="d_core_count"></td>
						</tr>					
					</tbody>
				</table>

				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>	
			</div>
		</div><!-- //pop-container -->
	</div>