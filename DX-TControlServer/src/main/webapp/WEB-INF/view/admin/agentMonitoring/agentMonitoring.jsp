<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : agentMonitoring.jsp
	* @Description : AgentMonitoring 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.30     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.30
	*
	*/
%>
<script>
</script>
	<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>Agent 모니터링 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li class="on">Agent 모니터링</li>
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
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="t2">DB 서버명</th>
											<td><input type="text" class="txt t2"/></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="overflow_area">
								<table class="list">
									<caption>Rman 백업관리 이력화면 리스트</caption>
									<colgroup>
										<col style="width:10%;" />
										<col style="width:25%;" />
										<col style="width:15%;" />
										<col style="width:35%;" />
										<col style="width:15%;" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">NO</th>
											<th scope="col">DB서버</th>
											<th scope="col">Agent 상태</th>
											<th scope="col">구동일시</th>
											<th scope="col">설치확인</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>1</td>
											<td>PGServer1</td>
											<td><img src="../images/ico_agent_1.png" alt="" /></td>
											<td>2017-01-01 12:13</td>
											<td><span class="btn btnC_01 btnF_03" onclick="windowPopup();"><button>확인</button></span></td>
										</tr>
										<tr>
											<td>1</td>
											<td>PGServer1</td>
											<td><img src="../images/ico_agent_2.png" alt="" /></td>
											<td>2017-01-01 12:13</td>
											<td><span class="btn btnC_01 btnF_03"><button>확인</button></span></td>
										</tr>
										<tr>
											<td>1</td>
											<td>PGServer1</td>
											<td><img src="../images/ico_agent_1.png" alt="" /></td>
											<td>2017-01-01 12:13</td>
											<td><span class="btn btnC_01 btnF_03"><button>확인</button></span></td>
										</tr>
										<tr>
											<td>1</td>
											<td>PGServer1</td>
											<td><img src="../images/ico_agent_2.png" alt="" /></td>
											<td>2017-01-01 12:13</td>
											<td><span class="btn btnC_01 btnF_03"><button>확인</button></span></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->