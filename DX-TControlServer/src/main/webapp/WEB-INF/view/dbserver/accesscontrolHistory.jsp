<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : accesscontrolHistory.jsp
	* @Description : accesscontrolHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.09.18     최초 생성
	*
	* author 김주영 사원
	* since 2017.09.18
	*
	*/
%>
<script>


</script>
<style>
.inner .tit {
    height: 28px;
    line-height: 28px;
    padding-left: 27px;
    border: 1px solid #b8c3c6;
    border-bottom: none;
    background: #e4e9ec;
    color: #101922;
    font-size: 13px;
    font-family: 'Nanum Square Bold';  
}
</style>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				접근제어이력 화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a>
			</h4>
			<div class="location">
				<ul>
					<li>${db_svr_nm}</li>
					<li>접근제어관리</li>
					<li class="on">접근제어이력</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()" id="btnSelect">조회</button></span>
					<span class="btn"><button onclick="fn_insert()" id="btnInsert">복원</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 130px;" />
							<col style="width: 180px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">수정일시</th>
								<td><select class="select t5" id="use_yn">
										<option value="%">전체</option>
								</select></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="inner">
					<p class="tit"><img src="/images/ico_left_1.png" style="line-height: 22px; margin: 0px 10px 0 0;">${db_svr_nm}</p>				
					<div class="overflow_area">
						<table id="accesscontrolHistoryTable" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th>No</th>
									<th>Type</th>
									<th>Database</th>
									<th>User</th>
									<th>IP Address</th>
									<th>IP Mask</th>
									<th>Method</th>
									<th>Option</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>