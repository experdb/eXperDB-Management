<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
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
			alert("<spring:message code='message.msg25' />");
			history.go(-1);
		}else if(extName == "agentfail"){
			alert("<spring:message code='message.msg27' />");
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
			
			html += '<tr><td colspan="3" rowspan="'+count+'" class="color"><spring:message code="properties.network" /></td>';
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

.iGraph {
    white-space: nowrap;
    line-height: normal;
}
.iGraph .gBar {
    display: inline-block;
    width: 70%;
    margin: 0 5px 0 0;
    border: 1px solid #ccc;
    background: #e9e9e9;
}
.iGraph .gAction {
    display: inline-block;
    height: 10px;
    border: 1px solid #8c9bac;
    background: #99a6b6;
    margin: -1px;
}
.iGraph .gPercent {
    font: 10px;
}
</style>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				<spring:message code="common.property"/><a href="#n"><img src="/images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.properties_01" /></li>
					<li><spring:message code="help.properties_02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li class="on"><spring:message code="common.property"/></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_tab">
				<ul id="tab1">
					<li class="atv"><a href="javascript:selectTab('systeminfo')"><spring:message code="properties.system_info" /></a></li>
					<li><a href="javascript:selectTab('dbmisinfo')"><spring:message code="menu.dbms_information" /></a></li>
					<li><a href="javascript:selectTab('settinginfo')"><spring:message code="properties.about_preferences" /> </a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')"><spring:message code="properties.tablespace_info" /></a></li>
				</ul>
				<ul id="tab2" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')"><spring:message code="properties.system_info" /></a></li>
					<li class="atv"><a href="javascript:selectTab('dbmisinfo')"><spring:message code="menu.dbms_information" /></a></li>
					<li><a href="javascript:selectTab('settinginfo')"><spring:message code="properties.about_preferences" /> </a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')"><spring:message code="properties.tablespace_info" /></a></li>
				</ul>
				<ul id="tab3" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')"><spring:message code="properties.system_info" /></a></li>
					<li><a href="javascript:selectTab('dbmisinfo')"><spring:message code="menu.dbms_information" /></a></li>
					<li class="atv"><a href="javascript:selectTab('settinginfo')"><spring:message code="properties.about_preferences" /> </a></li>
					<li><a href="javascript:selectTab('tablespaceinfo')"><spring:message code="properties.tablespace_info" /></a></li>
				</ul>
				<ul id="tab4" style="display: none;">
					<li><a href="javascript:selectTab('systeminfo')"><spring:message code="properties.system_info" /></a></li>
					<li><a href="javascript:selectTab('dbmisinfo')"><spring:message code="menu.dbms_information" /></a></li>
					<li><a href="javascript:selectTab('settinginfo')"><spring:message code="properties.about_preferences" /> </a></li>
					<li class="atv"><a href="javascript:selectTab('tablespaceinfo')"><spring:message code="properties.tablespace_info" /></a></li>
				</ul>
			</div>
			<div class="cmm_grp">
				<div id="systeminfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p><spring:message code="properties.system_info" /></p></div>
						<div class="overflow_areas" style="height: 365px;">
							<table class="list3" id="systemInfo">
								<caption>시스템 정보</caption>
								<colgroup>
									<col style="width: 10%;" />
									<col style="width: 5%;" />
									<col style="width: 5%;" />
									<col style="width: 7%;" />
									<col style="width: 5%;" />
									<col style="width: 68%;" />
									<col /> 
								</colgroup>
								<tr>
									<th colspan="5"><spring:message code="properties.item" /></th>
									<th><spring:message code="properties.description" /> </th>
								</tr>
								<tr>
									<td colspan="5" class="color"><spring:message code="properties.host" /> </td>
									<td>${result.CMD_HOSTNAME}</td>
								</tr>
								<tr>
									<td colspan="2" rowspan="2" class="color"><spring:message code="properties.os_info" /></td>
									<td colspan="3" class="color"><spring:message code="properties.version" /></td>
									<td>${result.CMD_OS_VERSION}</td>
								</tr>
								<tr>
									<td colspan="3" class="color"><spring:message code="properties.kernel" /></td>
									<td>${result.CMD_OS_KERNUL}</td>
								</tr>
								<tr>
									<td colspan="5" class="color"><spring:message code="properties.cpu" /></td>
									<td>${result.CMD_CPU}</td>
								</tr>
								<tr>
									<td colspan="5" class="color"><spring:message code="properties.memory" /></td>
									<td>${result.CMD_MEMORY}</td>
								</tr>														
							</table>
						</div>
					</div>
				</div>

				<div id="dbmisinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p><spring:message code="properties.basic_info" /></p></div>
							<table class="list3">
								<caption>기본 정보</caption>
								<colgroup>
									<col style="width: 25%;" />
									<col style="width: 75%;" />
									<col />
								</colgroup>
								<tr>
									<th><spring:message code="properties.item" /></th>
									<th><spring:message code="properties.description" /></th>
								</tr>
								<tr>
									<td><spring:message code="properties.postgresql_version" /></td>
									<td>${result.POSTGRESQL_VERSION}</td>
								</tr>
								<tr>
									<td><spring:message code="properties.dbms_path" /></td>
									<td>${result.CMD_DBMS_PATH}</td>
								</tr>
								<tr>
									<td><spring:message code="properties.data_path" /></td>
									<td>${result.DATA_PATH}</td>
								</tr>
								<tr>
									<td><spring:message code="properties.log_path" /></td>
									<td>${result.LOG_PATH}</td>
								</tr>
								<tr>
									<td>Online <spring:message code="properties.backup_path" /></td>
									<td>${result.CMD_BACKUP_PATH}</td>
								</tr>
								<tr>
									<td>DUMP <spring:message code="properties.backup_path" /></td>
									<td>${result.PGDBAK}</td>
								</tr>
<!-- 								<tr> -->
<!-- 									<th >Archive 백업 경로</th> -->
<%-- 									<td>${result.ARCHIVE_PATH}</td> --%>
<!-- 								</tr> -->
							</table>
			
						<br><br>
						<div class="sub_tit"><p><spring:message code="properties.database_info" /></p></div>
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
										<th scope="col"><spring:message code="properties.name" /></th>
										<th scope="col"><spring:message code="properties.owner" /></th>
										<th scope="col"><spring:message code="properties.incording" /></th>
										<th scope="col"><spring:message code="properties.collate" /> </th>
										<th scope="col"><spring:message code="properties.ctype" /></th>
										<th scope="col"><spring:message code="properties.size" /></th>
										<th scope="col"><spring:message code="properties.tablespace" /></th>
										<th scope="col"><spring:message code="properties.explanation" /></th>
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
											<td>
												<c:if test="${!empty databaseInfo.description}">${databaseInfo.description}</c:if>
												<c:if test="${empty databaseInfo.description}">
												<c:forEach var="dbnmInfo" items="${resultRepoDB}">
												<c:if test="${dbnmInfo.db_nm eq databaseInfo.name}" >${dbnmInfo.db_exp}</c:if>	
												</c:forEach>
												</c:if>									
											</td>
										</tr>
									</c:forEach>
									<c:forEach var="deleteDB" items="${deleteDB}">
										<tr>
											<td><img src="../images/ico_state_01.png" style="margin-right: 5px;"/>${deleteDB}</td>
											<td>-</td>
											<td>-</td>
											<td>-</td>
											<td>-</td>
											<td>-</td>
											<td>-</td>
											<td>-</td>
										</tr>
									</c:forEach>	
								</tbody>
							</table>
						<br><br>
						<div class="sub_tit"><p><spring:message code="properties.ha_config" /></p></div>
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
										<th scope="col"><spring:message code="properties.ip" /></th>
										<th scope="col"><spring:message code="properties.server_type" /></th>
										<th scope="col"><spring:message code="properties.host" /></th>
										<th scope="col"><spring:message code="properties.status" /> </th>
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
						<div class="sub_tit"><p><spring:message code="properties.about_preferences" /></p></div>
							<table class="list3">
								<caption>주요환경설정 정보</caption>
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 23%;">
									<col style="width: 15%;">
									<col style="width: 6%;">
									<col style="width: 7%;">
									<col style="width: 10%;">
									<col style="width: 29%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col"><spring:message code="properties.category" /></th>
										<th scope="col"><spring:message code="properties.item" /></th>
										<th scope="col"><spring:message code="properties.setting_value" /></th>
										<th scope="col"><spring:message code="properties.unit" /></th>
										<th scope="col"><spring:message code="properties.min_value" /></th>
										<th scope="col"><spring:message code="properties.max_value" /></th>
										<th scope="col"><spring:message code="properties.short_desc" /></th>
									</tr>
								</thead>
								<tbody>
									<c:set var="i" value="0" />
									<c:forEach var="dbmsinfo" items="${result.CMD_DBMS_INFO}">
										 <c:choose>
									       	<c:when test="${dbmsinfo.rnum == '1' && i=='0'}">
										        <tr>
										       		<td>${dbmsinfo.category}</td>
													<td>${dbmsinfo.name}</td>
													<td>${dbmsinfo.setting}</td>
													<td>${dbmsinfo.unit}</td>
													<td>${dbmsinfo.min_val}</td>
													<td>${dbmsinfo.max_val}</td>
													<td>${dbmsinfo.short_desc}</td>
												</tr>
									       	</c:when>
											
											<c:when test="${dbmsinfo.rnum > '1' && i=='0'}">
												<tr>
													<td rowspan="${dbmsinfo.rnum}">${dbmsinfo.category}</td>
													<td>${dbmsinfo.name}</td>
													<td>${dbmsinfo.setting}</td>
													<td>${dbmsinfo.unit}</td>
													<td>${dbmsinfo.min_val}</td>
													<td>${dbmsinfo.max_val}</td>
													<td>${dbmsinfo.short_desc}</td>
												</tr>
												<c:set var="i" value="1" />
											</c:when>
									       
									       <c:when test="${dbmsinfo.rnum >= '1' && i!='0'}">
										       <tr>
													<td>${dbmsinfo.name}</td>
													<td>${dbmsinfo.setting}</td>
													<td>${dbmsinfo.unit}</td>
													<td>${dbmsinfo.min_val}</td>
													<td>${dbmsinfo.max_val}</td>
													<td>${dbmsinfo.short_desc}</td>
												</tr>
												<c:if test="${dbmsinfo.rnum == 1}">
													<c:set var="i" value="0" />
	 											</c:if>	
									       </c:when>
									  	</c:choose>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

				<div id="tablespaceinfo">
					<div class="cmm_bd">
						<div class="sub_tit"><p><spring:message code="properties.tablespace_info" /></p></div>
							<div class="overflows_areas">
								<table class="list4" >
									<caption>테이블스페이스 정보</caption>
									<colgroup>
										<col style="width: 10%;">
										<col style="width: 7%;">
										<col style="width: 6%;">
										<col style="width: 7%;">
										<col style="width: 8%;">
										<col style="width: 10%;">
										
										<col style="width: 8%;">
										<col style="width: 8%;">
										<col style="width: 11%;">
										<col style="width: 8%;">
										<col style="width: 7%;">
										<col style="width: 10%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" colspan="6"><spring:message code="properties.filesystem" /></th>
											<th scope="col" colspan="6"><spring:message code="properties.tablespace" /></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="color">Filesystem</td>
											<td class="color">Size</td>
											<td class="color">Used</td>
											<td class="color">Avail</td>
											<td class="color">Use%</td>
											<td class="color">Mounted on</td>	
											<td class="color">Name</td>
											<td class="color">Owner</td>
											<td class="color">Location</td>
											<td class="color">Options</td>
											<td class="color">Size</td>
											<td class="color">Description</td>
										</tr>
										<c:forEach var="tablespaceinfo" items="${result.CMD_TABLESPACE_INFO}">
											<tr>
												<td>${tablespaceinfo.filesystem}</td>
												<td>${tablespaceinfo.fsize}</td>
												<td>${tablespaceinfo.used}</td>
												<td>${tablespaceinfo.avail}</td>
												<td>
												<span class="iGraph">
													<span class="gBar"><span class="gAction" style="width:${tablespaceinfo.use}"></span></span>
													<span class="gPercent">${tablespaceinfo.use}</span>
												</span>	
												</td>
												<td>${tablespaceinfo.mounton}</td>
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