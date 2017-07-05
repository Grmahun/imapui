'use strict';

angular.module('myApp').factory('ReportingService', ['$http', '$q', function($http, $q){

    var REST_SERVICE_URI = 'http://localhost:8080/imapservices/api/';

    var factory = {
    		dataAnalysisOptions: dataAnalysisOptions        
    };

    return factory;

    function dataAnalysisOptions() {
        var deferred = $q.defer();
        $http.get(REST_SERVICE_URI+"dataanalysis")
            .then(
            function (response) {
            	console.log("**********:"+JSON.stringify(response.data))
                deferred.resolve(response.data);
            },
            function(errResponse){
                console.error('Error while fetching data analysis options');
                deferred.reject(errResponse);
            }
        );
        return deferred.promise;
    }

 
}]);
