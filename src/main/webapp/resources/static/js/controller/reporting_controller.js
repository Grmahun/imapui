'use strict';

angular.module('myApp').controller('ReportingController', ['$scope', 'ReportingService', function($scope, ReportingService) {
    var self = this;
    self.dataAnalysis={id:null,dataAnalysisDescription:'',dataAnalysisName:''};
    self.dataAnalysis=[];

    


    dataAnalysisOptions();

    function dataAnalysisOptions(){
    	ReportingService.dataAnalysisOptions()
            .then(
            function(d) {
                self.dataAnalysis = d;
            },
            function(errResponse){
                console.error('Error while fetching data analysis options');
            }
        );
    }  
}]);
