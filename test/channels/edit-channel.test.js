'use strict';
var browser = require('testium-mocha').browser;

var Channel = require("../../src/server/models/channel"),
    db = require("../../src/server/db");

describe('Edit Channel Page', function() {
  before(browser.beforeHook());

  var submitButton = 'input[name="submit"]',
      nameInput = 'input[name="name"]',
      firstUrlInput = 'input[name="cells0url0"]',
      editLink = 'a[name="MockChannel"]',
      editedEditLink = 'a[name="MockChannel-Edit"]',
      mockChannel;

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

  // While on a channel edit page, edit the inputs to
  // the given name, url
  function editChannel(name, url) {
    if (name) {
      nameInput.clear();
      nameInput.sendKeys(name);
    }
    if (url) {
      firstUrlInput.clear();
      firstUrlInput.sendKeys(url);
    }
    submitButton.click();
  }

  // Needed for manual cleanup of channels
  function deleteByName(name) {
    return browser.navigateTo('/channels')
      .clickOn('a[name="' + name + '"]')
      .clickOn('#delete');
  }

  it('should redirect you to the channels page after saving changes', function() {
    return browser
      .clickOn(editLink)
      .clickOn(submitButton)
      .waitForPath('/channels')
      .then(deleteByName.bind(null, 'MockChannel'));
  });

  it('should let you edit a channel name', function() {
    return browser
      .clickOn(editLink)
      .setValue(nameInput, 'MockChannel-Edit')
      .clickOn(submitButton)
      .waitForElementDisplayed(editedEditLink)
      .waitForElementNotExist(editLink)
      .then(deleteByName.bind(null, 'MockChannel-Edit'));
  });

  it('should let you edit a channel url', function() {
    var expectedUrl = 'http://example.com';

    return browser
      .clickOn(editLink)
      .setValue(firstUrlInput, expectedUrl)
      .clickOn(submitButton)
      .clickOn(editLink)
      .assertElementHasValue(firstUrlInput, expectedUrl)
      .then(deleteByName.bind(null, 'MockChannel'));
  });
});
