<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 20%;">
				<p class="tit">스케줄 정보</p>
				<table border="1">
					<caption>스케줄 정보</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">스케줄명</td>
							<td style="width: 70%;"><input type="text" name="scd_nm_info" id="scd_nm_info" style="width: 100%;"/></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">스케줄 설명</td>
							<td style="width: 70%;"><input type="text" name="scd_exp_info" id="scd_exp_info" style="width: 100%;"/></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행상태</td>
							<td style="width: 70%;"><input type="text"  name="scd_cndt_info" id="scd_cndt_info" style="width: 100%;"/></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행주기</td>
							<td style="width: 70%;"><input type="text" name="exe_perd_cd_info" id="exe_perd_cd_info" style="width: 100%;"/></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">실행일자</td>
							<td style="width: 70%;"><input type="text"  name="scd_exe_hms" id="scd_exe_hms" style="width: 100%;"/></td>
						</tr>						
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span>닫기</span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
