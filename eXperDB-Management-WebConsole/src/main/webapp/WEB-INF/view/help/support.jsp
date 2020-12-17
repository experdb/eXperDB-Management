<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="modal fade" id="pop_layer_support" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog  modal-xl-top" role="document">
		<div class="modal-content">
			<div class="top-modal-header">
				<img src="../../login/img/help.png" alt="eXperDB" style="width :350px; margin: 0 0px 0 auto; display: block; "> 
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="table-responsive">
					<h3 class="modal-title" id="ModalLabel" style="padding-left:25px;background:url(../../images/popup/ico_p_1.png) 4px 50% no-repeat;">Support</h3>
					<table class="table">
						<colgroup>
							<col style="width: 170px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="t1"><spring:message code="help.support.title.company"/></th>
 								<td id="version" style="border : 0 none;"><spring:message code="help.support.company"/></td>
							</tr>
 							<tr>
								<th class="t1"><spring:message code="help.support.title.solution"/></th>
								<td style="border : 0 none;"><spring:message code="help.support.solution"/></td>
							</tr>
 							<tr>
								<th class="t1"><spring:message code="help.support.title.address"/></th>
								<td style="border : 0 none;"><spring:message code="help.support.address"/></td>
							</tr>
 							<tr>
								<th class="t1"><spring:message code="help.support.title.tel"/></th>
								<td style="border : 0 none;"><spring:message code="help.support.tel"/></td>
							</tr>
 							<tr>
								<th class="t1"><spring:message code="help.support.title.fax"/></th>
								<td style="border : 0 none;"><spring:message code="help.support.fax"/></td>
							</tr>
 							<tr>
								<th class="t1"><spring:message code="help.support.title.homepage"/></th>
								<td style="border : 0 none;"><spring:message code="help.support.homepage"/></td>
							</tr>
 							
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="top-modal-footer" style="text-align: center !important;">
				<button type="button" class="btn btn-light" data-dismiss="modal"><spring:message code="common.close"/></button>
			</div>
		</div>
	</div>
</div>