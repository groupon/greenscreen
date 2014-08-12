###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

angular.module("GScreen").factory "localDevice", (Chromecast, sockets) ->
  listeners = {"change": []}

  clearTimeoutId = null

  loadChromecast = (id) ->
    Chromecast.get(id).$promise.then (c) ->
      console.log "loadChromecast", c
      updateChromecast(c)
      createAlert c.alert

  updateChromecast = (c) ->
    exports.chromecast = c
    l(c) for l in listeners.change

  updateChannelId = (channelId) ->
    newCast = {}
    newCast[k] = v for k,v of exports.chromecast
    newCast.channelId = channelId
    updateChromecast(newCast)

  updateAlert = (alert) ->
    newCast = {}
    newCast[k] = v for k,v of exports.chromecast
    newCast.alert = alert
    updateChromecast(newCast)

  loadChromecastFromPersistence = ->
    if id = localStorage.getItem "chromecast-id"
      loadChromecast(id)

  clearAlert = ->
    console.log "Clearing the alert"
    clearTimeout clearTimeoutId if clearTimeoutId
    updateAlert null

  createAlert = (alert) ->
    if alert
      duration = new Date(alert.expiresAt).getTime() - new Date().getTime()
      if duration > 0
        updateAlert alert
        console.log "duration", duration
        clearTimeoutId = setTimeout clearAlert, Math.ceil(duration)
      else
        clearAlert()

  sockets.on "receiver-updated", (chromecast) ->
    if exports.chromecast.id == chromecast.id
      updateChromecast chromecast

  sockets.on "takeover-created", (takeover) ->
    updateChannelId takeover.channelId

  sockets.on "takeover-updated", (takeover) ->
    updateChannelId takeover.channelId

  sockets.on "takeover-deleted", ->
    loadChromecastFromPersistence()

  sockets.on "alert-created", (alert) ->
    console.log "Creating alert", alert
    createAlert alert

  loadChromecastFromPersistence()

  exports =
    setChromecastId: (id) ->
      loadChromecast(id)
      localStorage.setItem "chromecast-id", id

    on: (event, func) ->
      listeners[event].push func

    chromecast: null

  exports
