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
    
	
	
</style>
 
</head>
<body>
<div id="header">

 <h3> <b> INTERACTIVE MAPS</b> <h3> 
    
    
  </div>
 
    <div id="updates" class="boxed">
      <h2 class="title">Download excel screen</h2>
      <div class="content">
	  <table  cellpadding="0"  width="70%" border="1" align="center" BORDERCOLOR=#ccffff>
					<th> Name </th>
					<th> Description</th>
					<th>Action</th>
					
					<c:forEach var="template" items="${templateFiles}">
						<tr>
							<td>
								<p>${template.uploadedFileName}</p>								 
							</td>
							<td>
							    <p>${template.uploadedDescription}</p>
							</td>
							<td>
							 <!-- <input type=button href="/admin/download-document/${document.id}"  value='Download'> -->
							 <a  href="/admin/download-template/${template.id}"><button>Download</button></a>
							 <!--<input type=button onClick="http://localhost:8484/admin/files/delete-document/${document.id}"  value='Delete'>-->
							 <a  href="/admin/delete-template/${template.id}"><button>Delete</button></a>
							</td>
						</tr>
                    </c:forEach>
					<!-- <tr>
						<td >
							<p>Hypothesis2: <a href="http://www.archsystemsinc.com/">Hypothesis2</a></p>
						</td>
						<td>						     
						</td>
						<td>
						    <input type=button onClick="location.href='file:///C:/Suganthi/Test/ornamental1/index1.html'"  value='Download'>		
						</td>
					</tr> -->
					
					<tr>
					<td>		
					</td>
					<td>	
					<a  href="/admin/download-templates"><button>Download All</button></a>
					<a  href="/admin/delete-templates"><button>Delete All</button></a>
					<!-- <input type=button onClick="location.href='file:///C:/Suganthi/Test/ornamental1/index1.html'"  value='Download All'> -->
					</td>
					<td>		
					</td>
					</tr>
		</table>
		
		<form:form action="/admin/new-template/" modelAttribute="templateFile"
			enctype="multipart/form-data" method="post">		
			<p>
				Description:<br>
				<form:input type="text" path="uploadedDescription" size="30"/>
			</p>
			<p>
				Please specify a file, or a set of files:<br>
				<form:input type="file" path="uploadFile" size="40"/>
			</p>
			<div>
				<input type="submit" value="Send">
			</div>
		</form:form>		
       </div>
    </div>
  </div>
   <div id="footer">
  <p id="legal">Copyright &copy; 2007 Ornamental. All Rights Reserved. Designed by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>.</p>
  <p id="links"><a href="#">Home</a> | <a href="#">Terms of Use</a></p>
</div>
</body>
</html>
