<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : agentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018. 01. 04
	*
	*/
%>
<script>
/*수정버튼 클릭시*/
function fn_agentMonitoringModifyForm(){
	var popUrl = "/popup/agentMonitoringModifyForm.do";
	var width = 954;
	var height = 670;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	
	var winPop = window.open(popUrl,"agentMonitoringModifyForm",popOption);
	winPop.focus();
}
</script>


<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>암호화 에이전트<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>암호화 에이전트 설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li>모니터링</li>
					<li class="on">암화화 에이전트</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button>조회</button></span> 
					<span class="btn"><button onClick="fn_agentMonitoringModifyForm();">수정</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 120px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t2">에이전트명</th>
								<td><input type="text" id="" name="" class="txt t2" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table class="list">
						<caption>리스트</caption>
						<colgroup>
							<col style="width: 5%;"/>
							<col style="width: 5%;"/>
							<col style="width: 10%;"/>
							<col style="width: 10%;"/>
							<col style="width: 10%;"/>
							<col style="width: 10%;"/>
							<col style="width: 15%;"/>
							<col style="width: 15%;"/>
							<col style="width: 10%;"/>
							<col style="width: 10%;"/>
							<col style="width: 10%;"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox"></th>
								<th scope="col">No</th>
								<th scope="col">에이전트명</th>
								<th scope="col">상태</th>
								<th scope="col">최근접속주소</th>
								<th scope="col">최근접속일시</th>
								<th scope="col">에이전트 정책 버전</th>
								<th scope="col">최근 전송 정책 버전</th>
								<th scope="col">설치일시</th>
								<th scope="col">변경일시</th>
								<th scope="col">변경자</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
