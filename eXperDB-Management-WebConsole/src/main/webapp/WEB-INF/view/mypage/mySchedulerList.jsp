<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
    
<script>
var table = null;

function fn_init(){
	/* ********************************************************
	 * work리스트
	 ******************************************************** */
	table = $('#scheduleList').DataTable({
	scrollY : "245px",
	bDestroy: true,
	processing : true,
	searching : false,	
	scrollX: true,
	bSort: false,
	columns : [
		{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
		{data : "idx", className : "dt-center", defaultContent : ""}, 
		{data : "scd_nm", className : "dt-left", defaultContent : ""
			,render: function (data, type, full) {
				  return '<span onClick=javascript:fn_scdLayer("'+full.scd_id+'"); class="bold">' + full.scd_nm + '</span>';
			}
		},
		{data : "scd_exp", className : "dt-left", defaultContent : ""}, 
		{data : "wrk_cnt", className : "dt-center", defaultContent : ""}, 
		{data : "prev_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "nxt_exe_dtm", className : "dt-center", defaultContent : ""}, 
		{data : "status", 
			render: function (data, type, full){
				if(full.status == "s"){
					var html = '<img src="../images/ico_agent_1.png" alt="" />';
						return html;
				}else{
					var html = '<img src="../images/ico_agent_2.png" alt="" />';
					return html;
				}
				return data;
			},
			className : "dt-center", defaultContent : "" 	
		},
		{data : "status", 
			render: function (data, type, full){
				if(full.status == "s"){
					var html = '<img src="../images/ico_w_25.png" alt="<spring:message code="dashboard.running" />" id="scheduleStop"/>';
						return html;
				}else{
					var html = '<img src="../images/ico_w_24.png" alt="중지중" id="scheduleStart" />';
					return html;
				}
				return data;
			},
			className : "dt-center", defaultContent : "" 	
		},		
		{data : "frst_regr_id", className : "dt-center", defaultContent : ""},
		{data : "frst_reg_dtm", className : "dt-center", defaultContent : ""},
		{data : "lst_mdfr_id", className : "dt-center", defaultContent : ""},
		{data : "lst_mdf_dtm", className : "dt-center", defaultContent : ""},
		{data : "scd_id", className : "dt-center", defaultContent : "", visible: false },
	]
	});
	
	table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
	table.tables().header().to$().find('th:eq(1)').css('min-width', '30px');
	table.tables().header().to$().find('th:eq(2)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(3)').css('min-width', '200px');
	table.tables().header().to$().find('th:eq(4)').css('min-width', '70px');
	table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(7)').css('min-width', '70px');
	table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(9)').css('min-width', '50px');
	table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(11)').css('min-width', '50px');
	table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
	table.tables().header().to$().find('th:eq(13)').css('min-width', '0px');
    $(window).trigger('resize'); 
    
    
 	$('#scheduleList tbody').on('click','#scheduleStop', function () {
 	    var $this = $(this);
	    var $row = $this.parent().parent();
	    $row.addClass('select-detail');
	    var datas = table.rows('.select-detail').data();

	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm('<spring:message code="message.msg131"/>')){
		     	$.ajax({
		    		url : "/scheduleStop.do",
		    		data : {
		    			scd_id : row.scd_id
		    		},
		    		dataType : "json",
		    		type : "post",
		    		beforeSend: function(xhr) {
		    	        xhr.setRequestHeader("AJAX", true);
		    	     },
		    		error : function(xhr, status, error) {
		    			if(xhr.status == 401) {
		    				alert('<spring:message code="message.msg02" />');
		    				 location.href = "/";
		    			} else if(xhr.status == 403) {
		    				alert('<spring:message code="message.msg03" />');
		    	             location.href = "/";
		    			} else {
		    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
		    			}
		    		},
		    		success : function(result) {
		    			location.reload();
		    		}
		    	});    
	       }
	    } 
	}); 
 	
 	$('#scheduleList tbody').on('click','#scheduleStart', function () {
 	    var $this = $(this);
	    var $row = $this.parent().parent();
	    $row.addClass('select-detail');
	    var datas = table.rows('.select-detail').data();

	    if(datas.length==1) {
	       var row = datas[0];
	       $row.removeClass('select-detail');
	       
	       if(confirm('<spring:message code="message.msg130"/>')){
		     	$.ajax({
		    		url : "/scheduleReStart.do",
		    		data : {
		    			sWork : JSON.stringify(row)
		    		},
		    		dataType : "json",
		    		type : "post",
		    		beforeSend: function(xhr) {
		    	        xhr.setRequestHeader("AJAX", true);
		    	     },
		    		error : function(xhr, status, error) {
		    			if(xhr.status == 401) {
		    				alert('<spring:message code="message.msg02" />');
		    				 location.href = "/";
		    			} else if(xhr.status == 403) {
		    				alert('<spring:message code="message.msg03" />');
		    	             location.href = "/";
		    			} else {
		    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
		    			}
		    		},
		    		success : function(result) {
		    			location.reload();
		    		}
		    	});    
	       }
	    } 
	}); 
 	
 	
	//더블 클릭시
	 $('#scheduleList tbody').on('dblclick','tr',function() {
		var scd_id = table.row(this).data().scd_id;
		
		var popUrl = "/scheduleWrkListVeiw.do?scd_id="+scd_id; // 서버 url 팝업경로
		var width = 1120;
		var height = 655;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";
				
		window.open(popUrl,"",popOption);
	});		 
	
}





		
/* ********************************************************
 * 페이지 시작시 함수
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
	fn_selectScheduleList();
});


/* ********************************************************
 * 스케줄 리스트 조회
 ******************************************************** */
function fn_selectScheduleList(){
  	$.ajax({
		url : "/selectMyScheduleList.do",
		data : {
			scd_nm : $("#scd_nm").val(),
			scd_exp : $("#scd_exp").val()
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				 location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
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



/* ********************************************************
 * 스케줄 리스트 삭제
 ******************************************************** */
function fn_deleteScheduleList(){
	
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	} 
	
	var rowList = [];
    for (var i = 0; i < datas.length; i++) {
        rowList.push( table.rows('.selected').data()[i].scd_id);   
       if(table.rows('.selected').data()[i].status == "s"){
    	   alert("<spring:message code='message.msg59' />");
    	   return false;
       }
  }	
    
   if(confirm('<spring:message code="message.msg134"/>')){
	  	$.ajax({
			url : "/deleteScheduleList.do",
			data : {
				rowList : JSON.stringify(rowList)
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					 location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
		             location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				alert('<spring:message code="message.msg37" />');
				location.reload();
			}
		}); 		   
   }
}


/* ********************************************************
 * 스케줄 리스트 수정
 ******************************************************** */
function fn_modifyScheduleListView(){
	var datas = table.rows('.selected').data();
	
	if (datas.length <= 0) {
		alert('<spring:message code="message.msg35" />');
		return false;
	}else if (datas.length >1){
		alert('<spring:message code="message.msg38" />');
	}
	
	var scd_id = table.row('.selected').data().scd_id;
	
	var form = document.modifyForm;
	form.action = "/modifyScheduleListVeiw.do?scd_id="+scd_id;
	form.submit();
	return;
	
}
</script>

<%@include file="../cmmn/scheduleInfo.jsp"%>

<form name="modifyForm" method="post">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.my_schedule_management" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.my_schedule_management01" /> </li>
					<li><spring:message code="help.my_schedule_management02" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li>My PAGE</li>
					<li class="on"><spring:message code="menu.my_schedule_management" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button onClick="fn_selectScheduleList();"><spring:message code="common.search" /></button></span>		
					<span class="btn" id="int_button"><a href="/insertScheduleView.do"><button><spring:message code="common.registory" /></button></a></span>
					<span class="btn" id="mdf_button"><button onClick="fn_modifyScheduleListView();"><spring:message code="common.modify" /></button></span>
					<span class="btn" id="del_button"><button onClick="fn_deleteScheduleList();"><spring:message code="common.delete" /></button></span>
				</div>
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:140px;" />
							<col />
						</colgroup>
						<tbody>
								<tr>
									<th scope="row" class="t9 line"><spring:message code="schedule.schedule_name" /></th>
									<td><input type="text" class="txt t2" id="scd_nm" name="scd_nm"/></td>
								</tr>
								<tr>
									<th scope="row" class="t9 line"><spring:message code="schedule.scheduleExp"/></th>
									<td><textarea class="tbd1" name="scd_exp" id="scd_exp"></textarea></td>
								</tr>
						</tbody>
					</table>
				</div>
				<div class="overflow_area">
				
				<table id="scheduleList" class="cell-border display" >
				<caption>스케쥴 리스트</caption>
					<thead>
						<tr>
							<th width="10"></th>
							<th width="30"><spring:message code="common.no" /></th>
							<th width="200" class="dt-center"><spring:message code="schedule.schedule_name" /></th>
							<th width="200" class="dt-center"><spring:message code="schedule.scheduleExp"/></th>
							<th width="70"><spring:message code="schedule.work_count" /></th>
							<th width="100"><spring:message code="schedule.pre_run_time" /></th>
							<th width="100"><spring:message code="schedule.next_run_time" /></th>
							<th width="70"><spring:message code="common.run_status" /></th>
							<th width="100"><spring:message code="schedule.run" /></th>
							<th width="50"><spring:message code="common.register" /></th>
							<th width="100"><spring:message code="common.regist_datetime" /></th>
							<th width="50"><spring:message code="common.modifier" /></th>
							<th width="100"><spring:message code="common.modify_datetime" /></th>
							<th width="0"></th>
						</tr>
					</thead>
				</table>						
				</div>
			</div>
		</div>
	</div>
</div><!-- // contents -->