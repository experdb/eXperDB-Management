<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="pop_layer_rman" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 30%; height: 550px; overflow: auto;">
				<p class="tit" style="margin-bottom: 15px;">WORK 정보 
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_rman'), 'off');"><img src="/images/ico_state_01.png" style="margin-left: 245px;"/></a>					
				</p>
				<table border="1" class="list">
					<caption>WORK 정보</caption>					
					<p><h3 style="height: 20px;">기본정보</h3></p>
					<tbody>						
						<tr>
							<td style="width: 70px; height: 20px;">백업구분</td>
							<td style="width: 110px; text-align: left" id="r_bck_bsn_dscd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">백업업무구분</td>
							<td style="width: 110px; text-align: left" id="bck_opt_cd_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">WORK 명</td>
							<td style="width: 110px; text-align: left" id="r_wrk_nm"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">WORK 설명</td>
							<td style="width: 110px; text-align: left" id="r_wrk_exp"></td>
						</tr>							
						<tr>
							<td style="width: 70px; height: 20px;">압축여부</td>
							<td style="width: 110px; text-align: left" id="cps_yn"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">로그경로</td>
							<td style="width: 110px; text-align: left" id="log_file_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">데이터경로</td>
							<td style="width: 110px; text-align: left" id="data_pth"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">백업경로</td>
							<td style="width: 110px; text-align: left" id="bck_pth"></td>
						</tr>						
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;">백업파일옵션</h3></p>
				<table border="1" class="list">
					<caption>백업파일옵션</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">FULL백업파일 보관일</td>
							<td style="width: 110px; text-align: left" id="r_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">FULL백업파일 유지갯수</td>
							<td style="width: 110px; text-align: left" id="r_bck_mtn_ecnt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">아카이브파일 보관일</td>
							<td style="width: 110px; text-align: left" id="acv_file_stgdt"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">아카이브파일 유지갯수</td>
							<td style="width: 110px; text-align: left" id="acv_file_mtncnt"></td>
						</tr>							
					</tbody>
				</table>
				
				<p><h3 style="height: 20px; margin-top: 25px;">로그파일 옵션</h3></p>
				<table border="1" class="list">
					<caption>로그파일 옵션</caption>
					<tbody>
						<tr>
							<td style="width: 70px; height: 20px;">로그파일 백업여부</td>
							<td style="width: 110px; text-align: left" id="log_file_bck_yn"></td>
						</tr>	
						<tr>
							<td style="width: 70px; height: 20px;">서버로그파일 보관일</td>
							<td style="width: 110px; text-align: left" id="log_file_stg_dcnt"></td>
						</tr>	
						<tr>
							<td style="width: 110px; height: 20px;">서버로그파일 유지갯수</td>
							<td style="width: 110px; text-align: left" id="log_file_mtn_ecnt"></td>
						</tr>								
					</tbody>
				</table>			
			</div>
		</div><!-- //pop-container -->
	</div>