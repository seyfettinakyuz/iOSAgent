# Instana iOSAgent

**[Changelog](https://github.com/instana/iOSAgent/blob/master/Changelog.md)** |

---

iOS agent to use Instana for your iOS app. The monitoring currently supports:

- Session Start
- Capture HTTP sessions automatically or manually
- Automatic delivery of device & app information (like bundle identifer, version, language, iOS device information)
- Send custom event (This can be especially helpful to send logs, to track additional performance metrics or errors.)
- [Tech Preview] Crash reporting, plus CPU exception, disk write exception, hang diagnostics and app launch diagnostics

Optionally:
- Ignore full URLs by regex or full URLs
- Set global meta data (key/value)
- Set user specific data (like id, name and email)
- Set the current visible view to match with the HTTP sessions  

## Requirements
- iOS 11+
- Swift 5.1+

## Installation

To install the iOS agent, use Swift Package Manager (via Xcode) or CocoaPods.

#### Swift Package Manager

1. Open Xcode.
2. Select File -> Swift Packages -> Add Package Dependency -> Your Xcode project.
3. Enter the https://github.com/instana/iOSAgent repository.

#### CocoaPods

1. Within your `Podfile` specification, add the following:

   `pod 'InstanaAgent'`

2. To download the dependencies, run `pod install`.

#### Setup
Just initialize the Instana iOS agent with the following setup. Make sure to call setup very early in `didFinishLaunchingWithOptions`

```
import InstanaAgent

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let options = InstanaSetupOptions(enableCrashReporting: <true or false>)
	Instana.setup(key: <Your Instana Key>, reportingURL: <Your Instana instance URL>, options: options)

	....
	return true
}
```

### Notes on diagnostic log report

1. Diagnostic test, crash as an example, needs to be done on physical devices: iPhone, iPad etc. Simulator is of no help.
2. The lowest versions that support crash reporting are iOS 14.0 and macOS 12.0.
3. A valid bundle id other than com.instana.ios.InstanaAgentExample for your test app is also a must.

### How to enable slow send mode on beacon send failure

By default, when beacon send failed, Instana agent tries to resend it until succeed. Beacons are also sent in batches (maximum 100 beacons) every 2 seconds. For certain cellular network, this is not an ideal option.
An alternative way, slow send mode, is introduced since version 1.6.1. This mode could be turned on by providing a positive slowSendInterval number (in seconds) in setup() call. Then if beacon send failed, Instana agent only sends out one beacon every \(slowSendInterval) seconds. If succeeded, beacon sending restores to normal mode, ie. in batches every 2 seconds. Otherwise sending stays in slow send mode.
Slow send mode is disabled by default. When enabled, valid slowSendInterval value is 2.0 to 3600.0 in seconds. Here is the example code to set slowSendInterval to 60 seconds:

```
import InstanaAgent

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let options = InstanaSetupOptions(slowSendInterval: 60.0)
    if !Instana.setup(key: InstanaKey, reportingURL: InstanaURL, options: options) {
        // Error handling here
    }

    ....
    return true
}
```

### API

See [API page](https://www.ibm.com/docs/en/instana-observability/current?topic=monitoring-ios-api#instana-ios-agent-api).

