var Channel = require("../../src/server/channel"),
    db = require("../../src/server/db");

describe('Delete Channel', function() {

  var mockChannel;

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

  function deleteByName(name){
    browser.get('http://localhost:4994/channels');
    element(by.name(name)).click();
    element(by.id('delete')).click();
  }

  it('should delete a channel', function(){
    expect(element(by.name('MockChannel')).isPresent()).toBe(true);
    deleteByName('MockChannel');
    expect(element(by.name('MockChannel')).isPresent()).toBe(false);
  });

});
