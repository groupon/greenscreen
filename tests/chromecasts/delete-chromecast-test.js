var Receiver = require('../../src/server/receiver'),
    db = require('../../src/server/db');

describe('Delete Chromecast', function(){

  var mockReceiver;

  beforeEach(function(){
    browser.get('http://localhost:4994/chromecasts');
    mockReceiver = new Receiver({
      name: 'MockReceiver',
      location: "MockLocation1"
    });
    mockReceiver.save();
  });

  afterEach(function(){
    mockReceiver.destroy();
  });

  function deleteByName(name){
    browser.get('http://localhost:4994/chromecasts');
    element(by.name(name)).click();
    element(by.id('delete')).click();
  }

  it('should delete a channel', function(){
    expect(element(by.name('MockReceiver')).isPresent()).toBe(true);
    deleteByName('MockReceiver');
    expect(element(by.name('MockReceiver')).isPresent()).toBe(false);
  });

});