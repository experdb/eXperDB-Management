<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
	/**
	* @Class Name : myPage.jsp
	* @Description : myPage 화면
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
				<div class="sch_form p1">
					<div class="inp_chk chk3">
						<input type="checkbox" id="" name="">
						<label for=""><span class="chk_img"><img src="../images/popup/ico_box_1.png" alt="" /></span>기본 접근 허용 (보안정책 생성시 기본값)</label>
					</div>
				</div>



				<table class="write2">
					<caption>기본옵션</caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><input type="checkbox" ></th>
							<td>기본 접근 허용 (보안정책 생성시 기본값)</td>
						</tr>
						<tr>
							<th scope="row"><input type="checkbox" ></th>
							<td>암복호화 로그 기록 중지 (보안 정책의 설정을 무시하고, 로그를 기록하지 않음)</td>
						</tr>
					</tbody>
				</table>
				
				
				<table class="write2">
					<caption>로그압축</caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><input type="checkbox" ></th>
							<td>부스트</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 서버에서 압축시간(초)</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 AP에서 최대 압축값</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 압축 시작값</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 압축 중단 시간(초)</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 압축 출력 시간(초)</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 전송 대기 시간(초)</td>
						</tr>
					</tbody>
				</table>
				
				
				<table class="write2">
					<caption>로그 일괄 전송</caption>
					<colgroup>
						<col style="width: 150px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><input type="checkbox" ></th>
							<td>암복호화 로그를 지정된 시간에만 수집</td>
						</tr>
						<tr>
							<th scope="row">로그 전송 요일</th>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 AP에서 최대 압축값</td>
						</tr>
						<tr>
							<th scope="row"><input type="text" class="txt"></th>
							<td>암복호화 로그 압축 시작값</td>
						</tr>
					</tbody>
				</table>			
			</div>
		</div>
	</div>
</div>