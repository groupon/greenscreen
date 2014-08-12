// conf.js
exports.config = {
  seleniumAddress: 'http://localhost:4444/wd/hub',
  specs: [
    'channels/channels-test.js',
    'channels/delete-channel-test.js',
    'channels/edit-channel-test.js',
    'channels/new-channel-test.js',
    'chromecasts/chromecasts-test.js',
    'chromecasts/delete-chromecast-test.js',
    'chromecasts/edit-chromecast-test.js'
  ]
};