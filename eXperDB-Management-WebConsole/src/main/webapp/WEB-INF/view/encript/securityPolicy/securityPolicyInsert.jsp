<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : securityPolicyInsert.jsp
	* @Description : securityPolicyInsert 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>
<style>
.contents .cmm_tab li {
	width: 33.33%;
}

.contents {
    min-height: 600px;
 }
 
.cmm_bd .sub_tit > p{
	padding:0 8px 0 33px;
	line-height:24px;
	background:url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}
</style>
<script>
	var table = null;
	var table2 = null;

	function fn_init() {
		table = $('#encryptPolicyTable').DataTable({
			scrollY : "250px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}
			]
		});

		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
	    
	    table2 = $('#accessControlTable').DataTable({
			scrollY : "250px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
			{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}, 
			{ data : "", className : "dt-center", defaultContent : ""}
			]
		});

	    table2.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	    table2.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
	    table2.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
	    table2.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(4)').css('min-width', '50px');
	    table2.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	    table2.tables().header().to$().find('th:eq(6)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(11)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(12)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(13)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(14)').css('min-width', '150px');
		table2.tables().header().to$().find('th:eq(15)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(16)').css('min-width', '50px');
		table2.tables().header().to$().find('th:eq(17)').css('min-width', '100px');
		table2.tables().header().to$().find('th:eq(18)').css('min-width', '100px');
	    $(window).trigger('resize'); 
	    
	}
	
	$(window.document).ready(function() {
		fn_init();

		$("#tab1").show();
		$("#tab2").hide();
		$("#tab3").hide();

		$("#info").show();
		$("#option").hide();
		$("#accessControl").hide();
	});

	function selectTab(tab) {
		if (tab == "info") {
			$("#tab1").show();
			$("#tab2").hide();
			$("#tab3").hide();

			$("#info").show();
			$("#option").hide();
			$("#accessControl").hide();
		} else if (tab == "option") {
			$("#tab1").hide();
			$("#tab2").show();
			$("#tab3").hide();

			$("#info").hide();
			$("#option").show();
			$("#accessControl").hide();
		} else {
			$("#tab1").hide();
			$("#tab2").hide();
			$("#tab3").show();

			$("#info").hide();
			$("#option").hide();
			$("#accessControl").show();
		}

	}
	
	/*암보호화 정책 등록*/
	function fn_SecurityAdd(){
		var popUrl = "/popup/securityPolicyRegForm.do"; // 서버 url 팝업경로
		var width = 1000;
		var height = 520;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);		
		
	}
	
	/*암보호화 정책 삭제*/
	function fn_SecurityDel(){
		alert("2");
	}
	
	/*접근제어 정책 등록*/
	function fn_AccessAdd(){
		alert("3");
	}
	
	/*접근제어 정책 삭제*/
	function fn_AccessDel(){
		alert("4");
	}
	
</script>

<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>정책등록<a href="#n"><img src="/images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>데이터암호화</li>
					<li>보안정책</li>
					<li class="on">정책등록</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('info')">기본정보</a></li>
					<li><a href="javascript:selectTab('option')">옵션</a></li>
					<li><a href="javascript:selectTab('accessControl')">접근제어정책</a></li>
				</ul>
				<ul id="tab2" style="display: none;">
					<li><a href="javascript:selectTab('info')">기본정보</a></li>
					<li class="atv"><a href="javascript:selectTab('option')">옵션</a></li>
					<li><a href="javascript:selectTab('accessControl')">접근제어정책</a></li>
				</ul>
				<ul id="tab3" style="display: none;">
					<li><a href="javascript:selectTab('info')">기본정보</a></li>
					<li><a href="javascript:selectTab('option')">옵션</a></li>
					<li class="atv"><a href="javascript:selectTab('accessControl')">접근제어정책</a></li>
				</ul>
			</div>

			<div id="info">
				<div class="sch_form">
					<table class="write">
						<colgroup>
							<col style="width: 110px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">보안정책이름</th>
								<td><input type="text" class="txt" name="policyName" id="policyName" /></td>

							</tr>
							<tr>
								<th scope="row" class="ico_t1">보안정책설명</th>
								<td><input type="text" class="txt" name="policyComment" id="policyComment" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="cmm_bd">
					<div class="sub_tit">
						<p>암호화정책</p>
						<div class="sub_btn">
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_SecurityAdd();">
							<span id="add_button"><spring:message code="common.add" /></span>
							</a> <a href="#n" class="btn btnF_04" onclick="fn_SecurityDel();"> 
							<span id="del_button"><spring:message code="button.delete" /></span></a>
						</div>
					</div>
					<div class="overflow_area">
						<table id="encryptPolicyTable" class="display" cellspacing="0"
							width="100%">
							<thead>
								<tr>
									<th width="10"></th>
									<th width="20">No</th>
									<th width="120">시작위치</th>
									<th width="100">길이</th>
									<th width="100">암호화알고리즘</th>
									<th width="100">암호화키</th>
									<th width="80">초기벡터</th>
									<th width="100">운영모드</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>


			<div id="option">
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
								<th scope="row" class="ico_t1">기본접근허용</th>
								<td>
									<div class="inp_rdo">
										<input name="rdo" id="rdo_2_1" type="radio" checked="checked">
										<label for="rdo_2_1" style="margin-right: 15%;">예</label> 
										<input name="rdo" id="rdo_2_2" type="radio"> 
										<label for="rdo_2_2">아니오</label>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">접근 거부시 처리</th>
								<td>
									<select class="select" id="" name="">
										<option value="ERROR">ERROR</option>
									</select>
								</td>
							</tr>
							
							<tr>
								<th scope="row" class="ico_t1">데이터 타입</th>
								<td>
									<select class="select" id="" name="">
										<option value="STRING">STRING</option>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="2"><div class="inp_chk">
									<div class="inp_chk">
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_1" name="" /> 
											<label for="option_1_1">실패 로그 기록</label>
										</span> 
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_2" name="" /> 
											<label for="option_1_2">로그압축</label>
										</span> 
										<span> 
											<input type="checkbox" id="option_1_3" name="" />
												<label for="option_1_3">이중 암호화 방지</label>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div class="inp_chk">
										<span style="margin-right: 10%;"> 
											<input type="checkbox" id="option_1_4" name="" /> 
											<label for="option_1_4">성공 로그 기록</label>
										</span> 
										<span> 
											<input type="checkbox" id="option_1_5" name="" />
											<label for="option_1_5">NULL 암호화</label>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<div id="accessControl">
				<div class="cmm_bd">
					<div class="sub_tit">
						<p>접근제어정책</p>
						<div class="sub_btn">
							<a href="#n" class="btn btnF_04 btnC_01" onclick="fn_AccessAdd();">
								<span id="add_button"><spring:message code="common.add" /></span>
							</a> <a href="#n" class="btn btnF_04" onclick="fn_AccessDel();"> 
							<span id="del_button"><spring:message code="button.delete" /></span></a>
						</div>
					</div>
					<div class="overflow_area">
						<table id="accessControlTable" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th width="10"></th>
									<th width="20">No</th>
									<th width="50">규칙이름</th>
									<th width="100">서버인스턴스</th>
									<th width="50">db사용자</th>
									<th width="100">eXperDB사용자</th>
									<th width="50">OS사용자</th>
									<th width="100">프로그램이름</th>
									<th width="100">접근 ip 주소</th>
									<th width="100">IP 주소 마스크</th>
									<th width="100">접근mac 주소</th>
									<th width="50">기간</th>
									<th width="50">시간대</th>
									<th width="50">요일</th>
									<th width="150">대량작업 임계건수</th>
									<th width="50">초</th>
									<th width="50">추가필드</th>
									<th width="100">호스트이름</th>
									<th width="100">접근허용여부</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
			</div>


			<div class="btn_type_02">
				<a href="#n" class="btn"><span>저장</span></a> 
				<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span>취소</span></a>
			</div>


		</div>
	</div>
</div>





