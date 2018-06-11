<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/cs.jsp"%>
<%
	/**
	* @Class Name : scriptHistory.jsp
	* @Description : Log List 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.07     최초 생성
	*
	* author 변승우
	* since 2017.06.07
	*
	*/
%>
<script type="text/javascript">
var table = null;


/* ********************************************************
 * Data initialization
 ******************************************************** */
$(window.document).ready(function() {
	fn_init();
});

/* ********************************************************
 * Rman Data Table initialization
 ******************************************************** */
function fn_init(){
   	table = $('#scriptHistory').DataTable({	
		scrollY: "405px",
		searching : false,
		scrollX: true,
		bSort: false,
	    columns : [
		         	{ data: "rownum", className: "dt-center", defaultContent: ""}, 
		         	{data : "wrk_nm", className : "dt-left", defaultContent : ""
		    			,"render": function (data, type, full) {				
		    				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold">' + full.wrk_nm + '</span>';
		    			}
		    		},
		    		{ data : "wrk_exp",
		    			render : function(data, type, full, meta) {	 	
		    				var html = '';					
		    				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
		    				return html;
		    			},
		    			defaultContent : ""
		    		}
 		        ]
	});
   	
   	table.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
   	table.tables().header().to$().find('th:eq(1)').css('min-width', '150px');
   	table.tables().header().to$().find('th:eq(2)').css('min-width', '150px');

    $(window).trigger('resize'); 
}




</script>

<!-- contents -->
<div id="contents">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4>스크립트이력<a href="#n"><img src="/images/ico_tit.png" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li>스크립트관리</li>
					<li>스크립트이력</li>
				</ul>
			</div>
			<div class="location">
				<ul>
					<li class="bold">${db_svr_nm}</li>
					<li>스크립트관리</li>
					<li class="on">스크립트이력</li>
				</ul>
			</div>
		</div>
	
		<div class="contents">
			<div class="cmm_grp">
				<div class="btn_type_01">
					<span class="btn"><button id="btnSelect"><spring:message code="common.search" /></button></span>
				</div>
				<div class="sch_form">
				<form name="findList" id="findList" method="post">
				<input type="hidden" name="db_svr_id" id="db_svr_id" value="${db_svr_id}"/> 
					<table class="write">
						<caption>검색 조회</caption>
						<colgroup>
							<col style="width:90px;" />
							<col style="width:230px;" />
							<col style="width:110px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="t10"><spring:message code="common.work_term" /></th>
								<td colspan="3">
									<div class="calendar_area">
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_strt_dtm" id="wrk_strt_dtm" class="calendar" readonly/>
										<span class="wave">~</span>
										<a href="#n" class="calendar_btn">달력열기</a>
										<input type="text" name="wrk_end_dtm" id="wrk_end_dtm" class="calendar" readonly/>
									</div>
								</td>
							</tr>
							<tr style="height:35px;">
								<th scope="row" class="t9"><spring:message code="common.status" /></th>
								<td>
									<select name="exe_rslt_cd" id="exe_rslt_cd" class="select t5">
										<option value=""><spring:message code="schedule.total" /></option>
										<option value="TC001701"><spring:message code="common.success" /></option>
										<option value="TC001702"><spring:message code="common.failed" /></option>
									</select>
								</td>						
							</tr>
							<tr>
								<th scope="row" class="t9"><spring:message code="common.work_name" /></th>
								<td><input type="text" name="wrk_nm" id="wrk_nm" class="txt t5" maxlength="25"  /></td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
								
					<table class="display" id="scriptHistory" cellspacing="0" width="100%">
						<caption>스크립트 이력화면 리스트</caption>
						<thead>
							<tr>
								<th width="100"><spring:message code="common.no" /></th>
								<th width="100"><spring:message code="common.work_name" /></th>
								<th width="100"><spring:message code="common.work_description" /></th>
							</tr>
						</thead>
					</table>
							
			</div>
		</div>
	</div>
</div><!-- // contents -->
