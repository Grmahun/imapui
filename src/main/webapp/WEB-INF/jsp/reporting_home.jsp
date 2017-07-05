<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
  <head>  
    <title>PQRS Interactive Map Data Analysis</title>  
    <style>
      .username.ng-valid {
          background-color: lightgreen;
      }
      .username.ng-dirty.ng-invalid-required {
          background-color: red;
      }
      .username.ng-dirty.ng-invalid-minlength {
          background-color: yellow;
      }

      .email.ng-valid {
          background-color: lightgreen;
      }
      .email.ng-dirty.ng-invalid-required {
          background-color: red;
      }
      .email.ng-dirty.ng-invalid-email {
          background-color: yellow;
      }

    </style>
     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
     <link href="<c:url value='/resources/static/css/app.css' />" rel="stylesheet"></link>
  </head>
  <body ng-app="myApp" class="ng-cloak">
  <h2 align="left">Welcome to PQRS Interactive Map Data Analysis Reporting Application </h2>
      <div class="generic-container" ng-controller="ReportingController as ctrl">
          <div class="panel panel-default">
              
          <div class="panel panel-default">
                <!-- Default panel contents -->
              <div class="panel-heading"><span class="lead">List of Users </span></div>
              <div class="tablecontainer">
                  <table class="table table-hover">
                      <thead>
                          <tr>
                              <th>ID.</th>
                              <th>DataAnalysisDescription</th>
                              <th>DataAnalysisName</th>
                          </tr>
                      </thead>
                      <tbody>
                          <tr ng-repeat="u in ctrl.dataAnalysis">
                              <td><span ng-bind="u.id"></span></td>
                              <td><span ng-bind="u.dataAnalysisDescription"></span></td>
                              <td><span ng-bind="u.dataAnalysisName"></span></td>
                              
                          </tr>
                      </tbody>
                  </table>
              </div>
          </div>
      </div>
      
      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.4/angular.js"></script>
      <script src="<c:url value='/resources/static/js/app.js' />"></script>
      <script src="<c:url value='/resources/static/js/service/reporting_service.js' />"></script>
      <script src="<c:url value='/resources/static/js/controller/reporting_controller.js' />"></script>
  </body>
</html>
