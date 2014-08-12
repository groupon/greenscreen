var Receiver = require('../../src/server/receiver'),
    db = require('../../src/server/db');

describe('Chromecasts Index', function(){

  var mockReceiver1,
      mockReceiver2;

  beforeEach(function(){
    browser.get('http://localhost:4994/chromecasts');
    mockReceiver1 = new Receiver({
      name: 'MockReceiver1',
      location: "MockLocation1"
    });
    mockReceiver2 = new Receiver({
      name: 'MockReceiver2',
      location: "MockLocation2"
    });

    mockReceiver1.save();
    mockReceiver2.save();
  });

  afterEach(function(){
    mockReceiver1.destroy();
    mockReceiver2.destroy();
  });

  function modelElementVal(model) {
    return element(by.model(model)).getAttribute('value')
  }

  it('should show you the available chromecasts', function(){
    expect(element(by.id(mockReceiver1.id)).isPresent()).toBe(true);
    expect(element(by.id(mockReceiver2.id)).isPresent()).toBe(true);
  });

  it('should take you to the edit form', function(){

    var mockReceiver1Button = element(by.id(mockReceiver1.id)),
        mockReceiver2Button = element(by.id(mockReceiver2.id)),
        expectedUrl1 = 'http://localhost:4994/chromecasts/' + mockReceiver1.id + '/edit',
        expectedUrl2 = 'http://localhost:4994/chromecasts/' + mockReceiver2.id + '/edit';

    mockReceiver1Button.click();
    expect(browser.getCurrentUrl()).toEqual(expectedUrl1);
    expect(modelElementVal('chromecast.name')).toEqual('MockReceiver1');
    expect(modelElementVal('chromecast.location')).toEqual('MockLocation1');


    browser.navigate().back();
    mockReceiver2Button.click();
    expect(browser.getCurrentUrl()).toEqual(expectedUrl2);
    expect(modelElementVal('chromecast.name')).toEqual('MockReceiver2');
    expect(modelElementVal('chromecast.location')).toEqual('MockLocation2');

  });

  it('should show you to the preview links', function(){
    expect(element(by.id(mockReceiver1.id + '-preview')).isPresent()).toBe(true);
    expect(element(by.id(mockReceiver2.id + '-preview')).isPresent()).toBe(true)
  });

  it('should lead you to the channel previews', function(){

    var mockReceiver1Button = element(by.id(mockReceiver1.id + '-preview')),
        mockReceiver2Button = element(by.id(mockReceiver2.id + '-preview')),
        expectedBaseUrl = 'http://localhost:4994/chromecasts/',
        expectedUrl1 = expectedBaseUrl + mockReceiver1.id,
        expectedUrl2 = expectedBaseUrl + mockReceiver2.id;

    expect(mockReceiver1Button.getAttribute('href')).toEqual(expectedUrl1);
    expect(mockReceiver2Button.getAttribute('href')).toEqual(expectedUrl2);
  })

});