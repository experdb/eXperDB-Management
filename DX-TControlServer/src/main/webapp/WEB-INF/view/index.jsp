<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- contents -->
<div id="contents" class="main">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>Dashboard <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
		</div>
		<div class="contents">
			<div class="main_grp">
				<div class="main_info">
					<div class="m_info_lt">
						<p class="m_tit">스케줄 정보</p>
						<ul>
							<li>
								<p class="state">
									<img src="../images/ico_state_03.png" alt="Running" /><span>Running</span>
								</p>
								<p class="state_num c1">${scheduleInfo.run_cnt}</p>
								<p class="state_txt">실행</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_07.png" alt="Stop" /><span>Stop</span>
								</p>
								<p class="state_num c1">${scheduleInfo.stop_cnt}</p>
								<p class="state_txt">중지</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_09.png" alt="Scheduled for today" /><span>Scheduled
										<br />for today
									</span>
								</p>
								<p class="state_num c2 double">${scheduleInfo.today_cnt}</p>
								<p class="state_txt">금일예정</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_01.png" alt="Fail" /><span>Fail</span>
								</p>
								<p class="state_num c3">${scheduleInfo.fail_cnt}</p>
								<p class="state_txt">오류</p>
							</li>
						</ul>
					</div>
					<div class="m_info_rt">
						<p class="m_tit">백업 정보</p>
						<ul>
							<li>
								<p class="state">
									<img src="../images/ico_state_10.png" alt="Server" /><span>Server</span>
								</p>
								<p class="state_num c1">${backupInfo.server_cnt}</p>
								<p class="state_txt">서버</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_11.png" alt="Backup" /><span>Backup
									</span>
								</p>
								<p class="state_num c1">${backupInfo.backup_cnt}</p>
								<p class="state_txt">백업등록</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_09.png" alt="Backup" /><span>Schedule
									</span>
								</p>
								<p class="state_num c1">${backupInfo.schedule_cnt}</p>
								<p class="state_txt">스캐줄등록</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_12.png" alt="Unregistered" /><span>Unregistered</span>
								</p>
								<p class="state_num c3">${backupInfo.unregistered_cnt}</p>
								<p class="state_txt">미등록</p>
							</li>
						</ul>
					</div>
				</div>

				<div class="main_server_info">
					<p class="tit">서버 정보</p>
					<div class="inner">
					<!--
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 104px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t2">서버명</th>
										<td><input type="text" class="txt t2" /></td>
									</tr>
									<tr>
										<th scope="row" class="t10">백업 실행일자</th>
										<td>
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> <input
													type="text" class="calendar" id="datepicker1"
													title="백업 실행 시작날짜" readonly /> <span class="wave">~</span>
												<a href="#n" class="calendar_btn">달력열기</a> <input
													type="text" class="calendar" id="datepicker2"
													title="백업 실행 종료날짜" readonly />
											</div> <span class="btn btnF_03 btnBd_01"><button>조회</button></span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
					-->
						<table class="list">
							<caption>서버 정보</caption>
							<colgroup>
								<col style="width: 10%;" />
								<col style="width: 10%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 14%;" />

								<col style="width: 14%;" />
								<col style="width: 9%;" />
								<col style="width: 9%;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" rowspan="2">서버명</th>
									<th scope="col" rowspan="2">관리DB</th>
									<th scope="col" colspan="4">백업관리</th>
									<th scope="col">접근제어</th>

									<th scope="col" rowspan="2">T엔진</th>
									<th scope="col" colspan="2">Transfer</th>
								</tr>
								<tr>
									<th scope="col">등록</th>
									<th scope="col">스케줄</th>
									<th scope="col">성공</th>
									<th scope="col">실패</th>
									<th scope="col">등록수</th>
									<th scope="col">connect 수</th>
									<th scope="col">실행</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${fn:length(serverInfo) == 0}">
										<tr>
											<td colspan="11">Not Found Data !!</td>

										</tr>
								</c:if>
								<c:forEach var="data" items="${serverInfo}" varStatus="status">
								<tr>
									<td>${data.db_svr_nm}</td>
									<td>${data.db_cnt}</td>
									<td>${data.wrk_cnt}</td>
									<td>${data.schedule_cnt}</td>
									<td>${data.success_cnt}</td>
									<td>${data.fail_cnt}</td>
									<td>${data.access_cnt}</td>

									<td>
									<c:if test="${data.agt_cndt_cd == null}">
										<span class="work_state"><img src="../images/ico_state_08.png" alt="Not Install" /></span>Not Install
									</c:if>
									<c:if test="${data.agt_cndt_cd == 'TC001101'}">
										<span class="work_state"><img src="../images/ico_state_03.png" alt="Running" /></span>Running
									</c:if>
									
									<c:if test="${data.agt_cndt_cd == 'TC001102'}">
										<span class="work_state"><img src="../images/ico_state_07.png" alt="Stop" /></span>Stop
									</c:if>
											
									</td>
									<td>5</td>
									<td>5</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>


			</div>
		</div>
	</div>
</div>
<!-- // contents -->
