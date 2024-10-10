# ETDistribution 🛰️

[![](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fwww.emergetools.com%2Fapi%2Fv2%2Fpublic_new_build%3FexampleId%3Detdistribution.ETDistribution%26platform%3Dios%26badgeOption%3Dversion_and_max_install_size%26buildType%3Dmanual&query=$.badgeMetadata&label=ETDistribution&logo=apple)](https://www.emergetools.com/app/example/ios/etdistribution.ETDistribution/manual)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEmergeTools%2FETDistribution%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/EmergeTools/ETDistribution)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEmergeTools%2FETDistribution%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/EmergeTools/ETDistribution)

ETDistribution is a Swift library that simplifies the process of distributing new app versions and checking for updates. It provides an easy-to-use API to verify if a new version is available and handles the update process seamlessly, ensuring your users are always on the latest release.

## Features

- 🚀 Automatic Update Check: Quickly determine if a new version is available.
- 🔑 Secure: No data is stored locally.
- 🎯 Objective-C Compatibility: Provides compatibility with both Swift and Objective-C.
- 🛠️ Flexible Update Handling: Customize how you handle updates.

## Installation

### Prerequisites:
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

### Swift Package Manager

To integrate ETDistribution into your project, add the following line to your Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/EmergeTools/ETDistribution.git", from: "v0.1.0")
]
```

### Manual Integration
1.	Clone the repository.
2.	Drag the ETDistribution folder into your Xcode project.

## Usage

### Checking for Updates
The ETDistribution library provides a simple API to check for updates:
```swift
import ETDistribution

ETDistribution.shared.checkForUpdate(apiKey: "YOUR_API_KEY") { result in
    switch result {
    case .success(let releaseInfo):
        if let releaseInfo {
            print("Update found: \(releaseInfo)")
        } else {
            print("Already up to date")
        }
    case .failure(let error):
        print("Error checking for update: \(error)")
    }
}
```

For Objective-C:
```objc
[[ETDistribution sharedInstance] checkForUpdateWithApiKey:@"YOUR_API_KEY"
                                                 tagName:nil
                                      onReleaseAvailable:^(DistributionReleaseInfo *releaseInfo) {
                                            NSLog(@"Release info: %@", releaseInfo);
                                      }
                                                 onError:^(NSError *error) {
                                            NSLog(@"Error checking for update: %@", error);
                                      }];
```

If you already have the `plist` url for the update, you can get the `itms-services` url by calling `buildUrlForInstall`:
```swift
if let installUrl = ETDistribution.shared.buildUrlForInstall("https://example.com/app.plist") {
    UIApplication.shared.open(installUrl, options: [:], completionHandler: nil)
}
```

## Configuration

### API Key

An API key is required to authenticate requests. You can obtain your API key from the Emerge Tools dashboard. Once you have the key, you can pass it as a parameter to the `checkForUpdate` method.

### Tag Name (Optional)

Tags can be used to associate builds, you could use tags to represent the dev branch, an internal project or any team builds. If the same binary has been uploaded with multiple tags, you can specify a tagName to differentiate between them. This is usually not needed, as the SDK will identify the tag automatically.

### Handling Responses

By default, if no completion closure is provided, the SDK will present an alert to the user, prompting them to install the release. You can customize this behavior using the closures provided by the API.

## Example Project
To see ETDistribution in action, check out our example project. The example demonstrates how to integrate and use the library in both Swift and Objective-C projects.

## Documentation

For more detailed documentation and additional examples, visit our [Documentation Site](https://docs.emergetools.com/).

## FAQ

### Why isn’t the update check working on the simulator?

The library is designed to skip update checks on the simulator. To test update functionality, run your app on a physical device.

### How do I skip an update?

There is no public API to programatically skip updates right now.