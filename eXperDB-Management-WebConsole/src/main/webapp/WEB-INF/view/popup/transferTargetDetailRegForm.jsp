<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : transferTargetDetailRegForm.jsp
	* @Description : transferTargetDetailRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.20     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.20
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="data_transfer.transfer_datile"/></title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body>

	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="data_transfer.transfer_datile"/></p>
			<div class="pop_cmm">
				<table class="write bdtype1">
					<caption><spring:message code="data_transfer.transfer_datile"/></caption>
					<colgroup>
						<col style="width:80px;" />
						<col style="width:300px;" />
						<col style="width:80px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.conn_name"/></th>
							<td><input type="text" class="txt t4" name="" value="${trf_trg_cnn_nm}" readonly="readonly" /></td>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.conn_type"/></th>
							<td><input type="text" class="txt t5" name="" value="${connector_type}" readonly="readonly" /></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="data_transfer.detail_option"/></p>
				<div class="overflow_area" style="height: 290px;">
					<table class="list pd_type3">
						<caption><spring:message code="data_transfer.detail_option"/></caption>
						<colgroup>
							<col style="width: 50%;" />
							<col style="width: 50%;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><spring:message code="properties.item" /></th>
								<th scope="col"><spring:message code="data_transfer.value"/></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="tal">connector.class</td>
								<td class="tal">${connector_class}</td>
							</tr>
							<tr>
								<td class="tal">flush.size</td>
								<td class="tal">${flush_size}</td>
							</tr>
							<tr>
								<td class="tal">hadoop.conf.dir</td>
								<td class="tal">${hadoop_conf_dir}</td>
							</tr>
							<tr>
								<td class="tal">name</td>
								<td class="tal">${trf_trg_cnn_nm}</td>
							</tr>
							<tr>
								<td class="tal">Rotate.interval.ms</td>
								<td class="tal">${rotate_interval_ms}</td>
							</tr>
							<tr>
								<td class="tal">tasks.max</td>
								<td class="tal">${task_max}</td>
							</tr>
							<tr>
								<td class="tal">topics</td>
								<td class="tal">${topics}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close"/></span></a>
			</div>
		</div>
	</div>


</body>
</html>