<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>INTERACTIVE MAPS</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/docfile.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/es6-shim/0.33.3/es6-shim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/systemjs/0.19.20/system-polyfills.js"></script>
    <script src="https://code.angularjs.org/2.0.0-beta.6/angular2-polyfills.js"></script>
    <script src="https://code.angularjs.org/tools/system.js"></script>
    <script src="https://code.angularjs.org/tools/typescript.js"></script>
    <script src="https://code.angularjs.org/2.0.0-beta.6/Rx.js"></script>
    <script src="https://code.angularjs.org/2.0.0-beta.6/angular2.dev.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<style>	
.hidden { display: none; }	
</style>
 
</head>
<body>
<div id="header">

 <h3> <b> INTERACTIVE MAPS</b> <h3> 
    
    
  </div>
 
    <div id="updates" class="boxed">
      <h2 class="title">Upload excel data screen</h2>
      <div class="content">
      
	  <form:form action="/pqrs-reporting-webapp/admin/documentupload/" modelAttribute="documentFileUpload"
			enctype="multipart/form-data" method="post">	
			<c:if test="${not empty documentuploadsuccess}">
			<br/>
				<div class="successblock">
					<spring:message code="${documentuploadsuccess}"></spring:message>
				</div>
			</c:if>
			<c:if test="${not empty documentuploaderror}">
			<br/>
			    <p>${documentuploaderror}</p>
				<div class="successblock">				    
					<spring:message code="${documentuploaderror}"></spring:message>
				</div>
			</c:if>																									
			<form:errors path="*" cssClass="errorblock" element="div" />
			 <div style="padding-left: 100px; padding-bottom: 10px;">
					<form:select
						path="providerHypId" id="ddl1" onchange="configureDropDownLists(this,document.getElementById('ddl2'))">
						<option value="0">Select</option>
						<c:forEach var="category"
							items="${dataAnalysisCategories}">
							<option value="${category.id}">${category.dataAnalysisName}</option>
						</c:forEach>
					</form:select>
					<form:select
						path="providerSubHypId" id="ddl2" class="hidden">
						<!--<option value="0">NA</option>-->
						<!--<c:forEach var="subCategory"
							items="${subDataAnalysisCategories}">
							<option value="${subCategory.id}">${subCategory.subDataAnalysisName}</option>
						</c:forEach>-->
					</form:select>
			 </div>			
			<p>
				Document Provider :
				<form:input type="file" path="provider" size="40"/>
			</p>        
			
			<div>
				<input type="submit" value="Upload" id="provider-upload" disabled="disabled">
				<input type="reset" value="Reset">
			</div>			
			<p>
				Document Specialty :
				<form:input type="file" path="specialty" size="40"/>				
			</p>
			<div>
				<input type="submit" value="Upload">
				<input type="reset" value="Reset">
			</div>
			<p>
				Document Statewise :
				<form:input type="file" path="statewise" size="40"/>
			</p>
			<div>
				<input type="submit" value="Upload">
				<input type="reset" value="Reset">
			</div>
	 </form:form>

       </div>
    </div>
  </div>
   <div id="footer">
  <p id="legal">Copyright &copy; 2007 Ornamental. All Rights Reserved. Designed by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>.</p>
  <p id="links"><a href="#">Home</a> | <a href="#">Terms of Use</a></p>
</div>
<script type="text/javascript">
    function configureDropDownLists(ddl,ddl2) {     
    
    var ele = document.getElementById("ddl1");    
	var seleHypoId = ele.options[ele.selectedIndex].value;
	$('#ddl2').empty();
	
	if(seleHypoId === "0"){
		$('#ddl2').addClass('hidden');
		$('#provider-upload').attr("disabled","disabled");
	}else{		
	    $.ajax({
	            url: "/pqrs-reporting-webapp/api/subdata/hypothesis/" + seleHypoId,
	            type: 'GET',
	            dataType:'json',
	            success: function(data) {
	            	if(data.length == 0){	            		
	            		$('#ddl2').addClass('hidden');
	            	}else{
	            		$('#ddl2').removeClass('hidden');	            	
		            	for (i = 0; i < data.length; i++) {
		                     createOption(ddl2, data[i].subDataAnalysisName, data[i].id);			                     
		                }
	            	}
	            	$('#provider-upload').removeAttr('disabled');
	                
	            	},
	            error : function(request,error){            
	                alert("Request: "+JSON.stringify(request));
	            }
	     });
	}  

}

function createOption(ddl, text, value) {
     var opt = document.createElement('option');
     opt.value = value;
     opt.text = text;
     ddl.options.add(opt);
}
</script>
</body>
</html>
