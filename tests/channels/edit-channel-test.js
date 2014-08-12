var Channel = require("../../src/server/channel"),
    db = require("../../src/server/db");

describe('Edit Channel Page', function() {

  var submitButton = element(by.name('submit')),
      nameInput = element(by.id('name')),
      firstUrlInput = element(by.name('cells0url0')),
      mockChannel;

  beforeEach(function(){
    mockChannel = new Channel({
      name: "MockChannel",
      cells: [{
        urls: [{
          url: 'http://github.com'
        }]
      }]
    });
    mockChannel.save();

    browser.get('http://localhost:4994/channels');
  });

  afterEach(function(){
    mockChannel.destroy();
  });

  // While on a channel edit page, edit the inputs to
  // the given name, url
  function editChannel(name, url){
    if (name){
      nameInput.clear();
      nameInput.sendKeys(name);
    }
    if (url){
      firstUrlInput.clear();
      firstUrlInput.sendKeys(url);
    }
    submitButton.click();
  }

  // Needed for manual cleanup of channels
  function deleteByName(name){
    browser.get('http://localhost:4994/channels');
    element(by.name(name)).click();
    element(by.id('delete')).click();
  }

  it('should redirect you to the channels page after saving changes', function(){
    var expectedUrl = 'http://localhost:4994/channels';

    element(by.name('MockChannel')).click();
    submitButton.click();
    expect(browser.getCurrentUrl()).toEqual(expectedUrl);

    deleteByName('MockChannel');
  });

  it('should let you edit a channel name', function(){
    element(by.name('MockChannel')).click();
    editChannel('MockChannel-Edit', null);

    expect(element(by.name('MockChannel-Edit')).isPresent()).toBe(true);
    expect(element(by.name('MockChannel')).isPresent()).toBe(false);

    deleteByName('MockChannel-Edit');
  });

  it('should let you edit a channel url', function(){
    var expectedUrl = 'http://example.com'

    element(by.name('MockChannel')).click();
    editChannel(null, expectedUrl);
    element(by.name('MockChannel')).click();
    expect(firstUrlInput.getAttribute('value')).toEqual(expectedUrl);

    deleteByName('MockChannel')
  });

});
