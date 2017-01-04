'use strict';
var assert = require('assertive');
var browser = require('testium-mocha').browser;

var models = require('../models');

describe('Chromecasts Index', function() {
  before(browser.beforeHook());

  var mockReceiver1 = models.withReceiver({
    name: 'MockReceiver1',
    location: "MockLocation1"
  });
  var mockReceiver2 = models.withReceiver({
    name: 'MockReceiver2',
    location: "MockLocation2"
  });

  beforeEach(function() {
    return browser.navigateTo('/chromecasts');
  });

  function modelElementVal(model) {
    return element(by.model(model)).getAttribute('value')
  }

  it('should show you the available chromecasts', function() {
    return browser
      .waitForElementDisplayed('#rec-' + mockReceiver1.id)
      .waitForElementDisplayed('#rec-' + mockReceiver2.id);
  });

  it('should take you to the edit form', function() {
    return browser
      .clickOn('#rec-' + mockReceiver1.id)
      .waitForPath('/chromecasts/' + mockReceiver1.id + '/edit')
      .assertElementHasValue('input[ng-model="chromecast.name"]', 'MockReceiver1')
      .assertElementHasValue('input[ng-model="chromecast.location"]', 'MockLocation1')
      .back()
      .clickOn('#rec-' + mockReceiver2.id)
      .waitForPath('/chromecasts/' + mockReceiver2.id + '/edit')
      .assertElementHasValue('input[ng-model="chromecast.name"]', 'MockReceiver2')
      .assertElementHasValue('input[ng-model="chromecast.location"]', 'MockLocation2');
  });

  it('should show you to the preview links', function() {
    return browser
      .waitForElementDisplayed('#preview-' + mockReceiver1.id)
      .waitForElementDisplayed('#preview-' + mockReceiver2.id);
  });

  it('should lead you to the previews', function() {
    return browser.getElement('#preview-' + mockReceiver1.id).get('href')
      .then(function (href) {
        assert.match(new RegExp('\/chromecasts\/' + mockReceiver1.id + '$'), href);
      });
  });
});