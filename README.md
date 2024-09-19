# ETDistribution 🛰️

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEmergeTools%2FETDistribution%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/EmergeTools/ETDistribution)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEmergeTools%2FETDistribution%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/EmergeTools/ETDistribution)

Keep internal builds up to date with ETDistribution

# Features

Check for updates and automatically prompt with an option to ignore or install
```swift
import ETDistribution

Button("Check for updates") {
  ETDistribution.shared.checkForUpdate(apiKey: "YOUR_API_KEY")
}
```

Or handle the update yourself

```swift
import ETDistribution

ETDistribution.shared.checkForUpdate(apiKey: "YOUR_API_KEY", tagName: "alpha") { result in
  if let update = try? result.get(), let url = ETDistribution.shared.buildUrlForInstall(update.downloadUrl) {
    UIApplication.shared.open(url)
  }
}
```

# Installation

Install ETDistribution with SPM using the URL of this repository (https://github.com/EmergeTools/ETDistribution)
