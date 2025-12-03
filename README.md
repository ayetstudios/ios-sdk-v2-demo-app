# Ayet iOS SDK v2 Demo App

A demo application showcasing the integration of the [Ayet iOS SDK v2](https://github.com/ayetstudios/ios-sdk-v2-repo).

## Requirements

- iOS 13.0+ (SDK minimum)
- Xcode 16+ (Swift 6.0)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/AyetStudios/ios-sdk-v2-demo-app.git
   ```

2. Open the project in Xcode:
   ```bash
   open iosSdkV2DemoApp.xcodeproj
   ```

3. Build and run on a device or simulator

The SDK package is already included via Swift Package Manager and will be fetched automatically.

## Configuration

All SDK configuration values are in [`AyetConfig.swift`](iosSdkV2DemoApp/AyetConfig.swift):

```swift
struct AyetConfig {
    static let placementId = 21213

    static let adslotOfferwall = "SdkV2Offerwall"
    static let adslotSurveywall = "SdkV2Surveywall"
    static let adslotFeed = "SdkV2OfferwallApi"

    static let defaultGender: AyetSDK.Gender = .male
    static let defaultAge = 27
    static let defaultCustom1 = "demo_app_example_custom"
}
```

**Note**: The bundle identifier must be set to `com.ayetsdk.iosSdkV2DemoApp` in your placement settings to use the demo app.

## Features Demonstrated

- SDK initialization
- Show Offerwall
- Show Surveywall
- Show Reward Status
- Get Offers (API)
- External identifier management

## Documentation

For full SDK documentation, see: https://docs.ayetstudios.com/v/product-docs/offerwall/sdk-integrations-v2/ios-sdk-v2

## License

MIT License - see [LICENSE](LICENSE) for details.
