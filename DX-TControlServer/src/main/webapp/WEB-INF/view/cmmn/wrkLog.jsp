<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

  <!--  popup -->
	<div id="pop_layer_wrkLog" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 800px; height: 400px; margin-right: 450px;">
				<p class="tit" style="margin-bottom: 15px;">작업로그 정보</p>
				<table class="write" border="">
					<caption>작업로그 정보</caption>
					<tbody>
						<tr>
							<td name="wrkLogInfo" id="wrkLogInfo" style="height: 270px;"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_wrkLog'), 'off');"><span>취소</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
