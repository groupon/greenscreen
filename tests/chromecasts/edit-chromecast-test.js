var Receiver = require('../../src/server/receiver'),
    Channel = require('../../src/server/channel'),
    db = require('../../src/server/db');

describe('Edit Chromecast Page', function(){

  var submitButton = element(by.name('submit')),
      nameInput = element(by.id('name')),
      locationInput = element(by.id('location')),
      mockReceiver,
      mockChannel;

  beforeEach(function(){
    browser.get('http://localhost:4994/chromecasts');
    mockReceiver = new Receiver({
      name: 'MockReceiver',
      location: "MockLocation"
    });
    mockChannel = new Channel({
      name: "MockChannel",
      cells: [{
        urls: [{
          url: 'http://github.com'
        }]
      }]
    });

    mockChannel.save();
    mockReceiver.save();
  });

  afterEach(function(){
    mockReceiver.destroy();
    mockChannel.destroy();
  });

  function deleteByName(name){
    browser.get('http://localhost:4994/chromecasts');
    element(by.name(name)).click();
    element(by.id('delete')).click();
  }

  function editChromecast(location){
    locationInput.clear();
    locationInput.sendKeys(location);
    submitButton.click();
  }

  function expectUrl(url){
    expect(browser.getCurrentUrl()).toEqual(url);
  }

  it('should redirect you to the chromecasts page after saving changes', function(){
    element(by.name('MockReceiver')).click();
    submitButton.click();
    expectUrl('http://localhost:4994/chromecasts');

    deleteByName('MockReceiver');
  });

  it('should not let you edit a chromecast name', function(){
    element(by.name('MockReceiver')).click();
    expect(nameInput.getAttribute('disabled')).toEqual('true');
  });

  it('should let you edit a chromecast location', function(){
    element(by.name('MockReceiver')).click();
    editChromecast('MockLocation-Edit');

    expect(element(by.name('MockReceiver')).isPresent()).toBe(true);
    element(by.name('MockReceiver')).click();

    expect(locationInput.getAttribute('value')).toEqual('MockLocation-Edit');

    deleteByName('MockReceiver');

  });

  it('should let you edit a chromecast channel', function(){
    element(by.name('MockReceiver')).click();

    var channel = element(by.css("select option[value='0']"));

    channel.click();
    submitButton.click();

    element(by.name('MockReceiver')).click();
    expect(channel.getAttribute('value')).toEqual('0');

    deleteByName('MockReceiver');
  });
});
