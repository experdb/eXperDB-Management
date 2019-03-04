<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%@include file="../cmmn/passwordConfirm.jsp"%>

<%
	/**
	* @Class Name : timeRestore.jsp
	* @Description : timeRestore 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2019.01.09     최초 생성
	*
	* author 변승우 대리
	* since 2019.01.09
	*
	*/
%>

<script type="text/javascript">
	var rman_pth = null;
	var db_svr_id = "${db_svr_id}";
	var restore_nmChk ="fail";

	/* ********************************************************
	 * 페이지 시작시 함수
	 ******************************************************** */
	$(window.document).ready(
			function() {
				fn_init();

				fn_makeHour();
				fn_makeMin();
				fn_makeSec();

				$.ajax({
					async : false,
					url : "/selectPathInfo.do",
					data : {
						db_svr_id : db_svr_id
					},
					type : "post",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("AJAX", true);
					},
					error : function(xhr, status, error) {
						if (xhr.status == 401) {
							alert('<spring:message code="message.msg02" />');
							top.location.href = "/";
						} else if (xhr.status == 403) {
							alert('<spring:message code="message.msg03" />');
							top.location.href = "/";
						} else {
							alert("ERROR CODE : "
									+ xhr.status
									+ "\n\n"
									+ "ERROR Message : "
									+ error
									+ "\n\n"
									+ "Error Detail : "
									+ xhr.responseText.replace(/(<([^>]+)>)/gi,
											""));
						}
					},
					success : function(result) {
						rman_pth = result[1].PGRBAK;
					}
				});
			});

	/* ********************************************************
	 * 초기설정
	 ******************************************************** */
	function fn_init() {
		$("#storage_view").hide();
	}

	/* ********************************************************
	 * 시간
	 ******************************************************** */
	function fn_makeHour() {
		var hour = "";
		var hourHtml = "";

		hourHtml += '<select class="select t6" name="timeline_h" id="timeline_h" style="height: 25px;">';
		for (var i = 0; i <= 23; i++) {
			if (i >= 0 && i < 10) {
				hour = "0" + i;
			} else {
				hour = i;
			}
			hourHtml += '<option value="'+hour+'">' + hour + '</option>';
		}
		hourHtml += '</select> <spring:message code="schedule.our" />';
		$("#hour").append(hourHtml);
	}

	/* ********************************************************
	 * 분
	 ******************************************************** */
	function fn_makeMin() {
		var min = "";
		var minHtml = "";

		minHtml += '<select class="select t6" name="timeline_m" id="timeline_m" style="height: 25px;">';
		for (var i = 0; i <= 59; i++) {
			if (i >= 0 && i < 10) {
				min = "0" + i;
			} else {
				min = i;
			}
			minHtml += '<option value="'+min+'">' + min + '</option>';
		}
		minHtml += '</select> <spring:message code="schedule.minute" />';
		$("#min").append(minHtml);
	}

	/* ********************************************************
	 * 초
	 ******************************************************** */
	function fn_makeSec() {
		var sec = "";
		var secHtml = "";

		secHtml += '<select class="select t6" name="timeline_s" id="timeline_s" style="height: 25px;">';
		for (var i = 0; i <= 59; i++) {
			if (i >= 0 && i < 10) {
				sec = "0" + i;
			} else {
				sec = i;
			}
			secHtml += '<option value="'+sec+'">' + sec + '</option>';
		}
		secHtml += '</select> <spring:message code="schedule.second" />';
		$("#sec").append(secHtml);
	}

	/* ********************************************************
	 * Storage 경로 선택 (기존/신규)
	 ******************************************************** */
	function fn_storage_path_set() {
		var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

		if (asis_flag == "0") {
			$("#storage_view").hide();
			fn_clean();
		} else {
			$("#storage_view").show();
			$("#restore_dir").val("");
		}
	}

	/* ********************************************************
	 * 신규 Storage 경로 확인
	 ******************************************************** */
	function fn_new_storage_check() {
		var new_storage = $("#restore_dir").val();
		
		$.ajax({
			async : false,
			url : "/existDirCheck.do",
		  	data : {
		  		db_svr_id : "${db_svr_id}",
		  		path : new_storage
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
			success : function(data) {
				if(data.result.ERR_CODE == ""){
					if(data.result.RESULT_DATA.IS_DIRECTORY == 0){
						alert('<spring:message code="message.msg100" />');
						$("#dtb_pth").val(new_storage + "${pgdata}");
						$("#svrlog_pth").val(new_storage + "${srvlog}");
					}else{
						alert('<spring:message code="backup_management.invalid_path"/>');
					}
				}else{
					alert('<spring:message code="message.msg76" />');
				}
			}
		});
	}

	/* ********************************************************
	 * 신규 Storage 초기화
	 ******************************************************** */
	function fn_clean() {
		$("#restore_dir").val("");
		$("#dtb_pth").val("${pgdata}");
		$("#svrlog_pth").val("${srvlog}");
	}
	
	/* ********************************************************
	 * RMAN Restore 시작 전 (select pg_switch_wal())
	 ******************************************************** */	
	function fn_pgWalFileSwitch(){
		$.ajax({
			url : "/pgWalFileSwitch.do",
			data : {
				db_svr_id : db_svr_id,
			},
			dataType : "json",
			type : "post",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if (xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : " + xhr.status + "\n\n"
							+ "ERROR Message : " + error + "\n\n"
							+ "Error Detail : "
							+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				if(result.RESULT_CODE ==0){
					fn_execute();
				} 
			}
		});		
	}
	
	/* ********************************************************
	 * RMAN Show 정보 확인
	 ******************************************************** */
	function fn_rmanShow() {

		var frmPop = document.frmPopup;
		var url = '/rmanShowView.do';
		window.open('', 'popupView', 'width=1500, height=800');

		frmPop.action = url;
		frmPop.target = 'popupView';
		frmPop.bck.value = rman_pth;
		frmPop.db_svr_id.value = db_svr_id;
		frmPop.submit();
	}

	/* ********************************************************
	 * Validation
	 ******************************************************** */
	function fn_Validation() {
		var restore_nm = document.getElementById('restore_nm');
		var restore_exp = document.getElementById('restore_exp');
		
		if (restore_nm.value == "" || restore_nm.value == "undefind" || restore_nm.value == null) {
			alert("복원명을 넣어주세요.");
			restore_nm.focus();
			return false;
		}else if(restore_nmChk =="fail"){
			alert('복원명 중복체크 바랍니다.');
			return false;
		}else if (restore_exp.value == "" || restore_exp.value == "undefind" || restore_exp.value == null) {
			alert("복원 설명을 넣어주세요.");
			restore_exp.focus();
			return false;
		}
		
		fn_passwordConfilm('rman');
	}	 
	 
	/* ********************************************************
	 * RMAN Restore 정보 저장
	 ******************************************************** */
	function fn_execute() {
		var timeline_dt = $("#datepicker1").val().replace(/-/gi, '').trim();
		var asis_flag = $(":input:radio[name=asis_flag]:checked").val();

		$.ajax({
			url : "/insertRmanRestore.do",
			data : {
				db_svr_id : db_svr_id,
				asis_flag : asis_flag,
				restore_dir : $("#restore_dir").val(),
				dtb_pth : $('#dtb_pth').val(),
				pgalog_pth : $('#pgalog_pth').val(),
				svrlog_pth : $('#svrlog_pth').val(),
				bck_pth : $('#bck_pth').val(),
				restore_cndt : 1,
				restore_flag : 1,
				timeline_dt : timeline_dt,
				timeline_h : $("#timeline_h").val(),
				timeline_m : $("#timeline_m").val(),
				timeline_s : $("#timeline_s").val(),
				restore_nm : $('#restore_nm').val(),
				restore_exp : $('#restore_exp').val()
			},
			dataType : "json",
			type : "post",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if (xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : " + xhr.status + "\n\n"
							+ "ERROR Message : " + error + "\n\n"
							+ "Error Detail : "
							+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				alert('<spring:message code="restore.msg223" />');
			}
		});
	}

	//복구명 중복체크
	function fn_check() {
		var restore_nm = document.getElementById("restore_nm");
		if (restore_nm.value == "") {
			alert('<spring:message code="message.msg107" />');
			document.getElementById('restore_nm').focus();
			return;
		}
		$.ajax({
			url : '/restore_nmCheck.do',
			type : 'post',
			data : {
				restore_nm : $("#restore_nm").val()
			},
			success : function(result) {
				if (result == "true") {
					alert('<spring:message code="restore.msg221" />');
					document.getElementById("restore_nm").focus();
					restore_nmChk = "success";
				} else {
					restore_nmChk = "fail";
					alert('<spring:message code="restore.msg222" />');
					document.getElementById("restore_nm").focus();
				}
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", true);
			},
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if (xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : " + xhr.status + "\n\n"
							+ "ERROR Message : " + error + "\n\n"
							+ "Error Detail : "
							+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			}
		});
	}
</script>

<form name="frmPopup">
	<input type="hidden" name="bck" id="bck"> <input type="hidden" name="db_svr_id" id="db_svr_id">
</form>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>
				<spring:message code="restore.Point-in-Time_Recovery" />
				<a href="#n"><img src="../images/ico_tit.png" class="btn_info" /></a>
			</h4>
			<div class="infobox">
				<ul>
					<li><spring:message code="help.Point-in-Time_Recovery" /></li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>Restore</li>
					<li class="on"><spring:message code="restore.Point-in-Time_Recovery" /></li>
				</ul>
			</div>
		</div>
		<div class="contents">
			<div class="btn_type_01">
				<span class="btn"><button type="button" id="btnSelect" onClick="fn_Validation();"><spring:message code="schedule.run" /></button></span>
			</div>
			<div class="sch_form">
				<table class="write">
					<colgroup>
						<col style="width: 140px;" />
						<col />
						<col style="width: 140px;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_name" /></th>
							<td><input type="text" class="txt t2" name="restore_nm" id="restore_nm" maxlength="20" onkeyup="fn_checkWord(this,20)" placeholder="20<spring:message code='message.msg188'/>" onblur="this.value=this.value.trim()" style="width:250px;"/> <span class="btn btnF_04 btnC_01">
								<button type="button" class="btn_type_02" onclick="fn_check()" style="width: 100px; margin-right: -60px; margin-top: 0;"> <spring:message code="common.overlap_check" /></button></span></td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_Description" /></th>
							<td colspan="3">
								<div class="textarea_grp">
									<textarea name="restore_exp" id="restore_exp" maxlength="150" onkeyup="fn_checkWord(this,150)" placeholder="150<spring:message code='message.msg188'/>"></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row" class="ico_t1"><spring:message code="data_transfer.server_name" /></th>
							<td><input type="text" class="txt" name="db_svr_nm" id="db_svr_nm" readonly="readonly" value="${db_svr_nm}" style="width:250px;">
							</td>		
							<th scope="row" class="ico_t1"><spring:message code="restore.Server_IP" /></th>
							<td><input type="text" class="txt" name="ipadr" id="ipadr" readonly="readonly" value="${ipadr}" style="width:250px;"></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="restore_grp">
				<div class="restore_lt">
					<table class="write">
						<colgroup>
							<col style="width: 120px;" />
							<col style="width: 65px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Storage <spring:message code="common.path" /></th>
								<td><input type="radio" name="asis_flag" id="storage_path_org" value="0" onClick="fn_storage_path_set();" checked> <spring:message code="restore.existing" /></td>
								<td><input type="radio" name="asis_flag" id="storage_path_new" value="1" onClick="fn_storage_path_set();"> <spring:message code="restore.new" /></td>
							</tr>
						</tbody>
					</table>

					<table class="write" id="storage_view">
						<colgroup>
							<col style="width: 80px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="restore.Recovery_Path" /></th>
								<td><input type="text" class="txt" name="restore_dir" id="restore_dir" style="width: 70%" /> <span class="btn btnC_01"><button type="button" class="btn_type_02" onclick="fn_new_storage_check()" style="width: 50px; margin-top: 0;"> <spring:message code="common.dir_check" />
								</button></span> <span class="btn btnC_01"><button type="button" class="btn_type_02" onclick="fn_clean()" style="width: 50px; margin-top: 0;">초기화</button></span></td>
							</tr>
						</tbody>
					</table>


					<table class="write" style="border: 1px solid #b8c3c6; margin-top: 20px; border-collapse: separate;">
						<colgroup>
							<col style="width: 150px;" />
							<col />
							<col style="width: 70px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t1"><spring:message code="restore.Select_viewpoint" /></th>
								<td><button type="button" class="btn_type_02" onclick="fn_rmanShow();" style="width: 100px; height: 25px; margin-right: -60px; margin-top: 0;">
									<spring:message code="restore.Recovery_Information" /></button></td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">
									<span id="calendar">
										<div class="calendar_area">
											<a href="#n" class="calendar_btn">달력열기</a> <input type="text" class="calendar" id="datepicker1" name="timeline_dt" title="스케줄시간설정" readonly />
										</div>
									</span>
								</td>
								<td style="display: inline-block; white-space: nowrap;"><span id="hour"></span> <span id="min"></span> <span id="sec"></span></td>
							</tr>
						</tbody>
					</table>

					<table class="write" style="margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Database Storage</th>
							</tr>
							<tr>
								<td><input type="text" class="txt t4" name="dtb_pth" id="dtb_pth" readonly="readonly" value="${pgdata}" />
							</tr>
						</tbody>
					</table>

					<table class="write" style="margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Archive WAL Storage</th>
							</tr>
							<tr>
								<td><input type="text" class="txt t4" name="pgalog_pth" id="pgalog_pth" readonly="readonly" value="${pgalog}" />
							</tr>
						</tbody>
					</table>

					<table class="write" style="margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Server Log Storage</th>
							</tr>
							<tr>
								<td><input type="text" class="txt t4" name="svrlog_pth" id="svrlog_pth" readonly="readonly" value="${srvlog}" />
							</tr>
						</tbody>
					</table>

					<table class="write" style="margin-top: 20px;">
						<tbody>
							<tr>
								<th scope="row" class="ico_t1">Backup Storage</th>
							</tr>
							<tr>
								<td><input type="text" class="txt t4" name="bck_pth" id="bck_pth" readonly="readonly" value="${pgrbak}" />
							</tr>
						</tbody>
					</table>		
				</div>

				<div class="restore_rt">
					<p class="ly_tit">
						<h8>Restore <spring:message code="restore.Execution_log" /></h8>
					</p>
					<div class="overflow_area4" name="exelog" id="exelog"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
