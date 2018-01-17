<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : securityPolicyOptionSet.jsp
	* @Description : securityPolicyOptionSet 화면
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
	fn_makeStartHour();
	fn_makeEndHour();
});


/* ********************************************************
 * 시간
 ******************************************************** */
function fn_makeStartHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t6" name="exe_h" id="exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#startHour" ).append(hourHtml);
}

function fn_makeEndHour(){
	var hour = "";
	var hourHtml ="";
	
	hourHtml += '<select class="select t6" name="exe_h" id="exe_h">';	
	for(var i=0; i<=23; i++){
		if(i >= 0 && i<10){
			hour = "0" + i;
		}else{
			hour = i;
		}
		hourHtml += '<option value="'+hour+'">'+hour+'</option>';
	}
	hourHtml += '</select>';	
	$( "#endHour" ).append(hourHtml);
}
</script>

<style>
.cmm_bd .sub_tit>p {
	padding: 0 8px 0 33px;
	line-height: 24px;
	background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}

.inp_chk >span{
margin-right: 10px;
}
</style>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>보안정책 옵션설정<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li>보안정책 옵션설정 설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>암호화</li>
					<li>설정</li>
					<li class="on">보안정책 옵션설정</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="cmm_bd">
					<div class="sub_tit">
						<p>기본옵션</p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 120px;" />
								<col />
								<col style="width: 100px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<div class="inp_chk">
												<span style="margin-right: 10%;"> 
												<input type="checkbox" id="option_1" name="" /> 
												<label for="option_1">기본 접근 허용 (보안정책 생성시 기본값)</label>
												</span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<div class="inp_chk">
												<span style="margin-right: 10%;"> 
												<input type="checkbox" id="option_2" name="" /> 
												<label for="option_2">암복호화 로그 기록 중지 (보안 정책의 설정을 무시하고, 로그를 기록하지 않음)</label>
												</span>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<br><br>

				<div class="cmm_bd">
					<div class="sub_tit">
						<p>로그옵션</p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 200px;" />
								<col />
								<col style="width: 200px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span style="margin-right: 10%;"> <input type="checkbox" id="option" name="" /> 
												<label for="option">부스트</label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">암복호화 로그 서버에서 압축시간</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0">(초)</td>
									<th scope="row" class="ico_t2">암복호화 로그 압축 중단 시간</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0">(초)</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">암복호화 로그 AP에서 최대 압축값</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0"></td>
									<th scope="row" class="ico_t2">암복호화 로그 압축 출력 시간</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0">(초)</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2">암복호화 로그 압축 시작값</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0"></td>
									<th scope="row" class="ico_t2">암복호화 로그 전송 대기 시간</th>
									<td><input type="number" class="txt t6" name="" id="" maxlength="3" min="0" value="0">(초)</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<br><br>

				<div class="cmm_bd">
					<div class="sub_tit">
						<p>로그 일괄 전송</p>
					</div>
					<div class="overflows_areas">
						<table class="write">
							<colgroup>
								<col style="width: 60px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option1" name="" /> 
												<label for="option1">암복호화 로그를 지정되 시간에만 수집</label>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row" class="ico_t2" colspan="2">로그 전송 요일</th>
								</tr>
								<tr>
									<td colspan="2">
										<div class="inp_chk">
											<span>
												<input type="checkbox" id="option_1_1" name="option_1_1" />
												<label for="option_1_1"><spring:message code="common.mon" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_2" name="option_1_2" />
												<label for="option_1_2"><spring:message code="common.tue" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_3" name="option_1_3" />
												<label for="option_1_3"><spring:message code="common.wed" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_4" name="option_1_4" />
												<label for="option_1_4"><spring:message code="common.thu" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_5" name="option_1_5" />
												<label for="option_1_5"><spring:message code="common.fri" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_6" name="option_1_6" />
												<label for="option_1_6"><spring:message code="common.sat" /></label>
											</span>
											<span>
												<input type="checkbox" id="option_1_7" name="option_1_7" />
												<label for="option_1_7"><spring:message code="common.sun" /></label>
											</span>
										</div>
									</td>
								</tr>
								<tr> 
									<td><div id="startHour"></div></td> 
									<td>전송시작(시)</td> 
								</tr> 
								<tr>
									<td><div id="endHour"></div></td> 
									<td>전송종료(시)</td> 
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
			<div class="btn_type_02">
				<a href="#n" class="btn"><span>저장</span></a> 
			</div>
			
		</div>
	</div>
</div>
