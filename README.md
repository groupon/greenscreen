# Greenscreen

A digital signage solution using the Web and Chromecast devices.

Built with Angular.js, Node.js, Express.js, and CouchDB.

## How to Use

### Home

![HomePage](screenshots/home.png?raw=true "Homepage")

On the homepage, you will find several options currently at your disposal, namely:

- Chromecasts
- Channels
- Alerts
- Channel Takeover

### Channels

![Channels](screenshots/channels.png?raw=true "Channels")

Chromecasts tune into 'Channels', which refer to certain URLs. 

Create a channel by clicking the 'Add a Channel' button.

![New Channel](screenshots/new_channel.png?raw=true "New Channel")

Here, you can specify the name of your channel as well as the URL it points to.
You can also choose to serve multiple URLs, which rotate at a specified time interval.

![Edit Channel](screenshots/edit_channel.png?raw=true "Edit Channel")

To edit a channel, click the name of your channel and adjust accordingly.

### Chromecasts

![Chromecasts](screenshots/chromecasts.png?raw=true "Chromecasts")

Here, you can browse the available chromecasts. Click 'Add a chromecast' to connect a new Chromecast.

You can also preview what that Chromecast is tuning into, by clicking 'Preview.'

![New Chromecast](screenshots/new_chromecast.png?raw=true "New Chromecast")

You will be prompted by the Google Cast extension to select a Chromecast. Select one of the available devices.
This will automatically populate the 'Name' field with the name of the Chromecast. 

Describe the location of the Chromecast in the 'Location' field.

From the dropdown, select the channel that you want that chromecast to view.

![Edit Chromecast](screenshots/edit_chromecast.png?raw=true "Edit Chromecast")

You can edit a Chromecast by clicking a Chromecast's name. From here, you can edit the location and the channel.

That Chromecast will be automatically updated with that location and channel.

In the case that a Chromecast becomes disconnected, you can also reconnect a Chromecast by clicking 'Reconnect.'
Just like adding a Chromecast, you can select the appropriate Chromecast, and it will associate itself with the current
record.

### Alerts

![Push Alert](screenshots/push_alert.png?raw=true "Push Alert")

You can also push an alert to all Chromecasts using 'Push Alert'. 

Here, you can specify the alert's content, its type, and its duration. 

Clicking 'Push Alert' will publicize this alert on all pages. Any subsequent alerts will currently override the current alert.

![Example Alert](screenshots/alert.png?raw=true "Example Alert")

### Channel Takeover

![Channel Takeover](screenshots/channel_takeover.png?raw=true "Channel Takeover")

Here, you can do a 'Channel Takeover' to set all Chromecasts to a specific channel, and also choose to stop said takeover.

## Getting Started: Local

### Installing dependencies

To install dependencies:

```shell
brew install couchdb
npm install
```

You must also have the Google Cast Chrome extension, as well as a Chromecast setup application.

You'll also need at least one Chromecast :)

### Registering your Application

In order for your Chromecast to properly receive our Custom Receiver, your must first 
[register your Cast Application](https://developers.google.com/cast/docs/registration#RegisterApp).

Following the instructions, you should sign into the [Google Cast SDK Developer Console](https://cast.google.com/publish),
create a new application, and select **Custom Receiver**.

In the **URL** field, you will need to provide a URL to the application.

By default, the URL you want will be:

```
http://<YOUR-LOCAL-IP>:4994/setup-chromecast.html
```

For OS X, you can find your local IP in System Preferences > Network, and will generally begin with `192.`

You may notice your newly created chromecast application will be in the 'Unpublished' state. This is expected, and your chromecast's will still be able to get to the app as long as they're registered (which is covered in the following section).

### Registering your Chromecasts

Along with registering your Chromecast Application, you will need to register your Chromecasts. This is done through the
[Google Cast SDK Developer Console](https://cast.google.com/publish).

Serial numbers can be found on the back of your Chromecast. Once registration is complete, make sure to reboot your devices, which
can be done through the Chromecast Desktop Application.

### Setting up your Chromecasts

Set up your chromecasts using the Chromecast Setup Application, through mobile or desktop (Desktop preferred).

Make sure that they are on the same Wi-Fi network as your local machine.

**Make sure that each Chromecast is configured to send its ID number via the Chromecast App.** In the desktop application,
this involves checking the box that says to 'Send this Chromecast's serial number to Google when checking for updates'.

Once that preference is saved, it may be useful to reboot your chromecast. Doesn't hurt!

### Application Config

You will need to create and edit some config files.

```
npm run create-config
```

In `public/js/gscreen-config.js`, edit the `chromecastApplicationId` field to your Chromecast Application ID.

You can configure the couchDB and sever details in config.json.

### Starting the Server

**Phew!** Now that all of that yucky registration is done, you're ready to start the Greenscreen server.

Start up couchdb with:

```shell
couchdb
```

Start the server (make sure you've installed the dependencies, see above section 'Installing Dependencies'):

```
npm start
```

(Optional) You can seed the database with dummy chromecasts.

```shell
npm run seed
```

View the project locally at [http://localhost:4994](http://localhost:4994).

## Developing

The client-side code is bundled from the `src/client` directory. To build, run:

```shell
npm run bundle
```

This will watch all changes to client side code, and bundle it to public/js/gscreen.js.

`public/js/gscreen.js` **is automatically generated, so don't edit this file!**

While the server is running with `npm start`, changes in the `src/server` will cause the server to restart
with the new changes.

## Tests

End-to-end tests are run using protractor. To start tests:

You will need protractor installed:

```sh
npm install -g protractor
```

Start up the application locally, and then:

Start a webdriver-manager:

```sh
npm run webdriver
```

Start the tests:
```sh
npm test
```


## Known Issues

> When adding a Chromecast, the Chrome extension may time out on requesting a Session, though the Chromecast may successfully
> display the 'Setting up Chromecast' page. This timeout occurs because connecting to your local server tends to be pretty slow.

To remedy this, select the Chromecast in the Google Cast extension, and select 'Stop Casting.' You'll need to
navigate back to the Chromecasts list, and click 'Add new Chromecast' to try again.

## Troubleshooting

> My Chromecasts aren't appearing in the Google Cast extension!

Make sure that you are able to see your Chromecast(s) in the Google Cast extension on other tabs/pages. If not, this is
most likely an error with your extension, or your connection.

- Check that your Chromecast and your local development server are on the same Wi-Fi network
- Try rebooting your Chromecasts through the desktop applications or manually, and reconnecting them.
- Try restarting your Chrome browser (Completely quit the application and re-open)

**When all else fails, reboot your chromecasts, and restart Chrome.**

## Security

Obviously, you don't neccessarily want to have everyone able to manipulate every Chromecast through the web
interface. Currently, the best way to secure this is by setting up a private Wi-Fi network for the Chromecasts
to connect to.

#### Good luck, and happy casting! :)
