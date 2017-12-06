<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		scrollY : "230px",
		searching : false,
		paging : false,
		columns : [
		{data : "rownum", defaultContent : "", className : "dt-center", 
			targets: 0,
	        searchable: false,
	        orderable: false,
	        render: function(data, type, full, meta){
	           if(type === 'display'){
	              data = '<input type="radio" name="radio" value="' + data + '">';      
	           }
	           return data;
	        }}, 
		{data : "idx", className : "dt-center", defaultContent : "" ,visible: false},
		{data : "db_svr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "db_svr_nm", className : "dt-center", defaultContent : ""},
		{data : "ipadr", className : "dt-center", defaultContent : "", visible: false},
		{data : "dft_db_nm", className : "dt-center", defaultContent : "", visible: false},
		{data : "portno", className : "dt-center", defaultContent : "", visible: false},
		{data : "svr_spr_usr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_regr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : "", visible: false},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : "", visible: false}			
		]
	});

	/* ********************************************************
	 * 디비 (데이터테이블)
	 ******************************************************** */
	table_db = $('#dbList').DataTable({
		scrollY : "275px",
		searching : false,
		paging : false,
		columns : [
		{data : "extname", className : "dt-center", defaultContent : ""}, 
		{data : "installYn", className : "dt-center", defaultContent : "설치"}, 		
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
				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
	             location.href = "/";
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
    				alert("인증에 실패 했습니다. 로그인 페이지로 이동합니다.");
    				 location.href = "/";
    			} else if(xhr.status == 403) {
    				alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
    	             location.href = "/";
    			} else {
    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
    			}
    		},
    		success : function(result) {
    			table_db.clear().draw();
    			if(result == null){
    				alert("서버상태를 확인해주세요.");
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
			<h4>확장팩설치정보 화면 <a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>선택한 데이터베이스 서버에 설치된 확장팩 목록을 조회합니다.</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>Admin</li>
					<li>확장팩설치정보</li>

				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="tree_grp">
				<div class="tree_lt">
					<div class="btn_type_01">
					</div>
					<div class="inner">
						<p class="tit">확장설치조회</p>
						<div class="tree_server">
							<table id="dbServerList" class="display" cellspacing="0" width="100%" align="right">
								<thead>
									<tr>
										<th>선택</th>
										<th></th>
										<th></th>
										<th>DB 서버</th>
										<th></th>
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
						<p class="tit">확장 목록</p>
						<div class="tree_list">
							<table id="dbList" class="display" cellspacing="0" width="100%" align="left">
								<thead>
									<tr>
										<th>확장명</th>
										<th>설치여부</th>
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

