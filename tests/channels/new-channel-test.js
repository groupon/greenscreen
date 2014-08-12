var Channel = require("../../src/server/channel"),
    db = require("../../src/server/db");

describe('New Channel Page', function() {

  var submitButton = element(by.name('submit')),
      nameInput = element(by.id('name')),
      firstUrlInput = element(by.name('cells0url0')),
      mockNames = [];

  beforeEach(function(){
    browser.get('http://localhost:4994/channels/new');
  });

  afterEach(function(){
    browser.get('http://localhost:4994/channels');
    mockNames.forEach(function(name){
      deleteByName(name);
    });
    mockNames = []
  });

  function createChannel(name, url){
    browser.get('http://localhost:4994/channels/new');
    nameInput.sendKeys(name);
    firstUrlInput.sendKeys(url);
    submitButton.click();
    mockNames.push(name)
  }

  // Needed for manual cleanup of Channels
  function deleteByName(name){
    browser.get('http://localhost:4994/channels');
    element(by.name(name)).click();
    element(by.id('delete')).click();
  }

  it('should redirect to channels after creating a new channel', function(){
    var expectedUrl = 'http://localhost:4994/channels';
    createChannel('mock-foo', 'http://github.com');
    expect(browser.getCurrentUrl()).toEqual(expectedUrl);
  });

  it('should create a new channel', function(){
    createChannel('mock-foo', 'http://github.com');
    expect(element(by.name('mock-foo'))).not.toBe(null);
  });

});
