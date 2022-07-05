# Trust-SDK
## Getting Started

The Trust-SDK get device info


## Installation

TrustSDK is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Trust_SDK'
```

Run `pod install`.

## Configuration

Follow the next steps to configure `Trust_SDK` in your app.

### Schema Configuration

Open Xcode an click on your project. Go to the 'Info' tab and expand the 'URL Types' group. Click on the **+** button to add a new scheme. Enter a custom scheme name in **'URL Scemes'**.

![Adding a scheme](docs/scheme.png)

### Initialization

Open `AppDelegate.swift` file and initialize TrustSDK in`application(_:didFinishLaunchingWithOptions:)` method:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let tructSDK = Trust_SDK.init()
    print(tructSDK.get_device_info())
    return true
}
```

### Install Trust_SDK

Add the following line to your Podfile:


```ruby
pod 'Trust_SDK', '~1.2'
```

Run `pod install`.

## Author

* Tester QTS

## License

Trust_SDK is available under the MIT license. See the LICENSE file for more info.
