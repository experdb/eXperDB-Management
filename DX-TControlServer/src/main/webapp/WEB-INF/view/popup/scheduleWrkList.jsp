<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>

<script>
var scd_id = ${scd_id};

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#workList').DataTable({
	scrollY : "245px",
	bDestroy: true,
	processing : true,
	searching : false,	
	columns : [
	{data : "idx", columnDefs: [ { searchable: false, orderable: false, targets: 0} ], order: [[ 1, 'asc' ]], className : "dt-center", defaultContent : ""},
	{data : "wrk_id", className : "dt-center", defaultContent : "", visible: false },
	{data : "db_svr_nm", className : "dt-center", defaultContent : ""}, //서버명
	{data : "bck_bsn_dscd_nm", className : "dt-center", defaultContent : ""}, //구분
	{data : "wrk_nm", className : "dt-center", defaultContent : ""
		,"render": function (data, type, full) {
			  return '<span onClick=javascript:fn_workLayer("'+full.wrk_nm+'"); style=cursor:pointer>' + full.wrk_nm + '</span>';
		}
	}, //work명
	{data : "wrk_exp", className : "dt-center", defaultContent : ""}, //work설명
	{data : "nxt_exe_yn",  
		className: "dt-center",
      	defaultContent: "",
        	render: function (data, type, full){
        		
        		var onError ='<select  id="nxt_exe_yn" name="nxt_exe_yn">';
        		if(data.NXT_EXE_YN  == 'Y') {
        			onError +='<option value="y" selected>Y</option>';
        			onError +='<option value="n">N</option>';
        		} else {
        			onError +='<option value="y">Y</option>';
        			onError +='<option value="n" selected>N</option>';
        		}

        		onError +='</select>';
        		return onError;	
        	}
          }
	]
});

    table.on( 'order.dt search.dt', function () {
    	table.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            cell.innerHTML = i+1;
        } );
    } ).draw();
    
}


/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();


 	$.ajax({
		url : "/selectWrkScheduleList.do",
		data : {
			scd_id : scd_id
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
	
});

</script>
	<%@include file="../cmmn/workRmanInfoPop.jsp"%>
	<%@include file="../cmmn/workDumpInfoPop.jsp"%>
					<div class="contents">
						<div class="cmm_grp">						
							<div class="cmm_bd">
								<div class="sub_tit">
									<p>Work  리스트</p>
								</div>
								<div class="overflow_area">							
									<table id="workList" class="cell-border display" >
										<thead>
											<tr>
												<th>No</th>
												<th></th>
												<th>서버명</th>
												<th>구분</th>
												<th>Work명</th>
												<th>Work설명</th>
												<th>OnError</th>
											</tr>
										</thead>
									</table>											
								</div>
							</div>		
						</div>
					</div>
		