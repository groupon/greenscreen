'use strict';
var browser = require('testium-mocha').browser;

var Channel = require("../../src/server/models/channel"),
    db = require("../../src/server/db");

describe('Delete Channel', function() {
  before(browser.beforeHook());

  var mockChannel;

  beforeEach(function() {
    mockChannel = new Channel({
      name: "MockChannel",
      cells: [{
        urls: [{
          url: 'http://github.com'
        }]
      }]
    });
    mockChannel.save();
    return browser.navigateTo('/channels');
  });

  afterEach(function() {
    mockChannel.destroy();
  });

  it('should delete a channel', function() {
    var editLink = 'a[name="MockChannel"]'
    return browser
      .waitForElementDisplayed(editLink)
      .clickOn(editLink)
      .clickOn('#delete')
      .waitForElementNotExist(editLink);
  });
});
