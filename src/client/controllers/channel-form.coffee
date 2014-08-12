###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

angular.module("GScreen").controller "ChannelForm", ($scope, $routeParams, $location, flash, Channel) ->
  $scope.mainUrls = []
  $scope.channel = if $routeParams.id then Channel.get($routeParams.id) else {layout: "single-cell", cells: [{urls: [{url: ""}], duration: 60}, {urls: [{url: ""}], duration: 60}]}

  $scope.channel.$promise?.then (channel) -> console.log channel

  $scope.onFormSubmit = ->
    Channel.save $scope.channel, ->
      flash.message "Your changes to '#{$scope.channel.name}' have been saved."
      $location.url "/channels"

  $scope.deleteChannel = ->
    Channel.remove $scope.channel, ->
      flash.message "The channel '#{$scope.channel.name}' has been deleted."
      $location.url "/channels"

  $scope.removeUrlFromCell = (url, cellIndex) ->
    $scope.channel.cells[cellIndex].urls = _.without $scope.channel.cells[cellIndex].urls, url

