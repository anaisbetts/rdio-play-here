## How to run the server side

```sh
npm install -g grunt coffee
npm install

cd server
grunt build && node app.js
```

## How to install the Chrome Extension

```sh
npm install -g grunt coffee
npm install

cd chrome
grunt build
```

Open Chrome, head to `chrome://extensions`, click on "Load Unpacked
Extension". Then, select the "dist" directory under the `chrome` folder. Most
of the interesting work is done as an [Event
Page](http://developer.chrome.com/extensions/event_pages.html) - if you click
on "background.html", you'll get a debugger attached to the event page that
you can fiddle with.
