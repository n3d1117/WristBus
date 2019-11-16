# WristBus 🚌⚜️🇮🇹
Florence's bus timetables directly on your wrist. Written in Swift 4.

<img src="https://i.imgur.com/eMTfyRz.png" alt="Screenshots" data-canonical-src="https://i.imgur.com/eMTfyRz.png" style="max-width:100%;">

## Features
- Add, remove and reorder your favorite bus stops, while keeping them in sync with your Apple Watch.
- See timetables for the bus stops you've added, both on the Apple Watch and on the device.
- Search local bus stops via code name (e.g. FM1234) or by name.
- Automatic timetable refresh anytime you raise your wrist.
- Never miss a bus again!

## Dependencies
This project uses the following third party dependencies:

- [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - The better way to deal with JSON data in Swift
- [CryptoSwift](https://github.com/SwiftyJSON/SwiftyJSON) - A growing collection of standard and secure cryptographic algorithms implemented in Swift

## Getting started
- Make sure [Cocoapods](https://cocoapods.org/) is installed. Run the following commands:
```console
$ git clone http://github.com/n3d1117/WristBus
$ cd WristBus/
$ pod install
$ open WristBus.xcworkspace
```
- Replace `YOUR_TICKET` inside `Network.swift` with your ticket.
- Select a target and run the project!

## Disclaimer
This app does not make use of any prohibited content. All data is publicly available on [temporealeataf.it](http://temporealeataf.it/). I am in no way affiliated with © Ataf Gestioni S.r.l.

## License
Under MIT license. See LICENSE file for further information.