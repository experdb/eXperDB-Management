<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : dbAuthority.jsp
	* @Description : DbAuthority 화면
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
	var dbTable = null;
	var dbServerTable = null;

	function fn_init() {
		userTable = $('#user').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "rownum",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_id",className : "dt-center",defaultContent : ""}, 
			            {data : "usr_nm",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
		dbServerTable = $('#dbserver').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
			          ]
		});
		
		dbTable = $('#db').DataTable({
			searching : false,
			paging : false,
			columns : [ 
			            {data : "",className : "dt-center",defaultContent : ""}, 
			            {data : "",className : "dt-center",defaultContent : ""} 
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
<body>
	<!-- contents -->
			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>DB 권한 관리 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>Admin</li>
								<li class="on">DB 권한 관리</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="db_roll_grp">
								<div class="db_roll_lt">
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
								<div class="db_roll_rt">
									<div class="btn_type_01">
										<span class="btn"><button>저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">DB서버 권한</p>
										<div class="overflow_area">
											<table class="db_table">
												<caption>DB서버 권한</caption>
												<colgroup>
													<col style="width:70%" />
													<col style="width:30%" />
												</colgroup>
												<thead>
													<tr>
														<th scope="col">DB서버 권한</th>
														<th scope="col">권한</th>
													</tr>
												</thead>
												<tbody>
													<tr class="db_tit">
														<th scope="row">DB server 1</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_1_all" name="db_server_1_all" checked="checked" />
																<label for="db_server_1_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_1_1" name="db_server_1" checked="checked" />
																<label for="db_server_1_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_1_2" name="db_server_1" checked="checked" />
																<label for="db_server_1_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_1_3" name="db_server_1" checked="checked" />
																<label for="db_server_1_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_1_4" name="db_server_1" checked="checked" />
																<label for="db_server_1_4"></label>
															</div>
														</td>
													</tr>
													<tr class="db_tit">
														<th scope="row">DB server 2</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_all" name="db_server_2_all" checked="checked" />
																<label for="db_server_2_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_1" name="db_server_2" checked="checked" />
																<label for="db_server_2_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_2" name="db_server_2" checked="checked" />
																<label for="db_server_2_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_3" name="db_server_2" checked="checked" />
																<label for="db_server_2_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_4" name="db_server_2" checked="checked" />
																<label for="db_server_2_4"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_5" name="db_server_2" checked="checked" />
																<label for="db_server_2_5"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk">
																<input type="checkbox" id="db_server_2_6" name="db_server_2" checked="checked" />
																<label for="db_server_2_6"></label>
															</div>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
								<div class="db_roll_last">
									<div class="btn_type_01">
										<span class="btn"><button>저장</button></span>
									</div>
									<div class="inner">
										<p class="tit">DB 권한</p>
										<div class="overflow_area">
											<table class="db_table">
												<caption>DB 권한</caption>
												<colgroup>
													<col style="width:70%" />
													<col style="width:30%" />
												</colgroup>
												<thead>
													<tr>
														<th scope="col">DB 권한</th>
														<th scope="col">권한</th>
													</tr>
												</thead>
												<tbody>
													<tr class="db_tit">
														<th scope="row">DB server 1</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_all" name="db_1_all" checked="checked" />
																<label for="db_1_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_1" name="db_1" checked="checked" />
																<label for="db_1_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_2" name="db_1" checked="checked" />
																<label for="db_1_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_3" name="db_1" checked="checked" />
																<label for="db_1_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_1_4" name="db_1" checked="checked" />
																<label for="db_1_4"></label>
															</div>
														</td>
													</tr>
													<tr class="db_tit">
														<th scope="row">DB server 2</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_all" name="db_2_all" checked="checked" />
																<label for="db_2_all"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">rman백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_1" name="db_2" checked="checked" />
																<label for="db_2_1"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">dump백업설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_2" name="db_2" checked="checked" />
																<label for="db_2_2"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">접근제어설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_3" name="db_2" checked="checked" />
																<label for="db_2_3"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_4" name="db_2" checked="checked" />
																<label for="db_2_4"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_5" name="db_2" checked="checked" />
																<label for="db_2_5"></label>
															</div>
														</td>
													</tr>
													<tr>
														<th scope="row">감사설정</th>
														<td>
															<div class="inp_chk chk2">
																<input type="checkbox" id="db_2_6" name="db_2" checked="checked" />
																<label for="db_2_6"></label>
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