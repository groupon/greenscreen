###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

cradle = require "cradle"
views = require "./couch-db-views"
validations = require "./couch-db-validations"

module.exports = class CouchDB
  constructor: (config) ->
    @couch = new cradle.Connection config.host, config.port
    @db = @couch.database config.db
    @ensureDbExists =>
      @installDesignDoc()

  ensureDbExists: (cb) ->
    console.log "Ensuring DB Exists..."
    @db.exists (err, exists) =>
      return cb() if exists
      console.log "Creating DB..."
      @db.create cb

  installDesignDoc: (cb) ->
    console.log "Creating Design Doc..."
    @db.save "_design/gscreen",
      views: views
      validate_doc_update: validations

  allWithType: (type, cb) ->
    @db.view "gscreen/byType", key: type, include_docs: true, (err, rows) ->
      return cb(err) if err
      # This next line looks crazy, and it is. Believe it or not, the cradle lib
      # overrides the `map` function to map over the docs, not the rows. This means
      # that the result is an array of docs, rather than an array of rows, which is
      # what we want. Very strange design choice on cradle's part.
      cb(null, rows.map (doc) -> doc)

  get: (args...) -> @db.get(args...)
  save: (args...) -> @db.save(args...)
  remove: (args...) -> @db.remove(args...)
