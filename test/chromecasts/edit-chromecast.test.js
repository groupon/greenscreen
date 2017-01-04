'use strict';
var browser = require('testium-mocha').browser;

var models = require('../models');

describe('Edit Chromecast Page', function() {
  before(browser.beforeHook());

  var editLink = 'a[name="MockReceiver"]',
      submitButton = 'input[name="submit"]',
      nameInput = '#name',
      locationInput = '#location';

  var mockReceiver = models.withReceiver({
    name: 'MockReceiver',
    location: "MockLocation"
  });
  var mockChannel = models.withChannel({
    name: "MockChannel",
    cells: [{
      urls: [{
        url: 'http://github.com'
      }]
    }]
  });

  beforeEach(function() {
    return browser.navigateTo('/chromecasts');
  });

  function deleteMockReceiver() {
    return browser.navigateTo('/chromecasts')
      .clickOn(editLink)
      .clickOn('#delete');
  }

  function editChromecast(location) {
    locationInput.clear();
    locationInput.sendKeys(location);
    submitButton.click();
  }

  it('should redirect you to the chromecasts page after saving changes', function() {
    return browser
      .clickOn(editLink)
      .clickOn(submitButton)
      .waitForPath('/chromecasts')
      .then(deleteMockReceiver);
  });

  it('should not let you edit a chromecast name', function() {
    return browser
      .clickOn(editLink)
      .assertElementHasAttributes(nameInput, { disabled: 'true' });
  });

  it('should let you edit a chromecast location', function() {
    return browser
      .clickOn(editLink)
      .setValue(locationInput, 'MockLocation-Edit')
      .clickOn(submitButton)
      .waitForElementDisplayed(editLink)
      .clickOn(editLink)
      .assertElementHasValue(locationInput, 'MockLocation-Edit')
      .then(deleteMockReceiver);
  });

  it('should let you edit a chromecast channel', function() {
    var channel = 'select option[value="0"]';
    return browser
      .clickOn(editLink)
      .clickOn(channel)
      .clickOn(submitButton)
      .waitForElementDisplayed(editLink)
      .clickOn(editLink)
      .assertElementHasValue(channel, '0')
      .then(deleteMockReceiver);
  });
});
