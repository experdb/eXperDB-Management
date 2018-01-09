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
	
	hourHtml += '<select class="select t5" name="exe_h" id="exe_h" style="width: 75px; height: 25px;">';	
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
	
	hourHtml += '<select class="select t5" name="exe_h" id="exe_h" style="width: 75px; height: 25px;">';	
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


<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>보안정책 옵션설정<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
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
			
			<div style="margin-bottom: 10px;"><h2>기본옵션</h2></div>		
				<div class="sch_form">
					<table class="write">
						<colgroup>
							<col style="width: 120px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<td colspan="2"><div class="inp_chk">
									<div class="inp_chk">
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_1" name="" /> 
											<label for="option_1_1">기본 접근 허용 (보안정책 생성시 기본값)</label>
										</span> 
									</div>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2"><div class="inp_chk">
									<div class="inp_chk">
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_1" name="" /> 
											<label for="option_1_1">암복호화 로그 기록 중지 (보안 정책의 설정을 무시하고, 로그를 기록하지 않음)</label>
										</span> 
									</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			<div style="margin-bottom: 10px;"><h2>로그옵션</h2></div>
				<div class="sch_form">
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
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_1" name="" /> 
											<label for="option_1_1">부스트</label>
										</span> 
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 서버에서 압축시간(초)</label>
										</span> 
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 AP에서 최대 압축값</label>
										</span> 
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 압축 시작값</label>
										</span> 
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 압축 중단 시간(초)</label>
										</span> 
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 압축 출력 시간(초)</label>
										</span> 
								</td>
							</tr>
							<tr>
								<td colspan="2">
										<span style="margin-right: 10%;"> 
											<input type="text" name="wrk_nm" id="wrk_nm" class="txt" style="width:100px"/>
											<label for="option_1_1">암복호화 로그 전송 대기 시간(초)</label>
										</span> 
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				
				
				<div style="margin-bottom: 10px;"><h2>로그 일괄 전송</h2></div>
				<div class="sch_form">
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
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_1" name="" /> 
											<label for="option_1_1">복호화 로그를 지정된 시간에만 수집</label>
										</span> 
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">로그 전송 요일</th>
								<td>
								</td>
							</tr>
							<tr>				
								<td colspan="4">
									<div class="schedule_wrap">
										<span id="weekDay"> 									 
										 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.mon" />
										 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.tue" />
										 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.wed" />
										 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.thu" />
									 	 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.fri" />
										 <input type="checkbox" id="chk" name="chk" value="0"> <spring:message code="common.sat" />
										 <input type="checkbox" id="chk"name="chk" value="0"> <spring:message code="common.sun" />
										</span> 
									</div>
								</td>
							</tr>
							<tr>	
								<th><div id="startHour"></div></th>			
								<td>
									 전송시작(시)
								</td>
							</tr>
							<tr>	
								<th><div id="endHour"></div></th>			
								<td>
									 전송종료(시)
								</td>
							</tr>
						</tbody>
					</table>
				</div>		
			</div>
		</div>
	</div>
</div>