<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <div id="pop_layer_dump" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 30%; height: 750px; overflow: auto; padding: 20px; margin: 0 auto;" id="workinfo">
				<p class="tit" style="margin-bottom: 15px;">WORK 정보
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_dump'), 'off');" style="float: right;"><img src="/images/ico_state_01.png" style="position: fixed;"/></a>
				</p>
				<table border="1" class="list">
					<caption>WORK 정보</caption>						
					<p><h3 style="height: 20px;">기본정보</h3></p>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">백업구분</td>
							<td style="width: 70%; text-align: left" id="d_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">WORK 명</td>
							<td style="width: 70%; text-align: left" id="d_wrk_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">WORK 설명</td>
							<td style="width: 70%; text-align: left" id="d_wrk_exp"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">DataBase</td>
							<td style="width: 70%; text-align: left" id="db_nm"></td>
						</tr>							
						<tr>
							<td style="width: 70px; height: 20px;">저장경로</td>
							<td style="width: 70%; text-align: left" id="save_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">파일포멧</td>
							<td style="width: 70%; text-align: left" id="file_fmt_cd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">압축률</td>
							<td style="width: 70%; text-align: left" id="cprt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">인코딩방식</td>
							<td style="width: 70%; text-align: left" id="encd_mth_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">Rolename</td>
							<td style="width: 70%; text-align: left" id="usr_role_nm"></td>
						</tr>		
						<tr>
							<td style="width: 70px; height: 20px;">파일보관 일수</td>
							<td style="width: 70%; text-align: left" id="d_file_stg_dcnt"></td>
						</tr>			
						<tr>
							<td style="width: 70px; height: 20px;">백업유지 갯수</td>
							<td style="width: 70%; text-align: left" id="d_bck_mtn_ecnt"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"">부가옵션1</h3></p>
				<table border="1" class="list">
					<caption>부가옵션1</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">Sections</td>
							<td style="width: 70%; text-align: left" id="sections"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">Object 형태</td>
							<td style="width: 70%; text-align: left" id="objectType"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">저장여부</td>
							<td style="width: 70%; text-align: left" id="save_yn"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"">부가옵션2</h3></p>
				<table border="1" class="list">
					<caption>부가옵션2</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">쿼리</td>
							<td style="width: 70%; text-align: left" id="query"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">기타</td>
							<td style="width: 70%; text-align: left" id="etc"></td>
						</tr>									
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;"">부가옵션3 - 선택한 Object</h3></p>
				<table border="1" class="list">
					<caption>부가옵션3 - 선택한 Object</caption>
					<tbody>
						<tr>
							<div class="view">
								<div class="tNav" >								
								</div>
							</div>
						</tr>									
					</tbody>
				</table>
				
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_dump'), 'off');"><span>닫기</span></a>
				</div>	
			</div>
		</div><!-- //pop-container -->
	</div>