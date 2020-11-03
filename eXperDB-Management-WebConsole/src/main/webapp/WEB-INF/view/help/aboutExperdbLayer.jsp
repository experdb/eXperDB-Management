<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div id="pop_layer_aboutExperdb" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-xl-top" role="document">
		<div class="modal-content">		
			<div class="top-modal-header">
				<img src="../../login/img/help.png" alt="eXperDB" style="width :350px; margin: 0 0px 0 auto; display: block; "> 
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>				
			</div>

			<div class="modal-body">
				<div class="table-responsive">
					<h3 class="modal-title" id="ModalLabel" style="padding-left:25px;background:url(../../images/popup/ico_p_1.png) 4px 50% no-repeat;">About eXperDB</h3>
					<table class="table">
						<colgroup>
							<col style="width: 170px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="t1">Version</th>
 								<td id="version" style="border : 0 none;">123</td>
							</tr>
 							<tr>
								<th class="t1">Copyright</th>
								<td style="border : 0 none;">2020, The eXperDB-Management Development Team</td>
							</tr>
 							<tr>
								<th class="t2" rowspan="3">Community</th>
								<td style="border : 0 none;"><a href="https://github.com/experdb/eXperDB-Management" target="_blank">https://github.com/experdb/eXperDB-Management</a></td>
							</tr>
 							<tr>
								<td style="border : 0 none;"><a href="https://www.facebook.com/experdb" target="_blank">https://www.facebook.com/experdb</a></td>
							</tr>
 							<tr>
								<td style="border : 0 none;"><a href="http://cafe.naver.com/psqlmaster" target="_blank">http://cafe.naver.com/psqlmaster</a></td>
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