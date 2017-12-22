<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
  <!--  popup -->
	<div id="pop_layer_wrkLog" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 60%; margin: 0 auto; min-height:0; min-width:0;">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="backup_management.job_log_info"/></p>
				<table class="write" border="0">
					<caption><spring:message code="backup_management.job_log_info"/></caption>
					<tbody>
						<tr>
							<td><textarea name="wrkLogInfo" id="wrkLogInfo" style="height: 250px;" readonly="readonly"> </textarea></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_wrkLog'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
