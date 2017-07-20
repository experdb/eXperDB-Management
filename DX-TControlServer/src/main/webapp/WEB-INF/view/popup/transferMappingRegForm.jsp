<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : transferMappingRegForm.jsp
	* @Description : transferMappingRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.24
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Database 매핑작업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script>

</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Database 맵핑 설정하기</p>
		<table class="write">
			<caption>전송대상 설정 등록하기</caption>
			<colgroup>
				<col style="width:105px;" />
				<col style="width:280px;" />
				<col style="width:80px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1">Connector명</th>
					<td><input type="text" class="txt t3 bg1" name="" value="TextConnection" /></td>
					<th>&nbsp;</th>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">서버명</th>
					<td>
						<select class="select t3" name="" id="">
							<option value=""></option>
							<option value="">서버명1</option>
							<option value="">서버명2</option>
						</select>
					</td>
					<th scope="row" class="ico_t1">DB명</th>
					<td>
						<select class="select" name="" id="">
							<option value=""></option>
							<option value="">DB명1</option>
							<option value="">DB명2</option>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="mapping_area">
			<div class="mapping_lt">
				<p class="tit">테이블 리스트</p>
				<div class="overflow_area">
					<table class="list pd_type2">
						<caption>테이블 목록</caption>
						<colgroup>
							<col style="width:43px;" />
							<col style="width:184px;" />
							<col style="width:102px;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">
									<div class="inp_chk">
										<input type="checkbox" id="chk_all" name="chk1" checked="checked" />
										<label for="chk_all"></label>
									</div>
								</th>
								<th scope="col">Schema</th>
								<th scope="col">Table명</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<div class="inp_chk">
										<input type="checkbox" id="chk_1" name="chk1" checked="checked" />
										<label for="chk_1"></label>
									</div>
								</td>
								<td>TestSchema 1</td>
								<td>Table 1</td>
							</tr>
							<tr>
								<td>
									<div class="inp_chk">
										<input type="checkbox" id="chk_2" name="chk1" checked="checked" />
										<label for="chk_2"></label>
									</div>
								</td>
								<td>TestSchema 2</td>
								<td>Table 2</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="mapping_rt">
				<p class="tit">Connector 테이블 리스트</p>
				<div class="overflow_area">
					<table class="list pd_type2">
						<caption>Connector 테이블 목록</caption>
						<colgroup>
							<col style="width:43px;" />
							<col style="width:184px;" />
							<col style="width:102px;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">
									<div class="inp_chk">
										<input type="checkbox" id="chk_all2" name="chk2" checked="checked" />
										<label for="chk_all2"></label>
									</div>
								</th>
								<th scope="col">Schema</th>
								<th scope="col">Table명</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<div class="inp_chk">
										<input type="checkbox" id="chk_21" name="chk2" checked="checked" />
										<label for="chk_21"></label>
									</div>
								</td>
								<td>TestSchema 1</td>
								<td>Table 1</td>
							</tr>
							<tr>
								<td>
									<div class="inp_chk">
										<input type="checkbox" id="chk_22" name="chk2" checked="checked" />
										<label for="chk_22"></label>
									</div>
								</td>
								<td>TestSchema 2</td>
								<td>Table 2</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="mapping_btn">
				<a href="#n"><img src="../../images/popup/ico_p_4.png" alt="전체우로" /></a>
				<a href="#n"><img src="../../images/popup/ico_p_5.png" alt="한개우로" /></a>
				<a href="#n"><img src="../../images/popup/ico_p_6.png" alt="전체좌로" /></a>
				<a href="#n"><img src="../../images/popup/ico_p_7.png" alt="한개좌로" /></a>
			</div>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01"><button>맵핑저장</button></span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>
</body>
</html>