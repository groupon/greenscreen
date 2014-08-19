pathLib = require "path"
express = require "express"
Alert = require "../models/alert"
Channel = require "../models/channel"
Receiver = require "../models/receiver"
Takeover = require "../models/takeover"

module.exports = (app, sockets) ->

  router = express.Router()

  addResources = (basePath, resourceClass) ->
    router.get "#{basePath}", (req, res) ->
      resourceClass.all (err, resources) ->
        if err then res.send err else res.send resources

    router.get "#{basePath}/:id", (req, res) ->
      resourceClass.findById req.param("id"), (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        res.send resource

    router.post "#{basePath}", (req, res) ->
      data = req.body
      resource = new resourceClass(data)
      resource.save (err) ->
        return res.status(500).send(err) if err
        sockets.emit "#{resourceClass.type}-created", resource
        res.send resource

    router.put "#{basePath}/:id", (req, res) ->
      resourceClass.findById req.param("id"), (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        resource.update req.body, (err) ->
          return res.status(500).send(err) if err
          sockets.emit "#{resourceClass.type}-updated", resource
          res.send resource

    router.delete "#{basePath}/:id", (req, res) ->
      resourceClass.findById req.param("id"), (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        resource.destroy (err) ->
          return res.status(500).send(err) if err
          sockets.emit "#{resourceClass.type}-deleted", resource
          res.send status: "success"

  addResource = (basePath, resourceClass, id) ->
    router.get "#{basePath}", (req, res) ->
      resourceClass.findById id, (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        res.send resource

    router.post "#{basePath}", (req, res) ->
      data = req.body
      data.id = id
      resource = new resourceClass(data)
      resource.save (err) ->
        return res.status(500).send(err) if err
        sockets.emit "#{resourceClass.type}-created", resource
        res.send resource

    router.put "#{basePath}", (req, res) ->
      resourceClass.findById id, (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        resource.update req.body, (err) ->
          return res.status(500).send(err) if err
          sockets.emit "#{resourceClass.type}-updated", resource
          res.send resource

    router.delete "#{basePath}", (req, res) ->
      resourceClass.findById id, (err, resource) ->
        return res.status(404).send(null) if err && err.error == "not_found"
        return res.status(500).send(err) if err
        resource.destroy (err) ->
          return res.status(500).send(err) if err
          sockets.emit "#{resourceClass.type}-deleted", resource
          res.send status: "success"

  addResources "/alerts", Alert
  addResources "/channels", Channel
  addResources "/receivers", Receiver
  addResource "/takeover", Takeover, "takeover-singleton"

  app.use('/api', router)
