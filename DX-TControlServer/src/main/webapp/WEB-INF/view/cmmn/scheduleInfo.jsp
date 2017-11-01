<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 20%;">
				<p class="tit" style="margin-bottom: 15px;">스케줄 정보
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><img src="/images/ico_state_01.png" style="margin-left: 252px;"/></a>
				</p>
				<table class="list" style="border:1px solid #99abb0;">
					<caption>스케줄 정보</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">스케줄명</td>
							<td style="width: 70%;" id="scd_nm_info" ></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">스케줄 설명</td>
							<td style="width: 50%;" id="scd_exp_info" ></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행상태</td>
							<td style="width: 70%;" id="scd_cndt_info"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행주기</td>
							<td style="width: 70%;" id="exe_perd_cd_info"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행일자</td>
							<td style="width: 70%;" id="scd_exe_hms"></td>
						</tr>						
					</tbody>
				</table>				
			</div>
		</div><!-- //pop-container -->
	</div>

	
	