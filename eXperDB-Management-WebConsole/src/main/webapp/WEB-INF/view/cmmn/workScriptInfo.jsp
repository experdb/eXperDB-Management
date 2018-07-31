<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_script" class="pop-layer">
		<div class="pop-container" style="padding: 0px;">
			<div class="pop_cts" style="width: 55%; height: 600px; overflow: auto; padding: 20px; margin: 0 auto; min-height:0; min-width:0; margin-top: 10%" id="scriptInfo">
				<p class="tit" style="margin-bottom: 15px;">스크립트 실행 명령어
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_script'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="margin-left: 235px;"/></a>
				</p>
				<table class="list" style="border:1px solid #b8c3c6;">
					<caption>스크립트 실행 명령어</caption>
					<tbody>						
							<tr>
								<td>
									<div class="textarea_grp">
										<textarea name="exe_cmd" id="exe_cmd"  style="height: 440px;" maxlength="100"  readonly></textarea>
									</div>
								</td>
							</tr>					
					</tbody>
				</table>
	
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_script'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
				
			</div>
		</div><!-- //pop-container -->
	</div>