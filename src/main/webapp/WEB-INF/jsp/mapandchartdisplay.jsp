<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
	<title>INTERACTIVE MAPS</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.bundle.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/utils.js"></script> 
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/common.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.0.3/dist/leaflet.css" integrity="sha512-07I2e+7D8p6he1SIM+1twR5TIrhUQn9+I6yjqD53JQjFiMf8EtC93ty0/5vJTZGF8aAocvHYNEDJajGdNx1IsQ==" crossorigin=""/>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.0.3/dist/leaflet.js" integrity="sha512-A7vV8IFfih/D732iSSKi20u/ooOfj/AGehOKq0f4vLT1Zr2Y+RX7C+w8A1gaSasGtRUZpF/NZgzSAu4/Gc41Lg==" crossorigin=""></script>
    
    <style>
		#map {
			width: 600px;
			height: 400px;
		}
	</style>

	<style>
	   #map { width: 800px; height: 500px; }
       .info { padding: 6px 8px; font: 14px/16px Arial, Helvetica, sans-serif; background: white; background: rgba(255,255,255,0.8); box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; } .info h4 { margin: 0 0 5px; color: #777; }
       .legend { text-align: left; line-height: 18px; color: #555; } 
       .legend i { width: 18px; height: 18px; float: left; margin-right: 8px; opacity: 0.7; }
    </style>
</head> 

<body>

<div class="HypothesisScreen">   

	<table>

	<tr>
		<td><label for="yearLookUpId">Optional Year : </label> </td>
		<td>
		<select id="yearLookUpId" name="yearLookUpId">
			<option value="">Select</option>
			<c:forEach items="${yearLookups}" var="yearLookUp">
			<option value="${yearLookUp.id}" ${yearLookUp.id == yearLookUpId ? 'selected="selected"' : ''}>${yearLookUp.yearName}</option>
			</c:forEach>
		</select>
		</td>
	</tr>

	<tr>
		<td><label for="reportingOptionLookupId">Reporting Option : </label> </td>
		<td>
		<select id="reportingOptionLookupId" name="reportingOptionLookupId">
			<option value="">Select</option>
			<c:forEach items="${reportingOptionLookups}" var="reportingOptionLookup">
			<option value="${reportingOptionLookup.id}" ${reportingOptionLookup.id == reportingOptionLookupId ? 'selected="selected"' : ''}>${reportingOptionLookup.reportingOptionName}</option>
			</c:forEach>
		</select>
		</td>
	</tr>
	
	<tr>
		<td><label for="parameterLookupId">Parameter Name : </label> </td>
		<td>
		<select id="parameterLookupId" name="parameterLookupId">
			<option value="">Select</option>
			<c:forEach items="${parameterLookups}" var="parameterLookup">
			<option value="${parameterLookup.id}" ${parameterLookup.id == parameterLookupId ? 'selected="selected"' : ''}>${parameterLookup.parameterName}</option>
			</c:forEach>
		</select>
		</td>
	</tr>

	<tr>
		<td><label for="reportTypeId">Report Type :</label> </td>
		<td>
		<select id="reportTypeId" name="reportTypeId">
			<option value="">Select</option>
			<c:forEach items="${reportTypes}" var="reportType">
				<option value="${reportType}">${reportType}</option>
			</c:forEach>
		</select>
		</td>
	</tr>
	
	<tr id="yesOrNoOptionRow" hidden="true">
		<td><label for="yesOrNoOptionId">Yes/No Option :</label> </td>
		<td>
		<select id="yesOrNoOptionId" name="yesOrNoOptionId">
			<option value="">Select</option>
			<option value="0">No</option>
			<option value="1">Yes</option>
		</select>
		</td>
	</tr>

	<tr>
		<td></td>
		<td>
		<input type="submit" id="displayreport" />
		</td>
	</tr>

	</table>

</div>

    <iframe id='mapIframe' hidden="true" frameborder="0" scrolling="no" width="100%" height="5000" ></iframe>

	<div id ="messageDisplay"></div>
	
    <div id="chart-container" style="width: 75%;">
        <canvas id="chart-canvas"></canvas>
    </div>
   
    
    
<script>
	var btn = document.getElementById("displayreport");
	var barChartData =null;
	var lineChartData =null;
	var serverContextPath = '${pageContext.request.contextPath}';
	
	btn.addEventListener("click", function(){
		
		var yesOrNoOptionId = $("#yesOrNoOptionId option:selected").text();
	    var reportTypeSelectedVal = $("#reportTypeId option:selected").text();
	    var yearLookUpSelectedVal = $("#yearLookUpId option:selected").text();
	    var reportingOptionLookupSelectedVal = $("#reportingOptionLookupId option:selected").text();
	    var parameterLookupSelectedVal = $("#parameterLookupId option:selected").text();
	    
	    if (reportTypeSelectedVal == "Bar Chart"){
	    	var url = 'http://localhost:8080'+serverContextPath+'/barChart/dataanalysis/${dataanalysis}/subdataanalysis/${subdataanalysis}/year/'+yearLookUpSelectedVal+'/reportingOption/'+reportingOptionLookupSelectedVal;
	    } 
	    if (reportTypeSelectedVal == "Line Chart"){
	    	var url = 'http://localhost:8080'+serverContextPath+'/lineChart/dataanalysis/${dataanalysis}/subdataanalysis/${subdataanalysis}/parameter/'+parameterLookupSelectedVal;
	    } 
	    if (reportTypeSelectedVal == "Map"){
	    	document.getElementById("mapIframe").hidden = false;
	    	var epGpro = '0';
	    	if(reportingOptionLookupSelectedVal == "CLAIMS" || reportingOptionLookupSelectedVal == "EHR" 
	    			|| reportingOptionLookupSelectedVal == "REGISTRY"
	    			|| reportingOptionLookupSelectedVal == "QCDR") {
	    		epGpro = '1';
	    	}else if(reportingOptionLookupSelectedVal == "GPROWI" || reportingOptionLookupSelectedVal == "GPRO Registry" 
	    			|| reportingOptionLookupSelectedVal == "GPRO EHR"
	    			|| reportingOptionLookupSelectedVal == "GPRO WI GROP") {
	    		epGpro = '2';
	    	}
	    	var ruralUrbanId = document.getElementById("parameterLookupId").value;
	    	var yesNoId = document.getElementById("yesOrNoOptionId").value;
	    	var yearId = document.getElementById("yearLookUpId").value;
	    	var reportingOptionId = document.getElementById("reportingOptionLookupId").value;
	    	var url = 'http://localhost:8080'+serverContextPath+'/maps/epOrGpro/'+ epGpro+'/ruralOrUrban/'+ ruralUrbanId +'/yesOrNoOption/'+ yesNoId +'/yearId/'+ yearId +'/reportingOptionId/'+ reportingOptionId;
 	        document.getElementById("mapIframe").src=url;
	    } 
		
	    var ourRequest = new XMLHttpRequest();
	    ourRequest.open('GET', url);
	    ourRequest.onload = function(){
		    if (reportTypeSelectedVal == "Bar Chart")
		    {
		    	barChartData = JSON.parse(ourRequest.responseText);
		        //console.log(barChartData);
		        var barChartDataAvail = barChartData.dataAvailable;
		        var yesCountValues = barChartData.yesCountValues;
		        var noCountValues = barChartData.noCountValues;
		        
		    	<!-- BAR CHART :: JAVA SCRIPT ###### START  -->
		    	var barChartData = {
		                labels: barChartData.parameters,
		                datasets: [{
		                    label: 'YES',
		    				backgroundColor: "rgba(0,0,128,.5)",
		    				borderColor: "rgba(0,0,128,.5)",
		                    borderWidth: 1,
		                    data: barChartData.yesPercents
		                }, {
		                    label: 'NO',
		    				backgroundColor: "rgba(255,0,0,.7)",
		    				borderColor: "rgba(255,0,0,.7)",
		                    borderWidth: 1,
		                    data: barChartData.noPercents
		                }]

		            };
		            
		            var optionsInfo = {
		                    responsive: true,
		                    title:{
		                        display:true,
		                        text:'Base Year(2012) to Option Year 3(2015) REGISTRY Reporting Option Eligible Professionals Summary'
		                    },
	    				    animation: {
  	    				      duration: 1,
  	    				      onComplete: function() {
  	    				        var chartInstance = this.chart,
  	    				        ctx = chartInstance.ctx;

  	    				        ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
  	    				        ctx.textAlign = 'center';
  	    				        ctx.textBaseline = 'bottom';

  	    				        this.data.datasets.forEach(function(dataset, i) {
  	    				          var meta = chartInstance.controller.getDatasetMeta(i);
  	    				          meta.data.forEach(function(bar, index) { 
	  	    				          //console.log(bar._view.datasetLabel);
	  	    				          var data = yesCountValues[index];
 	  	    				          if(bar._view.datasetLabel == "NO"){
	  	    				        	data = noCountValues[index];
	  	    				          }
  	    				          
  	    				              ctx.fillText(data, bar._model.x, bar._model.y - 5);
  	    				          });
  	    				        });
  	    				      }
  	    				    },
		                    legend: {
		                        position: 'bottom',
		                    },
		                    tooltips: {
		                        mode: 'index',
		                        intersect: true,
		                    },
		                    
		                    hover: {
		                        mode: 'nearest',
		                        intersect: true,
		                    },
		                    scales: {
		                        xAxes: [{
		                            display: true,
		                            scaleLabel: {
		                                display: true,
		                                labelString: 'PARAMETER'
		                            },
		    	                    ticks: {
		    	                        display: true,
		    	                        beginAtZero:true
		    	                    }
		                        }],
		                        yAxes: [{
		                            display: true,
		                            scaleLabel: {
		                                display: true,
		                                labelString: 'PERCENT'
		                            },
		    	                    ticks: {
		    	                    	callback: function(label, index, labels) {
		    	                    		return label + ' %';
		    	                    	},
		    	                        display: true,
		    	                        beginAtZero:true
		    	                    }
		                        }]
		                    }
		            }

		            var barconfig = {
		            	type: 'bar',
		            	data: barChartData,
		                options: optionsInfo
		            };
		        <!-- BAR CHART :: JAVA SCRIPT ###### END  -->
		        
		    } <!-- Bar Chart If Logic Ends-->
		    
		    if (reportTypeSelectedVal == "Line Chart")
		    {
		    	lineChartData = JSON.parse(ourRequest.responseText);
		        //console.log(lineChartData);
		        
		        <!-- LINE CHART :: JAVA SCRIPT ###### START  -->
		        var lineChartDataAvail = lineChartData.dataAvailable;
		        var titletext = 'Base Year to Option Year 3 ' + 'Mental Health HPSA' + ' Percentage Summary'
		    	var yaxeslabelstring = 'Percent of EPs & GPROs in ' +'Mental Health HPSA'
		    
		        var lineconfig = {
		            type: 'line',
		            data: {
		                labels: lineChartData.uniqueYears,
		                datasets: [{
		                    label: "CLAIMS",
		                    fill: false,
		                    backgroundColor: window.chartColors.red,
		                    borderColor: window.chartColors.red,
		                    data: lineChartData.claimsPercents,
		                }, {
		                    label: "EHR",
		                    fill: false,
		                    backgroundColor: window.chartColors.green,
		                    borderColor: window.chartColors.green,
		                    data: lineChartData.ehrPercents,
		                }, {
		                    label: "Registry",
		                    fill: false,
		                    backgroundColor: window.chartColors.orange,
		                    borderColor: window.chartColors.orange,
		                    data: lineChartData.registryPercents,
		                }, {
		                    label: "GPROWI",
		                    fill: false,
		                    backgroundColor: window.chartColors.purple,
		                    borderColor: window.chartColors.purple,
		                    data: lineChartData.gprowiPercents,
		                }, {
		                    label: "QCDR",
		                    fill: false,
		                    backgroundColor: window.chartColors.brown,
		                    borderColor: window.chartColors.brown,
		                    data: lineChartData.qcdrPercents,
		                }]
		            },
		            options: {
		                responsive: true,
		                title:{
		                    display:true,
		                    text: titletext
		                },
		                legend: {
		                    position: 'bottom',
		                },
		                tooltips: {
		                    mode: 'index',
		                    intersect: false,
		                },
		                hover: {
		                    mode: 'nearest',
		                    intersect: true
		                },
		                scales: {
		                    xAxes: [{
		                        display: true,
		                        scaleLabel: {
		                            display: true,
		                            labelString: 'YEAR'
		                        }
		                    }],
		                    yAxes: [{
		                        display: true,
		                        scaleLabel: {
		                            display: true,
		                            labelString: yaxeslabelstring
		                        },
			                    ticks: {
			                    	callback: function(label, index, labels) {
			                    		return label + ' %';
			                    	},
			                        display: true
			                    }
		                    }]
		                }
		            }
		        };
		        <!-- LINE CHART :: JAVA SCRIPT ###### END  -->
		        
		    } <!-- Line Chart If Logic Ends-->
	        if(reportTypeSelectedVal == "Map") {
	        	<!-- TODO for Map-->
	        }
	        <!-- MAP ENDS -->
	        
	        <!-- Deleting the <canvas> element and then reappending a new <canvas> to the parent container: To Fix the Hover Over Issue   -->
	        resetCanvas();
	        
	        
	        var chartctx = document.getElementById("chart-canvas").getContext("2d");
            
            <!-- Different Chart Display :: START -->
    	    if (reportTypeSelectedVal == "Bar Chart"){
    	    	document.getElementById("mapIframe").hidden = true;
    	    	if (barChartDataAvail == "YES") {
    	    		document.getElementById('messageDisplay').style.display = 'none';
    	    		var myBarChart = new Chart(chartctx, barconfig);
    	    	}
    	    	if (barChartDataAvail == "NO") {
    	    		document.getElementById("messageDisplay").innerHTML = "No Data Available For The Selected Options!";
    	    	}
    	    } 
    	    if (reportTypeSelectedVal == "Line Chart"){
    	    	document.getElementById("mapIframe").hidden = true;
    	    	if (lineChartDataAvail == "YES") {
    	    		document.getElementById('messageDisplay').style.display = 'none';
    	    		var myLineChart = new Chart(chartctx, lineconfig);
    	    	}
    	    	if (lineChartDataAvail == "NO") {
    	    		document.getElementById("messageDisplay").innerHTML = "No Data Available For The Selected Options!";
    	    	}
    	    } 
    	    if (reportTypeSelectedVal == "Map"){
    	    	<!-- TODO for Map-->
    	    } 
            <!-- Different Chart Display :: END -->
	        
	    };
	    
	    ourRequest.send();
	
	});
	
	
 	var resetCanvas = function(){
		$('#chart-canvas').remove(); // this is my <canvas> element
		$('#chart-container').append('<canvas id="chart-canvas"><canvas>');
	};  
	
	document.getElementById("reportTypeId").onchange = function() {
		 var x = document.getElementById("reportTypeId").value;
		 if(x == 'Map') {
			 var x = document.getElementById("yesOrNoOptionRow")
			 x.hidden = false;
		 }else {
			 var x = document.getElementById("yesOrNoOptionRow")
			 x.hidden = true;
		 }
	};

</script>

</body>
</html>
