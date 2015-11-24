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
  //$scope.availableCategories = [];
  $scope.availableLocs = [];
  //$scope.categoryFilter = null;
  $scope.filterSpec = [];
  $scope.filters = {};
  // $scope.setCategoryFilter = function(category) {
  //   $scope.categoryFilter = category;
  //};
  results = animalModel.init();
  $scope.current = results[0];
  $scope.alum = results[1];
  //$scope.availableCategories = animalModel.getCategories();
  $scope.availableLocs = animalModel.getLocs();
});
app.factory('animalModel', function($http) {
  var classes = [];
  //var availableCategories = [];
  var availableLocs = [];
  var results = [];
  var alum = [];
  var current = [];

  var init = function() {
    // Download the spreadsheet data and add it to the scope objects above
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
          //console.log("cat: " + value.image);
          // Building personality array
          // angular.forEach(classes.gsx$personality, function(category, index) {
          //     var exists = false;
          //     angular.forEach(availableCategories, function(avCat, index) {
          //         if (avCat == category) {
          //             exists = true;
          //         }
          //     });
          //     if (exists === false) {
          //         availableCategories.push(category);
          //     }
          // });
          // // Building species array
          // angular.forEach(classes.gsx$species, function(species, index) {
          //     var exists = false;
          //     angular.forEach(availableSpecies, function(avSpec, index) {
          //         if (avSpec == species) {
          //             exists = true;
          //         }
          //     });
          //     if (exists === false) {
          //         availableSpecies.push(species);
          //     }
          // });
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
    //getCategories: getCategories
  };
});
