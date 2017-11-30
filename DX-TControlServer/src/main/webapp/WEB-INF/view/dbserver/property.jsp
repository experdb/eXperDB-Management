<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	/**
	* @Class Name : dbmsInformation.jsp
	* @Description : dbmsInformation 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.11.09     최초 생성
	*
	* author 김주영 사원
	* since 2017.11.09 
	*
	*/
%>


<script type="text/javascript">
	/* ********************************************************
	 * Data initialization
	 ******************************************************** */
	$(window.document).ready(function() {
		var extName = "${extName}";
		if(extName == "agent") {
			alert("서버에 experdb엔진이 설치되지 않았습니다.");
			history.go(-1);
		}else if(extName == "agentfail"){
			alert("experdb엔진 상태를 확인해주세요.");
			history.go(-1);
		}else{		
			$("#tab1").show();
			$("#tab2").hide();
			$("#tab3").hide();
			$("#tab4").hide();

			$("#systeminfo").show();
			$("#dbmisinfo").hide();
			$("#settinginfo").hide();
			$("#tablespaceinfo").hide();
			
			var html = '';
			var count = 0;
			<c:forEach items="${result.CMD_NETWORK}" var="networkinfo" varStatus="status">
			count = '${status.count}';
			</c:forEach>
			count = count*2;
			
			html += '<tr><td colspan="3" rowspan="'+count+'" class="color">네트워크</td>';
			<c:forEach items="${result.CMD_NETWORK}" var="networkinfo" varStatus="status">
			if('${status.index}'!=0){
				html +='<tr>'
			}
			html += '<td rowspan="2" class="color">${networkinfo.CMD_NETWORK_INTERFACE}</td>';
			html += '<td class="color">ip</td>';
			html += '<td>${networkinfo.CMD_NETWORK_IP}</td></tr>';
			html += '<tr><td class="color">mac</td><td>${networkinfo.CMD_MACADDRESS}</td></tr>';
			</c:forEach>
			
			$("#systemInfo").append(html);
		}

	});

	/* ********************************************************
	 * Tab Click
	 ******************************************************** */
	function selectTab(tab) {
		if (tab == "systeminfo") {
			$("#tab1").show();
			$("#tab2").hide();
			$("#tab3").hide();
			$("#tab4").hide();

			$("#systeminfo").show();
			$("#dbmisinfo").hide();
			$("#settinginfo").hide();
			$("#tablespaceinfo").hide();
		} else if (tab == "dbmisinfo") {
			$("#tab1").hide();
			$("#tab2").show();
			$("#tab3").hide();
			$("#tab4").hide();

			$("#systeminfo").hide();
			$("#dbmisinfo").show();
			$("#settinginfo").hide();
			$("#tablespaceinfo").hide();
		} else if (tab == "settinginfo") {
			$("#tab1").hide();
			$("#tab2").hide();
			$("#tab3").show();
			$("#tab4").hide();

			$("#systeminfo").hide();
			$("#dbmisinfo").hide();
			$("#settinginfo").show();
			$("#tablespaceinfo").hide();
		} else {
			$("#tab1").hide();
			$("#tab2").hide();
			$("#tab3").hide();
			$("#tab4").show();

			$("#systeminfo").hide();
			$("#dbmisinfo").hide();
			$("#settinginfo").hide();
			$("#tablespaceinfo").show();
		}
	}
</script>
<style>
.contents .cmm_tab li {
	width: 25%;
}

.cmm_bd .sub_tit>p {
	padding: 0 8px 0 33px;
	line-height: 24px;
	background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}
</style>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				속성<a href="#n"><img src="/images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li>선택한 DBMS가 설치된 시스템의 주요 정보를 조회합니다.</li>
					<li>선택한 DBMS의 기본 정보와 주요 설정 정보를 조회합니다</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li class="on">속성</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('systeminfo')">시스템정보</a></li>
					<li><a href="javascript:selectTab('dbmisinfo')">DBMS정보</a></li>
					<li><a href="javascript:selectTab('settinginfo')">주요환경설정 정보</a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')">테이블스페이스 정보</a></li>
				</ul>
				<ul id="tab2" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')">시스템정보</a></li>
					<li class="atv"><a href="javascript:selectTab('dbmisinfo')">DBMS정보</a></li>
					<li><a href="javascript:selectTab('settinginfo')">주요환경설정 정보</a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')">테이블스페이스 정보</a></li>
				</ul>
				<ul id="tab3" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')">시스템정보</a></li>
					<li><a href="javascript:selectTab('dbmisinfo')">DBMS정보</a></li>
					<li class="atv"><a href="javascript:selectTab('settinginfo')">주요환경설정 정보</a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')">테이블스페이스 정보</a></li>
				</ul>
				<ul id="tab4" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')">시스템정보</a></li>
					<li><a href="javascript:selectTab('dbmisinfo')">DBMS정보</a></li>
					<li><a href="javascript:selectTab('settinginfo')">주요환경설정 정보</a></li>
					<li class="atv"><a href="javascript:selectTab('tablespaceinfo')">테이블스페이스 정보</a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div id="systeminfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>시스템 정보</p></div>
						<div class="overflow_areas" style="height: 365px;">
							<table class="list3" id="systemInfo">
								<caption>시스템 정보</caption>
								<colgroup>
									<col style="width: 5%;" />
									<col style="width: 5%;" />
									<col style="width: 5%;" />
									<col style="width: 5%;" />
									<col style="width: 5%;" />
									<col style="width: 75%;" />
									<col />
								</colgroup>
								<tr>
									<th colspan="5">항목</th>
									<th>내용</th>
								</tr>
								<tr>
									<td colspan="5" class="color">호스트명</td>
									<td>${result.CMD_HOSTNAME}</td>
								</tr>
								<tr>
									<td colspan="2" rowspan="2" class="color">OS 정보</td>
									<td colspan="3" class="color">버전</td>
									<td>${result.CMD_OS_VERSION}</td>
								</tr>
								<tr>
									<td colspan="3" class="color">커널</td>
									<td>${result.CMD_OS_KERNUL}</td>
								</tr>
								<tr>
									<td colspan="5" class="color">CPU</td>
									<td>${result.CMD_CPU}</td>
								</tr>
								<tr>
									<td colspan="5" class="color">메모리</td>
									<td>${result.CMD_MEMORY}</td>
								</tr>														
							</table>
						</div>
					</div>
				</div>

				<div id="dbmisinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>기본 정보</p></div>
						<div class="overflow_areas">
							<table class="list3">
								<caption>기본 정보</caption>
								<colgroup>
									<col style="width: 25%;" />
									<col style="width: 75%;" />
									<col />
								</colgroup>
								<tr>
									<th>항목</th>
									<th>내용</th>
								</tr>
								<tr>
									<td>POSTGRESQL 버전</td>
									<td>${result.POSTGRESQL_VERSION}</td>
								</tr>
								<tr>
									<td>DBMS 경로</td>
									<td>${result.CMD_DBMS_PATH}</td>
								</tr>
								<tr>
									<td>DATA 경로</td>
									<td>${result.DATA_PATH}</td>
								</tr>
								<tr>
									<td>로그 경로</td>
									<td>${result.LOG_PATH}</td>
								</tr>
								<tr>
									<td>백업 경로</td>
									<td>${result.CMD_BACKUP_PATH}</td>
								</tr>
<!-- 								<tr> -->
<!-- 									<th >Archive 백업 경로</th> -->
<%-- 									<td>${result.ARCHIVE_PATH}</td> --%>
<!-- 								</tr> -->
							</table>
						</div>
						<br><br>
						<div class="sub_tit"><p>데이터베이스 정보</p></div>
						<div class="overflow_areas" style="height: 365px;">
							<table class="list3">
								<caption>데이터베이스 정보</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 20%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">이름</th>
										<th scope="col">소유자</th>
										<th scope="col">인코딩</th>
										<th scope="col">COLLATE</th>
										<th scope="col">CTYPE</th>
										<th scope="col">사이즈</th>
										<th scope="col">테이블스페이스</th>
										<th scope="col">설명</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="databaseInfo" items="${result.CMD_DATABASE_INFO}">
										<tr>
											<td>
												<c:forEach var="dbnmInfo" items="${resultRepoDB}">
													<c:if test="${dbnmInfo.db_nm eq databaseInfo.name}" >
													<img src="../images/ico_state_05.png" style="margin-right: 5px;"/></c:if>	
												</c:forEach>
												${databaseInfo.name}
											</td>
											<td>${databaseInfo.owner}</td>
											<td>${databaseInfo.encoding}</td>
											<td>${databaseInfo.collate}</td>
											<td>${databaseInfo.ctype}</td>
											<td>${databaseInfo.size}</td>
											<td>${databaseInfo.tablespace}</td>
											<td>${databaseInfo.description}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<br><br>
						<div class="sub_tit"><p>HA구성정보</p></div>
						<div class="overflow_areas">
							<table class="list3">
								<caption>HA구성정보</caption>
								<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">IP</th>
										<th scope="col">서버유형</th>
										<th scope="col">호스트명</th>
										<th scope="col">상태</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="hainfo" items="${resultIpadr}">
										<tr>
											<td class="center">${hainfo.ipadr}</td>
											<td class="center">
												<c:choose><c:when test="${hainfo.master_gbn eq 'M'}">master</c:when>
												<c:when test="${hainfo.master_gbn eq 'S'}">slave</c:when>
												</c:choose>
											</td>
											<td class="center">${hainfo.svr_host_nm}</td>
											<td class="center">
												<c:choose><c:when test="${hainfo.db_cndt eq 'Y'}"><span class="work_state"><img src="../images/ico_state_03.png" alt="Running" /></span>Running</c:when>
												<c:when test="${hainfo.db_cndt eq 'N'}"><span class="work_state"><img src="../images/ico_state_07.png" alt="Stop" /></span>Stop</c:when>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="settinginfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>주요환경설정 정보</p></div>
						<div class="overflow_areas" style="height: 670px;">
							<table class="list3">
								<caption>주요환경설정 정보</caption>
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 20%;">
									<col style="width: 30%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">구분</th>
										<th scope="col">항목</th>
										<th scope="col">설정값</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td rowspan="3" class="color">접속 및 인증</td>
										<td class="center">listen_addresses</td>
										<td >${result.CMD_LISTEN_ADDRESSES}</td>
									</tr>
									<tr>
										<td class="center">port</td>
										<td>${result.CMD_PORT}</td>
									</tr>
									<tr>
										<td class="center">max_connections</td>
										<td>${result.CMD_MAX_CONNECTIONS}</td>
									</tr>
									<tr>
										<td rowspan="5" class="color">자원설정</td>
										<td class="center">shared_buffers</td>
										<td>${result.CMD_SHARED_BUFFERS}</td>
									</tr>
									<tr>
										<td class="center">work_mem</td>
										<td>${result.CMD_WORK_MEM}</td>
									</tr>
									<tr>
										<td class="center">maintenance_work_mem</td>
										<td>${result.CMD_MAINTENANCE_WORK_MEM}</td>
									</tr>
									<tr>
										<td class="center">effective_cache_size</td>
										<td>${result.CMD_EFFECTIVE_CACHE_SIZE}</td>
									</tr>
									<tr>
										<td class="center">shared_preload_libraries</td>
										<td>${result.CMD_SHARED_PRELOAD_LIBRARIES}</td>
									</tr>
									<tr>
										<td rowspan="6" class="color">WAL 설정</td>
										<td class="center">wal_level</td>
										<td>${result.CMD_WAL_LEVEL}</td>
									</tr>
									<tr>
										<td class="center">wal_buffers</td>
										<td>${result.CMD_WAL_BUFFERS}</td>
									</tr>
									<tr>
										<td class="center">archive_mode</td>
										<td>${result.CMD_ARCHIVE_MODE}</td>
									</tr>
									<tr>
										<td class="center">archive_command</td>
										<td>${result.CMD_ARCHIVE_COMMAND}</td>
									</tr>
									<tr>
										<td class="center">min_wal_size</td>
										<td>${result.CMD_MIN_WAL_SIZE}</td>
									</tr>
									<tr>
										<td class="center">max_wal_size</td>
										<td>${result.CMD_MAX_WAL_SIZE}</td>
									</tr>
									<tr>
										<td rowspan="2" class="color">복제</td>
										<td class="center">hot_standby</td>
										<td>${result.CMD_HOT_STANDBY}</td>
									</tr>
									<tr>
										<td class="center">wal_keep_segments</td>
										<td>${result.CMD_WAL_KEEP_SEGMENTS}</td>
									</tr>
									<tr>
										<td rowspan="2" class="color">파일위치</td>
										<td class="center">config_file</td>
										<td>${result.CMD_CONFIG_FILE}</td>
									</tr>
									<tr>
										<td class="center">data_directory</td>
										<td>${result.CMD_DATA_DIRECTORY}</td>
									</tr>
									<tr>
										<td class="color">표준시간대</td>
										<td class="center">TimeZone</td>
										<td>${result.CMD_TIMEZONE}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="tablespaceinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>테이블스페이스 정보</p></div>
						<div class="overflow_areas" style="height: 365px;">
							<table class="list3">
								<caption>테이블스페이스 정보</caption>
								<colgroup>
									<col style="width: 15%;">
									<col style="width: 10%;">
									<col style="width: 5%;">
									<col style="width: 5%;">
									<col style="width: 5%;">
									<col style="width: 15%;">
									<col style="width: 15%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" colspan="4">파일시스템</th>
										<th scope="col" colspan="6">테이블스페이스</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="color">Filesystem</td>
										<td class="color">Mounted on</td>
										<td class="color">Total size</td>
										<td class="color">Used</td>
										<td class="color">Name</td>
										<td class="color">Owner</td>
										<td class="color">Location</td>
										<td class="color">Options</td>
										<td class="color">Size</td>
										<td class="color">Description</td>
									</tr>
									<c:forEach var="tablespaceinfo" items="${result.CMD_TABLESPACE_INFO}">
										<tr>
											<td >${tablespaceinfo.filesystem}</td>
											<td >${tablespaceinfo.mounton}</td>
											<td>${tablespaceinfo.fsize}</td>
											<td>${tablespaceinfo.used}</td>
											<td>${tablespaceinfo.name}</td>
											<td>${tablespaceinfo.owner}</td>
											<td>${tablespaceinfo.location}</td>
											<td>${tablespaceinfo.options}</td>
											<td>${tablespaceinfo.size}</td>
											<td>${tablespaceinfo.description}</td>
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
</div>