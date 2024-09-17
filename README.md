# ETDistribution 🛰️

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
