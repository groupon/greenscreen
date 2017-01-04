'use strict';
var browser = require('testium-mocha').browser;

var Channel = require("../../src/server/models/channel"),
    db = require("../../src/server/db");

describe('New Channel Page', function() {
  before(browser.beforeHook());

  var submitButton = 'input[name="submit"]',
      nameInput = 'input[name="name"]',
      firstUrlInput = 'input[name="cells0url0"]',
      mockNames = [];

  beforeEach(function() {
    return browser.navigateTo('/channels/new');
  });

  // Needed for manual cleanup of Channels
  function deleteByName(name) {
    return browser.navigateTo('/channels')
      .clickOn('a[name="' + name + '"]')
      .clickOn('#delete');
  }

  afterEach(function() {
    var oldMockNames = mockNames;
    mockNames = [];
    return Promise.all(oldMockNames.map(deleteByName));
  });

  function createChannel(name, url){
    mockNames.push(name);
    return browser.navigateTo('/channels/new')
      .setValue(nameInput, name)
      .setValue(firstUrlInput, url)
      .clickOn(submitButton);
  }

  it('should redirect to channels after creating a new channel', function(){
    return createChannel('mock-foo', 'http://github.com')
      .waitForPath('/channels');
  });

  it('should create a new channel', function(){
    return createChannel('mock-foo', 'http://github.com')
      .waitForElementDisplayed('a[name="mock-foo"]');
  });
});
