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
		$("#tab1").show();
		$("#tab2").hide();
		$("#tab3").hide();
		$("#tab4").hide();

		$("#systeminfo").show();
		$("#dbmisinfo").hide();
		$("#settinginfo").hide();
		$("#tablespaceinfo").hide();
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
						<div class="sub_tit"><p>시스템정보</p></div>
						<div class="overflow_area" style="border: none;">
							<table class="write2">
								<caption>시스템정보</caption>
								<colgroup>
									<col style="width: 50px;" />
									<col style="width: 50px;" />
									<col style="width: 50px;" />
									<col style="width: 100px;" />
									<col style="width: 200px;" />
									<col />
								</colgroup>
								<tr>
									<th scope="row" colspan="5">항목</th>
									<td>내용</td>
								</tr>
								<tr>
									<th scope="row" colspan="5">호스트명</th>
									<td>db1</td>
								</tr>
								<tr>
									<th scope="row" colspan="2" rowspan="2">OS 정보</th>
									<th scope="row" colspan="3">버전</th>
									<td>Red Hat Enterprise Linux Server release 6.7 (Santiago)</td>
								</tr>
								<tr>
									<th scope="row" colspan="3">커널</th>
									<td>kernel-2.6.32-573.el6.x86_64</td>
								</tr>
								<tr>
									<th scope="row" colspan="5">CPU</th>
									<td>1.8 GB</td>
								</tr>
								<tr>
									<th scope="row" colspan="3" rowspan="4">네트워크</th>
									<th scope="row" rowspan="2">eth0</th>
									<th scope="row">ip</th>
									<td>192.168.56.110</td>
								</tr>
								<tr>
									<th scope="row">mac</th>
									<td>08:00:27:AF:E7:BC</td>
								</tr>
								<tr>
									<th scope="row" rowspan="2">eth1</th>
									<th scope="row">ip</th>
									<td>192.168.56.111</td>
								</tr>
								<tr>
									<th scope="row">mac</th>
									<td>02:10:22:TF:K7:QC</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div id="dbmisinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>DBMS 정보</p></div>
						<div class="overflow_area" style="height: 200px; border: none;">
							<table class="write2">
								<caption>DBMS정보</caption>
								<colgroup>
									<col style="width: 200px;" />
									<col />
								</colgroup>
								<tr>
									<th scope="row">POSTGRESQL 버전</th>
									<td>PostgreSQL 9.6.2 on x86_64-pc-linux-gnu, compiled by
										gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-18), 64-bit</td>
								</tr>
								<tr>
									<th scope="row">DBMS 경로</th>
									<td>/experdb/app/postgres</td>
								</tr>
								<tr>
									<th scope="row">DATA 경로</th>
									<td>/experdata/data</td>
								</tr>
								<tr>
									<th scope="row">로그 경로</th>
									<td>pg_log</td>
								</tr>
								<tr>
									<th scope="row">백업 경로</th>
									<td>/experdata/backup</td>
								</tr>
								<tr>
									<th scope="row">Archive 백업 경로</th>
									<td>/experdata/backup/archive</td>
								</tr>
							</table>
						</div>

						<div class="sub_tit"><p>데이터베이스 정보</p></div>
						<div class="overflow_area" style="height: 200px;">
							<table class="list pd_type3">
								<caption>데이터베이스정보</caption>
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
									<tr>
										<td>db</td>
										<td>experdba</td>
										<td>utf-8</td>
										<td>ko_kr.utf8</td>
										<td>utf8</td>
										<td>17GB</td>
										<td>tbs</td>
										<td>업무디비</td>
									</tr>
								</tbody>
							</table>
						</div>
						<br>
						
						<div class="sub_tit"><p>HA구성정보</p></div>
						<div class="overflow_area" style="height: 200px;">
							<table class="list pd_type3">
								<caption>HA구성정보</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">서버유형</th>
										<th scope="col">서버명칭</th>
										<th scope="col">아이피</th>
										<th scope="col">주서버</th>
										<th scope="col">상태</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>Master</td>
										<td>Master Cluster</td>
										<td>127.0.0.1</td>
										<td>-</td>
										<td>active</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>


				<div id="settinginfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>주요환경설정 정보</p></div>
						<div class="overflow_area" style="height: 663px;">
							<table class="list pd_type3">
								<caption>스케쥴 리스트화면 리스트</caption>
								<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 50%;">
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
										<td rowspan="3">접속 및 인증</td>
										<td>listen_addresses</td>
										<td>*</td>
									</tr>
									<tr>
										<td>port</td>
										<td>5433</td>
									</tr>
									<tr>
										<td>max_connections</td>
										<td>100</td>
									</tr>
									<tr>
										<td rowspan="5">자원설정</td>
										<td>shared_buffers</td>
										<td>512MB</td>
									</tr>
									<tr>
										<td>work_mem</td>
										<td>1GB</td>
									</tr>
									<tr>
										<td>maintenance_work_mem</td>
										<td>16MB</td>
									</tr>
									<tr>
										<td>effective_cache_size</td>
										<td>256MB</td>
									</tr>
									<tr>
										<td>shared_preload_libraries</td>
										<td>128MB</td>
									</tr>

									<tr>
										<td rowspan="6">WAL 설정</td>
										<td>wal_level</td>
										<td>16MB</td>
									</tr>
									<tr>
										<td>wal_buffers</td>
										<td>replica</td>
									</tr>
									<tr>
										<td>archive_mode</td>
										<td>16MB</td>
									</tr>
									<tr>
										<td>archive_command</td>
										<td>on</td>
									</tr>
									<tr>
										<td>min_wal_size</td>
										<td>on</td>
									</tr>
									<tr>
										<td>max_wal_size</td>
										<td>cd .</td>
									</tr>
									<tr>
										<td rowspan="2">복제</td>
										<td>hot_standby</td>
										<td>/experdata/data/postgresql.conf</td>
									</tr>
									<tr>
										<td>wal_keep_segments</td>
										<td>/experdata/data</td>
									</tr>
									<tr>
										<td rowspan="2">파일위치</td>
										<td>config_file</td>
										<td>on</td>
									</tr>
									<tr>
										<td>data_directory</td>
										<td>Asia/Seoul</td>
									</tr>
									<tr>
										<td>data_directory</td>
										<td>TimeZone</td>
										<td>repmgr_funcs, pg_stat_statements, pg_cron, pgaudit</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div id="tablespaceinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p>테이블스페이스 정보</p></div>
						<div class="overflow_area">
							<table class="list pd_type3">
								<caption>스케쥴 리스트화면 리스트</caption>
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
										<th scope="col" colspan="5">테이블스페이스</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>Filesystem</td>
										<td>Mounted on</td>
										<td>Total size</td>
										<td>Used</td>
										<td>Name</td>
										<td>Owner</td>
										<td>Location</td>
										<td>Options</td>
										<td>Size</td>
										<td>Description</td>
									</tr>
									<tr>
										<td>/dev/mapper/cl-home</td>
										<td>/home</td>
										<td>100</td>
										<td>10%</td>
										<td>pg_default</td>
										<td>experdba</td>
										<td>/home/experdb/pgdata/data</td>
										<td></td>
										<td>14GB</td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>

