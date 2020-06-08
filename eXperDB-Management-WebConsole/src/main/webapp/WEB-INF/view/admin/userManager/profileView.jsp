<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_profileView" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">			 
			<div class="modal-body">
				<h3 class="modal-title" id="ModalLabel" style="padding-left:25px;background:url(../../images/popup/ico_p_1.png) 4px 50% no-repeat;">Profile</h3>
  
				<div class="border-bottom text-center pb-4">
					<img src="/images/icons8-admin-settings-male-100.png" alt="profile" class="img-lg rounded-circle mb-3"/>
					<div class="mb-3">
						<h3 id="pro_name"></h3> <!-- 이름 -->
					</div>
					<p class="clearfix">
						<span class="float-left font-weight-bolder">
							<spring:message code="common.login_time"/>
						</span>
						<span class="float-right text-muted profile_bText" id="pro_lgi_dtm">
						</span>
					</p>
				</div>

				<div class="border-bottom py-4">
					<p class="clearfix"> <!-- 소속 -->
						<span class="float-left">
							<spring:message code="user_management.company" />
						</span>
						<span class="float-right text-muted" id="pro_bln_nm"></span>
					</p>
					<p class="clearfix"> <!-- 부서 -->
						<span class="float-left">
							<spring:message code="history_management.department" />
						</span>
						<span class="float-right text-muted" id="pro_dept_nm"></span>
					</p>
					<p class="clearfix"> <!-- 직급 -->
						<span class="float-left">
							<spring:message code="user_management.position" />
						</span>
						<span class="float-right text-muted" id="pro_pst_nm"></span>
					</p>
					<p class="clearfix"> <!-- 휴대전화번호 -->
						<span class="float-left">
							<spring:message code="user_management.mobile_phone_number" />
						</span>
						<span class="float-right text-muted" id="pro_cpn"></span>
					</p>
					<p class="clearfix"> <!-- 담당업무 -->
						<span class="float-left">
							<spring:message code="user_management.Responsibilities" />
						</span>
						<span class="float-right text-muted" id="pro_rsp_bsn_nm"></span>
					</p>
					<p class="clearfix"> <!-- 사용만료일 -->
						<span class="float-left">
							<spring:message code="user_management.expiration_date" />
						</span>
						<span class="float-right text-muted" id="pro_usr_expr_dt"></span>
					</p>
					<p class="clearfix"> <!-- 암호화사용여부 -->
						<span class="float-left">
							<spring:message code="user_management.encp_use_yn" />
						</span>
						<span class="float-right text-muted" id="pro_encp_use_yn"></span>
					</p>
				</div>   
			</div>
			
			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>