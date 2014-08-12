var Channel = require("../../src/server/channel"),
    db = require("../../src/server/db");

describe('Channels Index', function() {

  var addChannelButton = element(by.id('addChannel')),
      channel1,
      channel2;

  beforeEach(function(){
    channel1 = new Channel({
      name: "Test Channel 1"
    });
    channel2 = new Channel({
      name: "Test Channel 2"
    });

    channel1.save();
    channel2.save();

    browser.get('http://localhost:4994/channels')
  });

  afterEach(function(){
    channel1.destroy();
    channel2.destroy();
  });

  function expectUrl(url){
    expect(browser.getCurrentUrl()).toEqual(url);
  }

  it('should take you the new form', function(){
    var expectedUrl = 'http://localhost:4994/channels/new';

    addChannelButton.click();
    expectUrl(expectedUrl);
  });

  it('should show you available channels', function(){
    expect(element(by.id(channel1.id)).isPresent()).toBe(true);
    expect(element(by.id(channel2.id)).isPresent()).toBe(true);
  });

  it('should take you to the edit form', function(){

    var channel1Button = element(by.id(channel1.id)),
        channel2Button = element(by.id(channel2.id)),
        expectedUrl1   = 'http://localhost:4994/channels/' + channel1.id + '/edit',
        expectedUrl2   = 'http://localhost:4994/channels/' + channel2.id + '/edit';

    channel1Button.click();
    expectUrl(expectedUrl1);

    browser.navigate().back();
    channel2Button.click();
    expectUrl(expectedUrl2);

  });

  it('should show you preview links', function(){
    expect(element(by.id(channel1.id + '-preview')).isPresent()).toBe(true);
    expect(element(by.id(channel2.id + '-preview')).isPresent()).toBe(true)
  });

  it('should lead you to the channel previews', function(){
    var channel1Button = element(by.id(channel1.id + '-preview')),
        channel2Button = element(by.id(channel2.id + '-preview')),
        expectedUrl1   = 'http://localhost:4994/channels/' + channel1.id,
        expectedUrl2   = 'http://localhost:4994/channels/' + channel2.id;

    expect(channel1Button.getAttribute('href')).toEqual(expectedUrl1);
    expect(channel2Button.getAttribute('href')).toEqual(expectedUrl2);

  })

});
