var app = angular.module('myApp', []);
app.filter('myFilter', function() {
  return function(input, selectedCatCheckBox) {
    var selectedAnimals = [];

    //If none checked, show all.
    var anyChecked = false;
    for (var sel in selectedCatCheckBox) {
      if (selectedCatCheckBox[sel] === true) {
        anyChecked = true;
      }
    }
    if (!anyChecked) {
      return input;
    }

    for (var ani in input) {
      var spec = input[ani].gsx$species.$t;

      for (sel in selectedCatCheckBox) {
        if (sel == spec && selectedCatCheckBox[sel] === true) {
          selectedAnimals.push(input[ani]);
        }
      }

    }
    return selectedAnimals;
  };
});

app.controller("mainController", function($scope, $http, animalModel) {
  $scope.current = [];
  $scope.alum = [];
  $scope.filterText = null;
  $scope.availableLocs = [];
  $scope.filterSpec = [];
  $scope.filters = {};
  results = animalModel.init();
  $scope.current = results[0];
  $scope.alum = results[1];

  $scope.availableLocs = animalModel.getLocs();
});
app.factory('animalModel', function($http) {
  var classes = [];
  var availableLocs = [];
  var results = [];
  var alum = [];
  var current = [];

  var init = function() {
    $http({
        url: '/cats.json',
        method: "GET"
    }).success(function(data) {
      angular.forEach(data, function(value, index) {
          if(value.is_current == 0) {
              alum.push(value);
          } else {
              current.push(value);
          }
          if(availableLocs.indexOf(value.loc) == -1) {
              availableLocs.push(value.loc);
          }
      });
    }).error(function(error) {
        Console.log("Err:" + error);
    });
    return [current, alum];
  };
  var getLocs = function() {
    return availableLocs;
  };
  return {
    init: init,
    getLocs: getLocs,
   };
});
