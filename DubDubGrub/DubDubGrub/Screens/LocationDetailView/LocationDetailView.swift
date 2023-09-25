//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/20/21.
//

import SwiftUI

struct LocationDetailView: View {
    /** Note: @ObservedObject meaning the view model relies on previous view passed in
     *  whereas @StateObject is creating the viewModel for the first time
     */
    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(
                    image: viewModel.location.createBannerImage()
                )
                HStack {
                    AddressView(address: viewModel.location.address)
                    Spacer()
                }
                    .padding(.horizontal)

                DescriptionView(text: viewModel.location.description)

                ZStack {
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))

                    HStack(spacing: 20) {
                        Button {
                            viewModel.getDirectionsToLocation()
                        } label: {
                            LocationActionButton(
                                color: .brandPrimary,
                                imageName: "location.fill"
                            )
                        }

                        Link(destination: URL(string: viewModel.location.websiteURL)!,
                             label: {
                                LocationActionButton(
                                    color: .brandPrimary,
                                    imageName: "network"
                                )
                            }
                        )

                        Button {
                            viewModel.callLocation()
                        } label: {
                            LocationActionButton(
                                color: .brandPrimary,
                                imageName: "phone.fill"
                            )
                        }

                        if CloudKitManager.shared.profileRecordID != nil {
                            Button {
                                viewModel.updateCheckInStatus(
                                    to: viewModel.isCheckedIn ? .checkedOut : .checkedIn
                                )
                            } label: {
                                LocationActionButton(
                                    color: viewModel.isCheckedIn ? .grubRed : .brandPrimary,
                                    imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
                                )
                            }
                        }
                    }
                }
                    .padding(.horizontal)

                Text("Who's Here?")
                    .bold()
                    .font(.title2)

                ZStack {
                    if viewModel.checkedInProfiles.isEmpty {
                        Text("Nobody is here😅")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: viewModel.columns) {
                                ForEach(viewModel.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            withAnimation { viewModel.isShowingProfileModal = true }
                                        }
                                }
                            }
                        }
                    }
                    if viewModel.isLoading {LoadingView()}
                }

                Spacer()
            }

            if viewModel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    // .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .transition(.opacity)
                    .animation(.easeOut)
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation { viewModel.isShowingProfileModal = false }
                    }
                ProfileModalView(
                    isShowingProfileModalView: $viewModel.isShowingProfileModal,
                    profile: DDGProfile(record: MockData.profile)
                )
                .transition(.opacity.combined(with: .scale))
                   .animation(.linear(duration: 0.5))
                   .zIndex(2)
            }

        }
            .onAppear {
                viewModel.getCheckedInProfiles()
                viewModel.getCheckedInStatus()
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: alertItem.dismissButton
                )

            }
            .navigationTitle(viewModel.location.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
        }
    }
}

struct LocationActionButton: View {

    var color: Color
    var imageName: String

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)

            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
        }
    }
}

struct FirstNameAvatarView: View {

    var profile: DDGProfile

    var body: some View {
        VStack {
            AvatarView(
                size: 64,
                image: profile.createAvatarImage()
            )
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

struct BannerImageView: View {

    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
}

struct AddressView: View {

    var address: String

    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DescriptionView: View {

    var text: String

    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}