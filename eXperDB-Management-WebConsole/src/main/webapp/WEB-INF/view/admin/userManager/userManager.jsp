<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : userManager.jsp
	* @Description : UserManager 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.25     최초 생성
	*
	* author 김주영 사원
	* since 2017.05.25
	*
	*/
%>
<script>
var table = null;

function fn_init() {
	table = $('#userListTable').DataTable({
		scrollY : "245px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{ data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{ data : "idx", className : "dt-center", defaultContent : ""}, 
		{ data : "usr_id", className : "dt-center", defaultContent : ""}, 
		{ data : "bln_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "usr_nm", className : "dt-center", defaultContent : ""}, 
		{ data : "cpn", className : "dt-center", defaultContent : ""}, 
		{
			data : "use_yn",
			render : function(data, type, full, meta) {
				var html = "";
				if (data == "Y") {
					html += "<spring:message code='dbms_information.use' />";
				} else {
					html += "<spring:message code='dbms_information.unuse' />";
				}
				return html;
			},
			className : "dt-center",
			defaultContent : ""
		},
		{ data : "usr_expr_dt", className : "dt-center", defaultContent : ""}
		]
	});

	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '20px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '120px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '80px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
    $(window).trigger('resize'); 
    
	//더블 클릭시
	if("${wrt_aut_yn}" == "Y"){
		$('#userListTable tbody').on('dblclick','tr',function() {
			var data = table.row(this).data();
			var usr_id = data.usr_id;				
			var popUrl = "/popup/userManagerRegForm.do?act=u&usr_id=" + encodeURI(usr_id); // 서버 url 팝업경로
			var width = 1000;
			var height = 570;
			var left = (window.screen.width / 2) - (width / 2);
			var top = (window.screen.height /2) - (height / 2);
			var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			window.open(popUrl,"",popOption);
		});	
	}
}
$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	$.ajax({
		url : "/selectUserManager.do",
		data : {
			type : $("#type").val(),
			search : "%" + $("#search").val() + "%",
			use_yn : $("#use_yn").val(),
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
			table.rows.add(result).draw();
		}
	});

});

function fn_buttonAut(){
	var btnSelect = document.getElementById("btnSelect"); 
	var btnInsert = document.getElementById("btnInsert"); 
	var btnUpdate = document.getElementById("btnUpdate"); 
	var btnDelete = document.getElementById("btnDelete"); 
	
	if("${wrt_aut_yn}" == "Y"){
		btnInsert.style.display = '';
		btnUpdate.style.display = '';
		btnDelete.style.display = '';
	}else{
		btnInsert.style.display = 'none';
		btnUpdate.style.display = 'none';
		btnDelete.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		btnSelect.style.display = '';
	}else{
		btnSelect.style.display = 'none';
	}
}	

/*조회버튼 클릭시*/
function fn_select(){
	$.ajax({
		url : "/selectUserManager.do",
		data : {
			type : $("#type").val(),
			search : "%" + $("#search").val() + "%",
			use_yn : $("#use_yn").val(),
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
			table.rows.add(result).draw();
		}
	});
}


/* 등록버튼 클릭시*/
function fn_insert() {
	var popUrl = "/popup/userManagerRegForm.do?act=i"; // 서버 url 팝업경로
	var width = 1000;
	var height = 570;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
	window.open(popUrl,"",popOption);
}

/* 수정버튼 클릭시*/
function fn_update() {
	var rowCnt = table.rows('.selected').data().length;
	if (rowCnt == 1) {
		var usr_id = table.row('.selected').data().usr_id;
		var popUrl = "/popup/userManagerRegForm.do?act=u&usr_id=" +  encodeURI(usr_id); // 서버 url 팝업경로
		var width = 1000;
		var height = 570;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";			
		window.open(popUrl,"",popOption);
	} else {
		alert("<spring:message code='message.msg04' />");
		return false;
	}
}

/*삭제 버튼 클릭시*/
function fn_delete(){
	var usr_id = "<%=(String)session.getAttribute("usr_id")%>"
	var datas = table.rows('.selected').data();
	if (datas.length <= 0) {
		alert("<spring:message code='message.msg04' />");
		return false;
	} else {
		if (!confirm('<spring:message code="message.msg162"/>'))return false;
		var rowList = [];
		for (var i = 0; i < datas.length; i++) {
			if(datas[i].usr_id=="admin"){
				alert("<spring:message code='message.msg10' />");
				return false;
			}else if(datas[i].usr_id==usr_id){
				alert("<spring:message code='message.msg11' />");
				return false;
			}else{
				rowList += datas[i].usr_id + ',';	
			}				
		}
		$.ajax({
			url : "/deleteUserManager.do",
			data : {
				usr_id : rowList,
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
				if (result) {
					alert("<spring:message code='message.msg37' />");
					fn_select();
				}else{
					alert("<spring:message code='message.msg13' />");
				}
			}
		});
	}
}	
</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.user_management" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.user_management_01" /> </li>
					<li><spring:message code="help.user_management_02" /> </li>	
					<li><spring:message code="help.user_management_03" /> </li>					
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li class="on"><spring:message code="menu.user_management" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onclick="fn_select()" id="btnSelect"><spring:message code="common.search" /></button></span>
					<span class="btn"><button onclick="fn_insert()" id="btnInsert"><spring:message code="common.registory" /></button></span>
					<span class="btn"><button onclick="fn_update()" id="btnUpdate"><spring:message code="common.modify" /></button></span>
					<a href="#n" class="btn" id="btnDelete" onclick="fn_delete()"><span><spring:message code="common.delete" /></span></a>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width: 120px;" />
							<col style="width: 180px;" />
							<col style="width: 200px;" />
							<col style="width: 80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.searchCondition"/></th>
								<td>
									<select class="select t5" id="type">
										<option value="usr_nm"><spring:message code="user_management.user_name" /></option>
										<option value="usr_id"><spring:message code="user_management.id" /></option>
									</select>
								</td>
								<td><input type="text" class="txt t2" id="search" /></td>
								<th scope="row" class="t9"><spring:message code="user_management.use_yn" /></th>
								<td>
									<select class="select t5" id="use_yn">
										<option value="%"><spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /></option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="userListTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="10"></th>
								<th width="20"><spring:message code="common.no" /></th>
								<th width="120"><spring:message code="user_management.id" /></th>
								<th width="100"><spring:message code="user_management.company" /></th>
								<th width="100"><spring:message code="user_management.user_name" /></th>
								<th width="100"><spring:message code="user_management.contact" /></th>
								<th width="80"><spring:message code="user_management.use_yn" /></th>
								<th width="100"><spring:message code="user_management.expiration_date" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>