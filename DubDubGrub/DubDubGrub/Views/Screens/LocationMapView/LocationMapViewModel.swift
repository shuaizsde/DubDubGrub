//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 9/26/23.
//

import CloudKit
import MapKit

final class LocationMapViewModel: ObservableObject {

    @Published var isShowingDetailView = false
    @Published var alertItem: AlertItem?
    @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
    @Published var region = MKCoordinateRegion(
        center:
            CLLocationCoordinate2D(
                latitude: 37.331516,
                longitude: -121.891054
            ),
        span:
            MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
    )

    func getCheckedInCounts() {
        CloudKitManager.shared.getCheckedInProfilesCount { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure:
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
    }

    func getLocations(for locationManager: LocationManager) {
        CloudKitManager.shared.getLocations { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                case .failure:
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
//
//    @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View {
//        if sizeCategory >= .accessibilityMedium {
//            LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
//        } else {
//            LocationDetailView(viewModel: LocationDetailViewModel(location: location))
//        }
//    }
}
