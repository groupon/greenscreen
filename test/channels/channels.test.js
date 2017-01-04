'use strict';
var assert = require('assertive');
var browser = require('testium-mocha').browser;

var Channel = require("../../src/server/models/channel"),
    db = require("../../src/server/db");

describe('Channels Index', function() {
  before(browser.beforeHook());

  var channel1,
      channel2;

  beforeEach(function() {
    channel1 = new Channel({
      name: "Test Channel 1"
    });
    channel2 = new Channel({
      name: "Test Channel 2"
    });

    channel1.save();
    channel2.save();

    return browser.navigateTo('/channels');
  });

  afterEach(function() {
    channel1.destroy();
    channel2.destroy();
  });

  it('should take you the new form', function() {
    return browser.clickOn('#addChannel')
      .waitForPath('/channels/new');
  });

  it('should show you available channels', function() {
    return browser
      .waitForElementDisplayed('#channel-' + channel1.id)
      .waitForElementDisplayed('#channel-' + channel2.id);
  });

  it('should show you preview links', function() {
    return browser
      .waitForElementDisplayed('#preview-' + channel1.id)
      .waitForElementDisplayed('#preview-' + channel2.id);
  });

  it('should take you to the edit form', function() {
    return browser
      .clickOn('#channel-' + channel1.id)
      .waitForPath('/channels/' + channel1.id + '/edit')
      .back()
      .clickOn('#channel-' + channel2.id)
      .waitForPath('/channels/' + channel2.id + '/edit');
  });

  it('should lead you to the channel previews', function() {
    return browser.getElement('#preview-' + channel1.id).get('href')
      .then(function (href) {
        assert.match(new RegExp('\/channels\/' + channel1.id + '$'), href);
      });
  });
});
