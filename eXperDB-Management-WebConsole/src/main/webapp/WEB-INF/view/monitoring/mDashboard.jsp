<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eXperDB Monitoring</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type="text/css" media="screen" href="/css/dt/jquery.dataTables.min.css"/>
<link rel = "stylesheet" type="text/css" media="screen" href="/css/dt/dataTables.jqueryui.min.css"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</head>

<style>
select {
  width: 803px;
  padding: .9em .5em;
  font-family: inherit;
  background: url(https://farm1.staticflickr.com/379/19928272501_4ef877c265_t.jpg) no-repeat 95% 50%;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  border: 3px solid #999;
  border-radius: 15px;
}

select::-ms-expand {
  /* for IE 11 */
  display: none;
}

.previewForm {height: 400px; }
</style>

<script>
//var chart = null;
google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawSteppedAreaChart);
google.charts.setOnLoadCallback(drawDonutChart);
google.charts.setOnLoadCallback(drawBarChart);


$(window.document).ready(function() {    
    $( "#preview" ).hide();
});


	function fn_veiwChoice(){
		toggleLayer($('#pop_layer'), 'on');
	}


    // run the currently selected effect
    function preview() {

    $( "#preview" ).hide();	
    
      // get effect type from
      var selectedGraph = "fade";

      // Most effect types need no options passed by default
      var options = {};

      // some effects have required parameters
      if ( selectedGraph === "scale" ) {
        options = { percent: 50 };
      } else if ( selectedGraph === "size" ) {
        options = { to: { width: 280, height: 185 } };
      }

      // Run the effect      
      if($("#graphTypes").val() == "bar"){
    	  drawBarChart();
      }else if($("#graphTypes").val() == "steppedArea"){
    	  drawSteppedAreaChart();
      }else if($("#graphTypes").val() == "donut"){
    	  drawDonutChart();
      }
        
      $( "#preview" ).show( selectedGraph, options, 500, callback );
    };

 

    //callback function to bring a hidden box back
    function callback() {
      setTimeout(function() {
        $( "#graph:visible" ).removeAttr( "style" ).fadeOut();
      }, 1000 );
    };
    
    
    function drawBarChart() {
        var data = google.visualization.arrayToDataTable([
         //[명칭, 수치, 색상]                                                 
          ["Element", "Percentage", { role: "style" } ],
          ["k4mdb", 8.94, "#b87333"],
          ["da21", 10.49, "silver"],
          ["da41", 19.30, "gold"],
          ["pidsvr", 21.45, "color: #e5e4e2"],
          ["da43", 21.45, "red"]
        ]);

        var view = new google.visualization.DataView(data);
        view.setColumns([0, 1,
                         { 
      	  				//calc: "stringify",
                          calc: getValueAt.bind(undefined, 1), 
      	  				sourceColumn: 1,
                           type: "string",
                           role: "annotation" 
                          },
                         2]);

        var options = {
          title: "CPU",
          width: 600,
          height: 400,
          bar: {groupWidth: "95%"},
          legend: { position: "none" },
          
        };
       var chart = new google.visualization.BarChart(document.getElementById("chart"));
       chart.draw(view, options);
    }
    
    
    
    function drawDonutChart() {
        var data = google.visualization.arrayToDataTable([
		  ['Effort', 'Amount given'],  // %형식으로  사용
        //  ['Task', 'Hours per Day'],  24시간을 기준으로 사용
          ['Work',     11],
          ['Eat',      2],
          ['Commute',  2],
          ['Watch TV', 2],
          ['Sleep',    7]
        ]);

        var options = {
          width: 650,
          height: 400,
          title: 'CPU',
          pieHole: 0.4,
         // is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('chart'));
        chart.draw(data, options);
      }
    
    
    
    function drawSteppedAreaChart() {
        var data = google.visualization.arrayToDataTable([
          ['Director (Year)',  'Rotten ', 'IMDB'],
          ['Alfred Hitchcock (1935)', 8.4,         7.9],
          ['Ralph Thomas (1959)',     6.9,         6.5],
          ['Don Sharp (1978)',        6.5,         6.4],
          ['James Hawes (2008)',      4.4,         6.2]
        ]);

        /* var options = {
          title: 'The decline of \'The 39 Steps\'',
          vAxis: {title: 'Accumulated Rating'},
          isStacked: true
        }; */

        var options_stacked = {
                isStacked: true,
                height: 400,
                width: 800,
                legend: {position: 'top', maxLines: 3},
                vAxis: {minValue: 0}
              };
        
        var chart = new google.visualization.SteppedAreaChart(document.getElementById('chart'));

        chart.draw(data, options_stacked);
       
      }
    
    function getValueAt(column, dataTable, row) {
        return dataTable.getFormattedValue(row, column);
      }
    
    
    
   function fn_chartAdd(){
	   
   }

</script>


<body>
<input type="hidden" id="chartNm" name="chartNm" />
	<!--  popup -->
	<div id="pop_layer" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width:730px;">
				<p class="tit">Monitoring View Choice</p>
				
				<select name="graph" id="graphTypes" onChange="preview();">
				 <option value="choice">선택</option>
				  <option value="bar">Bar Charts</option>
				  <option value="steppedArea">SteppedArea Chart</option>
				  <option value="donut">Donut Chart</option>
				</select>
				
				
				<div class="previewForm" style="margin-top: 10px;">
				  <div id="preview" class="ui-widget-content ui-corner-all">
				    <h3 class="ui-widget-header ui-corner-all">그래프 미리보기</h3>
				    <p>			    	
				    	<div id=chart></div>
				    </p>
				  </div>
				</div>


			  
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="fn_chartAdd();"><span><spring:message code="common.add" /></span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer'), 'off');"><span><spring:message code="common.cancel" /></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>


<span onclick="fn_veiwChoice();" style="cursor:pointer">모니터링 데시보드</span>

<div id=chart></div>


</body>
</html>