<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : auditLogList.jsp
	* @Description : Audit 로그 
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
	*
	*/
%>

			<div id="contents">
				

				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>감사 이력화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>PG Server1</li>
								<li>접근제어관리</li>
								<li class="on">감사 이력</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn"><button>조회</button></span>
							</div>
							<div class="sch_form">
								<table class="write">
									<caption>검색 조회</caption>
									<colgroup>
										<col style="width:90px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col style="width:200px;" />
										<col style="width:80px;" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t4">Database</th>
											<td>
												<select class="select t5" name="" id="">
													<option value="">-선택하세요-</option>
													<option value="">Database1</option>
												</select>
											</td>
											<th scope="row" class="t9">사용자</th>
											<td><input type="text" class="txt t2"/></td>
											<th scope="row" class="t9">성공&#47;실패</th>
											<td>
												<select class="select t5" name="" id="">
													<option value="">-선택하세요-</option>
													<option value="">상태1</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row" class="t10">작업기간</th>
											<td colspan="5">
												<div class="calendar_area">
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="datepicker1" title="기간검색 시작날짜" readonly />
													<span class="wave">~</span>
													<a href="#n" class="calendar_btn">달력열기</a>
													<input type="text" class="calendar" id="datepicker2" title="기간검색 종료날짜" readonly />
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="overflow_area">
								<table class="list">
									<caption>Rman 백업관리 이력화면 리스트</caption>
									<colgroup>
										<col style="width:20%;" />
										<col style="width:8%;" />
										<col style="width:10%;" />
										<col style="width:5%;" />
										<col style="width:10%;" />
										<col style="width:11%;" />
										<col style="width:15%;" />
										<col style="width:6%;" />
										<col style="width:6%;" />
										<col style="width:5%;" />
										<col style="width:8%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">Time</th>
											<th scope="col">User name</th>
											<th scope="col">Statement <br/>ID</th>
											<th scope="col">State</th>
											<th scope="col">Error <br/>session line</th>
											<th scope="col">Substatement <br/> ID</th>
											<th scope="col">Substatement</th>
											<th scope="col">Class</th>
											<th scope="col">Command</th>
											<th scope="col">Object <br/>Type</th>
											<th scope="col">Object <br/>name</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>"2017-05-11 14:26:52.207+09"</td>
											<td>name</td>
											<td>121</td>
											<td>OK</td>
											<td></td>
											<td></td>
											<td>select * from table</td>
											<td>Read</td>
											<td>Select</td>
											<td>Table</td>
											<td>Public table</td>
										</tr>
										<tr>
											<td>"2017-05-11 14:26:52.207+09"</td>
											<td>name</td>
											<td>121</td>
											<td>OK</td>
											<td></td>
											<td></td>
											<td>select * from table</td>
											<td>Read</td>
											<td>Select</td>
											<td>Table</td>
											<td>Public table</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>