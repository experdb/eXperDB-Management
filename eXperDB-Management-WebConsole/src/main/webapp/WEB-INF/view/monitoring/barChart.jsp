<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    google.charts.load("current", {packages:["corechart"]});
    google.charts.setOnLoadCallback(drawChart);
    
    function drawChart() {
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
      var chart = new google.visualization.BarChart(document.getElementById("barchart_values"));
      chart.draw(view, options);
  }
    
    
    function getValueAt(column, dataTable, row) {
        return dataTable.getFormattedValue(row, column);
      }
  </script>
  
</head>
<body>
	<table>
		<tr>
			<td><div id="barchart_values"></div></td>
			<td></td>
		</tr>
	</table>
</body>
</html>