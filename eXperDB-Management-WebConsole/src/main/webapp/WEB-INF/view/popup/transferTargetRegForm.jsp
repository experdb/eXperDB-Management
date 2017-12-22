<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : transferTargetRegForm.jsp
	* @Description : transferTargetRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.07.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.07.26
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>전송대상등록팝업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script>
	var nmCheck = 0;
	
	/* Validation */
	function fn_transferTargetValidation(){
		if (trf_trg_url.value == "" || trf_trg_url.value == "undefind" || trf_trg_url.value == null) {
			alert('<spring:message code="message.msg149"/>');
			trf_trg_url.focus();
			return false;
		}
		
		if (nmCheck != 1) {
			alert('<spring:message code="message.msg142"/>');
			return false;
		}
		
		return true;	
	}

	/*저장버튼 클릭시insert*/
	function fn_insert() {
		if (!fn_transferTargetValidation()) return false;
		if (!confirm('<spring:message code="message.msg148"/>')) return false;
			$.ajax({
				url : '/insertTransferTarget.do',
				type : 'post',
				data : {
					cnr_id : "${cnr_id}",
					trf_trg_cnn_nm : $("#trf_trg_cnn_nm").val(),
					trf_trg_url : $("#trf_trg_url").val(),
					connector_class : $("#connector_class").val(),
					task_max : $("#task_max").val(),
					hadoop_conf_dir : $("#hadoop_conf_dir").val(),
					hadoop_home : $("#hadoop_home").val(),
					flush_size : $("#flush_size").val(),
					rotate_interval_ms : $("#rotate_interval_ms").val(),
				},
				success : function(result) {
					if(result){
						alert('<spring:message code="message.msg07" />');
						window.close();
						opener.fn_select();
					}else{
						alert('<spring:message code="message.msg115" />');
					}
				},
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
				}
			});
	}
	
	/*저장버튼 클릭시update*/
	function fn_update(){
		nmCheck = 1;
		if (!fn_transferTargetValidation()) return false;
		if (!confirm('<spring:message code="message.msg148"/>')) return false;
			$.ajax({
				url : '/updateTransferTarget.do',
				type : 'post',
				data : {
					cnr_id : "${cnr_id}",
					strTopics : "${topics}",
					trf_trg_cnn_nm : $("#trf_trg_cnn_nm").val(),
					trf_trg_url : $("#trf_trg_url").val(),
					connector_class : $("#connector_class").val(),
					task_max : $("#task_max").val(),
					hadoop_conf_dir : $("#hadoop_conf_dir").val(),
					hadoop_home : $("#hadoop_home").val(),
					flush_size : $("#flush_size").val(),
					rotate_interval_ms : $("#rotate_interval_ms").val(),
				},
				success : function(result) {
					if(result){
						alert('<spring:message code="message.msg07" />');
						window.close();
						opener.fn_select();
					}else{
						alert('<spring:message code="message.msg115" />');
					}
				},
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
				}
			});
	}
	
	$(window.document).ready(function() {
		var act = "${act}";
		if(act=="i"){
			$("#task_max").val("3");
			$("#flush_size").val("100");
			$("#rotate_interval_ms").val("3000");	
			
			document.getElementById("trf_trg_cnn_nm").focus();
		}
		if(act=="u"){
			$("#trf_trg_cnn_nm").attr("readonly",true);
		}
	})
	
	/* Connect명 중복체크*/
	function fn_nmCheck(){
		var str = document.getElementById("trf_trg_cnn_nm").value;
		var err = 0; 
		if( str == '' || str == null ){
		    alert( '<spring:message code="message.msg116" />' );
		    return;
		}

		for (var i=0; i<str.length; i++)  { 
		    var chk = str.substring(i,i+1); 
		    if ( str.match(/[^a-z0-9]/) != null ) {
		        err = err + 1; 
		    } 
		} 
		if (err > 0) { 
		    alert('<spring:message code="message.msg117" />'); 
		    document.getElementById('trf_trg_cnn_nm').focus();
			nmCheck = 0;
		    return;
		} 
		$.ajax({
			url : '/transferTargetNameCheck.do',
			type : 'post',
			data : {
				trf_trg_cnn_nm : $("#trf_trg_cnn_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert('<spring:message code="message.msg118" />');
					document.getElementById("trf_trg_url").focus();
					nmCheck = 1;
				}else {
					alert('<spring:message code="message.msg119" />');
					document.getElementById("trf_trg_cnn_nm").focus();
					nmCheck = 0;
				}
			},
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
			}
		});
	}
	
</script>
</head>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			<c:if test="${act == 'i'}"><spring:message code="data_transfer.transfer_set_reg"/></c:if>
			<c:if test="${act == 'u'}"><spring:message code="data_transfer.transfer_set_mod"/></c:if>
		</p>
		<table class="write">
			<caption>
				<c:if test="${act == 'i'}"><spring:message code="data_transfer.transfer_set_reg"/></c:if>
				<c:if test="${act == 'u'}"><spring:message code="data_transfer.transfer_set_mod"/></c:if>
			</caption>
			<colgroup>
				<col style="width:150px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="ico_t1"><spring:message code="data_transfer.connect_name" /></th>
					<td>
						<c:if test="${act == 'i'}">
							<input type="text" class="txt" name="trf_trg_cnn_nm" id="trf_trg_cnn_nm" value="${trf_trg_cnn_nm}" style="width: 300px;"/>
							<span class="btn btnC_01">
								<button type="button" class= "btn_type_02" onclick="fn_nmCheck()" style="width: 60px; margin-right: -60px; margin-top: 0;"><spring:message code="common.overlap_check" /></button>
							</span>
						</c:if>
						<c:if test="${act == 'u'}">
							<input type="text" class="txt" name="trf_trg_cnn_nm" id="trf_trg_cnn_nm" value="${trf_trg_cnn_nm}" style="width: 500px;"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">hdfs.url</th>
					<td><input type="text" class="txt t2" name="trf_trg_url" id="trf_trg_url" value="${trf_trg_url}" placeholder="예시 hdfs://ip:port/HadoopPath" style="width: 500px;""/><span style=""></span></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">connector.class</th>
					<td>
						<select class="select" id="connector_class" name="connector_class" style="width: 500px;">
							<option value="io.confluent.connect.hdfs.HdfsSinkConnector" ${connector_class == 'io.confluent.connect.hdfs.HdfsSinkConnector' ? 'selected="selected"' : ''}>io.confluent.connect.hdfs.HdfsSinkConnector</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">tasks.max</th>
					<td><input type="number" class="txt t2" name="task_max" id="task_max" value="${task_max}" style="width: 200px;" /></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">hadoop.conf.dir</th>
					<td><input type="text" class="txt t2" name="hadoop_conf_dir" id="hadoop_conf_dir" value="${hadoop_conf_dir}" style="width: 500px;"/></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">hadoop.home</th>
					<td><input type="text" class="txt t2" name="hadoop_home" id="hadoop_home" value="${hadoop_home}" style="width: 500px;"/></td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">flush.size</th>
					<td><input type="number" class="txt t2" name="flush_size" id="flush_size" value="${flush_size}" style="width: 100px; margin-right: 5px;"/>Byte</td>
				</tr>
				<tr>
					<th scope="row" class="ico_t1">rotate.interval.ms</th>
					<td><input type="number" class="txt t2" name="rotate_interval_ms" id="rotate_interval_ms" value="${rotate_interval_ms}" style="width: 100px;"/></td>
				</tr>
			</tbody>
		</table>
		<div class="btn_type_02">
			<c:if test="${act == 'i'}"><span class="btn" onclick="fn_insert();"><button><spring:message code="button.create" /></button></span></c:if>
			<c:if test="${act == 'u'}"><span class="btn" onclick="fn_update();"><button><spring:message code="button.modify" /></button></span></c:if>
			<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.cancel" /></span></a>
		</div>
	</div>
</div>
</body>
</html>