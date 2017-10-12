<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">

<link rel = "stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type="text/css" media="screen" href="<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel = "stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel = "stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>

<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>" />
<script src="/js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="/js/treeview/jquery.treeview.js" type="text/javascript"></script>
</head>

<script language="javascript">
	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(function() {
		$("#rman_path").hide();
		$("#rman_bck_opt").hide();
		$("#dump_bck_opt").hide();

		fn_makeHour();
		fn_makeMin();

	});
	
	
	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeHour(){
		var hour = "";
		var hourHtml ="";
		
		hourHtml += '<select class="select t7" name="exe_h" id="exe_h">';	
		for(var i=0; i<=23; i++){
			if(i >= 0 && i<10){
				hour = "0" + i;
			}else{
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">'+hour+'</option>';
		}
		hourHtml += '</select> 시';	
		$( "#hour" ).append(hourHtml);
	}


	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin(){
		var min = "";
		var minHtml ="";
		
		minHtml += '<select class="select t7" name="exe_m" id="exe_m">';	
		for(var i=0; i<=59; i++){
			if(i >= 0 && i<10){
				min = "0" + i;
			}else{
				min = i;
			}
			minHtml += '<option value="'+min+'">'+min+'</option>';
		}
		minHtml += '</select> 분';	
		$( "#min" ).append(minHtml);
	}



	//스케줄명 중복체크
	function fn_check() {
		var scd_nm = document.getElementById("scd_nm");
		if (scd_nm.value == "") {
			alert("스케줄명을 입력하세요.");
			document.getElementById('scd_nm').focus();
			return;
		}
		$.ajax({
			url : '/scd_nmCheck.do',
			type : 'post',
			data : {
				scd_nm : $("#scd_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert("등록가능한 스케줄명 입니다.");
					document.getElementById("scd_nm").focus();
					scd_nmChk = "success";
				} else {
					scd_nmChk = "fail";
					alert("중복된 스케줄명이 존재합니다.");
					document.getElementById("scd_nm").focus();
				}
			},
			error : function(request, status, error) {
				alert("실패");
			}
		});
	}


	 function fn_bck(){
		var bck = $("#bck").val();
		
		if(bck == "rman"){
			$("#rman_bck_opt").show();
			$("#rman_path").show();
			$("#dump_bck_opt").hide();
		}else if(bck == "dump"){
			$("#dump_bck_opt").show();
			$("#rman_path").hide();
			$("#rman_bck_opt").hide();
		}else{
			$("#rman_path").hide();
			$("#rman_bck_opt").hide();
			$("#dump_bck_opt").hide();
		}	
	} 	
</script>
<body>
		<div class="contents_wrap">
			<div class="contents_tit">
				<h4>
					백업 스케줄 간편 등록 <a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
				</h4>
			</div>
			<div class="contents_pop">
				<div class="cmm_grp">
					<div class="sch_form">
						<table class="write">
							<caption>검색 조회</caption>
							<colgroup>
								<col style="width: 90px;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="t9 line">스케줄명</th>
									<td><input type="text" class="txt t2" id="scd_nm"
										name="scd_nm" /> <span class="btn btnF_04 btnC_01"><button
												type="button" class="btn_type_02" onclick="fn_check()"
												style="width: 60px; margin-right: -60px; margin-top: 0;">중복체크</button></span>
									</td>
								</tr>
								<tr>
									<th scope="row" class="t9 line">백업설정</th>
									<td>
											<select name="bck" id="bck" class="txt t3" style="width: 150px;" onChange="fn_bck();">
												<option value="">선택</option>
												<option value="rman">RMAN</option>
												<option value="dump">DUMP</option>
											</select> 
											<span id="rman_bck_opt"> 											
												<select name="bck_opt_cd" id="bck_opt_cd" class="txt t3" style="width: 150px;">
													<option value="">선택</option>
													<option value="TC000301">FULL</option>
													<option value="TC000302">incremental</option>
													<option value="TC000303">archive</option>
												</select>
											</span> 
											<span id="dump_bck_opt"> 
												<select name="db_id" id="db_id" class="txt t3" style="width: 150px;">
													<option value="">선택</option>
													<c:forEach var="result" items="${dbList}" varStatus="status">
														<option value="<c:out value="${result.db_id}"/>"><c:out value="${result.db_nm}" /></option>
													</c:forEach>
												</select>
											</span>
									</td>
								</tr>
								
								<div id="rman_path">
								<tr>
									<th scope="row" class="t9 line">로그경로</th>
									<td>
										<input type="text" class="txt" name="log_pth" id="log_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path3').val('N')"/>
										<span class="btn btnF_04 btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(3)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
									</td>
								</tr>
</div>
								<tr>
									<th scope="row" class="t9 line">데이터경로</th>
									<td>
										<input type="text" class="txt" name="data_pth" id="data_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path1').val('N')"/>
										<span class="btn btnF_04 btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(1)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
									</td>
								</tr>

								<tr>	
									<th scope="row" class="t9 line">백업경로</th>
									<td>
										<input type="text" class="txt" name="bck_pth" id="bck_pth" maxlength=50 style="width:230px" onKeydown="$('#check_path2').val('N')"/>
										<span class="btn btnF_04 btnC_01"><button type="button" class= "btn_type_02" onclick="checkFolder(2)" style="width: 60px; margin-right: -60px; margin-top: 0;">경로체크</button></span>
									</td>
								</tr>
							</div>
								
								<tr>
									<th scope="row" class="t9 line">스케줄설정</th>
									<td>
										<div class="schedule_wrap">
											<span id="weekDay"> 
												일 <input type="checkbox" id="chk" name="chk" value="0"> 
												월 <input type="checkbox" id="chk" name="chk" value="0"> 
												화 <input type="checkbox" id="chk" name="chk" value="0"> 
												수 <input type="checkbox" id="chk" name="chk" value="0"> 
												목 <input type="checkbox" id="chk" name="chk" value="0"> 
												금 <input type="checkbox" id="chk" name="chk" value="0"> 
												토 <input type="checkbox" id="chk" name="chk" value="0">
											</span> <span>
												<div id="hour"></div>
											</span> <span>
												<div id="min"></div>
											</span>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
</body>
</html>