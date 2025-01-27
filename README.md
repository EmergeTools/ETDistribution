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
    .package(url: "https://github.com/EmergeTools/ETDistribution.git", from: "v0.1.2")
]
```

### Manual Integration
1.	Clone the repository.
2.	Drag the ETDistribution folder into your Xcode project.

## Usage

### Checking for Updates
The ETDistribution library provides a simple API to check for updates:
```swift
import UIKit
import ETDistribution

ETDistribution.shared.checkForUpdate(apiKey: "YOUR_API_KEY") { result in
    switch result {
    case .success(let releaseInfo):
        if let releaseInfo {
            print("Update found: \(releaseInfo)")
            guard let url = ETDistribution.shared.buildUrlForInstall(releaseInfo.downloadUrl) else {
              return
            }
            DispatchQueue.main.async {
              UIApplication.shared.open(url) { _ in
                exit(0)
              }
            }
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

If you do not provide a completion handler, a default UI will be shown asking if the update should be installed.

## Configuration

### API Key

An API key is required to authenticate requests. You can obtain your API key from the Emerge Tools dashboard. Once you have the key, you can pass it as a parameter to the `checkForUpdate` method.

### Tag Name (Optional)

Tags can be used to associate builds, you could use tags to represent the dev branch, an internal project or any team builds. If the same binary has been uploaded with multiple tags, you can specify a tagName to differentiate between them. This is usually not needed, as the SDK will identify the tag automatically.

### Login Level

Login levels can be configured to require login for certain actions (like downloading the update or checking for updates). They are set at [Emerge Tools Settings](https://www.emergetools.com/settings?tab=feature-configuration). You should match that level at the app level.

### Debug Overrides

There are several override options to help debug integration and test the SDK.
They are:
 - **binaryIdentifierOverride**: Allows overriding the binary identifier to test updates from a different build.
 - **appIdOverride**: Allows changing the application identifier (aka Bundle Id).

### Handling Responses

By default, if no completion closure is provided, the SDK will present an alert to the user, prompting them to install the release. You can customize this behavior using the closures provided by the API.

## Example Project
To see ETDistribution in action, check out our example project. The example demonstrates how to integrate and use the library in both Swift and Objective-C projects.

## Documentation

For more detailed documentation and additional examples, visit our [Documentation Site](https://docs.emergetools.com/).

## FAQ

### Why isn’t the update check working on the simulator?

The library is designed to skip update checks on the simulator. To test update functionality, run your app on a physical device.

### Why I am not getting any update?

There could be several reasons:
- Update checks are disabled for both Simulators and Debug builds.
- ETDistribution is intended to update from an already published version on ETDistribution. If the current build has not been uploaded to Emerge Tools, you won't get any update notification.

### How do I skip an update?

When handling the response you can check the release version field to decide if it should be installed or not.

### Can I use ETDistribution to get updates from the AppStore?

No, since the binary signer is different (builds installed from the AppStore are signed by Apple), the update will fail.

### Can I require login to get updates?

Yes, there are 3 options for security:
- No login required.
- Login required only for downloading the update (can check for updates without login).
- Login required for checking for updates.

These options can be configured per platform at [Emerge Tools Settings](https://www.emergetools.com/settings?tab=feature-configuration).