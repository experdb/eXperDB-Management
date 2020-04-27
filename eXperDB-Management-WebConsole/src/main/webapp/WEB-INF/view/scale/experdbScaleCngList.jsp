<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : experdbScaleCngList.jsp
	* @Description : Auto scale 설정
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
<style>
.scaleIng {  display:inline-block; margin:0 2px; height:20px; padding:0 12px; color:red; text-align:left; font-weight: bold; font-size:13px;}

table {border-spacing: 0}
table th, table td {padding: 0}

button:disabled,
button[disabled]{
  background-color: #fff;
  color: #324452;
  cursor:wait;
}
</style>

<script type="text/javascript">
	var popOpen = null;
	var msgVale = "";

	/* ********************************************************
	 * scale setting 초기 실행
	 ******************************************************** */
	$(window.document).ready(function() {
		fn_init();

		//aws 서버 확인
		fn_selectScaleInstallChk();
	});

	function fn_init(){
		var scale_type_nm_init = "";
		table = $('#scaleSetTable').DataTable({
		scrollY : "360px",
		scrollX : true,
		searching : false,	
		deferRender : true,
		bSort: false,
		columns : [
					{data : "rownum", defaultContent : "", targets : 0, orderable : false, checkboxes : {'selectRow' : true}}, 
					{data : "idx", className : "dt-center", defaultContent : ""}, 
		         	{data : "scale_type_nm", className : "dt-center", defaultContent : ""
						,"render": function (data, type, full) {

	 						if (full.scale_type == "1") {
	 							scale_type_nm_init = '<spring:message code="etc.etc38" />';
	 						} else {
	 							scale_type_nm_init = '<spring:message code="etc.etc39" />';
	 						}
							return '<span onClick=javascript:fn_wrkLayer("'+full.wrk_id+'"); class="bold">' + scale_type_nm_init + '</span>';
						}
		         	},
		         	{data : "policy_type_nm", className : "dt-center", defaultContent : ""},
		         	{
		         		data : "auto_policy_contents", 
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						
	 						if (full.auto_policy_set_div == "1") {
 								html += '<spring:message code="eXperDB_scale.policy_time_1" />';
	 						} else {
 								html += '<spring:message code="eXperDB_scale.policy_time_2" />';
	 						}
	 						
	 						html += "&nbsp;&nbsp;&nbsp;&nbsp;" + full.auto_policy_time + '&nbsp;' + '<spring:message code="eXperDB_scale.time_minute" />';

	 						return html;
	 					},
		         		className : "dt-left", defaultContent : ""},
		         	{
		         		data : "auto_level", 
	 					render : function(data, type, full, meta) {	 						
	 						var html = full.auto_level;
	 						
	 						if (full.policy_type == "TC003501") {
 								html += ' %';
	 						}
	 						return html;
	 					},
		         		className : "dt-right", defaultContent : ""},
		         	{
		         		data : "execute_type_nm", 
	 					render : function(data, type, full, meta) {	 						
	 						var html = '';
	 						if (full.execute_type_cd == 'TC003401') {
	 							html += '<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_1.png" alt=""  style="margin-right:3px;"/>' + full.execute_type_nm +'</span>';
	 						} else {
	 							html +='<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_2.png" alt="" style="margin-right:3px;" />' + full.execute_type_nm +'</span>';
	 						}
	 						return html;
	 					},
		         		className : "dt-center", defaultContent : ""},
					{data : "expansion_clusters", className : "dt-right", defaultContent : ""},
					{data : "min_clusters", className : "dt-right", defaultContent : ""},
					{data : "max_clusters", className : "dt-right", defaultContent : ""},
					{data : "frst_regr_id", defaultContent : ""},
					{data : "frst_reg_dtm", defaultContent : ""},
					{data : "lst_mdfr_id", defaultContent : ""},
					{data : "lst_mdf_dtm", defaultContent : ""},
					{data : "wrk_id", defaultContent : "", visible: false }
			],'select': {'style': 'multi'}
		});
		
		table.tables().header().to$().find('th:eq(0)').css('min-width', '10px');
		table.tables().header().to$().find('th:eq(1)').css('min-width', '40px');
		table.tables().header().to$().find('th:eq(2)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(3)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(4)').css('min-width', '200px');
		table.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(8)').css('min-width', '100px');  
		table.tables().header().to$().find('th:eq(9)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(10)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(11)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(12)').css('min-width', '100px');
		table.tables().header().to$().find('th:eq(13)').css('min-width', '100px');
 
		$(window).trigger('resize'); 
	}
	
	/* ********************************************************
	 * Scale Data Fetch List
	 ******************************************************** */
	function fn_search_list(){
		$.ajax({
			url : "/scale/selectScaleCngList.do", 
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val(),
		  		scale_type_cd : $("#scale_type_cd").val(),
		  		execute_type_cd : $("#execute_type_cd").val(),
		  		policy_type_cd : $("#policy_type_cd").val()
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

				if (nvlSet(result) != '' && nvlSet(result) != '-') {
					table.rows.add(result).draw();
				}
			}
		});
	}
	
	/* ********************************************************
	 * Scale reg Btn click
	 ******************************************************** */
	function fn_reg_popup(){
	    var popUrl = '/scale/popup/scaleAutoRegForm.do';
		var width = 954;
		var height = 543;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no,";

	    popOpen = window.open("","scaleregPop",popOption);

	    $('#wrk_id', '#frmRegPopup').val("");
	    $('#db_svr_id', '#frmRegPopup').val($("#db_svr_id", "#findList").val());

	    $('#frmRegPopup').attr("action", popUrl);
	    $('#frmRegPopup').attr("target", "scaleregPop");

	    $('#frmRegPopup').submit();
	    
	    popOpen.focus();
	}
	
	/* ********************************************************
	 * scale Aotu Reregist Window Open
	 ******************************************************** */
	function fn_mod_popup(){
		var datas = table.rows('.selected').data();
		
		if (datas.length <= 0) {
			alert("<spring:message code='message.msg35' />");
			return;
		}else if(datas.length > 1){
			alert("<spring:message code='message.msg04' />");
			return;
		}
		
		//scale 실행 중 체크
		if (!fn_scaleChk()) {
			return;
		}
		
	    var popUrl = '/scale/popup/scaleAutoReregForm.do';
		var width = 954;
		var height = 543;
		var left = (window.screen.width / 2) - (width / 2);
		var top = (window.screen.height /2) - (height / 2);
		var popOption = "width="+width+", height="+height+", top="+top+", left="+left+", resizable=no, scrollbars=yes, status=no, toolbar=no, titlebar=yes, location=no";

	    popOpen = window.open("","scaleregPop",popOption);

	    $('#wrk_id', '#frmRegPopup').val(table.row('.selected').data().wrk_id);
	    $('#db_svr_id', '#frmRegPopup').val($("#db_svr_id", "#findList").val());

	    $('#frmRegPopup').attr("action", popUrl);
	    $('#frmRegPopup').attr("target", "scaleregPop");

	    $('#frmRegPopup').submit();
	    
	    popOpen.focus();
		
	}

	/* ********************************************************
	 * scale setting Data Delete
	 ******************************************************** */
	function fn_del_data(){
 		var wrk_id = "";
		var scale_set = "";

		var datas = table.rows('.selected').data();

		if(datas.length < 1){
			alert("<spring:message code='message.msg16' />");
			return false;
		}

		var wrk_id_List = [];
		for (var i = 0; i < datas.length; i++) {
			wrk_id_List.push( table.rows('.selected').data()[i].wrk_id); 
		}
		
		//scale 실행 중 체크
		if (!fn_scaleChk()) {
			return;
		}
		
		if(!confirm('<spring:message code="message.msg17" />')){
			return;
		}
		
		$.ajax({
			url : "/scale/scaleWrkIdDelete.do",
		  	data : {
		  		wrk_id_List : JSON.stringify(wrk_id_List),
		  		db_svr_id : $("#db_svr_id", "#findList").val()
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
				if(result == "O" || result == "F"){//저장실패
					msgVale = "<spring:message code='menu.eXperDB_scale_settings' />";
					alert('<spring:message code="eXperDB_scale.msg9" arguments="'+ msgVale +'" />');
					return false;
				}else{
					alert('<spring:message code="message.msg60" />');
					fn_search_list();
				}
			}
		});	

	}
	
	/* ********************************************************
	 * scale ing check
	 ******************************************************** */
	function fn_scaleChk() {
		//scale 이 실행되고 있는 지 체크
 		$.ajax({
			url : "/scale/selectScaleLChk.do",
			data : {
				db_svr_id : $("#db_svr_id", "#findList").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert("<spring:message code='message.msg02' />");
					return false;
				} else if(xhr.status == 403) {
					alert("<spring:message code='message.msg03' />");
					return false;
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					return false;
				}
			},
			success : function(result) {
				if (result != null) {
					wrk_id = result.wrk_id;
					scale_set = result.scale_type;

					if (wrk_id == "1") {
						alert("<spring:message code='eXperDB_scale.msg4' />");
						return false;
					} else {
						return true;
					}
				}
			}
		});
		
		return true;
	}

	/* ********************************************************
	 * scale 설정 상세
	 ******************************************************** */
	function fn_wrkLayer(wrk_id){
		var auto_policy_set_div_nm = "";
		var level_nm = "";
		var execute_type_nm = "";
		var scale_type_nm = "";
	
		$.ajax({
			url : "/scale/selectAutoScaleCngInfo.do",
			data : {
				wrk_id : wrk_id,
				db_svr_id : $("#db_svr_id", "#findList").val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
		     error : function(xhr, status, error) {
					if(xhr.status == 401) {
						alert(message_msg02);
						top.location.href = "/";
					} else if(xhr.status == 403) {
						alert(message_msg03);
						top.location.href = "/";
					} else {
						alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
					}
				},
			success : function(result) {
				if(result == null){
					msgVale = "<spring:message code='menu.eXperDB_scale_settings' />";
					alert('<spring:message code="eXperDB_scale.msg8" arguments="'+ msgVale +'" />');
				}else{	
					if (result.scale_type == "1") {
						scale_type_nm = '<spring:message code="etc.etc38" />';
 					} else {
 						scale_type_nm = '<spring:message code="etc.etc39" />';
 					}

					$("#d_scale_type_nm").html(scale_type_nm);
					$("#d_policy_type_nm").html(nvlSet(result.policy_type_nm));

					if (result.auto_policy_set_div == "1") {
						auto_policy_set_div_nm = '<spring:message code="eXperDB_scale.policy_time_1" />';
 					} else {
 						auto_policy_set_div_nm = '<spring:message code="eXperDB_scale.policy_time_2" />';
 					}
					$("#d_auto_policy_set_div_nm").html(auto_policy_set_div_nm);

					$("#d_auto_policy_time").html(nvlSet(result.auto_policy_time + ' ' +'<spring:message code="eXperDB_scale.time_minute" />'));

					level_nm = nvlSet(result.auto_level);
					if (result.policy_type == "TC003501" && level_nm != "-") {
						level_nm += " %";
					}
					$("#d_level").html(level_nm);

					if (result.execute_type == 'TC003401') {
						execute_type_nm = '<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_1.png" alt=""  style="margin-right:3px;"/>' + result.execute_type_nm +'</span>';
 					} else {
 						execute_type_nm = '<span class="btn btnC_01 btnF_02"><img src="../images/ico_agent_2.png" alt="" style="margin-right:3px;" />' + result.execute_type_nm +'</span>';
 					}
					$("#d_execute_type_nm").html(execute_type_nm);

					$("#d_expansion_clusters").html(nvlSet(result.expansion_clusters));
					$("#d_min_clusters").html(nvlSet(result.min_clusters));
					$("#d_max_clusters").html(nvlSet(result.max_clusters));
					$("#d_frst_regr_id").html(nvlSet(result.frst_regr_id));
					$("#d_frst_reg_dtm").html(nvlSet(result.frst_reg_dtm));
					$("#d_lst_mdfr_id").html(nvlSet(result.lst_mdfr_id));
					$("#d_lst_mdf_dtm").html(nvlSet(result.lst_mdf_dtm));

					toggleLayer($('#pop_layer_cng'), 'on'); 
				}
		
			}
		});	
	}

	/* ********************************************************
	 * null체크
	 ******************************************************** */
	function nvlSet(val) {
		var strValue = val;
		if( strValue == null || strValue == '') {
			strValue = "-";
		}
		
		return strValue;
	}

	/* ********************************************************
	 * aws 서버 확인
	 ******************************************************** */
	function fn_selectScaleInstallChk() {
		//scale 체크 조회
		var install_yn = "";

		$.ajax({
			url : "/scale/selectScaleInstallChk.do",
			data : {
				db_svr_id : '${db_svr_id}'
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				console.log("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			},
			success : function(result) {
				if (result != null) {
					install_yn = result.install_yn;
				}

				//AWS 서버인경우
				if (install_yn == "Y") {
					$("#scaleIngMsg").hide();
					
					fn_search_list();
				} else {
					$("#scaleIngMsg").show();

					//설치안된경우 버튼 막아야함
					$("#btnInsert").prop("disabled", "disabled");
					$("#btnModify").prop("disabled", "disabled");
					$("#btnDelete").prop("disabled", "disabled");
					
					$("#btnCngSearch").prop("disabled", "disabled");

					$("#scale_type_cd").prop("disabled", "disabled");
					$("#policy_type_cd").prop("disabled", "disabled");
					$("#execute_type_cd").prop("disabled", "disabled");
				}
			}
		});
		$('#loading').hide();
	}
</script>

<%@include file="./experdbScaleCngInfo.jsp"%>

<form name="frmRegPopup" id="frmRegPopup" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value=""/>
	<input type="hidden" name="wrk_id" id="wrk_id" value=""/>
</form>


<form name="findList" id="findList" method="post">
	<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/>
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.eXperDB_scale_settings" /><a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a></h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.eXperDB_scale_history_01" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li><spring:message code="menu.eXperDB_scale" /></li>
					<li class="on"><spring:message code="menu.eXperDB_scale_settings" /></li>
				</ul>
			</div>
		</div>

		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="scaleIng" id="scaleIngMsg" style="display:none;">* <spring:message code="eXperDB_scale.msg10" /></span>

					<span class="btn"><button type="button" id="btnCngSearch" onClick="fn_search_list();"><spring:message code="common.search" /></button></span>
					<span class="btn"><button type="button" id="btnInsert" onClick="fn_reg_popup();"><spring:message code="common.registory" /></button></span>
					<span class="btn"><button type="button" id="btnModify" onClick="fn_mod_popup();"><spring:message code="common.modify" /></button></span>
					<span class="btn"><button type="button" id="btnDelete" onClick="fn_del_data();"><spring:message code="common.delete" /></button></span>
				</div>
				
				<div class="sch_form">
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>							
							<col style="width:120px;" />
							<col style="width:310px;" />
							<col style="width:120px;" />
							<col />
						</colgroup>
						<tbody>
							<tr style="height:35px;">
								<th scope="row" class="t9"><spring:message code="eXperDB_scale.scale_type" /></th>
								<td>
									<select name="scale_type_cd" id="scale_type_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="1"><spring:message code="eXperDB_scale.scale_in" /></option>
										<option value="2"><spring:message code="eXperDB_scale.scale_out" /></option>
									</select>
								</td>
								<th scope="row" class="t9"><spring:message code="eXperDB_scale.policy_type" /></th>
								<td>
									<select name="policy_type_cd" id="policy_type_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${policyTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr class="search_occur">
								<th scope="row" class="t9"><spring:message code="eXperDB_scale.execute_type" /></th>
								<td colspan="3">
									<select name="execute_type_cd" id="execute_type_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<c:forEach var="result" items="${executeTypeList}" varStatus="status">
											<option value="<c:out value="${result.sys_cd}"/>"><c:out value="${result.sys_cd_nm}"/></option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="overflow_area">
					<table id="scaleSetTable" class="display" style="width:100%;">
						<caption>자동확장 설정 리스트</caption>
						<thead>
							<tr>
								<th width="10"></th>
								<th width="40" height="0"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="eXperDB_scale.scale_type" /></th> <!-- scale 유형 -->
								<th width="100"><spring:message code="eXperDB_scale.policy_type" /></th> <!-- 정책 유형 -->
								<th width="200"><spring:message code="eXperDB_scale.policy_type_time" /></th> <!-- 정책 유형 시간 -->
								<th width="100"><spring:message code="eXperDB_scale.target_value" /></th> <!-- level -->
								<th width="100"><spring:message code="eXperDB_scale.execute_type" /></th> <!-- 실행 유형 -->
								<th width="100"><spring:message code="eXperDB_scale.expansion_clusters" /></th> <!-- 확장 클러스터 수 -->
								<th width="100"><spring:message code="eXperDB_scale.min_clusters" /></th> <!-- 최저 클러스터 수 -->
								<th width="100"><spring:message code="eXperDB_scale.max_clusters" /></th> <!-- 최대 클러스터 수 -->
								<th width="100"><spring:message code="common.register" /></th> <!-- 등록자 -->
								<th width="100"><spring:message code="common.regist_datetime" /></th> <!-- 등록일시 -->
								<th width="100"><spring:message code="common.modifier" /></th> <!-- 수정자 -->
								<th width="100"><spring:message code="common.modify_datetime" /></th> <!-- 수정일시 -->				
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>