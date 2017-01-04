'use strict';
var db = require('../src/server/db');
var Channel = require('../src/server/models/channel');
var Receiver = require('../src/server/models/receiver');

function withModel(ModelType, options) {
  var proxy = {};
  var model = null;
  beforeEach(function (done) {
    model = proxy.__proto__ = new ModelType(options);
    model.save(done);
  });
  afterEach(function () {
    proxy.__proto__ = Object.prototype;
  });
  return proxy;
}
exports.withModel = withModel;
exports.withChannel = withModel.bind(null, Channel);
exports.withReceiver = withModel.bind(null, Receiver);

function rmAll(done) {
  db.get('_all_docs', function (err, docs) {
    if (err) return done(err);
    var pending = docs.filter(function (doc) { return doc.id[0] !== '_'; });
    if (!pending.length) return done();

    var firstDelErr = null;

    function deleteDoc(doc) {
      function onDeleteSuccessful() {
        pending = pending.filter(function (x) { return x.id !== doc.id });
        if (!pending.length) done(firstDelErr);
      }

      function retryDelete() {
        db.get(doc.id, function (fetchErr, updated) {
          if (fetchErr) return onDeleted(fetchErr);
          deleteDoc({ id: doc.id, value: { rev: updated._rev } });
        });
      }

      function onDeleted(delError) {
        if (delError && delError.error === 'conflict') return retryDelete();
        if (delError && delError.error === 'not_found') delError = null;

        firstDelErr = firstDelErr || delError;
        onDeleteSuccessful();
      }
      db.remove(doc.id, doc.value.rev, onDeleted);
    }
    pending.forEach(deleteDoc);
  });
}

function cleanSlate() {
  beforeEach(rmAll);
  afterEach(rmAll);
}
cleanSlate();
exports.cleanSlate = cleanSlate;
