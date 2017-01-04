###
Copyright (c) 2014, Groupon
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.###

# NOTE: This function is going to be stringified and sent to CouchDB
# for execution, which means it cannot reference any code outside of
# the function scope (ie no requires, etc.)
#
# Also, remember that oldDoc will be null if this is a new record.
module.exports = (newDoc, oldDoc, usrCtx) ->
  raise = (error, reason) ->
    throw error: error, reason: reason

  # If we're deleting, no need for validations
  return if newDoc._deleted

  unless newDoc.type
    raise "missing type", "all documents must have a type: #{JSON.stringify(newDoc)}"

  if oldDoc && newDoc.type != oldDoc.type
    raise "invalid value", "cannot change a document's type"

  requiredFieldsMap =
    channel: ["name", "layout", "cells"]
    receiver: ["name", "groups"]
    alert: ["text", "duration", "style"]

  requiredFields = requiredFieldsMap[newDoc.type] || []
  for field in requiredFields
    continue if newDoc[field]?
    baseMessage = "documents with type='#{newDoc.type}' requires a '#{field}' value"
    raise "missing field", "#{baseMessage}: #{JSON.stringify(newDoc)}" unless newDoc[field]?

  null # No implicit return
