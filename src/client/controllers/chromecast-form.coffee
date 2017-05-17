###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

angular.module("GScreen").controller "ChromecastForm", ($scope, $routeParams, $location, castAway, flash, Chromecast, Channel) ->
  $scope.chromecast = if $routeParams.id then Chromecast.get($routeParams.id) else {}
  $scope.channels = Channel.query()

  session = null

  connect = (leave) ->
    castAway.connect (err, s) ->
      return console.log "ERR", err if err
      s.session.leave() if leave
      session = s
      $scope.$apply ->
        $scope.chromecast.name = session.session.receiver.friendlyName

  # new chromecast: do not 'leave' the session after it is selected,
  # since the chromecast needs to be configured after the save using the 'setChromecastId' message.
  if !$routeParams.id
    connect(false)

  # release the session after the reconnection occurs
  $scope.reconnect = ->
    connect(true)

  $scope.onFormSubmit = ->
    Chromecast.save $scope.chromecast, (chromecast) ->
      flash.message "Your changes to '#{$scope.chromecast.name}' have been saved."
      if session
        session.send "setChromecastId", chromecast.id, ->
          session.session.leave()
      $location.url "/chromecasts"

  $scope.deleteChannel = ->
    console.log "deleteing", $scope.chromecast
    Chromecast.remove $scope.chromecast, ->
      flash.message "The Chromecast '#{$scope.chromecast.name}' has been deleted."
      $location.url "/chromecasts"
