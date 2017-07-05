<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
	<title>Hypothesis</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">      
    <link href="${pageContext.request.contextPath}/resources/css/common.css" rel="stylesheet">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	
</head> 

<body>

<div class="DataAnalysisScreen">   

<script type="text/javascript">console.log("justprint")</script>

	<h1> Data Analysis </h1>
	<br>	

	<table id = "dataAnalysisTableId" class="display" border="0.5" cellspacing="0" width="75%">
	     <thead>
            <tr>
                <th align="center">Data Analysis Name</th>
                <th align="center">Description</th>
                <th align="center">Action</th>
            </tr>
        </thead>
		 
		<tbody>
			
			<c:forEach items="${dataAnalysisList}" var="dataAnalysis">
				<tr>
					<td>
					<a href="${pageContext.request.contextPath}/mapandchartdisplay/dataanalysis/${dataAnalysis.dataAnalysisName}/subdataanalysis/ALL">${dataAnalysis.dataAnalysisName}</a>
					</td>
					
					<td> ${dataAnalysis.dataAnalysisDescription}
					</td>
					
					<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" id="view"  value= "View"/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" id="download" value= "Download"/>
					</td>
				
				</tr>
				
				<c:forEach items="${dataAnalysis.subDataAnalysis}" var="subDataAnalysis">
				
				<c:if test="${subDataAnalysis.subDataAnalysisName ne 'Not Applicable'}">
				
					<tr>
						<td>
						<ul> <li> <a href="${pageContext.request.contextPath}/mapandchartdisplay/dataanalysis/${dataAnalysis.dataAnalysisName}/subdataanalysis/${subDataAnalysis.subDataAnalysisName}">${subDataAnalysis.subDataAnalysisName}</a> </li> </ul>
						</td>
						
						<td> ${subDataAnalysis.subDataAnalysisDescription}
						</td>
						
						<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" id="view"  value= "View"/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" id="download" value= "Download"/>
						</td>
				
					</tr>
					
					</c:if>
				
				</c:forEach>
				
			</c:forEach>
		
		</tbody>
		
	</table>
	
<!-- 	
<script type="text/javascript">
	$(document).ready(function() {
	    $('#dataAnalysisTableId').DataTable();
	} );
</script>

 -->

</div>

</body>
</html>
