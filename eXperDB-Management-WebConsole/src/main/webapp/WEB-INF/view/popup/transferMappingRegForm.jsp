<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : transferMappingRegForm.jsp
	* @Description : transferMappingRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.24
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Database 매핑작업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<link rel="stylesheet" type="text/css" href="/css/dt/dataTables.checkboxes.css" />
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.select.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
<script>
	var tableList = null;
	var connectorTableList = null;
	
	function fn_init() {
		tableList = $('#tableList').DataTable({
			scrollY : "200px",
			scrollX : true,
			searching : false,
			paging: false,
			bSort: false,
			columns : [
			{ data : "table_name", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "table_schema",  defaultContent : ""}, 
			{ data : "table_name",  defaultContent : ""}, 
			 ],'select': {'style': 'multi'}
		});
		
		tableList.tables().header().to$().find('th:eq(0)').css('min-width', '50px');
		tableList.tables().header().to$().find('th:eq(1)').css('min-width', '50px');
		tableList.tables().header().to$().find('th:eq(2)').css('min-width', '50px');
		
		connectorTableList = $('#connectorTableList').DataTable({
			scrollY : "200px",
			scrollX : true,
			searching : false,
			paging: false,
			bSort: false,
			columns : [
			{ data : "table_name", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
			{ data : "table_schema",  defaultContent : ""}, 
			{ data : "table_name",  defaultContent : ""}, 
			 ],'select': {'style': 'multi'}
		});
		
		connectorTableList.tables().header().to$().find('th:eq(0)').css('min-width', '80px');
		connectorTableList.tables().header().to$().find('th:eq(1)').css('min-width', '80px');
		connectorTableList.tables().header().to$().find('th:eq(2)').css('min-width', '80px');
		$(window).trigger('resize');
	}

	$(window.document).ready(function() {
		if("${error}"!=""){
			alert('<spring:message code="message.msg174"/>');
			window.close();
		}
		fn_init();
		if("${result}" == ""){
			fn_dbSelect($("#db_svr_nm").val());
		}else{		
			$("#db_svr_nm").val("${result[0].db_svr_nm}").attr("selected", "selected");	
			$("select[name='db_nm'] option").remove();		
	       	$.ajax({
	    		url : "/selectServerDbLists.do",
	    		data : {
	    			db_svr_nm: '${result[0].db_svr_nm}',			
	    		},
	    		dataType : "json",
	    		type : "post",
	    		beforeSend: function(xhr) {
	    	        xhr.setRequestHeader("AJAX", true);
	    	     },
	    		error : function(xhr, status, error) {
	    			if(xhr.status == 401) {
	    				alert('<spring:message code="message.msg02" />');
	    				top.location.href = "/";
	    			} else if(xhr.status == 403) {
	    				alert('<spring:message code="message.msg03" />');
	    				top.location.href = "/";
	    			} else {
	    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
	    			}
	    		},
	    		success : function(result) {  
	    				var option = "<option value='no'><spring:message code="schedule.total" /></option>";
						for(var i=0; i<result.length; i++){	
							 option += "<option value='"+result[i].db_id+"'>"+result[i].db_nm;
							 if(result[i].db_exp!=""){
								option += "("+result[i].db_exp+")";
							 }
							 option +="</option>";
						}
					$('#db_nm').append(option);
					$("#db_nm").val("${result[0].db_id}").attr("selected", "selected");
					fn_dbChange();				
	    		}
	    	});
		}
	
	});
	
	/*서버선택시*/
	function fn_serverChange(){
		tableList.rows({selected: true}).deselect();
		tableList.clear().draw();
		connectorTableList.rows({selected: true}).deselect();
		connectorTableList.clear().draw();
		fn_dbSelect($("#db_svr_nm").val());
	}
	
	/*서버선택시 데이터베이스 조회*/
	function fn_dbSelect(db_svr_nm){
		$("select[name='db_nm'] option").remove();		
       	$.ajax({
    		url : "/selectServerDbLists.do",
    		data : {
    			db_svr_nm: db_svr_nm,			
    		},
    		dataType : "json",
    		type : "post",
    		beforeSend: function(xhr) {
    	        xhr.setRequestHeader("AJAX", true);
    	     },
    		error : function(xhr, status, error) {
    			if(xhr.status == 401) {
    				alert('<spring:message code="message.msg02" />');
    				top.location.href = "/";
    			} else if(xhr.status == 403) {
    				alert('<spring:message code="message.msg03" />');
    				top.location.href = "/";
    			} else {
    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
    			}
    		},
    		success : function(result) {  
    				var option = "<option value='no'><spring:message code="schedule.total" /></option>";
					for(var i=0; i<result.length; i++){	
						 option += "<option value='"+result[i].db_id+"'>"+result[i].db_nm+"</option>";		 
					}
				$('#db_nm').append(option);
    		}
    	});
	}
	
	/*DB선택시 -> 테이블리스트 조회*/
	function fn_dbChange(){
		tableList.rows({selected: true}).deselect();
		tableList.clear().draw();
		//Connector 테이블 값이 있을 경우
		if("${result[0].db_id}"==$("#db_nm").val()){
			$.ajax({
	    		url : "/selectMappingTableList.do",
	    		data : {
	    			db_id : $("#db_nm").val(),
	    		},
	    		dataType : "json",
	    		type : "post",
	    		beforeSend: function(xhr) {
	    	        xhr.setRequestHeader("AJAX", true);
	    	     },
	    		error : function(xhr, status, error) {
	    			if(xhr.status == 401) {
	    				alert('<spring:message code="message.msg02" />');
	    				top.location.href = "/";
	    			} else if(xhr.status == 403) {
	    				alert('<spring:message code="message.msg03" />');
	    				top.location.href = "/";
	    			} else {
	    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
	    			}
	    		},
	    		success : function(result) {
	    			if(result.data == null){
	    				alert('<spring:message code="message.msg27" />');
	    			}else{
	    				tableList.rows({selected: true}).deselect();
	    				tableList.clear().draw();	
	    				connectorTableList.rows({selected: true}).deselect();
	    				connectorTableList.clear().draw();
	    				<c:forEach items="${result}" var="result">
		    			for(var i=0; i<result.data.length;i++){
		    				if("${result.scm_nm}" == result.data[i].table_schema && "${result.tb_engl_nm}"== result.data[i].table_name){
		    					result.data.splice(i,1);
			    			}
		    					
			    		}
		    			</c:forEach>
		    			
		    			<c:forEach items="${result}" var="result">
		    			connectorTableList.row.add( {
		    		        "table_schema":"${result.scm_nm}",
		    		        "table_name": "${result.tb_engl_nm}"
		    		    } ).draw();
		    			</c:forEach>
		    			tableList.rows.add(result.data).draw();
		    			
		    	    	$('.selected').removeClass('selected');
		    	    	$("input[type=checkbox]").prop("checked", false);
	    			}
	    			
	    			
	    		}
	    	});	
		}else if($("#db_nm").val()!="no"){
			connectorTableList.clear().draw();
			$.ajax({
	    		url : "/selectMappingTableList.do",
	    		data : {
	    			db_id : $("#db_nm").val(),
	    		},
	    		dataType : "json",
	    		type : "post",
	    		beforeSend: function(xhr) {
	    	        xhr.setRequestHeader("AJAX", true);
	    	     },
	    		error : function(xhr, status, error) {
	    			if(xhr.status == 401) {
	    				alert('<spring:message code="message.msg02" />');
	    				top.location.href = "/";
	    			} else if(xhr.status == 403) {
	    				alert('<spring:message code="message.msg03" />');
	    				top.location.href = "/";
	    			} else {
	    				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
	    			}
	    		},
	    		success : function(result) {
	    			if(result.bottledwater !=null){
	    				alert('<spring:message code="message.msg150"/>');
	    			}else if(result.database !=null){
	    				alert('<spring:message code="message.msg203"/>');
	    			}else if(result.data == null){
	    				alert('<spring:message code="message.msg27" />');
	    			}else{
	    				tableList.rows({selected: true}).deselect();
		    			tableList.clear().draw();		
		    			tableList.rows.add(result.data).draw();
		    			
		    	    	$('.selected').removeClass('selected');
		    	    	$("input[type=checkbox]").prop("checked", false);
	    			}
	    		}
	    	});	
		}else if($("#db_nm").val()=="no"){
			connectorTableList.rows({selected: true}).deselect();
			connectorTableList.clear().draw();
		}
	}
	
 	/*-> 클릭시*/
 	function fn_rightMove(){
 		var datas = tableList.rows('.selected').data();
 		if(datas.length <1){
 			alert('<spring:message code="message.msg35" />');	
 		}else{
 			var rows = [];
        	for (var i = 0;i<datas.length;i++) {
				rows.push(tableList.rows('.selected').data()[i]); 
			}
        	
        	connectorTableList.rows.add(rows).draw();
        	tableList.rows('.selected').remove().draw();
 		}	 		 
	}
 	
 	/*->> 클릭시*/
 	function fn_allRightMove(){
 		var datas = tableList.rows().data();
 		if(datas.length <1){
 			alert('<spring:message code="message.msg01" />');	
 		}else{
 	 		var rows = [];
 	        for (var i = 0;i<datas.length;i++) {
 				rows.push(tableList.rows().data()[i]); 
 			}
 	        connectorTableList.rows.add(rows).draw(); 	
 	       	tableList.rows({selected: true}).deselect();
 	        tableList.rows().remove().draw();
 		}

	}
 	
 	
 	/*<- 클릭시*/
 	function fn_leftMove(){
 		var datas = connectorTableList.rows('.selected').data();
 		if(datas.length <1){
 			alert('<spring:message code="message.msg35" />');	
 		}else{
 			var rows = [];
        	for (var i = 0;i<datas.length;i++) {
				rows.push(connectorTableList.rows('.selected').data()[i]); 
			}
        	tableList.rows.add(rows).draw();
        	connectorTableList.rows('.selected').remove().draw();	
 		}	 
 	}
	
 	/*<<- 클릭시*/
 	function fn_allLeftMove(){
 		var datas = connectorTableList.rows().data();
 		if(datas.length <1){
 			alert('<spring:message code="message.msg01" />');	
 		}else{
 	 		var rows = [];
 	        for (var i = 0;i<datas.length;i++) {
 				rows.push(connectorTableList.rows().data()[i]); 
 			}
 	        tableList.rows.add(rows).draw(); 
 	        connectorTableList.rows({selected: true}).deselect();
 	        connectorTableList.rows().remove().draw();
 		}
 	}
 		
 	
	/*매핑저장 클릭시*/
	function fn_insert(){
		var data = connectorTableList.rows().data();
		if(data.length <1){
			alert('<spring:message code="message.msg151"/>');	
		}else{
			 if (!confirm('<spring:message code="message.msg148"/>')) return false;
			//connector 테이블 리스트가 있을 경우
			var trf_trg_mpp_id = 0;
			if("${result[0].trf_trg_mpp_id}" != ""){
				trf_trg_mpp_id = "${result[0].trf_trg_mpp_id}";
			}
			var rowList = [];
            for (var i = 0; i < data.length; i++) {
               rowList.push(connectorTableList.rows().data()[i]);
            }
    		$.ajax({
    			url : '/insertTransferMapping.do',
    			type : 'post',
    			dataType : 'text',
    			data : {
    				rowList : JSON.stringify(rowList),
    				trf_trg_id : '${trf_trg_id}',
    				cnr_id : '${cnr_id}',
    				db_id : $("#db_nm").val(),
    				trf_trg_mpp_id : trf_trg_mpp_id,
    				trf_trg_cnn_nm : '${trf_trg_cnn_nm}'
    			},
    			success : function(result) {
    				alert('<spring:message code="message.msg57" />');
    				window.close();
    				opener.fn_select();
    			},
    			beforeSend: function(xhr) {
    		        xhr.setRequestHeader("AJAX", true);
    		     },
    			error : function(xhr, status, error) {
    				if(xhr.status == 401) {
    					alert('<spring:message code="message.msg02" />');
    					top.location.href = "/";
    				} else if(xhr.status == 403) {
    					alert('<spring:message code="message.msg03" />');
    					top.location.href = "/";
    				} else {
    					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
    				}
    			}
    		});
		}	
	}
</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">Database <spring:message code="data_transfer.mapping_settings" /></p>
		<table class="write">
			<caption>전송대상 설정 등록</caption>
			<colgroup>
				<col style="width:115px;" />
				<col style="width:280px;" />
				<col style="width:100px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="data_transfer.connect_name" /></th>
					<td><input type="text" class="txt t3 bg1" name="trf_trg_cnn_nm" value="${trf_trg_cnn_nm}" readonly="readonly"/></td>
					<th>&nbsp;</th>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="common.dbms_name" /></th>
					<td>	
						<select class="select t3" name="db_svr_nm" id="db_svr_nm" onchange="fn_serverChange()">
							<c:forEach var="resultSet" items="${resultSet}" varStatus="status">
								<option value="${resultSet.db_svr_nm}">${resultSet.db_svr_nm}</option>
							</c:forEach>
						</select>		
					</td>
					<th scope="row" class="ico_t1"><spring:message code="common.database" /></th>
					<td>
						<select class="select" name="db_nm" id="db_nm" onchange="fn_dbChange()"></select>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="mapping_area">
			<div class="mapping_lt">
				<p class="tit"><spring:message code="data_transfer.tableList"/></p>
				<div class="overflow_area">
					<table id="tableList" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="50"></th>
								<th width="50"><spring:message code="data_transfer.schema"/></th>
								<th width="50"><spring:message code="data_transfer.tableNm"/></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="mapping_rt">
				<p class="tit"><spring:message code="data_transfer.transfer_table"/></p>
				<div class="overflow_area">
					<table id="connectorTableList" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="80"></th>
								<th width="80"><spring:message code="data_transfer.schema"/></th>
								<th width="80"><spring:message code="data_transfer.tableNm"/></th>
							</tr>	
							</thead>			
					</table>
				</div>
			</div>
			<div class="mapping_btn">
				<a href="#n" onclick="fn_allRightMove();"><img src="../../images/popup/ico_p_4.png" alt="전체우로" /></a>
				<a href="#n" onclick="fn_rightMove();"><img src="../../images/popup/ico_p_5.png" alt="한개우로" /></a>
				<a href="#n" onclick="fn_leftMove();"><img src="../../images/popup/ico_p_6.png" alt="한개좌로" /></a>
				<a href="#n" onclick="fn_allLeftMove();"><img src="../../images/popup/ico_p_7.png" alt="전체좌로" /></a>
			</div>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01"><button onclick="fn_insert()" type="button"><spring:message code="button.create" /></button></span>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>