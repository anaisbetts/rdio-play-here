"use strict"

angular.module("serverApp", []).config ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"
  ).otherwise redirectTo: "/"
