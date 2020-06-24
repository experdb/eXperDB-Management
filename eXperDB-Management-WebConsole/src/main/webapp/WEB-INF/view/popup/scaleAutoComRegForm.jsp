<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : scaleAutoReRegForm.jsp
	* @Description : scale Auto ì¤ì  ìì  íë©´
	* @Modification Information
	*
	*   ìì ì¼         ìì ì                   ìì ë´ì©
	*  ------------    -----------    ---------------------------
	*  
	*
	* author 
	* since 
	*
	*/
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>

<style>
a.tip {
    position: relative;
    color:black;
}

a.tip span {
    display: none;
    position: absolute;
    top: 20px;
    left: -10px;
    width: 200px;
    padding: 5px;
    z-index: 100;
    background: #000;
    color: #fff;
    line-height: 20px;
    -moz-border-radius: 5px; /* íí­ ë°ì¤ ë¥ê·¼ ì ë */
    -webkit-border-radius: 5px; /* ì¬íë¦¬ ë°ì¤ ë¥ê·¼ ì ë */
}

a:hover.tip span {
    display: block;
}
</style>


<script type="text/javascript">
	var db_svr_id_param = "${db_svr_id}";

	/* ********************************************************
	 * 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		$("#expansion_clusters").prop('disabled', true);
		$("#min_clusters").prop('disabled', true);
		$("#max_clusters").prop('disabled', true);
	
		$("#check_execute_sp").hide();
		
		//데이터 조회
		fnc_search();
	});
	
	/* ********************************************************
	 * ìì  ë´ì­ ì¡°í
	 ******************************************************** */
	function fnc_search(){
		$.ajax({
			url : "/scale/popup/selectAutoScaleComCngInfo.do", 
		  	data : {
		  		db_svr_id : db_svr_id_param
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
			success : function(data) {
				if (data != null) {
					$("#com_db_svr_nm", "#scaleComRegForm").val(data.db_svr_nm);
					$("#com_ipadr", "#scaleComRegForm").val(data.ipadr);					
					$("#com_max_clusters", "#scaleComRegForm").val(data.max_clusters);
					$("#com_min_clusters", "#scaleComRegForm").val(data.min_clusters);
/* 					$("#com_auto_run_cycle", "#scaleComRegForm").val(data.auto_run_cycle); */
				} else {
					alert("<spring:message code='eXperDB_scale.msg7' />");
				}
			}
		});
	}

	/* ********************************************************
	 * nullì²´í¬
	 ******************************************************** */
	function nvlPrmSet(val, reVal) {
		var strValue = val;
		if( strValue == null || strValue == 'undefined') {
			strValue = reVal;
		}
		
		return strValue;
	}

	/* ********************************************************
	 * insert 실행
	 ******************************************************** */
	function fnc_com_insert_wrk() {
		if (!valCheck()) return false;

		$.ajax({
			async : false,
			url : "/scale/popup/scaleComCngWrite.do",
		  	data : {
		  		db_svr_id : db_svr_id_param,
		  		min_clusters : nvlPrmSet($("#com_min_clusters","#scaleComRegForm").val(),''),
		  		max_clusters : nvlPrmSet($("#com_max_clusters","#scaleComRegForm").val(),''),
		  		auto_run_cycle : 0
/* 		  		,
		  		auto_run_cycle : nvlPrmSet($("#com_auto_run_cycle","#scaleComRegForm").val(),'') */
		  	},
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
				if(result == "F"){//저장실패
					alert('<spring:message code="eXperDB_scale.msg2"/>');
					return false;
				}else{
					alert('<spring:message code="message.msg144"/>');	
					window.close();
					opener.fn_search_list();
				}
			}
		});
	}

	/* ********************************************************
	 * screen valid check
	 ******************************************************** */
	function valCheck(){
		var msgVale="";
		if(nvlPrmSet($("#com_max_clusters").val(),"") == "") {
			msgVale = '<spring:message code="eXperDB_scale.max_clusters" />';
			alert('<spring:message code="errors.required" arguments="'+ msgVale +'" />');

			$('input[name=com_max_clusters]').focus();
			return false;
		} 

		if(nvlPrmSet($("#com_min_clusters").val(),"") == "") {
			msgVale = '<spring:message code="eXperDB_scale.min_clusters" />';
			alert('<spring:message code="errors.required" arguments="'+ msgVale +'" />');

			$('input[name=com_min_clusters]').focus();
			return false;
		}
/* 
		if(nvlPrmSet($("#com_auto_run_cycle").val(),"") == "") {
			msgVale = '<spring:message code="eXperDB_scale.auto_execution_cycle" />';
			alert('<spring:message code="errors.required" arguments="'+ msgVale +'" />');

			$('input[name=com_auto_run_cycle]').focus();
			return false;
		} */
/* 		
		var com_auto_run_cycle_num = nvlPrmSet($("#com_auto_run_cycle").val(),"") * 1 ;

		if(com_auto_run_cycle_num <= 1 || com_auto_run_cycle_num > 60) {
			alert('<spring:message code="eXperDB_scale.msg17" />');

			$('input[name=com_auto_run_cycle]').focus();
			return false;
		}
 */
		return true;
	}

	//숫자 체크
	function chk_Number(object){
		$(object).keyup(function(){
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});   
	}
	
</script>
</head>
<body>
	<div class="pop_container" >
		<div class="pop_cts" style="min-width:500px;min-height:315px;"> 
			<p class="tit"><spring:message code="common.reg_default_setting"/></p>
			<div class="pop_cmm">
				<form name="scaleComRegForm" id="scaleComRegForm">
					<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>

					<table class="write">
						<caption><spring:message code="common.reg_default_setting"/></caption>
						<colgroup>
							<col style="width:120px;" />
							<col style="width:300px;" />
						</colgroup>
						<tbody>
							<tr>
							
								<th scope="row" class="ico_t1">
									<spring:message code="common.dbms_name"/>
								</th>
								<td>
									<input type="text" class="txt" name="com_db_svr_nm" id="com_db_svr_nm" disabled tabindex=1 />
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<spring:message code="dbms_information.dbms_ip"/>
								</th>
								<td>
									<input type="text" class="txt" name="com_ipadr" id="com_ipadr" disabled tabindex=2 />
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip" onclick="return false;" ><spring:message code="eXperDB_scale.max_clusters"/>
										<span style="width: 500px;"><spring:message code="help.eXperDB_scale_set_msg08" /></span>
									</a>
								</th>
								<td>
									<input type="text" class="txt" name="com_max_clusters" id="com_max_clusters" style="width: 200px;" maxlength="5"  onKeyPress="chk_Number(this);" placeholder="<spring:message code='eXperDB_scale.msg15'/>" onblur="this.value=this.value.trim()" tabindex=3 />
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip" onclick="return false;"><spring:message code="eXperDB_scale.min_clusters"/>
										<span style="width: 500px;"><spring:message code="help.eXperDB_scale_set_msg07" /></span>
									</a>
								</th>
								<td>
									<input type="text" class="txt" name="com_min_clusters" id="com_min_clusters" style="width: 200px;" maxlength="5"  onKeyPress="chk_Number(this);" placeholder="<spring:message code='eXperDB_scale.msg15' />" onblur="this.value=this.value.trim()" tabindex=4 />
								</td>
							</tr>
<%-- 							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip" onclick="return false;"><spring:message code="eXperDB_scale.auto_execution_cycle"/>
										<span style="width: 500px;"><spring:message code="help.eXperDB_scale_set_msg12" /></span>
									</a>
								</th>
								<td>
									<input type="text" class="txt" name="com_auto_run_cycle" id="com_auto_run_cycle" style="width: 200px;" maxlength="2"  onKeyPress="chk_Number(this);" placeholder='<spring:message code="eXperDB_scale.msg16" />' onblur="this.value=this.value.trim()" tabindex=5 />
								</td>
							</tr> --%>
						</tbody>
					</table>
				</form>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01" onClick="fnc_com_insert_wrk();"><button type="button"><spring:message code="common.registory" /></button></span>
				<span class="btn" onclick="self.close();return false;"><button type="button"><spring:message code="common.cancel" /></button></span>
			</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>