<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : dbServer.jsp
	* @Description : dbServer 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.06.01
	*
	*/
%>

<script>
var table = null;

function fn_init() {
		/* ********************************************************
		 * 서버리스트 (데이터테이블)
		 ******************************************************** */
		table = $('#serverList').DataTable({	
		scrollY : "245px",
		searching : false,
		deferRender : true,
		scrollX: true,
		bSort: false,
		columns : [
		{data : "idx", defaultContent : ""},
		{data : "db_svr_nm", defaultContent : ""},
		{data : "ipadr", defaultContent : ""},
		{data : "dft_db_nm", defaultContent : ""},
		{data : "portno", defaultContent : ""},
		{data : "svr_spr_usr_id", defaultContent : ""},
        {data : "useyn", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(full.useyn == 'Y'){
	              data = '<spring:message code="dbms_information.use" />';      
	           }else{
	        	  data ='<spring:message code="dbms_information.unuse" />';
	           }
	           return data;
	        }},
		{data : "frst_regr_id", defaultContent : ""},
		{data : "frst_reg_dtm", defaultContent : ""},
		{data : "lst_mdfr_id", defaultContent : ""},
		{data : "lst_mdf_dtm", defaultContent : ""}
		]
	});
		

		table.tables().header().to$().find('th:eq(0)').css('min-width', '30px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '130px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '70px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '65px');  
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(9)').css('min-width', '65px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	    $(window).trigger('resize'); 
}



     

/* ********************************************************
 * 페이지 시작시, 서버 리스트 조회
 ******************************************************** */
$(window.document).ready(function() {
	fn_buttonAut();
	fn_init();
	
  	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.clear().draw();
			table.rows.add(result).draw();
		}
	}); 
  	
  	
  	$(function() {	
  		$('#serverList tbody').on( 'click', 'tr', function () {
  			 if ( $(this).hasClass('selected') ) {
  	     	}else {	        	
  	     	table.$('tr.selected').removeClass('selected');
  	         $(this).addClass('selected');	            
  	     } 
  		})     
  	});
 
});


function fn_buttonAut(){
	var read_button = document.getElementById("read_button"); 
	var int_button = document.getElementById("int_button"); 
	var mdf_button = document.getElementById("mdf_button"); 
	var del_button = document.getElementById("del_button"); 
	
	if("${wrt_aut_yn}" == "Y"){
		int_button.style.display = '';
		mdf_button.style.display = '';
	}else{
		int_button.style.display = 'none';
		mdf_button.style.display = 'none';
	}
		
	if("${read_aut_yn}" == "Y"){
		read_button.style.display = '';
	}else{
		read_button.style.display = 'none';
	}
}

/* ********************************************************
 * 서버리스트 조회 (검색조건 입력)
 ******************************************************** */
function fn_search(){
	$.ajax({
		url : "/selectDbServerServerList.do",
		data : {
			db_svr_nm : $("#db_svr_nm").val(),
			ipadr : $("#ipadr").val(),
			dft_db_nm : $("#dft_db_nm").val(),
			useyn: $("#useyn").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			table.rows({selected: true}).deselect();
			table.clear().draw();
			table.rows.add(result).draw();
		}
	});
}


/* ********************************************************
 * 서버 등록 팝업페이지 호출
 ******************************************************** */
function fn_reg_popup(){
	var popUrl = "/popup/dbServerRegForm.do?flag=server"; // 서버 url 팝업경로
	var width = 1000;
	var height = 630;
	var left = (window.screen.width / 2) - (width / 2);
	var top = (window.screen.height /2) - (height / 2);
	var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
		
	window.open(popUrl,"",popOption);	
	
// 	window.open("/popup/dbServerRegForm.do?flag=server","dbServerRegPop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=950,height=613,top=0,left=0");
}


/* ********************************************************
 * 서버 수정 팝업페이지 호출
 ******************************************************** */
function fn_regRe_popup(){
	var datas = table.rows('.selected').data();
	if (datas.length == 1) {
		var db_svr_id = table.row('.selected').data().db_svr_id;
		var popUrl = "/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=server"; // 서버 url 팝업경로
		var width = 1000;
		var height = 660;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
			
		window.open(popUrl,"",popOption);
		
// 		window.open("/popup/dbServerRegReForm.do?db_svr_id="+db_svr_id+"&flag=server","dbServerRegRePop","location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=950,height=638,top=0,left=0");
	} else {
		alert("<spring:message code='message.msg04' />");
	}	
}
</script>




<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.dbms_management" /> <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.dbms_management_01" /></li>
					<li><spring:message code="help.dbms_management_02" /></li>						
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li><spring:message code="menu.dbms_information" /></li>
					<li class="on"><spring:message code="menu.dbms_management" /></li>
				</ul>
			</div>
		</div>


		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
						<span class="btn" onClick="fn_search()" id="read_button"><button><spring:message code="common.search" /></button></span>
						<span class="btn" onclick="fn_reg_popup();" id="int_button"><button><spring:message code="common.registory" /></button></span>
						<span class="btn" onclick="fn_regRe_popup();" id="mdf_button"><button><spring:message code="common.modify" /></button></span>
						
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>DB Server 조회</caption>
						<colgroup>
							<col style="width: 100px;" />
							<col style="width: 250px;" />
							<col style="width: 100px;" />
							<col style="width: 250px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.dbms_name" /></th>
								<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" /></td>
								<th scope="row" class="t9"><spring:message code="dbms_information.dbms_ip"/></th>
								<td><input type="text" class="txt" name="ipadr" id="ipadr" /></td>
							</tr>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.database" /></th>
								<td><input type="text" class="txt" name="dft_db_nm" id="dft_db_nm" /></td>
								<th scope="row" class="t9"><spring:message code="dbms_information.use_yn" /></th>
								<td>
									<select class="select t5" id="useyn">
										<option value="%"><spring:message code="common.total" /></option>
										<option value="Y"><spring:message code="dbms_information.use" /></option>
										<option value="N"><spring:message code="dbms_information.unuse" /> </option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
					<table id="serverList" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="30"><spring:message code="common.no" /></th>
								<th width="130"><spring:message code="common.dbms_name" /></th>
								<th width="100"><spring:message code="dbms_information.dbms_ip"/></th>
								<th width="130"><spring:message code="common.database" /></th>
								<th width="70"><spring:message code="data_transfer.port" /></th>
								<th width="70"><spring:message code="dbms_information.account" /></th>
								<th width="70"><spring:message code="dbms_information.use_yn" /></th>
								<th width="65"><spring:message code="common.register" /></th>
								<th width="100"><spring:message code="common.regist_datetime" /></th>
								<th width="65"><spring:message code="common.modifier" /></th>
								<th width="100"><spring:message code="common.modify_datetime" /></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
