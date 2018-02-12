<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : securityPolicy.jsp
	* @Description : securityPolicy 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 김주영 사원
	* since 2018.01.04 
	*
	*/
%>
<script>
var table = null;

	function fn_init() {
		table = $('#policyTable').DataTable({
			scrollY : "310px",
			searching : false,
			deferRender : true,
			scrollX: true,
			columns : [
				{ data : "", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
				{ data : "rnum", className : "dt-center", defaultContent : ""}, 
				{ data : "profileName", className : "dt-center", defaultContent : ""}, 
				{ data : "profileNote", className : "dt-center", defaultContent : ""}, 
				{ data : "profileStatusName", className : "dt-center", defaultContent : ""}, 
				{ data : "createDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "createName", className : "dt-center", defaultContent : ""}, 
				{ data : "updateDateTime", className : "dt-center", defaultContent : ""}, 
				{ data : "updateName", className : "dt-center", defaultContent : ""}
			 ]
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '20px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '80px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	
	    $(window).trigger('resize');
	    
		//더블 클릭시
		$('#policyTable tbody').on('dblclick', 'tr', function() {
	
		});
	}
	$(window.document).ready(function() {
		fn_init();
		$.ajax({
			url : "/selectSecurityPolicy.do",
			data : {
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				table.clear().draw();
				if(result.data!=null){
					table.rows.add(result.data).draw();
				}
			}
		});
	});

	/* 조회 버튼 클릭시*/
	function fn_select() {

	}

	/* 수정 버튼 클릭시*/
	function fn_update() {
		var datas = table.rows('.selected').data();
		if (datas.length <= 0) {
			alert('<spring:message code="message.msg35" />');
			return false;
		}else if (datas.length >1){
			alert('<spring:message code="message.msg38" />');
		}
		var form = document.modifyForm;
		form.action = "/securityPolicyModify.do";
		form.submit();
		return;
	}
	
	/* 삭제 버튼 클릭시*/
	function fn_delete() {

	}
</script>
<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>정책리스트<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li>보안정책관리설명</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>데이터암호화</li>
					<li>보안정책</li>
					<li class="on">정책리스트</li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn" onclick="fn_select();"><button>조회</button></span>
					<span class="btn" onclick="fn_insert();"><a href="/securityPolicyInsert.do"><button>등록</button></a></span>
					<span class="btn" onclick="fn_update();"><button>수정</button></span>
					<span class="btn" onclick="fn_delete();"><button>삭제</button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col />
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9">정책이름</th>
								<td><input type="text" class="txt t2" id="policyName" /></td>
								<th scope="row" class="t9">정책상태</th>
								<td><select class="select t5" id="policyStatus">
										<option value="Active">Active</option>
								</select></td>
							</tr>						
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="policyTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="20"></th>
								<th width="40">No</th>
								<th width="50">정책이름</th>
								<th width="100">정책설명</th>
								<th width="100">정책상태</th>
								<th width="100">등록자</th>
								<th width="100">등록일시</th>
								<th width="80">수정자</th>
								<th width="100">수정일시</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
