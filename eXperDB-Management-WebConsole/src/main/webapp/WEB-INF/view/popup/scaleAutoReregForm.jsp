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
	* @Description : scale Auto 설정 수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
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
/*툴팁 스타일*/
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
    -moz-border-radius: 5px; /* 파폭 박스 둥근 정도 */
    -webkit-border-radius: 5px; /* 사파리 박스 둥근 정도 */
}

a:hover.tip span {
    display: block;
}
</style>


<script type="text/javascript">
	var wrk_id_param = "${wrk_id}";
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
	 * 수정 내역 조회
	 ******************************************************** */
	function fnc_search(){
		$.ajax({
			url : "/scale/popup/scaleAutoInstallInfo.do", 
		  	data : {
		  		db_svr_id : db_svr_id_param,
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
					$("#min_clusters_hd").val(data.min_clusters);
					$("#max_clusters_hd").val(data.max_clusters);
				}
			}
		});

		$.ajax({
			url : "/scale/selectScaleCngList.do", 
		  	data : {
		  		db_svr_id : db_svr_id_param,
		  		wrk_id : wrk_id_param
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
					$("#scale_type_cd", "#scaleReregForm").val(data[0].scale_type);
					$("#execute_type_cd", "#scaleReregForm").val(data[0].execute_type);
					$("#policy_type_cd", "#scaleReregForm").val(data[0].policy_type);

					$("#auto_policy_time", "#scaleReregForm").val(data[0].auto_policy_time);
					$("#auto_level", "#scaleReregForm").val(data[0].auto_level);

					$("#min_clusters", "#scaleReregForm").val(data[0].min_clusters);
					$("#max_clusters", "#scaleReregForm").val(data[0].max_clusters);
					$("#expansion_clusters", "#scaleReregForm").val(data[0].expansion_clusters);
					
					var auto_policy_set_div = data[0].auto_policy_set_div;
					
					//radio policy_time_div
					$('input:radio[name=auto_policy_set_div]:input[value=' + auto_policy_set_div + ']').attr("checked", true);
					
					var useyn = data[0].useyn;
					$('input:radio[name=useyn]:input[value=' + useyn + ']').attr("checked", true);
					
				} else {
					alert("<spring:message code='eXperDB_scale.msg7' />");
				}
				
				fn_scale_type_chg_init();
				fn_policy_type_chg();
			}
		});
	}
	
	/* ********************************************************
	 * NUMBER check
	 ******************************************************** */
	function NumObj() {
		if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
			return true;
		} else {
			(event.preventDefault) ? event.preventDefault() : event.returnValue = false;
		}
	}

	/* ********************************************************
	 * scale 유형 / 실행유형 변경에 따른 최소/최대 클러수터 변경
	 ******************************************************** */
	function fn_scale_type_chg_init() {
		var scale_type_cd = nvlSet($("#scale_type_cd").val(),""); //scale 유형
		var execute_type_cd = nvlSet($("#execute_type_cd").val(),""); //실행유형

		if (scale_type_cd == "1" && execute_type_cd == "TC003402") { //scale-in / auto-scale
			$("#max_clusters").val("");

			$("#expansion_clusters").prop('disabled', true);			
			$("#expansion_clusters").val("");
		} else if (scale_type_cd == "2" && execute_type_cd == "TC003402") { //scale-out / auto-scale
			$("#min_clusters").val("");

			$("#expansion_clusters").prop('disabled', false);
		} else {
			$("#min_clusters").val("");
			$("#max_clusters").val("");
			$("#expansion_clusters").val("");

			$("#expansion_clusters").prop('disabled', true);
		}
	}
	
	/* ********************************************************
	 * scale 유형 / 실행유형 변경에 따른 최소/최대 클러수터 변경
	 ******************************************************** */
	function fn_scale_type_chg() {
		var scale_type_cd = nvlSet($("#scale_type_cd").val(),""); //scale 유형
		var execute_type_cd = nvlSet($("#execute_type_cd").val(),""); //실행유형

		if (scale_type_cd == "1" && execute_type_cd == "TC003402") { //scale-in / auto-scale
			$("#min_clusters").val($("#min_clusters_hd").val());
			$("#max_clusters").val("");

			$("#expansion_clusters").prop('disabled', true);			
			$("#expansion_clusters").val("");
			
			if ($("#min_clusters").val() == "") {
				$("#min_clusters").val("2");
			}
		} else if (scale_type_cd == "2" && execute_type_cd == "TC003402") { //scale-out / auto-scale
			$("#max_clusters").val($("#max_clusters_hd").val());
			$("#min_clusters").val("");

			$("#expansion_clusters").prop('disabled', false);
		} else {
			$("#min_clusters").val("");
			$("#max_clusters").val("");
			$("#expansion_clusters").val("");

			$("#expansion_clusters").prop('disabled', true);
		}
	}

	/* ********************************************************
	 * 정책유형에 따른 %표시 출력
	 ******************************************************** */
	function fn_policy_type_chg() {
		var policy_type_cd = nvlSet($("#policy_type_cd").val(),""); //정책유형

		if (policy_type_cd == "TC003501") { //cpu
			$("#check_execute_sp").show();
		} else {
			$("#check_execute_sp").hide();
		}
	}
	
	/* ********************************************************
	 * null체크
	 ******************************************************** */
	function nvlSet(val, reVal) {
		var strValue = val;
		if( strValue == null || strValue == 'undefined') {
			strValue = reVal;
		}
		
		return strValue;
	}
	
	/* ********************************************************
	 * update button click
	 ******************************************************** */
	function fn_update_wrk() {
		//화면 valid check
		if (!valCheck()) return false;

		var min_clusters_val = nvlSet($("#min_clusters").val(), "");
		var max_clusters_val = nvlSet($("#max_clusters").val(), "");
		var expansion_clusters_val = nvlSet($("#expansion_clusters").val(), "");
		
		//중복 체크
		$.ajax({
			async : false,
			url : "/scale/popup/scaleCngUpdate.do",
		  	data : {
		  		wrk_id : $("#wrk_id").val(),
		  		db_svr_id : $("#db_svr_id").val(),
		  		scale_type_cd : $("#scale_type_cd").val(),
		  		execute_type_cd : $("#execute_type_cd").val(),
		  		policy_type_cd : $("#policy_type_cd").val(),
		  		auto_policy_time : $("#auto_policy_time").val(),
		  		auto_level : $("#auto_level").val(),
		  		min_clusters : min_clusters_val,
		  		max_clusters : max_clusters_val,
		  		expansion_clusters : expansion_clusters_val,
		  		auto_policy_set_div : $(':radio[name="auto_policy_set_div"]:checked').val(),
		  		useyn : $(':radio[name="useyn"]:checked').val()
		  	},
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
				if(result == "O"){//중복
					alert('<spring:message code="eXperDB_scale.msg5"/>');
					return false;
				}else if(result == "F"){//저장실패
					alert('<spring:message code="eXperDB_scale.msg2"/>');
					return false;
				}else{
					alert('<spring:message code="message.msg84"/>');
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
		if(nvlSet($("#scale_type_cd").val(),"") == "") { //scale type
			msgVale = '<spring:message code="eXperDB_scale.scale_type" />';
			alert('<spring:message code="eXperDB_scale.msg3" arguments="'+ msgVale +'" />');

			$('input[name=scale_type_cd]').focus();
			return false;
		} 

		if(nvlSet($("#execute_type_cd").val(),"") == "") { //execute type
			msgVale = '<spring:message code="eXperDB_scale.execute_type" />';
			alert('<spring:message code="eXperDB_scale.msg3" arguments="'+ msgVale +'" />');

			$('input[name=execute_type_cd]').focus();
			return false;
		}

		if(nvlSet($("#policy_type_cd").val(),"") == "") { //policy type
			msgVale = '<spring:message code="eXperDB_scale.policy_type" />';
			alert('<spring:message code="eXperDB_scale.msg3" arguments="'+ msgVale +'" />');

			$('input[name=policy_type_cd]').focus();
			return false;
		}

		if(nvlSet($("#auto_policy_time").val(),"") == "") { //auto_policy_time
			alert('<spring:message code="eXperDB_scale.msg18" arguments="1" />');

			$('input[name=auto_policy_time]').focus();
			return false;
		}

		if(nvlSet($("#auto_level").val(),"") == "") { //auto_level
			alert('<spring:message code="eXperDB_scale.msg18" arguments="1" />');

			$('input[name=auto_level]').focus();
			return false;
		}
		
		if (nvlSet($("#scale_type_cd").val(),"") == "1" && nvlSet($("#execute_type_cd").val(),"") == "TC003402") { //scale-in / auto-scale
			if(nvlSet($("#min_clusters").val(),"") == "") { 
				msgVale = '<spring:message code="eXperDB_scale.min_clusters" />';
				alert('<spring:message code="eXperDB_scale.msg19" arguments="'+ msgVale +'" />' + "\n" +'<spring:message code="eXperDB_scale.msg20" />');

				$('input[name=min_clusters]').focus();
				return false;
			}
		
			if(nvlSet($("#min_clusters").val(),"") < "2") { 
				alert('<spring:message code="eXperDB_scale.msg6" arguments="2" />');

				$('input[name=min_clusters]').focus();
				return false;
			}
		} else if (nvlSet($("#scale_type_cd").val(),"") == "2" && nvlSet($("#execute_type_cd").val(),"") == "TC003402") { //scale-out / auto-scale
			if(nvlSet($("#max_clusters").val(),"") == "") { 
				msgVale = '<spring:message code="eXperDB_scale.max_clusters" />';
				alert('<spring:message code="eXperDB_scale.msg19" arguments="'+ msgVale +'" />' + "\n" +'<spring:message code="eXperDB_scale.msg20" />');

				$('input[name=max_clusters]').focus();
				return false;
			}

			if(nvlSet($("#expansion_clusters").val(),"") == "") { 
				msgVale = '<spring:message code="eXperDB_scale.expansion_clusters" />';
				alert('<spring:message code="eXperDB_scale.msg18" arguments="1" />');

				$('input[name=expansion_clusters]').focus();
				return false;
			}
		}
		
		return true;
	}
</script>
</head>
<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="menu.Register_auto_scale_setting" /></p>
			<div class="pop_cmm">
				<form name="scaleReregForm" id="scaleReregForm">
					<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
					<input type="hidden" name="wrk_id" id="wrk_id" value="${wrk_id}"/>
					<input type="hidden" name="min_clusters_hd" id="min_clusters_hd" value=""/>
					<input type="hidden" name="max_clusters_hd" id="max_clusters_hd" value=""/>

					<table class="write">
						<caption><spring:message code="menu.Register_auto_scale_setting" /></caption>
						<colgroup>
							<col style="width:120px;" />
							<col style="width:300px;" />
							<col style="width:120px;" />
							<col style="width:300px;" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.scale_type" />
										<span style="width: 350px;"><spring:message code="help.eXperDB_scale_set_msg01" /></span>
									</a>
								</th>
								<td>
									<select name="scale_type_cd" id="scale_type_cd" class="select"  onChange="fn_scale_type_chg();" style="width: 170px;" tabindex=1>
										<option value=""><spring:message code="common.choice" /></option>
										<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
										<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
									</select>
								</td>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.execute_type" />
										<span style="width: 370px;"><spring:message code="help.eXperDB_scale_set_msg02" /></span>
									</a>
								</th>
								<td>
									<select name="execute_type_cd" id="execute_type_cd" class="select" onChange="fn_scale_type_chg();" style="width: 170px;" tabindex=2>
										<option value=""><spring:message code="common.choice" /></option>
										<c:forEach var="result" items="${executeTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.policy_type" />
										<span ><spring:message code="help.eXperDB_scale_set_msg03" /></span>
									</a>
								</th>
								<td>
									<select name="policy_type_cd" id="policy_type_cd" class="select t5" style="width: 170px;" onChange="fn_policy_type_chg();" tabindex=3>
										<option value=""><spring:message code="common.choice" /></option>
										<c:forEach var="result" items="${policyTypeList}" varStatus="status">
											<c:if test="${result.sys_cd == 'TC003501'}">
												<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
											</c:if>
										</c:forEach>
									</select>
								</td>
								<th scope="row" class="ico_t1">
									<spring:message code="user_management.use_yn" />
								</th>
								<td>
									<div class="inp_rdo">
										<input name="useyn" id="useyn_1" type="radio" value="Y" checked="checked" tabindex=4>
										<label for="useyn_1" style="margin-right: 2%;"><spring:message code="dbms_information.use"/></label>
										<input name="useyn" id="useyn_2" type="radio" value="N" tabindex=5>
										<label for="useyn_2" style="margin-right: 2%;"><spring:message code="dbms_information.unuse"/></label>
									</div>
								</td>
								
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.policy_time_div" />
										<span style="width: 320px;"><spring:message code="help.eXperDB_scale_set_msg04" /></span>
									</a>
								</th>
								<td>
									<div class="inp_rdo">
										<input name="auto_policy_set_div" id="auto_policy_set_div_1" type="radio" value="1" checked="checked" tabindex=5>
										<label for="auto_policy_set_div_1" style="margin-right: 2%;"><spring:message code="eXperDB_scale.policy_time_1"/></label>
										<input name="auto_policy_set_div" id="auto_policy_set_div_2" type="radio" value="2" tabindex=6>
										<label for="auto_policy_set_div_2" style="margin-right: 2%;"><spring:message code="eXperDB_scale.policy_time_2"/></label>
									</div>
								</td>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.policy_time" />
										<span style="width: 350px;"><spring:message code="help.eXperDB_scale_set_msg05" /></span>
									</a>
								</th>
								<td>
									<span>
										<input type="text" class="txt" name="auto_policy_time" id="auto_policy_time" style="width: 200px;" maxlength="10" onKeyPress="NumObj();" placeholder="<spring:message code='eXperDB_scale.msg16'/>" onblur="this.value=this.value.trim()" tabindex=7 />
										&nbsp;<spring:message code="eXperDB_scale.time_minute"/>
									</span>
								</td>
							</tr>					
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.target_value" />
										<span style="width: 310px;"><spring:message code="help.eXperDB_scale_set_msg06" /></span>
									</a>
								</th>
								<td colspan="3">
									<input type="text" class="txt" name="auto_level" id="auto_level" style="width: 200px;" maxlength="10" onKeyPress="NumObj();" placeholder="<spring:message code="eXperDB_scale.msg15" />" onblur="this.value=this.value.trim()" tabindex=8 />
									<span id="check_execute_sp">	
										&nbsp;%
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.min_clusters" />
										<span style="width: 400px;"><spring:message code="help.eXperDB_scale_set_msg10" /></span>
									</a>
								</th>
								<td colspan="3">
									<input type="text" class="txt" name="min_clusters" id="min_clusters" style="width: 200px;" maxlength="5" onKeyPress="NumObj();" onblur="this.value=this.value.trim()" tabindex=9 />
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.max_clusters" />
										<span style="width: 400px;"><spring:message code="help.eXperDB_scale_set_msg11" /></span>
									</a>
								</th>
								<td>
									<input type="text" class="txt" name="max_clusters" id="max_clusters" style="width: 200px;" maxlength="5" onKeyPress="NumObj();" onblur="this.value=this.value.trim()" tabindex=10 />
								</td>
								<th scope="row" class="ico_t1">
									<a href="#" class="tip"><spring:message code="eXperDB_scale.expansion_clusters" />
										<span style="width: 400px;"><spring:message code="help.eXperDB_scale_set_msg09" /></span>
									</a>
								</th>
								<td>
									<input type="text" class="txt" name="expansion_clusters" id="expansion_clusters" style="width: 200px;" maxlength="5" onKeyPress="NumObj();" placeholder="<spring:message code='eXperDB_scale.msg15'/>" onblur="this.value=this.value.trim()" tabindex=11 />
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<div class="btn_type_02">
				<span class="btn btnC_01" onClick="fn_update_wrk();"><button type="button"><spring:message code="common.modify" /></button></span>
				<span class="btn" onclick="self.close();return false;"><button type="button"><spring:message code="common.cancel" /></button></span>
			</div>
		</div><!-- //pop-container -->
	</div>
</body>
</html>