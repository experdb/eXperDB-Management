<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : serverKeySet.jsp
	* @Description : serverKeySet 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>
<script>

/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	$("#pnlOldPassword").attr('checked', true);
	$("#pnlChangePassword").attr('checked', true);
});


function fn_pnlOldPassword(){
	var pnlOldPassword = $("#pnlOldPassword").prop("checked");

	if(pnlOldPassword == false){
		$('#txtOldFilePath').prop('disabled', true);
	}else{
		$('#txtOldFilePath').prop('disabled', false);
	}
	
}

function fn_pnlChangePassword(){
	var pnlChangePassword = $("#pnlChangePassword").prop("checked");
	
	if(pnlChangePassword == false){
		$('#new').hide();		
	}else{
		$('#new').show();		
	}
	
}

</script>


<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>서버 마스터키 암호 설정<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>서버 마스터키 암호 설정</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>암호화</li>
					<li>설정</li>
					<li class="on">서버 마스터키 암호 설정</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="cmm_bd">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 5px;" />
								<col style="width: 55px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="pnlOldPassword" name="pnlOldPassword"  onClick="fn_pnlOldPassword();"/> 
												<label for="pnlOldPassword">마스터키 파일 사용</label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">마스터키 위치</th>
									<td><input type="text" class="txt t9" id="txtOldFilePath" name="txtOldFilePath"/><span class="btn btnC_01" style="margin-left: 5px;"><button type="button" class= "btn_type_02" style="margin-right: -60px; margin-top: 0;">찾아보기</button></span></td>
	
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호</th>
									<td><input type="text" class="txt t2" id="txtOldPassword" name="txtOldPassword"/></td>																		
								</tr>
							</tbody>
						</table>
					</div>
				</div>	
							
				<div class="cmm_bd" style="margin-top: 20px;">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 300px;" />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span> <input type="checkbox" id="pnlChangePassword" name="pnlChangePassword" onClick="fn_pnlChangePassword();"/> 
												<label for="pnlChangePassword">서버 마스터키 갱신</label>
											</span>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="cmm_bd" style="margin-top: 10px;" id="new">
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 5px;" />
								<col style="width: 55px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="ico_t2">마스터키 모드</th>
									<td><select class="select t5" id="policyStatus">
											<option value="새로운 마스터키 파일">새로운 마스터키 파일</option>
											<option value="새로운 마스터키 파일">기존 마스터키 파일</option>
											<option value="새로운 마스터키 파일">마스터키 파일 사용 안함</option>
										  </select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">마스터키 위치</th>
									<td><input type="text" class="txt t9" id="policyName" /><span class="btn btnC_01" style="margin-left: 5px;"><button type="button" class= "btn_type_02" style="margin-right: -60px; margin-top: 0;">찾아보기</button></span></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호</th>
									<td><input type="text" class="txt t2" id="txtNewPassword" name="txtNewPassword"/></td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">비밀번호 확인</th>
									<td><input type="text" class="txt t2" id="txtNewPassword2" name="txtNewPassword2"/></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
							
				<div class="btn_type_02">
					<a href="#n" class="btn" onClick="fn_save()"><span>저장</span></a> 
				</div>	
			</div>
		</div>
	</div>
</div>