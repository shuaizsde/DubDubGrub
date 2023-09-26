//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 9/20/23.
//

import SwiftUI

struct LocationDetailView: View {

    /// Note: @ObservedObject meaning the view model relies on previous view passed in
    /// whereas @StateObject is creating the viewModel for the first time
    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)
                AddressView(address: viewModel.location.address).padding(.horizontal)
                DescriptionView(text: viewModel.location.description)
                ButtonStack(viewModel: viewModel)
                GridHeaderTitleView()
                CheckedInProfilesView(viewModel: viewModel)

                Spacer()
            }

            if viewModel.isShowingProfileModal {
                ProfileCard(viewModel: viewModel)
            }
        }
            .onAppear {
                viewModel.getCheckedInProfiles()
                viewModel.getCheckedInStatus()
            }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
            .navigationTitle(viewModel.location.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct LocationActionButton: View {

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

fileprivate struct FirstNameAvatarView: View {

    var profile: DDGProfile

    var body: some View {
        VStack {
            AvatarView(
                image: profile.avatarImage, size: 64
            )
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

fileprivate struct BannerImageView: View {

    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
}

fileprivate struct AddressView: View {

    var address: String

    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

fileprivate struct DescriptionView: View {

    var text: String

    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}

fileprivate struct ButtonStack: View {

    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
            HStack(spacing: 20) {
                Button {
                    viewModel.getDirectionsToLocation()
                } label: {
                    LocationActionButton(
                        color: .brandPrimary,
                        imageName: "location.fill"
                    )
                }

                Link(destination: URL(string: viewModel.location.websiteURL)!) {
                    LocationActionButton(color: .brandPrimary, imageName: "network")
                }

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
                        viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
						playHaptic()
                    } label: {
                        LocationActionButton(
                            color: viewModel.isCheckedIn ? .grubRed : .brandPrimary,
                            imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
                        )
					}
					.disabled(viewModel.isLoading)
                }
            }
			.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
			.background(Color(.secondarySystemBackground))
			.clipShape(Capsule())
    }
}

fileprivate struct CheckedInProfilesView: View {

    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
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
    }
}

fileprivate struct GridHeaderTitleView: View {

    var body: some View {
        Text("Who's Here?")
			.bold()
			.font(.title2)
    }
}

fileprivate struct ProfileCard: View {

    @ObservedObject var viewModel: LocationDetailViewModel
    var body: some View {

        Color(.systemBackground)
            .ignoresSafeArea()
            .opacity(0.9)
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

struct LocationDetailView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
        }
    }
}
