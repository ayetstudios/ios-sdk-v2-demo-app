//
//  AyetConfig.swift
//  iosSdkV2DemoApp
//
//  Configuration constants for the Ayet SDK demo app.
//

import Foundation
import AyetSDK

struct AyetConfig {
    static let placementId = 21213
    static let adslotOfferwall = "SdkV2Offerwall"
    static let adslotSurveywall = "SdkV2Surveywall"
    static let adslotFeed = "SdkV2OfferwallApi"

    static let defaultGender: AyetSDK.Gender = .male
    static let defaultAge = 27
    static let defaultCustom1 = "demo_app_example_custom"
}
