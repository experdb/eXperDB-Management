<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_scale" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document" style="margin: 100px 150px;">
		<div class="modal-content" style="width:1400px;">		 	 
			<div class="modal-body" style="margin-bottom:-40px;">
				<h4 class="modal-title mdi mdi-alert-circle text-info" id="ModalLabel" style="padding-left:5px;cursor:pointer;" data-dismiss="modal">
					<spring:message code="menu.scale_information"/>(<span id ="d_name"></span>)
				</h4>

				<div class="card" style="border:0px;">
					<div class="card-body-modal">
						<!-- title -->
						<h3 class="card-title fa fa-dot-circle-o">
							<spring:message code="schedule.detail_view" />
						</h3>
				
						<div class="table-responsive system-tlb-scroll" style="overflow:auto;max-height: 465px; ">
							<table class="table table-striped">
								<tbody>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.instance_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_instance_id"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.public_IPv4"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_public_IPv4"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.instance_state"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_instance_status_name"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.IPv4_public_ip"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_IPv4_public_ip"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.instance_type"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_instance_type"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.IPv6_ip"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_IPv6_ip"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.state_reason"/>
										</td>
										<td colspan="3" style="width: 73%; word-break:break-all;" id="d_state_reason"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.private_dns_name"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_private_dns_name"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.availability_zone"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_availability_zone"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.private_ip_address"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_private_ip_address"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.security_group"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_security_group"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.vpc_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_vpc_id"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.subnet_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_subnet_id"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.network_interfaces"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_network_interfaces"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.keyname"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_key_name"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.source_dest_check"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_source_dest_check"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.product_code"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_productcodeid"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.ebs_optimized"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_ebs_optimized"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.owner"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_owner"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.root_device_type"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_root_device_type"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.start_time"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_start_time"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.root_device_name"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_root_device_name"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.monitoring"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_monitoring"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.block_device_name"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_block_device_name"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.virtualization_type"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_virtualization_type"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.capacity_reservation_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_capacity_reservation_id"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.reservation_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_reservation_id"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.cct_revt_spect_re_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_cct_revt_spect_re_id"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.ami_launch_index"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_ami_launch_index"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.image_id"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_image_id"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.tenancy"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_tenancy"></td>
									</tr>
									<tr>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.hiber_configured"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_hiber_configured"></td>
										<td class="py-1" style="width: 17%; word-break:break-all;">
											<spring:message code="eXperDB_scale.core_count"/>
										</td>
										<td style="width: 33%; word-break:break-all;" id="d_core_count"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>