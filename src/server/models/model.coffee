###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

db = require "../db"
_ = require "underscore"

module.exports = class Model
  @all: (cb) ->
    db.allWithType @type, (err, docs) =>
      return cb(err) if err
      channels = docs.map (doc) => new this(doc)
      cb(null, channels)

  @findById: (id, cb) ->
    db.get id, (err, doc) =>
      return cb(err) if err
      cb(null, new this(doc))

  save: (cb=->) ->
    attrs = {}
    for own k,v of this
      if !_(["id", "rev"]).contains(k) && !/^\$/.test k
        attrs[k] = v
    if @id
      db.save @id, @rev, attrs, (err, res) ->
        return cb(err) if err
        @rev = res.rev
        cb()
    else
      db.save attrs, (err, res) =>
        return cb(err) if err
        @id = res.id
        @rev = res.rev
        cb()

  update: (data, cb=->) ->
    this[k] = v for k,v of data
    @save(cb)

  destroy: (cb=->) ->
    db.remove @id, @rev, cb
