###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

angular.module("GScreen").factory "castAway", (CONFIG) ->
  castAway = null
  listeners =
    "receivers:available": []

  exports =
    available: false
    on: (key, func) ->
      listeners[key].push func
    connect: (cb) ->
      return unless castAway
      castAway.requestSession cb
    receiver: ->
      return unless castAway
      castAway.receiver()

  if chrome?.cast
    chrome.cast.timeout ?= {}
    chrome.cast.timeout.requestSession = 20000

    castAway = window.castAway = new CastAway
      applicationID: CONFIG.chromecastApplicationId
      namespace: "urn:x-cast:json"

    castAway.on "receivers:available", ->
      console.log "receivers available"
      exports.available = true
      l() for l in listeners["receivers:available"]
      $("#cast").click (ev) ->
        ev.preventDefault()

    castAway.initialize (err, data) ->
      console.log "initialized", err, data

  exports
