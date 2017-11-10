<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	/**
	* @Class Name : accesscontrolHistory.jsp
	* @Description : accesscontrolHistory 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.09.18     최초 생성
	*
	* author 김주영 사원
	* since 2017.09.18
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#accesscontrolHistoryTable').DataTable({
			scrollY : "250px",
			paging: false,
			searching : false,
			scrollX: true,
			sort: false,
			columns : [
			{ data : "rownum", className : "dt-center", defaultContent : ""}, 
			{ data : "ctf_tp_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "dtb", className : "dt-center", defaultContent : ""}, 
			{ data : "prms_usr_id", className : "dt-center", defaultContent : ""}, 
			{ data : "prms_ipadr", className : "dt-center", defaultContent : ""},
			{ data : "prms_ipmaskadr", className : "dt-center", defaultContent : ""}, 
			{ data : "ctf_mth_nm", className : "dt-center", defaultContent : ""}, 
			{ data : "opt_nm", className : "dt-center", defaultContent : ""}, 
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '60px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');

	    $(window).trigger('resize');
	}
	
	$(window.document).ready(function() {
		fn_init();
		if($("#lst_mdf_dtm").val()!=null){
			$.ajax({
				url : "/selectAccessControlHistory.do",
				data : {
					svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {
					table.clear().draw();
					table.rows.add(result).draw();
				}
			});
		}

	});
	
	/*조회버튼 클릭시*/
	function fn_select(){
		if($("#lst_mdf_dtm").val()==null){
			alert("정책변경이력이 없습니다.");
			return false;
		}
			$.ajax({
				url : "/selectAccessControlHistory.do",
				data : {
					svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
				},
				dataType : "json",
				type : "post",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", true);
			     },
				error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
						 location.href = "/";
					} else if(xhr.status == 403) {
						alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
			             location.href = "/";
					} else {
						alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
				success : function(result) {
					table.clear().draw();
					table.rows.add(result).draw();
				}
			});
	}
	
	/*복원버튼 클릭시*/
	function fn_recovery(){
		if($("#lst_mdf_dtm").val()==null){
			alert("정책변경이력이 없습니다.");
			return false;
		}
		if (!confirm("정말 복원하시겠습니까?")) return false;
		$.ajax({
			url : "/recoveryAccessControlHistory.do",
			data : {
				db_svr_id : "${db_svr_id}",
				svr_acs_cntr_his_id : $("#lst_mdf_dtm").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ request.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ request.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {			
				if (result=="true") {
					alert("복원되었습니다.");
				}else if(result=="pgaudit"){
					alert("서버에 pgaudit Extension 이 설치되지 않았습니다.");
				}else if(result=="agent"){
					alert("서버에 experdb엔진이 설치되지 않았습니다.");
				}else {
					alert("복원에 실패하였습니다.");
				}
			}
		});
	}
	

</script>
<style>
.inner .tit {
    height: 28px;
    line-height: 28px;
    padding-left: 27px;
    border: 1px solid #b8c3c6;
    border-bottom: none;
    background: #e4e9ec;
    color: #101922;
    font-size: 13px;
    font-family: 'Nanum Square Bold';  
}
</style>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>정책변경이력<a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>접근제어 변경 이력을 조회하고, 조회된 이력 중 원하는 항목으로 복원합니다.</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>접근제어관리</li>
					<li class="on">정책변경이력</li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()">조회</button></span>
					<span class="btn"><button onclick="fn_recovery()">복원</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 130px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">수정일시</th>
								<td>
									<select class="select t3" id="lst_mdf_dtm">
										<c:forEach var="result" items="${lst_mdf_dtm}">
												<option value="${result.svr_acs_cntr_his_id}">${result.lst_mdf_dtm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="inner">
					<p class="tit"><img src="/images/ico_left_1.png" style="line-height: 22px; margin: 0px 10px 0 0;">${db_svr_nm}</p>				
					<div class="overflow_area">
						<table id="accesscontrolHistoryTable" class="display" cellspacing="0" width="100%">
							<thead>
								<tr>
									<th width="20">No</th>
									<th width="60">Type</th>
									<th width="100">Database</th>
									<th width="100">User</th>
									<th width="100">IP Address</th>
									<th width="100">IP Mask</th>
									<th width="100">Method</th>
									<th width="100">Option</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>