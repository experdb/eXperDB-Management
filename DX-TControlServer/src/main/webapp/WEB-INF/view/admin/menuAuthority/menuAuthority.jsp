<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : menuAuthority.jsp
	* @Description : MenuAuthority 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.29     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.29
	*
	*/
%>
<script>
var userTable = null;
var menuTable = null;

function fn_init() {
	userTable = $('#user').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		paging: false,
		columns : [
		{data : "rownum", className : "dt-center", defaultContent : ""}, 
		{data : "usr_id", className : "dt-center", defaultContent : ""}, 
		{data : "usr_nm", className : "dt-center", defaultContent : ""}
		 ]
	});
	menuTable = $('#menu').DataTable({
		scrollY : "300px",
		processing : true,
		searching : false,
		paging: false,
		columns : [
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}, 
		{data : "", className : "dt-center", defaultContent : ""}
		 ]
	});
}

$(window.document).ready(function() {
	fn_init();
	$.ajax({
		url : "/selectUserManager.do",
		dataType : "json",
		type : "post",
		error : function(xhr, status, error) {
			alert("실패")
		},
		success : function(result) {
			userTable.clear().draw();
			userTable.rows.add(result).draw();
		}
	});

});
</script>
			<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>메뉴 권한 관리 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li class="on">메뉴 권한 관리</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="menu_roll_grp">
								<div class="menu_roll_lt">
									<div class="btn_type_01">
										<div class="search_area">
											<input type="text" class="txt search">
											<button class="search_btn">검색</button>
										</div>
									</div>
									<div class="inner">
										<p class="tit">사용자 선택</p>
										<div class="overflow_area">
											<table id="user" class="list" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th>No</th>
														<th>아이디</th>
														<th>사용자명</th>
													</tr>
													</thead>
											</table>
										</div>
									</div>
								</div>
								<div class="menu_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button>저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">메뉴권한</p>
										<div class="overflow_area">
											<table class="menu_table">
												<caption>메뉴권한</caption>
												<colgroup>
													<col />
													<col style="width:30%" />
													<col style="width:30%" />
													<col style="width:10%" />
													<col style="width:10%" />
												</colgroup>
												<thead>
													<tr>
														<th scope="col" colspan="3">메뉴</th>
														<th scope="col">읽기</th>
														<th scope="col">쓰기</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th scope="row" rowspan="4">Functions</th>
														<th scope="row" rowspan="2">Scheduler</th>
														<td>스케쥴 설정</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_1_1" name="chk_menu1" checked="checked" />
																<label for="chk_menu_1_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_1_2" name="chk_menu1" checked="checked" />
																<label for="chk_menu_1_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td>스케쥴 조회</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_2_1" name="chk_menu2" checked="checked" />
																<label for="chk_menu_2_2"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_2_2" name="chk_menu2" checked="checked" />
																<label for="chk_menu_2_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row" rowspan="2">Transfer</th>
														<td>전송설정</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_3_1" name="chk_menu3" checked="checked" />
																<label for="chk_menu_3_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_3_2" name="chk_menu3" checked="checked" />
																<label for="chk_menu_3_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td>Connector 등록</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_4_1" name="chk_menu4" checked="checked" />
																<label for="chk_menu_4_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_4_2" name="chk_menu4" checked="checked" />
																<label for="chk_menu_4_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row" rowspan="8">Admin</th>
														<th scope="row" rowspan="3">DB 서버관리</th>
														<td>DB Tree</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_5_1" name="chk_menu5" checked="checked" />
																<label for="chk_menu_5_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_5_2" name="chk_menu5" checked="checked" />
																<label for="chk_menu_5_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td>DB Server</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_6_1" name="chk_menu6" checked="checked" />
																<label for="chk_menu_6_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_6_2" name="chk_menu6" checked="checked" />
																<label for="chk_menu_6_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td>Database</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_7_1" name="chk_menu7" checked="checked" />
																<label for="chk_menu_7_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_7_2" name="chk_menu7" checked="checked" />
																<label for="chk_menu_7_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="2">사용자관리</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_8_1" name="chk_menu8" checked="checked" />
																<label for="chk_menu_8_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_8_2" name="chk_menu8" checked="checked" />
																<label for="chk_menu_8_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="2">메뉴권한관리</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_9_1" name="chk_menu9" checked="checked" />
																<label for="chk_menu_9_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_9_2" name="chk_menu9" checked="checked" />
																<label for="chk_menu_9_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="2">DB 권한관리</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_10_1" name="chk_menu10" checked="checked" />
																<label for="chk_menu_10_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_10_2" name="chk_menu10" checked="checked" />
																<label for="chk_menu_10_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="2">회원접근이력</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_11_1" name="chk_menu11" checked="checked" />
																<label for="chk_menu_11_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_11_2" name="chk_menu11" checked="checked" />
																<label for="chk_menu_11_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<td colspan="2">Agent모니터링</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_12_1" name="chk_menu12" checked="checked" />
																<label for="chk_menu_12_1"></label>
															</div>
														</td>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="chk_menu_12_2" name="chk_menu12" checked="checked" />
																<label for="chk_menu_12_2"></label>
															</div>
														</td>
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
			</div><!-- // contents -->
