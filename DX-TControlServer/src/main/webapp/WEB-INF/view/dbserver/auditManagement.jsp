<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/**
	* @Class Name : auditManagement.jsp
	* @Description : Audit 등록/수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.06     최초 생성
	*
	* author 박태혁
	* since 2017.07.06
	*
	*/
%>

			<div id="contents">
				<div class="contents_wrap">
					<div class="contents_tit">
						<h4>스케쥴 리스트화면 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
						<div class="location">
							<ul>
								<li>My Page</li>
								<li class="on">스케쥴 리스트</li>
							</ul>
						</div>
					</div>
					<div class="contents">
						<div class="cmm_grp">
							<div class="btn_type_01">
								<span class="btn btnC_01"><button>저장</button></span>
								<a href="#n" class="btn"><span>취소</span></a>
							</div>
							<div class="sch_form p1">
								<div class="inp_chk chk3">
									<input type="checkbox" id="log_atv" name="log_atv" checked="checked">
									<label for="log_atv"><span class="chk_img"><img src="../images/popup/ico_box_1.png" alt="" /></span>감사로그 활성화</label>
								</div>
							</div>
							<div class="layout_grp">
								<div class="layout_lt">
									<table class="log_table">
										<caption>로그수준</caption>
										<colgroup>
											<col style="width:128px" />
											<col />
											<col style="width:128px" />
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th scope="row">로그수준</th>
												<td colspan="3">
													<select class="select" name="" id="">
														<option value="">INFO</option>
													</select>
												</td>
											</tr>
											<tr>
												<th scope="row">로그종류</th>
												<td colspan="3">
													<div class="log_list">
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_1" name="log_1" checked="checked">
																<label for="log_1">Read</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_2" name="log_1" checked="checked">
																<label for="log_2">Write</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_3" name="log_1" checked="checked">
																<label for="log_3">Function</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_4" name="log_1" checked="checked">
																<label for="log_4">ROLE</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_5" name="log_1">
																<label for="log_5">DDL</label>
															</div>
														</span>
														<span>
															<div class="inp_chk">
																<input type="checkbox" id="log_6" name="log_1">
																<label for="log_6">MISC</label>
															</div>
														</span>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row">로그카탈로그</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="log_2_1" name="log_2" checked="checked">
														<label for="log_2_1">활성화</label>
													</div>
												</td>
												<th scope="row" class="double">로그 Parameter</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="log_3_1" name="log_3" checked="checked">
														<label for="log_3_1">활성화</label>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row">로그 Relation</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="log_4_1" name="log_4" checked="checked">
														<label for="log_4_1">활성화</label>
													</div>
												</td>
												<th scope="row" class="double">로그 Statement</th>
												<td>
													<div class="inp_chk">
														<input type="checkbox" id="log_5_1" name="log_5">
														<label for="log_5_1">활성화</label>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="layout_rt">
									<p class="ly_tit">Database</p>
									<div class="overflow_area">
										<table class="list">
											<caption>Database 리스트</caption>
											<colgroup>
												<col style="width:12%;" />
												<col style="width:12%;" />
												<col />
											</colgroup>
											<thead>
												<tr>
													<th scope="col">
														<div class="inp_chk">
															<input type="checkbox" id="chk_all" name="chk_all" checked="checked" />
															<label for="chk_all"></label>
														</div>
													</th>
													<th scope="col">NO</th>
													<th scope="col">Database</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>
														<div class="inp_chk">
															<input type="checkbox" id="chk_1_1" name="chk"  />
															<label for="chk_1_1"></label>
														</div>
													</td>
													<td>1</td>
													<td>postgres</td>
												</tr>
												<tr>
													<td>
														<div class="inp_chk">
															<input type="checkbox" id="chk_2_1" name="chk"  />
															<label for="chk_2_1"></label>
														</div>
													</td>
													<td>2</td>
													<td>postgres</td>
												</tr>
												<tr>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<td></td>
													<td></td>
													<td></td>
												</tr>
												<tr>
													<td></td>
													<td></td>
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