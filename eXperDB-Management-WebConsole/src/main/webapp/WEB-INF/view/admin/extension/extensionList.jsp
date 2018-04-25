<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : dbTree.jsp
	* @Description : dbTree 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.05.31     최초 생성
	*
	* author 변승우 대리
	* since 2017.05.31
	*
	*/
%>

<script>
//연결테스트 확인여부
var connCheck = "fail";

var table_dbServer = null;
var table_db = null;

function fn_init() {
	
	/* ********************************************************
	 * 서버 (데이터테이블)
	 ******************************************************** */
	table_dbServer = $('#dbServerList').DataTable({
		scrollY : "270px",
		searching : false,
		paging : false,
		bSort: false,
		columns : [
		{data : "rownum", defaultContent : "", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        className : "dt-center",
	        render: function(data, type, full, meta){
	           if(type === 'display'){
// 	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "idx", defaultContent : "" ,visible: false},
		{data : "db_svr_id", defaultContent : "", visible: false},
		{data : "db_svr_nm", defaultContent : ""},
		{data : "ipadr", defaultContent : ""},
		{data : "dft_db_nm", defaultContent : "", visible: false},
		{data : "portno", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", defaultContent : "", visible: false},
		{data : "frst_regr_id", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", defaultContent : "", visible: false}			
		]
	});

	/* ********************************************************
	 * 디비 (데이터테이블)
	 ******************************************************** */
	table_db = $('#dbList').DataTable({
		scrollY : "255px",
		searching : false,
		paging : false,
		bSort: false,
		columns : [
		{data : "extname", defaultContent : ""}, 
		{data : "extversion", defaultContent : ""},
		{data : "installYn", defaultContent : "설치"}, 		
		]
	});
	
}


/* ********************************************************
 * 페이지 시작시(서버 조회)
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	
  	$.ajax({
		url : "/selectDbServerList.do",
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
			table_dbServer.clear().draw();
			table_dbServer.rows.add(result).draw();
		}
	});
  	
  	

});

$(function() {		
	
	/* ********************************************************
	 * 서버 테이블 (선택영역 표시)
	 ******************************************************** */
    $('#dbServerList tbody').on( 'click', 'tr', function () {
    	var check = table_dbServer.row( this ).index()+1
    	$(":radio[name=input:radio][value="+check+"]").attr("checked", true);
         if ( $(this).hasClass('selected') ) {
        }
        else {
        	
        	table_dbServer.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
            
        } 
         var db_svr_id = table_dbServer.row('.selected').data().db_svr_id;

        /* ********************************************************
         * 선택된 서버에 대한 확장 조회
        ******************************************************** */
       	$.ajax({
    		url : "/extensionDetail.do",
    		data : {
    			db_svr_id: db_svr_id,			
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
    			table_db.clear().draw();
    			if(result == null){
    				alert("<spring:message code='message.msg05' />");
    			}else{
	    			table_db.rows.add(result).draw();
	    			//fn_dataCompareChcek(result);
    			}
    		}
    	});
        
    } );
    

})


</script>
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.extension_pack_installation_information" /> <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.extension_pack_installation_information" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li class="on"><spring:message code="menu.extension_pack_installation_information" /></li>

				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="tree_grp">
				<div class="tree_lt">
					<div class="btn_type_01">
					</div>
					<div class="inner">
						<p class="tit"><spring:message code="extension_pack_installation_information.dbms_list"/></p>
						<div class="tree_server">
							<table id="dbServerList" class="display" cellspacing="0" width="100%" align="right">
								<thead>
									<tr>
										<th><spring:message code="common.no" /></th>
										<th></th>
										<th></th>
										<th><spring:message code="common.dbms_name" /></th>
										<th><spring:message code="dbms_information.dbms_ip" /> </th>
										<th></th>
										<th></th>
										<th></th>
										<th></th>
										<th></th>
										<th></th>
										<th></th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>
				<div class="tree_rt">
					<div class="btn_type_01">
						
					</div>
					<div class="inner">
						<p class="tit"><spring:message code="extension_pack_installation_information.exp_module_list"/></p>
						<div class="tree_list">
							<table id="dbList" class="display" cellspacing="0" width="100%" align="left">
								<thead>
									<tr>
										<th><spring:message code="extension_pack_installation_information.extension_name" /></th>
										<th><spring:message code="properties.version" /></th>
										<th><spring:message code="extension_pack_installation_information.install_yn" /> </th>
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

