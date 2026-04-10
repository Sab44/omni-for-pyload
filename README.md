# ![Omni Icon](assets/banner/banner.png)

# About Omni

Omni is an app to manage downloads for your [pyLoad](https://github.com/pyload/pyload) instance.
It is available for both Android and iOS.

> [!IMPORTANT]
> This app is in beta. If you encounter a bug, check the known issues section first and create 
an [issue](https://github.com/Sab44/omni_for_pyload/issues) if it is not listed there.

> [!WARNING]
> Starting from version `0.2.0`, a pyLoad version of `0.5.0b3.dev97` or newer is required and you need to [create an API key](#Generate-an-API-key) when adding a server.  
> Versions `0.1.x` require a minimum pyLoad version of `0.5.0b3.dev94`. These app versions are deprecated and will be removed in the future.

## Screenshots

<div align="center">
  <div>
    <img src="./assets/screenshots/overview_light.png" width="30%" style="margin:6px;" alt="Overview page"/>
    <img src="./assets/screenshots/downloads_light.png" width="30%" style="margin:6px;" alt="Downloads page"/>
    <img src="./assets/screenshots/add_links_light.png" width="30%" style="margin:6px;" alt="Add links sheet"/>
    <img src="./assets/screenshots/overview_dark.png" width="30%" style="margin:6px;" alt="Overview page dark theme"/>
    <img src="./assets/screenshots/downloads_dark.png" width="30%" style="margin:6px;" alt="Downloads page dark theme"/>
    <img src="./assets/screenshots/upload_dlc_dark.png" width="30%" style="margin:6px;" alt="Upload dlc sheet dark theme"/>
  </div>
</div>

## Support development

A lot of work has gone into building this app. It is provided for free and open-source. If you like it, please consider donating to support the development.  
Ideally, I would like to publish the app on the App Store but for enrolling in Apple's developer program there is a fee of 99$ per year. 

<div align="center">
  <div>
  <a href="https://www.buymeacoffee.com/sab44" title="Buy me a coffee" target="_blank"><img src="./assets/funding/buymeacoffee.png" style="margin:6px;" alt="Buy me a coffee"/></a>
  <a href="https://github.com/sponsors/sab44" title="GitHub Sponsor" target="_blank"><img src="./assets/funding/github_sponsor.png" style="margin:6px;" alt="GitHub Sponsor"/></a>
  </div>
</div>

## Features

* Manage multiple instances
* All views will periodically auto-refresh, no manual refreshing required
* Add downloads via links or upload DLC file
* See active downloads & packages in Queue and Collector
* Stop, pause and resume Queue
* Delete one or multiple packages from Queue or Collector
* Move packages between Queue and Collector
* Restart packages
* Trigger package extraction
* Clear finished packages
* Restart failed packages
* Light and dark mode

## Click'N'Load

⚠️ ANDROID ONLY  

The app supports adding downloads via Click'N'Load. You can start the service via the `+` button once you selected a server and configured your Click'N'Load settings. Due to background limitations on iOS this is only available for Android. This is an experimental feature and might not work reliably.

## Installation

### Android

Recommended: install via [Obtainium](https://github.com/ImranR98/Obtainium)  

[<img src="./assets/badges/badge_obtainium.png"
  alt="Get it on Obtainium"
  height="80">][obtainium-app]

Alternatively, install the APK from the releases section manually.


### iOS

Recommended: install via [AltStore](https://altstore.io)  

[<img src="./assets/badges/badge_altstore.png"
  alt="Get it on Obtainium"
  height="80">][altstore-source]

Or, add AltStore source manually:
```
https://github.com/Sab44/omni_for_pyload/raw/refs/heads/main/ios/AltStoreSource.json
```

Alternatively, install the IPA from the releases section manually (e.g. via Sideloadly).

### Generate an API key

You need an API key to connect the app to your pyLoad instance. Open pyLoad in your browser and navigate to:  
**Settings** → **Users** → Next to your username tap on **Actions** → **Manage API Keys** → **Generate**.  
Make sure to copy the API key when it is shown as you will not be able to view it again after closing the dialog.

## Known limitations

* No support for captcha solving


## Roadmap

* Improve error handling
* Allow editing a server after it has been added
* Support managing pyLoad server settings from the app
* Show estimated time left for downloads
* Allow receiving URLs via the share action
* Allow receiving dlc files via the share action

## Contributing

This is a flutter project, written in Dart and Kotlin (for the Android service).  
Contributions are welcome. Make sure they are well tested and unit tests are adapted if feasible.

[obtainium-app]: http://apps.obtainium.imranr.dev/redirect.html?r=obtainium://add/https://github.com/Sab44/omni_for_pyload
[altstore-source]: https://sab44.github.io/