<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>sampleRowsShuffle</title>
 <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/jquery-ui.css'/>"/>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/jquery.treeview.css'/>"/>
<link rel="stylesheet" href="<c:url value='/css/treeview/screen.css'/>"/>

<script src="js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="js/jquery/jquery-ui.js" type="text/javascript"></script>

<script src="js/json2.js" type="text/javascript"></script>
<script src="js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<!-- <script src="js/treeview/jquery.js" type="text/javascript"></script> -->
<script src="js/treeview/jquery.cookie.js" type="text/javascript"></script>
<script src="js/treeview/jquery.treeview.js" type="text/javascript"></script> 

</head>
<style>
a.dtMoveUp, a.dtMoveDown {
  margin-right:5px;
  text-decoration: underline;
  cursor:pointer;
}
</style>
<script>
function fncCycleSeChange()
{
    var strCycleSe = document.getElementById("executCycle").value;
    
    var divB = document.getElementById("divCycleB");
    var divC = document.getElementById("divCycleC");
    var divD = document.getElementById("divCycleD");
    var divE = document.getElementById("divCycleE");
    
    divB.style.display = "none";
    divC.style.display = "none";
    divD.style.display = "none";
    divE.style.display = "none";
    
    if (strCycleSe == "B")
    {
        divB.style.display = "block";
    }
    else if (strCycleSe == "C")
    {
        divC.style.display = "block";
    }
    else if (strCycleSe == "D")
    {
        divC.style.display = "block";
        divD.style.display = "block";
    }
    else if (strCycleSe == "E")
    {
        divE.style.display = "block";
    }
}

function fncMonthChange()
{
    var strMonth = document.getElementById("executSchdulMonth").value;
    var objDaySel = document.getElementById("executSchdulDay");
    
    if (strMonth == "02")
    {
        objDaySel.options[30] = null;
        objDaySel.options[29] = null;
        objDaySel.options[28] = null;
    }
    else if (strMonth == "04" || strMonth == "06" || strMonth == "09" || strMonth == "11")
    {
        objDaySel.options[30] = null;
        objDaySel.options[29] = null;
        objDaySel.options[28] = null;
        
        objDaySel.options.add(new Option("29", "29"), 28);
        objDaySel.options.add(new Option("30", "30"), 29);
    }
    else
    {
        objDaySel.options[30] = null;
        objDaySel.options[29] = null;
        objDaySel.options[28] = null;
        
        objDaySel.options.add(new Option("29", "29"), 28);
        objDaySel.options.add(new Option("30", "30"), 29);
        objDaySel.options.add(new Option("31", "31"), 30);
    }
}

$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
});

$(function() {
	  $( "#datepicker" ).datepicker({
	    dateFormat: 'yy/mm/dd'
	  });
	});
	
var table = null;

function fn_init(){
   	table = $('#example').DataTable({	
		scrollY: "350px",	
		"processing": true,
// 		"paging": false,
	    columns : [
		         	{data: "rownum", className: "dt-center", defaultContent: ""}, 
 		         	{ data: "category_id", className: "dt-center", defaultContent: "",sortable: false},
 		         	{ data: "category_nm", className: "dt-center", defaultContent: "",sortable: false}, 
 		         	{ data: "use_yn", className: "dt-center", defaultContent: "",sortable: false}, 
 		         	{ data: "contents", className: "dt-center", defaultContent: "",sortable: false}, 
 		         	{ data: "reg_nm", className: "dt-center", defaultContent: "",sortable: false},
 					{
 		         		className: "dt-center",
 						data: null,
 						title: '실행순서',
 						searchable: false,
 						sortable: false,					
 						render: function (data, type, full, meta,row) {
 							if (type === 'display') {
 								var $span = $('<span></span>');
 								$('<a class="dtMoveUp"><i class="fa fa-arrow-circle-up" style="color:red;"></i></a>').appendTo($span);
 								$('<a class="dtMoveDown"><i class="fa fa-arrow-circle-down" style="color:blue;"></i></a>').appendTo($span); 																												
 								return $span.html();
 							}
 							return data;
 						}
 					}
 		        ],
 				'drawCallback': function (settings) {
 					// Remove previous binding before adding it
 					$('.dtMoveUp').unbind('click');
 					$('.dtMoveDown').unbind('click');
 					// Bind clicks to functions
 					$('.dtMoveUp').click(moveUp);
 					$('.dtMoveDown').click(moveDown);
 				}
	});
	// Move the row up
	function moveUp() {
		var tr = $(this).parents('tr');
		moveRow(tr, 'up');
	}

	// Move the row down
	function moveDown() {
		var tr = $(this).parents('tr');
		moveRow(tr, 'down');
	}

  // Move up or down (depending...)
  function moveRow(row, direction) {
    var index = table.row(row).index();
    var rownum = -1;
    if (direction === 'down') {
    	rownum = 1;
    }

    var data1 = table.row(index).data();
    data1.rownum += rownum;

    var data2 = table.row(index + rownum).data();
    data2.rownum += -rownum;

    table.row(index).data(data2);
    table.row(index + rownum).data(data1);
    table.draw(false);
	}
}


$(window.document).ready(
		function() {
			fn_init();
			
			$.ajax({
				url : "/selectSampleDatatableList.do",
			  	data : {},
				dataType : "json",
				type : "post",
				error : function(xhr, status, error) {
					alert("실패")
				},
				success : function(result) {
					table.clear().draw();
					table.rows.add(result).draw();
				}
			});
			
		});
</script>
<body>

			<div id="contents">
				<div class="contents_wrap">
	<h1>스케줄시간 , 테이블 셔플</h1>

	<h3>*스케줄시간설정</h3>
	<form id="parameter" name="parameter" method="post" action="">
	 <div class="bbsDetail">
            <table summary="배치I.D., Job이름(배치명), 스케줄명, 실행주기, 파라미터 순서로 나타낸 스케줄 등록 데이터 표입니다." id="detailTable">
            <tbody>
                <tr>
                    <th style="border-right:0px">실행주기</th>
                    <th></th>
                    <td>
                        <div id="divCycleSe" style="float:left">
                            <select id="executCycle" name="executCycle" onchange="fncCycleSeChange()" title="실행주기 선택">
                                <option value="A" selected="selected">매일</option>
                                <option value="B">매주</option>
                                <option value="C">매월</option>
                                <option value="D">매년</option>
                                <option value="E">1회실행</option>
                            </select>
                            <input type='hidden' name='executSchdulDe' id='executSchdulDe'>
                        </div>
                        <div id="divCycleE" style="display:none;float:left">
                        	<!-- 달력 들어오기! -->
                        	<input type="text" id="datepicker">
                        </div>
                        <div id="divCycleB" style="display:none;float:left">
                            <input type="checkbox" id="sun" name="executSchdulWeek" value="0">일요일
                            <input type="checkbox" id="mon" name="executSchdulWeek" value="1">월요일
                            <input type="checkbox" id="tue" name="executSchdulWeek" value="2">화요일
                            <input type="checkbox" id="wed" name="executSchdulWeek" value="3">수요일
                            <input type="checkbox" id="thu" name="executSchdulWeek" value="4">목요일
                            <input type="checkbox" id="fri" name="executSchdulWeek" value="5">금요일
                            <input type="checkbox" id="sat" name="executSchdulWeek" value="6">토요일
                        </div>
                        <div id="divCycleD" style="display:none;float:left">
                            <select id="executSchdulMonth" onchange="fncMonthChange()">
                              <c:forEach var="i" begin="1" end="12" step="1">
                                <c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
                                <c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
                              </c:forEach>
                            </select>월
                        </div>
                        <div id="divCycleC" style="display:none;float:left">
                            <select id="executSchdulDay">
                              <c:forEach var="i" begin="1" end="31" step="1">
                                <c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
                                <c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
                              </c:forEach>
                            </select>일
                        </div>
                        <div id="divCycleA" style="display:block;float:left">
                            <select id="executSchdulHour" name="executSchdulHour">
                              <c:forEach var="i" begin="0" end="23" step="1">
                                <c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
                                <c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
                              </c:forEach>
                            </select>시
                            <select id="executSchdulMnt" name="executSchdulMnt">
                              <c:forEach var="i" begin="0" end="59" step="1">
                                <c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
                                <c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
                              </c:forEach>
                            </select>분
                            <select id="executSchdulSecnd" name="executSchdulSecnd">
                              <c:forEach var="i" begin="0" end="59" step="1">
                                <c:if test="${i < 10}"><option value="0${i}">0${i}</option></c:if>
                                <c:if test="${i >= 10}"><option value="${i}">${i}</option></c:if>
                              </c:forEach>
                            </select>초
                        </div>
                    </td>
                </tr>
            </tbody>
            </table>
        </div>
	</form>
	<h3>*work 등록</h3>
	<table id="example" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>No</th>
                <th>카테고리ID</th>
                <th>카테고리명</th>
                <th>사용여부</th>
                <th>내용</th>
                <th>등록자</th>
                <th>실행순서</th>
            </tr>
        </thead>
    </table>
    </div>
    </div>
</body>
</html>