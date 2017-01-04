'use strict';
var browser = require('testium-mocha').browser;

var models = require('../models');

describe('Delete Chromecast', function() {
  before(browser.beforeHook());

  var mockReceiver = models.withReceiver({
    name: 'MockReceiver',
    location: "MockLocation1"
  });
  var editLink = 'a[name="MockReceiver"]';

  beforeEach(function(){
    return browser.navigateTo('/chromecasts');
  });

  function deleteByName(name){
    return browser.navigateTo('/chromecasts')
      .clickOn('a[name="' + name + '"]')
      .clickOn('#delete');
  }

  it('should delete a channel', function(){
    return browser
      .waitForElementDisplayed(editLink)
      .then(deleteByName.bind(null, 'MockReceiver'))
      .waitForElementNotExist(editLink);
  });
});
