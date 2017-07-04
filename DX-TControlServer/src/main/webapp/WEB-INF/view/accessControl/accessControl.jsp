<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : serverAccessControl.jsp
	* @Description : serverAccessControl 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26 
	*
	*/
%>	
<script>
	var table = null;

	function fn_init() {
		table = $('#accessControlTable').DataTable({
			scrollY : "300px",
			searching : false,
			columns : [
				{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}, 
				{ data : "", className : "dt-center", defaultContent : ""}
			 ]
		});
	}
	$(window.document).ready(function() {
		fn_init();
			
/*  		$.ajax({
			url : "/selectAccessControl.do",
			data : {
			},
			dataType : "json",
			type : "post",
			error : function(xhr, status, error) {
				alert("실패")
			},
			success : function(result) {
				table.clear().draw();
				table.rows.add(result).draw();
			}
		}); 
	 */
	});
	
	/* 조회 버튼 클릭시*/
	function fn_select() {
		
	}
	
	/* 등록 버튼 클릭시*/
	function fn_insert() {
		window.open("/popup/accessControlRegForm.do?act=i","accessControlRegForm","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=600,height=400,top=0,left=0");
	}
	
	/* 수정 버튼 클릭시*/
	function fn_update() {
		window.open("/popup/accessControlRegForm.do?act=u","accessControlRegForm","location=no,menubar=no,resizable=yes,scrollbars=no,status=no,width=600,height=400,top=0,left=0");
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {
		
	}
	
	
	function windowPopup(){
		var popUrl = "/popup/accessControlRegForm.do?act=i"; // 서버 url 팝업경로
		var width = 920;
		var height = 480;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=no, status=no, toolbar=no, titlebar=yes, location=no,";
		
		window.open(popUrl,"",popOption);
	}
	

</script>
		<!-- contents -->
			<div id="contents">
				<div class="location">
					<ul>
						<li>PG Server1</li>
						<li>접근제어관리</li>
						<li class="on">서버접근제어</li>
					</ul>
				</div>

				<div class="contents_wrap">
					<h4>접근제어 리스트 <a href="#n"><img src="../images/ico_tit.png" alt="" /></a></h4>
					<div class="contents">
						<div class="cmm_grp">
							<div class="control_grp">
								<div class="control_lt">
									<div class="inner">
										<p class="tit">Database 목록</p>
										<div class="control_list">
											<ul>
												<li>
													<div class="inp_chk">
														<img src="/images/chk.png" style="width: 22px; height: 22px; line-height: 22px; margin: 0px 10px 0 0;">
														<label for="server">${db_svr_nm}</label>
													</div>
													<ul>
														<c:forEach var="resultSet" items="${resultSet}">
															<li>
																<div class="inp_chk">
																	<input type="checkbox" id="${resultSet.db_nm}" name="${resultSet.db_nm}" />
																	<label for="${resultSet.db_nm}">${resultSet.db_nm}</label>
																</div>
															</li>															
														</c:forEach>
													</ul>
												</li>
											</ul>
										</div>
									</div>
								</div>
								
								<div class="control_rt">
									<div class="btn_type_01">
										<span>
											<div class="search_area">
												<input type="text" class="txt search" />
												<button class="search_btn">검색</button>
											</div>
										</span>
										<span class="btn" onclick="windowPopup();"><button>등록</button></span>
										<span class="btn"><button>수정</button></span>
										<a href="#n" class="btn"><span>삭제</span></a>
									</div>
									<div class="inner">
										<p class="tit">접근제어 리스트</p>
										<div class="overflow_area">
											<table id="accessControlTable" class="display" cellspacing="0" width="100%">
												<thead>
													<tr>
														<th></th>
														<th>No</th>
														<th>User</th>
														<th>IP Address</th>
														<th>Method</th>
														<th>Option</th>
														<th>Type</th>
													</tr>
												</thead>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div><!-- // contents -->
			
			
			
	<!-- <h2>서버접근제어</h2>
	<div style="overflow: scroll; overflow-x: hidden; width: 30%; height: 500px; padding: 5px; float: left; margin-right: 50px;">
		<h3>DB서버</h3>
	</div>
	<div style="overflow: scroll; overflow-x: hidden; width: 60%; height: 500px; padding: 5px; float: left;">
		<h3>접근제어리스트</h3>
		<div id="search" style="float: left; ">
			<input type="text" >	
		</div>
		<div id="button" style="float: right;">
			<button onclick="fn_select()">조회</button>
			<button onclick="fn_insert()">등록</button>
			<button onclick="fn_update()">수정</button>
			<button onclick="fn_delete()">삭제</button>
		</div>
		<table id="accessControlTable" class="display" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th></th>
					<th>No</th>
					<th>User</th>
					<th>IP Address</th>
					<th>Method</th>
					<th>Option</th>
					<th>Type</th>
				</tr>
			</thead>
		</table>
	</div>
 -->