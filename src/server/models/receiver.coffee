###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

_ = require "underscore"
Alert = require "./alert"
Channel = require "./channel"
Model = require "./model"
Takeover = require "./takeover"
db = require "../db"

module.exports = class Receiver extends Model
  @type: "receiver"

  @all: (cb) ->
    db.allWithType @type, (err, docs) =>
      return cb(err) if err
      receivers = docs.map (doc) => new this(doc)
      Channel.all (err, channels) ->
        return cb(err) if err
        receivers.forEach (r) ->
          r.channelName = _(channels).detect((ch) -> ch.id == r.channelId)?.name
        cb null, receivers

  @findById: (id, cb) ->
    db.get id, (err, doc) =>
      return cb(err) if err
      receiver = new Receiver(doc)
      Takeover.singleton (err, takeover) ->
        receiver.channelId = takeover.channelId if takeover
        Alert.forReceiver receiver, (err, alert) ->
          return cb(err) if err
          receiver.alert = alert
          cb null, receiver

  constructor: (data={}) ->
    @type = "receiver"
    @id = data.id || data._id
    @rev = data._rev
    @name = data.name
    @location = data.location
    @groups = data.groups || []
    @channelId = data.channelId

