//
//  iosSdkV2DemoAppApp.swift
//  iosSdkV2DemoApp
//
//  Created by Ross Work on 02/12/2025.
//

import SwiftUI
import Combine
import AyetSDK

@main
struct iosSdkV2DemoAppApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

class AppState: ObservableObject {
    @Published var externalId: String

    private let externalIdKey = "AyetDemoExternalId"

    init() {
        if let storedId = UserDefaults.standard.string(forKey: externalIdKey), !storedId.isEmpty {
            externalId = storedId
        } else {
            let randomNum = Int.random(in: 100000...999999)
            externalId = "user_\(randomNum)"
            UserDefaults.standard.set(externalId, forKey: externalIdKey)
        }

        initializeSDK()
    }

    func initializeSDK() {
        AyetSDK.shared.setDebug(true)
        AyetSDK.shared.initialize(placementId: AyetConfig.placementId, externalIdentifier: externalId)
        AyetSDK.shared.setGender(AyetConfig.defaultGender)
        AyetSDK.shared.setAge(AyetConfig.defaultAge)
        AyetSDK.shared.setTrackingCustom1(AyetConfig.defaultCustom1)
    }

    func updateExternalId(_ newId: String) {
        externalId = newId
        UserDefaults.standard.set(newId, forKey: externalIdKey)
        initializeSDK()
    }
}
