//
//  ContentView.swift
//  iosSdkV2DemoApp
//
//  Created by Ross Work on 02/12/2025.
//

import SwiftUI
import AyetSDK

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingEditIdDialog = false
    @State private var editedExternalId = ""
    @State private var isLoadingOffers = false
    @State private var toastMessage: String?
    @State private var showToast = false

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerSection

                    VStack(spacing: 16) {
                        externalIdCard
                        actionButtonsSection
                        getOffersButton
                        footerSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }

            if showToast, let message = toastMessage {
                toastOverlay(message: message)
            }
        }
        .sheet(isPresented: $showingEditIdDialog) {
            editExternalIdSheet
        }
    }

    private var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color("NavyPrimary").opacity(0.6), Color("NavyPrimary").opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 12) {
                Image("AyetLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 64)

                Text("SDK Demo")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
        }
        .frame(height: 200)
        .clipShape(
            RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 32)
        )
    }

    private var externalIdCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("External Identifier")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text(appState.externalId)
                    .font(.body)
                    .fontWeight(.medium)

                Spacer()

                Button {
                    editedExternalId = appState.externalId
                    showingEditIdDialog = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("NavyPrimary"))
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            ActionButton(
                title: "Show Offerwall",
                icon: "list.bullet.rectangle.fill",
                color: Color("OrangeSecondary")
            ) {
                Task {
                    await AyetSDK.shared.showOfferwall(adSlotName: AyetConfig.adslotOfferwall)
                }
            }

            ActionButton(
                title: "Show Surveywall",
                icon: "checkmark.circle.fill",
                color: Color("PurpleTertiary")
            ) {
                Task {
                    await AyetSDK.shared.showSurveywall(adSlotName: AyetConfig.adslotSurveywall)
                }
            }

            ActionButton(
                title: "Reward Status",
                icon: "star.fill",
                color: Color("NavyPrimary")
            ) {
                Task {
                    await AyetSDK.shared.showRewardStatus()
                }
            }
        }
    }

    private var getOffersButton: some View {
        Button {
            guard !isLoadingOffers else { return }
            isLoadingOffers = true

            Task {
                if let offersJson = await AyetSDK.shared.getOffers(adSlotName: AyetConfig.adslotFeed) {
                    print("Offers received: \(offersJson)")
                    showToastMessage("Offers loaded - check console logs for details")
                } else {
                    print("Failed to get offers - null response")
                    showToastMessage("Failed to load offers - check console logs")
                }
                isLoadingOffers = false
            }
        } label: {
            HStack {
                if isLoadingOffers {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("NavyPrimary")))
                        .scaleEffect(0.8)
                }
                Text(isLoadingOffers ? "Loading..." : "Get Offers (API)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color("NavyPrimary"))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
        .disabled(isLoadingOffers)
        .animation(.easeInOut(duration: 0.2), value: isLoadingOffers)
    }

    private var footerSection: some View {
        Text("Gender: Male \u{2022} Age: 27")
            .font(.caption)
            .foregroundColor(.secondary.opacity(0.7))
            .padding(.top, 16)
    }

    private var editExternalIdSheet: some View {
        NavigationView {
            Form {
                Section {
                    TextField("External Identifier", text: $editedExternalId)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } footer: {
                    Text("The SDK will be re-initialized with the new identifier.")
                }
            }
            .navigationTitle("Edit External ID")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingEditIdDialog = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedId = editedExternalId.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedId.isEmpty {
                            appState.updateExternalId(trimmedId)
                            showToastMessage("External ID updated")
                        }
                        showingEditIdDialog = false
                    }
                    .disabled(editedExternalId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.height(200)])
    }

    private func toastOverlay(message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.85))
                .cornerRadius(24)
                .padding(.bottom, 50)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(100)
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))

                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)

                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(color)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.3), radius: 8, y: 4)
        }
    }
}

struct RoundedCornerShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
