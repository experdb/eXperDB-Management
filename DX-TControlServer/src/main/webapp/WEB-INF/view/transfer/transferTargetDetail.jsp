<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : transferTargetDetail.jsp
	* @Description : transferTargetDetail 화면
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
<script type="text/javascript">

</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>전송대상 설정 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
			<div class="location">
				<ul>
					<li>Transfer</li>
					<li>${cnr_nm}</li>
					<li class="on">전송대상 설정</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 75px;" />
							<col style="width: 225px;" />
							<col style="width: 75px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t5">연결이름</th>
								<td><input type="text" class="txt t3" name="" value="${trf_trg_cnn_nm}" readonly="readonly"/></td>
								<th scope="row" class="t6">연결유형</th>
								<td><input type="text" class="txt t3" name="" value="${connector_type}" readonly="readonly"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area2">
					<div class="row_th">상세옵션</div>
					<table class="list row_tbl pd_type1">
						<caption>DB 서버 조회 리스트</caption>
						<colgroup>
							<col style="width: 30%;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">항목</th>
								<th scope="col">값</th>
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
		</div>
	</div>
</div>
<!-- // contents -->